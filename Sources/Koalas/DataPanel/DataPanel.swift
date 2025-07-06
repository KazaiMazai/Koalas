//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

/**
 A dictionary-like structure that maps keys to DataFrames.
 Used to store and manipulate 3D tabular data with multiple keys and columns.
 */
public typealias DataPanel<Key: Hashable, Key2: Hashable, V: Codable> = [Key: DataFrame<Key2, V>]

public extension DataPanel {
    /**
     Transposes the DataPanel by swapping the key dimensions.
     Converts from [Key1: DataFrame<Key2, V>] to [Key2: DataFrame<Key1, V>].
     Useful for restructuring data from wide to long format or vice versa.
     */
    func transposed<Key2, V>() -> DataPanel<Key2, Key, V>
        where Value == DataFrame<Key2, V> {

            var transposedData: [Key2: DataFrame<Key, V>] = [:]
            self.forEach {
                let key1 = $0.key
                $0.value.forEach {
                    let key2 = $0.key
                    let value = $0.value
                    var df = transposedData[key2] ?? DataFrame<Key, V>()
                    df[key1] = value
                    transposedData[key2] = df
                }
            }

            return transposedData
    }

    /**
     Applies a transformation function to each DataSeries within all DataFrames in the DataPanel.
     Returns a new DataPanel with transformed DataSeries while preserving the structure.
     */
    func flatMapDataFrameValues<Key2, V, U>(_ transform: (DataSeries<V>) -> DataSeries<U> ) -> DataPanel<Key, Key2, U> where Value == DataFrame<Key2, V>  {
        return self.mapValues { $0.mapValues { transform($0) } }
    }

    /**
     Applies a transformation function to each individual value within all DataSeries in the DataPanel.
     Handles nil values and returns a new DataPanel with transformed values.
     */
    func flatMapValues<Key2, V, U>(_ transform: (V?) -> U? ) -> DataPanel<Key, Key2, U> where Value == DataFrame<Key2, V>  {
        return self.flatMapDataFrameValues { series in DataSeries(series.map { transform($0) }) }
    }

    /**
     Applies a transformation function to two specific DataFrames in the DataPanel.
     Takes two keys and a transformation function that operates on the corresponding DataFrames.
     Returns a single DataFrame as the result of the transformation.
     */
    func mapValues<Key2, V>(keys: (Key, Key),
                            transform: (DataFrame<Key2, V>?, DataFrame<Key2, V>?) -> DataFrame<Key2, V>)
        -> DataFrame<Key2, V>

        where
        Value == DataFrame<Key2, V>  {

            return transform(self[keys.0], self[keys.1])
    }

    /**
     Returns the dimensions of the DataPanel as (depth, width, height).
     Depth is the number of top-level keys, width and height are from the contained DataFrames.
     */
    func shape<Key2, V>() -> (depth: Int, width: Int, height: Int) where Value == DataFrame<Key2, V>  {
        let valueShape = self.values.first?.shape() ?? (width: 0, height: 0)
        return (self.keys.count, valueShape.width, valueShape.height)
    }
}


