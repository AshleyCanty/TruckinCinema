//
//  ConfirmationToastView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/26/23.
//

import Foundation
import UIKit

/// ConfirmationToastView class
class ConfirmationToastView: UIView {
    
    public let toastLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        /// Configures the toast view for when an item is added to the order
        backgroundColor = .systemOrange
        toastLabel.font = AppFont.medium(size: 11)
        toastLabel.textColor = .white
        
        addSubview(toastLabel)
        toastLabel.disableTranslatesAutoresizingMaskIntoContraints()
        toastLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        toastLabel.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
    }
    
    public func setToastLabel(item: String, size: String) {
        toastLabel.text = "Added \(item) for \(size) to order"
    }
}
