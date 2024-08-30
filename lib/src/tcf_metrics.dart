import 'package:eagleyeix/metric.dart';

class TcfMetrics {
  static final lib = {'package': 'text_copperframe'};

  static ExMetricKey getRuleNotFound(String id) {
    return ExMetricKey(name: [
      'get-rule'
    ], dimensions: {
      ...lib,
      'class': 'TextFieldEventBuilder',
      'method': '_buildRule',
      'id': id,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
