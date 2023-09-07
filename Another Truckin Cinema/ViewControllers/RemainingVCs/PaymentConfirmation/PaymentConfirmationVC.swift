//
//  PaymentConfirmationVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


class PaymentConfirmationVC: BaseViewController, AppNavigationBarDelegate, LocationConfirmationCellDelegate, DateConfirmationCellDelegate, DoneButtonConfirmationCellDelegate {
        
    struct Style {
        static let LargeTitleFont: UIFont = AppFont.bold(size: 21)
        static let LargeTitleTextColor: UIColor = AppColors.TextColorPrimary
        static let GreyTextFont: UIFont = AppFont.regular(size: 10)
        static let GreyTextColor: UIColor = AppColors.TextColorSecondary
        static let SemiBoldTextColor: UIColor = AppColors.TextColorPrimary
        static let SemiBoldTextFont: UIFont = AppFont.semiBold(size: 10)
        static let LinkTextColor: UIColor = AppColors.RegularTeal
        static let MovieImageSize: CGFloat = 125
        static let QRImageSize: CGFloat = 115
        static let QRImageBorderColor: UIColor = UIColor(hex: "E90505")
        static let DoneButtonHeight: CGFloat = 50
    }
    
    private lazy var appNavBar = AppNavigationBar(type: .PurchaseConfirmation)
    /// table view
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = AppColors.BackgroundMain
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "PaymentConfirmationV VC")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
        setupTableDataSource()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.contentSize.height < tableView.frame.size.height {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: "You're all set, Tony", withSubtitle: "WE EMAILED YOUR RECEIPT. SEE YOU AT THE DRIVE-IN!")
    }
    
    /// Configure views
    private func configure() {
        view.addSubview(tableView)
        
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: 45)
        tableView.bottomAnchor.tc_constrain(equalTo: view.bottomAnchor)
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
    }
    
    // MARK: - Cell Delegate Methods
    
    func didTapAddressLink() {
        print()
    }
    
    func didTapCalenderLink() {
        print()
    }
    
    func didTapDoneButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}


extension PaymentConfirmationVC: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieQRCodeConfirmationCell.self, forCellReuseIdentifier: MovieQRCodeConfirmationCell.reuseIdentifier)
        tableView.register(TicketsAndScreenConfirmationCell.self, forCellReuseIdentifier: TicketsAndScreenConfirmationCell.reuseIdentifier)
        tableView.register(LocationConfirmationCell.self, forCellReuseIdentifier: LocationConfirmationCell.reuseIdentifier)
        tableView.register(DateConfirmationCell.self, forCellReuseIdentifier: DateConfirmationCell.reuseIdentifier)
        tableView.register(DoneButtonConfirmationCell.self, forCellReuseIdentifier: DoneButtonConfirmationCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else if indexPath.row == 4 {
            return 74
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0, let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: MovieQRCodeConfirmationCell.reuseIdentifier, for: indexPath) as? MovieQRCodeConfirmationCell {
            cell = unwrappedCell
        } else if indexPath.row == 1, let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: TicketsAndScreenConfirmationCell.reuseIdentifier, for: indexPath) as? TicketsAndScreenConfirmationCell {
            cell = unwrappedCell
        } else if indexPath.row == 2, let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: LocationConfirmationCell.reuseIdentifier, for: indexPath) as? LocationConfirmationCell {
            unwrappedCell.delegate = self
            cell = unwrappedCell
        } else if indexPath.row == 3, let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: DateConfirmationCell.reuseIdentifier, for: indexPath) as? DateConfirmationCell {
            unwrappedCell.delegate = self
            cell = unwrappedCell
        } else if indexPath.row == 4, let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: DoneButtonConfirmationCell.reuseIdentifier, for: indexPath) as? DoneButtonConfirmationCell {
            unwrappedCell.delegate = self
            cell = unwrappedCell
        }
        cell.selectionStyle = .none
        cell.backgroundColor = AppColors.BackgroundMain
        cell.contentView.backgroundColor = AppColors.BackgroundMain
        return cell
    }
}
