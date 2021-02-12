//
//  ViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.02.2021.
//

import UIKit

class ViewController: UIViewController {
    

// MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let function = #function
        printLog(state: "ВЬЮ ЗАГРУЗИЛСЯ", function: function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let function = #function
        printLog(state: "ВЬЮ СЕЙЧАС ПОЯВИТСЯ", function: function)
    }
    
    override func viewWillLayoutSubviews() {
        let function = #function
        printLog(state: "ВЬЮ БУДЕТ КОМПОНОВАТЬ САБВЬЮ", function: function)
    }
    
    override func viewDidLayoutSubviews() {
        let function = #function
        printLog(state: "ВЬЮ СКОМПОНОВАЛ САБВЬЮ", function: function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let function = #function
        printLog(state: "ВЬЮ ПОЯВИЛСЯ", function: function)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let function = #function
        printLog(state: "ВЬЮ БУДЕТ ИЗМЕНЯТЬСЯ", function: function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let function = #function
        printLog(state: "ВЬЮ СЕЙЧАС ИСЧЕЗНЕТ", function: function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let function = #function
        printLog(state: "ВЬЮ ИСЧЕЗ", function: function)
    }

}

// MARK: - Set Log
extension ViewController {
    
    var logON: Bool {
        return true
    }
    
    private func printLog(state: String, function: String) {
        if logON {
            print("VC:  \(state): \n     \(function) \n")
        }
    }
}
