//
//  Character.swift
//  WBDL_Sample
//
//  Created by Eric Gilbert on 10/12/18.
//  Copyright © 2018 Eric Gilbert. All rights reserved.
//

import Foundation

struct ComicCharacter: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: CharacterDataClass
}
struct CharacterDataClass: Codable {
    let offset, limit, total, count: Int
    let results: [CharacterInfo]
}

struct CharacterInfo: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}
