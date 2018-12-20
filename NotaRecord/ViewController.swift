//
//  ViewController.swift
//  NotaRecord
//
//  Created by Victor on 20/12/2018.
//  Copyright © 2018 Rinver. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    var notaAudio: NSManagedObject!
    
    @IBOutlet weak var textoTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textoTextField.text = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

    }

 
    @IBAction func salvar(_ sender: Any?) {
        salvarNotaAudio()
        
    }

    
    func salvarNotaAudio(){
        
        let novaAudioNota = NSEntityDescription.insertNewObject(forEntityName:"NotaAudio" , into: context)
        
        novaAudioNota.setValue(self.textoTextField.text, forKey: "texto" )
        novaAudioNota.setValue( Date(), forKey: "data")
        
        do {
            try context.save()
            print("Nota Salva Com Sucesso")
            
            let alerta = UIAlertController(title: "Alerta", message: "Salvo com Sucesso", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            alerta.addAction(ok)
                
            present(alerta, animated: true, completion: nil)
            
            self.textoTextField.text = ""
            
        } catch let erro {
            print("Nao foi possivel salvar nota erro: \(erro)")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

