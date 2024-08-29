//
//  BulletinBoardDetailViewViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/13.
//

import UIKit

protocol successRereplyPost: AnyObject {
    func successRereplyPost(replyId: Int)
}

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
    @IBOutlet weak var likeAndChatStackView: UIStackView!
    @IBOutlet weak var likeButton: RoundButton!
    
    private var tapGesture: UITapGestureRecognizer?
    private var scrollPhotoView = PhotoScrollView()
    private var hasImage = true
    private var selectedRereplyButton: UIButton?
    private let headerCell = ReplyHeaderCollectionReusableView()
    private var dataClass : DataClass?
    var id: Int = 0
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    private var url = ""
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var selectedReplyId = -1
    private var tagArray = [String]()
    private var isWished = false
    private var status = ""
    private var isWriter = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        network(url: url)
        setUI()
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
        likeButton.setTitleColor(.gray5, for: .normal)
        self.profileImage.layer.cornerRadius = profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setNavigationItem() {
        //네비게이션바 오른쪽 more버튼 UI
        if isWriter {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bulletinBoardDetailMore"), style: .plain, target: self, action: #selector(postMoreButtonTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = .gray4
        }
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
            } else {
                url = URL(string: Url.postRereplyUrl(replyId: selectedReplyId))!
            }
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let token = Token.shared.access
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if data != nil {
                    print("Response: \(response)")
                    DispatchQueue.main.async {
                        self.replyNetwork(id: self.id) {
                            self.selectedReplyId = -1
                            self.collectionView.reloadData()
                            self.commentTextView.text = ""
                            self.showCompletionAlert(status: "댓글 작성")
                            self.scrollToTop()
                            guard let replyCount = self.replyCountLabel.text as? Int else { return }
                            self.replyCountLabel.text = String(replyCount + 1)
                            
                        }
                    }
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
                    self.nickname.title5 = data.nickname ?? ""
                    self.profileImage.image = UIImage(named: data.profileUrl)
                    self.dormitory.title5 = data.memberDormitory
                    self.categoryTag.subTitle2 = data.boardType
                    
                    self.contentLabel.body1 = data.content
                    self.likeCountLabel.text = String(data.wishCount)
                    self.isWished = data.isWished
                    self.statusTag.subTitle2 = data.status
                    
                    let datetime = data.createdAt
                    self.timeLabel.body2 = self.changeToTime(createdAt: datetime)
                    self.dateLabel.body2 = self.changeToDate(createdAt: datetime)
                    //프로필 이미지 불러오기
                    let url = URL(string: data.profileUrl)
                    self.profileImage.kf.setImage(with: url)
                    self.profileImage.contentMode = .scaleAspectFill
                    self.isWriter = data.isWriter
                    self.setNavigationItem()
                    self.status = data.status
                    
                    if status == Status.finish.rawValue {
                        statusTag.backgroundColor = .gray0
                        statusTag.setTitleColor(.gray5, for: .normal)
                        statusTag.subTitle2 = "모집완료"
                    }
                    
                    
                    if isWriter {
                        self.likeButton.setTitle("관심목록 \(likeCountLabel.text ?? "")", for: .normal)
                    }else {
                        if isWished {
                            likeButton.setImage(UIImage(named: "like"), for: .normal)
                        }
                        self.likeButton.setTitle(likeCountLabel.text, for: .normal)
                    }
                    
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
    
    
    private func replyNetwork(id: Int, completion: (() -> Void)? = nil) {
        let commentUrl = Url.replyUrl(id: id)
        Network.getMethod(url: commentUrl) { [self] (result: Result<ReplyResponse, Error>) in
            switch result {
            case .success(let response):
                self.dataClass = response.data
                DispatchQueue.main.async {
                    self.replyCountLabel.text = String(dataClass!.totalCount)
                    completion?()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    private func showCompletionAlert(status: String) {
        let alertController = UIAlertController(title: "\(status) 완료", message: "\(status) 완료되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func scrollToTop() {
        if let scrollView = view.subviews.compactMap({ $0 as? UIScrollView }).first {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        let heightPhoto: CGFloat = hasImage ? 100 : 0
        
        var constraints = [
            scrollPhotoView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            scrollPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollPhotoView.heightAnchor.constraint(equalToConstant: heightPhoto)
        ]
        
        if hasImage {
            constraints.append(likeAndChatStackView.topAnchor.constraint(equalTo: scrollPhotoView.bottomAnchor, constant: 20))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func postMoreButtonTapped() {
        var statusText = ""
        var statusTitle = ""
        var statusMessage = ""
        var statusQuery = ""
        
        if status == Status.ing.rawValue {
            statusText = "모집 완료하기"
            statusTitle = "모집완료를 할까요?"
            statusMessage = "모집을 완료하면 1주일 뒤에 게시판에서 글이 내려가고, 보관함으로 이동해요."
            statusQuery = Status.finish.rawValue
        }else {
            statusText = "모집하기"
            statusTitle = "모집을 할까요?"
            statusMessage = "모집을 하게되면 글이 내려가지 않고 유지되요"
            statusQuery = Status.ing.rawValue
        }
        
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
            //얼럿을 여기 넣는 이유는, UI가 본인이 쓴 글일 경우만 삭제버튼이 나오도록 설계하여 삭제에 오류가 없을것이며, 궁극적인 이유는.. 삭제는 잘 되는데 failure로 빠지는 이슈가 있어서 success가 되었든 failure가 되었든 얼럿 처리를 하도록 설계
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "게시글 삭제 완료", message: "게시글 삭제가 완료되었습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: {(ACTION:UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: statusText, style: .default, handler: {(ACTION:UIAlertAction) in
            let finishAlert = UIAlertController(title: statusTitle, message: statusMessage, preferredStyle: .alert)
            
            
            finishAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                
            }))
            
            finishAlert.addAction(UIAlertAction(title: "완료하기", style: .default, handler: { [self] _ in
                let finishUrl = Url.changeStatus(id: id, status: statusQuery)
                
                Network.putMethod(url: finishUrl, body: nil) { [self] (result: Result<SuccessCode, Error>) in
                    switch result {
                    case .success(let successCode):
                        print("PUT 성공: \(successCode)")
                        DispatchQueue.main.async { [self] in
                            if status == Status.ing.rawValue {
                                statusTag.backgroundColor = .gray0
                                statusTag.setTitleColor(.gray5, for: .normal)
                                statusTag.subTitle2 = "모집완료"
                                status = Status.finish.rawValue
                            } else {
                                statusTag.backgroundColor = UIColor(red: 216/255, green: 234/255, blue: 255/255, alpha: 1)
                                statusTag.setTitleColor(.doomzBlack, for: .normal)
                                statusTag.subTitle2 = "모집중"
                                status = Status.ing.rawValue
                            }
                            statusTag.layoutIfNeeded()
                        }
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
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        //본인이 쓴 글이 아닐땐 좋아요/좋아요 취소 기능
        if !isWriter {
            let likeUrl = Url.like(id: id)
            if isWished {
                Network.deleteMethod(url: likeUrl, completion: { [self] (result: Result<SuccessCode, Error>) in
                    switch result {
                    case .success(let response):
                        print(response)
                        DispatchQueue.main.async { [self] in
                            self.likeButton.setImage(UIImage(named: "bulletinBaordDetailLike"), for: .normal)
                            if let currentLikeCount = Int(self.likeButton.currentTitle ?? "0") {
                                self.likeButton.setTitle(String(currentLikeCount - 1), for: .normal)
                                likeCountLabel.text = String(currentLikeCount - 1)
                            }
                        }
                        isWished = false
                        
                    case .failure(_):
                        print("error")
                    }
                })
            }else {
                Network.postMethod(url: likeUrl, body: nil, completion: { (result: Result<LikeStatus, Error>) in
                    switch result {
                    case .success(let response):
                        print(response)
                    case .failure(_):
                        print("error")
                        DispatchQueue.main.async { [self] in
                            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                            if let currentLikeCount = Int(self.likeButton.currentTitle ?? "0") {
                                self.likeButton.setTitle(String(currentLikeCount + 1), for: .normal)
                                likeCountLabel.text = String(currentLikeCount + 1)
                            }
                        }
                        self.isWished = true
                    }
                })
            }
        }else { //TODO: 본인이 쓴 글이면 다른 로직
            
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture!)
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            view.frame.origin.y = -(keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let tap = tapGesture {
            view.removeGestureRecognizer(tap)
            tapGesture = nil
        }
        view.frame.origin.y = 0
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
            cell.createdTime.body2 = self.changeToTime(createdAt: replyComment?.createdAt ?? "")
            cell.createdAt.body2 = DateUtility.yymmdd(from: replyComment?.createdAt ?? "", separator: ".")
            cell.moreButtonDelegate = self
            if replyComment?.memberId == dataClass?.loginMemberId {
                cell.isCommentWriter = true
            }else {
                cell.isCommentWriter = false
            }
            if replyComment?.isArticleWriter ?? false {
                cell.isArticleWriter = true
            }else {
                cell.isArticleWriter = false
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionViewCell
            
            let tag = tagArray[indexPath.item]
            cell.tagButton.setTitle(tag, for: .normal)
            
            return cell
        }
    }
    
    //헤더뷰관련
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
        headerView.nickname.text = replyComment?.nickname ?? ""
        let datetime = replyComment?.createdAt ?? ""
        headerView.timeLabel.body2 = changeToTime(createdAt: datetime)
        headerView.dateLabel.body2 = DateUtility.yymmdd(from: replyComment?.createdAt ?? "", separator: ".")
        headerView.content.text = replyComment?.content ?? ""
        if (replyComment?.isDeleted) ?? false {
            headerView.content.text = "삭제된 댓글입니다."
            headerView.content.textColor = .gray4
        }else {
            headerView.content.textColor = .black
        }
        if replyComment?.memberId == dataClass?.loginMemberId {
            headerView.isCommentWriter = true
        }else {
            headerView.isCommentWriter = false
        }
        
        if replyComment?.isArticleWriter ?? false {
            headerView.isArticleWriter = true
        }else {
            headerView.isArticleWriter = false
        }
        
        // 현재 선택된 버튼이 이 헤더의 버튼이면 배경색을 노란색으로 설정
        if selectedReplyId == headerView.commentId {
            headerView.rereplyButton.backgroundColor = .yellow
        } else {
            headerView.rereplyButton.backgroundColor = .white
        }
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
                    //TODO: 삭제가 완료되면 왜 failure로 빠지면서 정상작동이 되는지 모르겠음. 백앤드에게 물어보기
                    DispatchQueue.main.async {
                        self.replyNetwork(id: self.id) {
                            self.collectionView.reloadData()
                            self.showCompletionAlert(status: "댓글 삭제")
                            self.scrollToTop()
                            guard let replyCount = self.replyCountLabel.text as? Int else { return }
                            self.replyCountLabel.text = String(replyCount - 1)
                        }
                    }
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func rereplyButtonTapped(replyId: Int, sender: UIButton) {
        // 이전에 선택된 버튼이 있다면 배경색을 흰색으로 변경
        if let selectedButton = selectedRereplyButton, selectedButton != sender {
            selectedButton.backgroundColor = .white
        }
        
        // 클릭된 버튼이 이미 선택된 버튼인지 확인
        if selectedRereplyButton == sender {
            // 동일한 버튼이 다시 클릭되면 선택 해제
            sender.backgroundColor = .white
            selectedRereplyButton = nil
            selectedReplyId = -1
        } else {
            // 새로운 버튼이 클릭되면 배경색을 노란색으로 변경
            sender.backgroundColor = .yellow
            selectedRereplyButton = sender
            selectedReplyId = replyId
        }
    }
    
}

extension BulletinBoardDetailViewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 140)
    }
    
    //셀과 셀 사이의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

enum Status: String {
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
