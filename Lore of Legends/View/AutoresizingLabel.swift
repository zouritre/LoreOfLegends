//
//  AutoresizingLabel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 21/11/2022.
//

import UIKit

public class AutoresizingLabel: UILabel {
    private var fontSize: CGFloat!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        numberOfLines = 1
        textAlignment = .center
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            fontSize = 30
        }
        else {
            fontSize = 20
        }
        
        if let customFont = UIFont(name: "FrizQuadrataBold", size: fontSize) {
            font = customFont
        }
        else {
            font = .systemFont(ofSize: fontSize)
        }
    }
}
