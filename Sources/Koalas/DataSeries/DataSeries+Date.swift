//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

public enum DateComponentsKeys: String {
    case year
    case month
    case day
}

public extension SeriesArray where Element == Date? {
    func toDateComponents() -> DataFrame<DateComponentsKeys, Int> {
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "yyyy"

        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"

        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"

        let yearSeries = DataSeries<Int>(map { compactMapValue(value: $0) { date in Int(yearDateFormatter.string(from: date)) } })
        let monthSeries = DataSeries<Int>(map { compactMapValue(value: $0) { date in Int(monthDateFormatter.string(from: date)) } })
        let daySeries = DataSeries<Int>(map { compactMapValue(value: $0) { date in Int(dayDateFormatter.string(from: date)) } })

        return DataFrame(uniqueKeysWithValues: [(.year, yearSeries),
                                                (.month, monthSeries),
                                                (.day, daySeries)])

         
    }

}
