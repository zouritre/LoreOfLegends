//
//  ChampionDetailViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 25/10/2022.
//

import UIKit
import Combine

extension ChampionDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let currentVc = pageViewController.viewControllers?.first as? SkinViewController {
                if currentVc.skinIndex == 0 {
                    if let champion, let title = champion.title {
                        championNameLabel.text = "\(champion.name), \(title)"
                    }
                }
                else {
                    championNameLabel.text = currentVc.skinName
                }
            }
        }
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
    var championSubscriber: AnyCancellable?
    /// ViewController that manages paginating for skins ViewController
    weak var skinsPageViewController: CenteredSkinsPageViewController?
    var pageViewControllers = [SkinViewController]()
    
    @IBOutlet weak var skinsLoadingIndicator: UIActivityIndicatorView!
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
        skinsPageViewController?.delegate = self
        
        setupSubscribers()
        
        viewmodel.setInfo(for: champion)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
        performSegue(withIdentifier: "showSplash", sender: nil)
    }
    /// Implement the subscribers
    private func setupSubscribers() {
        championSubscriber = viewmodel.$champion.sink(receiveValue: { [unowned self] champ in
            guard let champ else { return }
            
            champion = champ
            
            DispatchQueue.main.async { [unowned self] in
                // Hide the indicator
                skinsLoadingIndicator.stopAnimating()
                
                // Display the champion lore
                loreTextView.text = champ.lore
                
                // Display the champion name and honorific title
                championNameLabel.text = "\(champ.name), \(champ.title ?? "")"
                
                guard let skins = champ.skins else { return }
                
                for (index, skin) in skins.enumerated() {
                    let vc = SkinViewController(nibName: "SkinViewController", bundle: nil)
                    
                    vc.centeredSkinData = skin.centered
                    vc.splashSkinData = skin.splash
                    vc.skinIndex = index
                    vc.skinName = skin.title
                    vc.assetToDisplay = .centered
                    
                    pageViewControllers.append(vc)
                }
                
                guard let firstSkin = pageViewControllers.first else {
                    return
                }
                
                self.skinsPageViewController?.setViewControllers([firstSkin], direction: .forward, animated: true)
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
        else if segue.identifier == "showSplash" {
            guard let vc = segue.destination as? SplashSkinViewController else {
                
                return
            }
            
            vc.pageViewControllers = pageViewControllers
            
            guard let currentVc = skinsPageViewController?.viewControllers?.first as? SkinViewController else {
                
                return }
            
            vc.currentVc = currentVc
            vc.champion = champion
        }
    }
}
