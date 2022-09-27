import Foundation

struct MainResponseData: Codable {
    var data: [ViewInfo]
    var view: [String]
}

struct ViewInfo: Codable {
    var name: String
    var data: ViewInfoData
}

struct ViewInfoData: Codable {
    var text: String?
    var url: String?
    var imageData: Data?
    var selectedId: Int?
    var variants: [SelectorVariant]?
}

struct SelectorVariant: Codable {
    var id: Int
    var text: String
}
