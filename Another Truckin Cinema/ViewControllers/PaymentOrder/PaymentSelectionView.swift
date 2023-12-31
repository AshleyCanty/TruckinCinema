//
//  PaymentSelectionView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/17/23.
//

import Foundation
import UIKit
import LTHRadioButton

protocol PaymentSelectionViewDelegate: AnyObject {
    func didSelectPaymentOption(isSelected: Bool)
}

class PaymentSelectionView: UIView {
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let SubtitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = .white
        static let ImageWidth: CGFloat = 50
        static let ImageHeight: CGFloat = 32
        static let RadioSelectedColor: UIColor = AppColors.RegularTeal
        static let RadioDeselectedColor: UIColor = AppColors.TextColorPrimary
        static let RadioLabelTextColor: UIColor = AppColors.TextColorPrimary
        static let RadioLabelFont: UIFont = AppFont.regular(size: 13)
        static let RadioSpacing: CGFloat = 25
    }
    
    /// radio options enum
    enum PaymentOptionTitle: String, CaseIterable {
        case one = "Apple Pay"
        case two = "Demo Pay"
        func getString() -> String { return self.rawValue }
    }
    /// radio options enum
    enum PaymentOptionIcon: String, CaseIterable {
        case one = "apple-pay"
        func getString() -> String { return self.rawValue }
    }
    /// contact info title label
    private lazy var paymentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TextColor
        label.font = Style.TitleFont
        label.textAlignment = .left
        label.text = "Payment"
        return label
    }()
    /// contact info subtitle label
    private lazy var paymentSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TextColor
        label.font = Style.SubtitleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "This is simply a demo app with no real purchases. If you select Apple Pay, the payment amount will reflect as $0.00."
        return label
    }()
    
    fileprivate var radioOptions = [UIView]()
    
    fileprivate var radioButtons = [LTHRadioButton]()
    
    weak var delegate: PaymentSelectionViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppColors.BackgroundMain
        
        
        // Radio Buttons stack
        let labelStack = UIStackView(arrangedSubviews: [paymentTitleLabel, paymentSubtitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 3
        
        addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: topAnchor)
        labelStack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        labelStack.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
        
        
        // Radio Buttons stack
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .leading
        vStack.spacing = Style.RadioSpacing
        
        addSubview(vStack)
        vStack.disableTranslatesAutoresizingMaskIntoContraints()
        vStack.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 20)
        vStack.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        vStack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        vStack.trailingAnchor.tc_constrain(equalTo: trailingAnchor)

        let applePayView = createPaymentOptionView(imageName: "apple-pay", title: "Apple Pay")
        let demoPayView = createPaymentOptionView(imageName: "demo-pay", title: "Demo Pay")
        
        radioOptions = [applePayView, demoPayView]
        radioOptions.forEach { optionView in
            let radioButton = LTHRadioButton(selectedColor: Style.RadioSelectedColor, deselectedColor: Style.RadioDeselectedColor)
            radioButton.useTapGestureRecognizer = true
            radioButton.onSelect { [weak self] in
                guard let sSelf = self else { return }
                sSelf.deselectOtherButtons(sender: radioButton)
                    sSelf.delegate?.didSelectPaymentOption(isSelected: true)
            }
            radioButton.onDeselect { [weak self] in
                guard let sSelf = self else { return }
                let results = sSelf.radioButtons.filter({ $0.isSelected == true }).count
                if results == 0 {
                    sSelf.delegate?.didSelectPaymentOption(isSelected: false)
                }
            }
            
            radioButtons.append(radioButton)
            
            let wrapperView = UIView()
            wrapperView.addSubviews(subviews: [radioButton, optionView])
            
            /// Set radio button constraints
            radioButton.disableTranslatesAutoresizingMaskIntoContraints()
            radioButton.centerYAnchor.tc_constrain(equalTo: optionView.centerYAnchor)
            radioButton.heightAnchor.tc_constrain(equalToConstant: radioButton.frame.height)
            radioButton.widthAnchor.tc_constrain(equalToConstant: radioButton.frame.width)
            radioButton.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor, constant: 12)
            
            optionView.disableTranslatesAutoresizingMaskIntoContraints()
            optionView.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor)
            optionView.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor)
            optionView.leadingAnchor.tc_constrain(equalTo: radioButton.trailingAnchor, constant: Style.RadioSpacing)
            optionView.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor, constant: 0)
            
            vStack.addArrangedSubview(wrapperView)
        }
    }
    
    @objc func deselectOtherButtons(sender: LTHRadioButton) {
        radioButtons.forEach { button in
            guard button != sender else { return }
            button.deselect()
        }
    }
    
    func createPaymentOptionView(imageName: String, title: String) -> UIView {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        
        let imageView = UIImageView(image: UIImage(imgNamed: imageName))
        imageView.disableTranslatesAutoresizingMaskIntoContraints()
        imageView.heightAnchor.tc_constrain(equalToConstant: Style.ImageHeight)
        imageView.widthAnchor.tc_constrain(equalToConstant: Style.ImageWidth)
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        let wrapper = UIView()
        
        wrapper.addSubview(stack)
        stack.disableTranslatesAutoresizingMaskIntoContraints()
        stack.tc_constrainToSuperview()
        
        return wrapper
    }
}
