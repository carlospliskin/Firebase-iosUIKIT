//
//  HomePresenter.swift
//  prueba
//
//  Created by Carlos Paredes León on 01/04/24.
//  
//

import Foundation

class HomePresenter {

    // MARK: Properties

    weak var view: HomeViewProtocol?
    private let router: HomeWireframeProtocol
    var interactor: HomeInteeractorInputProtocol?

    init(interface: HomeViewProtocol, interactor: HomeInteeractorInputProtocol, router: HomeWireframeProtocol) {
        view = interface
        self.interactor = interactor
        self.router = router
    }


}

extension HomePresenter: HomePresenterProtocol { }

extension HomePresenter: HomeInteractorOutputProtocol { }
