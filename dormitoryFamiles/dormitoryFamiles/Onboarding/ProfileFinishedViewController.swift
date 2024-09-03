//
//  ProfileFinishedViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import UIKit

final class ProfileFinishedViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.textAlignment = .center
        putInformation()
    }
    
    private func putInformation() {
        let info = UserInformation.shared
           let requestBody: [String: Any] = [
            "nickname": info.getNickname(),
            "studentCardImageUrl": info.getStudentCardImageUrl(),
            "collegeType": info.getCollegeType(),
            "departmentType": info.getDepartmentType(),
            "studentNumber": info.getStudentNumber(),
            "dormitoryType": info.getDormitoryType()
           ]
           
        print(requestBody)
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
               Network.putMethod(url: Url.setProfile(), body: jsonData) { (result: Result<CodeResponse, Error>) in
                   switch result {
                   case .success(let successCode):
                       print("PUT 성공: \(successCode)")
                   case .failure(let error):
                       print("Error: \(error)")
                   }
               }
           } catch {
               print("JSON 변환 에러: \(error)")
           }
    }
   
}
