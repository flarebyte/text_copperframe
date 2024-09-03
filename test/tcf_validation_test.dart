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
      final messages = textRule.validate('some text');
      expect(messages, [bigEnoughMessage, smallEnoughMessage]);
      expectNoMetricError(metricStoreHolder);
    });
  });
}
