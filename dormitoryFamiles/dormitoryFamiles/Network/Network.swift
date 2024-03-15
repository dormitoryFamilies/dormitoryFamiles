//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
struct Network {
    static let url = "http://43.202.254.127:8080"

    static var pathAllPostUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles?page=0&size=10&sort=s&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       }
       static var helpPostUrl: String {
           "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/도와주세요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       }
       static var togetherUrl: String {
           "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/함께해요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       }
       static var shareUrl: String {
           "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/나눔해요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       }
       static var lostUrl: String {
           "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/분실신고/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       }
    
    static func searchUrl(searchText: String) -> String {
        var url: String {
            "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles/search?&page=0&size=10&q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        return url
    }
    
    static func postRereplyUrl(replyId: Int) -> String {
        return Network.url + "/api/comments/\(replyId)/replyComments"
    }

    static func replyUrl(id: Int) -> String {
        return Network.url + "/api/articles/\(id)/comments"
    }
    
    static func postReplyUrl(id: Int) -> String {
        return Network.url + "/api/articles/\(id)/comments"
    }
    
    static func getMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
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

}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
    case 양현재 = "양현재"
}
