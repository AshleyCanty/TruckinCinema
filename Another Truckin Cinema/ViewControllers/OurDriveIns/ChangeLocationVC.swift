//
//  ChangeLocationVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/29/23.
//

import Foundation
import UIKit


struct DriveInLocations {
    static let names = ["ATC NewPark 12", "ATC Classic Kennewick 12","ATC New Lenox 14"]
}

protocol ChangeLocationDelegate: AnyObject {
    func didSelectUpdatedLocation(location: String)
}

class ChangeLocationVC: BaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let SubtitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let BackButtonHeight: CGFloat = 23
        static let BackButtonWidth: CGFloat = 16.33
        static let ClearButtonHeight: CGFloat = 20
        static let ClearButtonWidth: CGFloat = 40
        static let NoResultsFont: UIFont = AppFont.regular(size: 9)
    }

    public lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.imageView?.tintColor = AppColors.TextColorPrimary
        btn.addTarget(self, action: #selector(didPressBackButton), for: .touchUpInside)
        return btn
    }()
    
    public lazy var clearButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(AppColors.RegularTeal, for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 12)
        btn.addTarget(self, action: #selector(didPressClearButton), for: .touchUpInside)
        return btn
    }()
    
    public lazy var searchField: RoundedTextField = {
        let sb = RoundedTextField(placeholder: "Search by drive-in, city, or zip")
        sb.delegate = self
        sb.returnKeyType = .search
        return sb
    }()
    
    private lazy var labelStack: UIStackView = {
        let topErrorLabel = UILabel()
        topErrorLabel.text = "Sorry, no results found."
        topErrorLabel.font = Style.NoResultsFont
        topErrorLabel.textColor = AppColors.TextColorPrimary
        topErrorLabel.textAlignment = .center
        
        let bottomErrorLabel = UILabel()
        bottomErrorLabel.text = "Try searching again or using your location:"
        bottomErrorLabel.font = Style.NoResultsFont
        bottomErrorLabel.textColor = AppColors.TextColorPrimary
        bottomErrorLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [topErrorLabel, bottomErrorLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()
    
    var tableView = UITableView()
    
    let currentLocationLabel = CurrentLocationLabel(forType: .ChangeLocation)
    
    var noResultsFoundView = UIView()
    
    var noResultsFoundViewTopAnchor = NSLayoutConstraint()
    
    var noResultsFoundViewHeightAnchor = NSLayoutConstraint()
    
    var isShowingNoResultsView: Bool = false
    
    /// tableview datasource
    var locationDataSource = [String]()
    
    weak var delegate: ChangeLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDataSource()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name(rawValue: AppNotificationNames.HideKeyboard), object: nil)
        
        locationDataSource = DriveInLocations.names
        tableView.reloadData()
    }
    
    private func setupTableViewDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseId)
    }

    private func setupUI() {
        view.addSubview(backButton)
        backButton.disableTranslatesAutoresizingMaskIntoContraints()
        backButton.heightAnchor.tc_constrain(equalToConstant: Style.BackButtonHeight)
        backButton.widthAnchor.tc_constrain(equalToConstant: Style.BackButtonWidth)
        backButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        backButton.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        
        view.addSubview(clearButton)
        clearButton.disableTranslatesAutoresizingMaskIntoContraints()
        clearButton.heightAnchor.tc_constrain(equalToConstant: Style.ClearButtonHeight)
        clearButton.widthAnchor.tc_constrain(equalToConstant: Style.ClearButtonWidth)
        clearButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        clearButton.centerYAnchor.tc_constrain(equalTo: backButton.centerYAnchor)
        
        view.addSubview(searchField)
        searchField.disableTranslatesAutoresizingMaskIntoContraints()
        searchField.heightAnchor.tc_constrain(equalToConstant: RoundedTextField.Style.Height)
        searchField.leadingAnchor.tc_constrain(equalTo: backButton.trailingAnchor, constant: AppTheme.LeadingTrailingMargin*2)
        searchField.trailingAnchor.tc_constrain(equalTo: clearButton.leadingAnchor, constant: -12)
        searchField.centerYAnchor.tc_constrain(equalTo: backButton.centerYAnchor)
        
        
        view.addSubview(tableView)
        tableView.backgroundColor = AppColors.BackgroundMain
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        tableView.topAnchor.tc_constrain(equalTo: searchField.bottomAnchor, constant: 0)
        tableView.bottomAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.isHidden = true
        
        view.addSubview(noResultsFoundView)
        noResultsFoundView.disableTranslatesAutoresizingMaskIntoContraints()
        noResultsFoundView.centerXAnchor.tc_constrain(equalTo: searchField.centerXAnchor)
        noResultsFoundViewTopAnchor = noResultsFoundView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 0)
        noResultsFoundViewTopAnchor.isActive = true
        noResultsFoundViewHeightAnchor = noResultsFoundView.heightAnchor.constraint(equalToConstant: 0)
        noResultsFoundViewHeightAnchor.isActive = true
        
        noResultsFoundView.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.tc_constrainToSuperview()
        
        view.addSubview(currentLocationLabel)
        currentLocationLabel.disableTranslatesAutoresizingMaskIntoContraints()
        currentLocationLabel.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12 + Style.BackButtonWidth + 24)
        currentLocationLabel.topAnchor.tc_constrain(equalTo: noResultsFoundView.bottomAnchor, constant: 25)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentLocationButton))
        tapGesture.delegate = self
        currentLocationLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapCurrentLocationButton() {
        delegate?.didSelectUpdatedLocation(location: "Lansdale, PA")
    }
    
    @objc func updateWithSelectedLocation(location: String) {
        delegate?.didSelectUpdatedLocation(location: location)
    }
    
    @objc func didPressClearButton() {
        searchField.text = ""
        showTable()
//        showNoResultsView()
    }
    
    @objc func showTable() {
        noResultsFoundView.isHidden = !noResultsFoundView.isHidden
        currentLocationLabel.isHidden = !currentLocationLabel.isHidden
        tableView.isHidden = !tableView.isHidden
//        tableView.reloadData()
    }
    
    /// shows noResultsView
    @objc func showNoResultsView() {
        guard !isShowingNoResultsView else {
            hideNoResultsView()
            return
        }
        var newResultsViewUpdatedHeight: CGFloat = labelStack.spacing * CGFloat((labelStack.arrangedSubviews.count - 1))
        labelStack.arrangedSubviews.forEach({ newResultsViewUpdatedHeight += $0.intrinsicContentSize.height })
        noResultsFoundViewHeightAnchor.constant = newResultsViewUpdatedHeight
        noResultsFoundViewTopAnchor.constant = 25
        isShowingNoResultsView = true
        view.layoutIfNeeded()
    }
    
    /// hides noResultsView
    @objc func hideNoResultsView() {
        noResultsFoundViewHeightAnchor.constant = 0
        noResultsFoundViewTopAnchor.constant = 0
        isShowingNoResultsView = false
        view.layoutIfNeeded()
    }
    
    @objc func didPressBackButton() {
        dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let sSelf = self else { return }
            textField.layer.borderColor = RoundedTextField.Style.BorderActiveColor.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let sSelf = self else { return }
            textField.layer.borderColor = RoundedTextField.Style.BorderColor.cgColor
        }
    }
}

// MARK: -- UITableView Delegate Methods

extension ChangeLocationVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectUpdatedLocation(location: locationDataSource[indexPath.item])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseId, for: indexPath) as! LocationCell
        cell.locationLabel.text = locationDataSource[indexPath.row]
        return cell
    }
    
}
