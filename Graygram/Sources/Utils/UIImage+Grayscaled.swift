//
//  UIImage+Grayscaled.swift
//  Graygram
//
//  Created by aney on 2017. 3. 13..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

extension UIImage {
  
  //복사해서 리턴하는것은 grayscaled, 정렬된 녀석을 반환하는것은 grayscale로 네이밍 (cf. sorted(), sort())
  func grayscaled() -> UIImage? {
    // 1. CGContext 생성 (color space를 gray로 만듦)
    // 2. CGContext 에 명령 (self를 그려라)
    // 3. CGContext 로부터 이미지를 생성 (CGImage)
    // 4. CGImage -> UIImage로 반환
    // Core Graphic Context
    guard let context = CGContext.init(
      data: nil,
      width: Int(self.size.width),
      height: Int(self.size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: CGColorSpaceCreateDeviceGray(),
      bitmapInfo: .allZeros
    )
    else { return nil }
    
    // 2.
    guard let inputCGImage = self.cgImage else { return nil }
    let imageRect = CGRect(origin: .zero, size: self.size)
    context.draw(inputCGImage, in: imageRect)
    
    // 3.
    guard let outputCGImage = context.makeImage() else { return nil }
    
    // 4.
    return UIImage(cgImage: outputCGImage)
  }

}
