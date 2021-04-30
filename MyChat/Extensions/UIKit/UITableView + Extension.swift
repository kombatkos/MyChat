//
//  UITableView + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import UIKit

protocol IDataProviderDelegate: AnyObject {
    func beginUpdates()
    func endUpdates()
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

extension UITableView: IDataProviderDelegate { }
