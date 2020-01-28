//
//  RegionsMap.swift
//  TripList
//
//  Created by Julien Vanheule on 28/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit


struct RegionsMapController: UIViewRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context){
        //If you changing the Map Annotation then you have to remove old Annotations
        //mapView.removeAnnotations(mapView.annotations)
        view.delegate = context.coordinator
        
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
            print("Nombre d'overlay \(overlays.count)")
            view.addOverlays(overlays)
        }
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
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor.red
            renderer.fillColor = UIColor.blue
            
            return renderer
        }
    }
}

struct RegionsMap_Previews: PreviewProvider {
    static var previews: some View {
        RegionsMapController()
    }
}



/*
 
 view.delegate = self
 

 */
