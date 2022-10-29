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
    var isDownloadingSub: AnyCancellable?
    var totalChampionsCount = Int()
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    @IBOutlet weak var isDownloadingLabel: UILabel!
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
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
                self.downloadProgressBar.isHidden = false
                self.totalChampionsCount = count
                self.progressLabel.text = "0 / \(count)"
            }
            
        })
        
        downloadedChampionsCountSub = championListVm?.$downloadedChampionsCount.sink(receiveValue: { downloadedCounter in
            if self.totalChampionsCount > 0 {
                let total = Float(self.totalChampionsCount)
                let current = Float(downloadedCounter)
                let progress = current/total
                let progressToString = self.numberFormatter.string(from: progress as NSNumber)
                
                guard let progressToString else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let progress = self.numberFormatter.number(from: progressToString) {
                        self.downloadProgressBar.progress = Float(truncating: progress)
                    }
                    else { return }
                    
                    self.progressLabel.text = "\(downloadedCounter) / \(self.totalChampionsCount)"
                }
            }
        })
        
        isDownloadingSub = championListVm?.$isDownloading.sink(receiveValue: { isDownloading in
            DispatchQueue.main.async {
                self.isDownloadingLabel.text = isDownloading ? NSLocalizedString("ChampionsLoadingViewController.isDownloading", comment: "A download is running") : NSLocalizedString("ChampionsLoadingViewController.isFetching", comment: "Fetching champions locally")
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
