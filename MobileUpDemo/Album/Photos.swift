//
//  Photos.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 23.07.2021.
//

import Foundation

struct Photos: Decodable {
    let response: Response
}

struct Response: Decodable {
    let count: Int
    let items: [Photo]
}

struct Photo: Decodable {
    let date: Int
    let sizes: [Size]
    
    var bestSize: Size {
        var biggestWidth = 0
        var index = 0
        sizes.enumerated().forEach { (x, size) in
            if size.width > biggestWidth {
                biggestWidth = size.width
                index = x
            }
        }
        return sizes[index]
    }
}

struct Size: Decodable {
    let height: Int
    let width: Int
    let url: String
    let type: String
}
