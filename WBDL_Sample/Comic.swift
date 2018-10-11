import Foundation

struct Welcome: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: DataClass
}

struct DataClass: Codable {
    let offset, limit, total, count: Int
    let results: [Result]
}

struct Result: Codable {
    let id, digitalID: Int
    let title: String
//    let issueNumber: Int
//    let variantDescription: VariantDescription
//    let description: String?
//    let modified: ModifiedUnion
//    let isbn: Isbn
//    let upc: String
//    let diamondCode: DiamondCode
//    let ean: Ean
//    let issn: String
//    let format: Format
//    let pageCount: Int
//    let textObjects: [TextObject]
//    let resourceURI: String
//    //let urls: [URL]
//    let series: Series
//    let variants, collections: [Series]
//    let collectedIssues: [JSONAny]
    let dates: [DateElement]
    let prices: [Price]
    let thumbnail: Thumbnail
//    let images: [Thumbnail]
    let creators: Creators
    let characters: Characters
//    let stories: Stories
//    let events: Characters
    
    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, thumbnail, characters, dates, prices, creators
        //case title, issueNumber, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

struct Series: Codable {
    let resourceURI: String
    let name: String
}

struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

struct CreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

struct DateElement: Codable {
    let type: DateType
    let date: ModifiedUnion
}

enum ModifiedUnion: Codable {
    case dateTime(Date)
    case enumeration(ModifiedEnum)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Date.self) {
            self = .dateTime(x)
            return
        }
        if let x = try? container.decode(ModifiedEnum.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(ModifiedUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ModifiedUnion"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dateTime(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum ModifiedEnum: String, Codable {
    case the00011130T0000000500 = "-0001-11-30T00:00:00-0500"
}

enum DateType: String, Codable {
    case focDate = "focDate"
    case onsaleDate = "onsaleDate"
    case unlimitedDate = "unlimitedDate"
}

enum DiamondCode: String, Codable {
    case aug082435 = "AUG082435"
    case empty = ""
}

enum Ean: String, Codable {
    case empty = ""
    case the978078512178753999 = "9780785 121787 53999"
}

enum Format: String, Codable {
    case comic = "Comic"
    case digitalComic = "Digital Comic"
    case hardcover = "Hardcover"
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case jpg = "jpg"
}

enum Isbn: String, Codable {
    case empty = ""
    case the9780785121787 = "978-0-7851-2178-7"
}

struct Price: Codable {
    let type: PriceType
    let price: Double
}

enum PriceType: String, Codable {
    case printPrice = "printPrice"
}

struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: ItemType
}

enum ItemType: String, Codable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
    case letters = "letters"
    case promo = "promo"
}

struct TextObject: Codable {
    let type, language, text: String
}

struct URLs: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case detail = "detail"
    case reader = "reader"
}

enum VariantDescription: String, Codable {
    case empty = ""
    case jimenezBlackPanther50ThAnniversaryVariant = "Jimenez Black Panther 50th Anniversary Variant"
    case lozanoTeaserVariant = "Lozano Teaser Variant"
    case xMenAgeOfApocalypse = "X-MEN - AGE OF APOCALYPSE"
}

// MARK: Encode/decode helpers

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

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
