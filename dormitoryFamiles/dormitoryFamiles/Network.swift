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

    static func replyUrl(id: Int) -> String {
        return "http://43.202.254.127:8080/api/articles/\(id)/comments"
    }
    
    static func postReplyUrl(id: Int) -> String {
        return "http://43.202.254.127:8080/api/articles/\(id)/comments"
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

}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
    case 양현재 = "양현재"
}
