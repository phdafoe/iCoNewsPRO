//
//  TitularServerModel.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation

// MARK: - TitularServerModel
struct TitularServerModel: Codable {
    let status: Bool?
    let time: Int?
    let format: String?
    let options: Options?
    let data: [DatumTitular]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case time = "time"
        case format = "format"
        case options = "options"
        case data = "data"
    }
}

// MARK: - Datum
struct DatumTitular: Codable, Identifiable {
    let id: Int?
    let title: String?
    let url: String?
    let caption: String?
    let text: String?
    let active: Bool?
    let typedescription: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case url = "url"
        case caption = "caption"
        case text = "text"
        case active = "active"
        case typedescription = "typedescription"
    }
}

// MARK: - Options
struct Options: Codable {
    let offset: Int?
    let limit: Int?
    let totalrecords: Int?

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case totalrecords = "totalrecords"
    }
}
