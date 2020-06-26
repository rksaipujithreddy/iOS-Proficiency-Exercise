//
//  DashboardModel.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import Foundation

struct DashboardModel : Codable {
    let titleValue : String?
    let rowValue : [DashboardDetailsModel]?

    enum CodingKeys: String, CodingKey {

        case titleValue = "title"
        case rowValue = "rows"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        titleValue = try values.decodeIfPresent(String.self, forKey: .titleValue)
        rowValue = try values.decodeIfPresent([DashboardDetailsModel].self, forKey: .rowValue)
    }

}

struct DashboardDetailsModel : Codable {
    let titleValue : String?
    let descriptionValue : String?
    let imageReferenceValue : String?

    enum CodingKeys: String, CodingKey {

        case titleValue = "title"
        case descriptionValue = "description"
        case imageReferenceValue = "imageHref"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        titleValue = try values.decodeIfPresent(String.self, forKey: .titleValue)
        descriptionValue = try values.decodeIfPresent(String.self, forKey: .descriptionValue)
        imageReferenceValue = try values.decodeIfPresent(String.self, forKey: .imageReferenceValue)
    }

}
