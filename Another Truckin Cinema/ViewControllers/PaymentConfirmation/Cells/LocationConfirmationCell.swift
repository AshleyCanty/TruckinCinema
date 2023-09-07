//
//  LocationConfirmationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/8/23.
//

import Foundation
import UIKit

protocol LocationConfirmationCellDelegate: AnyObject {
    func didTapAddressLink()
}

class LocationConfirmationCell: UITableViewCell {
    /// reuse id
    static let reuseIdentifier = "LocationConfirmationCell"
    
    struct Style {
        static let LeftMargin: CGFloat = 17
        static let LargeTitleFont: UIFont = AppFont.bold(size: 19)
        static let LargeTitleTextColor: UIColor = AppColors.TextColorPrimary
        static let GreyTextFont: UIFont = AppFont.regular(size: 11)
        static let GreyTextColor: UIColor = AppColors.TextColorSecondary
        static let SemiBoldTextColor: UIColor = AppColors.TextColorPrimary
        static let SemiBoldTextFont: UIFont = AppFont.semiBold(size: 11)
        static let LinkTextColor: UIColor = AppColors.RegularTeal
        static let MovieImageSize: CGFloat = 85
        static let QRImageSize: CGFloat = 110
        static let QRImageBorderColor: UIColor = AppColors.QRImageBorderColor
        static let IconSize: CGFloat = 22
        static let LabelVerticalSpacing: CGFloat = 4
    }
    
    /// enum for Movie Detail Title Detail Icon names
    enum IconName: String {
        case Location = "pinLocation"
        func getString() -> String { return self.rawValue }
    }
    
    ///  ticket icon image view
    lazy var locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(imgNamed: IconName.Location.getString()))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.TextColorPrimary
        imageView.frame.size = CGSize(width: Style.IconSize, height: Style.IconSize)
        return imageView
    }()
    
    /// ticket confirmation stackview
    lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationTitleLabel, driveInLocationLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Style.LabelVerticalSpacing
        return stack
    }()
    /// ticket confirmation header label
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var driveInLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.SemiBoldTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.LinkTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    weak var delegate: LocationConfirmationCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let stackWrapperView = UIView()
        stackWrapperView.addSubviews(subviews: [locationStack, addressLabel])
        
        contentView.addSubview(locationIcon)
        contentView.addSubview(stackWrapperView)
        
        locationIcon.disableTranslatesAutoresizingMaskIntoContraints()
        locationIcon.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: (AppTheme.LeadingTrailingMargin + Style.MovieImageSize - Style.IconSize))
        locationIcon.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        locationIcon.heightAnchor.tc_constrain(equalToConstant: Style.IconSize)
        locationIcon.widthAnchor.tc_constrain(equalToConstant: Style.IconSize)
        
        stackWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        stackWrapperView.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        stackWrapperView.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor)
        stackWrapperView.trailingAnchor.tc_constrain(lessThanOrEqualTo: contentView.trailingAnchor)
        stackWrapperView.leadingAnchor.tc_constrain(equalTo: locationIcon.trailingAnchor, constant: Style.LeftMargin)
        
        locationIcon.disableTranslatesAutoresizingMaskIntoContraints()
        locationIcon.heightAnchor.tc_constrain(equalToConstant: Style.IconSize)
        locationIcon.widthAnchor.tc_constrain(equalToConstant: Style.IconSize)

        locationStack.disableTranslatesAutoresizingMaskIntoContraints()
        locationStack.topAnchor.tc_constrain(equalTo: stackWrapperView.topAnchor)
        locationStack.leadingAnchor.tc_constrain(equalTo: stackWrapperView.leadingAnchor)
        locationStack.trailingAnchor.tc_constrain(equalTo: stackWrapperView.trailingAnchor)
        
        addressLabel.disableTranslatesAutoresizingMaskIntoContraints()
        addressLabel.leadingAnchor.tc_constrain(equalTo: stackWrapperView.leadingAnchor)
        addressLabel.trailingAnchor.tc_constrain(equalTo: stackWrapperView.trailingAnchor)
        addressLabel.topAnchor.tc_constrain(equalTo: locationStack.bottomAnchor, constant: Style.LabelVerticalSpacing)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddress))
        tapGesture.delegate = self
        addressLabel.isUserInteractionEnabled = true
        addressLabel.addGestureRecognizer(tapGesture)
    }
    
    private func addText() {
        locationTitleLabel.text = "LOCATION"
        driveInLocationLabel.text = "Drive-in No. 3 Zanzibar"
        addressLabel.text = "Route 44,  13 Doverton,\nDemo, PA 29481"
    }
    
    @objc func didTapAddress() {
        delegate?.didTapAddressLink()
    }
}
