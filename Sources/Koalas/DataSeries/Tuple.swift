//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 03.07.2020.
//

import Foundation

public struct Tuple2<T1: Codable, T2: Codable>: Codable {
    public let t1: T1
    public let t2: T2

    public init(t1: T1, t2: T2) {
        self.t1 = t1
        self.t2 = t2
    }
}

public struct Tuple3<T1: Codable, T2: Codable, T3: Codable>: Codable {
    public let t1: T1
    public let t2: T2
    public let t3: T3

    public init(t1: T1, t2: T2, t3: T3) {
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
}

public struct Tuple4<T1: Codable, T2: Codable, T3: Codable, T4: Codable>: Codable {
    public let t1: T1
    public let t2: T2
    public let t3: T3
    public let t4: T4

    public init(t1: T1, t2: T2, t3: T3, t4: T4) {
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
}
