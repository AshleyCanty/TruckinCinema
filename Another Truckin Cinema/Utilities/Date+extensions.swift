//
//  Date+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/23/23.
//

import Foundation


extension Date {
    /// Converts date to string format. Example - 'Tue, May 7, 2001'
    func convertToStringShowingWeekdayAndDate(rsvpFormat: Bool) -> String {
        let dateFormatter = DateFormatter()
        if !rsvpFormat {
            dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d yyy")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MM/dd")
        }
        return dateFormatter.string(from: self)
    }
}
