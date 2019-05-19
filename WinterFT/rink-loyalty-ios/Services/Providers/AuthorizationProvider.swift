//
//  AuthorizationProvider.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

enum AuthorizationProvider {

    // MARK: - Enumeration Cases

    case createUser(AccountUserBuffer)
    case sendVerificationCode(AccountUserBuffer)
    case verifyVerificationCode(AccountUserBuffer)
}

// MARK: -

extension AuthorizationProvider: DefaultTargetType {

    // MARK: - Instance Properties

    var path: String {
        switch self {
        case .createUser:
            return "register"

        case .sendVerificationCode:
            return "sms/send"

        case .verifyVerificationCode:
            return "sms/verify"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createUser,
             .sendVerificationCode,
             .verifyVerificationCode:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .createUser(let accountUserBuffer):
            var parameters = [String: Any]()
            parameters["phone"] = accountUserBuffer.phone
            parameters["name"] = accountUserBuffer.name

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

        case .sendVerificationCode(let accountUserBuffer):
            var parameters = [String: Any]()

            parameters["phone"] = accountUserBuffer.phone

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

        case .verifyVerificationCode(let accountUserBuffer):
            var parameters = [String: Any]()

            parameters["phone"] = accountUserBuffer.phone
            parameters["code"] = accountUserBuffer.verificationCode

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
