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
         test_whenDFKeysAndSeriesEqual_MemberwiseDivision)
    ]

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
}
