//
//  RoundedView.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 20/11/2022.
//

import UIKit

@IBDesignable public class RoundedView: UIView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(gray: 0.5, alpha: 1)
    }
    
}
