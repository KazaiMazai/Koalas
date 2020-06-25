//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public func compactMapValues<T, U>(lhs: T?, rhs: T?, map: (T, T) -> U) -> U? {
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
