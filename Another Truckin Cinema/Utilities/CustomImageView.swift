//
//  CustomImageView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/19/23.
//

import UIKit


class CustomImageView: UIImageView {
    struct Style {
        static let SpinnerSize: CGFloat = 46
    }
    
    let activityIndicator = UIActivityIndicatorView()
    
    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func showSpinner() {
        activityIndicator.startAnimating()
    }
    
    public func hideSpinner() {
        activityIndicator.stopAnimating()
    }
    
    private func configure() {
        addSubview(activityIndicator)
        
        activityIndicator.disableTranslatesAutoresizingMaskIntoContraints()
        activityIndicator.widthAnchor.tc_constrain(equalToConstant: Style.SpinnerSize)
        activityIndicator.heightAnchor.tc_constrain(equalToConstant: Style.SpinnerSize)
        activityIndicator.centerXAnchor.tc_constrain(equalTo: centerXAnchor)
        activityIndicator.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        
        activityIndicator.hidesWhenStopped = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
