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

