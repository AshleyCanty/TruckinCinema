//
//  TrailerPlayerVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/4/23.
//

import Foundation
import UIKit
import youtube_ios_player_helper

/// TrailerPlayerVC
class TrailerPlayerVC: UIViewController, YTPlayerViewDelegate {
    
    public var videoKey: String?
    
    lazy var ytPlayer = YTPlayerView()
    
    lazy var closeButton = UIButton(type: .close)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playVideo()
    }
    
    func configure() {
        view.backgroundColor = .black
        
        ytPlayer.delegate = self
        view.addSubview(ytPlayer)
        
        ytPlayer.disableTranslatesAutoresizingMaskIntoContraints()
        ytPlayer.centerYAnchor.tc_constrain(equalTo: view.centerYAnchor)
        ytPlayer.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        ytPlayer.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        ytPlayer.heightAnchor.tc_constrain(equalTo: view.widthAnchor, multiplier: 9.0/16.0)
        
        
        view.addSubview(closeButton)
        closeButton.disableTranslatesAutoresizingMaskIntoContraints()
        closeButton.widthAnchor.tc_constrain(equalToConstant: 30)
        closeButton.heightAnchor.tc_constrain(equalToConstant: 30)
        closeButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -15)
        closeButton.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    func playVideo() {
        guard let key = videoKey else { return }
        ytPlayer.load(withVideoId: key)
    }
    
    func setVideKey(key: String) {
        self.videoKey = key
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
