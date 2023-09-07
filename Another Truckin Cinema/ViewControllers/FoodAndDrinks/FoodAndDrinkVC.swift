//
//  FoodAndDrinkVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

protocol AppNavigationBarDel: AnyObject {
    
}

/// FoodAndDrinkVC class
class FoodAndDrinkVC: BaseViewController, AppNavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    /// Custom nav bar
    private lazy var appNavBar = AppNavigationBar(type: .Plain)
    
    ///  segmented control
    fileprivate lazy var segmentedControl: CustomSegmentedControl = {
        let sc = CustomSegmentedControl(items: ["ORDER AHEAD", "MCGOLDIE BAR"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let headerImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "food_drinks_main"))
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    let detailView = DriveInDetailView()
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Order Ahead"
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Select your drive-in to order your favorite food & drinks ahead of time."
        label.textColor = RegistrationVC.Style.SubtitleTextColor
        label.font = AppFont.regular(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    let orderNowButton = ThemeButton()
    
    let dropdownView = DriveInDropDownView()
    
    let driveInTableModal = ParticipatingDriveInsTableView()
    
    var tableModalTopAnchor = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: TabBarItemTitle.FoodAndDrinks.getString())
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        addCustomNavBar()
        
        view.addSubview(segmentedControl)
        segmentedControl.disableTranslatesAutoresizingMaskIntoContraints()
        segmentedControl.heightAnchor.tc_constrain(equalToConstant: 45)
        segmentedControl.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor)
        segmentedControl.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        segmentedControl.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        view.addSubview(headerImageView)
        headerImageView.clipsToBounds = true
        headerImageView.disableTranslatesAutoresizingMaskIntoContraints()
        headerImageView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        headerImageView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        headerImageView.heightAnchor.tc_constrain(equalToConstant: 180)
        headerImageView.topAnchor.tc_constrain(equalTo: segmentedControl.bottomAnchor)
        
        let labelStack = UIStackView(arrangedSubviews: [largeTitleLabel, subTitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 12
        
        view.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: headerImageView.bottomAnchor, constant: 8)
        labelStack.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12)
        labelStack.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        
        view.addSubview(dropdownView)
        dropdownView.disableTranslatesAutoresizingMaskIntoContraints()
        dropdownView.heightAnchor.tc_constrain(equalToConstant: 40)
        dropdownView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12)
        dropdownView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        dropdownView.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 12)
        
        let dropDownTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropDown))
        dropdownView.isUserInteractionEnabled = true
        dropdownView.addGestureRecognizer(dropDownTapGesture)
        
        view.addSubview(detailView)
        detailView.disableTranslatesAutoresizingMaskIntoContraints()
        detailView.heightAnchor.tc_constrain(equalToConstant: 125)
        detailView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12)
        detailView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        detailView.topAnchor.tc_constrain(equalTo: dropdownView.bottomAnchor, constant: 15)
        
        view.addSubview(orderNowButton)
        orderNowButton.disableTranslatesAutoresizingMaskIntoContraints()
        orderNowButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        orderNowButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12)
        orderNowButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        orderNowButton.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppTheme.BottomMargin)
        
        orderNowButton.setTitle("Order Now", for: .normal)
        orderNowButton.addTarget(self, action: #selector(didTapOrderNowButton), for: .touchUpInside)
        
        
        view.addSubview(driveInTableModal)
        driveInTableModal.disableTranslatesAutoresizingMaskIntoContraints()
        driveInTableModal.heightAnchor.tc_constrain(equalTo: view.heightAnchor)
        driveInTableModal.widthAnchor.tc_constrain(equalTo: view.widthAnchor)
        driveInTableModal.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        tableModalTopAnchor = driveInTableModal.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableModalTopAnchor.isActive = true
        
        driveInTableModal.cancellable = driveInTableModal.tapCloseButton.sink(receiveValue: { _ in
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.tableModalTopAnchor.isActive = false
                sSelf.tableModalTopAnchor = sSelf.driveInTableModal.topAnchor.constraint(equalTo: sSelf.view.safeAreaLayoutGuide.bottomAnchor)
                sSelf.tableModalTopAnchor.isActive = true
                sSelf.view.setNeedsLayout()
            }
        })
        
        setupTable()
    }
    
    func setupTable() {
        driveInTableModal.tableView.delegate = self
        driveInTableModal.tableView.dataSource = self
        driveInTableModal.tableView.register(ParticipatingDriveInCell.self, forCellReuseIdentifier: ParticipatingDriveInCell.reuseId)
    }
    
    
    @objc func didTapDropDown() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableModalTopAnchor.isActive = false
            sSelf.tableModalTopAnchor = sSelf.driveInTableModal.topAnchor.constraint(equalTo: sSelf.largeTitleLabel.topAnchor, constant: sSelf.largeTitleLabel.frame.height/2)
            sSelf.tableModalTopAnchor.isActive = true
            sSelf.view.setNeedsLayout()
        }

    }
    
    @objc func didTapOrderNowButton() {
        AppNavigation.shared.navigateTo(SnackBarVC())
    }
    
    @objc func selectedSegment() {
        // TODO - Create a sidemenu with a gradient background and corner radius
        if segmentedControl.selectedSegmentIndex == 0 {
            
        } else {
            
        }
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

        appNavBar.configureNavBar(withTitle: NavigationTitle.FoodAndDrinks.getString())
    }
    
}

extension FoodAndDrinkVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ParticipatingDriveInCell
        dropdownView.promptLabel.text = cell.driveInLabel.text
        // Store selected theater & use it for food order
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DriveInLocations.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParticipatingDriveInCell
            .reuseId, for: indexPath) as! ParticipatingDriveInCell
        cell.driveInLabel.text = DriveInLocations.names[indexPath.row]
        
        return cell
    }
}



