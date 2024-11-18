import Foundation
import CoreData

// Core Data entity for storing APOD data.
@objc (ItemApod)
final class ItemApod: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var apodDate: String
    @NSManaged var date: Date
    @NSManaged var title: String
    @NSManaged var explanation: String
    @NSManaged var mediaType: String
    @NSManaged var mediaURL: URL?
    @NSManaged var version: String
    
    
    convenience init(context: NSManagedObjectContext, item: Apod) {
        self.init(context: context)
        self.updateItem(item: item)
    }
    
    // Method to update the Core Data object with values from an `Apod` object
    func updateItem(item: Apod) {
        self.apodDate = item.date
        self.title = item.title
        self.explanation = item.explanation
        self.mediaURL = item.url
        self.version = item.service_version
        self.mediaType = item.mediaType.rawValue
        self.date = Date()
    }
}

extension ItemApod {
    // Converts a Core Data `ItemApod` object into an `Apod` model object
    func toModel() -> Apod {
        Apod(
            date: apodDate,
            explanation: explanation,
            media_type: mediaType,
            title: title,
            service_version: version,
            url: mediaURL
        )
    }
}


