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
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

