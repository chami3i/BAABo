//
//  CategoryResultView.swift
//  BAABo
//
//  Created by 김찬영 on 8/4/25.
//

import SwiftUI

struct CategoryResultView: View {
    @State private var moveToPlaceView = false
    let selectedCategory = "아시안" // TODO: 나중에 동적으로 바꾸기
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("오늘의 메뉴")
                    
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                ZStack {    // 결과 카테고리 표시
                    
                    Text("🍜")
                            .font(.system(size: 150))
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
                    .background(Color.orange)
                    .cornerRadius(20)
                }
                .padding(.top, 50)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $moveToPlaceView) {
                PlaceView(category: selectedCategory)
            }
        }
    }
}

#Preview {
    CategoryResultView()
} 
