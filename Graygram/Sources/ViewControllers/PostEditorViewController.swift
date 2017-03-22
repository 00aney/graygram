//
//  PostEditorViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 19..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

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
    
    self.progressView.isHidden = false
    
    PostService.create(
      image: self.image,
      message: self.message,
      progress: { [weak self] progress in
        self?.progressView.progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
        // self에 대한 참조가 PostService에 대한 참조로 넘어간다 +1
        // 화면을 닫으면 -1이 되는데, 도중에 취소를 해버려도 +1
        // 해결방법 : 약한 참조 사용 [weak self] - - - - ->(o), -------->(x)
        // 레퍼런스 카운트가 증가되지 않는다.
        // 약한 참조를 쓰면, self가 에러가 난다. 왜냐하면
        // self: PostEditorViewController? 옵셔널이기 때문이다.
        // 화면이 닫혔을 경우 nil이 된다. self?로 고친다.
        // 클로저앞에 [ ] 를 캡쳐한다고 한다.
      },
      completion: { [weak self] response in
        guard let `self` = self else { return }   // ``백틱으로 self를 다시 정의 Strong Self
        switch response.result {
        case .success(let post):
          NotificationCenter.default.post(
            name: .postDidCreate,
            object: self,   // 이 경우는 옵셔널 체이닝을 사용할 수 없다. 그래서 Strong Self하게 만들어 준다.
            userInfo: ["post": post]
          )
          self.dismiss(animated: true, completion: nil)
          
        case .failure(let error):
          print("업로드 실패: \(error)")
        }
      }
    )
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
