//
//  WeatherManager.swift
//  Weather-App iOS13
//
//  Created by Apple on 18/04/21.
//

import Foundation
import CoreLocation




//we will use WeatherManagerDelegate to avoid rendering single use of code.

protocol WeatherManagerDelegate {
    //2.b DELEGATES-  WeatherManagerDelegate protocol.
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
    
    }





struct WeatherManager {
    
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0be7b1434d32da9c06f5168d078cd8ca&units=metric"
    
    
    
    var delegate: WeatherManagerDelegate? // 2.a DELEGATES- in order to set a class or struct as the delegate of  WeatherManager, It must conform the WeatherManagerDelegate protocol.
    
    
    
    func fetchWeather(cityName: String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    
    
    

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    
    
    

//MARK: - NETWORKING
    
    func performRequest(with urlString: String)  {
        
        
        //1. create a URL
        if let url = URL(string: urlString){
            
            
        //2. create a URLSession
        let session = URLSession(configuration: .default)
            
            
        //3. give the session a tesk
        let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print("arbaaz this is error: \(error!)")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
            
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
        }
            
            
            
        //4. Start the task
            task.resume()
            
        }
        
}
  
    
    
    
    
 //MARK: - PARSE JSON
    
    func parseJSON(_ weatherData: Data)  -> WeatherModel? {
     /*in order to parse the data from JSON format,first we have to inform the compiler that how the data is structured, through the use of structure we create.i.e(WeatherData Structure)
         */
        
        
        let decoder = JSONDecoder()
        
        
        do{
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            }
        catch{
            print("arbaaz this is error: \(error)")
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
        
}
    
    
    
    
    
    
   
}

