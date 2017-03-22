//
//  PostTileCell.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class PostTileCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(post: Post) {
    // TODO: 구현
  }
  
  class func size(width: CGFloat, post: Post) -> CGSize {
    // TODO: 구현하기
    return CGSize(width: 0, height: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    // TODO: photoView가 꽉차도록 구현하기
    
  }
  
}
