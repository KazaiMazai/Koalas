//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

extension DataFrame {
    /**
     Converts the DataFrame to an array of string lines representing the data in tabular format.
     The first line contains column headers (keys), followed by data rows.
     Each row is joined with the specified separator.
     */
    public func toStringRowLines<V>(separator: String) -> [String] where Value == DataSeries<V>, V: LosslessStringConvertible, Key: LosslessStringConvertible {
        var resultStringLines: [String] = []
        let sortedKeys = keys.sorted { return String($0) < String($1) }

        resultStringLines.append("\(sortedKeys.map { String($0) }.joined(separator: separator))")
        let sortedValues = sortedKeys.map { self[$0] }

        let height = shape().height
        for idx in 0..<height {
            let lineArr: [String] = sortedValues.map { series in series?[idx].map { String($0) } ?? "nil" }
            let line = lineArr.joined(separator: separator)
            resultStringLines.append("\(line)")
        }

        return resultStringLines
    }

    /**
     Writes the DataFrame to a file in CSV-like format.
     Uses the specified column separator and encoding for the output file.
     */
    public func write<V>(toFile: String,
                         atomically: Bool = true,
                         encoding: String.Encoding = .utf8,
                         columnSeparator: String) throws
        where

        Value == DataSeries<V>,
        V: LosslessStringConvertible,
        Key: LosslessStringConvertible {

            let dataframeString = toStringRowLines(separator: columnSeparator).joined(separator: "\n")
            try dataframeString.write(toFile: toFile, atomically: atomically, encoding: encoding)
    }

    /**
     Initializes a DataFrame from a file containing tabular data.
     The first line is expected to contain column headers, followed by data rows.
     Uses the specified encoding and column separator to parse the file.
     */
    public init<V>(
        contentsOfFile file: String,
        encoding: String.Encoding = .utf8,
        columnSeparator: String) throws

        where
        Value == DataSeries<V>,
        V: LosslessStringConvertible,
        Key: LosslessStringConvertible,
        Key: Hashable {

        self = try Self.read(from: file, encoding: encoding, columnSeparator: columnSeparator)
    }

    /**
     Reads a DataFrame from a file and parses it according to the specified format.
     Expects the first line to contain column headers and subsequent lines to contain data.
     Returns a DataFrame with the parsed data structure.
     */
    fileprivate static func read<K, V>(
        from file: String,
        encoding: String.Encoding = .utf8,
        columnSeparator: String) throws -> DataFrame<K, V>

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
