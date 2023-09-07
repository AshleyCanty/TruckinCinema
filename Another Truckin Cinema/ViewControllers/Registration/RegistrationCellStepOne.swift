//
//  RegistrationCellStepOne.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/3/23.
//

import Foundation
import UIKit
import Combine

class RegistrationCellStepOne: UITableViewCell {
    
    static let reuseId = "RegistrationCellStepOne"
    
    private let iconImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "red-carpet"))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.LargeTitleOne.getString()
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.SubtitleOne.getString()
        label.textColor = RegistrationVC.Style.SubtitleTextColor
        label.font = RegistrationVC.Style.SubtitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.DescriptionOne.getString()
        label.textColor = RegistrationVC.Style.BodyTextColor
        label.font = RegistrationVC.Style.BodyTextFont
        label.numberOfLines = 0
        return label
    }()
    
    let firstNameField = RoundedTextField(placeholder: RegistrationPlaceholder.FirstName.getString())
    
    let lastNameField = RoundedTextField(placeholder: RegistrationPlaceholder.LastName.getString())
    
    let emailField = RoundedTextField(placeholder: RegistrationPlaceholder.Email.getString())
    
    let passwordField = RoundedTextField(type: .Password, placeholder: RegistrationPlaceholder.Password.getString())
    
    let passwordCheckerPills: [UIView] = [PasswordCheckerPill(type: .LowercaseLetter), PasswordCheckerPill(type: .CapitalLetter), PasswordCheckerPill(type: .SpecialCharacter)]
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = RegistrationVC.Style.ErrorTextFont
        label.textColor = RegistrationVC.Style.ErrorTextColor
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateErrorLabel(message: String) {
        errorLabel.text = message
    }
    
    private func setup() {
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        contentView.addSubview(iconImageView)
        
        iconImageView.disableTranslatesAutoresizingMaskIntoContraints()
        iconImageView.heightAnchor.tc_constrain(equalToConstant: RegistrationVC.Style.IconSize)
        iconImageView.widthAnchor.tc_constrain(equalToConstant: RegistrationVC.Style.IconSize)
        iconImageView.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        iconImageView.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 20)
        
        let labelStack = UIStackView(arrangedSubviews: [largeTitleLabel, descriptionLabel, subTitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 12
        
        contentView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: iconImageView.bottomAnchor, constant: 12)
        labelStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        labelStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -12)
        
        
        let textFields = [firstNameField, lastNameField, emailField, passwordField]
        textFields.forEach { tf in
            tf.disableTranslatesAutoresizingMaskIntoContraints()
            tf.heightAnchor.tc_constrain(equalToConstant: RoundedTextField.Style.Height)
        }
        
        let fieldStack = UIStackView(arrangedSubviews: textFields)
        fieldStack.axis = .vertical
        fieldStack.distribution = .fill
        fieldStack.alignment = .fill
        fieldStack.spacing = 8
        
        contentView.addSubview(fieldStack)
        fieldStack.disableTranslatesAutoresizingMaskIntoContraints()
        fieldStack.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 25)
        fieldStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        fieldStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -12)

        let pillStackSpacing = 3.0
        passwordCheckerPills.forEach { pill in
            pill.disableTranslatesAutoresizingMaskIntoContraints()
            pill.heightAnchor.tc_constrain(equalToConstant: 30)
            pill.widthAnchor.tc_constrain(greaterThanOrEqualToConstant: pill.intrinsicContentSize.width)
        }
        
        let pillStack = UIStackView(arrangedSubviews: passwordCheckerPills)
        pillStack.axis = .horizontal
        pillStack.distribution = .fill
        pillStack.alignment = .fill
        pillStack.spacing = pillStackSpacing
        
        contentView.addSubview(pillStack)
        pillStack.disableTranslatesAutoresizingMaskIntoContraints()
        pillStack.topAnchor.tc_constrain(equalTo: fieldStack.bottomAnchor, constant: 8)
        pillStack.centerXAnchor.tc_constrain(equalTo: contentView.centerXAnchor)
        
        contentView.addSubview(errorLabel)
        errorLabel.disableTranslatesAutoresizingMaskIntoContraints()
        errorLabel.topAnchor.tc_constrain(equalTo: pillStack.bottomAnchor, constant: 12)
        errorLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
    }
}
