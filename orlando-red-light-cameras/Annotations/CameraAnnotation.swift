//
//  CameraAnnotation.swift
//  orlando-red-light-cameras
//
//  Created by Keli'i Martin on 5/31/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import UIKit
import MapKit

class CameraAnnotation: NSObject, MKAnnotation
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    let coordinate: CLLocationCoordinate2D
    var title: String? = nil
    let defaultLocation = CLLocationCoordinate2DMake(28.540655, -81.381483)

    ////////////////////////////////////////////////////////////

    init(camera: RedLightCamera)
    {
        if let latitude = camera.latitude,
           let longitude = camera.longitude
        {
            self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        }
        else
        {
            self.coordinate = defaultLocation
        }

        if let title = camera.intersection
        {
            self.title = title
        }
    }

}
