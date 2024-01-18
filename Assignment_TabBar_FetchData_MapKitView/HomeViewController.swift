//
//  HomeViewController.swift
//  Assignment_TabBar_FetchData_MapKitView
//
//  Created by Mac on 17/01/24.
//

import UIKit
import GoogleMaps
class HomeViewController: UIViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var dataTableView: UITableView!
    
    
    var user : [User] = []
    
    var apiresponse : [ApiResponse] = []
    var dataObject : [Data]?
    var apiResponse : ApiResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     fetchData()
        initializeCollectionView()
        registerXIBWithCollectionView()
        fetchDataUseingDecodable()
        initializeTableView()
        registerXIBWithTableView()
    }
    func fetchDataUseingDecodable(){
        let populationUrl = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population")
        
        var populationRequest = URLRequest(url: populationUrl!)
      
        let userSession = URLSession(configuration: .default)
        
        let userDatatask = userSession.dataTask(with: populationRequest) { userData, userResponse, userError in
            
            self.apiResponse = try! JSONDecoder().decode(ApiResponse.self, from: userData!)
            self.dataObject = self.apiResponse?.data
            print(self.dataObject)
            
            DispatchQueue.main.async {
                self.dataTableView.reloadData()
            }
        }
        userDatatask.resume()

    }
    func initializeTableView(){
        dataTableView.dataSource = self
        dataTableView.delegate = self
    }
    func registerXIBWithTableView(){
        let uinib2 = UINib(nibName: "DataTableViewCell", bundle: nil)
        dataTableView.register(uinib2, forCellReuseIdentifier: "DataTableViewCell")
    }
    
    
    
    
    
    func fetchData(){
        let userUrl = URL(string: "https://gorest.co.in/public/v2/users")
        var userUrlRequest = URLRequest(url: userUrl!)
        userUrlRequest.httpMethod = "GET"
        let userUrlSession = URLSession(configuration: .default)
        let userDataTask = userUrlSession.dataTask(with: userUrlRequest) { userData, userResponse, userError in
            let userResponse = try! JSONSerialization.jsonObject(with: userData!) as! [[String : Any]]
    
            for eachResponse in userResponse{
                let userDictionary = eachResponse as! [String : Any]
                let userId = userDictionary["id"] as! Int
                let userName = userDictionary["name"] as! String
                let userGender = userDictionary["gender"] as! String
                
                let userObject = User(id: userId, name: userName, gender: userGender)
                
                self.user.append(userObject)
              //  print(userObject)
            }
            DispatchQueue.main.async {
                self.userCollectionView.reloadData()
            }
        }
        userDataTask.resume()
    }
    func initializeCollectionView(){
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
    }
    func registerXIBWithCollectionView(){
        let uinib1 = UINib(nibName: "UserCollectionViewCell", bundle: nil)
        userCollectionView.register(uinib1, forCellWithReuseIdentifier: "UserCollectionViewCell")
    }
    
}
extension HomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        user.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCollectionViewCell = self.userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        
        userCollectionViewCell.idLabel.text = user[indexPath.item].id.description.codingKey.stringValue
        userCollectionViewCell.nameLabel.text = user[indexPath.item].name.description.codingKey.stringValue
        userCollectionViewCell.genderLabel.text = user[indexPath.item].gender.description.codingKey.stringValue
        
        return userCollectionViewCell
    }
    
    
}
extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowlayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let spaceBetweenTheCells = (flowlayout.minimumInteritemSpacing ?? 0.0) + (flowlayout.sectionInset.left ?? 0.0) + (flowlayout.sectionInset.right ?? 0.0)
        
        let size = (userCollectionView.frame.width - spaceBetweenTheCells) / 2.0
        
        return CGSize(width: size, height: size)
    }
}
extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
}
extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apiresponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        
        for i in 0...user.count-1
        dataTableViewCell.populationLabel.text = dataObject![0].Population.description.codingKey.stringValue
        dataTableViewCell.yearLabel.text = dataObject![1].Year.description.codingKey.stringValue
        
        return dataTableViewCell
     }
    
    
}

