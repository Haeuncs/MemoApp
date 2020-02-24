//
//  Tutorial.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct TutorialType {
  let image: UIImage
  let title: String
  let subTitle: String
}

private enum Style {
  enum Title {
    static let title: String = "메모\n시작하기"
    static let font: UIFont = .sb24
  }
  enum Table {
    static let rowHeight: CGFloat = 100
    static let data: [TutorialType] = [
      TutorialType(image: UIImage(named: "shopping-list")!, title: "메모", subTitle: "사진과 메모를 함께 저장하세요."),
      TutorialType(image: UIImage(named: "cost-per-click")!, title: "메모를 꾹 눌러보세요.", subTitle: "빠르게 메모를 편집할 수 있어요."),
      TutorialType(image: UIImage(named: "pigeon")!, title: "다크모드", subTitle: "다크모드를 지원합니다. 설정에서 확인해보세요."),
    ]
  }
  enum Button {
    static let title: String = "계속하기"
  }
}
class TutorialViewController: UIViewController {
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
    setAppearance()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  func setAppearance() {
    view.backgroundColor = Color.background
    tableView.backgroundColor = Color.background
    titleLabel.textColor = Color.black
    addButton.backgroundColor = Color.black
    addButton.setTitleColor(Color.background, for: .normal)
  }

  // View ✨
  func initView(){
    view.addSubview(titleLabel)
    view.addSubview(tableView)
    view.addSubview(addButton)
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(view).offset(60)
      make.leading.trailing.equalTo(view)
    }
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(60)
      make.bottom.equalTo(addButton)
      make.leading.equalTo(view).offset(32)
      make.trailing.equalTo(view).offset(-32)
    }
    addButton.snp.makeConstraints { (make) in
      make.leading.equalTo(view).offset(Constant.UI.Size.margin)
      make.trailing.equalTo(view).offset(-Constant.UI.Size.margin)
      make.height.equalTo(60)
      make.bottom.equalTo(view).offset(-60)
    }
  }
  // Bind 🏷
  func bindRx(){
    addButton.rx.tap
      .subscribe(onNext: {[weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
        
      }).disposed(by: disposeBag)
  }
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = Style.Title.title
    label.font = .sb28
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  lazy var tableView: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(TutorialTableCell.self, forCellReuseIdentifier: "cell")
    table.rowHeight = Style.Table.rowHeight
    table.dataSource = self
    return table
  }()
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Style.Button.title, for: .normal)
    button.titleLabel?.font = .sb16
    button.layer.cornerRadius = Constant.UI.radius
    return button
  }()

}

extension TutorialViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Style.Table.data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TutorialTableCell {
      cell.configure(type: Style.Table.data[indexPath.row])
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  
}
