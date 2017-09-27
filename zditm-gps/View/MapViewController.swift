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

protocol HandleLineSelectedDelegate {
    func onLineSelected(line: String)
}

class MapViewController: UIViewController, MapScreenProtocol, HandleLineSelectedDelegate, MKMapViewDelegate {
    
    @IBOutlet var searchVar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    var searchBar: UISearchBar!
    var viewModel: MapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSearchBar()
        setupUserTrackingButtonAndScaleView()
        self.viewModel = MapViewModel(self)
    }
    
    private func setupSearchBar(){
        let resultSearchController = storyboard!.instantiateViewController(withIdentifier: "ResultSearchController") as! ResultSearchController
        let searchController = UISearchController(searchResultsController: resultSearchController)
        searchController.searchResultsUpdater = resultSearchController
        resultSearchController.delegate = self
        searchBar = searchController.searchBar
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search bus or tram line"
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
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
        mapView.register(VehicleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func setupUserTrackingButtonAndScaleView() {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay
        let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.alpha = 0.3
        polyLineRenderer.lineWidth = 7.0
        return polyLineRenderer
    }
    
    func updateView() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addAnnotations(self.viewModel.vehicleStops)
        self.mapView.addAnnotations(self.viewModel.vehicleMarkers)
        self.mapView.add(self.viewModel.vehicleRoute)
    }
    
    
    func onLineSelected(line: String) {
        viewModel.userRequestHighlightLine(line: line)
        searchBar?.text = line
    }
}

