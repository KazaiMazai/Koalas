//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public extension SeriesArray  {
    func whereTrue<U>(then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>? where Element == Bool?  {
        guard let trueSeries = trueSeries,
            let series = series
            else {
                return nil
        }

        let zip3 = zipSeries(s1: self, s2: trueSeries, s3: series)

        let resultArray = zip3.map { zipped in zipped.0.map { $0 ? zipped.1 : zipped.2 } ?? nil }
        return DataSeries<U>(resultArray)
    }
}

public extension SeriesArray {
    func equalsTo<T>(series: DataSeries<T>?) -> Bool where Element == T?, T: Equatable {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1) }  == nil
    }

    func equalsTo<T>(series: DataSeries<T>?, with precision: T) -> Bool where Element == T?, T: FloatingPoint {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1, with: precision) }  == nil
    }

    func equalsTo<T>(series: DataSeries<T>?) -> Bool where Element == T?, T: Numeric {
        guard let series = series else {
            return false
        }

        guard count == series.count else {
            return false
        }

        return zip(self, series).first { !isElementEqual(lhs: $0.0, rhs: $0.1) }  == nil
    }

    func fillNils<T>(with value: Element) -> DataSeries<T> where Element == T? {
        return DataSeries(map { $0 ?? value } )
    }

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

    func mapTo<T>(constant value: T) -> DataSeries<T> {
        return DataSeries(repeating: value, count: self.count)
    }

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

    func sum<T>(ignoreNils: Bool = true) -> T? where Element == T?, T: Numeric {
        let nonNils = filter { $0 != nil }
        guard ignoreNils || nonNils.count == count else {
            return nil
        }

        return nonNils.map { $0 ?? 0 }.reduce(0, +)
    }

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

    func cumulativeSum<T>(initial: T) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = scan(initial: initial) {  $0 + ($1 ?? 0) }
        return DataSeries(res)
    }

    func rollingFunc<T>(initial: T?, window: Int, windowFunc: (([Element]) -> Element)) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = rollingScan(initial: initial, window: window, windowFunc: windowFunc)
        return DataSeries(res)
    }

    func rollingSum<T>(window: Int) -> DataSeries<T> where Element == T?, T: Numeric {
        let res = rollingScan(initial: nil, window: window) { windowArray in
            guard windowArray.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return windowArray.reduce(0) { $0 + ($1 ?? 0) }
        }

        return DataSeries(res)
    }

    func rollingMean<T>(window: Int) -> DataSeries<T> where Element == T?, T: FloatingPoint {
        let res = rollingScan(initial: nil, window: window) { windowArray in
            guard windowArray.allSatisfy({ $0 != nil }) else {
                return nil
            }

            return windowArray.reduce(0) { $0 + ($1 ?? 0) } / T(windowArray.count)
        }

        return DataSeries(res)
    }
}

public extension SeriesArray {
    func at(index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }

    func setAt(index: Int, value: Element) -> Self {
        guard index >= 0 && index < count else {
            return self
        }

        var array = self

        array[index] = value
        return array
    }
}

public extension SeriesArray {
    func scan<T>(initial: T, _ f: (T, Element) -> T) -> [T] {
        var result = self.reduce([initial]) { (listSoFar: [T], next: Element) -> [T] in
            let lastElement = listSoFar.last ?? initial
            return listSoFar + [f(lastElement, next)]
        }

        result.removeFirst()
        return result
    }

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

fileprivate func isElementEqual<T>(lhs: T?, rhs: T?) -> Bool where T: Equatable {
    if lhs == nil && rhs == nil {
        return true
    }

    guard let lhs = lhs, let rhs = rhs else {
        return false
    }

    return lhs == rhs
}

public func zipSeries<T1, T2, T3>(s1: SeriesArray<T1>, s2: SeriesArray<T2>, s3: SeriesArray<T3>) -> Array<(T1, T2, T3)> {
    assert(s1.count == s2.count, "Dataseries should have equal length")
    assert(s1.count == s3.count, "Dataseries should have equal length")

    return zip(s1, zip(s2, s3)).map { ($0.0, $0.1.0, $0.1.1) }
}
