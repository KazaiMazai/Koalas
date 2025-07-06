//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

/**
 A SeriesArray of optional values that can be encoded and decoded using Codable.
 Used to store and manipulate 1D tabular data with optional values.
 */
public typealias DataSeries<T: Codable> = SeriesArray<T?>

/**
 Applies a conditional operation to DataSeries based on a boolean condition.
 Returns the true DataSeries where condition is true, false DataSeries where condition is false.
 Handles DataSeriesType which can be either a DataSeries or a scalar value.
 */
public func whereCondition<U>(_ condition: DataSeries<Bool>?,
                              then trueSeries: DataSeriesType<DataSeries<U>, U>,
                              else series: DataSeriesType<DataSeries<U>, U>) -> DataSeries<U>? {

    guard let condition = condition else {
        return nil
    }

    guard let trueDS = trueSeries.toDataSeriesWithShape(of: condition) else {
        return nil
    }

    guard let falseDS = series.toDataSeriesWithShape(of: condition) else {
        return nil
    }

    return whereCondition(condition, then: trueDS, else: falseDS)
}

/**
 Applies a conditional operation to DataSeries based on a boolean condition.
 Returns the true DataSeries where condition is true, false DataSeries where condition is false.
 */
public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>?   {
    return condition?.whereTrue(then: trueSeries, else: series)
}

/**
 Applies a conditional operation to DataSeries based on a boolean condition.
 Returns a DataSeries with trueValue where condition is true, value where condition is false.
 */
public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueValue: U, else value: U) -> DataSeries<U>?   {
    guard let condition = condition else {
        return nil
    }

    let trueSeries = condition.mapTo(constant: trueValue)
    let falseSeries = condition.mapTo(constant: value)

    return condition.whereTrue(then: trueSeries, else: falseSeries)
}

/**
 Combines three DataSeries into a single DataSeries of tuples.
 Returns nil if any of the input series are nil or have different lengths.
 Each element in the result is a Tuple3 containing corresponding elements from the input series.
 */
public func zipSeries<T1, T2, T3>(_ s1: DataSeries<T1>?, _ s2: DataSeries<T2>?, _ s3: DataSeries<T3>?) -> DataSeries<Tuple3<T1?, T2?, T3?>>? {
    guard let s1 = s1,
        let s2 = s2,
        let s3 = s3
    else {
        return nil
    }

    assert(s1.count == s2.count, "Dataseries should have equal length")
    assert(s1.count == s3.count, "Dataseries should have equal length")

    let result = zip(s1, zip(s2, s3)).map { Tuple3(t1: $0.0, t2: $0.1.0, t3: $0.1.1) }
    return DataSeries(result)
}

/**
 Combines four DataSeries into a single DataSeries of tuples.
 Returns nil if any of the input series are nil or have different lengths.
 Each element in the result is a Tuple4 containing corresponding elements from the input series.
 */
public func zipSeries<T1, T2, T3, T4>(_ s1: DataSeries<T1>?, _ s2: DataSeries<T2>?, _ s3: DataSeries<T3>?, _ s4: DataSeries<T4>?) -> DataSeries<Tuple4<T1?, T2?, T3?, T4?>>? {
    guard let s1 = s1,
        let s2 = s2,
        let s3 = s3,
        let s4 = s4
    else {
        return nil
    }

    assert(s1.count == s2.count, "Dataseries should have equal length")
    assert(s1.count == s3.count, "Dataseries should have equal length")
    assert(s1.count == s4.count, "Dataseries should have equal length")


    let result = zip(zip(s1, s2), zip(s3, s4)).map { Tuple4(t1: $0.0.0, t2: $0.0.1, t3: $0.1.0, t4: $0.1.1) }
    return DataSeries(result)
}

/**
 Combines two DataSeries into a single DataSeries of tuples.
 Returns nil if any of the input series are nil or have different lengths.
 Each element in the result is a Tuple2 containing corresponding elements from the input series.
 */
public func zipSeries<T1, T2>(_ s1: DataSeries<T1>?, _ s2: DataSeries<T2>?) -> DataSeries<Tuple2<T1?, T2?>>? {
    guard let s1 = s1,
        let s2 = s2
    else {
        return nil
    }

    assert(s1.count == s2.count, "Dataseries should have equal length")

    let result = zip(s1, s2).map { Tuple2(t1: $0.0, t2: $0.1) }
    return DataSeries(result)
}
