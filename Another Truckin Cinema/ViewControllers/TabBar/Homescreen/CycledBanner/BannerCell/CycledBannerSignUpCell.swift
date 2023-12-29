//
//  CycledBannerSignUpCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/13/23.
//

import Foundation
import UIKit

/// CycleBannerSignUpCell class
class CycledBannerSignUpCell: UICollectionViewCell {

    static let reuseIdentifier: String = "CycledBannerSignUpCell"
    
    public lazy var signUpBannerView = SignUpBannerView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented.")
    }

    /// Sets up views
    fileprivate func setupViews() {
        contentView.addSubview(signUpBannerView)
        
        signUpBannerView.disableTranslatesAutoresizingMaskIntoContraints()
        signUpBannerView.tc_constrainToSuperview()
    }
}
