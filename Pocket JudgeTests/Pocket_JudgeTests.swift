//
//  Pocket_JudgeTests.swift
//  Pocket JudgeTests
//
//  Created by Carlos Arcenas on 2/18/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Pocket_Judge

extension XCTestCase {
    func XCTAssertThrows<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
        do {
            try expression()
            XCTFail("No error to catch! - \(message)", file: file, line: line)
        } catch {
        }
    }
    
    func XCTAssertNoThrow<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
        do {
            try expression()
        } catch let error {
            XCTFail("Caught error: \(error) - \(message)", file: file, line: line)
        }
    }
}

class Pocket_JudgeTests: XCTestCase {
    
    var testRealm: Realm?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        testRealm = try! Realm()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecisionCreation() {
        let decision = Decision(name: "Decision Title")
        XCTAssertTrue(decision.name == "Decision Title")
        XCTAssertEqual(decision.options.count, 2)
        
        try! testRealm!.write {
            testRealm!.add(decision)
        }
        
        testOptionAddition(decision)
        testComputationFailure(decision)
    }
    
    func testOptionAddition(decision: Decision) {
        let newOption = Option(name: "Option 3")
        try! testRealm!.write {
            decision.addOption(newOption)
        }
        XCTAssertTrue(decision.options.filter("name = 'Option 3'").count == 1)
    }
    
    func testComputationFailure(decision: Decision) {
        XCTAssertNil(decision.options.first!.computeAggregatedValue())
    }
    
    func testOptionMetricBounds() {
        let decision = Decision(name: "Test Decision")
        let option = decision.options.first!
        for metric in option.metrics {
            let metricMax = metric.type.maximumMinimum().1
            let metricMin = metric.type.maximumMinimum().0
            let targetVal = (metricMax + metricMin) / 2
            metric.value = targetVal
            XCTAssertTrue(metric.value == targetVal)
            metric.value = -100
            if metricMax < metricMin {
                XCTAssertEqual(metric.value, metricMax)
            } else {
                XCTAssertEqual(metric.value, metricMin)
            }
            
            metric.value = 100
            if metricMax < metricMin {
                XCTAssertEqual(metric.value, metricMin)
            } else {
                XCTAssertEqual(metric.value, metricMax)
            }
        }
    }
    
    func testOptionRemoval() {
        let decision = Decision(name: "Decision Title")
        XCTAssertThrows(try decision.removeOption(0))
        decision.options.append(Option(name: "Option 3"))
        XCTAssertNoThrow(try decision.removeOption(0))
    }
    
    func testMetricDefinitionCreation() {
        let fondness = MetricDefinition(metricDef: "fondness")
        XCTAssertNotNil(fondness)
        let permanence = MetricDefinition(metricDef: "permanence")
        XCTAssertNotNil(permanence)
        let frequency = MetricDefinition(metricDef: "frequency")
        XCTAssertNotNil(frequency)
        let risk = MetricDefinition(metricDef: "risk")
        XCTAssertNotNil(risk)
        let distance = MetricDefinition(metricDef: "distance")
        XCTAssertNotNil(distance)
        let time = MetricDefinition(metricDef: "time")
        XCTAssertNotNil(time)
        let familiarity = MetricDefinition(metricDef: "familiarity")
        XCTAssertNotNil(familiarity)
        let opportunity = MetricDefinition(metricDef: "opportunity")
        XCTAssertNotNil(opportunity)
        let quality = MetricDefinition(metricDef: "quality")
        XCTAssertNotNil(quality)
        let money = MetricDefinition(metricDef: "money")
        XCTAssertNotNil(money)
        let effort = MetricDefinition(metricDef: "effort")
        XCTAssertNotNil(effort)
        let coolness = MetricDefinition(metricDef: "coolness")
        XCTAssertNotNil(coolness)
        let thoughtfulness = MetricDefinition(metricDef: "thoughtfulness")
        XCTAssertNotNil(thoughtfulness)
        
        let niller = MetricDefinition(metricDef: "nil")
        XCTAssertNil(niller)
    }
    
    func testCorrectValue() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
