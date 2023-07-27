//
//  HomescreenVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit

/// HomescreenVC class
class HomescreenVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {    
    
    /// Style struct
    fileprivate struct Style {
        static let BannerHeight: CGFloat = 100
        static let BannerTopAnchorConstant: CGFloat = 0
        static let BannerLeadingTrailingMargin: CGFloat = 12
        static let BannerCornerRadius: CGFloat = 15
        static let LeadingTrailingMargin: CGFloat = 12
        static let MenuButtonSize: CGFloat = 24
        static let NavigationTitleLeftRightMargin: CGFloat = 32
        static let NavigationTitleFontSize: CGFloat = 25
        static let NavigationTitleTextColor: UIColor = UIColor.white
        static let RightButtonTintColor: UIColor = AppColors.RegularGray
        static let CurrentPageIndicatorTintColor: UIColor = AppColors.CurrentPageIndicatorTintColor
        static let PageIndicatorTintColor: UIColor = AppColors.PageIndicatorTintColor
        static let TimerInterval: TimeInterval = 5.5
        static let DataLabelTopMargin: CGFloat = 12
        static let MovieCollectionViewMinSpacing: CGFloat = 5
        static let MovieCollectionViewTopMargin: CGFloat = 12
    }
    /// Stack view that holds dataLabesl
    fileprivate lazy var dateStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        return sv
    }()
    
    /// Date Labels . Refactor - Use real dates
    fileprivate lazy var dateViews: [DateView] = {
        let dates: [String] = ["Fri Jun 9, 2023", "Sat Jun 10, 2023", "Sun Jun 11, 2023"]
        var views: [DateView] = []
        dates.forEach { views.append(DateView(date: $0)) }
        return views
    }()
    
    /// Banner item data
    fileprivate lazy var bannerItems: [BannerItem] = [
        BannerItem(bannerImage: .SignUp, icon: .SignUp, description: .SignUp),
        BannerItem(bannerImage: .One, icon: .One, description: .One),
        BannerItem(bannerImage: .Two, icon: .Two, description: .Two),
        BannerItem(bannerImage: .Three, icon: .Three, description: .Three)
    ]
    
    /// Cycled banner collection view4
    fileprivate lazy var cycledBanner: CycledBanner = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width - Style.BannerLeadingTrailingMargin * 2, height: Style.BannerHeight)
        let collectionView = CycledBanner(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = Style.BannerCornerRadius
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    /// Banner's wrapper view for displaying the drop shadow
    fileprivate lazy var bannerWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addShadow(color: .black, opacity: 0.25, radius: 6, offset: CGSize(width: 1, height: 3))
        return view
    }()
    
    /// Page control
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = bannerItems.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = Style.PageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = Style.CurrentPageIndicatorTintColor
        return pageControl
    }()
    
    /// True if sign-up banner should be hidden. Determined by parent ViewController
    fileprivate lazy var hideSignupBanner: Bool = false {
        didSet {
            if hideSignupBanner { bannerItems.removeFirst() }
            cycledBanner.reloadData()
            startBannerAnimation()
        }
    }
    
    /// Movie collection view
    fileprivate lazy var movieCollection: MovieCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Style.MovieCollectionViewMinSpacing
        layout.minimumInteritemSpacing = Style.MovieCollectionViewMinSpacing
        let itemWidth = (view.bounds.width - ((AppTheme.LeadingTrailingMargin*2) + Style.MovieCollectionViewMinSpacing)) / 2
        let itemHeight = itemWidth * 1.5
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collection = MovieCollection(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = AppColors.BackgroundMain
        return collection
    }()
    
    
    /// Tracks banner's current item index
    fileprivate var bannerItemIndex: Int = 0
    
    /// Timer used for auto scrolling the banner
    fileprivate var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: UIControl.Event.valueChanged)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSource(sourceTitle: TabBarItemTitle.Home.getString())
        super.viewWillAppear(animated)
    }

    // MARK: -- Private methods

    /// Calls methods to setup views
    fileprivate func setupViews() {
        setupCollectionViewDataSources()
        
        /// In order of layout
        addBannerConstraints()
        addDateLabels()
        addMovieCollectionConstraints()
    }

    /// Sets up date label views
    fileprivate func addDateLabels() {
        dateViews.forEach{ dateStackView.addArrangedSubview($0) }
        view.addSubview(dateStackView)
        
        dateStackView.disableTranslatesAutoresizingMaskIntoContraints()
        dateStackView.topAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor, constant: Style.DataLabelTopMargin)
        dateStackView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: Style.LeadingTrailingMargin)
        dateStackView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -Style.LeadingTrailingMargin)
    }
    
    /// Sets up data source for both the banner and movie collection views
    fileprivate func setupCollectionViewDataSources() {
        /// Cycled banner
        cycledBanner.delegate = self
        cycledBanner.dataSource = self
        cycledBanner.register(CycledBannerSignUpCell.self, forCellWithReuseIdentifier: CycledBannerSignUpCell.reuseIdentifier)
        cycledBanner.register(CycledBannerCell.self, forCellWithReuseIdentifier: CycledBannerCell.reuseIdentifier)
        
        /// Movie Collection view
        movieCollection.delegate = self
        movieCollection.dataSource = self
        movieCollection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    }

    /// Sets up banner constraints
    fileprivate func addBannerConstraints() {
        cycledBanner.isPagingEnabled = true
        cycledBanner.showsHorizontalScrollIndicator = false
        cycledBanner.backgroundColor = AppColors.BannerCollectionBGColor

        bannerWrapper.addSubviews(subviews: [cycledBanner, pageControl])
        view.addSubview(bannerWrapper)
        
        /// banner shadow wrapper view constraints
        bannerWrapper.disableTranslatesAutoresizingMaskIntoContraints()
        bannerWrapper.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Style.BannerTopAnchorConstant)
        bannerWrapper.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: Style.BannerLeadingTrailingMargin)
        bannerWrapper.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -Style.BannerLeadingTrailingMargin)
        bannerWrapper.heightAnchor.tc_constrain(equalToConstant: Style.BannerHeight)
        
        /// banner collection view constraints
        cycledBanner.disableTranslatesAutoresizingMaskIntoContraints()
        cycledBanner.tc_constrainToSuperview()
        
        /// Add page control constraints
        pageControl.disableTranslatesAutoresizingMaskIntoContraints()
        pageControl.bottomAnchor.tc_constrain(equalTo: bannerWrapper.bottomAnchor)
        pageControl.centerXAnchor.tc_constrain(equalTo: bannerWrapper.centerXAnchor)
        
        /// begin auto scroll animation
        startBannerAnimation()
    }
    
    /// Add movie collection constraints
    fileprivate func addMovieCollectionConstraints() {
        view.addSubview(movieCollection)
        movieCollection.disableTranslatesAutoresizingMaskIntoContraints()
        movieCollection.topAnchor.tc_constrain(equalTo: dateStackView.bottomAnchor, constant: Style.MovieCollectionViewTopMargin)
        movieCollection.bottomAnchor.tc_constrain(equalTo: view.bottomAnchor, constant: -Style.MovieCollectionViewTopMargin)
        movieCollection.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        movieCollection.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
    }
}


// MARK: -- UICollectionViewDataSource & Delegate methods
extension HomescreenVC {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailsVC(movieId: 385687)
        AppNavigation.shared.navigateTo(movieDetailVC)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cycledBanner {
            return bannerItems.count
        }
        return MovieCellData.movieCollectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if collectionView == self.cycledBanner {
            if indexPath.item == 0 && !hideSignupBanner {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycledBannerSignUpCell.reuseIdentifier, for: indexPath) as! CycledBannerSignUpCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycledBannerCell.reuseIdentifier, for: indexPath) as! CycledBannerCell
                let gradientWidth = view.bounds.width - Style.BannerLeadingTrailingMargin*2
                cell.setup(item: bannerItems[indexPath.item], gradientSize: CGSize(width: gradientWidth, height: Style.BannerHeight))
                return cell
            }
        } else if collectionView == movieCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
            cell.item = MovieCellData.movieCollectionItems[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// Used for Banner animation
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

// MARK: -- Banner animation methods
extension HomescreenVC {
    
    /// Changes banner offset based on pageControl
    @objc fileprivate func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * bannerWrapper.frame.size.width
        cycledBanner.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    /// Sets timer for auto scroll animation
    @objc public func startBannerAnimation() {
        self.timer = Timer.scheduledTimer(withTimeInterval: Style.TimerInterval, repeats: true, block: { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.showNextBannerItem()
        })
    }
    /// Performs auto scroll animation
    fileprivate func showNextBannerItem() {
        guard bannerItems.count > 0 else { return }
    
        let currentOffsetX = cycledBanner.contentOffset.x
        let lastItemMinX = (bannerWrapper.frame.width * CGFloat(bannerItems.count - 1))

        /// Reset offsetX if reached last item, otherswise keep moving
        if currentOffsetX == lastItemMinX {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5.0) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.cycledBanner.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                sSelf.bannerItemIndex = 0
                sSelf.pageControl.currentPage = 0
            }
        } else {
            bannerItemIndex += 1
            
            /// Only scroll if within bounds
            guard bannerItemIndex < bannerItems.count else { return }
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5.0) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.cycledBanner.scrollToItem(at: IndexPath(item: Int(sSelf.bannerItemIndex), section: 0), at: .right, animated: true)
                    sSelf.pageControl.currentPage = sSelf.bannerItemIndex
            }
        }
    }
}