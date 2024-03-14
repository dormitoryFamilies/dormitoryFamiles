//
//  SelectedDormitory.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import Foundation
class SelectedDormitory {
    static let shared = SelectedDormitory()
    var domitory = "본관"
    
    private init() { }
    
    func changeKind(_ kind: String) {
            self.domitory = kind
        NotificationCenter.default.post(name: .changeDormiotry, object: nil)
        }

}


extension Notification.Name {
    static let changeDormiotry = Notification.Name("changeDormiotry")
}
