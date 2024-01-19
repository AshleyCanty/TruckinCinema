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
class MovieDetailsVC: BaseViewController, ShowtimeRadioListCellDelegate, MovieSummaryGenreCellProtocol, MovieTrailerCellProtocol, MovieDetailsTrailerTopViewProtocol, YTPlayerViewDelegate, AppNavigationBarDelegate {
    
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
    
    private let loader = RemoteMovieLoader(client: MovieDBClient())
    
    /// movieId string
    private var movieId: String? {
        didSet {
            fetchMovieDetails()
        }
    }
    
    private var movie: Movie? 
    
    private var trailers: MovieTrailers?
    
    /// Screen info for movie viewing
    private var screen: Screen?
    
    /// stores the rsvp order
    lazy var rsvpOrder: MovieReservation? = {
        return MovieReservation()
    }()

    init(movieId: String, screen: Screen) {
        super.init() /// used to place this last, but switched it on 11/19
        self.movieId = movieId
        self.screen = screen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rsvpOrder = MovieReservation()
        trailerHeader.delegate = self
        configure()
        fetchMovieDetails()
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

    private func refreshTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /// Configured tableview datasource and delegate
    fileprivate func configureTableDataSource() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: ShowtimeCell.reuseIdentifier)
        tableView.register(ShowtimeRadioListCell.self, forCellReuseIdentifier: ShowtimeRadioListCell.reuseIdentifier)
        tableView.register(MovieSummaryGenreCell.self, forCellReuseIdentifier: MovieSummaryGenreCell.reuseIdentifier)
        tableView.register(MovieTrailerCell.self, forCellReuseIdentifier: MovieTrailerCell.reuseIdentifier)
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
    
    private func filterForUSRating() {
        
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
    func didSelectRadioButton(isSelected: Bool, date: String?) {
        if isSelected {
            storeRSVPDate(date: date ?? "")
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
    
    /// Delegate method for trailer cells in table view
    func didPressPlayButton(key: String) {
        playTrailer(videoKey: key)
    }
    
    /// Delegate method for trailer in top header
    func didPressPlayButtonForTopTrailer() {
        guard let trailers = trailers, let list = trailers.results, let lastTrailer = list.last else { return }
        playTrailer(videoKey: lastTrailer.key)
    }
    
    private func playTrailer(videoKey: String? = ""){
        guard let key = videoKey else { return }
        let trailerPlayerVC = TrailerPlayerVC()
        trailerPlayerVC.setVideKey(key: key)
        trailerPlayerVC.modalTransitionStyle = .coverVertical
        trailerPlayerVC.modalPresentationStyle = .fullScreen
        present(trailerPlayerVC, animated: true)
        
        trailerPlayerVC.ytPlayer.videoUrl()
    }
    
    /// Present the popoever sheet for the trailer to be shared
    func didPressTrailerShareButton(key: String) {
        do {
            let url = try loader.getTrailerUrl(withKey: key)
            let text = "Hey, you should check out this movie!"
            let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
            self.present(vc, animated: true)
        } catch {
            NSLog("Unable to process request: invalid url")
        }
    }
    
    @objc private func didPressRSVPButton() {
        /// Store movie details in rsvpOrder object
        storeRSVPMovieDetails()
        
        let alertVC = UIAlertController(title: "Which location would you like to choose?", message: nil, preferredStyle: .actionSheet)
        DriveInLocations.names.forEach { location in
            let action = UIAlertAction(title: location, style: .default) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.rsvpOrder?.location = location
                /// pass rsvpOrder to next view controller
                let ticketSelectionVC = TicketSelectionVC(rsvpOrder: sSelf.rsvpOrder)
                AppNavigation.shared.pushViewController(ticketSelectionVC, animated: true)
            }
            alertVC.addAction(action)
        }
        present(alertVC, animated: true)
    }
    
    /// Stores movie details in rsvp pbject
    private func storeRSVPMovieDetails() {
        guard let unwrappedMovie = movie, let title = unwrappedMovie.title, let duration = unwrappedMovie.runtime, let rating = titleDetailView.ratingLabel.text else { return }
        let movieDetails = ReservedMovieDetails(movieTitle: title,
                                                duration: duration.convertToRuntimeString(),
                                                rating: rating,
                                                screen: screen)
        
        rsvpOrder?.reservedMovieDetails = movieDetails
    }
    
    private func storeRSVPDate(date: String) {
        rsvpOrder?.date = date
    }
    
    // MARK :- API Methods
    
    /// Calls on client to fetch movie details
    private func fetchMovieDetails() {
        Task {
            do {
                try await fetchMovie()
                try await fetchRatingAndReleaseDates()
                try await fetchTrailers()
            } catch (let error) {
                print("Invalid movie Id: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMovie() async throws {
        guard let id = movieId else { throw APIError.invalidData }
        loader.load(forRequestType: .singleMovie(usingMovieId: id), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let results):
                movie = results as? Movie
                DispatchQueue.main.async { [weak self] in
                    self?.titleDetailView.movie = self?.movie
                }
                
                Task {
                    await self.fetchTrailerHeaderBackDropImage()
                }
            case .failure(_):
                print()
            }
        })
    }
    
    private func fetchTrailers() async throws {
        guard let id = movieId else { throw APIError.invalidData }
        loader.load(forRequestType: .movieTrailers(usingMovieId: id), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let results):
                trailers = results as? MovieTrailers
                refreshTable()
            case .failure(_):
                print()
            }
        })
    }
    
    /// Loads backdrop image for trailer header
    @objc fileprivate func fetchTrailerHeaderBackDropImage() async {
        do {
            guard let backdropPath = movie?.backdropPath else {
                setDefaultImageForTrailerBackdrop(errorMessage: "invalid backdrop path")
                return
            }
            
            let url = try loader.getPosterUrl(with: backdropPath)
            try await trailerHeader.backdropImageView.downloadImage(from: url)
            
            DispatchQueue.main.async { [weak self] in
                self?.trailerHeader.hidePlayButton(shouldHide: false)
            }
        } catch (let error) {
            setDefaultImageForTrailerBackdrop(errorMessage: error.localizedDescription)
        }
    }
    
    private func setDefaultImageForTrailerBackdrop(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.trailerHeader.backdropImageView.image = UIImage(named: "placeholder-backdrop")
            self?.trailerHeader.hidePlayButton(shouldHide: true)
        }
        print("Failed to retrieve image: \(errorMessage)")
    }
    
    private func fetchRatingAndReleaseDates() async throws {
        guard let id = movieId else { throw APIError.invalidData }
        loader.load(forRequestType: .movieRatingAndReleaseDates(usingMovieId: id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let results):
                let ratings = results as? MovieReleaseDates
                let filteredRatings = ratings?.filterForUSRating()
                
                DispatchQueue.main.async { [weak self] in
                    self?.titleDetailView.ratingLabel.text = filteredRatings
                }
            case .failure(_):
                print()
            }
        }
    }
}

// MARK: -- Custom table methods

extension MovieDetailsVC {
    
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
        var cell = UITableViewCell()

        if indexPath.row == 0 {
            if let showtimeCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeCell.reuseIdentifier, for: indexPath) as? ShowtimeCell {
                showtimeCell.setup(title: ShowtimeTitle.Placement.getString(), subtitle: getMoviePlacementString())
                cell = showtimeCell
            }
        } else if indexPath.row == 1 {
            if let showtimeCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeCell.reuseIdentifier, for: indexPath) as? ShowtimeCell {
                showtimeCell.setup(title: ShowtimeTitle.Showtime.getString(), subtitle: getMovieShowtimeString())
                cell = showtimeCell
            }
        } else {
            if let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: ShowtimeRadioListCell.reuseIdentifier, for: indexPath) as? ShowtimeRadioListCell {
                unwrappedCell.cellDelegate = self
                cell = unwrappedCell
            }
        }
        return cell
    }
    
    /// Returns string for movie screen placement
    func getMoviePlacementString() -> String {
        guard let unwrappedScreen = screen, let screenId = MovieScreenId(rawValue: unwrappedScreen.id), let viewingOrder = MovieViewingOrder(rawValue: unwrappedScreen.viewingOrder) else { return "" }
        return "\(screenId.getStringVal()) Movie on Screen \(viewingOrder.getStringVal())"
    }
    
    /// Returns string for movie showtime
    func getMovieShowtimeString() -> String {
        guard let unwrappedScreen = screen, let movieScreenId = MovieShowtime(rawValue: unwrappedScreen.showtime) else { return "" }
        return movieScreenId.getStringVal()
    }
    
    func getReducedGenreList() -> [Genre] {
        guard let genres = movie?.genres?.prefix(3) else { return [] }
        return Array(genres)
    }
    
    /// Return summary cell
    private func getSummaryCell(indexPath: IndexPath) -> MovieSummaryGenreCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSummaryGenreCell.reuseIdentifier, for: indexPath) as? MovieSummaryGenreCell else {  return MovieSummaryGenreCell() }
        cell.summaryTextView.text = movie?.overview
        cell.genres = getReducedGenreList()
        cell.cellDelegate = self
        return cell
    }
    
    /// Return movie trailer cell
    private func getTrailerCell(indexPath: IndexPath) -> MovieTrailerCell {
        guard let trailers = trailers?.results, let cell = tableView.dequeueReusableCell(withIdentifier: MovieTrailerCell.reuseIdentifier, for: indexPath) as? MovieTrailerCell else { return MovieTrailerCell() }
        cell.cellDelegate = self
        Task {
            do {
                guard let key = trailers[indexPath.row].key else { throw APIError.invalidData }
                cell.setVideoKey(key: key)
                
                let thumbnailUrl = try loader.getTrailerThumbnailUrl(withKey: key)
                try await cell.backdropImageView.downloadImage(from: thumbnailUrl)
            } catch {
                print("Failed to fetch thumbnail: \(error.localizedDescription)")
                cell.backdropImageView.image = UIImage(named: "placeholder-backdrop")
            }
        }
        cell.trailerTitleLabel.text = trailers[indexPath.row].name
        cell.durationlabel.text = generateRandomDuration()
        cell.trailerDateLabel.text = ChangeDatePublishedFormat(datePublishedString: trailers[indexPath.row].publishedAt ?? "")
        return cell
    }
    
    // MARK: -- Movie Trailer Cell Methods
    
    /// Returns year string
    private func getYearsDisplayString(years: Int) -> String {
        return years > 1 ? "\(years) years" : "\(years) year"
    }
    
    /// Returns month string
    private func getMonthDisplayString(months: Int) -> String {
        return months > 1 ? "\(months) months ago" : "\(months) month ago"
    }
    
    /// Returns day string
    private func getDayDisplayString(days: Int) -> String {
        return days > 1 ? "\(days) days ago" : "\(days) day ago"
    }
    
    /// Returns formatted date published string
    private func ChangeDatePublishedFormat(datePublishedString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let datePublished = dateFormatter.date(from: datePublishedString) ?? Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"

        var gregorianCalender = Calendar(identifier: .gregorian)
        gregorianCalender.locale = Locale.autoupdatingCurrent
        
        let timeBetweenDates = gregorianCalender.dateComponents(
            [.year, .month, .day], from: datePublished, to: Date())
        let days = timeBetweenDates.day ?? 0
        let months = timeBetweenDates.month ?? 0
        let years = timeBetweenDates.year ?? 0
        
        if years == 0 && months == 0 {
            return getDayDisplayString(days: days)
        } else if years > 0 {
            return getYearsDisplayString(years: years).appending(" ").appending(getMonthDisplayString(months: months))
        } else {
            return getMonthDisplayString(months: months)
        }
    }
    
    /// Creates and returns randomly generated duration for a trailer
    private func generateRandomDuration() -> String {
        let minutes = Int.random(in: 1...3)
        let seconds = Int.random(in: 10...59)
        return String(format: "%02i:%02i", arguments: [minutes, seconds])
    }
}


// MARK: -- TableView Delegate & Data Source Methods

extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSegmentIndex = SegmentedControlIndex(rawValue: segmentedControl.selectedSegmentIndex)
        switch selectedSegmentIndex {
        case .zero:
            return 3
        case .one:
            return 1
        case .two:
            return trailers?.results?.count ?? 0
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
                cell = getSummaryCell(indexPath: indexPath)
        case .two:
            cell = getTrailerCell(indexPath: indexPath)
        case .none:
            print() // Do nothing
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
}
