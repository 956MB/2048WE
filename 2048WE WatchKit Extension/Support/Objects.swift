//
//  Objects.swift
//  2048WE
//
//  Created by Trevor Bays on 5/12/22.
//

import Foundation

struct SavedScore: Codable, Identifiable {
    let id: UUID
    let score: Int
    let moves: Int
    let board: [Int]
    var best: Bool
}

public class GameState: ObservableObject {
    static let shared = GameState()

    @Published var currentScore: Int = 0
    @Published var currentMoves: Int = 0
    @Published var currentBoard: [[Int]] = freshBoard()
    @Published var endActive: Bool = false
}

struct MergeN: Identifiable {
    let id: UUID
    let num: Int
    let title: String
    var value: Int

    init(_ nu: Int, _ ti: String, _ va: Int) {
        self.id = UUID()
        self.num = nu
        self.title = ti
        self.value = va
    }
}
