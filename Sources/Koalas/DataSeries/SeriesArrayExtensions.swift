//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public extension SeriesArray  {
    /**
     Applies a conditional operation based on boolean values in the series.
     Returns trueSeries values where the condition is true, else series values where false.
     Returns nil if either input series is nil.
     */
    func whereTrue<U>(then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>? where Element == Bool?  {
        guard let trueSeries = trueSeries,
            let series = series
            else {
                return nil
        }

        let zip3 = zipSeriesArray(s1: self, s2: trueSeries, s3: series)

        let resultArray = zip3.map { zipped in zipped.0.map { $0 ? zipped.1 : zipped.2 } ?? nil }
        return DataSeries<U>(resultArray)
    }
}

public extension SeriesArray {
    /**
     Checks if the series contains only nil values.
     Returns true if all elements are nil or if the series is empty.
     */
    func isEmptySeries<T>() -> Bool where Element == T?, T: Equatable {
        guard let firstNonNil = first(where: { $0 != nil }) else {
            return true
        }

        return firstNonNil == nil
    }

    /**
     Compares this series with another series for equality.
     Returns true if both series have the same length and corresponding elements are equal.
     */
    func equalsTo<T>(series: DataSeries<T>?) -> Bool where Element == T?, T: Equatable {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1) } == nil
    }

    /**
     Compares this series with another series for equality with precision tolerance.
     Useful for floating-point comparisons where exact equality is not required.
     */
    func equalsTo<T>(series: DataSeries<T>?, with precision: T) -> Bool where Element == T?, T: FloatingPoint {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1, with: precision) }  == nil
    }

    /**
     Compares this series with another series for equality.
     Returns true if both series have the same length and corresponding elements are equal.
     */
    func equalsTo<T>(series: DataSeries<T>?) -> Bool where Element == T?, T: Numeric {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1) }  == nil
    }

    /**
     Fills all nil values in the series with a specified value.
     Returns a new series with nil values replaced by the provided value.
     */
    func fillNils<T>(with value: Element) -> DataSeries<T> where Element == T? {
        return DataSeries(map { $0 ?? value } )
    }

    /**
     Fills nil values using the specified method (all, backward, or forward fill).
     Returns a new series with nil values filled according to the method.
     */
    func fillNils<T>(method: FillNilsMethod<Element>) -> DataSeries<T> where Element == T? {
        switch method {
        case .all(let value):
            return fillNils(with: value)
        case .backward(let initial):
            let res = DataSeries(reversed()).scan(initial: initial) { ($1 ?? $0) }
            return DataSeries(res.reversed())
        case .forward(let initial):
            let res = scan(initial: initial) { ($1 ?? $0) }
            return DataSeries(res)
        }
    }

    /**
     Creates a new series with all elements set to a constant value.
     Returns a series of the same length with every element equal to the specified value.
     */
    func mapTo<T>(constant value: T) -> DataSeries<T> {
        return DataSeries(repeating: value, count: self.count)
    }

    /**
     Shifts the series by the specified number of positions.
     Positive values shift forward (add nils at beginning), negative values shift backward (add nils at end).
     */
    func shiftedBy<T>(_ k: Int) -> DataSeries<T> where Element == T?  {
        let shift = abs(k)
        guard k > 0  else {
            var arr = self
            arr.append(contentsOf: DataSeries<T>(repeating: nil, count: shift))
            arr.removeFirst(shift)
            return arr
        }

        var arr = self
        arr.insert(contentsOf: DataSeries<T>(repeating: nil, count: shift), at: 0)
        arr.removeLast(shift)
        return arr
    }

    /**
     Calculates the sum of all non-nil values in the series.
     Returns nil if ignoreNils is false and there are nil values present.
     */
    func sum<T>(ignoreNils: Bool = true) -> T? where Element == T?, T: Numeric {
        let nonNils = filter { $0 != nil }
        guard ignoreNils || nonNils.count == count else {
            return nil
        }

        return nonNils.map { $0 ?? 0 }.reduce(0, +)
    }

    /**
     Calculates the mean of all values in the series.
     If shouldSkipNils is true, only non-nil values are considered. Otherwise, nils are treated as 0.
     */
    func mean<T>(shouldSkipNils: Bool = true) -> T? where Element == T?, T: FloatingPoint {
        let nonNils = shouldSkipNils ?
            DataSeries(self.filter { $0 != nil }) :
            self.fillNils(with: 0)

        guard nonNils.count > 0 else {
            return nil
        }

        let sum = nonNils.map { $0 ?? 0 }.reduce(0, +)

        return sum / T(nonNils.count)
    }

    /**
     Calculates the standard deviation of all values in the series.
     If shouldSkipNils is true, only non-nil values are considered. Otherwise, nils are treated as 0.
     */
    func std<T>(shouldSkipNils: Bool = true) -> T? where Element == T?, T: FloatingPoint {
        let nonNils = shouldSkipNils ?
            DataSeries(self.filter { $0 != nil }) :
            self.fillNils(with: 0)

        guard nonNils.count > 1 else {
            return nil
        }

        let sum = nonNils.map { $0 ?? 0 }.reduce(0, +)
        let mean = sum / T(nonNils.count)


        let diff = nonNils - nonNils.mapTo(constant: mean)
        let squaredDiffSum = (diff * diff)?.map { $0 ?? 0 }.reduce(0, +)
        let squaredStd = (squaredDiffSum ?? 0) / T(nonNils.count - 1)
        return sqrt(squaredStd)
    }

    /**
     Calculates expanding (cumulative) sum of the series.
     Returns a series where each element is the sum of all previous elements plus the current element.
     */
    func expandingSum<T>(initial: T) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = scan(initial: initial) {  $0 + ($1 ?? 0) }
        return DataSeries(res)
    }

    /**
     Calculates expanding (cumulative) maximum of the series.
     Returns a series where each element is the maximum of all previous elements and the current element.
     */
    func expandingMax<T>() -> DataSeries<T> where Element == T?, T: Comparable {
        let res = scan(initial: first ?? nil) { current, next in
            guard let next = next else {
                return current
            }

            guard let current = current else {
                return next
            }

            return Swift.max(current, next)

        }

        return DataSeries(res)
    }

    /**
     Calculates expanding (cumulative) minimum of the series.
     Returns a series where each element is the minimum of all previous elements and the current element.
     */
    func expandingMin<T>() -> DataSeries<T> where Element == T?, T: Comparable {
        let res = scan(initial: first ?? nil) { current, next in
            guard let next = next else {
                return current
            }

            guard let current = current else {
                return next
            }

            return Swift.min(current, next)

        }

        return DataSeries(res)
    }

    /**
     Applies a rolling window function to the series.
     Uses the specified window size and custom function to process each window of elements.
     */
    func rollingFunc<T>(initial: T?, window: Int, windowFunc: (([Element]) -> Element)) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = rollingScan(initial: initial, window: window, windowFunc: windowFunc)
        return DataSeries(res)
    }

    /**
     Calculates rolling sum with the specified window size.
     Returns a series where each element is the sum of the current element and the previous (window-1) elements.
     */
    func rollingSum<T>(window: Int) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = rollingScan(initial: nil, window: window) { windowArray in
            guard windowArray.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return windowArray.reduce(0) { $0 + ($1 ?? 0) }
        }

        return DataSeries(res)
    }

    /**
     Calculates rolling mean with the specified window size.
     Returns a series where each element is the mean of the current element and the previous (window-1) elements.
     */
    func rollingMean<T>(window: Int) -> DataSeries<T> where Element == T?, T: FloatingPoint {
        let res = rollingScan(initial: nil, window: window) { windowArray in
            guard windowArray.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return windowArray.reduce(0) { $0 + ($1 ?? 0) } / T(windowArray.count)
        }

        return DataSeries(res)
    }

    /**
     Applies a scan operation to the series with a custom transformation function.
     Performs cumulative operations with an initial value and transformation function.
     */
    func scanSeries<T, U>(initial: T?, _ nextPartialResult: (_ current: T?, _ next: U?) -> T?) -> DataSeries<T> where Element == U? {
        let res = scan(initial: initial, nextPartialResult)
        return DataSeries(res)
    }
}

public extension SeriesArray {
    /**
     Safely accesses an element at the specified index.
     Returns nil if the index is out of bounds.
     */
    func at(index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }

    /**
     Safely sets an element at the specified index.
     Returns the original series unchanged if the index is out of bounds.
     */
    func setAt(index: Int, value: Element) -> Self {
        guard index >= 0 && index < count else {
            return self
        }

        var array = self

        array[index] = value
        return array
    }
}

fileprivate extension SeriesArray {
    /**
     Performs a scan operation with a custom transformation function.
     Returns an array where each element is the result of applying the function to all previous elements.
     */
    func scan<T>(initial: T, _ f: (T, Element) -> T) -> [T] {
        var result = self.reduce([initial]) { (listSoFar: [T], next: Element) -> [T] in
            let lastElement = listSoFar.last ?? initial
            return listSoFar + [f(lastElement, next)]
        }

        result.removeFirst()
        return result
    }

    /**
     Performs a rolling scan operation with a custom window function.
     Applies the window function to each window of elements as the series is processed.
     */
    func rollingScan(initial: Element, window: Int, windowFunc: (([Element]) -> Element)) -> Array<Element> {
        let initialWindowArray = Array(repeating: initial, count: window)
        let f: ([Element], Element) -> [Element] = {
            var arr = $0
            arr.append($1)
            let _ = arr.removeFirst()

            return arr
        }

        var result = reduce([initialWindowArray]) { (listSoFar: [[Element]], next: Element) -> [[Element]] in
            let lastElement = listSoFar.last ?? initialWindowArray
            return listSoFar + [f(lastElement, next)]
        }

        result.removeFirst()
        return result.map { windowFunc($0) }
    }
}

/**
 Compares two optional floating-point values for equality with precision tolerance.
 Returns true if the absolute difference is less than or equal to the precision value.
 */
fileprivate func isElementEqual<T>(lhs: T?, rhs: T?, with precision: T) -> Bool where T: FloatingPoint {
    if lhs == nil && rhs == nil {
        return true
    }

    guard let lhs = lhs, let rhs = rhs else {
        return false
    }

    guard !lhs.isEqual(to: rhs) else {
        return true
    }

    return abs(lhs - rhs) <= precision
}

/**
 Compares two optional values for equality.
 Returns true if both values are nil or if both values are equal.
 */
fileprivate func isElementEqual<T>(lhs: T?, rhs: T?) -> Bool where T: Equatable {
    if lhs == nil && rhs == nil {
        return true
    }

    guard let lhs = lhs, let rhs = rhs else {
        return false
    }

    return lhs == rhs
}

/**
 Combines three SeriesArrays into a single array of tuples.
 Asserts that all arrays have equal length and returns corresponding elements as tuples.
 */
func zipSeriesArray<T1, T2, T3>(s1: SeriesArray<T1>, s2: SeriesArray<T2>, s3: SeriesArray<T3>) -> Array<(T1, T2, T3)> {
    assert(s1.count == s2.count, "Dataseries should have equal length")
    assert(s1.count == s3.count, "Dataseries should have equal length")

    return zip(s1, zip(s2, s3)).map { ($0.0, $0.1.0, $0.1.1) }
}
