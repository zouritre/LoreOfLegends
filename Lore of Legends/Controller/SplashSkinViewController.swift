//
//  SplashSkinViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 14/11/2022.
//

import UIKit

class SplashSkinViewController: UIPageViewController {
    
    var pageViewControllers = [SkinViewController]()
    var currentVc: SkinViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        print("controller count: ", pageViewControllers.count)
        print("current skin: ", currentVc?.skinName)
        // Do any additional setup after loading the view.
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
