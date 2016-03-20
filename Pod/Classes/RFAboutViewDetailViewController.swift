//
//  RFAboutViewDetailViewController.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 20/03/16.
//  Copyright (c) 2016 René Fouquet. All rights reserved.
//

import UIKit

public class RFAboutViewDetailViewController: UIViewController {
    public var tintColor: UIColor = .blackColor()
    public var backgroundColor: UIColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    public var showsScrollIndicator: Bool = true
    public var fontLicenseText: UIFont?
    public var textColor: UIColor = .blackColor()
    private var infoDict: [String:String]!
    
    public init(infoDictionary: [String:String]) {
        super.init(nibName: nil, bundle: nil)
        
        self.infoDict = infoDictionary
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = self.backgroundColor
        self.view.tintColor = self.tintColor
        
        self.navigationItem.title = self.infoDict.keys.first
        self.navigationController?.toolbarHidden = true
        
        let contentTextView = UITextView()
        contentTextView.frame = self.view.bounds
        contentTextView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        contentTextView.textContainerInset = UIEdgeInsetsMake(self.sizeForPercent(3.125), self.sizeForPercent(3.125), self.sizeForPercent(3.125), self.sizeForPercent(3.125))
        contentTextView.userInteractionEnabled = true
        contentTextView.selectable = true
        contentTextView.editable = false
        contentTextView.scrollEnabled = true
        contentTextView.showsHorizontalScrollIndicator = false
        contentTextView.showsVerticalScrollIndicator = self.showsScrollIndicator
        contentTextView.backgroundColor = .clearColor()
        contentTextView.spellCheckingType = .No
        contentTextView.textColor = self.textColor
        contentTextView.font = UIFont.systemFontOfSize(self.sizeForPercent(4.063), weight: -1)
        
        if let theFont = self.fontLicenseText {
            contentTextView.font = theFont
        }
        contentTextView.text = self.infoDict.values.first
        
        self.view.addSubview(contentTextView)
    }
}