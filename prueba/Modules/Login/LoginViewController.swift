//
//  LoginViewController.swift
//  xybooster
//
//  Created by Kelly Jocelyn Farías Gómez on 13/02/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var imgLogoWhite: UIImageView!
    @IBOutlet private weak var lblWelcomeMsg: UILabel!
    @IBOutlet private weak var tfMail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    @IBOutlet private weak var btnForgotPasswd: UIButton!
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var lblAcountAsk: UILabel!
    @IBOutlet private weak var btnSingUp: UIButton!
    
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc func signUpButtonTapped() {
      
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        presenter?.navigateToChat()
    }
    @IBAction func forgottenPasswordTapped(_ sender: Any) {
       
    }
}
extension LoginViewController: LoginViewProtocol { }
