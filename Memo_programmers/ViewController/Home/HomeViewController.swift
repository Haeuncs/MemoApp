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

enum HomeConstants {
  enum Table {
    static let EstimatedHeight: CGFloat = 100
    static let IdentifierWithImage: String = "CellWithImage"
    static let IdentifierWithoutImage: String = "CellWithoutImage"
  }
  enum AddButton {
    static let height: CGFloat = 48
    static let rightMargin: CGFloat = 8
    static let backgroundColor: UIColor = Color.veryLightGrey
    static let image: UIImage = UIImage(named: "addIcon")!
  }
}

class HomeViewController: BaseViewController {

  // MARK: - Properties
  private var disposeBag = DisposeBag()
  private var viewModel: HomeViewModelType = HomeViewModel(coreData: CoreDataModel())
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    let theme = userPreferences.getColorTheme()
    if theme == .light {
      if #available(iOS 13.0, *) {
        return .darkContent
      } else {
        // Fallback on earlier versions
        return .default
      }
    } else {
      return .lightContent
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
    setAppearance()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.getMemo()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if userPreferences.getisOpenTutorial() == false {
      let tutorialVC = TutorialViewController()
      present(tutorialVC, animated: true, completion: {
        userPreferences.setOpenTutorial(bool: true)
      })
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.delegate = nil
  }

  // MARK: - View ✨
  func setAppearance() {
    view.backgroundColor = Color.background
    contentView.backgroundColor = Color.background
    self.tableView.backgroundColor = Color.background
    self.addMemoButton.backgroundColor = HomeConstants.AddButton.backgroundColor
  }

  func initView() {
    contentView.addSubview(navView)
    contentView.addSubview(tableView)
    contentView.addSubview(addMemoButton)
    
    view.bringSubviewToFront(addMemoButton)

    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(Constant.UI.NavigationBar.height)
    }
    tableView.snp.makeConstraints { (make) in
      make.leading.trailing.bottom.equalTo(view)
      make.top.equalTo(navView.snp.bottom)
    }
    addMemoButton.snp.makeConstraints { (make) in
      make.height.width.equalTo(HomeConstants.AddButton.height)
      make.trailing.equalTo(contentView)
      make.bottom.equalTo(contentView).offset(-Constant.UI.Size.margin)
    }
  }

  // MARK: - Bind 🏷
  func bindRx() {

    self.navView.addButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.openMemoOrderVC()
      }).disposed(by: disposeBag)

    self.navView.settingButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.openSetting()
      }).disposed(by: disposeBag)

    self.addMemoButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        let addMemoVC = MemoDetailViewController(type: .add, coreData: CoreDataModel(), memoData: nil)
        self?.navigationController?.pushViewController(addMemoVC, animated: true)
      }).disposed(by: disposeBag)

    self.tableView.rx.modelSelected(MemoData.self)
      .subscribe(onNext: { [weak self] (memoData) in

        let readMemoVC = MemoDetailViewController(type: .read, coreData: CoreDataModel(), memoData: memoData)
        self?.navigationController?.pushViewController(readMemoVC, animated: true)
      }).disposed(by: disposeBag)

    self.viewModel.outputs.memos
      .bind(to: tableView.rx.items) { table, _, element in
        if element.imageArray?.count ?? 0 > 0 {
          return self.cellWithImage(with: element, from: table)
        } else {
          return self.cellWithoutImage(with: element, from: table)
        }
    }.disposed(by: disposeBag)

    self.viewModel.outputs.memos
      .subscribe(onNext: { [weak self] (memos) in
        if memos.count == 0 {
          self?.tableView.setHomeEmptyBackgroundView()
        } else {
          self?.tableView.restore()
        }
      }).disposed(by: disposeBag)
    
  }

  @objc func pushSearchView() {
    let searchVC = SearchViewController(searchViewFrame: self.navView.searchView.frame, memos: self.viewModel.outputs.memos.value)
    self.navigationController?.pushViewController(searchVC, animated: false)
  }
  lazy var navView: HomeNavigationView = {
    let view = HomeNavigationView()
    view.searchView.addTarget(self, action: #selector(pushSearchView), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.UI.safeInsetBottomiOS10, right: 0)
    view.separatorStyle = .none
    view.estimatedRowHeight = HomeConstants.Table.EstimatedHeight
    view.rowHeight = UITableView.automaticDimension
    view.register(HomeMemoTableCell.self, forCellReuseIdentifier: HomeConstants.Table.IdentifierWithImage)
    view.register(HomeMemoWithoutImageTableCell.self, forCellReuseIdentifier: HomeConstants.Table.IdentifierWithoutImage)
    view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:))))
    return view
  }()

  lazy var addMemoButton: BaseButton = {
    let view = BaseButton()
    view.backgroundColor = HomeConstants.AddButton.backgroundColor
    view.layer.cornerRadius = Constant.UI.radius
    view.layer.shadow(shadow: Constant.UI.shadow)
    view.setImage(HomeConstants.AddButton.image, for: .normal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}

extension HomeViewController {
  /// 이미지가 있는 cell
  private func cellWithImage(with element: MemoData, from table: UITableView) -> UITableViewCell {
    if let cell = table.dequeueReusableCell(withIdentifier: HomeConstants.Table.IdentifierWithImage) as? HomeMemoTableCell {
      cell.configure(title: element.title, memo: element.memo, date: element.date, image: element.imageArray?.first?.image)
      return cell
    }
    return UITableViewCell()
  }

  /// 이미지가 없는 cell
  private func cellWithoutImage(with element: MemoData, from table: UITableView) -> UITableViewCell {
    if let cell = table.dequeueReusableCell(withIdentifier: HomeConstants.Table.IdentifierWithoutImage) as? HomeMemoWithoutImageTableCell {
      cell.configure(title: element.title, memo: element.memo, date: element.date)
      return cell
    }
    return UITableViewCell()
  }

  @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: location)
    if let row = indexPath?.row {
      self.openMemoEditVC(memo: self.viewModel.outputs.memos.value[row])
    }
  }

  // MARK: - Popup
  func shareMemo(text: String) {
    let textToShare = text
    let objectsToShare = [textToShare] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

    present(activityVC, animated: true, completion: nil)
  }

  func openSetting() {
    let currentTheme = userPreferences.getColorTheme()
    let bottomPopupVC = BottomViewController(title: "설정")
    bottomPopupVC.addAction(BottomCellData(cellData:
      MemoEdit(image: currentTheme == .light ? UIImage(named: "darkMode")! : UIImage(named: "lightMode")!,
               title: currentTheme == .light ? "다크모드 켜기" : "라이트모드 켜기"),
                                handler: {
                                  let vc = HomeViewController()
                                  if currentTheme == .light {
                                    userPreferences.setColorTheme(theme: .dark)
                                    Theme.darkMode()
                                    self.setRootViewController(vc)
                                  } else {
                                    userPreferences.setColorTheme(theme: .light)
                                    Theme.lightMode()
                                    self.setRootViewController(vc)
                                  }
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: MemoEdit(image: UIImage(named: "orderTitle")!, title: "튜토리얼 다시보기"), handler: {
      let tutorialVC = TutorialViewController()
      self.present(tutorialVC, animated: true, completion: {})
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: MemoEdit(image: UIImage(named: "MoreDelete")!, title: "모든 데이터 삭제하기"), handler: {
      self.viewModel.inputs.flushData()
    }))
    self.present(bottomPopupVC, animated: true, completion: nil)
  }

  /// 선택된 메모 수정
  func openMemoEditVC(memo: MemoData) {
    let memoEditType = Constant.BottomPopup.MemoEditType.self
    let bottomPopupVC = BottomViewController(title: memoEditType.typeTitle)
    bottomPopupVC.addAction(BottomCellData(cellData: memoEditType.share, handler: {
      self.shareMemo(text: memo.memo ?? "")
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: memoEditType.edit, handler: {
      let editMemoVC = MemoDetailViewController(type: .edit, coreData: CoreDataModel(), memoData: memo)
      self.navigationController?.pushViewController(editMemoVC, animated: true)
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: memoEditType.delete, handler: {
      self.viewModel.inputs.deleteMemo(identifier: memo.identifier)
      self.viewModel.inputs.getMemo()
    }))
    present(bottomPopupVC, animated: true, completion: nil)
  }

  /// 메모 정렬하는 뷰컨 열기
  func openMemoOrderVC() {
    let currentOrderType = userPreferences.getOrderTypeKor()
    let orderTypes = Constant.BottomPopup.MemoOrderType.self
    let bottomPopupVC = BottomViewController(title: orderTypes.typeTitle)
    bottomPopupVC.addAction(BottomCellData(cellData: orderTypes.title,
                                style: currentOrderType == orderTypes.title.title ? .selected : .default ,
                                handler: {
                                  userPreferences.setOrderType(type: .title)
                                  self.viewModel.inputs.getMemo()
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: orderTypes.createDate,
                                style: currentOrderType == orderTypes.createDate.title ? .selected : .default,
                                handler: {
                                  userPreferences.setOrderType(type: .createDate)
                                  self.viewModel.inputs.getMemo()
    }))
    bottomPopupVC.addAction(BottomCellData(cellData: orderTypes.modifyDate,
                                style: currentOrderType == orderTypes.modifyDate.title ? .selected : .default,
                                handler: {
                                  userPreferences.setOrderType(type: .modifyDate)
                                  self.viewModel.inputs.getMemo()
    }))

    self.present(bottomPopupVC, animated: true, completion: nil)
  }

  func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
      guard let window = UIApplication.shared.keyWindow else {
          return
      }
      window.rootViewController = UINavigationController(rootViewController: vc)
      window.makeKeyAndVisible()
      UIView.transition(with: window,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: nil,
                        completion: nil)
  }
}
