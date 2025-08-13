//
//  RoomModel.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import FirebaseFirestore

class RoomService {
    static let db = Firestore.firestore()
    
    // MARK: - 방 생성
    static func createRoom(completion: @escaping (String?) -> Void) {
        let roomRef = db.collection("rooms").document()
        let data: [String: Any] = [
            "createdAt": Timestamp(date: Date()),
            "location": "",
            "participants": []
        ]
        
        roomRef.setData(data) { error in
            if let error = error {
                print("Error creating room: \(error)")
                completion(nil)
            } else {
                completion(roomRef.documentID)
            }
        }
    }
    
    // MARK: - 위치 업데이트
    static func updateRoomLocation(roomId: String, location: String, completion: @escaping (Bool) -> Void) {
        let roomRef = db.collection("rooms").document(roomId)
        roomRef.updateData(["location": location]) { error in
            if let error = error {
                print("Error updating location: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // 방의 location 필드 읽기
    static func fetchRoomLocation(roomId: String, completion: @escaping (String?) -> Void) {
        db.collection("rooms").document(roomId).getDocument { snapshot, error in
            if let error = error {
                print("fetchRoomLocation error:", error.localizedDescription)
                completion(nil)
                return
            }
            let loc = snapshot?.data()?["location"] as? String
            completion(loc)
        }
    }
    
    // location 등 변경 실시간 감지
    static func listenRoom(roomId: String, onChange: @escaping (_ location: String?) -> Void) -> ListenerRegistration {
        db.collection("rooms").document(roomId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("listenRoom error:", error.localizedDescription)
                DispatchQueue.main.async { onChange(nil) }
                return
            }
            let loc = snapshot?.data()?["location"] as? String
            DispatchQueue.main.async { onChange(loc) }
        }
    }
    
    // MARK: - 역할(방장/참가자)에 따라 참가 처리
    static func joinRoomWithRole(roomId: String,
                                 userId: String,
                                 isHost: Bool,
                                 completion: @escaping (Bool) -> Void) {
        if isHost {
            // 방장: 마이페이지(전역) 프로필로 참가 문서 업서트
            let roomRef = db.collection("rooms").document(roomId)
            let participantRef = roomRef.collection("participants").document(userId)
            
            UserService.fetchUserProfile(userId: userId) { profile in
                let p = profile ?? UserProfile(userId: userId, nickname: "게스트", foodToAvoid: "없음")
                let batch = db.batch()
                batch.updateData(["participants": FieldValue.arrayUnion([userId])], forDocument: roomRef)
                batch.setData([
                    "userId": userId,
                    "nickname": p.nickname,
                    "foodToAvoid": p.foodToAvoid,
                    "imageName": "memoji1",              // 필요시 전역 이미지 필드가 있으면 그 값 사용
                    "joinedAt": Timestamp()
                ], forDocument: participantRef, merge: true)
                
                batch.commit { error in
                    if let error = error {
                        print("joinRoomWithRole(host) error:", error.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        } else {
            // 참가자: 문서 없으면 "게스트N + 랜덤 이미지"로 최초 생성
            let roomRef = db.collection("rooms").document(roomId)
            let participantRef = roomRef.collection("participants").document(userId)
            
            participantRef.getDocument { snap, err in
                if let err = err {
                    print("joinRoomWithRole(guest) read error:", err.localizedDescription)
                    completion(false)
                    return
                }
                
                if let snap, snap.exists {
                    // 이미 참가 기록 있음 → 배열만 보강(혹시 빠졌을 수 있으니)
                    roomRef.updateData(["participants": FieldValue.arrayUnion([userId])]) { error in
                        if let error = error {
                            print("arrayUnion error:", error.localizedDescription)
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    // 새로 참가 → 게스트N 이름 생성 후 저장
                    RandomProfile.guestName(roomId: roomId) { guestName in
                        let image = RandomProfile.randomImage()
                        let batch = db.batch()
                        batch.updateData(["participants": FieldValue.arrayUnion([userId])], forDocument: roomRef)
                        batch.setData([
                            "userId": userId,
                            "nickname": guestName,
                            "foodToAvoid": "없음",
                            "imageName": image,
                            "joinedAt": Timestamp()
                        ], forDocument: participantRef, merge: true)
                        
                        batch.commit { error in
                            if let error = error {
                                print("joinRoomWithRole(guest) create error:", error.localizedDescription)
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 참가자 리스트 실시간 반영
    static func listenParticipants(roomId: String,
                                   onChange: @escaping ([Friend]) -> Void) -> ListenerRegistration {
        let ref = db.collection("rooms")
            .document(roomId)
            .collection("participants")
            .order(by: "joinedAt", descending: false)
        
        return ref.addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ participants listener error:", error.localizedDescription)
                DispatchQueue.main.async { onChange([]) }
                return
            }
            guard let docs = snapshot?.documents else {
                print("ℹ️ participants snapshot is nil")
                DispatchQueue.main.async { onChange([]) }
                return
            }
            
            let friends: [Friend] = docs.map { doc in
                let data = doc.data()
                let userId = data["userId"] as? String ?? doc.documentID
                let nickname = data["nickname"] as? String ?? "게스트"
                let foodToAvoid = data["foodToAvoid"] as? String ?? "없음"
                let imageName = data["imageName"] as? String ?? "memoji1"
                return Friend(
                    userId: userId,
                    name: nickname,
                    foodToAvoid: foodToAvoid,
                    imageName: imageName
                )
            }
            
            // 디버그
            print("✅ participants updated. count =", friends.count)
            DispatchQueue.main.async {
                onChange(friends)
            }
        }
    }
    
}
