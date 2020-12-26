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

    @IBAction func pushAbout() {
        let aboutViewController = createAboutViewController()

        // Push the About View Controller:
        navigationController?.pushViewController(aboutViewController, animated: true)
    }

    @IBAction func presentAbout() {
        let aboutViewController = createAboutViewController()

        // First create a UINavigationController.
        // The RFAboutView needs to be wrapped in a UINavigationController.

        let aboutNav = UINavigationController(rootViewController: aboutViewController)

        // Present the navigation controller:
        self.present(aboutNav, animated: true, completion: nil)
    }

    func createAboutViewController() -> UIViewController {
        // Initialise the RFAboutView:

        let aboutViewController = RFAboutViewController(appName: nil, appVersion: nil, appBuild: nil, copyrightHolderName: "ExampleApp, Inc.", contactEmail: "mail@example.com", contactEmailTitle: "Contact us", websiteURL: URL(string: "http://example.com"), websiteURLTitle: "Our Website", pubYear: nil)

        // Set some additional options:

        aboutViewController.headerBackgroundColor = UIColor.black
        aboutViewController.headerTextColor = UIColor.white
        aboutViewController.blurStyle = .dark
        aboutViewController.headerBackgroundImage = UIImage(named: "about_header_bg.jpg")

        // Add an additional button:
        aboutViewController.addAdditionalButton("Privacy Policy", content: "Here's the privacy policy")

        return aboutViewController
    }
}

