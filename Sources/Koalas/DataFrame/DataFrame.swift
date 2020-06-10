//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V> = Dictionary<K, DataSeries<V>>


public extension DataFrame {
    func mapTo<V, Constant>(constant value: Constant) -> DataFrame<Key, Constant> where Value == DataSeries<V> {
        return mapValues {  $0.mapTo(constant: value)  }
    }

    func shiftedBy<V>(_ amount: Int) -> DataFrame<Key, V> where Value == DataSeries<V> {
        return mapValues { $0.shiftedBy(amount) }
    }

    func cumsum<V>(initial: V) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        return mapValues { $0.cumsum(initial: initial) }
    }

    func rollingFunc<V>(initial: V, window: Int, windowFunc: (([V?]) -> V?)) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingFunc(initial: initial, window: window, windowFunc: windowFunc)}
    }

    func rollingSum<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingSum(window: window) }
    }

    func movingAverage<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint  {
        return mapValues { $0.movingAverage(window: window) }
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

