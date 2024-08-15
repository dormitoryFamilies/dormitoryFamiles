//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
import UIKit
struct Network {
    
    static func getMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        func createURL(from url: String) -> URL? {
            return URL(string: url)
        }
        //안될경우 한글이 들어가있는 url임으로addingPercentEncoding붙여서 다시 시도
        guard let url = createURL(from: url) else {
            guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedURL = createURL(from: encodedUrlString) else {
                completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
                return
            }
            
            fetchData(from: encodedURL, completion: completion)
            return
        }
        fetchData(from: url, completion: completion)
    }
    
    private static func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
           
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 500, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 500, userInfo: nil)))
                return
            }
           
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    static func deleteMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        //TODO: 여기 부분 안되서 도움을 좀 받았는데, 코드 수정해야함 작동은 잘 됨
        guard let url = URL(string: url) else {
            print("url오류")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    // 데이터가 없는 경우 적절한 에러 처리
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: ["description": "No data received from server"])))
                    return
                }
                do {
                    // 데이터를 T 타입으로 디코딩
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    // 디코딩 실패 시 에러 처리
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: ["description": "HTTP Status Code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }
    
    static func putMethod<T: Codable>(url: String,  completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL: \(url)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: ["description": "No HTTP response"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: ["description": "No data received from server"])))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: ["description": "HTTP Status Code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }
    
    static func postMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: ["description": "URL is not valid."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: ["description": "No HTTP response"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("postMethod 200번대 성공")
            } else {
                print("postMethod 200번대아님 실패")
            }
        }
        task.resume()
    }
    
    static func patchMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
            guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let token = Token.shared.number
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: ["description": "No HTTP response"])))
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    guard let data = data else {
                        completion(.failure(NSError(domain: "No data", code: 0, userInfo: ["description": "No data received from server"])))
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: ["description": "HTTP Status Code: \(httpResponse.statusCode)"])))
                }
            }
            task.resume()
        }
    
    
    static func loadImage(url: String) -> UIImageView {
        let imageView = UIImageView()
        guard let imageUrl = URL(string: url) else {
            return imageView
        }
        imageView.kf.setImage(with: imageUrl)
        return imageView
    }
}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
    case 양현재 = "양현재"
}
