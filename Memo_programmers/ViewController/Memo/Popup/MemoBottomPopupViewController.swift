////
////  MemoEditPopupViewController.swift
////  Memo_programmers
////
////  Created by LEE HAEUN on 2020/02/11.
////  Copyright © 2020 LEE HAEUN. All rights reserved.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa
//
//enum MemoBottomType {
//  case addImage
//  case editMemo
//}
//class MemoBottomPopupViewController: BasePullDownViewController {
//  
//  typealias BottomPopupTypes = Constant.BottomPopup
//  // Public
//  public weak var delegate: MemoDetailDelegate?
//  public weak var homeOrderDelegate: MemoOrderTypeDelegate?
//  
//  // Private
//  private var tableViewHeightConstrants: NSLayoutConstraint?
//  private var disposeBag = DisposeBag()
//  private var tableData: [MemoEdit] = [] {
//    didSet {
//      self.tableView.reloadData()
//    }
//  }
//  private var selectedTitle: String?
//  
//  init(data: [MemoEdit], title: String, selectedTitle: String? = nil) {
//    self.selectedTitle = selectedTitle
//    super.init(nibName: nil, bundle: nil)
//    self.navView.titleLabel.text = title
//    defer {
//      self.tableData = data
//    }
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    initView()
//    bindRx()
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//  }
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//  }
//  // View ✨
//  func initView(){
//    contentView.addSubview(tableView)
//    tableView.snp.makeConstraints { (make) in
//      make.top.equalTo(navView.snp.bottom)
//      make.leading.trailing.equalTo(contentView)
//      make.bottom.equalTo(contentView)
//    }
//    tableViewHeightConstrants = tableView.heightAnchor.constraint(equalToConstant: CGFloat(54 * self.tableData.count))
//    tableViewHeightConstrants?.isActive = true
//  }
//  // Bind 🏷
//  func bindRx(){
//    self.navView.doneButton.rx.tap
//      .subscribe(onNext: { [weak self] (_) in
//        self?.dismiss(animated: true, completion: nil)
//      }).disposed(by: disposeBag)
//  }
//
//  lazy var tableView: UITableView = {
//    let view = UITableView()
//    view.delegate = self
//    view.dataSource = self
//    view.separatorStyle = .none
//    view.translatesAutoresizingMaskIntoConstraints = false
////    view.estimatedRowHeight = 50
//    view.rowHeight = 54
//    view.backgroundColor = .systemPink
//    view.register(MemoPopupCell.self, forCellReuseIdentifier: "cell")
//    return view
//  }()
//}
//
//extension MemoBottomPopupViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let selectedData = self.tableData[indexPath.row]
//    switch selectedData.title {
//    case BottomPopupTypes.MemoEditType.edit.title:
//      self.delegate?.memoDetailPopup(type: .edit)
//    case BottomPopupTypes.MemoEditType.delete.title:
//      self.delegate?.memoDetailPopup(type: .delete)
//    case BottomPopupTypes.MemoAddPhotoType.loadByGallery.title:
//      self.delegate?.memoDetailPopup(type: .loadPhoto)
//    case BottomPopupTypes.MemoAddPhotoType.loadByCamera.title:
//      self.delegate?.memoDetailPopup(type: .camera)
//    case BottomPopupTypes.MemoAddPhotoType.loadByURL.title:
//      self.delegate?.memoDetailPopup(type: .urlLoadImage)
//    case BottomPopupTypes.MemoOrderType.title.title:
//      self.homeOrderDelegate?.memoOrderSelected(type: .title)
//    case BottomPopupTypes.MemoOrderType.createDate.title:
//      self.homeOrderDelegate?.memoOrderSelected(type: .createDate)
//    case BottomPopupTypes.MemoOrderType.modifyDate.title:
//      self.homeOrderDelegate?.memoOrderSelected(type: .modifyDate)
//    default:
//      return
//    }
//  }
//}
//
//
//extension MemoBottomPopupViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return self.tableData.count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoPopupCell
//    let data = self.tableData[indexPath.row]
//    if (self.selectedTitle == "title" &&
//      data.title == Constant.BottomPopup.MemoOrderType.title.title) ||
//      (self.selectedTitle == "createDate" && data.title == Constant.BottomPopup.MemoOrderType.createDate.title) ||
//      (self.selectedTitle == "modifyDate" && data.title == Constant.BottomPopup.MemoOrderType.modifyDate.title) {
//      cell.configure(data: data, isSelected: true)
//    } else {
//      cell.configure(data: data)
//    }
//    return cell
//  }
//}
