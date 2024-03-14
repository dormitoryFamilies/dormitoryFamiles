//
//  CommentCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/18.
//

import UIKit

class ReplyCollectionViewCell: UICollectionViewCell {
    
    var replyCommentId: Int?
    var memberId: Int?
    var profileUrl: String?
    var createdAt: String?
    var isWriter: Bool?
   
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
