//
//  ChampionsLoadingViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 29/10/2022.
//

import UIKit
import Combine

class ChampionsLoadingViewController: UIViewController {

    var championListVm: ChampionListViewModel?
    var championsDataSub: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscribers()
        championListVm?.getChampions()
    }
    
    private func setupSubscribers() {
        championsDataSub = championListVm?.$champions.sink(receiveValue: { champions in
            if champions.count > 0 {
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                }
            }
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
