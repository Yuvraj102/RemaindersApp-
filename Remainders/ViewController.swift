//
//  ViewController.swift
//  Remainders
//
//  Created by Yuvraj Vijay Agarkar on 26/10/20.
//

import UIKit
import CoreData
import UserNotifications
let name = Notification.Name("pushData")
class ViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
//    @IBAction func testPressed(_ sender:UIBarButtonItem){
//        //   permission for notifications and we can request authorization , current is the shared istan of notifCenter
//        scheduleNotification()
//    }
    func scheduleNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (success, error) in
            if success {
                //                schedule notifi
                
            }else if let error = error {
                print("error occured \(error)")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do{
            try context.save()
        }catch {
            print("problem in saving data in viewDidAppear\(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scheduleNotification()
        do{
            remainder = try context.fetch(MyRemainder.fetchRequest())
        } catch {
            print("error in viewdidLoad while fetching data\(error)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotifi), name: name, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func didReceiveNotifi(_ notification:Notification){
        let dict = notification.userInfo as? [String:Any]
        let new = MyRemainder(context: context)
        new.title = dict!["title"] as! String
        new.date = dict!["date"] as! Date
        new.identifier = "id_\(dict!["date"])"
        //            MyRemainder(title: dict!["title"] as! String, date: dict!["date"] as! Date, identifier: "id_\(dict!["date"])")
        remainder.append(new)
        self.tableView.reloadData()
        do{
            try context.save()
        }catch {
            print("there is error saving data\(error)")
        }
        let content = UNMutableNotificationContent()
        content.title = new.title!
        content.body = dict!["body"] as! String
        content.sound = .default
        let targetDate = new.date
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate!)
        print(dateComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uidString, content: content, trigger: trigger)
        if new.identifier != nil {
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("something went wrong \(error)")
                }
            }
        }
        
        //
    }
    
}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(remainder[indexPath.row])
            try! context.save()
            remainder = try! context.fetch(MyRemainder.fetchRequest())
            tableView.reloadData()
        }
    }
    //    MARK:- dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        remainder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = remainder[indexPath.row].title
        let date = remainder[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd,YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date!)
        return cell
    }
    
    
}
//struct MyRemainder {
//    let title:String
//    let date:Date
//    let identifier:String
//}
