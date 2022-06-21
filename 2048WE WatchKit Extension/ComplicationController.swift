//
//  ComplicationController.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 5/10/22.
//

import ClockKit


final class ComplicationController: NSObject, CLKComplicationDataSource {

    private lazy var shortcutProvider = ShortcutProvider()
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "2048WE", supportedFamilies: [.graphicCorner, .graphicCircular])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
//        switch complication.family {
//        case .graphicCorner: handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: shortcutProvider.getShortcutGraphicCorner()))
//        case .graphicCircular: handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: shortcutProvider.getShortcutGraphicCircular()))
//        default: handler(nil)
//        }

        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
//        switch complication.family {
//        case .graphicCorner: handler(shortcutProvider.getShortcutGraphicCorner())
//        case .graphicCircular: handler(shortcutProvider.getShortcutGraphicCircular())
//        default: handler(nil)
//        }

        handler(nil)
    }
}
