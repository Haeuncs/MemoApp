//
//  MemoDetailView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/21.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum MemoDetailConstants {
  enum Text {
    static let photo = "📸 사진"
    static let title = "🏷 제목"
    static let titlePlaceHolder = "제목을 입력해주세요."
    static let memo = "📝 메모"
    static let memoPlaceHolder = "메모를 입력해주세요."
    static let create = "생성: "
    static let edit = "마지막 수정: "
  }
  enum UI {
    static let collectionHeight: CGFloat = 132
    static let horizontalMargin: CGFloat = 30
  }
  enum Cell {
    static let height: CGFloat = 100
    static let width: CGFloat = 100
    static let verticalInset: CGFloat = 46
  }
  enum DateLabel {
    static let font: UIFont = .r12
    static let color: UIColor = Color.grey
  }
}

class MemoDetailView: BaseView {
  private typealias UI = Constant.UI
  
  /// date 값이 있으면 setting
  func configureDate(createDate: Date?, editDate: Date?) {
    if let date = createDate {
      self.createDate.text = MemoDetailConstants.Text.create + date.korDateString()
    }
    if let date = editDate {
      self.editDate.text = MemoDetailConstants.Text.edit + date.korDateString()
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setAppearance() {
    navView.setAppearance()
    titleTextView.setAppearance()
    memoTextView.setAppearance()
    photoLabel.textColor = Color.black
    photoCollect.backgroundColor = Color.background
  }
  // View ✨
  func initView(){
    baseView.addSubview(navView)
    baseView.addSubview(scrollView)
    scrollView.addSubview(titleTextView)
    scrollView.addSubview(memoTextView)
    scrollView.addSubview(photoLabel)
    scrollView.addSubview(photoCollect)
    scrollView.addSubview(dateStack)
    
    navView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(baseView)
      $0.height.equalTo(UI.NavigationBar.height)
    }
    scrollView.snp.makeConstraints {
      $0.top.equalTo(navView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self)
    }
    titleTextView.snp.makeConstraints {
      $0.top.equalTo(scrollView.snp.top).offset(MemoDetailConstants.UI.horizontalMargin)
      $0.leading.trailing.equalTo(baseView)
    }
    memoTextView.snp.makeConstraints {
      $0.top.equalTo(titleTextView.snp.bottom).offset(MemoDetailConstants.UI.horizontalMargin)
      $0.leading.trailing.equalTo(baseView)
    }
    photoLabel.snp.makeConstraints {
      $0.top.equalTo(memoTextView.snp.bottom).offset(MemoDetailConstants.UI.horizontalMargin)
      $0.leading.trailing.equalTo(baseView)
    }
    photoCollect.snp.makeConstraints {
      $0.top.equalTo(photoLabel.snp.bottom)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(MemoDetailConstants.UI.collectionHeight)
    }
    dateStack.snp.makeConstraints { (make) in
      make.top.equalTo(photoCollect.snp.bottom).offset(MemoDetailConstants.UI.horizontalMargin)
      make.leading.trailing.equalTo(self)
      make.bottom.equalTo(scrollView.snp.bottom).offset(-Constant.UI.Size.margin)
    }
  }

  lazy var navView: BasePopNavView = {
    let view = BasePopNavView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  lazy var titleTextView: MemoTextFieldView = {
    let view = MemoTextFieldView()
    view.titleLabel.text = MemoDetailConstants.Text.title
    view.textField.placeholder = MemoDetailConstants.Text.titlePlaceHolder
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var memoTextView: MemoTextView = {
    let view = MemoTextView()
    view.titleLabel.text = MemoDetailConstants.Text.memo
//    view.textView.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var photoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = MemoDetailConstants.Text.photo
    label.font = .sb18
    return label
  }()
  lazy var photoCollect: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: MemoDetailConstants.Cell.width, height: MemoDetailConstants.Cell.height)
    layout.minimumLineSpacing = UI.Size.margin
    layout.minimumInteritemSpacing = 0
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.contentInset = UIEdgeInsets(top: 0, left: MemoDetailConstants.Cell.verticalInset, bottom: 0, right: MemoDetailConstants.Cell.verticalInset)
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = Constant.UI.backgroundColor
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(MemoPhotoAddPhotoCell.self, forCellWithReuseIdentifier: MemoDetailViewController.photoIdentifier)
    return view
  }()
  lazy var dateStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [createDate, editDate])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = Constant.UI.Size.margin
    return stack
  }()

  lazy var createDate: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = MemoDetailConstants.DateLabel.font
    label.textColor = MemoDetailConstants.DateLabel.color
    return label
  }()
  lazy var editDate: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = MemoDetailConstants.DateLabel.font
    label.textColor = MemoDetailConstants.DateLabel.color
    return label
  }()

}
