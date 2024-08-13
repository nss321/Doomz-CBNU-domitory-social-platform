//
//  StudentCertificationViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/13/24.
//

import UIKit

class StudentCertificationViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadImage(_ image: UIImage) {
      
        //이미지 로드가 끝나면 화면 전환
        self.navigationController?.pushViewController(ProfileFinishedViewController(), animated: true)
    }
}

extension StudentCertificationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension StudentCertificationViewController: UINavigationControllerDelegate {
    
}
