//
//  BulletinBoardDetailViewViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/13.
//

import UIKit

class BulletinBoardDetailViewViewController: UIViewController {
    @IBOutlet weak var roundLine: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textViewSuperView: TagButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var statusTag: RoundButton!
    @IBOutlet weak var categoryTag: RoundButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var dormitory: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var chatCountLabel: UILabel!
    
    var collectionViewHeightConstraint = NSLayoutConstraint()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setCollectionViewAutoSizing()
        setTextView()
        collectionView.isScrollEnabled = false

    }
    
   

    
    private func setDelegate() {
        commentTextView?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "relpyCell")
    }
    
    private func setCollectionViewAutoSizing() {
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
        collectionViewHeightConstraint.isActive = true
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            collectionViewHeightConstraint.constant = collectionView.contentSize.height
        }
    }

    
    private func setTextView() {
        if commentTextView.text == "" {
            commentTextView.textColor = .gray4
            commentTextView.text = "댓글을 남겨주세요."
                }else {
                    commentTextView.textColor = .black
                }
    }
    
    private func setCommentTextView() {
        commentTextView.font = .body2
        
        //텍스트뷰 사이즈에 맞게 늘리기
        commentTextView.isScrollEnabled = false
        commentTextView.sizeToFit()
    }
    
}


extension BulletinBoardDetailViewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray4 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .gray4
            textView.text = "내용을 입력해 주세요."
        }
    }
}

extension BulletinBoardDetailViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 100
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relpyCell", for: indexPath) as UICollectionViewCell
           return cell
       }

}

extension BulletinBoardDetailViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 100
        
        return CGSize(width: width, height: height)
    }
    
    //셀과 셀 사이의 간격.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}
