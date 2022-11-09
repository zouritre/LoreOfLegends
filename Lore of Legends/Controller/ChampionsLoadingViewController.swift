//
//  ChampionsLoadingViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 29/10/2022.
//

import UIKit
import Combine

class ChampionsLoadingViewController: UIViewController {
    
    /// View model instance
    weak var championListVm: ChampionListViewModel?
    /// Subscriber for total number of champions in League
    var totalChampionsCountSub: AnyCancellable?
    /// Subsriber for the number of champions currently downloaded or fetched from Core Data
    var downloadedChampionsCountSub: AnyCancellable?
    /// Number formatter that allows float number with max of 2 digits decimals
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
        
        isDownloadingLabel.text = NSLocalizedString("Downloading champions", comment: "Champions download is running")
        
        setupSubscribers()
    }
    
    /// Implement the subscribers
    private func setupSubscribers() {
        totalChampionsCountSub = championListVm?.$totalChampionsCount.sink(receiveValue: { count in
            DispatchQueue.main.async { [unowned self] in
                progressLabel.text = "0 / \(count ?? 0)"
            }
            
        })
        
        downloadedChampionsCountSub = championListVm?.$downloadedChampionsCount.sink(receiveValue: { downloadedCounter in
            DispatchQueue.main.async { [unowned self] in
                progressLabel.text = "\(downloadedCounter ?? 0) / \(championListVm?.totalChampionsCount ?? 0)"
                
                downloadProgressBar.progress = downloadProgress()
                
                guard championListVm?.totalChampionsCount != nil,
                      downloadedCounter != nil else { return }
                
                if downloadedCounter == championListVm?.totalChampionsCount {
                    print("Dissmissed")
                    dismiss(animated: true)
                }
            }
        })
    }
    
    private func downloadProgress() -> Float {
        guard let downloaded = championListVm?.downloadedChampionsCount,
              let total = championListVm?.totalChampionsCount
        else { return 0 }
        
        let progress = Float(downloaded)/Float(total)
        
        guard let progressToString = numberFormatter.string(from: progress as NSNumber) else { return 0 }
        guard let progressFormatted = numberFormatter.number(from: progressToString) else { return 0 }
        
        return Float(truncating: progressFormatted)
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
