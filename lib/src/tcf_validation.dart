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
      case 'chars less than or equal':
        return _buildCharsLessThanOrEqual(rule);
      case 'chars more than':
        return _buildCharsMoreThan(rule);
      case 'chars more than or equal':
        return _buildcharsMoreThanOrEqual(rule);
      case 'words less than':
        return _buildWordsLessThan(rule);
      case 'words less than or equal':
        return _buildWordsLessThanOrEqual(rule);
      case 'words more than':
        return _buildWordsMoreThan(rule);
      case 'words more than or equal':
        return _buildWordsMoreThanOrEqual(rule);
      default:
        metricStoreHolder.store
            .addMetric(TcfMetrics.getRuleNotFound(rule.name), 1);
        return null;
    }
  }

  String _createName(FieldRule fieldRule) {
    return '${fieldEvent.name}${fieldRule.name}';
  }

  _buildCharsLessThan(FieldRule fieldRule) {
    final rule = VxStringRules.charsLessThan<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildCharsMoreThan(FieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThan<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildCharsLessThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.charsLessThanOrEqual<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildcharsMoreThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThanOrEqual<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildWordsLessThan(FieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThan<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildWordsLessThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThanOrEqual<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildWordsMoreThan(FieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThan<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }

  _buildWordsMoreThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThanOrEqual<UserMessage>(
        name: _createName(fieldRule),
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: UserMessageProducer(fieldRule.successMessages[0]),
        failureProducer: UserMessageProducer(fieldRule.failureMessages[0]));
    return rule;
  }
}
