//
//  TierCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/31/23.
//

import Foundation
import UIKit
import Combine

class TierCell: UITableViewCell {

    static let reuseId = "TierCell"

    struct Style {
        static let JoinButtonBorderWidth: CGFloat = 1
        static let JoinButtonBorderColor: UIColor = AppColors.TextColorPrimary
        static let JoinButtonTitleLabelFont: UIFont = AppFont.semiBold(size: 10)
        static let JoinButtonTextColor: UIColor = AppColors.TextColorPrimary
        static let ButtonWidth: CGFloat = 65
        static let ButtonHeight: CGFloat = 25
        static let JoinButtonTrailingMargin: CGFloat = 12
        static let JoinButtonBottomMargin: CGFloat = 12
    }
    
    // 'Join' button
    fileprivate lazy var joinButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.addBorder(color: Style.JoinButtonBorderColor, width: Style.JoinButtonBorderWidth)
        button.backgroundColor = .clear
        button.setTitle(ButtonTitle.JoinNow.getString(), for: .normal)
        button.setTitleColor(Style.JoinButtonTextColor, for: .normal)
        button.titleLabel?.font = Style.JoinButtonTitleLabelFont
        return button
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private lazy var tierTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.semiBold(size: 15)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var tierSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.semiBold(size: 14)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        return label
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular(size: 11)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public var tier: VIPTier = .Tier1
    
    var cancellable: AnyCancellable?
    
    let tapJoinButton = PassthroughSubject<VIPTier, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        joinButton.addTarget(self, action: #selector(didTapJoinButton), for: .touchUpInside)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapJoinButton() {
        self.tapJoinButton.send(tier)
    }
    
    public func configure(withTier tier: VIPTier) {
        self.tier = tier
        bgImageView.image = UIImage(imgNamed: "tier_\(tier.getString())")
        var tierData: TierData
        switch tier {
        case .Tier1:
            tierData = TierData(title: Tier.tier1.getString(), subtitle: TierSubtitle.tier1.getString(), description: TierDescription.tier1.getString())
        case .Tier2:
            tierData = TierData(title: Tier.tier2.getString(), subtitle: TierSubtitle.tier2.getString(), description: TierDescription.tier2.getString())
        case .Tier3:
            tierData = TierData(title: Tier.tier3.getString(), subtitle: TierSubtitle.tier3.getString(), description: TierDescription.tier3.getString())
        }
        
        tierTitleLabel.text = tierData.title
        tierSubtitleLabel.text = tierData.subtitle
        descriptionLabel.text = tierData.description
    }
    
    private func setup() {
        let wrapperView = UIView()
        wrapperView.backgroundColor = .clear
        wrapperView.clipsToBounds = true
        wrapperView.layer.cornerRadius = 8
        
        contentView.addSubview(wrapperView)
        wrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        wrapperView.tc_constrainToEdgesWithMargins(view: contentView, top: 4, bottom: -4, leading: 12, trailing: -12)
        
        wrapperView.addSubviews(subviews: [bgImageView, tierTitleLabel, joinButton])
        
        bgImageView.disableTranslatesAutoresizingMaskIntoContraints()
        bgImageView.tc_constrainToSuperview()
        
        joinButton.disableTranslatesAutoresizingMaskIntoContraints()
        joinButton.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor, constant: -12)
        joinButton.centerYAnchor.tc_constrain(equalTo: tierTitleLabel.centerYAnchor)
        joinButton.heightAnchor.tc_constrain(equalToConstant: Style.ButtonHeight)
        joinButton.widthAnchor.tc_constrain(equalToConstant: Style.ButtonWidth)
        
        tierTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        tierTitleLabel.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor, constant: 12)
        tierTitleLabel.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor, constant: 20)
        
        let labelStack = UIStackView(arrangedSubviews: [tierSubtitleLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 6
        
        wrapperView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor, constant: 12)
        labelStack.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor, constant: -12)
        labelStack.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor, constant: -16)
    }
}



struct TierData {
    let title: String
    let subtitle: String
    let description: String
}

/// VIP tier enum
enum Tier: String {
    case tier1 = "Tier 1"
    case tier2 = "Tier 2"
    case tier3 = "Tier 3"
    func getString() -> String { return self.rawValue }
}

enum TierSubtitle: String {
    case tier1 = "See up to 3 Movies Every Week"
    case tier2 = "Get Premium Perks"
    case tier3 = "Join FREE & Enjoy"
    func getString() -> String { return self.rawValue }
}

enum TierDescription: String {
    case tier1 = "Join our monthly movie membership and make FREE online reservations in advance. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis."
    case tier2 = "Enjoy waived online fees. Free pocorn and fountain drink size upgrades and more for just $15.00 (+tax)/year. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantiure veritatis."
    case tier3 = "Get a FREE refill on every large popcorn you purchase. Discount Wednesday savings and more."
    func getString() -> String { return self.rawValue }
}
