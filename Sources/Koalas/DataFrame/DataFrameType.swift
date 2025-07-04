//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.06.2020.
//

import Foundation

/**
 A type that can represent either a DataFrame or a scalar value.
 Used for conditional operations where the result can be either a full DataFrame
 or a constant value applied across all elements.
 */
public enum DataFrameType<DF, V> {
    case df(DF?)
    case value(V?)

    /**
     Converts this DataFrameType to a DataFrame with the same shape as the reference DataFrame.
     If this is a scalar value, it creates a DataFrame filled with that value.
     If this is already a DataFrame, it returns it directly.
     */
    func toDataframeWithShape<Key, T>(of dataframe: DataFrame<Key, T>) -> DataFrame<Key, V>? where DF == DataFrame<Key, V> {
        switch self {
        case .df(let df):
            return df
        case .value(let scalarValue):
            return dataframe.mapValues { DataSeries($0.map { _ in return scalarValue }) }
        }
    }
}
