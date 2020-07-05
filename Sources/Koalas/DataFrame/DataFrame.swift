//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V: Codable> = Dictionary<K, DataSeries<V>>

public extension DataFrame {
    init<S, V>(uniqueKeysWithSeries keysAndValues: S)
        where
        S: Sequence,
        S.Element == (Key, DataSeries<V>),
        Value == DataSeries<V> {

            let firstDataSeriesCount = keysAndValues.first(where: { _ in true })?.1.count ?? 0
           
            let allSeriesCountsAreEqual = keysAndValues.allSatisfy { $0.1.count == firstDataSeriesCount }

            assert(allSeriesCountsAreEqual, "DataSeries should have equal length")
            self = Dictionary<Key, DataSeries<V>>(uniqueKeysWithValues: keysAndValues)
    }
}

public extension DataFrame {
    func upscaleTransform<V, U, Key2>(transform: (DataSeries<V>) -> DataFrame<Key2, U>) -> DataPanel<Key2, Key, U> where Value == DataSeries<V> {

        let keyValues = map { ($0.key, transform($0.value)) }
        let dataPanel = DataPanel<Key, Key2, U>(uniqueKeysWithValues: keyValues)

        return dataPanel.transposed()
    }

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

    func scan<T, V>(initial: T?, _ nextPartialResult: (T?, V?) -> T?) -> DataFrame<Key, T> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.scanSeries(initial: initial, nextPartialResult) }
    }

    func shiftedBy<V>(_ amount: Int) -> DataFrame<Key, V> where Value == DataSeries<V> {
        return mapValues { $0.shiftedBy(amount) }
    }

    func expandingSum<V>(initial: V) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        return mapValues { $0.expandingSum(initial: initial) }
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


    func equalsTo<V>(dataframe: DataFrame<Key, V>?) -> Bool where Value == DataSeries<V>, V: Equatable {
        guard let dataframe = dataframe else {
            return false
        }
        
        guard Set(self.keys) == Set(dataframe.keys) else {
            return false
        }

        return self.first { !$0.value.equalsTo(series: dataframe[$0.key]) } == nil
    }

    func equalsTo<V>(dataframe: DataFrame<Key, V>?, with precision: V) -> Bool where Value == DataSeries<V>, V: FloatingPoint {
        guard let dataframe = dataframe else {
            return false
        }

        guard Set(self.keys) == Set(dataframe.keys) else {
            return false
        }

        return self.first { !$0.value.equalsTo(series: dataframe[$0.key], with: precision) } == nil
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
        res[key] = unwrap(condition[key],
                          trueDataFrame[key],
                          dataframe[key]) { return whereCondition($0, then: $1, else: $2)  }
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
