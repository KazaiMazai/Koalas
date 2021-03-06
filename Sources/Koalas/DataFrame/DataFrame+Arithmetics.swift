//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public func != <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    return unwrap(lhs, rhs) { $0 != $1 }
}

public func == <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

public func != <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Equatable {
    return unwrap(lhs, rhs) { $0 != $1 }
}

public func == <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

public func >= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 >= $1 }
}

public func > <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

public func < <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 < $1 }
}

public func <= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

public func >= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 >= $1 }
}

public func > <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

public func < <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 < $1 }
}

public func <= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

public func + <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

public func - <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

public func * <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

public func / <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>?  where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}

public func || <Key>(lhs: DataFrame<Key, Bool>?,
                     rhs: DataFrame<Key, Bool>?) -> DataFrame<Key, Bool>? {
    unwrap(lhs, rhs) { $0 || $1 }
}

public func && <Key>(lhs: DataFrame<Key, Bool>?,
                     rhs: DataFrame<Key, Bool>?) -> DataFrame<Key, Bool>? {
    unwrap(lhs, rhs) { $0 && $1 }
}


public func + <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 + $1 }
    }

    return res
}

public func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 - $1 }
    }

    return res
}

public func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 * $1 }
    }

    return res
}

public func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                                      rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {
    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 / $1 }
    }

    return res
}

public func == <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 == $1 }
    }

    return res
}

public func != <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 != $1 }
    }

    return res
}

public func >= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 >= $1 }
    }

    return res
}

public func > <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 > $1 }
    }

    return res
}

public func <= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 <= $1 }
    }

    return res
}

public func < <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool>  where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 < $1 }
    }

    return res
}

public func < <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs < rhsConst
}

public func <= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs <= rhsConst
}

public func > <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs > rhsConst
}

public func >= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs >= rhsConst
}

public func == <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Equatable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs == rhsConst
}

public func != <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Equatable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs != rhsConst
}


public func && <Key>(lhs: DataFrame<Key, Bool>,
                       rhs: DataFrame<Key, Bool>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 && $1 }
    }

    return res
}

public func || <Key>(lhs: DataFrame<Key, Bool>,
                       rhs: DataFrame<Key, Bool>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 || $1 }
    }

    return res
}
