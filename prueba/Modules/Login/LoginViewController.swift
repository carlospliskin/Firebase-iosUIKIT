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
        setupTapGesture()
        setupShowPasswordButton()
        retrieveSavedCredentialsFromKeychain()
    }
    
    // MARK: - Setup Methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
        saveOrDeletePasswordInKeychain()
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
        saveOrDeletePasswordInKeychain()
    }
    
    private func saveOrDeletePasswordInKeychain() {
        if isRememberingPassword {
            savePasswordToKeychain()
        } else {
            deleteCredentialsFromKeychain()
        }
    }
    
    private func savePasswordToKeychain() {
        guard let password = tfPassword.text, let email = tfMail.text else { return }
        
        // Eliminar tanto el correo electrónico como la contraseña existentes
        deleteCredentialsFromKeychain()
        
        // Guardar la nueva contraseña en el Keychain
        let passwordData = password.data(using: .utf8)!
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword",
            kSecValueData as String: passwordData
        ]
        let passwordStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
        guard passwordStatus == errSecSuccess else {
            print("Error saving password to Keychain: \(passwordStatus)")
            return
        }
        print("Password saved to Keychain")
        
        // Guardar el correo electrónico en el Keychain
        let emailData = email.data(using: .utf8)!
        let emailQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userEmail",
            kSecValueData as String: emailData
        ]
        let emailStatus = SecItemAdd(emailQuery as CFDictionary, nil)
        guard emailStatus == errSecSuccess else {
            print("Error saving email to Keychain: \(emailStatus)")
            return
        }
        print("Email saved to Keychain")
    }


    private func retrieveSavedCredentialsFromKeychain() {
        // Retrieve saved password data from Keychain
        guard let savedPasswordData = getPasswordFromKeychain() else {
            return
        }
        
        // Convert saved password data to string
        guard let savedPassword = String(data: savedPasswordData, encoding: .utf8) else {
            return
        }
        
        // Set the retrieved password to the password text field
        tfPassword.text = savedPassword
        
        // Retrieve saved email data from Keychain
        guard let savedEmailData = getEmailFromKeychain() else {
            return
        }
        
        // Convert saved email data to string
        guard let savedEmail = savedEmailData as? String else {
            return
        }
        
        // Set the retrieved email to the email text field
        tfMail.text = savedEmail
    }


    private func deleteCredentialsFromKeychain() {
        // Eliminar la contraseña del Keychain
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword"
        ]
        let passwordStatus = SecItemDelete(passwordQuery as CFDictionary)
        guard passwordStatus == errSecSuccess || passwordStatus == errSecItemNotFound else {
            print("Error deleting password from Keychain")
            return
        }
        print("Password deleted from Keychain")
        
        // Eliminar el correo electrónico del Keychain
        let emailQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userEmail"
        ]
        let emailStatus = SecItemDelete(emailQuery as CFDictionary)
        guard emailStatus == errSecSuccess || emailStatus == errSecItemNotFound else {
            print("Error deleting email from Keychain")
            return
        }
        print("Email deleted from Keychain")
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
        print ("estoy marcado")
    }
    
    private func getPasswordFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            print("Error retrieving password from Keychain")
            return nil
        }
        
        return item as? Data
    }
    
    private func getEmailFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userEmail",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            print("Error retrieving email from Keychain")
            return nil
        }
        
        guard let data = item as? Data else {
            print("Error converting retrieved data to Data")
            return nil
        }
        
        guard let email = String(data: data, encoding: .utf8) else {
            print("Error converting data to String")
            return nil
        }
        
        return email
    }
}

extension LoginViewController: LoginViewProtocol { }
