//
//  PullNavigationView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class PullNavigationView: BaseView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    baseView.addSubview(imageView)
    baseView.addSubview(titleLabel)
    baseView.addSubview(doneButton)
    baseView.addSubview(lineView)
//    imageView.snp.makeConstraints { (make) in
//      make.top.equalTo(baseView).offset(4)
//      make.centerX.equalTo(baseView)
//      make.width.equalTo(34)
//      make.height.equalTo(4)
//    }
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalTo(baseView)
    }
    doneButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(baseView)
      make.centerY.equalTo(baseView)
    }
    lineView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.bottom.equalTo(baseView)
      make.leading.trailing.equalTo(self)
      make.height.equalTo(1)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "28")
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .sb16
    label.textColor = .memo_black
    return label
  }()
  lazy var doneButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("완료", for: .normal)
    button.titleLabel?.font = .sb12
    button.setTitleColor(.memo_black, for: .normal)
    return button
  }()

  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .memo_very_light_grey
    return view
  }()

}

