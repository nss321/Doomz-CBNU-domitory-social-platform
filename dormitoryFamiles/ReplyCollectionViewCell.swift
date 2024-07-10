//
//  ReplyCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/15.
//

import UIKit
import Kingfisher

final class ReplyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var articleWriterButton: RoundButton!
    
    weak var moreButtonDelegate: MoreButtonDelegate?
    var replyCommentId: Int?
    var memberId: Int?
    var profileUrl: String? {
        didSet {
            updateProfileImage()
        }
    }
    var isCommentWriter: Bool = false {
        didSet {
            if isCommentWriter == false {
                moreButton.isHidden = true
            }else {
                moreButton.isHidden = false
            }
        }
    }
    
    var isArticleWriter = false {
        didSet {
            if isArticleWriter == true {
                articleWriterButton.isHidden = false
            }else {
                articleWriterButton.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        if let replyCommentId = replyCommentId {
            moreButtonDelegate?.moreButtonTapped(replyId: replyCommentId, format: .rereply)
        }
    }
    
    private func updateProfileImage() {
        guard let profileUrl = profileUrl, let url = URL(string: profileUrl) else {
            return
        }
        profileImageView.kf.setImage(with: url)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}
