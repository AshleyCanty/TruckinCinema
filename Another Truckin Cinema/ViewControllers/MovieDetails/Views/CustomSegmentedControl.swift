//
//  CustomSegmentedControl.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/25/23.
//

import Foundation
import UIKit

class CustomSegmentedControl: UIView {
    
//    private var buttonTitles: [String]!
//    private var buttons: [UIButton]
//    private var selectorView: UIView!
//
//    var textColor: UIColor = .black
//    var selectorViewColor: UIColor = .systemPink
//    var selectorTextColor: UIColor = .systemPink
//
//    private func configureStackView() {
//        let stack = UIStackView(arrangedSubviews: buttons)
//        stack.axis = .horizontal
//        stack.alignment = .fill
//        stack.distribution = .fillEqually
//        addSubview(stack)
//        stack.disableTranslatesAutoresizingMaskIntoContraints()
//        stack.tc_constrainToSuperview()
//
//    }
//
//    private func configureSelectorView() {
//        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
//
//        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
//        selectorView.backgroundColor = selectorViewColor
//        addSubview(selectorView)
//    }
}





extension UISegmentedControl {
    func addBorderForSelectedSegment() {
        let borderWidth = frame.width / CGFloat(numberOfSegments)
        let borderHeight = CGFloat(2)
        let borderPositionX = borderWidth * CGFloat(selectedSegmentIndex)
        let borderpositionY = bounds.maxY - 1
        
        let borderView = UIView(frame: CGRect(x: borderPositionX, y: borderpositionY, width: borderWidth, height: borderHeight))
        borderView.backgroundColor = .yellow
        addSubview(borderView)
    }
    
    func updateBorder() {
        setDividerImage(AppColors.BackgroundMain.image(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: UIBarMetrics.default)
    }
}
