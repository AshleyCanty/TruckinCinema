//
//  MembershipTiersVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

/// MembershipTiersVC class
class MembershipTiersVC: BaseViewController, AppNavigationBarDelegate {
    
    /// Custom nav bar
    private lazy var appNavBar = AppNavigationBar(type: .Plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: TabBarItemTitle.Membership.getString())
        super.viewWillAppear(animated)
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        // show side menu
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: NavigationTitle.MyATCMembership.getString())
    }
}
