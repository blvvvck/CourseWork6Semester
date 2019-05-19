//
//  CreateAccountViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 18/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class CreateAccountViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let enterPhoneNumber = "EnterPhoneNumber"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var firstNameTextField: UITextField!

    @IBOutlet private weak var nextButton: PrimaryButton!

    @IBOutlet private weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!

    // MARK: -

    private(set) var accountUserBuffer: AccountUserBuffer?

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @IBAction private func onTextFieldChanged(_ sender: Any) {
        self.nextButton.isEnabled = self.firstNameTextField.hasText
    }

    @IBAction private func onNextButtonTouchUpInside(_ sender: Any) {
        guard let accountUserBuffer = self.accountUserBuffer, let name = self.firstNameTextField.text else {
            return
        }

        accountUserBuffer.name = name

        self.performSegue(withIdentifier: Segues.enterPhoneNumber, sender: accountUserBuffer)
    }

    // MARK: -

    private func apply(accountUserBuffer: AccountUserBuffer) {
        Log.i("accountUserBuffer: \(accountUserBuffer)")

        self.accountUserBuffer = accountUserBuffer

        if let firstName = accountUserBuffer.name {
            self.firstNameTextField.text = firstName
        } else {
            self.firstNameTextField.text = nil
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.apply(accountUserBuffer: self.accountUserBuffer ?? AccountUserBuffer())

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(true)

        self.unsubscribeFromKeyboardNotifications()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier {
        case Segues.enterPhoneNumber:
            guard let accountUserBuffer = sender as? AccountUserBuffer else {
                fatalError()
            }

            let dictionaryReceiver: DictionaryReceiver?

            if let navigationController = segue.destination as? UINavigationController {
                dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
            } else {
                dictionaryReceiver = segue.destination as? DictionaryReceiver
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["accountUserBuffer": accountUserBuffer, "actionType": ActionType.signUp])
            }

        default:
            break
        }
    }
}

// MARK: - KeyboardHandler

extension CreateAccountViewController: KeyboardHandler {

    // MARK: - Instance Methods

    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerViewHeightConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
