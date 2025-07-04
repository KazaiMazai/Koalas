//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

import Foundation

public typealias DataFrame<K: Hashable, V: Codable> = Dictionary<K, DataSeries<V>>

public extension DataFrame {
    /**
     Initializes a DataFrame with unique keys and their corresponding DataSeries.
     Ensures all DataSeries have equal length for proper DataFrame structure.
     */
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
    /**
     Transforms each DataSeries into a DataFrame and returns a transposed DataPanel.
     Useful for restructuring data from wide to long format.
     */
    func upscaleTransform<V, U, Key2>(transform: (DataSeries<V>) -> DataFrame<Key2, U>) -> DataPanel<Key2, Key, U> where Value == DataSeries<V> {

        let keyValues = map { ($0.key, transform($0.value)) }
        let dataPanel = DataPanel<Key, Key2, U>(uniqueKeysWithValues: keyValues)

        return dataPanel.transposed()
    }

    /**
     Applies a transformation function to each value in the DataFrame, handling nil values.
     Returns a new DataFrame with transformed values.
     */
    func flatMapValues<V, U>(transform: (V?) -> U?) -> DataFrame<Key, U> where Value == DataSeries<V> {
        return mapValues { series in DataSeries(series.map { transform($0) }) }
    }

    /**
     Maps all values in the DataFrame to a constant value.
     Returns a new DataFrame with the same keys but all values replaced by the constant.
     */
    func mapTo<V, Constant>(constant value: Constant) -> DataFrame<Key, Constant> where Value == DataSeries<V> {
        return mapValues {  $0.mapTo(constant: value)  }
    }

    /**
     Maps all values in the DataFrame to a single DataSeries.
     Returns nil if the provided series is nil or has different length than existing series.
     */
    func mapTo<V, U>(series value: DataSeries<U>?) -> DataFrame<Key, U>? where Value == DataSeries<V> {
        guard let value = value else {
            return nil
        }
        
        return mapValues {
            assert($0.count == value.count, "DataSeries should have equal length")
            return value
        }
    }

    /**
     Applies a scan operation to each DataSeries in the DataFrame.
     Performs cumulative operations with an initial value and transformation function.
     */
    func scan<T, V>(initial: T?, _ nextPartialResult: (T?, V?) -> T?) -> DataFrame<Key, T> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.scanSeries(initial: initial, nextPartialResult) }
    }

    /**
     Shifts all DataSeries in the DataFrame by the specified amount.
     Positive values shift forward, negative values shift backward.
     */
    func shiftedBy<V>(_ amount: Int) -> DataFrame<Key, V> where Value == DataSeries<V> {
        return mapValues { $0.shiftedBy(amount) }
    }

    /**
     Calculates expanding sum for each DataSeries in the DataFrame.
     Returns cumulative sums starting from the initial value.
     */
    func expandingSum<V>(initial: V) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        return mapValues { $0.expandingSum(initial: initial) }
    }

    /**
     Calculates expanding maximum for each DataSeries in the DataFrame.
     Returns cumulative maximum values.
     */
    func expandingMax<V>() -> DataFrame<Key, V> where Value == DataSeries<V>, V: Comparable {
        return mapValues { $0.expandingMax() }
    }

    /**
     Calculates expanding minimum for each DataSeries in the DataFrame.
     Returns cumulative minimum values.
     */
    func expandingMin<V>() -> DataFrame<Key, V> where Value == DataSeries<V>, V: Comparable {
        return mapValues { $0.expandingMin() }
    }

    /**
     Applies a rolling window function to each DataSeries in the DataFrame.
     Uses a custom window function to process values within the specified window size.
     */
    func rollingFunc<V>(initial: V, window: Int, windowFunc: (([V?]) -> V?)) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingFunc(initial: initial, window: window, windowFunc: windowFunc)}
    }

    /**
     Calculates rolling sum for each DataSeries in the DataFrame.
     Uses the specified window size for the rolling calculation.
     */
    func rollingSum<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric  {
        return mapValues { $0.rollingSum(window: window) }
    }

    /**
     Calculates rolling mean for each DataSeries in the DataFrame.
     Uses the specified window size for the rolling calculation.
     */
    func rollingMean<V>(window: Int) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint  {
        return mapValues { $0.rollingMean(window: window) }
    }

    /**
     Compares this DataFrame with another DataFrame for equality.
     Returns true if both DataFrames have the same keys and corresponding DataSeries are equal.
     */
    func equalsTo<V>(dataframe: DataFrame<Key, V>?) -> Bool where Value == DataSeries<V>, V: Equatable {
        guard let dataframe = dataframe else {
            return false
        }
        
        guard Set(self.keys) == Set(dataframe.keys) else {
            return false
        }

        return self.first { !$0.value.equalsTo(series: dataframe[$0.key]) } == nil
    }

    /**
     Compares this DataFrame with another DataFrame for equality with precision tolerance.
     Useful for floating-point comparisons where exact equality is not required.
     */
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

/**
 Applies a conditional operation to DataFrames based on a boolean condition.
 Returns the true DataFrame where condition is true, false DataFrame where condition is false.
 */
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

/**
 Applies a conditional operation to DataFrames based on a boolean condition.
 Returns the true DataFrame where condition is true, false DataFrame where condition is false.
 */
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
    /**
     Returns the dimensions of the DataFrame as (width, height).
     Width is the number of columns (keys), height is the length of DataSeries.
     */
    func shape<V>() -> (width: Int, height: Int) where Value == DataSeries<V> {
        return (self.keys.count, self.values.first?.count ?? 0)
    }

    /**
     Calculates the sum of each DataSeries in the DataFrame.
     Returns a DataFrame with single-value DataSeries containing the sums.
     */
    func sum<V>(ignoreNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: Numeric {
        mapValues { DataSeries([$0.sum(ignoreNils: ignoreNils)]) }
    }

    /**
     Calculates the sum of all columns (DataSeries) in the DataFrame.
     Returns a single DataSeries with the sum of corresponding elements across all columns.
     */
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

    /**
     Calculates the mean of each DataSeries in the DataFrame.
     Returns a DataFrame with single-value DataSeries containing the means.
     */
    func mean<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.mean(shouldSkipNils: shouldSkipNils)]) }
    }

    /**
     Calculates the standard deviation of each DataSeries in the DataFrame.
     Returns a DataFrame with single-value DataSeries containing the standard deviations.
     */
    func std<V>(shouldSkipNils: Bool = true) -> DataFrame<Key, V> where Value == DataSeries<V>, V: FloatingPoint {
        mapValues { DataSeries([$0.std(shouldSkipNils: shouldSkipNils)]) }
    }

    /**
     Fills nil values in all DataSeries of the DataFrame using the specified method.
     Returns a new DataFrame with nil values replaced according to the fill method.
     */
    func fillNils<V>(method: FillNilsMethod<V?>) -> DataFrame<Key, V> where Value == DataSeries<V> {
        mapValues { $0.fillNils(method: method) }
    }
}
