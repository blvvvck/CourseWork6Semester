//
//  PrimaryButton.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 18/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

@IBDesignable final class PrimaryButton: Button {

    // MARK: - Initializers

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.initialize()
    }

    // MARK: - Instance Methods

    private func initialize() {
        self.defaultTitleColor = UIColor.white
        self.defaultBackgroundColor = Colors.primaryColor

        self.disabledTitleColor = UIColor.white
        self.disabledBackgroundColor = Colors.disabledPrimaryColor

        self.cornerRadius = 8.0
    }
}
