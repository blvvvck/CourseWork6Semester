//
//  ConfirmPhoneNumberViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class ConfirmPhoneNumberViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showRinks = "ShowRinks"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var verificationCodeTextField: UITextField!

    @IBOutlet private weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var verifyButton: PrimaryButton!

    // MARK: -

    private(set) var shouldApplyData = true

    private(set) var accountUserBuffer: AccountUserBuffer?

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @IBAction private func onTextFieldDidChanged(_ sender: Any) {
        self.verifyButton.isEnabled = self.verificationCodeTextField.hasText
    }

    @IBAction private func onNextButtonTouchUpInside(_ sender: Any) {
        guard let verificationCode = self.verificationCodeTextField.text else {
            return
        }

        let loadingViewController = LoadingViewController()

        self.present(loadingViewController, animated: true, completion: {
            self.confirm(verificationCode: verificationCode, loadingViewController: loadingViewController)
        })
    }

    // MARK: -

    private func confirm(verificationCode: String, loadingViewController: LoadingViewController) {
        guard let accountUserBuffer = self.accountUserBuffer else {
            return
        }

        accountUserBuffer.verificationCode = verificationCode

        Services.authorizationService.verifyVerificationCode(accountUserBuffer, onSuccess: { [weak self] in
            guard let `self` = self else {
                return
            }

            loadingViewController.dismiss(animated: true, completion: {
                if self.presentingViewController != nil {
                    self.dismiss(animated: true)
                } else {
                    self.performSegue(withIdentifier: Segues.showRinks, sender: self)
                }
            })
        }, onFailure: { stringError in
            Log.e(stringError)
        })
    }

    // MARK: -

    private func apply(accountUserBuffer: AccountUserBuffer) {
        Log.i("accountUserBuffer: \(accountUserBuffer)")

        self.accountUserBuffer = accountUserBuffer

        self.shouldApplyData = false
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData {
            self.apply(accountUserBuffer: self.accountUserBuffer ?? AccountUserBuffer())
        }

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(true)

        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - DictionaryReceiver

extension ConfirmPhoneNumberViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let accountUserBuffer = dictionary["accountUserBuffer"] as? AccountUserBuffer else {
            return
        }

        self.apply(accountUserBuffer: accountUserBuffer)
    }
}

// MARK: - KeyboardHandler

extension ConfirmPhoneNumberViewController: KeyboardHandler {

    // MARK: - Instance Methods

    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerViewHeightConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
