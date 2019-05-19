//
//  LoadingViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 13/03/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit

class LoadingViewController: LoggedViewController {

    // MARK: - Instance Properties

    private weak var boardView: UIView!

    private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Initializers

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    // MARK: - Instance Methods

    private func initialize() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    private func createBoardView() {
        let boardView = UIView()

        boardView.backgroundColor = Colors.lightGrayBackground
        boardView.clipsToBounds = true

        boardView.layer.cornerRadius = 14.0
        boardView.layer.masksToBounds = true

        boardView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(boardView)

        NSLayoutConstraint.activate([boardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
                                     boardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0)])

        self.boardView = boardView
    }

    private func createActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

        activityIndicatorView.startAnimating()

        activityIndicatorView.color = Colors.primaryColor
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([activityIndicatorView.topAnchor.constraint(equalTo: self.boardView.topAnchor,
                                                                                constant: 36.0),
                                     activityIndicatorView.bottomAnchor.constraint(equalTo: self.boardView.bottomAnchor,
                                                                                   constant: -36.0),
                                     activityIndicatorView.leadingAnchor.constraint(equalTo: self.boardView.leadingAnchor,
                                                                                    constant: 36.0),
                                     activityIndicatorView.trailingAnchor.constraint(equalTo: self.boardView.trailingAnchor,
                                                                                     constant: -36.0)])

        self.activityIndicatorView = activityIndicatorView
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createBoardView()
        self.createActivityIndicatorView()

        self.view.backgroundColor = Colors.darkBackground
    }
}
