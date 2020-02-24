//
//  ImageViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 이미지 터치 시 나타나는 뷰컨
 */
class ImageViewController: UIViewController {
  private var disposeBag = DisposeBag()
  private var images: [UIImage]
  private var selectedIndex: Int
  private var isFirstLoad: Bool = true
  init(images: [UIImage], selectedIndex: Int) {
    self.images = images
    self.selectedIndex = selectedIndex
    super.init(nibName: nil, bundle: nil)
    defer {
      self.setTitle(index: selectedIndex)
      self.navView.dismissButton.popLabel.textColor = .white
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  override func viewDidLayoutSubviews() {
    if self.isFirstLoad {
    imageCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
      self.isFirstLoad = false
    }
  }
  func setTitle(index: Int) {
    self.navView.dismissButton.popLabel.text = "\(index + 1) / \(images.count)"
  }
  // View ✨
  func initView(){
    view.backgroundColor = .black
    view.addSubview(navView)
    view.addSubview(imageCollectionView)
    navView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide)
      } else {
        // Fallback on earlier versions
        make.top.equalTo(view)
      }
      make.leading.equalTo(view).offset(Constant.UI.Size.margin)
      make.trailing.equalTo(view)
      make.height.equalTo(Constant.UI.NavigationBar.height)
    }
    imageCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.trailing.equalTo(view)
      if #available(iOS 11.0, *) {
        make.bottom.equalTo(view.safeAreaLayoutGuide)
      } else {
        // Fallback on earlier versions
        make.bottom.equalTo(view)
      }
    }
  }
  // Bind 🏷
  func bindRx(){
    self.navView.dismissButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
  lazy var navView: BaseDismissNavView = {
    let view = BaseDismissNavView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.dismissButton.popImage.tintColor = .white
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb24
    label.textColor = .white
    return label
  }()
  lazy var imageCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collect.isPagingEnabled = true
    collect.delegate = self
    collect.dataSource = self
    collect.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
    collect.translatesAutoresizingMaskIntoConstraints = false
    return collect
  }()
}

extension ImageViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    for cell in imageCollectionView.visibleCells {
      let indexPath = imageCollectionView.indexPath(for: cell)
      if let first = indexPath?[1] {
        self.setTitle(index: first)
      }
    }
  }
}

extension ImageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell {
      cell.photoImage.image = self.images[indexPath.row]
      return cell
    } else {
      return UICollectionViewCell()
    }
  }
  
  
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.imageCollectionView.frame.width, height: self.imageCollectionView.frame.height)
  }
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    debugPrint(indexPath.row)
  }
}


