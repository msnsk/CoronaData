//
//  LocationViewModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/25.
//

//import CoreLocation
//import Combine
//
//final class LocationViewModel: NSObject, ObservableObject {
//    let manager: LocationManager
//    var cancellables = Set<AnyCancellable>()
//    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
//    @Published var location = CLLocation()
//    @Published var administrativeArea = "Hokkaido"
//
//    init(manager: LocationManager) {
//        self.manager = manager
//    }
//    
//    func requestAuthorization() {
//        manager.requestAuthorization()
//    }
//
//    func activate() {
//        manager.authorizationPublisher().print("dump:status").sink { [weak self] authorizationStatus in
//            guard let self = self else { return }
//            self.authorizationStatus = authorizationStatus
//        }.store(in: &cancellables)
//
//        manager.locationPublisher().print("dump:location").sink { [weak self] locations in
//            guard let self = self else { return }
//            if let last = locations.last {
//                self.location = last
//            }
//        }.store(in: &cancellables)
//    }
//
//    func deactivate() {
//        cancellables.removeAll()
//    }
//
//    func startUpdatingLocation() {
//        manager.startUpdatingLocation()
//    }
//
//    func stopUpdatingLocation() {
//        manager.stopUpdatingLocation()
//    }
//    
//    func getCurrentLocation() {
//        manager.lookUpCurrentLocation { location in
//            if let location = location {
//                if let area = location.administrativeArea {
//                    self.administrativeArea = area
//                }
//            }
//        }
//    }
//}
