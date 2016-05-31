//
//  DataService.swift
//  orlando-red-light-cameras
//
//  Created by Keli'i Martin on 5/31/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DataService
{
    static let sharedInstance = DataService()

    func getRedLightCameras(completion: (cameras: [RedLightCamera]) -> Void)
    {
        let camerasUrlString = "https://brigades.opendatanetwork.com/resource/5gyy-dfem.json"
        var cameras = [RedLightCamera]()

        Alamofire.request(.GET, camerasUrlString).validate().responseJSON
        { response in
            switch response.result
            {
            case .Success:
                if let value = response.result.value
                {
                    let json = JSON(value)
                    for (_, subJson) in json
                    {
                        let camera = RedLightCamera(json: subJson)
                        cameras.append(camera)
                    }

                    completion(cameras: cameras)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}