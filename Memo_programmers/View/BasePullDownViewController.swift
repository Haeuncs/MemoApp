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
    view.addSubview(dimView)
    view.addSubview(contentView)
    view.addSubview(safeView)
    contentView.addSubview(navView)
    dimView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(contentView.snp.top)
    }
    contentView.snp.makeConstraints { (make) in
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    safeView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.bottom)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(view.snp.bottom)
    }
    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
    }

//    navView.doneButton.rx.tap
//      .subscribe(onNext: { [weak self] (_) in
//        self?.dismiss(animated: true, completion: nil)
//      }).disposed(by: disposeBag)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  // View ✨
  lazy var dimView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.11)
    return view
  }()
  lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
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
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

}



