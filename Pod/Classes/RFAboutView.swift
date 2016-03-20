//
//  RFAboutView.swift
//  RFAboutView-Swift
//
//  Created by René Fouquet on 21/05/15.
//  Copyright (c) 2015 René Fouquet. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

public class RFAboutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate {
    
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
    public var closeButtonImage: UIImage? = UIImage(named: "Frameworks/RFAboutView_Swift.framework/RFAboutView_Swift.bundle/RFAboutViewCloseX")
    
    /// Determines if the header background image should be blurred. Defaults to true.
    public var blurHeaderBackground = true
    
    /// Effect style of the header blur. Defaults to UIBlurEffectStyleLight.
    public var blurStyle: UIBlurEffectStyle = .Light
    
    /// Determines if diagnostic information (app title, version, build, device etc.) should be included in the email when the user taps the email link. This information can be very useful to debug certain problems and can be deleted by the user if they don't want to send this information. Defaults to true.
    public var includeDiagnosticInformationInEmail = true
    
    /// Determines if the acknowledgements tableview should be shown. Defaults to true.
    public var showAcknowledgements = true
    
    /// Determines if the main scrollview should show a scroll indicator. Defaults to true.
    public var showsScrollIndicator = true
    
    /// File name of the acknowledgements plist *without* extension. Defaults to "Acknowledgements".
    public var acknowledgementsFilename = "Acknowledgements"
    
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
    
    /// Font used for the app name
    public var fontAppName: UIFont?
    
    /// Font used for the copyright information text
    public var fontCopyrightInfo: UIFont?
    
    /// Font used for the website button label
    public var fontWebsiteButton: UIFont?
    
    /// Font used for the email button label
    public var fontEmailButton: UIFont?
    
    /// Font used for the label on top of the "pods used" table
    public var fontHeaderLabel: UIFont?
    
    /// Font used for the "pods used" table cell label
    public var fontTableCellText: UIFont?
    
    /// Font used for the license text in the pod detail view
    public var fontLicenseText: UIFont?
    
    private var acknowledgements = [[String:String]]()
    private var metrics: [String:AnyObject]!
    private var scrollViewContainerWidth: NSLayoutConstraint?
    private var additionalButtons = [[String:String]]()

    private let additionalButtonsTable = UITableView(frame: .zero, style: .Grouped)
    private let acknowledgementsTableView = UITableView(frame: .zero, style: .Grouped)
    
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

        self.appName = appName ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
        self.appVersion = appVersion ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        self.appBuild = appBuild ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        self.contactEmail = contactEmail
        self.contactEmailTitle = contactEmailTitle ?? self.contactEmail
        self.copyrightHolderName = copyrightHolderName ?? "Some Developer"
        self.websiteURL = websiteURL
        self.websiteURLTitle = websiteURLTitle ?? self.websiteURL?.absoluteString
        self.pubYear = pubYear ?? String(NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: NSDate()).year)
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
            if let dict = NSDictionary(contentsOfFile: ackFile) {
                self.acknowledgements = self.reformatAcknowledgementsDictionary(dict)
            }
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
        appName.font = UIFont.systemFontOfSize(self.sizeForPercent(5.625), weight: -0.5)

        if let theFont = self.fontAppName {
            appName.font = theFont
        }
        
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
        copyrightInfo.font = UIFont.systemFontOfSize(self.sizeForPercent(4.375), weight: -1)

        if let theFont = self.fontCopyrightInfo {
            copyrightInfo.font = theFont
        }
        copyrightInfo.numberOfLines = 0
        copyrightInfo.backgroundColor = .clearColor()
        copyrightInfo.textAlignment = .Center
        copyrightInfo.text = String(format: "Version %@ (%@)\n© %@ %@", self.appVersion!, self.appBuild!, self.pubYear!, self.copyrightHolderName!) as String
        copyrightInfo.textColor = self.headerTextColor
        headerView.addSubview(copyrightInfo)
        copyrightInfo.sizeToFit()
        copyrightInfo.layoutIfNeeded()
        
        let websiteButton = UIButton(type: .Custom)
        
        if self.websiteURL != nil {
            websiteButton.translatesAutoresizingMaskIntoConstraints = false
            websiteButton.setTitle(self.websiteURLTitle, forState: .Normal)
            websiteButton.setTitleColor(self.headerTextColor, forState: .Normal)
            websiteButton.titleLabel?.font = UIFont.systemFontOfSize(self.sizeForPercent(4.375), weight: -1)

            if let theFont = self.fontWebsiteButton {
                websiteButton.titleLabel?.font = theFont
            }
            websiteButton.addTarget(self, action: "goToWebsite", forControlEvents: .TouchUpInside)
            headerView.addSubview(websiteButton)
        }
        
        let eMailButton = UIButton(type: .Custom)
        
        if self.contactEmail != nil {
            eMailButton.translatesAutoresizingMaskIntoConstraints = false
            eMailButton.setTitle(self.contactEmailTitle, forState: .Normal)
            eMailButton.setTitleColor(self.headerTextColor, forState: .Normal)
            eMailButton.titleLabel?.font = UIFont.systemFontOfSize(self.sizeForPercent(4.375), weight: -1)

            if let theFont = self.fontEmailButton {
                eMailButton.titleLabel?.font = theFont
            }
            eMailButton.addTarget(self, action: "email", forControlEvents: .TouchUpInside)
            headerView.addSubview(eMailButton)
        }

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
        tableHeaderLabel.font = UIFont.systemFontOfSize(self.sizeForPercent(4.375), weight: -1)

        if let theFont = self.fontHeaderLabel {
            tableHeaderLabel.font = theFont
        }
        tableHeaderLabel.numberOfLines = 0
        tableHeaderLabel.textColor = self.acknowledgementsHeaderColor
        tableHeaderLabel.backgroundColor = .clearColor()
        tableHeaderLabel.textAlignment = .Left
        tableHeaderLabel.text = NSLocalizedString(String(format: NSLocalizedString("%@ makes use of the following third party libraries. Many thanks to the developers making them available!", comment: "Acknowlegdments header title"), self.appName!) as String, comment: "Acknowlegdments header title")
        headerView.addSubview(tableHeaderLabel)
        tableHeaderLabel.sizeToFit()
        tableHeaderLabel.layoutIfNeeded()
        
        if self.showAcknowledgements {
            scrollViewContainer.addSubview(tableHeaderLabel)
        }

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
        if self.navigationController?.viewControllers.first == self {
            let leftItem = UIBarButtonItem(image:self.closeButtonImage, style: .Plain, target: self, action: Selector("close"))
            self.navigationItem.leftBarButtonItem = leftItem
        }
        self.navigationItem.title = NSLocalizedString("About", comment:"UINavigationBar Title")
    }
    
    //MARK:- UITableView Delegate & Data Source
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case additionalButtonsTable:
            return additionalButtons.count
        case acknowledgementsTableView:
            return acknowledgements.count
        default:
            return 0
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell==nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            cell?.textLabel?.font = UIFont.systemFontOfSize(self.sizeForPercent(4.688), weight: -1)

            if let theFont = self.fontTableCellText {
                cell?.textLabel?.font = theFont
            }
            cell?.selectionStyle = .Default
            
            if let cellBGColor = self.tableViewSelectionColor {
                let bgColorView = UIView()
                bgColorView.backgroundColor = cellBGColor
                cell?.selectedBackgroundView = bgColorView
            }
            
            var title = ""
            if tableView == additionalButtonsTable {
                title = (self.additionalButtons[indexPath.row].keys.first)!
            } else {
                title = (self.acknowledgements[indexPath.row].keys.first)!
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
        
        var theDict: [String: String]?
        
        if tableView == additionalButtonsTable {
            theDict = self.additionalButtons[indexPath.row]
        } else {
            theDict = self.acknowledgements[indexPath.row]
        }
        let viewController = RFAboutViewDetailViewController(infoDictionary: theDict)
        viewController.showsScrollIndicator = self.showsScrollIndicator
        viewController.backgroundColor = self.backgroundColor
        viewController.tintColor = self.tintColor
        viewController.fontLicenseText = self.fontLicenseText
        viewController.textColor = self.acknowledgementsHeaderColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- Action methods
    
    public func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func goToWebsite() {
        if #available(iOS 9.0, *) {
            let webVC = SFSafariViewController(URL: self.websiteURL!)
            webVC.delegate = self
            self.presentViewController(webVC, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(self.websiteURL!)
        }
    }
    
    @available(iOS 9.0, *)
    public func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func email() {
        
        let iOSVersion = UIDevice.currentDevice().systemVersion as String
        let device = UIDevice.currentDevice().model as String
        let deviceString = self.platformModelString()
        let lang = NSLocale.preferredLanguages().first ?? ""
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
        self.additionalButtons.append([title:content])
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
    
    private func reformatAcknowledgementsDictionary(originalDict: NSDictionary) -> [[String: String]] {
        let tmp: NSMutableArray = originalDict.objectForKey("PreferenceSpecifiers")?.mutableCopy() as AnyObject! as! NSMutableArray
        
        tmp.removeObjectAtIndex(0)
        tmp.removeLastObject()
        
        var outputArray = [[String:String]]()
        
        for innerDict: AnyObject in tmp {
            if let tempTitle = innerDict.objectForKey("Title") as! String!, let tempContent = innerDict.objectForKey("FooterText") as! String! {
                outputArray.append([tempTitle:tempContent])
            }
        }
        return outputArray
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
    public var fontLicenseText: UIFont?
    public var textColor: UIColor = .blackColor()
    private var infoDict: NSDictionary = NSDictionary()
    
    convenience public init() {
        self.init(infoDictionary: nil)
    }
    
    public init(infoDictionary: NSDictionary?) {
        super.init(nibName: nil, bundle: nil)
        
        self.infoDict = infoDictionary!
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        contentTextView.textColor = self.textColor
        contentTextView.font = UIFont.systemFontOfSize(self.sizeForPercent(4.063), weight: -1)

        if let theFont = self.fontLicenseText {
            contentTextView.font = theFont
        }
        contentTextView.text = self.infoDict["content"] as! String!
        
        self.view.addSubview(contentTextView)
    }
}