//
//  CarDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit



class CarDetailsVC: BaseViewController, SignUpBannerViewDelegate, CarDetailCellDelegate, AppNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var dropDownTopMargin: CGFloat {
        let lm = view.layoutMargins
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        let topMargin: CGFloat = (lm.top + Style.BannerTopAnchorConstant + Style.BannerHeight + appNavBar.frame.height + statusBarHeight + 15)
        return topMargin
    }


    /// Style struct
    private struct Style {
        static let ContinueButtonHeight: CGFloat = 50
        static let BannerHeight: CGFloat = 100
        static let BannerTopAnchorConstant: CGFloat = 9
        static let BannerLeadingTrailingMargin: CGFloat = 12
        static let BannerCornerRadius: CGFloat = 15
    }
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .MovieRSVP, shouldShowTimer: true)
    /// Banner's wrapper view for displaying the drop shadow
    private lazy var bannerWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addShadow(color: .black, opacity: 0.25, radius: 6, offset: CGSize(width: 1, height: 3))
        return view
    }()
    /// sign up banner view
    private lazy var signUpBannerView = SignUpBannerView()
    /// tableview
    private lazy var tableView = UITableView()
    /// order cart view
    private lazy var orderCartView = OrderCartView()
    
    /// timer
    private var timer: Timer?
    /// timer amount in seconds
    private var timeLeft: Int = 420
    
    private var rsvpOrder: MovieReservation?

    
    init(rsvpOrder: MovieReservation?) {
        super.init()
        self.rsvpOrder = rsvpOrder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableDataSource()
        updateCartInfo()
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name(rawValue: AppNotificationNames.HideKeyboard), object: nil)
    }
    
    private func updateCartInfo() {
        guard let rsvpOrder = rsvpOrder, let tickets = rsvpOrder.tickets else { return }
        orderCartView.updateItemCountAndPrice(addItemQuantity: tickets.quantity, price: tickets.calculateTotalPrice())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        executeTimer()
    }
    
    /// Sets up banner constraints
    fileprivate func addBanner() {
        signUpBannerView.delegate = self
        
        bannerWrapper.addSubview(signUpBannerView)
        signUpBannerView.disableTranslatesAutoresizingMaskIntoContraints()
        signUpBannerView.tc_constrainToSuperview()
        
        view.addSubview(bannerWrapper)
        bannerWrapper.disableTranslatesAutoresizingMaskIntoContraints()
        bannerWrapper.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: Style.BannerTopAnchorConstant)
        bannerWrapper.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: Style.BannerLeadingTrailingMargin)
        bannerWrapper.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -Style.BannerLeadingTrailingMargin)
        bannerWrapper.heightAnchor.tc_constrain(equalToConstant: Style.BannerHeight)
        
        bannerWrapper.layer.cornerRadius = SignUpBannerView.Style.BannerCornerRadius
        bannerWrapper.clipsToBounds = true
    }
    
    // MARK: - Order Cart Delegate Methods
    @objc func didTapContinueButton() {
//        guard checkIfCarDetailsAreFilled() else {
//            showErrorAlertForCarDetails()
//            return
//        }
        let vc = SnackBarVC(rsvpOrder: rsvpOrder)
//        let vc = FoodDeliveryDetailsVC(rsvpOrder: rsvpOrder)
//        let vc = PaymentOrderVC()
        AppNavigation.shared.navigateTo(vc)
    }
    

    /// Returns true if car details exist
    private func checkIfCarDetailsAreFilled() -> Bool {
        guard let order = rsvpOrder, (order.car?.make != nil || order.car?.model != nil || order.car?.color != nil || order.car?.licensePlate != nil) else { return false }
        return true
    }
    
    // MARK: - Signup Banner Delegate Methods
    
    func didPressSignUpButton() {
        let vc = RegistrationVC(step: .One, tier: .Tier1)
        AppNavigation.shared.navigateTo(vc)
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }

    func didPressNavBarRightButton() {}

    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self

        appNavBar.configureNavBar()
    }
    
    /// triggers timer
    private func executeTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let sSelf = self, sSelf.timeLeft > 0 else { return }
            sSelf.timeLeft -= 1
            sSelf.appNavBar.updateTimerLabel(with: sSelf.timeLeft.convertToMinutesAndSeconds())
        })
    }
    
    private func configure() {
        addCustomNavBar()
        addBanner()
        view.addSubview(tableView)
        view.addSubview(orderCartView)
        
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: AppTheme.BannerBottomMargin)
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        tableView.bottomAnchor.tc_constrain(equalTo: orderCartView.topAnchor)
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
    }
    
    // MARK: - Cell Delegate Methods
    func carDetailValueDidChange(type: CarDetailType, detailValue: String) {
        // Stores car data in rsvpOrder object
        switch type {
        case .make:
            rsvpOrder?.car?.make = detailValue
        case .model:
            rsvpOrder?.car?.model = detailValue
        case .color:
            rsvpOrder?.car?.color = detailValue
        case .licensePlate:
            rsvpOrder?.car?.licensePlate = detailValue
        }
    }
    
    // MARK: -- UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.05) {
            textField.layer.borderColor = RoundedTextField.Style.BorderActiveColor.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.05) {
            textField.layer.borderColor = RoundedTextField.Style.BorderColor.cgColor
        }
    }
}

extension CarDetailsVC {
    
    private func setupTableDataSource() {
        tableView.backgroundColor = AppColors.BackgroundMain
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CarDetailsCell.self, forCellReuseIdentifier: CarDetailsCell.reuseID)
        tableView.register(CarDetailsDropDownCell.self, forCellReuseIdentifier: CarDetailsDropDownCell.reuseID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CarDetailsCell.reuseID, for: indexPath) as? CarDetailsCell
            dequeuedCell?.setup(question: "What is the make of your car?*", textFieldType: .Plain)
            dequeuedCell?.detailType = .make
            dequeuedCell?.delegate = self
            dequeuedCell?.textField.delegate = self
            cell = dequeuedCell
        } else if indexPath.row == 1 {
            let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CarDetailsDropDownCell.reuseID, for: indexPath) as? CarDetailsDropDownCell
                dequeuedCell?.setup(question: "What is the model of your car?*", dataSource: ["Mazda", "Bladda", "Froggy XD"])
            dequeuedCell?.detailType = .model
            dequeuedCell?.delegate = self
            cell = dequeuedCell
        } else if indexPath.row == 2 {
            let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CarDetailsDropDownCell.reuseID, for: indexPath) as? CarDetailsDropDownCell
            dequeuedCell?.setup(question: "What is the color of your car?*", dataSource: ["White", "Blue", "Yellow", "Green", "Black"])
            dequeuedCell?.detailType = .color
            dequeuedCell?.delegate = self
            cell = dequeuedCell
        } else {
            let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CarDetailsCell.reuseID, for: indexPath) as? CarDetailsCell
            dequeuedCell?.setup(question: "What is the license plate of your car?*", textFieldType: .Plain)
            dequeuedCell?.detailType = .licensePlate
            dequeuedCell?.delegate = self
            dequeuedCell?.textField.delegate = self
            cell = dequeuedCell
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension CarDetailsVC {
    func showAlertToExtendTimer() {
        
    }
    
    func showAlertToCancelOrder() {
        var cancelAlert: UIAlertController!
        
        let handlerNo: ((UIAlertAction) -> ())? = { _ in
            cancelAlert.dismiss(animated: true)
        }
        let handlerYes: ((UIAlertAction) -> ())? = { [weak self] _ in
            guard let sSelf = self else { return }
            if let movieDetailsVC = sSelf.navigationController?.viewControllers.filter({ $0 is MovieDetailsVC }).first {
                sSelf.navigationController?.popToViewController(movieDetailsVC, animated: true)
            }
        }
        cancelAlert = AppAlertController.createAlertToCancelOrder(handlerActionNo: handlerNo, handlerActionYes: handlerYes)
        self.present(cancelAlert, animated: true)
    }
    
    func showErrorAlertForCarDetails() {
        let errorAlert = UIAlertController(title: "Error", message: "Please complete all fields.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { _ in
            errorAlert.dismiss(animated: true)
        }
        errorAlert.addAction(action)
        self.present(errorAlert, animated: true)
    }
}

extension UIViewController {
    /// custom method for UIIVewController extension
    @objc public func hideKeyboard() {
        view.endEditing(true)
    }
}
