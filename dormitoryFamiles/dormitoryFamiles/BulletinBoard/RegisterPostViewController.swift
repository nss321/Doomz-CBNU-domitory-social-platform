//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit
import DropDown
import PhotosUI

final class RegisterPostViewController: UIViewController, CancelButtonTappedDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    
    @IBOutlet weak var dormitoryLabel: UILabel!
    
    @IBOutlet weak var bulletinBoardLabel: UILabel!
    
    @IBOutlet weak var countTextFieldTextLabel: UILabel!
    
    @IBOutlet weak var countTextViewTextLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var descriptionStack: UIStackView!
    
    private let dropDown = DropDown()
    private let textFieldMaxLength = 20
    private let textViewMaxLength = 300
    private let photoScrollView = AddPhotoScrollView()
    private var photoArray = [PHPickerResult]()
    private let maximumPhotoNumber = 5
    private var imageUrl = [String]()
    private var uploadImages: [(id: Int, data: Data)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        AddImageBaseView.cancelButtonTappedDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDropDown()
        setDelegate()
        [dormitoryLabel, bulletinBoardLabel, countTextFieldTextLabel, titleLabel, descriptionLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
        setPHPPicker()
    }
    
    private func uploadSelectedImages() {
        for image in uploadImages {
            if let image = UIImage(data: image.data) {  // uploadImages 배열에서 data를 추출
                Network.multipartFilePostMethod(url: Url.postImage(), image: image) { (result: Result<ImageResponse, Error>) in
                    switch result {
                    case .success(let response):
                        self.imageUrl.append(response.data.imageUrl)
                    case .failure(let error):
                        print("Upload Error: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Error: 데이터를 이미지로 변경 불가")
            }
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setDelegate() {
        textField.delegate = self
        textView.delegate = self
    }
    
    private func setUI() {
        layoutPhotoScrollView()
        countTextViewTextLabel.textAlignment = .right
        countTextViewTextLabel.numberOfLines = 0 // 라인 수 제한을 해제
        countTextViewTextLabel.sizeToFit()
        
        //textViewPlaceHolder느낌
        textView.delegate = self
        if textView.text == "" {
            textView.textColor = .gray4
            textView.text = "내용을 입력해 주세요."
        }else {
            textView.textColor = .black
        }
    }
    
    private func setDropDown() {
        DropDown.startListeningToKeyboard()
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0
        DropDown.appearance().selectionBackgroundColor = .gray0 ?? .white
        DropDown.appearance().textFont = UIFont(name: CustomFonts.defult.rawValue, size: 16)!
        dropDown.cancelAction = { [self] in
            [dormitoryButton, categoryButton].forEach{$0?.borderColor = .gray1}
        }
        
    }
    
    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        switch sender {
        case dormitoryButton:
            dropDown.dataSource = ["본관", "양성재","양진재", "양현재"]
        case categoryButton:
            dropDown.dataSource = ["도와주세요", "함께해요", "나눔해요", "궁금해요"]
        default:
            dropDown.dataSource = []
        }
        
        //공통된 작업
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!-5))
        sender.borderColor = .primaryMid
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
            sender.borderColor = .gray1
        }
    }
    
    private func changeFinishButtonBackgroundColor() {
        if countTextViewTextLabel.text?.first == "0" || countTextFieldTextLabel.text?.first == "0" {
            finishButton.backgroundColor = .gray3
        }else{
            finishButton.backgroundColor = .primary
        }
        
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        let post = Post(dormitoryType: dormitoryButton.title(for: .normal) ?? "",
                        boardType: categoryButton.title(for: .normal) ?? "",
                        title: textField.text ?? "",
                        content: textView.text ?? "",
                        tags: "#태그는 추후 구현!",
                        imagesUrls: [])
        
        //이제 이미지 업로드 시작
        uploadImagesAndCreatePost(post: post)
    }
    
    private func uploadImagesAndCreatePost(post: Post) {
        let dispatchGroup = DispatchGroup()
        var uploadedImageUrls: [String] = []
        
        //dispatchGroup을 쓰는 이윤는, 이미지가 모두 url로 변경이 되고 난 뒤 다음 작업을 진행해야하기 때문에 (아니면 이미지 유실이 생겨버림)
        for imageData in uploadImages {
            dispatchGroup.enter()
            
            //멀티파트파일인 이미지 데이터 > url로 변경하는 api
            if let image = UIImage(data: imageData.data) {
                Network.multipartFilePostMethod(url: Url.postImage(), image: image) { (result: Result<ImageResponse, Error>) in
                    switch result {
                    case .success(let response):
                        uploadedImageUrls.append(response.data.imageUrl)
                    case .failure(let error):
                        print("이미지데이터 -> url변경 실패: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        //게시물 성공 알림을 추가하기 위해 메인큐 사용
        dispatchGroup.notify(queue: .main) {
            var updatedPost = post
            //셋팅했던 포스트 포맷에 추가되었던 url을 imageUrls로 초기화
            updatedPost.imagesUrls = uploadedImageUrls
            
            do {
                let jsonData = try JSONEncoder().encode(updatedPost)
                guard let request = Network.createRequest(
                    url: Url.articles,
                    token: Token.shared.number,
                    contentType: "application/json",
                    body: jsonData
                ) else {
                    print("리퀘스트 생성 오류")
                    return
                }
                
                Network.executeRequest(request: request) { (result: Result<PostResponse, Error>) in
                    switch result {
                    case .success(let response):
                        print("게시글 업로드 성공. 게시물Id: \(response.data.articleId)")
                    case .failure(let error):
                        print("게시글 업로드 실패: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("인코딩 에러: \(error.localizedDescription)")
            }
        }
    }
    
    private func layoutPhotoScrollView() {
        photoScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(photoScrollView)
        NSLayoutConstraint.activate([
            photoScrollView.topAnchor.constraint(equalTo: self.descriptionStack.bottomAnchor, constant: 18),
            photoScrollView.leadingAnchor.constraint(equalTo: self.descriptionStack.leadingAnchor),
            photoScrollView.trailingAnchor.constraint(equalTo: self.descriptionStack.trailingAnchor),
            photoScrollView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func cancelButtonTapped(id: Int) {
        if let index = uploadImages.firstIndex(where: { $0.id == id }) {
            uploadImages.remove(at: index)
            // Update UI by removing the corresponding view
            if let viewToRemove = photoScrollView.addPhotoStackView.arrangedSubviews.first(where: { ($0 as? AddImageBaseView)?.id == id }) {
                photoScrollView.addPhotoStackView.removeArrangedSubview(viewToRemove)
                viewToRemove.removeFromSuperview()
            }
        } else {
            print("Error: No image found with id \(id).")
        }
        updatePhotoButtonTitle()
    }
    
    private func updatePhotoButtonTitle() {
           let currentCount = photoScrollView.addPhotoStackView.arrangedSubviews.count - 2
           photoScrollView.addPhotoButton.setTitle("\(currentCount)/\(maximumPhotoNumber)", for: .normal)
       }
    
}



extension RegisterPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let addedText = string
        let newText = oldText + addedText
        let newTextLength = newText.count
        
        
        if newTextLength <= textFieldMaxLength {
            return true
        }
        
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)])
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) }
        let separatedCharactersCount = separatedCharacters.count
        
        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }
        
        if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        }
        
        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }
        
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/" + String(textFieldMaxLength)
        let text = textField.text ?? ""
        if text.count > textFieldMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textFieldMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
        changeFinishButtonBackgroundColor()
    }
    
    func getImageData(from result: PHPickerResult, completion: @escaping (Data?) -> Void) {
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    if let imageData = image.jpegData(compressionQuality: 0.1) {
                        completion(imageData)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
}

extension RegisterPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let oldText = textView.text ?? ""
        let addedText = text
        let newText = oldText + addedText
        let newTextLength = newText.count
        
        
        if newTextLength <= textViewMaxLength {
            return true
        }
        
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)])
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) }
        let separatedCharactersCount = separatedCharacters.count
        
        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }
        
        if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        }
        
        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }
        
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countTextViewTextLabel.text = String(textView.text!.count) + "/" + String(textViewMaxLength)
        let text = textView.text ?? ""
        if text.count > textViewMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textViewMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textView.text = fixedText
        }
        changeFinishButtonBackgroundColor()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray4 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .gray4
            textView.text = "내용을 입력해 주세요."
        }
    }
}

extension RegisterPostViewController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        let alert = UIAlertController(title: "확인", message: "진짜 뒤로 가시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
        return false
    }
}

//갤러리와 관련된 코드들 집합
extension RegisterPostViewController: PHPickerViewControllerDelegate  {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        for result in results {
                    let itemProvider = result.itemProvider
                    if let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                       let utType = UTType(typeIdentifier),
                       utType.conforms(to: .image) {
                        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                            if let image = image as? UIImage {
                                DispatchQueue.main.async { [self] in
                                    // 새로운 id를 생성하고 이미지 추가
                                    let newId = (uploadImages.last?.id ?? 0) + 1
                                    uploadImages.append((id: newId, data: image.jpegData(compressionQuality: 0.1)!))
                                    
                                    // photoScrollView에 이미지 추가
                                    photoScrollView.addImage(image: image, id: newId)
                                    updatePhotoButtonTitle()
                                }
                            }
                        }
                    }
                }
        
        photoArray.append(contentsOf: results)
        print(photoArray.count)
    }
    
    private func setPHPPicker() {
        photoScrollView.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func addPhotoButtonTapped() {
        //TODO: 버튼배경(?)을눌렀으시만(카메라뷰나 카운팅레이블을누르면 터치가안먹음) 반응이 되는데, 힛테스트 통해서 전체를 눌러도 가능하도록 수정조치 취해야함
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = maximumPhotoNumber-photoScrollView.addPhotoStackView.arrangedSubviews.count+2
        
        
        if uploadImages.count == maximumPhotoNumber {
            print("더이상 사진을 추가할 수 없습니다.")
        }else{
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            DispatchQueue.main.async {
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func pickerDidCancel(_ picker: PHPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension String {
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        
        let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
        
        return consonantScalarRange ~= scalar
    }
}
