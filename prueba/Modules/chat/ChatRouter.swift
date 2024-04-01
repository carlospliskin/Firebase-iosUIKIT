//
//  ChatRouter.swift
//  prueba
//
//  Created by Carlos Paredes León on 25/03/24.
//  
//

import Foundation
import UIKit

class ChatRouter {
    
    // MARK: Properties
    
    weak var view: UIViewController?
    
    // MARK: Static methods
    
    static func setupModule() -> UIViewController {
        let viewController = ChatViewController()
        let router = ChatRouter()
        let interactor = ChatInteractor()
        let presenter = ChatPresenter(interface: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        router.view = viewController // Asigna la vista al router
        
        interactor.presenter = presenter
        
        return viewController
    }
}

extension ChatRouter: ChatWireframeProtocol {
    // Implementa métodos de protocolo aquí
}

