//
//  SnackBarSelectedItemOptionsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit
import Combine

class SnackBarSelectedItemOptionsVC: BaseViewController, AppNavigationBarDelegate, SignUpBannerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct Style {
        static let ToastHeight: CGFloat = 40
    }
    
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
    
    /// Updates SnackBarVC with selected items
    var snackOrder = PassthroughSubject<SnackBarItemModel, Never>()
    
    private var snackItemManager: SnackBarItemManager = SnackBarItemManager(type: .popcorn)
    
    private var rsvpOrder: MovieReservation?
    
    private let confirmationToastView = ConfirmationToastView()
    
    private var toastViewTopAnchor: NSLayoutConstraint?
    
    private var isAnimatingToastView = false
    
    convenience init(itemType: SnackBarItemType?, rsvpOrder: MovieReservation?) {
        self.init()
        self.rsvpOrder = rsvpOrder
        type = itemType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDataSource()
        collectionView.reloadData()
        updateCartInfo()
        setupUI()
    }
    
    private func setupUI() {
        addCustomNavBar()
        addBanner()
        view.addSubviews(subviews: [collectionView, confirmationToastView, orderCartView])
    
        collectionView.disableTranslatesAutoresizingMaskIntoContraints()
        collectionView.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: AppTheme.BannerBottomMargin)
        collectionView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        collectionView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        orderCartView.topAnchor.tc_constrain(equalTo: collectionView.bottomAnchor)
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 0)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: 0)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        orderCartView.continueButton.setTitle(ButtonTitle.ContinueToPurchase.getString(), for: .normal)
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        orderCartView.cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        
        /// Configures the toast view for when an item is added to the order
        confirmationToastView.disableTranslatesAutoresizingMaskIntoContraints()
        confirmationToastView.widthAnchor.tc_constrain(equalTo: view.widthAnchor, constant: 0)
        confirmationToastView.heightAnchor.tc_constrain(equalToConstant: Style.ToastHeight)
        confirmationToastView.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        toastViewTopAnchor = confirmationToastView.bottomAnchor.constraint(equalTo: orderCartView.topAnchor, constant: Style.ToastHeight)
        toastViewTopAnchor?.isActive = true
        
        view.bringSubviewToFront(confirmationToastView)
        view.bringSubviewToFront(orderCartView)
    }
    
    @objc private func didTapContinueButton() {
        let vc = PaymentOrderVC(rsvpOrder: rsvpOrder)
        AppNavigation.shared.navigateTo(vc)
   
    }
    
    @objc func didTapCartButton() {
        
    }
    
    private func updateCartInfo() {
        guard let rsvpOrder = rsvpOrder else { return }
        orderCartView.updateItemCountAndPrice(addItemQuantity: rsvpOrder.tickets.quantity, price: rsvpOrder.tickets.calculateTotalPrice())
    }
    
    /// setup collection view datasource
    func setupCollectionViewDataSource() {
        guard let type = type else { return }
        snackItemManager = SnackBarItemManager(type: type)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SnackBarCell.self, forCellWithReuseIdentifier: SnackBarCell.reuseIdentifier)
        collectionView.register(SnackBarItemOptionCell.self, forCellWithReuseIdentifier: SnackBarItemOptionCell.reuseID)
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
        
        appNavBar.configureNavBar(withTitle: NavigationTitle.FoodDeliveryOrPickup.getString(), withSubtitle: rsvpOrder?.location)
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
    
    /// Shows toast view and then hides it after a few seconds
    func showAndAutoHideConfirmationToast(withItem item: String, size: String) {
        guard toastViewTopAnchor?.constant == Style.ToastHeight else { return }
        confirmationToastView.setToastLabel(item: item, size: size)
        
        /// Show toast view
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.isAnimatingToastView = true
            sSelf.toastViewTopAnchor?.isActive = false
            sSelf.toastViewTopAnchor?.constant = 0
            sSelf.toastViewTopAnchor?.isActive = true
            sSelf.view.layoutIfNeeded()
        } completion: { finished in
            /// Hide toast view
            UIView.animate(withDuration: 0.3, delay: 2.5) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.toastViewTopAnchor?.isActive = false
                sSelf.toastViewTopAnchor?.constant = Style.ToastHeight
                sSelf.toastViewTopAnchor?.isActive = true
                sSelf.view.layoutIfNeeded()
            } completion: { [weak self] finished in
                guard let sSelf = self else { return }
                sSelf.isAnimatingToastView = false
            }
        }
    }
    
    // Helpers
    
    func getSnackBarItems() -> [SnackBarItemModel] {
        return snackItemManager.items
    }
    
    // MARK: - Alert methods
    
    // Popcorn method
    func setupAlertForSelectedPopcornSnack(index: Int, item: SnackBarItemModel) -> (UIAlertAction, String) {
        var alertAction = UIAlertAction()
        var sizeString = ""
        
        if index == 1 {
            // traditional
            SnackBarTraditionalPopcornPrice.allCases.forEach { size in
                let action = UIAlertAction(title: size.getSizeAndPriceStringVal(), style: .default) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.rsvpOrder?.foodOrder?.popcorn?.append(Popcorn(title: item.name, price: item.priceNumber, size: size.getStringVal()))
                    sSelf.snackOrder.send(item)
                    sSelf.showAndAutoHideConfirmationToast(withItem: item.name, size: size.getStringVal())
                    sSelf.orderCartView.updateItemCountAndPrice(addItemQuantity: 1, price: item.priceNumber)
                    sSelf.view.setNeedsLayout()
                }
                
                alertAction = action
                sizeString = size.getSizeAndPriceStringVal()
            }
        } else if index == 2 {
            // gourmet single
            SnackBarGourmetSinglePopcornPrice.allCases.forEach { size in
                let action = UIAlertAction(title: size.getSizeAndPriceStringVal(), style: .default) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.rsvpOrder?.foodOrder?.popcorn?.append(Popcorn(title: item.name, price: item.priceNumber, size: size.getStringVal()))
                    sSelf.snackOrder.send(item)
                    sSelf.showAndAutoHideConfirmationToast(withItem: item.name, size: size.getStringVal())
                    sSelf.orderCartView.updateItemCountAndPrice(addItemQuantity: 1, price: item.priceNumber)
                    sSelf.view.setNeedsLayout()
                }

                alertAction = action
                sizeString = size.getSizeAndPriceStringVal()
            }
        } else if index == 3 {
            // gourmet duo
            SnackBarGourmetDuoPopcornPrice.allCases.forEach { size in
                let action = UIAlertAction(title: size.getSizeAndPriceStringVal(), style: .default) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.rsvpOrder?.foodOrder?.popcorn?.append(Popcorn(title: item.name, price: item.priceNumber, size: size.getStringVal()))
                    sSelf.snackOrder.send(item)
                    sSelf.showAndAutoHideConfirmationToast(withItem: item.name, size: size.getStringVal())
                    sSelf.orderCartView.updateItemCountAndPrice(addItemQuantity: 1, price: item.priceNumber)
                    sSelf.view.setNeedsLayout()
                }

                alertAction = action
                sizeString = size.getSizeAndPriceStringVal()
            }
        }
        
        return (alertAction, sizeString)
    }
    
}
