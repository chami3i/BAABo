//
//  MypageView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct MypageView: View {
    // 고정 시작값
    @State private var name: String = "바보 2"
    @State private var showFood: Bool = true
    @State private var foodToAvoid: String = "없음"
    
    @State private var isLoading = false
    @State private var isSaving = false
    @State private var saveMessage: String? = nil
    @State private var currentUserId: String? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // 상단 타이틀 + 닫기(X)
                ZStack {
                    Text("마이페이지")
                        .font(.title).bold()
                    HStack {
                        Spacer()
                        
                    }
                }
                .padding(.top, 40)
                
                // 아바타 (Assets에 "memoji1" 이미지 필요)
                Image("memoji2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 5))
                    .shadow(radius: 4)
                    .padding(.top, 30)
                
                // 이름
                VStack(spacing: 8) {
                    label("이름")
                    TextField("이름", text: $name)
                        .fieldStyle()
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                // 못 먹는 음식 설정 + 입력
                VStack(spacing: 12) {
                    HStack {
                        Text("못 먹는 음식 설정")
                            .font(.subheadline)
                        Spacer()
                        Toggle("", isOn: $showFood)
                            .labelsHidden()
                            .tint(.green)
                    }
                    .padding(.horizontal, 4)
                    
                    TextField("없음", text: $foodToAvoid)
                        .fieldStyle()
                        .disabled(!showFood)
                        .opacity(showFood ? 1.0 : 0.5)
                }
                .padding(.top, 4)
                
                // 전역(users/{uid}) 저장
                Button {
                    saveProfile()
                } label: {
                    HStack(spacing: 8) {
                        if isSaving { ProgressView().tint(.black) }
                        Text(isSaving ? "저장 중..." : "저장")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(.black)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(radius: 3, y: 1)
                }
                .disabled(isSaving)
                .padding(.top, 6)
                
                if let msg = saveMessage {
                    Text(msg)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 6)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.1).ignoresSafeArea()
                    ProgressView("불러오는 중...")
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            loadProfile()   // 진입 시 전역 프로필 로드
        }
    }
    
    // 작은 라벨
    private func label(_ text: String) -> some View {
        Text(text).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // 전역 프로필 저장
    private func saveProfile() {
        guard let uid = currentUserId else { return }
        isSaving = true
        saveMessage = nil
        
        // 입력값 정리
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nickname = trimmedName.isEmpty ? "게스트" : trimmedName
        let food = showFood ? foodToAvoid.trimmingCharacters(in: .whitespacesAndNewlines) : "없음"
        
        let profile = UserProfile(userId: uid, nickname: nickname, foodToAvoid: food)
        UserService.saveUserProfile(profile) { ok in
            DispatchQueue.main.async {
                self.isSaving = false
                self.saveMessage = ok ? "저장 완료!" : "저장 실패. 네트워크를 확인해주세요."
            }
        }
    }
    
    // 전역 프로필 로드
    private func loadProfile() {
        isLoading = true
        AuthService.getCurrentUserId { uid in
            self.currentUserId = uid
            guard let uid = uid else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.saveMessage = "로그인이 필요합니다."
                }
                return
            }
            UserService.fetchUserProfile(userId: uid) { profile in
                DispatchQueue.main.async {
                    if let p = profile {
                        self.name = p.nickname
                        self.foodToAvoid = p.foodToAvoid
                        self.showFood = (p.foodToAvoid != "없음")
                    } else {
                        // 최초 진입 기본값
                        self.name = "게스트"
                        self.foodToAvoid = "없음"
                        self.showFood = false
                    }
                    self.isLoading = false
                }
            }
        }
    }
}

// 공통 필드 스타일
private extension View {
    func fieldStyle() -> some View {
        self
            .padding(.horizontal, 14)
            .frame(height: 54)
            .background(Color(uiColor: .systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    MypageView()
}
