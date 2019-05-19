//
//  WelcomeCollectionViewCell.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 12/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit

protocol WelcomeCollectionViewCellDelegate: AnyObject {

    // MARK: - Instance Methods

    func toExtendButtonDidTouchUpInside()
}

class WelcomeCollectionViewCell: UICollectionViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var welcomeImageView: UIImageView!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var toExtendButton: UIButton!

    // MARK: -

    public var isContinueButtonVisible = false

    weak var delegate: WelcomeCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction private func toExtendButtonTouchUpInside(_ sender: UIButton) {
        delegate?.toExtendButtonDidTouchUpInside()
    }

    func configureUI() {
        if isContinueButtonVisible {
            self.toExtendButton.isHidden = false
        }
    }

    func configureCell(with model: WelcomeInfo) {
        self.welcomeImageView.image = model.introImage
        self.mainLabel.text = model.firstLabel
        self.detailLabel.text = model.secondLabel
    }
}
