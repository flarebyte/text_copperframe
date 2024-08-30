import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

expectMetricError(
    {required ExMetricStoreHolder metricStoreHolder,
    required List<String> expectations}) {
  expect(metricStoreHolder.store.length, 1);
  final count = ExMetricAggregations.count();
  final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);
  final values = aggregatedMetrics.first.key.dimensions.values;
  for (var expectation in expectations) {
    expect(values, contains(expectation));
  }
}

String debugCountMetric(ExMetricStoreHolder metricStoreHolder) {
  if (metricStoreHolder.store.isEmpty) {
    return 'no metric';
  }
  final count = ExMetricAggregations.count();
  final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);
  final String text =
      aggregatedMetrics.map((metric) => metric.toJson().toString()).join(';');
  return text;
}

expectNoMetricError(ExMetricStoreHolder metricStoreHolder) {
  expect(metricStoreHolder.store.isEmpty, true,
      reason: debugCountMetric(metricStoreHolder));
}
