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
        var bigEnoughMessage = UserMessage(
            label: 'Big enough', level: MessageLevel.info, category: 'length');
        var tooSmallMessage = UserMessage(
            label: 'Too small', level: MessageLevel.error, category: 'length');
        final minRule = FieldRule(
          name: 'chars more than$strictness',
          options: {'text#minChars': '1'},
          successMessages: [bigEnoughMessage],
          failureMessages: [tooSmallMessage],
        );
        var smallEnoughMessage = UserMessage(
            label: 'Small enough',
            level: MessageLevel.info,
            category: 'length');
        var tooBigMessage = UserMessage(
            label: 'Too big', level: MessageLevel.error, category: 'length');
        final maxRule = FieldRule(
          name: 'chars less than$strictness',
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
            optionsInventory: optionsInventory,
            widgetOptions: {},
            pageOptions: {'page': 'page789'});
        final textRule = builder.build();
        expect(textRule.validate('some text'),
            [bigEnoughMessage, smallEnoughMessage]);
        expect(textRule.validate(''), [tooSmallMessage, smallEnoughMessage]);
        expect(textRule.validate('A' * 100), [bigEnoughMessage, tooBigMessage]);
        expectNoMetricError(metricStoreHolder);
      });
    }
    for (var strictness in ['', ' or equal']) {
      final strictnessLabel = strictness == '' ? 'strict' : 'accept equal';

      test('check validation for a range of words when $strictnessLabel', () {
        var bigEnoughMessage = UserMessage(
            label: 'Big enough', level: MessageLevel.info, category: 'length');
        var tooSmallMessage = UserMessage(
            label: 'Too small', level: MessageLevel.error, category: 'length');
        final minRule = FieldRule(
          name: 'words more than$strictness',
          options: {'text#minWords': '2'},
          successMessages: [bigEnoughMessage],
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
        expect(textRule.validate('three little words'),
            [bigEnoughMessage, smallEnoughMessage]);
        expect(textRule.validate('one'), [tooSmallMessage, smallEnoughMessage]);
        expect(textRule.validate('word ' * 100),
            [bigEnoughMessage, tooBigMessage]);
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
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: ['greater-than', 'text#minChars', 'not-found']);
    });

    test('check missing rule', () {
      var anyMessage = UserMessage(
          label: 'We should never see this message',
          level: MessageLevel.info,
          category: 'length');
      final minRule = FieldRule(
        name: 'this rule does not exist',
        options: {'text#pageRow': 'row123'},
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
  });
}
