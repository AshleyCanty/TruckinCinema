//
//  Membership.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation


struct Membership: Codable {
    var memberId: String?
    var tier: Int?
}

enum MembershpiTierLevel: Int {
    case tierOne
    case tierTwo
    case tierThree
}
