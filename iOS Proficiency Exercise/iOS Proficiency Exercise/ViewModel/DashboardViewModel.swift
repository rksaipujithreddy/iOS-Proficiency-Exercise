//
//  DashboardViewModel.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import Foundation

class DashboardViewModel {
    
    //MARK:- getDashboardData API Service call
    func getDashboardData()-> DashboardModel{
        var dashboardData: DashboardModel?
        ServiceManager.sharedInstance.getData(baseURL: Constants.ConfigurationItems.serverURL, onSuccess: { data in
//            DispatchQueue.main.async {
                do {
                    let jsonDecoder = JSONDecoder()
                    dashboardData = try jsonDecoder.decode(DashboardModel.self, from: data)
                } catch {
                }
//            }
        }, onFailure: { error in
        })
        return dashboardData!
    }
    
    
}
