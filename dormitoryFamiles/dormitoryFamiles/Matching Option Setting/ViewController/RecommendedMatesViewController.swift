//
//  RecommendedMatesViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/22/24.
//

import UIKit
import SnapKit
import Combine

final class RecommendedMatesViewController: UIViewController, ConfigUI {
    
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
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let didntSetupLifeStyleAlert = didntSetupLifeStyleView()
    
    private let dim: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .gray3!, height: 52) {
        // self.didClickNextButton()
    }
    
    private lazy var typePreferredButtonModel = CommonbuttonModel(title: "선호 룸메 정보 입력하기 >", titleColor: .white ,backgroundColor: .primary!, height: 48) {
        self.navigationController?.pushViewController(SleepPatternViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("추천 룸메")
        dim.isHidden = true
        didntSetupLifeStyleAlert.isHidden = true
        didntSetupLifeStyleAlert.typePreferredButton.setup(model: typePreferredButtonModel)
        
        setUI()
        fetchMyLifeStyle()
    }
    
    private func setUI() {
        addComponents()
        setConstraints()
        fetchTitleLabel()
        fetchUserProfile()
    }
    
    func addComponents() {
        view.addSubview(titleLabel)
        view.addSubview(userInfoLabel)
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
        
        userInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func fetchTitleLabel() {
        let endpoint = Url.getMyProfile()
        NetworkService.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
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
    
    private func fetchUserProfile() {
        let endpoint = Url.getMyProfile()
        NetworkService.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched user profile.")
                case .failure(let error):
                    print("Failed to fetch user profile: \(error)")
                }
            }, receiveValue: { [weak self] (userProfile: UserProfileData) in
                self?.displayUserInfo(userProfile)
            })
            .store(in: &cancellables)
    }
    
    private func fetchMyLifeStyle() {
        let endpoint = Url.lifeStyles()
        NetworkService.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { (compeltion: Subscribers.Completion<Error>) in
                switch compeltion {
                case .finished:
                    print("Successfully fetched user profile.")
                case .failure(let error):
                    print("Failed to fetch user profile: \(error)")
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
            } receiveValue: { (lifestyle: LifeStyleData) in
                print("lifeStyle \(lifestyle)")
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
    
    private func displayUserInfo(_ profile: UserProfileData) {
        userInfoLabel.text = """
        이름: \(profile.name)
        닉네임: \(profile.nickname)
        성별: \(profile.genderType)
        생일: \(profile.birthDate)
        학과: \(profile.departmentType)
        기숙사: \(profile.memberDormitoryType)
        """
    }
}


final class didntSetupLifeStyleView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
//        typePreferredButton.setup(model: typePreferredButtonModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 32
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray0?.cgColor
        
        [logo, titleLabel, contentLabel, typePreferredButton].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    private let logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "completeMyCondition_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " 아직 룸메 정보 설정을\n입력하지 않았어요!"
        label.font = FontManager.head1()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "룸메 매칭을 설정하면 둠즈가\n원하는 룸메를 추천해드려요!"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    let typePreferredButton = CommonButton()
    
    private func setConstraints() {
        logo.snp.makeConstraints {
            $0.width.equalTo(Double(UIScreen.currentScreenWidth) * 0.57)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(12)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        typePreferredButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
}
