//
//  PlaceResultContainerView.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import SwiftUI
import CoreLocation

// Kakao 검색 → 최대 30개 모은 뒤 랜덤 6개 셔플 → 그중 1개를 선택해 PlaceResultView(UI 그대로)에 주입
struct PlaceResultContainerView: View {
    let center: CLLocationCoordinate2D
    let radiusMeters: Int
    let categoryKeyword: String
    let fallbackImageName: String   // 이미지가 없을 때 사용할 기본 이미지 이름

    @StateObject private var vm: RestaurantListViewModel

    init(center: CLLocationCoordinate2D,
         radiusMeters: Int,
         categoryKeyword: String,
         fallbackImageName: String = "yourFoodImage") {

        self.center = center
        self.radiusMeters = radiusMeters
        self.categoryKeyword = categoryKeyword
        self.fallbackImageName = fallbackImageName

        // Kakao 기반 레포 구성 (오버라이드 사용 안 함)
        let kakao = KakaoLocalService(apiKey: AppConfig.kakaoRestAPIKey)
        let repo = PlaceRepositoryImpl(kakao: kakao, overrides: [])
        _vm = StateObject(wrappedValue: RestaurantListViewModel(repo: repo))
    }

    var body: some View {
        Group {
            if let one = vm.items.first {
                // vm.items에서 최대 3개 후보를 구성 (무작위)
                let picks = Array(vm.items.shuffled().prefix(3))
                let candidates = picks.map { item in
                    let idSource = item.placeURL?.absoluteString ?? item.name
                    return PlaceResultView.Candidate(
                        id: idSource,
                        title: item.name,
                        kakaoURL: item.placeURL
                    )
                }
                PlaceResultView(candidates: candidates)
            } else if vm.isLoading {
                ProgressView("주변 가게 찾는 중…")
                    .padding()
            } else if let err = vm.error {
                VStack(spacing: 12) {
                    Text("불러오기 실패")
                        .font(.headline)
                    Text(err).foregroundStyle(.secondary)
                    Button("다시 시도") {
                        Task {
                            await vm.load(center: center, radius: radiusMeters, categoryKeyword: categoryKeyword)
                        }
                    }
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                    Text("결과가 없습니다.")
                        .font(.headline)
                    Button("다시 시도") {
                        Task {
                            await vm.load(center: center, radius: radiusMeters, categoryKeyword: categoryKeyword)
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            // 최대 30개 중 셔플된 6개를 로드하고, 그중 첫 번째를 사용
            await vm.load(center: center, radius: radiusMeters, categoryKeyword: categoryKeyword)
        }
    }
}

#Preview {
    // 미리보기용 더미 좌표 (서울시청 근처)
    let demoCenter = CLLocationCoordinate2D(latitude: 37.5662952, longitude: 126.9779451)
    NavigationStack {
        PlaceResultContainerView(
            center: demoCenter,
            radiusMeters: 800,
            categoryKeyword: "아시안 음식점",
            fallbackImageName: "yourFoodImage"
        )
    }
}
