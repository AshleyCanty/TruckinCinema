//
//  Int+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/9/23.
//

import Foundation

extension Int {
    func convertToMinutesAndSeconds() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return "\(minutes):\(seconds)"
    }
}
