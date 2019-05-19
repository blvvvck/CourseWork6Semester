//
//  AlertFactory.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 18/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

protocol AlertFactory {

    // MARK: - Instance Methods

    func getAlert(with message: String) -> UIAlertController
}
