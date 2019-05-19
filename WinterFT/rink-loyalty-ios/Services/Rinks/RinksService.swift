//
//  RinksService.swift
//  rink-loyalty-ios
//
//  Created by Дамир Зарипов on 03/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

protocol RinksService {

    // MARK: - Instance Methods

    func getRinks(onSuccess: @escaping ([Rink]) -> Void,
                  onFailure: @escaping (String) -> Void)
}
