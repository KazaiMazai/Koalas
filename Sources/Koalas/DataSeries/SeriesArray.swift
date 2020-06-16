//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06.06.2020.
//

import Foundation

public struct SeriesArray<T: Codable>: RangeReplaceableCollection, Codable {

    public typealias Element = T
    public typealias Index = Int
    public typealias SubSequence = SeriesArray<T>
    public typealias Indices = Range<Int>
    fileprivate var array: Array<T>

    public var startIndex: Int { return array.startIndex }
    public var endIndex: Int { return array.endIndex }
    public var indices: Range<Int> { return array.indices }


    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }

    public init() { array = [] }
}

// Instance Methods

public extension SeriesArray {

    init<S>(_ elements: S) where S : Sequence, SeriesArray.Element == S.Element {
        array = Array<S.Element>(elements)
    }

    init(repeating repeatedValue: SeriesArray.Element, count: Int) {
        array = Array(repeating: repeatedValue, count: count)
    }
}

// Instance Methods

public extension SeriesArray {

    mutating func append(_ newElement: SeriesArray.Element) {
        array.append(newElement)
    }

    mutating func append<S>(contentsOf newElements: S) where S : Sequence, SeriesArray.Element == S.Element {
        array.append(contentsOf: newElements)
    }

    func filter(_ isIncluded: (SeriesArray.Element) throws -> Bool) rethrows -> SeriesArray {
        let subArray = try array.filter(isIncluded)
        return SeriesArray(subArray)
    }

    mutating func insert(_ newElement: SeriesArray.Element, at i: SeriesArray.Index) {
        array.insert(newElement, at: i)
    }

    mutating func insert<S>(contentsOf newElements: S, at i: SeriesArray.Index) where S : Collection, SeriesArray.Element == S.Element {
        array.insert(contentsOf: newElements, at: i)
    }

    mutating func popLast() -> SeriesArray.Element? {
        return array.popLast()
    }

    @discardableResult mutating func remove(at i: SeriesArray.Index) -> SeriesArray.Element {
        return array.remove(at: i)
    }

    mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        array.removeAll()
    }

    mutating func removeAll(where shouldBeRemoved: (SeriesArray.Element) throws -> Bool) rethrows {
        try array.removeAll(where: shouldBeRemoved)
    }

    @discardableResult mutating func removeFirst() -> SeriesArray.Element {
        return array.removeFirst()
    }

    mutating func removeFirst(_ k: Int) {
        array.removeFirst(k)
    }

    @discardableResult mutating func removeLast() -> SeriesArray.Element {
        return array.removeLast()
    }

    mutating func removeLast(_ k: Int) {
        array.removeLast(k)
    }

    mutating func removeSubrange(_ bounds: Range<Int>) {
        array.removeSubrange(bounds)
    }

    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, T == C.Element, SeriesArray<T>.Index == R.Bound {
        array.replaceSubrange(subrange, with: newElements)
    }

    mutating func reserveCapacity(_ n: Int) {
        array.reserveCapacity(n)
    }
}

// Subscripts

public extension SeriesArray {

    subscript(bounds: Range<SeriesArray.Index>) -> SeriesArray.SubSequence {
        get { return SeriesArray(array[bounds]) }
    }

    subscript(bounds: SeriesArray.Index) -> SeriesArray.Element {
        get { return array[bounds] }
        set(value) { array[bounds] = value }
    }
}

extension SeriesArray: CustomStringConvertible {
    public var description: String { return "\(array)" }
}
