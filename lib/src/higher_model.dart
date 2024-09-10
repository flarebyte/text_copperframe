import 'package:validomix/validomix.dart';

/// Represents a message to be displayed to a user.
class UserMessage {
  /// The label or content of the message.
  final String label;

  /// The level of the message, such as info, warning, or error.
  final MessageLevel level;

  /// The category of the message, which can be any user-defined string.
  final String category;

  /// A list of flags associated with the message.
  final String? flags;

  @override
  String toString() {
    return '$level $label';
  }

  /// Constructs a [UserMessage] with the provided [label], [level], and [category].
  UserMessage({
    required this.label,
    required this.level,
    required this.category,
    this.flags,
  });

  /// Serializes this [UserMessage] to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] that represents this message.
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'level': level.toString().split('.').last,
      'category': category,
      'flags': flags,
    };
  }

  /// Deserializes a [UserMessage] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory UserMessage.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('label') &&
        json.containsKey('level') &&
        json.containsKey('category')) {
      return UserMessage(
        label: json['label'],
        level: MessageLevelExtension.fromString(json['level']),
        category: json['category'],
        flags: json['flags'],
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

/// Enum representing the level of the message.
enum MessageLevel { info, warning, error }

/// Extension on [MessageLevel] to facilitate conversion from string.
extension MessageLevelExtension on MessageLevel {
  /// Converts a string to a [MessageLevel].
  ///
  /// Returns the corresponding [MessageLevel] for a valid input.
  /// Throws an [ArgumentError] if the input string does not match any [MessageLevel].
  static MessageLevel fromString(String level) {
    switch (level) {
      case 'info':
        return MessageLevel.info;
      case 'warning':
        return MessageLevel.warning;
      case 'error':
        return MessageLevel.error;
      default:
        throw ArgumentError('Invalid message level: $level');
    }
  }
}

/// Represents a rule that can be applied to a field.
class FieldRule {
  /// The name of the rule.
  final String name;

  /// A map of options for configuring the rule.
  final Map<String, String> options;

  /// A list of [UserMessage] objects representing success messages.
  final List<UserMessage> successMessages;

  /// A list of [UserMessage] objects representing failure messages.
  final List<UserMessage> failureMessages;

  /// Constructs a [FieldRule] with the provided [name], [options], [successMessages], and [failureMessages].
  FieldRule({
    required this.name,
    required this.options,
    required this.successMessages,
    required this.failureMessages,
  });

  /// Serializes this [FieldRule] to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] that represents this rule.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'options': options,
      'successMessages': successMessages.map((msg) => msg.toJson()).toList(),
      'failureMessages': failureMessages.map((msg) => msg.toJson()).toList(),
    };
  }

  /// Deserializes a [FieldRule] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory FieldRule.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') &&
        json.containsKey('options') &&
        json.containsKey('successMessages') &&
        json.containsKey('failureMessages')) {
      return FieldRule(
        name: json['name'],
        options: Map<String, String>.from(json['options']),
        successMessages: (json['successMessages'] as List)
            .map((msg) => UserMessage.fromJson(msg))
            .toList(),
        failureMessages: (json['failureMessages'] as List)
            .map((msg) => UserMessage.fromJson(msg))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

/// Represents an event for a field, which triggers a list of [FieldRule]s.
class FieldEvent {
  /// The name of the event.
  final String name;

  /// A list of [FieldRule] objects that are applied when the event occurs.
  final List<FieldRule> rules;

  /// Constructs a [FieldEvent] with the provided [name] and [rules].
  FieldEvent({
    required this.name,
    required this.rules,
  });

  /// Serializes this [FieldEvent] to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] that represents this event.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rules': rules.map((rule) => rule.toJson()).toList(),
    };
  }

  /// Deserializes a [FieldEvent] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory FieldEvent.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') && json.containsKey('rules')) {
      return FieldEvent(
        name: json['name'],
        rules: (json['rules'] as List)
            .map((rule) => FieldRule.fromJson(rule))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

/// Represents a widget for a field, which can trigger various events.
class FieldWidget {
  /// The name of the widget.
  final String name;

  /// The kind of widget (e.g., text, dropdown).
  final String kind;

  /// A map of options for configuring the widget.
  final Map<String, String> options;

  /// A list of [FieldEvent] objects representing events that can occur for the widget.
  final List<FieldEvent> events;

  /// Constructs a [FieldWidget] with the provided [name], [kind], [options], and [events].
  FieldWidget({
    required this.name,
    required this.kind,
    required this.options,
    required this.events,
  });

  /// Serializes this [FieldWidget] to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] that represents this widget.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'kind': kind,
      'options': options,
      'events': events.map((event) => event.toJson()).toList(),
    };
  }

  /// Deserializes a [FieldWidget] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory FieldWidget.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') &&
        json.containsKey('kind') &&
        json.containsKey('options') &&
        json.containsKey('events')) {
      return FieldWidget(
        name: json['name'],
        kind: json['kind'],
        options: Map<String, String>.from(json['options']),
        events: (json['events'] as List)
            .map((event) => FieldEvent.fromJson(event))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

class UserMessageProducer implements VxMessageProducer<UserMessage, String> {
  final UserMessage message;
  UserMessageProducer(this.message);
  @override
  UserMessage produce(Map<String, String> options, String value) => message;
}

abstract class BaseUserRule {
  List<UserMessage> validate(String value);
}

class UserRule extends BaseUserRule {
  final VxBaseRule<UserMessage> rule;
  final Map<String, String> options;
  UserRule({required this.rule, required this.options});

  @override
  List<UserMessage> validate(String value) {
    return rule.validate(options, value);
  }
}

class TcfRuleComposer extends BaseUserRule {
  final Iterable<BaseUserRule> rules;

  TcfRuleComposer(this.rules);

  @override
  List<UserMessage> validate(String value) {
    final List<UserMessage> messages = [];

    for (final rule in rules) {
      final List<UserMessage> result = rule.validate(value);
      messages.addAll(result);
    }

    return messages;
  }
}
