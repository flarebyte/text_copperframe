import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:validomix/validomix.dart';

final metricStoreHolder = ExMetricStoreHolder();
final optionsInventory = VxOptionsInventory();
final successMessage = UserMessage(label: 'Success', level: MessageLevel.info, category: 'Length');
final failureMessage = UserMessage(label: 'Too many characters', level: MessageLevel.error, category: 'Length');
final rule = VxStringRules.charsLessThan<UserMessage>(
    name: 'test',
    metricStoreHolder: metricStoreHolder,
    optionsInventory: optionsInventory,
    successProducer: successMessage,
    failureProducer: failureMessage);
