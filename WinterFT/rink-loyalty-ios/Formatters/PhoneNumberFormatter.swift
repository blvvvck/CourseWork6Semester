//
//  PhoneNumberFormatter.swift
//  rink-loyalty-ios
//
//  Created by Damir Zaripov on 08/09/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import Foundation

class PhoneNumberFormatter {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let countryCode = "+7"
    }

    private enum DomesticNumberFormat: String {

        // MARK: - Enumeration Cases

        case short = "XXX-XXXX"
        case long = "+7 (XXX) XXX-XXXX"

        // MARK: - Instance Properties

        var minCount: Int {
            switch self {
            case .short:
                return 4

            case .long:
                return 8
            }
        }

        var maxCount: Int {
            switch self {
            case .short:
                return 7

            case .long:
                return 11
            }
        }
    }

    // MARK: - Type Properties

    static let shared = PhoneNumberFormatter()

    // MARK: - Instance Methods

    func countryCode(from phoneNumber: PhoneNumber) -> String? {
        return phoneNumber.countryCode
    }

    func domesticNumber(from phoneNumber: PhoneNumber) -> String {
        let format: DomesticNumberFormat

        switch phoneNumber.domesticNumber.count {
        case DomesticNumberFormat.short.minCount...DomesticNumberFormat.short.maxCount:
            format = .short

        case DomesticNumberFormat.long.minCount...DomesticNumberFormat.long.maxCount:
            format = .long

        default:
            if !phoneNumber.domesticNumber.contains(Constants.countryCode) {
                return "\(Constants.countryCode)\(phoneNumber.domesticNumber)"
            } else {
                return phoneNumber.domesticNumber
            }
        }

        var domesticNumber = ""

        var iteratorIndex = phoneNumber.domesticNumber.startIndex

        for character in format.rawValue {
            if iteratorIndex == phoneNumber.domesticNumber.endIndex {
                break
            }

            if character == "X" {
                domesticNumber.append(phoneNumber.domesticNumber[iteratorIndex])

                iteratorIndex = phoneNumber.domesticNumber.index(after: iteratorIndex)
            } else {
                domesticNumber.append(character)
            }
        }

        if !phoneNumber.domesticNumber.contains(Constants.countryCode) {
            return "\(Constants.countryCode)\(phoneNumber.domesticNumber)"
        } else {
            return phoneNumber.domesticNumber
        }
    }

    func string(from phoneNumber: PhoneNumber) -> String? {
        guard let countryCode = self.countryCode(from: phoneNumber) else {
            return nil
        }

        return "\(countryCode) \(self.domesticNumber(from: phoneNumber))"
    }
}
