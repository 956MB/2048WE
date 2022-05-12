//
//  ContentView.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 5/10/22.
//

import SwiftUI
import WatchKit

struct ContentView: View {

    @StateObject var def = DefaultsManager.shared
    @StateObject var gameState = GameState.shared

    @State var gameScreenActive : Bool = true
    @State var menuScreenActive : Bool = false
    @State var endScreenActive : Bool = false
    @State var clearSavesActive : Bool = false
    @State var gameScore : Int = 0
    @State var gameMoves : Int = 0
    @State var gameMerges : Int = 0
    @State var gameBoard = freshBoard()
    @State var menuIndex : Int = 1
    @State var leftTitle : String = "local_score".localized()
    @State var rightTitle : String = "\(0)"

    private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    @State var mergeNs : [MergeN] = [ MergeN(0, "local_0s".localized(), 0), MergeN(2, "local_2s".localized(), 0), MergeN(4, "local_4s".localized(), 0), MergeN(8, "local_8s".localized(), 0), MergeN(16, "local_16s".localized(), 0), MergeN(32, "local_32s".localized(), 0), MergeN(64, "local_64s".localized(), 0), MergeN(128, "local_128s".localized(), 0), MergeN(256, "local_256s".localized(), 0), MergeN(512, "local_512s".localized(), 0), MergeN(1024, "local_1024s".localized(), 0), MergeN(2048, "local_2048s".localized(), 0), MergeN(4096, "local_4096s".localized(), 0), MergeN(8192, "local_8192s".localized(), 0), MergeN(16384, "local_16384s".localized(), 0), MergeN(32768, "local_32768s".localized(), 0), MergeN(65536, "local_65536s".localized(), 0), MergeN(131072, "local_131072s".localized(), 0) ]

    var body: some View {

        VStack {
            if (self.gameScreenActive) {
                // MARK: - Game screen
                VStack {
                    MBoard(gameBoard)
                }
                .edgesIgnoringSafeArea(.bottom)
                .gesture(
                    // LONG PRESS TO OPEN MENU
                    LongPressGesture(minimumDuration: 1.0)
                        .onEnded { _ in
                            self.toggleScreen(&self.menuScreenActive, "local_menu".localized(), "")
                        }
                )
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                     // SWIPE TO PLAY
                    .onEnded { value in
                        switch(value.translation.width, value.translation.height) {
                            case (...0, -30...30):    moveDir(0, 3, 1, Dir.Horizontal) // left
                            case (0..., -30...30):    moveDir(3, 0, -1, Dir.Horizontal) // right
                            case (-100...100, ...0):  moveDir(0, 3, 1, Dir.Vertical) // up
                            case (-100...100, 0...):  moveDir(3, 0, -1, Dir.Vertical) // down
                            default:                  break
                        }
                    }
                )
            } else if (self.endScreenActive) {
                // MARK: - End screen
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                MBox(title: "local_score".localized(), value: "\(self.gameScore)", textColor: -1)
                            }
                            LazyVGrid(columns: twoColumnGrid) {
                                MBox(title: "local_best".localized(), value: "\(self.def.bestScore)", textColor: -1)
                                MBox(title: "local_moves".localized(), value: "\(self.gameMoves)", textColor: -1)
                                MBox(title: "local_merges".localized(), value: "\(self.gameMerges)", textColor: -1)
                                ForEach(self.mergeNs) { merge in
                                    if (merge.value >= 1) {
                                        MBox(title: merge.title, value: "\(merge.value)", textColor: merge.num)
                                    }
                                }
                            }
                        }
                    }
                    MButton(text: "local_tryagain".localized(), action: { self.gameRestart() })
                }
                .edgesIgnoringSafeArea(.bottom)
            } else if (self.menuScreenActive) {
                TabView(selection: self.$menuIndex) {
                    // MARK: - SAVED BEST SCORES PAGE
                    VStack {
                        if (self.def.savedScores.count >= 1) {
                            ScrollView {
                                VStack {
                                    ForEach(self.def.savedScores) { score in
                                        MSaved(score)
                                    }
                                    MButton(text: "local_clearscores".localized(), action: { self.clearSavesActive.toggle() })
                                        .background(.red)
                                        .cornerRadius(6)
                                        .padding(.top, 5)
                                }
                            }
                        } else {
                            Text("local_nosaves".localized())
                                .opacity(0.7)
                        }
                    }
                    .tag(0)
                    .confirmationDialog("local_delete".localized(), isPresented: self.$clearSavesActive) {
                        MButton(text: "local_clear".localized(), action: { self.def.clearSavedScores() })
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    } message: {
                        Text("local_deleteconfirm".localized())
                    }
                    // MARK: - MAIN MENU PAGE
                    VStack {
                        MButton(text: "local_continue".localized(), action: { self.toggleScreen(&self.gameScreenActive, "local_score".localized(), "\(self.gameScore)") })
                        MButton(text: "local_restart".localized(), action: { self.gameRestart() })
                        MButton(text: "local_howtoplay".localized(), action: {  })
                            .disabled(true)
                            .opacity(0.7)
                    }.padding(.top, 5).tag(1)
                    // MARK: - CHALLENGES PAGE (or something else idk yet)
                    Text("Third")
                        .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .onChange(of: self.menuIndex) { idx in
                    // TODO: slow? slow changing?
                    self.leftTitle = (idx == 0 ? "local_top".localized() : "local_menu".localized())
                }
            }
        }
        /// LOAD: Sets score, moves, and board to saved values from DefaultManager
        .onAppear {
            self.gameScore = self.def.currentScore
            self.gameMoves = self.def.currentMoves
            self.gameBoard = self.def.currentBoard
            self.updateGameStateObject()
            self.rightTitle = "\(self.gameScore)"
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: - POTENTIAL HACK, setting confirmationAction position (right side) to empty hstack, the clock in the right is gone?? NOPE! the clock can be hidden, but i cant figure out how to make the nav bar background color clear so contents behind it arent blocked
//            Spacer() // TODO: - WORKAROUND, toolbar bar leading space is a fixed width, so the whole hstack needs as much space to the right as possible
            ToolbarItem(placement: .cancellationAction) {
                HStack {
                    Spacer()
                    MTitle(text: self.$leftTitle, dim: true)
                }
                .padding(.leading, (self.endScreenActive || self.menuScreenActive) ? 105 : 0)
            }
            // TODO: BUG, right text holding score for some reason is a little bit lower than it should be when its reset to 0, and until the score goes above 10
            ToolbarItem(placement: .confirmationAction) {
                HStack {
                    Spacer()
                    MTitle(text: self.$rightTitle, dim: false)
                }
                .padding(.trailing, 20) // TODO: - WORKAROUND, need to give more padding than i want to make text not run off the right side BECAUSE FOR SOME REASON IT WILL NOT ALIGN RIGHT
            }
        }
    }

    /// Applies move in specified direction (Dir) on board
    /// - Parameters:
    ///   - start: Start index of row loop (Int)
    ///   - end: End index of row loop (Int)
    ///   - incr: Row loop increment value (Int, 1/-1)
    ///   - dir: Direction of swipe move (Dir, Vertical/Horizontal)
    func moveDir(_ start: Int, _ end: Int, _ incr: Int, _ dir: Dir) {
        self.gameMoves += 1
        
        for row in 0...3 {
            var useRow = self.gameBoard[row]
            if (dir == Dir.Vertical) { useRow = [self.gameBoard[0][row], self.gameBoard[1][row], self.gameBoard[2][row], self.gameBoard[3][row]] }
            var highestMerge = 0

            for _ in 0...3 {
                for cell in stride(from: start, to: end, by: incr) {
                    if (cell+incr > 3 || cell+incr < 0) { break }

                    let curr = useRow[cell]
                    let check = useRow[cell+incr]
                    if (curr == 0) { slide(&useRow, cell, incr) }
                    if (curr == check) { merge(&useRow, cell, incr, curr, &highestMerge) }
                }
            }
            if (dir == Dir.Vertical) {
                self.gameBoard[0][row] = useRow[0]
                self.gameBoard[1][row] = useRow[1]
                self.gameBoard[2][row] = useRow[2]
                self.gameBoard[3][row] = useRow[3]
            } else {
                self.gameBoard[row] = useRow
            }
        }

        // NEW RANDOM TILE SPAWN
        var reduced = self.gameBoard.reduce([], +)
        // TODO: - Game should not end if there are still possible moves on the board, right now the game ends if there are no 0 spots on the board
        let zeros_idx = (reduced.indexes(ofItemsNotEqualTo: 0) ?? []) as [Int]
        guard zeros_idx.count > 0 else {
            self.endGame()
            return
        }

        reduced[zeros_idx.randomElement()!] = [2,4].randomElement()!
        self.gameBoard = form2D(values: reduced)

        self.updateGameStateObject()
    }

    /// Merges current and following cells in row if merge is valid
    /// - Parameters:
    ///   - row: Current row (inout [Int])
    ///   - cell: Current cell in current row (Int)
    ///   - increment: Next following cell in current row (Int)
    ///   - value: Value inside current cell (Int)
    ///   - hMerge: Current highest merge value in row (inout Int)
    func merge(_ row: inout [Int], _ cell: Int, _ increment: Int, _ value: Int, _ hMerge: inout Int) {
        if (hMerge < value) {
            row[cell] = value*2
            row[cell+increment] = 0
            self.gameScore += value*2
            self.gameMerges += 1
            self.rightTitle = "\(self.gameScore)"
//            self.mergeNs[value*2]?.1 += 1
            if let mergeItem = self.mergeNs.firstIndex(where: { $0.num == value*2 }) {
                self.mergeNs[mergeItem].value += 1
            }
            hMerge = value*2
        }
    }
    /// Slides following cell into current cell position
    /// - Parameters:
    ///   - row: Current row (inout [Int])
    ///   - cell: Current cell in current row (Int)
    ///   - increment: Next following cell in current row (Int)
    func slide(_ row: inout [Int], _ cell: Int, _ increment: Int) {
        row[cell] = row[cell+increment]
        row[cell+increment] = 0
    }


    /// Closes all screens then sets supplied screen to active, sets left and right toolbar titles with supplied (String), (String)
    /// - Parameters:
    ///   - toggleScreen: Screen to activate (Bool)
    ///   - lTitle: Left toolbar title text (String)
    ///   - rTitle: Right toolbar title text (String)
    func toggleScreen(_ toggleScreen: inout Bool, _ lTitle: String, _ rTitle: String) {
        self.gameScreenActive = false
        self.endScreenActive = false
        self.menuScreenActive = false
        self.clearSavesActive = false
        self.leftTitle = lTitle
        self.rightTitle = rTitle
        toggleScreen = true
    }
    /// Restarts game by refreshing board, setting score to 0, setting moves to 0, and activates main game screen
    func gameRestart() {
        self.gameBoard = freshBoard()
        self.gameScore = 0
        self.gameMoves = 0
        self.toggleScreen(&self.gameScreenActive, "local_score".localized(), "\(self.gameScore)")
        self.updateGameStateObject()
        self.def.saveGameState(self.gameScore, self.gameMoves, self.gameBoard)
    }
    /// Ends game by switching to the end screen, then sending current game state to Defaults to save score
    func endGame() {
        self.toggleScreen(&self.endScreenActive, "local_gameover".localized(), "")
        self.def.addSavedScore(self.gameScore, self.gameMoves, self.gameBoard.reduce([], +))
        self.gameState.endActive = self.endScreenActive
        self.def.saveGameState(0, 0, freshBoard())
    }

    /// Updates StateObject GameState with all current game state values
    func updateGameStateObject() {
        self.gameState.currentScore = self.gameScore
        self.gameState.currentMoves = self.gameMoves
        self.gameState.currentBoard = self.gameBoard
        self.gameState.endActive = self.endScreenActive
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
