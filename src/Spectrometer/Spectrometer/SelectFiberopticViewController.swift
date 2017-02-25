//
//  SelectFiberopticViewController.swift
//  Spectrometer
//
//  Created by raphi on 25.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

protocol SelectFiberopticDelegate {
    func didSelectFiberoptic(fiberoptic: CalibrationFile)
}

class SelectFiberOpticTableViewController: UITableViewController {
    
    let foreoptics = (UIApplication.shared.delegate as! AppDelegate).config?.fiberOpticCalibrations?.allObjects as! [CalibrationFile]
    
    var delegate: SelectFiberopticDelegate!
    
    override func viewDidLoad() {
        self.preferredContentSize = CGSize(width: 320, height: foreoptics.count * 40)
        tableView.register(UINib(nibName: "FiberOpticFileTableViewCell", bundle: nil), forCellReuseIdentifier: "FiberOpticFileTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreoptics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiberOpticFileTableViewCell", for: indexPath) as! FiberOpticFileTableViewCell
        cell.name.text = foreoptics[indexPath.row].name
        cell.fileName.text = foreoptics[indexPath.row].filename
        cell.iconBackView.backgroundColor = cell.backView.backgroundColor
        
        if (indexPath.row % 2 != 0) {
            cell.iconBackView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            cell.backView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
        cell.iconImage.image = UIImage.fontAwesomeIcon(name: .squareO, textColor: .lightGray, size: CGSize(width: 22, height: 22))
        cell.removeButton.isHidden = true
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FiberOpticFileTableViewCell
        cell.iconImage.image = UIImage.fontAwesomeIcon(name: .checkSquareO, textColor: .green, size: CGSize(width: 22, height: 22))
        cell.fileName.textColor = UIColor.green
        cell.name.textColor = UIColor.green
        
        let cali = foreoptics[indexPath.row]
        delegate.didSelectFiberoptic(fiberoptic: cali)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
