//
//  MapViewController.swift
//  GeoCode
//
//  Created by Backlin,Gene on 3/14/18.
//  Copyright © 2018 Backlin,Gene. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet var latlongLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var zipcode: String!
    var geocoder: CLGeocoder!
    var mapURL: String?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = zipcode
        latlongLabel.text = ""
        geocoder = CLGeocoder()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        geocode(address: zipcode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility methods
    
    func geocode(address: String) {
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else {
                if placemarks != nil {
                    let placemark: CLPlacemark = placemarks![0]
                    let latitude: CLLocationDegrees = placemark.location!.coordinate.latitude
                    let longitude: CLLocationDegrees = placemark.location!.coordinate.longitude
                    let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark.location!.coordinate, 200, 200)
                    
                    let city = placemark.locality
                    let state = placemark.administrativeArea

                    self!.mapView.region = region
                    let pin: MKPointAnnotation = MKPointAnnotation()
                    pin.coordinate = placemark.location!.coordinate
                    pin.title = "\(city!), \(state!)"
                    self!.mapView.addAnnotation(pin)

                    self!.mapURL = "http://maps.apple.com/?q=\(latitude),\(longitude)"
                    self!.latlongLabel.text = "φ: \(latitude), λ: \(longitude)"
                }
            }
        }
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            view.rightCalloutAccessoryView = mapsButton
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = latlongLabel.text
            view.detailCalloutAccessoryView = detailLabel
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        UIApplication.shared.open(URL(string: mapURL!)!, options: launchOptions, completionHandler: nil)
    }
    
}
