//
//  NetworkService.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 23.07.2021.
//

import Foundation

class NetworkService {
    
    init() {
        components = URLComponents()
    }
    
    var components: URLComponents
    
    let badMessage = "Что-то пошло не так"
    
    func badURL(_ errCompletion: @escaping (String) -> ()) {
        print("Wrong URL")
        DispatchQueue.main.async {
            errCompletion(self.badMessage)
        }
    }
    
    func failed(message: String, errCompletion: @escaping (String) -> ()) {
        DispatchQueue.main.async {
            errCompletion(message)
        }
    }
    
    func success<T: Decodable>(with data: Data?, status: Int, completion: @escaping (T) -> ()) {
        if let data = data {
            let object = try? JSONDecoder().decode(T.self, from: data)
            if let object = object {
                DispatchQueue.main.async {
                    completion(object)
                }
            } else {
                DispatchQueue.main.async {
                    completion(status as! T)
                }
            }
        }
    }
    
    func badCode(data: Data?, errCompletion: @escaping (String) -> ()) {
        if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let error = json?["error"] as? [String: Any]
            let message = error?["error_msg"] as? String
            print(message ?? "cannot read JSON")
            failed(message: message ?? badMessage , errCompletion: errCompletion)
        }
    }
    
    func completionHandler<T: Decodable>(
        _ status: Int,
        _ data: Data?,
        _ completion: @escaping ((T) -> ()),
        _ errCompletion: @escaping (String) -> ()
    ){
        print(status)
        switch status {
        case 200...226:
            success(with: data, status: status, completion: completion)
        default:
            badCode(data: data, errCompletion: errCompletion)
        }
    }
}
