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
        
        // Set device orientation to portrait
        XCUIDevice.shared.orientation = .portrait
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // Wait Homescreen to appear after downloading champions
        navigationBar = app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0)
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 30))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func testArriveOnHomeScreen() {
        // Get the collection view
        let collectionView = app.collectionViews.element(boundBy: 0)
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))
        // Swipe up inside the collection view
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeUp()
        
        // Snapshot !
        snapshot("01LoginScreen")
    }
    
    func testDisplayLanguageSettings() {
        let settingsButton = app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0)
        // Navigate to settings
        settingsButton.tap()
        
        let languagePicker = app.pickerWheels.element(boundBy: 0)
        // Wait for async query to get languages
        XCTAssertTrue(languagePicker.waitForExistence(timeout: 10))
        languagePicker.swipeUp()
        
        // Snapshot !
        snapshot("02LanguagePicker")
    }
    
    func testDisplayPatchNotes() async {
        let patchNoteButton = app.toolbars.element(boundBy: 0).buttons.element(boundBy: 0)
        // Navigate to patch note webview
        DispatchQueue.main.sync {
            patchNoteButton.tap()
        }
        
        let expectation = expectation(description: "Wait webpage to load")
        // Prevent multiple calls to this expectation
        expectation.assertForOverFulfill = false
        // Wait 15 seconds for webpage to load
        var countdown = 15
        let cancellable = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink(receiveValue: { _ in
            // Decrement countdown by 1 if above 0
            countdown = countdown > 0 ? countdown - 1 : 0
            print("timer: ", countdown)
            if countdown == 0 {
                expectation.fulfill()
            }
        })
        
        await waitForExpectations(timeout: 25)
        
        DispatchQueue.main.sync {
            // Snapshot !
            snapshot("03PatchNotes")
        }
    }
    
    func testDisplayLoreForBelVeth() {
        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Belveth")
        
        let belVethCell = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0).children(matching: .other).element
        belVethCell.tap()
        
        // Wait for champion detail page to load
        let centeredSkinsContainer = app.scrollViews.element(boundBy: 0).children(matching: .other).element
        XCTAssertTrue(centeredSkinsContainer.waitForExistence(timeout: 10))
        
        // Snapshot !
        snapshot("04BelVeth")
    }

    func testDisplayLoreForKSante() {
        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Ksant")
        
        let ksanteCell = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0).children(matching: .other).element
        ksanteCell.tap()
        
        // Wait for champion detail page to load
        let centeredSkinsContainer = app.scrollViews.element(boundBy: 0).children(matching: .other).element
        XCTAssertTrue(centeredSkinsContainer.waitForExistence(timeout: 10))
        
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
        let jannaCell = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0).children(matching: .other).element
        jannaCell.tap()
        
        // Wait for champion detail page to load
        let centeredSkinsContainer = app.scrollViews.element(boundBy: 0).children(matching: .other).element
        XCTAssertTrue(centeredSkinsContainer.waitForExistence(timeout: 10))
        // Navigate to splash skins page view
        centeredSkinsContainer.tap()
        
        // Scroll to desired splash skin
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
