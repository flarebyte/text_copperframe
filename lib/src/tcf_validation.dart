import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:validomix/validomix.dart';

class UserMessageProducer implements VxMessageProducer<UserMessage, String> {
  final UserMessage message;
  UserMessageProducer(this.message);
  @override
  UserMessage produce(Map<String, String> options, String value) => message;
}

class TextFieldEventBuilder {
  final FieldEvent fieldEvent;
  final ExMetricStoreHolder metricStoreHolder;
  final VxOptionsInventory optionsInventory;
  final List<VxBaseRule<UserMessage>> charChangeRules = []; 
  TextFieldEventBuilder(
      {required this.fieldEvent,
      required this.metricStoreHolder,
      required this.optionsInventory});

  _buildRule(FieldRule rule) {
    switch (rule.name) {
      case 'chars less than':
        charChangeRules.add(_buildCharsLessThan(rule));
    }
  }

  _buildCharsLessThan(FieldRule fieldRule) {
    final rule = VxStringRules.charsLessThan<UserMessage>(
        name: '${fieldEvent.name}${fieldRule.name}',
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }
}
