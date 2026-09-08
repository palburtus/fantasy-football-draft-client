import Foundation

struct Constants {
    
    // MARK: - App Info
    static let appName = "Fantasy Football Draft"
    static let appVersion = "1.0"
    
    // MARK: - Firebase
    static let firestoreNotesCollection = "notes"
    
    // MARK: - Data
    static let availableYears = [2020, 2021, 2022, 2023, 2024, 2025, 2026]
    static let defaultYear = 2026
    static let supportedPositions = ["QB", "RB", "WR", "TE", "K", "DEF"]
    
    // MARK: - UI
    static let cornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 8
    static let smallCornerRadius: CGFloat = 6
    static let standardPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    // MARK: - Animation
    static let standardAnimation: Animation = .easeInOut(duration: 0.3)
    
    // MARK: - Limits
    static let maxPlayerSearchResults = 500
    static let playerListRowHeight: CGFloat = 120
    
    // MARK: - Firestore Document Limits
    static let maxNotesPerPlayer = 1
    static let maxTagsPerNote = 10
}
