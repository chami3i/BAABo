//
//  CategoryResultView.swift
//  BAABo
//
//  Created by 김찬영 on 8/4/25.
//

import SwiftUI

struct CategoryResultView: View {
    @State private var moveToPlaceView = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("오늘의 메뉴")
                    
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                ZStack {    // 결과 카테고리 표시
                    Circle()
                        .frame(width:327, height:327)
                        .foregroundColor(Color("2_greenColor"))
                    Image("아시안")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                Text("아시안")     // 결과 카테고리 텍스트
                    .font(.system(size: 32, weight: .bold))
                    .padding(.bottom, 30)
                
                // 식당 보러 가기 버튼
                Button(action:{
                    moveToPlaceView = true
                }) {
                    HStack {
                        Text("식당 보러 가기")
                           // .font(.system(size: 32, weight: .bold))
                            .font(.title)
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .frame(width:30, height:30)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 337, height: 101)
                    .background(Color(.accent))
                    .cornerRadius(20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $moveToPlaceView) {
                PlaceView()
            }
        }
    }
}

#Preview {
    CategoryResultView()
}
