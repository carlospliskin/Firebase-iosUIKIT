//
//  LoginProtocols.swift
//  xybooster
//
//  Created by Kelly Jocelyn Farías Gómez on 13/02/24.
//

import Foundation
/// Protocolo de comunicacion entre el Presenter y la Vista.
protocol LoginViewProtocol: AnyObject {
    /// Referencia al Presenter
    var presenter: LoginPresenterProtocol? { get set }

}
/// Protocolo de comunicacion entre el Presenter y el Interactor.
protocol LoginInteractorInputProtocol: AnyObject {
    /// Referencia al Interactor.
    var presenter: LoginInteractorOutputProtocol? { get set }

}
/// Protocolo de comunicacion entre el Interactor y el Presenter.
protocol LoginInteractorOutputProtocol: AnyObject {
/// Protocolo de comunicacion entre la Vista y el Presenter.

}

protocol LoginPresenterProtocol: AnyObject {
    /// Referencia al Interactor.
    var interactor: LoginInteractorInputProtocol? { get set }
    /// Funcion para navegar a la vista de Registro.

    func navigateToChat()
}
/// Protocolo de comunicacion entre el Presenter y el Router.
protocol LoginRouterProtocol: AnyObject {
    /// Funcion para navegar a la vista de Registro.
    func navigateToChat()
}
