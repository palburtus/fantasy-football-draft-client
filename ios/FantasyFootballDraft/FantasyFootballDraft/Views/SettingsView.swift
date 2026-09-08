import SwiftUI

struct SettingsView: View {
    @Binding var selectedYear: Int
    @Binding var selectedPosition: Position
    @Binding var showOnlyAvailable: Bool
    
    let years = [2020, 2021, 2022, 2023, 2024, 2025, 2026]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Season") {
                    Picker("Select Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Filters") {
                    Picker("Position", selection: $selectedPosition) {
                        ForEach(Position.allCases, id: \.self) { position in
                            Text(position.displayName).tag(position)
                        }
                    }
                    
                    Toggle("Show Only Available Players", isOn: $showOnlyAvailable)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("App")
                        Spacer()
                        Text("Fantasy Football Draft")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(
        selectedYear: .constant(2026),
        selectedPosition: .constant(.all),
        showOnlyAvailable: .constant(false)
    )
}
