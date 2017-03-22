//
//  PostViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
  
  // MARK: Properties
  
  fileprivate let post: Post
  
  
  // MARK: UI
  
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  
  // MARK: Initializing
  
  init(post: Post) {
    self.post = post
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}


// MARK: - UICollectionViewDataSource

extension PostViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCardCell", for: indexPath)
      as! PostCardCell
    cell.configure(post: self.post, isMessageTrimmed: false)
    return cell
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PostViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return PostCardCell.size(width: collectionView.width, post: self.post, isMessageTrimmed: false)
  }
  
}
