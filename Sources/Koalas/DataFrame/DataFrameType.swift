//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

public enum DataFrameType<DF, V> {
    case df(DF?)
    case value(V?)

    func toDataframeWithShape<Key, T>(of dataframe: DataFrame<Key, T>) -> DataFrame<Key, V>? where DF == DataFrame<Key, V> {
        switch self {
        case .df(let df):
            return df
        case .value(let scalarValue):
            return dataframe.mapValues { DataSeries($0.map { _ in return scalarValue }) }
        }
    }
}
