import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:text_copperframe/text_copperframe.dart';
import 'package:validomix/validomix.dart';

void main() {
  final metricStoreHolder = ExMetricStoreHolder();
  final optionsInventory = VxOptionsInventory();

  final tooSmallMessage = CopperframeMessage(
      label: 'Too small',
      level: CopperframeMessageLevel.error,
      category: 'length');
   
  // 1 is the minimum number of characters that a field must have to be considered valid
  final minRule = CopperframeFieldRule(
    name: 'chars more than',
    options: {'text#minChars': '1'},
    successMessages: [],
    failureMessages: [tooSmallMessage],
  );
  var smallEnoughMessage = CopperframeMessage(
      label: 'Small enough',
      level: CopperframeMessageLevel.info,
      category: 'length');
    
  var tooBigMessage = CopperframeMessage(
      label: 'Too big',
      level: CopperframeMessageLevel.error,
      category: 'length');

  var tooBigMessageHelp = CopperframeMessage(
      label: 'If too big try to summarise',
      level: CopperframeMessageLevel.info,
      category: 'length');

  /// 30 is the maximum number of characters that a field must have to be considered valid
  final maxRule = CopperframeFieldRule(
    name: 'chars less than',
    options: {'text#maxChars': '30'},
    successMessages: [smallEnoughMessage],
    failureMessages: [tooBigMessage, tooBigMessageHelp],
  );
  
  final event = CopperframeFieldEvent(
    name: 'OnCharChange',
    rules: [minRule, maxRule],
  );
  final builder = TextFieldEventBuilder(
      fieldEvent: event,
      metricStoreHolder: metricStoreHolder,
      optionsInventory: optionsInventory,
      widgetOptions: {'pageRow': 'row123'},
      pageOptions: {'page': 'page789'});
  final textRule = builder.build();
  
  /// Validates the text
  textRule.validate('some text');
}
