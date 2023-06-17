import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchMessagesEntity() -> [MessageEntity] {
        var items = [MessageEntity]()
        do {
            items =  try context.fetch(MessageEntity.fetchRequest())
        } catch {
            print(error)
        }
        return items
    }
    
    func removeMessageEntity(removeMessage: MessageEntity) {
        context.delete(removeMessage)
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
