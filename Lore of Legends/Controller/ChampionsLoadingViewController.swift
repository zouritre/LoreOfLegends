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
    var totalChampionsCountSub: AnyCancellable?
    var downloadedChampionsCountSub: AnyCancellable?
    var totalChampionsCount = Int()
    
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscribers()
        championListVm?.getChampions()
    }
    
    private func setupSubscribers() {
        championsDataSub = championListVm?.$champions.sink(receiveValue: { champions in
            if champions.count > 0 {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        })
        totalChampionsCountSub = championListVm?.$totalChampionsCount.sink(receiveValue: { count in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.downloadProgressBar.isHidden = false
                self.totalChampionsCount = count
                self.progressLabel.text = "0 / \(count)"
            }
            
        })
        
        downloadedChampionsCountSub = championListVm?.$downloadedChampionsCount.sink(receiveValue: { downloadedCounter in
            if self.totalChampionsCount > 0 {
                DispatchQueue.main.async {
                    self.downloadProgressBar.progress = Float((downloadedCounter*100)/self.totalChampionsCount)
                    self.progressLabel.text = "\(downloadedCounter) / \(self.totalChampionsCount)"
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
