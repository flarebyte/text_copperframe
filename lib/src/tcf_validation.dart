import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/src/tcf_metrics.dart';
import 'package:validomix/validomix.dart';

/// A class that contains the rule names for text field
class TextFieldEventNames {
  static const charsLessThan = 'chars less than';
  static const charsLessThanOrEqual = 'chars less than or equal';
  static const charsMoreThan = 'chars more than';
  static const charsMoreThanOrEqual = 'chars more than or equal';
  static const wordsLessThan = 'words less than';
  static const wordsLessThanOrEqual = 'words less than or equal';
  static const wordsMoreThan = 'words more than';
  static const wordsMoreThanOrEqual = 'words more than or equal';
  static const url = 'url';
  static const all = [
    charsLessThan,
    charsLessThanOrEqual,
    charsMoreThan,
    charsMoreThanOrEqual,
    wordsLessThan,
    wordsLessThanOrEqual,
    wordsMoreThan,
    wordsMoreThanOrEqual,
    url
  ];
}

/// A class that builds multiple
class TextFieldEventBuilder {
  final CopperframeFieldEvent fieldEvent;
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

  CopperframeRuleComposer build() {
    final List<BaseCopperframeRule> charChangeRules = [];
    for (var fieldRule in fieldEvent.rules) {
      final ruleItem = _buildRule(fieldRule);
      if (ruleItem != null) {
        charChangeRules.add(ruleItem);
      }
    }

    return CopperframeRuleComposer(charChangeRules);
  }

  /// Merges the options from the page, widget and field rules
  Map<String, String> _mergeOptions(Map<String, String> fieldRuleOpts) {
    final Map<String, String> mergedOpts = Map.from(pageOptions);
    mergedOpts.addAll(widgetOptions);
    mergedOpts.addAll(fieldRuleOpts);
    return mergedOpts;
  }

  BaseCopperframeRule? _buildRule(CopperframeFieldRule rule) {
    switch (rule.name) {
      case TextFieldEventNames.charsLessThan:
        return _buildCharsLessThan(rule);
      case TextFieldEventNames.charsLessThanOrEqual:
        return _buildCharsLessThanOrEqual(rule);
      case TextFieldEventNames.charsMoreThan:
        return _buildCharsMoreThan(rule);
      case TextFieldEventNames.charsMoreThanOrEqual:
        return _buildcharsMoreThanOrEqual(rule);
      case TextFieldEventNames.wordsLessThan:
        return _buildWordsLessThan(rule);
      case TextFieldEventNames.wordsLessThanOrEqual:
        return _buildWordsLessThanOrEqual(rule);
      case TextFieldEventNames.wordsMoreThan:
        return _buildWordsMoreThan(rule);
      case TextFieldEventNames.wordsMoreThanOrEqual:
        return _buildWordsMoreThanOrEqual(rule);
      case TextFieldEventNames.url:
        return _buildUrl(rule);
      default:
        metricStoreHolder.store.addMetric(
            TcfMetrics.getRuleNotFound(
                id: rule.name,
                page: pageOptions['page'],
                pageRow: rule.options['pageRow']),
            1);
        return null;
    }
  }

  BaseCopperframeRule _buildCharsLessThan(CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.charsLessThan<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildCharsMoreThan(CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThan<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildCharsLessThanOrEqual(
      CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.charsLessThanOrEqual<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildcharsMoreThanOrEqual(
      CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.charsMoreThanOrEqual<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildWordsLessThan(CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThan<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildWordsLessThanOrEqual(
      CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.wordsLessThanOrEqual<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildWordsMoreThan(CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThan<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildWordsMoreThanOrEqual(
      CopperframeFieldRule fieldRule) {
    final rule = VxStringRules.wordsMoreThanOrEqual<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            fieldRule.failureMessages));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }

  BaseCopperframeRule _buildUrl(CopperframeFieldRule fieldRule) {
    final rule = VxUrlRule<CopperframeMessage>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducers: CopperframeMessageProducer.createProducers(
            fieldRule.successMessages),
        failureProducers: CopperframeMessageProducer.createProducers(
            CopperframeMessage.getMessagesWithNoFlag(
                fieldRule.failureMessages)),
        domainFailureProducers: CopperframeMessageProducer.createProducers(
            CopperframeMessage.getMessagesWithFlag(
                fieldRule.failureMessages, 'domain')),
        secureFailureProducers: CopperframeMessageProducer.createProducers(
            CopperframeMessage.getMessagesWithFlag(
                fieldRule.failureMessages, 'secure')));
    return CopperframeRule(
        rule: rule, options: _mergeOptions(fieldRule.options));
  }
}
