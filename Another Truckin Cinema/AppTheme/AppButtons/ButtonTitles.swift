//
//  ButtonTitle.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/19/23.
//

import Foundation

enum ButtonTitle: String {
    /// General / RSVP flow
    case Continue = "Continue"
    case ContinueToPurchase = "Continue to Purchase"
    case Done = "Done"
    case Okay = "Ok"
    case RSVPNow = "RSVP Now"
    case Submit = "Submit"
    
    /// Food and Drinks
    case OrderNow = "Order Now"
    case NoThankYou = "No, thank you"
    case YesDelivery = "Yes, schedule a delivery"
    
    /// Signin/Signup
    case ForgotPassword = "Forgot password?"
    case JoinNow = "Join Now"
    case LearnMore = "Learn More"
    case SignIn = "Sign In"
    case SignUp = "Sign up"
    
    /// Our Drive-ins
    case DriveInInfo = "Drive-in Info"
    case Showtimes = "Showtimes"
    
    func getString() -> String { return self.rawValue }
}


/*
 TODO
 
 create segmented bar for movie details screen
 */
