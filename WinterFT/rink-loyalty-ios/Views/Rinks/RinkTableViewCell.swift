//
//  RinkTableViewCell.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class RinkTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var entrancePriceLabel: UILabel!
    @IBOutlet private weak var skateRentalPriceLabel: UILabel!
    @IBOutlet private weak var workScheduleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    // MARK: -

    var name: String? {
        get {
            return self.nameLabel.text
        }

        set {
            self.nameLabel.text = newValue
        }
    }

    var distance: String? {
        get {
            return self.distanceLabel.text
        }

        set {
            self.distanceLabel.text = newValue
        }
    }

    var address: String? {
        get {
            return self.addressLabel.text
        }

        set {
            self.addressLabel.text = newValue
        }
    }

    var entrancePrice: String? {
        get {
            return self.entrancePriceLabel.text
        }

        set {
            self.entrancePriceLabel.text = newValue
        }
    }

    var skateRentalPrice: String? {
        get {
            return self.skateRentalPriceLabel.text
        }

        set {
            self.skateRentalPriceLabel.text = newValue
        }
    }

    var workSchedule: String? {
        get {
            return self.workScheduleLabel.text
        }

        set {
            self.workScheduleLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.containerView.layer.cornerRadius = 20
    }
}
