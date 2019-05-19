//
//  ShareView.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 02/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

class ShareView: UIView {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let size = CGSize(width: 500, height: 500)
    }

    // MARK: - Instance Properties

    private let textLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let logoLabel = UILabel()

    // MARK: - Initializers

    init(text: String, backgroundImage: UIImage = #imageLiteral(resourceName: "SnowBg"), logo: String = "Winter Fairy Tale") {
        super.init(frame: .zero)

        self.initialize(text: text, backgroundImage: backgroundImage, logo: logo)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Instance Methods

    private func initialize(text: String, backgroundImage: UIImage, logo: String) {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.image = backgroundImage

        self.addSubview(self.backgroundImageView)

        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.textColor = Colors.white
        self.textLabel.text = text
        self.textLabel.font = Fonts.regular(ofSize: 17)
        self.textLabel.textAlignment = .center
        self.textLabel.numberOfLines = 0

        self.addSubview(self.textLabel)

        self.logoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.logoLabel.text = logo
        self.logoLabel.textColor = Colors.white
        self.logoLabel.font = Fonts.bold(ofSize: 22)

        self.addSubview(self.logoLabel)

        NSLayoutConstraint.activate([
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            self.logoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Constants.size.width),
            self.heightAnchor.constraint(equalToConstant: Constants.size.height)
        ])
    }

    // MARK: -

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)

        return renderer.image(actions: { [unowned self] rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        })
    }
}
