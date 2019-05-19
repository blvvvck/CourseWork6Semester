//
//  AuthorizationService.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 15/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

protocol AuthorizationSerivce {

    // MARK: - Instance Methods

    func sendVerificationCode(_ accountUserBuffer: AccountUserBuffer,
                              onSuccess: @escaping () -> Void,
                              onFailure: @escaping (String) -> Void)

    func verifyVerificationCode(_ accountUserBuffer: AccountUserBuffer,
                                onSuccess: @escaping () -> Void,
                                onFailure: @escaping (String) -> Void)

    func createUser(_ accountUserBuffer: AccountUserBuffer,
                    onSuccess: @escaping () -> Void,
                    onFailure: @escaping (String) -> Void)
}
