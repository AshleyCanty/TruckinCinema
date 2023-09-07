//
//  CarDetailsCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/13/23.
//

import Foundation
import UIKit

enum CarDetailType: Int {
    case make, model, color, licensePlate
    func getInt() -> Int { return self.rawValue }
}

protocol CarDetailCellDelegate: AnyObject {
    func carDetailValueDidChange(type: CarDetailType, detailValue: String)
}

class CarDetailsCell: UITableViewCell {
    static let reuseID = "CarDetailsCell"
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let TextFieldFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
    }
    /// field title label
    private lazy var fieldTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.textColor = Style.TextColor
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    public lazy var textField = RoundedTextField()
    
    weak var delegate: CarDetailCellDelegate?
    
    var detailType: CarDetailType = .make
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(question: String, textFieldType: RoundedTextFieldType = .Plain, textFieldPlaceholder: String = "") {
        textField.setup(type: textFieldType, placeholder: textFieldPlaceholder)
        fieldTitleLabel.text = question
    }
    
    private func configure() {
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        contentView.addSubview(fieldTitleLabel)
        contentView.addSubview(textField)
        
        fieldTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        fieldTitleLabel.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 0)
        fieldTitleLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 5)
        fieldTitleLabel.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: 0)
        
        textField.disableTranslatesAutoresizingMaskIntoContraints()
        textField.topAnchor.tc_constrain(equalTo: fieldTitleLabel.bottomAnchor, constant: 12)
        textField.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 0)
        textField.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: 0)
        textField.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor, constant: -12)
        
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField) {
        if let value = textField.text {
            delegate?.carDetailValueDidChange(type: detailType, detailValue: value)
        }
    }
}
