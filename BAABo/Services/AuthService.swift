//
//  AuthService.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import FirebaseAuth

enum AuthService {
    static func signInAnonymouslyIfNeeded() {
        guard Auth.auth().currentUser == nil else {
            print("👤 이미 로그인됨: \(Auth.auth().currentUser?.uid ?? "")")
            return
        }

        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("❌ 익명 로그인 실패:", error.localizedDescription)
            } else if let user = result?.user {
                print("✅ 익명 로그인 성공: \(user.uid)")
            }
        }
    }
}
