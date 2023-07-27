//
//  MovieDetailsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/18/23.
//

import Foundation
import AVKit
import AVFoundation
import UIKit
import youtube_ios_player_helper


/*
 TMDB Bearer token
 eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNzgxMTQ5Mzg1Y2JiMzQwNjljMmE4NjZlYWMzNWEzMCIsInN1YiI6IjY0YTRhYzBjOGM0NGI5MDEyZDZiOTMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jexcRRrax-HS91ElbcQlu1Xnf8_yp97WgjUjvEQeVJk
 
 
 Now Playing
 https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1
 
 Popular
 https://api.themoviedb.org/3/movie/popular?language=en-US&page=1
 
 Single Movie Retrieval with ID
 https://api.themoviedb.org/3/movie/667538
 
 Youtube base URL
 https://youtu.be/
 https://www.youtube.com/watch?v={Key}
 example - https://youtu.be/OW1mU4vBBEU
 
 This screen will display an image, play button that push to a new view which will automatically play a Youtube video.
 base url, file size, file path
 
 http://image.tmdb.org/t/p/ w500/
 /2vFuG6bWGyQUzYS9d69E5l85nIz.jpg
 
 Clip, teaser, trailer, featureette
 official = true
 
 */

/// MovieDetailsVC
class MovieDetailsVC: BaseViewController {
    /// enum  for Segmented Control Titles
    enum SegmentedControlTitle: String, CaseIterable {
        case Showtimes = "SHOWTIMES"
        case Details = "DETAILS"
        case Videos = "VIDEOS"
        func getString() -> String { return self.rawValue }
    }
    /// enum for Movie Detail screen Icon names
    enum IconName: String {
        case PlayButton = "play-button-hollow"
        func getString() -> String { return self.rawValue }
    }
    /// Style struct
    struct Style {
        static let RSVPButtonHeight: CGFloat = 50
        static let SegmentedControlBackgroundColor: UIColor = AppColors.BackgroundMain
        static let SegmentedControlTintColor: UIColor = .yellow
        static let SegmentedControlTopMargin: CGFloat = 14
    }
    /// movieId string
    fileprivate var movieId: Int? {
        didSet {
            // Call method that calls API class
        }
    }
    /// Tralier header view
    fileprivate lazy var trailerHeader = MovieDetailsTrailerTopView()
    /// Title details view
    fileprivate lazy var titleDetailView = MovieDetailsTitleDurationView()
    /// Title details view top anchor
    fileprivate var titleDetailViewTopAnchor: NSLayoutConstraint?
    /// Title details view height anchor
    fileprivate var titleDetailViewHeightAnchor: NSLayoutConstraint?
    ///  segmented control
    fileprivate lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [SegmentedControlTitle.Showtimes.getString(),
                                            SegmentedControlTitle.Details.getString(),
                                            SegmentedControlTitle.Videos.getString()])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = Style.SegmentedControlBackgroundColor
        sc.tintColor = Style.SegmentedControlTintColor
        sc.selectedSegmentTintColor = .orange
        return sc
    }()
    /// rsvp button
    fileprivate lazy var rsvpButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.RSVPNow.getString(), for: .normal)
        return btn
    }()

    init(movieId: Int) {
        self.movieId = movieId
        super.init()
        configure()
        
//        startButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppNavigation.shared.setNavBarToTranslucent()
        loadBackDropImage()
        segmentedControl.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
        segmentedControl.setDividerImage(nil, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: UIBarMetrics.default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard titleDetailView.frame != .zero else { return }
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.titleDetailViewTopAnchor?.constant = -sSelf.titleDetailView.getTitleLabelHeight()
            sSelf.titleDetailViewHeightAnchor?.constant = sSelf.titleDetailView.intrinsicContentSize.height
            sSelf.view.layoutIfNeeded()
        }
    }
    
    @objc func selectedSegment() {
        segmentedControl.addBorderForSelectedSegment()
        print()
        
    }
    
    // Youtube videos are embedded in webpages, you can use WebView to show those.
    // Or you can have movies stored locally and
    
    /// configure views
    fileprivate func configure() {
        view.addSubview(trailerHeader)
        view.addSubview(titleDetailView)
        view.addSubview(segmentedControl)
        view.addSubview(rsvpButton)
        
        trailerHeader.disableTranslatesAutoresizingMaskIntoContraints()
        trailerHeader.topAnchor.tc_constrain(equalTo: view.topAnchor)
        trailerHeader.heightAnchor.tc_constrain(equalTo: view.widthAnchor, multiplier: 9.0/16.0)
        trailerHeader.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        trailerHeader.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        titleDetailView.disableTranslatesAutoresizingMaskIntoContraints()
        titleDetailView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        titleDetailView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        titleDetailViewTopAnchor = titleDetailView.topAnchor.constraint(equalTo: trailerHeader.bottomAnchor, constant: 0)
        titleDetailViewTopAnchor?.isActive = true
        titleDetailViewHeightAnchor = titleDetailView.heightAnchor.constraint(equalToConstant: 0)
        titleDetailViewHeightAnchor?.isActive = true

        segmentedControl.disableTranslatesAutoresizingMaskIntoContraints()
        segmentedControl.topAnchor.tc_constrain(equalTo: titleDetailView.bottomAnchor, constant: Style.SegmentedControlTopMargin)
        segmentedControl.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        segmentedControl.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        rsvpButton.disableTranslatesAutoresizingMaskIntoContraints()
        rsvpButton.heightAnchor.tc_constrain(equalToConstant: Style.RSVPButtonHeight)
        rsvpButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        rsvpButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        rsvpButton.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppTheme.BottomMargin)
    }
    
    /// Loads backdrop image for trailer header
    @objc fileprivate func loadBackDropImage() {
        let imageUrlString = "https://image.tmdb.org/t/p/w780/qWQSnedj0LCUjWNp9fLcMtfgadp.jpg"
        ImageDownloader.downloadImage(imageUrlString) { [weak self] image, urlString in
            guard let sSelf = self, let image = image else { return }
            DispatchQueue.main.async {
                sSelf.trailerHeader.setBackdropImage(image)
            }
        }
    }
    
    @objc fileprivate func play() {
        let key = "pYPcCSxprcs" // Get ready to join the fight
    }
}
