//
//  HomeScreenViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 18/10/2022.
//

import UIKit
import Combine
import SafariServices

extension UIViewController {
    /// Display an alert with a custom message
    /// - Parameter message: Text to display in the alert
    func alert(type: AlertType, message: String) {
        var title = ""
        
        switch type {
        case .Error:
            title = NSLocalizedString("Error", comment: "An error ocurred")
        case .Update:
            title = NSLocalizedString("Update", comment: "An update is available")
        case .Information:
            title = NSLocalizedString("Information", comment: "Provide information about an event")
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
        
        guard let cell, let champion = cell.champion else { return }
        // Go to the champion detail screen
        performSegue(withIdentifier: "goToDetail", sender: champion)
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            return CGSize(width: view.bounds.width*0.15, height: view.bounds.width*0.2)
        }
        else {
            return CGSize(width: view.bounds.width*0.3, height: view.bounds.width*0.4)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Close the keyboard
        searchBar.resignFirstResponder()
    }
}

extension HomeScreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Hide the  keyboard
        self.searchBar.resignFirstResponder()
        
        if scrollView.panGestureRecognizer.velocity(in: championIconsCollection).y < 0 {
            scrollDirection = "down"
        }
        else if scrollView.panGestureRecognizer.velocity(in: championIconsCollection).y > 0 {
            scrollDirection = "up"
        }
        
        if didEndDecelerating && scrollDirection == "down" {
            // Prevent this code from executing until scrolling animation completly stops
            // Then
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating = false
        
        if scrollDirection == "up" {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating = true
    }
}

class HomeScreenViewController: UIViewController {
    /// CollectionView scroll direction
    var scrollDirection = "neutral"
    /// Scrolling inside CollectionView  has ended
    var didEndDecelerating: Bool = true
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
    /// Notify when a new update is available
    var newUpdateSubscriber: AnyCancellable?
    // Notify patch version for assets saved on the device
    var patchVersionSubscriber: AnyCancellable?
    
    /// Main collectionview of the UI
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patchVersionItem: UIBarButtonItem!
    @IBOutlet weak var championIconsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        setupCollectionView()
        setupSubscribers()
        
        Task {
            await homescreenViewmodel.getChampions()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @IBAction func leaguePatchUrl(_ sender: Any) {
        var officialPatchNotesUrl: URL?
        
        if #available(iOS 16, *) {
            if Locale.current.language.languageCode == "fr" {
                officialPatchNotesUrl = URL(string: "https://www.leagueoflegends.com/fr-fr/news/tags/patch-notes/")
            }
            else {
                officialPatchNotesUrl = URL(string: "https://www.leagueoflegends.com/en-us/news/tags/patch-notes/")
            }
        }
        else {
            if Locale.current.languageCode == "fr" {
                officialPatchNotesUrl = URL(string: "https://www.leagueoflegends.com/fr-fr/news/tags/patch-notes/")
            }
            else {
                officialPatchNotesUrl = URL(string: "https://www.leagueoflegends.com/en-us/news/tags/patch-notes/")
            }
        }
        
        guard let officialPatchNotesUrl else { return }
        
        let safariController = SFSafariViewController(url: officialPatchNotesUrl)
        
        present(safariController, animated: true)
    }
    
    @IBAction func settingsButon(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    private func setupNavigationTitle() {
        // Set font for navigation bar title
        var fontSize: CGFloat!
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            fontSize = 25
        }
        else { fontSize = 20 }
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "FrizQuadrataBold", size: fontSize)!]
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
            
            self.alert(type: .Error, message: dataError.localizedDescription)
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
        
        newUpdateSubscriber = homescreenViewmodel.$newUpdate.sink { [unowned self] newVersion in
            guard let newVersion else { return }
            
            alert(type: .Update, message: NSLocalizedString("Patch \(newVersion) is available! Restart the app to update.", comment: "A new patch is available"))
        }
        
        patchVersionSubscriber = homescreenViewmodel.$patchVersion.sink { [unowned self] patchVersion in
            DispatchQueue.main.async { [unowned self] in
                patchVersionItem.title = "\(NSLocalizedString("Patch version", comment: "The League patch version for assets saved on this device")): \(patchVersion ?? "")"
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChampionDetailViewController {
            if let champion = sender as? Champion {
                // Send the selected champion to the next view controller
                vc.champion = champion
            }
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
