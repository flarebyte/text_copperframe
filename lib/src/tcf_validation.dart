import 'package:eagleyeix/metric.dart';
import 'package:text_copperframe/src/higher_model.dart';
import 'package:validomix/validomix.dart';

final metricStoreHolder = ExMetricStoreHolder();
final optionsInventory = VxOptionsInventory();

class UserMessageProducer implements VxMessageProducer<UserMessage, String> {
  final UserMessage message;
  UserMessageProducer(this.message);
  @override
  UserMessage produce(Map<String, String> options, String value) => message;
}

final successMessage =
    UserMessage(label: 'Success', level: MessageLevel.info, category: 'Length');
final failureMessage = UserMessage(
    label: 'Too many characters',
    level: MessageLevel.error,
    category: 'Length');
final rule = VxStringRules.charsLessThan<UserMessage>(
    name: 'test',
    metricStoreHolder: metricStoreHolder,
    optionsInventory: optionsInventory,
    successProducer: UserMessageProducer(successMessage),
    failureProducer: UserMessageProducer(failureMessage));
