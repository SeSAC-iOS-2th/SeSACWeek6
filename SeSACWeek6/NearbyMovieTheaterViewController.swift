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
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let center = CLLocationCoordinate2D(latitude: 37.51190, longitude: 126.90345)
        setRegionAndMovieAnnotation(center: center)

    }
    
    func setAnnotation(title: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        
        return annotation
    }
    

    func setRegionAndMovieAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
        let CGVInfo: [String: [Double]] = ["CGV 영등포": [37.517135, 126.903685], "CGV여의도": [37.525078, 126.925905]]
        let lotteInfo: [String: [Double]] = ["롯데시네마 영등포": [37.516190, 126.908323], "롯데시네마 용산": [37.532800, 126.959707]]
        let megaInfo: [String : [Double]] = ["메가박스 홍대": [37.555991, 126.922044], "메가박스 신촌": [37.559769, 126.941903]]
        
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
        
        let megaBox = UIAlertAction(title: "메가박스", style: .default, handler: nil)
        let lotteCinema = UIAlertAction(title: "롯데시네마", style: .default, handler: nil)
        let CGV = UIAlertAction(title: "CGV", style: .default, handler: nil)
        let all = UIAlertAction(title: "전체보기", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(megaBox)
        alert.addAction(lotteCinema)
        alert.addAction(CGV)
        alert.addAction(all)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
    @objc func megaBoxButtonClicked() {
        
    }
    @objc func lotteCinemaButtonClicked() {
        
    }
    @objc func megaButtonClicked() {
        
    }
    @objc func allButtonClicked() {
        
    }
}
