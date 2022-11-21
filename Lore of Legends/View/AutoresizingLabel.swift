//
//  AutoresizingLabel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 21/11/2022.
//

import UIKit

public class AutoresizingLabel: UILabel {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        numberOfLines = 1
        
        if let customFont = UIFont(name: "FrizQuadrataBold", size: 50) {
            font = customFont
        }
        else {
            font = .systemFont(ofSize: 50)
        }
    }
}
