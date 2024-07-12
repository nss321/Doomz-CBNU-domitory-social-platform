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
    func rereplyButtonTapped(replyId: Int, sender: UIButton)
}

final class ReplyHeaderCollectionReusableView: UICollectionReusableView {
    weak var moreButtonDelegate: MoreButtonDelegate?
    weak var rereplyButtonDelegate: HeaderRereplyButtonDelegate?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rereplyButton: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var articleWriterButton: RoundButton!
    @IBOutlet weak var contentView: UIView!
    var commentId: Int?
    var memberId: Int?
    var createdAt: String?
    var isDeleted: Bool?
    var isArticleWriter = false {
        didSet {
            if isArticleWriter == true {
                articleWriterButton.isHidden = false
            }else {
                articleWriterButton.isHidden = true
            }
        }
    }
    
    var profileUrl: String? {
        didSet {
            updateProfileImage()
        }
    }
    
    var isCommentWriter = false {
        didSet {
            if isCommentWriter == false {
                moreButton.isHidden = true
            }else {
                moreButton.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rereplyButton.contentHorizontalAlignment = .leading
        rereplyButton.contentVerticalAlignment = .top
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreButtonDelegate!.moreButtonTapped(replyId: commentId!, format: .reply)
    }
    
    @IBAction func postRereplyButtonTapped(_ sender: UIButton) {
        rereplyButtonDelegate?.rereplyButtonTapped(replyId: commentId!, sender: sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rereplyButton.backgroundColor = .white
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        // contentView에 대해 layoutAttributes.size를 사용하여 fittingSize 계산
        let fittingSize = UIView.layoutFittingCompressedSize
        let size = contentView.systemLayoutSizeFitting(fittingSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        
        var frame = layoutAttributes.frame
        frame.size.height = size.height
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}

enum Reply {
    case reply
    case rereply
}
