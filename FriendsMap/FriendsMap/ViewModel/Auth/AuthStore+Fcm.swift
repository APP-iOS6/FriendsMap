//
//  AuthStore+Fcm.swift
//  FriendsMap
//
//  Created by 박범규 on 10/22/24.
//

import Firebase

func sendPushNotification(to token: String, title: String, body: String) {
    let urlString = "https://fcm.googleapis.com/fcm/send"
    let url = URL(string: urlString)!
    let serverKey = "YOUR_SERVER_KEY" // Firebase Cloud Messaging 서버 키

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    
    let notification: [String: Any] = ["to": token,
                                       "notification": ["title": title,
                                                        "body": body,
                                                        "sound": "default"]]
    let jsonNotification = try? JSONSerialization.data(withJSONObject: notification, options: [])

    request.httpBody = jsonNotification

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error sending push notification: \(error)")
            return
        }
        if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
            print("Response from FCM: \(jsonData)")
        }
    }
    task.resume()
}
