//
//  RinksMapViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 29/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GLKit

class RinksMapViewController: UIViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let latitudinalMeters: Double = 2_000
        static let longitudinalMeters: Double = 2_000
    }

    private enum Segues {

        // MARK: - Type Properties

        static let showNewTrip = "ShowNewTrip"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var mapView: MKMapView!

    // MARK: -

    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?

    private var rinks: [Rink] = []

    // MARK: - Instance Methods

    private func addRinksPolygons(_ rinks: [Rink]) {
        for rink in rinks {
            var points = [
                CLLocationCoordinate2D(latitude: rink.area.leftBottom.latitude, longitude: rink.area.leftBottom.longitude),
                CLLocationCoordinate2D(latitude: rink.area.leftTop.latitude, longitude: rink.area.leftTop.longitude),
                CLLocationCoordinate2D(latitude: rink.area.rightTop.latitude, longitude: rink.area.rightTop.longitude),
                CLLocationCoordinate2D(latitude: rink.area.rightBottom.latitude, longitude: rink.area.rightBottom.longitude)]

            let polygon = MKPolygon(coordinates: &points, count: points.count)

            self.mapView.addOverlay(polygon)
        }
    }

    private func addRinksAnnotations(_ rinks: [Rink]) {
        self.rinks.forEach {
            let annotation = MKPointAnnotation()

            annotation.title = $0.name
            annotation.subtitle = $0.workSchedule
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.area.center.latitude, longitude: $0.area.center.longitude)

            self.mapView.addAnnotation(annotation)
        }
    }

    private func refreshRinks() {
        Services.rinksService.getRinks(onSuccess: { [weak self] rinks in
            guard let `self` = self else {
                return
            }

            self.rinks = rinks

            self.addRinksPolygons(self.rinks)

            self.addRinksAnnotations(self.rinks)
        }, onFailure: { [weak self] error in
            self?.present(DefaultAlertFactory().getAlert(with: error), animated: true, completion: nil)
        })
    }

    // MARK: -

    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }

    private func configureMapView() {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
        self.mapView.showsUserLocation = true
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLocationManager()
        self.configureMapView()

        self.refreshRinks()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showNewTrip:
            guard let rink = sender as? Rink else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["rink": rink])
            }

        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension RinksMapViewController: CLLocationManagerDelegate {

    // MARK: - Instance Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { self.currentLocation = locations.last }

        if self.currentLocation == nil, let userLocation = locations.last {
            let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: Constants.latitudinalMeters, longitudinalMeters: Constants.longitudinalMeters)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
}

// MARK: - MKMapViewDelegate

extension RinksMapViewController: MKMapViewDelegate {

    // MARK: - Instance Methods

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polygonView = MKPolygonRenderer(overlay: overlay)

        polygonView.strokeColor = Colors.primaryColor
        polygonView.lineWidth = 3
        polygonView.fillColor = Colors.rinkFillColor

        return polygonView
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }

        let identifier = "Annotation"

        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)

            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setImage(UIImage(named: "nextArrow"), for: .normal)

            view.rightCalloutAccessoryView = rightButton
        }

        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let rink = self.rinks.filter({ $0.name == view.annotation?.title }).first else {
            return
        }

        self.performSegue(withIdentifier: Segues.showNewTrip, sender: rink)
    }
}
