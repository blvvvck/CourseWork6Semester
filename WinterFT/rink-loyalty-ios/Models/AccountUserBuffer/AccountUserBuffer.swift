//
//  AccountUserBuffer.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

class AccountUserBuffer {

    // MARK: - Instance Properties

    var phone: String?
    var name: String?
    var verificationCode: String?

    // MARK: - Instance Methods

    func reset() {
        self.phone = nil
        self.name = nil
        self.verificationCode = nil
    }
}
