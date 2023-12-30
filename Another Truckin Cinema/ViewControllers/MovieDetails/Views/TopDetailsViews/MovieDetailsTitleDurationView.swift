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
        static let QuestionIconTintColor: UIColor = AppColors.TextColorSecondary
        static let TitleFont: UIFont = AppFont.bold(size: 17)
        static let TitleTextColor: UIColor = AppColors.TextColorPrimary
        static let DurationRatingFont: UIFont = AppFont.regular(size: 11)
        static let DurationRatingTextColor: UIColor = AppColors.TextColorSecondary
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
        label.textColor = Style.TitleTextColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    ///  duration label
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TitleTextColor
        label.font = Style.DurationRatingFont
        return label
    }()
    ///  rating label
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TitleTextColor
        label.font = Style.DurationRatingFont
        return label
    }()
    ///  release date label
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TitleTextColor
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
    
    public var movie: Movie? {
        didSet {
            updateViewsWithMovieData()
        }
    }
    
    /// vertical seperator view
    lazy var verticalSeperator = SeperatorView()
    /// True if question icon constraints have bee set
    var didSetQuestionIconConstraints: Bool = false
    /// true if should show release label
    private var showReleaseDate: Bool = true
    
    override var intrinsicContentSize: CGSize {
        var height: CGFloat = Style.HStackTopMargin + Style.releaseDateTopMargin
        [titleLabel, durationLabel, releaseDateLabel].forEach { height += $0.intrinsicContentSize.height }
        /// Find this view's width by using its superview's width and subtracting the side margins
        let superviewWidth = superview?.frame.width ?? 0
        return CGSize(width: superviewWidth - (AppTheme.LeadingTrailingMargin*2), height: height)
    }
    
    init(showReleaseDate: Bool = true) {
        super.init(frame: .zero)
        self.showReleaseDate = showReleaseDate
        backgroundColor = .clear
        configure()
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
    
    private func updateViewsWithMovieData() {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        durationLabel.text = movie.runtime?.convertToRuntimeString()
        releaseDateLabel.text = movie.releaseDate?.convertToDisplayDate()
    }
    
    
    
    /// Updates font of movie title
    public func updateMovieTitleFont(font: UIFont) {
        titleLabel.font = font
    }
    
    public func updateDurationRatingTextColor(with color: UIColor) {
        durationLabel.textColor = color
        ratingLabel.textColor = color
        questionIcon.tintColor = color
        verticalSeperator.backgroundColor = color
    }
    
    /// Returns height of title label
    public func getTitleLabelHeight() -> CGFloat {
        return titleLabel.frame.height
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
        
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        hStack.disableTranslatesAutoresizingMaskIntoContraints()
        
        titleLabel.topAnchor.tc_constrain(equalTo: topAnchor)
        titleLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        titleLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
        
        hStack.topAnchor.tc_constrain(equalTo: titleLabel.bottomAnchor, constant: Style.HStackTopMargin)
        hStack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        hStack.trailingAnchor.tc_constrain(lessThanOrEqualTo: trailingAnchor)
        
        
        guard showReleaseDate else { return }
        addSubview(releaseDateLabel)
        releaseDateLabel.disableTranslatesAutoresizingMaskIntoContraints()
        releaseDateLabel.topAnchor.tc_constrain(equalTo: hStack.bottomAnchor, constant: Style.releaseDateTopMargin)
        releaseDateLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        releaseDateLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
    }
}
