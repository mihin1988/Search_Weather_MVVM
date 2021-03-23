//
//  SearchWeather.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 21/03/21.
//

import UIKit

class SearchWeather: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK: - OUTLETS
    
    @IBOutlet var tblCityList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var segment: UISegmentedControl!
    
    var arrLoaclList : [List] = []
    let defaults = UserDefaults.standard
    var array:[Int] = []
    
    private var cityViewModel : CityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        array = defaults.array(forKey: "SavedCity")  as? [Int] ?? []
        arrLoaclList = appDelegate.arrList
        print(appDelegate.arrList.count)
        self.tblCityList.register(UINib(nibName: CityLIstCell.className, bundle: nil), forCellReuseIdentifier: CityLIstCell.className)

        searchBar.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = Constants.navigationBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.title = "Weather Forecast"
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.navigationBarColor as Any], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white as Any], for: .normal)

        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        searchBar.text = ""
        searchBar.endEditing(true)
        if sender.selectedSegmentIndex == 0 {
            arrLoaclList = appDelegate.arrList
        }else{
            arrLoaclList = appDelegate.arrList.filter { list in
                return array.contains(list.id ?? 0)
            }
        }
        tblCityList.reloadData()

    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLoaclList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let list = arrLoaclList[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell : CityLIstCell = tableView.dequeueReusableCell(withIdentifier: CityLIstCell.className, for: indexPath) as! CityLIstCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.lblCityName?.text = list.name
        cell.btnInfomration.isHidden = true
        cell.btnIsFavorite.tag = list.id ?? 0
        
        if let index = array.firstIndex(of: cell.btnIsFavorite.tag) {
            cell.btnIsFavorite.setImage(UIImage(named: "Star_Fill.png"), for: .normal)
        }else{
            cell.btnIsFavorite.setImage(UIImage(named: "Star.png"), for: .normal)
        }
    
        cell.btnIsFavorite.addTarget(self, action: #selector(actionAddRemoveFavoriteButton), for: .touchUpInside)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = arrLoaclList[indexPath.row]
//        callAPIForGetWeather(cityId: list.id ?? 0)
        
        self.cityViewModel =  CityViewModel()
        self.cityViewModel.callAPIForGetWeather(cityId: list.id ?? 0)
        self.cityViewModel.bindCityViewModelToController = {
            self.updateDataSource()
        }
        
    }

    func updateDataSource(){
        
        let weatherDetails = MainStoryBoard.instantiateViewController(withIdentifier: "WeatherDetails") as! WeatherDetails
        weatherDetails.weatherForecast = self.cityViewModel.watherData
        self.navigationController?.present(weatherDetails, animated: true, completion: nil)
    }
    
    //MARK: - APICall
    
    func callAPIForGetWeather(cityId:Int) {
        Webservice().getWeather(requestParam: "id=\(cityId)&appid=\(openWeatherMapAPIKey)"){ (responseModel) in
            if(responseModel.cod == 200){
                print(responseModel)
                
                
                let weatherDetails = MainStoryBoard.instantiateViewController(withIdentifier: "WeatherDetails") as! WeatherDetails
                weatherDetails.weatherForecast = responseModel
                self.navigationController?.present(weatherDetails, animated: true, completion: nil)

                
//                self.truckTypeListModels = responseModel.message ?? []
            }
        }
    }
    //MARK: - IBAction
    
    @IBAction func actionAddRemoveFavoriteButton(_ sender: UIButton) {
        
        if let index = array.firstIndex(of: sender.tag) {
            array.remove(at: index)
        }else{
            array.append(sender.tag)
        }
        defaults.set(array, forKey: "SavedCity")
        segmentedControlValueChanged(segment)
//        tblCityList.reloadData()
    }
}

extension SearchWeather: UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("=> \(arrLoaclList.count)")
        
        arrLoaclList = searchText.isEmpty ? appDelegate.arrList : appDelegate.arrList.filter{
            $0.name?.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        tblCityList.reloadData()
        print("=> \(arrLoaclList.count)")
    }
}
