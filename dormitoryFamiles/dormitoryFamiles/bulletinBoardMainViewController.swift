//
//  bulletinBoardMainViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/01.
//

import UIKit

class BulletinBoardMainViewController: UIViewController {
    let cellIdentifier = "BulletinBoardMainTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setTableViewCell()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setTableViewCell() {
        tableView.dataSource = self
               let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
}

extension BulletinBoardMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
}

