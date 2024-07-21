import UIKit
import SnapKit
import Kingfisher

class ChattingDetailViewController: UIViewController, ConfigUI {
    
    let tableView = UITableView()
    var roomId = 0
    var messages: [ChatMessage] = []
    var isLoading = false
    var page = 0
    var isLast = false
    
    private var profileStackView: ChattingNavigationProfileStackView!
    var profileImageUrl: String?
    var nickname: String?
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메세지 보내기"
        textField.font = .body2
        return textField
    }()
    
    private let containerView: RoundLabel = {
        let containerView = RoundLabel()
        containerView.backgroundColor = .gray0
        containerView.isUserInteractionEnabled = true
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBar()
        setupTableView()
        chattingHistoryApiNetwork(url: Url.chattingHistory(page: page, size: 2, roomId: roomId))
        addComponents()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        messages = []
        page = 0
    }
    
    private func createProfileStackView() -> ChattingNavigationProfileStackView {
        profileStackView = ChattingNavigationProfileStackView(frame: .zero)
        if let url = profileImageUrl, let nickname = nickname {
            let profileImageView = Network.loadImage(url: url)
            self.profileStackView.profileImageView.image = profileImageView.image
            self.profileStackView.configure(nickname: nickname)
        }
        return profileStackView
    }
    
    private func setNavigationBar() {
        let profileStackView = createProfileStackView()
        self.navigationItem.titleView = profileStackView
        let moreImage = UIImage(named: "chattingDetailMore")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(moreButtonTapped))
    }
    
    func addComponents() {
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(textField)
    }
    
    func setConstraints() {
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
            $0.left.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(containerView.snp.top)
            $0.left.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func moreButtonTapped() {
        print("moreButtonTapped")
    }
    
    func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MyChattingTableViewCell.self, forCellReuseIdentifier: "MyChattingTableViewCell")
        tableView.register(YourChattingTableViewCell.self, forCellReuseIdentifier: "YourChattingTableViewCell")
    }
    
    private func chattingHistoryApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<ApiResponse, Error>) in
            switch result {
            case .success(let response):
                
                self.messages.insert(contentsOf: response.data.chatHistory, at: 0)
                self.isLast = response.data.isLast
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    @objc private func loadMoreData() {
        guard !isLast else { return }
        isLoading = true
        page += 1
        chattingHistoryApiNetwork(url: Url.chattingHistory(page: page, size: 2, roomId: roomId))
    }
}

extension ChattingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.isSender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChattingTableViewCell", for: indexPath) as! MyChattingTableViewCell
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChattingTableViewCell", for: indexPath) as! YourChattingTableViewCell
            cell.configure(with: message)
            cell.profileImageView = profileStackView.profileImageView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChattingDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == tableView {
            if offsetY < -1 && !isLoading {
                isLoading = true
                loadMoreData()
            }
        }
    }
}
