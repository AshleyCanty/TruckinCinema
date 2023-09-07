//
//  RegistrationVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


/// Registration VC
class RegistrationVC: BaseViewController, AppNavigationBarDelegate {
    
    /// Style struct
    struct Style {
        static let RSVPButtonHeight: CGFloat = 50
    }
    /// Step / Screen in registration process
    private lazy var stepInRegistration: RegistrationStep = .One
    /// VIP Tier
    private lazy var vipTier: VIPTier = .Tier1
    
    /// rsvp button
    fileprivate lazy var continueButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.RSVPNow.getString(), for: .normal)
        return btn
    }()
    
    /// Custom nav bar
    private lazy var appNavBar = AppNavigationBar(type: .Registration)
    
    init(step: RegistrationStep, tier: VIPTier) {
        super.init()
        stepInRegistration = step
        vipTier = tier
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "Registration VC")
        super.viewWillAppear(animated)
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {}
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self

        appNavBar.configureNavBar(withTitle: NavigationTitle.MyATCMembership.getString(), withSubtitle: "VIP Tier \(vipTier.getString()) - Step \(stepInRegistration.getString()) of 2")
    }
}
