//
//  ChampionDetailViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 25/10/2022.
//

import UIKit
import Combine

extension ChampionDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let champion else { return 0 }
        
        return champion.skins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let champion {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-centered-image", for: indexPath) as! ChampionDetailCell
            let centeredImageData = champion.skins[indexPath.row].centered
            
            var centeredImage: UIImage? = nil
            
            if let centeredImageData {
                centeredImage = UIImage(data: centeredImageData)
            }
            else {
                centeredImage = UIImage(data: Data())
            }
            
            cell.championCenteredImage.image = centeredImage
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

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
                
                DispatchQueue.main.async {
                    self.centeredImageCollection.reloadData()
                }
            }
        })
        
        viewmodel.setSkinsForChampion(champion: champion)
    }
    
    func setupCollection() {
        let nib = UINib(nibName: "ChampionDetailCell", bundle: .main)
        
        centeredImageCollection.register(nib, forCellWithReuseIdentifier: "champion-centered-image")
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
