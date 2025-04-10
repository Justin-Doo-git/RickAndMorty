//
//  MockNetworkManager.swift
//  RickAndMortySearchTests
//
//  Created by Justin Doo on 4/10/25.
//

import Foundation
@testable import RickAndMortySearch

class MockNetworkManager: NetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let mockResponse = CharacterResponse(results: [MockData.mockCharacter])
        completion(.success(mockResponse as! T))
    }
}
