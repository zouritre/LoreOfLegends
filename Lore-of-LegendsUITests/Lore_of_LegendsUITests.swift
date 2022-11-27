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
    var navigationBar: XCUIElement!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // Wait Homescreen to appear after downloading champions
        navigationBar = app.navigationBars["Lore of Legends"].buttons.element(boundBy: 0)
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 30))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testArriveOnHomeScreen() {
        snapshot("01LoginScreen")
    }
    
    func testChooseLanguageForLores() {
        let settingsButton = app.navigationBars["Lore of Legends"].buttons.element(boundBy: 0)
        // Navigate to settings
        settingsButton.tap()
        
        let languagePicker = app.pickerWheels.element(boundBy: 0)
        // Wait for async query to get languages
        XCTAssertTrue(languagePicker.waitForExistence(timeout: 5))
        
        // Snapshot !
        snapshot("02LanguagePicker")
        
        // Save settings button
        let saveButton = app.buttons.matching(identifier: "SaveSettingsButton").element
        saveButton.tap()
        // Tap Ok button from alert
        app.alerts.element(boundBy: 0).scrollViews.otherElements.buttons.element(boundBy: 0).tap()
        // Tap back button from nav bar
        app.navigationBars["Lore_of_Legends.SettingsView"].buttons.element(boundBy: 0).tap()
    }
    
    func testDisplayPatchNotes() {
        let patchNoteButton = app.toolbars.element(boundBy: 0).buttons.element(boundBy: 0)
        // Navigate to patch note webview
        patchNoteButton.tap()
        
        let backButton = app/*@START_MENU_TOKEN@*/.otherElements["URL"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=54115\"]",".otherElements[\"TopBrowserBar\"]",".buttons[\"Adresse\"]",".otherElements[\"Adresse\"]",".otherElements[\"URL\"]",".buttons[\"URL\"]"],[[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3]],[[-1,4],[-1,3]]],[0]]@END_MENU_TOKEN@*/
        
        // Wait webpage to load
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        
        // Snapshot !
        snapshot("03PatchNotes")
        
        // Return to homescreen
        backButton.tap()
    }
    
    func testDisplayLoreForBelVeth() {
        
        let searchBar = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField)
        
        searchBar.element.tap()
        
        let bKey = app.keys["B"]
        // Press 'K' key on keyboard
        bKey.tap()
        
        // Press 'S' key on keyboard
        let lKey = app.keys["l"]
        lKey.tap()
        
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Bel'Veth").children(matching: .other).element.tap()
        
        // Snapshot !
        snapshot("04BelVethLore")
        
        app.navigationBars["Lore_of_Legends.ChampionDetailView"].buttons.element(boundBy: 0).tap()
    }

    func testDisplayLoreForKSante() {
        
        let searchBar = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField)
        
        searchBar.element.tap()
        
        let kKey = app/*@START_MENU_TOKEN@*/.keys["K"]/*[[".keyboards.keys[\"K\"]",".keys[\"K\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        // Press 'K' key on keyboard
        kKey.tap()
        
        // Press 'S' key on keyboard
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        let ksanteCell = app.collectionViews.cells.otherElements.containing(.staticText, identifier:"K'Sante").children(matching: .other).element
        ksanteCell.tap()
        
        // Snapshot !
        snapshot("05KSante")
        
        // Press back button
        app.navigationBars["Lore_of_Legends.ChampionDetailView"].buttons.element(boundBy: 0).tap()
    }
    
    func testDisplaySkinForJanna() {
        
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element.tap()
        
        let jKey = app/*@START_MENU_TOKEN@*/.keys["J"]/*[[".keyboards.keys[\"J\"]",".keys[\"J\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        jKey.tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Janna").children(matching: .other).element.tap()
        
        let jannaCenteredSkin01 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element
        
        XCTAssertTrue(jannaCenteredSkin01.waitForExistence(timeout: 10))
        jannaCenteredSkin01.tap()
        
        let pageView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let scrollView = pageView.children(matching: .scrollView).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element
        
        // Scroll to desired skin
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        
        // Snapshot !
        snapshot("06JannaSkin")
        
        // Navigate back to champion detail
        let backButton = app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0)
        backButton.tap()
    }
    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
