//
//  URLNavigationMap.swift
//  Graygram
//
//  Created by aney on 2017. 3. 27..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import URLNavigator

struct URLNavigationMap {
  
  static func initialize() {
    // Python Flask 와 URL 패턴 동일
     Navigator.map("grgm://post/<int:id>", PostViewController.self)
  }

    /*
     Navigator.push("grgm://post/3")
     Navigator.present("grgm://post/3")
    */
  
}
