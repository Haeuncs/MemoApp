//
//  MemoDetailViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MemoDetailViewController: BaseViewController {
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindRx()
    contentView.addSubview(navView)
    contentView.addSubview(titleTextView)
    contentView.addSubview(memoTextView)
    contentView.addSubview(photoLabel)
    contentView.addSubview(photoCollect)
    
    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(34+16)
    }
    titleTextView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom).offset(24)
      make.leading.trailing.equalTo(contentView)
    }
    memoTextView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextView.snp.bottom).offset(30)
      make.leading.trailing.equalTo(contentView)
    }
    photoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(memoTextView.snp.bottom).offset(30)
      make.leading.trailing.equalTo(contentView)
    }
    photoCollect.snp.makeConstraints { (make) in
      make.top.equalTo(photoLabel.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(116)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  func bindRx(){
    navView.popButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
  }
  lazy var navView: BasePopNavView = {
    let view = BasePopNavView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleTextView: MemoTextFieldView = {
    let view = MemoTextFieldView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var memoTextView: MemoTextView = {
    let view = MemoTextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var photoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .sb18
    return label
  }()
  lazy var photoCollect: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 116, height: 116)
    layout.minimumLineSpacing = 6
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.contentInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36)
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = .white
    view.delegate = self
    view.dataSource = self
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(MemoPhotoAddPhotoCell.self, forCellWithReuseIdentifier: "addCell")
    return view
  }()
}


extension MemoDetailViewController: UICollectionViewDelegate {
  
}

extension MemoDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! MemoPhotoAddPhotoCell
    return cell
  }
  
}
