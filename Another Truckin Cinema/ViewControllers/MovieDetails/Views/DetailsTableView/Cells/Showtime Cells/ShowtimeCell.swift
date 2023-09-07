//
//  ShowtimeCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/31/23.
//

import Foundation
import UIKit

/// enum for showtime title
enum ShowtimeTitle: String {
    case Placement = "Placement:"
    case Showtime = "Showtime for all days listed:"
    func getString() -> String { return self.rawValue }
}

/// enum for showtime title
enum ShowtimeSubtitle: String {
    case Placement = "First Movie on Screen One"
    case Showtime = "8:30 PM"
    func getString() -> String { return self.rawValue }
}

class ShowtimeCell: UITableViewCell {
    /// Reuse identifier
    static let reuseIdentifier = "ShowtimeCell"
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let TitleLabelFont: UIFont = AppFont.semiBold(size: 12)
        static let RegularLabelFont: UIFont = AppFont.regular(size: 12)
        static let SpacerViewHeight: CGFloat = 5
    }
    /// Title label
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleLabelFont
        label.textColor = Style.TextColor
        label.textAlignment = .left
        return label
    }()
    /// Subtitle label
    fileprivate var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.RegularLabelFont
        label.textColor = Style.TextColor
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = Style.BackgroundColor
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 8
        
        addSubview(stack)
        stack.disableTranslatesAutoresizingMaskIntoContraints()
        stack.topAnchor.tc_constrain(equalTo: topAnchor, constant: 02)
        stack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        stack.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
    }
    
    // public func setup(withTitle title: String, withSubtitle subtitle: String)
    /// Sets up labels
    public func setup(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

