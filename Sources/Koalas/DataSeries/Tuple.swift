//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 03.07.2020.
//

import Foundation

public struct Tuple3<T1: Codable, T2: Codable, T3: Codable>: Codable {
    let t1: T1
    let t2: T2
    let t3: T3
}

public struct Tuple2<T1: Codable, T2: Codable>: Codable {
    let t1: T1
    let t2: T2
}
