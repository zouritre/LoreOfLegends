//
//  SettingsViewController.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 09/11/2022.
//

import UIKit
import Combine

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let languages = vm.languages.value else { return 0 }
        
        return languages.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let languages = vm.languages.value else {
            print("languages is nil")
            return "" }
        
        return languages[row].identifier
    }
}

class SettingsViewController: UIViewController {
    let vm = SettingsViewModel()
    var languagesSubscriber: AnyCancellable?
    var languagesErrorSubscriber: AnyCancellable?
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        vm.getLanguages()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        UserDefaults.standard.setValue(languagePicker.selectedRow(inComponent: 0), forKey: UserDefaultKeys.userSelectedLanguage.rawValue)
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        
        alert(message: NSLocalizedString("Please restart the app to apply the new language", comment: "User selected a new language for lores display"))
    }
    
    private func setupSubscribers() {
        languagesSubscriber = vm.languages.sink { [unowned self] _ in
            print("received languages")
            languagePicker.reloadAllComponents()
        }
        
        languagesErrorSubscriber = vm.$requestError.sink { [unowned self] error in
            print("received error")
            guard let error else {
                alert(message: NSLocalizedString("Unknown error", comment: "Error occured but can't be retrieved"))
                
                return
            }
            
            alert(message: error.localizedDescription)
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
