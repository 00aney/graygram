//
//  PostEditorImageCell.swift
//  Graygram
//
//  Created by aney on 2017. 3. 19..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class PostEditorImageCell: UITableViewCell {
  
  // MARK: UI
  
  fileprivate let photoView = UIImageView()
  
  
  // MARK: Initializing
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.contentView.addSubview(self.photoView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Configuring
  
  func configure(image: UIImage) {
    self.photoView.image = image
  }
  
  
  // MARK: size
  
  class func height(width: CGFloat) -> CGFloat {
    return width // 정사각형
  }
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.photoView.frame = self.contentView.bounds
  }
}
