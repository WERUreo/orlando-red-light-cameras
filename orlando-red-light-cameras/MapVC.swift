//
//  MapVC.swift
//  orlando-red-light-cameras
//
//  Created by Keli'i Martin on 5/31/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    ////////////////////////////////////////////////////////////
    // MARK: - Outlets
    ////////////////////////////////////////////////////////////
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toolbar: UIToolbar!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    let centerPoint = CLLocationCoordinate2DMake(28.540655, -81.381483)
    var cameras = [RedLightCamera]()
    lazy var locationManager = CLLocationManager()
    var currentMapType = MKMapType.Standard

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Life Cycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self

        let region = MKCoordinateRegionMakeWithDistance(centerPoint, 6000, 6000)
        mapView.setRegion(region, animated: true)

        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }

        mapView.userTrackingMode = .None
        mapView.mapType = currentMapType

        // setup toolbar
        var barItems = [UIBarButtonItem]()

        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        barItems.append(userTrackingButton)

        let flexBar = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        barItems.append(flexBar)

        let infoButton = UIButton(type: .InfoLight)
        infoButton.addTarget(self, action: #selector(MapVC.infoButtonPressed(_:)), forControlEvents: .TouchUpInside)
        let infoBarButton = UIBarButtonItem(customView: infoButton)
        barItems.append(infoBarButton)

        self.toolbar.setItems(barItems, animated: true)

        DataService.sharedInstance.getRedLightCameras
        { cameras in
            var annotations = [CameraAnnotation]()
            for camera in cameras
            {
                let annotation = CameraAnnotation(camera: camera)
                annotations.append(annotation)
            }

            dispatch_async(dispatch_get_main_queue())
            {
                self.mapView.addAnnotations(annotations)
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper functions
    ////////////////////////////////////////////////////////////

    func infoButtonPressed(sender: UIButton)
    {
        switch (currentMapType)
        {
        case .Standard:
            mapView.mapType = .Hybrid
        default:
            mapView.mapType = .Standard
        }

        currentMapType = mapView.mapType
    }

    ////////////////////////////////////////////////////////////
    // MARK: - CLLocationManagerDelegate
    ////////////////////////////////////////////////////////////

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: MKMapViewDelegate
    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseID = "Camera"

        if annotation is CameraAnnotation
        {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)

            if annotationView != nil
            {
                annotationView?.annotation = annotation
            }
            else
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                annotationView?.image = UIImage(named: "camera")
                annotationView?.canShowCallout = true
            }

            return annotationView
        }

        return nil
    }
}

