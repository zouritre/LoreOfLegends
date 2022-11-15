//
//  SplashSkinViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 14/11/2022.
//

import UIKit
import Combine

extension SkinDisplayViewController: UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
            if let itemNumber = currentVc.skinIndex {
                return itemNumber
            }
        }
        
        return 0
    }
}

extension SkinDisplayViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
            guard let currentSkinIndex = currentVc.skinIndex else { return nil }
            
            if currentSkinIndex > 0 {
                return controllers[currentSkinIndex-1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
            guard let currentSkinIndex = currentVc.skinIndex else { return nil }
            
            if currentSkinIndex < controllers.count-1 {
                return controllers[currentSkinIndex+1]
            }
        }
        
        return nil
    }
}

class SkinDisplayViewController: UIPageViewController {
    
    var controllers = [SkinViewController]()
    var skins: [ChampionAsset]?
    var assetType: ChampionAssetType = .centered
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
        dataSource = self
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        guard let currentVC = viewControllers?.first as? SkinViewController,
              let currentSkinImage = currentVC.skinImageView.image else { return }
        
        let action = UIActivityViewController(activityItems: [currentSkinImage], applicationActivities: nil)
        
        present(action, animated: true)
    }
    
    func setupControllers(with skins: [ChampionAsset], for assetType: ChampionAssetType, selectedSkinIndex: Int? = nil) {
        for (index, skin) in skins.enumerated() {
            let vc = SkinViewController(nibName: "SkinViewController", bundle: nil)
            
            vc.centeredSkinData = skin.centered
            vc.splashSkinData = skin.splash
            vc.skinIndex = index
            vc.skinName = skin.title
            vc.assetToDisplay = assetType
            
            controllers.append(vc)
        }
        
        if assetType == .centered {
            guard let firstSkin = controllers.first else { return }
            
            setViewControllers([firstSkin], direction: .forward, animated: true)
        }
        else if assetType == .splash {
            guard let selectedSkinIndex else { return }
            
            if controllers.firstIndex(where: { $0.skinIndex == selectedSkinIndex }) != nil {
                // selectedSkinIndex is in controller array bounds
                setViewControllers([controllers[selectedSkinIndex]], direction: .forward, animated: true)
            }
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