//
//  HomeScreenViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 18/10/2022.
//

import UIKit
import Combine

extension UIViewController {
    /// Display an alert with a custom message
    /// - Parameter message: Text to display in the alert
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension HomeScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = homescreenViewmodel.champions?.count else { return 0 }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Return an empty cell if champion list is empty
        guard let champions = homescreenViewmodel.champions else { return UICollectionViewCell() }
        
        if champions.isEmpty {
            return UICollectionViewCell()
        }
        else {
            // Else dequeue a custom cell and returns it
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "champion-icon", for: indexPath) as? ChampionIconCell

            guard let cell else { return UICollectionViewCell() }
            
            cell.champion = champions[indexPath.row]
            
            return cell
        }
    }
}

extension HomeScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt: IndexPath) {
        let cell = collectionView.cellForItem(at: didSelectItemAt) as? ChampionIconCell
        
        guard let cell else { return }
        
        // Store the selected champion
        selectedChampion = cell.champion
        
        // Go to the champion detail screen
        performSegue(withIdentifier: "goToDetail", sender: nil)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Set the collectionview datasource to display the full champion list if no search entry
        if searchText.isEmpty {
            homescreenViewmodel.champions = originalChampionList
        }
        else {
            // Else filter the champion list against the given search text
            var foundPerfectMatch = false

            // Set the collectionview datasource array to contain a single champion matching the exact search text
            for champion in originalChampionList {
                if champion.name == searchText {
                    self.homescreenViewmodel.champions = [champion]
                    foundPerfectMatch = true

                    break
                }
            }

            // Exit the statement if a champion name matched the exact search text
            if foundPerfectMatch { return }

            // Create a copy or the original champion list
            var originalListCopy = originalChampionList
            
            // Filter the copy against the search text
            for searchCharacter in searchText {
                originalListCopy = originalListCopy.filter {
                    $0.name.contains { nameCharacter in
                        searchCharacter.lowercased() == nameCharacter.lowercased()
                    }
                }
            }
            
            // Set the filetered champion list as the collectionview datasource array
            self.homescreenViewmodel.champions = originalListCopy
        }
    }
}

class HomeScreenViewController: UIViewController {
    var selectedChampion: Champion?
    /// Original list of champions received the first time it's successfully fetched from API. Only set once per app execution.
    var originalChampionList: [Champion] = []
    /// View model
    var homescreenViewmodel = HomeScreenViewModel()
    /// Subscriber for the viewmodel champion list property
    var championsSubscriber: AnyCancellable?
    /// Subscriber for the viewmodel champion list error property
    var errorSubscriber: AnyCancellable?
    /// Publisher for the original champion list. Publish  a single value then complete.
    var originalChampListPublisher = PassthroughSubject<[Champion], Never>()
    /// Subscriber for the original champion list. Receive a single value then cancel activity.
    var originalChampListSubscriber: AnyCancellable?
    /// Notify if champions download is pending or not
    var totalNumberOfChampionsSubscriber: AnyCancellable?
    
    /// Main collectionview of the UI
    @IBOutlet weak var championIconsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupSubscribers()
        
        homescreenViewmodel.getChampions()
    }
    
    @IBAction func settingsButon(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    /// Register a Nib to the collection view
    private func setupCollectionView() {
        let nib = UINib(nibName: "ChampionIconCell", bundle: .main)
        
        self.championIconsCollection.register(nib, forCellWithReuseIdentifier: "champion-icon")
    }
    
    /// Implement the subscribers
    private func setupSubscribers() {
        championsSubscriber = homescreenViewmodel.$champions.sink(receiveValue: { [unowned self] champions in
            guard let champions else { return }
            
            if champions.count > 0 {
                self.originalChampListPublisher.send(champions)
                self.originalChampListPublisher.send(completion: .finished)
            }
            
            DispatchQueue.main.async {
                self.championIconsCollection.reloadData()
            }
        })
        
        errorSubscriber = homescreenViewmodel.$error.sink(receiveValue: { [unowned self] dataError in
            guard let dataError else { return }

            self.alert(message: dataError.localizedDescription)
        })
        
        originalChampListSubscriber = originalChampListPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.originalChampListSubscriber?.cancel()
                return
            case .failure(_):
                return
            }
        }, receiveValue: { champions in
                self.originalChampionList = champions
        })
        
        totalNumberOfChampionsSubscriber = homescreenViewmodel.$totalNumberOfChampions.sink { [unowned self] total in
            guard let total else { return }
            
            DispatchQueue.main.async { [unowned self] in
                performSegue(withIdentifier: "championsLoading", sender: total)
            }
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChampionDetailViewController {
            // Send the selected champion to the next view controller
            vc.champion = selectedChampion
        }
        else if let vc = segue.destination as? ChampionsLoadingViewController {
            // Send the selected champion to the next view controller
            if let totalChampions = sender as? Int {
                vc.totalNumberOfChampions = totalChampions
                vc.homescreenViewModel = homescreenViewmodel
            }
        }
    }

}
