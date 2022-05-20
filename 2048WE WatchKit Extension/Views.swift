//
//  Views.swift
//  2048WE
//
//  Created by Trevor Bays on 5/11/22.
//

import SwiftUI

struct MTile: View {
    var number : Int
    var colors : [UInt]

    var body: some View {
        HStack(alignment: .center) {
            Text(self.number >= 1 ? "\(String(self.number))" : "")
                .foregroundColor(Color(hex: self.colors[1]))
                .fontWeight(.bold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(hex: self.colors[0]))
        .cornerRadius(6)
    }
}

struct MTitle: View {
    @Binding var text : String
    var dim : Bool

    var body: some View {
        Text(self.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: true, vertical: false)
            .opacity(self.dim ? 0.45 : 1.0)
    }
}

struct MToolbarItem: View {
    @Binding var gameScreenActive : Bool
    @Binding var text : String
    var dim : Bool
    var pad : Int

    var body: some View {
        if (self.gameScreenActive) {
            HStack {
                Spacer()
                MTitle(text: self.$text, dim: self.dim)
            }
//            .padding(.leading, (self.endScreenActive || self.menuScreenActive) ? 110 : 0) // 105
            .padding(.leading, self.pad)
        }
    }
}

struct MButton: View {
    var text : String
    var action : () -> Void

    var body: some View {
        Button(action: { self.action() }, label: {
            Text(self.text)
                .padding(10)
        })
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
        .background(.gray.opacity(0.27))
        .cornerRadius(6)
    }
}

struct MBoard: View {
    var board : [[Int]]

    init(_ flatBoard: [Int]) {
        self.board = form2D(values: flatBoard)
    }
    init(_ board: [[Int]]) {
        self.board = board
    }

    var body: some View {
        VStack {
            ForEach(0..<4) { row in
                HStack {
                    ForEach(0..<4) { cell in
                        MTile(number: board[row][cell], colors: cc[board[row][cell]]!)
                    }
                }
            }
        }
    }
}

struct MSaved: View {
    var score : Int
    var moves : Int
    var board : MBoard
    var best : Bool

    init(_ savedScore: SavedScore) {
        self.score = savedScore.score
        self.moves = savedScore.moves
        self.board = MBoard(savedScore.board)
        self.best = savedScore.best
    }

    init(score: Int, moves: Int, board: MBoard, best: Bool) {
        self.score = score
        self.moves = moves
        self.board = board
        self.best = best
    }

    var body: some View {
        VStack {
            VStack(spacing: 4) {
                HStack {
                    Text(self.best ? "local_best".localized() : "local_score".localized())
                        .foregroundColor(self.best ? .orange : .white)
                        .opacity(self.best ? 0.85 : 0.5)
                    Text("\(self.score)")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(self.moves)")
                        .opacity(0.35)
                }
                self.board.frame(height: 128)
            }
            .padding(5)
        }
        .background(.white.opacity(0.12))
        .cornerRadius(6)
    }
}

struct MBox: View {
    var title : String
    var value : String
    var textColor: Int

    var body: some View {
        VStack(spacing: 0) {
            Text(self.title)
                .foregroundColor((textColor == -1 ? .white : Color(hex: cc[textColor]![0])))
                .opacity((textColor == -1 ? 0.5 : 1.0))
            Text(self.value)
                .fontWeight(.bold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.27))
        .cornerRadius(6)
    }
}
