//
//  MemoPhotoAddPhotoCell.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum Style {
  enum Image {
    static let AddImage: UIImage = UIImage(named: "photoAdd")!.withRenderingMode(.alwaysTemplate)
    static let DeleteImage: UIImage = UIImage(named: "DeleteIcon")!.withRenderingMode(.alwaysTemplate)
    static let EmptyImage: UIImage = UIImage(named: "emptyImage")!.withRenderingMode(.alwaysTemplate)
    static let DeleteHeight: CGFloat = 24
    static let DeleteMargin: CGFloat = 10
  }
  enum Text {
    static let EmptyImage: String = "이미지 없음"
    static let AddImage: String = "사진 추가"
    static let font: UIFont = .sb12
  }
}

class MemoPhotoAddPhotoCell: UICollectionViewCell {
    func configure(image: UIImage?, type: MemoDetailType, count: Int){
    if image == nil {
      if type == .Read && count == 0{
        addImage.image = Style.Image.EmptyImage
        addLabel.text = Style.Text.EmptyImage
      } else {
        addImage.image = Style.Image.AddImage
        addLabel.text = Style.Text.AddImage
      }
      self.stackView.isHidden = false
      self.imageView.isHidden = true
      self.deleteButton.isHidden = true
    } else {
      self.stackView.isHidden = true
      self.imageView.isHidden = false
      self.imageView.image = image!
      
      switch type {
      case .Add, .Edit:
        self.deleteButton.isHidden = false
      case .Read:
        self.deleteButton.isHidden = true
      }

    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(baseView)
    self.addSubview(stackView)
    self.addSubview(deleteButton)
    baseView.addSubview(imageView)
    
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(self)
      make.leading.equalTo(self)
      make.trailing.equalTo(self)
      make.bottom.equalTo(self)
    }
    stackView.snp.makeConstraints { (make) in
      make.center.equalTo(baseView)
    }
    imageView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(baseView)
    }
    deleteButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(Style.Image.DeleteHeight)
      make.trailing.equalTo(imageView.snp.trailing).offset(Style.Image.DeleteMargin)
      make.top.equalTo(imageView.snp.top).offset(-Style.Image.DeleteMargin)
    }
    setAppearance()
  }
  func setAppearance() {
    baseView.backgroundColor = Color.background
    addImage.tintColor = Color.black
    deleteButton.tintColor = Color.black
    addLabel.textColor = Color.black
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.shadow(shadow: Constant.UI.shadow)
    view.layer.cornerRadius = Constant.UI.radius
    view.backgroundColor = Constant.UI.backgroundColor
    return view
  }()
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = Constant.UI.radius
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFill
    return view
  }()
    lazy var stackView: UIStackView = {
      let stack = UIStackView(arrangedSubviews: [addImage, addLabel])
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = 4
      stack.alignment = .center
      stack.distribution = .fill
      return stack
    }()
  lazy var addImage: UIImageView = {
    let view = UIImageView()
    view.image = Style.Image.AddImage
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()
  lazy var deleteButton: BaseButton = {
    let view = BaseButton()
    view.setImage(Style.Image.DeleteImage, for: .normal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var addLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = Style.Text.AddImage
    label.font = Style.Text.font
    return label
  }()

}
