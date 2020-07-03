//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 03.07.2020.
//

import Foundation

public struct Tuple3<T1: Codable, T2: Codable, T3: Codable>: Codable {
    public let t1: T1
    public let t2: T2
    public let t3: T3
}

public struct Tuple2<T1: Codable, T2: Codable>: Codable {
    public let t1: T1
    public let t2: T2
}
