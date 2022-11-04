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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Selected champion: ", champion?.name)
        // Do any additional setup after loading the view.
        guard let champion else {
            alert(message: "Couldn't retrieve champion data")
            
            return
        }
        
        championDataSub = viewmodel.$champion.sink(receiveValue: { champ in
            if let champ {
                self.champion = champ
            }
        })
        
        viewmodel.setSkinsForChampion(champion: champion)
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
