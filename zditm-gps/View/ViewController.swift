//
//  ViewController.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import UIKit
import MapKit

protocol MapScreenProtocol {
    func updateView()
}

class ViewController: UIViewController, MapScreenProtocol, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var viewModel: MapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MapViewModel(self)
        setupMap()
        updateView()
        viewModel.updateVehiclePositions()
    }
    
    private func setupMap(){
        let cityCenter = CLLocationCoordinate2D(latitude: 53.4285, longitude: 14.5528)
        let span = 0.16
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let cityRegion = MKCoordinateRegion(center: cityCenter, span: coordinateSpan)
        mapView.setRegion(cityRegion, animated: true)
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.register(VehicleMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupUserTrackingButtonAndScaleView()
    }
    
    func updateView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.vehicleMarkers)
//        mapView.addAnnotations(viewModel.vehicleStopMarkers)
    }
    
    func setupUserTrackingButtonAndScaleView() {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
    
   
}

