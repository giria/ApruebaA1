//
//  Settings.swift
//  Guess
//
//  Created by joan Barrull on 11/04/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Sound", isOn: .constant(true))
                    Toggle("Notifications", isOn: .constant(false))
                }
            }
            .navigationTitle("Settings")
        }
    }
}
