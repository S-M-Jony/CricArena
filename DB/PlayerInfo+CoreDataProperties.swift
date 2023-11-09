//
//  PlayerInfo+CoreDataProperties.swift
//  cricArena
//
//  Created by Shahnewaz on 21/2/23.
//
//

import Foundation
import CoreData
extension PlayerInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerInfo> {
        return NSFetchRequest<PlayerInfo>(entityName: "PlayerInfo")
    }
    @NSManaged public var playerId: Int32
    @NSManaged public var playerImage: String?
    @NSManaged public var playerName: String?
}
extension PlayerInfo : Identifiable {

}
