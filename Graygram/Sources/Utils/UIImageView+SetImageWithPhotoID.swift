//
//  UIImageView+SetImageWithPhotoID.swift
//  Graygram
//
//  Created by aney on 2017. 2. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

extension UIImageView {
	
	/// photoID를 사용해서 이미지를 설정합니다.
	///
	/// - parameter photoID: Photo ID
	func setImage(with photoID: String?) {
		if let photoID = photoID {
			let url = URL(string: "https://www.graygram.com/photos/\(photoID)/600x600")
			self.kf.setImage(with: url)
		} else {
			self.kf.setImage(with: nil)
		}
	}
	
	/*
	self.photoView.setImage(with: photo.photoID)
	*/
	
}
