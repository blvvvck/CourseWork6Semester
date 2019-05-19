//
//  DefaultRinksService.swift
//  rink-loyalty-ios
//
//  Created by Дамир Зарипов on 03/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

struct DefaultRinksService: RinksService {

    // MARK: - Nested Types

    private enum Errors {

        // MARK: - Type Properties

        static let wrongToken = "Токен истек или не верный"
    }

    // MARK: - Instance Properties

    let rinksProvider: MoyaProvider<RinksProvider>

    func getRinks(onSuccess: @escaping ([Rink]) -> Void, onFailure: @escaping (String) -> Void) {
        self.rinksProvider.request(.getRinks) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 404 {
                    onFailure(Errors.wrongToken)
                } else {
                    guard let rinks: [Rink] = try? response.map([Rink].self) else {
                        return onFailure(Messages.badResponse)
                    }

                    onSuccess(rinks)
                }

            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
    }
}
