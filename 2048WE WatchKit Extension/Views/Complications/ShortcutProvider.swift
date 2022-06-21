//
//  ShortcutProvider.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 6/20/22.
//

import Foundation
import ClockKit
import SwiftUI

final class ShortcutProvider {
    func getShortcutGraphicCorner() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicCornerCircularView(ShortcutComplication())
    }
    func getShortcutGraphicCircular() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicCircularView(ShortcutComplication())
    }
}
