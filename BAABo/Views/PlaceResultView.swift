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

public extension PlaceResultView {
    struct Candidate: Identifiable {
        public let id: String
        public let title: String
        public let kakaoURL: URL?
    }
}

public struct PlaceResultView: View {
    @Environment(\.dismiss) private var dismiss

    let candidates: [Candidate]
    @State private var chosen: Candidate?
    @State private var goHome = false
    @State private var showSafari = false

    public init(candidates: [Candidate]) {
        self.candidates = candidates
    }

    public var body: some View {
        VStack(spacing: 20) {
            // 상단 큰 타이틀
            Text("당신은\n먹을 자격이\n있습니다")
                .font(.system(size: 60, weight: .heavy))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 70)

            // 후보 카드 (읽기 전용)
            if let c = chosen {
                ResultReadonlyCard(title: c.title)
                    .transition(.opacity)
            }

            // 서브 카피
            Text("\(chosen?.title ?? "선택된 가게")(으)로 떠나자!")
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)

            // CTA 버튼 (카카오맵) - 인앱 열기
            if let url = chosen?.kakaoURL {
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
        .onAppear {
            if chosen == nil {
                chosen = candidates.randomElement()
            }
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


private struct ResultReadonlyCard: View {
    var title: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                .frame(height: 150)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("★ 4.7")
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .foregroundColor(.orange)
                        .background(Color.white)
                        .clipShape(Capsule())
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.orange)
                        .frame(width: 32, height: 32)
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(title)
                        .font(.title3).bold()
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Spacer()
                }
                Text("영업 중 · 오늘 09:00 - 22:00")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(.top, 15)
    }
}

#Preview {
    NavigationStack {
        PlaceResultView(candidates: [
            .init(id: "1", title: "소노이", kakaoURL: URL(string: "https://map.kakao.com/?q=소노이")),
            .init(id: "2", title: "미정국수", kakaoURL: URL(string: "https://map.kakao.com/?q=미정국수")),
            .init(id: "3", title: "연어상회", kakaoURL: URL(string: "https://map.kakao.com/?q=연어상회"))
        ])
    }
}
