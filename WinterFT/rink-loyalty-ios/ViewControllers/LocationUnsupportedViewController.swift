//
//  LocationUnsupportedViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 18/01/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class LocationUnsupportedViewController: UIViewController {

    // MARK: - Instance Methods

    @IBAction private func backButtonTouchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
