
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
    let thumbnail: Thumbnail
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

