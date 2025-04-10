//
//  CharacterSearchView.swift
//  RickAndMortySearch
//
//  Created by Justin Doo on 4/9/25.
//

import SwiftUI

struct CharacterSearchView: View {
    @StateObject private var viewModel = CharacterViewModel()
    @State private var selectedCharacter: Character?

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Searchbar
                    TextField("Search characters...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .accessibilityLabel("Search field")

                    // Filters
                    HStack {
                        TextField("Status", text: $viewModel.statusFilter)
                        TextField("Species", text: $viewModel.speciesFilter)
                        TextField("Type", text: $viewModel.typeFilter)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .accessibilityElement(children: .combine)

                    // Loading
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                            .accessibilityLabel("Loading results")
                    }

                    // Character list
                    List(viewModel.characters) { character in
                        Button {
                            withAnimation(.easeInOut) {
                                selectedCharacter = character
                            }
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: character.image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .opacity(selectedCharacter?.id == character.id ? 0 : 1)

                                Text(character.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
                .navigationTitle("Rick & Morty Search")
                .alert(isPresented: $viewModel.showFilterAlert) {
                    Alert(
                        title: Text("Search Required"),
                        message: Text("Please enter a main character name before using filters."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }

            //Overlay detail view on top
            if let selected = selectedCharacter {
                CharacterDetailView(character: selected,
                                    onDismiss: {selectedCharacter = nil})
                    .background(Color(.systemBackground))
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation {
                            selectedCharacter = nil
                        }
                    }
            }
        }
    }
}



#Preview {
    CharacterSearchView()
}
