//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit

class registerPostViewController: UIViewController {
    
    @IBOutlet weak var dormitoryButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDormitoryButton()
        setCategoryButton()
    }
    
    func setDormitoryButton() {
        let a = UIAction(title: "양진재", handler: { _ in print("양진재") })
        let b = UIAction(title: "개척관", handler: { _ in print("개척관") })
        let c = UIAction(title: "계영원", handler: { _ in print("계영원") })
        let d = UIAction(title: "양성재", handler: { _ in print("양성재") })
        let e = UIAction(title: "행복관", handler: { _ in print("행복관") })
        self.dormitoryButton.menu = UIMenu(title: "", children: [a, b, c, d, e])
        self.dormitoryButton.showsMenuAsPrimaryAction = true
        self.dormitoryButton.changesSelectionAsPrimaryAction = true
    }
    
    
    func setCategoryButton() {
        let a = UIAction(title: "도와주세요", handler: { _ in print("도와주세요") })
        let b = UIAction(title: "살려주세요", handler: { _ in print("살려주세요") })
        let c = UIAction(title: "안녕하세요", handler: { _ in print("안녕하세요") })
        let d = UIAction(title: "삐리빠빠", handler: { _ in print("삐리빠빠") })
        let e = UIAction(title: "뿡빵뿡빵", handler: { _ in print("뿡빵뿡빵") })
        self.categoryButton.menu = UIMenu(title: "", children: [a, b, c, d, e])
        self.categoryButton.showsMenuAsPrimaryAction = true
        self.categoryButton.changesSelectionAsPrimaryAction = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
