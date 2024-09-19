import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/src/tcf_metrics.dart';
import 'package:validomix/validomix.dart';

class TextFieldEventBuilder {
  final FieldEvent fieldEvent;
  final ExMetricStoreHolder metricStoreHolder;
  final VxOptionsInventory optionsInventory;
  final String name = 'text';
  final Map<String, String> widgetOptions;
  final Map<String, String> pageOptions;

  TextFieldEventBuilder(
      {required this.fieldEvent,
      required this.metricStoreHolder,
      required this.optionsInventory,
      required this.widgetOptions,
      required this.pageOptions});

  TcfRuleComposer build() {
    final List<BaseUserRule> charChangeRules = [];
    for (var fieldRule in fieldEvent.rules) {
      final ruleItem = _buildRule(fieldRule);
      if (ruleItem != null) {
        charChangeRules.add(ruleItem);
      }
    }

    return TcfRuleComposer(charChangeRules);
  }

  BaseUserRule? _buildRule(FieldRule rule) {
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
      case 'url':
        return _buildUrl(rule);
      default:
        metricStoreHolder.store.addMetric(
            TcfMetrics.getRuleNotFound(
                id: rule.name,
                page: pageOptions['page'],
                pageRow: rule.options['text#pageRow']),
            1);
        return null;
    }
  }

  BaseUserRule _buildCharsLessThan(FieldRule fieldRule) {
    final rule = VxStringRules.charsLessThan<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildCharsMoreThan(FieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThan<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildCharsLessThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.charsLessThanOrEqual<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildcharsMoreThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThanOrEqual<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildWordsLessThan(FieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThan<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildWordsLessThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThanOrEqual<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildWordsMoreThan(FieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThan<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildWordsMoreThanOrEqual(FieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThanOrEqual<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers:
            UserMessageProducer.createProducers(fieldRule.failureMessages));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }

  BaseUserRule _buildUrl(FieldRule fieldRule) {
    final rule = VxUrlRule<UserMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers:
            UserMessageProducer.createProducers(fieldRule.successMessages),
        failureProducers: UserMessageProducer.createProducers(
            UserMessage.getMessagesWithNoFlag(fieldRule.failureMessages)),
        domainFailureProducers: UserMessageProducer.createProducers(
            UserMessage.getMessagesWithFlag(
                fieldRule.failureMessages, 'domain')),
        secureFailureProducers: UserMessageProducer.createProducers(
            UserMessage.getMessagesWithFlag(
                fieldRule.failureMessages, 'secure')));
    return UserRule(rule: rule, options: Map.from(fieldRule.options));
  }
}
