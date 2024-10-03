# text_copperframe

![Experimental](https://img.shields.io/badge/status-experimental-blue)

> The versatile text field for every design

Validate a text field and produce a user-friendly message.

![Hero image for text_copperframe](doc/text_copperframe.jpeg)

Highlights:

* Validate a text field based on character size
* Validate a text field based on word size
* Validate a URL text field
* Produce meaningful messages that can be understood by the user
* Can produce multiple messages for success or failure



A few examples:

Create a message:
```dart
final tooSmallMessage = CopperframeMessage(label: 'Too small',level: CopperframeMessageLevel.error, category: 'length');
```
Create a rule:
```dart
final minRule = CopperframeFieldRule(name: 'chars more than',options: {'text#minChars': '1'}, successMessages: [], failureMessages: [tooSmallMessage]);
```
Create a field event:
```dart
final event = CopperframeFieldEvent(name: 'OnCharChange', rules: [minRule]);
```
Create a text field event builder:
```dart
final builder = TextFieldEventBuilder(fieldEvent: event, metricStoreHolder: metricStoreHolder, optionsInventory: optionsInventory, widgetOptions: {'pageRow': 'row123'}, pageOptions: {'page': 'page789'});
```
Build a text field event using the builder:
```dart
final textRule = builder.build();
```
Validate the text field:
```dart
textRule.validate('some text');
```

## Documentation and links

* [Code Maintenance :wrench:](MAINTENANCE.md)
* [Code Of Conduct](CODE_OF_CONDUCT.md)
* [Contributing :busts_in_silhouette: :construction:](CONTRIBUTING.md)
* [Architectural Decision Records :memo:](DECISIONS.md)
* [Contributors :busts_in_silhouette:](https://github.com/flarebyte/text_copperframe/graphs/contributors)
* [Dependencies](https://github.com/flarebyte/text_copperframe/network/dependencies)
* [Glossary :book:](https://github.com/flarebyte/overview/blob/main/GLOSSARY.md)
* [Software engineering principles :gem:](https://github.com/flarebyte/overview/blob/main/PRINCIPLES.md)
* [Overview of Flarebyte.com ecosystem :factory:](https://github.com/flarebyte/overview)
* [Dart dependencies](DEPENDENCIES.md)
* [Usage](USAGE.md)
* [Example](example/example.dart)

## Related

* [form_validator](https://pub.dev/packages/form_validator)
