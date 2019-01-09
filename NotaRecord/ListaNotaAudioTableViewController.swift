//
//  ListaNotaAudioTableViewController.swift
//  NotaRecord
//
//  Created by Victor on 20/12/2018.
//  Copyright © 2018 Rinver. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ListaNotaAudioTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var notaAudio: [NSManagedObject] = []
    
    var player = AVAudioPlayer()
    let fileManager = FileManager.default

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    //recupero/seto o caminho do arquivo de audio
    func getDocumentDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperaNotas()
    }


    func recuperaNotas(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "NotaAudio")
        
        let ordenar = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenar]
        
        do {
          let notaRecuperada = try context.fetch(requisicao)
          self.notaAudio = notaRecuperada as! [NSManagedObject]
            tableView.reloadData()
        } catch let erro {
            print("erro ao listar notas: \(erro)")
        }
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notaAudio.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaNota", for: indexPath)

        let notaAudioRecuperado = self.notaAudio[indexPath.row]
        let textoRecuperado = notaAudioRecuperado.value(forKey: "texto")
        let dataRecuperada = notaAudioRecuperado.value(forKey: "data")
        let nomeAudioRecuperado = notaAudioRecuperado.value(forKey: "audioNome")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let novaDataRecuperada = dateFormatter.string(from: dataRecuperada as! Date)
        
        cell.textLabel?.text = textoRecuperado as? String
        cell.detailTextLabel?.text = nomeAudioRecuperado as? String
    
        return cell
    }
    
    /*
     self.tableView.deselectRow(at: indexPath, animated: true)
     
     let indice = indexPath.row
     let anotacao = self.anotacoes[indice]
     */
    
    func executaAudio(caminho: String){
        if let path = Bundle.main.path(forAuxiliaryExecutable: caminho){
            let url = URL(fileURLWithPath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.play()
                
            } catch let erro {
                print("Nao foi possivel executar audio erro: \(erro)")
            }
        }

    }
    
    //seleciona elemento da celula /get
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let indice = indexPath.row
        let notas = self.notaAudio[indice]
        let nomeAudioRecuperado = notas.value(forKey: "audioNome")
        let nome = nomeAudioRecuperado as? String
        let caminhoAudio = notas.value(forKey: "caminho")
        let caminho = caminhoAudio as? String
        
        executaAudio(caminho: caminho!)
        
        print("estou selecionando a celula\(String(describing: nome))")
        print("estou selecionando a celula\(String(describing: caminho))")

        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let indice = indexPath.row
            let notasAudio = self.notaAudio[indice]
            let endereco = notasAudio.value(forKey: "caminho")
            let caminho = endereco as? String
            
            self.context.delete(notasAudio)
            self.notaAudio.remove(at: indice)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        
            do{
                try fileManager.removeItem(atPath: caminho!)
                try context.save()
                print("Removido com sucesso")
            }catch {
                print("Erro ao remover")
            }

        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
