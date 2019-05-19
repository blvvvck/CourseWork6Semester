//
//  TripListTableViewCell.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit

class TripListTableViewCell: UITableViewCell {

    private enum Constants {

        // MARK: - Nested Properties

        static let russianEnergyCaption = "ккал"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(with model: Trip) {
        let formattedDistance = FormatDisplay.distance(model.distance)
        let formattedDate = FormatDisplay.date(model.startDate)
        let formattedTime = FormatDisplay.tripDuration(model.startDate, finish: model.finishDate)

        self.distanceLabel.text = "\(formattedDistance)"
        self.dateLabel.text = "\(formattedDate)"
        self.timeLabel.text = "\(formattedTime)"
        self.calorieLabel.text = "\(model.calories) \(Constants.russianEnergyCaption)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
