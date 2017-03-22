//
//  PostEditorViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 19..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

import Alamofire

final class PostEditorViewController: UIViewController {

  // MARK: Properties
  
  fileprivate let image: UIImage
  fileprivate var message: String?
  
  
  // MARK UI
  
  fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
  fileprivate let progressView = UIProgressView(frame: .zero)
  
  
  // MARK: Initializing
  
  init(image: UIImage) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
    self.title = "New Post"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(cancelButtonDidTap)
    )
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonItemDidTap)
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(PostEditorImageCell.self, forCellReuseIdentifier: "imageCell")
    self.tableView.register(PostEditorMessageCell.self, forCellReuseIdentifier: "messageCell")
    
    self.progressView.isHidden = true
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.progressView)
    
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.progressView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrame),
      name: .UIKeyboardWillChangeFrame,
      object: nil
    )
  }
  
  
  // MARK: Notifications
  
  func keyboardWillChangeFrame(notification: Notification) {
    guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
      let duration =  notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
    else { return }
    
    let keyboardVisibleHeight = UIScreen.main.bounds.height - keyboardFrame.origin.y
    
    UIView.animate(withDuration: duration) {
      self.tableView.contentInset.bottom = keyboardVisibleHeight
      self.tableView.scrollIndicatorInsets.bottom = keyboardVisibleHeight
      
      // 키보드가 보여지는 경우 메시지 셀로 스크롤
      if keyboardVisibleHeight > 0 {
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
      }
    }
  }
  
  
  // MARK: Actions
  
  func cancelButtonDidTap() {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func doneButtonItemDidTap() {
    let urlString = "https://api.graygram.com/posts"
    let headers: HTTPHeaders = [
      "Accept": "application/json",
    ]
    
    self.progressView.isHidden = false
    
    Alamofire.upload(
      multipartFormData: { formData in
        if let imageData = UIImageJPEGRepresentation(self.image, 1) {
          formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
        }
        if let messageData = self.message?.data(using: .utf8) {
          formData.append(messageData, withName: "message")
        }
      },
      to: urlString,
      headers: headers,
      encodingCompletion: { result in
        switch result {
        case .success(let request, _, _):
          print("인코딩 성공")
          request // API 요청
            .uploadProgress { progress in
              print("\(progress.completedUnitCount) / \(progress.totalUnitCount)")
              self.progressView.progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
            }
            .validate(statusCode: 200..<400)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
              print("업로드 성공: \(value)")
              if let json = value as? [String: Any], let post = Post(JSON: json) {
                NotificationCenter.default.post(
                  name: .postDidCreate,
                  object: self,
                  userInfo: ["post": post]
                )
              }
              self.dismiss(animated: true, completion: nil)

            case .failure(let error):
              print("업로드 실패: \(error)")
              self.progressView.isHidden = true
              self.progressView.progress = 0
            }
          }
          
        case .failure(let error):
          print("인코딩 실패: \(error)")
          self.progressView.isHidden = true
          self.progressView.progress = 0
        }
      }
    )
    // multiPartFormData, multiFormData 찾아보기
  }
  
}


extension PostEditorViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! PostEditorImageCell
      cell.configure(image: self.image)
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! PostEditorMessageCell
      cell.configure(message: self.message)
      cell.textDidChange = { [weak self] message in
        guard let `self` = self else { return }
        self.message = message
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
      }
      return cell
      
    default:
      return UITableViewCell()
    }
  }
  
}


extension PostEditorViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return PostEditorImageCell.height(width: tableView.width)
      
    case 1:
      return PostEditorMessageCell.height(width: tableView.width, message: self.message)
      
    default:
      return 0
    }
  }
  
}