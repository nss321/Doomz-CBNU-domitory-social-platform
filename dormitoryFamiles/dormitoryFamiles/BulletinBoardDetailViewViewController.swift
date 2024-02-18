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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setTextView()
        setCommentTextView()
//        setCollectionView()
    }
    
    private func setDelegate() {
        commentTextView.delegate = self
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
    
//    private func setCollectionView() {
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            collectionView.bottomAnchor.constraint(equalTo: roundLine.topAnchor, constant: -3)
//        ])
//    }
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
