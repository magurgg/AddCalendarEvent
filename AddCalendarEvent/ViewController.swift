//
//  ViewController.swift
//  AddCalendarEvent
//
//  Created by Marco Antonio Gutierrez López on 3/6/18.
//  Copyright © 2018 Marco Antonio Gutierrez López. All rights reserved.
//

import UIKit
import Foundation
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtDatePicker: UITextField!
    var eti: Int = 0
    let store = EKEventStore()
    let datePicker = UIDatePicker()
    @IBOutlet weak var txtDP2: UITextField!
    @IBOutlet weak var txtEvento: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func txtTouchDown(_ sender: Any) {
        showDatePicker("1")
    }
    
    @IBAction func addE(_ sender: UIButton) {
        if txtEvento.text=="" || txtDP2.text=="" || txtDatePicker.text==""{
            let alert = UIAlertController(title: "Campos vacíos", message: "Ha dejado uno o más campos vacíos, favor de llenarlos", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            let alertController = UIAlertController(title: "Confirmar?", message: "Estás seguro de crear el evento?", preferredStyle: .actionSheet)
            
            let action2 = UIAlertAction(title: "Confirmar", style: .default) { (action:UIAlertAction) in
                self.createEventinTheCalendar(with: self.txtEvento.text!,forDate: formatter.date(from: self.txtDatePicker.text!)!, toDate: formatter.date(from: self.txtDatePicker.text!)!)
            }
            
            let action1 = UIAlertAction(title: "Cancelar", style: .destructive) { (action:UIAlertAction) in
                print("Presionaste cancelar");
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func txtDP2(_ sender: Any) {
        showDatePicker("2")
    }

    func showDatePicker(_ tipo: String){
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "es_MX")
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        if(tipo.description=="1"){
            if(!(txtDatePicker.text?.isEmpty)!){
                datePicker.date = formatter.date(from: txtDatePicker.text!)!
            }
            txtDatePicker.inputAccessoryView = toolbar
            txtDatePicker.inputView = datePicker
            eti=100
        }
        else{
            if(!(txtDP2.text?.isEmpty)!){
                datePicker.date = formatter.date(from: txtDP2.text!)!
            }
            txtDP2.inputAccessoryView = toolbar
            txtDP2.inputView = datePicker
            eti=200
        }
    }
    
    @objc func donedatePicker(_ tipo: Int){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        if eti==100 {
            txtDatePicker.text = formatter.string(from: datePicker.date)
            formatter.date
        }
        if eti==200 {
            txtDP2.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func createEventinTheCalendar(with title:String, forDate eventStartDate:Date, toDate eventEndDate:Date) {
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                event.addAlarm(alarm)
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    let alert = UIAlertController(title: "Hecho!", message: "Se ha creado correctamente el evento.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } catch let error as NSError {
                    print("fallo a crear evento con error : \(error)")
                    let alert = UIAlertController(title: "Error!", message: "No se han concedido los permisos", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                //Error al obtener permiso al calendario
                let alert = UIAlertController(title: "Error!", message: "No se han concedido los permisos", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
        txtEvento.text=""
        txtDP2.text=""
        txtDatePicker.text=""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
