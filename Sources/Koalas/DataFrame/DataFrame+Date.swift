//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

public extension DataFrame where Value == DataSeries<Date>  {
    /**
     Converts a DataFrame containing Date DataSeries into a DataPanel with DateComponents.
     Extracts individual date components (year, month, day, hour, minute, second, etc.) 
     from each date series and organizes them into a structured panel format.
     */
    func toDateComponents() -> DataPanel<DateComponentsKeys, Key, Int> {
        return upscaleTransform { $0.toDateComponents() }
    }
}


