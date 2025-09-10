//
//  Content2.swift
//  Aprueba A1
//
//  Created by joan Barrull on 21/04/2025.
//
    
import SwiftUI

struct Content2: View {
    @State private var viewModel = CSVViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.rows, id: \.self) { row in
                VStack() {
                    ForEach(row, id: \.self) { column in
                        Text(column)
                    }
                }
            }
            .navigationTitle("CSV Reader")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .task {
            await viewModel.loadCSV()
        }
    }
}

@MainActor
@Observable
class CSVViewModel {
    var rows: [[String]] = []
    var isLoading = false
    var showError = false
    var errorMessage = ""
    
    let csvURL = URL(string: "https://docs.google.com/spreadsheets/d/1TOHH5HbEKL0hATDbQ70Hl5692RjKsG-kMZtY4v8tEJM/export?format=csv")!
    
    func loadCSV() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: csvURL)
            let csvString = String(decoding: data, as: UTF8.self)
            rows = parseCSV(csvString)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func parseCSV(_ csvString: String) -> [[String]] {
        var result: [[String]] = []
        let rows = csvString.components(separatedBy: "\n")
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
}
