//
//  AuthEmail.swift
//  FriendsMap
//
//  Created by 김수민 on 10/15/24.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

extension AuthenticationStore {
    func signInWithEmailPassword(email: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            authenticationState = .authenticated
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }

func signUpWithEmailPassword(email: String, password: String) async -> Bool {
    authenticationState = .authenticating
    do  {
        try await Auth.auth().createUser(withEmail: email, password: password)
        return true
    }
    catch {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
    }
}
}
