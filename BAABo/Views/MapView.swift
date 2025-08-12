import SwiftUI
import MapKit

struct LocationMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedLocationName: String = ""
    
    private var canConfirm: Bool { !selectedLocationName.isEmpty }
    
    let roomId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
//                NavigationLink(
//                    destination: InviteView(location: selectedLocationName),
//                    isActive: $navigateToInvite,      // true가 되면 push
//                    label: { EmptyView() }
//                )
//                .hidden()
                
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
                .onAppear {
                    viewModel.requestLocationAccess()
                }
                
                // 하단 고정 슬라이더 + 버튼
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        HStack {
                            Text("0m")
                            Slider(value: $viewModel.radiusInMeters, in: 0...1000, step: 50)
                            Text("1km")
                        }
                        
                        Button("확정") {
                            RoomService.updateRoomLocation(roomId: roomId, location: selectedLocationName) { success in
                                if success {
                                    DispatchQueue.main.async {
                                        router.selectedLocation = selectedLocationName
                                        router.navigateToInviteView = true
                                        router.navigateToMapView = false
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
}
