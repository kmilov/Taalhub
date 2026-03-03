import Foundation
import CoreData

@objc(VerbEntity)
public class VerbEntity: NSManagedObject {
}

extension VerbEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VerbEntity> {
        return NSFetchRequest<VerbEntity>(entityName: "VerbEntity")
    }

    @NSManaged public var infinitive: String?
    @NSManaged public var pastTense: String?
    @NSManaged public var pastParticiple: String?
    @NSManaged public var english: String?
    @NSManaged public var spanish: String?
    @NSManaged public var sentences: [String]?
}

extension VerbEntity {
    func toVerbCard() -> VerbCard {
        VerbCard(
            infinitive: self.infinitive ?? "",
            vtt: self.pastParticiple ?? "",
            ovt: self.pastTense ?? "",
            isIrregular: false,
            sentences: sentences ?? [],
            auxVerb: "hebben",
            english: self.english ?? "",
            spanish: self.spanish ?? ""
        )
    }
}
