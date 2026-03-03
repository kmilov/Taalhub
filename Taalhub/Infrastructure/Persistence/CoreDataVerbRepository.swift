import Foundation
import CoreData

struct CoreDataVerbRepository: SavedVerbRepository {
    private let controller: PersistenceController

    init(controller: PersistenceController = .shared) {
        self.controller = controller
    }

    func fetchAll() -> [VerbCard] {
        let context = controller.container.viewContext
        let fetchRequest: NSFetchRequest<VerbEntity> = VerbEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest).map { $0.toVerbCard() }
        } catch {
            print("Failed to fetch verb cards: \(error)")
            return []
        }
    }

    func save(_ verbCard: VerbCard) {
        let context = controller.container.viewContext
        let entity = VerbEntity(context: context)
        
        entity.infinitive = verbCard.infinitive
        entity.pastTense = verbCard.ovt
        entity.pastParticiple = verbCard.vtt
        entity.sentences = verbCard.sentences
        entity.english = verbCard.english
        entity.spanish = verbCard.spanish
        
        do {
            try context.save()
        } catch {
            print("Failed to save verb: \(error)")
        }
    }

    func deleteAll() {
        let context = controller.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VerbEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            print("Failed to delete all saved verb cards: \(error)")
        }
    }
}
