//
//  AppDates.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/23/23.
//

import Foundation

struct ShowtimeDates {
    /// Get showtime dates from calender. Returns dates for Fri - Sun
    public func getShowtimwDates(rsvpFormat: Bool = false) -> [String] {
        let now = Date()
        let startDate = Date()
        let calender = Calendar.current
        let weekEndInterval = calender.dateIntervalOfWeekend(containing: now) ?? calender.nextWeekend(startingAfter: now)!
        
        // Get open days for theater: Fri - Sun
        /// Get Saturday date
        let saturdayDate = weekEndInterval.start
        let endDate = saturdayDate.addingTimeInterval(weekEndInterval.duration - 1)
        
        /// Get Friday date
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let fridayDate = calender.date(byAdding: dayComponent, to: saturdayDate)
        
        /// Get Sunday date
        dayComponent.day = 1
        let sundayDate = calender.date(byAdding: dayComponent, to: saturdayDate)
        
        let theaterOpenDays: [Date?] = [fridayDate, saturdayDate, sundayDate]
        let formattedDates = convertDatesToStringFormat(dates: theaterOpenDays, rsvpFormat: rsvpFormat)
        
        print(startDate, calender.startOfDay(for: endDate))
        
        return formattedDates
    }
    
    /// Convert dates into String format
    private func convertDatesToStringFormat(dates: [Date?], rsvpFormat: Bool) -> [String] {
        let formattedDates = dates.map { optionalDate in
            guard let date = optionalDate else { return ""}
            return date.convertToStringShowingWeekdayAndDate(rsvpFormat: rsvpFormat)
        }
        return formattedDates.filter({ $0.count > 0})
    }
}
