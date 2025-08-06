import SwiftUI
import MapKit

struct LocationMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var navigateToInvite = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    // 검색창
                    HStack {
                        TextField("위치를 검색하세요", text: $viewModel.searchQuery)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)

                        Button(action: {
                            viewModel.searchLocation()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                        }
                    }
                    .padding(.top)
                    .background(Color.white)

                    // 지도 뷰
                    ZStack {
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
                    }
                    .onAppear {
                        viewModel.requestLocationAccess()
                    }

                    // 슬라이더 + 버튼 UI
                    VStack {
                        HStack {
                            Text("0m")
                            Slider(value: $viewModel.radiusInMeters, in: 0...1000, step: 50)
                            Text("1km")
                        }
                        .padding()

                        Button("확정") {
                            navigateToInvite = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 10)
                    }
                    .background(Color.white)
                }

                // ✅ 자동완성 리스트 (ZStack 상단에 덮이게)
                if !viewModel.completions.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.completions, id: \.self) { item in
                                Button {
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
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 250)
                    .padding(.top, 80)
                    .zIndex(10)
                }
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
//11
