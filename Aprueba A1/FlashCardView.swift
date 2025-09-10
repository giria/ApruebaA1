//
//  FlashCardView.swift
//  Guess
//
//  Created by joan Barrull on 09/04/2025.
//




import SwiftUI

struct FlashCardView: View {
    let flashcards: [Flashcard] = CSVLoader.loadFlashcards(from: "kv")
   // let flashcards: [Flashcard] = CSVLoader.loadFlashcardsFromURL()
    @State private var searchText: String = ""

    var body: some View {
        let allHashtags = Array(Set(flashcards.map { $0.hashtag })).sorted()
        let allTagsWithAll = ["Todos"] + allHashtags
        let filteredTags = searchText.isEmpty ? allTagsWithAll : allTagsWithAll.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        
        let todos = filteredTags.filter { $0 == "Todos" }
        let otherTags = filteredTags.filter { $0 != "Todos" }

        let columns = [
            GridItem(.adaptive(minimum: 130), spacing: 10)
        ]

        NavigationStack {
            ScrollView {
                VStack {
                    

                    // "Todos" section
                    if !todos.isEmpty {
                        Section(header: Text("").font(.headline).padding(.top)) {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(todos, id: \.self) { tag in
                                    NavigationLink(
                                        destination: FilteredFlashcardView(
                                            flashcards: flashcards,
                                            hashtag: tag == "Todos" ? "Todos" : tag
                                        )
                                    ) {
                                        Text(tag)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }

                    // Other tags section
                    if !otherTags.isEmpty {
                        Section(header: Text("").font(.headline)) {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(otherTags, id: \.self) { tag in
                                    NavigationLink(
                                        destination: FilteredFlashcardView(
                                            flashcards: flashcards,
                                            hashtag: tag == "Todos" ? "Todos" : tag
                                        )
                                    ) {
                                        Text(tag)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Escoge un tema:")
                .navigationViewStyle(StackNavigationViewStyle()) // 👈 Add this line
            }
        }
    }
}



struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 10, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == data.first {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        width += d.width + spacing
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == data.first {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .frame(height: abs(height) + 40)
    }
}


