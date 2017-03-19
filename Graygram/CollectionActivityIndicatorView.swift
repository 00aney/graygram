//
//  CollectionActivityIndicatorView.swift
//  Graygram
//
//  Created by aney on 2017. 2. 27..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class CollectionActivityIndicatorView: UICollectionReusableView {
	
	//MARK: UI
	fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
//		self.backgroundColor = .red
		self.addSubview(self.activityIndicatorView)
		self.activityIndicatorView.startAnimating()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.activityIndicatorView.centerX = self.width / 2
		self.activityIndicatorView.centerY = self.height / 2
	}
}
