//
//  SignInVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit

/// Sign-In VC
class SignInVC: BaseViewController, AppNavigationBarDelegate {
    
    /// Style struct
    fileprivate struct Style {
        static let BannerHeight: CGFloat = 100
        static let BannerTopAnchorConstant: CGFloat = 9
        static let BannerLeadingTrailingMargin: CGFloat = 12
        static let BannerCornerRadius: CGFloat = 15
    }
    
    /// Cycled banner collection view4
    fileprivate lazy var cycledBanner: CycledBanner = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width - Style.BannerLeadingTrailingMargin * 2, height: Style.BannerHeight)
        let collectionView = CycledBanner(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = Style.BannerCornerRadius
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    /// Banner's wrapper view for displaying the drop shadow
    fileprivate lazy var bannerWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addShadow(color: .black, opacity: 0.25, radius: 6, offset: CGSize(width: 1, height: 3))
        return view
    }()
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .SignIn)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: NavigationTitle.SignIn.getString())
    }
}
