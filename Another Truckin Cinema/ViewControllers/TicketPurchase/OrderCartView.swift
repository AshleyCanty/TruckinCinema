//
//  OrderCartView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/13/23.
//

import Foundation
import UIKit


class OrderCartView: UIView {
    
    struct Style {
        static let Height: CGFloat = 74
        static let CartImageSize: CGFloat = 38
    }
    
    private lazy var itemCount: Int = 0
    private lazy var currentSumTotal: Double = 0.0
    
    private lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = AppFont.regular(size: 13)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = AppFont.regular(size: 13)
        label.textColor = AppColors.TextColorPrimary
        return label
    }()
    
    public lazy var cartButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: "cart").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = AppColors.RegularGray
        btn.imageView?.layer.transform = CATransform3DMakeScale(1.12, 1.12, 1.12)
        return btn
    }()
    
    public lazy var continueButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.Continue.getString(), for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 13)
        return btn
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = AppColors.BackgroundMain
        addSubviews(subviews: [priceLabel, cartButton, continueButton])
        cartButton.addSubview(itemCountLabel)
        
        cartButton.disableTranslatesAutoresizingMaskIntoContraints()
        cartButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        cartButton.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        cartButton.heightAnchor.tc_constrain(equalToConstant: Style.CartImageSize)
        cartButton.widthAnchor.tc_constrain(equalToConstant: Style.CartImageSize)
        
        itemCountLabel.disableTranslatesAutoresizingMaskIntoContraints()
        itemCountLabel.centerXAnchor.tc_constrain(equalTo: cartButton.centerXAnchor, constant: 3)
        itemCountLabel.centerYAnchor.tc_constrain(equalTo: cartButton.centerYAnchor, constant: -2)
        
        priceLabel.disableTranslatesAutoresizingMaskIntoContraints()
        priceLabel.leadingAnchor.tc_constrain(equalTo: cartButton.trailingAnchor, constant: 10)
        priceLabel.centerYAnchor.tc_constrain(equalTo: cartButton.centerYAnchor)
        
        continueButton.disableTranslatesAutoresizingMaskIntoContraints()
        continueButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        continueButton.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: -AppTheme.BottomMargin)
        continueButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        continueButton.widthAnchor.tc_constrain(equalTo: widthAnchor, multiplier: 0.5)
    }
    
    public func updateItemCountAndPrice(addItemQuantity itemCount: Int, price: Double) {
        addToCart(itemCount: itemCount, price: price)
        itemCountLabel.text = String(self.itemCount)
        priceLabel.text = String(format: "$%.2f", self.currentSumTotal)
    }
    
    public func addToCart(itemCount: Int, price: Double) {
        self.itemCount += itemCount
        self.currentSumTotal += price
    }
    
    public func removeFromCart(itemCount: Int, price: Double) {
        self.itemCount -= itemCount
        self.currentSumTotal -= price
    }
}


// FIX - the Alert Toast View!!!!!!!! ITs foating!!!
