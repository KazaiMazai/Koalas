//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06.06.2020.
//

import XCTest
@testable import Koalas

final class DataFrameTests: XCTestCase {
    static var allTests = [
        ("test_whenDFKeysAndSeriesEqual_MemberwiseSum",
         test_whenDFKeysAndSeriesEqual_MemberwiseSum),

        ("test_whenDFKeysAndSeriesEqual_MemberwiseProd",
         test_whenDFKeysAndSeriesEqual_MemberwiseProd),

        ("test_whenDFKeysAndSeriesEqual_MemberwiseDiff",
         test_whenDFKeysAndSeriesEqual_MemberwiseDiff),

        ("test_whenDFKeysAndSeriesEqual_MemberwiseDivision",
         test_whenDFKeysAndSeriesEqual_MemberwiseDivision),

        ("test_whenMapToContant_equalLengthsAndValueMatch",
         test_whenMapToContant_equalLengthsAndValueMatch),

        ("test_whenDFContainsNoNils_sum",
         test_whenDFContainsNoNils_sum),

        ("test_whenDFContainsNils_sumWithIgnoreNils",
         test_whenDFContainsNils_sumWithIgnoreNils),

        ("test_whenDFContainsNils_sumNotIgnoreNils",
         test_whenDFContainsNils_sumNotIgnoreNils),
    ]

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

        guard let df3 = df1 + df2 else {
            XCTFail("Not equal length")
            return
        }

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

        guard let df3 = df1 * df2 else {
            XCTFail("Not equal length")
            return
        }

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

        guard let df3 = df1 - df2 else {
            XCTFail("Not equal length")
            return
        }

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

        guard let df3 = df1 / df2 else {
            XCTFail("Not equal length")
            return
        }

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
}
