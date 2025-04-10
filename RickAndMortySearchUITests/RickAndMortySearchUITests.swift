//
//  RickAndMortySearchUITests.swift
//  RickAndMortySearchUITests
//
//  Created by Justin Doo on 4/9/25.
//

import XCTest

final class RickMortySearchAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testSearchAndOpenCharacterDetail() {
        let searchField = app.textFields["Search field"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("Rick")

        // Wait for the character to appear
        let characterCell = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(characterCell.waitForExistence(timeout: 5))
        characterCell.tap()

        // Wait for the detail view
        let detailTitle = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2))
    }

    func testUsingFiltersWithoutSearchShowsAlert() {
        let statusField = app.textFields["Status"]
        statusField.tap()
        statusField.typeText("alive")

        let alert = app.alerts["Search Required"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.staticTexts["Please enter a main character name before using filters."].exists)
    }
}
