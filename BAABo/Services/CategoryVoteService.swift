//
//  CategoryVoteService.swift
//  BAABo
//
//  Created by Wren on 8/13/25.
//

import Foundation
import FirebaseFirestore

struct CategoryVoteService {
    static let db = Firestore.firestore()
    
    // 방별 투표 저장
    static func submitVote(roomId: String,
                           userId: String,
                           categories: [String],
                           abstain: Bool,
                           completion: @escaping (Bool) -> Void) {
        let doc = db.collection("rooms")
            .document(roomId)
            .collection("votes")
            .document(userId)
        
        let payloadCategories = abstain ? [] : Array(categories.prefix(3))
        let data: [String: Any] = [
            "categories": abstain ? [] : Array(categories.prefix(3)),
            "abstain": abstain,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        doc.setData(data, merge: true) { error in
            if let error = error {
                print("❌ submitVote failed: \(error.localizedDescription)")
            } else {
                print("✅ submitVote success (document created/merged)")
            }
            completion(error == nil)
        }
    }
    
    // 실시간 리스너
    static func listenVotes(roomId: String,
                            onChange: @escaping ([[String: Any]]) -> Void) -> ListenerRegistration {
        return db.collection("rooms").document(roomId)
            .collection("votes")
            .addSnapshotListener { snap, err in
                if let err = err {
                    print("❌ listenVotes error: \(err.localizedDescription)")
                    onChange([]); return
                }
                let rows = snap?.documents.map { $0.data() } ?? []
                print("✅ listenVotes docs count: \(rows.count)")
                onChange(rows)
            }
    }
    
    // 가중치 집계 (1위 3점, 2위 2점, 3위 1점)
    private static func aggregateScores(from docs: [QueryDocumentSnapshot]) -> (winner: String?, scores: [String:Int], abstainCount: Int, totalVotes: Int) {
            let weight = [3, 2, 1]
            var score: [String:Int] = [:]
            var firstChoiceCount: [String:Int] = [:]
            var abstainCount = 0
            var total = 0
            
            for doc in docs {
                total += 1
                let data = doc.data()
                let abstain = (data["abstain"] as? Bool) == true
                if abstain {
                    abstainCount += 1
                    continue
                }
                let cats = (data["categories"] as? [String]) ?? []
                for (idx, name) in cats.prefix(3).enumerated() {
                    score[name, default: 0] += weight[idx]
                    if idx == 0 { firstChoiceCount[name, default: 0] += 1 }
                }
            }
            
            let winner = score.isEmpty ? nil : score.sorted { a, b in
                if a.value != b.value { return a.value > b.value }
                let a1 = firstChoiceCount[a.key] ?? 0
                let b1 = firstChoiceCount[b.key] ?? 0
                if a1 != b1 { return a1 > b1 }
                return a.key < b.key
            }.first?.key
            
            return (winner, score, abstainCount, total)
        }

    
    static func aggregateAndSaveResult(roomId: String,
                                           completion: @escaping (_ winner: String?, _ scores: [String:Int]) -> Void) {
            db.collection("rooms").document(roomId)
                .collection("votes")
                .getDocuments { snap, err in
                    if let err = err {
                        print("❌ aggregate getDocuments error: \(err.localizedDescription)")
                        completion(nil, [:]); return
                    }
                    
                    let docs = snap?.documents ?? []
                    let (winner, scores, abstainCount, totalVotes) = aggregateScores(from: docs)
                    
                    // ✅ 결과 문서 저장
                    let resultRef = db.collection("rooms").document(roomId).collection("categoryResult").document("latest")
                    let payload: [String: Any] = [
                        "winner": winner ?? NSNull(),
                        "scores": scores,                 // { "중식": 8, "고기·구이": 7, ... }
                        "abstainCount": abstainCount,     // 기권 수
                        "totalVotes": totalVotes,         // 총 제출 수
                        "updatedAt": FieldValue.serverTimestamp()
                    ]
                    resultRef.setData(payload, merge: true) { saveErr in
                        if let saveErr = saveErr {
                            print("❌ save categoryResult error:", saveErr.localizedDescription)
                        }
                        completion(winner, scores)
                    }
                }
        }
        
        // (선택) 최종 결과 읽기 (PlaceView 등에서 사용)
        static func fetchSavedResult(roomId: String,
                                     completion: @escaping (_ winner: String?, _ scores: [String:Int]) -> Void) {
            db.collection("rooms").document(roomId)
                .collection("categoryResult").document("latest")
                .getDocument { doc, err in
                    if let err = err {
                        print("❌ fetchSavedResult error:", err.localizedDescription)
                        completion(nil, [:]); return
                    }
                    let data = doc?.data() ?? [:]
                    let winner = data["winner"] as? String
                    let scores = data["scores"] as? [String:Int] ?? [:]
                    completion(winner, scores)
                }
        }
}
