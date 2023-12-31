//
//  NearbyDriveInCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/26/23.
//

import Foundation
import UIKit


class NearbyDriveInCell: UITableViewCell {
    
    static let reuseId = "NearbyDriveInCell"
    
    struct Style {
        static let pillButtonWidth: CGFloat = 80
        static let pillButtonHeight: CGFloat = 30
        static let starButtonSize: CGFloat = 20
    }
    
    public lazy var bigNumberLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular(size: 15)
        label.textColor = AppColors.TextColorPrimary
        label.text = " "
        return label
    }()
    
    public lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: "star"), for: .selected)
        btn.setImage(UIImage(imgNamed: "star-inactive"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = AppFont.semiBold(size: 17)
        label.textColor = AppColors.TextColorPrimary
        label.text = "Drive-in No. 3 Zanzibar"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = AppFont.regular(size: 11)
        label.textColor = AppColors.TextColorPrimary
        label.text = "Drive-in opens 30 minutes prior to the first showtime and closes 15 minutes after the last showtime."
        return label
    }()
    
    private lazy var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = AppFont.regular(size: 11)
        label.textColor = AppColors.RegularTeal
        label.text = "1234 SomeAddress Pike Route 401 & 93, Suite C13"
        return label
    }()
    
    private lazy var cityAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = AppFont.regular(size: 11)
        label.textColor = AppColors.RegularTeal
        label.text = "Zanzibar, AD 12312"
        return label
    }()
    
    public lazy var driveInInfoButton: UIButton = {
        let btn = RoundedButton(type: .custom)
        btn.backgroundColor = AppColors.BackgroundMain
        btn.setTitle("Drive-in Info", for: .normal)
        btn.setTitleColor(AppColors.TextColorPrimary, for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 9)
        btn.addBorder(color: .white, width: 2)
        return btn
    }()
    
    public lazy var showtimesButton: UIButton = {
        let btn = RoundedButton(type: .custom)
        btn.backgroundColor = AppColors.BackgroundSecondary
        btn.setTitle("Showtimes", for: .normal)
        btn.setTitleColor(AppColors.TextColorPrimary, for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 9)
        return btn
    }()
    
    private lazy var mileDistanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = AppFont.regular(size: 11)
        label.textColor = AppColors.TextColorPrimary
        label.text = "24.1"
        return label
    }()
    
    private var bigNumberLabelWidthAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard bigNumberLabel.intrinsicContentSize.width > 0 else { return }
        bigNumberLabelWidthAnchor?.constant = bigNumberLabel.intrinsicContentSize.width
        layoutIfNeeded()
    }
    
    private func setup() {
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        
        // set up big number label
        contentView.addSubview(bigNumberLabel)
        bigNumberLabel.disableTranslatesAutoresizingMaskIntoContraints()
        bigNumberLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        bigNumberLabel.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 12)
        bigNumberLabelWidthAnchor = bigNumberLabel.widthAnchor.constraint(equalToConstant: bigNumberLabel.intrinsicContentSize.width)
        bigNumberLabelWidthAnchor?.isActive = true
        
        // set up big star button
        contentView.addSubview(favoriteButton)
        favoriteButton.disableTranslatesAutoresizingMaskIntoContraints()
        favoriteButton.leadingAnchor.tc_constrain(equalTo: bigNumberLabel.trailingAnchor, constant: 8)
        favoriteButton.centerYAnchor.tc_constrain(equalTo: bigNumberLabel.centerYAnchor)
        favoriteButton.heightAnchor.tc_constrain(equalToConstant: Style.starButtonSize)
        favoriteButton.widthAnchor.tc_constrain(equalToConstant: Style.starButtonSize)
        
        // set up big location Title label, description label, address label
        let labelStack = UIStackView(arrangedSubviews: [locationTitleLabel, descriptionLabel, streetAddressLabel, cityAddressLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 6
        labelStack.setCustomSpacing(0, after: streetAddressLabel)
        
        contentView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.leadingAnchor.tc_constrain(equalTo: favoriteButton.trailingAnchor, constant: 8)
        labelStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        // CNPostalAddressFormatter()
        labelStack.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 11)
        
        
        // set up button hStack
        let pillButtons = [driveInInfoButton, showtimesButton]
        pillButtons.forEach { button in
            button.disableTranslatesAutoresizingMaskIntoContraints()
            button.heightAnchor.tc_constrain(equalToConstant: Style.pillButtonHeight)
            button.widthAnchor.tc_constrain(equalToConstant: Style.pillButtonWidth)
        }
        let buttonStack = UIStackView(arrangedSubviews: pillButtons)
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.alignment = .leading
        buttonStack.spacing = 8
        
        contentView.addSubview(buttonStack)
        buttonStack.disableTranslatesAutoresizingMaskIntoContraints()
        buttonStack.leadingAnchor.tc_constrain(equalTo: labelStack.leadingAnchor)
        buttonStack.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 12)
        
        // set up mileage distance label
        contentView.addSubview(mileDistanceLabel)
        mileDistanceLabel.disableTranslatesAutoresizingMaskIntoContraints()
        mileDistanceLabel.centerYAnchor.tc_constrain(equalTo: buttonStack.centerYAnchor)
        mileDistanceLabel.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
    }
}
