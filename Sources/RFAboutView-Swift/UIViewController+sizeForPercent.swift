//
//  UIViewController+sizeForPercent.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 20/03/16.
//  Copyright (c) 2016 René Fouquet. All rights reserved.
//

import UIKit

extension UIViewController {
    func sizeForPercent(_ percent: CGFloat) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return ceil(((view.frame.size.width * 0.7) * (percent / 100)))
        } else {
            return ceil(view.frame.size.width * (percent / 100))
        }
    }
}
