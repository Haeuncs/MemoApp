//
//  ImageCollectionCell.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class ImageCollectionCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
  }
    
  func initView() {
    self.addSubview(photoImage)
    photoImage.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
    }
  }
  
  lazy var photoImage: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .black
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()
}
