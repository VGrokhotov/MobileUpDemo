//
//  AlbumNetworkService.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 23.07.2021.
//

import Foundation

class AlbumNetworkService: NetworkService {
    
    // TODO: придумать что делать при смене ip
    override init() {
        super.init()
        
        components = URLComponents(string: "https://api.vk.com/method/photos.get")!
        components.queryItems = [
            URLQueryItem(name: "access_token", value: UsersInfoManager.shared.userInfo?.token),
            URLQueryItem(name: "owner_id", value: "-128666765"),
            URLQueryItem(name: "album_id", value: "266276915"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "v", value: "5.131")
        ]
    }
    
    static var authURL: URL? {
        var components = URLComponents(string: "https://oauth.vk.com/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "7909293"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        return components?.url
    }
    
    func getPhotosWith(offset: Int, completion: @escaping (Photos) -> (), errCompletion: @escaping (String) -> ()) {
        
        let index = components.queryItems?.firstIndex(where: { item in
            item.name == "offset"
        })
        components.queryItems?[index!].value = String(offset)
        
        guard
            let url = components.url
        else {
            badURL(errCompletion)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.failed(message: error.localizedDescription, errCompletion: errCompletion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.completionHandler(httpResponse.statusCode, data, completion, errCompletion)
            }
        }
        task.resume()
    }
}
