//
//  HomeScreenViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 18/10/2022.
//

import UIKit

extension UIViewController {
    func alert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("alert.error", comment: "Error title"), message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        
        self.present(alert, animated: true)
    }
}

extension HomeScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return champions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "championIcon", for: indexPath)

        return cell
    }
}

class HomeScreenViewController: UIViewController {
    
    var championListVM = ChampionListViewModel()
    var champions = [Champion]()
    var championsDataListSubscriber: Any?
    var championsDataErrorSubscriber: Any?
    
    @IBOutlet weak var championIcons: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        championsDataListSubscriber = championListVM.$champions.sink(receiveValue: { [weak self] championList in
            guard let self else { return }
            guard let championList else { return }
            
            self.champions = championList
            
            self.championIcons.reloadData()
        })
        
        championsDataErrorSubscriber = championListVM.$championsDataError.sink(receiveValue: { [weak self] dataError in
            guard let self else { return }
            guard let dataError else { return }
            
            self.alert(message: dataError.localizedDescription)
        })
        
        championListVM.getChampions()
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
