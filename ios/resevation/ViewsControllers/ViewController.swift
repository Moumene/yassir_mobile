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
import Alamofire
import SwiftyJSON
import SVProgressHUD
class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    
    let URL_API = "http://192.168.1.215:8080/data"
    

    
    @IBOutlet weak var navigtionView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heureLabel: UILabel!

    
    @IBOutlet weak var PassengerPicture: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RatingLabel: UILabel!
    
    
    @IBOutlet weak var TitleAddressSourceLabel: UILabel!
    @IBOutlet weak var AddressSourceLabel: UILabel!
    @IBOutlet weak var TitleAddressDestinationLabel: UILabel!
    @IBOutlet weak var AddressDestinationLabel: UILabel!
    
    @IBOutlet weak var CostLabel: UILabel!
    
    @IBOutlet weak var IDLabel: UILabel!
    //@IBOutlet weak var heureView: UIView!
    @IBOutlet weak var notifIcon: UIImageView!
    
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var passagerView: UIView!
    @IBOutlet weak var trajetView: UIView!
    @IBOutlet weak var sommeView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var notifButton: UIButton!
    var dateNotif : Date!
    var notif: Bool!
    var ride: Ride!
    
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate


    override func viewDidLoad() {
        getRiderData(url: URL_API)
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        let nav = self.navigationController?.navigationBar
        nav?.barStyle=UIBarStyle.black

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
    
    func getRiderData(url : String){
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success! got the rider data")
                self.ride = parseRide(jsonObj: JSON(response.result.value!))
                
                let date: Date = self.ride.dateTime
                self.dateLabel.text = parseDateToString(date: date)
                self.heureLabel.text = parseTimeToString(date: date)
                
                self.NameLabel.text = self.ride.passenger.fullName
                self.RatingLabel.text = String(Float(self.ride.passenger.rating))
                //self.PhoneNumber = ride.passenger.phoneNumber
                
                self.TitleAddressSourceLabel.text = self.ride.source.name
                self.AddressSourceLabel.text = self.ride.source.address
                //retrieve GPS coords
                self.TitleAddressDestinationLabel.text = self.ride.destination.address
                self.AddressDestinationLabel.text = self.ride.destination.address
                //retrieve GPS coords
                
                self.CostLabel.text = ("\(self.ride.cost) Da")
                self.IDLabel.text = self.ride.id
                self.updateNotif()
                
            }else{
                print("WTTTFFFFFFFFFFF")
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    func validateNotif(url : String, dateNotif : Date, dateReservation : Date){
        let parameters: [String: Any] = ["dateNotif" : dateNotif.timeIntervalSince1970, "dateRes" : dateReservation.timeIntervalSince1970]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess{
                let dataJSON : JSON = JSON(response.result.value!)
                if dataJSON["validation"] == "NOTIFICATION VALIDE"{
                    print ("notification accepté")
                    self.dateNotif = dateNotif
                    self.notif = true
                    self.notifIcon.isHidden = false
                    //let userActions = "User Actions"
                    
                    let date = parseDateToString(date: dateReservation) + parseTimeToString(date: dateReservation)
                    self.ajouterNotif(dateNotif: self.dateNotif, dateReservation: date, rider: self.ride.passenger.fullName, identifier:self.ride.id)
                    
                }else{
                    print("alerte indiquant l'entrée dune date non valide")
                    let alert = UIAlertController(title: "Date erronnée", message: "Vous avez introduit une date passée", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                    self.present(alert, animated: true)
                }
                
            }else{
                print("WTTTFFFFFFFFFFF")
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //xlet content = notification.request.content
        //print("Test: \(notification.request.identifier)")
        if (notification.request.identifier == self.ride.id){
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
                    if (request.identifier == self.ride.id){
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

        guard let url = URL(string: "tel://" + self.ride.passenger.phoneNumber )else {return}
        UIApplication.shared.open(url)
    }
    
    //ouvre l'app map avec les coordonnées donneés
    @IBAction func locateDepartPoint(_ sender: UIButton) {
        let latitude:CLLocationDegrees = ride.source.latitude
        let longitude:CLLocationDegrees = ride.source.longitude
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        } else {
        //print("Can't use comgooglemaps://")
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
        let latitude:CLLocationDegrees = ride.destination.latitude
        let longitude:CLLocationDegrees = ride.destination.longitude
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        } else {
            //print("Can't use comgooglemaps://")
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
    
    
    @IBAction func notifPressButton(_ sender: Any) {
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
                if (date != nil)
                {
                    self.validateNotif(url: self.URL_API, dateNotif: date!, dateReservation: self.ride.dateTime)
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
    
    func ajouterNotif (dateNotif:Date, dateReservation:String, rider:String, identifier:String){
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
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateNotif)
        print(triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // 4
        UNUserNotificationCenter.current().add(request)
        { (error) in if let error = error {
            print("Error \(error.localizedDescription)")
            }
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


