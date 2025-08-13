//
//  PlaceView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI
import CoreLocation
import Foundation
import SafariServices

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

// 화면에 뿌릴 카드 모델(랜덤 속성 포함)
private struct PlaceCard: Identifiable {
    let id: String
    let title: String
    let categoryName: String
    let link: URL?
    let rating: String
    let hoursText: String
    let statusText: String
}

struct PlaceView: View {
    @EnvironmentObject var search: SearchContext

    // 타이머
    @State private var remainingTime: Int = 120
    @State private var timerActive: Bool = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // 데이터
    @State private var cards: [PlaceCard] = []
    @State private var isLoading = false
    @State private var loadError: String?

    // 인앱 사파리
    @State private var safariURL: URL?

    // 네비게이션
    @State private var moveToPlaceResultView: Bool = false
    
    // 하트 선택 개수
    @State private var selectedPlaceIDs: Set<String> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20) {

                    Text(search.category.isEmpty ? "추천" : search.category)
                        .font(.title)
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, -15)

                    // 상단 타이틀, 타이머
                    HStack {
                        Text("식당 선택")
                            .font(.largeTitle).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Group {
                            Image(systemName: "timer.circle.fill").font(.title2)
                            Text(timeString(from: remainingTime))
                                .font(.title).monospacedDigit()
                        }
                        .foregroundColor(timerActive ? .orange : .gray)
                    }
                    .padding(.horizontal)

                    Text("방문해보고싶은 가게를 pick! 해 보세요.\n(최대 3개 선택 가능)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // 리스트
                    VStack(alignment: .leading, spacing: 20) {
                        if isLoading {
                            ProgressView("주변 검색 중...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if let err = loadError {
                            Text("불러오는 중 오류가 발생했어요: \(err)")
                                .foregroundColor(.red)
                                .fixedSize(horizontal: false, vertical: true)
                        } else if cards.isEmpty {
                            Text("주변에 표시할 결과가 없어요.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(cards) { card in
                                // ✅ 카드 '탭' = 링크 열기(인앱 사파리)
                                Button {
                                    safariURL = card.link
                                } label: {
                                    ImageCardView(
                                        title: card.title,
                                        category: card.categoryName,
                                        status: card.statusText,
                                        hours: card.hoursText,
                                        rating: card.rating,
                                        isEnabled: timerActive,
                                        isSelected: selectedPlaceIDs.contains(card.id),
                                        selectedCount: selectedPlaceIDs.count,
                                        onVote: {
                                            if selectedPlaceIDs.contains(card.id) {
                                                selectedPlaceIDs.remove(card.id)
                                            } else if selectedPlaceIDs.count < 3 {
                                                selectedPlaceIDs.insert(card.id)
                                            } else {
                                                // do nothing when already at limit
                                            }
                                            // TODO: 서버 투표 API 연결 (선택/해제에 맞춰 갱신)
                                        }
                                    )
                                }
                            }
                        }
                    }

                    // 결과 보기
                    Button(action : { moveToPlaceResultView = true }) {
                        Text(timerActive ? "\(timeString(from: remainingTime)) 후 결과 보기" : "결과 보기")
                            .font(.title).bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding()
                            .background(timerActive ? Color.gray.opacity(0.4) : Color.orange)
                            .cornerRadius(20)
                    }
                    .disabled(timerActive)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $moveToPlaceResultView) {
                PlaceResultView()
            }
        }
        // 타이머
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if remainingTime > 0 { remainingTime -= 1 } else { timerActive = false }
        }
        // 검색 트리거
        .onAppear { runSearch() }
        .onChange(of: search.center) { _, _ in runSearch() }
        .onChange(of: search.radius) { _, _ in runSearch() }
        .onChange(of: search.category) { _, _ in runSearch() }
        // 인앱 사파리
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }

    private func runSearch() {
        // 좌표는 MapView에서 설정한 값만 사용
        guard let coord = search.center else {
            self.loadError = "검색 위치가 설정되지 않았어요. 지도에서 위치를 먼저 선택해 주세요."
            self.cards = []
            self.isLoading = false
            return
        }

        let radius = min(max(search.radius, 10), 20000)
        let query = search.category.isEmpty ? "맛집" : search.category

        isLoading = true
        loadError = nil

        Task {
            do {
                let places = try await KakaoPlaceService.shared.search(
                    query: query, center: coord, radius: radius
                )
                // 무작위 섞고 상위 6개 + 랜덤 속성 부여
                let randomized = Array(places.shuffled().prefix(6))
                let mapped = randomized.map { p in
                    let distMeters: String? = p.distance
                    let distanceText: String = {
                        if let d = distMeters, let m = Int(d) {
                            return "\(m)m"
                        }
                        return ""
                    }()
                    let hours: String = {
                        let rand = Self.randomHoursText()
                        return distanceText.isEmpty ? rand : "\(distanceText) · \(rand)"
                    }()
                    return PlaceCard(
                        id: p.id,
                        title: p.place_name,
                        categoryName: p.category_name ?? query,
                        link: URL(string: p.place_url ?? ""),
                        rating: Self.randomRatingText(),
                        hoursText: hours,
                        statusText: "영업 중"
                    )
                }
                await MainActor.run {
                    self.cards = mapped
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.loadError = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    private static func randomRatingText() -> String {
        let r = Double.random(in: 3.8...5.0)
        return String(format: "%.1f", r)
    }

    private static func randomHoursText() -> String {
        // 시작 09~13시, 종료 18~23시 중 시작 < 종료 보장
        let openH = Int.random(in: 9...13)
        let closeH = Int.random(in: max(openH+6, 18)...23)
        return String(format: "%02d:00 - %02d:00", openH, closeH)
    }
}

// 타이머 표시
private func timeString(from seconds: Int) -> String {
    let m = seconds / 60, s = seconds % 60
    return String(format: "%02d:%02d", m, s)
}

// 인앱 사파리
private struct SafariView: UIViewControllerRepresentable, Identifiable {
    let id = UUID()
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

// 이미지 카드 뷰
private struct ImageCardView: View {
    var title: String
    var category: String
    var status: String
    var hours: String
    var rating: String
    var isEnabled: Bool
    var isSelected: Bool
    var selectedCount: Int
    var onVote: () -> Void
    
    private var displayCategory: String {
        let trimmed = category.trimmingCharacters(in: .whitespacesAndNewlines)
        // 카테고리 문자열을 '>' 기준으로 분해하되, 양옆 공백 제거
        let parts = trimmed
            .split(separator: ">")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        if parts.isEmpty { return trimmed }
        // 첫 토큰이 "음식점"을 포함하면 제거하고 나머지만 조합
        if let first = parts.first, first.contains("음식점") {
            let rest = parts.dropFirst()
            return rest.isEmpty ? "" : rest.joined(separator: " > ")
        }
        // 그 외에는 마지막 세부 카테고리만 노출(원하면 라인 아래를 주석 해제/변경)
        // return parts.last ?? trimmed
        return parts.joined(separator: " > ")
    }

    var body: some View {
        ZStack {
            // 배경 프레임: 연회색 + 라운드 + 얇은 외곽선 + 살짝 그림자
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)

            VStack(alignment: .leading, spacing: 8) {
                // 상단: 평점 배지 + 우상단 하트 버튼(주황 원형)
                HStack(spacing: 8) {
                    Text("★ \(rating)")
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .foregroundColor(.orange)
                        .background(Color.white)
                        .clipShape(Capsule())

                    Spacer()

                    Button {
                        onVote()
                    } label: {
                        Image(systemName: isSelected ? "heart.fill" : "heart")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(isSelected ? .orange : .secondary)
                            .frame(width: 32, height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(!isEnabled || (!isSelected && selectedCount >= 3))
                    .opacity((isEnabled && (isSelected || selectedCount < 3)) ? 1 : 0.4)
                }

                // 가운데: 가게 이름(볼드) + 카테고리(작게, 회색)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(title)
                        .font(.title3).bold()
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(displayCategory)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Spacer()
                }

                // 하단: 영업 상태 + 시간
                Text("\(status) · \(hours)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
        }
        .overlay(alignment: .bottomTrailing) {
            ZStack {
                Circle().fill(Color.white)
                Circle().stroke(Color.black.opacity(0.12), lineWidth: 1)
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.black)
            }
            .frame(width: 34, height: 34)
            .padding(.trailing, 14)
            .padding(.bottom, 10)
        }
        // 선택 마감 오버레이
        .overlay {
            if !isEnabled {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.black.opacity(0.45))
                Text("선택 마감")
                    .font(.headline).bold()
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
    }
}

// ===== Kakao 모델/서비스 =====

struct KakaoKeywordResponse: Decodable { let documents: [KakaoKeywordPlace] }
struct KakaoKeywordPlace: Decodable, Identifiable {
    let id: String
    let place_name: String
    let road_address_name: String?
    let address_name: String?
    let phone: String?
    let x: String
    let y: String
    let place_url: String?
    let category_name: String?
    let distance: String?
}

final class KakaoPlaceService {
    static let shared = KakaoPlaceService()
    private init() {}
    func search(query: String, center: CLLocationCoordinate2D, radius: Int) async throws -> [KakaoKeywordPlace] {
        var comps = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json")!
        comps.queryItems = [
            .init(name: "query", value: query),
            .init(name: "x", value: String(center.longitude)),
            .init(name: "y", value: String(center.latitude)),
            .init(name: "radius", value: String(radius)),
            .init(name: "size", value: "15"),
            .init(name: "sort", value: "distance")
        ]
        var req = URLRequest(url: comps.url!)
        let key = AppConfig.kakaoRestAPIKey
        precondition(!key.isEmpty, "KAKAO_REST_API_KEY is empty. Check Secrets.plist & Target Membership.")
        req.addValue("KakaoAK \(key)", forHTTPHeaderField: "Authorization")
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw NSError(domain: "KakaoPlaceService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kakao API 응답 오류"])
        }
        return try JSONDecoder().decode(KakaoKeywordResponse.self, from: data).documents
    }
}

#Preview {
    // 프리뷰 전용 임시 위치/반경 주입
    let sc = SearchContext()
    sc.center = CLLocationCoordinate2D(latitude: 37.561, longitude: 126.946)
    sc.radius = 800 // 0.8km
    sc.category = "" // 전체 맛집
    
    return PlaceView()
        .environmentObject(sc)
}
