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
    weak var homescreenViewModel: HomeScreenViewModel?
    // Number of champions in League
    var totalNumberOfChampions: Int?
    /// Notify champions icon download progress
    var iconsDownloadProgressSubscriber: AnyCancellable?
    /// Allows float number with max of 2 digits decimals
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
        
        isDownloadingLabel.text = NSLocalizedString("Downloading champions icon", comment: "Champions download is running")
        
        setupSubscribers()
    }
    
    /// Implement the subscribers
    private func setupSubscribers() {
        iconsDownloadProgressSubscriber = homescreenViewModel?.$iconsDownloaded.sink { [unowned self] count in
            guard let count else { return }
            // Set label
            // Then
            updateDownloadProgress(with: count)
        }
    }
    
    private func updateDownloadProgress(with iconsDownloaded: Int) {
        guard let total = homescreenViewModel?.totalNumberOfChampions else { return }
        
        let progress = Float(iconsDownloaded)/Float(total)
        
        guard let progressToString = numberFormatter.string(from: progress as NSNumber) else { return }
        guard let progressFormatted = numberFormatter.number(from: progressToString) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            downloadProgressBar.progress = Float(truncating: progressFormatted)
        }
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
