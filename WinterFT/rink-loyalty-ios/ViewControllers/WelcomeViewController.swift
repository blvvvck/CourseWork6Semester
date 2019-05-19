//
//  WelcomeViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 12/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, WelcomeCollectionViewCellDelegate {

    private enum Constants {

        // MARK: - Nested Properties

        static let welcomeCollectionViewCellIdentifier = "WelcomeCollectionViewCell"
    }

    private enum WelcomeCaptions {
        static let infoArray = [WelcomeInfo(introImage: #imageLiteral(resourceName: "ice-skate.png"), firstLabel: "Стадион «Нижний Новгород»", secondLabel: "Находясь на катке, включите таймер поездки перед началом катания, чтобы потом увидеть результат!"),
                                WelcomeInfo(introImage: #imageLiteral(resourceName: "ice-skate.png"), firstLabel: "Подробнее", secondLabel: "Вы можете оставить отзыв и поделиться опытом с друзьями через 60 минут после начала катания."),
                                WelcomeInfo(introImage: #imageLiteral(resourceName: "placeholder-filled-point.png"), firstLabel: "Геолокация", secondLabel: "Включите геолокацию для определения пройденного расстояния")]
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var welcomeBackgroungImageView: UIImageView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Instance Methods

    func saveOnboardingFinished() {
        UserDefaultsManager.shared.save(onbordingState: true)
    }

    func toExtendButtonDidTouchUpInside() {
        LocationManager.shared.requestWhenInUseAuthorization()

        self.dismiss(animated: true, completion: nil)
    }

    func registerNibs() {
        self.collectionView.register(UINib(nibName: Constants.welcomeCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.welcomeCollectionViewCellIdentifier)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.registerNibs()
        self.saveOnboardingFinished()
    }
}

// MARK: - UICollectionViewDataSource
extension WelcomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WelcomeCaptions.infoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.welcomeCollectionViewCellIdentifier, for: indexPath) as! WelcomeCollectionViewCell
        if indexPath.row == 2 {
            cell.isContinueButtonVisible = true
            cell.configureUI()
        }
        let welcomeInfo = WelcomeCaptions.infoArray[indexPath.row]
        cell.configureCell(with: welcomeInfo)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDataDelegate
extension WelcomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = (scrollView.contentOffset.x + pageWidth / 2) / pageWidth
        self.pageControl.currentPage = Int(currentPage)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
