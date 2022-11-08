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
        pageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        pageViewController
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
    
    @IBOutlet weak var championNameLabel: UILabel!
    @IBOutlet weak var skinsContainerView: UIView!
    @IBOutlet weak var loreTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let champion else {
            alert(message: "Couldn't retrieve champion data")
            
            return
        }
        
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
        championDataSub = viewmodel.$champion.sink(receiveValue: { [unowned self] champ in
            if let champ {
                self.champion = champ
            }
        })
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "centeredSkinPageVC" {
             skinsPageViewController = segue.destination as? CenteredSkinsPageViewController
         }
     }
}
