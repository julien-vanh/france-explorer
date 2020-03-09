//
//  RegionsMap.swift
//  TripList
//
//  Created by Julien Vanheule on 28/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit
import CoreData
import UIKit


struct RegionsMapController: UIViewRepresentable {
    @ObservedObject var appState = AppState.shared
    var regionsCompletion: [String: Int]
    private var regionsOverlay: [String: MKOverlay] = [:]
    private let view = MKMapView(frame: .zero)
    private let decoder = JSONDecoder()
    
    init(regionsCompletion: [String: Int]){
        self.regionsCompletion = regionsCompletion
        
        if let file = Bundle.main.url(forResource: "regions", withExtension: "geojson"),
            let data = try? Data(contentsOf: file),
            let geojsonFeatures = try? MKGeoJSONDecoder().decode(data),
            let features = geojsonFeatures as? [MKGeoJSONFeature]
        {
            features.forEach { (feature) in
                if let overlay = feature.geometry[0] as? MKOverlay {
                    do {
                        let metadata: RegionMetadata = try decoder.decode(RegionMetadata.self, from: feature.properties!)
                        regionsOverlay[metadata.regionId] = overlay
                    } catch {
                        fatalError("Couldn't parse regions metadata")
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        //Configure map
        view.delegate = context.coordinator
        view.mapType = .mutedStandard
        view.showsUserLocation = true
        view.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        centerMapOnFrance(map: view)
        
        //Build annotations
        view.removeAnnotations(view.annotations)
        let places = placesData
        let annotations = places.map{PlaceAnnotation(place: $0)}
        view.addAnnotations(annotations)
        
        return view
    }
    
    struct RegionMetadata: Hashable, Codable {
        var name: String
        var regionId: String
    }
    
    
    func centerMapOnUserButtonClicked(_ view: MKMapView) {
        view.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context){
        view.removeOverlays(view.overlays)
        
        regionsCompletion.keys.forEach { regionId in
            if let overlay = regionsOverlay[regionId] {
                view.addOverlay(overlay, level: .aboveRoads)
            }
        }
    }
    
    func centerMapOnFrance(map: MKMapView){
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.183753, longitude: 2.4)
        let span = MKCoordinateSpan(latitudeDelta: 14.5, longitudeDelta: 14.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RegionsMapController

        init(_ map: RegionsMapController) {
            self.parent = map
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer: MKOverlayPathRenderer
            switch overlay {
                case is MKMultiPolygon:
                    renderer = MKMultiPolygonRenderer(overlay: overlay)
                case is MKPolygon:
                    renderer = MKPolygonRenderer(overlay: overlay)
                default:
                    return MKOverlayRenderer(overlay: overlay)
            }
            
            renderer.lineWidth = 1
            renderer.strokeColor = UIColor.clear
            renderer.fillColor = UIColor.mapOverlayExploring
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is PlaceAnnotation {
                let placeAnnotation = view.annotation as! PlaceAnnotation
                print(placeAnnotation.place.title)
                self.parent.appState.place = placeAnnotation.place
                mapView.setCenter(placeAnnotation.coordinate, animated: true)
            }
        }
    }
}


internal final class PlaceAnnotationView: MKMarkerAnnotationView {
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if annotation is PlaceAnnotation {
            let placeAnnotation = annotation as! PlaceAnnotation
            
            switch placeAnnotation.place.popularity{
            case 3:
                displayPriority = .required
            case 2:
                displayPriority = .defaultHigh
            default:
                displayPriority = .defaultLow
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
    
    func configure(with annotation: MKAnnotation) {
        guard annotation is PlaceAnnotation else { fatalError("Unexpected annotation type: \(annotation)") }
        let placeAnnotation = annotation as! PlaceAnnotation
        markerTintColor = AppStyle.color(for: placeAnnotation.place.category)
        glyphImage = UIImage(named: "\(placeAnnotation.place.category)-colored")
    }
}
