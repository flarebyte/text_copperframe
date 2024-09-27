import 'package:validomix/validomix.dart';

/// Represents a message to be displayed to a user.
class CopperframeMessage {
  /// The label or content of the message.
  final String label;

  /// The level of the message, such as info, warning, or error.
  final CopperframeMessageLevel level;

  /// The category of the message, which can be any user-defined string.
  final String category;

  /// A list of flags associated with the message.
  final String? flags;

  @override
  String toString() {
    return '$level $label';
  }

  /// Constructs a [CopperframeMessage] with the provided [label], [level], and [category].
  CopperframeMessage({
    required this.label,
    required this.level,
    required this.category,
    this.flags,
  });

  /// Serializes this [CopperframeMessage] to a JSON-compatible map.
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

  /// Deserializes a [CopperframeMessage] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory CopperframeMessage.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('label') &&
        json.containsKey('level') &&
        json.containsKey('category')) {
      return CopperframeMessage(
        label: json['label'],
        level: MessageLevelExtension.fromString(json['level']),
        category: json['category'],
        flags: json['flags'],
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }

  static List<CopperframeMessage> getMessagesWithFlag(
      List<CopperframeMessage> messages, String tag) {
    return messages
        .where((message) => (message.flags ?? '').contains(tag))
        .toList();
  }

  static List<CopperframeMessage> getMessagesWithNoFlag(
      List<CopperframeMessage> messages) {
    return messages.where((message) => (message.flags ?? '').isEmpty).toList();
  }
}

/// Enum representing the level of the message.
enum CopperframeMessageLevel { info, warning, error }

/// Extension on [CopperframeMessageLevel] to facilitate conversion from string.
extension MessageLevelExtension on CopperframeMessageLevel {
  /// Converts a string to a [CopperframeMessageLevel].
  ///
  /// Returns the corresponding [CopperframeMessageLevel] for a valid input.
  /// Throws an [ArgumentError] if the input string does not match any [CopperframeMessageLevel].
  static CopperframeMessageLevel fromString(String level) {
    switch (level) {
      case 'info':
        return CopperframeMessageLevel.info;
      case 'warning':
        return CopperframeMessageLevel.warning;
      case 'error':
        return CopperframeMessageLevel.error;
      default:
        throw ArgumentError('Invalid message level: $level');
    }
  }
}

/// Represents a rule that can be applied to a field.
class CopperframeFieldRule {
  /// The name of the rule.
  final String name;

  /// A map of options for configuring the rule.
  final Map<String, String> options;

  /// A list of [CopperframeMessage] objects representing success messages.
  final List<CopperframeMessage> successMessages;

  /// A list of [CopperframeMessage] objects representing failure messages.
  final List<CopperframeMessage> failureMessages;

  /// Constructs a [CopperframeFieldRule] with the provided [name], [options], [successMessages], and [failureMessages].
  CopperframeFieldRule({
    required this.name,
    required this.options,
    required this.successMessages,
    required this.failureMessages,
  });

  /// Serializes this [CopperframeFieldRule] to a JSON-compatible map.
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

  /// Deserializes a [CopperframeFieldRule] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory CopperframeFieldRule.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') &&
        json.containsKey('options') &&
        json.containsKey('successMessages') &&
        json.containsKey('failureMessages')) {
      return CopperframeFieldRule(
        name: json['name'],
        options: Map<String, String>.from(json['options']),
        successMessages: (json['successMessages'] as List)
            .map((msg) => CopperframeMessage.fromJson(msg))
            .toList(),
        failureMessages: (json['failureMessages'] as List)
            .map((msg) => CopperframeMessage.fromJson(msg))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

/// Represents an event for a field, which triggers a list of [CopperframeFieldRule]s.
class CopperframeFieldEvent {
  /// The name of the event.
  final String name;

  /// A list of [CopperframeFieldRule] objects that are applied when the event occurs.
  final List<CopperframeFieldRule> rules;

  /// Constructs a [CopperframeFieldEvent] with the provided [name] and [rules].
  CopperframeFieldEvent({
    required this.name,
    required this.rules,
  });

  /// Serializes this [CopperframeFieldEvent] to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] that represents this event.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rules': rules.map((rule) => rule.toJson()).toList(),
    };
  }

  /// Deserializes a [CopperframeFieldEvent] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory CopperframeFieldEvent.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') && json.containsKey('rules')) {
      return CopperframeFieldEvent(
        name: json['name'],
        rules: (json['rules'] as List)
            .map((rule) => CopperframeFieldRule.fromJson(rule))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

/// Represents a widget for a field, which can trigger various events.
class CopperframeFieldWidget {
  /// The name of the widget.
  final String name;

  /// The kind of widget (e.g., text, dropdown).
  final String kind;

  /// A map of options for configuring the widget.
  final Map<String, String> options;

  /// A list of [CopperframeFieldEvent] objects representing events that can occur for the widget.
  final List<CopperframeFieldEvent> events;

  /// Constructs a [CopperframeFieldWidget] with the provided [name], [kind], [options], and [events].
  CopperframeFieldWidget({
    required this.name,
    required this.kind,
    required this.options,
    required this.events,
  });

  /// Serializes this [CopperframeFieldWidget] to a JSON-compatible map.
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

  /// Deserializes a [CopperframeFieldWidget] from a JSON-compatible map.
  ///
  /// Throws a [FormatException] if the JSON map does not contain the required fields.
  factory CopperframeFieldWidget.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') &&
        json.containsKey('kind') &&
        json.containsKey('options') &&
        json.containsKey('events')) {
      return CopperframeFieldWidget(
        name: json['name'],
        kind: json['kind'],
        options: Map<String, String>.from(json['options']),
        events: (json['events'] as List)
            .map((event) => CopperframeFieldEvent.fromJson(event))
            .toList(),
      );
    } else {
      throw FormatException('Missing required fields in JSON');
    }
  }
}

class CopperframeMessageProducer
    implements VxMessageProducer<CopperframeMessage, String> {
  final CopperframeMessage message;
  CopperframeMessageProducer(this.message);
  @override
  CopperframeMessage produce(Map<String, String> options, String value) =>
      message;

  static List<CopperframeMessageProducer> createProducers(
      List<CopperframeMessage> messages) {
    return messages
        .map((message) => CopperframeMessageProducer(message))
        .toList();
  }
}

abstract class BaseCopperframeRule {
  List<CopperframeMessage> validate(String value);
}

class CopperframeRule extends BaseCopperframeRule {
  final VxBaseRule<CopperframeMessage> rule;
  final Map<String, String> options;
  CopperframeRule({required this.rule, required this.options});

  @override
  List<CopperframeMessage> validate(String value) {
    return rule.validate(options, value);
  }
}

/// Class that declaratively defines a set of rules that are used to validate a text field
class CopperframeRuleComposer extends BaseCopperframeRule {
  final Iterable<BaseCopperframeRule> rules;

  CopperframeRuleComposer(this.rules);

  @override
  List<CopperframeMessage> validate(String value) {
    final List<CopperframeMessage> messages = [];

    for (final rule in rules) {
      final List<CopperframeMessage> result = rule.validate(value);
      messages.addAll(result);
    }

    return messages;
  }
}
