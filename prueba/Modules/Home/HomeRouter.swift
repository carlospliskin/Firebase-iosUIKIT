//
//  HomeRouter.swift
//  prueba
//
//  Created by Carlos Paredes León on 01/04/24.
//  
//

import Foundation
import UIKit

class HomeRouter {

    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Static methods

    static func setupModule() -> UIViewController {

        let viewController = HomeRViewController()
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interface: viewController, interactor: interactor, router: router)

        viewController.presenter =  presenter
        interactor.presenter = presenter
        router.view = viewController

        return viewController
    }
}

extension HomeRouter: HomeWireframeProtocol { }
