//
//  DriveInLocationsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/6/23.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation

/// DriveInLocationsVC class
class DriveInLocationsVC: BaseViewController, AppNavigationBarDelegate, UIGestureRecognizerDelegate, ChangeLocationDelegate {
    
    /// Style struct
    struct Style {
        static let RSVPButtonHeight: CGFloat = 50
        static let SegmentedControlBackgroundColor: UIColor = AppColors.BackgroundMain
        static let SegmentedControlTopMargin: CGFloat = 0
        static let DimmingViewAlpha: CGFloat = 0.2
        static let DraggingBoundary: CGFloat = 30.0
        static let NearbyVCDimmingViewHeight: CGFloat = 50.0
    }

    var nearbyDriveInsChildVCTopAnchor = NSLayoutConstraint()
    
    let nearbyDriveInsChildVC = NearbyDriveInsVC()
    
    let favoriteDriveInsChildVC = FavoriteDriveInsVC()
    
    let manager = CLLocationManager()
    
    /// enum  for Segmented Control Titles
    enum SegmentedControlTitle: String, CaseIterable {
        case NearbyDriveins = "DRIVE-INS NEAR YOU"
        case FavoriteDriveIns = "MY FAVORITE DRIVE-INS"
        func getString() -> String { return self.rawValue }
    }
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .Plain)
    
    ///  segmented control
    fileprivate lazy var segmentedControl: CustomSegmentedControl = {
        let sc = CustomSegmentedControl(items: [SegmentedControlTitle.NearbyDriveins.getString(),
                                            SegmentedControlTitle.FavoriteDriveIns.getString()])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let cityStateLabel: CurrentLocationLabel = {
        let label = CurrentLocationLabel()
        label.text = "Philadelphia, PA"
        return label
    }()

    let changeLocationButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Change Location", for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 12)
        btn.setTitleColor(AppColors.RegularTeal, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    
    lazy var locationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        return view
    }()
    
    let dimmingView = UIView()
    
    lazy var nearbyVCDimmingView = UIView()
    
    private var dragViewEndPoint: CGFloat {
       return locationView.frame.maxY + 45
    }
    
    private let nearbyDriveInsVCInitialPointY: CGFloat = -180
    
    private var offset: CGPoint = .zero
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    
    /// true if dragging view should be tall enough to cover nearbyVC at bottom of screen for tap gesture
    private var dragViewShouldBeTappableHeight: Bool = true {
        didSet {
            guard dragViewShouldBeTappableHeight != oldValue else { return }
            updateDragViewHeight()
        }
    }
    
    lazy var nearbyVCPanGestureStoppingPointY: CGFloat = {
        /// Use heights of other subviews to determine where nearbyVC should stop being dragged
        var subviewsTotalHeight = (appNavBar.frame.height + segmentedControl.frame.height + locationView.frame.height + 45)
        if let navController = navigationController, let statusBarHeight = navController.getStatusBarHeight() {
            subviewsTotalHeight += statusBarHeight
        }
        return -(view.frame.height - subviewsTotalHeight)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapAndLocation()
        setupUI()
        segmentedControl.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setStatusBar(backgroundColor: .clear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setStatusBar(backgroundColor: .clear)
    }
    
    private func setupMapAndLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
        
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0
        dimmingView.frame = view.frame
        view.addSubview(dimmingView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Syndey"
        marker.snippet = "Australia"
        marker.map = mapView
        // TODO - must display in app
//        print("License: \n\n \(GMSServices.openSourceLicenseInfo())")
    }
    
    private func removeChildVC() {
        nearbyDriveInsChildVC.removeAsChildVC()
    }
    
    private func setupUI() {
        addCustomNavBar()
    
        view.addSubview(segmentedControl)
        segmentedControl.disableTranslatesAutoresizingMaskIntoContraints()
        segmentedControl.heightAnchor.tc_constrain(equalToConstant: 45)
        segmentedControl.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: Style.SegmentedControlTopMargin)
        segmentedControl.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        segmentedControl.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        
        view.addSubview(locationView)
        locationView.disableTranslatesAutoresizingMaskIntoContraints()
        locationView.topAnchor.tc_constrain(equalTo: segmentedControl.bottomAnchor)
        locationView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        locationView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        locationView.heightAnchor.tc_constrain(equalToConstant: 45)
        
        locationView.addSubviews(subviews: [cityStateLabel, changeLocationButton])
        
        cityStateLabel.disableTranslatesAutoresizingMaskIntoContraints()
        cityStateLabel.leadingAnchor.tc_constrain(equalTo: locationView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        cityStateLabel.centerYAnchor.tc_constrain(equalTo: locationView.centerYAnchor)
        
        changeLocationButton.disableTranslatesAutoresizingMaskIntoContraints()
        changeLocationButton.trailingAnchor.tc_constrain(equalTo: locationView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        changeLocationButton.centerYAnchor.tc_constrain(equalTo: locationView.centerYAnchor)
        
        changeLocationButton.addTarget(self, action: #selector(didTapChangeLocationButton), for: .touchUpInside)
        
        addChild(childVC: nearbyDriveInsChildVC)
        nearbyDriveInsChildVC.view.disableTranslatesAutoresizingMaskIntoContraints()
        nearbyDriveInsChildVC.view.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        nearbyDriveInsChildVC.view.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        nearbyDriveInsChildVC.view.heightAnchor.tc_constrain(equalTo: view.heightAnchor)
        nearbyDriveInsChildVCTopAnchor = nearbyDriveInsChildVC.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: nearbyDriveInsVCInitialPointY)
        nearbyDriveInsChildVCTopAnchor.isActive = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: Style.NearbyVCDimmingViewHeight)
        gradient.setVerticalGradient(withColors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], startPoint: .zero, endPoint: CGPoint(x: 0.0, y: 1))
        nearbyVCDimmingView.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(nearbyVCDimmingView)
        nearbyVCDimmingView.isUserInteractionEnabled = false
        nearbyVCDimmingView.disableTranslatesAutoresizingMaskIntoContraints()
        nearbyVCDimmingView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        nearbyVCDimmingView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        nearbyVCDimmingView.heightAnchor.tc_constrain(equalToConstant: Style.NearbyVCDimmingViewHeight)
        nearbyVCDimmingView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        updateDragViewHeight()
        nearbyDriveInsChildVC.dragView.addGestureRecognizer(panGesture)
        nearbyDriveInsChildVC.dragView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        panGesture.delegate = self
    
        view.bringSubviewToFront(nearbyVCDimmingView)
    }
    
    /// Calculates height for the dragView inside of the nearbyDriveInVC child
    func getDragViewUpdatedHeight() -> CGFloat {
        if dragViewShouldBeTappableHeight {
            guard let tabBar = tabBarController?.tabBar else { return NearbyDriveInsVC.Style.DragViewDefaultHeight }
            let positiveVal = abs(nearbyDriveInsVCInitialPointY)
            let dragViewNewHeight = positiveVal - tabBar.frame.height
            return dragViewNewHeight
        }

        return NearbyDriveInsVC.Style.DraggableHeight
    }
    
    /// sets new height for the dragView inside of the nearbyDriveInVC child
    func updateDragViewHeight() {
        let newHeight = getDragViewUpdatedHeight()
        guard nearbyDriveInsChildVC.dragViewHeightAnchor.constant != newHeight else { return }
        nearbyDriveInsChildVC.dragViewHeightAnchor.constant = newHeight
        view.layoutIfNeeded()
    }
    
    @objc func selectedSegment() {
        // TODO - Create a sidemenu with a gradient background and corner radius
        if segmentedControl.selectedSegmentIndex == 0 {
            favoriteDriveInsChildVC.removeAsChildVC()
        } else {
            addChild(childVC: favoriteDriveInsChildVC)
            favoriteDriveInsChildVC.view.disableTranslatesAutoresizingMaskIntoContraints()
            favoriteDriveInsChildVC.view.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
            favoriteDriveInsChildVC.view.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
            favoriteDriveInsChildVC.view.topAnchor.tc_constrain(equalTo: segmentedControl.bottomAnchor)
            favoriteDriveInsChildVC.view.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            view.bringSubviewToFront(favoriteDriveInsChildVC.view)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGesture  && otherGestureRecognizer == panGesture && dragViewShouldBeTappableHeight {
            return true /// handle tap if nearbyVC child is at bottom of screen
        }
        return false
    }
    
    /// Animates the nearbyVC child up to by fully displayed
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard nearbyDriveInsChildVCTopAnchor.constant == nearbyDriveInsVCInitialPointY else { return }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: [.curveEaseOut]) {[weak self] in
            guard let sSelf = self else { return }
            sSelf.nearbyDriveInsChildVCTopAnchor.constant = sSelf.nearbyVCPanGestureStoppingPointY
            sSelf.nearbyVCDimmingView.alpha =  0
            sSelf.dragViewShouldBeTappableHeight = false
            sSelf.dimmingView.alpha = Style.DimmingViewAlpha
            sSelf.view.layoutIfNeeded()
        }
    }
    
    /// Handles pan gestures and end gesture events
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let distanceDivisor = 2.8
        let translation = gesture.translation(in: self.view)
        let offsetAndTranslationY = (offset.y + translation.y)
        
        let startPoint = view.frame.height - (abs(nearbyDriveInsVCInitialPointY))
        let currentPosition = nearbyDriveInsChildVC.view.frame.minY
        let endPoint = dragViewEndPoint
        let totalDistance = startPoint - endPoint
        
        switch gesture.state {
        case .began:
            offset = CGPoint(x: 0, y: nearbyDriveInsChildVCTopAnchor.constant)
            break
        case .changed:
            if offsetAndTranslationY <= nearbyVCPanGestureStoppingPointY || offsetAndTranslationY > nearbyDriveInsVCInitialPointY {
                return
            } else {
                
                /// 1. While nearbyVC is at bottom of screen, the user should be able to tap nearbyVC anywhere and it animates up to its endPoint
                /// 2. When user drags nearbyVC up and its less than about 1/3 of totalDistance, it should animate back down to its initial y-coordinate
                /// 3. If user drags nearbyVC up to 1/3 or above the totalDistance, it should animate up to the endPoint.
                /// 4. User should be able to initiate a drag from touching anywhere while nearbyVC is at bottom of screeen
                /// 5. From the endPoint, the user should only be able to drag the nearbyVC view from along the very top
                /// Invisible dragView's height initially covers visible portion of nearbyVC at bottom of screen
                /// Once nearbyVC is moved up, the dragView's height becomes 20.0pts
                
                /// increase dimmingVIew's alpha as the nearbyVC is being dragged up
                /// decrease alpha when being dragged down
                let distanceTraveled = startPoint - currentPosition
                let percentageTraveled = distanceTraveled / totalDistance
                
                dimmingView.alpha = percentageTraveled * Style.DimmingViewAlpha
                nearbyDriveInsChildVCTopAnchor.constant = offsetAndTranslationY
                
                /// show / hide another dimming view when nearbyVC is at initial y-coordinate
                if currentPosition  >= (startPoint - Style.DraggingBoundary) {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let sSelf = self, sSelf.nearbyVCDimmingView.alpha != 1 else { return }
                        sSelf.nearbyVCDimmingView.alpha =  1
                        sSelf.dragViewShouldBeTappableHeight = true
                    }
                } else {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let sSelf = self, sSelf.nearbyVCDimmingView.alpha != 0 else { return }
                        sSelf.nearbyVCDimmingView.alpha =  0
                        sSelf.dragViewShouldBeTappableHeight = false
                    }
                }
            }
            view.layoutIfNeeded()
        case .ended:
            let oneThirdOfTotalDistance = totalDistance / distanceDivisor
            let autoPanTriggerPoint = nearbyDriveInsVCInitialPointY - oneThirdOfTotalDistance
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: [.curveEaseOut]) {[weak self] in
                guard let sSelf = self else { return }
                if sSelf.nearbyDriveInsChildVCTopAnchor.constant > autoPanTriggerPoint {
                    /// animate view back down to tappable state
                    sSelf.nearbyDriveInsChildVCTopAnchor.constant = sSelf.nearbyDriveInsVCInitialPointY
                    sSelf.nearbyVCDimmingView.alpha =  1
                    sSelf.dimmingView.alpha = 0
                    sSelf.dragViewShouldBeTappableHeight = true
                } else {
                    /// animate up to draggable state
                    sSelf.nearbyDriveInsChildVCTopAnchor.constant = sSelf.nearbyVCPanGestureStoppingPointY
                    sSelf.nearbyVCDimmingView.alpha =  0
                    sSelf.dimmingView.alpha = Style.DimmingViewAlpha
                    sSelf.dragViewShouldBeTappableHeight = false
                }
                sSelf.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    /// Triggers the ChangeLocationVC to be displayed
    @objc func didTapChangeLocationButton() {
        let modalVC = ChangeLocationVC()
        modalVC.delegate = self
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.modalPresentationStyle = .fullScreen
        present(modalVC, animated: true)
    }
    
    /// Dismisses the ChangeLocationVC and updates map to current location. 
    @objc func UseCurrentLocation() {
        dismiss(animated: true)
        cityStateLabel.text = "Lansdale, PA"
        // reset the google map
    }
    
    func didSelectUpdatedLocation(location: String) {
        dismiss(animated: true)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
                sSelf.cityStateLabel.text = location
        }
        // reset the google map
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        // show side menu
    }
    
    func addCustomNavBar() {
        appNavBar.configureNavBar(withTitle: NavigationTitle.OurDriveIns.getString())
        
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        navigationController?.setStatusBar()
        if let statusBarView = navigationController?.view.subviews.first(where: { type(of: $0) == StatusBarUIView.self }) {
            appNavBar.topAnchor.tc_constrain(equalTo: view.topAnchor, constant: statusBarView.frame.height)
        } else {
            appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        }
    }
}


