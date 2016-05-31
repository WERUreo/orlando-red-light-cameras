//
//  RedLightCamera.swift
//  orlando-red-light-cameras
//
//  Created by Keli'i Martin on 5/31/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import Foundation
import SwiftyJSON

class RedLightCamera
{
    var intersection: String?
    var latitude: Double?
    var longitude: Double?

    init(json: JSON)
    {
        if let intersection = json["intersection"].string
        {
            self.intersection = intersection
        }

        if let latitude = json["coordinates"]["coordinates"][1].double
        {
            self.latitude = latitude
        }

        if let longitude = json["coordinates"]["coordinates"][0].double
        {
            self.longitude = longitude
        }
    }
}
