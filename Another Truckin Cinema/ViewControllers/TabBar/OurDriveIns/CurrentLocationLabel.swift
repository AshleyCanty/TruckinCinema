//
//  CurrentLocationLabel.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/30/23.
//

import Foundation
import UIKit

/// UIlabel with an image for a right-view. Used to show current location.
class CurrentLocationLabel: UILabel {
    
    enum ScreenType {
        case OurDriveIns
        case ChangeLocation
    }
    
    private var isInteractive: Bool = false
    
    override var text: String? {
        didSet {
            setup()
        }
    }
    
    struct Style {
        static let Font: UIFont = AppFont.regular(size: 12)
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let InteractiveFont: UIFont = AppFont.semiBold(size: 12)
        static let InteractiveTextColor: UIColor = AppColors.RegularTeal
        static let IconDefaultSize: CGFloat = 24
    }
    
    
    init(forType type: ScreenType = .OurDriveIns) {
        super.init(frame: .zero)
        if type == .ChangeLocation {
            isInteractive = true
            isUserInteractionEnabled = true
        }
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let textColor = isInteractive ? AppColors.RegularTeal : AppColors.TextColorPrimary
        let font = isInteractive ? Style.InteractiveFont : Style.Font
        let str = isInteractive ? "Use Current Location" : text ?? ""
        var image = UIImage(imgNamed: "location-current")
        image = image.withTintColor(textColor, renderingMode: .alwaysTemplate)
        
        let imageAttachment = NSTextAttachment(image: image)
        let height = imageAttachment.image?.size.height ?? Style.IconDefaultSize
        let width = imageAttachment.image?.size.width ?? Style.IconDefaultSize
        
        imageAttachment.bounds = CGRect(x: 0, y: (font.capHeight - height).rounded() / 2, width: width, height: height)
        
        let finalString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor])
        
        let finalStringWithImage = NSMutableAttributedString(attachment: imageAttachment)
        finalStringWithImage.append(NSAttributedString(string: "  "))
        finalStringWithImage.append(finalString)
        
        attributedText = finalStringWithImage
        layoutIfNeeded()
    }
}
