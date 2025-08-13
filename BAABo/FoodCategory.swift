//
//  FoodCategory.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import Foundation

enum FoodCategory: String, CaseIterable {
    case jokbalBossam = "족발·보쌈"
    case japanese = "돈가스·회·일식"
    case meatGrill = "고기·구이"
    case pizzaChickenBurger = "피자·치킨·버거"
    case stewSoup = "찜·탕·찌개"
    case western = "양식"
    case chinese = "중식"
    case asian = "아시안"
    case bunsik = "분식"

    // Kakao API 검색에 사용할 키워드
    var keyword: String {
        switch self {
        case .jokbalBossam:
            return "족발 보쌈"
        case .japanese:
            return "돈가스 회 일식"
        case .meatGrill:
            return "고기 구이"
        case .pizzaChickenBurger:
            return "피자 치킨 버거"
        case .stewSoup:
            return "찜 탕 찌개"
        case .western:
            return "양식"
        case .chinese:
            return "중식"
        case .asian:
            return "아시안 음식점"
        case .bunsik:
            return "분식"
        }
    }

    // UI에 표시할 이미지 파일명
    var imageName: String {
        switch self {
        case .jokbalBossam:
            return "보쌈"
        case .japanese:
            return "초밥"
        case .meatGrill:
            return "고기"
        case .pizzaChickenBurger:
            return "버거"
        case .stewSoup:
            return "수프"
        case .western:
            return "파스타"
        case .chinese:
            return "핫팟"
        case .asian:
            return "아시안"
        case .bunsik:
            return "떡볶이"
        }
    }
}
