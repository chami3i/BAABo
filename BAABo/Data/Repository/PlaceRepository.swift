//
//  PlaceRepository.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import CoreLocation

protocol PlaceRepository {
    func pickSix(
        center: CLLocationCoordinate2D,
        radius: Int,
        categoryKeyword: String
    ) async throws -> [Place]
}

final class PlaceRepositoryImpl: PlaceRepository {
    private let kakao: KakaoLocalService
    private let overrides: [PlaceOverride]
    
    init(kakao: KakaoLocalService, overrides: [PlaceOverride]) {
        self.kakao = kakao
        self.overrides = overrides
    }
    
    func pickSix(center: CLLocationCoordinate2D, radius: Int, categoryKeyword: String) async throws -> [Place] {
        // 1. 후보 2페이지까지 (최대 30개) 모아서 랜덤성 ^
        let page1 = try await kakao.searchRestaurants(keyword: categoryKeyword, center: center, radiusMeters: radius, page:1, size: 15)
        let page2 = try? await kakao.searchRestaurants(keyword: categoryKeyword, center: center, radiusMeters: radius, page:2, size: 15)
        var all = page1 + (page2 ?? [])
        
        // 2. 랜덤 6개
        all.shuffle()
        var six = Array(all.prefix(6))
        
        // 3. 로컬 오버라이드 병합 (kakaoId -> name 순으로 매칭)
        for i in six.indices {
            if let m = overrides.first(where: { $0.kakaoId == six[i].id }) ?? overrides.first(where: { $0.name == six[i].name }) {
                six[i].rating = m.rating ?? six[i].rating
                six[i].ratingCount = m.ratingCount ?? six[i].ratingCount
                six[i].isOpenNow = m.isOpenNow ?? six[i].isOpenNow
                six[i].todayHours = m.todayHours ?? six[i].todayHours
                six[i].imageName = m.imageName ?? six[i].imageName
            }
        }
        return six
    }
}
