
import Foundation

struct SeriesResult: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: DataClassSeries
}

struct DataClassSeries: Codable {
    let offset, limit, total, count: Int
    let seriesResults: [Series]
    
    enum CodingKeys: String, CodingKey {
        case seriesResults = "results"
        case offset, limit, total, count
    }
}

struct Series: Codable {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let urls: [URLs]
    let startYear, endYear: Int
    let rating, type: String
    //let modified: Date
    let thumbnail: Thumbnail
    //let creators, characters, stories, comics: Characters
    //let events: Characters
    let comics: SeriesComics
    let next, previous: JSONNull?
}


struct Item: Codable {
    let resourceURI: String
    let name: String
    let role, type: String?
}
struct SeriesComics: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
}

//struct URL: Codable {
//    let type: String
//    let url: String
//}

// MARK: Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
