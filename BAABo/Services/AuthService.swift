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
    
    // 현재 로그인된 유저 ID 반환 (비동기 아님, nil 가능)
    static func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // 유저 ID를 비동기로 안전하게 얻고 싶을 때 (예: 익명 로그인이 끝난 후 호출)
    static func getCurrentUserId(completion: @escaping (String?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            completion(uid)
        } else {
            // 아직 로그인 안됐으면 익명 로그인 시도 후 uid 전달
            Auth.auth().signInAnonymously { result, error in
                if let user = result?.user {
                    completion(user.uid)
                } else {
                    completion(nil)
                }
            }
        }
    }
}

