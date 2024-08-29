//
//  StudentCertificationViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/13/24.
//

import UIKit

class StudentCertificationViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var imageUrl: String?
    var activityIndicator: UIActivityIndicatorView! {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        return indicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
        } else {
            print("카메라를 사용할 수 없습니다.")
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("카메라를 사용할 수 없습니다.")
        }
    }
    
    private func uploadImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        // multipartFilePostMethod 호출
        Network.multipartFilePostMethod(url: Url.postImage(), image: image) { (result: Result<ImageResponse, Error>) in
            DispatchQueue.main.async {
                // 인디케이터 돌아가도록
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let response):
                self.imageUrl = response.data.imageUrl
                UserInformation.shared.setStudentCardImageUrl(url: self.imageUrl ?? "")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let profileFinishedVC = storyboard.instantiateViewController(withIdentifier: "ProfileFinishedViewController") as? ProfileFinishedViewController {
                        self.navigationController?.pushViewController(profileFinishedVC, animated: true)
                    }
                }
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
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

