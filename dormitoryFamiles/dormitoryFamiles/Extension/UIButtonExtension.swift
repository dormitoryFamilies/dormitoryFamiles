//
//  UIButtonExtension.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/03.
//

import UIKit

extension UIButton {
    func makeSquare(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIButton {
        self.layer.borderColor = .init(red: 179/255, green: 179/255, blue: 179/255, alpha: 0.39)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height),
        ])
        return self
    }
    
    func makeCircle(size: CGFloat, title: String, BackgroundColor: UIColor) -> UIButton {
        self.layer.cornerRadius = size/2
        self.clipsToBounds = true
        self.backgroundColor = BackgroundColor
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size),
        ])
        return self
    }
}

extension UILabel {
    func lineSpacing(_ spacing: CGFloat) {
            guard let text = text, let font = font else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = spacing
            let attributedString = NSAttributedString(string: text, attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ])
            self.attributedText = attributedString
    }
    
    func asColor(targetString: [String], color: UIColor) {
            let fullText = text ?? ""
            let attributedString = NSMutableAttributedString(string: fullText)
        for str in targetString {
            let range = (fullText as NSString).range(of: str)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
            attributedText = attributedString
        }
}
