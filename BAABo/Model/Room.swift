//
//  Room.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import Foundation
import FirebaseFirestore

struct Room {
    let code: String
    let hostUID: String
    let createdAt: Timestamp?
    let maxPlayers: Int
    var participants: [String]

    var isFull: Bool { participants.count >= maxPlayers }

    func toDict() -> [String: Any] {
        return [
            "hostUID": hostUID,
            "createdAt": FieldValue.serverTimestamp(),
            "maxPlayers": maxPlayers,
            "participants": participants
        ]
    }

    // DocumentSnapshot : Firebase Firestore에서 어떤 "문서(document)"의 현재 상태를 담고 있는 객체
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.code = document.documentID
        self.hostUID = data["hostUID"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp
        self.maxPlayers = data["maxPlayers"] as? Int ?? 8
        self.participants = data["participants"] as? [String] ?? []
    }
}
