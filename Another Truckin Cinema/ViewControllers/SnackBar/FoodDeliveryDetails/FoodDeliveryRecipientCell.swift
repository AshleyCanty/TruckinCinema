//
//  FoodDeliveryRecipientCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/22/23.
//

import Foundation
import UIKit

class FoodDeliveryRecipientCell: UICollectionViewCell, DropDownTextFieldViewDelegate {
    func didSelectDropDownOption(sender: UITextField) { }
    
    /// reuse id
    static let reuseId = "FoodDeliveryRecipientCell"
    
    private enum LabelText: String {
        case title = "Who should we deliver to?"
        case subtitle = "Enter the name of the person who will be accepting the order and what seat they will be sitting in."
        func getString() -> String { return self.rawValue }
    }
    
    private enum Placeholder: String {
        case Name = "Name"
        case DriverOrPassengerSeat = "Driver or Passenger seat?"
        func getString() -> String { return self.rawValue }
    }
    
    private lazy var recipientTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.semiBold(size: 14)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        label.text = LabelText.title.getString()
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular(size: 12)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = LabelText.subtitle.getString()
        return label
    }()
    
    private lazy var nameTextField = RoundedTextField(placeholder: Placeholder.Name.getString())
    
    private lazy var seatChoiceDropDownView = DropDownTextFieldView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDropDownViews() {
        seatChoiceDropDownView.delegate = self
        seatChoiceDropDownView.dropDown.direction = .top
        seatChoiceDropDownView.dropDown.topOffset = CGPoint(x: 0, y: -(RoundedTextField.Style.Height + 5))
        seatChoiceDropDownView.setDataSource(dataSource: ["Driver seat", "Passenger seat"])
        seatChoiceDropDownView.textField.setup(placeholder: Placeholder.DriverOrPassengerSeat.getString())
    }
    
    private func setupUI() {
        setupDropDownViews()
        
        let labelStack = UIStackView(arrangedSubviews: [recipientTitleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 5
        
        contentView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 15)
        labelStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        labelStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
        
        // text field stack
        let textfields = [nameTextField, seatChoiceDropDownView]
        textfields.forEach { textfield in
            textfield.disableTranslatesAutoresizingMaskIntoContraints()
            textfield.heightAnchor.tc_constrain(equalToConstant: RoundedTextField.Style.Height)
        }
        
        let fieldStack = UIStackView(arrangedSubviews: textfields)
        fieldStack.axis = .vertical
        fieldStack.distribution = .fill
        fieldStack.alignment = .fill
        fieldStack.spacing = 12
        
        contentView.addSubview(fieldStack)
        fieldStack.disableTranslatesAutoresizingMaskIntoContraints()
        fieldStack.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 15)
        fieldStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        fieldStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
    }
}
