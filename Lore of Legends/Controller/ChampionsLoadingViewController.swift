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
    
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadLabel.text = NSLocalizedString("Downloading champions icon", comment: "Champions download is running")
        
        setupSubscribers()
    }
    
    /// Implement the subscribers
    private func setupSubscribers() {
        iconsDownloadProgressSubscriber = homescreenViewModel?.$iconsDownloaded.sink { [unowned self] amountDownloaded in
            guard let amountDownloaded, let totalNumberOfChampions else { return }
            
            DispatchQueue.main.async { [unowned self] in
                // Update label for download progress
                progressLabel.text = "\(amountDownloaded) / \(totalNumberOfChampions)"
                // Update progress bar
                updateDownloadProgress(with: amountDownloaded)
                
                if amountDownloaded == totalNumberOfChampions {
                    // Dismiss if all icons have been downloaded
                    dismiss(animated: true)
                }
            }
        }
    }
    
    /// Update the progress bar
    /// - Parameter iconsDownloaded: Amount of icons downloaded yet
    private func updateDownloadProgress(with iconsDownloaded: Int) {
        guard let total = homescreenViewModel?.totalNumberOfChampions else { return }
        
        let progress = Float(iconsDownloaded)/Float(total)
        
        guard let progressToString = numberFormatter.string(from: progress as NSNumber) else { return }
        guard let progressFormatted = numberFormatter.number(from: progressToString) else { return }
        
        downloadProgressBar.progress = Float(truncating: progressFormatted)
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
