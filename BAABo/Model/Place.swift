//
//  Place.swift
//  BAABo
//
//  Created by 김찬영 on 8/5/25.
//

//// Place.swift (Model)
import Foundation
import CoreLocation

struct Place: Identifiable {
    let id : String             // kakao place_id
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: String?       // kakao category name
    let placeURL: URL?          // kakao place_url
    
    // 화면 표시용
    var rating: Double?
    var ratingCount: Int?
    var isOpenNow: Bool?
    var todayHours: String?
    var imageName: String?
}
