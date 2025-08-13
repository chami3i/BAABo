import SwiftUI
import MapKit

struct LocationMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var search: SearchContext
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedLocationName: String = ""
    
    private var canConfirm: Bool { !selectedLocationName.isEmpty }
    
    let roomId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 지도 및 중심 원
                ZStack(alignment: .top) {
                    Map(coordinateRegion: $viewModel.region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: .constant(.follow),
                        annotationItems: [LocationMarker(coordinate: viewModel.region.center)]) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                        }
                    }
                        .edgesIgnoringSafeArea(.all)
                        .ignoresSafeArea(.keyboard)
                    
                        // 중심 좌표가 바뀔 때마다 공유 상태에 반영
                        .onChange(of: viewModel.region.center) { _, newCenter in
                            search.center = newCenter
                        }
                        .onAppear {
                            viewModel.requestLocationAccess()
                            // 초기 진입 시 현재 지도 중심/반경을 공유 상태에 세팅
                            search.center = viewModel.region.center
                            search.radius = Int(viewModel.radiusInMeters)
                        }

                    
                    GeometryReader { geo in
                        let diameter = viewModel.radiusInMeters /
                        metersPerPoint(region: viewModel.region, screenWidth: geo.size.width)
                        
                        Circle()
                            .fill(Color.green.opacity(0.25))
                            .overlay(
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                            )
                            .frame(width: diameter, height: diameter)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    }
                    .allowsHitTesting(false)
                    
                    // 검색
                    VStack(spacing: 0) {
                        // 검색창
                        HStack {
                            TextField("위치를 검색하세요", text: $viewModel.searchQuery)
                                .textFieldStyle(.plain)
                                .padding(12)
                            
                            Button(action: {
                                viewModel.searchLocation()
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 자동완성 리스트
                        if !viewModel.completions.isEmpty {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.completions, id: \.self) { item in
                                        Button {
                                            selectedLocationName = item.title // 위치 저장
                                            viewModel.searchLocation(from: item)
                                        } label: {
                                            VStack(alignment: .leading) {
                                                Text(item.title)
                                                    .font(.headline)
                                                if !item.subtitle.isEmpty {
                                                    Text(item.subtitle)
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        Divider()
                                    }
                                }
                            }
                            .frame(maxHeight: 208)
                            .background(Color.white)
                            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                            //.shadow(radius: 4)
                            .padding(.horizontal)
                            .zIndex(11)
                        }
                    }
                    .zIndex(10)
                }
                .ignoresSafeArea(.keyboard)
                
                // 하단 고정 슬라이더 + 버튼
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        HStack {
                            Text("0m")
                            Slider(value: $viewModel.radiusInMeters, in: 0...1000, step: 50)
                                .onChange(of: viewModel.radiusInMeters) { _, newValue in
                                    search.radius = Int(newValue)
                                }
                            Text("1km")
                        }
                        
                        Button("확정") {
                            // 확정 시, 최종 좌표/반경 기록 + 카카오 역지오코딩으로 주소 확정
                            let center = viewModel.region.center
                            let radius = Int(viewModel.radiusInMeters)

                            Task {
                                var finalAddress = selectedLocationName
                                if finalAddress.isEmpty {
                                    // 주소를 선택하지 않은 경우, 현재 중심 좌표로 카카오 역지오코딩
                                    if let addr = try? await KakaoGeoService.shared.reverseGeocode(latitude: center.latitude, longitude: center.longitude) {
                                        finalAddress = addr
                                    }
                                }

                                // 공유 상태 업데이트 (PlaceView가 여기서 center/radius를 사용해 카카오 검색 수행)
                                await MainActor.run {
                                    search.center = center
                                    search.radius = radius
                                }

                                // 서버에 저장(주소 문자열이 있으면 사용, 없으면 좌표 문자열 전송)
                                let locationForServer: String
                                if !finalAddress.isEmpty {
                                    locationForServer = finalAddress
                                } else {
                                    locationForServer = String(format: "%.6f, %.6f", center.latitude, center.longitude)
                                }

                                RoomService.updateRoomLocation(roomId: roomId, location: locationForServer) { success in
                                    if success {
                                        DispatchQueue.main.async {
                                            router.selectedLocation = finalAddress.isEmpty ? locationForServer : finalAddress
                                            router.navigateToInviteView = true
                                            router.navigateToMapView = false
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canConfirm ? Color.orange : Color.gray.opacity(0.5)) // 비활성화 색상
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(!canConfirm)
                        .animation(.default, value: canConfirm)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .ignoresSafeArea(.keyboard)
                .zIndex(5)
            }
        }
    }
    
    func metersPerPoint(region: MKCoordinateRegion, screenWidth: CGFloat) -> Double {
        let span = region.span.longitudeDelta
        let centerLat = region.center.latitude * .pi / 180
        let earthCircumference = 40_075_000.0
        let metersPerDegree = earthCircumference * cos(centerLat) / 360
        return (span * metersPerDegree) / screenWidth
    }
}

// ===== Kakao 역지오코딩 서비스 =====
private struct KakaoAddressResponse: Decodable {
    struct Document: Decodable { let address: Address?; let road_address: RoadAddress? }
    struct Address: Decodable { let address_name: String }
    struct RoadAddress: Decodable { let address_name: String }
    let documents: [Document]
}

final class KakaoGeoService {
    static let shared = KakaoGeoService(); private init() {}

    func reverseGeocode(latitude lat: Double, longitude lon: Double) async throws -> String? {
        var comps = URLComponents(string: "https://dapi.kakao.com/v2/local/geo/coord2address.json")!
        comps.queryItems = [
            .init(name: "y", value: String(lat)),
            .init(name: "x", value: String(lon))
        ]
        var req = URLRequest(url: comps.url!)
        let key = AppConfig.kakaoRestAPIKey
        precondition(!key.isEmpty, "KAKAO_REST_API_KEY is empty. Check Secrets.plist & Target Membership.")
        req.addValue("KakaoAK \(key)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            return nil
        }
        let decoded = try JSONDecoder().decode(KakaoAddressResponse.self, from: data)
        // 도로명 주소가 있으면 우선 사용, 없으면 지번 주소
        if let road = decoded.documents.first?.road_address?.address_name {
            return road
        }
        if let lot = decoded.documents.first?.address?.address_name {
            return lot
        }
        return nil
    }
}

//// ✅ 특정 모서리만 둥글게 처리하기 위한 커스텀 확장
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat
//    var corners: UIRectCorner
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}

#Preview {
    MapView(roomId: "dummyRoomId123")
        .environmentObject(SearchContext())
}
