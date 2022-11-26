//
//  Lore_of_LegendsUITests.swift
//  Lore-of-LegendsUITests
//
//  Created by Bertrand Dalleau on 25/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class Lore_of_LegendsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testArriveOnHomeScreen() {
        snapshot("01LoginScreen")
    }
    
    func testChooseLanguageForLores() {
        app.navigationBars["Lore of Legends"].buttons["Item"].tap()
        let pickerExist = app.pickerWheels["ANGLAIS"].waitForExistence(timeout: 5)
        XCTAssertTrue(pickerExist)
        snapshot("02LanguagePicker")
        app.pickerWheels["ANGLAIS"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Sauvegarder"]/*[[".buttons[\"Sauvegarder\"].staticTexts[\"Sauvegarder\"]",".staticTexts[\"Sauvegarder\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Information"].scrollViews.otherElements.buttons["Ok"].tap()
        app.navigationBars["Lore_of_Legends.SettingsView"].buttons["Lore of Legends"].tap()
                
    }
    
    func testDisplayPatchNotes() {
        
        let app = XCUIApplication()
        let patchNoteButton = app/*@START_MENU_TOKEN@*/.toolbars["Toolbar"]/*[[".toolbars[\"Barre d’outils\"]",".toolbars[\"Toolbar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Version de patch: 12.22.1"]
        XCTAssertTrue(patchNoteButton.waitForExistence(timeout: 10))
        patchNoteButton.tap()
        let backButton = app/*@START_MENU_TOKEN@*/.otherElements["URL"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=54115\"]",".otherElements[\"TopBrowserBar\"]",".buttons[\"Adresse\"]",".otherElements[\"Adresse\"]",".otherElements[\"URL\"]",".buttons[\"URL\"]"],[[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3]],[[-1,4],[-1,3]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        
        snapshot("03PatchNotes")
        backButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
