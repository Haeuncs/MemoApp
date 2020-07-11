//
//  SearchViewController.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/04/05.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
  private typealias UI = Constant.UI
  
  private var disposeBag = DisposeBag()
  
  private var frame: CGRect
  private var memos: [MemoData]
  private var filteredMemos: BehaviorRelay<[MemoData]>
  
  private var isAlreadyAppear: Bool = false
  
  init(searchViewFrame: CGRect, memos: [MemoData]) {
    self.frame = searchViewFrame
    self.memos = memos
    filteredMemos = BehaviorRelay(value: [])

    super.init(nibName: nil, bundle: nil)
    
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
    
    self.view.layoutIfNeeded()
    
    if isAlreadyAppear == false {
      self.remakeLayout()
      UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
        
      }, completion: { _ in
        self.isAlreadyAppear = true
        self.searchView.textField.becomeFirstResponder()
      })
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  // MARK: - View ✨
  
  func initView() {
    navView.addSubview(popButton)
    contentView.addSubview(navView)
    navView.addSubview(searchView)
    contentView.addSubview(tableView)
    
    navView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(contentView)
      $0.height.equalTo(UI.NavigationBar.height)
    }
    
    searchView.snp.makeConstraints { (make) in
      make.top.equalTo(navView).offset(self.frame.minY)
      make.leading.equalTo(navView).offset(self.frame.minX)
      make.width.equalTo(self.frame.width)
      make.height.equalTo(self.frame.height)
    }
    popButton.snp.makeConstraints { (make) in
      make.leading.centerY.equalTo(navView)
      make.height.equalTo(34)
    }
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.trailing.bottom.equalTo(view)
    }
  }
  
  func remakeLayout() {
    searchView.snp.remakeConstraints { (make) in
      make.leading.equalTo(popButton.snp.trailing)
      make.trailing.equalTo(contentView)
      make.top.equalTo(contentView).offset(10)
    }
  }
  // MARK: - Bind 🏷
  
  func bindRx() {
    popButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    
    searchView.textField.rx.text.orEmpty
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] (str) in
        guard let self = self else {
            return
        }
        let filteredMemos = self.memos.filter { (memo) -> Bool in
          return memo.title?.contains(str) ?? false || ((memo.memo?.contains(str)) ?? false)
        }
        self.filteredMemos.accept(filteredMemos)
      }).disposed(by: disposeBag)
    
    self.filteredMemos.bind(to: self.tableView.rx.items(cellIdentifier: HomeConstants.Table.IdentifierWithImage, cellType: HomeMemoTableCell.self)) {_, element, cell in
      cell.configure(title: element.title, memo: element.memo, date: element.date)
    }.disposed(by: disposeBag)
    
    self.tableView.rx.modelSelected(MemoData.self)
      .subscribe(onNext: { [weak self] (memoData) in

        let readMemoVC = MemoDetailViewController(type: .read, coreData: CoreDataModel(), memoData: memoData)
        guard let navVC =  self?.navigationController else {
          return
        }
        navVC.popViewController(animated: false)
        navVC.pushViewController(readMemoVC, animated: true)
      }).disposed(by: disposeBag)

  }
  
  lazy var navView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var popButton: PopButton = {
    let button = PopButton()
    button.popImage.tintColor = Color.black
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  lazy var searchView: SearchView = {
    let view = SearchView()
    view.textField.isUserInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var tableView: UITableView = {
    let view = UITableView()
    view.backgroundColor = Color.background
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.UI.safeInsetBottomiOS10, right: 0)
    view.separatorStyle = .none
    view.estimatedRowHeight = HomeConstants.Table.EstimatedHeight
    view.rowHeight = UITableView.automaticDimension
    view.register(HomeMemoTableCell.self, forCellReuseIdentifier: HomeConstants.Table.IdentifierWithImage)
    return view
  }()
}
