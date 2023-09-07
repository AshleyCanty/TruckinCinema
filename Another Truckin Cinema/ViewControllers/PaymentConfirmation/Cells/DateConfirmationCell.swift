//
//  DateConfirmationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/8/23.
//

import Foundation
import UIKit


protocol DateConfirmationCellDelegate: AnyObject {
    func didTapCalenderLink()
}

class DateConfirmationCell: UITableViewCell {
    /// reuse id
    static let reuseIdentifier = "DateConfirmationCell"
    
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
        case Calender = "calender"
        func getString() -> String { return self.rawValue }
    }
    
    ///  ticket icon image view
    lazy var calenderIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(imgNamed: IconName.Calender.getString()))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.TextColorPrimary
        imageView.frame.size = CGSize(width: Style.IconSize, height: Style.IconSize)
        return imageView
    }()
    
    /// ticket confirmation stackview
    lazy var dateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateTitleLabel, dayMonthLabel, timeLabel, addToCalenderButton])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Style.LabelVerticalSpacing
        return stack
    }()
    /// ticket confirmation header label
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var dayMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.SemiBoldTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation header label
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    /// ticket confirmation number label
    private lazy var addToCalenderButton: UILabel = {
        let btn = UILabel()
        btn.text = "Add to calender"
        btn.textColor = Style.LinkTextColor
        btn.font = Style.SemiBoldTextFont
        return btn
    }()
    
    weak var delegate: DateConfirmationCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        /// wrapper for right side stack views
        let stackWrapperView = UIView()
        stackWrapperView.addSubview(dateStack)
        
        contentView.addSubviews(subviews: [calenderIcon, stackWrapperView])
        
        calenderIcon.disableTranslatesAutoresizingMaskIntoContraints()
        calenderIcon.heightAnchor.tc_constrain(equalToConstant: Style.IconSize)
        calenderIcon.widthAnchor.tc_constrain(equalToConstant: Style.IconSize)
        calenderIcon.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: (AppTheme.LeadingTrailingMargin + Style.MovieImageSize - Style.IconSize))
        calenderIcon.topAnchor.tc_constrain(equalTo: dateTitleLabel.topAnchor)
        
        stackWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        stackWrapperView.leadingAnchor.tc_constrain(equalTo: calenderIcon.trailingAnchor, constant: Style.LeftMargin)
        stackWrapperView.trailingAnchor.tc_constrain(lessThanOrEqualTo: contentView.trailingAnchor)
        stackWrapperView.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        stackWrapperView.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor)
        
        dateStack.disableTranslatesAutoresizingMaskIntoContraints()
        dateStack.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        dateStack.leadingAnchor.tc_constrain(equalTo: stackWrapperView.leadingAnchor)
        dateStack.trailingAnchor.tc_constrain(equalTo: stackWrapperView.trailingAnchor)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCalenderLink))
        tapGesture.delegate = self
        addToCalenderButton.isUserInteractionEnabled = true
        addToCalenderButton.addGestureRecognizer(tapGesture)
    }
    
    private func addText() {
        dateTitleLabel.text = "DATE"
        dayMonthLabel.text = "Sunday, June 11"
        timeLabel.text = "at 08:30 PM"
    }
    
    @objc private func didTapCalenderLink() {
        delegate?.didTapCalenderLink()
    }
}
