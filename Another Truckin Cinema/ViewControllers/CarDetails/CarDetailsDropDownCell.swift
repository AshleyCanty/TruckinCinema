//
//  CarDetailsDropDownCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/16/23.
//

import Foundation
import UIKit

class CarDetailsDropDownCell: UITableViewCell , DropDownTextFieldViewDelegate {
    
    static let reuseID = "CarDetailsDropDownCell"
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
    
    let dropDownView = DropDownTextFieldView()
    
    weak var delegate: CarDetailCellDelegate?
    
    var detailType: CarDetailType = .model
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(question: String, dataSource: [String]) {
        fieldTitleLabel.text = question
        dropDownView.setDataSource(dataSource: dataSource)
        dropDownView.dropDown.direction = .any
    }
    
    private func configure() {
        dropDownView.delegate = self
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        contentView.addSubviews(subviews: [fieldTitleLabel, dropDownView])
        
        fieldTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        fieldTitleLabel.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 0)
        fieldTitleLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 5)
        fieldTitleLabel.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: 0)
        
        dropDownView.disableTranslatesAutoresizingMaskIntoContraints()
        dropDownView.topAnchor.tc_constrain(equalTo: fieldTitleLabel.bottomAnchor, constant: 12)
        dropDownView.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 0)
        dropDownView.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: 0)
        dropDownView.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor, constant: -12)
    }
    
    func didSelectDropDownOption(sender: UITextField) {
        if let value = dropDownView.textField.text {
            delegate?.carDetailValueDidChange(type: detailType, detailValue: value)
        }
    }
}
