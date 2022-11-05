//
//  ChampionDetailViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 25/10/2022.
//

import UIKit
import Combine

class ChampionDetailViewController: UIViewController {

    var champion: Champion?
    let viewmodel = ChampionDetailViewModel()
    var championDataSub: AnyCancellable?
    
    @IBOutlet weak var championNameLabel: UILabel!
    @IBOutlet weak var centeredImageCollection: UICollectionView!
    @IBOutlet weak var loreTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let champion else {
            alert(message: "Couldn't retrieve champion data")
            
            return
        }
        
        setupCollection()
        
        loreTextView.text = champion.lore
        championNameLabel.text = "\(champion.name), \(champion.title)"
        
        print("Selected champion: ", champion.name)
        // Do any additional setup after loading the view.
        
        championDataSub = viewmodel.$champion.sink(receiveValue: { champ in
            if let champ {
                self.champion = champ
            }
        })
        
        viewmodel.setSkinsForChampion(champion: champion)
    }
    
    func setupCollection() {
        let nib = UINib(nibName: "ChampionDetailCell", bundle: .main)
        
        centeredImageCollection.register(nib, forCellWithReuseIdentifier: "championCenteredImage")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
