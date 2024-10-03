import 'package:eagleyeix/metric.dart';

/// Metrics for the [TextCopperframe] package.
class TcfMetrics {
  static final lib = {'package': 'text_copperframe'};

  /// Metric to record a rule not found error.
  static ExMetricKey getRuleNotFound(
      {required String id, String? page, String? pageRow}) {
    final withPage = page != null ? {'page': page} : {};
    final withPageRow = pageRow != null
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
