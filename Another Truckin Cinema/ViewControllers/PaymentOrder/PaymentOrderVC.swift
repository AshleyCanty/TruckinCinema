//
//  PaymentOrderVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


class PaymentOrderVC: BaseViewController, AppNavigationBarDelegate, PaymentSelectionViewDelegate {
   @objc func didPressAddEmailButton() {
        let vc = ContactInfoEmailVC()
        AppNavigation.shared.navigateTo(vc)
    }
    
    func didSelectPaymentOption(isSelected: Bool) {
        guard !orderCartView.continueButton.isEnabled, let emailText = contactInfoView.emailButton.titleLabel?.text, !emailText.isEmpty else { return }
        orderCartView.continueButton.isEnabled = true
    }
    
    @objc func didTapContinueButton() {
        let vc = PaymentConfirmationVC(rsvpOrder: rsvpOrder)
        AppNavigation.shared.navigateTo(vc)
    }
    
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let SubtitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
    }
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .MovieRSVP, shouldShowTimer: false)
    /// contact inof view
    private lazy var contactInfoView = ContactInfoView()
    /// payment selection view
    private lazy var paymentSelectionView = PaymentSelectionView()
    /// order cart view
    private lazy var orderCartView = OrderCartView()
    
    private var rsvpOrder: MovieReservation?
    

    init(rsvpOrder: MovieReservation?) {
        super.init()
        self.rsvpOrder = rsvpOrder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        addCustomNavBar()
        contactInfoView.emailButton.addTarget(self, action: #selector(didPressAddEmailButton), for: .touchUpInside)
        paymentSelectionView.delegate = self
        
        view.addSubview(contactInfoView)
        view.addSubview(paymentSelectionView)
        view.addSubview(orderCartView)
        
        contactInfoView.disableTranslatesAutoresizingMaskIntoContraints()
        contactInfoView.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: 35)
        contactInfoView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        contactInfoView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        paymentSelectionView.disableTranslatesAutoresizingMaskIntoContraints()
        paymentSelectionView.topAnchor.tc_constrain(equalTo: contactInfoView.bottomAnchor, constant: 45)
        paymentSelectionView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        paymentSelectionView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        paymentSelectionView.bottomAnchor.tc_constrain(lessThanOrEqualTo: orderCartView.topAnchor)
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        orderCartView.continueButton.isEnabled = false
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {
        // exit the flow? show alert
        showAlertToCancelOrder()
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar()
    }
}

extension PaymentOrderVC {
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
    
}
