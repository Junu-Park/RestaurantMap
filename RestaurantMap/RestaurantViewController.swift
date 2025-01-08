//
//  RestaurantViewController.swift
//  RestaurantMap
//
//  Created by 박준우 on 1/8/25.
//

import UIKit
import MapKit

class RestaurantViewController: UIViewController, MKMapViewDelegate {

    let restaurantList = RestaurantList.restaurantArray
    
    var filteredRestaurantList: [Restaurant] = RestaurantList.restaurantArray
    
    let categoryList = RestaurantList.categoryArray
    
    var currentCategory: String = "전체"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        setSegmentControl()
        
        mapView.delegate = self
        setMapView()
        setMapAnnotations()
    }
    
    func setNavigationBarItem() {
        navigationController?.navigationBar.tintColor = UIColor.systemGray
        navigationItem.title = "맛집 지도"
        
        let rightItem = UIBarButtonItem(
            title: "Filter",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(openFilterActionSheet)
        )
        navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    @objc func openFilterActionSheet() {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        for order in 0..<categoryList.count {
            let action = UIAlertAction(
                title: categoryList[order],
                style: UIAlertAction.Style.default
            ) { ele in
                self.segmentControl.selectedSegmentIndex = order + 1
                self.filteringData(self.segmentControl)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: UIAlertAction.Style.cancel,
            handler: nil
        )
        actionSheet.addAction(cancelAction)
        let allAction = UIAlertAction(title: "전체", style: UIAlertAction.Style.default) { _ in
            self.segmentControl.selectedSegmentIndex = 0
            self.filteringData(self.segmentControl)
        }
        actionSheet.addAction(allAction)
        
        present(actionSheet, animated: true)
    }
    
    func setSegmentControl() {
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: "전체", at: 0, animated: true)
        for order in 0..<categoryList.count {
            segmentControl.insertSegment(withTitle: categoryList[order], at: order + 1, animated: true)
        }
        segmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func filteringData(_ sender: UISegmentedControl) {
        currentCategory = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        switch currentCategory {
        case "전체":
            filteredRestaurantList = restaurantList
        default:
            filteredRestaurantList = restaurantList.filter({ ele in
                currentCategory == ele.category
            })
        }
        
        setMapAnnotations()
    }
    
    func setMapView() {
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 37.653,
            longitude: 127.047
        )
        mapView.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
    
    func setMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations: [MKPointAnnotation] = filteredRestaurantList.map { ele in
            let annotation = MKPointAnnotation()
            annotation.title = ele.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude)
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
}

