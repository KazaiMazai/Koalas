//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

extension DataFrame {
    public func toStringLines<V>(separator: String) -> [String] where Value == DataSeries<V>, V: LosslessStringConvertible, Key: LosslessStringConvertible {
        var resultStringLines: [String] = []
        resultStringLines.append("\(keys.map { String($0) }.joined(separator: separator))")

        let height = shape().height
        for idx in 0..<height {
            let lineArr: [String] = values.map { series in series[idx].map { String($0) } ?? "nil" }
            let line = lineArr.joined(separator: separator)
            resultStringLines.append("\(line)")
        }

        return resultStringLines
    }

    public func writeToCSV<V>(file: String, atomically: Bool = true, encoding: String.Encoding = .utf8, columnSeparator: String) throws where Value == DataSeries<V>, V: LosslessStringConvertible, Key: LosslessStringConvertible {
        let dataframeString = toStringLines(separator: columnSeparator).joined(separator: "\n")
        try dataframeString.write(toFile: file, atomically: atomically, encoding: encoding)
    }

    public static func readFromCSV<K, V>(file: String, encoding: String.Encoding = .utf8, columnSeparator: String) throws -> DataFrame<K, V>

        where
        Value == DataSeries<V>,
        V: LosslessStringConvertible,
        K: LosslessStringConvertible,
        K: Hashable {

            let fileString = try String(contentsOfFile: file, encoding: encoding)

            var df = DataFrame<K, V>()
            var keys: [K] = []

            var lineNumber = 0

            fileString.enumerateLines { (line, _) in
                let lineComponents = line.components(separatedBy: columnSeparator)
                if lineNumber == 0 {
                    keys = lineComponents
                        .map { K($0) }
                        .compactMap { $0 }

                    keys.forEach { df[$0] = DataSeries() }
                } else {
                    let valuesRow = lineComponents.map { V($0) }
                    zip(keys, valuesRow).forEach { df[$0]?.append($01) }
                }

                lineNumber += 1
            }

            return df
    }
}
