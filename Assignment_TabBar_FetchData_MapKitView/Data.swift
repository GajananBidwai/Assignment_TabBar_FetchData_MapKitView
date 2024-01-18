//
//  Data.swift
//  Assignment_TabBar_FetchData_MapKitView
//
//  Created by Mac on 17/01/24.
//

import Foundation
struct ApiResponse : Decodable{
    var data : [Data]
}
struct Data : Decodable{
    var Population : Int
    var Year : String
}
