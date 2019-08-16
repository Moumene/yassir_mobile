//
//  JSONParsing.swift
//  Yassir_mobile_testing
//
//  Created by Meave on 06/08/2019.
//  Copyright © 2019 Dregon Corp. All rights reserved.
//


import Foundation
import SwiftyJSON

let MONTHS:[String] = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juiller", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]

func parseLocal(filepath: String) -> JSON?
{
    if let path = Bundle.main.path(forResource: filepath, ofType: "json")
    {
        do
        {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let jsonObj = try JSON(data: data)
            return jsonObj
        } catch let error
        {
            print("parse error: \(error.localizedDescription)")
        }
    } else
    {
        print("File not found!")
    }
    return nil
}

//MARK:Function to parse JSON from remote source (backend)
func parseRemote(filepath: String?) -> JSON?
{
    return nil
}

func parseRide(jsonObj: JSON) -> Passenger
{
    let ride = Ride()
    let passenger = Passenger()
    
    ride.cost = jsonObj["cout_course"].intValue
    ride.id = jsonObj["ID"].stringValue
    
    passenger.fullName = jsonObj["rider"]["nom"].stringValue
    passenger.phoneNumber = jsonObj["rider"]["numTel"].stringValue
    passenger.rating = jsonObj["rider"]["note"].intValue
    
    ride.source = Location()
    ride.source!.name = jsonObj["trajet"]["lieuDepart"].stringValue
    ride.source!.address = jsonObj["trajet"]["adressDepart"].stringValue
    ride.source!.latitude = jsonObj["trajet"]["latDepart"].doubleValue
    ride.source!.longitude = jsonObj["trajet"]["lonDepart"].doubleValue
    
    ride.destination = Location()
    ride.destination!.name = jsonObj["trajet"]["lieuDesti"].stringValue
    ride.destination!.address = jsonObj["trajet"]["adressDesti"].stringValue
    ride.destination!.latitude = jsonObj["trajet"]["latDesti"].doubleValue
    ride.destination!.longitude = jsonObj["trajet"]["lonDesti"].doubleValue
    
    ride.dateTime = parseTimestamp(timeStamp: jsonObj["dateHeur"].doubleValue)
    
    passenger.rides.append(ride)
    
    return passenger
}

func parseTimestamp(timeStamp: Double) -> Date
{
    let d = NSDate(timeIntervalSince1970:timeStamp)
    let date = Date(date: d)
    return date
}

func parseDateToString(date: Date) -> String
{
    let component = Calendar.current.dateComponents([.day,.month,.year], from: date)
    let result: String = ("\(String(describing: component.day!)) \(MONTHS[component.month! - 1]) \(String(describing: component.year!))")
    return result
}


func parseTimeToString(date: Date) -> String
{
    let component = Calendar.current.dateComponents([.hour, .minute], from: date)
    let result: String = ("\(String(describing: component.hour!)):\(String(describing:component.minute!))")
    return result
}

extension Date {
    init(date: NSDate) {
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
}

