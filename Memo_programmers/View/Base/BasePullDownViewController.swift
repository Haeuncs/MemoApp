//
//  BasePullDownViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BasePullDownViewController: UIViewController {
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setAppearance()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimGesture))
    dimView.addGestureRecognizer(tapGesture)
    initView_()
//    navView.doneButton.rx.tap
//      .subscribe(onNext: { [weak self] (_) in
//        self?.dismiss(animated: true, completion: nil)
//      }).disposed(by: disposeBag)
  }
  @objc func dimGesture() {
    self.dismiss(animated: true, completion: nil)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.safeView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: 0, height: 0)
    UIView.animate(withDuration: 0.33, animations: {
      self.safeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    })
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  func setAppearance() {
    safeView.backgroundColor = Color.background
    contentView.backgroundColor = Color.background
    dimView.backgroundColor = Color.dim
  }

  // View ✨
  func initView_() {
    view.addSubview(dimView)
    view.addSubview(safeView)
    safeView.addSubview(contentView)
    contentView.addSubview(navView)
    dimView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(view)
    }
    contentView.snp.makeConstraints { (make) in
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      if #available(iOS 11.0, *) {
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      } else {
        // Fallback on earlier versions
        make.bottom.equalTo(view.snp.bottom)
      }
    }
    safeView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.bottom.equalTo(view.snp.bottom)
    }
    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
    }
  }
  lazy var dimView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.dim
    return view
  }()
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var navView: PullNavigationView = {
    let view = PullNavigationView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var safeView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

}
