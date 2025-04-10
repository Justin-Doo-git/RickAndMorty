//
//  CharacterDetailView.swift
//  RickAndMortySearch
//
//  Created by Justin Doo on 4/10/25.
//

import SwiftUI
import Foundation

struct CharacterDetailView: View {
    let character: Character
    var onDismiss: () -> Void
    
    
    var body: some View {
        ScrollView {
        
            VStack(alignment: .leading, spacing: 16) {
                
                //Dismiss Button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            onDismiss()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                
                //Header
                Text(character.name)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                
                //Character Image
                AsyncImage(url: URL(string: character.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Full image of \(character.name)")
                
                //Character Details
                Text("Species: \(character.species)")
                Text("Status: \(character.status)")
                Text("Origin: \(character.origin.name)")
                
                if !character.type.isEmpty {
                    Text("Type: \(character.type)")
                }
                
                if let formattedDate = dateFormatter(date: character.created) {
                    Text("Created: \(formattedDate)")
                }
                
                //Share Link
                if let url = URL(string: character.image) {
                    ShareLink(item: url,
                              message: Text("Check out \(character.name) from Rick & Morty!"))
                    .padding(.top)
                }
            }
            .padding()
        }
    }
}


func dateFormatter(date: String) -> String? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let parsedDate = isoFormatter.date(from: date) else {
        return nil
    }

    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none

    return formatter.string(from: parsedDate)
}


struct CharacterDetailView_Previews: PreviewProvider {

    static var previews: some View {
        CharacterDetailView(character: MockData.mockCharacter, onDismiss: {})
    }
}

