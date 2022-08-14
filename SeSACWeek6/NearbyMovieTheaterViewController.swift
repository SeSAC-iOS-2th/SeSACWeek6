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
    
    let CGVInfo: [String: [Double]] = ["CGV 영등포": [37.517135, 126.903685], "CGV여의도": [37.525078, 126.925905], "CGV 구로": [37.501136, 126.882770], "CGV 목동": [37.526522, 126.875187]]
    let lotteInfo: [String: [Double]] = ["롯데시네마 영등포": [37.516190, 126.908323], "롯데시네마 용산": [37.532800, 126.959707], "롯데시네마 홍대": [37.557297, 126.925099], "롯데시네마 신림": [37.483778, 126.930211]]
    let megaInfo: [String : [Double]] = ["메가박스 홍대": [37.555991, 126.922044], "메가박스 신촌": [37.559769, 126.941903], "메가박스 목동": [37.529050, 126.876048], "메가박스 화곡": [37.540604, 126.837607]]
    
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
                
        for info in CGVInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
        for info in lotteInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
        for info in megaInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
    }

    @IBAction func FilterButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController()
        
        let megaBox = UIAlertAction(title: "메가박스", style: .default, handler: {action in self.megaBoxButtonClicked()
        })
        let lotteCinema = UIAlertAction(title: "롯데시네마", style: .default, handler: {action in self.lotteCinemaButtonClicked()
        })
        let CGV = UIAlertAction(title: "CGV", style: .default, handler: {action in self.CGVButtonClicked()
        })
        let all = UIAlertAction(title: "전체보기", style: .default, handler: {action in self.allButtonClicked()
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(megaBox)
        alert.addAction(lotteCinema)
        alert.addAction(CGV)
        alert.addAction(all)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
    func CGVButtonClicked() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for info in CGVInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
    }
    func lotteCinemaButtonClicked() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for info in lotteInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
    }
    func megaBoxButtonClicked() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for info in megaInfo {
            let annotation = setAnnotation(title: info.key, latitude: info.value[0], longitude: info.value[1])
            mapView.addAnnotation(annotation)
        }
    }
    func allButtonClicked() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let center = CLLocationCoordinate2D(latitude: 37.51190, longitude: 126.90345)
        setRegionAndMovieAnnotation(center: center)
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
