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


struct ProgressionMapController: UIViewRepresentable {
    @ObservedObject var appState = AppState.shared
    var completions: [Completion]
    private var regionsOverlay: [String: MKOverlay] = [:]
    private let view = MKMapView(frame: .zero)
    private let decoder = JSONDecoder()
    
    init(completions:  [Completion]){
        self.completions = completions
        
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
        
        getRegionsCompletion(completions).keys.forEach { regionId in
            if let overlay = regionsOverlay[regionId] {
                view.addOverlay(overlay, level: .aboveRoads)
            }
        }
        
        //Build annotations
        view.removeAnnotations(view.annotations)
        let places = placesData
        let annotations = places.map { (place) -> PlaceAnnotation in
            let explored = completions.contains { (completion) -> Bool in
                completion.placeId == place.id
            }
            var style: PlaceAnnotationStyle = (explored ? .Explored : .Unexplored)
            if place.iap && !appState.isPremium {
                style = .PremiumLock
            }
            return PlaceAnnotation(place: place, style: style)
        }
        view.addAnnotations(annotations)
    }
    
    private func getRegionsCompletion(_ completions: [Completion]) -> [String: Int]{
        var regionsCompletion:[String: Int] = [:]
        
        self.completions.forEach { (completion) in
            if let place = PlaceStore.shared.get(id: completion.placeId!) {
                if regionsCompletion[place.regionId] != nil {
                    regionsCompletion[place.regionId]! += 1
                } else {
                    regionsCompletion[place.regionId] = 1
                }
            }
        }
        
        return regionsCompletion
    }
    
    func centerMapOnFrance(map: MKMapView){
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.183753, longitude: 2.4)
        let span = MKCoordinateSpan(latitudeDelta: 14.5, longitudeDelta: 14.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ProgressionMapController

        init(_ map: ProgressionMapController) {
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
            renderer.fillColor = UIColor.explored
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is PlaceAnnotation {
                let placeAnnotation = view.annotation as! PlaceAnnotation
                
                self.parent.appState.place = placeAnnotation.place
                
                mapView.setCenter(placeAnnotation.coordinate, animated: true)
            }
        }
    }
}



