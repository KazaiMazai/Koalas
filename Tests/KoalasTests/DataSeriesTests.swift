//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import XCTest
@testable import Koalas

final class DataSeriesTests: XCTestCase {
    static var allTests = [
        ("test_whenShiftedPositiveByN_NilsInTheBeginningCountsNAndArraysMatch", test_whenShiftedPositiveByN_NilsInTheBeginningCountsNAndArraysMatch),

        ("test_whenShiftedNegativeByN_NilsInTheEndCountsNAndArraysMatch",
         test_whenShiftedNegativeByN_NilsInTheEndCountsNAndArraysMatch),

        ("test_whenShiftedOnFullLength_AllNils",
         test_whenShiftedOnFullLength_AllNils),

        ("test_cumulativeSum",
         test_cumulativeSum),

        ("test_whenWindowIsUnderSeriesLength_rollingSumEqualsShiftedSubstractedCumsSums", test_whenWindowIsUnderSeriesLength_rollingSumEqualsShiftedSubstractedCumsSums),

        ("test_whenWindowLargerThenSeriesLength_rollingSumInNil",
         test_whenWindowLargerThenSeriesLength_rollingSumInNil),

        ("test_whenWindowEqualsSeriesLength_rollingSumLastValueNotNil",
         test_whenWindowEqualsSeriesLength_rollingSumLastValueNotNil),

        ("test_whenMapToContant_equalLengthAndValueMatch",
         test_whenMapToContant_equalLengthAndValueMatch),

        ("test_whenSeriesLengthEqual_MemberwiseSum",
         test_whenSeriesLengthEqual_MemberwiseSum),

        ("test_whenSeriesLengthEqual_MemberwiseDiff",
         test_whenSeriesLengthEqual_MemberwiseDiff),

        ("test_whenSeriesLengthEqual_MemberwiseProd",
         test_whenSeriesLengthEqual_MemberwiseProd),

        ("test_whenSeriesLengthEqual_MemberwiseDevide",
         test_whenSeriesLengthEqual_MemberwiseDevide)
    ]

    func test_whenShiftedPositiveByN_NilsInTheBeginningCountsNAndArraysMatch() {
        let n = 3
        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let s2 = s1.shiftedBy(n)

        XCTAssertEqual(s1.count, s2.count)
        let allNils = s2[0..<n].allSatisfy { $0 == nil }
        XCTAssertTrue(allNils)

        let s3 = s2.dropFirst(n)


        let valuesMatch = zip(s3, s1).allSatisfy { $0.0 == $0.1  }
        XCTAssertTrue(valuesMatch)
    }

    func test_whenShiftedNegativeByN_NilsInTheEndCountsNAndArraysMatch() {
        let n = 3
        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let s2 = s1.shiftedBy(-n)

        XCTAssertEqual(s1.count, s2.count)
        let lastNil = s2.count
        let firstNil = s2.count - n


        let allNils = s2[firstNil..<lastNil].allSatisfy { $0 == nil }
        XCTAssertTrue(allNils)

        let s3 = s1.dropFirst(n)


        let valuesMatch = zip(s3, s2).allSatisfy { $0.0 == $0.1  }
        XCTAssertTrue(valuesMatch)
    }

    func test_whenShiftedOnFullLength_AllNils() {

        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let n = s1.count
        let s2 = s1.shiftedBy(-n)

        XCTAssertEqual(s1.count, s2.count)
        let lastNil = s2.count
        let firstNil = s2.count - n


        let allNils = s2[firstNil..<lastNil].allSatisfy { $0 == nil }
        XCTAssertTrue(allNils)

        let s3 = s1.dropFirst(n)


        let valuesMatch = zip(s3, s2).allSatisfy { $0.0 == $0.1  }
        XCTAssertTrue(valuesMatch)
    }

    func test_cumulativeSum() {
        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let cumulativeSum = s1.cumulativeSum(initial: 0)

        XCTAssertEqual(s1.count, cumulativeSum.count)

        cumulativeSum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (cumulativeSum[idx - 1] ?? 0) + (s1[idx] ?? 0))
            }
        }
    }

    func test_whenWindowIsUnderSeriesLength_rollingSumEqualsShiftedSubstractedCumsSums() {
        let first: Int = 1
        let last: Int = 20
        let window = 4

        let arr = Array(first...last)
        let s1 = DataSeries(arr)
        let s2 = s1.shiftedBy(window)


        let cumulativeSum1 = s1.cumulativeSum(initial: 0)
        let cumulativeSum2 = s2.cumulativeSum(initial: 0)

        guard var rollingSum1 = cumulativeSum1 - cumulativeSum2 else {
            XCTFail("Not equal length")
            return
        }
        /**when index is less then window size, then nil value in rolling sum
         */
        rollingSum1.replaceSubrange(0..<window-1, with: DataSeries(repeating: nil, count: window-1))

        let rollingSum2 = s1.rollingScan(initial: nil, window: window) { (w: [Int?]) -> Int? in
            /**when array of values is less then window size, then nil value in rolling sum
             */
            guard w.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return w.reduce(0) { $0 + ($1 ?? 0) }
        }


        XCTAssertEqual(rollingSum1.count, rollingSum2.count)

        zip(rollingSum1, rollingSum2).forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }

    func test_whenWindowLargerThenSeriesLength_rollingSumInNil() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)
        let s1 = DataSeries(arr)

        let window = arr.count + 1
        let cumulativeSum1 = s1.cumulativeSum(initial: 0)
        let cumulativeSum2 = cumulativeSum1.shiftedBy(window)

        guard let rollingSum1 = cumulativeSum1 - cumulativeSum2 else {
            XCTFail("Not equal length")
            return
        }



        let rollingSum2 = s1.rollingScan(initial: nil, window: window) { (w: [Int?]) -> Int? in
            guard w.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return w.reduce(0) { $0 + ($1 ?? 0) }
        }

        XCTAssertEqual(rollingSum1.count, rollingSum2.count)
        XCTAssertTrue(rollingSum2.allSatisfy { $0 == nil })
        zip(rollingSum1, rollingSum2).forEach {
            XCTAssertEqual($0.0, $0.1)
        }

    }

    func test_whenWindowEqualsSeriesLength_rollingSumLastValueNotNil() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)
        let s1 = DataSeries(arr)

        let window = arr.count
        let cumulativeSum1 = s1.cumulativeSum(initial: 0)
        var cumulativeSum2 = cumulativeSum1.shiftedBy(window)
        cumulativeSum2[window - 1] = 0 //otherwise rolling sum at this point would be wrong due to nil
        guard let rollingSum1 = cumulativeSum1 - cumulativeSum2 else {
            XCTFail("Not equal length")
            return
        }

        let rollingSum2 = s1.rollingScan(initial: nil, window: window) { (w: [Int?]) -> Int? in
            guard w.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return w.reduce(0) { $0 + ($1 ?? 0) }
        }
        XCTAssertEqual(rollingSum1.count, rollingSum2.count)

        XCTAssertEqual(rollingSum1.enumerated().first { $0.element != nil}?.offset, window - 1)
        zip(rollingSum1, rollingSum2).forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }

    func test_whenMapToContant_equalLengthAndValueMatch() {
        let first: Int = 1
        let last: Int = 20

        let constant = 1
        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = s1.mapTo(constant: constant)

        XCTAssertEqual(s2.count, s1.count)
        s2.forEach { XCTAssertEqual($0, constant) }
    }

    func test_whenSeriesLengthEqual_MemberwiseSum() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        guard let s3 = s1 + s2 else {
            XCTFail("Not equal length")
            return
        }

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! + s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseDiff() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        guard let s3 = s1 - s2 else {
            XCTFail("Not equal length")
            return
        }

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! - s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseProd() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        guard let s3 = s1 * s2 else {
            XCTFail("Not equal length")
            return
        }

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! * s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseDevide() {
        let first: Double = 1.0
        let last: Double = 20.0
        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        guard let s3 = s1 / s2 else {
            XCTFail("Not equal length")
            return
        }

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! / s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseConditionalMap() {

        let s1 = DataSeries(repeating: 1, count: 5)
        let s2 = DataSeries(repeating: 2, count: 5)
        let s3 = DataSeries([true, false, true, nil, false])

        guard let result = s3.whereTrue(then: s1, else: s2) else {
            XCTFail("Not equal length")
            return
        }

        result.enumerated().forEach {
            if let s3Value = s3[$0.offset] {

                if s3Value {
                    XCTAssertEqual($0.element, s1[$0.offset])
                } else {
                    XCTAssertEqual($0.element, s2[$0.offset])
                }
            } else {
                XCTAssertEqual($0.element, nil)
            }

        }
    }

    func test_whenSeriesLengthNotEqual_MemberwiseConditionalNilResult() {

        let s1 = DataSeries(repeating: 1, count: 4)
        let s2 = DataSeries(repeating: 2, count: 5)
        let s3 = DataSeries([true, false, true, nil, false])
        let result = s3.whereTrue(then: s1, else: s2)
        XCTAssertNil(result)
    }
}
