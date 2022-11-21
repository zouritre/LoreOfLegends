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
    
    func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int
    ) -> CGFloat {
        return super.view.layer.bounds.size.height * 0.1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.font = UIFont(name: "FrizQuadrataBold", size: 70)!
        
        guard let languages = vm.languages.value else { return label }
        
        if languages[row].identifier == "vn_VN" {
            label.text = NSLocalizedString("VIETNAMESE", comment: "Language for Vietnam country")
            
            return label
        }
        
        let localizedIdentifier = Locale.current.localizedString(forLanguageCode: languages[row].identifier)?.uppercased()
        
        label.text = localizedIdentifier
        
        return label
    }
}

class SettingsViewController: UIViewController {
    let vm = SettingsViewModel()
    var languagesSubscriber: AnyCancellable?
    
    @IBOutlet weak var languageSelectionLabel: UILabel!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubscribers()
        
        Task {
            await vm.getSupportedLanguages()
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let languages = vm.languages.value else { return }
        
        let selectedLanguageIndex = languagePicker.selectedRow(inComponent: 0)
        // Save the new language selected by the user
        UserDefaults.standard.setValue(languages[selectedLanguageIndex].identifier, forKey: UserDefaultKeys.userSelectedLanguage.rawValue)
        // Forces redownload of champions data
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        
        alert(type: .Information, message: NSLocalizedString("Please restart the app to apply the new language", comment: "User selected a new language for lores display"))
    }
    
    private func setupSubscribers() {
        languagesSubscriber = vm.languages.sink { [unowned self] languages in
            if languages != nil {
                DispatchQueue.main.async { [unowned self] in
                    languagePicker.reloadAllComponents()
                }
            }
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
