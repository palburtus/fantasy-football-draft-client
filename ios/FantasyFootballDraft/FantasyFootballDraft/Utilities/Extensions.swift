import Foundation
import Combine

extension NotificationCenter {
    static let playerUpdated = NSNotification.Name("PlayerUpdated")
    static let notesUpdated = NSNotification.Name("NotesUpdated")
}

// MARK: - Observable Extensions
extension Binding {
    func onUpdate(_ block: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                block()
            }
        )
    }
}

// MARK: - String Extensions
extension String {
    var initials: String {
        self.split(separator: " ")
            .prefix(2)
            .map { String($0.first ?? " ") }
            .joined()
            .uppercased()
    }
}

// MARK: - Array Extensions
extension Array where Element: Hashable {
    mutating func toggle(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        } else {
            append(element)
        }
    }
}
