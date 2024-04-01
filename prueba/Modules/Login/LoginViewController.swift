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
        updateTextfieldTextColor()
        print("Botón de recordar presionado")
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
        if isRememberingPassword {
            savePasswordToKeychain()
        } else {
            deletePasswordFromKeychain()
        }
    }
    
    private func savePasswordToKeychain() {
        guard let password = tfPassword.text, let email = tfMail.text else { return }
        
        // Guardar la contraseña en el Keychain
        let passwordData = password.data(using: .utf8)!
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword",
            kSecValueData as String: passwordData
        ]
        let passwordStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
        guard passwordStatus == errSecSuccess else {
            print("Error saving password to Keychain")
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
            print("Error saving email to Keychain")
            return
        }
        print("Email saved to Keychain")
    }
    
    private func deletePasswordFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userPassword"
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Error deleting password from Keychain")
            return
        }
        print("Password deleted from Keychain")
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
    
    private func updateTextfieldTextColor() {
        tfMail.textColor = isRememberingPassword ? .systemPink : .black
        tfPassword.textColor = isRememberingPassword ? .systemPink : .black
    }
    
    private func retrieveSavedCredentialsFromKeychain() {
        // Recupera la contraseña del Keychain
        guard let savedPasswordData = getPasswordFromKeychain() else {
            // No se encontraron credenciales guardadas en el Keychain
            return
        }
        
        guard let savedPassword = String(data: savedPasswordData, encoding: .utf8) else {
            // No se pudo convertir la data del password del Keychain a String
            return
        }
        
        // Establecer el email y contraseña recuperados en los campos de texto
        tfMail.text = getEmailFromKeychain()
        tfPassword.text = savedPassword
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
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let existingItem = item as? [String: Any], let email = existingItem[kSecAttrAccount as String] as? String else {
            print("Error retrieving email from Keychain")
            return nil
        }
        
        return email
    }
}

extension LoginViewController: LoginViewProtocol { }
