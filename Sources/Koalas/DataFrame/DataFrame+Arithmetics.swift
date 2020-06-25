//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public func != <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    return compactMapValues(lhs: lhs, rhs: rhs) { $0 != $1 }
}

public func == <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 == $1 }
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
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 + $1 }
    }

    return res
}

public func == <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 == $1 }
    }

    return res
}

public func != <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 != $1 }
    }

    return res
}

public func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 - $1 }
    }

    return res
}

public func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 * $1 }
    }

    return res
}

public func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                                      rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {
    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 / $1 }
    }

    return res
}