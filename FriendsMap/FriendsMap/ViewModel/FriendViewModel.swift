import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class FriendViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var receiveList: [String] = []
    @Published var requestList: [String] = []

    private var userEmail: String? {
        return Auth.auth().currentUser?.email
    }
    

    func loadFriendData() async {
        guard let email = userEmail else {
            print("User not logged in")
            return
        }
        
        do {
            let db = Firestore.firestore()
            let doc = try await db.collection("User").document(email).getDocument()
            
            if let data = doc.data() {
                self.friends = data["friends"] as? [String] ?? []
                self.receiveList = data["receiveList"] as? [String] ?? []
                self.requestList = data["requestList"] as? [String] ?? []
                print("Loaded friend data: \(friends)")
            } else {
                print("No document for user: \(email)")
            }
        } catch {
            print("Error loading friend data: \(error)")
        }
    }
    
    // 친구 요청 보내기
    func sendFriendRequest(to friendEmail: String) async -> Bool {
          do {
              let db = Firestore.firestore()
              let friendDoc = try await db.collection("User").document(friendEmail).getDocument()
              
              // 친구 문서가 있는지 확인
              guard friendDoc.exists else {
                  return false // 친구 문서가 없으면 실패
              }
              
              // 친구 요청 보내기
              try await db.collection("User").document(friendEmail).updateData([
                  "receiveList": FieldValue.arrayUnion([userEmail])
              ])
              
              print("Friend request sent to \(friendEmail)")
              return true // 성공
              
          } catch {
              print("Error sending friend request: \(error)")
              return false // 실패
          }
      }

    // 친구 요청 수락하기
    func acceptFriendRequest(from friendEmail: String) async {
        guard let email = userEmail else {
            print("User not logged in")
            return
        }
        
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
            
            print("Accepted friend request from \(friendEmail)")
        } catch {
            print("Error accepting friend request: \(error)")
        }
    }
}
