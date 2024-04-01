//
//  HomeProtocols.swift
//  prueba
//
//  Created by Carlos Paredes León on 01/04/24.
//  
//

import Foundation

//MARK: Presenter -> View
protocol HomeViewProtocol: AnyObject {
    var presenter:HomePresenterProtocol? { get set }
}

//MARK: View -> Presenter
protocol HomePresenterProtocol: AnyObject {
    var interactor: HomeInteeractorInputProtocol? { get set }
}

//MARK: Presenter -> Interactor
protocol HomeInteeractorInputProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol?  { get set }
}

//MARK: Interactor -> Presenter
protocol HomeInteractorOutputProtocol: AnyObject {

}

//MARK: Presenter -> Router
protocol HomeWireframeProtocol: AnyObject { }
