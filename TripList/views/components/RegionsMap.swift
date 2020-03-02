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
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    let view = MKMapView(frame: .zero)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        view.delegate = context.coordinator
        view.mapType = .mutedStandard
        view.showsUserLocation = true
        view.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        centerMapOnFrance(map: view)
        
        view.removeOverlays(view.overlays)
        if let file = Bundle.main.url(forResource: "regions", withExtension: "geojson"),
            let data = try? Data(contentsOf: file),
            let geojsonFeatures = try? MKGeoJSONDecoder().decode(data),
            let features = geojsonFeatures as? [MKGeoJSONFeature]
        {
            let geometry = features.flatMap( {$0.geometry})
            let overlays = geometry.compactMap({$0 as? MKOverlay})
            
            view.addOverlays(overlays, level: MKOverlayLevel.aboveRoads)
        }
        
        view.removeAnnotations(view.annotations)
        let places = placesData
        let annotations = places.map{PlaceAnnotation(place: $0, completed: self.placeIsComplete(place: $0))}
        view.addAnnotations(annotations)
        
        return view
    }
    
    
    
    func centerMapOnUserButtonClicked(_ view: MKMapView) {
        view.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context){
        //print("UPDATE updateUIView")
        
    }
    
    func placeIsComplete(place: Place) -> Bool{
        return completions.firstIndex(where: {$0.placeId == place.id}) != nil
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
            renderer.strokeColor = UIColor.gray
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

struct RegionsMap_Previews: PreviewProvider {
    static var previews: some View {
        RegionsMapController()
    }
}





internal final class PlaceAnnotationView: MKMarkerAnnotationView {
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //displayPriority = .required
        //collisionMode = .circle
        //centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
    
    func configure(with annotation: MKAnnotation) {
        guard annotation is PlaceAnnotation else { fatalError("Unexpected annotation type: \(annotation)") }
        let placeAnnotation = annotation as! PlaceAnnotation
        //markerTintColor = placeAnnotation.completed ? UIColor.green : UIColor.red
        markerTintColor = AppStyle.color(for: placeAnnotation.place.category)
        glyphImage = UIImage(named: "mapicon.\(placeAnnotation.place.category)")
    }
}
