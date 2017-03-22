//
//  PostViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
  
  fileprivate let post: Post
  fileprivate let collectionView = UICollectionView()
  
  init(post: Post) {
    self.post = post
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 미션: 콜렉션 뷰에 PostCardCell이 보이게 해보세요.
    // 힌트:
    //  1. 콜렉션 뷰가 화면에 보이도록 함.
    //  2. DataSource에서 아이템 개수와 셀 인스턴스 반환
    //  3. Delegate에서 셀 크기 반환
    
  }
  
}
