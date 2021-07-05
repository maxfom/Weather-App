//
//  NetworkService.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 05.07.2021.
//

import Foundation
import SwiftyJSON

class NetworkService {
    
    @discardableResult
    func sendRequest(request: URLRequest, completion: @escaping (Result<JSON, Error>) -> Void) throws -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = JSON(data)
                completion(.success(json))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
    
}
