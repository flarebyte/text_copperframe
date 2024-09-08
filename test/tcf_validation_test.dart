import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/text_copperframe.dart';
import 'package:validomix/validomix.dart';

import 'tcf_test_utils.dart';

void main() {
  group('TextFieldEventBuilder', () {
    late ExMetricStoreHolder metricStoreHolder;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
    });

    test('check validation for a range of chars', () {
      var bigEnoughMessage = UserMessage(
          label: 'Big enough', level: MessageLevel.info, category: 'length');
      var tooSmallMessage = UserMessage(
          label: 'Too small', level: MessageLevel.error, category: 'length');
      final minRule = FieldRule(
        name: 'chars more than',
        options: {'text#minChars': '1'},
        successMessages: [bigEnoughMessage],
        failureMessages: [tooSmallMessage],
      );
      var smallEnoughMessage = UserMessage(
          label: 'Small enough', level: MessageLevel.info, category: 'length');
      var tooBigMessage = UserMessage(
          label: 'Too big', level: MessageLevel.error, category: 'length');
      final maxRule = FieldRule(
        name: 'chars less than or equal',
        options: {'text#maxChars': '30'},
        successMessages: [smallEnoughMessage],
        failureMessages: [tooBigMessage],
      );
      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [minRule, maxRule],
      );
      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory);
      final textRule = builder.build();
      expect(textRule.validate('some text'),
          [bigEnoughMessage, smallEnoughMessage]);
      expect(textRule.validate(''), [tooSmallMessage, smallEnoughMessage]);
      expect(textRule.validate('A' * 100), [bigEnoughMessage, tooBigMessage]);
      expectNoMetricError(metricStoreHolder);
    });
    test('check missing prop for validation', () {
      var anyMessage = UserMessage(
          label: 'We should never see this message',
          level: MessageLevel.info,
          category: 'length');
      final minRule = FieldRule(
        name: 'chars more than',
        options: {},
        successMessages: [anyMessage],
        failureMessages: [anyMessage],
      );

      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [minRule],
      );
      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory);
      final textRule = builder.build();
      textRule.validate('some text');
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: ['greater-than', 'text#minChars', 'not-found']);
    });

    test('check validation for diverse chars comparators', () {
      var bigEnoughMessage = UserMessage(
          label: 'Big enough', level: MessageLevel.info, category: 'length');
      var tooSmallMessage = UserMessage(
          label: 'Too small', level: MessageLevel.error, category: 'length');
      final minRule = FieldRule(
        name: 'chars more than',
        options: {'text#minChars': '1'},
        successMessages: [bigEnoughMessage],
        failureMessages: [tooSmallMessage],
      );
      var smallEnoughMessage = UserMessage(
          label: 'Small enough', level: MessageLevel.info, category: 'length');
      var tooBigMessage = UserMessage(
          label: 'Too big', level: MessageLevel.error, category: 'length');
      final maxRule = FieldRule(
        name: 'chars less than or equal',
        options: {'text#maxChars': '30'},
        successMessages: [smallEnoughMessage],
        failureMessages: [tooBigMessage],
      );
      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [minRule, maxRule],
      );
      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory);
      final textRule = builder.build();
      expect(textRule.validate('some text'),
          [bigEnoughMessage, smallEnoughMessage]);
      expect(textRule.validate(''), [tooSmallMessage, smallEnoughMessage]);
      expect(textRule.validate('A' * 100), [bigEnoughMessage, tooBigMessage]);
      expectNoMetricError(metricStoreHolder);
    });
  });
}
