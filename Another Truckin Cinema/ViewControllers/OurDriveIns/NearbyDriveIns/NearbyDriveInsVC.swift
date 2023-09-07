//
//  NearbyDriveInsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/26/23.
//

import Foundation
import UIKit


class NearbyDriveInsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    struct Style {
        static let DragViewDefaultHeight: CGFloat = 80
        static let DraggableHeight: CGFloat = 20
        static let WrapperCornerRadius: CGFloat = 20
    }
    
    private lazy var tableView = UITableView()
    
    private let draggingBarView = DraggingBarView()
    
    public var dragView = UIView()
    
    public var dragViewHeightAnchor = NSLayoutConstraint()
    
    public let wrapperView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupTableDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard view.layer.shadowPath == nil && wrapperView.frame != .zero else { return }
        view.addShadow(color: AppTheme.ShadowColor, opacity: 0.5, radius: 3, offset: CGSize(width: 0, height: -3))
        view.layer.shadowPath = UIBezierPath(roundedRect: wrapperView.frame, cornerRadius: Style.WrapperCornerRadius)
        .cgPath
    }
    
    private func setupTableDataSource() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearbyDriveInCell.self, forCellReuseIdentifier: NearbyDriveInCell.reuseId)
    }

    private func setup() {
        view.backgroundColor = .clear
        tableView.backgroundColor = AppColors.BackgroundMain
        wrapperView.backgroundColor = AppColors.BackgroundMain
        wrapperView.layer.cornerRadius = Style.WrapperCornerRadius
        wrapperView.layer.masksToBounds = true
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        dragView.addSubview(draggingBarView)
        wrapperView.addSubview(dragView)
        
        wrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        wrapperView.tc_constrainToSuperview()
        
        tableView.disableTranslatesAutoresizingMaskIntoContraints()
        tableView.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor, constant: 20)
        tableView.heightAnchor.tc_constrain(equalToConstant: view.frame.height)
        tableView.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        tableView.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        
        dragView.disableTranslatesAutoresizingMaskIntoContraints()
        dragView.topAnchor.tc_constrain(equalTo: wrapperView.topAnchor)
        dragView.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor)
        dragView.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor)
        dragViewHeightAnchor = dragView.heightAnchor.constraint(equalToConstant: Style.DragViewDefaultHeight) // default with 80 for starters
        dragViewHeightAnchor.isActive = true
        
        draggingBarView.disableTranslatesAutoresizingMaskIntoContraints()
        draggingBarView.heightAnchor.tc_constrain(equalToConstant: DraggingBarView.Height)
        draggingBarView.widthAnchor.tc_constrain(equalToConstant: DraggingBarView.Width)
        draggingBarView.topAnchor.tc_constrain(equalTo: dragView.topAnchor, constant: 8)
        draggingBarView.centerXAnchor.tc_constrain(equalTo: dragView.centerXAnchor)
    }
    
    @objc func didTapFavoriteButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}

// MARK: -- TableView Delegate methods

extension NearbyDriveInsVC {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearbyDriveInCell.reuseId, for: indexPath) as? NearbyDriveInCell
            cell?.bigNumberLabel.text = "\(indexPath.row+1)."
            cell?.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
            
        return cell ?? NearbyDriveInCell()
    }
}

class DraggingBarView: UIView {
    
    static let Width: CGFloat = 60
    static let Height: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.RegularGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}
