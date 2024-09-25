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

    for (var strictness in ['', ' or equal']) {
      final strictnessLabel = strictness == '' ? 'strict' : 'accept equal';

      test('check validation for a range of chars when $strictnessLabel', () {
        final tooSmallMessage = UserMessage(
            label: 'Too small', level: MessageLevel.error, category: 'length');
        final minRule = FieldRule(
          name: 'chars more than$strictness',
          options: {'text#minChars': '1'},
          successMessages: [],
          failureMessages: [tooSmallMessage],
        );
        var smallEnoughMessage = UserMessage(
            label: 'Small enough',
            level: MessageLevel.info,
            category: 'length');
        var tooBigMessage = UserMessage(
            label: 'Too big', level: MessageLevel.error, category: 'length');
        var tooBigMessageHelp = UserMessage(
            label: 'If too big try to summarise',
            level: MessageLevel.info,
            category: 'length');
        final maxRule = FieldRule(
          name: 'chars less than$strictness',
          options: {'text#maxChars': '30'},
          successMessages: [smallEnoughMessage],
          failureMessages: [tooBigMessage, tooBigMessageHelp],
        );
        final event = FieldEvent(
          name: 'OnCharChange',
          rules: [minRule, maxRule],
        );
        final builder = TextFieldEventBuilder(
            fieldEvent: event,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {'page': 'page789'});
        final textRule = builder.build();
        expect(textRule.validate('some text'), [smallEnoughMessage]);
        expect(textRule.validate(''), [tooSmallMessage, smallEnoughMessage]);
        expect(
            textRule.validate('A' * 100), [tooBigMessage, tooBigMessageHelp]);
        expectNoMetricError(metricStoreHolder);
      });
    }
    for (var strictness in ['', ' or equal']) {
      final strictnessLabel = strictness == '' ? 'strict' : 'accept equal';

      test('check validation for a range of words when $strictnessLabel', () {
        var tooSmallMessage = UserMessage(
            label: 'Too small', level: MessageLevel.error, category: 'length');
        final minRule = FieldRule(
          name: 'words more than$strictness',
          options: {'text#minWords': '2'},
          successMessages: [],
          failureMessages: [tooSmallMessage],
        );
        var smallEnoughMessage = UserMessage(
            label: 'Small enough',
            level: MessageLevel.info,
            category: 'length');
        var tooBigMessage = UserMessage(
            label: 'Too big', level: MessageLevel.error, category: 'length');
        final maxRule = FieldRule(
          name: 'words less than$strictness',
          options: {'text#maxWords': '30'},
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
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {'page': 'page789'});
        final textRule = builder.build();
        expect(textRule.validate('three little words'), [smallEnoughMessage]);
        expect(textRule.validate('one'), [tooSmallMessage, smallEnoughMessage]);
        expect(textRule.validate('word ' * 100), [tooBigMessage]);
        expectNoMetricError(metricStoreHolder);
      });
    }

    test('check validation for a url', () {
      var validMessage = UserMessage(
          label: 'Valid', level: MessageLevel.info, category: 'url');
      var invalidMessage = UserMessage(
          label: 'Invalid', level: MessageLevel.error, category: 'url');
      var invalidDomainMessage = UserMessage(
          label: 'Invalid domain',
          level: MessageLevel.error,
          category: 'url',
          flags: 'domain');
      var insecureMessage = UserMessage(
          label: 'Insecure',
          level: MessageLevel.error,
          category: 'url',
          flags: 'secure');
      final urlRule = FieldRule(
        name: 'url',
        options: {
          'text~allowDomains': 'en.wikipedia.org dart.dev',
          'text~secure': 'true'
        },
        successMessages: [validMessage],
        failureMessages: [
          invalidMessage,
          invalidDomainMessage,
          insecureMessage
        ],
      );
      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [urlRule],
      );
      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          widgetOptions: {},
          pageOptions: {'page': 'page789'});
      final textRule = builder.build();
      expect(textRule.validate('https://en.wikipedia.org/wiki/Henry_VIII'),
          [validMessage]);
      expect(textRule.validate('not a url'), [invalidMessage]);
      expect(textRule.validate('https://en.other.com/wiki/Henry_VIII'),
          [invalidDomainMessage]);
      expect(textRule.validate('http://en.wikipedia.org/wiki/Henry_VIII'),
          [insecureMessage]);
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

      final minRuleWithMetricInfo = FieldRule(
        name: 'chars more than',
        options: {'page': 'page789', 'pageRow': 'row123'},
        successMessages: [anyMessage],
        failureMessages: [anyMessage],
      );

      final event = FieldEvent(
        name: 'OnCharChange',
        rules: [minRule],
      );
      final eventWithMetricInfo = FieldEvent(
        name: 'OnCharChange',
        rules: [minRuleWithMetricInfo],
      );
      final builders = [
        TextFieldEventBuilder(
            fieldEvent: event,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {'pageRow': 'row123'},
            pageOptions: {'page': 'page789'}),
        TextFieldEventBuilder(
            fieldEvent: event,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {'page': 'page789', 'pageRow': 'row123'}),
        TextFieldEventBuilder(
            fieldEvent: event,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {'page': 'page789', 'pageRow': 'row123'},
            pageOptions: {}),
        TextFieldEventBuilder(
            fieldEvent: event,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {'page': 'page789', 'pageRow': 'row123'},
            pageOptions: {'page': 'pageOpts789', 'pageRow': 'rowOpts123'}),
        TextFieldEventBuilder(
            fieldEvent: eventWithMetricInfo,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {}),
        TextFieldEventBuilder(
            fieldEvent: eventWithMetricInfo,
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {'page': 'pageOpts789', 'pageRow': 'rowOpts123'}),
      ];
      for (var builder in builders) {
        final textRule = builder.build();
        textRule.validate('some text');
        expectMetricError(metricStoreHolder: metricStoreHolder, expectations: [
          'greater-than',
          'text#minChars',
          'not-found',
          'page789',
          'row123'
        ]);
      }
    });

    test('check missing rule', () {
      var anyMessage = UserMessage(
          label: 'We should never see this message',
          level: MessageLevel.info,
          category: 'length');
      final minRule = FieldRule(
        name: 'this rule does not exist',
        options: {'pageRow': 'row123'},
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
          optionsInventory: optionsInventory,
          widgetOptions: {},
          pageOptions: {'page': 'page789'});
      final textRule = builder.build();
      textRule.validate('some text');
      expectMetricError(metricStoreHolder: metricStoreHolder, expectations: [
        'this rule does not exist',
        'not-found',
        'page789',
        'row123'
      ]);
    });

    test('check inventory', () {
      var anyMessage = UserMessage(
          label: 'We should never see this message',
          level: MessageLevel.info,
          category: 'length');
      final names = ['chars more than', 'chars less than'];
      final List<FieldRule> rules = names
          .map((name) => FieldRule(
                name: name,
                options: {},
                successMessages: [anyMessage],
                failureMessages: [anyMessage],
              ))
          .toList();

      final event = FieldEvent(
        name: 'OnCharChange',
        rules: rules,
      );

      final builder = TextFieldEventBuilder(
          fieldEvent: event,
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          widgetOptions: {},
          pageOptions: {});

      builder.build();
      final inventoryKeyList = optionsInventory
          .toList()
          .map((key) => '${key.name},${key.descriptors.join(" ")}')
          .toList();
      expect(inventoryKeyList,
          ['text#maxChars,integer positive', 'text#minChars,integer positive']);
    });
  });
}
