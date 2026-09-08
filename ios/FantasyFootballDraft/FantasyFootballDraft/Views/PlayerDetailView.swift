import SwiftUI

struct PlayerDetailView: View {
    let player: Player
    @Binding var note: String
    let onSaveNote: (String) -> Void
    let onToggleDrafted: () -> Void
    
    @State private var isEditingNote = false
    @State private var selectedTags: Set<String> = []
    @State private var tempNote = ""
    @Environment(\.dismiss) var dismiss
    
    let allTags = [
        "Target", "Value", "2nd-Year", "3rd-Year", "Servicable", "Upside",
        "Rookie", "Price has to be Right", "High-Floor / Low Ceiling",
        "Limited Upside", "TD Regression to Mean", "Stash", "Lottery Ticket",
        "Handcuff", "Reach", "Avoid"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(player.playerName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 12) {
                                    Label(player.position, systemImage: "person.fill")
                                        .font(.headline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue)
                                        .cornerRadius(6)
                                    
                                    Label(player.nflTeam, systemImage: "building.2.fill")
                                        .font(.headline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.purple)
                                        .cornerRadius(6)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Stats Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Statistics")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(label: "ADP", value: player.adp > 0 ? String(format: "%.1f", player.adp) : "N/A")
                            StatCard(label: "Age", value: player.age.map { String($0) } ?? "N/A")
                            StatCard(label: "Air Yards", value: String(format: "%.0f", player.airYards))
                            StatCard(label: "WOPR", value: String(format: "%.2f", player.wopr))
                            StatCard(label: "Rush Attempts", value: String(player.rushAttempts))
                            StatCard(label: "Yards/Carry", value: String(format: "%.2f", player.yardsPerCarry))
                            StatCard(label: "Touchdowns", value: String(player.tds))
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Notes")
                                .font(.headline)
                            Spacer()
                            Button(action: { isEditingNote = true }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if !note.isEmpty {
                            Text(note)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.tertiarySystemBackground))
                                .cornerRadius(8)
                        } else {
                            Text("No notes yet")
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Tag Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tags")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(allTags, id: \.self) { tag in
                                Button(action: { toggleTag(tag) }) {
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity)
                                        .background(selectedTags.contains(tag) ? (tagColors[tag] ?? Color.gray) : Color(UIColor.tertiarySystemBackground))
                                        .foregroundColor(selectedTags.contains(tag) ? .white : .primary)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: onToggleDrafted) {
                            HStack {
                                Image(systemName: player.isDrafted ? "checkmark.circle.fill" : "circle")
                                Text(player.isDrafted ? "Mark as Available" : "Mark as Drafted")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(player.isDrafted ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $isEditingNote) {
                NoteEditingView(
                    playerName: player.playerName,
                    note: $tempNote,
                    onSave: { updatedNote in
                        onSaveNote(updatedNote)
                        isEditingNote = false
                    }
                )
            }
            .onAppear {
                tempNote = note
            }
        }
    }
    
    private func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(8)
    }
}

struct NoteEditingView: View {
    let playerName: String
    @Binding var note: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $note)
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        onSave(note)
                        dismiss()
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Edit Note for \(playerName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlayerDetailView(
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
        note: .constant("Great value at this ADP"),
        onSaveNote: { _ in },
        onToggleDrafted: { }
    )
}
