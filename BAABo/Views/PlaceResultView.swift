//
//  PlaceResultView.swift
//  BAABo
//
//  Created by chaem on 8/7/25.
//

import SwiftUI
import SafariServices

// 인앱 사파리 래퍼
private struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.preferredBarTintColor = nil   // 시스템 기본
        vc.preferredControlTintColor = nil
        return vc
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

public struct PlaceResultView: View {
    @Environment(\.dismiss) private var dismiss

    let placeName: String
    let imageName: String
    let kakaoPlaceURL: URL?

    @State private var goHome = false
    @State private var showSafari = false

    public init(
        placeName: String = "소노이",
        imageName: String = "yourFoodImage", // 결정된 이미지
        kakaoPlaceURL: URL? = URL(string: "https://map.kakao.com/")
    ) {
        self.placeName = placeName
        self.imageName = imageName
        self.kakaoPlaceURL = kakaoPlaceURL
    }

    public var body: some View {
        VStack(spacing: 20) {
            // 상단 큰 타이틀
            Text("당신은\n먹을 자격이\n있습니다")
                .font(.system(size: 60, weight: .heavy))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 70)

            // 사진 카드
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .clipped()

            // 서브 카피
            Text("\(placeName)(으)로 떠나자!")
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)

            // CTA 버튼 (카카오맵) - 인앱 열기
            if let url = kakaoPlaceURL {
                Button {
                    showSafari = true
                } label: {
                    HStack(spacing: 8) {
                        Text("카카오맵에서 보기")
                            .font(.headline.bold())
                        Image(systemName: "arrow.right.circle")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.black)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            } else {
                Button {} label: {
                    HStack(spacing: 8) {
                        Text("카카오맵에서 보기")
                            .font(.headline.bold())
                        Image(systemName: "arrow.right.circle")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(true)
            }

            Spacer(minLength: 8)

            // 하단 홈으로 가기
            Button {
                goHome = true
            } label: {
                HStack(spacing: 6) {
                    Text("🏠")
                    Text("홈으로 가기")
                        .underline()
                }
                .foregroundColor(.primary)
            }
            .padding(.bottom, 8)
        }
        .padding(20)
        .background(
            Color.orange.opacity(0.12).ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goHome) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

// 사진 모서리 L자 마크 (원본 유지)
private struct CornerMarks: View {
    var color: Color = .white
    var lineWidth: CGFloat = 4
    var size: CGFloat = 24

    var body: some View {
        GeometryReader { geo in
            let s = size, w = lineWidth
            ZStack {
                // top-leading
                VStack {
                    HStack {
                        Rectangle().fill(color).frame(width: s, height: w)
                        Spacer()
                    }
                    HStack {
                        Rectangle().fill(color).frame(width: w, height: s)
                        Spacer()
                    }
                    Spacer()
                }
                // top-trailing
                VStack {
                    HStack {
                        Spacer()
                        Rectangle().fill(color).frame(width: s, height: w)
                    }
                    HStack {
                        Spacer()
                        Rectangle().fill(color).frame(width: w, height: s)
                    }
                    Spacer()
                }
                // bottom-leading
                VStack {
                    Spacer()
                    HStack {
                        Rectangle().fill(color).frame(width: w, height: s)
                        Spacer()
                    }
                    HStack {
                        Rectangle().fill(color).frame(width: s, height: w)
                        Spacer()
                    }
                }
                // bottom-trailing
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Rectangle().fill(color).frame(width: s, height: w)
                    }
                    HStack {
                        Spacer()
                        Rectangle().fill(color).frame(width: s, height: w)
                    }
                }
            }
            .padding(10)
        }
    }
}

#Preview {
    NavigationStack {
        PlaceResultView(
            placeName: "소노이에",
            imageName: "yourFoodImage",
            kakaoPlaceURL: URL(string: "https://map.kakao.com/")
        )
    }
}
