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
    
    func sendFriendRequest(to friendEmail: String) async -> Bool {
        guard let email = userEmail else {
            print("User not logged in")
            return false
        }
        
        do {
            let db = Firestore.firestore()
            let friendDoc = try await db.collection("User").document(friendEmail).getDocument()
            
            guard friendDoc.exists else {
                return false // 친구 문서가 없으면 실패
            }
            
            // 친구 요청 받는 사람의 receiveList에 추가
            try await db.collection("User").document(friendEmail).updateData([
                "receiveList": FieldValue.arrayUnion([email])
            ])
            
            // 요청 보낸 사람의 requestList에 친구 추가
            try await db.collection("User").document(email).updateData([
                "requestList": FieldValue.arrayUnion([friendEmail])
            ])
            
            // 로컬 requestList 업데이트 (UI 업데이트용)
            self.requestList.append(friendEmail)
            
            print("Friend request sent to \(friendEmail)")
            return true
            
        } catch {
            print("Error sending friend request: \(error)")
            return false
        }
    }

    func acceptFriendRequest(from friendEmail: String) async {
        guard let email = userEmail else {
            print("User not logged in")
            return
        }
        
        do {
            let db = Firestore.firestore()
            let userRef = db.collection("User").document(email)
            let friendRef = db.collection("User").document(friendEmail)
            
            try await userRef.updateData([
                "friends": FieldValue.arrayUnion([friendEmail]),
                "receiveList": FieldValue.arrayRemove([friendEmail])
            ])
            
            try await friendRef.updateData([
                "friends": FieldValue.arrayUnion([email])
            ])
            
            print("Accepted friend request from \(friendEmail)")
        } catch {
            print("Error accepting friend request: \(error)")
        }
    }
}
