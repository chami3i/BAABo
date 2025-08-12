//
//  RoomModel.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RoomService {
    
    // MARK: - 방 생성
    static func createRoom(completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let roomRef = db.collection("rooms").document()
        
        let data: [String: Any] = [
            "createdAt": Timestamp(),
            "createdBy": userId,
        ]
        
        roomRef.setData(data) { error in
            if let error = error {
                completion(nil)
            } else {
                roomRef.collection("members").document(userId).setData([
                    "joinedAt": Timestamp()
                ]) { _ in
                    completion(roomRef.documentID) // 방 코드
                }
            }
        }
    }
    
    // MARK: - 위치 업데이트
    static func updateRoomLocation(roomId: String, location: String, completion: ((Bool) -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).updateData([
            "location": location
        ]) { error in
            if let error = error {
                print("위치 업데이트 실패: \(error)")
                completion?(false)
            } else {
                print("위치 업데이트 성공")
                completion?(true)
            }
        }
    }
}
