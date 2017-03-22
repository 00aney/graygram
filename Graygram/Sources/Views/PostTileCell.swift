//
//  PostTileCell.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class PostTileCell: UICollectionViewCell {
  
  fileprivate let photoView = UIImageView(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.photoView.backgroundColor = .lightGray
    self.contentView.addSubview(self.photoView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(post: Post) {
    self.photoView.setImage(with: post.photoID)
  }
  
  class func size(width: CGFloat, post: Post) -> CGSize {
    return CGSize(width: width, height: width)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.photoView.frame = self.contentView.bounds
//    self.photoView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: self.contentView.height)
  }
  
}
