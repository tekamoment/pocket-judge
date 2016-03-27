//
//  Decision.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 2/18/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation
import RealmSwift

class Decision: Object {
    dynamic var name = ""
    private let privateOptions = List<Option>()
    var options: List<Option> {
        get {
            return privateOptions
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
        privateOptions.append(Option(name: "Option 1"))
        privateOptions.append(Option(name: "Option 2"))
    }
    
    // prevent direct manipulation of list
    func addOption(option: Option) {
        privateOptions.append(option)
    }
    
    func removeOption(index: Int) throws {
        if privateOptions.count == 2 {
            throw OptionCountError.MinimumOptionsReached
        }
        privateOptions.removeAtIndex(index)
    }
}

enum OptionCountError: ErrorType {
    case MinimumOptionsReached
}

class Option: Object {
    dynamic var name = ""
    let aggregateValue = RealmOptional<Float>()
    //
    let metrics = List<Metric>()
    let metricList = ["fondness", "permanence", "frequency", "risk", "distance", "time", "familiarity", "opportunity", "quality", "money", "effort", "coolness", "thoughtfulness"]
    
    convenience init(name: String){
        self.init()
        self.name = name
        for metricName in metricList {
            metrics.append(Metric(definition: MetricDefinition(metricDef: metricName)!))
        }
    }
    
    func computeAggregatedValue() -> Float? {
        
        var metricDictionary = [String: Float]()
        
        for metric in metrics {
            guard metric.userValue.value != nil && metricDictionary.indexForKey(metric.type.metricDefinition) == nil else {
                return nil
            }
            
            metricDictionary[metric.type.metricDefinition] = metric.userValue.value
        }
        
        guard Set(Array(metricDictionary.keys)).isSubsetOf(Set(metricList)) else {
            return nil
        }
        
        let firstMultiply = metricDictionary["fondness"]! * (metricDictionary["permanence"]! * metricDictionary["frequency"]!) / 56.25
        let secondMultiply = metricDictionary["risk"]! + (metricDictionary["distance"]! + metricDictionary["time"]!)
        let thirdMultiply = 1 + (metricDictionary["familiarity"]! + metricDictionary["opportunity"]! + metricDictionary["quality"]!) / 3 - (metricDictionary["money"]! + metricDictionary["effort"]!) / 2
        let fourthMultiply = metricDictionary["coolness"]! + metricDictionary["thoughtfulness"]!
        aggregateValue.value = firstMultiply * secondMultiply * thirdMultiply * fourthMultiply
        return aggregateValue.value
    }
    
    override static func indexedProperties() -> [String] {
        return ["metricList"]
    }
}

class Metric: Object {
    private dynamic var privateType = ""
    var type: MetricDefinition {
        get {
            return MetricDefinition(metricDef: privateType)!
        }
        
        set {
            privateType = newValue.metricDefinition
        }
    }

    private let userValue = RealmOptional<Float>()
    var value: Float? {
        set {
            if newValue == nil {
                userValue.value = nil
            } else {
                setMetricValue(newValue!)
            }
        }
        
        get {
            return userValue.value
        }
    }
    
    convenience init(definition: MetricDefinition) {
        self.init()
        self.privateType = definition.metricDefinition
    }
    
    func setMetricValue(newValue: Float) {
        var lowerBound, upperBound: Float
        if type.maximumMinimum().0 > type.maximumMinimum().1 {
            lowerBound = type.maximumMinimum().1
            upperBound = type.maximumMinimum().0
        } else {
            lowerBound = type.maximumMinimum().0
            upperBound = type.maximumMinimum().1
        }
        
        if case lowerBound ... upperBound = newValue {
            userValue.value = newValue
        } else if newValue > upperBound {
            userValue.value = upperBound
        } else {
            userValue.value = lowerBound
        }
    }
    
    override static func indexedProperties() -> [String] {
        return ["value", "type"]
    }
}

enum MetricDefinition {
    case Preference(PreferenceMetric)
    enum PreferenceMetric: String {
        case Fondness
    }
    
    case Duration(DurationMetric)
    enum DurationMetric: String {
        case Permanence
        case Frequency
    }
    
    case Certainty(CertaintyMetric)
    enum CertaintyMetric: String {
        case Risk
    }
    
    case Closeness(ClosenessMetric)
    enum ClosenessMetric: String {
        case Distance
        case Time
    }
    
    case Productiveness(ProductivenessMetric)
    enum ProductivenessMetric: String {
        case Familiarity
        case Opportunity
        case Quality
    }
    
    case Cost(CostMetric)
    enum CostMetric: String {
        case Money
        case Effort
    }
    
    case Social(SocialMetric)
    enum SocialMetric: String {
        case Coolness
        case Thoughtfulness
    }
    
    var metricCategory: String {
        switch self {
        case Preference: return "Preference"
        case Duration: return "Duration"
        case Certainty: return "Certainty"
        case Closeness: return "Closeness"
        case Productiveness: return "Productiveness"
        case Cost: return "Cost"
        case Social: return "Social"
        }
    }
    
    func allMetricCategories() -> [String] {
        return ["Preference", "Duration", "Certainty", "Closeness", "Productiveness", "Cost", "Social"]
    }
    
    var metricDefinition: String {
        switch self {
        case .Preference(let m): return m.rawValue
        case .Duration(let m): return m.rawValue
        case .Certainty(let m): return m.rawValue
        case .Closeness(let m): return m.rawValue
        case .Productiveness(let m): return m.rawValue
        case .Cost(let m): return m.rawValue
        case .Social(let m): return m.rawValue
        }
    }
    
    func maximumMinimum() -> (Float, Float) {
        switch self {
        case Preference: return (0.0, 1.0)
        case Duration: return (0.0, 10.0)
        case Certainty: return (0.0, 0.5)
        case Closeness: return (0.0, 0.25)
        case Productiveness: return (0.0, 1.0)
        case Cost: return (1.0, 0.0)
        case Social: return (0.0, 0.75)
        }
    }
    
    init?(metricDef: String) {
        let mD = metricDef.lowercaseString
        switch mD {
            case "fondness": self = .Preference(.Fondness)
            case "permanence": self = .Duration(.Permanence)
            case "frequency": self = .Duration(.Frequency)
            case "risk": self = .Certainty(.Risk)
            case "distance": self = .Closeness(.Distance)
            case "time": self = .Closeness(.Time)
            case "familiarity": self = .Productiveness(.Familiarity)
            case "opportunity": self = .Productiveness(.Opportunity)
            case "quality": self = .Productiveness(.Quality)
            case "money": self = .Cost(.Money)
            case "effort": self = .Cost(.Effort)
            case "coolness": self = .Social(.Coolness)
            case "thoughtfulness": self = .Social(.Thoughtfulness)
            default:
                return nil
        }
    }
}