//
//  TagScrollView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/03.
//

import UIKit

class TagScrollView: UIScrollView {

    var tagStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagStackView.spacing = 8
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tagStackView.spacing = 8
        configure()
    }
    
    private func configure() {
        self.addSubview(tagStackView)
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tagStackView.topAnchor.constraint(equalTo: self.topAnchor),
            tagStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tagStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        //스크롤바 가리기
        self.showsHorizontalScrollIndicator = false
    }

}
