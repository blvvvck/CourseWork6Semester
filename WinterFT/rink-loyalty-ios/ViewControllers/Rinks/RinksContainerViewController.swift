//
//  RinksContainerViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 25/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class RinksContainerViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let listIndex = 0
        static let mapIndex = 1
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showWelcome = "ShowWelcome"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var rinksListContainerView: UIView!
    @IBOutlet private weak var rinksMapContainerView: UIView!

    // MARK: - Instance Methods

    @IBAction private func onSegmentControlValueChanged(_ sender: UISegmentedControl) {
        Log.i()

        switch sender.selectedSegmentIndex {
        case Constants.listIndex:
            self.rinksListContainerView.isHidden = false
            self.rinksMapContainerView.isHidden = true

        case Constants.mapIndex:
            self.rinksListContainerView.isHidden = true
            self.rinksMapContainerView.isHidden = false

        default:
            fatalError()
        }
    }

    @IBAction private func onLogoutBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        let actionSheet = UIAlertController(title: "Выйти?", message: nil, preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive, handler: { [unowned self] action in
            UserDefaultsManager.shared.clear()

            self.performSegue(withIdentifier: Segues.showWelcome, sender: self)
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true)
    }
}
