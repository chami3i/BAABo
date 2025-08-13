//
//  KakaoLocalService.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import Foundation
import CoreLocation

struct KakaoSearchResponse: Decodable {
    struct Document: Decodable {
        let id: String
        let place_name: String
        let category_name: String?
        let x: String       // longitude
        let y: String       // latitude
        let place_url: String?
        let distance: String?
    }
    let documents: [Document]
}

final class KakaoLocalService {
    private let session = URLSession(configuration: .default)
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // 키워드 + 반경 검색
    func searchRestaurants(keyword: String,
                           center: CLLocationCoordinate2D,
                           radiusMeters: Int,
                           page: Int = 1,
                           size: Int = 15) async throws -> [Place] {
        
        var comps = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json")!
        comps.queryItems = [
            .init(name: "query", value: keyword),
            .init(name: "x", value: "\(center.longitude)"),
            .init(name: "y", value: "\(center.latitude)"),
            .init(name: "radius", value: "\(radiusMeters)"),
            .init(name: "size", value: "\(size)"),
            .init(name: "page", value: "\(page)")
        ]
        
        var req = URLRequest(url: comps.url!)
        req.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, resp) = try await session.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw NSError(domain: "Kakao", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kakao search failed"])
        }
        
        let decoded = try JSONDecoder().decode(KakaoSearchResponse.self, from: data)
        return decoded.documents.map { d in
            let lat = Double(d.y) ?? 0
            let lon = Double(d.x) ?? 0
            return Place(
                id: d.id,
                name: d.place_name,
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                category: d.category_name,
                placeURL: d.place_url.flatMap { URL(string: $0) },
                rating: nil, ratingCount: nil, isOpenNow: nil, todayHours: nil, imageName: nil
            )
        }
    }
}
