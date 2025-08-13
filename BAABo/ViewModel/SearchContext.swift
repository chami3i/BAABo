//
//  SearchContext.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import Foundation
import CoreLocation

final class SearchContext: ObservableObject {
    @Published var center: CLLocationCoordinate2D?  // 지도 중심(선택 위치)
    @Published var radius: Int = 1000               // m 단위 (슬라이더 값)
    @Published var category: String = ""            // 사용 중이면 활용, 아니면 무시해도 됨
}
