//
//  HomeView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 1
    @State private var didLike: Bool? = nil
    // 퀘스트 상태 저장 (획득 여부)
    @State private var collected: [Bool] = Array(repeating: false, count: 9)
    // 오늘의 메뉴는 최초 한 번만 선택해 보관
    @State private var todayMenu: TodayMenuItem? = nil
    
    let nickname = "홍길동"
    let place = "오모오모 신세계점"
    
    // 그리드 레이아웃 (4열)
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    // 퀘스트 설명 목록
    private let quests = [
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
    
    // 프로필 배경 색상 팔레트
    let gradientColors: [[Color]] = [
        [Color.red, Color.orange],
        [Color.blue, Color.purple],
        [Color.green, Color.yellow],
        [Color.pink, Color.teal],
        [Color.indigo, Color.mint]
    ]
    
    // 이름 기반으로 고정 그라데이션 선택
    func gradientFor(_ name: String) -> [Color] {
        let idx = abs(name.hashValue) % gradientColors.count
        return gradientColors[idx]
    }
    
    let menuItems: [TodayMenuItem] = [
        TodayMenuItem(name: "비빔밥", category: "한식", emoji: "🍚", description: "다양한 재료가 한 그릇에 쏙! 맛과 건강을 모두 담은 비빔밥!"),
        TodayMenuItem(name: "라멘", category: "일식", emoji: "🍜", description: "따뜻하고 깊은 국물의 일본식 라멘 어때요~?"),
        TodayMenuItem(name: "파스타", category: "양식", emoji: "🍝", description: "입안 가득 퍼지는 크림과 토마토의 조화, 오늘은 파스타로 기분 전환"),
        TodayMenuItem(name: "떡볶이", category: "분식", emoji: "🌶️", description: "쫄깃한 떡과 매콤달콤 소스의 완벽한 조화! 오늘은 떡볶이로 스트레스 탈출!"),
        TodayMenuItem(name: "김치찌개", category: "한식", emoji: "🥘", description: "한국인의 소울푸드, 집밥 같은 정겨운 김치찌개 한 그릇 어떠세요?"),
        TodayMenuItem(name: "샐러드", category: "양식", emoji: "🥗", description: "칼로리 걱정 없이 든든하게, 신선함 가득한 샐러드 한 그릇")
    ]
    
    @State private var isNavigating = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    ZStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(height: 130)
                            .cornerRadius(16)
                        
                        HStack {
                            Text("식당 정하러\n떠나자!")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Button(action: {
                                isNavigating = true
                            }) {
                                HStack(spacing: 6) {
                                    Text("방 만들기")
                                        .font(.body)
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.black)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                    
                    // 🥘 오늘의 메뉴 추천 (한 번만 선택한 값을 표시)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("오늘의 메뉴 추천")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 120)
                            .overlay(
                                Group {
                                    if let menu = todayMenu {
                                        HStack(spacing: 16) {
                                            Text(menu.emoji)
                                                .font(.system(size: 48))
                                            
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(menu.name)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)
                                                Text(menu.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    } else {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            )
                    }
                    
                    Spacer()
                    
                    // 🎯 챌린지
                    VStack(alignment: .leading, spacing: 8) {
                        Text("챌린지")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        Spacer()

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                            ForEach(0..<quests.count, id: \.self) { index in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        collected[index].toggle()
                                    }
                                } label: {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(collected[index] ? Color.orange : Color.gray.opacity(0.25))
                                            
                                            Image(systemName: "star.fill") // 별은 항상 흰색, 테두리 없음
                                                .font(.system(size: 34, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())        // ✅ 사각형 아티팩트 제거
                                        .contentShape(Circle())     // ✅ 히트영역도 원
                                        .compositingGroup()         // ✅ 오프스크린 컴포지팅
                                        .shadow(radius: collected[index] ? 4 : 0)

                                        Text(quests[index])
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 80, height: 34)
                                    }
                                }
                                .buttonStyle(.plain) // 기본 버튼 효과 제거
                            }
                        }
                    }

                    // 📝 최근 방문 식당 리뷰
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(nickname)님, 최근에 방문하신\n\(place) 어떠셨어요?")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            // 👍 좋았다 버튼
                            Button(action: {
                                didLike = true
                            }) {
                                HStack { Text("👍") }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(didLike == true ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(didLike == true ? Color.green : Color.clear, lineWidth: 1)
                                    )
                            }
                            
                            // 👎 싫었다 버튼
                            Button(action: {
                                didLike = false
                            }) {
                                HStack { Text("👎") }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(didLike == false ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(didLike == false ? Color.red : Color.clear, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 📌 최근에 결정한 식당
                    VStack(alignment: .leading, spacing: 8) {
                        Text("최근에 결정한 식당")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(height: 60)
                                .shadow(radius: 3)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("버거킹 포항공대점")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("경북 포항시 남구 청암로 77 · 11:00 - 20:00")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8),
                                    alignment: .leading
                                )
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(height: 60)
                                .shadow(radius: 3)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("탐솥 효자점")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("경북 포항시 남구 효자동길5번길 17 · 11:00 - 21:00")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8),
                                    alignment: .leading
                                )
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(height: 60)
                                .shadow(radius: 3)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("수가성")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("경북 포항시 북구 상대로 31 · 00:00 - 24:00")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8),
                                    alignment: .leading
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // 📌 최근에 함께한 사람들
                    VStack(alignment: .leading, spacing: 8) {
                        Text("최근에 함께한 사람들")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                            ForEach(people, id: \.name) { person in
                                VStack(spacing: 8) {
                                    if let imageName = person.imageName, !imageName.isEmpty {
                                        // ✅ 이미지가 있는 경우
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        // ✅ 이미지가 없는 경우: 이름 기반 고정 그라데이션 + 이니셜
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: gradientFor(person.name)),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 70, height: 70)
                                            
                                            Text(String(person.name.prefix(1)))
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Text(person.name)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .navigationDestination(isPresented: $isNavigating) {
                    MapView()
                }
            }
            .onAppear {
                if todayMenu == nil {
                    todayMenu = menuItems.randomElement()
                }
            }
        }
    }
}

struct Person {
    let name: String
    let imageName: String?
}

struct TodayMenuItem {
    let name: String
    let category: String
    let emoji: String
    let description: String
}

#Preview {
    HomeView()
}
