//
//  CustomTabBar.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        
        
        // 탭바
        HStack {
            // 홈 탭
            Button(action: {
                selectedTab = .home
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house")
                        .font(.system(size: 22))
                }
                .foregroundColor(selectedTab == .home ? .black : .gray)
            }
            
            Spacer()
            
            // 방 만들기 탭
            Button(action: {
                selectedTab = .createRoom
            }) {
                ZStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "plus.bubble.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // 마이페이지 탭
            Button(action: {
                selectedTab = .myPage
            }) {
                VStack {
                    Image(systemName: "person")
                        .font(.system(size: 22))
                }
                .foregroundColor(selectedTab == .myPage ? .black : .gray)
            }
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 10)
        .background(
            Color.white
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: -2)
        )
    }
}
