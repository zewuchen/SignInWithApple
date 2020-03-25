//
//  ViewController.swift
//  SignInApple
//
//  Created by Matheus Silva on 20/03/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController {
    @IBOutlet weak var authorizationButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSignInAppleButton()
    }
}


extension ViewController: ASAuthorizationControllerDelegate {
    func setUpSignInAppleButton() {
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let alert = UIAlertController(title: "Authorization Success", message: "\(userIdentifier) \n \(String(describing: fullName)) \n \(email)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Authorization Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    // MARK: It’s responsible for presenting the Apple ID login view, so you can simply return the window of your app
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
