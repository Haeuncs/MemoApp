//
//  PopupData.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/04/03.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public struct PopupData {
  public fileprivate(set) var body: String
  public fileprivate(set) var left: String
  public fileprivate(set) var right: String
  public fileprivate(set) var rightHandler: ( () -> Void )?
}
