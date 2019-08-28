//
//  ViewController.swift
//  Navigation
//
//  Created by wedatalab on 16/08/2019.
//  Copyright © 2019 KimMinwoo. All rights reserved.
//
import MapKit
import UIKit
import Foundation
import CoreLocation

class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(pinTitle:String,  location:CLLocationCoordinate2D) {
        
        self.title = pinTitle
        self.coordinate = location
        
    }
}


struct Toilet {
    let FNAME:String
    let X_WGS84:Double
    let Y_WGS84:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let FNAME = json["FNAME"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let X_WGS84 = json["X_WGS84"] as? Double else {throw SerializationError.missing("icon is missing")}
        
        guard let Y_WGS84 = json["Y_WGS84"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.FNAME = FNAME
        self.X_WGS84 = X_WGS84
        self.Y_WGS84 = Y_WGS84
        
    }
    

    
    
    static func show (completion: @escaping ([Toilet]) -> ()) {
        
        let url = "http://openapi.seoul.go.kr:8088/624e525270726c6136354956534855/json/SearchPublicToiletPOIService/1/1000/"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var toiletArray:[Toilet] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let first = json["SearchPublicToiletPOIService"] as? [String:Any] {
                            if let second = first["row"] as? [[String:Any]] {
                                for dataPoint in second {
                                    if let toiletObject = try? Toilet(json: dataPoint) {
                                        toiletArray.append(toiletObject)
                                    }
                                }
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(toiletArray)
                
            }
            
            
        }
        
        task.resume()
    }
}



class ViewController: UIViewController {

    
    func makePin(name: String, lat: Double, long: Double) {
        self.mapView.addAnnotation(customPin(pinTitle: name, location: CLLocationCoordinate2D(latitude: lat, longitude: long)))
    }
    
    let locationManager : CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
      
        makePin(name:"home", lat: 37.500768, long: 127.042256)

        Toilet.show(){(results:[Toilet]) in
        for result in results {
            self.makePin(name: result.FNAME, lat: result.Y_WGS84, long: Double(result.X_WGS84))
        }
            

    }

}
}
