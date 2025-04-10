//
//  CharacterViewModel.swift
//  RickAndMortySearch
//
//  Created by Justin Doo on 4/9/25.
//

import Foundation
import Combine

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var statusFilter: String = ""
    @Published var speciesFilter: String = ""
    @Published var typeFilter: String = ""
    @Published var showFilterAlert: Bool = false

    private let networkManager: NetworkService
    private var cancellables = Set<AnyCancellable>()

    init(networkManager: NetworkService = NetworkManager.shared) {
        self.networkManager = networkManager
        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest4(
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main).removeDuplicates(),
            $statusFilter.debounce(for: .milliseconds(300), scheduler: RunLoop.main).removeDuplicates(),
            $speciesFilter.debounce(for: .milliseconds(300), scheduler: RunLoop.main).removeDuplicates(),
            $typeFilter.debounce(for: .milliseconds(300), scheduler: RunLoop.main).removeDuplicates()
        )
        .sink { [weak self] (text, status, species, type) in
            guard let self = self else { return }

            // Show alert if filters are used without a main search term
            if text.isEmpty && (!status.isEmpty || !species.isEmpty || !type.isEmpty) {
                self.showFilterAlert = true
                return
            }

            self.fetchCharacters(for: text)
        }
        .store(in: &cancellables)
    }


    func fetchCharacters(for query: String) {
        guard !query.isEmpty else {
            self.characters = []
            return
        }

        var components = URLComponents(string: "https://rickandmortyapi.com/api/character/")
        var queryItems = [URLQueryItem(name: "name", value: query)]

        if !statusFilter.isEmpty {
            queryItems.append(URLQueryItem(name: "status", value: statusFilter))
        }
        if !speciesFilter.isEmpty {
            queryItems.append(URLQueryItem(name: "species", value: speciesFilter))
        }
        if !typeFilter.isEmpty {
            queryItems.append(URLQueryItem(name: "type", value: typeFilter))
        }

        components?.queryItems = queryItems

        guard let url = components?.url else {
            print("Invalid URL")
            return
        }

        isLoading = true

        networkManager.fetch(url: url) { (result: Result<CharacterResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.characters = response.results
                case .failure(let error):
                    print("Error fetching characters: \(error.localizedDescription)")
                    self.characters = []
                }
            }
        }
    }
}
