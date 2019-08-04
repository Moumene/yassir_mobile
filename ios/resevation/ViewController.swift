//
//  ViewController.swift
//  resevation
//
//  Created by mac on 7/28/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import MapKit
class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var navigtionView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heureLabel: UILabel!
    //@IBOutlet weak var heureView: UIView!
    @IBOutlet weak var notifIcon: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var passagerView: UIView!
    @IBOutlet weak var trajetView: UIView!
    @IBOutlet weak var sommeView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var notifButton: UIButton!
    var dateNotif : Date!
    var notif: Bool!
    var request:UNNotificationRequest!
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self

        self.dateLabel.cornerRadius(usingCorners: [.topLeft,.bottomLeft], cornerRadii:CGSize(width : 20,height : 20))
        
        self.dateView.layer.shadowPath =
            UIBezierPath(roundedRect: self.dateView.bounds,
                         cornerRadius: self.dateView.layer.cornerRadius).cgPath
        self.dateView.layer.shadowColor = UIColor.gray.cgColor
        self.dateView.layer.shadowOpacity = 0.5
        self.dateView.layer.shadowOffset = CGSize(width:0, height: 0)
        self.dateView.layer.shadowRadius = 10
        self.dateView.layer.masksToBounds = false

        self.heureLabel.cornerRadius(usingCorners: [.topRight,.bottomRight], cornerRadii:CGSize(width : 20,height : 20))
        self.callButton.cornerRadius(usingCorners: [.allCorners],
            cornerRadii:CGSize(width : 10,height : 10))
        self.informationButton.cornerRadius(usingCorners: [.allCorners],
            cornerRadii:CGSize(width : 20,height : 20))
        
        self.passagerView.setShadow()
        
        self.trajetView.setShadow() 

        self.sommeView.setShadow()

        self.idView.setShadow()
        
        
        updateNotif()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotif), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("cnvngvh")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //xlet content = notification.request.content
        //print("Test: \(notification.request.identifier)")
        if (notification.request.identifier == "dateView_rappel"){
            self.notifIcon.isHidden = true
            self.notif=false
        }
        
        completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //print("Test: \(response.notification.request.identifier)")
//        if (response.notification.request.identifier == "dateView_rappel"){
//            self.notifIcon.isHidden = true
//            self.notif=false
//        }
    }
    
    @objc func updateNotif() {
        self.notifIcon.isHidden = true
        self.notif=false
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            DispatchQueue.main.async { 
                for request in requests {
                    if (request.identifier == "dateView_rappel"){
                        self.notif=true
                    }
                }
                self.notifIcon.isHidden = !self.notif
            }
            
        })
    }
    
    //fonction de retour
    @IBAction func pop(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //fonction d'appel
    @IBAction func tellAccess(_ sender: UIButton) {
        var number : String
        number = "0559882554"
        guard let url = URL(string: "tel://" + number )else {return}
        UIApplication.shared.open(url)
    }
    
    //ouvre l'app map avec les coordonnées donneés
    @IBAction func locateDepartPoint(_ sender: UIButton) {
        let latitude:CLLocationDegrees = 36.811336
        let longitude:CLLocationDegrees = 3.236343
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
            } else {
            //print("Can't use comgooglemaps://")
                let latitude:CLLocationDegrees = 36.811336
                let longitude:CLLocationDegrees = 3.236343
                let regionDistance:CLLocationDistance = 1000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [MKLaunchOptionsCameraKey : NSValue(mkCoordinate : regionSpan.center), MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
            
                let placemark = MKPlacemark(coordinate:coordinates)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "My House"
                mapItem.openInMaps(launchOptions: options )
            }
    }
    
    @IBAction func locateArrivalPoint(_ sender: UIButton) {
    }
    
    
    
    @IBAction func ajouterNotif(_ sender: Any) {
        if (notif==false)
        {
            DatePickerDialog(locale: Locale(identifier: "fr_FR")).show("Ajouter une alarme", doneButtonTitle: "AJOUTER", cancelButtonTitle: "CANCEL", datePickerMode: .dateAndTime)
            {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy HH:mm"
                    _ = formatter.string(from: dt)
                }
                print(date ?? "error")
                if (date != nil)
                {
                    if (date! < Date())
                    {
                        let alert = UIAlertController(title: "Date erronnée", message: "Vous avez introduit une date passée", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))

                        self.present(alert, animated: true)
                    }else {
                        self.dateNotif = date
                        self.notif = true
                        self.notifIcon.isHidden = false
                        let dateReservation : String!
                        let rider : String!
                        dateReservation = "19/08/2019 15:15"
                        rider = "alaa"
                        //let userActions = "User Actions"
                        let content = UNMutableNotificationContent()
                        content.title = "Resrvation client"
                        content.subtitle = rider
                        content.body = dateReservation
                        // 2
                        //let imageName = "student"
                        //guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
                        //let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                        //content.attachments = [attachment]
                        //let date = Date(timeIntervalSinceNow: 30)
                        
                        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: self.dateNotif)
                        print(triggerDate)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                        let identifier = "dateView_rappel"
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        // 4
                        self.request=request
                        UNUserNotificationCenter.current().add(request)
                        { (error) in if let error = error {
                            print("Error \(error.localizedDescription)")
                            self.request=nil
                            }
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "Suprimer l'alarme ?", message: "Êtes-vous sûr de vouloir supprimer définitivement l’alarme ?", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive,handler : { (action) -> Void in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dateView_rappel"])
                self.dateNotif = nil
                self.notif = false
                self.notifIcon.isHidden = true
            }))

            alert.addAction(UIAlertAction(title: "Garder", style: .cancel, handler:nil))
            
            self.present(alert, animated: true)
        }
    }
}
extension UIView {
    func cornerRadius(usingCorners corners : UIRectCorner, cornerRadii: CGSize) {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path=path.cgPath
        self.layer.mask = maskLayer
    }
    
    func setShadow() {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width:0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
}


