//
//  SnackBarSelectedItemOptionsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit

class SnackBarSelectedItemOptionsVC: BaseViewController, AppNavigationBarDelegate, SignUpBannerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// Custom NavBar
    private lazy var appNavBar = AppNavigationBar(type: .FoodDeliveryOrPickUp, shouldShowTimer: true)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 100)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = AppColors.BackgroundMain
        return collection
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
    
    var type: SnackBarItemType? {
        didSet {
            setupCollectionViewDataSource()
        }
    }
    
    lazy var datasource = [SnackBarItemModel]()
    
    convenience init(itemType: SnackBarItemType) {
        self.init()
        type = itemType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDataSource()
        collectionView.reloadData()
        setupUI()
    }
    
    private func setupUI() {
        addCustomNavBar()
        addBanner()
        view.addSubviews(subviews: [collectionView, orderCartView])
    
        collectionView.disableTranslatesAutoresizingMaskIntoContraints()
        collectionView.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: AppTheme.BannerBottomMargin)
        collectionView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        collectionView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        orderCartView.topAnchor.tc_constrain(equalTo: collectionView.bottomAnchor)
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        orderCartView.continueButton.setTitle(ButtonTitle.ContinueToPurchase.getString(), for: .normal)
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        orderCartView.cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
    }
    
    @objc private func didTapContinueButton() {
        let vc = PaymentOrderVC()
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
    
    
    @objc func didTapCartButton() {
        
    }
    
    /// setup collection view datasource
    func setupCollectionViewDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SnackBarCell.self, forCellWithReuseIdentifier: SnackBarCell.reuseIdentifier)
        collectionView.register(SnackBarItemOptionCell.self, forCellWithReuseIdentifier: SnackBarItemOptionCell.reuseID)
        
        guard let itemType = type else { return }
        switch itemType {
        case .popcorn: setDataForPopcornItems()
        case .beverages: setDataForBeverageItems()
        case .snacks: setDataForSnackItems()
        }
    }
    
    /// setup popcorn items
    private func setDataForPopcornItems() {
        let items: [SnackBarItemModel] = [
            SnackBarItemModel(name: SnackBarPopcornOption.Traditional.getString(), image: SnackBarPopcornImage.Traditional.getString(), priceString: SnackBarPopcornPrice.Traditional.getString(), priceNumber: SnackBarPopcornPrice.Traditional.getDoubleValue()),
            SnackBarItemModel(name: SnackBarPopcornOption.GourmetSingle.getString(), image: SnackBarPopcornImage.GourmetSingle.getString(), priceString: SnackBarPopcornPrice.GourmetSingle.getString(), priceNumber: SnackBarPopcornPrice.GourmetSingle.getDoubleValue()),
            SnackBarItemModel(name: SnackBarPopcornOption.GourmetDuo.getString(), image: SnackBarPopcornImage.GourmetDuo.getString(), priceString: SnackBarPopcornPrice.GourmetDuo.getString(), priceNumber: SnackBarPopcornPrice.GourmetDuo.getDoubleValue())
        ]
        self.datasource = items
    }
    
    /// setup beverage items
    private func setDataForBeverageItems() {
        let items: [SnackBarItemModel] = [
            SnackBarItemModel(name: SnackBarBeverageOption.Small.getString(), image: SnackBarBeverageImage.Small.getString(), priceString: SnackBarBeveragePrice.Small.getString(), priceNumber: SnackBarBeveragePrice.Small.getDoubleValue()),
            SnackBarItemModel(name: SnackBarBeverageOption.Medium.getString(), image: SnackBarBeverageImage.Medium.getString(), priceString: SnackBarBeveragePrice.Medium.getString(), priceNumber: SnackBarBeveragePrice.Medium.getDoubleValue()),
            SnackBarItemModel(name: SnackBarBeverageOption.Large.getString(), image: SnackBarBeverageImage.Large.getString(), priceString: SnackBarBeveragePrice.Large.getString(), priceNumber: SnackBarBeveragePrice.Large.getDoubleValue())
        ]
        self.datasource = items
    }
    
    /// setup snack items
    private func setDataForSnackItems() {
        var items: [SnackBarItemModel] = [
            SnackBarItemModel(name: SnackBarSnackOption.MixedCandy.getString(), image: SnackBarSnackImage.MixedCandy.getString(), priceString: SnackBarSnackPrice.MixedCandy.getString(), priceNumber: SnackBarSnackPrice.MixedCandy.getDoubleValue()),
            SnackBarItemModel(name: SnackBarSnackOption.Nachos.getString(), image: SnackBarSnackImage.Nachos.getString(), priceString: SnackBarSnackPrice.Nachos.getString(), priceNumber: SnackBarSnackPrice.Nachos.getDoubleValue()),
            SnackBarItemModel(name: SnackBarSnackOption.PretzelBites.getString(), image: SnackBarSnackImage.PretzelBites.getString(), priceString: SnackBarSnackPrice.PretzelBites.getString(), priceNumber: SnackBarSnackPrice.PretzelBites.getDoubleValue())
        ]
        self.datasource = items
    }
    
    // MARK: - Custom Banner Delegate Methods
    
    func didPressSignUpButton() {
        let vc = RegistrationVC(step: .One, tier: .Tier1)
        AppNavigation.shared.navigateTo(vc)
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
}


// MARK: - CollectionView Delegate methods

extension SnackBarSelectedItemOptionsVC {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 150)
        }
        return CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count + 1 // extra one for large cell at top
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarCell.reuseIdentifier, for: indexPath) as? SnackBarCell {
                cell.type = type
                cell.rightArrowIcon.isHidden = true
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarItemOptionCell.reuseID, for: indexPath) as? SnackBarItemOptionCell {
                let item = datasource[indexPath.item - 1]
                let itemImage = UIImage(imgNamed: item.image)
                cell.configure(image: itemImage, item: item)
                return cell
            }
        }
        
        return SnackBarItemOptionCell()
    }
}
