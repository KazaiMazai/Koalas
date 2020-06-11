//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.06.2020.
//

public typealias DataPanel<Key: Hashable, Key2: Hashable, V> = [Key: DataFrame<Key2, V>]

public extension DataPanel {
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

    func mapPanelValues<Key2, V>(_ transform: (DataSeries<V>) -> DataSeries<V> ) -> DataPanel<Key, Key2, V> where Value == DataFrame<Key2, V>  {
        return self.mapValues { $0.mapValues { transform($0) } }
    }

    func mapValues<Key2, V>(keys: (Key, Key),
                            transform: (DataFrame<Key2, V>?, DataFrame<Key2, V>?) -> DataFrame<Key2, V>)
        -> DataFrame<Key2, V>

        where
        Value == DataFrame<Key2, V>  {

            return transform(self[keys.0], self[keys.1])
    }
}

 
