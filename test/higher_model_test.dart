import 'package:test/test.dart';
import 'package:text_copperframe/src/higher_model.dart';

void main() {
  group('UserMessage', () {
    test('toJson and fromJson serialization/deserialization', () {
      final message = UserMessage(
        label: 'This is an info message',
        level: MessageLevel.info,
        category: 'usage',
      );

      final json = message.toJson();
      final deserializedMessage = UserMessage.fromJson(json);

      expect(deserializedMessage.label, equals(message.label));
      expect(deserializedMessage.level, equals(message.level));
      expect(deserializedMessage.category, equals(message.category));
    });

    test('fromJson with missing fields should throw FormatException', () {
      final json = {
        'label': 'This is an error message',
        'level': 'error',
      };

      expect(() => UserMessage.fromJson(json), throwsFormatException);
    });

    test('fromJson with invalid level should throw ArgumentError', () {
      final json = {
        'label': 'This is an invalid level message',
        'level': 'critical',
        'category': 'length',
      };

      expect(() => UserMessage.fromJson(json), throwsArgumentError);
    });
  });

  group('FieldRule', () {
    test('toJson and fromJson serialization/deserialization', () {
      final rule = FieldRule(
        name: 'Length Check',
        options: {'min': '1', 'max': '255'},
        successMessages: [
          UserMessage(
              label: 'Valid length',
              level: MessageLevel.info,
              category: 'length')
        ],
        failureMessages: [
          UserMessage(
              label: 'Invalid length',
              level: MessageLevel.error,
              category: 'length')
        ],
      );

      final json = rule.toJson();
      final deserializedRule = FieldRule.fromJson(json);

      expect(deserializedRule.name, equals(rule.name));
      expect(deserializedRule.options, equals(rule.options));
      expect(deserializedRule.successMessages.length, equals(1));
      expect(deserializedRule.failureMessages.length, equals(1));
    });

    test('fromJson with missing fields should throw FormatException', () {
      final json = {
        'name': 'Required Field',
        'options': {'required': 'true'},
        'successMessages': []
      };

      expect(() => FieldRule.fromJson(json), throwsFormatException);
    });
  });

  group('FieldEvent', () {
    test('toJson and fromJson serialization/deserialization', () {
      final rule = FieldRule(
        name: 'Required Check',
        options: {'required': 'true'},
        successMessages: [
          UserMessage(
              label: 'Field is required',
              level: MessageLevel.info,
              category: 'validation')
        ],
        failureMessages: [
          UserMessage(
              label: 'Field is missing',
              level: MessageLevel.error,
              category: 'validation')
        ],
      );

      final event = FieldEvent(
        name: 'OnBlur',
        rules: [rule],
      );

      final json = event.toJson();
      final deserializedEvent = FieldEvent.fromJson(json);

      expect(deserializedEvent.name, equals(event.name));
      expect(deserializedEvent.rules.length, equals(1));
    });

    test('fromJson with missing fields should throw FormatException', () {
      final json = {
        'name': 'OnChange',
      };

      expect(() => FieldEvent.fromJson(json), throwsFormatException);
    });
  });

  group('FieldWidget', () {
    test('toJson and fromJson serialization/deserialization', () {
      final rule = FieldRule(
        name: 'MaxLength Check',
        options: {'max': '100'},
        successMessages: [
          UserMessage(
              label: 'Valid length',
              level: MessageLevel.info,
              category: 'validation')
        ],
        failureMessages: [
          UserMessage(
              label: 'Too long',
              level: MessageLevel.error,
              category: 'validation')
        ],
      );

      final event = FieldEvent(
        name: 'OnChange',
        rules: [rule],
      );

      final widget = FieldWidget(
        name: 'Username',
        kind: 'text',
        options: {'placeholder': 'Enter your username'},
        events: [event],
      );

      final json = widget.toJson();
      final deserializedWidget = FieldWidget.fromJson(json);

      expect(deserializedWidget.name, equals(widget.name));
      expect(deserializedWidget.kind, equals(widget.kind));
      expect(deserializedWidget.options, equals(widget.options));
      expect(deserializedWidget.events.length, equals(1));
    });

    test('fromJson with missing fields should throw FormatException', () {
      final json = {
        'name': 'Email',
        'kind': 'text',
        'options': {'placeholder': 'Enter your email'}
      };

      expect(() => FieldWidget.fromJson(json), throwsFormatException);
    });
  });
}
