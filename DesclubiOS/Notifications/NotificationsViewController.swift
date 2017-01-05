//
//  NotificationsViewController.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation
import OneSignal

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var refreshControl:UIRefreshControl!
    private var isLoading:Bool = false

    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var notificationsTableView: UITableView!

    var arrNotifications = [OSNotification]()
    var offset = 0
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.notificationsTableView.delegate = self
        self.notificationsTableView.dataSource = self
        
        self.notificationsTableView.tableFooterView = UIView()
        
        //register custom cell
        let nib = UINib(nibName: "NotificationsViewCell", bundle: nil)
        notificationsTableView.registerNib(nib, forCellReuseIdentifier: "NotificationsViewCell")
        
        self.setUpLoadingIndicators()
        
        OneSignal.IdsAvailable { (user, token) in
            if let id = user {
                self.userID = id
            }
        }
        
        self.loadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalitycUtil.trackScreenName("analytics.screen.notifications")
    }
    
    func loadData() {
        
        if self.offset == -1 {
            return
        }
        
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        _ = SwiftSpinner.show("Cargando notificaciones")
        loadingIndicatorView.hidden = (self.arrNotifications.count == 0) ? true: false

        NotificationFacade.sharedInstance.getAllNotificationsWithOffset(self, number: self.offset, completionHandler: { (response :NotificationsRepresentation?) in
            
            self.isLoading = false
            SwiftSpinner.hide()
            self.refreshControl.endRefreshing()

            if let data = response {
                
                if self.offset == -1 {
                    return
                }
                
                if let limit = data.limit {
                    
                    self.offset = self.offset + limit

                    if let total = data.total_count{
                        if self.offset > total {
                            self.offset = -1
                        }
                    }
                }
                
                for obj in data.getArrNotificationsIOS(self.userID) {
                    self.arrNotifications.append(obj)
                }
            }
            
            self.showEmptyResultsMessage("No tienes notificaciones.")

            self.notificationsTableView.reloadData()
            
        }) { (error) in
            
            self.showEmptyResultsMessage("Error de conexión. Verifica tu conexión a internet.")

            self.isLoading = false
            SwiftSpinner.hide()
            self.refreshControl.endRefreshing()

            if let err = error {
                print(err)
            }
        }
    }
    
    func refresh(sender:AnyObject?){
        self.offset = 0
        self.arrNotifications.removeAll()
        
        self.loadData()
    }
    
    //MARK:- TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.notificationsTableView.dequeueReusableCellWithIdentifier("NotificationsViewCell", forIndexPath: indexPath) as! NotificationsViewCell
        
        let obj = self.arrNotifications[indexPath.row]
        cell.configCell(obj)
        
        return cell

    }
    
    func tableView(tableView: UITableView, heightForRowAt indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: NSIndexPath) {
        
        if indexPath.row == self.arrNotifications.count-1 {
            self.loadData()
        }

    }
    
    // MARK:- private
    
    private func showEmptyResultsMessage(labelText:String){
        
        if self.arrNotifications.count == 0{
            
            let viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.notificationsTableView.bounds.size.width, height: self.notificationsTableView.bounds.size.height))
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.notificationsTableView.bounds.size.width, height: self.notificationsTableView.bounds.size.height))
            messageLabel.text = labelText
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            messageLabel.center = self.notificationsTableView.center
            
            let tryAgainButton = UIButton(frame: CGRect(x: 0, y: 30, width: self.notificationsTableView.bounds.size.width/2, height: 40))
            tryAgainButton.setTitle("Intentar de nuevo", forState: UIControlState.Normal)
            tryAgainButton.addTarget(self, action: #selector(NotificationsViewController.refresh(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            
            tryAgainButton.backgroundColor = UIColor.grayColor()
            tryAgainButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
            tryAgainButton.center = CGPoint(x: self.notificationsTableView.center.x, y: self.notificationsTableView.center.y + tryAgainButton.bounds.height)
            
            viewContainer.addSubview(messageLabel)
            viewContainer.addSubview(tryAgainButton)
            viewContainer.sizeToFit()
            
            self.notificationsTableView.backgroundView = viewContainer
        }
        
    }

    private func setUpLoadingIndicators(){
        //pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Actualizando ...")
        
        refreshControl.addTarget(self, action: #selector(NotificationsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        notificationsTableView.addSubview(refreshControl)
        
        spinner.startAnimating()
        spinner.transform = CGAffineTransformMakeScale(1.75, 1.75);
        
    }
}
