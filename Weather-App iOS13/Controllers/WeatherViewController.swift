//
//  ViewController.swift
//  Weather-App iOS13
//
//  Created by Apple on 18/04/21.
//


import UIKit
import CoreLocation



class WeatherViewController: UIViewController {



    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!// 1.a DELEGATES - we create new text field from reusable template of UITextField.
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()//requestLocation ask for only one time location.
        //When requestLocation is called then it returns nothing. So, once it find the location then it call a delegate i.e <func locationManager(_:didUpdateLocations:)>. So, we have to adopts a delegate protocol in WeatherViewController, if we wanna able to sign ourself as a delegate for the locationManager to be notified of that location update.
        
        
        
        
        searchTextField.delegate = self// 1.b DELEGATES - now we set the TextField delegate property to self as the WeatherViewController... This is only possible because WeatherViewController has adopt and conformed the UITextFieldDelegate... Now whenever event occur in textField, the delegate is called.
        
        weatherManager.delegate = self//2.c Delegate- now we set the WeatherManager delegate proprty to self as the WeatherViewController... This is only possible because WeatherViewController has adopt and conformed the WeatherManagerDelegate... Now whenever event occur in WeatherManager, the delegate is called.
      
        
        }
    
    
    
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
    
    
}
    
    
    
    
    
//MARK: - UITextFieldDelegate



extension WeatherViewController: UITextFieldDelegate {
    
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
      searchTextField.endEditing(true)
        }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
      searchTextField.endEditing(true)
        return true
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "ENTER CITY NAME"
            return false
        }
        }

    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
        }


    
}





//MARK: - WeatherManagerDelegate



extension WeatherViewController: WeatherManagerDelegate
{
    
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)  {
         //1st thing in delegate method is identity of object that cause this delegate method.
         
         print(weather.cityName)
         print(weather.conditionId)
         print(weather.temperatureString)
         print(weather.conditionName)
         
         DispatchQueue.main.async {
             self.conditionImageView.image = UIImage(systemName: weather.conditionName)
             self.temperatureLabel.text = weather.temperatureString
             self.cityLabel.text = weather.cityName
         }
     }
     
    
     
     
     
     func didFailWithError(error: Error)  {
         print("arbaaz this is error: \(error)")
     }
    
    
    
}



//MARK: - CLLocationManagerDelegate



extension WeatherViewController:  CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //when locationManager calls above method, then it also passes locations input,which is type of array of CLLocation.
        
        
        if let location = locations.last {
            //by locations.last , we get the last and most accurate location from the <locations input,which is type of array of CLLocation>
            
            
            locationManager.stopUpdatingLocation()
            
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
          
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
}
