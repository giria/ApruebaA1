//
//  SearchView.swift
//  Guess
//
//  Created by joan Barrull on 11/04/2025.
//

import SwiftUI
struct SearchView: View {
    enum FocusField: Hashable {
        case field
    }
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    let flashcards: [Flashcard] = CSVLoader.loadFlashcards(from: "kv")
    
    var filteredCards: [Flashcard] {
        if searchText.isEmpty {
            return []
        }
        return flashcards.filter {
            $0.front.localizedCaseInsensitiveContains(searchText) ||
            $0.back.localizedCaseInsensitiveContains(searchText) ||
            $0.hashtag.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search flashcards...", text: $searchText)
                        .padding(10)
                        .padding(.leading, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    //
                        .focused($isFocused)
                        .task {
                            self.isFocused = true
                        }
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                
                                if !searchText.isEmpty {
                                    Button(action: {
                                        withAnimation {
                                            searchText = ""
                                            // Dismiss the keyboard
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                    .transition(.opacity)
                                }
                            }
                        )
                        .animation(.easeInOut(duration: 0.2), value: searchText)
                }
                .padding()
                .padding(.horizontal)
                
                List(filteredCards) { card in
                    VStack(alignment: .leading) {
                        Text("Front: \(card.front)").font(.headline)
                        Text("Back: \(card.back)").font(.subheadline)
                        Text("Tag: #\(card.hashtag)").font(.caption).foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Search")
            
        }
    }
    
}
