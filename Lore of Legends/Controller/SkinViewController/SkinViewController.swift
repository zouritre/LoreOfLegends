//
//  SkinViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 08/11/2022.
//

import UIKit

class SkinViewController: UIViewController {
    var centeredSkinData: Data?
    var splashSkinData: Data?
    var skinIndex: Int?
    var skinName: String?
    var assetToDisplay: ChampionAssetType?
    
    @IBOutlet weak var skinImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let assetToDisplay else {
            
            return
        }
        
        switch assetToDisplay {
        case .centered:
            if let centeredSkinData { skinImageView.image = UIImage(data: centeredSkinData) }
        case .splash:
            if let splashSkinData { skinImageView.image = UIImage(data: splashSkinData) }
        }
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
