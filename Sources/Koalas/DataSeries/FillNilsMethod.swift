//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 11.06.2020.
//

import Foundation

/**
 Defines methods for filling nil values in DataSeries.
 Provides different strategies for handling missing data in time series or sequential data.
 
 - all: Fills all nil values with a constant value. Replaces every nil element with the specified value regardless of position.
 
 - backward: Fills nil values using backward fill strategy. 
 Propagates the last known value backward to fill preceding nil values. Uses the specified initial value for the first nil values encountered.
 
 - forward: Fills nil values using forward fill strategy. 
 Propagates the last known value forward to fill succeeding nil values. Uses the specified initial value for the first nil values encountered.
 */
public enum FillNilsMethod<T> {
    case all(value: T)
    case backward(initial: T)
    case forward(initial: T)
}
