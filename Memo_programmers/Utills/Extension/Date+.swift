//
//  Date+.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

extension Date {
  static var dateFormatterKor: DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy년 M월 d일 hh:mm a"
    return dateFormat
  }()
  static var dateFormatter20200201: DateFormatter = {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "yyyyMMdd"
    return dateStringFormatter
  }()
  static var dateFormatterHour: DateFormatter = {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "HH"
    return dateStringFormatter
  }()
  func korDateString() -> String {
    return Date.dateFormatterKor.string(from: self)
  }
  func fetchWeatherDateString() -> String {
    return Date.dateFormatter20200201.string(from: self)
  }
  
  func fetchWeatherDateWithHourString() -> (String, String) {
  return (Date.dateFormatter20200201.string(from: self), Date.dateFormatterHour.string(from: self))
  }
  
  @nonobjc static var localFormatter: DateFormatter = {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateStyle = .medium
    dateStringFormatter.timeStyle = .medium
    return dateStringFormatter
  }()
  
  func localDateString() -> String
  {
    return Date.localFormatter.string(from: self)
  }
}
