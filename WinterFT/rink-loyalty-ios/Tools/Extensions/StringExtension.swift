//
//  StringExtension.swift
//  Tools
//
//  Created by Rinat Mukhammetzyanov on 01.01.2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import Foundation

public extension String {

    // MARK: - Instance Methods

    public func localized(tableName: String? = nil, comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: comment)
    }

    // MARK: -

    public func prefix(count: Int) -> String {
        return ((self.count > count) ? String(self[..<self.index(self.startIndex, offsetBy: count)]) : self)
    }

    public func suffix(from index: Int) -> String {
        return ((self.count > index) ? String(self[self.index(self.startIndex, offsetBy: index)...]) : "")
    }
}
