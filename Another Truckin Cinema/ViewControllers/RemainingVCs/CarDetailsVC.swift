//
//  CarDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit

class CarDetailsVC: BaseViewController, AppNavigationBarDelegate {
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .MovieRSVP, shouldShowTimer: true)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar()
    }
}
