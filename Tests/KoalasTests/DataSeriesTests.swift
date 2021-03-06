//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import XCTest
@testable import Koalas

final class DataSeriesTests: XCTestCase {
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

    func test_expandingSum() {
        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let expandingSum = s1.expandingSum(initial: 0)

        XCTAssertEqual(s1.count, expandingSum.count)

        expandingSum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (expandingSum[idx - 1] ?? 0) + (s1[idx] ?? 0))
            }
        }
    }

    func test_expandingMax() {
        let s1 = DataSeries([nil, nil, 2, 3 ,1 ,0 ,1, 4, 3])
        let result = s1.expandingMax()

        XCTAssertEqual(s1.count, result.count)

        let expectedResult = DataSeries([nil, nil, 2, 3 ,3 ,3 ,3, 4, 4])
        XCTAssertTrue(result.equalsTo(series: expectedResult))
    }

    func test_expandingMin() {
        let s1 = DataSeries([nil, nil, 2, 3 ,1 ,0 ,1, 4, 3])
        let result = s1.expandingMin()

        XCTAssertEqual(s1.count, result.count)

        let expectedResult = DataSeries([nil, nil, 2, 2 ,1 ,0 ,0, 0, 0])
        XCTAssertTrue(result.equalsTo(series: expectedResult))
    }

    func test_expandingSumWithNilAndInitialNonZero() {
        let s1 = DataSeries([nil, 1, nil ,nil ,nil ,nil, 1, 1])
        let expandingSum = s1.expandingSum(initial: 1)

        XCTAssertEqual(s1.count, expandingSum.count)

        expandingSum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (expandingSum[idx - 1] ?? 0) + (s1[idx] ?? 0))
            }
        }
    }

    func test_scanSeries() {
        let s1 = DataSeries([1, 2, 3 ,4 ,5 ,6, 7, 8])
        let expandingSum = s1.scanSeries(initial: 1)  {  ($0 ?? 0) + ($1 ?? 0) }

        XCTAssertEqual(s1.count, expandingSum.count)

        expandingSum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (expandingSum[idx - 1] ?? 0) + (s1[idx] ?? 0))
            }
        }
    }

    func test_scanSeriesWithNilAndInitialNonZero() {
        let s1 = DataSeries([nil, 1, nil ,nil ,nil ,nil, 1, 1])
        let expandingSum = s1.scanSeries(initial: 1)  {  ($0 ?? 0) + ($1 ?? 0) }
        XCTAssertEqual(s1.count, expandingSum.count)

        expandingSum.enumerated().forEach {
            let idx = $0.offset
            if idx > 0 {
                XCTAssertEqual($0.element, (expandingSum[idx - 1] ?? 0) + (s1[idx] ?? 0))
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


        let expandingSum1 = s1.expandingSum(initial: 0)
        let expandingSum2 = s2.expandingSum(initial: 0)

        var rollingSum1 = expandingSum1 - expandingSum2

        /**when index is less then window size, then nil value in rolling sum
         */
        rollingSum1.replaceSubrange(0..<window-1, with: DataSeries(repeating: nil, count: window-1))

        let rollingSum2 = s1.rollingFunc(initial: nil, window: window) { (w: [Int?]) -> Int? in
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
        let expandingSum1 = s1.expandingSum(initial: 0)
        let expandingSum2 = expandingSum1.shiftedBy(window)

        let rollingSum1 = expandingSum1 - expandingSum2

        let rollingSum2 = s1.rollingFunc(initial: nil, window: window) { (w: [Int?]) -> Int? in
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
        let expandingSum1 = s1.expandingSum(initial: 0)
        var expandingSum2 = expandingSum1.shiftedBy(window)
        expandingSum2[window - 1] = 0 //otherwise rolling sum at this point would be wrong due to nil
        let rollingSum1 = expandingSum1 - expandingSum2

        let rollingSum2 = s1.rollingFunc(initial: nil, window: window) { (w: [Int?]) -> Int? in
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
    
    func test_whenSeriesContainsNoNils_sum() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        XCTAssertEqual(s1.sum(ignoreNils: true), arr.reduce(0, +))
    }

    func test_whenSeriesContainsDoubleAndNoNils_sum() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        XCTAssertEqual(s1.sum(ignoreNils: true), arr.reduce(0, +))
    }

    func test_whenSeriesContainsNills_sumWithIgnoreNils() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        var s1 = DataSeries(arr)
        s1.append(nil)
        XCTAssertEqual(s1.sum(ignoreNils: true), arr.reduce(0, +))
    }

    func test_whenSeriesContainsNills_sumWithNoIgnoreNilsEqualsNil() {
        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        var s1 = DataSeries(arr)
        s1.append(nil)

        XCTAssertNil(s1.sum(ignoreNils: false))
    }

    func test_whenSeriesContainsNoNils_mean() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        let s1 = DataSeries(arr)
        XCTAssertEqual(s1.mean(shouldSkipNils: true), arr.reduce(0, +) / Double(arr.count))
    }

    func test_whenSeriesContainsNils_meanWithIgnoreNils() {
        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        s1.append(nil)

        XCTAssertEqual(s1.mean(shouldSkipNils: true), arr.reduce(0, +) / Double(arr.count))
    }

    func test_whenSeriesContainsNils_meanNoIgnoreNils() {
        let first: Double = 1
        let last: Double = 20

        var arr = Array(stride(from: first, through: last, by: 1.0))

        var s1 = DataSeries(arr)
        s1.append(contentsOf: [nil, nil, nil])
        arr.append(contentsOf: [0, 0, 0])

        XCTAssertEqual(s1.mean(shouldSkipNils: false), arr.reduce(0, +) / Double(arr.count))
    }

    func test_forwardFillNils() {
        let arr1 = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr = [1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5]
        let s1 = DataSeries(arr1)
        let s2 = s1.fillNils(method: .forward(initial: 0))

        XCTAssertEqual(s1.count, s2.count)
        zip(s2, expectedArr).forEach { XCTAssertEqual($0.0, $0.1) }
    }

    func test_whenFirstNil_forwardFillNilsStartWithInitial() {
        let initial = 0
        let arr1 = [nil, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr = [initial, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5]
        let s1 = DataSeries(arr1)
        let s2 = s1.fillNils(method: .forward(initial: initial))

        XCTAssertEqual(s1.count, s2.count)
        zip(s2, expectedArr).forEach { XCTAssertEqual($0.0, $0.1) }
    }

    func test_backwardFillNils() {
        let arr1 = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, 6]
        let expectedArr = [1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6]
        let s1 = DataSeries(arr1)
        let s2 = s1.fillNils(method: .backward(initial: 0))

        XCTAssertEqual(s1.count, s2.count)
        zip(s2, expectedArr).forEach { XCTAssertEqual($0.0, $0.1) }
    }

    func test_whenLastNil_backwardFillNils() {
        let initial = 6
        let arr1 = [1, 2, nil, 3, nil, 4, nil, 5, nil, nil, nil]
        let expectedArr = [1, 2, 3, 3, 4, 4, 5, 5, initial, initial, initial]
        let s1 = DataSeries(arr1)
        let s2 = s1.fillNils(method: .backward(initial: initial))

        XCTAssertEqual(s1.count, s2.count)
        zip(s2, expectedArr).forEach { XCTAssertEqual($0.0, $0.1) }
    }

    func test_toDateComponentsFunc() {
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

        let dateComponentsDF = s1.toDateComponents()
        dateComponentsDF[.year]?.enumerated()
            .forEach  { XCTAssertEqual($0.element, years[$0.offset]) }

        dateComponentsDF[.month]?.enumerated()
            .forEach  { XCTAssertEqual($0.element, months[$0.offset]) }

        dateComponentsDF[.day]?.enumerated()
            .forEach  { XCTAssertEqual($0.element, days[$0.offset]) }
    }

    func test_whenSeriesEqual_equalToReturnsTrue() {

        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr)

        XCTAssertTrue(s1.equalsTo(series: s2))
    }

    func test_whenSeriesEqualAndContainNil_equalToReturnsTrue() {

        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries([nil, nil, 1, 2, 3])
        let s2 = DataSeries([nil, nil, 1, 2, 3])

        XCTAssertTrue(s1.equalsTo(series: s2))
    }

    func test_whenFloatingPointSeriesEqual_equalToReturnsTrue() {

        let first: Double = 1
        let last: Double = 20

        let arr = Array(stride(from: first, through: last, by: 1.0))
        let arr2 = Array(stride(from: first, through: last, by: 1.0))


        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr2)

        XCTAssertTrue(s1.equalsTo(series: s2, with: 0.000001))
    }

    func test_whenSeriesNotEqual_equalsToReturnsFalse() {

        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr.reversed())

        XCTAssertFalse(s1.equalsTo(series: s2))
    }

    func test_whenSeriesNotEqualLength_equalsToReturnsFalse() {

        let first: Int = 1
        let last: Int = 20

        let arr = Array(first...last)
        let arr2 = Array(first..<last)

        let s1 = DataSeries(arr)
        let s2 = DataSeries(arr2)

        XCTAssertFalse(s1.equalsTo(series: s2))
    }




    func test_strictCompareToConst() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let constToCompare = 2

        let expectedResult1 = DataSeries([true, false, false])
        let expectedResult2 = DataSeries([false, false, true])

        XCTAssertTrue(expectedResult1.equalsTo(series: s1 < constToCompare))
        XCTAssertTrue(expectedResult2.equalsTo(series: s1 > constToCompare))
    }


    func test_nonStrictCompareToConst() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let constToCompare = 2

        let expectedResult1 = DataSeries([true, true, false])
        let expectedResult2 = DataSeries([false, true, true])

        XCTAssertTrue(expectedResult1.equalsTo(series: s1 <= constToCompare))
        XCTAssertTrue(expectedResult2.equalsTo(series: s1 >= constToCompare))
    }

    func test_equalityCompareToConst() {
        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let constToCompare = 2

        let expectedResult = DataSeries([false, true, false])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 == constToCompare))
    }

    func test_nonEqualityCompareToConst() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let constToCompare = 2

        let expectedResult = DataSeries([true, false, true])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 != constToCompare))
    }

    func test_strictCompare() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = DataSeries([2, 2, 2])

        let expectedResult = DataSeries([true, false, false])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 < s2))
        XCTAssertTrue(expectedResult.equalsTo(series: s2 > s1))
    }

    func test_nonStrictCompare() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = DataSeries([2, 2, 2])

        let expectedResult = DataSeries([true, true, false])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 <= s2))
        XCTAssertTrue(expectedResult.equalsTo(series: s2 >= s1))
    }

    func test_equalityCompare() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = DataSeries([2, 2, 2])

        let expectedResult = DataSeries([false, true, false])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 == s2))
    }

    func test_nonEqualityCompare() {

        let s1: DataSeries<Int>? = DataSeries([1, 2, 3])
        let s2: DataSeries<Int>? = DataSeries([2, 2, 2])

        let expectedResult = DataSeries([true, false, true])

        XCTAssertTrue(expectedResult.equalsTo(series: s1 != s2))
    }

    func test_isEmptySeries() {
        let s1: DataSeries<Int> = DataSeries([nil, nil, nil])
        let s2: DataSeries<Int> = DataSeries([1, 2, nil])
        let s3: DataSeries<Int> = DataSeries([1, 2, 3])

        XCTAssertTrue(s1.isEmptySeries())
        XCTAssertFalse(s2.isEmptySeries())
        XCTAssertFalse(s3.isEmptySeries())
    }
}
