//
//  DashboardViewController.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var tblDashboardView   = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
    var lblNoData = UILabel()
    var dashboardData: DashboardModel?
    var dashboardViewModel : DashboardViewModel?
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.getLoadedData()
        self.setupDashboardTableView()
        // Do any additional setup after loading the view.
    }
    
    func getLoadedData() {
        ServiceManager.sharedInstance.getData(baseURL: Constants.ConfigurationItems.serverURL, onSuccess: { data in
            DispatchQueue.main.async {
                do {
                    let jsonDecoder = JSONDecoder()
                    self.dashboardData = try jsonDecoder.decode(DashboardModel.self, from: data)
                    DispatchQueue.main.async {
                        self.navigationItem.title =  self.dashboardData?.titleValue
                        self.tblDashboardView.reloadData()
                    }
                } catch {
                }
            }
        }, onFailure: { error in
        })
    }
    
    
    func setupDashboardTableView() {
        tblDashboardView = UITableView()
        tblDashboardView.translatesAutoresizingMaskIntoConstraints = false
        tblDashboardView.dataSource = self
        tblDashboardView.delegate = self
        tblDashboardView.backgroundColor = UIColor.clear
        tblDashboardView.register(DashboardTableViewCell.self, forCellReuseIdentifier:Constants.ConfigurationItems.cellIdentifier)
        lblNoData = UILabel(frame:
            CGRect(x: 0, y: 0, width: tblDashboardView.bounds.size.width, height:tblDashboardView.bounds.size.height))
        lblNoData.text = Constants.ConfigurationItems.noDataText
        lblNoData.textColor = UIColor.black
        lblNoData.textAlignment = .center
        lblNoData.isHidden = true
        tblDashboardView.backgroundView = lblNoData
        tblDashboardView.separatorStyle = .none
        tblDashboardView.rowHeight = UITableView.automaticDimension
        tblDashboardView.estimatedRowHeight = UITableView.automaticDimension
//        tblDashboardView.addRefreshControll(actionTarget: self, action: #selector(refreshUpdateData))

        self.view.addSubview(tblDashboardView)
        NSLayoutConstraint.activate([
            tblDashboardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            tblDashboardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8),
            tblDashboardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            tblDashboardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
        tblDashboardView.showsHorizontalScrollIndicator = false
        tblDashboardView.showsVerticalScrollIndicator = false
    }

}

extension DashboardViewController: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: tableview : numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: tableview : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dashboardData?.rowValue?.count == 0 {
            lblNoData.isHidden = false
        } else {
            lblNoData.isHidden = true
        }
        return dashboardData?.rowValue?.count ?? 0
    }
    
    //MARK: tableview : cellForRowAtIndexPath
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
        if dashboardData?.rowValue?[indexPath.row].titleValue != nil {
            
        let dashViewModel = DashboardViewModel(model:(dashboardData?.rowValue?[indexPath.row])!)
            cell.displayDataInCell(using: dashViewModel)
           
        } else {
            cell.viewCellBg.removeFromSuperview()
        }
        return cell
    }
    
    //MARK: tableview - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if dashboardData?.rowValue?[indexPath.row].titleValue == nil {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    //MARK: tableview - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggleRows
    }
    
    //MARK: tableview - calculateHeight of Cell
    func calculateHeight(inString:String) -> CGFloat {
        let message = inString
        let attributes = NSDictionary.init(object: UIFont.systemFont(ofSize: 15.0),
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

