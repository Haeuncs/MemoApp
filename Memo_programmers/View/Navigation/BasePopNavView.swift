//
//  BasePopNavView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class BasePopNavView: UIView {
  func configure(type: MemoDetailType) {
    switch type {
    case .Edit:
      self.dotButton.isHidden = true
      self.titleButton.isHidden = false
      self.titleButton.setTitle("수정 완료", for: .normal)
    case .Add:
      self.dotButton.isHidden = true
      self.titleButton.isHidden = false
      self.titleButton.setTitle("저장", for: .normal)
    case .Read:
      self.dotButton.setImage(UIImage(named: "dot"), for: .normal)
      self.dotButton.isHidden = false
      self.titleButton.isHidden = true
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(popButton)
    self.addSubview(dotButton)
    self.addSubview(titleButton)
    //    self.addSubview(saveLabel)
    popButton.snp.makeConstraints { (make) in
      make.leading.bottom.equalTo(self)
      make.top.equalTo(self).offset(16)
    }
    dotButton.snp.makeConstraints { (make) in
      make.trailing.bottom.equalTo(self)
      make.height.equalTo(34)
    }
    titleButton.snp.makeConstraints { (make) in
      make.trailing.bottom.equalTo(self)
      make.height.equalTo(34)
    }
    //    saveLabel.snp.makeConstraints { (make) in
    //      make.trailing.bottom.equalTo(self)
    //    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var popButton: PopButton = {
    let view = PopButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var dotButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "dot"), for: .normal)
    return button
  }()
  lazy var titleButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .sb12
    button.setTitleColor(.memo_black, for: .normal)
    button.setTitle("저장", for: .normal)
    return button
  }()
  lazy var saveLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "저장"
    label.font = .sb12
    return label
  }()
  
}


class PopButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(popImage)
    self.addSubview(popLabel)
    
    popImage.snp.makeConstraints { (make) in
      make.width.equalTo(34)
      make.top.bottom.leading.equalTo(self)
    }
    popLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(popImage.snp.trailing).offset(6)
      make.trailing.equalTo(self)
      make.centerY.equalTo(self)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var popImage: UIImageView = {
    let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 28), scale: .small)
    let image = UIImage(systemName: "arrow.left", withConfiguration: config)
    image?.withRenderingMode(.alwaysTemplate)
    let view = UIImageView()
    view.tintColor = .memo_black
    view.image = image
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()
  lazy var popLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "홈"
    label.font = .sb14
    label.textColor = UIColor.memo_black
    return label
  }()
  
}
