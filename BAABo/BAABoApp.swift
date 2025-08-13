//
//  BAABoApp.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct BAABoApp: App {
    
    @StateObject var router = Router()
    @StateObject private var searchContext = SearchContext()
    
    init() {
        print("🔥 Firebase 초기화 시도")
        FirebaseApp.configure()
        AuthService.signInAnonymouslyIfNeeded() // 앱 실행 시 익명 로그인
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(searchContext) // 전역 공유
                .onOpenURL { url in
                    // URL 예: myapp://join/ABC123
                    if url.host == "join", let roomId = url.pathComponents.dropFirst().first {
                        router.isHost = false
                        router.currentRoomId = roomId
                        router.selectedLocation = "현재 위치"
                        router.navigateToInviteView = true
                    }
                }
        }
    }
    
    
}
