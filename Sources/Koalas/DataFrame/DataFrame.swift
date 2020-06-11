//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V> = Dictionary<K, DataSeries<V>>

public extension DataFrame {
    func compactMapValues<V, U>(transform: (V?) -> U?) -> DataFrame<Key, U> where Value == DataSeries<V> {
        mapValues { series in DataSeries(series.map { transform($0) }) }
    }

    func mapTo<V, Constant>(constant value: Constant) -> DataFrame<Key, Constant> where Value == DataSeries<V> {
        return mapValues {  $0.mapTo(constant: value)  }
    }

    func shiftedBy<V>(_ amount: Int) -> DataFrame<Key, V> where Value == DataSeries<V> {
        return mapValues { $0.shiftedBy(amount) }
    }

    func cumulativeSum<V>(initial: V) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        return mapValues { $0.cumulativeSum(initial: initial) }
    }

    func rollingFunc<V>(initial: V, window: Int, windowFunc: (([V?]) -> V?)) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingFunc(initial: initial, window: window, windowFunc: windowFunc)}
    }

    func rollingSum<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingSum(window: window) }
    }

    func rollingMean<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint  {
        return mapValues { $0.rollingMean(window: window) }
    }
}

public func whereCondition<Key, T>(_ condition: DataFrame<Key, Bool>, then trueDataFrame: DataFrame<Key, T>, else dataframe: DataFrame<Key, T>) -> DataFrame<Key, T>? {

    let keysSet = Set(condition.keys)
    guard keysSet == Set(trueDataFrame.keys),
        keysSet == Set(dataframe.keys)
        else {
            return nil
    }

    var res = DataFrame<Key,T>()

    keysSet.forEach { key in
        res[key] = compactMapValues(condition[key],
                                    trueDataFrame[key],
                                    dataframe[key]) { return whereCondition($0, then: $1, else: $2)  }

    }

    return res
}

public func + <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 + $1 }
}

public func - <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 - $1 }
}

public func * <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 * $1 }
}

public func / <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>?  where T: FloatingPoint {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 / $1 }
}

public func + <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T>? {

    guard Set(lhs.keys) == Set(rhs.keys) else {
        return nil
    }
    
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 + $1 }
    }

    return res
}

public func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T>? {

    guard Set(lhs.keys) == Set(rhs.keys) else {
        return nil
    }

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 - $1 }
    }

    return res
}

public func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T>? {

    guard Set(lhs.keys) == Set(rhs.keys) else {
        return nil
    }

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 * $1 }
    }

    return res
}

public func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                                      rhs: DataFrame<Key,T>) -> DataFrame<Key,T>? {

    guard Set(lhs.keys) == Set(rhs.keys) else {
        return nil
    }

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 / $1 }
    }

    return res
}


extension DataFrame {
    func sum<V>(ignoreNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        mapValues { DataSeries([$0.sum(ignoreNils: ignoreNils)]) }
    }

    func columnSum<V>(ignoreNils: Bool = true) -> DataSeries<V>? where Value == DataSeries<V>, V: Numeric {
        guard let first = values.first else {
            return nil
        }

        let initial = DataSeries<V>(repeating: 0, count: first.count)

        return values.reduce(initial) { (currentRes: DataSeries<V>, next: DataSeries<V>) -> DataSeries<V> in
            let nextSeries: DataSeries<V> = ignoreNils ? next.fillNils(with: 0) : next
            return (currentRes + nextSeries) ?? currentRes
        }
    }

    func mean<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.mean(shouldSkipNils: shouldSkipNils)]) }
    }

    func std<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.std(shouldSkipNils: shouldSkipNils)]) }
    }

    func fillNils<V>(method: FillNilsMethod<V>) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        mapValues { $0.fillNils(method: method) }
    }
}
