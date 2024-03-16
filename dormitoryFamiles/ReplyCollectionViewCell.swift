//
//  ReplyCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/15.
//

import UIKit

class ReplyCollectionViewCell: UICollectionViewCell {
    weak var moreButtonDelegate: MoreButtonDelegate?
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
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreButtonDelegate!.moreButtonTapped(replyId: replyCommentId!, format: .rereply)
    }
}
