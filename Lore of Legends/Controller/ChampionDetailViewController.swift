//
//  ChampionDetailViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 25/10/2022.
//

import UIKit
import Combine

extension ChampionDetailViewController: UIPageViewControllerDataSource {
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

class ChampionDetailViewController: UIViewController {
    
    /// Champion selected by the user in HomeScreenViewController
    var champion: Champion?
    /// View model instance to use for fetching the useler selected champion skins images
    let viewmodel = ChampionDetailViewModel()
    /// Subscriber that notify the selected champion datas
    var championDataSub: AnyCancellable?
    /// ViewController that manages paginating for skins ViewController
    weak var skinsPageViewController: CenteredSkinsPageViewController?
    var pageViewControllers = [SkinViewController]()
    
    @IBOutlet weak var championNameLabel: UILabel!
    @IBOutlet weak var skinsContainerView: UIView!
    @IBOutlet weak var loreTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let champion else {
            alert(message: "Couldn't retrieve champion data")
            
            return
        }
        
        skinsPageViewController?.dataSource = self
        
        setupSubscribers()
        setupUiTexts(for: champion)
        
        viewmodel.setSkinsForChampion(champion: champion)
    }
    
    /// Set the text value of the different outlets of the UI
    /// - Parameter champion: Champion from wich to extract data for the text values
    private func setupUiTexts(for champion: Champion) {
        loreTextView.text = champion.lore
        championNameLabel.text = "\(champion.name), \(champion.title)"
    }
    
    /// Implement the subscribers
    private func setupSubscribers() {
        championDataSub = viewmodel.$champion.sink(receiveValue: { champ in
            if let champ {
                DispatchQueue.main.async { [unowned self] in
                    for (index, skin) in champ.skins.enumerated() {
                        print(index)
                        let vc = SkinViewController(nibName: "SkinViewController", bundle: nil)
                        
                        vc.skinImageData = skin.centered
                        vc.skinIndex = index
                        
                        pageViewControllers.append(vc)
                    }
                    
                    guard let firstSkin = pageViewControllers.first else {
                        return
                    }
                    
                    self.skinsPageViewController?.setViewControllers([firstSkin], direction: .forward, animated: true)
                }
            }
        })
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "centeredSkinPageVC" {
             // Retrieve CenteredSkinsPageViewController instance
             skinsPageViewController = segue.destination as? CenteredSkinsPageViewController
         }
     }
}
