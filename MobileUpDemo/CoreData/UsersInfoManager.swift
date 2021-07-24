//
//  UsersInfoManager.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import Foundation

class UsersInfoManager {
    
    var userInfo: UserInfo?
    
    func getUserInfo() {
        if let userInfo = UserInfoStorage.shared.get() {
            if Date().timeIntervalSince1970 > userInfo.expires {
                self.userInfo = nil
            } else {
                self.userInfo = userInfo
            }
        } else {
            self.userInfo = nil
        }
    }
    
    static let shared = UsersInfoManager()
    private init(){}
    
}
