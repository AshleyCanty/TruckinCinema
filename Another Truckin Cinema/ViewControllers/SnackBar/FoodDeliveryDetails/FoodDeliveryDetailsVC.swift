//
//  FoodDeliveryDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/22/23.
//

import Foundation
import UIKit

class FoodDeliveryDetailsVC: BaseViewController, AppNavigationBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .FoodDeliveryOrPickUp, shouldShowTimer: true)
    
    /// order cart view
    private lazy var orderCartView = OrderCartView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionDataSource()
        setupUI()
    }
    
    private func setupUI() {
        addCustomNavBar()
        view.addSubviews(subviews: [collectionView, orderCartView])
        
        collectionView.backgroundColor = AppColors.BackgroundMain
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        collectionView.disableTranslatesAutoresizingMaskIntoContraints()
        collectionView.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor)
        collectionView.bottomAnchor.tc_constrain(equalTo: orderCartView.topAnchor)
        collectionView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        collectionView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        
        orderCartView.disableTranslatesAutoresizingMaskIntoContraints()
        orderCartView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        orderCartView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        orderCartView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        orderCartView.heightAnchor.tc_constrain(equalToConstant: OrderCartView.Style.Height)
        
        orderCartView.continueButton.setTitle(ButtonTitle.ContinueToPurchase.getString(), for: .normal)
        orderCartView.continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
    }
    
    private func setCollectionDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FoodDeliveryTimeCell.self, forCellWithReuseIdentifier: FoodDeliveryTimeCell.reuseId)
        collectionView.register(FoodDeliveryRecipientCell.self, forCellWithReuseIdentifier: FoodDeliveryRecipientCell.reuseId)
    }
    
    @objc private func didTapContinueButton() {
        let vc = PaymentOrderVC()
        AppNavigation.shared.navigateTo(vc)
    }
    
    @objc private func didTapCartButton() {
        // show cart modal
    }
    
    @objc private func didTapAddMoreFoodButton() {
        let vc = SnackBarVC()
        AppNavigation.shared.navigateTo(vc)
    }
    
    // MARK: - App NavBar Delegate Methods
    
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

extension FoodDeliveryDetailsVC {
    
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

// MARK: - Collection View Delegate Methods

extension FoodDeliveryDetailsVC {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - (AppTheme.LeadingTrailingMargin*2))
        if indexPath.item == 0 {
            return CGSize(width: width, height: 335)
        } else {
            return CGSize(width: width, height: 210)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodDeliveryTimeCell.reuseId, for: indexPath) as? FoodDeliveryTimeCell {
                cell.addMoreFoodButton.addTarget(self, action: #selector(didTapAddMoreFoodButton), for: .touchUpInside)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodDeliveryRecipientCell.reuseId, for: indexPath) as? FoodDeliveryRecipientCell {
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
