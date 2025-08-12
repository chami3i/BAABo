//
//  AppConfig.swift
//  BAABo
//

import Foundation

private struct AppSecrets: Decodable {
    let KAKAO_REST_API_KEY: String
}

enum AppConfig {
    // Secrets.plist에서 카카오 REST API 키를 읽어옴
    static let kakaoRestAPIKey: String = {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let secrets = try? PropertyListDecoder().decode(AppSecrets.self, from: data),
            !secrets.KAKAO_REST_API_KEY.isEmpty
        else {
            assertionFailure("Missing/invalid Secrets.plist or empty KAKAO_REST_API_KEY (Target Membership/키 이름 확인)")
            return "" // 비어 있으면 이후 precondition에서 방어
        }
        return secrets.KAKAO_REST_API_KEY
    }()
}
