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
    
    let badMessage = Strings.somethingWentWrong
    
    func badURL(_ errCompletion: @escaping (NetworkError) -> ()) {
        print("Wrong URL")
        DispatchQueue.main.async {
            errCompletion(.other(self.badMessage))
        }
    }
    
    func failed(error: NetworkError, errCompletion: @escaping (NetworkError) -> ()) {
        DispatchQueue.main.async {
            errCompletion(error)
        }
    }
    
    func success<T: Decodable>(with data: Data?, status: Int, completion: @escaping (T) -> (), errCompletion: @escaping (NetworkError) -> ()) {
        if let data = data {
            let object = try? JSONDecoder().decode(T.self, from: data)
            if let object = object {
                DispatchQueue.main.async {
                    completion(object)
                }
            } else {
                DispatchQueue.main.async {
                    if let response = status as? T {
                        completion(response)
                    } else {
                        self.failed(error: .unauthorized, errCompletion: errCompletion)
                    }
                }
            }
        }
    }
    
    func badCode(data: Data?, errCompletion: @escaping (NetworkError) -> ()) {
        if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let error = json?["error"] as? [String: Any]
            let message = error?["error_msg"] as? String
            print(message ?? "cannot read JSON")
            failed(error: .other(message ?? badMessage), errCompletion: errCompletion)
        }
    }
    
    func completionHandler<T: Decodable>(
        _ status: Int,
        _ data: Data?,
        _ completion: @escaping ((T) -> ()),
        _ errCompletion: @escaping (NetworkError) -> ()
    ){
        print(status)
        switch status {
        case 200...226:
            success(with: data, status: status, completion: completion, errCompletion: errCompletion)
        default:
            badCode(data: data, errCompletion: errCompletion)
        }
    }
}
