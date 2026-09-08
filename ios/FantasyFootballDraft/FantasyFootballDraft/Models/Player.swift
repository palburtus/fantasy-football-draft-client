import Foundation

struct Player: Identifiable, Codable {
    let id: String
    let playerName: String
    let position: String
    let nflTeam: String
    let adp: Double
    let airYards: Double
    let wopr: Double
    let rushAttempts: Int
    let yardsPerCarry: Double
    let tds: Int
    let age: Int?
    var isDrafted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case playerName = "player_name"
        case position
        case nflTeam = "nfl_team"
        case adp
        case airYards = "air_yards"
        case wopr
        case rushAttempts = "rush_attempts"
        case yardsPerCarry = "yards_per_carry"
        case tds = "TDs"
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playerName = try container.decode(String.self, forKey: .playerName)
        position = try container.decode(String.self, forKey: .position)
        nflTeam = try container.decode(String.self, forKey: .nflTeam)
        adp = try container.decodeIfPresent(Double.self, forKey: .adp) ?? 0
        airYards = try container.decodeIfPresent(Double.self, forKey: .airYards) ?? 0
        wopr = try container.decodeIfPresent(Double.self, forKey: .wopr) ?? 0
        rushAttempts = try container.decodeIfPresent(Int.self, forKey: .rushAttempts) ?? 0
        yardsPerCarry = try container.decodeIfPresent(Double.self, forKey: .yardsPerCarry) ?? 0
        tds = try container.decodeIfPresent(Int.self, forKey: .tds) ?? 0
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        id = UUID().uuidString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerName, forKey: .playerName)
        try container.encode(position, forKey: .position)
        try container.encode(nflTeam, forKey: .nflTeam)
        try container.encode(adp, forKey: .adp)
        try container.encode(airYards, forKey: .airYards)
        try container.encode(wopr, forKey: .wopr)
        try container.encode(rushAttempts, forKey: .rushAttempts)
        try container.encode(yardsPerCarry, forKey: .yardsPerCarry)
        try container.encode(tds, forKey: .tds)
        try container.encodeIfPresent(age, forKey: .age)
    }
}

struct PlayerNote: Codable {
    let playerName: String
    let note: String
    let tags: [String]
    let year: Int
}

enum Position: String, CaseIterable {
    case all = "ALL"
    case qb = "QB"
    case rb = "RB"
    case wr = "WR"
    case te = "TE"
    case k = "K"
    case def = "DEF"
    
    var displayName: String {
        return self.rawValue
    }
}

let tagColors: [String: Color] = [
    "Target": Color(red: 0.11, green: 0.37, blue: 0.125),
    "Value": Color(red: 0.30, green: 0.64, blue: 0.31),
    "2nd-Year": Color(red: 0.61, green: 0.80, blue: 0.40),
    "3rd-Year": Color(red: 0.61, green: 0.80, blue: 0.40),
    "Servicable": Color(red: 0.72, green: 0.84, blue: 0.37),
    "Upside": Color(red: 0.83, green: 0.88, blue: 0.34),
    "Rookie": Color(red: 0.08, green: 0.40, blue: 0.75),
    "Price has to be Right": Color(red: 0.08, green: 0.40, blue: 0.75),
    "High-Floor / Low Ceiling": Color(red: 0.08, green: 0.40, blue: 0.75),
    "Limited Upside": Color(red: 1.0, green: 0.70, blue: 0.0),
    "TD Regression to Mean": Color(red: 1.0, green: 0.44, blue: 0.26),
    "Stash": Color(red: 0.45, green: 0.12, blue: 0.67),
    "Lottery Ticket": Color(red: 0.48, green: 0.12, blue: 0.64),
    "Handcuff": Color(red: 0.67, green: 0.28, blue: 0.74),
    "Reach": Color(red: 0.96, green: 0.26, blue: 0.21),
    "Avoid": Color(red: 0.78, green: 0.16, blue: 0.16)
]
