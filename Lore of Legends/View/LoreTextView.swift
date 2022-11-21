//
//  LoreTextView.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 21/11/2022.
//

import UIKit

class LoreTextView: UILabel {

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.01
        numberOfLines = 0
        
        if let customFont = UIFont(name: "FrizQua-ReguOS", size: 50) {
            font = customFont
        }
        else {
            font = .systemFont(ofSize: 50)
        }
    }
}
