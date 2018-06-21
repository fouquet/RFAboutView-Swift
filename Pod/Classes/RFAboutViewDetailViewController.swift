//
//  RFAboutViewDetailViewController.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 20/03/16.
//  Copyright (c) 2016 René Fouquet. All rights reserved.
//

import UIKit

open class RFAboutViewDetailViewController: UIViewController {
    open var tintColor = UIColor.black
    open var backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    open var showsScrollIndicator: Bool = true
    open var fontLicenseText: UIFont?
    open var textColor = UIColor.black
    private var infoDict: [String:String]!
    
    public init(infoDictionary: [String:String]) {
        super.init(nibName: nil, bundle: nil)
        infoDict = infoDictionary
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        
        view.backgroundColor = backgroundColor
        view.tintColor = tintColor
        
        navigationItem.title = infoDict.keys.first
        navigationController?.isToolbarHidden = true
        
        let contentTextView = UITextView()
        contentTextView.frame = view.bounds
        contentTextView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        contentTextView.textContainerInset = UIEdgeInsetsMake(sizeForPercent(3.125), sizeForPercent(3.125), sizeForPercent(3.125), sizeForPercent(3.125))
        contentTextView.isUserInteractionEnabled = true
        contentTextView.isSelectable = true
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = true
        contentTextView.showsHorizontalScrollIndicator = false
        contentTextView.showsVerticalScrollIndicator = showsScrollIndicator
        contentTextView.backgroundColor = UIColor.clear
        contentTextView.spellCheckingType = .no
        contentTextView.textColor = textColor
        contentTextView.font = UIFont.systemFont(ofSize: sizeForPercent(4.063), weight: -1)
        
        if let theFont = fontLicenseText {
            contentTextView.font = theFont
        }
        contentTextView.text = infoDict.values.first
        
        view.addSubview(contentTextView)
    }
}
