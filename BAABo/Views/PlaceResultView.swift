//
//  PlaceResultView.swift
//  BAABo
//
//  Created by chaem on 8/7/25.
//

import SwiftUI

public struct PlaceResultView: View {
    @Environment(\.dismiss) private var dismiss

    let placeName: String
    let imageName: String
    let naverPlaceURL: URL?
    
    @State private var goHome = false

    public init(
        placeName: String = "소노이",
        imageName: String = "yourFoodImage", // 결정된 이미지
        naverPlaceURL: URL? = URL(string: "https://map.naver.com/")
    ) {
        self.placeName = placeName
        self.imageName = imageName
        self.naverPlaceURL = naverPlaceURL
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

            // CTA 버튼 (네이버 플레이스)
            if let url = naverPlaceURL {
                Link(destination: url) {
                    HStack(spacing: 8) {
                        Text("네이버 플레이스로 보기")
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
            } else {
                Button {} label: {
                    HStack(spacing: 8) {
                        Text("네이버 플레이스로 보기")
                            .font(.headline.bold())
                        Image(systemName: "arrow.right.circle")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundColor(.black)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
                }
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
            // 배경 톤(시안의 살구색 느낌). 필요 없으면 제거 가능
            Color.orange.opacity(0.12).ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        
        .navigationDestination(isPresented: $goHome) {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                }
    }
}

// 사진 모서리 L자 마크
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
                        Rectangle().fill(color).frame(width: w, height: s)
                    }
                    HStack {
                        Spacer()
                        Rectangle().fill(color).frame(width: s, height: w)
                    }
                }
            }
            .padding(10) // 사진 가장자리에서 살짝 안쪽으로
        }
    }
}

#Preview {
    NavigationStack {
        PlaceResultView(
            placeName: "소노이",
            imageName: "yourFoodImage",
            naverPlaceURL: URL(string: "https://map.naver.com/")
        )
    }
}

