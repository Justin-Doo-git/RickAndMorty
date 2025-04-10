//
//  RickAndMortySearchTests.swift
//  RickAndMortySearchTests
//
//  Created by Justin Doo on 4/9/25.
//

import XCTest
@testable import RickAndMortySearch


class CharacterViewModelTests: XCTestCase {
    
    func testFetchCharactersReturnsMockResult() {
        let mockNetwork = MockNetworkManager()
        let viewModel = CharacterViewModel(networkManager: mockNetwork)

        let expectation = XCTestExpectation(description: "Characters fetched")

        viewModel.statusFilter = ""
        viewModel.speciesFilter = ""
        viewModel.typeFilter = ""
        viewModel.fetchCharacters(for: "Rick")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.characters.count, 1)
            XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterWithoutSearchTriggersAlert() {
        let viewModel = CharacterViewModel(networkManager: MockNetworkManager())
        viewModel.statusFilter = "alive"

        let expectation = XCTestExpectation(description: "Alert triggered")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(viewModel.showFilterAlert)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testEmptySearchClearsCharacters() {
        let viewModel = CharacterViewModel(networkManager: MockNetworkManager())
        viewModel.characters = [MockData.mockCharacter] // preload

        viewModel.fetchCharacters(for: "") // simulate empty search

        XCTAssertTrue(viewModel.characters.isEmpty)
    }
}
