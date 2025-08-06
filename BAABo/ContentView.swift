//
//  ContentView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI

enum Tab {
    case home
    case createRoom
    case myPage
}

struct ContentView: View {
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        
        // Tab
        ZStack(alignment: .bottom) {
            
            // 콘텐츠 영역
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .createRoom:
                    HomeView()
                case .myPage:
                    MypageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
         
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
