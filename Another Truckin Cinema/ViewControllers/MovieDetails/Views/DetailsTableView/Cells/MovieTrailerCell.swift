//
//  MovieTrailersTableView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/31/23.
//

import Foundation
import UIKit

protocol MovieTrailerCellProtocol: AnyObject {
    func updateRowHeightForTrailerCell()
    func didPressPlayButton(key: String)
    func didPressTrailerShareButton(key: String)
}

class MovieTrailerCell: UITableViewCell {
    /// reuse identifier
    static let reuseIdentifier = "MovieTrailerCell"
    /// icon name enum
    enum IconName: String {
        case share = "share"
        func getString() -> String { return self.rawValue }
    }
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TextFont: UIFont = AppFont.regular(size: 11)
        static let TextColor: UIColor = AppColors.TextColorSecondary
        static let DurationTextColor: UIColor = AppColors.TextColorPrimary
        static let TitleTopMargin: CGFloat = 12
        static let GenrePillBackgroundColor: UIColor = AppColors.BackgroundSecondary
        static let GenrePillTextFont: UIFont = AppFont.medium(size: 13)
        static let GenrePillTextColor: UIColor = AppColors.TextColorPrimary
        static let GenrePillSpacing: CGFloat = 10.0
        static let PlayButtonSize: CGFloat = 36
        static let CornerRadius: CGFloat = 15
        
    }
    /// shadowview for backdrop image view
    fileprivate let shadowWrapperView = UIView()
    /// poster image view
    public var backdropImageView: CustomImageView = {
        let imageview = CustomImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = Style.CornerRadius
        imageview.backgroundColor = AppColors.BannerCollectionBGColor
        return imageview
    }()
    /// play button
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: MovieDetailsTrailerTopView.IconName.PlayButton.getString()), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = .zero
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    /// share button
    public let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(imgNamed: IconName.share.getString()), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = .zero
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    /// duration label
    public let durationlabel: UILabel = {
        let label = UILabel()
        label.text = "2:37"
        label.textAlignment = .right
        label.textColor = Style.DurationTextColor
        label.font = Style.TextFont
        return label
    }()
    /// trailer title label
    public let trailerTitleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = Style.TextColor
        label.font = Style.TextFont
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    /// trailer date posted label
    public let trailerDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2 months ago"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = Style.TextColor
        label.font = Style.TextFont
        return label
    }()
    
    private var videoKey = ""
    
    weak var cellDelegate: MovieTrailerCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shadowWrapperView.backgroundColor = .clear
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellDelegate?.updateRowHeightForTrailerCell()
        // refactor - fix shadow getting cut off at sides
        guard shadowWrapperView.layer.shadowPath == nil else { return }
        shadowWrapperView.addShadow(color: AppTheme.ShadowColor, opacity: AppTheme.ShadowOpacity, radius: AppTheme.ShadowRadius, offset: AppTheme.ShadowOffset)
    }
    
    /// configure views
    private func configure() {
        backgroundColor = Style.BackgroundColor
        contentView.backgroundColor = Style.BackgroundColor
        
        let wrapperView = UIView()
        wrapperView.backgroundColor = .clear
        contentView.addSubview(wrapperView)
        wrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        wrapperView.tc_constrainToSuperview()
        
        wrapperView.addSubviews(subviews: [shadowWrapperView])
        shadowWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        shadowWrapperView.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor)
        shadowWrapperView.heightAnchor.tc_constrain(equalTo: contentView.widthAnchor, multiplier: 9.0/16.0)
        shadowWrapperView.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor)
        shadowWrapperView.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor)
        
        shadowWrapperView.addSubviews(subviews: [backdropImageView])
        backdropImageView.disableTranslatesAutoresizingMaskIntoContraints()
        backdropImageView.tc_constrainToSuperview()
        
        contentView.addSubview(playButton)
        playButton.disableTranslatesAutoresizingMaskIntoContraints()
        playButton.heightAnchor.tc_constrain(equalToConstant: Style.PlayButtonSize)
        playButton.widthAnchor.tc_constrain(equalToConstant: Style.PlayButtonSize)
        playButton.centerXAnchor.tc_constrain(equalTo: backdropImageView.centerXAnchor)
        playButton.centerYAnchor.tc_constrain(equalTo: backdropImageView.centerYAnchor)
        
        playButton.addTarget(self, action: #selector(playTrailer), for: .touchUpInside)
        
        backdropImageView.addSubview(durationlabel)
        durationlabel.disableTranslatesAutoresizingMaskIntoContraints()
        durationlabel.trailingAnchor.tc_constrain(equalTo: backdropImageView.trailingAnchor, constant: -6)
        durationlabel.bottomAnchor.tc_constrain(equalTo: backdropImageView.bottomAnchor, constant: -6)
        
        let labelStack = UIStackView(arrangedSubviews: [trailerTitleLabel, trailerDateLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 3
        
        wrapperView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.widthAnchor.tc_constrain(lessThanOrEqualTo: widthAnchor, multiplier: 2/3, constant: 0)
        labelStack.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor)
        labelStack.topAnchor.tc_constrain(equalTo: shadowWrapperView.bottomAnchor, constant: 8)
        labelStack.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor, constant: -18)
        
        wrapperView.addSubview(shareButton)
        shareButton.disableTranslatesAutoresizingMaskIntoContraints()
        shareButton.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor)
        shareButton.topAnchor.tc_constrain(equalTo: shadowWrapperView.bottomAnchor, constant: 8)
        shareButton.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor, constant: -18)
        shareButton.heightAnchor.tc_constrain(equalToConstant: 25)
        shareButton.widthAnchor.tc_constrain(equalToConstant: 25)
        
        shareButton.addTarget(self, action: #selector(shareTrailer), for: .touchUpInside)
        
        backdropImageView.bringSubviewToFront(playButton)
    }
    
    /// Sets video key with value passed. Must be set before the ytplayer can play a video
    public func setVideoKey(key: String) {
        videoKey = key
    }
    
    /// Triggers ytplayer to be presented for trailer viewing
    @objc private func playTrailer() {
        cellDelegate?.didPressPlayButton(key: videoKey)
    }
    
    @objc private func shareTrailer() {
        cellDelegate?.didPressTrailerShareButton(key: videoKey)
    }
}

