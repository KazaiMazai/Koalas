//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

/**
 Performs element-wise inequality comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where elements are not equal.
 */
public func != <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    return unwrap(lhs, rhs) { $0 != $1 }
}

/**
 Performs element-wise equality comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where elements are equal.
 */
public func == <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

/**
 Performs element-wise inequality comparison between a DataFrame and a scalar value.
 Returns a DataFrame of boolean values indicating where elements are not equal to the scalar.
 */
public func != <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Equatable {
    return unwrap(lhs, rhs) { $0 != $1 }
}

/**
 Performs element-wise equality comparison between a DataFrame and a scalar value.
 Returns a DataFrame of boolean values indicating where elements are equal to the scalar.
 */
public func == <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

/**
 Performs element-wise greater than or equal comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where left elements are >= right elements.
 */
public func >= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 >= $1 }
}

/**
 Performs element-wise greater than comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where left elements are > right elements.
 */
public func > <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

/**
 Performs element-wise less than comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where left elements are < right elements.
 */
public func < <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 < $1 }
}

/**
 Performs element-wise less than or equal comparison between two DataFrames.
 Returns a DataFrame of boolean values indicating where left elements are <= right elements.
 */
public func <= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

/**
 Performs element-wise greater than or equal comparison between a DataFrame and a scalar.
 Returns a DataFrame of boolean values indicating where elements are >= the scalar.
 */
public func >= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 >= $1 }
}

/**
 Performs element-wise greater than comparison between a DataFrame and a scalar.
 Returns a DataFrame of boolean values indicating where elements are > the scalar.
 */
public func > <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

/**
 Performs element-wise less than comparison between a DataFrame and a scalar.
 Returns a DataFrame of boolean values indicating where elements are < the scalar.
 */
public func < <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable  {
    unwrap(lhs, rhs) { $0 < $1 }
}

/**
 Performs element-wise less than or equal comparison between a DataFrame and a scalar.
 Returns a DataFrame of boolean values indicating where elements are <= the scalar.
 */
public func <= <Key, T>(lhs: DataFrame<Key,T>?,
                        rhs: T?) -> DataFrame<Key, Bool>? where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

/**
 Performs element-wise addition between two DataFrames.
 Returns a DataFrame with the sum of corresponding elements.
 */
public func + <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

/**
 Performs element-wise subtraction between two DataFrames.
 Returns a DataFrame with the difference of corresponding elements.
 */
public func - <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

/**
 Performs element-wise multiplication between two DataFrames.
 Returns a DataFrame with the product of corresponding elements.
 */
public func * <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

/**
 Performs element-wise division between two DataFrames.
 Returns a DataFrame with the quotient of corresponding elements.
 */
public func / <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>?  where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}

/**
 Performs element-wise logical OR between two boolean DataFrames.
 Returns a DataFrame with the logical OR of corresponding boolean elements.
 */
public func || <Key>(lhs: DataFrame<Key, Bool>?,
                     rhs: DataFrame<Key, Bool>?) -> DataFrame<Key, Bool>? {
    unwrap(lhs, rhs) { $0 || $1 }
}

/**
 Performs element-wise logical AND between two boolean DataFrames.
 Returns a DataFrame with the logical AND of corresponding boolean elements.
 */
public func && <Key>(lhs: DataFrame<Key, Bool>?,
                     rhs: DataFrame<Key, Bool>?) -> DataFrame<Key, Bool>? {
    unwrap(lhs, rhs) { $0 && $1 }
}

/**
 Performs element-wise addition between two DataFrames.
 Asserts that both DataFrames have the same keys and returns the sum of corresponding elements.
 */
public func + <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 + $1 }
    }

    return res
}

/**
 Performs element-wise subtraction between two DataFrames.
 Asserts that both DataFrames have the same keys and returns the difference of corresponding elements.
 */
public func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 - $1 }
    }

    return res
}

/**
 Performs element-wise multiplication between two DataFrames.
 Asserts that both DataFrames have the same keys and returns the product of corresponding elements.
 */
public func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 * $1 }
    }

    return res
}

/**
 Performs element-wise division between two DataFrames.
 Asserts that both DataFrames have the same keys and returns the quotient of corresponding elements.
 */
public func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                                      rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {
    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 / $1 }
    }

    return res
}

/**
 Performs element-wise equality comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values indicating equality.
 */
public func == <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 == $1 }
    }

    return res
}

/**
 Performs element-wise inequality comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values indicating inequality.
 */
public func != <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                   rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 != $1 }
    }

    return res
}

/**
 Performs element-wise greater than or equal comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for >= comparison.
 */
public func >= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 >= $1 }
    }

    return res
}

/**
 Performs element-wise greater than comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for > comparison.
 */
public func > <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 > $1 }
    }

    return res
}

/**
 Performs element-wise less than or equal comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for <= comparison.
 */
public func <= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 <= $1 }
    }

    return res
}

/**
 Performs element-wise less than comparison between two DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for < comparison.
 */
public func < <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool>  where T: Comparable {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 < $1 }
    }

    return res
}

/**
 Performs element-wise less than comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func < <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs < rhsConst
}

/**
 Performs element-wise less than or equal comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func <= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs <= rhsConst
}

/**
 Performs element-wise greater than comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func > <Key, T>(lhs: DataFrame<Key,T>,
                       rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs > rhsConst
}

/**
 Performs element-wise greater than or equal comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func >= <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Comparable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs >= rhsConst
}

/**
 Performs element-wise equality comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func == <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Equatable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs == rhsConst
}

/**
 Performs element-wise inequality comparison between a DataFrame and a scalar value.
 Converts the scalar to a DataFrame and performs the comparison.
 */
public func != <Key, T>(lhs: DataFrame<Key,T>,
                        rhs: T) -> DataFrame<Key, Bool> where T: Equatable  {

    let rhsConst = lhs.mapTo(constant: rhs)
    return lhs != rhsConst
}

/**
 Performs element-wise logical AND between two boolean DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for logical AND.
 */
public func && <Key>(lhs: DataFrame<Key, Bool>,
                       rhs: DataFrame<Key, Bool>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 && $1 }
    }

    return res
}

/**
 Performs element-wise logical OR between two boolean DataFrames.
 Asserts that both DataFrames have the same keys and returns boolean values for logical OR.
 */
public func || <Key>(lhs: DataFrame<Key, Bool>,
                       rhs: DataFrame<Key, Bool>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = unwrap($0.value, rhs[$0.key]) { $0 || $1 }
    }

    return res
}
