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
    @IBOutlet private weak var btnRememberPassword: UIButton!
    
    // MARK: - Properties
    private var btnShowPassword: UIButton!
    private var isRememberingPassword = false
    var presenter: LoginPresenterProtocol?
    
    // MARK: - Lifecycle Methods
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         retrieveSavedCredentialsFromKeychain()
     }

     // MARK: - Setup Methods
     private func setupUI() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
         setupShowPasswordButton()
     }

     private func setupShowPasswordButton() {
         btnShowPassword = UIButton(type: .custom)
         btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
         btnShowPassword.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
         tfPassword.rightView = btnShowPassword
         tfPassword.rightViewMode = .always
     }

     // MARK: - Actions
     @IBAction func loginButtonTapped(_ sender: Any) {
         guard let email = tfMail.text, !email.isEmpty else {
             showAlert(message: "Por favor ingresa tu correo electrónico")
             return
         }
         guard let password = tfPassword.text, !password.isEmpty else {
             showAlert(message: "Por favor ingresa tu contraseña")
             return
         }
         handleRememberPassword()
         presenter?.navigateToChat()
     }

     @IBAction func forgottenPasswordTapped(_ sender: Any) {
         // Handle forgotten password action
     }

     @IBAction func rememberPasswordButtonTapped() {
         isRememberingPassword.toggle()
         updateRememberPasswordButtonTitle()
         saveOrDeleteCredentialsInKeychain()
     }

     // MARK: - Private Methods
     @objc private func dismissKeyboard() {
         view.endEditing(true)
     }

     @objc private func showPasswordButtonTapped() {
         tfPassword.isSecureTextEntry.toggle()
         let imageName = tfPassword.isSecureTextEntry ? "eye" : "eyeSlash"
         btnShowPassword.setImage(UIImage(named: imageName), for: .normal)
     }

     private func handleRememberPassword() {
         saveOrDeleteCredentialsInKeychain()
     }

     private func saveOrDeleteCredentialsInKeychain() {
         if isRememberingPassword {
             saveCredentialsToKeychain()
         } else {
             deleteCredentialsFromKeychain()
         }
     }

     private func saveCredentialsToKeychain() {
         guard let password = tfPassword.text, let email = tfMail.text else { return }
         
         deleteCredentialsFromKeychain()
         
         let passwordData = password.data(using: .utf8)!
         let emailData = email.data(using: .utf8)!
         
         let passwordQuery: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: "userPassword",
             kSecValueData as String: passwordData
         ]
         
         let emailQuery: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: "userEmail",
             kSecValueData as String: emailData
         ]
         
         saveItemToKeychain(query: passwordQuery)
         saveItemToKeychain(query: emailQuery)
     }
     
     private func saveItemToKeychain(query: [String: Any]) {
         let status = SecItemAdd(query as CFDictionary, nil)
         guard status == errSecSuccess else {
             print("Error saving item to Keychain: \(status)")
             return
         }
         print("Item saved to Keychain")
     }

     private func deleteCredentialsFromKeychain() {
         deleteItemFromKeychain(account: "userPassword")
         deleteItemFromKeychain(account: "userEmail")
     }

     private func deleteItemFromKeychain(account: String) {
         let query: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: account
         ]
         
         let status = SecItemDelete(query as CFDictionary)
         guard status == errSecSuccess || status == errSecItemNotFound else {
             print("Error deleting item from Keychain: \(status)")
             return
         }
         print("Item deleted from Keychain")
     }

     private func showAlert(message: String) {
         let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(okAction)
         present(alertController, animated: true, completion: nil)
     }

     private func updateRememberPasswordButtonTitle() {
         let buttonTitle = isRememberingPassword ? "Desmarcar" : "Recordar"
         btnRememberPassword.setTitle(buttonTitle, for: .normal)
         print("Estoy marcado")
     }

     private func retrieveSavedCredentialsFromKeychain() {
         tfPassword.text = getStringFromKeychain(account: "userPassword")
         tfMail.text = getStringFromKeychain(account: "userEmail")
     }

     private func getStringFromKeychain(account: String) -> String? {
         let query: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: account,
             kSecReturnData as String: true,
             kSecMatchLimit as String: kSecMatchLimitOne
         ]
         
         var item: CFTypeRef?
         let status = SecItemCopyMatching(query as CFDictionary, &item)
         
         guard status == errSecSuccess else {
             print("Error retrieving item from Keychain: \(status)")
             return nil
         }
         
         guard let data = item as? Data else {
             print("Error converting retrieved data to Data")
             return nil
         }
         
         guard let string = String(data: data, encoding: .utf8) else {
             print("Error converting data to String")
             return nil
         }
         
         return string
     }
}

extension LoginViewController: LoginViewProtocol { }
