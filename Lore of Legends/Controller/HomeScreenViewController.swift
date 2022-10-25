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
        if championListVM.champions.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-icon-notFound", for: indexPath) as? ChampionIconCell

            guard let cell else { return UICollectionViewCell() }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-icon", for: indexPath) as? ChampionIconCell

            guard let cell else { return UICollectionViewCell() }
            
            cell.champIcon.image = UIImage(data: championListVM.champions[indexPath.row].icon)
            cell.champName.text = championListVM.champions[indexPath.row].name
            
            return cell
        }
    }
}

extension HomeScreenViewController: UICollectionViewDelegate {
    
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            championListVM.champions = originalChampionList
        }
        else {
            var foundPerfectMatch = false

            for champion in originalChampionList {
                if champion.name == searchText {
                    self.championListVM.champions = [champion]
                    foundPerfectMatch = true

                    break
                }
            }

            if foundPerfectMatch { return }

            for searchCharacter in searchText {
                self.championListVM.champions = self.championListVM.champions.filter {
                    $0.name.contains { nameCharacter in
                        searchCharacter.lowercased() == nameCharacter.lowercased()
                    }
                }
            }
        }
    }
}

class HomeScreenViewController: UIViewController {
    var originalChampionList: [Champion] = []
    var championListVM = ChampionListViewModel()
    var championsDataListSubscriber: AnyCancellable?
    var championsDataErrorSubscriber: AnyCancellable?
    var originalChampListPublisher = PassthroughSubject<[Champion], Never>()
    var originalChampListSubscriber: AnyCancellable?
    
    @IBOutlet weak var championIconsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupViewModelSubscribers()
        
        championListVM.getChampions()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ChampionIconCell", bundle: .main)
        
        self.championIconsCollection.register(nib, forCellWithReuseIdentifier: "champion-icon")
    }
    
    private func setupViewModelSubscribers() {
        championsDataListSubscriber = championListVM.$champions.sink(receiveValue: { [weak self] champions in
            guard let self else { return }
            if champions.count > 0 {
                self.originalChampListPublisher.send(champions)
                self.originalChampListPublisher.send(completion: .finished)
            }
            
            DispatchQueue.main.async {
                self.championIconsCollection.reloadData()
            }
        })
        
        championsDataErrorSubscriber = championListVM.$championsDataError.sink(receiveValue: { [weak self] dataError in
            guard let self else { return }
            guard let dataError else { return }
            
            self.alert(message: dataError.localizedDescription)
        })
        
        originalChampListSubscriber = originalChampListPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                return
            case .failure(_):
                return
            }
        }, receiveValue: { champions in
                self.originalChampionList = champions
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
