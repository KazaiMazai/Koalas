//
//  DataPanelTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class DataPanelTests: XCTestCase {
    
    // MARK: - transposed Tests
    
    func test_transposed_SwapsKeyDimensions() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([7, 8, 9])
        let s4 = DataSeries([10, 11, 12])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let transposed = panel.transposed()
        
        // Check that keys are swapped
        XCTAssertEqual(transposed.keys.count, 2)
        XCTAssertTrue(transposed.keys.contains("col1"))
        XCTAssertTrue(transposed.keys.contains("col2"))
        
        // Check that values are correctly transposed
        XCTAssertEqual(transposed["col1"]?["row1"]?[0], 1)
        XCTAssertEqual(transposed["col1"]?["row2"]?[0], 7)
        XCTAssertEqual(transposed["col2"]?["row1"]?[0], 4)
        XCTAssertEqual(transposed["col2"]?["row2"]?[0], 10)
    }
    
    func test_transposed_WithEmptyPanel() {
        let panel: DataPanel<String, String, Int> = [:]
        
        let transposed = panel.transposed()
        
        XCTAssertEqual(transposed.count, 0)
    }
    
    func test_transposed_WithEmptyDataFrames() {
        let df1: DataFrame<String, Int> = [:]
        let df2: DataFrame<String, Int> = [:]
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let transposed = panel.transposed()
        
        XCTAssertEqual(transposed.count, 0)
    }
    
    // MARK: - flatMapDataFrameValues Tests
    
    func test_flatMapDataFrameValues_TransformsDataSeries() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([7, 8, 9])
        let s4 = DataSeries([10, 11, 12])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let result = panel.flatMapDataFrameValues { series in
            DataSeries(series.map { $0.map { $0 * 2 } })
        }
        
        XCTAssertEqual(result["row1"]?["col1"]?[0], 2)
        XCTAssertEqual(result["row1"]?["col1"]?[1], 4)
        XCTAssertEqual(result["row1"]?["col2"]?[0], 8)
        XCTAssertEqual(result["row2"]?["col1"]?[0], 14)
        XCTAssertEqual(result["row2"]?["col2"]?[0], 20)
    }
    
    func test_flatMapDataFrameValues_HandlesNilValues() {
        let s1 = DataSeries([1, nil, 3])
        let s2 = DataSeries([4, 5, nil])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1
        ]
        
        let result = panel.flatMapDataFrameValues { series in
            DataSeries(series.map { ($0 ?? 0) * 2 })
        }
        
        XCTAssertEqual(result["row1"]?["col1"]?[0], 2)
        XCTAssertEqual(result["row1"]?["col1"]?[1], 0)
        XCTAssertEqual(result["row1"]?["col1"]?[2], 6)
        XCTAssertEqual(result["row1"]?["col2"]?[0], 8)
        XCTAssertEqual(result["row1"]?["col2"]?[1], 10)
        XCTAssertEqual(result["row1"]?["col2"]?[2], 0)
    }
    
    // MARK: - flatMapValues Tests
    
    func test_flatMapValues_TransformsIndividualValues() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1
        ]
        
        let result = panel.flatMapValues { value in
            value.map { $0 * 2 }
        }
        
        XCTAssertEqual(result["row1"]?["col1"]?[0], 2)
        XCTAssertEqual(result["row1"]?["col1"]?[1], 4)
        XCTAssertEqual(result["row1"]?["col1"]?[2], 6)
        XCTAssertEqual(result["row1"]?["col2"]?[0], 8)
        XCTAssertEqual(result["row1"]?["col2"]?[1], 10)
        XCTAssertEqual(result["row1"]?["col2"]?[2], 12)
    }
    
    func test_flatMapValues_HandlesNilValues() {
        let s1 = DataSeries([1, nil, 3])
        let s2 = DataSeries([4, 5, nil])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1
        ]
        
        let result = panel.flatMapValues { value in
            value.map { $0 * 2 }
        }
        
        XCTAssertEqual(result["row1"]?["col1"]?[0], 2)
        XCTAssertNil(result["row1"]?["col1"]?[1])
        XCTAssertEqual(result["row1"]?["col1"]?[2], 6)
        XCTAssertEqual(result["row1"]?["col2"]?[0], 8)
        XCTAssertEqual(result["row1"]?["col2"]?[1], 10)
        XCTAssertNil(result["row1"]?["col2"]?[2])
    }
    
    // MARK: - mapValues Tests
    
    func test_mapValues_WithTwoKeys() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([7, 8, 9])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("col1", s2), ("col2", s3))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let result = panel.mapValues(keys: ("row1", "row2")) { df1, df2 in
            guard let df1 = df1, let df2 = df2 else { return DataFrame() }
            return df1 + df2
        }
        
        XCTAssertEqual(result["col1"]?[0], 5) // 1 + 4
        XCTAssertEqual(result["col1"]?[1], 7) // 2 + 5
        XCTAssertEqual(result["col1"]?[2], 9) // 3 + 6
        XCTAssertEqual(result["col2"]?[0], 11) // 4 + 7
        XCTAssertEqual(result["col2"]?[1], 13) // 5 + 8
        XCTAssertEqual(result["col2"]?[2], 15) // 6 + 9
    }
    
    func test_mapValues_WithNilDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1
        ]
        
        let result = panel.mapValues(keys: ("row1", "nonexistent")) { df1, df2 in
            guard let df1 = df1, let df2 = df2 else { return DataFrame() }
            return df1 + df2
        }
        
        XCTAssertEqual(result.count, 0) // Should return empty DataFrame
    }
    
    // MARK: - shape Tests
    
    func test_shape_ReturnsCorrectDimensions() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([7, 8, 9])
        let s4 = DataSeries([10, 11, 12])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let shape = panel.shape()
        
        XCTAssertEqual(shape.depth, 2) // 2 top-level keys
        XCTAssertEqual(shape.width, 2) // 2 columns in each DataFrame
        XCTAssertEqual(shape.height, 3) // 3 rows in each DataFrame
    }
    
    func test_shape_WithEmptyPanel() {
        let panel: DataPanel<String, String, Int> = [:]
        
        let shape = panel.shape()
        
        XCTAssertEqual(shape.depth, 0)
        XCTAssertEqual(shape.width, 0)
        XCTAssertEqual(shape.height, 0)
    }
    
    func test_shape_WithEmptyDataFrames() {
        let df1: DataFrame<String, Int> = [:]
        let df2: DataFrame<String, Int> = [:]
        
        let panel: DataPanel<String, String, Int> = [
            "row1": df1,
            "row2": df2
        ]
        
        let shape = panel.shape()
        
        XCTAssertEqual(shape.depth, 2)
        XCTAssertEqual(shape.width, 0)
        XCTAssertEqual(shape.height, 0)
    }
} 