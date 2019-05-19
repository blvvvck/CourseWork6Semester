//
//  DefaultAlertFactory.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 18/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class DefaultAlertFactory: AlertFactory {

    // MARK: - Instance Methods

    func getAlert(with message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }
}
