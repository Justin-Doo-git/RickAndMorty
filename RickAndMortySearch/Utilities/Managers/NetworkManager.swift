//
//  NetworkManager.swift
//  RickAndMortySearch
//
//  Created by Justin Doo on 4/9/25.
//

import Foundation

//This is used so we can create unit tests without having to create an instance of the NetworkManager in order to mainitain the singleton pattern
protocol NetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

