//
//  Character.swift
//  RickAndMortySearch
//
//  Created by Justin Doo on 4/9/25.
//

import Foundation

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let origin: Origin
    let image: String
    let created: String
}

struct Origin: Codable {
    let name: String
}

struct CharacterResponse: Codable {
    let results: [Character]
}

struct MockData {
    static var mockCharacter = Character( id: 001, name: "Rick Sanchez", status: "Alive", species: "Human", type: "Scientist", origin: Origin(name: "Earth (C-137)"), image: "Rick", created: "2017-11-04T18:48:46.250Z")
}
