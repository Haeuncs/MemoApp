//
//  BottomViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 아래로 붙어있는 present 되는 vc
 */

private enum Style {
  enum Table {
    static let rowHeight: CGFloat = 54
  }
}
class BottomViewController: BasePullDownViewController {
  
  // MARK: - Properties
  
  typealias BottomPopupTypes = Constant.BottomPopup
  private var tableViewHeightConstrants: NSLayoutConstraint?
  private var disposeBag = DisposeBag()
  private var tableData = [BottomCellData]()
  private var selectedTitle: String?
  
  init(title: String) {
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
    self.navView.titleLabel.text = title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
  }
  
  // MARK: - View ✨
  
  func initView(){
    contentView.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.trailing.equalTo(contentView)
      make.bottom.equalTo(contentView)
    }
    // 추가된 item 만큼 높이를 설정
    tableViewHeightConstrants = tableView.heightAnchor.constraint(equalToConstant: CGFloat(Int(Style.Table.rowHeight) * self.tableData.count))
    tableViewHeightConstrants?.isActive = true
  }
  
  // MARK: - Bind 🏷
  
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
    view.rowHeight = Style.Table.rowHeight
    view.backgroundColor = Color.veryLightGrey
    view.register(MemoPopupCell.self, forCellReuseIdentifier: "cell")
    return view
  }()
  
  open func addAction(_ data: BottomCellData) {
    self.tableData.append(data)
  }
  
}

// MARK: - UITableViewDelegate

extension BottomViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.dismiss(animated: true, completion: nil)
    let data = self.tableData[indexPath.row]
    data.handler()
  }
}

// MARK: - UITableViewDataSource

extension BottomViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoPopupCell
    let data = self.tableData[indexPath.row]
    
    if data.style == .selected {
      cell.configure(data: data.cellData, isSelected: true)
    } else {
      cell.configure(data: data.cellData)
    }
    return cell
  }
}
