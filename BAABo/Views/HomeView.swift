//
//  HomeView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 16) {
                
                HomeBannerView() // 방 만들기 배너
                Spacer()
                HomeTodayMenuView() // 🥘 오늘의 메뉴 추천
                Spacer()
                HomeChallengeView() // 🎯 챌린지
                Spacer()
                HomeReviewView() // 📝 최근 방문 식당 리뷰
                Spacer()
                HomeVisitedView() // 📌 최근에 방문한(결정한) 식당
                Spacer()
                HomeWithView() // 📌 최근에 함께한 사람들
                Spacer().frame(height: 100)
                
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
        }
    }
}



#Preview {
    HomeView()
}
