//
//  BaseViewController.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/8/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    fileprivate struct Style {
        static let MenuButtonSize: CGFloat = 24
        static let NavigationTitleLeftRightMargin: CGFloat = 32
        static let NavigationTitleFontSize: CGFloat = 25
        static let NavigationTitleTextColor: UIColor = UIColor.white
        static let RightButtonTintColor: UIColor = AppColors.RegularGray
    }
    
    /// Right bar button item
    fileprivate lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 0, y: 0, width: Style.MenuButtonSize, height: Style.MenuButtonSize)
        menuButton.setImage(UIImage(named: NavigationIcon.MenuButton.getString())?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.imageView?.tintColor = AppColors.RegularGray
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        return menuButton
    }()
    
    public var statusBarHeight: CGFloat {
        get { return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44}
    }
    
    static var source: String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /// Refactor - do we want this to be nil? Its already an empty string
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.BackgroundMain
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: BaseViewController.source)
    }
    
    ///  Use a viewController's title to set the "source" property, which is then used to set the title & style of the navigationBar in the root navigation controller. "source" is a static property belonging to the BaseViewController class.
    public func setSource(sourceTitle: String) {
        BaseViewController.source = sourceTitle
    }
    
    /// Opens side menu
    /// Will need custom class, that can be triggered from multiple places throughout app. Refactor
    @objc fileprivate func openSideMenu() {
        
    }
    
    /// Sets up navigationBar depending on source view controller. All tab view controllers use the regular setup, otherwise a more custom style is applied.
    func setupNavigationBar(title: String) {
        if let tabTitle = TabBarItemTitle(rawValue: title) {
            applyMainNavigationBarStyle(title: tabTitle)
        } else {
            /// handles other viewcontrollers that are NOT the 4 main tabBar ViewControllers
            ///
        }
    }

    /// Sets up regular navigation bar used by all 4 Tabbar viewControllers.
    func applyMainNavigationBarStyle(title: TabBarItemTitle) {
        // if the view contrller is any of the 4 tab VCs, set up navigationBar
        /// Method that sets up the navigation bar
        if let tabBarController = AppNavigation.shared.viewControllers.first {
            tabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
            tabBarController.navigationItem.rightBarButtonItem?.tintColor = AppColors.RegularGray
            let titleLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.width - Style.NavigationTitleLeftRightMargin, view.frame.height))
            titleLabel.text = title.getString()
            titleLabel.textColor = Style.NavigationTitleTextColor
            titleLabel.font = AppFont.semiBold(size: Style.NavigationTitleFontSize)
            
            tabBarController.navigationItem.titleView = titleLabel
        }
    }
}
