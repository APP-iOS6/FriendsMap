import Foundation
import FirebaseFirestore
import FirebaseAuth

extension AuthenticationStore {
    func loadFriendData() async {
        let email = self.user.email
        
        do {
            let db = Firestore.firestore()
            let doc = try await db.collection("User").document(email).getDocument()
            
            if let data = doc.data() {
                self.user.friends = data["friends"] as? [String] ?? []
                self.user.receiveList = data["receiveList"] as? [String] ?? []
                self.user.requestList = data["requestList"] as? [String] ?? []
                print("Loaded friend data: \(self.user.friends)")
            } else {
                print("No document for user: \(email)")
            }
        } catch {
            print("Error loading friend data: \(error)")
        }
    }
    
    // 친구 요청 보내기
    func sendFriendRequest(to friendEmail: String) async -> String {
        let email = self.user.email
           
           // 이미 친구 요청을 보낸 경우
        if self.user.requestList.contains(friendEmail) {
               return "이미 친구 요청을 보냈습니다." // 중복 요청 메시지
           }

           do {
               let db = Firestore.firestore()
               let friendDoc = try await db.collection("User").document(friendEmail).getDocument()
               
               // 친구 문서가 있는지 확인
               guard friendDoc.exists else {
                   return "해당 이메일의 사용자를 찾을 수 없습니다." // 문서가 없을 경우
               }
               
               // 친구 요청 보내기
               try await db.collection("User").document(friendEmail).updateData([
                   "receiveList": FieldValue.arrayUnion([email])
               ])
               
               // 요청 목록에 친구 추가
               self.user.requestList.append(friendEmail)
               try await db.collection("User").document(email).updateData([
                   "requestList": FieldValue.arrayUnion([friendEmail])
               ])
               
               print("Friend request sent to \(friendEmail)")
               return "성공적으로 친구 요청을 보냈습니다." // 성공 메시지
               
           } catch {
               print("Error sending friend request: \(error)")
               return "친구 요청을 보내는 중 오류가 발생했습니다."
           }
       }
    // 친구 요청 수락하기
    func acceptFriendRequest(from friendEmail: String) async {
        let email = self.user.email
        
        do {
            let db = Firestore.firestore()
            let userRef = db.collection("User").document(email)
            let friendRef = db.collection("User").document(friendEmail)
            
            // 내 friends에 친구 추가하고, receiveList에서 제거
            try await userRef.updateData([
                "friends": FieldValue.arrayUnion([friendEmail]),
                "receiveList": FieldValue.arrayRemove([friendEmail])
            ])
            
            // 친구의 friends에도 내 이메일 추가
            try await friendRef.updateData([
                "friends": FieldValue.arrayUnion([email])
            ])
            
            // 뷰모델의 receiveList 업데이트
            if let index = self.user.receiveList.firstIndex(of: friendEmail) {
                self.user.receiveList.remove(at: index)
            }
            
            print("Accepted friend request from \(friendEmail)")
        } catch {
            print("Error accepting friend request: \(error)")
        }
    }
    
    // 친구 요청 거절하기
    func rejectFriendRequest(from friendEmail: String) async {
        let email = self.user.email
        
        do {
            let db = Firestore.firestore()
            let userRef = db.collection("User").document(email)
            
            // receiveList에서 친구 요청 제거
            try await userRef.updateData([
                "receiveList": FieldValue.arrayRemove([friendEmail])
            ])
            
            // 뷰모델의 receiveList 업데이트
            if let index = self.user.receiveList.firstIndex(of: friendEmail) {
                self.user.receiveList.remove(at: index)
            }
            
            print("Rejected friend request from \(friendEmail)")
        } catch {
            print("Error rejecting friend request: \(error)")
        }
    }
}
