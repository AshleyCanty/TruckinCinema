//
//  MembershipTiersVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit
import Combine

/// MembershipTiersVC class
class MembershipTiersVC: BaseViewController, AppNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    /// Custom nav bar
    private lazy var appNavBar = AppNavigationBar(type: .Plain)
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = AppColors.BackgroundMain
        table.dataSource = self
        table.delegate = self
        table.register(MembershipPromptCell.self, forCellReuseIdentifier: MembershipPromptCell.reuseId)
        table.register(TierCell.self, forCellReuseIdentifier: TierCell.reuseId)
        table.register(CompareLevelsCell.self, forCellReuseIdentifier: CompareLevelsCell.reuseId)
        return table
    }()
    
    // all views go in tableview cells
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
        
        view.addSubview(tableView)
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor)
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        tableView.bottomAnchor.tc_constrain(equalTo: view.bottomAnchor)
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

extension MembershipTiersVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 90
        } else if indexPath.item == 1 {
            return 190
        } else if indexPath.item == 2 {
            return 170
        } else if indexPath.item == 3 {
            return 150
        } else {
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MembershipPromptCell.reuseId, for: indexPath) as! MembershipPromptCell
            cell.cancellable = cell.tapSignInButton.compactMap{}.sink(receiveValue: {  AppNavigation.shared.navigateTo(SignInVC()) })
            tableCell = cell
        } else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TierCell.reuseId, for: indexPath) as! TierCell
            cell.configure(withTier: .Tier1)
            cell.cancellable = cell.tapJoinButton.compactMap{$0}.sink(receiveValue: { tier in
                AppNavigation.shared.navigateTo(RegistrationVC(step: .One, tier: tier))
            })
            tableCell = cell
        } else if indexPath.item == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TierCell.reuseId, for: indexPath) as! TierCell
            cell.configure(withTier: .Tier2)
            cell.cancellable = cell.tapJoinButton.compactMap{$0}.sink(receiveValue: { tier in
                AppNavigation.shared.navigateTo(RegistrationVC(step: .One, tier: tier))
            })
            tableCell = cell
        } else if indexPath.item == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TierCell.reuseId, for: indexPath) as! TierCell
            cell.configure(withTier: .Tier3)
            cell.cancellable = cell.tapJoinButton.compactMap{$0}.sink(receiveValue: { tier in
                AppNavigation.shared.navigateTo(RegistrationVC(step: .One, tier: tier))
            })
            tableCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompareLevelsCell.reuseId, for: indexPath) as! CompareLevelsCell
            tableCell = cell
        }

        return tableCell
    }
}
