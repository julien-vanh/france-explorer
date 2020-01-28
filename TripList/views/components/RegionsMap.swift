//
//  RegionsMap.swift
//  TripList
//
//  Created by Julien Vanheule on 28/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

import SwiftUI
import MapKit

struct RegionsMap: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.183753, longitude: 2.4)

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 14.5, longitudeDelta: 14.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)
    }
}

struct RegionsMap_Previews: PreviewProvider {
    static var previews: some View {
        RegionsMap(coordinate: CLLocationCoordinate2D(latitude: 46.183753, longitude: 2.4))
    }
}
