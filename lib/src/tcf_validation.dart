import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/src/tcf_metrics.dart';
import 'package:validomix/validomix.dart';

class UserMessageProducer implements VxMessageProducer<UserMessage, String> {
  final UserMessage message;
  UserMessageProducer(this.message);
  @override
  UserMessage produce(Map<String, String> options, String value) => message;
}

class TcfRuleComposer extends VxBaseRule<UserMessage> {
  final Iterable<VxBaseRule<UserMessage>> rules;

  TcfRuleComposer(
    this.rules,
  );

  @override
  List<UserMessage> validate(Map<String, String> options, String value) {
    final List<UserMessage> messages = [];

    for (final rule in rules) {
      final List<UserMessage> result = rule.validate(options, value);
      messages.addAll(result);
    }

    return messages;
  }
}

class TextFieldEventBuilder {
  final FieldEvent fieldEvent;
  final ExMetricStoreHolder metricStoreHolder;
  final VxOptionsInventory optionsInventory;

  TextFieldEventBuilder(
      {required this.fieldEvent,
      required this.metricStoreHolder,
      required this.optionsInventory});

  TcfRuleComposer build() {
    final charChangeRules = fieldEvent.rules
        .map((fieldRule) => _buildRule(fieldRule))
        .whereType<VxBaseRule<UserMessage>>();
    return TcfRuleComposer(charChangeRules);
  }

  VxBaseRule<UserMessageProducer>? _buildRule(FieldRule rule) {
    switch (rule.name) {
      case 'chars less than':
        return _buildCharsLessThan(rule);
      default:
        metricStoreHolder.store
            .addMetric(TcfMetrics.getRuleNotFound(rule.name), 1);
        return null;
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
