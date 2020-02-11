//
//  HomeViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.addSubview(navView)
    contentView.addSubview(tableView)
    
    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(53)
    }
    tableView.snp.makeConstraints { (make) in
      make.leading.trailing.bottom.equalTo(view)
      make.top.equalTo(navView.snp.bottom)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  lazy var navView: HomeNavigationView = {
    let view = HomeNavigationView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var tableView: UITableView = {
    let view = UITableView()
    view.delegate = self
    view.dataSource = self
    view.separatorStyle = .none
    view.translatesAutoresizingMaskIntoConstraints = false
    view.estimatedRowHeight = 100
    view.rowHeight = UITableView.automaticDimension
    view.backgroundColor = .white
    view.register(HomeMemoTableCell.self, forCellReuseIdentifier: "cell")
    return view
  }()

}



extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = MemoDetailViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1000
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeMemoTableCell
    return cell
  }
  
  
}
