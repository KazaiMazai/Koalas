//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 11.06.2020.
//

import Foundation

public enum FillNilsMethod<T> {
    case all(value: T)
    case backward(initial: T)
    case forward(initial: T)
}
