//
//  BaseViewController.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 마진 적용 베이스 뷰컨트롤러
 */
class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Color.background

    navigationController?.navigationBar.isHidden = true
    self.setupHideKeyboardOnTap()
    view.addSubview(contentView)
    contentView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        // Fallback on earlier versions
        make.top.equalTo(view.snp.top)
      }
      if #available(iOS 11.0, *) {
        make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Constant.UI.Size.margin)
      } else {
        // Fallback on earlier versions
        make.leading.equalTo(view.snp.leading).offset(Constant.UI.Size.margin)
      }
      if #available(iOS 11.0, *) {
        make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Constant.UI.Size.margin)
      } else {
        // Fallback on earlier versions
        make.trailing.equalTo(view.snp.trailing).offset(Constant.UI.Size.margin)
      }
      if #available(iOS 11.0, *) {
        make.bottom.equalTo(view.safeAreaLayoutGuide)
      } else {
        // Fallback on earlier versions
        make.bottom.equalTo(view)
      }
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
