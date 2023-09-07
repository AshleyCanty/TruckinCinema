//
//  RegistrationSuccessView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/7/23.
//

import Foundation
import UIKit
import Combine

class RegistrationSuccessView: UIView {
    
    let iconImageView: UIImageView = {
       let imgView = UIImageView(image: UIImage(imgNamed: "success"))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Congratulations, your registration was successful!"
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "You now have access to all membership perks and benefits. Enjoy!"
        label.textColor = RegistrationVC.Style.BodyTextColor
        label.font = RegistrationVC.Style.BodyTextFont
        label.numberOfLines = 0
        return label
    }()
    
    let okayButton = ThemeButton()
    
    let alertView = UIView()
    
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        return  view
    }()
    
    var cancellable: AnyCancellable?
    
    let tapOkayButton = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapOkayButton() {
        tapOkayButton.send()
    }
    
    private func setup() {
        addSubview(blurView)
        blurView.disableTranslatesAutoresizingMaskIntoContraints()
        blurView.tc_constrainToSuperview()
        alertView.backgroundColor = AppColors.BackgroundMain
        alertView.layer.cornerRadius = 30
        
        addSubview(alertView)
        alertView.disableTranslatesAutoresizingMaskIntoContraints()
        alertView.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 35)
        alertView.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -35)
        alertView.heightAnchor.tc_constrain(equalToConstant: 340)
        alertView.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        
        alertView.addSubview(okayButton)
        okayButton.setTitle(ButtonTitle.Okay.getString(), for: .normal)
        okayButton
            .disableTranslatesAutoresizingMaskIntoContraints()
        okayButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        okayButton.widthAnchor.tc_constrain(equalToConstant: 110)
        okayButton.centerXAnchor.tc_constrain(equalTo: alertView.centerXAnchor)
        okayButton.bottomAnchor.tc_constrain(equalTo: alertView.bottomAnchor, constant: -30)
        
        okayButton.addTarget(self, action: #selector(didTapOkayButton), for: .touchUpInside)
        
        alertView.addSubview(iconImageView)
        iconImageView.disableTranslatesAutoresizingMaskIntoContraints()
        iconImageView.heightAnchor.tc_constrain(equalToConstant: 100)
        iconImageView.widthAnchor.tc_constrain(equalToConstant: 100)
        iconImageView.centerXAnchor.tc_constrain(equalTo: alertView.centerXAnchor)
        iconImageView.topAnchor.tc_constrain(equalTo: alertView.topAnchor, constant: 30)
        
        let labelStack = UIStackView(arrangedSubviews: [largeTitleLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .fill
        labelStack.spacing = 12
        
        alertView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.leadingAnchor.tc_constrain(equalTo: alertView.leadingAnchor, constant: 15)
        labelStack.trailingAnchor.tc_constrain(equalTo: alertView.trailingAnchor, constant: -15)
        labelStack.topAnchor.tc_constrain(equalTo: iconImageView.bottomAnchor, constant: 25)
        labelStack.bottomAnchor.tc_constrain(equalTo: okayButton.topAnchor, constant: -12)
    }
}
