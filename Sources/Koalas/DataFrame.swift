//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V> = Dictionary<K, DataSeries<V>>

public extension DataFrame {
    func mapToConstant<V, Constant>(value: Constant) -> DataFrame<Key, Constant> where Value == DataSeries<V> {
        return mapValues {  $0.mapToConstant(value: value)  }
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

func + <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                         rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "DataFrame keys mismatch")
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 + $1 }
    }

    return res
}

func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                         rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "DataFrame keys mismatch")
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 - $1 }
    }

    return res
}

func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                         rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "DataFrame keys mismatch")
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 * $1 }
    }

    return res
}

func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                               rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "DataFrame keys mismatch")
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 / $1 }
    }

    return res
}
