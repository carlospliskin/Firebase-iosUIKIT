//
//  LoginRouter.swift
//  xybooster
//
//  Created by Kelly Jocelyn Farías Gómez on 13/02/24.
//  

import UIKit

class LoginRouter {
 
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let view = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}

extension LoginRouter: LoginRouterProtocol {
    func navigateToChat() {
        let chatViewController = ChatRouter.setupModule()
        viewController?.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
