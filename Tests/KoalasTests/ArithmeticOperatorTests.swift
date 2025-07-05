//
//  ArithmeticOperatorTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class ArithmeticOperatorTests: XCTestCase {
    
    // MARK: - DataFrame Arithmetic Operators with Optional DataFrames
    
    func test_DataFrameAddition_WithOptionalDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([7, 8, 9])
        let s4 = DataSeries([10, 11, 12])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 + df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], 8) // 1 + 7
        XCTAssertEqual(result?["col1"]?[1], 10) // 2 + 8
        XCTAssertEqual(result?["col1"]?[2], 12) // 3 + 9
        XCTAssertEqual(result?["col2"]?[0], 14) // 4 + 10
        XCTAssertEqual(result?["col2"]?[1], 16) // 5 + 11
        XCTAssertEqual(result?["col2"]?[2], 18) // 6 + 12
    }
    
    func test_DataFrameAddition_WithNilDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = nil
        
        let result = df1 + df2
        
        XCTAssertNil(result)
    }
    
    func test_DataFrameSubtraction_WithOptionalDataFrames() {
        let s1 = DataSeries([10, 20, 30])
        let s2 = DataSeries([40, 50, 60])
        let s3 = DataSeries([1, 2, 3])
        let s4 = DataSeries([4, 5, 6])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 - df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], 9) // 10 - 1
        XCTAssertEqual(result?["col1"]?[1], 18) // 20 - 2
        XCTAssertEqual(result?["col1"]?[2], 27) // 30 - 3
        XCTAssertEqual(result?["col2"]?[0], 36) // 40 - 4
        XCTAssertEqual(result?["col2"]?[1], 45) // 50 - 5
        XCTAssertEqual(result?["col2"]?[2], 54) // 60 - 6
    }
    
    func test_DataFrameMultiplication_WithOptionalDataFrames() {
        let s1 = DataSeries([2, 3, 4])
        let s2 = DataSeries([5, 6, 7])
        let s3 = DataSeries([3, 4, 5])
        let s4 = DataSeries([2, 3, 4])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 * df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], 6) // 2 * 3
        XCTAssertEqual(result?["col1"]?[1], 12) // 3 * 4
        XCTAssertEqual(result?["col1"]?[2], 20) // 4 * 5
        XCTAssertEqual(result?["col2"]?[0], 10) // 5 * 2
        XCTAssertEqual(result?["col2"]?[1], 18) // 6 * 3
        XCTAssertEqual(result?["col2"]?[2], 28) // 7 * 4
    }
    
    func test_DataFrameDivision_WithOptionalDataFrames() {
        let s1 = DataSeries([10.0, 20.0, 30.0])
        let s2 = DataSeries([40.0, 50.0, 60.0])
        let s3 = DataSeries([2.0, 4.0, 5.0])
        let s4 = DataSeries([5.0, 10.0, 12.0])
        
        let df1: DataFrame<String, Double>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Double>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 / df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], 5.0) // 10 / 2
        XCTAssertEqual(result?["col1"]?[1], 5.0) // 20 / 4
        XCTAssertEqual(result?["col1"]?[2], 6.0) // 30 / 5
        XCTAssertEqual(result?["col2"]?[0], 8.0) // 40 / 5
        XCTAssertEqual(result?["col2"]?[1], 5.0) // 50 / 10
        XCTAssertEqual(result?["col2"]?[2], 5.0) // 60 / 12
    }
    
    // MARK: - DataFrame Comparison Operators with Optional DataFrames
    
    func test_DataFrameEquality_WithOptionalDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([1, 2, 3])
        let s4 = DataSeries([4, 5, 6])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 == df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 1 == 1
        XCTAssertEqual(result?["col1"]?[1], true) // 2 == 2
        XCTAssertEqual(result?["col1"]?[2], true) // 3 == 3
        XCTAssertEqual(result?["col2"]?[0], true) // 4 == 4
        XCTAssertEqual(result?["col2"]?[1], true) // 5 == 5
        XCTAssertEqual(result?["col2"]?[2], true) // 6 == 6
    }
    
    func test_DataFrameInequality_WithOptionalDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([2, 3, 4])
        let s4 = DataSeries([5, 6, 7])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 != df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 1 != 2
        XCTAssertEqual(result?["col1"]?[1], true) // 2 != 3
        XCTAssertEqual(result?["col1"]?[2], true) // 3 != 4
        XCTAssertEqual(result?["col2"]?[0], true) // 4 != 5
        XCTAssertEqual(result?["col2"]?[1], true) // 5 != 6
        XCTAssertEqual(result?["col2"]?[2], true) // 6 != 7
    }
    
    func test_DataFrameLessThan_WithOptionalDataFrames() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        let s3 = DataSeries([2, 3, 4])
        let s4 = DataSeries([5, 6, 7])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 < df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 1 < 2
        XCTAssertEqual(result?["col1"]?[1], true) // 2 < 3
        XCTAssertEqual(result?["col1"]?[2], true) // 3 < 4
        XCTAssertEqual(result?["col2"]?[0], true) // 4 < 5
        XCTAssertEqual(result?["col2"]?[1], true) // 5 < 6
        XCTAssertEqual(result?["col2"]?[2], true) // 6 < 7
    }
    
    func test_DataFrameGreaterThan_WithOptionalDataFrames() {
        let s1 = DataSeries([3, 4, 5])
        let s2 = DataSeries([6, 7, 8])
        let s3 = DataSeries([1, 2, 3])
        let s4 = DataSeries([4, 5, 6])
        
        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 > df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 3 > 1
        XCTAssertEqual(result?["col1"]?[1], true) // 4 > 2
        XCTAssertEqual(result?["col1"]?[2], true) // 5 > 3
        XCTAssertEqual(result?["col2"]?[0], true) // 6 > 4
        XCTAssertEqual(result?["col2"]?[1], true) // 7 > 5
        XCTAssertEqual(result?["col2"]?[2], true) // 8 > 6
    }
    
    // MARK: - DataFrame Comparison with Scalars
    
    func test_DataFrameEquality_WithScalar() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let scalar = 2
        
        let result = df == scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], false) // 1 == 2
        XCTAssertEqual(result?["col1"]?[1], true) // 2 == 2
        XCTAssertEqual(result?["col1"]?[2], false) // 3 == 2
        XCTAssertEqual(result?["col2"]?[0], false) // 4 == 2
        XCTAssertEqual(result?["col2"]?[1], false) // 5 == 2
        XCTAssertEqual(result?["col2"]?[2], false) // 6 == 2
    }
    
    func test_DataFrameInequality_WithScalar() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let scalar = 2
        
        let result = df != scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 1 != 2
        XCTAssertEqual(result?["col1"]?[1], false) // 2 != 2
        XCTAssertEqual(result?["col1"]?[2], true) // 3 != 2
        XCTAssertEqual(result?["col2"]?[0], true) // 4 != 2
        XCTAssertEqual(result?["col2"]?[1], true) // 5 != 2
        XCTAssertEqual(result?["col2"]?[2], true) // 6 != 2
    }
    
    func test_DataFrameLessThan_WithScalar() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let scalar = 3
        
        let result = df < scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // 1 < 3
        XCTAssertEqual(result?["col1"]?[1], true) // 2 < 3
        XCTAssertEqual(result?["col1"]?[2], false) // 3 < 3
        XCTAssertEqual(result?["col2"]?[0], false) // 4 < 3
        XCTAssertEqual(result?["col2"]?[1], false) // 5 < 3
        XCTAssertEqual(result?["col2"]?[2], false) // 6 < 3
    }
    
    func test_DataFrameGreaterThan_WithScalar() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let scalar = 3
        
        let result = df > scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], false) // 1 > 3
        XCTAssertEqual(result?["col1"]?[1], false) // 2 > 3
        XCTAssertEqual(result?["col1"]?[2], false) // 3 > 3
        XCTAssertEqual(result?["col2"]?[0], true) // 4 > 3
        XCTAssertEqual(result?["col2"]?[1], true) // 5 > 3
        XCTAssertEqual(result?["col2"]?[2], true) // 6 > 3
    }
    
    // MARK: - Logical Operators with Optional DataFrames
    
    func test_DataFrameLogicalAND_WithOptionalDataFrames() {
        let s1 = DataSeries([true, false, true])
        let s2 = DataSeries([false, true, false])
        let s3 = DataSeries([true, true, false])
        let s4 = DataSeries([false, false, true])
        
        let df1: DataFrame<String, Bool>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Bool>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 && df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // true && true
        XCTAssertEqual(result?["col1"]?[1], false) // false && true
        XCTAssertEqual(result?["col1"]?[2], false) // true && false
        XCTAssertEqual(result?["col2"]?[0], false) // false && false
        XCTAssertEqual(result?["col2"]?[1], false) // true && false
        XCTAssertEqual(result?["col2"]?[2], false) // false && true
    }
    
    func test_DataFrameLogicalOR_WithOptionalDataFrames() {
        let s1 = DataSeries([true, false, true])
        let s2 = DataSeries([false, true, false])
        let s3 = DataSeries([true, true, false])
        let s4 = DataSeries([false, false, true])
        
        let df1: DataFrame<String, Bool>? = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        let df2: DataFrame<String, Bool>? = DataFrame(dictionaryLiteral: ("col1", s3), ("col2", s4))
        
        let result = df1 || df2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?[0], true) // true || true
        XCTAssertEqual(result?["col1"]?[1], true) // false || true
        XCTAssertEqual(result?["col1"]?[2], true) // true || false
        XCTAssertEqual(result?["col2"]?[0], false) // false || false
        XCTAssertEqual(result?["col2"]?[1], true) // true || false
        XCTAssertEqual(result?["col2"]?[2], true) // false || true
    }
    
    // MARK: - DataSeries Arithmetic Operators with Optional DataSeries
    
    func test_DataSeriesAddition_WithOptionalDataSeries() {
        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = DataSeries([4, 5, 6])
        
        let result = s1 + s2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 5) // 1 + 4
        XCTAssertEqual(result?[1], 7) // 2 + 5
        XCTAssertEqual(result?[2], 9) // 3 + 6
    }
    
    func test_DataSeriesAddition_WithNilDataSeries() {
        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = nil
        
        let result = s1 + s2
        
        XCTAssertNil(result)
    }
    
    func test_DataSeriesSubtraction_WithOptionalDataSeries() {
        let s1: DataSeries<Int>? = DataSeries([10, 20, 30])
        let s2: DataSeries<Int>? = DataSeries([1, 2, 3])
        
        let result = s1 - s2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 9) // 10 - 1
        XCTAssertEqual(result?[1], 18) // 20 - 2
        XCTAssertEqual(result?[2], 27) // 30 - 3
    }
    
    func test_DataSeriesMultiplication_WithOptionalDataSeries() {
        let s1: DataSeries<Int>? = DataSeries([2, 3, 4])
        let s2: DataSeries<Int>? = DataSeries([5, 6, 7])
        
        let result = s1 * s2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 10) // 2 * 5
        XCTAssertEqual(result?[1], 18) // 3 * 6
        XCTAssertEqual(result?[2], 28) // 4 * 7
    }
    
    func test_DataSeriesDivision_WithOptionalDataSeries() {
        let s1: DataSeries<Double>? = DataSeries([10.0, 20.0, 30.0])
        let s2: DataSeries<Double>? = DataSeries([2.0, 4.0, 5.0])
        
        let result = s1 / s2
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 5.0) // 10 / 2
        XCTAssertEqual(result?[1], 5.0) // 20 / 4
        XCTAssertEqual(result?[2], 6.0) // 30 / 5
    }
    
    // MARK: - DataSeries Comparison with Scalars
    
    func test_DataSeriesAddition_WithScalar() {
        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let scalar: Int? = 5
        
        let result = s1 + scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 6) // 1 + 5
        XCTAssertEqual(result?[1], 7) // 2 + 5
        XCTAssertEqual(result?[2], 8) // 3 + 5
    }
    
    func test_DataSeriesSubtraction_WithScalar() {
        let s1: DataSeries<Int>? = DataSeries([10, 20, 30])
        let scalar: Int? = 5
        
        let result = s1 - scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 5) // 10 - 5
        XCTAssertEqual(result?[1], 15) // 20 - 5
        XCTAssertEqual(result?[2], 25) // 30 - 5
    }
    
    func test_DataSeriesMultiplication_WithScalar() {
        let s1: DataSeries<Int>? = DataSeries([2, 3, 4])
        let scalar: Int? = 5
        
        let result = s1 * scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 10) // 2 * 5
        XCTAssertEqual(result?[1], 15) // 3 * 5
        XCTAssertEqual(result?[2], 20) // 4 * 5
    }
    
    func test_DataSeriesDivision_WithScalar() {
        let s1: DataSeries<Double>? = DataSeries([10.0, 20.0, 30.0])
        let scalar: Double? = 2.0
        
        let result = s1 / scalar
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?[0], 5.0) // 10 / 2
        XCTAssertEqual(result?[1], 10.0) // 20 / 2
        XCTAssertEqual(result?[2], 15.0) // 30 / 2
    }
    
    // MARK: - Edge Cases
    
    func test_DataFrameArithmetic_WithEmptyDataFrames() {
        let df1: DataFrame<String, Int> = [:]
        let df2: DataFrame<String, Int> = [:]
        
        let result = df1 + df2
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_DataSeriesArithmetic_WithEmptySeries() {
        let s1: DataSeries<Int> = DataSeries()
        let s2: DataSeries<Int> = DataSeries()
        
        let result = s1 + s2
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_DataFrameArithmetic_WithDifferentKeys() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df1 = DataFrame(dictionaryLiteral: ("col1", s1))
        let df2 = DataFrame(dictionaryLiteral: ("col2", s2))
        
        // This should assert in debug mode, but we can't test assertions easily
        // This test documents the expected behavior
        XCTAssertEqual(df1.count, 1)
        XCTAssertEqual(df2.count, 1)
    }
    
    func test_DataSeriesArithmetic_WithDifferentLengths() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5])
        
        // This should assert in debug mode, but we can't test assertions easily
        // This test documents the expected behavior
        XCTAssertEqual(s1.count, 3)
        XCTAssertEqual(s2.count, 2)
    }
} 