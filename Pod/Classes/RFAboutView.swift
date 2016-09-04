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

public enum CloseButtonSide {
    case leftSide
    case rightSide
}

public class RFAboutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate {
    
    /// Tint color of the RFAboutViewController. Defaults to black color.
    public var tintColor = UIColor.blackColor()
    
    /// Background color of the RFAboutViewController. Defaults to a light gray color.
    public var backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    
    /// Color of the text in the header. Defaults to black color.
    public var headerTextColor = UIColor.blackColor()
    
    /// Border color of the header. Defaults to light gray color.
    public var headerBorderColor = UIColor.lightGrayColor()
    
    ///  Background color of the header. Defaults to white color.
    public var headerBackgroundColor = UIColor.whiteColor()
    
    /// Acknowledgements header text color. Defaults to black color.
    public var acknowledgementsHeaderColor = UIColor.blackColor()
    
    /// TableView background color. Defaults to white color.
    public var tableViewBackgroundColor = UIColor.whiteColor()
    
    /// Background Color of the selected tableview cell.
    public var tableViewSelectionColor: UIColor?
    
    /// TableView text color. Defaults to black color.
    public var tableViewTextColor = UIColor.blackColor()
    
    /// TableView separator color. Defaults to black color with alpha 0.5
    public var tableViewSeparatorColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    
    /// Background Color of the Navigation Bar.
    public var navigationViewBackgroundColor: UIColor?
    
    /// Bar Tint Color of the Navigation Bar.
    public var navigationBarBarTintColor: UIColor?
    
    /// Tint color of the Navigation Bar. Defaults to the view's default tint color.
    public var navigationBarTintColor: UIColor?
    
    /// Color of the Navigation Bar Title. Defaults to blackColor.
    public var navigationBarTitleTextColor = UIColor.blackColor()
    
    /// The background of the about header. Defaults to nil.
    public var headerBackgroundImage: UIImage?
    
    /// The image for the button to dismiss the RFAboutViewController. Defaults to image of "X".
    public var closeButtonImage = UIImage(named: "Frameworks/RFAboutView_Swift.framework/RFAboutView_Swift.bundle/RFAboutViewCloseX")
    
    /// Determines if the close button should be an image, or text.
    public var closeButtonAsImage = true
    
    /// The text of the close button, if not an image
    public var closeButtonText = NSLocalizedString("Close", comment:"Close button text")
    
    /// The position of the close button (left or right side)
    public var closeButtonSide: CloseButtonSide = .leftSide
    
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
    private var additionalButtons = [[String:String]]()
    private var scrollViewContainer: UIView!
    
    private var scrollViewContainerWidth: NSLayoutConstraint?
    private var additionalButtonsTableView: UITableView!
    private var acknowledgementsTableView: UITableView!
    
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
    public init(appName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String, appVersion: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String, appBuild: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String, copyrightHolderName: String? = "Developer", contactEmail: String? = nil, contactEmailTitle: String? = nil, websiteURL: NSURL? = nil, websiteURLTitle: String? = nil, pubYear: String? = String(NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: NSDate()).year)) {
        super.init(nibName: nil, bundle: nil)
        
        navigationViewBackgroundColor = navigationController?.view.backgroundColor // Set from system default
        navigationBarBarTintColor = navigationController?.navigationBar.barTintColor // Set from system default
        navigationBarTintColor = tintColor // Set from system default
        
        self.appName = appName ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
        self.appVersion = appVersion ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        self.appBuild = appBuild ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        self.contactEmail = contactEmail
        self.contactEmailTitle = contactEmailTitle ?? self.contactEmail
        self.copyrightHolderName = copyrightHolderName ?? "Developer"
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
        view.backgroundColor = backgroundColor
        view.tintColor = tintColor
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.view.backgroundColor = navigationViewBackgroundColor
        navigationController?.navigationBar.barTintColor = navigationBarBarTintColor
        navigationController?.navigationBar.tintColor = navigationBarTintColor
        
        if let ackFile = NSBundle.mainBundle().pathForResource(acknowledgementsFilename, ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: ackFile) {
                acknowledgements = reformatAcknowledgementsDictionary(dict)
            }
        }
        
        let mainScrollView = createMainScrollView()
        view.addSubview(mainScrollView)
        
        scrollViewContainer = createScrollViewContainer()
        mainScrollView.addSubview(scrollViewContainer)
        
        let headerView = createHeaderView()
        scrollViewContainer.addSubview(headerView)
        
        let headerBackground = createHeaderBackground(headerView: headerView)
        headerView.addSubview(headerBackground)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if headerBackgroundImage != nil {
            headerBackground.addSubview(visualEffectView)
        }
        
        let appNameLabel = createAndAddNameLabel(headerView: headerView)
        let copyrightInfo = createAndAddCopyrightLabel(headerView: headerView)
        
        let websiteButton = UIButton(type: .Custom)
        
        if let _ = websiteURL {
            var buttonFont = UIFont.systemFontOfSize(sizeForPercent(4.375), weight: -1)
            if let theFont = fontWebsiteButton {
                buttonFont = theFont
            }
            setupAndAddHeaderButton(websiteButton, title: websiteURLTitle, font: buttonFont, target: #selector(goToWebsite), headerView: headerView)
        }
        
        let eMailButton = UIButton(type: .Custom)
        
        if let _ = contactEmail {
            var buttonFont = UIFont.systemFontOfSize(sizeForPercent(4.375), weight: -1)
            if let theFont = fontEmailButton {
                buttonFont = theFont
            }
            setupAndAddHeaderButton(eMailButton, title: contactEmailTitle, font: buttonFont, target: #selector(email), headerView: headerView)
        }
        
        additionalButtonsTableView = createAndAddAdditionalButtonsTableView(scrollViewContainer: scrollViewContainer)
        
        let tableHeaderLabel = createAndAddTableHeaderLabel(scrollViewContainer: scrollViewContainer)
        
        acknowledgementsTableView = createAndAddAcknowledgementsTableView(scrollViewContainer: scrollViewContainer)
        
        setConstraints(mainScrollView: mainScrollView, scrollViewContainer: scrollViewContainer, headerView: headerView, appNameLabel: appNameLabel, copyrightInfo: copyrightInfo, eMailButton: eMailButton, websiteButton: websiteButton, tableHeaderLabel: tableHeaderLabel)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: navigationBarTitleTextColor]
    if navigationController?.viewControllers.first == self {
            var closeItem: UIBarButtonItem!
            
            if closeButtonAsImage {
                closeItem = UIBarButtonItem(image:closeButtonImage, style: .Plain, target: self, action: #selector(close))
            } else {
                closeItem = UIBarButtonItem(title: closeButtonText, style: .Plain, target: self, action: #selector(close))
            }
            
            if closeButtonSide == .leftSide {
                navigationItem.leftBarButtonItem = closeItem
            } else {
                navigationItem.rightBarButtonItem = closeItem
            }
        }

        navigationItem.title = NSLocalizedString("About", comment:"UINavigationBar Title")
    }
    
    //MARK:- UITableView Delegate & Data Source
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case additionalButtonsTableView:
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
            cell?.tintColor = tableViewTextColor
            
            cell?.textLabel?.font = UIFont.systemFontOfSize(sizeForPercent(4.688), weight: -1)
            
            if let theFont = fontTableCellText {
                cell?.textLabel?.font = theFont
            }
            cell?.selectionStyle = .Default
            
            if let cellBGColor = tableViewSelectionColor {
                let bgColorView = UIView()
                bgColorView.backgroundColor = cellBGColor
                cell?.selectedBackgroundView = bgColorView
            }
            
            var title = ""
            if tableView == additionalButtonsTableView {
                title = (additionalButtons[indexPath.row].keys.first)!
            } else {
                title = (acknowledgements[indexPath.row].keys.first)!
            }
            cell?.separatorInset = UIEdgeInsetsZero
            cell?.layoutMargins = UIEdgeInsetsZero
            cell?.textLabel?.textColor = tableViewTextColor
            cell?.backgroundColor = tableViewBackgroundColor
            cell?.textLabel!.text = title
            cell?.accessoryType = .DisclosureIndicator
        }
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
        var theDict = [String: String]()
        
        if tableView == additionalButtonsTableView {
            theDict = additionalButtons[indexPath.row]
        } else {
            theDict = acknowledgements[indexPath.row]
        }
        showDetailViewController(theDict)
    }
    
    
    private func showDetailViewController(infoDictionary: [String:String]) {
        let viewController = RFAboutViewDetailViewController(infoDictionary: infoDictionary)
        viewController.showsScrollIndicator = showsScrollIndicator
        viewController.backgroundColor = backgroundColor
        viewController.tintColor = tintColor
        viewController.fontLicenseText = fontLicenseText
        viewController.textColor = acknowledgementsHeaderColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func createMainScrollView() -> UIScrollView {
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.backgroundColor = .clearColor()
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = showsScrollIndicator
        return mainScrollView
    }
    
    private func createScrollViewContainer() -> UIView {
        let scrollViewContainer = UIView()
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.backgroundColor = .clearColor()
        return scrollViewContainer
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = headerBackgroundColor
        headerView.layer.borderColor = headerBorderColor.CGColor
        headerView.layer.borderWidth = 0.5
        headerView.clipsToBounds = true
        return headerView
    }
    
    private func createHeaderBackground(headerView headerView: UIView) -> UIImageView {
        let headerBackground = UIImageView()
        headerBackground.translatesAutoresizingMaskIntoConstraints = true
        headerBackground.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        headerBackground.image = headerBackgroundImage
        headerBackground.contentMode = .ScaleAspectFill
        headerBackground.frame = headerView.bounds
        return headerBackground
    }
    
    private func createAndAddNameLabel(headerView headerView: UIView) -> UILabel {
        let appNameLabel = UILabel()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.font = UIFont.systemFontOfSize(sizeForPercent(5.625), weight: -0.5)
        
        if let theFont = fontAppName {
            appNameLabel.font = theFont
        }
        
        appNameLabel.numberOfLines = 0
        appNameLabel.backgroundColor = .clearColor()
        appNameLabel.textAlignment = .Center
        appNameLabel.text = appName
        appNameLabel.textColor = headerTextColor
        headerView.addSubview(appNameLabel)
        appNameLabel.sizeToFit()
        appNameLabel.layoutIfNeeded()
        return appNameLabel
    }
    
    private func createAndAddCopyrightLabel(headerView headerView: UIView) -> UILabel {
        let copyrightInfo = UILabel()
        copyrightInfo.translatesAutoresizingMaskIntoConstraints = false
        copyrightInfo.font = UIFont.systemFontOfSize(sizeForPercent(4.375), weight: -1)
        
        if let theFont = fontCopyrightInfo {
            copyrightInfo.font = theFont
        }
        copyrightInfo.numberOfLines = 0
        copyrightInfo.backgroundColor = .clearColor()
        copyrightInfo.textAlignment = .Center
        copyrightInfo.text = "Version \(appVersion!) (\(appBuild!))\n © \(pubYear!) \(copyrightHolderName!)"
        copyrightInfo.textColor = headerTextColor
        headerView.addSubview(copyrightInfo)
        copyrightInfo.sizeToFit()
        copyrightInfo.layoutIfNeeded()
        return copyrightInfo
    }
    
    private func setupAndAddHeaderButton(button: UIButton, title: String?, font: UIFont, target: Selector, headerView: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(headerTextColor, forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = font
        button.addTarget(self, action: target, forControlEvents: .TouchUpInside)
        headerView.addSubview(button)
    }
    
    private func createAndAddAdditionalButtonsTableView(scrollViewContainer scrollViewContainer: UIView) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        tableView.separatorInset = UIEdgeInsetsZero
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        tableView.separatorColor = tableViewSeparatorColor
        tableView.backgroundColor = .clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = sizeForPercent(12.5)
        if additionalButtons.count > 0 {
            scrollViewContainer.addSubview(tableView)
        }
        return tableView
    }
    
    private func createAndAddTableHeaderLabel(scrollViewContainer scrollViewContainer: UIView) -> UILabel {
        let tableHeaderLabel = UILabel()
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.font = UIFont.systemFontOfSize(sizeForPercent(4.375), weight: -1)
        
        if let theFont = fontHeaderLabel {
            tableHeaderLabel.font = theFont
        }
        tableHeaderLabel.numberOfLines = 0
        tableHeaderLabel.textColor = acknowledgementsHeaderColor
        tableHeaderLabel.backgroundColor = .clearColor()
        tableHeaderLabel.textAlignment = .Left
        tableHeaderLabel.text = String(format: NSLocalizedString("%@ makes use of the following third party libraries. Many thanks to the developers making them available!", comment: "Acknowlegdments header title"), appName!)
        tableHeaderLabel.sizeToFit()
        tableHeaderLabel.layoutIfNeeded()
        
        if showAcknowledgements {
            scrollViewContainer.addSubview(tableHeaderLabel)
        }
        return tableHeaderLabel
    }
    
    private func createAndAddAcknowledgementsTableView(scrollViewContainer scrollViewContainer: UIView) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        tableView.separatorColor = tableViewSeparatorColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = sizeForPercent(12.5)
        if showAcknowledgements {
            scrollViewContainer.addSubview(tableView)
        }
        return tableView
    }
    
    private func setConstraints(mainScrollView mainScrollView: UIScrollView, scrollViewContainer: UIView, headerView: UIView, appNameLabel: UILabel, copyrightInfo: UILabel, eMailButton: UIButton, websiteButton: UIButton, tableHeaderLabel: UILabel) {
        /*
         A word of warning!
         Here comes all the Autolayout mess. Seriously, it's horrible. It's ugly, hard to follow and hard to maintain.
         But that'spretty much the only way to do it in code without external Autolayout wrappers like Masonry.
         Do yourself a favor and don't set up constraints like that if you can help it. You will save yourself a
         lot of headaches.
         */
        
        let currentScreenSize = UIScreen.mainScreen().bounds.size
        let padding = sizeForPercent(3.125)
        let tableViewHeight = sizeForPercent(12.5) * CGFloat(acknowledgements.count)
        let additionalButtonsTableHeight = sizeForPercent(12.5) * CGFloat(additionalButtons.count)
        
        metrics = ["padding":padding,
                   "doublePadding":padding * 2,
                   "tableViewHeight":tableViewHeight,
                   "additionalButtonsTableHeight":additionalButtonsTableHeight]
        
        let viewsDictionary = ["mainScrollView":mainScrollView,"scrollViewContainer":scrollViewContainer,"headerView":headerView,"appName":appNameLabel,"copyrightInfo":copyrightInfo,"eMailButton":eMailButton,"websiteButton":websiteButton,"tableHeaderLabel":tableHeaderLabel,"acknowledgementsTableView":acknowledgementsTableView,"additionalButtonsTable":additionalButtonsTableView]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainScrollView]|", options: [], metrics: metrics, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainScrollView]|", options: [], metrics: metrics, views: viewsDictionary))
        
        // We need to save the constraint to manually change the constant when the screen rotates:
        
        scrollViewContainerWidth = NSLayoutConstraint(item: scrollViewContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: currentScreenSize.width)
        
        mainScrollView.addConstraint(scrollViewContainerWidth!)
        
        mainScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollViewContainer]|", options: [], metrics: metrics, views: viewsDictionary))
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView]|", options: [], metrics: metrics, views: viewsDictionary))
        
        var firstFormatString = ""
        
        if additionalButtons.count > 0 {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[additionalButtonsTable]|", options: [], metrics: metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[additionalButtonsTable(==additionalButtonsTableHeight)]"
        }
        
        if showAcknowledgements {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[tableHeaderLabel]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[acknowledgementsTableView]|", options: [], metrics: metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[tableHeaderLabel]-padding-[acknowledgementsTableView(==tableViewHeight)]-doublePadding-"
        }
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(String(format: "V:|[headerView]%@|", firstFormatString), options: [], metrics: metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[appName]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[copyrightInfo]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
        
        var secondFormatString = ""
        
        if websiteURL != nil {
            headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[websiteButton]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            secondFormatString = secondFormatString+"-padding-[websiteButton]"
        }
        
        if contactEmail != nil {
            headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[eMailButton]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            
            if websiteURL != nil {
                secondFormatString = secondFormatString+"-0-[eMailButton]"
            } else {
                secondFormatString = secondFormatString+"-padding-[eMailButton]"
            }
        }
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(String(format:"V:|-doublePadding-[appName]-padding-[copyrightInfo]%@-doublePadding-|",secondFormatString), options: [], metrics: metrics, views: viewsDictionary))
    }
    
    
    //MARK:- Action methods
    
    public func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func goToWebsite() {
        if #available(iOS 9.0, *) {
            let webVC = SFSafariViewController(URL: websiteURL!)
            webVC.delegate = self
            presentViewController(webVC, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(websiteURL!)
        }
    }
    
    @available(iOS 9.0, *)
    public func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func email() {
        
        let iOSVersion = UIDevice.currentDevice().systemVersion as String
        let device = UIDevice.currentDevice().model as String
        let deviceString = platformModelString()
        let lang = NSLocale.preferredLanguages().first ?? ""
        var messageString = ""
        
        if includeDiagnosticInformationInEmail {
            messageString = String(format: NSLocalizedString("<p>[Please insert your message here]</p><p><em>For support inquiries, please include the following information. These make it easier for me to help you. Thank you!</em><p><hr><p><strong>Support Information</strong></p></p>%@ Version %@ (%@)<br>%@ (%@)<br>iOS %@ (%@)</p><hr>", comment: "Prefilled Email message text"),appName!, appVersion!, appBuild!, device, deviceString!, iOSVersion, lang)
        }
        
        let subject = "\(appName!) \(appVersion!)"
        
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            mailController.setSubject(subject)
            mailController.setMessageBody(messageString, isHTML: true)
            mailController.setToRecipients([contactEmail!])
            presentViewController(mailController, animated: true, completion: nil)
        } else {
            let supportText = "\"\(appName!) Version \(appVersion!) (\(appBuild!)), \(device) (\(deviceString!)), iOS \(iOSVersion) (\(lang))\""
            
            let alert = UIAlertController(title: NSLocalizedString("Cannot send Email", comment: "Cannot send Email"), message: String(format:NSLocalizedString("Unfortunately there are no Email accounts available on your device.\n\nFor support questions, please send an Email to %@ and include the following information: %@.\n\nTab the 'Copy info' button to copy this information to your pasteboard. Thank you!", comment: "Error message: no email accounts available"),contactEmail!, supportText, lang), preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss error message"), style:UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                alert.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
            let copyInfoAction = UIAlertAction(title: NSLocalizedString("Copy Info", comment: "Copy diagnostic info to pasteboard"), style:UIAlertActionStyle.Default, handler: { (action) -> Void in
                UIPasteboard.generalPasteboard().string = supportText
                alert.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(dismissAction)
            alert.addAction(copyInfoAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
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
        additionalButtons.append([title:content])
    }
    
    public func addAcknowledgement(title: String, content: String) {
        acknowledgements.append([title:content])
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
        scrollViewContainerWidth?.constant = size.width
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}
