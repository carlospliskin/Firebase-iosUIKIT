//
//  ChatViewController.swift
//  prueba
//
//  Created by Carlos Paredes León on 25/03/24.
//

import UIKit

class ChatViewController: UIViewController {

    var presenter: ChatPresenterProtocol?
    var router: ChatWireframeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hola estoy en chat" )

        // Do any additional setup after loading the view.
    }
}

extension ChatViewController: ChatViewProtocol { }

