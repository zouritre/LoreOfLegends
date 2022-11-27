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
    
    func testDisplayLanguageForLores() {
        let settingsButton = app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0)
        // Navigate to settings
        settingsButton.tap()
        
        let languagePicker = app.pickerWheels.element(boundBy: 0)
        // Wait for async query to get languages
        XCTAssertTrue(languagePicker.waitForExistence(timeout: 10))
        
        // Snapshot !
        snapshot("02LanguagePicker")
    }
    
    func testDisplayPatchNotes() {
        let patchNoteButton = app.toolbars.element(boundBy: 0).buttons.element(boundBy: 0)
        // Navigate to patch note webview
        patchNoteButton.tap()
        
        let backButton = app/*@START_MENU_TOKEN@*/.otherElements["URL"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=54115\"]",".otherElements[\"TopBrowserBar\"]",".buttons[\"Adresse\"]",".otherElements[\"Adresse\"]",".otherElements[\"URL\"]",".buttons[\"URL\"]"],[[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3],[-1,1,2]],[[-1,4],[-1,3],[-1,5,3],[-1,2,3]],[[-1,4],[-1,3]]],[0]]@END_MENU_TOKEN@*/
        
        // Wait webpage to load
        XCTAssertTrue(backButton.waitForExistence(timeout: 30))
        
        // Snapshot !
        snapshot("03PatchNotes")
    }
    
    func testDisplayLoreForBelVeth() {
        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Belveth")
        
        app.collectionViews.element(boundBy: 0).cells.containing(.staticText, identifier:"Bel'Veth").children(matching: .other).element.tap()
        
        // Snapshot !
        snapshot("04BelVethLore")
    }

    func testDisplayLoreForKSante() {
        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Ksante")
        
        let ksanteCell = app.collectionViews.element(boundBy: 0).cells.containing(.staticText, identifier:"K'Sante").children(matching: .other).element
        ksanteCell.tap()
        
        // Snapshot !
        snapshot("05KSante")
    }
    
    func testDisplaySkinForJanna() {
        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.exists)
        
        // Type 'Janna' in search field
        searchField.tap()
        searchField.typeText("Janna")
        
        // Tap on Janna cell
        let jannaCell = app.collectionViews.element(boundBy: 0).cells.containing(.staticText, identifier:"Janna").children(matching: .other).element
        jannaCell.tap()
        
        // Tap on Janna first centered skin
        let jannaCenteredSkin01 = app.scrollViews.element(boundBy: 0).children(matching: .other).element
        XCTAssertTrue(jannaCenteredSkin01.waitForExistence(timeout: 10))
        jannaCenteredSkin01.tap()
        
        // Scroll to desired skin
        let scrollView = app.scrollViews.element(boundBy: 0)
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        scrollView.swipeLeft()
        
        // Snapshot !
        snapshot("06JannaSkin")
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
