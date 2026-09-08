import SwiftUI

struct DraftBoardView: View {
    let players: [Player]
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(players) { player in
                    NavigationLink(destination: PlayerDetailView(
                        player: player,
                        note: .constant(""),
                        onSaveNote: { _ in },
                        onToggleDrafted: { }
                    )) {
                        DraftCardView(player: player)
                    }
                }
            }
            .padding()
        }
    }
}

struct DraftCardView: View {
    let player: Player
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.playerName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Text(player.position)
                            .font(.caption2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .cornerRadius(3)
                        
                        Text(player.nflTeam)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                if player.isDrafted {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            
            Divider()
            
            HStack(spacing: 4) {
                if player.adp > 0 {
                    Text("ADP: \(String(format: "%.1f", player.adp))")
                        .font(.caption2)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if player.tds > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "touchid")
                        Text(String(player.tds))
                    }
                    .font(.caption2)
                }
            }
            .foregroundColor(.secondary)
            
            Spacer(minLength: 0)
        }
        .frame(height: 140)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .opacity(player.isDrafted ? 0.6 : 1.0)
    }
}

#Preview {
    DraftBoardView(players: [
        Player(
            id: "1",
            playerName: "Patrick Mahomes",
            position: "QB",
            nflTeam: "KC",
            adp: 5.2,
            airYards: 0,
            wopr: 0,
            rushAttempts: 12,
            yardsPerCarry: 4.2,
            tds: 24,
            age: 28
        )
    ])
}
