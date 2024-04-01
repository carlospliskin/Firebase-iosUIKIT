//
//  LoginPresenter.swift
//  xybooster
//
//  Created by Kelly Jocelyn Farías Gómez on 13/02/24.
//

import Foundation

class LoginPresenter {

    var interactor: LoginInteractorInputProtocol?
    weak private var view: LoginViewProtocol?
    private let router: LoginRouterProtocol
    
    init(interface: LoginViewProtocol, interactor: LoginInteractorInputProtocol, router: LoginRouterProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func navigateToChat() {
        router.navigateToChat()
    }
    

}
extension LoginPresenter: LoginInteractorOutputProtocol { }
