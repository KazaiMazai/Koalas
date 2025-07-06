//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

/**
 Safely unwraps two optional values and applies a transformation function.
 Returns nil if either value is nil, otherwise applies the map function to the unwrapped values.
 */
public func unwrap<T, U>(_ lhs: T?, _ rhs: T?, map: (T, T) -> U) -> U? {
    guard let lhs = lhs, let rhs = rhs else {
        return nil
    }

    return map(lhs, rhs)
}

/**
 Safely unwraps two optional values of different types and applies a transformation function.
 Returns nil if either value is nil, otherwise applies the map function to the unwrapped values.
 */
public func unwrap<T, U, V>(_ lhs: T?, _ rhs: U?, map: (T, U) -> V?) -> V? {
    guard let lhs = lhs, let rhs = rhs else {
        return nil
    }

    return map(lhs, rhs)
}

/**
 Safely unwraps three optional values and applies a transformation function.
 Returns nil if any value is nil, otherwise applies the map function to the unwrapped values.
 */
public func unwrap<T, U, V, S>(_ t: T?, _ u: U?, _ v: V?, map: (T, U, V) -> S?) -> S? {
    guard let t = t, let u = u, let v = v else {
        return nil
    }

    return map(t, u, v)
}

/**
 Safely unwraps a single optional value and applies a transformation function.
 Returns nil if the value is nil, otherwise applies the map function to the unwrapped value.
 */
public func unwrap<T, U>(value: T?, map: (T) -> U?) -> U? {
    guard let value = value else {
        return nil
    }

    return map(value)
}
