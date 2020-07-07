//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.07.2020.
//

import Foundation

public enum DataSeriesType<DS, V> {
    case ds(DS?)
    case value(V?)

    func toDataSeriesWithShape<T>(of series: DataSeries<T>) -> DataSeries<V>? where DS == DataSeries<V> {
        switch self {
        case .ds(let dataSeries):
            return dataSeries
        case .value(let scalarValue):
            return DataSeries(series.map { _ in return scalarValue })
        }
    }
}
