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
    var dashboardData: DashboardModel?
    var dashboardViewModels = [DashboardViewModel]()
    var indicator = UIActivityIndicatorView()

// MARK: setupDashboardactivityIndicator
    func activityIndicator() {
           indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
           indicator.style = UIActivityIndicatorView.Style.medium
           indicator.center = self.view.center
           self.view.addSubview(indicator)
       }
// MARK: startAnimating
       func startAnimating() {
           activityIndicator()
           indicator.startAnimating()
           indicator.backgroundColor = .white
       }
// MARK: stopAnimating
       func stopAnimating() {
           indicator.stopAnimating()
           indicator.hidesWhenStopped = true
       }
// MARK: viewDidLoad
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
    func isNetworkAvailable() {
        //To check network connectivity
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
        } else {
            self.showAlert("Error","Internet Not Available", "Dismiss")
        }
    }
    func getLoadedData() {
        //Getting data from service manager
        if Reachability.isConnectedToNetwork() {
                   print("Internet Connection Available!")
         if(!Constants.ConfigurationItems.serverURL.isEmpty){
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
         }else {
             self.showAlert("Error","URL Not Available", "Dismiss")
            }}
        else { self.showAlert("Error","Internet Not Available", "Dismiss")
        }
}
    func convertJsonzToViewModelArray(dashboardItems:[DashboardDetailsModel]) -> [DashboardViewModel] {
        var dashboardViewModelItems = [DashboardViewModel]()
        for dashboardItem in dashboardItems {
            let dashViewModel = DashboardViewModel(model:(dashboardItem))
            if !(dashViewModel.title).isEmpty {
                dashboardViewModelItems.append(dashViewModel)
            }
        }
        return dashboardViewModelItems
    }
// MARK: Common UIAlertView
   func showAlert(_ title: String, _ message: String, _ buttonTitle: String) {
       let alert = UIAlertController(title: "Alert",
                                     message: message,
                                     preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "Dismiss",
                                     style: UIAlertAction.Style.default,
                                     handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
// MARK: refreshDashboardData for UIRefreshControl
    @objc private func refreshUpdateData(_ sender: Any) {
           getLoadedData()
           tblDashboardView.endRefreshing(deadline: .now() + .seconds(3))
       }
// MARK: refreshData for Refresh ButtonAction
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
// MARK: tableview - for RefreshControl
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
