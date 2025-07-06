//
//  UtilityTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class UtilityTests: XCTestCase {
    
    // MARK: - UnwrapUtils Tests
    
    func test_unwrap_TwoValues() {
        let result = unwrap(5, 10) { a, b in
            a + b
        }
        
        XCTAssertEqual(result, 15)
    }
    
    func test_unwrap_TwoValuesWithNil() {
        let result = unwrap(5, nil) { a, b in
            a + b
        }
        
        XCTAssertNil(result)
    }
    
    func test_unwrap_TwoValuesBothNil() {
        let result = unwrap(nil as Int?, nil as Int?) { a, b in
            a + b
        }
        
        XCTAssertNil(result)
    }
    
    func test_unwrap_TwoDifferentTypes() {
        let result = unwrap(5, "hello") { a, b in
            "\(a) + \(b)"
        }
        
        XCTAssertEqual(result, "5 + hello")
    }
    
    func test_unwrap_TwoDifferentTypesWithNil() {
        let result = unwrap(5, nil as String?) { a, b in
            "\(a) + \(b)"
        }
        
        XCTAssertNil(result)
    }
    
    func test_unwrap_ThreeValues() {
        let result = unwrap(1, 2, 3) { a, b, c in
            a + b + c
        }
        
        XCTAssertEqual(result, 6)
    }
    
    func test_unwrap_ThreeValuesWithNil() {
        let result = unwrap(1, nil, 3) { a, b, c in
            a + b + c
        }
        
        XCTAssertNil(result)
    }
    
    func test_unwrap_SingleValue() {
        let result = unwrap(value: 5) { a in
            a * 2
        }
        
        XCTAssertEqual(result, 10)
    }
    
    func test_unwrap_SingleValueWithNil() {
        let result = unwrap(value: nil as Int?) { a in
            a * 2
        }
        
        XCTAssertNil(result)
    }
    
    // MARK: - DataSeriesType Tests
    
    func test_toDataSeriesWithShape_WithDataSeries() {
        let referenceSeries = DataSeries([1, 2, 3, 4])
        let dataSeries = DataSeries([10, 20, 30, 40])
        
        let dataSeriesType: DataSeriesType<DataSeries<Int>, Int> = .ds(dataSeries)
        
        let result = dataSeriesType.toDataSeriesWithShape(of: referenceSeries)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0], 10)
        XCTAssertEqual(result?[1], 20)
        XCTAssertEqual(result?[2], 30)
        XCTAssertEqual(result?[3], 40)
    }
    
    func test_toDataSeriesWithShape_WithScalarValue() {
        let referenceSeries = DataSeries([1, 2, 3, 4])
        let scalarValue = 100
        
        let dataSeriesType: DataSeriesType<DataSeries<Int>, Int> = .value(scalarValue)
        
        let result = dataSeriesType.toDataSeriesWithShape(of: referenceSeries)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0], 100)
        XCTAssertEqual(result?[1], 100)
        XCTAssertEqual(result?[2], 100)
        XCTAssertEqual(result?[3], 100)
    }
    
    func test_toDataSeriesWithShape_WithNilDataSeries() {
        let referenceSeries = DataSeries([1, 2, 3, 4])
        
        let dataSeriesType: DataSeriesType<DataSeries<Int>, Int> = .ds(nil)
        
        let result = dataSeriesType.toDataSeriesWithShape(of: referenceSeries)
        
        XCTAssertNil(result)
    }
    
    func test_toDataSeriesWithShape_WithNilScalarValue() {
        let referenceSeries = DataSeries([1, 2, 3, 4])
        
        let dataSeriesType: DataSeriesType<DataSeries<Int>, Int> = .value(nil)
        
        let result = dataSeriesType.toDataSeriesWithShape(of: referenceSeries)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?[0], nil)
        XCTAssertEqual(result?[1], nil)
        XCTAssertEqual(result?[2], nil)
        XCTAssertEqual(result?[3], nil)
    }
    
    // MARK: - DataFrameType Tests
    
    func test_toDataframeWithShape_WithDataFrame() {
        let referenceDataFrame = DataFrame(dictionaryLiteral: 
            ("col1", DataSeries([1, 2, 3])),
            ("col2", DataSeries([4, 5, 6]))
        )
        
        let dataFrame = DataFrame(dictionaryLiteral:
            ("col1", DataSeries([10, 20, 30])),
            ("col2", DataSeries([40, 50, 60]))
        )
        
        let dataFrameType: DataFrameType<DataFrame<String, Int>, Int> = .df(dataFrame)
        
        let result = dataFrameType.toDataframeWithShape(of: referenceDataFrame)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?.count, 3)
        XCTAssertEqual(result?["col2"]?.count, 3)
        XCTAssertEqual(result?["col1"]?[0], 10)
        XCTAssertEqual(result?["col2"]?[0], 40)
    }
    
    func test_toDataframeWithShape_WithScalarValue() {
        let referenceDataFrame = DataFrame(dictionaryLiteral: 
            ("col1", DataSeries([1, 2, 3])),
            ("col2", DataSeries([4, 5, 6]))
        )
        
        let scalarValue = 100
        
        let dataFrameType: DataFrameType<DataFrame<String, Int>, Int> = .value(scalarValue)
        
        let result = dataFrameType.toDataframeWithShape(of: referenceDataFrame)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?.count, 3)
        XCTAssertEqual(result?["col2"]?.count, 3)
        XCTAssertEqual(result?["col1"]?[0], 100)
        XCTAssertEqual(result?["col1"]?[1], 100)
        XCTAssertEqual(result?["col1"]?[2], 100)
        XCTAssertEqual(result?["col2"]?[0], 100)
        XCTAssertEqual(result?["col2"]?[1], 100)
        XCTAssertEqual(result?["col2"]?[2], 100)
    }
    
    func test_toDataframeWithShape_WithNilDataFrame() {
        let referenceDataFrame = DataFrame(dictionaryLiteral: 
            ("col1", DataSeries([1, 2, 3])),
            ("col2", DataSeries([4, 5, 6]))
        )
        
        let dataFrameType: DataFrameType<DataFrame<String, Int>, Int> = .df(nil)
        
        let result = dataFrameType.toDataframeWithShape(of: referenceDataFrame)
        
        XCTAssertNil(result)
    }
    
    func test_toDataframeWithShape_WithNilScalarValue() {
        let referenceDataFrame = DataFrame(dictionaryLiteral: 
            ("col1", DataSeries([1, 2, 3])),
            ("col2", DataSeries([4, 5, 6]))
        )
        
        let dataFrameType: DataFrameType<DataFrame<String, Int>, Int> = .value(nil)
        
        let result = dataFrameType.toDataframeWithShape(of: referenceDataFrame)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?["col1"]?.count, 3)
        XCTAssertEqual(result?["col2"]?.count, 3)
        XCTAssertEqual(result?["col1"]?[0], nil)
        XCTAssertEqual(result?["col1"]?[1], nil)
        XCTAssertEqual(result?["col1"]?[2], nil)
        XCTAssertEqual(result?["col2"]?[0], nil)
        XCTAssertEqual(result?["col2"]?[1], nil)
        XCTAssertEqual(result?["col2"]?[2], nil)
    }
    
    // MARK: - Tuple Tests
    
    func test_Tuple2_Initialization() {
        let tuple = Tuple2(t1: 1, t2: "hello")
        
        XCTAssertEqual(tuple.t1, 1)
        XCTAssertEqual(tuple.t2, "hello")
    }
    
    func test_Tuple3_Initialization() {
        let tuple = Tuple3(t1: 1, t2: "hello", t3: 3.14)
        
        XCTAssertEqual(tuple.t1, 1)
        XCTAssertEqual(tuple.t2, "hello")
        XCTAssertEqual(tuple.t3, 3.14)
    }
    
    func test_Tuple4_Initialization() {
        let tuple = Tuple4(t1: 1, t2: "hello", t3: 3.14, t4: true)
        
        XCTAssertEqual(tuple.t1, 1)
        XCTAssertEqual(tuple.t2, "hello")
        XCTAssertEqual(tuple.t3, 3.14)
        XCTAssertEqual(tuple.t4, true)
    }
    
    func test_Tuple_Codable() {
        let tuple = Tuple2(t1: 1, t2: "hello")
        
        // Test that it can be encoded and decoded
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(tuple)
            let decoded = try decoder.decode(Tuple2<Int, String>.self, from: data)
            
            XCTAssertEqual(decoded.t1, 1)
            XCTAssertEqual(decoded.t2, "hello")
        } catch {
            XCTFail("Failed to encode/decode tuple: \(error)")
        }
    }
    
    // MARK: - FillNilsMethod Tests
    
    func test_FillNilsMethod_All() {
        let method = FillNilsMethod.all(value: 0)
        
        if case .all(let value) = method {
            XCTAssertEqual(value, 0)
        } else {
            XCTFail("Expected .all case")
        }
    }
    
    func test_FillNilsMethod_Backward() {
        let method = FillNilsMethod.backward(initial: 10)
        
        if case .backward(let initial) = method {
            XCTAssertEqual(initial, 10)
        } else {
            XCTFail("Expected .backward case")
        }
    }
    
    func test_FillNilsMethod_Forward() {
        let method = FillNilsMethod.forward(initial: 20)
        
        if case .forward(let initial) = method {
            XCTAssertEqual(initial, 20)
        } else {
            XCTFail("Expected .forward case")
        }
    }
    
    // MARK: - DateComponentsKeys Tests
    
    func test_DateComponentsKeys_Values() {
        XCTAssertEqual(DateComponentsKeys.year.rawValue, "year")
        XCTAssertEqual(DateComponentsKeys.month.rawValue, "month")
        XCTAssertEqual(DateComponentsKeys.day.rawValue, "day")
    }
    
    // MARK: - SeriesArray Core Function Tests
    
    func test_SeriesArray_IndexAfter() {
        let array = SeriesArray([1, 2, 3, 4, 5])
        
        XCTAssertEqual(array.index(after: 0), 1)
        XCTAssertEqual(array.index(after: 2), 3)
        XCTAssertEqual(array.index(after: 4), 5)
    }
    
    func test_SeriesArray_Append() {
        var array = SeriesArray([1, 2, 3])
        
        array.append(4)
        
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(array[3], 4)
    }
    
    func test_SeriesArray_AppendContentsOf() {
        var array = SeriesArray([1, 2, 3])
        
        array.append(contentsOf: [4, 5, 6])
        
        XCTAssertEqual(array.count, 6)
        XCTAssertEqual(array[3], 4)
        XCTAssertEqual(array[4], 5)
        XCTAssertEqual(array[5], 6)
    }
    
    func test_SeriesArray_Filter() {
        let array = SeriesArray([1, 2, 3, 4, 5, 6])
        
        let filtered = array.filter { $0 % 2 == 0 }
        
        XCTAssertEqual(filtered.count, 3)
        XCTAssertEqual(filtered[0], 2)
        XCTAssertEqual(filtered[1], 4)
        XCTAssertEqual(filtered[2], 6)
    }
    
    func test_SeriesArray_Insert() {
        var array = SeriesArray([1, 2, 3])
        
        array.insert(10, at: 1)
        
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 10)
        XCTAssertEqual(array[2], 2)
        XCTAssertEqual(array[3], 3)
    }
    
    func test_SeriesArray_InsertContentsOf() {
        var array = SeriesArray([1, 2, 3])
        
        array.insert(contentsOf: [10, 20], at: 1)
        
        XCTAssertEqual(array.count, 5)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 10)
        XCTAssertEqual(array[2], 20)
        XCTAssertEqual(array[3], 2)
        XCTAssertEqual(array[4], 3)
    }
    
    func test_SeriesArray_PopLast() {
        var array = SeriesArray([1, 2, 3])
        
        let last = array.popLast()
        
        XCTAssertEqual(last, 3)
        XCTAssertEqual(array.count, 2)
    }
    
    func test_SeriesArray_RemoveAt() {
        var array = SeriesArray([1, 2, 3, 4])
        
        let removed = array.remove(at: 1)
        
        XCTAssertEqual(removed, 2)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 3)
        XCTAssertEqual(array[2], 4)
    }
    
    func test_SeriesArray_RemoveAll() {
        var array = SeriesArray([1, 2, 3, 4])
        
        array.removeAll(keepingCapacity: false)
        
        XCTAssertEqual(array.count, 0)
    }
    
    func test_SeriesArray_RemoveAllWhere() {
        var array = SeriesArray([1, 2, 3, 4, 5, 6])
        
        array.removeAll { $0 % 2 == 0 }
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 3)
        XCTAssertEqual(array[2], 5)
    }
    
    func test_SeriesArray_RemoveFirst() {
        var array = SeriesArray([1, 2, 3, 4])
        
        let first = array.removeFirst()
        
        XCTAssertEqual(first, 1)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 2)
    }
    
    func test_SeriesArray_RemoveFirstK() {
        var array = SeriesArray([1, 2, 3, 4, 5])
        
        array.removeFirst(2)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 3)
        XCTAssertEqual(array[1], 4)
        XCTAssertEqual(array[2], 5)
    }
    
    func test_SeriesArray_RemoveLast() {
        var array = SeriesArray([1, 2, 3, 4])
        
        let last = array.removeLast()
        
        XCTAssertEqual(last, 4)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[2], 3)
    }
    
    func test_SeriesArray_RemoveLastK() {
        var array = SeriesArray([1, 2, 3, 4, 5])
        
        array.removeLast(2)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 2)
        XCTAssertEqual(array[2], 3)
    }
    
    func test_SeriesArray_RemoveSubrange() {
        var array = SeriesArray([1, 2, 3, 4, 5])
        
        array.removeSubrange(1..<4)
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 5)
    }
    
    func test_SeriesArray_ReplaceSubrange() {
        var array = SeriesArray([1, 2, 3, 4, 5])
        
        array.replaceSubrange(1..<4, with: [10, 20, 30])
        
        XCTAssertEqual(array.count, 5)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 10)
        XCTAssertEqual(array[2], 20)
        XCTAssertEqual(array[3], 30)
        XCTAssertEqual(array[4], 5)
    }
    
    func test_SeriesArray_ReserveCapacity() {
        var array = SeriesArray([1, 2, 3])
        
        array.reserveCapacity(100)
        
        // Capacity is implementation detail, but we can test it doesn't crash
        XCTAssertEqual(array.count, 3)
    }
    
    func test_SeriesArray_SubscriptRange() {
        let array = SeriesArray([1, 2, 3, 4, 5])
        
        let subArray = array[1..<4]
        
        XCTAssertEqual(subArray.count, 3)
        XCTAssertEqual(subArray[0], 2)
        XCTAssertEqual(subArray[1], 3)
        XCTAssertEqual(subArray[2], 4)
    }
    
    func test_SeriesArray_SubscriptSingle() {
        var array = SeriesArray([1, 2, 3, 4, 5])
        
        XCTAssertEqual(array[2], 3)
        
        array[2] = 100
        
        XCTAssertEqual(array[2], 100)
    }
    
    func test_SeriesArray_Description() {
        let array = SeriesArray([1, 2, 3])
        
        XCTAssertEqual(array.description, "[1, 2, 3]")
    }
} 