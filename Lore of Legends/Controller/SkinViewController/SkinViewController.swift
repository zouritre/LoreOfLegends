//
//  SkinViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 08/11/2022.
//

import UIKit

class SkinViewController: UIViewController {
    var skinImageData: Data?
    var skinIndex: Int?
    
    @IBOutlet weak var skinImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let skinImageData else {
            print("data is empty")
            return
        }
        
        skinImageView.image = UIImage(data: skinImageData)
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
