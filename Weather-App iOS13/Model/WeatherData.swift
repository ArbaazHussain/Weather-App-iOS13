//
//  WeatherData.swift
//  Weather-App iOS13
//
//  Created by Apple on 18/04/21.
//

import Foundation



struct WeatherData: Codable {
    let name: String
    let main:  Main
    let weather: [Weather]
}



struct Main: Codable {
    let temp: Double
}



struct Weather: Codable {
   let id: Int
}



