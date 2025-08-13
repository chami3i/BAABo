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
        FirebaseApp.configure()
        AuthService.signInAnonymouslyIfNeeded() // 앱 실행 시 익명 로그인
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(searchContext) // 전역 공유
                .onOpenURL { url in
                    // 커스텀 스킴 예: baabo://join/ABC123
                    let host = url.host?.lowercased() ?? ""
                    let paths = url.pathComponents // ["/", "join", "ABC123"]
                    
                    if host == "join", paths.count >= 2 {
                        let roomId = paths[1]  // 예: "ABC123"
                        
                        router.isHost = false
                        router.currentRoomId = roomId
                        // Firestore에서 해당 방의 location 읽음
                        router.navigateToInviteView = false  // 네비게이션 보류
                        
                        RoomService.fetchRoomLocation(roomId: roomId) { loc in
                            DispatchQueue.main.async {
                                // 값이 비어있으면 기본 문구, 있으면 방장 값으로 반영
                                router.selectedLocation = (loc?.isEmpty == false) ? (loc ?? "") : "현재 위치에서 찾는 중"
                                
                                // location 세팅이 끝난 후에 InviteView로 이동
                                router.navigateToInviteView = true
                            }
                        }
                    }
                }
        }
    }
    
    
}
