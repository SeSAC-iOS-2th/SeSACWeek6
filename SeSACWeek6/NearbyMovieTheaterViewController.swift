//
//  NearbyMovieTheaterViewController.swift
//  SeSACWeek6
//
//  Created by 이중원 on 2022/08/14.
//

import UIKit
import MapKit

class NearbyMovieTheaterViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        let center = CLLocationCoordinate2D(latitude: 37.51190, longitude: 126.90345)
        setRegionAndMovieAnnotation(center: center)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
    func setAnnotation(title: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        
        return annotation
    }
    

    func setRegionAndMovieAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
                
        MovieTheaterInfo.CGVInfo.forEach({ (key, value) in
            let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
            mapView.addAnnotation(annotation)
        })
        MovieTheaterInfo.lotteInfo.forEach({ (key, value) in
            let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
            mapView.addAnnotation(annotation)
        })
        MovieTheaterInfo.megaInfo.forEach({ (key, value) in
            let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
            mapView.addAnnotation(annotation)
        })
    }

    @IBAction func FilterButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController()
        
        let megaBox = UIAlertAction(title: "메가박스", style: .default, handler: {_ in self.movieTheaterButtonClicked("megaBox")
        })
        let lotteCinema = UIAlertAction(title: "롯데시네마", style: .default, handler: {_ in self.movieTheaterButtonClicked("lotteCinema")
        })
        let CGV = UIAlertAction(title: "CGV", style: .default, handler: {_ in self.movieTheaterButtonClicked("CGV")
        })
        let all = UIAlertAction(title: "전체보기", style: .default, handler: {_ in self.movieTheaterButtonClicked("all")
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(megaBox)
        alert.addAction(lotteCinema)
        alert.addAction(CGV)
        alert.addAction(all)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }

    func movieTheaterButtonClicked(_ movieTheater: String) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)

        switch movieTheater {
        case "CGV":
            MovieTheaterInfo.CGVInfo.forEach({ (key, value) in
                let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
                mapView.addAnnotation(annotation)
            })
        case "lotteCinema":
            MovieTheaterInfo.lotteInfo.forEach({ (key, value) in
                let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
                mapView.addAnnotation(annotation)
            })
        case "megaBox":
            MovieTheaterInfo.megaInfo.forEach({ (key, value) in
                let annotation = setAnnotation(title: key, latitude: value[0], longitude: value[1])
                mapView.addAnnotation(annotation)
            })
        case "all":
            let center = CLLocationCoordinate2D(latitude: 37.51190, longitude: 126.90345)
            setRegionAndMovieAnnotation(center: center)
        default: print("default")
        }
    }
}


extension NearbyMovieTheaterViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
    
    func showRequestLocationServiceAlert() {
        
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 이용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 활성화해주십시오.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancel)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}


extension NearbyMovieTheaterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            setRegionAndMovieAnnotation(center: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
