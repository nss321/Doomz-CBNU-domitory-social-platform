//
//  RecommendedMatesViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/22/24.
//

import UIKit
import SnapKit
import Combine
import Then

final class RecommendedMatesViewController: UIViewController, ConfigUI {
    
    private let cardWidth: CGFloat = Double(UIScreen.currentScreenWidth) * 0.894
    private let cardHeight: CGFloat = Double(UIScreen.currentScreenHeight) * 0.517
    private var profiles: [ProfileCard] = []
    private let spacing: CGFloat = 17 // 카드 사이 간격

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "선호하는 룸메의 라이프 스타일 선택이\n나랑 비슷한 둠즈를 추천해요."
        label.font = FontManager.body2()
        label.textAlignment = .left
        label.textColor = .gray4
        label.numberOfLines = 0
        label.addCharacterSpacing()
        return label
    }()
    
    private let didntSetupLifeStyleAlert = didntSetupLifeStyleView()
    
    private let dim = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.5
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .gray3!, height: 52) {
        // self.didClickNextButton()
    }
    
    private lazy var typePreferredButtonModel = CommonbuttonModel(title: "선호 룸메 정보 입력하기 >", titleColor: .white ,backgroundColor: .primary!, height: 48) {
        self.navigationController?.pushViewController(SleepPatternViewController(), animated: true)
    }
    
    private let scrollView = UIScrollView()
    
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("추천 룸메")
        dim.isHidden = true
        didntSetupLifeStyleAlert.isHidden = true
        didntSetupLifeStyleAlert.typePreferredButton.setup(model: typePreferredButtonModel)
        
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 스크롤 뷰의 contentOffset 설정
        let initialOffsetX = -scrollView.contentInset.left
        if scrollView.contentOffset == .zero { // 처음에만 설정되도록
            scrollView.setContentOffset(CGPoint(x: initialOffsetX, y: 0), animated: false)
        }
    }
    
    private func setUI() {
        addComponents()
        setConstraints()
        fetchTitleLabel()
        fetchMyLifeStyle()
    }
    
    func addComponents() {
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            $0.left.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.left.equalTo(titleLabel.snp.left)
        }
    }
    
    /// 사용자의 프로필을 조회해서 닉네임을 가져오기 위한 함수
    private func fetchTitleLabel() {
        let endpoint = Url.getMyProfile()
        NetworkService.shared.getRequest(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched title label.")
                case .failure(let error):
                    print("Failed to fetch title label: \(error)")
                }
            } receiveValue: { (userProfile: UserProfileData) in
                let nickname = userProfile.nickname
                let text = "\(nickname)님의\n추천 룸메입니다!"
                let attributedText = NSMutableAttributedString(string: text, attributes: [.font: FontManager.title1(), .foregroundColor: UIColor.doomzBlack])
                attributedText.addAttributes([
                    .font: FontManager.body1()
                ], range: NSRange(location: nickname.count, length: 2))
                self.titleLabel.attributedText = attributedText
            }
            .store(in: &cancellables)
    }
    
    /// 나의 생활습관을 설정했는지 여부를 체크하고, 분기에 따라 룸메이트 추천 or 생활습관 설정 페이지로 이동
    private func fetchMyLifeStyle() {
        let endpoint = Url.lifeStyles()
        NetworkService.shared.getRequest(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { (compeltion: Subscribers.Completion<Error>) in
                switch compeltion {
                case .finished:
                    print("Successfully fetched user's life style.")
                case .failure(let error):
                    print("Failed to fetch user's life style: \(error)")
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .notFound(let message):
                            // TODO: 체크 후 얼럿 표시
                            self.hideAllComponent()
                            self.showAlertWithDim()
                            print("Not Found Error: \(message)")
                            
                        case .serverError(let message):
                            print("Server Error: \(message)")
                        case .unknown(let message):
                            print("Unknown Error: \(message)")
                        }
                    } else {
                        print("Unhandled Error: \(error.localizedDescription)")
                    }
                }
            } receiveValue: { [weak self] (lifestyle: LifeStyleData) in
//                print("lifeStyle \(lifestyle)")
                self?.fetchMatchedMates()
            }
            .store(in: &cancellables)
    }
    
    private func showAlertWithDim() {
        view.addSubview(dim)
        view.addSubview(didntSetupLifeStyleAlert)
        dim.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        didntSetupLifeStyleAlert.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().inset(27)
            $0.height.equalToSuperview().inset(190)
        }
        dim.isHidden = false
        didntSetupLifeStyleAlert.isHidden = false
    }
    
    private func hideAllComponent() {
        view.subviews.forEach {
            $0.isHidden = true
        }
    }
    
    /// 나의 룸메 매칭 결과 조회
    private func fetchMatchedMates() {
        let endpoint = Url.getMatchedMatesIds()
        NetworkService.shared.getRequest(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .flatMap { (matchedUserIds: MatchedUserIds) -> AnyPublisher<[MatchedUser], Error> in
                // 매칭된 ID 리스트를 먼저 가져오고, 해당 유저 프로필을 검색하는 요청을 반환
                let profileRequests = matchedUserIds.candidateIds.map { id in
                    self.fetchProfileForUser(id: id)
                }
                // 요청 배열 반환
                return Publishers.MergeMany(profileRequests).collect().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched all recommendations")
                case .failure(let error):
                    print("Failed to fetch recommendations: \(error)")
                }
            }, receiveValue: { [weak self] matchedUser in
                for _ in matchedUser {
                    let card = ProfileCard()
                    self?.profiles.append(card)
                }
                self?.fetchProfileCards(matchedUser)
                self?.setupScrollView(matchedUser.count)
                self?.setupPageControl(matchedUser.count)
                self?.layoutProfileCards()
            })
            .store(in: &cancellables)
    }
    
    /// 나와 매칭된 유저들의 ID로 프로필 조회
    private func fetchProfileForUser(id: Int) -> AnyPublisher<MatchedUser, Error> {
        // ID로 프로필을 가져오는 요청
        print("ID: \(id)")
        let endpoint = "/api/matchings/members/\(id)/profiles"
        return NetworkService.shared.getRequest(endpoint: endpoint)
            .eraseToAnyPublisher() // Publisher 변환
    }
    
    /// 더미 프로필 카드에 매칭된 유저들의 정보 패치
    private func fetchProfileCards(_ matchedUsers: [MatchedUser]) {
        for (index, user) in matchedUsers.enumerated() {
            if index < profiles.count {
                profiles[index].setup(user)  // 각 프로필 카드에 사용자 데이터 적용
//                print("\(user.nickname) 추가")
            }
        }
    }
    
    private func setupScrollView(_ numberOfCards: Int) {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        let totalContentWidth = (cardWidth + spacing) * CGFloat(numberOfCards) - spacing
        scrollView.contentSize = CGSize(width: totalContentWidth, height: cardHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.height.equalTo(cardHeight)
        }
    }
    
    private func setupPageControl(_ numberOfCards: Int) {
        pageControl.numberOfPages = numberOfCards
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func layoutProfileCards() {
        for (index, profile) in profiles.enumerated() {
            scrollView.addSubview(profile)
            
            profile.frame = CGRect(
                x: CGFloat(index) * (cardWidth + spacing),
                y: 0,
                width: cardWidth,
                height: cardHeight
            )
        }
    }
}

extension RecommendedMatesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = cardWidth + spacing
        let currentPage = round(scrollView.contentOffset.x / pageWidth)

        let targetOffsetX = currentPage * pageWidth - scrollView.contentInset.left
        scrollView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        
        pageControl.currentPage = Int(currentPage)
    }
}
