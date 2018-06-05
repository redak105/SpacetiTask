//
//  WeatherViewController.swift
//  SpacetiTask
//
//  Created by Radek Zmeskal on 05/06/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Mapbox

class WeatherViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var viewMap: MGLMapView!
    @IBOutlet weak var switchWeather: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var reports:[Report] = []
    var annotations:[MGLPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        viewMap.setUserTrackingMode(.follow, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - map box

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        if let location = locationManager.location {
            mapView.setCenter(location.coordinate, zoomLevel: 12, animated: false)
            
            DataManager.getReport(lat:location.coordinate.latitude, lon: location.coordinate.longitude, completion: { (result) in
                if let reports = result {
                    self.reports = reports
                    self.loadAnnotations(index: self.switchWeather.selectedSegmentIndex)
                }
            })
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        if let title = annotation.title as? String {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
                annotationView.setTitle(title: title)
                
                return annotationView
            } else {
                let annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier, title: title)
                annotationView.bounds = CGRect(x: 0, y: 0, width: 150, height: 30)
                
                return annotationView
            }
        } else {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
                annotationView.setTitle(title: "")
                
                return annotationView
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    //MARK: - function
    
    /// generate temperature annotation
    func generateTempreatureAnnotations() {
        if let annotations = viewMap.annotations {
            viewMap.removeAnnotations(annotations)
        }
        
        annotations = [MGLPointAnnotation]()
        for report in self.reports {
            let point = MGLPointAnnotation()
            point.coordinate = report.coord
            point.title = "\(report.tempMin)-\(report.tempMax) ºC"
            annotations.append(point)
        }
        
        viewMap.addAnnotations(annotations)
    }
    
    /// generate weather annotations
    func generateWeatherAnnotations() {
        viewMap.removeAnnotations(annotations)
        
        annotations = [MGLPointAnnotation]()
        for report in self.reports {
            let point = MGLPointAnnotation()
            point.coordinate = report.coord
            point.title = report.weather
            annotations.append(point)
        }
        
        viewMap.addAnnotations(annotations)
    }
    
    /// Load annotaion for map
    ///
    /// - Parameter index: index
    func loadAnnotations( index: Int) {
        switch index {
        case 0:
            self.generateTempreatureAnnotations()
            break;
        case 1:
            self.generateWeatherAnnotations()
            break;
        default:
            break;
        }
    }
    
    //MARK: - actions
    
    /// Action of selecton in Segment
    ///
    /// - Parameter sender: segment control
    @IBAction func touchSwitch(_ sender: UISegmentedControl) {
        loadAnnotations(index: sender.selectedSegmentIndex)
    }
}


