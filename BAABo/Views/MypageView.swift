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
                
                // 저장 버튼 (고정형이라 일단 출력만)
                Button {
                    print("저장: \(name), \(showFood ? foodToAvoid : "사용안함")")
                } label: {
                    Text("저장")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(.black)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(radius: 3, y: 1)
                }
                
                .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.white.ignoresSafeArea())
    }
    
    // 작은 라벨
    private func label(_ text: String) -> some View {
        Text(text).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
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
