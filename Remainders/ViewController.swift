//
//  ViewController.swift
//  Remainders
//
//  Created by Yuvraj Vijay Agarkar on 26/10/20.
//

import UIKit
import UserNotifications
let name = Notification.Name("pushData")
class ViewController: UIViewController {
  var remainder = [MyRemainder]()
    @IBOutlet var tableView:UITableView!
    @IBAction func addPressed(_ sender:UIBarButtonItem){
//        show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            
            return
        }
        vc.title = "New Remainder"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func testPressed(_ sender:UIBarButtonItem){
//   permission for notifications and we can request authorization , current is the shared istan of notifCenter
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (success, error) in
            if success {
//                schedule notifi
                self.scheduleNotification()
            }else if let error = error {
                print("error occured \(error)")
            }
        }
    }
    func scheduleNotification(){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotifi), name: name, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func didReceiveNotifi(_ notification:Notification){
        let dict = notification.userInfo as? [String:Any]
        let new = MyRemainder(title: dict!["title"] as! String, date: dict!["date"] as! Date, identifier: "id_\(dict!["date"])")
        remainder.append(new)
        self.tableView.reloadData()
        let content = UNMutableNotificationContent()
        content.title = new.title
        content.body = dict!["body"] as! String
        content.sound = .default
        let targetDate = new.date
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate)
        print(dateComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("something went wrong \(error)")
            }
        }
    }

}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    MARK:- dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        remainder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = remainder[indexPath.row].title
        return cell
    }
    
    
}
struct MyRemainder {
    let title:String
    let date:Date
    let identifier:String
}
