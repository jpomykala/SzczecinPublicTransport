//
//  ViewController.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import UIKit
import MapKit

protocol MapScreenDelegate {
    func updateView()
    func showAlert(error: String)
}

protocol HandleLineSelectedDelegate {
    func onSelection(line: String)
    func onSelection(id: Int)
    func resetSelection()
}

class MapViewController: UIViewController, MapScreenDelegate, HandleLineSelectedDelegate, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var resultSearchController: ResultTableViewController!
    var viewModel: MapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MapViewModel(self)
        setupMap()
        setupSearchBar()
        setupUserTrackingButtonAndScaleView()
    }
    
    private func setupSearchBar() {
        let searchControllerId = "resultTableViewController"
        resultSearchController = storyboard!.instantiateViewController(withIdentifier: searchControllerId) as! ResultTableViewController
        resultSearchController.delegate = self
        searchController = UISearchController(searchResultsController: resultSearchController)
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Wyszukaj linię autobusową lub tramwajową"
        navigationItem.titleView = searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = resultSearchController
        definesPresentationContext = true
    }
    
    private func setupMap() {
        let cityCenter = CLLocationCoordinate2D(latitude: 53.4285, longitude: 14.5528)
        let span = 0.16
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let cityRegion = MKCoordinateRegion(center: cityCenter, span: coordinateSpan)
        mapView.setRegion(cityRegion, animated: true)
        mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        mapView.register(VehicleMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addAnnotations(self.viewModel.vehicleStops)
            self.mapView.addAnnotations(self.viewModel.vehicleMarkers)
            self.mapView.add(self.viewModel.vehicleRoute)
        }
    }
    
    func showAlert(error: String){
        let alert = UIAlertController(title: "Usługa niedostępna", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onSelection(line: String) {
        viewModel.userHiglightRequest(line: line)
    }
    
    func onSelection(id: Int) {
        viewModel.userHiglightRequest(id: id)
    }
    
    func resetSelection() {
         viewModel.userResetSelectionRequest()
    }
}

