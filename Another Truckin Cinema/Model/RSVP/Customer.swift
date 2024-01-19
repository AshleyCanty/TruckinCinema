//
//  Customer.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation


struct Customer: Codable {
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var emailAddress: String?
    var membership: Membership?
}
