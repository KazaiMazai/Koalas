//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.07.2020.
//

import Foundation

/**
 A type that can represent either a DataSeries or a scalar value.
 Used for conditional operations where the result can be either a full DataSeries
 or a constant value applied across all elements.
 */
public enum DataSeriesType<DS, V> {
    case ds(DS?)
    case value(V?)

    /**
     Converts this DataSeriesType to a DataSeries with the same shape as the reference series.
     If this is a scalar value, it creates a DataSeries filled with that value.
     If this is already a DataSeries, it returns it directly.
     */
    func toDataSeriesWithShape<T>(of series: DataSeries<T>) -> DataSeries<V>? where DS == DataSeries<V> {
        switch self {
        case .ds(let dataSeries):
            return dataSeries
        case .value(let scalarValue):
            return DataSeries(series.map { _ in return scalarValue })
        }
    }
}
