//
//  DormitoryButtonHandlingProtocol.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import Foundation
import UIKit

protocol DormitoryButtonHandling: UIViewController {
    func presentSheet()
}

extension DormitoryButtonHandling {
    func presentSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let choiceDormitoryViewController = storyboard.instantiateViewController(withIdentifier: "ChoiceDormitoryViewController")
        
        guard let sheet = choiceDormitoryViewController.presentationController as? UISheetPresentationController else {
            return
        }
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
        sheet.preferredCornerRadius = 50
        self.present(choiceDormitoryViewController, animated: true)
    }
}

