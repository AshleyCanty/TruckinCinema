//
//  RegistrationVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit
import Combine


/// Registration VC
class RegistrationVC: BaseViewController, AppNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    enum RegistrationTextFieldType: Int {
        case FirstName
        case LastName
        case Email
        case Password
    }
    
    /// Style struct
    struct Style {
        static let RSVPButtonHeight: CGFloat = 50
        static let BodyTextFont = AppFont.regular(size: 12)
        static let BodyTextColor = UIColor(hex: "A3A3B1")
        static let TitleTextColor = AppColors.TextColorPrimary
        static let TitleFont = AppFont.semiBold(size: 17)
        static let SubtitleTextColor = AppColors.TextColorPrimary
        static let SubtitleFont = AppFont.semiBold(size: 12)
        static let ErrorTextColor = AppColors.AlertLabelTextColor
        static let ErrorTextFont = AppFont.regular(size: 12)
        static let PasswordCheckerPillFont = AppFont.regular(size: 10)
        static let PasswordCheckerPillTextColor = AppColors.PasswordCheckUnselected
        static let PasswordCheckerPillColor = AppColors.PasswordCheckBackgroundUnselected
        static let PasswordCheckerPillTextColorActive = AppColors.PasswordCheckSelected
        static let PasswordCheckerPillColorActive = AppColors.PasswordCheckBackgroundSelected
        static let PasswordCheckerIconSize = 13
        static let IconSize: CGFloat = 60
    }
    
    /// Step / Screen in registration process
    private lazy var stepInRegistration: RegistrationStep = .One
    /// VIP Tier
    private lazy var vipTier: VIPTier = .Tier1
    
    private var firstNameIsValid: Bool = false
    
    private var lastNameIsValid: Bool = false
    
    private var emailIsValid: Bool = false
    
    private var passwordIsValid: Bool = false
    
    /// rsvp button
    fileprivate lazy var continueButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.RSVPNow.getString(), for: .normal)
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.backgroundColor = AppColors.BackgroundMain
        table.delegate = self
        table.dataSource = self
        table.register(RegistrationCellStepOne.self, forCellReuseIdentifier: RegistrationCellStepOne.reuseId)
        table.register(RegistrationCellStepTwo.self, forCellReuseIdentifier: RegistrationCellStepTwo.reuseId)
        return table
    }()
    
    /// Custom nav bar
    private lazy var appNavBar = AppNavigationBar(type: .Registration)
    
    init(step: RegistrationStep, tier: VIPTier) {
        super.init()
        stepInRegistration = step
        vipTier = tier
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: "Registration VC")
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        view.addSubviews(subviews: [tableView, continueButton])
        
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor)
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        continueButton.disableTranslatesAutoresizingMaskIntoContraints()
        continueButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        continueButton.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: AppTheme.BottomMargin)
        continueButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        continueButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        continueButton.topAnchor.tc_constrain(equalTo: tableView.bottomAnchor)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        if stepInRegistration == .One {
            continueButton.setTitle(ButtonTitle.Continue.getString(), for: .normal)
        } else {
            continueButton.setTitle(ButtonTitle.Submit.getString(), for: .normal)
        }
        
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() {}
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self

        appNavBar.configureNavBar(withTitle: NavigationTitle.MyATCMembership.getString(), withSubtitle: "VIP Tier \(vipTier.getString()) - Step \(stepInRegistration.getString()) of 2")
    }
    
    @objc func textFieldDidChange(_ textField: RoundedTextField) {
        let text = textField.text ?? ""
        let type = RegistrationTextFieldType(rawValue: textField.tag)
        
        // TODO - store the input using this method.
        // eliminates need for flags when you tap Continue Button
        
        switch type {
        case .FirstName:
            firstNameIsValid = !text.isEmpty
        case .LastName:
            lastNameIsValid = !text.isEmpty
        case .Email:
            emailIsValid = text.isValidEmailAddress()
        case .Password:
            passwordIsValid = checkIfPasswordIsValid(string: text)
        default:
            break
        }
    }
    
    /// checks if passwor dis valid and updates UI for passwordChcker pills
    private func checkIfPasswordIsValid(string: String) -> Bool {
        let containsLowercase = string.containsLowerCase
        let containsUppercase = string.containsUpperCase
        let containsSpecialCharacter = string.containsSpecialCharacter
        
        var isValid = false
        if containsLowercase || containsUppercase || containsSpecialCharacter {
            guard let cell = tableView.visibleCells.first as? RegistrationCellStepOne, let pills = cell.passwordCheckerPills as? [PasswordCheckerPill] else { return false }
            pills.forEach { pill in

                switch pill.type {
                case .LowercaseLetter:
                    pill.isEnabled = containsLowercase
                case .CapitalLetter:
                    pill.isEnabled = containsUppercase
                case .SpecialCharacter:
                    pill.isEnabled = containsSpecialCharacter
                }
            }
        }
        if containsLowercase && containsUppercase && containsSpecialCharacter {
             isValid = true
        }
        return isValid
    }
    
    
    @objc func didTapContinueButton() {
        // 1. Check to make sure all input is collected
        // 2. Store data
        // 3. Show next screen
        if stepInRegistration == .One {
//            guard let cell = tableView.visibleCells.first as? RegistrationCellStepOne else { return }
//            if !firstNameIsValid || !lastNameIsValid {
//                cell.errorLabel.text = RegistrationErrorMessage.MissingBasicInfo.getString()
//            } else if !emailIsValid {
//                cell.errorLabel.text = RegistrationErrorMessage.InvalidEmail.getString()
//            } else if !passwordIsValid {
//                cell.errorLabel.text = RegistrationErrorMessage.InvalidPassword.getString()
//            } else {
                AppNavigation.shared.navigateTo(RegistrationVC(step: .Two, tier: vipTier))
//            }
        } else {
            guard let cell = tableView.visibleCells.first as? RegistrationCellStepTwo else { return }
            let birthdate = cell.datePicker.date
            let today = Date()
            
            guard let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian), let year = gregorian.components([.year], from: birthdate, to: today, options: []).year else { return }

//            if year <= 18 {
//                // user is under 18
//                cell.updateErrorLabel(errorType: .EighteenMinimum)
//            } else if year > 99 {
//                cell.updateErrorLabel(errorType: .NinetyNineMaximum)
//            } else {
                // show loading view for completion
                DispatchQueue.main.async {
                    self.showSpinner()
                }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                DispatchQueue.main.async {
                    self.hideSpinner()
                    if let tabBarController = self.navigationController?.viewControllers.first(where: {type(of: $0) == TabBarController.self }) as? TabBarController {
                        NotificationCenter.default.post(name: NSNotification.Name(AppNotificationNames.RegistrationComplete), object: nil)
                        tabBarController.selectedIndex = 0
                        AppNavigation.shared.popToRootVC()
                    }
                }
            }
//            }
            print(birthdate)
        }
        
    }
}

extension RegistrationVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch stepInRegistration {
        case .One:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCellStepOne.reuseId, for: indexPath) as! RegistrationCellStepOne
            let textFields = [cell.firstNameField, cell.lastNameField, cell.emailField, cell.passwordField]
            var tag = 0
            textFields.forEach { tf in
                tf.tag = tag
                tf.delegate = self
                tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                tag += 1
            }
            return cell
        case .Two:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCellStepTwo.reuseId, for: indexPath) as! RegistrationCellStepTwo
            return cell
        }
    }
}
