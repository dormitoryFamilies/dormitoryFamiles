//
//  ReplyHeaderCollectionReusableView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/07.
//

import UIKit

protocol MoreButtonDelegate: AnyObject {
    func moreButtonTapped(replyId: Int, format: Reply)
}

protocol HeaderRereplyButtonDelegate: AnyObject {
    func rereplyButtonTapped(replyId: Int)
}

class ReplyHeaderCollectionReusableView: UICollectionReusableView {
    weak var moreButtonDelegate: MoreButtonDelegate?
    weak var rereplyButtonDelegate: HeaderRereplyButtonDelegate?
   
    var commentId: Int?
    var memberId: Int?
    var profileUrl: String?
    var createdAt: String?
    var isWriter: Bool?
    var isDeleted: Bool?
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rereplyButton: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rereplyButton.contentHorizontalAlignment = .leading
        rereplyButton.contentVerticalAlignment = .top
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreButtonDelegate!.moreButtonTapped(replyId: commentId!, format: .reply)
    }
    
    @IBAction func postRereplyButtonTapped(_ sender: UIButton) {
        rereplyButtonDelegate?.rereplyButtonTapped(replyId: commentId!)
                rereplyButton.backgroundColor = .yellow
    }
    
    
}

enum Reply {
    case reply
    case rereply
}
