//
//  AppNavigation.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/19/23.
//

import Foundation
import UIKit

final class AppNavigation: UINavigationController {
    
    static let shared = AppNavigation()
    
    private init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Replaces current view controller with those passed as paramters
    func setVCs(_ viewControllers: [UIViewController], animated: Bool = true) {
        setViewControllers(viewControllers, animated: animated)
    }
    
    func navigateTo(_ viewController: UIViewController, animated: Bool = true) {
        pushViewController(viewController, animated: animated)
    }
    
    func popToVC(viewController: UIViewController, animated: Bool = true) {
        popToViewController(viewController, animated: animated)
    }
    
    func popToRootVC(animated: Bool = true) {
        popToRootViewController(animated: animated)
    }
    
    func setNavBarToTranslucent() {
        UINavigationBar.appearance().isTranslucent = true
    }
    
    func setnavBarBackgroundColor() {
        UINavigationBar.appearance().isTranslucent = false
    }
}
