//
//  UserManager.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

protocol UserManagerDelegate {
    func didUpdateUser()
    func didLogoutUser()
}

class UserManager {
    var user: User?
    var delegate: UserManagerDelegate?
    
    func fetchUser() {
        let auth = Auth.auth()
        if let currentUser = auth.currentUser {
            let id = currentUser.uid
            user = User(id: id)
            delegate?.didUpdateUser()
        } else if user != nil {
            user = nil
            delegate?.didLogoutUser()
        } else {
            delegate?.didUpdateUser()
        }
    }
    
    func logoutUser() {
        let auth = Auth.auth()
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print("로그아웃 Error 발생:", signOutError)
        }
        fetchUser()
    }
}
