//
//  NetworkManager.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getRequest(with url: URL, headers: [String: String], completion: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {
    private let headers: [String: String] = [
        "accept": "application/json"
    ]
    
    init() {}

    func getRequest(with url: URL, headers: [String: String] = [:], completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.setValue("Bearer \(AppConfig.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidData
    case invalidURL
}

