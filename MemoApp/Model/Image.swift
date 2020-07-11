//
//  Image.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public struct Image {
  var image: UIImage
  var date: Date
}

extension Image {
  public init() {
    image = UIImage()
    date = Date()
  }
}
