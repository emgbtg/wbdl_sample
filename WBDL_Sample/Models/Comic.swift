import Foundation

struct ComicResult: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: DataClass
}

struct DataClass: Codable {
    let offset, limit, total, count: Int
    let results: [Comic]
}

struct Comic: Codable {
    let id, digitalID: Int
    let title: String
    let description: String?
    let pageCount: Int
    let series: ComicSeries
    let prices: [Price]
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    let characters: Characters
    
    enum CodingKeys: String, CodingKey {
        case digitalID = "digitalId"
        case title, thumbnail, characters, id, series, description, images, pageCount, prices
    }
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

struct Price: Codable {
    let type: String
    let price: Double
}
enum Extension: String, Codable {
    case jpg = "jpg"
}

struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

struct ComicSeries: Codable {
    let resourceURI: String
    let name: String
}
struct URLs: Codable {
    let type: URLType
    let url: String
}
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
enum URLType: String, Codable {
    case detail = "detail"
    case reader = "reader"
}
