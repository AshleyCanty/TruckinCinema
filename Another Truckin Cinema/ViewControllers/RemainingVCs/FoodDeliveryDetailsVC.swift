//
//  FoodDeliveryDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


class FoodDeliveryDetailsVC: BaseViewController, AppNavigationBarDelegate {
    /// Custom NavBar
    private lazy var appNavBar = AppNavigationBar(type: .FoodDeliveryOrPickUp)
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "FoodDeliveryDetails VC")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {}
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.HeightWithSubtitle)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: NavigationTitle.FoodDeliveryOrPickup.getString(), withSubtitle: "Drive-in No. 3 Zanzibar")
    }
}
