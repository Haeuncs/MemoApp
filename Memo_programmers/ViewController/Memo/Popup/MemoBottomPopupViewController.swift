//
//  MemoEditPopupViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum MemoBottomType {
  case addImage
  case editMemo
}
class MemoBottomPopupViewController: BasePullDownViewController {
  
  // Public
  public weak var delegate: MemoDetailDelegate?
  
  // Private
  private var tableViewHeightConstrants: NSLayoutConstraint?
  private var disposeBag = DisposeBag()
  private var tableData: [MemoEdit] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  init(data: [MemoEdit]) {
    super.init(nibName: nil, bundle: nil)
    defer {
      self.tableData = data
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
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  // View ✨
  func initView(){
    self.navView.titleLabel.text = "사진 입력"
    contentView.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.trailing.equalTo(contentView)
      make.bottom.equalTo(contentView)
    }
    tableViewHeightConstrants = tableView.heightAnchor.constraint(equalToConstant: CGFloat(54 * self.tableData.count))
    tableViewHeightConstrants?.isActive = true
  }
  // Bind 🏷
  func bindRx(){
    self.navView.doneButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }

  lazy var tableView: UITableView = {
    let view = UITableView()
    view.delegate = self
    view.dataSource = self
    view.separatorStyle = .none
    view.translatesAutoresizingMaskIntoConstraints = false
//    view.estimatedRowHeight = 50
    view.rowHeight = 54
    view.backgroundColor = .systemPink
    view.register(MemoPopupCell.self, forCellReuseIdentifier: "cell")
    return view
  }()
}

extension MemoBottomPopupViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedData = self.tableData[indexPath.row]
    switch selectedData.title {
    case "편집":
      self.delegate?.memoDetailPopup(type: .edit)
    case "삭제":
      self.delegate?.memoDetailPopup(type: .delete)
    case "사진 불러오기":
      self.delegate?.memoDetailPopup(type: .loadPhoto)
    case "카메라로 찍기":
      self.delegate?.memoDetailPopup(type: .camera)
    case "URL 로 입력하기":
      self.delegate?.memoDetailPopup(type: .urlLoadImage)
    default:
      print("편집")
    }
  }
}


extension MemoBottomPopupViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoPopupCell
    let data = self.tableData[indexPath.row]
    cell.configure(data: data)
    return cell
  }
}
