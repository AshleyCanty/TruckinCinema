//
//  MovieQRCodeConfirmationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/8/23.
//

import Foundation
import UIKit

class MovieQRCodeConfirmationCell: UITableViewCell {
    /// reuse id
    static let reuseIdentifier = "MovieQRCodeConfirmationCell"
    
    struct Style {
        static let LargeStackSpacing: CGFloat = 25
        static let LeftMargin: CGFloat = 17
        static let LargeTitleFont: UIFont = AppFont.extraBold(size: 19)
        static let LargeTitleTextColor: UIColor = AppColors.TextColorPrimary
        static let GreyTextFont: UIFont = AppFont.regular(size: 11)
        static let GreyTextColor: UIColor = AppColors.TextColorSecondary
        static let SemiBoldTextColor: UIColor = AppColors.TextColorPrimary
        static let SemiBoldTextFont: UIFont = AppFont.semiBold(size: 11)
        static let LinkTextColor: UIColor = AppColors.RegularTeal
        static let MovieImageSize: CGFloat = 85
        static let QRImageSize: CGFloat = 110
        static let QRImageBorderColor: UIColor = AppColors.QRImageBorderColor
    }
    
    /// ticket confirmation stackview
    lazy var ticketNumberStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ticketConfirmationTitle, ticketConfirmationNumber])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        return stack
    }()
    
    /// ticket confirmation header label
    private lazy var ticketConfirmationTitle: UILabel = {
        let label = UILabel()
        label.textColor = Style.GreyTextColor
        label.font = Style.GreyTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    /// ticket confirmation number label
    private lazy var ticketConfirmationNumber: UILabel = {
        let label = UILabel()
        label.textColor = Style.SemiBoldTextColor
        label.font = Style.SemiBoldTextFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// ticket confirmation stackview
    lazy var rightSideStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleDetailView, ticketNumberStack, qrImageView])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    /// movie image view
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemRed
        imageView.layer.cornerRadius = Style.MovieImageSize / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    /// QR code Image view
    private lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addBorder(color: Style.QRImageBorderColor, width: 5)
        imageView.backgroundColor = .systemGreen
        imageView.layer.cornerRadius = Style.QRImageSize / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    /// Movie details view (rating, duration)
    private lazy var titleDetailView = MovieDetailsTitleDurationView(showReleaseDate: false)
    /// Title details view top anchor
    fileprivate var titleDetailViewTopAnchor: NSLayoutConstraint?
    /// Title details view height anchor
    fileprivate var titleDetailViewHeightAnchor: NSLayoutConstraint?
    
    private var rightSideQRDetailVew = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard titleDetailView.frame != .zero else { return }
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.titleDetailViewTopAnchor?.constant = -sSelf.titleDetailView.getTitleLabelHeight()
            sSelf.titleDetailViewHeightAnchor?.constant = sSelf.titleDetailView.intrinsicContentSize.height
                sSelf.layoutIfNeeded()
        }
    }
    
    /// set up views
    private func configure() {
        titleDetailView.updateMovieTitleFont(font: Style.LargeTitleFont)
        titleDetailView.updateDurationRatingTextColor(with: Style.GreyTextColor)
        
        backgroundColor = .clear
        contentView.addSubview(movieImageView)
        contentView.addSubview(rightSideQRDetailVew)
        rightSideQRDetailVew.addSubview(rightSideStack)
        
        movieImageView.disableTranslatesAutoresizingMaskIntoContraints()
        movieImageView.heightAnchor.tc_constrain(equalToConstant: Style.MovieImageSize)
        movieImageView.widthAnchor.tc_constrain(equalToConstant: Style.MovieImageSize)
        movieImageView.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        movieImageView.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        movieImageView.bottomAnchor.tc_constrain(lessThanOrEqualTo: contentView.bottomAnchor)
        
        rightSideQRDetailVew.disableTranslatesAutoresizingMaskIntoContraints()
        rightSideQRDetailVew.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        rightSideQRDetailVew.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor, constant: -12)
        rightSideQRDetailVew.leadingAnchor.tc_constrain(equalTo: movieImageView.trailingAnchor, constant: Style.LeftMargin)
        rightSideQRDetailVew.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
        
        rightSideStack.disableTranslatesAutoresizingMaskIntoContraints()
        rightSideStack.topAnchor.tc_constrain(equalTo: rightSideQRDetailVew.topAnchor)
        rightSideStack.leadingAnchor.tc_constrain(equalTo: rightSideQRDetailVew.leadingAnchor)
        rightSideStack.trailingAnchor.tc_constrain(equalTo: rightSideQRDetailVew.trailingAnchor)
        
        qrImageView.disableTranslatesAutoresizingMaskIntoContraints()
        qrImageView.heightAnchor.tc_constrain(equalToConstant: Style.QRImageSize)
        qrImageView.widthAnchor.tc_constrain(equalToConstant: Style.QRImageSize)
        
        rightSideStack.setCustomSpacing(Style.LargeStackSpacing, after: ticketNumberStack)
    }

    private func addText() {
        ticketConfirmationTitle.text = "TICKET CONFIRMATION #:"
        ticketConfirmationNumber.text = "01736492745"
    }
}
