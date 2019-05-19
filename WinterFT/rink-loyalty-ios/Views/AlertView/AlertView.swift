//
//  AlertView.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 07/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class AlertView: UIView, UITextViewDelegate {

    // MARK: - Instance Properties

    private let shareButton = UIButton()
    private let cancelButton = UIButton()
    private let textView = UITextView()
    private let separatorView = UIView()

    // MARK: -

    var onCancelButtonClicked: (() -> Void)?

    var onSharedButtonClicked: (() -> Void)?

    // MARK: -

    var textForShare: String? {
        get {
            return self.textView.text
        }

        set {
            self.textView.text = newValue
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    // MARK: - Instance Methods

    @objc private func onCancelButtonTouchUpInside(_ sender: Any) {
        self.onCancelButtonClicked?()
    }

    @objc private func onSharedButtonTouchUpInside(_ sender: Any) {
        self.onSharedButtonClicked?()
    }

    private func initialize() {
        self.textView.delegate = self

        self.shareButton.setTitleColor(Colors.rinkLoyaltyTextColor, for: .normal)
        self.shareButton.setTitle("Поделиться", for: .normal)
        self.shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false

        self.shareButton.addTarget(self, action: #selector(onSharedButtonTouchUpInside(_:)), for: .touchUpInside)

        self.addSubview(self.shareButton)

        self.cancelButton.setTitleColor(Colors.rinkLoyaltyTextColor, for: .normal)
        self.cancelButton.setTitle("Отменить", for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false

        self.cancelButton.addTarget(self, action: #selector(onCancelButtonTouchUpInside(_:)), for: .touchUpInside)

        self.addSubview(self.cancelButton)

        self.separatorView.backgroundColor = UIColor.lightGray
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.separatorView)

        self.textView.textColor = UIColor.black
        self.textView.autocorrectionType = .no
        self.textView.font = UIFont.systemFont(ofSize: 18)
        self.textView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.textView)

        self.shareButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([self.cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                                     self.cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)])

        NSLayoutConstraint.activate([self.shareButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                                     self.shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])

        NSLayoutConstraint.activate([self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                                     self.separatorView.topAnchor.constraint(equalTo: self.shareButton.bottomAnchor, constant: 8),
                                     self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                                     self.separatorView.heightAnchor.constraint(equalToConstant: 0.5)])

        NSLayoutConstraint.activate([self.textView.heightAnchor.constraint(equalToConstant: 140),
                                     self.textView.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: 0),
                                     self.textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                                     self.textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)])
    }
}
