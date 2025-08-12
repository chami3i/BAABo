//
//  AppConfig.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import Foundation

private struct Secrets: Decodable {
    let KAKAO_REST_API_KEY: String
}

enum AppConfig {
    static var kakaoRestAPIKey: String = {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let secrets = try? PropertyListDecoder().decode(Secrets.self, from: data)
        else {
            fatalError("Missing/invalid Secrets.plist")
        }
        return secrets.KAKAO_REST_API_KEY
    } ()
}
