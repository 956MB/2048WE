//
//  DefaultsManager.swift
//  2048WE
//
//  Created by Trevor Bays on 5/12/22.
//

import Foundation

/// Class holding all settings defaults to be used in StickyNotes
class DefaultsManager: ObservableObject {

    static let shared = DefaultsManager()
    let defaults      = UserDefaults.standard

    @Published public var bestScore   : Int = 0
    @Published public var currentScore : Int = 0
    @Published public var currentMoves : Int = 0
    @Published public var currentBoard : [[Int]] = freshBoard()
    @Published public var savedScores : [SavedScore] = []

    /// Inits DefaultsManager variables from saved UserDefaults.standard
    public func initSavedDefaults() {
        // Reset Standard User Defaults
//        if ProcessInfo.processInfo.environment["clear_defaults"] == "true" {
//            UserDefaults.resetStandardUserDefaults()
//        }

        let key_bestScore    = defaults.value(forKey: "key_bestScore") as? Int ?? 0
        let key_currentScore = defaults.value(forKey: "key_currentScore") as? Int ?? 0
        let key_currentMoves = defaults.value(forKey: "key_currentMoves") as? Int ?? 0
        let key_currentBoard = defaults.value(forKey: "key_currentBoard") as? [[Int]] ?? freshBoard()
        let data_savedScores = initSavedScores()

        self.bestScore = key_bestScore
        self.currentScore = key_currentScore
        self.currentMoves = key_currentMoves
        self.currentBoard = key_currentBoard
        self.savedScores = data_savedScores
    }

    /// Sets supplied key in DefaultsManager with supplied value, then saves to UserDefaults.standard
    /// - Parameters:
    ///   - key: Key string (String)
    ///   - value: Value (Any?)
    public func setKeyValue(key: String, value: Any?) {
        switch (key) {
            case "key_bestScore":    self.bestScore    = value as! Int;     break
            case "key_currentScore": self.currentScore = value as! Int;     break
            case "key_currentMoves": self.currentMoves = value as! Int;     break
            case "key_currentBoard": self.currentBoard = value as! [[Int]]; break
            default: break
        }

        defaults.setValue(value, forKey: key)
    }

    /// Checks supplied game score (Int, Int, [Int]) to see if it is new best score, or is high enough score to save in top 5, then saves savedScores list
    /// - Parameters:
    ///   - score: Score to check (Int)
    ///   - moves: Paired game moves (Int)
    ///   - board: Paired game board ([Int])
    public func addSavedScore(_ score: Int, _ moves: Int, _ board: [Int]) {
        do {
            // check if score is new best or top 5
            let newBest = (score > self.bestScore)
            self.savedScores = self.savedScores.sorted(by: { $0.score > $1.score })
            let saveScore = self.savedScores.count <= 4 ? true : (score > self.savedScores.last?.score ?? 0)

            if (newBest) {
                // Set "best" in all saved scores to false if new best is added
                for index in (0 ..< self.savedScores.count) where self.savedScores[index].best == true {
                    self.savedScores[index].best = false
                }
                self.setKeyValue(key: "key_bestScore", value: score)
            }
            if (saveScore) {
                if (self.savedScores.count >= 5) {
                    self.savedScores.removeLast()
                }
                self.savedScores.append(SavedScore(id: UUID(), score: score, moves: moves, board: board, best: newBest))
                self.savedScores = self.savedScores.sorted(by: { $0.score > $1.score })

                let encoder = JSONEncoder()
                let data = try encoder.encode(self.savedScores)
                defaults.set(data, forKey: "key_savedScores")
            }
        } catch {
            print("Unable to Encode SavedScore (\(error))")
        }
    }

    /// Saves entire game state of score, moves and board with supplied (Int), (Int), ([[Int]])
    /// - Parameters:
    ///   - score: Game score to save (Int)
    ///   - moves: Game moves to save (Int)
    ///   - board: Game board to save ([[Int]]])
    public func saveGameState(_ score: Int, _ moves: Int, _ board: [[Int]]) {
        self.setKeyValue(key: "key_currentScore", value: score)
        self.setKeyValue(key: "key_currentMoves", value: moves)
        self.setKeyValue(key: "key_currentBoard", value: board)
    }

    /// Clears saved game scores list and saves DefaultsManager
    public func clearSavedScores() {
        do {
            self.savedScores.removeAll()

            let encoder = JSONEncoder()
            let data = try encoder.encode(self.savedScores)
            defaults.set(data, forKey: "key_savedScores")
        } catch {
            print("Unable to Encode SavedScore (\(error))")
        }
    }

    /// Inits and decodes savedScores list from Defaults
    /// - Returns: Saved scores list ([SavedScore])
    private func initSavedScores() -> [SavedScore] {
        if let data = defaults.data(forKey: "key_savedScores") {
            do {
                let decoder = JSONDecoder()
                let saved = try decoder.decode([SavedScore].self, from: data)
                return saved
            } catch {
                print("Unable to Decode SavedScores (\(error))")
            }
        }
        return []
    }
}
