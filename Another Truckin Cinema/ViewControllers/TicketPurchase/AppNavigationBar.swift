//
//  CustomNavigationBar.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit


protocol AppNavigationBarDelegate: AnyObject {
    func didPressNavBarLeftButton()
    func didPressNavBarRightButton()
}

/// AppNavigationBar class
class AppNavigationBar: UIView {
    /// style struct
    struct Style {
        static let Height: CGFloat = 44
        static let HeightWithSubtitle: CGFloat = 75
        static let LeftMargin: CGFloat = AppTheme.LeadingTrailingMargin
        static let LeftMarginWithIcon: CGFloat = 8
        static let RightMargin: CGFloat = 15
        static let BackButtonHeight: CGFloat = 23
        static let BackButtonWidth: CGFloat = 16.33
        static let BackButtonTintColor: UIColor = .white
        static let CloseButtonHeight: CGFloat = 21
        static let CloseButtonWidth: CGFloat = 22.33
        static let CloseButtonTintColor: UIColor = .white
        static let MenuButtonSize: CGFloat = 25
        static let MenuButtonTintColor: UIColor = AppColors.RegularGray
        static let TitleLabelTextColor: UIColor = .white
        static let TitleLabelFont: UIFont = AppFont.semiBold(size: 18)
        static let LargeTitleLabelFont: UIFont = AppFont.semiBold(size: 25)
        static let SubtitleLabelTextColor: UIColor = AppColors.MovieDetailsTextColorSecondary
        static let SubtitleLabelFont: UIFont = AppFont.regular(size: 10)
        static let StackLeftSpacing: CGFloat = 12
        static let StackRightSpacing: CGFloat = 12
        static let CloseButtonBottomSpacing: CGFloat = 5
    }
    
    /// enum for Title View types
    enum NavBarType {
        case Plain // VC title and menu button
        case MovieDetails
        case MovieRSVP
        case PurchaseConfirmation
        case FoodDeliveryOrPickUp
        case SignUp
    }
    /// stackview for timer & close button
    lazy var rightSideStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.spacing = 8
        return stack
    }()
    /// stackview for labels
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    /// title label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleLabelFont
        label.lineBreakMode = .byWordWrapping
        label.textColor = Style.TitleLabelTextColor
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    /// subtitle label
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.SubtitleLabelFont
        label.lineBreakMode = .byWordWrapping
        label.textColor = Style.SubtitleLabelTextColor
        label.sizeToFit()
        return label
    }()
    /// back button
    lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.imageView?.tintColor = Style.BackButtonTintColor
        btn.addTarget(self, action: #selector(didPressLeftButton), for: .touchUpInside)
        return btn
    }()
    /// close button
    lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.imageView?.tintColor = Style.CloseButtonTintColor
        btn.tintColor = Style.CloseButtonTintColor
        btn.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        return btn
    }()
    /// menu button
    lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(imgNamed: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.imageView?.tintColor = Style.MenuButtonTintColor
        menuButton.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        return menuButton
    }()
    /// timer label
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = Style.SubtitleLabelFont
        label.lineBreakMode = .byWordWrapping
        label.textColor = Style.SubtitleLabelTextColor
        label.sizeToFit()
        return label
    }()
    /// timer
    private lazy var timer = Timer()
    /// title view
    private lazy var titleView = UIView()
    /// view for holding rightSide stack
    private lazy var rightSideView = UIView()
    /// width constraint for right side view
    private lazy var rightSideViewWidthConstraint = NSLayoutConstraint()
    /// delegate for AppNavigationBarDelegate
    weak var delegate: AppNavigationBarDelegate?
    /// type for setting up navbar views and constraints
    private var type: NavBarType?

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: getwindowSceneWidth(), height: Style.HeightWithSubtitle)
    }
    
    init(type: NavBarType) {
        super.init(frame: .zero)
        self.type = type
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rightSideViewWidthConstraint.constant = max(Style.CloseButtonWidth, timerLabel.intrinsicContentSize.width)
        layoutIfNeeded()
    }

    /// configure views
    private func configure() {
        self.tintColor = .white
 
        switch type {
        case .Plain: setupViewsForPlainNavBar()
        case .MovieDetails:
            setupViewsForMovieDetails()
        case .MovieRSVP:
            setupViewsForRSVPFlow()
        case .PurchaseConfirmation:
            setupViewsForPurchaseConfirmation()
        case .FoodDeliveryOrPickUp:
            setupViewsFoodDeliveryOrPickup()
        case .SignUp:
            setupViewsForSignUp()
        case .none: break // do nothing
        }
        
        configureNavBar()
    }

    /// configure based on type
    public func configureNavBar(withTitle title: String? = "Transformers: Rise of the Beasts Collection",
                                    withSubtitle subtitle: String? = "Drive-in No. 3 Zanzibar | Sun, Jun 11 | 8:30pm",
                                    shouldEnableTimer: Bool? = false) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        timerLabel.text = "7:00"
    }
    
    // MARK: - Delegate methoda
    
    @objc private func didPressLeftButton() {
        delegate?.didPressNavBarLeftButton()

    }
    
    @objc private func didPressRightButton() {
        delegate?.didPressNavBarRightButton()
    }
}

// MARK: - Methods for setting up views

extension AppNavigationBar {
    
    private func setupViewsForPlainNavBar() {
        titleLabel.font = Style.LargeTitleLabelFont
        addSubview(titleLabel)
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMargin)
        titleLabel.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        
        addSubview(menuButton)
        menuButton.disableTranslatesAutoresizingMaskIntoContraints()
        menuButton.heightAnchor.tc_constrain(equalToConstant: Style.MenuButtonSize)
        menuButton.widthAnchor.tc_constrain(equalToConstant: Style.MenuButtonSize)
        menuButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
        menuButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
    }
    
    private func setupViewsForMovieDetails() {
        addSubview(backButton)
        backButton.disableTranslatesAutoresizingMaskIntoContraints()
        backButton.heightAnchor.tc_constrain(equalToConstant: Style.BackButtonHeight)
        backButton.widthAnchor.tc_constrain(equalToConstant: Style.BackButtonWidth)
        backButton.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMarginWithIcon)
        backButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
    }
    
    private func setupViewsForRSVPFlow() {
        
        addSubview(titleView)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        titleView.addSubview(titleStack)
        
        // Add views
        addSubview(backButton)
        addSubview(rightSideView)
        
        rightSideView.addSubview(closeButton)
        rightSideView.addSubview(timerLabel)
        
        // Add constraints
        
        /// back button - left side
        backButton.disableTranslatesAutoresizingMaskIntoContraints()
        backButton.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMarginWithIcon)
        backButton.heightAnchor.tc_constrain(equalToConstant: Style.BackButtonHeight)
        backButton.widthAnchor.tc_constrain(equalToConstant: Style.BackButtonWidth)
        backButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor, constant: 0)
        
        /// stack view - middle
        titleStack.disableTranslatesAutoresizingMaskIntoContraints()
        titleStack.tc_constrainToSuperview()
        
        titleView.disableTranslatesAutoresizingMaskIntoContraints()
        titleView.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: Style.StackLeftSpacing)
        titleView.topAnchor.tc_constrain(equalTo: topAnchor, constant: 0)
        titleView.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: -5)
        
        
        /// Right side view (timer label & close button)
        rightSideView.disableTranslatesAutoresizingMaskIntoContraints()
        rightSideView.topAnchor.tc_constrain(equalTo: topAnchor)
        rightSideView.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: 0)
        rightSideView.leadingAnchor.tc_constrain(equalTo: titleView.trailingAnchor, constant: Style.StackRightSpacing)
        rightSideView.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
        rightSideViewWidthConstraint = rightSideView.widthAnchor.constraint(equalToConstant: max(Style.CloseButtonWidth , timerLabel.intrinsicContentSize.width))
        rightSideViewWidthConstraint.isActive = true
        
        closeButton.disableTranslatesAutoresizingMaskIntoContraints()
        closeButton.heightAnchor.tc_constrain(equalToConstant: Style.CloseButtonHeight)
        closeButton.widthAnchor.tc_constrain(equalToConstant: Style.CloseButtonWidth)
        closeButton.centerYAnchor.tc_constrain(equalTo: rightSideView.centerYAnchor)
        
        timerLabel.disableTranslatesAutoresizingMaskIntoContraints()
        timerLabel.leadingAnchor.tc_constrain(equalTo: rightSideView.leadingAnchor)
        timerLabel.trailingAnchor.tc_constrain(equalTo: rightSideView.trailingAnchor)
        timerLabel.bottomAnchor.tc_constrain(equalTo: rightSideView.bottomAnchor, constant: -5)
    }
    
    private func setupViewsForPurchaseConfirmation() {
        
    }
    
    private func setupViewsForSignUp() {
        
    }
    
    private func setupViewsFoodDeliveryOrPickup() {
        
    }
}
