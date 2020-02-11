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
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(popButton)
    self.addSubview(dotButton)
    popButton.snp.makeConstraints { (make) in
      make.leading.bottom.equalTo(self)
      make.top.equalTo(self).offset(16)
    }
    dotButton.snp.makeConstraints { (make) in
      make.trailing.bottom.equalTo(self)
      make.height.width.equalTo(34)
    }
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
