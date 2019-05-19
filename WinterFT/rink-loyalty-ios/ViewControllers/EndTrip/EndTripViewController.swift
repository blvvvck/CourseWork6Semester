//
//  EndTripViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit
import Charts

class EndTripViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Nested Properties

        static let feedbackViewControllerIdentifier = "FeedbackViewController"
        static let russianDescriptionOfTheGraphOnTheX = "Минуты"
        static let russianEnergyCaption = "ккал"
        static let newsLink = "https://vk.com/nizhnynovgorod2018?w=wall-147059220_8692"

        static let chartCircleRadius = 5.0
        static let chartLineWidth = 5
        static let minimumCountOfValuesToBuildAGraph = 2
        static let lineChartViewHeightConstraintValue: CGFloat = 0

        static let minPresentDistance: Double = 5_000

        static let sharingTextFormat = "Хорошо накатали %@ на %@! Сожгли %@ за %@!"
        static let presentDistanceInstruction = "Для получения подарка необходимо откатать 5км. Получить подарок можно только раз в день!"
        static let presentAlreadyGettedInstruction = "Вы уже получали подарок за последние 24 часа. Приходите снова завтра!"
    }

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showTripList = "ShowTripList"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var rinkLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var tripDetailView: UIView!
    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var lineChartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var alertView: AlertView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var presentInstructionLabel: UILabel!

    // MARK: -

    private var rink: Rink?
    private var trip: Trip?

    // MARK: -

    private(set) var tripBuffer: TripBuffer?

    private(set) var shouldApplyData = true

    // MARK: - Initializers

    deinit {
        TripBuffer.shared.reset()
    }

    // MARK: - Instance Methods

    @IBAction private func shareButtonTouchUpInside(_ sender: UIButton) {
        guard let distance = self.tripBuffer?.distance else {
            return
        }

        guard let rinkName = self.rink?.name else {
            return
        }

        guard let calories = self.tripBuffer?.calorie else {
            return
        }

        guard let time = self.tripBuffer?.time else {
            return
        }

        let sharingText = String(format: Constants.sharingTextFormat, distance, rinkName, calories, time)

        let shareView = ShareView(text: sharingText)

        shareView.setNeedsLayout()
        shareView.layoutIfNeeded()

        let sharingImage = shareView.asImage()

        let activity = UIActivityViewController(activityItems: [sharingImage], applicationActivities: nil)

        self.present(activity, animated: true)
    }

    @IBAction private func tripListButtonTouchUpInside(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segues.showTripList, sender: self)
    }

    // MARK: -

    private func setupChart() {
        guard let trip = self.trip else {
            return
        }

        self.setChart(duration: trip.durations, distance: trip.distances)
    }

    private func setChart(duration: [Double], distance: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<distance.count {
            let dataEntry = ChartDataEntry(x: duration[i], y: distance[i])
            dataEntries.append(dataEntry)
        }

        if dataEntries.count < Constants.minimumCountOfValuesToBuildAGraph {
            self.lineChartViewHeightConstraint.constant = Constants.lineChartViewHeightConstraintValue
            return
        }

        let chartDataSet = LineChartDataSet(entries: dataEntries, label: Constants.russianDescriptionOfTheGraphOnTheX)

        chartDataSet.setColor(Colors.rinkLoyaltyTextColor)
        chartDataSet.circleRadius = CGFloat(Constants.chartCircleRadius)
        chartDataSet.mode = .cubicBezier
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = CGFloat(Constants.chartLineWidth)

        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.drawGridLinesEnabled = true
        self.lineChartView.leftAxis.drawGridLinesEnabled = true
        self.lineChartView.legend.enabled = true
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.leftAxis.drawLabelsEnabled = true
        self.lineChartView.doubleTapToZoomEnabled = false

        let chartData = LineChartData(dataSet: chartDataSet)
        self.lineChartView.data = chartData
    }

    private func configureView() {
        guard let trip = self.trip else {
            return
        }

        let distance = Measurement(value: trip.distance, unit: UnitLength.meters)
        let seconds = trip.finishDate - trip.startDate
        let calorie = trip.calories

        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(trip.startDate)
        let formattedTime = FormatDisplay.timeWithBriefUnitStyle(Int(seconds))

        self.tripBuffer?.distance = "\(formattedDistance)"
        self.tripBuffer?.date = "\(formattedDate)"
        self.tripBuffer?.time = "\(formattedTime)"
        self.tripBuffer?.calorie = "\(calorie) \(Constants.russianEnergyCaption)"

        self.distanceLabel.text = self.tripBuffer?.distance
        self.dateLabel.text = self.tripBuffer?.date
        self.timeLabel.text = self.tripBuffer?.time
        self.calorieLabel.text = self.tripBuffer?.calorie

        self.tripBuffer?.textForSharing = "Хорошо накатали \(self.tripBuffer?.distance ?? "") на катке в Нижнем Новгороде! Сожгли \(self.tripBuffer?.calorie ?? "") за \(self.tripBuffer?.time ?? "")! Подробнее про каток: \(Constants.newsLink)"
    }

    private func apply(tripBuffer: TripBuffer) {
        Log.i()

        self.tripBuffer = tripBuffer
    }

    private func apply(trip: Trip) {
        Log.i()

        self.trip = trip

        if self.isViewLoaded {
            if let gift = trip.gift {
                if trip.distance < Constants.minPresentDistance {
                    self.shareButton.isHidden = true
                    self.presentInstructionLabel.text = Constants.presentDistanceInstruction
                } else if gift {
                    self.shareButton.isHidden = false
                    self.presentInstructionLabel.isHidden = false
                } else {
                    self.shareButton.isHidden = true
                    self.presentInstructionLabel.text = Constants.presentAlreadyGettedInstruction
                }
            } else {
                self.shareButton.isHidden = true
                self.presentInstructionLabel.isHidden = true
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(rink: Rink) {
        Log.i(rink.name)

        self.rink = rink

        if self.isViewLoaded {
            self.rinkLabel.text = rink.name

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData {
            self.apply(tripBuffer: self.tripBuffer ?? TripBuffer.shared)

            if let rink = self.rink {
                self.apply(rink: rink)
            }

            if let trip = self.trip {
                self.apply(trip: trip)
            }

            self.configureView()
            self.setupChart()
        }
    }
}

extension EndTripViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        if let rink = dictionary["rink"] as? Rink {
            self.apply(rink: rink)
        }

        if let trip = dictionary["trip"] as? Trip {
            self.apply(trip: trip)
        }
    }
}
