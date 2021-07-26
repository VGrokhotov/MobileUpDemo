//
//  UserInfoObject.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import CoreData

@objc(UserInfoObject)
class UserInfoObject: NSManagedObject {
    @NSManaged public var token: String
    @NSManaged public var expires: Double
    @NSManaged public var id: String
}

extension UserInfoObject {
    func toUserInfo() -> UserInfo {
        return UserInfo(token: token, expires: expires, id: id)
    }
}
