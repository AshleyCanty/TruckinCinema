//
//  ParticipatingDriveInsTableView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/7/23.
//

import Foundation
import UIKit
import Combine

class ParticipatingDriveInsTableView: UIView {
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFill
        btn.imageView?.tintColor = .white
        return btn
    }()
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Select a Participating Drive-in"
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "NEARBY DRIVE-INS"
        label.textColor = AppColors.RegularGray
        label.font = AppFont.regular(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = AppColors.BackgroundSecondary
        return table
    }()
    
    var cancellable: AnyCancellable?
    
    let tapCloseButton = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapCloseButton() {
        tapCloseButton.send()
    }
    
    private func setup() {
        backgroundColor = AppColors.BackgroundSecondary
        addSubviews(subviews: [largeTitleLabel, subTitleLabel, closeButton, tableView])
        
        largeTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        largeTitleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 12)
        largeTitleLabel.topAnchor.tc_constrain(equalTo: topAnchor, constant: 20)
        
        closeButton.disableTranslatesAutoresizingMaskIntoContraints()
        closeButton.heightAnchor.tc_constrain(equalToConstant: 15)
        closeButton.widthAnchor.tc_constrain(equalToConstant: 15)
        closeButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -12)
        closeButton.centerYAnchor.tc_constrain(equalTo: largeTitleLabel.centerYAnchor)
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    
        subTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        subTitleLabel.topAnchor.tc_constrain(equalTo: largeTitleLabel.bottomAnchor, constant: 12)
        subTitleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 12)
        
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: subTitleLabel.bottomAnchor, constant: 20)
        tableView.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        tableView.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
        tableView.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
    }
}


class ParticipatingDriveInCell: UITableViewCell {
    
    static let reuseId = "ParticipatingDriveInCell"
    
    let driveInLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = AppColors.TextColorPrimary
        label.font = RegistrationVC.Style.BodyTextFont
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let selectedView = UIView()
        selectedView.backgroundColor = AppColors.BackgroundMain
        
        let normalView = UIView()
        normalView.backgroundColor = AppColors.BackgroundSecondary
        
        selectedBackgroundView = selectedView
        backgroundView = normalView
        
        contentView.addSubview(driveInLabel)
        driveInLabel.disableTranslatesAutoresizingMaskIntoContraints()
        driveInLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        driveInLabel.centerYAnchor.tc_constrain(equalTo: contentView.centerYAnchor)
    }
}
