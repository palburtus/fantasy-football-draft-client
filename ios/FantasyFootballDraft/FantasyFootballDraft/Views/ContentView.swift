import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DraftDataManager.shared
    @StateObject private var notesRepo = NotesRepository()
    
    @State private var searchText = ""
    @State private var selectedPosition: Position = .all
    @State private var showOnlyAvailable = false
    @State private var selectedYear = 2026
    @State private var showPlayerDetail: Bool = false
    @State private var selectedPlayer: Player?
    @State private var notesMap: [String: String] = [:]
    
    let years = [2020, 2021, 2022, 2023, 2024, 2025, 2026]
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            VStack(spacing: 16) {
                // Year Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Season")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedYear) { newYear in
                        loadYearData(newYear)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                // Filters
                VStack(alignment: .leading, spacing: 12) {
                    Text("Filters")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    // Position Filter
                    Menu {
                        ForEach(Position.allCases, id: \.self) { position in
                            Button(position.displayName) {
                                selectedPosition = position
                                applyFilters()
                            }
                        }
                    } label: {
                        HStack {
                            Text("Position: \(selectedPosition.displayName)")
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                    
                    // Availability Toggle
                    Toggle("Show Only Available", isOn: $showOnlyAvailable)
                        .onChange(of: showOnlyAvailable) { _ in
                            applyFilters()
                        }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .frame(idealWidth: 280)
        } content: {
            // Main Content
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search players...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: searchText) { _ in
                            applyFilters()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                // Players List
                ScrollView {
                    LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                        if dataManager.filteredPlayers.isEmpty {
                            VStack {
                                Image(systemName: "person.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No players found")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding()
                        } else {
                            ForEach(dataManager.filteredPlayers) { player in
                                PlayerRowView(player: player, note: notesMap[player.playerName] ?? "")
                                    .onTapGesture {
                                        selectedPlayer = player
                                        showPlayerDetail = true
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Draft Board")
            .sheet(isPresented: $showPlayerDetail) {
                if let player = selectedPlayer {
                    PlayerDetailView(
                        player: player,
                        note: .constant(notesMap[player.playerName] ?? ""),
                        onSaveNote: { updatedNote in
                            notesMap[player.playerName] = updatedNote
                            notesRepo.saveNote(updatedNote, for: player.playerName, year: selectedYear, tags: []) { _ in }
                        },
                        onToggleDrafted: {
                            dataManager.toggleDrafted(for: player)
                        }
                    )
                }
            }
        } detail: {
            if let player = selectedPlayer {
                PlayerDetailView(
                    player: player,
                    note: .constant(notesMap[player.playerName] ?? ""),
                    onSaveNote: { updatedNote in
                        notesMap[player.playerName] = updatedNote
                        notesRepo.saveNote(updatedNote, for: player.playerName, year: selectedYear, tags: []) { _ in }
                    },
                    onToggleDrafted: {
                        dataManager.toggleDrafted(for: player)
                    }
                )
            } else {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Select a player to view details")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            loadYearData(selectedYear)
        }
    }
    
    private func loadYearData(_ year: Int) {
        dataManager.loadData()
        notesRepo.loadNotes(for: year) { notes in
            DispatchQueue.main.async {
                self.notesMap = notes
            }
        }
        applyFilters()
    }
    
    private func applyFilters() {
        dataManager.filterPlayers(
            searchText: searchText,
            position: selectedPosition,
            showOnlyAvailable: showOnlyAvailable
        )
    }
}

#Preview {
    ContentView()
}
