//
//  DefaultAuthorizationService.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 15/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

struct DefaultAuthorizationService: AuthorizationSerivce {

    // MARK: - Nested Types

    private enum Errors {

        // MARK: - Type Properties

        static let wrongPhoneNumber = "Неверный номер"
        static let wrongToken = "Токен истек или не верный"
        static let serverError = "Ошибка сервера"
        static let userAlreadyExists = "Пользователь с таким номером телефона уже существует"
    }

    // MARK: - Instance Properties

    let authorizationProvider: MoyaProvider<AuthorizationProvider>

    // MARK: - Instance Methods

    func sendVerificationCode(_ accountUserBuffer: AccountUserBuffer, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.authorizationProvider.request(.sendVerificationCode(accountUserBuffer)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 404 {
                    onFailure(Errors.wrongPhoneNumber)
                } else {
                    onSuccess()
                }

            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
    }

    func verifyVerificationCode(_ accountUserBuffer: AccountUserBuffer, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.authorizationProvider.request(.verifyVerificationCode(accountUserBuffer)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 404 {
                    onFailure(Errors.wrongToken)
                } else {
                    guard let json = try? response.mapJSON() as? [String: String], let token = json?["token"]  else {
                        onFailure(Errors.serverError)
                        return
                    }

                    UserDefaultsManager.shared.save(token: token)

                    onSuccess()
                }

            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
    }

    func createUser(_ accountUserBuffer: AccountUserBuffer, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.authorizationProvider.request(.createUser(accountUserBuffer)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 409 {
                    onFailure(Errors.userAlreadyExists)
                    return
                }

                onSuccess()

            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
    }
}
