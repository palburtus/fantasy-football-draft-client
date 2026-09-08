import Foundation
import FirebaseFirestore

class NotesRepository: ObservableObject {
    private let db = Firestore.firestore()
    
    func loadNotes(for year: Int, completion: @escaping ([String: String]) -> Void) {
        db.collection("notes")
            .whereField("year", isEqualTo: year)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading notes: \(error)")
                    completion([:])
                    return
                }
                
                var notesMap: [String: String] = [:]
                snapshot?.documents.forEach { doc in
                    if let playerName = doc["playerName"] as? String,
                       let note = doc["note"] as? String {
                        notesMap[playerName] = note
                    }
                }
                completion(notesMap)
            }
    }
    
    func saveNote(_ note: String, for playerName: String, year: Int, tags: [String], completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("notes").document("\(year)_\(playerName)")
        
        docRef.setData([
            "playerName": playerName,
            "note": note,
            "tags": tags,
            "year": year,
            "timestamp": Timestamp.now()
        ]) { error in
            completion(error == nil)
        }
    }
    
    func deleteNote(for playerName: String, year: Int, completion: @escaping (Bool) -> Void) {
        db.collection("notes").document("\(year)_\(playerName)").delete { error in
            completion(error == nil)
        }
    }
}
