//
//  ShowtimeRadioListCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/31/23.
//

import Foundation
import UIKit
import LTHRadioButton

protocol ShowtimeRadioListCellDelegate: AnyObject {
    func didSelectRadioButton(isSelected: Bool)
}

class ShowtimeRadioListCell: UITableViewCell {
    /// Reuse identifier
    static let reuseIdentifier = "ShowtimeRadioListCell"

    /// radio title enum
    enum RadioTitle: String {
        case WhichDayOfRSVPTitle = "Which day would you like to RSVP for?"
        func getString() -> String { return self.rawValue }
    }
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let TitleLabelFont: UIFont = AppFont.semiBold(size: 13)
        static let RegularLabelFont: UIFont = AppFont.regular(size: 13)
        static let RadioSelectedColor: UIColor = AppColors.RegularTeal
        static let RadioDeselectedColor: UIColor = AppColors.TextColorPrimary
        static let RadioLabelTextColor: UIColor = AppColors.TextColorPrimary
        static let RadioLabelFont: UIFont = AppFont.regular(size: 13)
        static let RadioSpacing: CGFloat = 20
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TextColor
        label.font = Style.TitleLabelFont
        label.text = RadioTitle.WhichDayOfRSVPTitle.getString()
        return label
    }()
    
    fileprivate var radioOptions = [String]()
    
    fileprivate var radioButtons = [LTHRadioButton]()
    
    weak var cellDelegate: ShowtimeRadioListCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    public func configure() {
        backgroundColor = Style.BackgroundColor
        
        contentView.addSubview(titleLabel)
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 0)
        titleLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        titleLabel.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .leading
        vStack.spacing = Style.RadioSpacing
        
        contentView.addSubview(vStack)
        vStack.disableTranslatesAutoresizingMaskIntoContraints()
        vStack.topAnchor.tc_constrain(equalTo: titleLabel.bottomAnchor, constant: 25)
        vStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        vStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
        
        let radioOptions = ShowtimeDates().getShowtimwDates(rsvpFormat: true)
        radioOptions.forEach { radioOption in
            let radioButton = LTHRadioButton(selectedColor: Style.RadioSelectedColor, deselectedColor: Style.RadioDeselectedColor)
            radioButton.useTapGestureRecognizer = true
            radioButton.onSelect { [weak self] in
                guard let sSelf = self else { return }
                sSelf.deselectOtherButtons(sender: radioButton)
                    sSelf.cellDelegate?.didSelectRadioButton(isSelected: true)
            }
            radioButton.onDeselect { [weak self] in
                guard let sSelf = self else { return }
                let results = sSelf.radioButtons.filter({ $0.isSelected == true }).count
                if results == 0 {
                    sSelf.cellDelegate?.didSelectRadioButton(isSelected: false)
                }
            }
    
            radioButtons.append(radioButton)
            
            let radioLabel = UILabel()
            radioLabel.text = radioOption
            radioLabel.font = Style.RadioLabelFont
            radioLabel.textColor = Style.RadioLabelTextColor
            
            let wrapperView = UIView()
            wrapperView.addSubviews(subviews: [radioButton, radioLabel])
            
            /// Set radio button constraints
            radioButton.disableTranslatesAutoresizingMaskIntoContraints()
            radioButton.centerYAnchor.tc_constrain(equalTo: radioLabel.centerYAnchor)
            radioButton.heightAnchor.tc_constrain(equalToConstant: radioButton.frame.height)
            radioButton.widthAnchor.tc_constrain(equalToConstant: radioButton.frame.width)
            radioButton.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor, constant: 12)
            
            radioLabel.disableTranslatesAutoresizingMaskIntoContraints()
            radioLabel.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor)
            radioLabel.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor)
            radioLabel.leadingAnchor.tc_constrain(equalTo: radioButton.trailingAnchor, constant: Style.RadioSpacing)
            radioLabel.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor, constant: 0)
            
            vStack.addArrangedSubview(wrapperView)
        }
    }
    
    @objc func deselectOtherButtons(sender: LTHRadioButton) {
        radioButtons.forEach { button in
            guard button != sender else { return }
            button.deselect()
        }
    }
}
