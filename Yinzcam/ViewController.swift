//
//  ViewController.swift
//  Yinzcam
//
//  Created by Setu Desai on 5/8/21.
//

import UIKit
import AWSCore
import AWSS3

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Variables Declaring
    var OpponentTeam: [Any] = []
    var dictTeam: [String : String] = [:]
    var oppGa: [Any] = []
    var oppHead: String = ""
    var triImage: [String : UIImage] = [:]
    
    //MARK:- Method Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    //MARK:- TableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return oppHead
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.font = UIFont(name: "MavenProRegular", size: 28.0)
        headerText.textAlignment = .center
        headerText.text = oppHead
        return headerText
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oppGa.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTableViewCell", for: indexPath) as! DisplayTableViewCell
        let oppDetails: [String : Any] = OpponentTeam[0] as! [String : Any]
        let boolHome: Bool = (oppDetails["IsHome"] != nil)
        let oppGat: [Any] = (oppDetails["Game"] as! [Any])
        let urlfirst = "http://yc-app-resources.s3.amazonaws.com/nfl/logos/nfl_"
        let urllast = "_light.png"
        let urlmid = dictTeam["TriCode"]!.lowercased()
        if(triImage[urlmid] != nil){
            cell.imgHomeTeam.image = triImage[urlmid]
        }else{
            let URLPhoto = urlfirst + urlmid + urllast
            let url = URL(string: URLPhoto)
            let data = try? Data(contentsOf: url!)
            triImage[urlmid] = UIImage(data: data!)
            cell.imgHomeTeam.image = UIImage(data: data!)
        }
        let oppGame: [String:Any] = oppGat[indexPath.row] as! [String:Any]
        
        if(oppGame["Type"] as! String == "F"){
            let arrDate: [String : Any] = oppGame["Date"] as! [String : Any]
            let oppName:String = arrDate["Numeric"] as! String
            let oppDet: [String:String] = oppGame["Opponent"] as! [String : String]
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EE, MMM d"
            if let date = dateFormatterGet.date(from: "\(oppName)") {
                cell.lblDate.text = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
            let optionalTime = timeChange24(date: oppName, timeapm: arrDate["Time"] as! String)
            let oppTime = arrDate["Timestamp"] as! String
            let timeText = oppTime.suffix(1)
            let urlmiddle = oppDet["TriCode"]!.lowercased()
            if(timeText == "Z"){
                let arrDateTime = timeZoneConverterZ(dateTimeString: optionalTime, abbString: "GMT")
                let lbltextdate = arrDateTime[0]
                cell.lblDate.text = String(lbltextdate)
            }else{
                let abbTZ = convertTimeZoneAbbrevation(wholeString: oppTime)
                print(abbTZ)
                let arrDateTime = timeZoneConverterZ(dateTimeString: optionalTime, abbString: abbTZ)
                let lbltextdate = arrDateTime[0]
                cell.lblDate.text = String(lbltextdate)
            }
            if(boolHome){
                cell.lblScore1.text = oppGame["AwayScore"] as? String
                cell.lblScore2.text = oppGame["HomeScore"] as? String
            }else{
                cell.lblScore1.text = oppGame["HomeScore"] as? String
                cell.lblScore2.text = oppGame["AwayScore"] as? String
            }
            cell.hiddenView.isHidden = true
            cell.viewHidden.isHidden = false
            cell.lblDate.font = UIFont(name: "MavenProRegular", size: 28.0)
            cell.lblTime.text = oppGame["GameState"] as? String
            cell.lblWeek.text = (oppGame["Week"]! as! String).uppercased()
            cell.lblOpponentTeam.font = UIFont(name: "LeagueGothic-Regular", size: 35.0)
            cell.lblOpponentTeam.text = oppDet["Name"]
            cell.lblScore1.font = UIFont(name: "LeagueGothic-Regular", size: 35.0)
            cell.lblScore2.font = UIFont(name: "LeagueGothic-Regular", size: 35.0)
            if(triImage[urlmiddle] == nil){
                let URLPhoto = urlfirst + urlmiddle + urllast
                let url = URL(string: URLPhoto)
                let data = try? Data(contentsOf: url!)
                triImage[urlmiddle] = UIImage(data: data!)
                cell.imgOpponent.image = UIImage(data: data!)
            }else{
                cell.imgOpponent.image = triImage[urlmiddle]
            }
            cell.lblDisplayHC.constant = 0
            cell.lblEndHC.constant = 0
        }else if (oppGame["Type"] as! String == "S"){
            let arrDate: [String : Any] = oppGame["Date"] as! [String : Any]
            let oppName:String = arrDate["Numeric"] as! String
            let oppDet: [String:String] = oppGame["Opponent"] as! [String : String]
            let optionalTime = timeChange24(date: oppName, timeapm: arrDate["Time"] as! String)
            let oppTime = arrDate["Timestamp"] as! String
            let timeText = oppTime.suffix(1)
            let urlmiddle = oppDet["TriCode"]!.lowercased()
            if(timeText == "Z"){
                let arrDateTime = timeZoneConverterZ(dateTimeString: optionalTime, abbString: "GMT")
                let lbltextdate = arrDateTime[0]
                let lbltexttime = arrDateTime[1]
                cell.lblDate.text = String(lbltextdate)
                cell.lblTime.text = String(lbltexttime)
            }else{
                let abbTZ = convertTimeZoneAbbrevation(wholeString: oppTime)
                print(abbTZ)
                let arrDateTime = timeZoneConverterZ(dateTimeString: optionalTime, abbString: abbTZ)
                let lbltextdate = arrDateTime[0]
                let lbltexttime = arrDateTime[1]
                cell.lblDate.text = String(lbltextdate)
                cell.lblTime.text = String(lbltexttime)
            }
            cell.lblScore1.text = "0 - 0"
            cell.lblScore2.text = "0 - 0"
            cell.hiddenView.isHidden = true
            cell.viewHidden.isHidden = false
            cell.lblWeek.text = (oppGame["Week"]! as! String).uppercased()
            cell.lblOpponentTeam.font = UIFont(name: "LeagueGothic-Regular", size: 35.0)
            cell.lblOpponentTeam.text = oppDet["Name"]
            cell.lblScore1.font = UIFont(name: "LeagueGothic-Regular", size: 21.0)
            cell.lblScore1.textColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
            cell.lblScore2.textColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
            cell.lblScore2.font = UIFont(name: "LeagueGothic-Regular", size: 21.0)
            if(triImage[urlmiddle] == nil){
                let URLPhoto = urlfirst + urlmiddle + urllast
                let url = URL(string: URLPhoto)
                let data = try? Data(contentsOf: url!)
                triImage[urlmiddle] = UIImage(data: data!)
                cell.imgOpponent.image = UIImage(data: data!)
            }else{
                cell.imgOpponent.image = triImage[urlmiddle]
            }
            cell.lblOpponentTeam.text = oppDet["Name"]
            cell.lblDisplayHC.constant = 21.5
            cell.lblEndHC.constant = 15
        }else{
            cell.hiddenView.isHidden = false
            cell.lblWeekHidden.text = (oppGame["Week"]! as! String).uppercased()
            cell.lblWeekHidden.textColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        }
        cell.imgHomeTeam.clipsToBounds = true
        cell.imgHomeTeam.contentMode = .scaleAspectFill
        cell.imgOpponent.clipsToBounds = true
        cell.imgOpponent.contentMode = .scaleAspectFill
        cell.viewCurve.layer.cornerRadius = 10
        cell.viewCurve.layer.masksToBounds = true
        cell.viewCurve.clipsToBounds = true
        cell.viewCurve.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.viewCurve.layer.shadowRadius = 2
        cell.viewCurve.layer.shadowOpacity = 0.5
        cell.hiddenView.layer.shadowColor = UIColor.black.cgColor
        cell.hiddenView.layer.cornerRadius = 10
        cell.hiddenView.layer.masksToBounds = true
        cell.hiddenView.clipsToBounds = true
        cell.hiddenView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.hiddenView.layer.shadowRadius = 2
        cell.hiddenView.layer.shadowOpacity = 0.5
        cell.hiddenView.layer.shadowColor = UIColor.black.cgColor
        cell.lblTeam.font = UIFont(name: "LeagueGothic-Regular", size: 35.0)
        cell.lblTeam.text = "\(String(describing: dictTeam["Name"]!))"
        cell.lblWeek.textColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        return cell
    }
    
    //MARK:- Made Functions
    func timeZoneConverterZ(dateTimeString : String, abbString : String) -> Array<Substring> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: abbString) as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: dateTimeString)
        dateFormatter.date(from: dateTimeString)
        dateFormatter.dateFormat = "EEE, MMM d'T'HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: TimeZone.current.identifier) as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp.split(separator: "T")
    }
    func timeChange24(date : String, timeapm : String) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let dates = timeFormatter.date(from: timeapm)
        timeFormatter.dateFormat = "HH:mm:ss"
        let date24 = timeFormatter.string(from: dates!)
        let oppT:String = "\(String(describing: date))" + "T" + "\(date24)"
        return oppT
    }
    func convertTimeZoneAbbrevation(wholeString :String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let convertedDate = dateFormatter.date(from: wholeString)
        dateFormatter.date(from: wholeString)
        dateFormatter.dateFormat = "zzz"
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp
    }
    
    //MARK:- API Function Call
    func apiCall(){
        let UrlString: String = "http://files.yinzcam.com.s3.amazonaws.com/iOS/interviews/ScheduleExercise/schedule.json"
        let url = URL(string: UrlString)
        guard let jsonData = url
        else{
            print("data not found")
            return
        }
        guard let data = try? Data(contentsOf: jsonData) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else{return}
        let dictionary = json as? [String: Any]
        dictTeam = dictionary?["Team"] as! [String : String]
        OpponentTeam = dictionary?["GameSection"] as! [Any]
        let oppDetails: [String : Any] = OpponentTeam[0] as! [String : Any]
        oppHead = oppDetails["Heading"] as! String
        oppGa = oppDetails["Game"] as! [Any]
    }
}
