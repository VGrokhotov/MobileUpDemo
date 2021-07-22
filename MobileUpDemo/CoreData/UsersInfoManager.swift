//
//  UsersInfoManager.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import Foundation

class UsersInfoManager {
    
    var userInfo: UserInfo?
    
    var isAuthorized: Bool {
        if let userInfo = UserInfoStorage.shared.get() {
            if Date().timeIntervalSince1970 > userInfo.expires {
                self.userInfo = nil
                return false
            } else {
                self.userInfo = userInfo
                return true
            }
        }
        userInfo = nil
        return false
    }
    
    static let shared = UsersInfoManager()
    private init(){}
    
}
