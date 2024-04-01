//
//  LoginViewController.swift
//  xybooster
//
//  Created by Kelly Jocelyn Farías Gómez on 13/02/24.
//

import UIKit
import Security

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var imgLogoWhite: UIImageView!
    @IBOutlet private weak var lblWelcomeMsg: UILabel!
    @IBOutlet private weak var tfMail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    @IBOutlet private weak var btnForgotPasswd: UIButton!
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var lblAcountAsk: UILabel!
    @IBOutlet private weak var btnSingUp: UIButton!
    private var btnShowPassword: UIButton!
    
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        btnShowPassword = UIButton(type: .custom)
        btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        btnShowPassword.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        tfPassword.rightView = btnShowPassword
        tfPassword.rightViewMode = .always
    }
    
    @objc func signUpButtonTapped() {
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = tfMail.text, !email.isEmpty else {
            showAlert(message: "Por favor ingresa tu correo electrónico")
            return
        }
        guard let password = tfPassword.text, !password.isEmpty else {
            showAlert(message: "Por favor ingresa tu contraseña")
            return
        }
        presenter?.navigateToChat()
    }
    @IBAction func forgottenPasswordTapped(_ sender: Any) {
        
    }
    
    @objc func showPasswordButtonTapped() {
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        let buttonImage = tfPassword.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eyeSlash")
        btnShowPassword.setImage(buttonImage, for: .normal)
    }
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
extension LoginViewController: LoginViewProtocol { }
