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

    test('check validation with less than', () {
      final minRule = FieldRule(
        name: 'chars more than',
        options: {'min': '1'},
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
      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [minRule],
      );
      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory);
      final textRule = builder.build();
      textRule.validate({}, 'some text');
      expectNoMetricError(metricStoreHolder);
    });
  });
}
