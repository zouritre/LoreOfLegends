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

extension HomeScreenViewController: ChampionListViewModelDelegate {
    func championList(champions: [Champion]?, error: Error?) {
        if let champions {
            self.champions = champions
            
            championIcons.reloadData()
        }
        
        if let error {
            alert(message: error.localizedDescription)
        }
    }
}

class HomeScreenViewController: UIViewController {
    
    var championIconsDatasource: UICollectionViewDiffableDataSource<Int, UUID>?
    var championListVM = ChampionListViewModel()
    var champions = [Champion]()
    
    @IBOutlet weak var championIcons: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        championListVM.delegate = self
        
        championIconsDatasource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: championIcons) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) -> UICollectionViewCell? in
            // Configure and return cell.
            
            
            return UICollectionViewCell()
        }
        // Do any additional setup after loading the view.
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
