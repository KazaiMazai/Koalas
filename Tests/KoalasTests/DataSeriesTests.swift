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
        let cumsum = s1.cumsum(initial: 0)

        XCTAssertEqual(s1.count, cumsum.count)

        cumsum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (cumsum[idx - 1] ?? 0) + (s1[idx] ?? 0))
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


        let cumsum1 = s1.cumsum(initial: 0)
        let cumsum2 = s2.cumsum(initial: 0)

        var rollingSum1 = cumsum1 - cumsum2
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
        let cumsum1 = s1.cumsum(initial: 0)
        let cumsum2 = cumsum1.shiftedBy(window)

        let rollingSum1 = cumsum1 - cumsum2



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
        let cumsum1 = s1.cumsum(initial: 0)
        var cumsum2 = cumsum1.shiftedBy(window)
        cumsum2[window - 1] = 0 //otherwise rolling sum at this point would be wrong due to nil
        let rollingSum1 = cumsum1 - cumsum2

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

    func test_whenSeriesLengthEqual_MemberwiseSum() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let s3 = s1 + s2

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! + s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseDiff() {
           let first: Int = 1
           let last: Int = 20

           let arr = Array(first...last)

           let s1 = DataSeries(arr)
           let s2 = DataSeries(arr)

           let s3 = s1 - s2

           XCTAssertEqual(s3.count, s1.count)
           s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! - s1[$0.offset]!)  }
       }

    func test_whenSeriesLengthEqual_MemberwiseProd() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let s3 = s1 * s2

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! * s1[$0.offset]!)  }
    }

    func test_whenSeriesLengthEqual_MemberwiseDevide() {
        let first: Double = 1.0
        let last: Double = 20.0
        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        let s3 = s1 / s2

        XCTAssertEqual(s3.count, s1.count)
        s3.enumerated().forEach { XCTAssertEqual($0.element!, s2[$0.offset]! / s1[$0.offset]!)  }
    }
}
