//
//  DoneButtonConfirmationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/9/23.
//

import Foundation
import UIKit


protocol DoneButtonConfirmationCellDelegate: AnyObject {
    func didTapDoneButton()
}

class DoneButtonConfirmationCell: UITableViewCell {
    /// reuse id
    static let reuseIdentifier = "DoneButtonConfirmationCell"
    
    /// done button
    fileprivate lazy var doneButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.Done.getString(), for: .normal)
        return btn
    }()
    
    weak var delegate: DoneButtonConfirmationCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(doneButton)
        doneButton.disableTranslatesAutoresizingMaskIntoContraints()
        doneButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        doneButton.centerYAnchor.tc_constrain(equalTo: contentView.centerYAnchor)
        doneButton.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        doneButton.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc private func didTapDoneButton() {
        delegate?.didTapDoneButton()
    }
}

