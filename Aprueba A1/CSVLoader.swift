//
//  CSVLoader.swift
//  Guess
//
//  Created by joan Barrull on 29/03/2025.
//

import Foundation






struct Flashcard: Identifiable {
    let id = UUID()
    let front: String
    let back: String
    let hashtag: String
}

struct CSVLoader {

    struct CSVEntry {
        let key: String
        let value: String
        let hashtag: String
    }
    
// // new
//   static  func loadStringFromURL()  -> String {
//         var st: String = ""
//        let csvURL = URL(string: "https://docs.google.com/spreadsheets/d/1TOHH5HbEKL0hATDbQ70Hl5692RjKsG-kMZtY4v8tEJM/export?format=csv")!
//            do {
//                let session: URLSession = URLSession(configuration: .ephemeral)
//                Task {
//                    let (data, _) = try await session.data(from: csvURL)
//                    st =  String(decoding: data, as: UTF8.self)
//                }
//               
//            } catch {
//                print( error.localizedDescription)
//               
//            }
//           return st
//        }
//    
//    
//  static func loadFlashcardsFromURL()  -> [Flashcard] {
//      func parseCSVLine(_ line: String) -> [String] {
//          var fields = [String]()
//          var currentField = ""
//          var insideQuotes = false
//          var i = line.startIndex
//          
//          while i < line.endIndex {
//              let char = line[i]
//              if char == "\"" {
//                  if insideQuotes {
//                      let nextIndex = line.index(after: i)
//                      if nextIndex < line.endIndex && line[nextIndex] == "\"" {
//                          currentField += "\""
//                          i = nextIndex // Skip the next quote
//                      } else {
//                          insideQuotes = false
//                      }
//                  } else {
//                      insideQuotes = true
//                  }
//              } else if char == "," && !insideQuotes {
//                  fields.append(currentField)
//                  currentField = ""
//              } else {
//                  currentField.append(char)
//              }
//              i = line.index(after: i)
//          }
//          fields.append(currentField)
//          return fields
//      }
//      do {
//         let stringFromURL =  loadStringFromURL()
//          let lines = stringFromURL.components(separatedBy: .newlines)
//          var result = [Flashcard]()
//          
//          for line in lines {
//              let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
//              guard !trimmedLine.isEmpty else { continue }
//              
//              let fields = parseCSVLine(trimmedLine)
//              guard fields.count == 3 else {
//                  print("Skipping invalid line (expected 3 fields): \(line)")
//                  continue
//              }
//              
//              let front = fields[0].trimmingCharacters(in: .whitespacesAndNewlines)
//              let back = fields[1].trimmingCharacters(in: .whitespacesAndNewlines)
//              let hashtag = fields[2].trimmingCharacters(in: .whitespacesAndNewlines)
//              
//              result.append(Flashcard(front: front , back:  back , hashtag: hashtag))
//          }
//          
//          return result
//      } catch {
//          print("Error reading CSV: \(error)")
//          return []
//      }
//      
//      
//      
//      
//        
//    }
    

    
    
   
    
    
    
    
    static   func loadFlashcards(from filename: String) -> [Flashcard] {
        func parseCSVLine(_ line: String) -> [String] {
            var fields = [String]()
            var currentField = ""
            var insideQuotes = false
            var i = line.startIndex
            
            while i < line.endIndex {
                let char = line[i]
                if char == "\"" {
                    if insideQuotes {
                        let nextIndex = line.index(after: i)
                        if nextIndex < line.endIndex && line[nextIndex] == "\"" {
                            currentField += "\""
                            i = nextIndex // Skip the next quote
                        } else {
                            insideQuotes = false
                        }
                    } else {
                        insideQuotes = true
                    }
                } else if char == "," && !insideQuotes {
                    fields.append(currentField)
                    currentField = ""
                } else {
                    currentField.append(char)
                }
                i = line.index(after: i)
            }
            fields.append(currentField)
            return fields
        }
        
        guard let path = Bundle.main.url(forResource: filename, withExtension: "csv") else {
            print("CSV file not found")
            return []
        }
        
        do {
            let data = try String(contentsOf: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            var result = [Flashcard]()
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedLine.isEmpty else { continue }
                
                let fields = parseCSVLine(trimmedLine)
                guard fields.count == 3 else {
                    print("Skipping invalid line (expected 3 fields): \(line)")
                    continue
                }
                
                let front = fields[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let back = fields[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let hashtag = fields[2].trimmingCharacters(in: .whitespacesAndNewlines)
                
                result.append(Flashcard(front: front , back:  back , hashtag: hashtag))
            }
            
            return result
        } catch {
            print("Error reading CSV: \(error)")
            return []
        }
    }
    
}
