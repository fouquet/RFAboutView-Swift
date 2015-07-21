//
//  ViewController.swift
//  RFAboutView
//
//  Created by René Fouquet on 23/05/15.
//  Copyright (c) 2015 René Fouquet. All rights reserved.
//

import UIKit
import RFAboutView_Swift
import MessageUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAbout(sender: AnyObject) {
        // First create a UINavigationController (or use your existing one).
        // The RFAboutView needs to be wrapped in a UINavigationController.

        let aboutNav = UINavigationController()

        // Initialise the RFAboutView:

        let aboutView = RFAboutViewController(appName: nil, appVersion: nil, appBuild: nil, copyrightHolderName: "ExampleApp, Inc.", contactEmail: "mail@example.com", contactEmailTitle: "Contact us", websiteURL: NSURL(string: "http://example.com"), websiteURLTitle: "Our Website", pubYear: nil)

        // Set some additional options:

        aboutView.headerBackgroundColor = .blackColor()
        aboutView.headerTextColor = .whiteColor()
        aboutView.blurStyle = .Dark
        aboutView.headerBackgroundImage = UIImage(named: "about_header_bg.jpg")

        // Add an additional button:
        aboutView.addAdditionalButton("Privacy Policy", content: "Here's the privacy policy")

        // Add the aboutView to the NavigationController:
        aboutNav.setViewControllers([aboutView], animated: false)

        // Present the navigation controller:
        self.presentViewController(aboutNav, animated: true, completion: nil)
    }
}

