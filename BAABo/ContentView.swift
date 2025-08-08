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
    @State private var isNavigating = false
    
    var body: some View {
        NavigationStack {
            // Tab
            ZStack(alignment: .bottom) {
                
                // 콘텐츠 영역
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .createRoom:
                        Color.clear
                            .onAppear {
                                isNavigating = true
                                selectedTab = .home  // 또는 .myPage 등 원하는 탭으로 복구
                            }
                    case .myPage:
                        MypageView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                //CustomTabBar(selectedTab: $selectedTab)
                if selectedTab == .home || selectedTab == .myPage {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                MapView()
            }
        }
    }
}

#Preview {
    ContentView()
}
