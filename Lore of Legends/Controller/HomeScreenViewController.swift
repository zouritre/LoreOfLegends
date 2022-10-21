//
//  HomeScreenViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 18/10/2022.
//

import UIKit
import Combine

extension UIViewController {
    func alert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("alert.error", comment: "Error title"), message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        
        self.present(alert, animated: true)
    }
}

extension HomeScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.championListVM.champions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-icon", for: indexPath) as? ChampionIconCell

        guard let cell else {
            return UICollectionViewCell()
        }
        
        cell.champName.text = championListVM.champions[indexPath.row].name
        
        return cell
    }
}

extension HomeScreenViewController: UICollectionViewDelegate {
    
}
class HomeScreenViewController: UIViewController {
    
    var championListVM = ChampionListViewModel()
    var champions = [Champion]()
    var championsDataListSubscriber: AnyCancellable?
    var championsDataErrorSubscriber: AnyCancellable?
    
    @IBOutlet weak var championIcons: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupViewModelSubscribers()
        
        championListVM.getChampions()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ChampionIconCell", bundle: .main)
        
        self.championIcons.register(nib, forCellWithReuseIdentifier: "champion-icon")
    }
    
    private func setupViewModelSubscribers() {
        championsDataListSubscriber = championListVM.$champions.sink(receiveValue: { [weak self] championList in
            guard let self else { return }
            
            self.championIcons.reloadData()
        })
        
        championsDataErrorSubscriber = championListVM.$championsDataError.sink(receiveValue: { [weak self] dataError in
            guard let self else { return }
            guard let dataError else { return }
            
            self.alert(message: dataError.localizedDescription)
        })
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
