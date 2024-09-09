import 'package:eagleyeix/metric.dart';

class TcfMetrics {
  static final lib = {'package': 'text_copperframe'};

  static ExMetricKey getRuleNotFound(
      {required String id, String? page, String? pageRow}) {
    final withPage = page != null ? {'page': page} : {};
    final withPageRow = page != null
        ? {
            'pageRow': pageRow,
          }
        : {};
    return ExMetricKey(name: [
      'get-rule'
    ], dimensions: {
      ...lib,
      'class': 'TextFieldEventBuilder',
      'method': '_buildRule',
      'id': id,
      ...withPage,
      ...withPageRow,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
