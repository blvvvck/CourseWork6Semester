//
//  PhoneNumberViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter

class PhoneNumberViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showConfirmPhoneNumber = "ShowConfirmPhoneNumber"
    }

    // MARK: -

    private enum Constants {

        // MARK: - Type Properties

        static let phoneNumberLength = 10
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var phoneNumberTextField: PhoneFormattedTextField!

    @IBOutlet private weak var sendCodeButton: UIButton!

    @IBOutlet private weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!

    // MARK: -

    private(set) var accountUserBuffer: AccountUserBuffer?

    private(set) var actionType: ActionType = .signIn

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @IBAction private func onSendVerifivationCodeButtonTouchUpInside(_ sender: Any) {
        guard let phoneNumber = self.phoneNumberTextField.phoneNumber() else {
            return
        }

        let loadingViewController = LoadingViewController()

        self.present(loadingViewController, animated: true, completion: {
            self.confirm(phoneNumber: "+\(phoneNumber)", loadingViewController: loadingViewController)
        })
    }

    // MARK: -

    private func confirm(phoneNumber: String, loadingViewController: LoadingViewController) {
        guard let accountUserBuffer = self.accountUserBuffer else {
            return
        }

        accountUserBuffer.phone = phoneNumber

        switch self.actionType {
        case .signIn:
            Services.authorizationService.sendVerificationCode(accountUserBuffer, onSuccess: { [weak self] in
                guard let strongSelf = self else {
                    return
                }

                loadingViewController.dismiss(animated: true, completion: {
                    strongSelf.performSegue(withIdentifier: Segues.showConfirmPhoneNumber, sender: accountUserBuffer)
                })
            }, onFailure: { [weak self] stringError in
                Log.e(stringError)

                guard let strongSelf = self else {
                    return
                }

                loadingViewController.dismiss(animated: true, completion: {
                    strongSelf.present(DefaultAlertFactory().getAlert(with: stringError), animated: true, completion: nil)
                })
            })

        case .signUp:
            Services.authorizationService.createUser(accountUserBuffer, onSuccess: { [weak self] in
                guard let strongSelf = self else {
                    return
                }

                loadingViewController.dismiss(animated: true, completion: {
                    strongSelf.performSegue(withIdentifier: Segues.showConfirmPhoneNumber, sender: accountUserBuffer)
                })
            }, onFailure: { [weak self] stringError in
                Log.e(stringError)

                guard let strongSelf = self else {
                    return
                }

                loadingViewController.dismiss(animated: true, completion: {
                    strongSelf.present(DefaultAlertFactory().getAlert(with: stringError), animated: true, completion: nil)
                })
            })
        }
    }

    // MARK: -

    private func apply(accountUserBuffer: AccountUserBuffer, actionType: ActionType) {
        Log.i("accountUserBuffer: \(accountUserBuffer), actionType: \(actionType)")

        self.accountUserBuffer = accountUserBuffer
        self.actionType = actionType
    }

    private func updateSendCodeButtonState() {
        self.sendCodeButton.isEnabled = (self.phoneNumberTextField.phoneNumberWithoutPrefix()?.count == Constants.phoneNumberLength)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false

        self.phoneNumberTextField.becomeFirstResponder()
        self.phoneNumberTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        self.phoneNumberTextField.prefix = "+7 "
        self.phoneNumberTextField.textDidChangeBlock = { [unowned self] textField in
            self.updateSendCodeButtonState()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.apply(accountUserBuffer: self.accountUserBuffer ?? AccountUserBuffer(), actionType: self.actionType)

        self.subscribeToKeyboardNotifications()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier {
        case Segues.showConfirmPhoneNumber:
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
                dictionaryReceiver.apply(dictionary: ["accountUserBuffer": accountUserBuffer, "actionType": self.actionType])
            }

        default:
            break
        }
    }
}

// MARK: - KeyboardHandler

extension PhoneNumberViewController: KeyboardHandler {

    // MARK: - Instance Methods

    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerViewHeightConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension PhoneNumberViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let accountUserBuffer = dictionary["accountUserBuffer"] as? AccountUserBuffer, let actionType = dictionary["actionType"] as? ActionType else {
            return
        }

        self.apply(accountUserBuffer: accountUserBuffer, actionType: actionType)
    }
}
