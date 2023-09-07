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
class MovieDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, ShowtimeRadioListCellDelegate, MovieSummaryGenreCellProtocol, MovieTrailerCellProtocol, MovieDetailsTrailerTopViewProtocol, YTPlayerViewDelegate, AppNavigationBarDelegate {
    
    /// enum  for Segmented Control Titles
    enum SegmentedControlTitle: String, CaseIterable {
        case Showtimes = "SHOWTIMES"
        case Details = "DETAILS"
        case Videos = "VIDEOS"
        func getString() -> String { return self.rawValue }
    }

    /// Style struct
    struct Style {
        static let SegmentedControlBackgroundColor: UIColor = AppColors.BackgroundMain
        static let SegmentedControlTintColor: UIColor = .yellow
        static let SegmentedControlTopMargin: CGFloat = 0
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
    fileprivate lazy var segmentedControl: CustomSegmentedControl = {
        let sc = CustomSegmentedControl(items: [SegmentedControlTitle.Showtimes.getString(),
                                            SegmentedControlTitle.Details.getString(),
                                            SegmentedControlTitle.Videos.getString()])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    /// table view that display different data when segmentedControl changes
    fileprivate var tableView: UITableView = {
       let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    /// rsvp button
    fileprivate lazy var rsvpButton: ThemeButton = {
        let btn = ThemeButton(type: .custom)
        btn.setTitle(ButtonTitle.RSVPNow.getString(), for: .normal)
        return btn
    }()
    /// wrapper view to hide/show the rsvp button
    fileprivate lazy var rsvpButtonWrapperView = UIView()
    /// movieId string
    fileprivate var movieId: Int? {
        didSet {
            // Call method that calls API class
        }
    }

    init(movieId: Int) {
        self.movieId = movieId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailerHeader.delegate = self
        configure()
        loadBackDropImage()
        registerTableViewCells()
        configureTableDataSource()
        self.navigationItem.hidesBackButton = true
        segmentedControl.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
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
    
    /// registers table view cells
    fileprivate func registerTableViewCells() {
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: ShowtimeCell.reuseIdentifier)
        tableView.register(ShowtimeRadioListCell.self, forCellReuseIdentifier: ShowtimeRadioListCell.reuseIdentifier)
        tableView.register(MovieSummaryGenreCell.self, forCellReuseIdentifier: MovieSummaryGenreCell.reuseIdentifier)
        tableView.register(MovieTrailerCell.self, forCellReuseIdentifier: MovieTrailerCell.reuseIdentifier)
        
    }
    
    /// Configured tableview datasource and delegate
    fileprivate func configureTableDataSource() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func selectedSegment() {
        // TODO - Create a sidemenu with a gradient background and corner radius
        if segmentedControl.selectedSegmentIndex != 0 {
            rsvpButton.isHidden = true
        } else {
            rsvpButton.isHidden = false
        }
        tableView.reloadData()
    }
     
    /// configure views
    fileprivate func configure() {
        view.addSubview(trailerHeader)
        view.addSubview(titleDetailView)
        view.addSubview(segmentedControl)
        view.addSubview(rsvpButtonWrapperView)
        view.addSubview(tableView)
        
        trailerHeader.disableTranslatesAutoresizingMaskIntoContraints()
        trailerHeader.topAnchor.tc_constrain(equalTo: view.topAnchor)
        trailerHeader.heightAnchor.tc_constrain(equalTo: view.widthAnchor, multiplier: 9.0/16.0)
        trailerHeader.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        trailerHeader.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        titleDetailView.disableTranslatesAutoresizingMaskIntoContraints()
        titleDetailView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        titleDetailView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        /// Updated in viewDidLayoutSubviews()
        titleDetailViewTopAnchor = titleDetailView.topAnchor.constraint(equalTo: trailerHeader.bottomAnchor, constant: 0)
        titleDetailViewTopAnchor?.isActive = true
        titleDetailViewHeightAnchor = titleDetailView.heightAnchor.constraint(equalToConstant: 0)
        titleDetailViewHeightAnchor?.isActive = true

        segmentedControl.disableTranslatesAutoresizingMaskIntoContraints()
        segmentedControl.heightAnchor.tc_constrain(equalToConstant: 45)
        segmentedControl.topAnchor.tc_constrain(equalTo: titleDetailView.bottomAnchor, constant: Style.SegmentedControlTopMargin)
        segmentedControl.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        segmentedControl.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: segmentedControl.bottomAnchor, constant: 25)
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        tableView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        rsvpButtonWrapperView.alpha = 0
        rsvpButtonWrapperView.backgroundColor = .clear
        view.bringSubviewToFront(rsvpButtonWrapperView)
        rsvpButtonWrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        rsvpButtonWrapperView.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height + AppTheme.BottomMargin*2)
        rsvpButtonWrapperView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        rsvpButtonWrapperView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        rsvpButtonWrapperView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)

        rsvpButtonWrapperView.addSubview(rsvpButton)
        rsvpButton.disableTranslatesAutoresizingMaskIntoContraints()
        rsvpButton.heightAnchor.tc_constrain(equalToConstant: ThemeButton.Style.Height)
        rsvpButton.centerYAnchor.tc_constrain(equalTo: rsvpButtonWrapperView.centerYAnchor)
        rsvpButton.leadingAnchor.tc_constrain(equalTo: rsvpButtonWrapperView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        rsvpButton.trailingAnchor.tc_constrain(equalTo: rsvpButtonWrapperView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        rsvpButton.addTarget(self, action: #selector(didPressRSVPButton), for: .touchUpInside)
        
        addCustomNavBar()
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
    
    // MARK: - Custom NavBar methods
    
    func didPressNavBarRightButton() {}
    
    func didPressNavBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addCustomNavBar() {
        let appNavBar = AppNavigationBar(type: .MovieDetails)
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
    }
    
    // MARK: - Cell Delegate methods
    
    /// animates rsvp button visibility based on isSelected value
    func didSelectRadioButton(isSelected: Bool) {
        if isSelected {
            showRSVPButton()
            return
        }
            hideRSVPButton()
    }
    /// shows rsvp button
    @objc func showRSVPButton() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.rsvpButtonWrapperView.alpha = 1
        }
    }
    /// hides rsvp button
    @objc func hideRSVPButton() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.rsvpButtonWrapperView.alpha = 0
        }
    }
    
    func didPressPlayButton(key: String) {
        playTrailer(videoKey: key)
    }
    
    func didPressPlayButtonForTopTrailer() {
        playTrailer(videoKey: "pYPcCSxprcs")
    }
    
    private func playTrailer(videoKey: String? = ""){
        // let key = "pYPcCSxprcs" // Get ready to join the fight
        guard let key = videoKey else { return }
        let trailerPlayerVC = TrailerPlayerVC()
        trailerPlayerVC.setVideKey(key: key)
        trailerPlayerVC.modalTransitionStyle = .coverVertical
        trailerPlayerVC.modalPresentationStyle = .fullScreen
        present(trailerPlayerVC, animated: true)
    }
    
    @objc private func didPressRSVPButton() {
        let ticketSelectionVC = TicketSelectionVC(movieDetails: "")
        AppNavigation.shared.pushViewController(ticketSelectionVC, animated: true)
    }
}

// MARK: -- TableView Delegate & Data Source Methods

extension MovieDetailsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSegmentIndex = SegmentedControlIndex(rawValue: segmentedControl.selectedSegmentIndex)
        switch selectedSegmentIndex {
        case .zero:
            return 3
        case .one:
            return 1
        case .two:
            return 3
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let selectedSegmentIndex = SegmentedControlIndex(rawValue: segmentedControl.selectedSegmentIndex)
        switch selectedSegmentIndex {
        case .zero:
            cell = getShowtimeCell(indexPath: indexPath)
        case .one:
            if let unwrappedCell = getSummaryCell(indexPath: indexPath) as? MovieSummaryGenreCell {
                unwrappedCell.cellDelegate = self
                cell = unwrappedCell
            }
        case .two:
            cell = getTrailerCell(indexPath: indexPath)
        case .none:
            print()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selectedSegmentIndex = SegmentedControlIndex(rawValue: segmentedControl.selectedSegmentIndex)
        switch selectedSegmentIndex {
        case .zero:
            return getHeightForShowtimeCells(indexPath: indexPath)
        case .one:
            return getHeightForSummaryCell(indexPath: indexPath)
        case .two:
            return getHeightForTrailerCell(indexPath: indexPath)
        case .none:
            return 0
        }
    }
    
    // MARK: -- Custom table methods
    
    /// MovieSummaryGenreCellProtocol method used to update TableView row heights after the summary textView height changes
    func updateRowHeightForSummaryCell() {
        triggerTableViewUpdates()
    }
    
    /// MovieTrailerCellProtocol method used to update TableView row heights 
    func updateRowHeightForTrailerCell() {
//        triggerTableViewUpdates()
    }
    
    private func triggerTableViewUpdates() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    /// enum for segmentedControl index2
    enum SegmentedControlIndex: Int {
        case zero, one, two
    }
    
    /// return showtime cell height
    func getHeightForShowtimeCells(indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 62
        } else {
            return 160
        }
    }
    /// return summary cell height
    func getHeightForSummaryCell(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    /// return trailer cell height
    func getHeightForTrailerCell(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Return showtime cell
    private func getShowtimeCell(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let showtimeCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeCell.reuseIdentifier, for: indexPath) as? ShowtimeCell {
                showtimeCell.setup(title: ShowtimeTitle.Placement.getString(), subtitle: ShowtimeSubtitle.Placement.getString())
                return showtimeCell
            }
        } else if indexPath.row == 1 {
            if let showtimeCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeCell.reuseIdentifier, for: indexPath) as? ShowtimeCell {
                showtimeCell.setup(title: ShowtimeTitle.Showtime.getString(), subtitle: ShowtimeSubtitle.Showtime.getString())
                return showtimeCell
            }
        } else {
            if let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeRadioListCell.reuseIdentifier, for: indexPath) as? ShowtimeRadioListCell {
                unwrappedCell.cellDelegate = self
                return unwrappedCell
            }
        }
        return UITableViewCell()
    }
    
    /// Return summary cell
    private func getSummaryCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieSummaryGenreCell.reuseIdentifier, for: indexPath) as? MovieSummaryGenreCell
        return cell ?? UITableViewCell()
    }
    
    /// Return movie trailer cell
    private func getTrailerCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTrailerCell.reuseIdentifier, for: indexPath) as? MovieTrailerCell {
            cell.cellDelegate = self
            cell.setVideoKey(key: "pYPcCSxprcs")
            let imageUrlString = "https://image.tmdb.org/t/p/w780/qWQSnedj0LCUjWNp9fLcMtfgadp.jpg"
            ImageDownloader.downloadImage(imageUrlString) { image, _ in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell.setBackdropImage(image)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}
