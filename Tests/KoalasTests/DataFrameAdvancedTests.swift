//
//  DataFrameAdvancedTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class DataFrameAdvancedTests: XCTestCase {
    
    // MARK: - upscaleTransform Tests
    
    func test_upscaleTransform_TransformsDataSeriesToDataFrame() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.upscaleTransform { series in
            DataFrame(dictionaryLiteral: ("transformed", series))
        }
        
        XCTAssertEqual(result["transformed"]?["col1"]?.count, 4)
        XCTAssertEqual(result["transformed"]?["col2"]?.count, 4)
        XCTAssertEqual(result["transformed"]?["col1"]?[0], 1)
        XCTAssertEqual(result["transformed"]?["col2"]?[0], 5)
    }
    
    // MARK: - flatMapValues Tests
    
    func test_flatMapValues_TransformsValues() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.flatMapValues { value in
            value.map { $0 * 2 }
        }
        
        XCTAssertEqual(result["col1"]?[0], 2)
        XCTAssertEqual(result["col1"]?[1], 4)
        XCTAssertEqual(result["col2"]?[0], 10)
        XCTAssertEqual(result["col2"]?[1], 12)
    }
    
    func test_flatMapValues_HandlesNilValues() {
        let s1 = DataSeries([1, nil, 3, 4])
        let s2 = DataSeries([5, 6, nil, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.flatMapValues { value in
            value.map { $0 * 2 }
        }
        
        XCTAssertEqual(result["col1"]?[0], 2)
        XCTAssertNil(result["col1"]?[1])
        XCTAssertEqual(result["col1"]?[2], 6)
        XCTAssertEqual(result["col2"]?[0], 10)
        XCTAssertEqual(result["col2"]?[1], 12)
        XCTAssertNil(result["col2"]?[2])
    }
    
    // MARK: - mapTo Series Tests
    
    func test_mapToSeries_WithValidSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        let targetSeries = DataSeries([10, 20, 30, 40])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.mapTo(series: targetSeries)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?.count, 4)
        XCTAssertEqual(result?["col2"]?.count, 4)
        XCTAssertEqual(result?["col1"]?[0], 10)
        XCTAssertEqual(result?["col1"]?[1], 20)
        XCTAssertEqual(result?["col2"]?[0], 10)
        XCTAssertEqual(result?["col2"]?[1], 20)
    }
    
    func test_mapToSeries_WithNilSeries() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result: DataFrame<String, Int>? = df.mapTo(series: nil)
        
        XCTAssertNil(result)
    }
    
    //    func test_mapToSeries_WithDifferentLengthSeries() {
    //        let s1 = DataSeries([1, 2, 3, 4])
    //        let s2 = DataSeries([5, 6, 7, 8])
    //        let targetSeries = DataSeries([10, 20, 30]) // Different length
    //        
    //        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
    //        
    //        let result = df.mapTo(series: targetSeries)
    //        
    //        // Should assert and fail in debug mode, but we can't test assertions easily
    //        // This test documents the expected behavior
    //        XCTAssertNotNil(result)
    //    }
    
    // MARK: - scan Tests
    
    func test_scan_WithAddition() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.scan(initial: 0) { current, next in
            (current ?? 0) + (next ?? 0)
        }
        
        XCTAssertEqual(result["col1"]?[0], 1)
        XCTAssertEqual(result["col1"]?[1], 3)
        XCTAssertEqual(result["col1"]?[2], 6)
        XCTAssertEqual(result["col1"]?[3], 10)
        XCTAssertEqual(result["col2"]?[0], 5)
        XCTAssertEqual(result["col2"]?[1], 11)
        XCTAssertEqual(result["col2"]?[2], 18)
        XCTAssertEqual(result["col2"]?[3], 26)
    }
    
    func test_scan_WithNilValues() {
        let s1 = DataSeries([1, nil, 3, 4])
        let s2 = DataSeries([5, 6, nil, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.scan(initial: 0) { current, next in
            (current ?? 0) + (next ?? 0)
        }
        
        XCTAssertEqual(result["col1"]?[0], 1)
        XCTAssertEqual(result["col1"]?[1], 1) // nil + 0
        XCTAssertEqual(result["col1"]?[2], 4)
        XCTAssertEqual(result["col1"]?[3], 8)
    }
    
    // MARK: - rollingFunc Tests
    
    func test_rollingFunc_WithSum() {
        let s1 = DataSeries([1, 2, 3, 4, 5])
        let s2 = DataSeries([5, 6, 7, 8, 9])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingFunc(initial: 0, window: 3) { window in
            window.compactMap { $0 }.reduce(0, +)
        }
        
        XCTAssertEqual(result["col1"]?[0], 1) // Window not full yet, but returns actual value
        XCTAssertEqual(result["col1"]?[1], 3) // Window not full yet, but returns actual sum
        XCTAssertEqual(result["col1"]?[2], 6) // 1+2+3
        XCTAssertEqual(result["col1"]?[3], 9) // 2+3+4
        XCTAssertEqual(result["col1"]?[4], 12) // 3+4+5
    }
    
    func test_rollingFunc_WithNilValues() {
        let s1 = DataSeries([1, nil, 3, 4, 5])
        let s2 = DataSeries([5, 6, nil, 8, 9])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingFunc(initial: 0, window: 3) { window in
            let validValues = window.compactMap { $0 }
            return validValues.isEmpty ? nil : validValues.reduce(0, +)
        }
        
        XCTAssertEqual(result["col1"]?[0], 1) // Window not full, but returns actual value
        XCTAssertEqual(result["col1"]?[1], 1) // Window not full, but returns actual sum
        XCTAssertEqual(result["col1"]?[2], 4) // 1+3 (nil ignored)
        XCTAssertEqual(result["col1"]?[3], 7) // 3+4 (nil ignored) - corrected from 8
        XCTAssertEqual(result["col1"]?[4], 12) // 4+5 (nil ignored)
        XCTAssertEqual(result["col2"]?[0], 5)
        XCTAssertEqual(result["col2"]?[1], 11)
        XCTAssertEqual(result["col2"]?[2], 11)
        XCTAssertEqual(result["col2"]?[3], 14)
        XCTAssertEqual(result["col2"]?[4], 17)
    }
    
    // MARK: - rollingSum Tests
    
    func test_rollingSum_WithValidData() {
        let s1 = DataSeries([1, 2, 3, 4, 5])
        let s2 = DataSeries([5, 6, 7, 8, 9])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingSum(window: 3)
        
        XCTAssertNil(result["col1"]?[0]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[1]) // Window not full, returns nil
        XCTAssertEqual(result["col1"]?[2], 6) // 1+2+3
        XCTAssertEqual(result["col1"]?[3], 9) // 2+3+4
        XCTAssertEqual(result["col1"]?[4], 12) // 3+4+5
    }
    
    func test_rollingSum_WithNilValues() {
        let s1 = DataSeries([1, nil, 3, 4, 5])
        let s2 = DataSeries([5, 6, nil, 8, 9])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingSum(window: 3)
        
        XCTAssertNil(result["col1"]?[0]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[1]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[2]) // Window has nil values
        XCTAssertNil(result["col1"]?[3]) // Window has nil values
        XCTAssertEqual(result["col1"]?[4], 12) // Last window has all non-nil values
        XCTAssertNil(result["col2"]?[0]) // Window not full, returns nil
        XCTAssertNil(result["col2"]?[1]) // Window not full, returns nil
        XCTAssertNil(result["col2"]?[2]) // Window has nil values
        XCTAssertNil(result["col2"]?[3]) // Window has nil values
        XCTAssertNil(result["col2"]?[4]) // Window has nil values - corrected from 17
    }
    
    // MARK: - rollingMean Tests
    
    func test_rollingMean_WithValidData() {
        let s1 = DataSeries([1.0, 2.0, 3.0, 4.0, 5.0])
        let s2 = DataSeries([5.0, 6.0, 7.0, 8.0, 9.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingMean(window: 3)
        
        XCTAssertNil(result["col1"]?[0]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[1]) // Window not full, returns nil
        XCTAssertEqual(result["col1"]?[2], 2.0) // (1+2+3)/3
        XCTAssertEqual(result["col1"]?[3], 3.0) // (2+3+4)/3
        XCTAssertEqual(result["col1"]?[4], 4.0) // (3+4+5)/3
    }
    
    func test_rollingMean_WithNilValues() {
        let s1 = DataSeries([1.0, nil, 3.0, 4.0, 5.0])
        let s2 = DataSeries([5.0, 6.0, nil, 8.0, 9.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.rollingMean(window: 3)
        
        XCTAssertNil(result["col1"]?[0]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[1]) // Window not full, returns nil
        XCTAssertNil(result["col1"]?[2]) // Window has nil values
        XCTAssertNil(result["col1"]?[3]) // Window has nil values
        XCTAssertEqual(result["col1"]?[4], 4.0) // Last window has all non-nil values
    }
    
    // MARK: - shape Tests
    
    func test_shape_ReturnsCorrectDimensions() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        let s3 = DataSeries([9, 10, 11, 12])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2), ("col3", s3))
        
        let shape = df.shape()
        
        XCTAssertEqual(shape.width, 3) // 3 columns
        XCTAssertEqual(shape.height, 4) // 4 rows
    }
    
    func test_shape_WithEmptyDataFrame() {
        let df: DataFrame<String, Int> = [:]
        
        let shape = df.shape()
        
        XCTAssertEqual(shape.width, 0)
        XCTAssertEqual(shape.height, 0)
    }
    
    // MARK: - mean Tests
    
    func test_mean_WithValidData() {
        let s1 = DataSeries([1.0, 2.0, 3.0, 4.0])
        let s2 = DataSeries([5.0, 6.0, 7.0, 8.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.mean(shouldSkipNils: true)
        
        XCTAssertEqual(result["col1"]?.count, 1)
        XCTAssertEqual(result["col2"]?.count, 1)
        XCTAssertEqual(result["col1"]?[0], 2.5) // (1+2+3+4)/4
        XCTAssertEqual(result["col2"]?[0], 6.5) // (5+6+7+8)/4
    }
    
    func test_mean_WithNilValues() {
        let s1 = DataSeries([1.0, nil, 3.0, 4.0])
        let s2 = DataSeries([5.0, 6.0, nil, 8.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.mean(shouldSkipNils: true)
        
        XCTAssertEqual(result["col1"]?[0], 2.6666666666666665) // (1+3+4)/3
        XCTAssertEqual(result["col2"]?[0], 6.333333333333333) // (5+6+8)/3
    }
    
    func test_mean_WithNilValuesNotSkipped() {
        let s1 = DataSeries([1.0, nil, 3.0, 4.0])
        let s2 = DataSeries([5.0, 6.0, nil, 8.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.mean(shouldSkipNils: false)
        
        XCTAssertEqual(result["col1"]?[0], 2.0) // (1+0+3+4)/4
        XCTAssertEqual(result["col2"]?[0], 4.75) // (5+6+0+8)/4
    }
    
    // MARK: - std Tests
    
    func test_std_WithValidData() {
        let s1 = DataSeries([1.0, 2.0, 3.0, 4.0])
        let s2 = DataSeries([5.0, 6.0, 7.0, 8.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.std(shouldSkipNils: true)
        
        XCTAssertEqual(result["col1"]?.count, 1)
        XCTAssertEqual(result["col2"]?.count, 1)
        // Expected values calculated manually
        XCTAssertEqual(result["col1"]?[0] ?? 0.0, 1.2909944487358056, accuracy: 0.0001)
        XCTAssertEqual(result["col2"]?[0] ?? 0.0, 1.2909944487358056, accuracy: 0.0001)
    }
    
    func test_std_WithNilValues() {
        let s1 = DataSeries([1.0, nil, 3.0, 4.0])
        let s2 = DataSeries([5.0, 6.0, nil, 8.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.std(shouldSkipNils: true)
        
        // Expected values calculated manually for (1,3,4) and (5,6,8)
        XCTAssertEqual(result["col1"]?[0] ?? 0.0, 1.5275252316519468, accuracy: 0.0001)
        XCTAssertEqual(result["col2"]?[0] ?? 0.0, 1.5275252316519468, accuracy: 0.0001)
    }
    
    func test_std_WithSingleValue() {
        let s1 = DataSeries([1.0])
        let s2 = DataSeries([5.0])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.std(shouldSkipNils: true)
        
        XCTAssertNil(result["col1"]?[0]) // Need at least 2 values for std
        XCTAssertNil(result["col2"]?[0]) // Need at least 2 values for std
    }
} 