//
//  PostViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

import URLNavigator

final class PostViewController: UIViewController {
  
  // MARK: Properties
  fileprivate let postID: Int
  fileprivate var post: Post?
  
  
  // MARK: UI
  
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  fileprivate let activityIndicatorView = UIActivityIndicatorView(
    activityIndicatorStyle: .gray
  )
  
  
  // MARK: Initializing
  
  init(postID: Int, post: Post?) {  // post ID 만 있어도 접근가능하도록 처리(커스텀 스킴)
    self.postID = postID
    self.post = post
    super.init(nibName: nil, bundle: nil)
    // post를 갱신
    self.fetchPost()
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
    
    // 미션: 콜렉션 뷰에 PostCardCell이 보이게 해보세요.
    // 힌트:
    //  1. 콜렉션 뷰가 화면에 보이도록 함.
    //  2. DataSource에서 아이템 개수와 셀 인스턴스 반환
    //  3. Delegate에서 셀 크기 반환
    self.collectionView.backgroundColor = .white
    self.collectionView.alwaysBounceVertical = true
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.register(PostCardCell.self, forCellWithReuseIdentifier: "postCardCell")
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.activityIndicatorView)
    
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    // 1. Post 에 좋아요가 표시/취소된 경우 콜렉션 뷰 업데이트
    
    NotificationCenter.default.addObserver(
      self, 
      selector: #selector(postDidLike), 
      name: .postDidLike, 
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(postDidUnlike),
      name: .postDidUnlike,
      object: nil
    )
    
  }
  
  
  // MARK: Notifications
  
  func postDidLike(notification: Notification) {
    guard var post = self.post else { return }  //post 가 옵셔널이기 때문
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    guard post.id == postID else { return }
    post.isLiked = true
    post.likeCount? += 1
    self.post = post
    self.collectionView.reloadData()
  }
  
  func postDidUnlike(notification: Notification) {
    guard var post = self.post else { return }  //post 가 옵셔널이기 때문
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    guard post.id == postID else { return }
    post.isLiked = false
    post.likeCount? -= 1
    self.post = post
    self.collectionView.reloadData()
  }
  //커스텀 스킴, 딥링크
  //앱에서 보기
  //자바스크립트가 앱에 등록된 커스텀 스킴을 호출시킨다.
  //자바스크립트에서 로케이션을 변경시키면, ex) graygram://-
  //iOS 자체에서 graygram:// 으로 등록된 앱을 찾아서 실행시켜준다.
  //1. 커스텀 스킨 등록 graygram://
  //2. graygram://post/3  : 포스트 3번화면으로 보낸다.
  //프로젝트 세팅 , 타겟 > 인포 탭 > URL타입스 > add items
  //사파리에서 등록한 스킴을 주소창에 치면, 얼럿이 뜬다. 오픈을 누르면 그레이그램이 실행된다.
  //
  
  func fetchPost() {
    self.activityIndicatorView.startAnimating()
    
    PostService.post(id: self.postID) { [weak self] response in  // 클로저 안에 self는 옵셔널로 바뀜
      guard let `self` = self else { return }
      self.activityIndicatorView.stopAnimating()
      
      switch response.result {
      case .success(let post):
        self.post = post
        self.collectionView.reloadData()
        
      case .failure(let error):
        print("Post 요청 실패 \(error)")
      }
    }
  }
  
}


// MARK: - URLNavigable

extension PostViewController: URLNavigable {
  
  // URLNavigationMap 
  convenience init?(
    url: URLConvertible,    // grgm://post/3
    values: [String : Any], // ["id": "3"]
    userInfo: [AnyHashable : Any]?
  ) {
    guard let postID = values["id"] as? Int else { return nil }
    self.init(postID: postID, post: nil)  // convenience init에서는 designated 생성자 반드시 호출
  }
  
}

// MARK: - UICollectionViewDataSource

extension PostViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.post == nil {
      return 0
    } else {
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // TODO: self.post 가 nil 일 때 빈셀 반환하도록 처리해보기
    //    guard let ...{ return emptyCell}
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCardCell", for: indexPath)
      as! PostCardCell
    cell.configure(post: self.post!, isMessageTrimmed: false)
    return cell
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PostViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // TODO: post 가 닐인경우 size 0를 반환하게 바꿔보기
    return PostCardCell.size(width: collectionView.width, post: self.post!, isMessageTrimmed: false)
  }
  
}
