//
//  MovieSummaryGenreCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/31/23.
//

import Foundation
import UIKit

struct MovieSummary {
    static let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}

enum Genres: String, CaseIterable {
    case Action = "Action"
    case Thriller = "Thriller"
    case SciFi = "Sci-fi"
    func getString() -> String { return self.rawValue }
}


protocol MovieSummaryGenreCellProtocol: AnyObject {
    func updateRowHeightForSummaryCell()
}


/// MovieSummaryGenreCell
class MovieSummaryGenreCell: UITableViewCell {
    /// reuse identifier
    static let reuseIdentifier = "MovieSummaryGenreCell"
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TitleFont: UIFont = AppFont.medium(size: 13)
        static let TitleTextColor: UIColor = AppColors.TextColorSecondary
        static let TitleTopMargin: CGFloat = 12
        static let SummaryTextViewTopMargin: CGFloat = 12
        static let SummaryTextViewFont: UIFont = AppFont.regular(size: 12)
        static let SummaryTextColor: UIColor = AppColors.TextColorPrimary
        static let GenrePillBackgroundColor: UIColor = AppColors.BackgroundSecondary
        static let GenrePillTextFont: UIFont = AppFont.medium(size: 12)
        static let GenrePillTextColor: UIColor = AppColors.TextColorPrimary
        static let GenrePillSpacing: CGFloat = 10.0
        
    }
    /// Summary title enum
    enum SummaryTitle: String {
        case Synopsis = "SYNOPSIS"
        func getString() -> String { return self.rawValue }
    }
    
    public var genres: [Genre]? {
        didSet {
            setGenreStack()
        }
    }
    
    /// summary titleLabel
    private var summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.textColor = Style.TitleTextColor
        label.text = SummaryTitle.Synopsis.getString()
        label.textAlignment = .left
        return label
    }()
    /// summary textView
    weak var summaryTextView: UITextView! = {
        let textview = UITextView()
        textview.font = Style.SummaryTextViewFont
        textview.textColor = Style.SummaryTextColor
        textview.isScrollEnabled = false
        textview.isEditable = false
        textview.backgroundColor = Style.BackgroundColor
        textview.textContainerInset = .zero
        textview.textContainer.lineFragmentPadding = 0
        return textview
    }()
    
    /// genre stackview
    private var genreStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = Style.GenrePillSpacing
        sv.distribution = .fillProportionally
        sv.alignment = .fill
        return sv
    }()
    
    /// height constraint for summary text view
    private var summaryTextViewHeightConstraint = NSLayoutConstraint()
    
    public weak var cellDelegate: MovieSummaryGenreCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genreStack.arrangedSubviews.forEach { genrePill in
            genrePill.layer.cornerRadius = genrePill.intrinsicContentSize.height / 2
        }
        if let delegate = cellDelegate {
            delegate.updateRowHeightForSummaryCell()
        }
    }
    
    private func setGenreStack() {
        guard let genreList = genres, genreStack.arrangedSubviews.isEmpty else { return }
        genreList.forEach { genre in
            let label = PaddedLabel()
            label.text = genre.name
            label.font = Style.GenrePillTextFont
            label.textColor = Style.GenrePillTextColor
            label.textAlignment = .center
            label.backgroundColor = Style.GenrePillBackgroundColor
            label.clipsToBounds = true
            label.padding(8, 8, 20, 20)
            label.layer.cornerRadius = label.intrinsicContentSize.height/2
            genreStack.addArrangedSubview(label)
        }
    }
    
    /// Configure the views
    private func configure() {
        contentView.backgroundColor = Style.BackgroundColor
        
        let genreStackWrapper = UIView()
        genreStackWrapper.addSubview(genreStack)
        genreStack.disableTranslatesAutoresizingMaskIntoContraints()
        genreStack.topAnchor.tc_constrain(equalTo: genreStackWrapper.topAnchor)
        genreStack.leadingAnchor.tc_constrain(equalTo: genreStackWrapper.leadingAnchor)
        genreStack.bottomAnchor.tc_constrain(equalTo: genreStackWrapper.bottomAnchor)
        
        let stack = UIStackView(arrangedSubviews: [genreStackWrapper, summaryTitleLabel, summaryTextView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 12

        contentView.addSubview(stack)
        stack.disableTranslatesAutoresizingMaskIntoContraints()
        stack.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        stack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        stack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
        stack.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor)
    }
}
