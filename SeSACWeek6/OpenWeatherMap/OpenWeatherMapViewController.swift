//
//  OpenWeatherMapViewController.swift
//  SeSACWeek6
//
//  Created by 이중원 on 2022/08/16.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class OpenWeatherMapViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    
    @IBOutlet weak var temperatureTalkLabel: UILabel!
    @IBOutlet weak var humidityTalkLabel: UILabel!
    @IBOutlet weak var windTalkLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var greetingTalkLabel: UILabel!
    
    //37.512552, 126.902768
    let latitude = 37.512552
    let longitude = 126.902768
    
    var temp: Double = 9
    var humid: Int = 78
    var wind: Double = 1
    var iconURL: String = "https://openweathermap.org/img/wn/10d@2x.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(named: "cloud&rain")
        
        currentTimeLabel.text = getCurrentTime(date: Date())
        currentTimeLabel.textColor = .white
        currentTimeLabel.font = UIFont.systemFont(ofSize: 16)
        
        locationLabel.text = "서울, 영등포동"
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 22)
        
        designTalkLabel(label: temperatureTalkLabel, text: "지금은 \(String(format: "%.lf", temp))도에요")
        designTalkLabel(label: humidityTalkLabel, text: "\(humid)%만큼 습해요")
        designTalkLabel(label: windTalkLabel, text: "\(String(format: "%.lf", wind))m/s의 바람이 불어요")
        designTalkLabel(label: greetingTalkLabel, text: "오늘도 행복한 하루 보내세요")
        
        weatherImageView.kf.setImage(with: URL(string: iconURL))
        weatherImageView.backgroundColor = .white
        weatherImageView.layer.cornerRadius = 8
        
        requestWeather()
    }
    
    func requestWeather() {
        let url = OpenWeatherMapAPI.APIUrl+"lat=\(latitude)&lon=\(longitude)&appid=\(OpenWeatherMapAPI.APIKey)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.temp = json["main"]["temp"].doubleValue - 273.15
                self.humid = json["main"]["humidity"].intValue
                self.wind = json["wind"]["speed"].doubleValue
                self.iconURL = "https://openweathermap.org/img/wn/\(json["weather"][0]["icon"].stringValue)@2x.png"
                print(self.iconURL)
                
                                                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCurrentTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func designTalkLabel(label: UILabel, text: String) {
        label.text = text
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.sizeToFit()
    }

    @IBAction func initButtonClicked(_ sender: UIButton) {
        
        requestWeather()
        self.viewDidLoad()
        
    }
}
