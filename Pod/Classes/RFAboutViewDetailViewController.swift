//
//  RFAboutViewDetailViewController.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 20/03/16.
//  Copyright (c) 2016 René Fouquet. All rights reserved.
//

import UIKit

public class RFAboutViewDetailViewController: UIViewController {
    public var tintColor = UIColor.blackColor()
    public var backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    public var showsScrollIndicator: Bool = true
    public var fontLicenseText: UIFont?
    public var textColor = UIColor.blackColor()
    private var infoDict: [String:String]!
    
    public init(infoDictionary: [String:String]) {
        super.init(nibName: nil, bundle: nil)
        infoDict = infoDictionary
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        view.backgroundColor = backgroundColor
        view.tintColor = tintColor
        
        navigationItem.title = infoDict.keys.first
        navigationController?.toolbarHidden = true
        
        let contentTextView = UITextView()
        contentTextView.frame = view.bounds
        contentTextView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        contentTextView.textContainerInset = UIEdgeInsetsMake(sizeForPercent(3.125), sizeForPercent(3.125), sizeForPercent(3.125), sizeForPercent(3.125))
        contentTextView.userInteractionEnabled = true
        contentTextView.selectable = true
        contentTextView.editable = false
        contentTextView.scrollEnabled = true
        contentTextView.showsHorizontalScrollIndicator = false
        contentTextView.showsVerticalScrollIndicator = showsScrollIndicator
        contentTextView.backgroundColor = .clearColor()
        contentTextView.spellCheckingType = .No
        contentTextView.textColor = textColor
        contentTextView.font = UIFont.systemFontOfSize(sizeForPercent(4.063), weight: -1)
        
        if let theFont = fontLicenseText {
            contentTextView.font = theFont
        }
        contentTextView.text = infoDict.values.first
        
        view.addSubview(contentTextView)
    }
}