//
//  ChatPresenter.swift
//  prueba
//
//  Created by Carlos Paredes León on 25/03/24.
//  
//

import Foundation

class ChatPresenter {

    // MARK: Properties

    weak var view: ChatViewProtocol?
    private let router: ChatWireframeProtocol
    var interactor: ChatInteeractorInputProtocol?

    init(interface: ChatViewProtocol, interactor: ChatInteeractorInputProtocol, router: ChatWireframeProtocol) {
        view = interface
        self.interactor = interactor
        self.router = router
    }


}

extension ChatPresenter: ChatPresenterProtocol { }

extension ChatPresenter: ChatInteractorOutputProtocol { }
