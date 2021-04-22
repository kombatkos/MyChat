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
            case .insert:
                print("INSERT")
                guard let newIndexPath = newIndexPath else { return }
                self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                print("DELETE")
                guard let indexPath = indexPath else { return }
                self.delegate?.deleteRows(at: [indexPath], with: .automatic)
            case .move:
                print("MOVE")
                guard let indexPath = indexPath else { return }
                self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                guard let newIndexPath = newIndexPath else { return }
                self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
            case .update:
                print("UPDATE")
                guard let indexPath = indexPath else { return }
                self.delegate?.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                fatalError("")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.endUpdates()
        }
    }
    
}
