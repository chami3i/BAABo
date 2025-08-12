//
//  MypageView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct MypageView: View {
    // 1) 영구 저장되는 값 (UserDefaults)
    @AppStorage("mypage_name") private var savedName: String = "바보 2"
    @AppStorage("mypage_showFood") private var savedShowFood: Bool = true
    @AppStorage("mypage_foodToAvoid") private var savedFoodToAvoid: String = "없음"
    
    // 2) 편집용 draft (화면에 바인딩)
    @State private var name: String = ""
    @State private var showFood: Bool = true
    @State private var foodToAvoid: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // 상단 타이틀
                ZStack {
                    Text("마이페이지")
                        .font(.title).bold()
                    HStack { Spacer() }
                }
                .padding(.top, 40)
                
                // 아바타
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
                
                // 못 먹는 음식
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
                
                // 저장 버튼: draft → saved 반영 (이후에도 값 유지됨)
                Button {
                    savedName = name
                    savedShowFood = showFood
                    savedFoodToAvoid = foodToAvoid
                    print("저장됨: \(savedName), \(savedShowFood ? savedFoodToAvoid : "사용안함")")
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
        // 3) 화면 열릴 때 저장된 값으로 draft 동기화
        .onAppear {
            name = savedName
            showFood = savedShowFood
            foodToAvoid = savedFoodToAvoid
        }
    }
    
    private func label(_ text: String) -> some View {
        Text(text).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
    }
}

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
