//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation


public func + <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

public func - <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

public func * <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

public func / <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}

public func != <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 != $1 }
}

public func == <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

public func == <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 == $1 }
}

public func != <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 != $1 }
}

public func < <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 < $1 }
}

public func <= <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

public func > <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

public func >= <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 >= $1 }
}

public func < <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 < $1 }
}

public func <= <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

public func > <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

public func >= <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 >= $1 }
}

public func && (lhs: DataSeries<Bool>?, rhs: DataSeries<Bool>?) -> DataSeries<Bool>? {
    unwrap(lhs, rhs) { $0 && $1 }
}

public func || (lhs: DataSeries<Bool>?, rhs: DataSeries<Bool>?) -> DataSeries<Bool>? {
    unwrap(lhs, rhs) { $0 || $1 }
}

public func + <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 + $1 }
    }

    return DataSeries(res)
}

public func - <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 - $1 }
    }

    return DataSeries(res)
}

public func * <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 * $1 }
    }

    return DataSeries(res)
}

public func / <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: FloatingPoint {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 / $1 }
    }

    return DataSeries(res)
}


public func < <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 < $1 }
    }

    return DataSeries(res)
}

public func <= <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 <= $1 }
    }

    return DataSeries(res)
}

public func > <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 > $1 }
    }

    return DataSeries(res)
}

public func >= <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 >= $1 }
    }

    return DataSeries(res)
}

public func != <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 != $1 }
    }

    return DataSeries(res)
}

public func == <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 == $1 }
    }

    return DataSeries(res)
}

public func == <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs == lhs.mapTo(constant: rhs)
}

public func != <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs != lhs.mapTo(constant: rhs)
}

public func < <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs < lhs.mapTo(constant: rhs)
}

public func <= <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs <= lhs.mapTo(constant: rhs)
}

public func > <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs > lhs.mapTo(constant: rhs)
}

public func >= <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs >= lhs.mapTo(constant: rhs)
}

public func + <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs + lhs.mapTo(constant: rhs)
}

public func - <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs - lhs.mapTo(constant: rhs)
}

public func * <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs * lhs.mapTo(constant: rhs)
}

public func / <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: FloatingPoint {
    return lhs / lhs.mapTo(constant: rhs)
}

public func - <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

public func + <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

public func * <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

public func / <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}



public func && (lhs: DataSeries<Bool>, rhs: DataSeries<Bool>) -> DataSeries<Bool> {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 && $1 }
    }

    return DataSeries(res)
}

public func || (lhs: DataSeries<Bool>, rhs: DataSeries<Bool>) -> DataSeries<Bool> {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 || $1 }
    }

    return DataSeries(res)
}
