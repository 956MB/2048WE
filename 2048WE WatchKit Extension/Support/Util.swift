//
//  Util.swift
//  2048WE
//
//  Created by Trevor Bays on 5/11/22.
//

import Foundation
import SwiftUI

enum Dir {
    case Vertical
    case Horizontal
}

var cellColors : [Int : [UInt]] = [ 0: [0x212121, 0x898989], 2: [0x313131, 0x898989], 4: [0x565656, 0xBEBEBE], 8: [0xF1B179, 0x0A0A0A], 16: [0xF59563, 0xFFFFFF], 32: [0xF57C5F, 0xFFFFFF], 64: [0xF65E3B, 0xFFFFFF], 128: [0xEBCF72, 0x0A0A0A], 256: [0xEBCF72, 0x0A0A0A], 512: [0xEBCF72, 0x0A0A0A], 1024: [0xECC850, 0x0A0A0A], 2048: [0xECC850, 0x0A0A0A], 4096: [0xF36674, 0x0A0A0A], 8192: [0xEF4B61, 0x0A0A0A], 16384: [0xEB433F, 0x0A0A0A], 32768: [0x73B6DD, 0x0A0A0A], 65536: [0x5EA1E5, 0x0A0A0A], 131072: [0x017DC0, 0x0A0A0A] ]

/// Returns new fresh board with two random (2/4) cells picked
/// - Returns: Starting board ([[Int]])
func freshBoard() -> [[Int]] {
    var zeros = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    let zeros_idx1 = (zeros.indexes(ofItemsNotEqualTo: 0) ?? []) as [Int]
    zeros[zeros_idx1.randomElement()!] = 2
    let zeros_idx2 = (zeros.indexes(ofItemsNotEqualTo: 0) ?? []) as [Int]
    zeros[zeros_idx2.randomElement()!] = [2,4].randomElement()!

    return form2D(values: zeros)
}

/// Forms 2D board ([[Int]]]) from flat array ([Int])
/// - Parameter values: Flat array of Int cells ([Int])
/// - Returns: 2D board ([[Int]])
func form2D<U>(values: [U]) -> [[U]] {
    let pattern = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
    var iter = values.makeIterator()
    return pattern.map { $0.compactMap { _ in iter.next() }}
}

extension Array where Element: Equatable {
    func indexes(ofItemsNotEqualTo item: Element) -> [Int]?  {
        var result: [Int] = []
        for (n, elem) in enumerated() {
            if elem == item {
                result.append(n)
            }
        }
        return result.isEmpty ? nil : result
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
