//
//  PlaceOverride.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

struct PlaceOverride: Codable {
    let kakaoId: String?        // 있으면 kakao id 로 매칭
    let name: String?           // 없으면 이름으로 매칭 (동일명 가게 충돌 가능)
    let imageName: String?
    let rating: Double?
    let ratingCount: Int?
    let isOpenNow: Bool?
    let todayHours: String?
}
