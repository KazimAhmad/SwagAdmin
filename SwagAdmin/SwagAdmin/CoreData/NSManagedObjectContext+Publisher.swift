//
//  NSManagedObjectContext+Publisher.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 28/01/2026.
//

import Combine
import CoreData
import Foundation

extension NSManagedObjectContext {
    func fetchPublisher<T: NSManagedObject>(
        _ request: NSFetchRequest<T>
    ) -> AnyPublisher<[T], Never> {
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: self,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        let subject = CurrentValueSubject<[T], Never>([])

        let delegate = FetchedResultsDelegate { objects in
            subject.send(objects)
        }

        controller.delegate = delegate

        try? controller.performFetch()
        subject.send(controller.fetchedObjects ?? [])

        return subject.eraseToAnyPublisher()
    }
}

final class FetchedResultsDelegate<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {

    private let onChange: ([T]) -> Void

    init(onChange: @escaping ([T]) -> Void) {
        self.onChange = onChange
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        guard let objects = controller.fetchedObjects as? [T] else {
            onChange([])
            return
        }
        onChange(objects)
    }
}
