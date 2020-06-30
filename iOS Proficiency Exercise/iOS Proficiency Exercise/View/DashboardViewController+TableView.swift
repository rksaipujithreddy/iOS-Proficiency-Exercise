//
//  DashboardViewController+TableView.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 29/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import UIKit

extension DashboardViewController: UITableViewDelegate,UITableViewDataSource {
// MARK: tableview : numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
// MARK: tableview : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return  self.dashboardViewModels.count
    }
// MARK: tableview : cellForRowAtIndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //table view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ConfigurationItems.cellIdentifier,
                                                         for: indexPath) as? DashboardTableViewCell else {
               // you can have your custom error
               // return the default cell as method return expect it
               return UITableViewCell()
        }
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.selectionStyle = .none

        cell.displayDataInCell(using: self.dashboardViewModels[indexPath.row])
        //UITestCaseSupport
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = String(format: "dtTVC_%d_%d",
        indexPath.section, indexPath.row)
        cell.lblTitle.isAccessibilityElement = true
        cell.lblTitle.accessibilityIdentifier = String(format: "TitleLabel",
        indexPath.section, indexPath.row)
        cell.lblDescription.isAccessibilityElement = true
        cell.lblDescription.accessibilityIdentifier = String(format: "DescriptionLabel",
              indexPath.section, indexPath.row)
        cell.imgDisplay.isAccessibilityElement = true
        cell.imgDisplay.accessibilityIdentifier = String(format: "callActionImage",
                    indexPath.section, indexPath.row)
        cell.viewCellBg.isAccessibilityElement = true
        cell.viewCellBg.accessibilityIdentifier = String(format: "callBGImage",
                           indexPath.section, indexPath.row)
        return cell
    }

// MARK: tableview - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
return UITableView.automaticDimension
    }
// MARK: tableview - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggleRows
    }
// MARK: tableview - calculateHeight of Cell
    func calculateHeight(inString:String) -> CGFloat {
        let message = inString
        let attributes = NSDictionary.init(object: UIFont.systemFont(ofSize:CGFloat(Constants.ConfigurationItems.txtSize)),
                                           forKey:NSAttributedString.Key.font as NSCopying)
        let attributedString : NSAttributedString = NSAttributedString(string: message,
                                                                       attributes:
            attributes as? [NSAttributedString.Key : Any])
        let rect : CGRect = attributedString.boundingRect(with:
            CGSize(width: 222.0,
                   height: CGFloat.greatestFiniteMagnitude),
                                                          options: .usesLineFragmentOrigin,
                                                          context: nil)
        let requredSize:CGRect = rect
        return requredSize.height
    }
}
