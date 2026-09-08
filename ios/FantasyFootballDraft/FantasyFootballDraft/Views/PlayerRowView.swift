import SwiftUI

struct PlayerRowView: View {
    let player: Player
    let note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.playerName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(player.position)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(4)
                        
                        Text(player.nflTeam)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if player.adp > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "chart.bar")
                            Text(String(format: "ADP: %.1f", player.adp))
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    if !note.isEmpty {
                        Image(systemName: "note.text")
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            // Stats Row
            HStack(spacing: 12) {
                StatBadge(label: "Age", value: player.age.map { String($0) } ?? "-")
                StatBadge(label: "Air Yards", value: String(format: "%.0f", player.airYards))
                StatBadge(label: "WOPR", value: String(format: "%.2f", player.wopr))
                StatBadge(label: "TDs", value: String(player.tds))
                Spacer()
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct StatBadge: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(6)
    }
}

#Preview {
    PlayerRowView(
        player: Player(
            id: "1",
            playerName: "Patrick Mahomes",
            position: "QB",
            nflTeam: "KC",
            adp: 5.2,
            airYards: 0,
            wopr: 0,
            rushAttempts: 0,
            yardsPerCarry: 0,
            tds: 0,
            age: 28
        ),
        note: "Target"
    )
}
