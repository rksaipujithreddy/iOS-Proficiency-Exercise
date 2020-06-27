//
//  DashboardViewModel.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import Foundation

struct DashboardViewModel {
    
    let title: String
    let imageURL: String
    let description: String

    init(model: DashboardDetailsModel) {
        self.title = model.titleValue?.uppercased() ?? ""
        self.imageURL = model.imageReferenceValue ?? ""
        self.description = model.descriptionValue ?? ""
    }
}
