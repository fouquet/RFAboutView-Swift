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

open class RFAboutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate {
    
    /// Tint color of the RFAboutViewController. Defaults to black color.
    open var tintColor = UIColor.black
    
    /// Background color of the RFAboutViewController. Defaults to a light gray color.
    open var backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    
    /// Color of the text in the header. Defaults to black color.
    open var headerTextColor = UIColor.black
    
    /// Border color of the header. Defaults to light gray color.
    open var headerBorderColor = UIColor.lightGray
    
    ///  Background color of the header. Defaults to white color.
    open var headerBackgroundColor = UIColor.white
    
    /// Acknowledgements header text color. Defaults to black color.
    open var acknowledgementsHeaderColor = UIColor.black
    
    /// TableView background color. Defaults to white color.
    open var tableViewBackgroundColor = UIColor.white
    
    /// Background Color of the selected tableview cell.
    open var tableViewSelectionColor: UIColor?
    
    /// TableView text color. Defaults to black color.
    open var tableViewTextColor = UIColor.black
    
    /// TableView separator color. Defaults to black color with alpha 0.5
    open var tableViewSeparatorColor = UIColor.black.withAlphaComponent(0.5)
    
    /// Background Color of the Navigation Bar.
    open var navigationViewBackgroundColor: UIColor?
    
    /// Bar Tint Color of the Navigation Bar.
    open var navigationBarBarTintColor: UIColor?
    
    /// Tint color of the Navigation Bar. Defaults to the view's default tint color.
    open var navigationBarTintColor: UIColor?
    
    /// Color of the Navigation Bar Title. Defaults to blackColor.
    open var navigationBarTitleTextColor = UIColor.black
    
    /// The background of the about header. Defaults to nil.
    open var headerBackgroundImage: UIImage?
    
    /// The image for the button to dismiss the RFAboutViewController. Defaults to image of "X".
    open var closeButtonImage = UIImage(named: "Frameworks/RFAboutView_Swift.framework/RFAboutView_Swift.bundle/RFAboutViewCloseX")
    
    /// Determines if the close button should be an image, or text.
    open var closeButtonAsImage = true
    
    /// The text of the close button, if not an image
    open var closeButtonText = NSLocalizedString("Close", comment:"Close button text")
    
    /// The position of the close button (left or right side)
    open var closeButtonSide: CloseButtonSide = .leftSide
    
    /// Determines if the header background image should be blurred. Defaults to true.
    open var blurHeaderBackground = true
    
    /// Effect style of the header blur. Defaults to UIBlurEffectStyleLight.
    open var blurStyle: UIBlurEffectStyle = .light
    
    /// Determines if diagnostic information (app title, version, build, device etc.) should be included in the email when the user taps the email link. This information can be very useful to debug certain problems and can be deleted by the user if they don't want to send this information. Defaults to true.
    open var includeDiagnosticInformationInEmail = true
    
    /// Determines if the acknowledgements tableview should be shown. Defaults to true.
    open var showAcknowledgements = true
    
    /// Determines if the main scrollview should show a scroll indicator. Defaults to true.
    open var showsScrollIndicator = true
    
    /// File name of the acknowledgements plist *without* extension. Defaults to "Acknowledgements".
    open var acknowledgementsFilename = "Acknowledgements"
    
    /// The name of the app. Leave nil to use the CFBundleName.
    open var appName: String?
    
    /// The current version of the app. Leave nil to use CFBundleShortVersionString.
    open var appVersion: String?
    
    /// The current build of the app. Leave nil to use CFBundleVersion.
    open var appBuild: String?
    
    /// The name of the person or entity who should appear as the copyright holder.
    open var copyrightHolderName: String?
    
    /// The email address users can send inquiries to (for example a support email address). Leave nil to skip.
    open var contactEmail: String?
    
    /// The text to use for the email link. Leave nil to use the email address as text.
    open var contactEmailTitle: String?
    
    /// The URL for the website link. Leave nil to skip.
    open var websiteURL: URL?
    
    /// The title for the website link. Leave nil to use the website URL.
    open var websiteURLTitle: String?
    
    /// The year the app's version was published. Used in the copyright text. Leave nil to use the current year.
    open var pubYear: String?
    
    /// Font used for the app name
    open var fontAppName: UIFont?
    
    /// Font used for the copyright information text
    open var fontCopyrightInfo: UIFont?
    
    /// Font used for the website button label
    open var fontWebsiteButton: UIFont?
    
    /// Font used for the email button label
    open var fontEmailButton: UIFont?
    
    /// Font used for the label on top of the "pods used" table
    open var fontHeaderLabel: UIFont?
    
    /// Font used for the "pods used" table cell label
    open var fontTableCellText: UIFont?
    
    /// Font used for the license text in the pod detail view
    open var fontLicenseText: UIFont?
    
    private var acknowledgements = [[String:String]]()
    private var metrics: [String:CGFloat]!
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
    public init(appName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, appVersion: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, appBuild: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String, copyrightHolderName: String? = "Developer", contactEmail: String? = nil, contactEmailTitle: String? = nil, websiteURL: URL? = nil, websiteURLTitle: String? = nil, pubYear: String? =         String(describing: Calendar.current.dateComponents([.year], from: Date()).year!)) {
        super.init(nibName: nil, bundle: nil)
        
        navigationViewBackgroundColor = navigationController?.view.backgroundColor // Set from system default
        navigationBarBarTintColor = navigationController?.navigationBar.barTintColor // Set from system default
        navigationBarTintColor = tintColor // Set from system default
        
        self.appName = appName ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        self.appVersion = appVersion ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        self.appBuild = appBuild ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        self.contactEmail = contactEmail
        self.contactEmailTitle = contactEmailTitle ?? self.contactEmail
        self.copyrightHolderName = copyrightHolderName ?? "Developer"
        self.websiteURL = websiteURL
        self.websiteURLTitle = websiteURLTitle ?? self.websiteURL?.absoluteString
        self.pubYear = pubYear ?? String(describing: Calendar.current.dateComponents([.year], from: Date()).year!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        
        // Set up the view
        view.backgroundColor = backgroundColor
        view.tintColor = tintColor
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.view.backgroundColor = navigationViewBackgroundColor
        navigationController?.navigationBar.barTintColor = navigationBarBarTintColor
        navigationController?.navigationBar.tintColor = navigationBarTintColor
        
        if let ackFile = Bundle.main.path(forResource: acknowledgementsFilename, ofType: "plist") {
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
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if headerBackgroundImage != nil {
            headerBackground.addSubview(visualEffectView)
        }
        
        let appNameLabel = createAndAddNameLabel(headerView: headerView)
        let copyrightInfo = createAndAddCopyrightLabel(headerView: headerView)
        
        let websiteButton = UIButton(type: .custom)
        
        if let _ = websiteURL {
            var buttonFont = UIFont.systemFont(ofSize: sizeForPercent(4.375), weight: -1)
            if let theFont = fontWebsiteButton {
                buttonFont = theFont
            }
            setupAndAddHeaderButton(websiteButton, title: websiteURLTitle, font: buttonFont, target: #selector(goToWebsite), headerView: headerView)
        }
        
        let eMailButton = UIButton(type: .custom)
        
        if let _ = contactEmail {
            var buttonFont = UIFont.systemFont(ofSize: sizeForPercent(4.375), weight: -1)
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
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: navigationBarTitleTextColor]
        if navigationController?.viewControllers.first == self {
            var closeItem: UIBarButtonItem!
            
            if closeButtonAsImage {
                closeItem = UIBarButtonItem(image:closeButtonImage, style: .plain, target: self, action: #selector(close))
            } else {
                closeItem = UIBarButtonItem(title: closeButtonText, style: .plain, target: self, action: #selector(close))
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
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case additionalButtonsTableView:
            return additionalButtons.count
        case acknowledgementsTableView:
            return acknowledgements.count
        default:
            return 0
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell==nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.tintColor = tableViewTextColor
            
            cell?.textLabel?.font = UIFont.systemFont(ofSize: sizeForPercent(4.688), weight: -1)
            
            if let theFont = fontTableCellText {
                cell?.textLabel?.font = theFont
            }
            cell?.selectionStyle = .default
            
            if let cellBGColor = tableViewSelectionColor {
                let bgColorView = UIView()
                bgColorView.backgroundColor = cellBGColor
                cell?.selectedBackgroundView = bgColorView
            }
            
            var title = ""
            if tableView == additionalButtonsTableView {
                title = (additionalButtons[(indexPath as NSIndexPath).row].keys.first)!
            } else {
                title = (acknowledgements[(indexPath as NSIndexPath).row].keys.first)!
            }
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            cell?.textLabel?.textColor = tableViewTextColor
            cell?.backgroundColor = tableViewBackgroundColor
            cell?.textLabel!.text = title
            cell?.accessoryType = .disclosureIndicator
        }
        
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.isSelected = false
        
        var theDict = [String: String]()
        
        if tableView == additionalButtonsTableView {
            theDict = additionalButtons[(indexPath as NSIndexPath).row]
        } else {
            theDict = acknowledgements[(indexPath as NSIndexPath).row]
        }
        showDetailViewController(theDict)
    }
    
    
    private func showDetailViewController(_ infoDictionary: [String:String]) {
        let viewController = RFAboutViewDetailViewController(infoDictionary: infoDictionary)
        viewController.showsScrollIndicator = showsScrollIndicator
        viewController.backgroundColor = backgroundColor
        viewController.tintColor = tintColor
        viewController.fontLicenseText = fontLicenseText
        viewController.textColor = acknowledgementsHeaderColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func createMainScrollView() -> UIScrollView {
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.backgroundColor = UIColor.clear
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = showsScrollIndicator
        return mainScrollView
    }
    
    private func createScrollViewContainer() -> UIView {
        let scrollViewContainer = UIView()
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.backgroundColor = UIColor.clear
        return scrollViewContainer
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = headerBackgroundColor
        headerView.layer.borderColor = headerBorderColor.cgColor
        headerView.layer.borderWidth = 0.5
        headerView.clipsToBounds = true
        return headerView
    }
    
    private func createHeaderBackground(headerView: UIView) -> UIImageView {
        let headerBackground = UIImageView()
        headerBackground.translatesAutoresizingMaskIntoConstraints = true
        headerBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerBackground.image = headerBackgroundImage
        headerBackground.contentMode = .scaleAspectFill
        headerBackground.frame = headerView.bounds
        return headerBackground
    }
    
    private func createAndAddNameLabel(headerView: UIView) -> UILabel {
        let appNameLabel = UILabel()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.font = UIFont.systemFont(ofSize: sizeForPercent(5.625), weight: -0.5)
        
        if let theFont = fontAppName {
            appNameLabel.font = theFont
        }
        
        appNameLabel.numberOfLines = 0
        appNameLabel.backgroundColor = UIColor.clear
        appNameLabel.textAlignment = .center
        appNameLabel.text = appName
        appNameLabel.textColor = headerTextColor
        headerView.addSubview(appNameLabel)
        appNameLabel.sizeToFit()
        appNameLabel.layoutIfNeeded()
        return appNameLabel
    }
    
    private func createAndAddCopyrightLabel(headerView: UIView) -> UILabel {
        let copyrightInfo = UILabel()
        copyrightInfo.translatesAutoresizingMaskIntoConstraints = false
        copyrightInfo.font = UIFont.systemFont(ofSize: sizeForPercent(4.375), weight: -1)
        
        if let theFont = fontCopyrightInfo {
            copyrightInfo.font = theFont
        }
        copyrightInfo.numberOfLines = 0
        copyrightInfo.backgroundColor = UIColor.clear
        copyrightInfo.textAlignment = .center
        copyrightInfo.text = "Version \(appVersion!) (\(appBuild!))\n © \(pubYear!) \(copyrightHolderName!)"
        copyrightInfo.textColor = headerTextColor
        headerView.addSubview(copyrightInfo)
        copyrightInfo.sizeToFit()
        copyrightInfo.layoutIfNeeded()
        return copyrightInfo
    }
    
    private func setupAndAddHeaderButton(_ button: UIButton, title: String?, font: UIFont, target: Selector, headerView: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(headerTextColor, for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = font
        button.addTarget(self, action: target, for: .touchUpInside)
        headerView.addSubview(button)
    }
    
    private func createAndAddAdditionalButtonsTableView(scrollViewContainer: UIView) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorColor = tableViewSeparatorColor
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = sizeForPercent(12.5)
        if additionalButtons.count > 0 {
            scrollViewContainer.addSubview(tableView)
        }
        return tableView
    }
    
    private func createAndAddTableHeaderLabel(scrollViewContainer: UIView) -> UILabel {
        let tableHeaderLabel = UILabel()
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.font = UIFont.systemFont(ofSize: sizeForPercent(4.375), weight: -1)
        
        if let theFont = fontHeaderLabel {
            tableHeaderLabel.font = theFont
        }
        tableHeaderLabel.numberOfLines = 0
        tableHeaderLabel.textColor = acknowledgementsHeaderColor
        tableHeaderLabel.backgroundColor = UIColor.clear
        tableHeaderLabel.textAlignment = .left
        tableHeaderLabel.text = String(format: NSLocalizedString("%@ makes use of the following third party libraries. Many thanks to the developers making them available!", comment: "Acknowlegdments header title"), appName!)
        tableHeaderLabel.sizeToFit()
        tableHeaderLabel.layoutIfNeeded()
        
        if showAcknowledgements {
            scrollViewContainer.addSubview(tableHeaderLabel)
        }
        return tableHeaderLabel
    }
    
    private func createAndAddAcknowledgementsTableView(scrollViewContainer: UIView) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorColor = tableViewSeparatorColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = sizeForPercent(12.5)
        if showAcknowledgements {
            scrollViewContainer.addSubview(tableView)
        }
        return tableView
    }
    
    private func setConstraints(mainScrollView: UIScrollView, scrollViewContainer: UIView, headerView: UIView, appNameLabel: UILabel, copyrightInfo: UILabel, eMailButton: UIButton, websiteButton: UIButton, tableHeaderLabel: UILabel) {
        /*
         A word of warning!
         Here comes all the Autolayout mess. Seriously, it's horrible. It's ugly, hard to follow and hard to maintain.
         But that'spretty much the only way to do it in code without external Autolayout wrappers like Masonry.
         Do yourself a favor and don't set up constraints like that if you can help it. You will save yourself a
         lot of headaches.
         */
        
        let currentScreenSize = UIScreen.main.bounds.size
        let padding = sizeForPercent(3.125)
        let tableViewHeight = sizeForPercent(12.5) * CGFloat(acknowledgements.count)
        let additionalButtonsTableHeight = sizeForPercent(12.5) * CGFloat(additionalButtons.count)
        
        metrics = ["padding":padding,
                   "doublePadding":padding * 2,
                   "tableViewHeight":tableViewHeight,
                   "additionalButtonsTableHeight":additionalButtonsTableHeight]
        
        let viewsDictionary = ["mainScrollView":mainScrollView,"scrollViewContainer":scrollViewContainer,"headerView":headerView,"appName":appNameLabel,"copyrightInfo":copyrightInfo,"eMailButton":eMailButton,"websiteButton":websiteButton,"tableHeaderLabel":tableHeaderLabel,"acknowledgementsTableView":acknowledgementsTableView,"additionalButtonsTable":additionalButtonsTableView]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainScrollView]|", options: [], metrics: metrics, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainScrollView]|", options: [], metrics: metrics, views: viewsDictionary))
        
        // We need to save the constraint to manually change the constant when the screen rotates:
        
        scrollViewContainerWidth = NSLayoutConstraint(item: scrollViewContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: currentScreenSize.width)
        
        mainScrollView.addConstraint(scrollViewContainerWidth!)
        
        mainScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollViewContainer]|", options: [], metrics: metrics, views: viewsDictionary))
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: [], metrics: metrics, views: viewsDictionary))
        
        var firstFormatString = ""
        
        if additionalButtons.count > 0 {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[additionalButtonsTable]|", options: [], metrics: metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[additionalButtonsTable(==additionalButtonsTableHeight)]"
        }
        
        if showAcknowledgements {
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[tableHeaderLabel]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            scrollViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[acknowledgementsTableView]|", options: [], metrics: metrics, views: viewsDictionary))
            firstFormatString = firstFormatString+"-doublePadding-[tableHeaderLabel]-padding-[acknowledgementsTableView(==tableViewHeight)]-doublePadding-"
        }
        
        scrollViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format: "V:|[headerView]%@|", firstFormatString), options: [], metrics: metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[appName]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[copyrightInfo]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
        
        var secondFormatString = ""
        
        if websiteURL != nil {
            headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[websiteButton]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            secondFormatString = secondFormatString+"-padding-[websiteButton]"
        }
        
        if contactEmail != nil {
            headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[eMailButton]-padding-|", options: [], metrics: metrics, views: viewsDictionary))
            
            if websiteURL != nil {
                secondFormatString = secondFormatString+"-0-[eMailButton]"
            } else {
                secondFormatString = secondFormatString+"-padding-[eMailButton]"
            }
        }
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"V:|-doublePadding-[appName]-padding-[copyrightInfo]%@-doublePadding-|",secondFormatString), options: [], metrics: metrics, views: viewsDictionary))
    }
    
    
    //MARK:- Action methods
    
    open func close() {
        dismiss(animated: true, completion: nil)
    }
    
    open func goToWebsite() {
        let webVC = SFSafariViewController(url: websiteURL!)
        webVC.delegate = self
        present(webVC, animated: true, completion: nil)
    }
    
    open func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    open func email() {
        let iOSVersion = UIDevice.current.systemVersion as String
        let device = UIDevice.current.model as String
        let deviceString = platformModelString()
        let lang = NSLocale.preferredLanguages.first ?? ""
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
            present(mailController, animated: true, completion: nil)
        } else {
            let supportText = "\"\(appName!) Version \(appVersion!) (\(appBuild!)), \(device) (\(deviceString!)), iOS \(iOSVersion) (\(lang))\""
            
            let alert = UIAlertController(title: NSLocalizedString("Cannot send Email", comment: "Cannot send Email"), message: String(format:NSLocalizedString("Unfortunately there are no Email accounts available on your device.\n\nFor support questions, please send an Email to %@ and include the following information: %@.\n\nTab the 'Copy info' button to copy this information to your pasteboard. Thank you!", comment: "Error message: no email accounts available"),contactEmail!, supportText, lang), preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss error message"), style:UIAlertActionStyle.cancel, handler: { (action) -> Void in
                alert.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            let copyInfoAction = UIAlertAction(title: NSLocalizedString("Copy Info", comment: "Copy diagnostic info to pasteboard"), style:UIAlertActionStyle.default, handler: { (action) -> Void in
                UIPasteboard.general.string = supportText
                alert.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(dismissAction)
            alert.addAction(copyInfoAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: { () -> Void in
            if result.rawValue == MFMailComposeResult.failed.rawValue {
                let alert = UIAlertController(title: NSLocalizedString("Message Failed!", comment: "Sending email message failed"), message: NSLocalizedString("Your email has failed to send.", comment: "Sending email message failed body"), preferredStyle: UIAlertControllerStyle.alert)
                let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss error message"), style:UIAlertActionStyle.cancel, handler: { (action) -> Void in
                    alert.presentingViewController?.dismiss(animated: true, completion: nil)
                })
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    /**
     Adds an additional button (as a TableView cell) below the header. Use it to supply further information, like TOS, Privacy Policy etc.
     
     - parameter title:   The title of the button
     - parameter content: The text to display in the detail view
     */
    open func addAdditionalButton(_ title: String, content: String) {
        additionalButtons.append([title:content])
    }
    
    open func addAcknowledgement(_ title: String, content: String) {
        acknowledgements.append([title:content])
    }
    
    //MARK:- Helper functions
    
    /*!
     *  Gets the raw platform id (e.g. iPhone7,1)
     *  Mad props to http://stackoverflow.com/questions/25467082/using-sysctlbyname-from-swift
     */
    
    private func platformModelString() -> String? {
        if let key = "hw.machine".cString(using: String.Encoding.utf8) {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname(key, &machine, &size, nil, 0)
            return String(cString: machine)
        }
        return nil
    }
    
    private func reformatAcknowledgementsDictionary(_ originalDict: NSDictionary) -> [[String: String]] {
        var outputArray = [[String:String]]()

        if let tmp = originalDict.object(forKey: "PreferenceSpecifiers") as? NSMutableArray {
            
            if let mutableTmp = tmp.mutableCopy() as? NSMutableArray {
                mutableTmp.removeObject(at: 0)
                mutableTmp.removeLastObject()
                
                for innerDict in mutableTmp {
                    if let dictionary = innerDict as? NSDictionary, let tempTitle = dictionary.object(forKey: "Title") as? String, let tempContent = dictionary.object(forKey: "FooterText") as? String {
                        outputArray.append([tempTitle:tempContent])
                    }
                }
            }
        }
        return outputArray
    }
    
    //MARK:- Autorotation
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollViewContainerWidth?.constant = size.width
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}
