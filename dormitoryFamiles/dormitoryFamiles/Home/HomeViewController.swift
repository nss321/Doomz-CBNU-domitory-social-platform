//
//  homeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/14.
//

import UIKit
import SwiftSoup

final class HomeViewController: UIViewController, DormitoryButtonHandling {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var todayMenuLabel: UILabel!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    @IBOutlet weak var morningButton: RoundButton!
    
    @IBOutlet weak var lunchButton: RoundButton!
    
    @IBOutlet weak var eveningButton: RoundButton!
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    
    @IBOutlet weak var fBoardTypeLabel: RoundButton!
    @IBOutlet weak var fTitleLabel: UIButton!
    @IBOutlet weak var fCreatedAtLabel: UILabel!
    
    @IBOutlet weak var sBoardTypeLabel: RoundButton!
    @IBOutlet weak var sTitleLabel: UIButton!
    @IBOutlet weak var sCreatedAtLabel: UILabel!
    
    @IBOutlet weak var tBoardTypeLabel: RoundButton!
    @IBOutlet weak var tTitleLabel: UIButton!
    @IBOutlet weak var tCreatedAtLabel: UILabel!
    
    @IBOutlet weak var fGoDetailButton: UIButton!
    
    @IBOutlet weak var sGoDetailButton: UIButton!
    
    @IBOutlet weak var tGoDetailButton: UIButton!
    
    var myTabBarController: UITabBarController?
    
    
    private var todayString: String {
        get {
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateFormat = "yyyy-MM-dd"
            return dateFormmatter.string(from: Date())
        }
    }
    
    private var isWeekend: Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: currentDate)
        
        if let weekday = components.weekday {
            return (weekday == 1 || weekday == 7)
        }
        
        // weekday 값이 nil일 경우 기본값으로 false 반환
        return false
    }
    
    private let site = ["본관": "https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=1", "양성재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=2", "양진재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=3"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabber()
        setObserver()
        setLabelAndButton()
        setDormitoryButton()
        
        let stackViewBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -16)
        stackViewBottomConstraint.isActive = true
        
        setTintAdjustmentModeForButtons(in: self.view)
        dormitoryButton.head1 = SelectedDormitory.shared.domitory
        dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
        fetchWebsite(time: .morning)
        
        popularPost()
    }
    
    private func setTabber() {
        if let tabBarController = self.tabBarController as? UITabBarController {
            self.myTabBarController = tabBarController
        }
    }
    
    //기숙사 시트의 버튼이 눌려지면(기숙사가 선택되면) 그 title을 버튼의 title과 일치시키는 함수
    @objc func dormitoryChangeNotification(_ notification: Notification) {
        if notification.object is String {
            dormitoryButton.head1 = SelectedDormitory.shared.domitory
            dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
        }
        
        //홈이라 메뉴 세팅도 다시 해줘야 함.
        //아침메뉴받아오는거
        fetchWebsite(time: .morning)
        //UI 아침으로 세팅
        [lunchButton, eveningButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        morningButton.backgroundColor = .white
        morningButton.tintColor = .primary
    }
    
    //시트를 동작하였을때 버튼의 컬러가 변하지 않게 하는 함수
    private func setTintAdjustmentModeForButtons(in view: UIView) {
        //받아온 뷰를 돌며 타입이 버튼이거나 버튼을 상속받은 엘리먼트들만
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.tintAdjustmentMode = .normal
            }
            //버튼이 아니라면 그 내부를 또 탐색
            setTintAdjustmentModeForButtons(in: subview)
        }
    }
    
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dormitoryChangeNotification(_:)), name: .init("DormitoryChangeNotification"), object: nil)
    }
    
    
    private func setLabelAndButton() {
        self.menuLabel.sizeToFit()
        self.menuLabel.lineSpacing(12)
        self.menuLabel.textAlignment = .center
        morningButton.setTitle("아침", for: .normal)
        lunchButton.setTitle("점심", for: .normal)
        eveningButton.setTitle("저녁", for: .normal)
        dormitoryButton.setTitle("양진재", for: .normal)
    }
    
    
    private func setDormitoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .init(4)
        dormitoryButton.configuration = configuration
        dormitoryButton?.tintAdjustmentMode = .normal
        dormitoryButton.head1 = SelectedDormitory.shared.domitory
    }
    
    
    
    @IBAction func menuButtonTapped(_ sender: RoundButton) {
        
        [morningButton, lunchButton, eveningButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        sender.backgroundColor = .white
        sender.tintColor = .primary
        
        
        let mealTimeMapping = ["아침": "morning", "점심": "lunch", "저녁": "evening"]
        if let title = sender.currentTitle, let mappedTitle = mealTimeMapping[title], let time = MealTime(rawValue: mappedTitle) {
            self.fetchWebsite(time: time)
            
        }
    }
    
    
    @IBAction func alarmButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(AlarmViewController(), animated: true)
    }
    
    
    @IBAction func dormitoryButtonTapped(_ sender: DormitoryButton) {
        presentSheet()
    }
    
    private func fetchWebsite(time: MealTime) {
        if !isWeekend {
            //평일
            if time == .morning {
                timeLabel.body2 = "운영시간 7:20 ~ 09:00"
            }else if time == .lunch {
                timeLabel.body2 = "운영시간 11:30 ~ 13:30"
            }else if time == .evening {
                timeLabel.body2 = "운영시간 17:30 ~ 19:10"
            }
        }else {
            //주말
            if time == .morning {
                timeLabel.body2 = "운영시간 8:00 ~ 09:00"
            }else if time == .lunch {
                timeLabel.body2 = "운영시간 12:00 ~ 13:00"
            }else if time == .evening {
                timeLabel.body2 = "운영시간 17:30 ~ 19:00"
            }
        }
        
        guard let url = URL(string: site[dormitoryButton.currentTitle!]!) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let html = String(data: data, encoding: .utf8)!
                self.parseHTML(html: html, for: self.todayString, time: time)
            }
        }
        task.resume()
    }
    
    private func parseHTML(html: String, for date: String, time: MealTime) {
        let mealTimeString = time.rawValue
        do {
            let document = try SwiftSoup.parse(html)
            if let element = try document.select("tr#\(date)").first() {
                let menu = try element.select("td.\(mealTimeString)").first()?.html().replacingOccurrences(of: "<br />", with: "\n").replacingOccurrences(of: "amp;", with: "")
                
                var kcal = ""
                //칼로리의 값을 얻기 위한 정규표현식 사용
                //(\\d+)는 숫자형식이 들어온다는것,\\s*Kcal는 Kcal앞에 공백이 있을수도 없을수도 있다는 뜻
                let regex = try! NSRegularExpression(pattern: "(\\d+)\\s*Kcal", options: [.caseInsensitive])
                let range = NSRange(location: 0, length: menu?.utf16.count ?? 0)
                if let match = regex.firstMatch(in: menu ?? "", options: [], range: range) {
                    if let energyRange = Range(match.range(at: 1), in: menu ?? "") {
                        kcal = String(menu?[energyRange] ?? "")
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    if menu == "\n" {
                        self.menuLabel.text = "긱식 정보 없음"
                        self.kcalLabel.text = ""
                    }else {
                        self.menuLabel.text = cutKcalLine(str: menu)
                        self.kcalLabel.text = "총 칼로리 \(kcal)kcal"
                    }
                }
            }else {
                DispatchQueue.main.async { [self] in
                    self.menuLabel.text = "긱식 정보 없음"
                    self.kcalLabel.text = ""
                }
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    //메뉴에 칼로리 부터 이후 줄 없앰
    private func cutKcalLine(str: String?) -> String {
        var lines = str?.components(separatedBy: "\n")
        // 칼로리의 인덱스 찾기
        if let index = lines?.firstIndex(where: { $0.contains("Kcal") || $0.contains("kcal") }) {
            lines = Array((lines?[0..<index])!)
        }
        return lines?.joined(separator: "\n") ?? ""
    }
    
    @IBAction func bulletinBoardButtonTapped(_ sender: UIButton) {
        self.myTabBarController?.selectedIndex = 1
    }
    
    @IBAction func roomateButtonTapped(_ sender: UIButton) {
        self.myTabBarController?.selectedIndex = 3
    }
    
    private func popularPost() {
        let url = Url.popular(dormitoryType: SelectedDormitory.shared.domitory)
        print(url)
        Network.getMethod(url: url) { [self] (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                let newArticles = response.data.articles
                let popularBoard = [fBoardTypeLabel, sBoardTypeLabel, tBoardTypeLabel]
                let popularTitle = [fTitleLabel, sTitleLabel, tTitleLabel]
                let popularCreatedAt = [fCreatedAtLabel, sCreatedAtLabel, tCreatedAtLabel]
                let popularGoDetail = [fGoDetailButton, sGoDetailButton, tGoDetailButton]
                DispatchQueue.main.async {
                    for index in 0..<3 {
                        popularBoard[index]?.body2 = newArticles[index].boardType
                        popularTitle[index]?.body2 = newArticles[index].title
                        popularCreatedAt[index]?.pretendardVariable = DateUtility.yymmdd(from: newArticles[index].createdAt, separator: ".")
                        popularGoDetail[index]?.tag = newArticles[index].articleId
                        
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    @IBAction func goDetailButtonTapped(_ sender: UIButton) {
        let articleId = sender.tag
        print(articleId)
        
        let url = "http://43.202.254.127:8080/api/articles/\(articleId)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let articleDetailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as? BulletinBoardDetailViewViewController {
                articleDetailViewController.setUrl(url: url)
                self.navigationController?.pushViewController(articleDetailViewController, animated: true)
            }
        
    }
    
}

enum MealTime:String, CaseIterable {
    case morning = "morning"
    case lunch = "lunch"
    case evening = "evening"
}

