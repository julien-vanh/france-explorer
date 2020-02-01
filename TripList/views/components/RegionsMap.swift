//
//  RegionsMap.swift
//  TripList
//
//  Created by Julien Vanheule on 28/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit
import Combine


struct RegionsMapController: UIViewRepresentable {
    @EnvironmentObject var session: Session
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context){
        view.delegate = context.coordinator
        view.mapType = .mutedStandard
        
        view.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.183753, longitude: 2.4)
        let span = MKCoordinateSpan(latitudeDelta: 14.5, longitudeDelta: 14.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        if let file = Bundle.main.url(forResource: "regions", withExtension: "geojson"),
            let data = try? Data(contentsOf: file),
            let geojsonFeatures = try? MKGeoJSONDecoder().decode(data),
            let features = geojsonFeatures as? [MKGeoJSONFeature]
        {
                
            let geometry = features.flatMap( {$0.geometry})
            let overlays = geometry.compactMap({$0 as? MKOverlay})
            view.addOverlays(overlays, level: MKOverlayLevel.aboveRoads)
            
            let places = placesData
            let annotations = places.map{PlaceAnnotation(place: $0, completed: session.isCompleted(placeId: $0.id))}
            view.addAnnotations(annotations)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RegionsMapController

        init(_ map: RegionsMapController) {
            self.parent = map
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let alpha = CGFloat(0.4)
            let colors: [UIColor] = [
                UIColor.init(red: 244/255, green: 67/255, blue: 54/255, alpha: alpha),
                UIColor.init(red: 33/255, green: 150/255, blue: 243/255, alpha: alpha),
                UIColor.init(red: 255/255, green: 235/255, blue: 59/255, alpha: alpha),
                UIColor.init(red: 121/255, green: 85/255, blue: 72/255, alpha: alpha),
            ]
            
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
            renderer.fillColor = colors.randomElement()
            
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is PlaceAnnotation {
                let placeAnnotation = view.annotation as! PlaceAnnotation
                print(placeAnnotation.place.title)
            }
        }
    }
}

struct RegionsMap_Previews: PreviewProvider {
    static var previews: some View {
        RegionsMapController().environmentObject(Session())
    }
}





internal final class PlaceAnnotationView: MKMarkerAnnotationView {
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .required
        //collisionMode = .circle
        //centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
    
    func configure(with annotation: MKAnnotation) {
        guard annotation is PlaceAnnotation else { fatalError("Unexpected annotation type: \(annotation)") }
        let placeAnnotation = annotation as! PlaceAnnotation
        markerTintColor = placeAnnotation.completed ? UIColor.green : UIColor.red
        glyphImage = UIImage(named: "mapicon.\(placeAnnotation.place.category)")
    }
}
