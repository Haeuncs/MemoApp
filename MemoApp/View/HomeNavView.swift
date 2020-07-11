//
//  HomeNavView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum HomeNavigationConstants {
  enum Title {
    static let Title: String = "Memo"
    static let color: UIColor = Color.black
    static let Font: UIFont = .h28
  }
  enum Button {
    static let Image: UIImage = UIImage(named: "transferBecris")!.withRenderingMode(.alwaysTemplate)
    static let settingImage: UIImage = UIImage(named: "settingsFreepik")!.withRenderingMode(.alwaysTemplate)
    static let width: CGFloat = 34
    static let height: CGFloat = 34
    static let color: UIColor = Color.black
  }
  enum Divider {
    static let height: CGFloat = 4
    static let color: UIColor = Color.black
  }
}

class HomeNavigationView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initView()
    setAppearance()
    
  }

  func expendSearchView() {
    self.bringSubviewToFront(searchView)
    searchView.snp.remakeConstraints { (make) in
      make.leading.equalTo(self).offset(8)
      make.trailing.equalTo(self).offset(-8)
      make.centerY.equalToSuperview()
      make.height.equalTo(30)
    }
    
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
  
  func initView() {
    self.addSubview(containerView)
//
    containerView.addSubview(searchView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(buttonStack)
//
    containerView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(Constant.UI.NavigationBar.height)
    }

    titleLabel.snp.makeConstraints { (make) in
      make.top.leading.bottom.equalTo(containerView)
      make.width.lessThanOrEqualTo(100)
    }
    searchView.snp.makeConstraints { (make) in
      make.leading.equalTo(titleLabel.snp.trailing).offset(8).priority(.high)
      make.trailing.equalTo(buttonStack.snp.leading).offset(-8)
      make.centerY.equalToSuperview()
      make.height.equalTo(30)
    }
    buttonStack.snp.makeConstraints { (make) in
      make.trailing.equalTo(containerView).priority(.high)
      make.centerY.equalTo(titleLabel)
      make.top.bottom.equalTo(containerView)
      make.width.equalTo(80)
    }
  }
  
  func setAppearance() {
    self.backgroundColor = Color.background
    self.titleLabel.textColor = Color.black
    self.addButton.imageView?.tintColor = Color.black
    self.settingButton.imageView?.tintColor = Color.black
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var searchView: SearchView = {
    let view = SearchView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = HomeNavigationConstants.Title.color
    label.font = HomeNavigationConstants.Title.Font
    label.text = HomeNavigationConstants.Title.Title
    return label
  }()
  lazy var buttonStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [addButton, settingButton])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 8
    return stack
  }()
  lazy var addButton: BaseButton = {
    let button = BaseButton()
    button.imageView?.tintColor = HomeNavigationConstants.Button.color
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(HomeNavigationConstants.Button.Image, for: .normal)
    return button
  }()
  lazy var settingButton: BaseButton = {
    let button = BaseButton()
    button.imageView?.tintColor = HomeNavigationConstants.Button.color
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(HomeNavigationConstants.Button.settingImage, for: .normal)
    return button
  }()
}
