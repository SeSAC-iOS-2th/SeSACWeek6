//
//  APIManager.swift
//  SeSACWeek6
//
//  Created by 이중원 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

struct User {
    fileprivate let name = "고래밥" //같은 스위프트 파일에서 다른 클래스, 구조체 사용 가능. 다른 스위프트 파일은 x
    private let age = 23 //같은 스위프트 파일 내에서 같은 타입에서 사용 가능
}

extension User {
    
    func example() {
        print(self.name, self.age)
    }
    
}

struct Person {
    
    func example() {
        let user = User()
//        user.name -> fileprivate으로 선언. 같은 스위프트 파일이라 오류x
//        user.age -> private으로 선언. 다른 타입(Person)이라 오류
    }
    
}

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    private let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        //Alamofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
