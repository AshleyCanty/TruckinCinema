//
//  RegistrationCellStepTwo.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/3/23.
//

import Foundation
import UIKit
import Combine

class RegistrationCellStepTwo: UITableViewCell {
    
    static let reuseId = "RegistrationCellStepTwo"
    
    private let iconImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "popcorn"))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.LargeTitleTwo.getString()
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.SubtitleTwo.getString()
        label.textColor = RegistrationVC.Style.SubtitleTextColor
        label.font = AppFont.semiBold(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = RegistrationLabel.DescriptionTwo.getString()
        label.textColor = RegistrationVC.Style.BodyTextColor
        label.font = RegistrationVC.Style.BodyTextFont
        label.numberOfLines = 0
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = .current
        picker.datePickerMode = .date
        picker.tintColor = AppColors.RegularTeal
        return picker
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = RegistrationVC.Style.ErrorTextFont
        label.textColor = RegistrationVC.Style.ErrorTextColor
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        contentView.addSubview(iconImageView)
        
        iconImageView.disableTranslatesAutoresizingMaskIntoContraints()
        iconImageView.heightAnchor.tc_constrain(equalToConstant: RegistrationVC.Style.IconSize)
        iconImageView.widthAnchor.tc_constrain(equalToConstant: RegistrationVC.Style.IconSize)
        iconImageView.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        iconImageView.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 8)
        
        let labelStack = UIStackView(arrangedSubviews: [largeTitleLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 12
        
        contentView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: iconImageView.bottomAnchor, constant: 12)
        labelStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        labelStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -12)
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        subTitleLabel.centerXAnchor.tc_constrain(equalTo: contentView.centerXAnchor)
        subTitleLabel.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 30)
        
        contentView.addSubview(datePicker)
        datePicker.disableTranslatesAutoresizingMaskIntoContraints()
        datePicker.topAnchor.tc_constrain(equalTo: subTitleLabel.bottomAnchor, constant: 12)
        datePicker.centerXAnchor.tc_constrain(equalTo: contentView.centerXAnchor)
        
        contentView.addSubview(errorLabel)
        errorLabel.disableTranslatesAutoresizingMaskIntoContraints()
        errorLabel.centerXAnchor.tc_constrain(equalTo: contentView.centerXAnchor)
        errorLabel.topAnchor.tc_constrain(equalTo: datePicker.bottomAnchor, constant: 12)
    }
    
    public func updateErrorLabel(errorType: AgeError?) {
        guard let error = errorType else {
            errorLabel.text = ""
            return
        }
        
        if error == .EighteenMinimum {
            errorLabel.text = "You must be 18yrs or older."
        } else {
            errorLabel.text = "Age must be less than 99yrs."
        }
    }
}

enum AgeError {
    case EighteenMinimum
    case NinetyNineMaximum
}
