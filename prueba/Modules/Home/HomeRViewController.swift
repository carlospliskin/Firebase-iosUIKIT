//
//  HomeRViewController.swift
//  prueba
//
//  Created by Carlos Paredes León on 01/04/24.
//

import UIKit

class HomeRViewController: UIViewController {

    var presenter: HomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation


}


extension HomeRViewController: HomeViewProtocol { }
