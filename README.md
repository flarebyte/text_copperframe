# text\_copperframe

![Experimental](https://img.shields.io/badge/status-experimental-blue)

> The versatile text field for every design

The versatile text field for every design

![Hero image for text\_copperframe](doc/text_copperframe.jpeg)

Highlights:

-   Validate text field size

A few examples:

Create an inventory used to keep track of rules:

```dart
final optionsInventory = VxOptionsInventory()
```

Create a string rule:

```dart
final rule = VxStringRules.charsLessThan<String>(name: 'test',
metricStoreHolder: metricStoreHolder, optionsInventory: optionsInventory,
failureProducer: SimpleMessageProducer('Too many characters'));
```

## Documentation and links

-   [Code Maintenance :wrench:](MAINTENANCE.md)
-   [Code Of Conduct](CODE_OF_CONDUCT.md)
-   [Contributing :busts\_in\_silhouette: :construction:](CONTRIBUTING.md)
-   [Architectural Decision Records :memo:](DECISIONS.md)
-   [Contributors
    :busts\_in\_silhouette:](https://github.com/flarebyte/text_copperframe/graphs/contributors)
-   [Dependencies](https://github.com/flarebyte/text_copperframe/network/dependencies)
-   [Glossary
    :book:](https://github.com/flarebyte/overview/blob/main/GLOSSARY.md)
-   [Software engineering principles
    :gem:](https://github.com/flarebyte/overview/blob/main/PRINCIPLES.md)
-   [Overview of Flarebyte.com ecosystem
    :factory:](https://github.com/flarebyte/overview)
-   [Dart dependencies](DEPENDENCIES.md)
-   [Usage](USAGE.md)
-   [Example](example/example.dart)

## Related

-   [form\_validator](https://pub.dev/packages/form_validator)
