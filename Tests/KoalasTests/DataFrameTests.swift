//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06.06.2020.
//

import XCTest
@testable import Koalas

final class DataFrameTests: XCTestCase {
    func test_whenMapToContant_equalLengthsAndValueMatch() {
        let first: Int = 1
        let last: Int = 20

        let constant = 1
        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = df1.mapTo(constant: constant)

        df2.forEach {
            XCTAssertEqual($0.value.count, s1.count)

            $0.value.forEach {
                XCTAssertEqual($0, constant)
            }
        }
    }

    func test_whenDFKeysAndSeriesEqual_MemberwiseSum() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let df3 = df1 + df2

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! + s1[$0.offset]!)  }
        }
    }

    func test_whenDFKeysAndSeriesEqual_MemberwiseProd() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let df3 = df1 * df2

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! * s1[$0.offset]!)  }
        }
    }

    func test_whenDFKeysAndSeriesEqual_MemberwiseDiff() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2), ("2", s2))

        let df3 = df1 - df2

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, s1[$0.offset]! - s2[$0.offset]!)  }
        }
    }

    func test_whenDFKeysAndSeriesEqual_MemberwiseDivision() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2), ("2", s2))

        let df3 = df1 / df2

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, s1[$0.offset]! / s2[$0.offset]!)  }
        }
    }

    func test_whenDFContainsNoNils_sum() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let sum = df1.sum(ignoreNils: true)

        sum.forEach { XCTAssertEqual($0.value.count, 1) }

        sum.forEach {
            XCTAssertEqual($0.value[0], df1[$0.key]?.map { $0 ?? 0 }.reduce(0, +))
        }
    }

    func test_whenDFContainsNils_sumWithIgnoreNils() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        var s2 = DataSeries(arr)
        s2.append(nil)
        s1.append(nil)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let sum = df1.sum(ignoreNils: true)

        sum.forEach { XCTAssertEqual($0.value.count, 1) }

        sum.forEach {
            XCTAssertEqual($0.value[0], df1[$0.key]?.map { $0 ?? 0 }.reduce(0, +))
        }
    }

    func test_whenDFContainsNils_sumNotIgnoreNils() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        var s2 = DataSeries(arr)
        s2.append(nil)
        s1.append(nil)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))


        let sum = df1.sum(ignoreNils: false)


        sum.forEach { XCTAssertEqual($0.value.count, 1) }

        sum.forEach {
            XCTAssertNil($0.value[0])
        }
    }

    func test_whenDFContainsNoNils_columnSum() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let sum = df1.columnSum(ignoreNils: true) ?? DataSeries()

        XCTAssertEqual(sum.count, s1.count)

        sum.enumerated().forEach { res in
            XCTAssertEqual(res.element, df1.values.map { v in v[res.offset] ?? 0 }.reduce(0, +))
        }
    }

    func test_whenDFContainsNils_columnSumWithIgnore() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        var s2 = DataSeries(arr)
        s1.append(1)
        s2.append(nil)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let sum = df1.columnSum(ignoreNils: true) ?? DataSeries()

        XCTAssertEqual(sum.count, s1.count)

        sum.enumerated().forEach { res in
            XCTAssertEqual(res.element, df1.values.map { v in v[res.offset] ?? 0 }.reduce(0, +))
        }
    }

    func test_whenDFContainsNils_columnSumNoIgnoreEqualNil() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        var s2 = DataSeries(arr)
        s1.append(1)
        s2.append(nil)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let sum = df1.columnSum(ignoreNils: false) ?? DataSeries()

        XCTAssertEqual(sum.count, s1.count)
        for idx in 0..<sum.count-1 {
            XCTAssertEqual(sum[idx], df1.values.map { v in v[idx] ?? 0 }.reduce(0, +))
        }

        XCTAssertNil(sum[sum.count-1])
    }

    func test_expandingSum() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let df3 = df1.expandingSum(initial: 0)

        let seriesExpandingSum = s1.expandingSum(initial: 0)

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, seriesExpandingSum[$0.offset]!)  }
        }
    }

    func test_expandingMax() {
        let s1 = DataSeries([nil, nil, 2, 3 ,1 ,0 ,1, 4, 3])

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let result = df1.expandingMax()

        let expectedResultSeries = DataSeries([nil, nil, 2, 3 ,3 ,3 ,3, 4, 4])

        let expectedResult = DataFrame(dictionaryLiteral: ("1", expectedResultSeries),
                                       ("2", expectedResultSeries))

        XCTAssertTrue(result.equalsTo(dataframe: expectedResult))
    }

    func test_expandingMin() {
        let s1 = DataSeries([nil, nil, 2, 3 ,1 ,0 ,1, 4, 3])

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let result = df1.expandingMin()

        let expectedResultSeries = DataSeries([nil, nil, 2, 2 ,1 ,0 ,0, 0, 0])

        let expectedResult = DataFrame(dictionaryLiteral: ("1", expectedResultSeries),
                                       ("2", expectedResultSeries))

        XCTAssertTrue(result.equalsTo(dataframe: expectedResult))
    }

    func test_scanFunc() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s1))
        let df3 = df1.scan(initial: 0) { ($0 ?? 0) + ($1 ?? 0) }

        let seriesExpandingSum = s1.expandingSum(initial: 0)

        df3.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df3.forEach {
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, seriesExpandingSum[$0.offset]!)  }
        }
    }

    func test_forwardFillNils() {
        let initial = 10

        let arr1 = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr1 = [1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5]

        let arr2 = [nil, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr2 = [initial, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5]

        let s1 = DataSeries(arr1)
        let s2 = DataSeries(arr2)

        let expectedS1 = DataSeries(expectedArr1)
        let expectedS2 = DataSeries(expectedArr2)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", expectedS1), ("2", expectedS2))
        let df3 = df1.fillNils(method: .forward(initial: initial))

        df3.forEach { kv in zip(df2[kv.key]!, kv.value).forEach { XCTAssertEqual($0.0, $0.1) } }
    }

    func test_backwardFillNils() {
        let initial = 10

        let arr1 = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr1 = [1, 2, 3, 3, 4, 4, 5, 5, initial, initial, initial]

        let arr2 = [nil, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr2 = [2, 2, 3, 3, 4, 4, 5, 5, initial, initial, initial]

        let s1 = DataSeries(arr1)
        let s2 = DataSeries(arr2)
        
        let expectedS1 = DataSeries(expectedArr1)
        let expectedS2 = DataSeries(expectedArr2)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", expectedS1), ("2", expectedS2))
        let df3 = df1.fillNils(method: .backward(initial: initial))

        df3.forEach { kv in zip(df2[kv.key]!, kv.value).forEach { XCTAssertEqual($0.0, $0.1) } }
    }

    func test_whenDFWithoutNilsWriteToCSV_thenReadEqualDF() throws {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test").appendingPathExtension("csv")

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        try df1.write(toFile: fileURL.path, columnSeparator: ";")

        let df2 = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ";")
        df2.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df1.forEach {
            let series = df2[$0.key]
            $0.value.enumerated().forEach { XCTAssertEqual($0.element!, series?[$0.offset])  }
        }

        try fileManager.removeItem(at: fileURL)
    }

    func test_whenDFWithNilsWriteToCSV_thenReadEqualDF() throws {
        
        let arr = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test").appendingPathExtension("csv")

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        try df1.write(toFile: fileURL.path, columnSeparator: ";")

        let df2 = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ";")
        df2.forEach { XCTAssertEqual($0.value.count, s1.count) }
        df1.forEach {
            let series = df2[$0.key]
            $0.value.enumerated().forEach { XCTAssertEqual($0.element, series?[$0.offset])  }
        }

        try fileManager.removeItem(at: fileURL)
    }

    func test_toDateComponents() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        let years = [2011, 2019, 2020]
        let months = [1, 2, 3]
        let days = [3, 4, 5]

        let s1 = DataSeries([
            dateFormatter.date(from: "\(years[0])/\(months[0])/\(days[0])"),
            dateFormatter.date(from: "\(years[1])/\(months[1])/\(days[1])"),
            dateFormatter.date(from: "\(years[2])/\(months[2])/\(days[2])")
        ])

        let s2 = DataSeries(s1.reversed())

        let df = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        let yearDF = DataFrame<String, Int>(uniqueKeysWithValues: [
            ("1", DataSeries(years)),
            ("2", DataSeries(years.reversed()))
        ])

        let monthDF = DataFrame<String, Int>(uniqueKeysWithValues: [
            ("1", DataSeries(months)),
            ("2", DataSeries(months.reversed()))
        ])

        let dayDF = DataFrame<String, Int>(uniqueKeysWithValues: [
            ("1", DataSeries(days)),
            ("2", DataSeries(days.reversed()))
        ])

        let dateComponentsPanel = df.toDateComponents()

        yearDF.forEach { key, value in
            XCTAssertEqual(dateComponentsPanel[.year]?[key]?.count, value.count)

            value.enumerated().forEach {
                XCTAssertEqual($0.element, dateComponentsPanel[.year]?[key]?[$0.offset])
            }
        }

        monthDF.forEach { key, value in
            XCTAssertEqual(dateComponentsPanel[.month]?[key]?.count, value.count)

            value.enumerated().forEach {
                XCTAssertEqual($0.element, dateComponentsPanel[.month]?[key]?[$0.offset])
            }
        }

        dayDF.forEach { key, value in
            XCTAssertEqual(dateComponentsPanel[.day]?[key]?.count, value.count)

            value.enumerated().forEach {
                XCTAssertEqual($0.element, dateComponentsPanel[.day]?[key]?[$0.offset])
            }
        }
    }

    func test_whenDFIntEqual_equalToReturnsTrue() {

        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        XCTAssertTrue(df1.equalsTo(dataframe: df2))
    }

    func test_whenDFEqual_equalToReturnsTrue() {

        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))

        XCTAssertTrue(df1.equalsTo(dataframe: df2, with: 0.000001))
    }

    func test_whenDFNotEqual_equalsToReturnsFalse() {

        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2), ("2", s2))

        XCTAssertFalse(df1.equalsTo(dataframe: df2))
    }

    func test_whenDFNotEqualKeys_equalsToReturnsFalse() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let df1 = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2 = DataFrame(dictionaryLiteral: ("1", s2))

        XCTAssertFalse(df1.equalsTo(dataframe: df2))
    }

    func test_strictCompare() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let expectedResult = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, false, false])),
                                       ("2", DataSeries([false, false, true])))

        XCTAssertTrue(expectedResult.equalsTo(dataframe: df1 < df2))
        XCTAssertTrue(expectedResult.equalsTo(dataframe: df2 > df1))
    }

    func test_nonStrictCompare() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let expectedResult = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, true, false])),
                                       ("2", DataSeries([false, true, true])))

        XCTAssertTrue(expectedResult.equalsTo(dataframe: df1 <= df2))
        XCTAssertTrue(expectedResult.equalsTo(dataframe: df2 >= df1))
    }

    func test_equalityCompare() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let expectedResult = DataFrame(dictionaryLiteral:
            ("1", DataSeries([false, true, false])),
                                       ("2", DataSeries([false, true, false])))

        XCTAssertTrue(expectedResult.equalsTo(dataframe: df1 == df2))
    }

    func test_nonEqualityCompare() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s2), ("2", s1))

        let expectedResult = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, false, true])),
                                       ("2", DataSeries([true, false, true])))

        XCTAssertTrue(expectedResult.equalsTo(dataframe: df1 != df2))
    }

    func test_strictCompareToConst() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2Const = 2

        let expectedResult1 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, false, false])),
                                        ("2", DataSeries([false, false, false])))

        let expectedResult2 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([false, false, true])),
                                        ("2", DataSeries([false, false, false])))

        XCTAssertTrue(expectedResult1.equalsTo(dataframe: df1 < df2Const))
        XCTAssertTrue(expectedResult2.equalsTo(dataframe: df1 > df2Const))
    }

    func test_nonStrictCompareToConst() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2Const = 2

        let expectedResult1 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, true, false])),
                                        ("2", DataSeries([true, true, true])))

        let expectedResult2 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([false, true, true])),
                                        ("2", DataSeries([true, true, true])))

        XCTAssertTrue(expectedResult1.equalsTo(dataframe: df1 <= df2Const))
        XCTAssertTrue(expectedResult2.equalsTo(dataframe: df1 >= df2Const))
    }

    func test_equalityCompareToConst() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([2, 2, 2])

        let df1: DataFrame<String, Int>? = DataFrame(dictionaryLiteral: ("1", s1), ("2", s2))
        let df2Const = 2

        let expectedResult1 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([false, true, false])),
                                        ("2", DataSeries([true, true, true])))

        let expectedResult2 = DataFrame(dictionaryLiteral:
            ("1", DataSeries([true, false, true])),
                                        ("2", DataSeries([false, false, false])))

        XCTAssertTrue(expectedResult1.equalsTo(dataframe: df1 == df2Const))
        XCTAssertTrue(expectedResult2.equalsTo(dataframe: df1 != df2Const))
    }
}
