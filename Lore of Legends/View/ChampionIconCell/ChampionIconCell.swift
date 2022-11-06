//
//  ChampionIconCell.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 21/10/2022.
//

import UIKit

class ChampionIconCell: UICollectionViewCell {
    
    /// Champion object to wich this cell is associated
    var champion: Champion? {
        willSet {
            guard let newValue else { return }
            
            champIcon.image = UIImage(data: newValue.icon)
            champName.text = newValue.name
        }
    }
    
    @IBOutlet weak var champIcon: UIImageView!
    @IBOutlet weak var champName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}