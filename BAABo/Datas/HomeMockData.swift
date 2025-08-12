//
//  HomeMockData.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import SwiftUI


// 퀘스트 설명 목록
let quests = [
    "앱 첫 접속",
    "첫 추천 식당 받기",
    "식당 리뷰 남기기",
    "방 만들기",
    "랜덤 식당 선택",
    "친구와 의견 일치하기",
    "방장 되기",
    "즐겨찾기 추가",
    "랜덤 추천 10번 달성",
]

let people: [Person] = [
    Person(name: "챔", imageName: nil),
    Person(name: "제인", imageName: nil),
    Person(name: "젤리", imageName: nil),
    Person(name: "옥돌", imageName: nil),
    Person(name: "렌", imageName: nil),
]

// 프로필 배경 색상
let gradientColors: [[Color]] = [
    [Color.red, Color.orange],
    [Color.blue, Color.purple],
    [Color.green, Color.yellow],
    [Color.pink, Color.teal],
    [Color.indigo, Color.mint]
]

var randomGradient: [Color] {
    gradientColors.randomElement() ?? [Color.gray, Color.gray]
}

let menuItems: [TodayMenuItem] = [
    TodayMenuItem(name: "비빔밥", category: "한식", emoji: "🍚", description: "다양한 재료가 한 그릇에 쏙! 맛과 건강을 모두 담은 비빔밥!"),
    TodayMenuItem(name: "라멘", category: "일식", emoji: "🍜", description: "따뜻하고 깊은 국물의 일본식 라멘 어때요~?"),
    TodayMenuItem(name: "파스타", category: "양식", emoji: "🍝", description: "입안 가득 퍼지는 크림과 토마토의 조화, 오늘은 파스타로 기분 전환"),
    TodayMenuItem(name: "떡볶이", category: "분식", emoji: "🌶️", description: "쫄깃한 떡과 매콤달콤 소스의 완벽한 조화! 오늘은 떡볶이로 스트레스 탈출!"),
    TodayMenuItem(name: "김치찌개", category: "한식", emoji: "🥘", description: "한국인의 소울푸드, 집밥 같은 정겨운 김치찌개 한 그릇 어떠세요?"),
    TodayMenuItem(name: "샐러드", category: "양식", emoji: "🥗", description: "칼로리 걱정 없이 든든하게, 신선함 가득한 샐러드 한 그릇")
]
