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
    private var imageURL = [String]()
    private var imageNameIndex = -1
    
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
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           textView.isScrollEnabled = false
           textView.sizeToFit()
           textView.isScrollEnabled = true
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
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar("긱사생활")
        
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
    
    private func setTextField() {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/20"
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
        // 이미지 없다고 가정함 일단은.
        // TODO: 이미지와 태그는 UI 세팅 후에 다시 처리해야 함
        let post = Post(dormitoryType: dormitoryButton.title(for: .normal) ?? "",
                        boardType: categoryButton.title(for: .normal) ?? "",
                        title: textField.text ?? "",
                        content: textView.text ?? "",
                        tags: "#태그는 추후 구현!",
                        imagesUrls: [])
        
        let encoder = JSONEncoder()
        
//        let imagesData = convertImageToData()
//        let group = DispatchGroup()
//
//        for imageData in imagesData {
//            group.enter()
//            //멀티파트파일로 전환
//            let body = makeBody(imageData: imageData)
//            sendRequest(body: body) { url in
//                if let url = url {
//                    self.imageURL.append(url)
//                }
//                group.leave()
//            }
//        }
//
        if let jsonData = try? encoder.encode(post) {
            let url = URL(string: Url.articles)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
//            request.setValue("multipart/form-data; boundary=\(generateBoundaryString())", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let token = Token.shared.number
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    print("Response: \(String(describing: response))")
                    let decoder = JSONDecoder()
                    if let response = try? decoder.decode(PostResponse.self, from: data) {
                        print("Article ID: \(response.data.articleId)")
                    }
                }
            }
            
            task.resume()
        } else {
            print("글쓰기 실패")
        }
    }
    
    func sendRequest(body: Data, completion: @escaping (String?) -> Void) {
        let url = URL(string: Url.imageToUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let alert = UIAlertController(title: "오류가 발생하였습니다.", message: "다시 시도해주세요.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            
            if let error = error {
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    do {
                        let responseData = try JSONDecoder().decode(ResponseImageUrl.self, from: data ?? Data())
                        let imageUrl = responseData.data.imageUrl
                        completion(imageUrl)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                    
                } else {
                }
            }
        }.resume()
    }
    
    private func layoutPhotoScrollView() {
        self.view.addSubview(photoScrollView)
        photoScrollView.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(28)
            $0.leading.trailing.equalTo(textView)
            $0.height.equalTo(80)
        }
    }
    
    func cancelButtonTapped() {
        //TODO: post시 url관리 해야하는곳
        
    }
    
    private func makeBody(imageData: Data) -> Data? {
        //        let boundary = generateBoundaryString()
        //        var body = Data()
        //        let imgDataKey = "itemImages"
        //        let boundaryPrefix = "--\(boundary)\r\n"
        //        let boundarySuffix = "--\(boundary)--\r\n"
        //
        //        let imageName = "image\(imageNameIndex)"
        //        imageNameIndex -= 1
        //        body.append(Data(boundaryPrefix.utf8))
        //        body.append(Data("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(imageName).jpeg\"\r\n".utf8))
        //        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        //        body.append(imageData)
        //        body.append(Data("\r\n".utf8))
        //        body.append(Data(boundarySuffix.utf8))
        //        return body
        //    }
        return nil
    }
        
    
    //    private func generateBoundaryString() -> String {
    //        return "Boundary-\(UUID().uuidString)"
    //    }
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
    
    private func convertImageToData() -> [Data]{
        let group = DispatchGroup()
        var imagesData: [Data] = []
        
        for result in photoArray {
            group.enter()
            getImageData(from: result) { imageData in
                if let imageData = imageData {
                    imagesData.append(imageData)
                }
                group.leave()
            }
        }
        group.wait()
        return imagesData
    }
    
    func getImageData(from result: PHPickerResult, completion: @escaping (Data?) -> Void) {
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let image = image as? UIImage, let data = image.jpegData(compressionQuality: 0.8) {
                    // 이미지 데이터 반환
                    completion(data)
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
                            photoScrollView.addImage(image: image)
                            self.photoScrollView.countPictureLabel.text = "\(photoScrollView.addPhotoStackView.arrangedSubviews.count-1)/\(maximumPhotoNumber)"
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
        configuration.selectionLimit = maximumPhotoNumber-photoScrollView.addPhotoStackView.arrangedSubviews.count
        
        
        if photoArray.count == maximumPhotoNumber {
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

