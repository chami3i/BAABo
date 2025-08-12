//
//  RandomProfile.swift
//  BAABo
//
//  Created by Wren on 8/13/25.
//

import FirebaseFirestore

struct RandomProfile {
    static let memojiImages = ["memoji1", "memoji2", "memoji3", "memoji4", "memoji5", "memoji6"]
    
    static func randomImage() -> String {
        memojiImages.randomElement() ?? "memoji1"
    }
    
    static func guestName(roomId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("rooms").document(roomId).collection("participants").getDocuments { snapshot, error in
            if let error = error {
                print("❌ 게스트 수 조회 실패:", error.localizedDescription)
                completion("게스트1") // 실패 시 기본값
                return
            }
            
            let guestCount = snapshot?.documents.count ?? 0
            completion("게스트\(guestCount + 1)")
        }
    }
}
