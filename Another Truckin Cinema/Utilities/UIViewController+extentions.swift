//
//  UIViewController+extentions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/27/23.
//


import UIKit

fileprivate var activityView: UIView?

extension UIViewController {
    
    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.tintColor = AppColors.RegularTeal
        guard let aView = activityView else { return }
        
        ai.center = aView.center
        ai.startAnimating()
        aView.addSubview(ai)
        self.view.addSubview(aView)
        
        // times out
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { _ in
            activityView?.removeFromSuperview()
            activityView = nil
        }
    }
    
    func hideSpinner() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    /// custom method that adds the childVC
    func addChild(childVC: UIViewController) {
        view.addSubview(childVC.view)
        addChild(childVC)
        childVC.didMove(toParent: self)
    }
    
    /// custom method that removes the childVC
    func removeAsChildVC() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    
}
