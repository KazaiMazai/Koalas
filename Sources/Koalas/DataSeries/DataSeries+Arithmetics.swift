//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public func + <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 + $1 }
}

public func - <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 - $1 }
}

public func * <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 * $1 }
}

public func / <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<T>?  where T: FloatingPoint {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 / $1 }
}

public func != <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 != $1 }
}

public func == <T>(lhs: DataSeries<T>?, rhs: DataSeries<T>?) -> DataSeries<Bool>? where T: Equatable {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 == $1 }
}

public func + <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 + $1 }
    }

    return DataSeries(res)
}

public func != <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 != $1 }
    }

    return DataSeries(res)
}

public func == <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<Bool>  where T: Equatable {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 == $1 }
    }

    return DataSeries(res)
}

public func - <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 - $1 }
    }

    return DataSeries(res)
}

public func * <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: Numeric {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 * $1 }
    }

    return DataSeries(res)
}

public func / <T>(lhs: DataSeries<T>, rhs: DataSeries<T>) -> DataSeries<T>  where T: FloatingPoint {
    assert(lhs.count == rhs.count, "Dataseries should have equal length")

    let res = zip(lhs, rhs).map {
        compactMapValues(lhs: $0.0, rhs: $0.1) { $0 / $1 }
    }

    return DataSeries(res)
}
