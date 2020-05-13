//
//  LogInViewControllerTests.swift
//  ui2Tests
//
//  Created by lamour on 5/11/20.
//  Copyright © 2020 Lamour Butcher. All rights reserved.
//

import XCTest
import EarlGrey
import FBSnapshotTestCase

@testable import ui2



class LogInViewControllerTests: FBSnapshotTestCase {
    private var controller: LogInViewController!
    override func setUp() {
        super.setUp()
        recordMode = false // so far this a bit annoying to flip... find a better way
        controller = LogInViewController.init(service: MockedService())
    }

    override func tearDown() {
        controller = nil
    }
    
    func testFailureStateOfSignInFlow() {
        FBSnapshotVerifyViewController(controller)

        let username = "ajaksjdas"
        let password = "adjasdjklasjdkl"
        
        let usernameField = EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.usernameFieldIdentifier))
        let passwordField =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.passwordFieldIdentifier))
        
        let spinner =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.spinnerIdentifier))
        let errorLabel = EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.errorLabelIdentifier))

        usernameField.perform(grey_typeText(username))
        passwordField.perform(grey_typeText(password))
        
        let signInButton =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.signInButtonIdentifier))
        
        // verify label is off
        spinner.assert(grey_notVisible())
        errorLabel.assert(grey_notVisible())
        
        // tap
        signInButton.perform(grey_tap())
        
        spinner.assert(grey_enabled())
        
        errorLabel.assert(grey_sufficientlyVisible())
        errorLabel.assert(grey_text(ErrorStrings.AccountNotFound))
        
    }
    
    
    func testSuccessfulStateOfSignInFlow() {
        FBSnapshotVerifyViewController(controller)
        
        let usernameField = EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.usernameFieldIdentifier))
        let passwordField =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.passwordFieldIdentifier))
        
        let spinner =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.spinnerIdentifier))
        let errorLabel = EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.errorLabelIdentifier))
        
        let alert = EarlGrey.selectElement(with: grey_accessibilityLabel(LogInViewController.UX.successAlertViewIdentifier))

        usernameField.perform(grey_typeText(MockedService.correctUsernameInput))
        passwordField.perform(grey_typeText(MockedService.correctPasswordInput))
        
        let signInButton =  EarlGrey.selectElement(with: grey_accessibilityID(LogInViewController.UX.signInButtonIdentifier))
        
        // verify label is off
        spinner.assert(grey_notVisible())
        errorLabel.assert(grey_notVisible())
        // tap
        signInButton.perform(grey_tap())
        // spinner is shown
        spinner.assert(grey_enabled())
        // then dismissed
        spinner.assert(grey_notVisible())
        // no error
        errorLabel.assert(grey_notVisible())
        // there is an alert view
        alert.assert(grey_enabled())
    }
    

}


