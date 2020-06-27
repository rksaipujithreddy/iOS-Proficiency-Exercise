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
    var dashboardViewModels = [DashboardViewModel]()
    private let refreshDashboard = UIRefreshControl()
    var indicator = UIActivityIndicatorView()

    
    //MARK:- setupDashboardactivityIndicator
       func activityIndicator() {
           indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
           indicator.style = UIActivityIndicatorView.Style.medium
           indicator.center = self.view.center
           self.view.addSubview(indicator)
       }
       
       //MARK: startAnimating
       func startAnimating() {
           activityIndicator()
           indicator.startAnimating()
           indicator.backgroundColor = .white
       }
       
       //MARK: stopAnimating
       func stopAnimating() {
           indicator.stopAnimating()
           indicator.hidesWhenStopped = true
       }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(self.refreshData))
        isNetworkAvailable()
        activityIndicator()
        self.getLoadedData()
        self.setupDashboardTableView()
        // Do any additional setup after loading the view.
    }
    
    func isNetworkAvailable()
    {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            self.showAlert("Error","Internet Not Available", "Dismiss")

        }
    }
    
    
    func getLoadedData() {
        if Reachability.isConnectedToNetwork(){
                   print("Internet Connection Available!")
               
        ServiceManager.sharedInstance.getData(baseURL: Constants.ConfigurationItems.serverURL, onSuccess: { data in
            DispatchQueue.main.async {
                do {
                    let jsonDecoder = JSONDecoder()
                    self.dashboardData = try jsonDecoder.decode(DashboardModel.self, from: data)
               
                    self.dashboardViewModels = self.convertJsonzToViewModelArray(dashboardItems: (self.dashboardData?.rowValue)!)
                    DispatchQueue.main.async {
                        self.navigationItem.title =  self.dashboardData?.titleValue
                        self.tblDashboardView.reloadData()
                    }
                } catch {
                    self.showAlert("Error", error.localizedDescription,"Dismiss")

                }
            }
        }, onFailure: { error in
            self.showAlert("Error", error.localizedDescription,"Dismiss")
        })
            }else{
                       self.showAlert("Error","Internet Not Available", "Dismiss")

                   }
    }
   //MARK:- Common UIAlertView
   func showAlert(_ title: String, _ message: String, _ buttonTitle: String) {
       let alert = UIAlertController(title: "Alert",
                                     message: message,
                                     preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "Dismiss",
                                     style: UIAlertAction.Style.default,
                                     handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
  //MARK:- refreshDashboardData for UIRefreshControl
    @objc private func refreshUpdateData(_ sender: Any) {
           getLoadedData()
           tblDashboardView.endRefreshing(deadline: .now() + .seconds(3))
       }
       
       //MARK:- refreshData for Refresh ButtonAction
    @objc func refreshData(_ refreshControl: UIRefreshControl) {
           tblDashboardView.pullAndRefresh()
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
        tblDashboardView.addRefreshControll(actionTarget: self, action: #selector(refreshUpdateData))

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

        return  self.dashboardViewModels.count
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

        cell.displayDataInCell(using: self.dashboardViewModels[indexPath.row])
        return cell
    }
    
    func convertJsonzToViewModelArray(dashboardItems:[DashboardDetailsModel]) -> [DashboardViewModel] {
        var dashboardViewModelItems = [DashboardViewModel]()
        for dashboardItem in dashboardItems {
            let dashViewModel = DashboardViewModel(model:(dashboardItem))
            if !(dashViewModel.title).isEmpty
            {
                dashboardViewModelItems.append(dashViewModel)
            }
        }
        return dashboardViewModelItems
    }
    
    //MARK: tableview - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            return UITableView.automaticDimension
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

//MARK:- tableview - for RefreshControl
public extension UITableView {

    private var myRefreshControl: DashboardRefreshControl? { return refreshControl as? DashboardRefreshControl }

    func addRefreshControll(actionTarget: AnyObject?, action: Selector, replaceIfExist: Bool = false) {
        if !replaceIfExist && refreshControl != nil { return }
        refreshControl = DashboardRefreshControl(actionTarget: actionTarget, actionSelector: action)
    }

    func scrollToTopAndShowRunningRefreshControl(changeContentOffsetWithAnimation: Bool = false) {
        myRefreshControl?.refreshActivityIndicatorView()
        guard   let refreshControl = refreshControl,
                contentOffset.y != -refreshControl.frame.height else { return }
        setContentOffset(CGPoint(x: 0,
                                 y: -(refreshControl.frame.height + 75)),
                         animated: changeContentOffsetWithAnimation)
    }

    private var canStartRefreshing: Bool {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else { return false }
        return true
    }

    func startRefreshing() {
        guard canStartRefreshing else { return }
        myRefreshControl?.generateRefreshEvent()
    }

    func pullAndRefresh() {
        guard canStartRefreshing else { return }
        scrollToTopAndShowRunningRefreshControl(changeContentOffsetWithAnimation: true)
        myRefreshControl?.generateRefreshEvent()
    }

    func endRefreshing(deadline: DispatchTime? = nil) { myRefreshControl?.endRefreshing(deadline: deadline) }
}
