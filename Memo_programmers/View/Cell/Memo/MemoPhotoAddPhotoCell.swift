//
//  MemoPhotoAddPhotoCell.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class MemoPhotoAddPhotoCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(baseView)
    self.addSubview(stackView)
    
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(self).offset(10)
      make.leading.equalTo(self).offset(6)
      make.trailing.equalTo(self).offset(-10)
      make.bottom.equalTo(self).offset(-6)
    }
    stackView.snp.makeConstraints { (make) in
      make.center.equalTo(baseView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 18
    view.layer.borderColor = UIColor.memo_black.cgColor
    view.layer.borderWidth = 1
    return view
  }()
    lazy var stackView: UIStackView = {
      let stack = UIStackView(arrangedSubviews: [addImage, addLabel])
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = 4
      stack.alignment = .center
      stack.distribution = .fill
      return stack
    }()
  lazy var addImage: UIImageView = {
    let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 18), scale: .small)
    let image = UIImage(systemName: "plus.square.on.square", withConfiguration: config)
    image?.withRenderingMode(.alwaysTemplate)
    image?.withTintColor(.memo_black)
    let view = UIImageView()
    view.image = image
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()
  lazy var addLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "사진 추가"
    label.textColor = .memo_black
    label.font = .sb12
    return label
  }()

}
