//
//  Map.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var place: Place

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.showsUserLocation = true
        view.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: place.locationCoordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = PlaceAnnotation(place: place, completed: false)
        
        view.addAnnotation(annotation)
        view.selectAnnotation(annotation, animated: false)
        view.showAnnotations(view.annotations, animated: false)
        //view
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: PlaceStore.shared.getRandom(count: 1)[0])
    }
}
