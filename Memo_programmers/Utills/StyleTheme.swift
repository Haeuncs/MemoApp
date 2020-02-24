//
//  StyleTheme.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@available(iOS 12.0, *)
enum SystemTheme {
    static func get(on view: UIView) -> UIUserInterfaceStyle {
        view.traitCollection.userInterfaceStyle
    }

    static func observe(on view: UIView) -> Observable<UIUserInterfaceStyle> {
        view.rx.methodInvoked(#selector(UIView.traitCollectionDidChange(_:)))
            .map { _ in SystemTheme.get(on: view) }
            .distinctUntilChanged()
    }
}
