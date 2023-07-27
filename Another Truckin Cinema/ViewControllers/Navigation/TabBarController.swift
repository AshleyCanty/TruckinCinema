//
//  TabBarController.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

/// Custom TabBarController class
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    struct Style {
        static let imageInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    /// lazy var to store tab controllers
    lazy var tabViewControllers: [UIViewController] = {
        let homeNC = UINavigationController(rootViewController: HomescreenVC())
        let ourDriveInsNC = UINavigationController(rootViewController: DriveInLocationsVC())
        let foodAndDrinkNC = UINavigationController(rootViewController: FoodAndDrinkVC())
        let membershipNC = UINavigationController(rootViewController: MembershipTiersVC())
        
        homeNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: TabBarIcon.HomeInactive.getString()), selectedImage: UIImage(named: TabBarIcon.Home.getString()))
        homeNC.tabBarItem.title = TabBarItemTitle.Home.getString()

        ourDriveInsNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: TabBarIcon.OurDriveInsInactive.getString()), selectedImage: UIImage(named: TabBarIcon.OurDriveIns.getString()))
        ourDriveInsNC.tabBarItem.title = TabBarItemTitle.OurDriveIns.getString()
        
        foodAndDrinkNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: TabBarIcon.FoodAndDrinksInactive.getString()), selectedImage: UIImage(named: TabBarIcon.FoodAndDrinks.getString()))
        foodAndDrinkNC.tabBarItem.title = TabBarItemTitle.FoodAndDrinks.getString()
        
        membershipNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: TabBarIcon.MembershipInactive.getString()), selectedImage: UIImage(named: TabBarIcon.Membership.getString()))
        membershipNC.tabBarItem.title = TabBarItemTitle.Membership.getString()
        
        let tabControllers = [homeNC, ourDriveInsNC, foodAndDrinkNC, membershipNC]
        tabControllers.forEach { addTabBarItemStyle(tabController: $0) }
        
        return tabControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()

        self.setViewControllers(tabViewControllers, animated: false)
        self.delegate = self
        self.selectedIndex = 0
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
    }
    
    /// Adds styling to tabBar item
    fileprivate func addTabBarItemStyle(tabController: UINavigationController) {
        tabController.tabBarItem.imageInsets = Style.imageInsets
        tabController.tabBarItem.setTitleTextAttributes([.font: AppFont.semiBold(size: 9)], for: .normal)
        tabController.tabBarItem.setTitleTextAttributes([.font: AppFont.semiBold(size: 9)], for: .selected)
    }
    
    fileprivate func setStyle() {
        UITabBar.appearance().backgroundColor = AppColors.BackgroundMain
        UITabBar.appearance().unselectedItemTintColor = AppColors.RegularGray
        UITabBar.appearance().tintColor = AppColors.RegularTeal
    }
}
