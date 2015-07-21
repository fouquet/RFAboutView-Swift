//
//  RFAboutView.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 21/05/15.
//  Copyright (c) 2015 René Fouquet. All rights reserved.
//

import UIKit
import MessageUI

public class RFAboutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    /// Tint color of the RFAboutViewController. Defaults to black color.
    public var tintColor: UIColor = .blackColor()
    
    /// Background color of the RFAboutViewController. Defaults to a light gray color.
    public var backgroundColor: UIColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    
    /// Color of the text in the header. Defaults to black color.
    public var headerTextColor: UIColor = .blackColor()
    
    /// Border color of the header. Defaults to light gray color.
    public var headerBorderColor: UIColor = .lightGrayColor()
    
    ///  Background color of the header. Defaults to white color.
    public var headerBackgroundColor: UIColor = .whiteColor()
    
    /// Acknowledgements header text color. Defaults to black color.
    public var acknowledgementsHeaderColor: UIColor = .blackColor()
    
    /// TableView background color. Defaults to white color.
    public var tableViewBackgroundColor: UIColor = .whiteColor()
    
    /// Background Color of the selected tableview cell.
    public var tableViewSelectionColor: UIColor?
    
    /// TableView text color. Defaults to black color.
    public var tableViewTextColor: UIColor = .blackColor()
    
    /// Background Color of the Navigation Bar.
    public var navigationViewBackgroundColor: UIColor?
    
    /// Bar Tint Color of the Navigation Bar.
    public var navigationBarBarTintColor: UIColor?
    
    /// Tint color of the Navigation Bar. Defaults to the view's default tint color.
    public var navigationBarTintColor: UIColor?
    
    /// Color of the Navigation Bar Title. Defaults to blackColor.
    public var navigationBarTitleTextColor: UIColor = .blackColor()
    
    /// The background of the about header. Defaults to nil.
    public var headerBackgroundImage: UIImage?
    
    /// The image for the button to dismiss the RFAboutViewController. Defaults to image of "X".
    public var closeButtonImage: UIImage? = UIImage(named: "RFAboutView_Swift.bundle/RFAboutViewCloseX")
    
    /// Determines if the header background image should be blurred. Defaults to true.
    public var blurHeaderBackground: Bool = true
    
    /// Effect style of the header blur. Defaults to UIBlurEffectStyleLight.
    public var blurStyle: UIBlurEffectStyle = .Light
    
    /// Determines if diagnostic information (app title, version, build, device etc.) should be included in the email when the user taps the email link. This information can be very useful to debug certain problems and can be deleted by the user if they don't want to send this information. Defaults to true.
    public var includeDiagnosticInformationInEmail: Bool = true
    
    /// Determines if the acknowledgements tableview should be shown. Defaults to true.
    public var showAcknowledgements: Bool = true
    
    /// Determines if the main scrollview should show a scroll indicator. Defaults to true.
    public var showsScrollIndicator: Bool = true
    
    /// File name of the acknowledgements plist *without* extension. Defaults to "Acknowledgements".
    public var acknowledgementsFilename: String = "Acknowledgements"
    
    /// The name of the app. Leave nil to use the CFBundleName.
    public var appName: String?
    
    /// The current version of the app. Leave nil to use CFBundleShortVersionString.
    public var appVersion: String?
    
    /// The current build of the app. Leave nil to use CFBundleVersion.
    public var appBuild: String?
    
    /// The name of the person or entity who should appear as the copyright holder.
    public var copyrightHolderName: String?
    
    /// The email address users can send inquiries to (for example a support email address). Leave nil to skip.
    public var contactEmail: String?
    
    /// The text to use for the email link. Leave nil to use the email address as text.
    public var contactEmailTitle: String?
    
    /// The URL for the website link. Leave nil to skip.
    public var websiteURL: NSURL?
    
    /// The title for the website link. Leave nil to use the website URL.
    public var websiteURLTitle: String?
    
    /// The year the app's version was published. Used in the copyright text. Leave nil to use the current year.
    public var pubYear: String?
    
    private var acknowledgements: NSArray = NSArray()
    private var metrics: Dictionary <String,NSObject> = Dictionary()
    private var scrollViewContainerWidth: NSLayoutConstraint?
    private var additionalButtons: NSMutableArray = NSMutableArray()
    
    convenience public init() {
        self.init(appName: nil, appVersion: nil, appBuild: nil, copyrightHolderName: nil, contactEmail: nil, contactEmailTitle: nil, websiteURL: nil, websiteURLTitle: nil, pubYear: nil)
    }
    
    /**
    Initializes the RFAboutViewController with the given parameters.
    
    - parameter appName:             The name of the app. Leave nil to use the CFBundleName.
    - parameter appVersion:          The current version of the app. Leave nil to use CFBundleShortVersionString.
    - parameter appBuild:            The current build of the app. Leave nil to use CFBundleVersion.
    - parameter copyrightHolderName: The name of the person or entity who should appear as the copyright holder.
    - parameter contactEmail:        The email address users can send inquiries to (for example a support email address). Leave nil to skip.
    - parameter contactEmailTitle:   The text to use for the email link. Leave nil to use the email address as text.
    - parameter websiteURL:          The URL for the website link. Leave nil to skip.
    - parameter websiteURLTitle:     The title for the website link. Leave nil to use the website URL.
    - parameter pubYear:             The year the app's version was published. Used in the copyright text. Leave nil to use the current year.
    
    - returns:  RFAboutViewController instance
    */
    public init(appName: String?, appVersion: String?, appBuild: String?, copyrightHolderName: String?, contactEmail: String?, contactEmailTitle: String?, websiteURL: NSURL?, websiteURLTitle: String?, pubYear: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationViewBackgroundColor = self.navigationController?.view.backgroundColor // Set from system default
        self.navigationBarBarTintColor = self.navigationController?.navigationBar.barTintColor // Set from system default
        self.navigationBarTintColor = self.tintColor // Set from system default
        
        self.appName = appName;
        self.appVersion = appVersion;
        self.appBuild = appBuild;
        self.contactEmail = contactEmail;
        self.contactEmailTitle = contactEmailTitle;
        self.websiteURLTitle = websiteURLTitle;
        self.copyrightHolderName = copyrightHolderName;
        self.websiteURL = websiteURL;
        
        if appName == nil {
            self.appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String!
        }
        if appVersion == nil {
            self.appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String!
        }
        if appBuild == nil {
            self.appBuild = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String!
        }
        if contactEmailTitle == nil {
            self.contactEmailTitle = self.contactEmail
        }
        if copyrightHolderName == nil {
            self.copyrightHolderName = "Some Developer"
        }
        if websiteURLTitle == nil {
            self.websiteURLTitle = self.websiteURL?.absoluteString
        }
        if pubYear == nil {
            self.pubYear = String(NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: NSDate()).year)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        // Set up the view
        self.view.backgroundColor = self.backgroundColor
        self.view.tintColor = self.tintColor
        self.navigationItem.leftBarButtonItem?.tintColor = self.tintColor
        self.navigationController?.view.backgroundColor = self.navigationViewBackgroundColor
        self.navigationController?.navigationBar.barTintColor = self.navigationBarBarTintColor
        self.navigationController?.navigationBar.tintColor = self.navigationBarTintColor
        
        if let ackFile = NSBundle.mainBundle().pathForResource(self.acknowledgementsFilename, ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: ackFile)
            self.acknowledgements = self.reformatAcknowledgementsDictionary(dict)
        }
        
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.backgroundColor = .clearColor()
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = self.showsScrollIndicator
        self.view.addSubview(mainScrollView)
        
        let scrollViewContainer = UIView()
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.backgroundColor = .clearColor()
        mainScrollView.addSubview(scrollViewContainer)
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = self.headerBackgroundColor
        headerView.layer.borderColor = self.headerBorderColor.CGColor
        headerView.layer.borderWidth = 0.5
        headerView.clipsToBounds = true
        scrollViewContainer.addSubview(headerView)
        
        let headerBackground = UIImageView()
        headerBackground.translatesAutoresizingMaskIntoConstraints = true
        headerBackground.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        headerBackground.image = self.headerBackgroundImage
        headerBackground.contentMode = .ScaleAspectFill
        headerBackground.frame = headerView.bounds
        headerView.addSubview(headerBackground)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: self.blurStyle))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if self.headerBackgroundImage != nil {
            headerBackground.addSubview(visualEffectView)
        }
        
        let appName = UILabel()
        appName.translatesAutoresizingMaskIntoConstraints = false
        appName.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(5.625))
        appName.numberOfLines = 0
        appName.backgroundColor = .clearColor()
        appName.textAlignment = .Center
        appName.text = self.appName
        appName.textColor = self.headerTextColor
        headerView.addSubview(appName)
        appName.sizeToFit()
        appName.layoutIfNeeded()
        
        let copyrightInfo = UILabel()
        copyrightInfo.translatesAutoresizingMaskIntoConstraints = false
        copyrightInfo.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(4.375))
        copyrightInfo.numberOfLines = 0
        copyrightInfo.backgroundColor = .clearColor()
        copyrightInfo.textAlignment = .Center
        copyrightInfo.text = String(format: "Version %@ (%@)\n© %@ %@", self.appVersion!, self.appBuild!, self.pubYear!, self.copyrightHolderName!) as String
        copyrightInfo.textColor = self.headerTextColor
        headerView.addSubview(copyrightInfo)
        copyrightInfo.sizeToFit()
        copyrightInfo.layoutIfNeeded()
        
        let websiteButton = UIButton(type: .Custom) as UIButton
        
        if self.websiteURL != nil {
            websiteButton.translatesAutoresizingMaskIntoConstraints = false
            websiteButton.setTitle(self.websiteURLTitle, forState: .Normal)
            websiteButton.setTitleColor(self.headerTextColor, forState: .Normal)
            websiteButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(4.375))
            websiteButton.addTarget(self, action: "goToWebsite", forControlEvents: .TouchUpInside)
            headerView.addSubview(websiteButton)
        }
        
        let eMailButton = UIButton(type: .Custom) as UIButton
        
        if self.contactEmail != nil {
            eMailButton.translatesAutoresizingMaskIntoConstraints = false
            eMailButton.setTitle(self.contactEmailTitle, forState: .Normal)
            eMailButton.setTitleColor(self.headerTextColor, forState: .Normal)
            eMailButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(4.375))
            eMailButton.addTarget(self, action: "email", forControlEvents: .TouchUpInside)
            headerView.addSubview(eMailButton)
        }
        
        let additionalButtonsTable = UITableView(frame: CGRectZero, style: .Grouped)
        additionalButtonsTable.tag = 0
        additionalButtonsTable.translatesAutoresizingMaskIntoConstraints = false
        additionalButtonsTable.clipsToBounds = false
        additionalButtonsTable.delegate = self
        additionalButtonsTable.dataSource = self
        additionalButtonsTable.scrollEnabled = false
        additionalButtonsTable.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        additionalButtonsTable.backgroundColor = .clearColor()
        additionalButtonsTable.rowHeight = UITableViewAutomaticDimension
        additionalButtonsTable.estimatedRowHeight = self.sizeForPercent(12.5)
        if self.additionalButtons.count > 0 {
            scrollViewContainer.addSubview(additionalButtonsTable)
        }
        
        let tableHeaderLabel = UILabel()
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(4.375))
        tableHeaderLabel.numberOfLines = 0
        tableHeaderLabel.textColor = self.acknowledgementsHeaderColor
        tableHeaderLabel.backgroundColor = .clearColor()
        tableHeaderLabel.textAlignment = .Left
        tableHeaderLabel.text = NSLocalizedString(String(format: "%@ makes use of the following third party libraries. Many thanks to the developers making them available!",self.appName!) as String, comment: "Acknowlegdments header title")
        headerView.addSubview(tableHeaderLabel)
        tableHeaderLabel.sizeToFit()
        tableHeaderLabel.layoutIfNeeded()
        
        if self.showAcknowledgements {
            scrollViewContainer.addSubview(tableHeaderLabel)
        }
        
        let acknowledgementsTableView = UITableView(frame: CGRectZero, style: .Grouped)
        acknowledgementsTableView.tag = 1
        acknowledgementsTableView.translatesAutoresizingMaskIntoConstraints = false
        acknowledgementsTableView.clipsToBounds = false
        acknowledgementsTableView.delegate = self
        acknowledgementsTableView.dataSource = self
        acknowledgementsTableView.scrollEnabled = false
        acknowledgementsTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        acknowledgementsTableView.backgroundColor = .clearColor()
        acknowledgementsTableView.rowHeight = UITableViewAutomaticDimension
        acknowledgementsTableView.estimatedRowHeight = self.sizeForPercent(12.5)
        if self.showAcknowledgements {
            scrollViewContainer.addSubview(acknowledgementsTableView)
        }
        
        /*
        A word of warning!
        Here comes all the Autolayout mess. Seriously, it's horrible. It's ugly, hard to follow and hard to maintain.
        But that'spretty much the only way to do it in code without external Autolayout wrappers like Masonry.
        Do yourself a favor and don't set up constraints like that if you can help it. You will save yourself a
        lot of headaches.
        */
        
        let currentScreenSize = UIScreen.mainScreen().bounds.size
        let padding = self.sizeForPercent(3.125)
        let tableViewHeight = self.sizeForPercent(12.5) * CGFloat(self.acknowledgements.count)
        let additionalButtonsTableHeight = self.sizeForPercent(12.5) * CGFloat(self.additionalButtons.count)
        
        self.metrics = ["padding":padding,
            "doublePadding":padding * 2,
            "tableViewHeight":tableViewHeight,
            "additionalButtonsTableHeight":additionalButtonsTableHeight]
        
        let viewsDictionary = ["mainScrollView":mainScrollView,"scrollViewContainer":scrollViewContainer,"headerView":headerView,"appName":appName,"copyrightInfo":copyrightInfo,"eMailButton":eMailButton,"websiteButton":websiteButton,"tableHeaderLabel":tableHeaderLabel,"acknowledgementsTableView":acknowledgementsTableView,"additionalButtonsTable":additionalButtonsTable]

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainScrollView]|", options: [], metrics: self.metrics, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainScrollView]|", options: [], metrics: self.metrics, views: viewsDictionary))
        
        // We need to save the constraint to manually change the constant when the screen rotates:
        
        self.scrollViewContainerWidth = NSLayoutConstraint(item: scrollViewContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: currentScreenSize.width)
        
        mainScrollView.addConstraint(self.scrollViewContainerWidth!)
        
        mainScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollViewContainer]|", options: [], metrics: self.metrics, views: viewsDictionary))
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView]|", options: [], metrics: self.metrics, views: viewsDictionary))
        
        var firstFormatString = ""
        
        if self.additionalButtons.count > 0 {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[additionalButtonsTable]|", options: [], metrics: self.metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[additionalButtonsTable(==additionalButtonsTableHeight)]"
        }
        
        if self.showAcknowledgements {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[tableHeaderLabel]-padding-|", options: [], metrics: self.metrics, views: viewsDictionary))
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[acknowledgementsTableView]|", options: [], metrics: self.metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[tableHeaderLabel]-padding-[acknowledgementsTableView(==tableViewHeight)]-doublePadding-"
        }
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(String(format: "V:|[headerView]%@|", firstFormatString), options: [], metrics: self.metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[appName]-padding-|", options: [], metrics: self.metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[copyrightInfo]-padding-|", options: [], metrics: self.metrics, views: viewsDictionary))
        
        var secondFormatString = ""
        
        if self.websiteURL != nil {
            headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[websiteButton]-padding-|", options: [], metrics: self.metrics, views: viewsDictionary))
            secondFormatString = secondFormatString+"-padding-[websiteButton]"
        }
        
        if self.contactEmail != nil {
            headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[eMailButton]-padding-|", options: [], metrics: self.metrics, views: viewsDictionary))
            
            if self.websiteURL != nil {
                secondFormatString = secondFormatString+"-0-[eMailButton]"
            } else {
                secondFormatString = secondFormatString+"-padding-[eMailButton]"
            }
        }
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(String(format:"V:|-doublePadding-[appName]-padding-[copyrightInfo]%@-doublePadding-|",secondFormatString), options: [], metrics: self.metrics, views: viewsDictionary))
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : self.navigationBarTitleTextColor
        ]
        
        let leftItem = UIBarButtonItem(image:self.closeButtonImage, style: .Plain, target: self, action: Selector("close"))
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.title = NSLocalizedString("About", comment:"UINavigationBar Title")
    }
    
    //MARK:- UITableView Delegate & Data Source
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.additionalButtons.count
        } else {
            return self.acknowledgements.count
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        if cell==nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: self.sizeForPercent(4.688))
            cell?.selectionStyle = .Default
            
            if let cellBGColor = self.tableViewSelectionColor {
                let bgColorView = UIView()
                bgColorView.backgroundColor = cellBGColor
                cell?.selectedBackgroundView = bgColorView
            }
            
            var title = ""
            if tableView.tag == 0 {
                title = (self.additionalButtons[indexPath.row].valueForKey("title") as? String)!
            } else {
                title = (self.acknowledgements[indexPath.row].valueForKey("title") as? String)!
            }
            cell?.textLabel?.textColor = self.tableViewTextColor
            cell?.backgroundColor = self.tableViewBackgroundColor
            cell?.textLabel!.text = title
            cell?.accessoryType = .DisclosureIndicator
        }
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
        var theDict: NSDictionary? = nil
        
        if tableView.tag == 0 {
            theDict = self.additionalButtons[indexPath.row] as? NSDictionary
        } else {
            theDict = self.acknowledgements[indexPath.row] as? NSDictionary
        }
        let viewController = RFAboutViewDetailViewController(infoDictionary: theDict)
        viewController.showsScrollIndicator = self.showsScrollIndicator
        viewController.backgroundColor = self.backgroundColor
        viewController.tintColor = self.tintColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- Action methods
    
    public func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func goToWebsite() {
        UIApplication.sharedApplication().openURL(self.websiteURL!)
    }
    
    public func email() {
        
        let iOSVersion = "" // UIDevice.currentDevice().model as String
        let device = "" // UIDevice.currentDevice().model as String
        let deviceString = self.platformModelString()
        let lang = NSLocale.preferredLanguages().first as String!
        var messageString = ""
        
        if self.includeDiagnosticInformationInEmail {
            messageString = String(format: NSLocalizedString("<p>[Please insert your message here]</p><p><em>For support inquiries, please include the following information. These make it easier for me to help you. Thank you!</em><p><hr><p><strong>Support Information</strong></p></p>%@ Version %@ (%@)<br>%@ (%@)<br>iOS %@ (%@)</p><hr>", comment: "Prefilled Email message text"),self.appName!, self.appVersion!, self.appBuild!, device, deviceString!, iOSVersion, lang)
        }
        
        let subject = String(format: "%@ %@", self.appName!, self.appVersion!)
        
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            mailController.setSubject(subject)
            mailController.setMessageBody(messageString, isHTML: true)
            mailController.setToRecipients([self.contactEmail!])
            self.presentViewController(mailController, animated: true, completion: nil)
        } else {
            let supportText = String(format: "\"%@ Version %@ (%@), %@ (%@), iOS %@ (%@)\"",self.appName!, self.appVersion!, self.appBuild!, device, deviceString!, iOSVersion, lang)
            
            let alert = UIAlertController(title: NSLocalizedString("Cannot send Email", comment: "Cannot send Email"), message: String(format:NSLocalizedString("Unfortunately there are no Email accounts available on your device.\n\nFor support questions, please send an Email to %@ and include the following information: %@.\n\nTab the 'Copy info' button to copy this information to your pasteboard. Thank you!", comment: "Error message: no email accounts available"),self.contactEmail!, supportText, lang), preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss error message"), style:UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                alert.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
            let copyInfoAction = UIAlertAction(title: NSLocalizedString("Copy Info", comment: "Copy diagnostic info to pasteboard"), style:UIAlertActionStyle.Default, handler: { (action) -> Void in
                UIPasteboard.generalPasteboard().string = supportText
                alert.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(dismissAction)
            alert.addAction(copyInfoAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if result.rawValue == MFMailComposeResultFailed.rawValue {
                let alert = UIAlertController(title: NSLocalizedString("Message Failed!", comment: "Sending email message failed"), message: NSLocalizedString("Your email has failed to send.", comment: "Sending email message failed body"), preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss error message"), style:UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    alert.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    /**
    Adds an additional button (as a TableView cell) below the header. Use it to supply further information, like TOS, Privacy Policy etc.
    
    - parameter title:   The title of the button
    - parameter content: The text to display in the detail view
    */
    public func addAdditionalButton(title: String, content: String) {
        self.additionalButtons.addObject(["title":title,"content":content])
    }
    
    //MARK:- Helper functions
    
    /*!
    *  Gets the raw platform id (e.g. iPhone7,1)
    *  Mad props to http://stackoverflow.com/questions/25467082/using-sysctlbyname-from-swift
    */
    
    private func platformModelString() -> String? {
        if let key = "hw.machine".cStringUsingEncoding(NSUTF8StringEncoding) {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            var machine = [CChar](count: Int(size), repeatedValue: 0)
            sysctlbyname(key, &machine, &size, nil, 0)
            return String.fromCString(machine)!
        }
        return nil
    }
    
    private func sizeForPercent(percent: CGFloat) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return ceil(((self.view.frame.size.width * 0.7) * (percent / 100)))
        } else {
            return ceil(self.view.frame.size.width * (percent / 100))
        }
    }
    
    private func reformatAcknowledgementsDictionary(originalDict: NSDictionary?) -> NSArray {
        let tmp: NSMutableArray = originalDict?.objectForKey("PreferenceSpecifiers") as AnyObject! as! NSMutableArray
        
        let theDict = tmp.mutableCopy() as! NSMutableArray
        
        theDict.removeObjectAtIndex(0)
        theDict.removeLastObject()
        
        let outputArray = NSMutableArray()
        
        for innerDict: AnyObject in theDict {
            if let tempTile = innerDict.objectForKey("Title") as! String!, let tempContent = innerDict.objectForKey("FooterText") as! String! {
                outputArray.addObject(["title":tempTile,"content":tempContent])
            }
        }
        return outputArray;
    }
    
    //MARK:- Autorotation
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.scrollViewContainerWidth?.constant = size.width
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

public class RFAboutViewDetailViewController: UIViewController {
    public var tintColor: UIColor = .blackColor()
    public var backgroundColor: UIColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    public var showsScrollIndicator: Bool = true
    private var infoDict: NSDictionary = NSDictionary()
    
    convenience public init() {
        self.init(infoDictionary: nil)
    }
    
    public init(infoDictionary: NSDictionary?) {
        super.init(nibName: nil, bundle: nil)
        
        self.infoDict = infoDictionary!
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = self.backgroundColor
        self.view.tintColor = self.tintColor
        
        self.navigationItem.title = self.infoDict["title"] as! String!
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
        contentTextView.font = UIFont(name: "HelveticaNeue-Light", size:self.sizeForPercent(4.063))
        
        contentTextView.text = self.infoDict["content"] as! String!
        
        self.view.addSubview(contentTextView)
    }
    
    private func sizeForPercent(percent: CGFloat) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return ceil(((self.view.frame.size.width * 0.7) * (percent / 100)))
        } else {
            return ceil(self.view.frame.size.width * (percent / 100))
        }
    }
    
}