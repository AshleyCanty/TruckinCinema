//
//  MovieSummaryGenreCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/31/23.
//

import Foundation
import UIKit


class MovieGenrePill: PaddedLabel {
    struct Style {
        static let GenrePillBackgroundColor: UIColor = AppColors.BackgroundSecondary
        static let GenrePillTextFont: UIFont = AppFont.medium(size: 12)
        static let GenrePillTextColor: UIColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
    }
    
    private func configure() {
        font = Style.GenrePillTextFont
        textColor = Style.GenrePillTextColor
        textAlignment = .center
        backgroundColor = Style.GenrePillBackgroundColor
        padding(12, 12, 18, 18)
    }
}

struct MovieSummary {
    static let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}

enum Genre: String, CaseIterable {
    case Action = "Action"
    case Thriller = "Thriller"
    case SciFi = "Sci-fi"
    func getString() -> String { return self.rawValue }
}

class MovieSummaryGenreCell: UITableViewCell {
    /// reuse identifier
    static let reuseIdentifier = "MovieSummaryGenreCell"
    
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let TitleFont: UIFont = AppFont.medium(size: 13)
        static let TitleTextColor: UIColor = AppColors.MovieDetailsTextColorSecondary
        static let TitleTopMargin: CGFloat = 12
        static let SummaryTextViewTopMargin: CGFloat = 12
        static let SummaryTextViewFont: UIFont = AppFont.regular(size: 12)
        static let SummaryTextColor: UIColor = .white
        static let GenrePillBackgroundColor: UIColor = AppColors.BackgroundSecondary
        static let GenrePillTextFont: UIFont = AppFont.medium(size: 12)
        static let GenrePillTextColor: UIColor = .white
        static let GenrePillSpacing: CGFloat = 10.0
        
    }
    
    enum SummaryTitle: String {
        case Synopsis = "SYNOPSIS"
        func getString() -> String { return self.rawValue }
    }
    
    private var summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.textColor = Style.TitleTextColor
        label.text = SummaryTitle.Synopsis.getString()
        label.textAlignment = .left
        return label
    }()
    
    private var summaryTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private var genreStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = Style.GenrePillSpacing
        sv.distribution = .equalCentering // TO-DO - Add stretch view. 3 Pills MAX
        sv.alignment = .fill
        return sv
    }()
    
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
            genrePill.layer.masksToBounds = true
            genrePill.layer.cornerRadius = genrePill.frame.height / 2
        }
    }
    
    private func configure() {
        contentView.backgroundColor = Style.BackgroundColor
        Genre.allCases.forEach { genre in
            let label = PaddedLabel()
            label.text = genre.getString()
            label.font = Style.GenrePillTextFont
            label.textColor = Style.GenrePillTextColor
            label.textAlignment = .center
            label.backgroundColor = Style.GenrePillBackgroundColor
            label.padding(8, 8, 25, 25)
//            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
            genreStack.addArrangedSubview(label)
        }
        
        contentView.addSubview(genreStack)
        genreStack.disableTranslatesAutoresizingMaskIntoContraints()
        genreStack.topAnchor.tc_constrain(equalTo: contentView.topAnchor)
        genreStack.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor)
        genreStack.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor)
    }
}
