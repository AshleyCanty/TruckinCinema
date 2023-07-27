//
//  SeperatorView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/25/23.
//

import Foundation
import UIKit

/// SeperatorView class
class SeperatorView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = AppColors.MovieDetailsTextColorSecondary
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1, height: 15)
    }
}
