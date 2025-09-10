//
//  Content3.swift
//  Aprueba A1
//
//  Created by joan Barrull on 22/04/2025.
//

import SwiftUI

struct CSVData {
    let headers: [String]
    var rows: [[String]]
}

@Observable
class CSVViewModel3 {
    var csvData = CSVData(headers: [], rows: [])
    var errorMessage: String?
    var isLoading = false
    
    private let csvURL = URL(string: "https://docs.google.com/spreadsheets/d/1TOHH5HbEKL0hATDbQ70Hl5692RjKsG-kMZtY4v8tEJM/export?format=csv")!
    
    func fetchCSV() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: csvURL)
            let csvString = String(decoding: data, as: UTF8.self)
            csvData = parseCSV(csvString)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func parseCSV(_ string: String) -> CSVData {
        let lines = string.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard !lines.isEmpty else { return CSVData(headers: [], rows: []) }
        
        let headers = lines[0].components(separatedBy: ",")
        var rows = [[String]]()
        
        for line in lines.dropFirst() {
            let columns = line.components(separatedBy: ",")
            rows.append(columns)
        }
        
        return CSVData(headers: headers, rows: rows)
    }
}

struct ContentView3: View {
    @State private var viewModel = CSVViewModel3()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading CSV data...")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView("Error Loading Data",
                                          systemImage: "exclamationmark.triangle",
                                          description: Text(error))
                } else {
                    List {
                      //  Section(header: headerView) {
                        Section(header: Text("hello")) {
                            ForEach(viewModel.csvData.rows.indices, id: \.self) { index in
                                rowView(for: viewModel.csvData.rows[index])
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("CSV Viewer")
            .refreshable {
                await viewModel.fetchCSV()
            }
        }
        .task {
            await viewModel.fetchCSV()
        }
    }
    
    private var headerView: some View {
        HStack {
            ForEach(viewModel.csvData.headers, id: \.self) { header in
                Text(header)
                    .fontWeight(.bold)
                Spacer()
            }
        }
    }
    
    private func rowView(for columns: [String]) -> some View {
        HStack {
            ForEach(columns, id: \.self) { column in
                Text(column)
                Spacer()
            }
        }
    }
}
