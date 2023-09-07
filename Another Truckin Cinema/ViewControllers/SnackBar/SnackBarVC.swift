//
//  FoodDeliveryDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


// TODO now  = Refactor App NavBar so that it can be customized from any child class of BaseView Controller


class SnackBarVC: BaseViewController, AppNavigationBarDelegate, SignUpBannerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    /// Custom NavBar
    private lazy var appNavBar = AppNavigationBar(type: .FoodDeliveryOrPickUp, shouldShowTimer: true)
    /// description label
    private lazy var desciptionLabel: UILabel = {
        let label = UILabel()
        label.text = snackBarDescriptionString
        label.font = AppFont.regular(size: 13)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// Banner's wrapper view for displaying the drop shadow
    private lazy var bannerWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addShadow(color: .black, opacity: 0.25, radius: 6, offset: CGSize(width: 1, height: 3))
        return view
    }()
    /// sign up banner view
    private lazy var signUpBannerView = SignUpBannerView()
    /// order cart view
    private lazy var orderCartView = OrderCartView()
    /// collectionview
    private lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 150)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = AppColors.BackgroundMain
        return collection
    }()
    
    let snackBarDescriptionString = "Head straight to your parking spot, get comfy and we’ll deliver your order right to you at the time you choose. You may also pick up your order at the Snackbar as an alternative."
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "FoodDeliveryDetails VC")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDataSource()
        setupUI()
    }
    
    private func setupUI() {
        addCustomNavBar()
        addBanner()
        
        view.addSubviews(subviews: [desciptionLabel, collectionView, orderCartView])
        
        desciptionLabel.disableTranslatesAutoresizingMaskIntoContraints()
        desciptionLabel.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: AppTheme.BannerBottomMargin)
        desciptionLabel.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        desciptionLabel.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        collectionView.disableTranslatesAutoresizingMaskIntoContraints()
        collectionView.topAnchor.tc_constrain(equalTo: desciptionLabel.bottomAnchor, constant: 3)
        collectionView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        collectionView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.topAnchor.tc_constrain(equalTo: collectionView.bottomAnchor)
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        orderCartView.continueButton.setTitle(ButtonTitle.ContinueToPurchase.getString(), for: .normal)
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        orderCartView.cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
    }
    
    /// Sets up banner constraints
    fileprivate func addBanner() {
        signUpBannerView.delegate = self
        
        bannerWrapper.addSubview(signUpBannerView)
        signUpBannerView.disableTranslatesAutoresizingMaskIntoContraints()
        signUpBannerView.tc_constrainToSuperview()
        
        view.addSubview(bannerWrapper)
        bannerWrapper.disableTranslatesAutoresizingMaskIntoContraints()
        bannerWrapper.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: AppTheme.BannerTopAnchorConstant)
        bannerWrapper.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.BannerLeadingTrailingMargin)
        bannerWrapper.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.BannerLeadingTrailingMargin)
        bannerWrapper.heightAnchor.tc_constrain(equalToConstant: AppTheme.BannerHeight)
        
        bannerWrapper.layer.cornerRadius = SignUpBannerView.Style.BannerCornerRadius
        bannerWrapper.clipsToBounds = true
    }
    
    private func setupCollectionViewDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SnackBarCell.self, forCellWithReuseIdentifier:  SnackBarCell.reuseIdentifier)
    }
    
    @objc private func didTapContinueButton() {
        let vc = FoodDeliveryDetailsVC()
        AppNavigation.shared.navigateTo(vc)
//        let alertVC = UIAlertController(title: "Would you like your food delivered to you?", message: nil, preferredStyle: .alert)
//        let actionNo = UIAlertAction(title: "No, thank you", style: .default) { _ in
//            alertVC.dismiss(animated: true)
//
//            let vc = PaymentOrderVC()
//            AppNavigation.shared.navigateTo(vc)
//        }
//        let actionYes = UIAlertAction(title: "Yes, schedule a delivery", style: .default) { _ in
//            let vc = FoodDeliveryDetailsVC()
//            AppNavigation.shared.navigateTo(vc)
//        }
//
//        alertVC.addAction(actionNo)
//        alertVC.addAction(actionYes)
//
//        present(alertVC, animated: true)
    }
    
    @objc private func didTapCartButton() {
        // show cart modal
    }
    
    // MARK: - Custom Banner Delegate Methods
    
    func didPressSignUpButton() {
        let vc = RegistrationVC(step: .One, tier: .Tier1)
        AppNavigation.shared.navigateTo(vc)
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        showAlertToCancelOrder()
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

// MARK: - CollectionView Delegate methods

extension SnackBarVC {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarCell.reuseIdentifier, for: indexPath) as? SnackBarCell {
            let itemType: SnackBarItemType = [.popcorn, .beverages, .snacks][indexPath.item]
            let vc = SnackBarSelectedItemOptionsVC(itemType: itemType)
            AppNavigation.shared.navigateTo(vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType: [SnackBarItemType] = [.popcorn, .beverages, .snacks]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarCell.reuseIdentifier, for: indexPath) as? SnackBarCell
        cell?.type = itemType[indexPath.row]
        return cell ?? SnackBarCell()
    }
}

extension SnackBarVC {
    
    func showAlertToExtendTimer() {
        
    }
    
    func showAlertToCancelOrder() {
        var cancelAlert: UIAlertController!
        
        let handlerNo: ((UIAlertAction) -> ())? = { _ in
            cancelAlert.dismiss(animated: true)
        }
        let handlerYes: ((UIAlertAction) -> ())? = { [weak self] _ in
            guard let sSelf = self else { return }
            
           if let viewControllerToBeShown = sSelf.navigationController?.viewControllers.filter({ vc in
                guard type(of: vc) == MovieDetailsVC.self || type(of: vc) == TabBarController.self else { return false }
                return true
           }).first {
               sSelf.navigationController?.popToViewController(viewControllerToBeShown, animated: true)
           }
        }
        cancelAlert = AppAlertController.createAlertToCancelOrder(handlerActionNo: handlerNo, handlerActionYes: handlerYes)
        self.present(cancelAlert, animated: true)
    }
    
}