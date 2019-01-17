//
//  ViewController.swift
//  NotaRecord
//
//  Created by Victor on 20/12/2018.
//  Copyright © 2018 Rinver. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Foundation

class ViewController: UIViewController, AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    var context: NSManagedObjectContext!
    var notaAudio: NSManagedObject!    
    
    
    @IBOutlet weak var textoTextField: UITextField!

    @IBOutlet weak var botaoGravar: UIButton!
    
    @IBOutlet weak var botaoPlay: UIButton!
    
    @IBOutlet weak var botaoSalvar: UIButton!
    
    //variavel do tipo Audio
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    var fileName: String = ""
    var player = AVAudioPlayer()
    var caminhoSon: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func randomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0...length-1).map{ _ in letters.randomElement()! })
        }

        let nome = randomString(length: 8)
        fileName = "audio\(nome).m4a"
 
        self.textoTextField.text = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

        setupRecorder()
        botaoPlay.isEnabled = false
        
        botaoGravar.layer.borderWidth = 0.5
        botaoGravar.layer.cornerRadius = 8
        botaoPlay.layer.borderWidth = 0.5
        botaoPlay.layer.cornerRadius = 8
        botaoSalvar.layer.borderWidth = 0.5
        botaoSalvar.layer.cornerRadius = 8
        botaoGravar.layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
        botaoPlay.layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
        botaoSalvar.layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
    }
    
    // cria diretorio de arquivo
    //quando termina de salvar eh necessario criar novamente o caminho do arquivo
    override func viewDidAppear(_ animated: Bool) {
        setupRecorder()
        botaoPlay.isEnabled = false
    }

    
    //recupero/seto o caminho do arquivo de audio
    func getDocumentDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //cria o arquivo adicionando caminho // grava suas propriedades
    func setupRecorder(){
        let audioFilename = getDocumentDirector().appendingPathComponent(fileName)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.2 ] as [String : Any]
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            caminhoSon = audioFilename.relativePath //add endereco do mp3 na variavel
            
        } catch  {
            print(error)
        }
        
    }
    
    //roda o audio
    func setupPlayer(){
        let audioFilename = getDocumentDirector().appendingPathComponent(fileName)
        do {
           soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 3.0
        } catch  {
            print(error)
        }
    }
    
    //quando audio terminar de gravar/ alerta/
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        botaoPlay.isEnabled = true
    }
    
    //quando o audio terminar de rodar/ alerta/
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        botaoGravar.isEnabled = true
        botaoPlay.setTitle("Play", for: .normal)
    }
    
    // gatilho ativa funcao
    @IBAction func gravarAction(_ sender: Any){
        if botaoGravar.titleLabel?.text == "Gravar" {
            soundRecorder.record()
            botaoGravar.setTitle("Parar", for: .normal)
            botaoPlay.isEnabled = false
        }else {
            soundRecorder.stop()
            botaoGravar.setTitle("Gravar", for: .normal)
            botaoPlay.isEnabled = false
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        if botaoPlay.titleLabel?.text == "Play" {
            botaoPlay.setTitle("Parar", for: .normal)
            botaoGravar.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        }else {
            soundPlayer.stop()
            botaoPlay.setTitle("Play", for: .normal)
            botaoGravar.isEnabled = false
        }
    }
    
 
    @IBAction func salvar(_ sender: Any?) {
        salvarNotaAudio()
    }

    
    func salvarNotaAudio(){
        
        let novaAudioNota = NSEntityDescription.insertNewObject(forEntityName:"NotaAudio" , into: context)
        
        novaAudioNota.setValue(self.textoTextField.text, forKey: "texto" )
        novaAudioNota.setValue( Date(), forKey: "data")
        novaAudioNota.setValue(self.fileName, forKey:"audioNome")
        novaAudioNota.setValue(self.caminhoSon, forKey: "caminho")
        
        do {
            try context.save()
            print("Nota Salva Com Sucesso")
            
            let alerta = UIAlertController(title: "Alerta", message: "Salvo com Sucesso", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            alerta.addAction(ok)
 
            present(alerta, animated: true, completion: nil)
            
            self.textoTextField.text = ""
            
            
            func randomString(length: Int) -> String {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return String((0...length-1).map{ _ in letters.randomElement()! })
            }
            
            let nome = randomString(length: 8)
            fileName = "audio\(nome).m4a"

            dismiss(animated: true, completion: nil)
            
            // cria diretorio de arquivo //ajuda no ciclo de vida para gravar e reproduzir arquivo conforme necessidade do app
            setupRecorder()
            botaoPlay.isEnabled = false
            
        } catch let erro {
            print("Nao foi possivel salvar nota erro: \(erro)")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

