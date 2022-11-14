//
//  SplashSkinViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 14/11/2022.
//

import UIKit

extension SplashSkinViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if finished {
//            if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
//                if currentVc.skinIndex == 0 {
//                    if let champion, let title = champion.title {
//                        championNameLabel.text = "\(champion.name), \(title)"
//                    }
//                }
//                else {
//                    championNameLabel.text = currentVc.skinName
//                }
//            }
//        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
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

extension SplashSkinViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
            guard let currentSkinIndex = currentVc.skinIndex else { return nil }
            
            if currentSkinIndex > 0 {
                return pageViewControllers[currentSkinIndex-1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
            guard let currentSkinIndex = currentVc.skinIndex else { return nil }
            
            if currentSkinIndex < pageViewControllers.count-1 {
                return pageViewControllers[currentSkinIndex+1]
            }
        }
        
        return nil
    }
}
class SplashSkinViewController: UIPageViewController {
    
    var champion: Champion?
    var pageViewControllers = [SkinViewController]()
    var currentVc: SkinViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
        dataSource = self
        
        guard let currentVc else {
            
            return
        }
        
        currentVc.assetToDisplay = .splash
        
        pageViewControllers.forEach { controller in
            controller.assetToDisplay = .splash
        }
        
        setViewControllers([currentVc], direction: .forward, animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print("shared")
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
