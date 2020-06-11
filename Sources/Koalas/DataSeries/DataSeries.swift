//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataSeries<T> = SeriesArray<T?>

public func compactMapValues<T, U>(lhs: T?, rhs: T?, map: (T, T) -> U?) -> U? {
    guard let lhs = lhs, let rhs = rhs else {
        return nil
    }

    return map(lhs, rhs)
}

public func compactMapValues<T, U, V, S>(_ t: T?, _ u: U?, _ v: V?, map: (T, U, V) -> S?) -> S? {
    guard let t = t, let u = u, let v = v else {
        return nil
    }

    return map(t, u, v)
}

public func compactMapValue<T, U>(value: T?, map: (T) -> U?) -> U? {
    guard let value = value else {
        return nil
    }

    return map(value)
}


public func + <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 + $1 }
}

public func - <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 - $1 }
}

public func * <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 * $1 }
}

public func / <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: FloatingPoint {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 / $1 }
}

public func + <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>?  where T: Numeric {
    guard lhs.count == rhs.count else {
        return nil
    }

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 + $1 }
    }

    return DataSeries(res)
}

public func != <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>?  where T: Numeric {
    guard lhs.count == rhs.count else {
        return nil
    }

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 != $1 }
    }

    return DataSeries(res)
}

public func == <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>?  where T: Numeric {
    guard lhs.count == rhs.count else {
        return nil
    }

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 == $1 }
    }

    return DataSeries(res)
}


public func - <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>?  where T: Numeric {
    guard lhs.count == rhs.count else {
        return nil
    }

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 - $1 }
    }

    return DataSeries(res)
}

public func * <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>?  where T: Numeric {
    guard lhs.count == rhs.count else {
        return nil
    }

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 * $1 }
    }

    return DataSeries(res)
}

public func / <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>?  where T: FloatingPoint {
    guard lhs.count == rhs.count else {
        return nil
    }
    
    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 / $1 }
    }

    return DataSeries(res)
}

public func zipSeries<T1, T2, T3>(s1: SeriesArray<T1>, s2: SeriesArray<T2>, s3: SeriesArray<T3>) -> Array<(T1, T2, T3)>? {
    guard s1.count == s2.count, s2.count == s3.count else {
        return nil
    }

    return zip(s1, zip(s2, s3)).map { ($0.0, $0.1.0, $0.1.1) }
}

public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>?   {
    return condition?.whereTrue(then: trueSeries, else: series)
}

public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueValue: U, else value: U) -> DataSeries<U>?   {
    guard let condition = condition else {
        return nil
    }

    let trueSeries = condition.mapTo(constant: trueValue)
    let falseSeries = condition.mapTo(constant: value)

    return condition.whereTrue(then: trueSeries, else: falseSeries)
}

public extension SeriesArray  {
    func whereTrue<U>(then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>? where Element == Bool?  {
        guard let trueSeries = trueSeries,
            let series = series
        else {
            return nil
        }

        guard let zip3 = zipSeries(s1: self, s2: trueSeries, s3: series) else {
            return nil
        }

        let resultArray = zip3.map { zipped in zipped.0.map { $0 ? zipped.1 : zipped.2 } ?? nil }
        return DataSeries<U>(resultArray)
    }
}

public extension SeriesArray {
    func fillNils<T>(with value: T) -> DataSeries<T> where Element == T? {
        return DataSeries(map { $0 ?? value } )
    }

    func fillNils<T>(method: FillNilsMethod<T>) -> DataSeries<T> where Element == T? {
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
        let res = scan(initial: initial) {  $0 + ($1 ?? initial) }
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
