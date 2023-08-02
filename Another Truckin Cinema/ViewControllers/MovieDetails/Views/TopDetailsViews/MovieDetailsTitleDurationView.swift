//
//  MovieDetailsTitleDurationView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/25/23.
//

import Foundation
import UIKit

/// MovieDetailsTitleDurationView class
class MovieDetailsTitleDurationView: UIView {
    
    /// enum for Movie Detail Title Detail Icon names
    enum IconName: String {
        case Question = "question"
        func getString() -> String { return self.rawValue }
    }
    /// Style struct
    struct Style {
        static let QuestionIconSize: CGFloat = 13
        static let QuestionIconTintColor: UIColor = AppColors.MovieDetailsTextColorSecondary
        static let TitleFont: UIFont = AppFont.bold(size: 17)
        static let TitleTextColor: UIColor = AppColors.MovieDetailsTextColorPrimary
        static let DurationRatingFont: UIFont = AppFont.regular(size: 11)
        static let DurationRatingTextColor: UIColor = AppColors.MovieDetailsTextColorSecondary
        static let HStackTopMargin: CGFloat = 8
        static let HStackSpacing: CGFloat = 8
        static let releaseDateTopMargin: CGFloat = 8
    }
    /// vertical stackview
    let vStack: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.axis = .vertical
        return sv
    }()
    /// horizontal stackview
    let hStack: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fill
        sv.alignment = .center
        sv.axis = .horizontal
        sv.spacing = Style.HStackSpacing
        return sv
    }()
    ///  title label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    ///  duration label
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = Style.DurationRatingFont
        return label
    }()
    ///  rating label
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = Style.DurationRatingFont
        return label
    }()
    ///  release date label
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = Style.DurationRatingFont
        return label
    }()
    ///  quetion icon image view
    lazy var questionIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(imgNamed: IconName.Question.getString()))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Style.DurationRatingTextColor
        imageView.frame.size = CGSize(width: Style.QuestionIconSize, height: Style.QuestionIconSize)
        return imageView
    }()
    /// vertical seperator view
    lazy var verticalSeperator = SeperatorView()
    /// True if question icon constraints have bee set
    var didSetQuestionIconConstraints: Bool = false
    
    override var intrinsicContentSize: CGSize {
        var height: CGFloat = Style.HStackTopMargin + Style.releaseDateTopMargin
        [titleLabel, durationLabel, releaseDateLabel].forEach { height += $0.intrinsicContentSize.height }
        /// Find this view's width by using its superview's width and subtracting the side margins
        let superviewWidth = superview?.frame.width ?? 0
        return CGSize(width: superviewWidth - (AppTheme.LeadingTrailingMargin*2), height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configure()
        showText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard hStack.frame != .zero, !didSetQuestionIconConstraints else { return }
        questionIcon.disableTranslatesAutoresizingMaskIntoContraints()
        questionIcon.heightAnchor.tc_constrain(equalToConstant: Style.QuestionIconSize)
        questionIcon.widthAnchor.tc_constrain(equalToConstant: Style.QuestionIconSize)
        didSetQuestionIconConstraints = true
    }
    
    /// Returns height of title label
    public func getTitleLabelHeight() -> CGFloat {
        return titleLabel.frame.height
    }
    
    fileprivate func showText() {
        titleLabel.text = "Transformers: Rise of the Beasts Collection"
        durationLabel.text = "2 HR 7 MIN"
        ratingLabel.text = "PG13"
        releaseDateLabel.text = "Released Jun 6, 2023"
    }
    
    /// Configures views
    fileprivate func configure() {
        ///  HStack's arranged subviews
        durationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        questionIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        verticalSeperator.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ratingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        hStack.addArrangedSubview(durationLabel)
        hStack.addArrangedSubview(questionIcon)
        hStack.addArrangedSubview(verticalSeperator)
        hStack.addArrangedSubview(ratingLabel)
        
        ///  Vertical stack's arranged subviews
        addSubview(titleLabel)
        addSubview(hStack)
        addSubview(releaseDateLabel)
        
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        hStack.disableTranslatesAutoresizingMaskIntoContraints()
        releaseDateLabel.disableTranslatesAutoresizingMaskIntoContraints()
        
        titleLabel.topAnchor.tc_constrain(equalTo: topAnchor)
        titleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        titleLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
        
        hStack.topAnchor.tc_constrain(equalTo: titleLabel.bottomAnchor, constant: Style.HStackTopMargin)
        hStack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        hStack.trailingAnchor.tc_constrain(lessThanOrEqualTo: trailingAnchor)
        
        releaseDateLabel.topAnchor.tc_constrain(equalTo: hStack.bottomAnchor, constant: Style.releaseDateTopMargin)
        releaseDateLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        releaseDateLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
    }
}