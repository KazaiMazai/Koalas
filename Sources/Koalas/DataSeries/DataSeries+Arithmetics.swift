//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

/**
 Performs element-wise addition between two optional DataSeries.
 Returns nil if either series is nil.
 */
public func + <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

/**
 Performs element-wise subtraction between two optional DataSeries.
 Returns nil if either series is nil.
 */
public func - <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

/**
 Performs element-wise multiplication between two optional DataSeries.
 Returns nil if either series is nil.
 */
public func * <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

/**
 Performs element-wise division between two optional DataSeries.
 Returns nil if either series is nil.
 */
public func / <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}

/**
 Performs element-wise inequality comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where elements are not equal.
 */
public func != <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 != $1 }
}

/**
 Performs element-wise equality comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where elements are equal.
 */
public func == <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    unwrap(lhs, rhs) { $0 == $1 }
}

/**
 Performs element-wise equality comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements equal the scalar.
 */
public func == <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 == $1 }
}

/**
 Performs element-wise inequality comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements are not equal to the scalar.
 */
public func != <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 != $1 }
}

/**
 Performs element-wise less than comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where left elements are < right elements.
 */
public func < <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 < $1 }
}

/**
 Performs element-wise less than or equal comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where left elements are <= right elements.
 */
public func <= <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

/**
 Performs element-wise greater than comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where left elements are > right elements.
 */
public func > <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

/**
 Performs element-wise greater than or equal comparison between two optional DataSeries.
 Returns a boolean DataSeries indicating where left elements are >= right elements.
 */
public func >= <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 >= $1 }
}

/**
 Performs element-wise less than comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements are < the scalar.
 */
public func < <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 < $1 }
}

/**
 Performs element-wise less than or equal comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements are <= the scalar.
 */
public func <= <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 <= $1 }
}

/**
 Performs element-wise greater than comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements are > the scalar.
 */
public func > <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 > $1 }
}

/**
 Performs element-wise greater than or equal comparison between an optional DataSeries and a scalar.
 Returns a boolean DataSeries indicating where elements are >= the scalar.
 */
public func >= <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<Bool>?  where T: Comparable {
    unwrap(lhs, rhs) { $0 >= $1 }
}

/**
 Performs element-wise logical AND between two optional boolean DataSeries.
 Returns a boolean DataSeries with the logical AND of corresponding elements.
 */
public func && (lhs: DataSeries<Bool>?, rhs: DataSeries<Bool>?) -> DataSeries<Bool>? {
    unwrap(lhs, rhs) { $0 && $1 }
}

/**
 Performs element-wise logical OR between two optional boolean DataSeries.
 Returns a boolean DataSeries with the logical OR of corresponding elements.
 */
public func || (lhs: DataSeries<Bool>?, rhs: DataSeries<Bool>?) -> DataSeries<Bool>? {
    unwrap(lhs, rhs) { $0 || $1 }
}

/**
 Performs element-wise addition between two DataSeries.
 Asserts that both series have equal length and returns the sum of corresponding elements.
 */
public func + <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 + $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise subtraction between two DataSeries.
 Asserts that both series have equal length and returns the difference of corresponding elements.
 */
public func - <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 - $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise multiplication between two DataSeries.
 Asserts that both series have equal length and returns the product of corresponding elements.
 */
public func * <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 * $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise division between two DataSeries.
 Asserts that both series have equal length and returns the quotient of corresponding elements.
 */
public func / <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: FloatingPoint {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 / $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise less than comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for < comparison.
 */
public func < <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 < $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise less than or equal comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for <= comparison.
 */
public func <= <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 <= $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise greater than comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for > comparison.
 */
public func > <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 > $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise greater than or equal comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for >= comparison.
 */
public func >= <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Comparable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 >= $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise inequality comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for != comparison.
 */
public func != <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 != $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise equality comparison between two DataSeries.
 Asserts that both series have equal length and returns boolean values for == comparison.
 */
public func == <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 == $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise equality comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func == <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs == lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise inequality comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func != <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs != lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise less than comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func < <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs < lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise less than or equal comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func <= <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs <= lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise greater than comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func > <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs > lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise greater than or equal comparison between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the comparison.
 */
public func >= <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<Bool>  where T: Comparable {
    return lhs >= lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise addition between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the addition.
 */
public func + <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs + lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise subtraction between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the subtraction.
 */
public func - <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs - lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise multiplication between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the multiplication.
 */
public func * <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: Numeric {
    return lhs * lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise division between a DataSeries and a scalar.
 Converts the scalar to a DataSeries and performs the division.
 */
public func / <T>(lhs: DataSeries<T>, rhs: T) -> DataSeries<T> where T: FloatingPoint {
    return lhs / lhs.mapTo(constant: rhs)
}

/**
 Performs element-wise subtraction between an optional DataSeries and a scalar.
 Returns nil if the DataSeries is nil.
 */
public func - <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 - $1 }
}

/**
 Performs element-wise addition between an optional DataSeries and a scalar.
 Returns nil if the DataSeries is nil.
 */
public func + <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 + $1 }
}

/**
 Performs element-wise multiplication between an optional DataSeries and a scalar.
 Returns nil if the DataSeries is nil.
 */
public func * <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: Numeric {
    unwrap(lhs, rhs) { $0 * $1 }
}

/**
 Performs element-wise division between an optional DataSeries and a scalar.
 Returns nil if the DataSeries is nil.
 */
public func / <T>(lhs: DataSeries<T>?, rhs: T?) -> DataSeries<T>? where T: FloatingPoint {
    unwrap(lhs, rhs) { $0 / $1 }
}

/**
 Performs element-wise logical AND between two boolean DataSeries.
 Asserts that both series have equal length and returns boolean values for logical AND.
 */
public func && (lhs: DataSeries<Bool>, rhs: DataSeries<Bool>) -> DataSeries<Bool> {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 && $1 }
    }

    return DataSeries(res)
}

/**
 Performs element-wise logical OR between two boolean DataSeries.
 Asserts that both series have equal length and returns boolean values for logical OR.
 */
public func || (lhs: DataSeries<Bool>, rhs: DataSeries<Bool>) -> DataSeries<Bool> {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        unwrap($0.0, $0.1) { $0 || $1 }
    }

    return DataSeries(res)
}
