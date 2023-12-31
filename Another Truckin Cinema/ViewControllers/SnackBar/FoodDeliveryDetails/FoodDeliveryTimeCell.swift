//
//  FoodDeliveryTimeCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/22/23.
//

import Foundation
import UIKit



class FoodDeliveryTimeCell: UICollectionViewCell, DropDownTextFieldViewDelegate {
    func didSelectDropDownOption(sender: UITextField) { }
    
    /// reuse id
    static let reuseId = "FoodDeliveryTimeCell"
    
    private enum LabelText: String {
        case title = "Delivery Time"
        case subtitle = "Select your screen and delivery time. We’ll deliver your order within 10 minutes of the time selected."
        func getString() -> String { return self.rawValue }
    }
    
    private enum Placeholder: String {
        case Date = "Date"
        case Screen = "Screen"
        case Showtime = "Showtime"
        func getString() -> String { return self.rawValue }
    }
    
    public lazy var addMoreFoodButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("  Add More Food and Drinks", for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 13)
        btn.setTitleColor(AppColors.RegularTeal, for: .normal)
        btn.setTitleColor(AppColors.EmailButtonTitleHighlighted, for: .highlighted)
        btn.setImage(UIImage(imgNamed: "add"), for: .normal)
        btn.setImage(UIImage(imgNamed: "add-highlighted"), for: .highlighted)
        btn.contentHorizontalAlignment = .left
        btn.imageView?.tintColor = AppColors.RegularTeal
        return btn
    }()
    
    private lazy var deliveryTitleLabel: UILabel = {
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
    
    private lazy var dateDropDownView = DropDownTextFieldView()
    
    private lazy var screenDropDownView = DropDownTextFieldView()
    
    private lazy var showtimeDropDownView = DropDownTextFieldView()
    
    /// genre stackview
    private var deliveryTimeStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10.0
        sv.distribution = .equalCentering
        sv.alignment = .fill
        return sv
    }()
    
    private let movieShowtime = "8:30pm"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deliveryTimeStack.arrangedSubviews.forEach { deliveryTimePill in
            deliveryTimePill.layer.masksToBounds = true
            deliveryTimePill.layer.cornerRadius = deliveryTimePill.intrinsicContentSize.height / 2
        }
    }
    
    private func setupDropDownViews() {
        dateDropDownView.delegate = self
        dateDropDownView.setDataSource(dataSource: ShowtimeDates().getShowtimwDates())
        dateDropDownView.textField.setup(placeholder: Placeholder.Date.getString())
        
        screenDropDownView.delegate = self
        screenDropDownView.setDataSource(dataSource: ["Screen One", "Screen Two"])
        screenDropDownView.textField.setup(placeholder: Placeholder.Screen.getString())
        
        showtimeDropDownView.delegate = self
        showtimeDropDownView.setDataSource(dataSource: ["08:30pm", "11:30pm"])
        showtimeDropDownView.textField.setup(placeholder: Placeholder.Showtime.getString())
    }
    
    private func setupUI() {
        setupDropDownViews()
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        
        contentView.addSubview(addMoreFoodButton)
        addMoreFoodButton.disableTranslatesAutoresizingMaskIntoContraints()
        addMoreFoodButton.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 0)
        addMoreFoodButton.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        addMoreFoodButton.heightAnchor.tc_constrain(equalToConstant: 30)
        
        // label stack
        let labelStack = UIStackView(arrangedSubviews: [deliveryTitleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 5
        
        contentView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: addMoreFoodButton.bottomAnchor, constant: 15)
        labelStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        labelStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
        
        // text field stack
        let textfields = [dateDropDownView, screenDropDownView, showtimeDropDownView]
        textfields.forEach { textfield in
            textfield.disableTranslatesAutoresizingMaskIntoContraints()
            textfield.heightAnchor.tc_constrain(equalToConstant: 45)
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
        
        // Delivery time pills
        
        let timeStackWrapper = UIView()
        timeStackWrapper.addSubview(deliveryTimeStack)
        
        let showtimeLabel = UILabel()
        showtimeLabel.font = AppFont.regular(size: 11)
        showtimeLabel.textColor = AppColors.TextColorPrimary
        showtimeLabel.text = "Showtime"
        showtimeLabel.textAlignment = .center
        
        timeStackWrapper.addSubview(showtimeLabel)
        showtimeLabel.disableTranslatesAutoresizingMaskIntoContraints()
        
        getDeliveryTimes().forEach { time in
            let label = PaddedLabel()
            label.text = time
            label.font = AppFont.regular(size: 11)
            label.textColor = AppColors.TextColorPrimary
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.addBorder(color: AppColors.BackgroundSecondary, width: 1)
            label.padding(6, 6, 14, 14)
        
            deliveryTimeStack.addArrangedSubview(label)
            
            if time == movieShowtime {
                showtimeLabel.centerXAnchor.tc_constrain(equalTo: label.centerXAnchor)
                showtimeLabel.topAnchor.tc_constrain(equalTo: label.bottomAnchor, constant: 5)
            }
        }
        
        deliveryTimeStack.disableTranslatesAutoresizingMaskIntoContraints()
        deliveryTimeStack.topAnchor.tc_constrain(equalTo: timeStackWrapper.topAnchor)
        deliveryTimeStack.centerXAnchor.tc_constrain(equalTo: timeStackWrapper.centerXAnchor)
        deliveryTimeStack.bottomAnchor.tc_constrain(equalTo: timeStackWrapper.bottomAnchor)
        
        contentView.addSubview(timeStackWrapper)
        timeStackWrapper.disableTranslatesAutoresizingMaskIntoContraints()
        timeStackWrapper.topAnchor.tc_constrain(equalTo: fieldStack.bottomAnchor, constant: 12)
        timeStackWrapper.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        timeStackWrapper.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
    }
    
    func getDeliveryTimes() -> [String] {
        return ["8:10pm", "8:20pm", "8:30pm", "8:40pm"]
    }
}


