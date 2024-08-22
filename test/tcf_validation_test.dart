import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/text_copperframe.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('TextFieldEventBuilder', () {
    late ExMetricStoreHolder metricStoreHolder;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
    });

    test('check validation with less than', () {
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
      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [rule],
      );
      final builder = TextFieldEventBuilder(fieldEvent: event,
       metricStoreHolder: metricStoreHolder, optionsInventory: optionsInventory);
       final textRule = builder.build();
       textRule.validate({}, 'some text');
  });
}