//
//  CompleteMyCondition.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/9/24.
//

import UIKit
import SnapKit
import Combine

final class CompleteMyCondition: UIViewController, ConfigUI {
    
    private let completeMyConditionLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "completeMyCondition_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 긱사생활 입력이 완료되었어요."
        label.font = FontManager.body3()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 룸메정보를 설정해봐요!"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 긱사생활 변경을 '마이페이지'에서 가능해요."
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "선호 룸메 우선순위 설정", titleColor: .white ,backgroundColor: .primary!, height: 52) {
        self.didClickNextButton()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("긱사생활 설정")
        addComponents()
        setConstraints()
        nextButton.setup(model: nextButtonModel)
    }
    
    func addComponents() {
        [firstLabel, secondLabel, thirdLabel, completeMyConditionLogo, nextButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(172)
            $0.centerX.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()

        }
        
        thirdLabel.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()

        }
        
        completeMyConditionLogo.snp.makeConstraints {
            $0.top.equalTo(thirdLabel.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    @objc
    func didClickNextButton() {
        print("nextBtn")
        self.postLifeStyleData()
        self.navigationController?.pushViewController(ChoosePriorityViewController(), animated: true)
    }
    
    private func getMyMatchingOptions() {
        let lifeStyleData = LifeStyleData(
            sleepTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedBedTimes") ?? "",
            wakeUpTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedWakeupTimes") ?? "",
            sleepingHabit: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedHabits") ?? "",
            sleepingSensitivity: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedSensitivity") ?? "",
            smoking: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedSmoke") ?? "",
            drinkingFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedAlcohol") ?? "",
            drunkHabit: UserDefaults.standard.getMatchingOptionValue(forKey: "drinkHabitText") ?? "",
            showerTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedShower") ?? "",
            showerDuration: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedShower") ?? "",
            cleaningFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCleanHabit") ?? "",
            heatTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedHot") ?? "",
            coldTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCold") ?? "",
            MBTI: "\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedEnergyOrientation") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedInformationProcessing") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedDecisionMaking") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedLifestyleApproach") ?? "")",
            visitHomeFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCycle") ?? "",
            lateNightSnack: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedMidnightSnack") ?? "",
            snackInRoom: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedEatingFoodInRoom") ?? "",
            phoneSound: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedNoise") ?? "",
            perfumeUsage: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedPerfume") ?? "",
            studyLocation: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedStudyPlace") ?? "",
            examPreparation: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedExam") ?? "",
            exercise: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedWorkout") ?? "",
            insectTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedBugs") ?? ""
        )
        
        print(lifeStyleData)
    }
    
    private func postLifeStyleData() {
        let endpoint = Url.lifeStyles()
        let lifeStyleData = createLifeStyleData()
        
        NetworkService.shared.postRequest(endpoint: endpoint, body: lifeStyleData)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully submitted lifestyle data.")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { (response: SuccessCode) in
                print(response)
            }
            .store(in: &cancellables)
        
        
    }
    
    private func createLifeStyleData() -> LifeStyleData {
        return LifeStyleData(
            sleepTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedBedTimes") ?? "",
            wakeUpTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedWakeupTimes") ?? "",
            sleepingHabit: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedHabits") ?? "",
            sleepingSensitivity: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedSensitivity") ?? "",
            smoking: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedSmoke") ?? "",
            drinkingFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedAlcohol") ?? "",
            drunkHabit: UserDefaults.standard.getMatchingOptionValue(forKey: "drinkHabitText") ?? "",
            showerTime: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedShower") ?? "",
            showerDuration: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedShower") ?? "",
            cleaningFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCleanHabit") ?? "",
            heatTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedHot") ?? "",
            coldTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCold") ?? "",
            MBTI: "\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedEnergyOrientation") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedInformationProcessing") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedDecisionMaking") ?? "")\(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedLifestyleApproach") ?? "")",
            visitHomeFrequency: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCycle") ?? "",
            lateNightSnack: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedMidnightSnack") ?? "",
            snackInRoom: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedEatingFoodInRoom") ?? "",
            phoneSound: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedNoise") ?? "",
            perfumeUsage: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedPerfume") ?? "",
            studyLocation: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedStudyPlace") ?? "",
            examPreparation: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedExam") ?? "",
            exercise: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedWorkout") ?? "",
            insectTolerance: UserDefaults.standard.getMatchingOptionValue(forKey: "selectedBugs") ?? ""
        )
    }

}
