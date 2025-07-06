//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2020.
//

import Foundation

/**
 Defines the keys for date components when extracting parts of dates.
 Used to organize date components (year, month, day) in a structured format.
 */
public enum DateComponentsKeys: String {
    case year
    case month
    case day
}

public extension SeriesArray where Element == Date? {
    /**
     Converts a SeriesArray of dates into a DataFrame containing individual date components.
     Extracts year, month, and day from each date and organizes them into separate DataSeries.
     Returns a DataFrame with three columns: year, month, and day, each containing integer values.
     */
    func toDateComponents() -> DataFrame<DateComponentsKeys, Int> {
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "yyyy"

        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"

        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"

        let yearSeries = DataSeries<Int>(map { unwrap(value: $0) { date in Int(yearDateFormatter.string(from: date)) } })
        let monthSeries = DataSeries<Int>(map { unwrap(value: $0) { date in Int(monthDateFormatter.string(from: date)) } })
        let daySeries = DataSeries<Int>(map { unwrap(value: $0) { date in Int(dayDateFormatter.string(from: date)) } })

        return DataFrame(uniqueKeysWithValues: [(.year, yearSeries),
                                                (.month, monthSeries),
                                                (.day, daySeries)])
    }

}
