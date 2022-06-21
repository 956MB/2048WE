//
//  ComplicationViews.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 6/20/22.
//

import SwiftUI
import ClockKit

struct ShortcutComplication: View {
    var body: some View {
        VStack {
            Image(systemName: "2048")
        }
    }
}

struct ShortcutComplication_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShortcutComplication()
            CLKComplicationTemplateGraphicCornerCircularView(
                ShortcutComplication()
            ).previewContext()
        }
    }
}
