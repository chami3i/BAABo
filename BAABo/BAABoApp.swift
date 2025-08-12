//
//  BAABoApp.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI

@main
struct BAABoApp: App {
    @StateObject private var searchContext = SearchContext()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(searchContext) // 전역 공유
        }
    }
}
