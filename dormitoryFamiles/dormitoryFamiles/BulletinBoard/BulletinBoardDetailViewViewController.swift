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
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var tagStackView: UIStackView!
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
                } else if let data = data {
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
                    
                    //TODO: 태그를 스택뷰로 구현하였는데, 스택뷰는 한줄처리만 된다는 특성이 있기 때문에 컬렉션뷰로 대체해야함.
                    let tagArr = data.tags.split(separator: "#")
                    let trimmedString = String(data.tags.dropFirst())
                    let tagsArray = trimmedString.components(separatedBy: "#").map { "#\($0)" }
                    for tag in tagsArray {
                        let tagButton = RoundButton()
                        tagButton.backgroundColor = .gray0
                        tagButton.setTitleColor(.gray5, for: .normal)
                        tagButton.body2 = tag
                        self.tagStackView.addArrangedSubview(tagButton)
                    }
                    
                    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ReplyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rereplyCell")
        collectionView.register(UINib(nibName: "ReplyHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "replyCell")
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
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            self.scrollPhotoView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            self.scrollPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.scrollPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.scrollPhotoView.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        if !hasImage {
            let tagStackViewConstraint = tagStackView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 16)
            constraints.append(tagStackViewConstraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func postMoreButtonTapped() {
        let actionSheet = UIAlertController(title: "글메뉴", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: {(ACTION:UIAlertAction) in
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: {(ACTION:UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "모집 완료하기", style: .default, handler: {(ACTION:UIAlertAction) in
            let finishAlert = UIAlertController(title: "모집완료를 할까요?", message: "모집을 완료하면 1주일 뒤에 게시판에서 글이 내려가고, 보관함으로 이동해요.", preferredStyle: .alert)

            // 취소 액션 추가
            finishAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                // 취소를 눌렀을 때 수행할 작업을 여기에 추가합니다 (선택사항)
                print("취소 버튼을 눌렀습니다.")
            }))

            // 완료하기 액션 추가
            finishAlert.addAction(UIAlertAction(title: "완료하기", style: .default, handler: { _ in
                // 완료하기를 눌렀을 때 수행할 작업을 여기에 추가합니다
                print("완료하기 버튼을 눌렀습니다.")
                // 모집 완료 처리 로직을 여기에 추가합니다.
            }))

            // UIAlertController를 표시합니다
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
        return dataClass?.comments.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = dataClass?.comments[section].replyComments?.count, count > 0 else {
            return 0
        }
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    //헤더뷰관련
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
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
            headerView.isWriter = ((replyComment?.isWriter) != nil)
            headerView.isDeleted = ((replyComment?.isDeleted) != nil)
            
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func moreButtonTapped(replyId: Int, format: Reply) {
        print(replyId)
        let actionSheet = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: {(ACTION:UIAlertAction) in
            
            var url = ""
            switch format {
            case .rereply:
                url = "http://43.202.254.127:8080/api/replyComments/\(replyId)"
            case .reply:
                url = "http://43.202.254.127:8080/api/comments/\(replyId)"
            }
            Network.deleteMethod(url: url) { (result: Result<ReplyDelete, Error>) in
                switch result {
                case .success(let response):
                    print(response)
                    print("아아")
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
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 100
        
        return CGSize(width: width, height: height)
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
