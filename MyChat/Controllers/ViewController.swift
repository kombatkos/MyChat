//
//  ViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.02.2021.
//

import UIKit
import SwiftyBeaver

class ViewController: UIViewController {
    

// MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyBeaver.verbose("ВЬЮ ЗАГРУЗИЛСЯ")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftyBeaver.verbose("ВЬЮ СЕЙЧАС ПОЯВИТСЯ")
    }
    
    override func viewWillLayoutSubviews() {
        SwiftyBeaver.verbose("ВЬЮ БУДЕТ КОМПОНОВАТЬ САБВЬЮ")
    }
    
    override func viewDidLayoutSubviews() {
        SwiftyBeaver.verbose("ВЬЮ СКОМПОНОВАЛ САБВЬЮ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SwiftyBeaver.verbose("ВЬЮ ПОЯВИЛСЯ")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        SwiftyBeaver.verbose("ВЬЮ БУДЕТ ИЗМЕНЯТЬСЯ")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftyBeaver.verbose("ВЬЮ СЕЙЧАС ИСЧЕЗНЕТ")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftyBeaver.verbose("ВЬЮ ИСЧЕЗ")
    }

}
