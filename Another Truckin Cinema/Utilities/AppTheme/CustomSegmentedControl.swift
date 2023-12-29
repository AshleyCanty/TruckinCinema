//
//  CustomSegmentedControl.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/25/23.
//

import Foundation
import UIKit


/// CustomSegmentedControl
class CustomSegmentedControl: UIControl {
    /// Style struct
    struct Style {
        static let ItemFont: UIFont = AppFont.regular(size: 13)
        static let ItemTextColor: UIColor = AppColors.SegmentedControlTextColor
        static let SelectedItemTextColor: UIColor = AppColors.SegmentedControlSelectedTextColor
        static let SelectedBorderColor: UIColor = AppColors.RegularTeal
        static let SelectedBorderHeight: CGFloat = 2
        static let HighlightedItemBackgroundColor = AppColors.SegmentedControlHighlightedBgColor
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
    }
    /// Buttons array
    private var buttons = [UIButton]()
    /// Bottom border for selected item
    private var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.SelectedBorderColor
        return view
    }()
    /// Selector view's width constraint
    private var selectorViewWidthConstraint: NSLayoutConstraint?
    /// Selector view's x-position
    private var selectorViewCenterXConstraint: NSLayoutConstraint?
    /// Stackview for holding items/buttons
    private var stackview: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    /// Selected segment index. Used to set new value. (public)
    public var selectedSegmentIndex: Int {
        get {
            return selectedSegment
        }
        set {
            guard selectedSegment != newValue else { return }
            selectedSegment = newValue
        }
    }
    /// Selected segment index (private)
    private var selectedSegment = 0
    /// True if buttons items should highlight when tapped
    private var shouldHighlightOnTap = false
    
    /// init with items
    init(items: [String], shouldHighlightOnTap: Bool = false) {
        super.init(frame: .zero)
        self.shouldHighlightOnTap = shouldHighlightOnTap
        backgroundColor = Style.BackgroundColor
        configure(buttonTitles: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard frame.width > 0, selectorView.frame.width == 0 else { return }
        updateSelectorViewWidth()
    }
    
    /// Called when button items are tapped
    @objc private func buttonTapped(sender: UIButton) {
        /// De-select previous selected button before updating selectedSegmentIndex
        buttons[selectedSegment].isSelected = false
        
        /// Set sender's isSelected to true and update selectedSegmentIndex
        sender.isSelected = true
        selectedSegment = sender.tag
        updateSelectorViewPosition()
        sendActions(for: .valueChanged)
    }
    
    /// Updates selector view's width
    private func updateSelectorViewWidth() {
        selectorViewWidthConstraint?.constant = frame.width / CGFloat(buttons.count)
        selectorViewCenterXConstraint?.isActive = true
    }
    
    /// Updates selector view's x position through animation
    private func updateSelectorViewPosition() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.selectorViewCenterXConstraint?.isActive = false
            sSelf.selectorViewCenterXConstraint = sSelf.selectorView.centerXAnchor.constraint(equalTo: sSelf.buttons[sSelf.selectedSegmentIndex].centerXAnchor)
            sSelf.selectorViewCenterXConstraint?.isActive = true
            sSelf.layoutIfNeeded()
        }
    }
    
    /// Set up segmented control
    private func configure(buttonTitles: [String]) {
        guard !buttonTitles.isEmpty else { return }
        /// Create buttons
        var highlightColor: UIColor =  .clear
        if shouldHighlightOnTap { highlightColor = Style.HighlightedItemBackgroundColor }
        
        var currentButtonTag = 0
        buttonTitles.forEach({ title in
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(Style.ItemTextColor, for: .normal)
            btn.setTitleColor(Style.SelectedItemTextColor, for: .selected)
            btn.titleLabel?.font = Style.ItemFont
            btn.setBackgroundImage(UIColor.clear.image(), for: .normal)
            btn.setBackgroundImage(highlightColor.image(), for: .highlighted)
            btn.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            btn.tag = currentButtonTag
            
            if currentButtonTag == selectedSegment { btn.isSelected = true }
            currentButtonTag += 1
            stackview.addArrangedSubview(btn)
            buttons.append(btn)
        })
        
        /// Set up stack view
        addSubview(stackview)
        stackview.disableTranslatesAutoresizingMaskIntoContraints()
        stackview.tc_constrainToSuperview()
        
        /// Set up selector view
        addSubview(selectorView)
        selectorView.disableTranslatesAutoresizingMaskIntoContraints()
        selectorView.heightAnchor.tc_constrain(equalToConstant: Style.SelectedBorderHeight)
        selectorView.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        selectorViewWidthConstraint = selectorView.widthAnchor.constraint(equalToConstant: buttons[selectedSegment].frame.width)
        selectorViewWidthConstraint?.isActive = true
        selectorViewCenterXConstraint = selectorView.centerXAnchor.constraint(equalTo: buttons[selectedSegment].centerXAnchor)
        selectorViewCenterXConstraint?.isActive = true

    }
}

