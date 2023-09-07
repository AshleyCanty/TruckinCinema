//
//  Registration+Enums.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/7/23.
//

import Foundation


/// RegistrationStep enum
enum RegistrationStep: String {
    case One = "1"
    case Two = "2"
    func getString() -> String { return self.rawValue }
}
/// VIP tier enum
enum VIPTier: String {
    case Tier1 = "1"
    case Tier2 = "2"
    case Tier3 = "3"
    func getString() -> String { return self.rawValue }
}
/// RegistrationScreen struct
struct RegistrationScreen {
    let iconName: String
    let largeTitle: String
    let subtitle: String?
    let description: String
    
    init(iconName: String, largeTitle: String, subtitle: String? = nil, description: String) {
        self.iconName = iconName
        self.largeTitle = largeTitle
        self.subtitle = subtitle
        self.description = description
    }
}
/// enum for placeholder
enum RegistrationPlaceholder: String {
    case FirstName = "First Name"
    case LastName = "Last Name"
    case Email = "Enter your email"
    case Password = "Enter your password"
    case BirthdayMonth = "Month"
    case BirthdayDate = "Date"
    case BirthdayYear = "Year"
    func getString() -> String { return self.rawValue }
}
/// enum for password checks
enum PasswordCheckerType: String {
    case LowercaseLetter = "1 lowercase letter"
    case CapitalLetter = "1 capital letter"
    case SpecialCharacter = "1 special character"
    func getString() -> String { return self.rawValue }
}
/// enum for password checks
enum RegistrationErrorMessage: String {
    case MissingBasicInfo = "Enter your name."
    case InvalidPassword = "Please enter a valid passowrd."
    case InvalidEmail = "Please enter a valid email address."
    case MissingBirthday = "Enter your birthday."
    case AgeMinimum = "You must be at least 16 years of age."
    func getString() -> String { return self.rawValue }
}
/// RegistrationIcon enum
enum RegistrationIcon: String {
    case IconScreenOne = "red-carpet"
    case IconScreenTwo = "popcorn"
    func getString() -> String { return self.rawValue }
}
 /// RegistrationLabel enum
enum RegistrationLabel: String {
    // Step one
    case LargeTitleOne = "Put Your Name on Our Walk of Fame"
    case DescriptionOne = "Your email address is your new “stage name”. It’s also the place we’ll send movie reservation confirmations, specials and more."
    case SubtitleOne = "Provide your name as it is shown on your photo ID."
    case SubtitleTwo = "Enter your birthday"
    
    // Step two
    case LargeTitleTwo = "Your Birthday is a Big Deal"
    case DescriptionTwo = "We want to celebrate you with a FREE large popcorn for your big day. We may use your birthday for verification purposes, so please make sure it’s correct."
    
    func getString() -> String { return self.rawValue }
}

let RegistrationScreenOneData = RegistrationScreen(iconName: RegistrationIcon.IconScreenOne.getString(),
                                                   largeTitle: RegistrationLabel.LargeTitleOne.getString(),
                                                   subtitle: RegistrationLabel.SubtitleOne.getString(),
                                                   description: RegistrationLabel.DescriptionOne.getString())

let RegistrationScreenTwoData = RegistrationScreen(iconName: RegistrationIcon.IconScreenTwo.getString(),
                                                   largeTitle: RegistrationLabel.LargeTitleTwo.getString(),
                                                   description: RegistrationLabel.DescriptionTwo.getString())
