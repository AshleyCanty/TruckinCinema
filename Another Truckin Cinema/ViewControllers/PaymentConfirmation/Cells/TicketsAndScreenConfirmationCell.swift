//
//  TicketsAndScreenConfirmationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/8/23.
//

import Foundation
import UIKit

class TicketsAndScreenConfirmationCell: UITableViewCell {
    /// reuse id
    static let reuseIdentifier = "TicketsAndScreenConfirmationCell"
    
    struct Style {
        static let LargeStackSpacing: CGFloat = 25
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
        case Tickets = "tickets"
        func getString() -> String { return self.rawValue }
    }
    
    ///  ticket icon image view
    lazy var ticketIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(imgNamed: IconName.Tickets.getString()))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.TextColorPrimary
        imageView.frame.size = CGSize(width: Style.IconSize, height: Style.IconSize)
        return imageView
    }()
    
    /// ticket confirmation stackview
    lazy var ticketNumberStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ticketTitleLabel, ticketAmountLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        return stack
    }()
    /// ticket confirmation header label
    private lazy var ticketTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var ticketAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.SemiBoldTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// ticket confirmation stackview
    lazy var screenStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [screenTitleLabel, movieScreenLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        return stack
    }()
    /// ticket confirmation header label
    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var movieScreenLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.SemiBoldTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
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
        stackWrapperView.addSubviews(subviews: [ticketNumberStack, screenStack])
        
        contentView.addSubview(ticketIcon)
        contentView.addSubview(stackWrapperView)
        
        ticketIcon.disableTranslatesAutoresizingMaskIntoContraints()
        ticketIcon.heightAnchor.tc_constrain(equalToConstant: Style.IconSize)
        ticketIcon.widthAnchor.tc_constrain(equalToConstant: Style.IconSize)
        ticketIcon.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: (AppTheme.LeadingTrailingMargin + Style.MovieImageSize - Style.IconSize))
        ticketIcon.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        
        stackWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        stackWrapperView.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        stackWrapperView.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor)
        stackWrapperView.leadingAnchor.tc_constrain(equalTo: ticketIcon.trailingAnchor, constant: Style.LeftMargin)
        stackWrapperView.trailingAnchor.tc_constrain(lessThanOrEqualTo: contentView.trailingAnchor)

        ticketNumberStack.disableTranslatesAutoresizingMaskIntoContraints()
        ticketNumberStack.topAnchor.tc_constrain(equalTo: stackWrapperView.topAnchor)
        ticketNumberStack.leadingAnchor.tc_constrain(equalTo: stackWrapperView.leadingAnchor)
        ticketNumberStack.trailingAnchor.tc_constrain(equalTo: stackWrapperView.trailingAnchor)
        
        screenStack.disableTranslatesAutoresizingMaskIntoContraints()
        screenStack.topAnchor.tc_constrain(equalTo: ticketNumberStack.bottomAnchor, constant: Style.LabelVerticalSpacing*2)
        screenStack.leadingAnchor.tc_constrain(equalTo: stackWrapperView.leadingAnchor)
        screenStack.trailingAnchor.tc_constrain(equalTo: stackWrapperView.trailingAnchor)
    }
    
    private func addText() {
        ticketTitleLabel.text = "TICKETS"
        ticketAmountLabel.text = "2 TOTAL"
        screenTitleLabel.text = "SCREEN"
        movieScreenLabel.text = "FIRST MOVIE ON SCREEN ONE"
    }
}
