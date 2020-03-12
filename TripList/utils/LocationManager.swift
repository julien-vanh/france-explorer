//
//  https://stackoverflow.com/questions/57681885/how-to-get-current-location-using-swiftui-without-viewcontrollers
//
import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var nearestPlaces: [Place]? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    public func isLocationEnable() -> Bool{
        return lastLocation != nil
    }
    
    public func distanceTo(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        if let userLocation = lastLocation {
            return MKMapPoint(userLocation.coordinate).distance(to: MKMapPoint(coordinate))
        }
        return -1.0
    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        self.nearestPlaces = PlaceStore.shared.getNearestPlaces(position: location.coordinate, count: 9, premium: AppState.shared.isPremium)
        print(#function, location)
    }

}
