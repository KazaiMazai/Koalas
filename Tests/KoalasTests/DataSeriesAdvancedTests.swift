//
//  DataSeriesAdvancedTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class DataSeriesAdvancedTests: XCTestCase {
    
    // MARK: - whereCondition Tests
    
    func test_whereCondition_WithDataSeriesType() {
        let condition = DataSeries([true, false, true, false])
        let trueSeries = DataSeries([1, 2, 3, 4])
        let falseSeries = DataSeries([10, 20, 30, 40])
        
        let result = whereCondition(condition,
                                   then: .ds(trueSeries),
                                   else: .ds(falseSeries))
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 1) // true -> trueSeries
        XCTAssertEqual(result?[1], 20) // false -> falseSeries
        XCTAssertEqual(result?[2], 3) // true -> trueSeries
        XCTAssertEqual(result?[3], 40) // false -> falseSeries
    }
    
    func test_whereCondition_WithScalarValues() {
        let condition = DataSeries([true, false, true, false])
        let trueValue = 100
        let falseValue = 200
        
        let result = whereCondition(condition,
                                   then: trueValue,
                                   else: falseValue)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 100) // true -> trueValue
        XCTAssertEqual(result?[1], 200) // false -> falseValue
        XCTAssertEqual(result?[2], 100) // true -> trueValue
        XCTAssertEqual(result?[3], 200) // false -> falseValue
    }
    
    func test_whereCondition_WithNilCondition() {
        let trueSeries = DataSeries([1, 2, 3, 4])
        let falseSeries = DataSeries([10, 20, 30, 40])
        
        let result = whereCondition(nil,
                                   then: .ds(trueSeries),
                                   else: .ds(falseSeries))
        
        XCTAssertNil(result)
    }
    
    func test_whereCondition_WithNilSeries() {
        let condition = DataSeries([true, false, true, false])
        
        let result: DataSeries<Int>? = whereCondition(condition,
                                   then: nil,
                                   else: nil)
        
        XCTAssertNil(result)
    }
    
    // MARK: - zipSeries Tests
    
    func test_zipSeries_TwoSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let result = zipSeries(s1, s2)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0]?.t1, 1)
        XCTAssertEqual(result?[0]?.t2, 5)
        XCTAssertEqual(result?[1]?.t1, 2)
        XCTAssertEqual(result?[1]?.t2, 6)
        XCTAssertEqual(result?[2]?.t1, 3)
        XCTAssertEqual(result?[2]?.t2, 7)
        XCTAssertEqual(result?[3]?.t1, 4)
        XCTAssertEqual(result?[3]?.t2, 8)
    }
    
    func test_zipSeries_ThreeSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        let s3 = DataSeries([9, 10, 11, 12])
        
        let result = zipSeries(s1, s2, s3)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0]?.t1, 1)
        XCTAssertEqual(result?[0]?.t2, 5)
        XCTAssertEqual(result?[0]?.t3, 9)
        XCTAssertEqual(result?[1]?.t1, 2)
        XCTAssertEqual(result?[1]?.t2, 6)
        XCTAssertEqual(result?[1]?.t3, 10)
    }
    
    func test_zipSeries_FourSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        let s3 = DataSeries([9, 10, 11, 12])
        let s4 = DataSeries([13, 14, 15, 16])
        
        let result = zipSeries(s1, s2, s3, s4)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0]?.t1, 1)
        XCTAssertEqual(result?[0]?.t2, 5)
        XCTAssertEqual(result?[0]?.t3, 9)
        XCTAssertEqual(result?[0]?.t4, 13)
        XCTAssertEqual(result?[1]?.t1, 2)
        XCTAssertEqual(result?[1]?.t2, 6)
        XCTAssertEqual(result?[1]?.t3, 10)
        XCTAssertEqual(result?[1]?.t4, 14)
    }
    
    func test_zipSeries_WithNilSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        
        let result: DataSeries<Tuple2<Int?, Int?>>? = zipSeries(s1, nil)
        
        XCTAssertNil(result)
    }
    
    //    func test_zipSeries_WithDifferentLengths() {
    //        let s1 = DataSeries([1, 2, 3, 4])
    //        let s2 = DataSeries([5, 6, 7]) // Different length
    //        
    //        let result = zipSeries(s1, s2)
    //        
    //        // Should assert and fail in debug mode
    //        XCTAssertNotNil(result)
    //    }
    
    // MARK: - whereTrue Tests
    
    func test_whereTrue_WithValidSeries() {
        let condition = DataSeries([true, false, true, false, nil])
        let trueSeries = DataSeries([1, 2, 3, 4, 5])
        let falseSeries = DataSeries([10, 20, 30, 40, 50])
        
        let result = condition.whereTrue(then: trueSeries, else: falseSeries)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 1) // true -> trueSeries
        XCTAssertEqual(result?[1], 20) // false -> falseSeries
        XCTAssertEqual(result?[2], 3) // true -> trueSeries
        XCTAssertEqual(result?[3], 40) // false -> falseSeries
        XCTAssertNil(result?[4]) // nil -> nil
    }
    
    func test_whereTrue_WithNilSeries() {
        let condition = DataSeries([true, false, true])
        
        let result: DataSeries<Int>? = condition.whereTrue(then: nil, else: nil)
        
        XCTAssertNil(result)
    }
    
    //    func test_whereTrue_WithDifferentLengths() {
    //        let condition = DataSeries([true, false, true])
    //        let trueSeries = DataSeries([1, 2]) // Shorter
    //        let falseSeries = DataSeries([10, 20, 30])
    //        
    //        let result = condition.whereTrue(then: trueSeries, else: falseSeries)
    //        
    //        XCTAssertNotNil(result)
    //        XCTAssertEqual(result?[0], 1) // true -> trueSeries
    //        XCTAssertEqual(result?[1], 20) // false -> falseSeries
    //        XCTAssertEqual(result?[2], 30) // true -> falseSeries (trueSeries too short)
    //    }
    
    // MARK: - isEmptySeries Tests
    
    func test_isEmptySeries_WithAllNils() {
        let series: DataSeries<Int?> = DataSeries([nil, nil, nil])
        
        XCTAssertTrue(series.isEmptySeries())
    }
    
    func test_isEmptySeries_WithSomeNils() {
        let series = DataSeries([1, nil, 3])
        
        XCTAssertFalse(series.isEmptySeries())
    }
    
    func test_isEmptySeries_WithNoNils() {
        let series = DataSeries([1, 2, 3])
        
        XCTAssertFalse(series.isEmptySeries())
    }
    
    func test_isEmptySeries_WithEmptySeries() {
        let series: DataSeries<Int> = DataSeries()
        
        XCTAssertTrue(series.isEmptySeries())
    }
    
    // MARK: - at and setAt Tests
    
    func test_at_WithValidIndex() {
        let series = DataSeries([1, 2, 3, 4, 5])
        
        XCTAssertEqual(series.at(index: 0), 1)
        XCTAssertEqual(series.at(index: 2), 3)
        XCTAssertEqual(series.at(index: 4), 5)
    }
    
    func test_at_WithInvalidIndex() {
        let series = DataSeries([1, 2, 3, 4, 5])
        
        XCTAssertNil(series.at(index: -1) as Any?)
        XCTAssertNil(series.at(index: 5) as Any?)
        XCTAssertNil(series.at(index: 10) as Any?)
    }
    
    func test_setAt_WithValidIndex() {
        let series = DataSeries([1, 2, 3, 4, 5])
        
        let result = series.setAt(index: 2, value: 100)
        
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 2)
        XCTAssertEqual(result[2], 100)
        XCTAssertEqual(result[3], 4)
        XCTAssertEqual(result[4], 5)
    }
    
    func test_setAt_WithInvalidIndex() {
        let series = DataSeries([1, 2, 3, 4, 5])
        
        let result = series.setAt(index: 10, value: 100)
        
        // Should return unchanged series
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 2)
        XCTAssertEqual(result[2], 3)
        XCTAssertEqual(result[3], 4)
        XCTAssertEqual(result[4], 5)
    }
    
    // MARK: - scanSeries Tests
    
    func test_scanSeries_WithAddition() {
        let series = DataSeries([1, 2, 3, 4, 5])
        
        let result = series.scanSeries(initial: 0) { current, next in
            (current ?? 0) + (next ?? 0)
        }
        
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 3)
        XCTAssertEqual(result[2], 6)
        XCTAssertEqual(result[3], 10)
        XCTAssertEqual(result[4], 15)
    }
    
    func test_scanSeries_WithNilValues() {
        let series = DataSeries([1, nil, 3, 4, 5])
        
        let result = series.scanSeries(initial: 0) { current, next in
            (current ?? 0) + (next ?? 0)
        }
        
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 1) // 1 + 0 (nil)
        XCTAssertEqual(result[2], 4) // 1 + 3
        XCTAssertEqual(result[3], 8) // 4 + 4
        XCTAssertEqual(result[4], 13) // 8 + 5
    }
    
    // MARK: - toDateComponents Tests
    
    func test_toDateComponents_WithValidDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let dates = DataSeries([
            dateFormatter.date(from: "2020/01/15"),
            dateFormatter.date(from: "2021/06/20"),
            dateFormatter.date(from: "2022/12/31")
        ])
        
        let result = dates.toDateComponents()
        
        XCTAssertEqual(result[.year]?.count, 3)
        XCTAssertEqual(result[.month]?.count, 3)
        XCTAssertEqual(result[.day]?.count, 3)
        
        XCTAssertEqual(result[.year]?[0], 2020)
        XCTAssertEqual(result[.month]?[0], 1)
        XCTAssertEqual(result[.day]?[0], 15)
        
        XCTAssertEqual(result[.year]?[1], 2021)
        XCTAssertEqual(result[.month]?[1], 6)
        XCTAssertEqual(result[.day]?[1], 20)
        
        XCTAssertEqual(result[.year]?[2], 2022)
        XCTAssertEqual(result[.month]?[2], 12)
        XCTAssertEqual(result[.day]?[2], 31)
    }
    
    func test_toDateComponents_WithNilDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let dates = DataSeries([
            dateFormatter.date(from: "2020/01/15"),
            nil,
            dateFormatter.date(from: "2022/12/31")
        ])
        
        let result = dates.toDateComponents()
        
        XCTAssertEqual(result[.year]?.count, 3)
        XCTAssertEqual(result[.month]?.count, 3)
        XCTAssertEqual(result[.day]?.count, 3)
        
        XCTAssertEqual(result[.year]?[0], 2020)
        XCTAssertNil(result[.year]?[1])
        XCTAssertEqual(result[.year]?[2], 2022)
    }
} 