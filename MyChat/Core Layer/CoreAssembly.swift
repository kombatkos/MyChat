//
//  CoreAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol ICoreAssembly {
    var filesManager: IFilesManager { get }
    var fileNames: IFileNames {get}
    var coreDataStack: IModernCoreDataStack {get}
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var filesManager: IFilesManager = FilesManager()
    lazy var fileNames: IFileNames = FileNames()
    lazy var coreDataStack: IModernCoreDataStack = ModernCoreDataStack()
    lazy var requestSender: IRequestSender = RequestSender()
}
