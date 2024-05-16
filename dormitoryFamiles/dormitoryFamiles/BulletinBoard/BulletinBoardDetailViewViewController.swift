//
//  BulletinBoardDetailViewViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/13.
//

import UIKit

final class BulletinBoardDetailViewViewController: UIViewController {
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
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    private var scrollPhotoView = PhotoScrollView()
    private var hasImage = true
    
    private let headerCell = ReplyHeaderCollectionReusableView()
    private var dataClass : DataClass?
    var id: Int = 0
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    private var url = ""
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var selectedReplyId = -1
    private var tagArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        network(url: url)
        setIndicator()
        setDelegate()
        setCollectionViewAutoSizing()
        setTextView()
        collectionView.isScrollEnabled = false
        replyNetwork(id: id)
    }
    
    private func setIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    private func setUI() {
        self.profileImage.layer.cornerRadius = profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        
        //네비게이션바 오른쪽 more버튼 UI
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bulletinBoardDetailMore"), style: .plain, target: self, action: #selector(postMoreButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .gray4
        
    }
    
    func setUrl(url: String) {
        self.url = url
    }
    
    @IBAction func replyPostButtonTapped(_ sender: UIButton) {
        let commentData = ["content": commentTextView.text]
        
        if let jsonData = try? JSONEncoder().encode(commentData) {
            var url = URL(string: "")
            if selectedReplyId == -1 {
                url = URL(string: Url.replyUrl(id: id))!
            }else {
                url = URL(string: Url.postRereplyUrl(replyId: selectedReplyId))!
            }
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let token = Token.shared.number
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if data != nil {
                    print("Response: \(response)")
                }
            }
            
            task.resume()
        }
    }
    
    private func network(url: String) {
        Network.getMethod(url: url) { (result: Result<DetailResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.data
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.titleLabel.title2 = data.title
                    self.nickname.title5 = data.nickName ?? "ㅇㄹ"
                    self.profileImage.image = UIImage(named: data.profileUrl)
                    self.dormitory.title5 = data.memberDormitory
                    self.categoryTag.subTitle2 = data.boardType
                    
                    let tagArr = data.tags.split(separator: "#")
                    let trimmedString = String(data.tags.dropFirst())
                    self.tagArray = trimmedString.components(separatedBy: "#").map { "#\($0)" }
                    print("ddddddddddddddddd",self.tagArray,"Ddddddddddddddfsfsdfsdfsdfs")
                    self.contentLabel.body1 = data.content
                    self.likeCountLabel.text = String(data.wishCount)
                    // isWished 구현 필요
                    self.statusTag.subTitle2 = data.status
                    
                    let datetime = data.createdAt
                    self.timeLabel.body2 = self.changeToTime(createdAt: datetime)
                    self.dateLabel.body2 = self.changeToDate(createdAt: datetime)
                    //프로필 이미지 불러오기
                    let url = URL(string: data.profileUrl)
                    self.profileImage.kf.setImage(with: url)
                    self.profileImage.contentMode = .scaleAspectFill
                    
                    //게시물 이미지 불러오기
                    if data.imagesUrls.isEmpty {
                        self.hasImage = false
                        self.layout()
                    }else {
                        self.layout()
                        for imageUrl in data.imagesUrls {
                            if let url = URL(string: imageUrl) {
                                self.loadImage(from: url) { [weak self] image in
                                    DispatchQueue.main.async {
                                        if let image = image {
                                            self?.scrollPhotoView.addImage(image: image)
                                        } else {
                                            print("이미지를 로드할 수 없습니다.")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.collectionView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error downloading image: \(String(describing: error))")
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
    
    
    private func replyNetwork(id: Int) {
        let commentUrl = Url.replyUrl(id: id)
        Network.getMethod(url: commentUrl) { [self] (result: Result<ReplyResponse, Error>) in
            switch result {
            case .success(let response):
                self.dataClass = response.data
                DispatchQueue.main.async { [self] in
                    self.replyCountLabel.text = String(dataClass!.totalCount)
                }
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func changeToTime(createdAt datetime: String) -> String {
        let timeStartIndex = datetime.index(datetime.startIndex, offsetBy: 11)
        let timeEndIndex = datetime.index(datetime.startIndex, offsetBy: 16)
        let timeRange = timeStartIndex..<timeEndIndex
        let time = String(datetime[timeRange]).replacingOccurrences(of: "-", with: ":")
        return time
    }
    
    private func changeToDate(createdAt datetime: String) -> String {
        let dateStartIndex = datetime.index(datetime.startIndex, offsetBy: 5)
        let dateEndIndex = datetime.index(datetime.startIndex, offsetBy: 10)
        let dateRange = dateStartIndex..<dateEndIndex
        let date = String(datetime[dateRange]).replacingOccurrences(of: "-", with: "/")
        return date
    }
    
    private func setDelegate() {
        commentTextView?.delegate = self
        tagCollectionView.delegate = self
        //TODO: 태그 구현시 dataSource 주석 해제 후 header부분 재 시도 해봐야 함. -1
        //tagCollectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.register(UINib(nibName: "ReplyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rereplyCell")
        collectionView.register(UINib(nibName: "ReplyHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "replyCell")
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "tagCell")
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
    
    private func layout() {
        self.view.addSubview(scrollPhotoView)
        scrollPhotoView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            self.scrollPhotoView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            self.scrollPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.scrollPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.scrollPhotoView.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        if !hasImage {
            let tagCollectionViewConstraint = tagCollectionView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 16)
            constraints.append(tagCollectionViewConstraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func postMoreButtonTapped() {
        let actionSheet = UIAlertController(title: "글메뉴", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: {(ACTION:UIAlertAction) in
            let url = Url.deletePost(id: self.id)
            Network.deleteMethod(url: url) { (result: Result<DeleteError, Error>) in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: {(ACTION:UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "모집 완료하기", style: .default, handler: {(ACTION:UIAlertAction) in
            let finishAlert = UIAlertController(title: "모집완료를 할까요?", message: "모집을 완료하면 1주일 뒤에 게시판에서 글이 내려가고, 보관함으로 이동해요.", preferredStyle: .alert)

           
            finishAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
              
            }))

            finishAlert.addAction(UIAlertAction(title: "완료하기", style: .default, handler: { [self] _ in
                let finishUrl = Url.changeStatus(id: id, status: .finish)
                Network.putMethod(url: finishUrl) { (result: Result<SuccessCode, Error>) in
                    switch result {
                    case .success(let successCode):
                        print("PUT 성공: \(successCode)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }

            }))
            
            self.present(finishAlert, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
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

extension BulletinBoardDetailViewViewController: UICollectionViewDelegate, UICollectionViewDataSource, MoreButtonDelegate, HeaderRereplyButtonDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return dataClass?.comments.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            guard let count = dataClass?.comments[section].replyComments?.count, count > 0 else {
                return 0
            }
            return count
        }
        return tagArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rereplyCell", for: indexPath) as! ReplyCollectionViewCell
            print(indexPath.section)
            let replyComment = dataClass?.comments[indexPath.section].replyComments?[indexPath.row]
            cell.nickname.text = replyComment?.nickname ?? ""
            cell.content.text = replyComment?.content ?? ""
            cell.replyCommentId = replyComment?.replyCommentId ?? 0
            cell.memberId = replyComment?.memberId ?? 0
            cell.profileUrl = replyComment?.profileUrl ?? ""
            cell.createdAt = replyComment?.createdAt ?? ""
            cell.isWriter = ((replyComment?.isWriter) != nil)
            cell.moreButtonDelegate = self
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionViewCell
            
            // 태그 배열에서 해당 인덱스의 태그를 가져옵니다.
            let tag = tagArray[indexPath.item]
            
            // 버튼에 태그를 설정합니다.
            cell.tagButton.setTitle(tag, for: .normal)
            
            return cell
        }
    }
    
    //헤더뷰관련
    //TODO: 태그 구현시 dataSource 주석 해제 후 header부분 재 시도 해봐야 함. -2
    //collectionView(댓글컬렉션뷰)는 헤더가 있지만,
    //tagCollectionView는 헤더가 없음 -> 해당 컬렉션뷰가 오면 UICollectionReusableView()를 반환 시 에러 발생하는것 잡아야함
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "replyCell", for: indexPath) as! ReplyHeaderCollectionReusableView
        let replyComment = dataClass?.comments[indexPath.section]
        headerView.moreButtonDelegate = self
        headerView.rereplyButtonDelegate = self
        headerView.commentId = replyComment?.commentId ?? 0
        headerView.memberId = replyComment?.memberId ?? 0
        headerView.profileUrl = replyComment?.profileUrl ?? ""
        headerView.nickname.text = replyComment?.nickName ?? ""
        let datetime = replyComment?.createdAt ?? ""
        headerView.timeLabel.body2 = changeToTime(createdAt: datetime)
        headerView.dateLabel.body2 = changeToDate(createdAt: datetime)
        headerView.content.text = replyComment?.content ?? ""
        headerView.isWriter = (replyComment?.isWriter ?? false)
        headerView.isDeleted = (replyComment?.isDeleted ?? false)
        
        return headerView
        
    }

    
    func moreButtonTapped(replyId: Int, format: Reply) {
        print(replyId)
        let actionSheet = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: {(ACTION:UIAlertAction) in
            
            var url = ""
            switch format {
            case .rereply:
                url = Url.deleteRereply(replyId: replyId)
            case .reply:
                url = Url.deleteReply(replyId: replyId)
            }
            
            Network.deleteMethod(url: url) { (result: Result<DeleteError, Error>) in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func rereplyButtonTapped(replyId: Int) {
        selectedReplyId = replyId
    }
}

extension BulletinBoardDetailViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let width: CGFloat = collectionView.bounds.width
            let height: CGFloat = 100
            
            return CGSize(width: width, height: height)
        }else {
            let tag = tagArray[indexPath.item]
                   let tagSize = tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.body2])
                   let cellWidth = tagSize.width + 20 // 여유 공간 추가
                   let cellHeight: CGFloat = 30 // 적절한 높이 설정
                   
                   return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
    
    //셀과 셀 사이의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    //헤더 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 148)
    }
    
}

enum Status:String {
case ing = "모집중"
case finish = "모집완료"
}

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    // 태그를 표시할 버튼
    let tagButton = RoundButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 버튼의 속성 설정
        tagButton.backgroundColor = .gray0
        tagButton.setTitleColor(.gray5, for: .normal)
        tagButton.titleLabel?.font = .body2
        
        // 버튼을 셀에 추가
        contentView.addSubview(tagButton)
        
        // 버튼을 셀의 영역에 맞게 설정
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
