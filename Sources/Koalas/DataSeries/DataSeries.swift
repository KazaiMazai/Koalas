//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataSeries<T: Codable> = SeriesArray<T?>





public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueSeries: DataSeries<U>?, else series: DataSeries<U>?) -> DataSeries<U>?   {
    return condition?.whereTrue(then: trueSeries, else: series)
}

public func whereCondition<U>(_ condition: DataSeries<Bool>?, then trueValue: U, else value: U) -> DataSeries<U>?   {
    guard let condition = condition else {
        return nil
    }

    let trueSeries = condition.mapTo(constant: trueValue)
    let falseSeries = condition.mapTo(constant: value)

    return condition.whereTrue(then: trueSeries, else: falseSeries)
}

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
