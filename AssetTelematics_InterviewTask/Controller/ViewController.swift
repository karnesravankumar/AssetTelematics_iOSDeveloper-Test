//
//  ViewController.swift
//  AssetTelematics_InterviewTask
//
//  Created by Macbook pro on 23/11/22.
//

import UIKit
import DropDown

class ViewController: UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfTwo: UITextField!
    @IBOutlet weak var tfThree: UITextField!
    @IBOutlet weak var tfFour: UITextField!
    @IBOutlet weak var tfFive: UITextField!
    @IBOutlet weak var tfSix: UITextField!
    
    @IBOutlet weak var imeiTF: UITextField!
    @IBOutlet weak var vehicleTagName: UITextField!
    @IBOutlet weak var vehicleRegistrationNumber: UITextField!
    @IBOutlet weak var vehicleTypeCV: UICollectionView!
    
    @IBOutlet weak var ownButton: UIButton!
    @IBOutlet weak var contractorButton: UIButton!
    
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var driverButton: UIButton!
    
    @IBOutlet weak var vehicleModeView: UIView!
    @IBOutlet weak var vehicleTypeView: UIView!
    @IBOutlet weak var vehicleYearView: UIView!
    @IBOutlet weak var vehicleFuelTypeView: UIView!
    @IBOutlet weak var vehicleCapacityView: UIView!
    
    @IBOutlet weak var vehicleModelLbl: UILabel!
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    @IBOutlet weak var vehicleYearLbl: UILabel!
    @IBOutlet weak var vehicleFuelTypeLbl: UILabel!
    @IBOutlet weak var vehicleCapacityLbl: UILabel!
    
    let dropDown = DropDown()
    var vModelStr = [String]()
    var vTypeStr = [String]()
    var yearStr = [String]()
    var fuelTypeStr = [String]()
    var vCapactyStr = [String]()
    
    var vehicleViewModel = VehicleDataViewModel()
    var lblOutputStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borderForView(view: vehicleModeView)
        borderForView(view: vehicleTypeView)
        borderForView(view: vehicleYearView)
        borderForView(view: vehicleFuelTypeView)
        borderForView(view: vehicleCapacityView)
        
        borderForTF(tf: tfOne)
        borderForTF(tf: tfTwo)
        borderForTF(tf: tfThree)
        borderForTF(tf: tfFour)
        borderForTF(tf: tfFive)
        borderForTF(tf: tfSix)
        borderForTF(tf: imeiTF)
        borderForTF(tf: vehicleTagName)
        borderForTF(tf: vehicleRegistrationNumber)
        
        vehicleViewModel.vc = self
        vehicleViewModel.getPostData()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width:90 , height: 80)
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.minimumLineSpacing = 15
        flowLayout.scrollDirection = .horizontal
        vehicleTypeCV.collectionViewLayout = flowLayout
        
        tfOne.delegate = self
        tfTwo.delegate = self
        tfThree.delegate = self
        tfFour.delegate = self
        tfFive.delegate = self
        tfSix.delegate = self
        
        self.tfOne.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tfTwo.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tfThree.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tfFour.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tfFive.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tfSix.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        
    }
    
    func userDidEnterInformation(info: String) {
//           label.text = info
        debugPrint("info", info)
        imeiTF.text = info
    }
    
    @objc func changeCharacter(textField : UITextField){
        if textField.text?.utf8.count == 1 {
            switch textField {
            case tfOne:
                tfTwo.becomeFirstResponder()
            case tfTwo:
                tfThree.becomeFirstResponder()
            case tfThree:
                tfFour.becomeFirstResponder()
            case tfFour:
                tfFive.becomeFirstResponder()
            case tfFive:
                tfSix.becomeFirstResponder()
            case tfSix:
                print("OTP = \(tfOne.text!)\(tfTwo.text!)\(tfThree.text!)\(tfFour.text!)\(tfFive.text!)\(tfSix.text!)")
            default:
                break
            }
        }else if textField.text!.isEmpty {
            switch textField {
            case tfSix:
                tfFive.becomeFirstResponder()
            case tfFive:
                tfFour.becomeFirstResponder()
            case tfFour:
                tfThree.becomeFirstResponder()
            case tfThree:
                tfTwo.becomeFirstResponder()
            case tfTwo:
                tfOne.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    @IBAction func ownBtnAction(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "btnon")  {
            contractorButton.setImage(UIImage(named: "uncheck"), for: .normal)
            ownButton.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        else {
            ownButton.setImage(UIImage(named: "btnon"), for: .normal)
            contractorButton.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        
    }
    
    @IBAction func contractorBtnAction(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "btnon")  {
            contractorButton.setImage(UIImage(named: "uncheck"), for: .normal)
            ownButton.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        else {
            contractorButton.setImage(UIImage(named: "btnon"), for: .normal)
            ownButton.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }
    
    @IBAction func qrCodeBtnAction(_ sender: UIButton) {
        debugPrint("scanner button tapped")
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func vehicleModelBtnAction(_ sender: UIButton) {
        print("fuel type arr", vehicleViewModel.vehicle_make.count)
        for ft in vehicleViewModel.vehicle_make {
            let text = ft.text
            if let text = text {
                self.vModelStr.append(text ?? "")
                debugPrint("fuel type", self.vModelStr)
            }
        }
        dropDown.anchorView = vehicleModeView
        dropDown.dataSource = vModelStr
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.vehicleModelLbl.text = vModelStr[index]
        }
        dropDown.show()
        
    }
    
    @IBAction func vehicleTypeBtnAction(_ sender: UIButton) {
        print("fuel type tapped")
        
    }
    
    
    @IBAction func vehicleYearBtnAction(_ sender: UIButton) {
        print("fuel type arr", vehicleViewModel.manufacture_year.count)
        for ft in vehicleViewModel.manufacture_year {
            let text = ft.text
            if let text = text {
                self.yearStr.append(text ?? "")
                debugPrint("fuel type", self.yearStr)
            }
        }
        dropDown.anchorView = vehicleYearView
        dropDown.dataSource = yearStr
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.vehicleYearLbl.text = yearStr[index]
        }
        dropDown.show()
        
    }
    
    @IBAction func vehicleFuelTypeBtnAction(_ sender: UIButton) {
        debugPrint("Dropdwon tappe")
        //        self.fuelTypeDropDown()
        print("fuel type arr", vehicleViewModel.fueltype.count)
        for ft in vehicleViewModel.fueltype {
            let text = ft.text
            if let text = text {
                self.fuelTypeStr.append(text ?? "")
                debugPrint("fuel type", self.fuelTypeStr)
                print("fuel type", self.fuelTypeStr)
            }
        }
        dropDown.anchorView = vehicleFuelTypeView
        dropDown.dataSource = fuelTypeStr
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.vehicleFuelTypeLbl.text = fuelTypeStr[index]
        }
        dropDown.show()
    }
    
    @IBAction func vehicleCapacityBtnAction(_ sender: UIButton) {
        print("fuel type arr", vehicleViewModel.vehicle_capacity.count)
        for ft in vehicleViewModel.vehicle_capacity {
            let text = ft.text
            if let text = text {
                self.vCapactyStr.append(text ?? "")
                debugPrint("fuel type", self.vCapactyStr)
            }
        }
        dropDown.anchorView = vehicleCapacityView
        dropDown.dataSource = vCapactyStr
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.vehicleCapacityLbl.text = vCapactyStr[index]
        }
        dropDown.show()
        
    }

    @IBAction func backBtn(_ sender: UIButton) {
        
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleViewModel.vehicle_type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleTypeCVCell", for: indexPath) as! VehicleTypeCVCell
        let type = vehicleViewModel.vehicle_type[indexPath.row]
        print(type.text)
        cell.typeLbl.text = type.text
        return cell
    }
    
    
}


extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown.show()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.tfOne {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == self.tfTwo {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == self.tfThree {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == self.tfFour {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == self.tfFive {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == self.tfSix {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        return true
    }
}


extension UIViewController {
    func borderForView(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5)
        view.layer.cornerRadius = 5
    }
    
    func borderForTF(tf: UITextField) {
        tf.layer.borderWidth = 1
        tf.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5)
        tf.layer.cornerRadius = 5
    }
}


class VehicleTypeCVCell: UICollectionViewCell {
    @IBOutlet weak var typeLbl: UILabel!
}
