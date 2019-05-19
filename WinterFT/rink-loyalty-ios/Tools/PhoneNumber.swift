//
//  PhoneNumber.swift
//  Tools
//
//  Created by Rinat Mukhammetzyanov on 31.03.2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import Foundation

public struct PhoneNumber {

    // MARK: - Instance Properties

    public var countryCode: String?

    public let domesticNumber: String
    public var internationalNumber: String?

    // MARK: -

    public var isEmpty: Bool {
        return (self.domesticNumber.count > 1)
    }

    // MARK: - Initializers

    public init(domesticNumber: String, countryCode: String? = nil) {
        self.domesticNumber = domesticNumber
    }

    public init?(internationalNumber: String) {
        let nonDigits = CharacterSet.decimalDigits.inverted

        self.internationalNumber = "+\(internationalNumber.components(separatedBy: nonDigits).joined())"

        guard internationalNumber.count > 1 else {
            return nil
        }

        self.countryCode = internationalNumber.prefix(count: 2)
        self.domesticNumber = internationalNumber.suffix(from: 2)
    }
}

// MARK: - Equatable

extension PhoneNumber: Equatable {

    // MARK: - Type Methods

    public static func == (left: PhoneNumber, right: PhoneNumber) -> Bool {
        return (left.internationalNumber == right.internationalNumber)
    }

    public static func != (left: PhoneNumber, right: PhoneNumber) -> Bool {
        return !(left == right)
    }

    public static func ~= (left: PhoneNumber, right: PhoneNumber) -> Bool {
        return (left == right)
    }
}
