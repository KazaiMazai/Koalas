//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V: Codable> = Dictionary<K, DataSeries<V>>

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

public extension DataFrame {
    func flatMapValues<V, U>(transform: (V?) -> U?) -> DataFrame<Key, U> where Value == DataSeries<V> {
        return mapValues { series in DataSeries(series.map { transform($0) }) }
    }

    func mapTo<V, Constant>(constant value: Constant) -> DataFrame<Key, Constant> where Value == DataSeries<V> {
        return mapValues {  $0.mapTo(constant: value)  }
    }

    func mapTo<V, U>(series value: DataSeries<U>?) -> DataFrame<Key, U>? where Value == DataSeries<V> {
        guard let value = value else {
            return nil
        }
        
        return mapValues {
            assert($0.count == value.count, "DataSeries should have equal length")
            return value
        }
    }

    func shiftedBy<V>(_ amount: Int) -> DataFrame<Key, V> where Value == DataSeries<V> {
        return mapValues { $0.shiftedBy(amount) }
    }

    func cumulativeSum<V>(initial: V) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        return mapValues { $0.cumulativeSum(initial: initial) }
    }

    func rollingFunc<V>(initial: V, window: Int, windowFunc: (([V?]) -> V?)) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingFunc(initial: initial, window: window, windowFunc: windowFunc)}
    }

    func rollingSum<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingSum(window: window) }
    }

    func rollingMean<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint  {
        return mapValues { $0.rollingMean(window: window) }
    }
}

public func whereCondition<Key, T>(_ condition: DataFrame<Key, Bool>?,
                                   then trueDF: DataFrameType<DataFrame<Key, T>, T>,
                                   else df: DataFrameType<DataFrame<Key, T>, T>) -> DataFrame<Key, T>? {
    guard let condition = condition else {
        return nil
    }

    guard let trueDF = trueDF.toDataframeWithShape(of: condition) else {
        return nil
    }

    guard let falseDF = df.toDataframeWithShape(of: condition) else {
        return nil
    }

    return whereCondition(condition, then: trueDF, else: falseDF)
}

public func whereCondition<Key, T>(_ condition: DataFrame<Key, Bool>?,
                                   then trueDataFrame: DataFrame<Key, T>?,
                                   else dataframe: DataFrame<Key, T>?) -> DataFrame<Key, T>? {

    guard let condition = condition,
        let trueDataFrame = trueDataFrame,
        let dataframe = dataframe
    else {
            return nil
    }

    let keysSet = Set(condition.keys)
    assert(keysSet == Set(trueDataFrame.keys), "Dataframes should have equal keys sets")
    assert(keysSet == Set(dataframe.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    keysSet.forEach { key in
        res[key] = compactMapValues(condition[key],
                                    trueDataFrame[key],
                                    dataframe[key]) { return whereCondition($0, then: $1, else: $2)  }
    }

    return res
}


public func + <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")
    
    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 + $1 }
    }

    return res
}

public func == <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                 rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 == $1 }
    }

    return res
}

public func != <Key, T: Equatable>(lhs: DataFrame<Key,T>,
                                 rhs: DataFrame<Key,T>) -> DataFrame<Key, Bool> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key, Bool>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 != $1 }
    }

    return res
}

public func - <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 - $1 }
    }

    return res
}

public func * <Key, T: Numeric>(lhs: DataFrame<Key,T>,
                                rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {

    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 * $1 }
    }

    return res
}

public func / <Key, T: FloatingPoint>(lhs: DataFrame<Key,T>,
                                      rhs: DataFrame<Key,T>) -> DataFrame<Key,T> {
    assert(Set(lhs.keys) == Set(rhs.keys), "Dataframes should have equal keys sets")

    var res = DataFrame<Key,T>()

    lhs.forEach {
        res[$0.key] = compactMapValues(lhs: $0.value, rhs: rhs[$0.key]) { $0 / $1 }
    }

    return res
}


public extension DataFrame {
    func shape<V>() -> (width: Int, height: Int) where Value == DataSeries<V> {
        return (self.keys.count, self.values.first?.count ?? 0)
    }

    func sum<V>(ignoreNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        mapValues { DataSeries([$0.sum(ignoreNils: ignoreNils)]) }
    }

    func columnSum<V>(ignoreNils: Bool = true) -> DataSeries<V>? where Value == DataSeries<V>, V: Numeric {
        guard let first = values.first else {
            return nil
        }

        let initial = DataSeries<V>(repeating: 0, count: first.count)

        return values.reduce(initial) { (currentRes: DataSeries<V>, next: DataSeries<V>) -> DataSeries<V> in
            let nextSeries: DataSeries<V> = ignoreNils ? next.fillNils(with: 0) : next
            return currentRes + nextSeries
        }
    }

    func mean<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.mean(shouldSkipNils: shouldSkipNils)]) }
    }

    func std<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.std(shouldSkipNils: shouldSkipNils)]) }
    }

    func fillNils<V>(method: FillNilsMethod<V?>) -> DataFrame<Key, V> where Value == DataSeries<V> {
        mapValues { $0.fillNils(method: method) }
    }
}

public func != <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    return compactMapValues(lhs: lhs, rhs: rhs) { $0 != $1 }
}

public func == <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key, Bool>? where T: Equatable {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 == $1 }
}

public func + <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 + $1 }
}

public func - <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 - $1 }
}

public func * <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>? where T: Numeric {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 * $1 }
}

public func / <Key, T>(lhs: DataFrame<Key,T>?,
                       rhs: DataFrame<Key,T>?) -> DataFrame<Key,T>?  where T: FloatingPoint {
    compactMapValues(lhs: lhs, rhs: rhs) { $0 / $1 }
}


extension DataFrame {
    public func toString<V>(separator: String) -> String where Value == DataSeries<V>, V: LosslessStringConvertible, Key: LosslessStringConvertible {

        var resultString = keys.map { String($0) }.joined(separator: separator)

        let height = shape().height
        for idx in 0..<height {
            let lineArr: [String] = values.map { series in series[idx].map { String($0) } ?? "nil" }
            let line = lineArr.joined(separator: separator)
            resultString.append("\n\(line)")
        }

        return resultString
    }
}
