//
//  Endpoint.swift
//  SeSACWeek6
//
//  Created by 이중원 on 2022/08/08.
//

import Foundation
import SwiftUI

//enum에서 저장 프로퍼티는 못 쓰고 연산 프로퍼티는 쓸 수 있는 이유?
enum Endpoint {
    case blog
    case cafe
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndpointString("blog?query=")
        case .cafe:
            return URL.makeEndpointString("cafe?query=")
        }
    }
}
