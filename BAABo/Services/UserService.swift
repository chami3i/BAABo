//
//  UserService.swift
//  BAABo
//
//  Created by Wren on 8/13/25.
//

import FirebaseFirestore

struct UserProfile {
    let userId: String
    var nickname: String
    var foodToAvoid: String
}

struct UserService {
    static let db = Firestore.firestore()
    
    static func saveUserProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(profile.userId).setData([
            "nickname": profile.nickname,
            "foodToAvoid": profile.foodToAvoid
        ]) { error in
            if let error = error {
                print("유저 프로필 저장 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func fetchUserProfile(userId: String, completion: @escaping (UserProfile?) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let nickname = data["nickname"] as? String,
               let foodToAvoid = data["foodToAvoid"] as? String {
                completion(UserProfile(userId: userId, nickname: nickname, foodToAvoid: foodToAvoid))
            } else {
                completion(nil)
            }
        }
    }
}
