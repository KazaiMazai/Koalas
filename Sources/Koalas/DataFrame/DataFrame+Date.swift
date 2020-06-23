//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

public extension DataFrame where Value == DataSeries<Date>  {
    func toDateComponents() -> DataPanel<DateComponentsKeys, Key, Int> {
        return upscaleTransform { $0.toDateComponents() }
    }
}


