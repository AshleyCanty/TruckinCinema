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
        static let HeightWithSubtitle: CGFloat = 70
        static let LeftMargin: CGFloat = AppTheme.LeadingTrailingMargin
        static let LeftMarginWithIcon: CGFloat = 8
        static let RightMargin: CGFloat = 15
        static let BackButtonHeight: CGFloat = 23
        static let BackButtonWidth: CGFloat = 16.33
        static let BackButtonTintColor: UIColor = AppColors.TextColorPrimary
        static let CloseButtonHeight: CGFloat = 17
        static let CloseButtonWidth: CGFloat = 19
        static let CloseButtonTintColor: UIColor = AppColors.TextColorPrimary
        static let MenuButtonSize: CGFloat = 25
        static let MenuButtonTintColor: UIColor = AppColors.RegularGray
        static let TitleViewLeftMargin: CGFloat = 25
        static let TitleViewRightMargin: CGFloat = 12
        static let TitleLabelTextColor: UIColor = AppColors.TextColorPrimary
        static let TitleLabelFont: UIFont = AppFont.semiBold(size: 18)
        static let LargeTitleLabelFont: UIFont = AppFont.semiBold(size: 25)
        static let SubtitleLabelTextColor: UIColor = AppColors.TextColorSecondary
        static let SubtitleLabelFont: UIFont = AppFont.regular(size: 10)
        static let SubtitleLabelMediumFont: UIFont = AppFont.medium(size: 13)
        static let SubtitleMediumFontPurchaseScreen: UIFont = AppFont.medium(size: 11)
        static let SubtitleTextColorSecondary: UIColor = AppColors.TextColorPrimary
        static let CloseButtonBottomSpacing: CGFloat = 5
    }
    
    /// enum for Title View types
    enum NavBarType {
        case Plain // VC title and menu button
        case MovieDetails
        case MovieRSVP
        case PurchaseConfirmation
        case FoodDeliveryOrPickUp
        case SignIn
        case Registration
        case ContactInfo
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
    /// timer for rsvp flow
    private lazy var shouldShowTimer: Bool = false
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: getwindowSceneWidth(), height: Style.HeightWithSubtitle)
    }
    
    init(type: NavBarType, shouldShowTimer: Bool = false) {
        super.init(frame: .zero)
        self.type = type
        self.shouldShowTimer = shouldShowTimer
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
    
    /// updates timer label
    public func updateTimerLabel(with timeLeft: String) {
        timerLabel.text = timeLeft
    }

    /// configure views
    private func configure() {
        backgroundColor = AppColors.BackgroundMain
        self.tintColor = AppColors.TextColorPrimary
 
        switch type {
        case .Plain: setupViewsForPlainNavBar()
        case .MovieDetails:
            backgroundColor = .clear
            setupViewsForMovieDetails()
        case .MovieRSVP:
            setupViewsForRSVPFlow()
        case .PurchaseConfirmation:
            setupViewsForPurchaseConfirmation()
        case .FoodDeliveryOrPickUp:
            setupViewsForFoodDeliveryOrPickup()
        case .SignIn:
            setupViewsForSignIn()
        case .Registration:
            setupViewsForRegistration()
        case .ContactInfo:
            setupViewsForContactInfo()
        case .none: break // do nothing
        }
        
        configureNavBar()
    }

    /// configure based on type
    public func configureNavBar(withTitle title: String? = "Transformers: Rise of the Beasts Collection",
                                    withSubtitle subtitle: String? = "Drive-in No. 3 Zanzibar | Sun, Jun 11 | 8:30pm") {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    /// returns true if timer is enabled
    public func isTimerEnabled() -> Bool {
        return shouldShowTimer
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
        addSubview(titleLabel)
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMargin)
        titleLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
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
        setBackButtonConstraints()
    }
    
    private func setupViewsForRSVPFlow() {
        /// Hide close button once rsvp process has begin and start timer
        closeButton.isHidden = shouldShowTimer
        timerLabel.isHidden = !shouldShowTimer
        timerLabel.text = shouldShowTimer ? "07:00" : ""
        
        // Add views
        addSubview(titleView)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        titleView.addSubview(titleStack)
        
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
        titleView.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: Style.TitleViewLeftMargin)
        titleView.topAnchor.tc_constrain(equalTo: topAnchor, constant: 0)
        titleView.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: -5)
        titleView.trailingAnchor.tc_constrain(lessThanOrEqualTo: rightSideView.leadingAnchor, constant: Style.TitleViewRightMargin)

        /// Right side view (timer label & close button)
        rightSideView.disableTranslatesAutoresizingMaskIntoContraints()
        rightSideView.topAnchor.tc_constrain(equalTo: topAnchor)
        rightSideView.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: 0)
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
        subtitleLabel.textColor = Style.SubtitleTextColorSecondary
        subtitleLabel.font = Style.SubtitleMediumFontPurchaseScreen
        
        addSubview(closeButton)
        addSubview(titleView)
        titleView.addSubview(titleStack)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        
        titleStack.disableTranslatesAutoresizingMaskIntoContraints()
        titleStack.leadingAnchor.tc_constrain(equalTo: titleView.leadingAnchor)
        titleStack.trailingAnchor.tc_constrain(equalTo: titleView.trailingAnchor)
        titleStack.topAnchor.tc_constrain(equalTo: topAnchor)
        
        titleView.disableTranslatesAutoresizingMaskIntoContraints()
        titleView.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMargin)
        titleView.topAnchor.tc_constrain(equalTo: topAnchor)
        titleView.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        
        closeButton.disableTranslatesAutoresizingMaskIntoContraints()
        closeButton.heightAnchor.tc_constrain(equalToConstant: Style.CloseButtonHeight)
        closeButton.widthAnchor.tc_constrain(equalToConstant: Style.CloseButtonWidth)
        closeButton.leadingAnchor.tc_constrain(equalTo: titleView.trailingAnchor, constant: Style.TitleViewRightMargin)
        closeButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
        closeButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
    }
    
    private func setupViewsForFoodDeliveryOrPickup() {
        addSubview(backButton)
        addSubview(titleView)
        titleView.addSubview(titleStack)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        
        setBackButtonConstraints()
        
        titleStack.disableTranslatesAutoresizingMaskIntoContraints()
        titleStack.tc_constrainToSuperview()
        
        titleView.disableTranslatesAutoresizingMaskIntoContraints()
        titleView.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: Style.TitleViewLeftMargin)
        titleView.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        titleView.topAnchor.tc_constrain(equalTo: topAnchor)
        titleView.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
    }
    
    private func setupViewsForSignIn() {
        addSubview(titleLabel)
        addSubview(closeButton)
        
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMargin)
        titleLabel.topAnchor.tc_constrain(equalTo: topAnchor)
        titleLabel.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        closeButton.disableTranslatesAutoresizingMaskIntoContraints()
        closeButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        closeButton.heightAnchor.tc_constrain(equalToConstant: Style.CloseButtonHeight)
        closeButton.widthAnchor.tc_constrain(equalToConstant: Style.CloseButtonWidth)
        closeButton.leadingAnchor.tc_constrain(lessThanOrEqualTo: titleLabel.trailingAnchor)
        closeButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
        closeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupViewsForRegistration() {
        subtitleLabel.font = Style.SubtitleLabelMediumFont
        subtitleLabel.textColor = Style.SubtitleTextColorSecondary
        
        addSubview(backButton)
        addSubview(titleView)
        titleView.addSubview(titleStack)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        
        setBackButtonConstraints()
        
        titleStack.disableTranslatesAutoresizingMaskIntoContraints()
        titleStack.tc_constrainToSuperview()
        
        titleView.disableTranslatesAutoresizingMaskIntoContraints()
        titleView.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: Style.TitleViewLeftMargin)
        titleView.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        titleView.topAnchor.tc_constrain(equalTo: topAnchor)
        titleView.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
    }
    
    private func setupViewsForContactInfo() {
        addSubview(backButton)
        setBackButtonConstraints()
        
        addSubview(titleLabel)
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: Style.LeftMargin)
        titleLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.RightMargin)
        titleLabel.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = AppColors.RegularGray.withAlphaComponent(0.30)
        
        addSubview(bottomBorder)
        bottomBorder.disableTranslatesAutoresizingMaskIntoContraints()
        bottomBorder.heightAnchor.tc_constrain(equalToConstant: 1)
        bottomBorder.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        bottomBorder.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        bottomBorder.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
    }
    
    private func setBackButtonConstraints() {
        backButton.disableTranslatesAutoresizingMaskIntoContraints()
        backButton.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.LeftMarginWithIcon)
        backButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        backButton.heightAnchor.tc_constrain(equalToConstant: Style.BackButtonHeight)
        backButton.widthAnchor.tc_constrain(equalToConstant: Style.BackButtonWidth)
    }
}
