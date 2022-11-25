//
//  AutoresizingLabel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 21/11/2022.
//

import UIKit

class AutoresizingLabel: UILabel {
    @IBInspectable var iPadFontSize: CGFloat = 40
    @IBInspectable var defaultFontSize: CGFloat = 20
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        numberOfLines = 1
        textAlignment = .center
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            defaultFontSize = iPadFontSize
        }
        
        if let customFont = UIFont(name: "FrizQuadrataBold", size: defaultFontSize) {
            font = customFont
        }
        else {
            font = .systemFont(ofSize: defaultFontSize)
        }
    }
}
