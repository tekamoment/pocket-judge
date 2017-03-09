protocol MetricType {
    
}

protocol MetricCategory {
    func maximumMinimum() -> (Float, Float)
    func categoryTypes() -> [MetricType]
}

enum MetricDefinition<MetricType, MetricCategory> {
    case Metric(MetricType, MetricCategory)
}
