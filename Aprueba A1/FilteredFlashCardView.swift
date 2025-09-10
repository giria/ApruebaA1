//
//  FilteredFlashCardView.swift
//  Guess
//
//  Created by joan Barrull on 09/04/2025.
//

import Foundation
import SwiftUI

struct FilteredFlashcardView: View {
    @State private var flashcards: [Flashcard] = CSVLoader.loadFlashcards(from: "kv")
   
    let hashtag: String?
        @State private var flippedStates: [Bool]

        init(flashcards: [Flashcard], hashtag: String?) {
            self.flashcards = flashcards
            self.hashtag = hashtag

            let filtered = hashtag == "Todos" ? flashcards : flashcards.filter { $0.hashtag == hashtag }
            self._flippedStates = State(initialValue: Array(repeating: false, count: filtered.count))
        }

        var body: some View {
            let filtered = flashcards.enumerated().filter {
                hashtag == "Todos" || $0.element.hashtag == hashtag
            }

            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(filtered.enumerated()), id: \.element.offset) { index, pair in
                        ZStack(alignment: .bottomTrailing) {
                            CardView(
                                text: flippedStates[index] ? pair.element.back : pair.element.front,
                                isFlipped: flippedStates[index]
                            )
                            .onTapGesture {
                                withAnimation {
                                    flippedStates[index].toggle()
                                }
                            }

                            // 📌 Hashtag label inside the card
                           // if !pair.element.hashtag.isEmpty {
                                Text("\(pair.element.hashtag)")
                                    .font(.caption2)
                                    .padding(6)
                                    .background(Color(UIColor.systemGray5))
                                    .foregroundColor(.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .padding(8)
                           // }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(hashtag == "Todos" ? "Todos los temas" : "#\(hashtag!)")
        }
    }
