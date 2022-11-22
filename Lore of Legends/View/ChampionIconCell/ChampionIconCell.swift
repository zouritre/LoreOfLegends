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
            guard let newValue, let icon = newValue.icon else { return }
            
            champIcon.image = UIImage(data: icon)
            champName.text = newValue.name
        }
    }
    
    @IBOutlet weak var champName: AutoresizingLabel!
    @IBOutlet weak var champIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
