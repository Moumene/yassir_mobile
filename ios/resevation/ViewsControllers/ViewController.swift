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
import RealmSwift

class ViewController: UIViewController,UNUserNotificationCenterDelegate,CLLocationManagerDelegate {
    
    let URL_API = "http://localhost:8080/data"
    
    let locationManager = CLLocationManager()
    var dateNotif : Date!
    var notif: Bool!
    var ride : Ride!
    var passenger : Passenger!
    var passengers : Results<Passenger>?
    var currentLocation : CLLocation!
    let realm = try! Realm()
    
    
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
    @IBOutlet weak var notifIcon: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var passagerView: UIView!
    @IBOutlet weak var trajetView: UIView!
    @IBOutlet weak var sommeView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var notifButton: UIButton!
    
    
    override func viewDidLoad() {
        
        getRiderData(url: URL_API,completion: {
            self.upDateUI()
            
            self.updateNotif()
        })
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        //        let nav = self.navigationController?.navigationBar
        //        nav?.barStyle=UIBarStyle.black
        
        self.dateLabel.cornerRadius(usingCorners: [.topLeft,.bottomLeft], cornerRadii:CGSize(width : 20,height : 20))
        
        self.heureLabel.cornerRadius(usingCorners: [.topRight,.bottomRight], cornerRadii:CGSize(width : 20,height : 20))
        self.callButton.cornerRadius(usingCorners: [.allCorners],
                                     cornerRadii:CGSize(width : 10,height : 10))
        self.informationButton.cornerRadius(usingCorners: [.allCorners],
                                            cornerRadii:CGSize(width : 20,height : 20))
        
        
        self.dateView.setShadow(color: UIColor.gray.cgColor, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 10)
        
        self.passagerView.setShadow(color: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width:0, height: 0), shadowRadius: 2)
        
        self.trajetView.setShadow(color: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width:0, height: 0), shadowRadius: 2)
        
        self.sommeView.setShadow(color: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width:0, height: 0), shadowRadius: 2)
        
        self.idView.setShadow(color: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width:0, height: 0), shadowRadius: 2)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotif), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            //print("longitude = \(location.coordinate.longitude ),latitude = \(location.coordinate.latitude ), ")
            //let longitude = String(location.coordinate.longitude)
            self.currentLocation=location
            print("longitude = \(self.currentLocation.coordinate.longitude ),latitude = \(self.currentLocation.coordinate.latitude ), ")
            
        }
        
    }
    
    func getRiderData(url : String, completion : @escaping ()->()){
        Alamofire.request(url, method: .get).responseJSON{ response in
            if response.result.isSuccess{
                print("Success! got the rider data")
                self.passenger = parseRide(jsonObj: JSON(response.result.value!))
                self.ride = self.passenger.rides[0]
                
                self.load()
                
                print(self.passengers?.count)
                
                if self.passengers?.count == 0 {
                    self.save()
                }else{
                    if let passenger = self.passengers?[0] {
                        do {
                            try self.realm.write {
                                passenger.fullName = self.passenger.fullName
                                passenger.phoneNumber = self.passenger.phoneNumber
                                passenger.rating = self.passenger.rating
                                passenger.rides[0] = self.ride
                            }
                        }catch{
                            print("Error updating datas , \(error)")
                        }
                    }
                }
                
            }else{
                print("Error \(String(describing: response.result.error))")
                self.load()
                if self.passengers?.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.passenger = self.passengers![0]
                    
                    self.ride = self.passenger.rides[0]
                }
            }
            completion()
        }
        
    }
    
    func upDateUI() {
        let date: Date = self.ride.dateTime
        self.dateLabel.text = parseDateToString(date: date)
        self.heureLabel.text = parseTimeToString(date: date)
        
        self.NameLabel.text = self.passenger.fullName
        self.RatingLabel.text = String(Float(self.passenger.rating))
        //self.PhoneNumber = ride.passenger.phoneNumber
        
        self.TitleAddressSourceLabel.text = self.ride.source?.name
        self.AddressSourceLabel.text = self.ride.source?.address
        //retrieve GPS coords
        self.TitleAddressDestinationLabel.text = self.ride.destination?.address
        self.AddressDestinationLabel.text = self.ride.destination?.address
        //retrieve GPS coords
        
        self.CostLabel.text = ("\(self.ride.cost) Da")
        self.IDLabel.text = self.ride.id
    }
    
    func validateNotif(url : String, dateNotif : Date, dateReservation : Date){
        let parameters: [String: Any] = ["dateNotif" : dateNotif.timeIntervalSince1970, "dateRes" : dateReservation.timeIntervalSince1970]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if let statusCode = response.response?.statusCode  {
                print(statusCode)
            }
            
            if response.result.isSuccess{
                if response.response?.statusCode == 202{
                    print ("notification accepté")
                    self.dateNotif = dateNotif
                    self.notif = true
                    self.notifIcon.isHidden = false
                    
                    let date = parseDateToString(date: dateReservation) + parseTimeToString(date: dateReservation)
                    self.ajouterNotif(dateNotif: self.dateNotif, dateReservation: date, rider: self.passenger.fullName, identifier:self.ride.id)
                    
                } else if response.response?.statusCode == 400{
                    print("alerte indiquant l'entrée dune date non valide")
                    let alert = UIAlertController(title: "Date erronnée", message: "Vous avez introduit une date passée", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                    self.present(alert, animated: true)
                } else {
                    print("don't know what the fuck u just did !!")
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
        
        guard let url = URL(string: "tel://" + self.passenger.phoneNumber )else {return}
        UIApplication.shared.open(url)
    }
    
    //ouvre l'app map avec les coordonnées donneés
    @IBAction func locateDepartPoint(_ sender: UIButton) {
        let latitude:CLLocationDegrees = ride.source!.latitude
        let longitude:CLLocationDegrees = ride.source!.longitude
        print("longitude = \(longitude ),latitude = \(latitude ), ")
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:String(format: "comgooglemaps://?saddr=%.6f,%.6f&daddr=\(latitude),\(longitude)&directionsmode=driving&views=traffic",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude))!, options: [:], completionHandler: nil)
            //&center=\(latitude),\(longitude)&zoom=14
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
        let latitude:CLLocationDegrees = ride.destination!.latitude
        let longitude:CLLocationDegrees = ride.destination!.longitude
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
                    //self.validateNotif(url: self.URL_API, dateNotif: date!, dateReservation: self.ride.dateTime)
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
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateNotif)
        print(triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Data manipulation Methods
    
    func save(){
        do {
            try realm.write {
                realm.add(passenger)
            }
        }catch{
            print("Error saving contexte, \(error)")
        }
    }
    
    func load(){
        passengers = realm.objects(Passenger.self)
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
    
    func setShadow(color : CGColor, shadowOpacity : Float , shadowOffset : CGSize , shadowRadius : CGFloat ) {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = color
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}


