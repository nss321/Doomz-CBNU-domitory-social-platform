//
//  MealOfWeekViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/06/19.
//

import UIKit
import SwiftSoup

final class MealOfWeekViewController: UIViewController {

    var date = ""
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var morningButton: RoundButton!
    
    @IBOutlet weak var lunchButton: RoundButton!
    
    @IBOutlet weak var eveningButton: RoundButton!
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    
    private var todayString: String {
        get {
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateFormat = "yyyy-MM-dd"
            return dateFormmatter.string(from: Date())
        }
    }
    
    private let site = ["본관": "https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=1", "양성재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=2", "양진재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserver()
        self.menuLabel.sizeToFit()
        self.menuLabel.lineSpacing(12)
        self.menuLabel.textAlignment = .center
        setLabelAndButton()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTintAdjustmentModeForButtons(in: self.view)
        fetchWebsite(time: .morning)
    }
    
    
    //기숙사 시트의 버튼이 눌려지면(기숙사가 선택되면) 그 title을 버튼의 title과 일치시키는 함수
    @objc func dormitoryChangeNotification(_ notification: Notification) {

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
        morningButton.setTitle("아침", for: .normal)
        lunchButton.setTitle("점심", for: .normal)
        eveningButton.setTitle("저녁", for: .normal)
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
    
    
    

    
    private func fetchWebsite(time: MealTime) {
        guard SelectedDormitory.shared.domitory != "양현재" else {
            return
        }
        
        guard let url = URL(string: site[SelectedDormitory.shared.domitory]!) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let html = String(data: data, encoding: .utf8)!
                self.parseHTML(html: html, for: self.date, time: time)
            }
        }
        task.resume()
    }
    
    private func parseHTML(html: String, for date: String, time: MealTime) {
        let mealTimeString = time.rawValue
        do {
            let document = try SwiftSoup.parse(html)
            if let element = try document.select("tr#\(date)").first() {
                var menu = try element.select("td.\(mealTimeString)").first()?.html().replacingOccurrences(of: "<br />", with: "\n").replacingOccurrences(of: "amp;", with: "")
                
                var kcal = ""
                //칼로리의 값을 얻기 위한 정규표현식 사용
                //(\\d+)는 숫자형식이 들어온다는것,\\s*Kcal는 Kcal앞에 공백이 있을수도 없을수도 있다는 뜻
                var regex = try! NSRegularExpression(pattern: "(\\d+)\\s*Kcal", options: [.caseInsensitive])
                var range = NSRange(location: 0, length: menu?.utf16.count ?? 0)
                if let match = regex.firstMatch(in: menu ?? "", options: [], range: range) {
                    if let energyRange = Range(match.range(at: 1), in: menu ?? "") {
                        kcal = String(menu?[energyRange] ?? "")
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    self.menuLabel.text = cutKcalLine(str: menu)
                    self.kcalLabel.text = "총 칼로리 \(kcal)kcal"
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

}
