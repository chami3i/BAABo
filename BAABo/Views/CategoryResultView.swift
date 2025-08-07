//
//  CategoryResultView.swift
//  BAABo
//
//  Created by 김찬영 on 8/4/25.
//

import SwiftUI

struct CategoryResultView: View {
    var body: some View {
        
        VStack {
            Text("오늘의 메뉴")
                .font(.system(size: 40, weight: .bold))
                .padding()
            ZStack {
                Circle()    // 배경 깔기
                    .frame(width:327, height:327)
                    .foregroundColor(Color("2_greenColor"))
                // 결과 카테고리 이미지 표시
                Image("아시안")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            // 결과 카테고리 표시
            Text("아시안")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 30)
            
            // 식당 보러 가기 버튼
            Button(action:{
                // 버튼 기능
            }) {
                HStack {
                    Text("식당 보러 가기")
                        .font(.system(size: 32, weight: .bold))
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .scaledToFit()
                        .bold()
                        .frame(width:30, height:30)
                }
                .foregroundColor(.black)    // 버튼 디자인 커스텀
                .padding()
                .frame(width: 337, height: 101)
                .background(Color(.accent))
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    CategoryResultView()
}
