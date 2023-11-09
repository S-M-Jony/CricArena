//
//  SearchPlayerModel.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import Foundation
struct Player: Codable, Sequence {
    let data: [AllPlayer]?
    func makeIterator() -> PlayerIterator {
        return PlayerIterator(data: data)
    }
    struct PlayerIterator: IteratorProtocol {
        let data: [AllPlayer]?
        var currentIndex = 0
        init(data: [AllPlayer]?) {
            self.data = data
        }
        mutating func next() -> AllPlayer? {
            guard let data = data, currentIndex < data.count else {
                return nil
            }
            let result = data[currentIndex]
            currentIndex += 1
            return result
        }
    }
}

struct AllPlayer: Codable {
    let id: Int?
    let fullname: String?
    let image_path: String?
    let updatedAt: String?
}


