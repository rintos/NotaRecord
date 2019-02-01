//
//  NotasViewController.swift
//  NotaRecord
//
//  Created by Victor on 30/01/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData

class NotasViewController: UIViewController {

    @IBOutlet weak var texto: UITextView!
    var notas: NSManagedObject!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
     
            if let textoRecuperado = notas.value(forKey: "texto"){
                self.texto.text = String(describing: textoRecuperado)
            }
   
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func salvar(){
        self.atualizarNota()
        self.navigationController?.popViewController(animated: true)
    }

    func atualizarNota(){
        notas.setValue(self.texto.text, forKey: "texto")
        notas.setValue(Date(), forKey: "data")
        
        do{
            try self.context.save()
            print("Atuallizado com sucesso")
        }catch {
            print("Erro ao atualizar")
        }
    }

}
