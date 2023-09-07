//
//  TicketSelectionVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit

/// TicketSelectionVC class
class TicketSelectionVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, AppNavigationBarDelegate, CycledBannerSignUpCellDelegate {
    
    /// Style struct
    fileprivate struct Style {
        static let ContinueButtonHeight: CGFloat = 50
        static let BannerHeight: CGFloat = 100
        static let BannerTopAnchorConstant: CGFloat = 9
        static let BannerLeadingTrailingMargin: CGFloat = 12
        static let BannerCornerRadius: CGFloat = 15
        static let PricingLabelFont: UIFont = AppFont.semiBold(size: 13)
        static let PricingLabelItalicFont: UIFont = AppFont.semiBoldItalic(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let RadioButonSize: CGFloat = 30
        static let RadioTitleFont: UIFont = AppFont.regular(size: 12)
        static let RadioTicketAmountLabelFont: UIFont = AppFont.semiBold(size: 17)
        static let RadioPriceLabelFont: UIFont = AppFont.regular(size: 12)
        static let RadioTopMargin: CGFloat = 80
        static let AlertLabelFont: UIFont = AppFont.regular(size: 12)
    }
    // enum for age range description
    enum PriceAgeRange: String {
        case GeneralAdmission = "General Admission (4 years of age and older) -"
        case Children = "Children (3 years or younger) - "
        func getString() -> String { return self.rawValue }
    }
    /// enum for ticket pricing
    enum TicketPrice: String {
        case GeneralAdmission = "$12.50"
        case Children = "FREE"
        func getString() -> String { return self.rawValue }
    }
    /// Radio button labels enum
    enum RadioButtonLabel: String {
        case Title = "Select your tickets"
        case SingleTicketSelection = "%@ Ticket"
        case MultiTicketsSelection = "%@ Tickets"
        func getString() -> String { return self.rawValue }
    }
    /// radio button icon enum
    enum RadioButtonIcon: String {
        case Minus = "minus-gray"
        case Plus = "plus"
        func getString() -> String { return self.rawValue }
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
    /// general admission label
    private lazy var generalAdmissionLabel: UILabel = {
        let label = UILabel()
        label.font = Style.PricingLabelFont
        label.textColor = Style.TextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "\(PriceAgeRange.GeneralAdmission.getString()) \(TicketPrice.GeneralAdmission.getString())"
        return label
    }()
    /// children admission label
    private lazy var childrenAdmissionLabel: UILabel = {
        let label = UILabel()
        label.font = Style.PricingLabelFont
        label.textColor = Style.TextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let attrString = NSMutableAttributedString(string: TicketPrice.Children.getString(), attributes: [NSAttributedString.Key.font: Style.PricingLabelItalicFont])
        let mainString = NSMutableAttributedString(string: PriceAgeRange.Children.getString())
        mainString.append(attrString)
        label.attributedText = mainString
        return label
    }()
    /// radio button for decrementing
    private lazy var radioButtonMinus: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: RadioButtonIcon.Minus.getString()), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.isEnabled = false
        return btn
    }()
    /// radio button for incrementing
    private lazy var radioButtonPlus: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: RadioButtonIcon.Plus.getString()), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    /// radio title label
    private lazy var radioTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Style.RadioTitleFont
        label.textColor = Style.TextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = RadioButtonLabel.Title.getString()
        return label
    }()
    /// radio selected ticket amount label
    private lazy var radioCounterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Style.RadioTicketAmountLabelFont
        label.textColor = Style.TextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    /// radio total ticket cost label
    private lazy var radioTicketCostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Style.RadioPriceLabelFont
        label.textColor = Style.TextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    /// continue button
    fileprivate lazy var continueButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.Continue.getString(), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    /// Max amount of tickets allower per purchase
    private let maxTicketsAllowed: Double = 10
    /// Amount of selected tickets
    private var numberOfSelectedTickets: Double = 0
    /// price of one ticket
    private let costOfSingleTicket: Double = 12.50
    /// sum total of all selected tickets
    private var totalPriceOfTickets: Double {
        return costOfSingleTicket * numberOfSelectedTickets
    }
    
    private lazy var appNavBar = AppNavigationBar(type: .MovieRSVP)
    /// maxLimitReachedLabel
    private lazy var maxLimitReachedLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.AlertLabelTextColor
        label.font = Style.AlertLabelFont
        label.textAlignment = .center
        label.text = "You can only select up to \(String(format: "%.0f", maxTicketsAllowed)) tickets per order."
        label.isHidden = true
        return label
    }()
    
    /// timer
    private var timer: Timer?
    /// timer amount in seconds
    private var timeLeft: Int = 420

    init(movieDetails: String) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
//        executeTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "TicketSelectionVC")
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
        addBannerConstraints()
        setupBannerDataSource()
        configure()
        
        radioTicketCostLabel.text = "$12.50"
        radioCounterLabel.text = "0 Tickets"
        
        radioButtonPlus.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        radioButtonMinus.addTarget(self, action: #selector(didTapMinusButton), for: .touchUpInside)
    }
    
    /// triggers timer
    private func executeTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let sSelf = self else { return }
            sSelf.timeLeft -= 1
            let str = sSelf.timeLeft.convertToMinutesAndSeconds()
            sSelf.appNavBar.updateTimerLabel(with: sSelf.timeLeft.convertToMinutesAndSeconds())
        })
    }
    
    @objc private func didTapMinusButton() {
        if numberOfSelectedTickets >= 1 {
            numberOfSelectedTickets -= 1
        }
        adjustRadioButtonsIfNeeded()
    }
    
    @objc private func didTapPlusButton() {
        if numberOfSelectedTickets < maxTicketsAllowed {
            numberOfSelectedTickets += 1
        }
        adjustRadioButtonsIfNeeded()
    }
    
    func adjustRadioButtonsIfNeeded() {
        if numberOfSelectedTickets == 0 {
            radioButtonMinus.isEnabled = false
            continueButton.isEnabled = false
        } else if numberOfSelectedTickets == maxTicketsAllowed {
            radioButtonPlus.isEnabled = false
            maxLimitReachedLabel.isHidden = false
        } else {
            radioButtonPlus.isEnabled = true
            radioButtonMinus.isEnabled = true
            maxLimitReachedLabel.isHidden = true
            continueButton.isEnabled = true
        }
        updateRadioLabels()
    }
    
    func updateRadioLabels() {
        let stringSelectedTickets = String(format: "%.0f", numberOfSelectedTickets)
        if numberOfSelectedTickets == 0 {
            radioCounterLabel.text = "\(stringSelectedTickets) Tickets"
            radioTicketCostLabel.text = String(format: "$%.02f", costOfSingleTicket)
        } else if numberOfSelectedTickets == 1 {
            radioCounterLabel.text = "\(stringSelectedTickets) Ticket"
            radioTicketCostLabel.text = String(format: "$%.02f", costOfSingleTicket)
        } else {
            radioCounterLabel.text = "\(stringSelectedTickets) Tickets"
            radioTicketCostLabel.text = String(format: "$%.02f", totalPriceOfTickets)
        }
    }
    
    private func configure() {
        let admissionsStack = UIStackView(arrangedSubviews: [generalAdmissionLabel, childrenAdmissionLabel])
        admissionsStack.axis = .vertical
        admissionsStack.distribution = .fill
        admissionsStack.alignment = .leading
        admissionsStack.spacing = 4
        view.addSubview(admissionsStack)
        
        admissionsStack.disableTranslatesAutoresizingMaskIntoContraints()
        admissionsStack.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: 15)
        admissionsStack.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        admissionsStack.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        let radioLabelStack = UIStackView(arrangedSubviews: [radioTitleLabel, radioCounterLabel, radioTicketCostLabel])
        radioLabelStack.axis = .vertical
        radioLabelStack.distribution = .fill
        radioLabelStack.alignment = .center
        radioLabelStack.spacing = 4
        radioLabelStack.setCustomSpacing(15, after: radioTitleLabel)
        
        let radioLabelStackWrapperView = UIView()
        radioLabelStackWrapperView.addSubview(radioLabelStack)
        
        radioLabelStack.disableTranslatesAutoresizingMaskIntoContraints()
        radioLabelStack.tc_constrainToSuperview()
        
        let radioHStack = UIStackView(arrangedSubviews: [radioButtonMinus, radioLabelStackWrapperView, radioButtonPlus])
        radioHStack.axis = .horizontal
        radioHStack.distribution = .equalCentering
        radioHStack.alignment = .center
        radioHStack.spacing = 25
        
        radioButtonMinus.disableTranslatesAutoresizingMaskIntoContraints()
        radioButtonMinus.heightAnchor.tc_constrain(equalToConstant: Style.RadioButonSize)
        radioButtonMinus.widthAnchor.tc_constrain(equalToConstant: Style.RadioButonSize)
        
        radioButtonPlus.disableTranslatesAutoresizingMaskIntoContraints()
        radioButtonPlus.heightAnchor.tc_constrain(equalToConstant: Style.RadioButonSize)
        radioButtonPlus.widthAnchor.tc_constrain(equalToConstant: Style.RadioButonSize)
        
        let radioHStackWrapperView = UIView()
        radioHStackWrapperView.addSubview(radioHStack)
        
        radioHStack.disableTranslatesAutoresizingMaskIntoContraints()
        radioHStack.tc_constrainToSuperview()
        
        view.addSubview(radioHStackWrapperView)
        radioHStackWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        radioHStackWrapperView.topAnchor.tc_constrain(equalTo: admissionsStack.bottomAnchor, constant: Style.RadioTopMargin)
        radioHStackWrapperView.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        
        view.addSubview(continueButton)
        continueButton.disableTranslatesAutoresizingMaskIntoContraints()
        continueButton.heightAnchor.tc_constrain(equalToConstant: Style.ContinueButtonHeight)
        continueButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        continueButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        continueButton.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppTheme.BottomMargin)
        
        view.addSubview(maxLimitReachedLabel)
        maxLimitReachedLabel.disableTranslatesAutoresizingMaskIntoContraints()
        maxLimitReachedLabel.topAnchor.tc_constrain(equalTo: radioHStackWrapperView.bottomAnchor, constant: 20)
        maxLimitReachedLabel.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
    }
    
    /// Sets up banner constraints
    fileprivate func addBannerConstraints() {
        cycledBanner.backgroundColor = AppColors.BannerCollectionBGColor
        cycledBanner.showsHorizontalScrollIndicator = false
        cycledBanner.showsVerticalScrollIndicator = false
        
        bannerWrapper.addSubview(cycledBanner)
        view.addSubview(bannerWrapper)
        
        /// banner shadow wrapper view constraints
        bannerWrapper.disableTranslatesAutoresizingMaskIntoContraints()
        bannerWrapper.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: Style.BannerTopAnchorConstant)
        bannerWrapper.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: Style.BannerLeadingTrailingMargin)
        bannerWrapper.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -Style.BannerLeadingTrailingMargin)
        bannerWrapper.heightAnchor.tc_constrain(equalToConstant: Style.BannerHeight)
        
        /// banner collection view constraints
        cycledBanner.disableTranslatesAutoresizingMaskIntoContraints()
        cycledBanner.tc_constrainToSuperview()
    }
    
    /// Sets up data source for both the banner and movie collection views
    fileprivate func setupBannerDataSource() {
        /// Cycled banner
        cycledBanner.delegate = self
        cycledBanner.dataSource = self
        cycledBanner.register(CycledBannerSignUpCell.self, forCellWithReuseIdentifier: CycledBannerSignUpCell.reuseIdentifier)
        cycledBanner.register(CycledBannerCell.self, forCellWithReuseIdentifier: CycledBannerCell.reuseIdentifier)
    }
    
    // MARK: - Signup Banner Delegate Methods
    
    func didPressSignUpButton() {
        let vc = RegistrationVC(step: .One, tier: .Tier1)
        AppNavigation.shared.navigateTo(vc)
    }
    
    // MARK: - Custom NavBar methods
    
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {
        // exit the flow? show alert
        showAlertToCancelOrder()
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.HeightWithSubtitle)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
    }
}

extension TicketSelectionVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycledBannerSignUpCell.reuseIdentifier, for: indexPath) as! CycledBannerSignUpCell
        cell.delegate = self
        return cell
    }
    
}

extension TicketSelectionVC {
    
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

