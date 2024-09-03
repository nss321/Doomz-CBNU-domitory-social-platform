//
//  BulluetinBoardCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/27.
//

import UIKit
import Kingfisher

final class BulluetinBoardCollectionViewCell: UICollectionViewCell {
    var articleId: Int?
    var profileUrl: String? {
        didSet {
            updateProfileImage()
        }
    }
    var status: String?
    var thumbnailUrl: String? {
        didSet {
            updateThumbnailImage()
        }
    }
    
    @IBOutlet weak var categoryTag: RoundButton!
    @IBOutlet weak var statusTag: RoundButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var wishCount: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    //셀 진입시
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.isHidden = true
    }
    
    //셀 재사용시
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.isHidden = true
        thumbnailImageView.image = nil
    }
    
    //모집완료일경우 색상 변경
    func changeFinish() {
        statusTag.backgroundColor = .gray0
        statusTag.tintColor = .gray5
    }
    
    func changeIng() {
        statusTag.backgroundColor = UIColor(hex: "#D8EAFF")
        statusTag.borderColor = UIColor(hex: "#D8EAFF")
        statusTag.tintColor = .black
    }
    
    private func updateProfileImage() {
        guard let profileUrl = profileUrl, let url = URL(string: profileUrl) else {
            return
        }
        profileImageView.kf.setImage(with: url)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    private func updateThumbnailImage() {
        guard let thumbnailUrl = thumbnailUrl, let url = URL(string: thumbnailUrl) else {
            return
        }
        thumbnailImageView.isHidden = false
        thumbnailImageView.kf.setImage(with: url)
        thumbnailImageView.contentMode = .scaleAspectFill
    }
}
