//
//  MovieDetailsTrailerTopView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/25/23.
//

import Foundation
import UIKit


class MovieDetailsTrailerTopView: UIView {
    /// enum for Movie Detail screen Icon names
    enum IconName: String {
        case PlayButton = "play-button-hollow"
        func getString() -> String { return self.rawValue }
    }
    /// Style struct
    fileprivate struct Style {
        static let PlayButtonSize: CGFloat = 36
        static let GradientColors: [UIColor] = [UIColor.clear, AppColors.BackgroundMain]
    }
    /// backdrop imageview
    fileprivate lazy var backdropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    /// backdrop gradientlayer
    fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.setVerticalGradient(withColors: Style.GradientColors, startPoint: .zero, endPoint: CGPoint(x: 0.0, y: 1))
        return layer
    }()
    /// play button
    fileprivate lazy var playButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: IconName.PlayButton.getString()), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = .zero
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard gradientLayer.frame == .zero else { return }
        gradientLayer.frame = bounds
    }
    
    /// Configure views
    fileprivate func configure()
    {
        backdropImageView.layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(backdropImageView)
        backdropImageView.disableTranslatesAutoresizingMaskIntoContraints()
        backdropImageView.tc_constrainToSuperview()
        
        addSubview(playButton)
        backdropImageView.bringSubviewToFront(playButton)
        playButton.disableTranslatesAutoresizingMaskIntoContraints()
        playButton.heightAnchor.tc_constrain(equalToConstant: Style.PlayButtonSize)
        playButton.widthAnchor.tc_constrain(equalToConstant: Style.PlayButtonSize)
        playButton.centerXAnchor.tc_constrain(equalTo: centerXAnchor)
        playButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
    }
    /// Sets the backdrop image
    public func setBackdropImage(_ image: UIImage) {
        backdropImageView.image = image
    }
}
