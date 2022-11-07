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
            // Dequeue the custom nib
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-centered-image", for: indexPath) as! ChampionDetailCell
            // Get the champion skin at the specified index of his skins property
            let centeredImageData = champion.skins[indexPath.row].centered
            
            // Initialise an optional image
            var centeredImage: UIImage? = nil
            
            if let centeredImageData {
                // Create an image from the data object
                centeredImage = UIImage(data: centeredImageData)
            }
            else {
                // Create an image with an empty data object
                centeredImage = UIImage(data: Data())
            }
            
            // Set the image for the imageView inside the custim cell
            cell.championCenteredImage.image = centeredImage
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

class ChampionDetailViewController: UIViewController {
    
    /// Champion selected by the user in HomeScreenViewController
    var champion: Champion?
    /// View model instance to use for fetching the useler selected champion skins images
    let viewmodel = ChampionDetailViewModel()
    /// Subscriber that notify the selected champion datas
    var championDataSub: AnyCancellable?
    var leftSwipe = UISwipeGestureRecognizer()
    var rightSwipe = UISwipeGestureRecognizer()
    var leftSwipeSubscriber: AnyCancellable?
    var rightSwipeSubscriber: AnyCancellable?
    
    @IBOutlet weak var championNameLabel: UILabel!
    @IBOutlet weak var centeredImageCollection: UICollectionView!
    @IBOutlet weak var loreTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let champion else {
            alert(message: "Couldn't retrieve champion data")
            
            return
        }
        
        setupGestures()
        setupCollection()
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
                self.champion = champ
                
                DispatchQueue.main.async {
                    self.centeredImageCollection.reloadData()
                }
            }
        })
        
        leftSwipeSubscriber = leftSwipe.publisher(for: \.state).sink { [unowned self] state in
            if state == .ended {
                let visibleItemIndexPath = centeredImageCollection.indexPathsForVisibleItems[0]
                let nextItem = IndexPath(item: visibleItemIndexPath.item+1, section: 0)
                let nextItemNotZeroBased = nextItem.item+1
                
                guard let champion else { return }
                
                if nextItemNotZeroBased <= champion.skins.count {
                    centeredImageCollection.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                }
            }
        }
        
        rightSwipeSubscriber = rightSwipe.publisher(for: \.state).sink { [unowned self] state in
            if state == .ended {
                let visibleItemIndexPath = centeredImageCollection.indexPathsForVisibleItems[0]
                let nextItem = IndexPath(item: visibleItemIndexPath.item-1, section: 0)
                
                if nextItem.item >= 0 {
                    centeredImageCollection.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    private func setupGestures() {
        leftSwipe.direction = .left
        rightSwipe.direction = .right
    }
    
    /// Register a custom nib object to the collection view
    private func setupCollection() {
        let nib = UINib(nibName: "ChampionDetailCell", bundle: .main)
        
        centeredImageCollection.register(nib, forCellWithReuseIdentifier: "champion-centered-image")
        centeredImageCollection.addGestureRecognizer(leftSwipe)
        centeredImageCollection.addGestureRecognizer(rightSwipe)
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
