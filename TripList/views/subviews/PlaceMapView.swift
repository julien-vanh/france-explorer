//
//  Map.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceMapView: UIViewRepresentable {
    var place: Place

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.showsUserLocation = true
        view.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 4.0)
        let region = MKCoordinateRegion(center: place.locationCoordinate, span: span)
        view.setRegion(region, animated: true)
        
        
        view.removeAnnotations(view.annotations)
        let annotation = PlaceAnnotation(place: place, style: .Colored)
        view.addAnnotation(annotation)
        //view.selectAnnotation(annotation, animated: true)
        
        if view.annotations.count > 1 {
            view.showAnnotations(view.annotations, animated: false)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceMapView(place: PlaceStore.shared.getRandom(count: 1, premium: false)[0])
    }
}
