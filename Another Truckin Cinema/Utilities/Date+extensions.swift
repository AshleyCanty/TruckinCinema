//
//  Date+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/23/23.
//

import Foundation


extension Date {
    /// Converts date to string format. Example - 'Tue, May 7, 2001'
    func convertToStringShowingWeekdayAndDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d yyy")
        return dateFormatter.string(from: self)
    }
}
