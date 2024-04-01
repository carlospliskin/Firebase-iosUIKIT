//
//  ChatProtocols.swift
//  prueba
//
//  Created by Carlos Paredes León on 25/03/24.
//  
//

import Foundation

//MARK: Presenter -> View
protocol ChatViewProtocol: AnyObject {
    var presenter:ChatPresenterProtocol? { get set }
}

//MARK: View -> Presenter
protocol ChatPresenterProtocol: AnyObject {
    var interactor: ChatInteeractorInputProtocol? { get set }
}

//MARK: Presenter -> Interactor
protocol ChatInteeractorInputProtocol: AnyObject {
    var presenter: ChatInteractorOutputProtocol?  { get set }
}

//MARK: Interactor -> Presenter
protocol ChatInteractorOutputProtocol: AnyObject {

}

//MARK: Presenter -> Router
protocol ChatWireframeProtocol: AnyObject { }
