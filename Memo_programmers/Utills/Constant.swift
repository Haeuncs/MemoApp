//
//  Constant.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/18.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

enum Constant {
  enum UI {
    static let backgroundColor: UIColor = Color.background
    static let radius: CGFloat = 12
    static let shadow: Shadow = Shadow(color: Color.black, alpha: 0.16, x: 0, y: 3, blur: 6)
    @available(iOS 11.0, *)
    static let safeInsetBottom: CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    @available(iOS 10.0, *)
    static let safeInsetBottom_iOS10: CGFloat = UIApplication.shared.keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0
    
    static let animationDuration: TimeInterval = 0.33
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    
    enum Size {
      static let margin: CGFloat = 16.0
    }
    
    enum NavigationBar {
      static let height: CGFloat = 50
    }
  }
  
  enum MemoHome {
    enum Cell {
      static let dividerLineHeight: CGFloat = 1
      static let memoLines: Int = 3
      static let imageRadius: CGFloat = 8
      static let imageHeight: CGFloat = 90
    }
  }
  
  enum BottomPopup {
    enum MemoOrderType {
      static let typeTitle: String = "정렬"
      static let title: MemoEdit = MemoEdit(image: UIImage(named: "orderTitle")!, title: "제목")
      static let createDate: MemoEdit = MemoEdit(image: UIImage(named: "orderAddCalender")!, title: "만든 날짜")
      static let modifyDate: MemoEdit = MemoEdit(image: UIImage(named: "orderCanlendar")!, title: "수정한 날짜")
    }
    
    enum MemoAddPhotoType {
      static let typeTitle: String = "사진 추가"
      static let loadByGallery: MemoEdit = MemoEdit(image: UIImage(named: "LoadGallery")!, title: "사진 불러오기")
      static let loadByCamera: MemoEdit = MemoEdit(image: UIImage(named: "Camera")!, title: "카메라로 찍기")
      static let loadByURL: MemoEdit = MemoEdit(image: UIImage(named: "AddByURL")!, title: "URL 로 입력하기")
    }
    
    enum MemoEditType {
      static let typeTitle: String = "메모"
      static let share: MemoEdit = MemoEdit(image: UIImage(named: "orderTitle")!, title: "메모 공유")
      static let edit: MemoEdit = MemoEdit(image: UIImage(named: "MoreEdit")!, title: "편집")
      static let delete: MemoEdit = MemoEdit(image: UIImage(named: "MoreDelete")!, title: "삭제")
    }
  }
}
