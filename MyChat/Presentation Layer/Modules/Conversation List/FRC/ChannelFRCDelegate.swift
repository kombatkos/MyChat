//
//  ChannelDataProvider.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import CoreData

protocol IChannelFRCDelegate {
    var delegate: IDataProviderDelegate? { get set }
}

class ChannelFRCDelegate: NSObject, IChannelFRCDelegate {
    
    weak var delegate: IDataProviderDelegate?
    var fetchedResultsController: NSFetchedResultsController<ChannelCD>
    
    init(delegate: IDataProviderDelegate, frc: NSFetchedResultsController<ChannelCD>) {
        fetchedResultsController = frc
        self.delegate = delegate
        super.init()
                
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
    }
    
}

extension ChannelFRCDelegate: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .delete:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
                
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    self.delegate?.reloadRows(at: [indexPath], with: .automatic)
                }
            @unknown default:
                assertionFailure("Ничего не работает)))")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.endUpdates()
        }
    }
    
}
