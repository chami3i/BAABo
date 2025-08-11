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
    init() {
        print("🔥 Firebase 초기화 시도")
        FirebaseApp.configure()
        AuthService.signInAnonymouslyIfNeeded() // 앱 실행 시 익명 로그인
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    

}
