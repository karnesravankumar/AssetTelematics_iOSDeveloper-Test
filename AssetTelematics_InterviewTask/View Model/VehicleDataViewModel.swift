//
//  VehicleDataViewModel.swift
//  AssetTelematics_InterviewTask
//
//  Created by Macbook pro on 23/11/22.
//

import Foundation
import UIKit


class VehicleDataViewModel {
    weak var vc : ViewController?
    
    var vehicle_type =  [Vehicle_type]()
    var vehicle_capacity = [Vehicle_capacity]()
    var vehicle_make = [Vehicle_make]()
    var manufacture_year = [Manufacture_year]()
    var fueltype = [Fuel_type]()
        
    func getPostData() {
        
        let parameters = "{\n \"clientid\": 11,\n \"enterprise_code\": 1007,\n \"mno\": \"9889897789\",\n \"passcode\": 3476\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://183.82.2.55:8090/jhsmobileapi/mobile/configure/v1/task")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let datas = data else {
                print(String(describing: error))
                return
            }
            print(String(data: datas, encoding: .utf8)!)
            do {
                let vehicleRes = try JSONDecoder().decode(VehicleData.self, from: datas)
                debugPrint("res", vehicleRes)
    
                if let ftype = vehicleRes.fuel_type {
                    self.fueltype.append(contentsOf: ftype)
                    debugPrint("res", self.fueltype)
                }
                if let vtype = vehicleRes.vehicle_type {
                    self.vehicle_type.append(contentsOf: vtype)
                    debugPrint("res", self.fueltype)
                }
                if let vcapacity = vehicleRes.vehicle_capacity {
                    self.vehicle_capacity.append(contentsOf: vcapacity)
                    debugPrint("res", self.fueltype)
                }
                if let vmake = vehicleRes.vehicle_make {
                    self.vehicle_make.append(contentsOf: vmake)
                    debugPrint("res", self.fueltype)
                }
                if let vman = vehicleRes.manufacture_year {
                    self.manufacture_year.append(contentsOf: vman)
                    debugPrint("res", self.fueltype)
                }
                
                DispatchQueue.main.async {
                    self.vc?.vehicleTypeCV.reloadData()
                }
                
            }catch let error {
                debugPrint("err", error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
}
