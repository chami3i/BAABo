//
//  PlaceView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI
import CoreLocation
import Foundation

// MARK: - Secrets Loader (Secrets.plist에서만 읽음)
enum Secrets {
    static var kakaoRESTAPIKey: String {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let key = plist["KAKAO_REST_API_KEY"] as? String,
              !key.isEmpty
        else {
            assertionFailure("❌ Secrets.plist의 KAKAO_REST_API_KEY 로딩 실패. 파일/키 이름/Target Membership 확인")
            return ""
        }
        return key
    }
}

// MARK: - View
struct PlaceView: View {

    // 입력
    var category: String
    var radius: Int = 1000   // 검색 반경(m)

    // 타이머
    @State private var remainingTime: Int = 120
    @State private var timerActive: Bool = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // 네비게이션
    @State private var moveToPlaceResultView: Bool = false

    // 데이터
    @StateObject private var locationManager = SimpleLocationManager()
    @State private var places: [KakaoKeywordPlace] = []
    @State private var isLoading = false
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20){

                    Text("\(category)")
                        .font(.title)
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, -15)

                    // 상단 타이틀, 타이머 UI
                    HStack {
                        Text("식당 선택")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        Group {
                            Image(systemName: "timer.circle.fill")
                                .font(.title2)
                            Text(timeString(from: remainingTime))
                                .font(.title)
                                .monospacedDigit()
                        }
                        .foregroundColor(timerActive ? .orange : .gray)
                    }
                    .padding(.horizontal)

                    // 식당 카드 영역 (동적)
                    VStack(alignment: .leading, spacing: 20) {
                        if isLoading {
                            ProgressView("주변 \(category) 검색 중...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if let err = loadError {
                            Text("불러오는 중 오류가 발생했어요: \(err)")
                                .foregroundColor(.red)
                                .fixedSize(horizontal: false, vertical: true)
                        } else if places.isEmpty {
                            Text("주변에 표시할 \(category) 결과가 없어요.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(places) { place in
                                NavigationLink(
                                    destination:
                                        PlaceResultView(
                                            placeName: place.place_name,
                                            imageName: "placeholder-restaurant", // 프로젝트 에셋 이름
                                            kakaoPlaceURL: URL(string: place.place_url ?? "")
                                        )
                                ) {
                                    ImageCardView(
                                        imageName: "placeholder-restaurant",
                                        title: place.place_name,
                                        category: place.category_name ?? category,
                                        status: "영업 정보 없음",
                                        hours: place.phone ?? "",
                                        rating: "4.5", // 카카오 응답에 평점 없음 → 임시
                                        isEnabled: timerActive
                                    )
                                }
                            }
                        }
                    }

                    // 결과 보기 버튼
                    Button(action : { moveToPlaceResultView = true }) {
                        Text(timerActive ? "\(timeString(from: remainingTime)) 후 결과 보기" : "결과 보기")
                            .font(.title)
                            .bold()
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
                // 결과 페이지로 이동 (필요 시 투표 결과 전달 로직 연결)
                PlaceResultView()
            }
        }
        // 타이머
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timerActive = false
            }
        }
        // 위치 변동 시 검색
        .onChange(of: locationManager.lastLocation) { _, loc in
            guard let loc else { return }
            fetchKakaoPlaces(center: loc.coordinate, category: category, radius: radius)
        }
        .onAppear {
            // 최초 진입 시 권한 요청 및 검색 트리거
            locationManager.requestIfNeeded()
            if let loc = locationManager.lastLocation {
                fetchKakaoPlaces(center: loc.coordinate, category: category, radius: radius)
            }
        }
    }

    // MARK: - Data Load
    private func fetchKakaoPlaces(center: CLLocationCoordinate2D, category: String, radius: Int) {
        isLoading = true
        loadError = nil

        Task {
            do {
                let result = try await KakaoPlaceService.shared.search(
                    query: category,
                    center: center,
                    radius: radius
                )
                // 랜덤 추천: 무작위 섞고 상위 6개
                let randomized = Array(result.shuffled().prefix(6))
                await MainActor.run {
                    self.places = randomized
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
}

// 타이머 표시를 위한 함수
func timeString(from seconds: Int) -> String {
    let minutes = seconds / 60
    let seconds = seconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

// MARK: - ImageCardView
struct ImageCardView: View {
    var imageName: String
    var title: String
    var category: String
    var status: String
    var hours: String
    var rating: String
    var isEnabled: Bool

    @State private var isFavorite = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 370, height: 200)
                .clipped()
                .cornerRadius(20)

            VStack {
                HStack {
                    Text("⭐️ \(rating)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(20)

                    Spacer()

                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .orange : .white)
                            .padding(6)
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding([.horizontal, .top], 10)

                Spacer()

                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(title)
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)

                            Text(category)
                                .font(.footnote)
                                .foregroundColor(.black)

                            Spacer()
                        }

                        HStack {
                            Text(status)
                                .font(.callout)
                                .foregroundColor(.black)

                            Text(hours)
                                .font(.callout)
                                .foregroundColor(.black)

                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, minHeight: 60)
                .padding([.horizontal, .bottom], 10)
            }

            if !isEnabled {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .cornerRadius(20)
                    Text("선택 마감")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Kakao Models / Service
struct KakaoKeywordResponse: Decodable {
    let documents: [KakaoKeywordPlace]
}

struct KakaoKeywordPlace: Decodable, Identifiable {
    // Kakao Local API: id는 문자열
    let id: String
    let place_name: String
    let road_address_name: String?
    let address_name: String?
    let phone: String?
    let x: String
    let y: String
    let place_url: String?
    let category_name: String?
}

final class KakaoPlaceService {
    static let shared = KakaoPlaceService()
    private init() {}

    // 카카오 로컬 검색 (키워드 + 좌표 + 반경)
    func search(query: String, center: CLLocationCoordinate2D, radius: Int) async throws -> [KakaoKeywordPlace] {
        var comps = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json")!
        comps.queryItems = [
            .init(name: "query", value: query),
            .init(name: "x", value: String(center.longitude)),
            .init(name: "y", value: String(center.latitude)),
            .init(name: "radius", value: String(radius)), // 0~20000
            .init(name: "size", value: "15"),
            .init(name: "sort", value: "distance")
        ]

        var req = URLRequest(url: comps.url!)
        // Secrets 사용
        let key = Secrets.kakaoRESTAPIKey
        precondition(!key.isEmpty, "❌ Secrets.plist의 KAKAO_REST_API_KEY가 비어있습니다.")
        req.addValue("KakaoAK \(key)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw NSError(domain: "KakaoPlaceService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kakao API 응답 오류"])
        }
        let decoded = try JSONDecoder().decode(KakaoKeywordResponse.self, from: data)
        return decoded.documents
    }
}

// MARK: - Simple Location Manager (이름 충돌 방지용)
final class SimpleLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestIfNeeded() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            DispatchQueue.main.async { self.lastLocation = last }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

#Preview {
    PlaceView(category: "돈가스·회·일식")
}
