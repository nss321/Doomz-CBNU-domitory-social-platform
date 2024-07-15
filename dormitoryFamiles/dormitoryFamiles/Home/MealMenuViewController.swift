//
//  ViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import Tabman
import Pageboy
import UIKit

final class MealMenuViewController: TabmanViewController {
 
    @IBOutlet weak var weekDateLabel: UILabel!
    @IBOutlet weak var tabmanView: UIView!
    
    private var year: String {
        get{
            let today = Date()
            let calendar = Calendar.current
            return String(calendar.component(.year, from: today))

        }
    }
    
    //year가 초기화 된 후 세팅이 되야함으로 lazy
    private lazy var mondayDate = year+"-"+DateUtility.weekRangeString(seperator: "-")[0]
    
    private var viewControllers: [MealOfWeekViewController] {
        let mondayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        mondayVC.date = mondayDate
        let tuesdayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        tuesdayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 1) ?? ""
        let wednesdayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        wednesdayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 2) ?? ""
        let thursdayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        thursdayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 3) ?? ""
        let fridayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        fridayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 4) ?? ""
        let saturdayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        saturdayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 5) ?? ""
        saturdayVC.isWeekend = true
        let sundayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mealOfWeekViewController") as! MealOfWeekViewController
        sundayVC.date = DateUtility.addDaysToDate(dateString: mondayDate, daysToAdd: 6) ?? ""
        sundayVC.isWeekend = true
        return [mondayVC, tuesdayVC, wednesdayVC, thursdayVC, fridayVC, saturdayVC, sundayVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        let dateArr = DateUtility.weekRangeString(seperator: ".")
        weekDateLabel.button = dateArr[0]+"~"+dateArr[1]
        setTabman()
    }
    
    private func setNavi() {
        self.title = "\(SelectedDormitory.shared.domitory) 메뉴"
        if let navigationController = self.navigationController {
                let navBarAppearance = navigationController.navigationBar
                navBarAppearance.titleTextAttributes = [
                    NSAttributedString.Key.font: UIFont.head1
                ]
            }
    }
   
    private func setTabman() {
        self.dataSource = self
        // 바 세팅
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        bar.buttons.customize { (button) in
            button.tintColor = .gray3 // 선택 안되어 있을 때
            button.selectedTintColor = .primary // 선택 되어 있을 때
            button.font = .body1!
            button.selectedFont = .title5!
            button.sizeToFit()
                    
                    // 강제로 버튼의 넓이를 30으로 설정
                    button.snp.makeConstraints { make in
                        make.width.equalTo(30)
                    }
        }
        
        //인디케이터 세팅
        bar.indicator.weight = .light
        bar.indicator.tintColor = .primary
        bar.layout.alignment = .centerDistributed
        
        bar.layout.interButtonSpacing = 15 // 버튼 사이 간격
        bar.layout.transitionStyle = .progressive// Customize
        
       
        addBar(bar, dataSource: dataSource as! TMBarDataSource, at: .custom(view: tabmanView, layout: nil))
    }
   
}

extension MealMenuViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //        let item = TMBarItem(title: "")
        //        item.title = "Page \(index)"
        //        item.image = UIImage(named: "image.png")
        //
        //        return item
        
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "월")
        case 1:
            return TMBarItem(title: "화")
        case 2:
            return TMBarItem(title: "수")
        case 3:
            return TMBarItem(title: "목")
        case 4:
            return TMBarItem(title: "금")
        case 5:
            return TMBarItem(title: "토")
        case 6:
            return TMBarItem(title: "일")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
}
