import Foundation

class DraftDataManager: ObservableObject {
    @Published var allPlayers: [Player] = []
    @Published var filteredPlayers: [Player] = []
    
    static let shared = DraftDataManager()
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let jsonData = loadJSON(forYear: 2026) {
            DispatchQueue.main.async {
                self.allPlayers = jsonData
                self.filteredPlayers = jsonData
            }
        }
    }
    
    private func loadJSON(forYear year: Int) -> [Player]? {
        guard let url = Bundle.main.url(forResource: "data_\(year)", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not load data_\(year).json")
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let players = try decoder.decode([Player].self, from: data)
            return players
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func filterPlayers(searchText: String = "", position: Position = .all, showOnlyAvailable: Bool = false) {
        var filtered = allPlayers
        
        // Filter by position
        if position != .all {
            filtered = filtered.filter { $0.position == position.rawValue }
        }
        
        // Filter by availability
        if showOnlyAvailable {
            filtered = filtered.filter { !$0.isDrafted }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { player in
                player.playerName.localizedCaseInsensitiveContains(searchText) ||
                player.nflTeam.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        DispatchQueue.main.async {
            self.filteredPlayers = filtered.sorted { $0.adp < $1.adp }
        }
    }
    
    func toggleDrafted(for player: Player) {
        if let index = allPlayers.firstIndex(where: { $0.id == player.id }) {
            allPlayers[index].isDrafted.toggle()
        }
    }
}
