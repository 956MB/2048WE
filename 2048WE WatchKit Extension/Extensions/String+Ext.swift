//
//  String+Ext.swift
//  2048WE
//
//  Created by Trevor Bays on 5/12/22.
//

import Foundation

extension String {

    /// Returns translated string based on localized language
    /// - Returns: String
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    /// Returns translated string from supplied language code
    /// - Parameter lang: language code, String
    /// - Returns: String
    func localizedSpecific(_ lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    /// Returns truncated version of supplied string with supplied length
    /// - Parameters:
    ///   - length: string truncate length, Int
    ///   - trailing: string trailing text, String
    /// - Returns: String
    func truncate(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
