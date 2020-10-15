//
//  MenuCircularesTableViewController.swift
//  CHMD2
//
//  Created by Rafael David Castro Luna on 4/7/20.
//  Copyright © 2020 Rafael David Castro Luna. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
class MenuCircularesTableViewController: UITableViewController {

    @IBOutlet weak var lblCorreo: UILabel!
    @IBOutlet weak var lblUsuario: UILabel!
    @IBOutlet weak var lblNumFamilia: UILabel!
    var urlFotos:String = "http://chmd.chmd.edu.mx:65083/CREDENCIALES/padres/"
    var urlBase:String="https://www.chmd.edu.mx/WebAdminCirculares/ws/"
    var cifrarMetodo:String="cifrar.php"
    var metodoTotalNoLeidas = "getTotalCircularesNoLeidas.php"
     var metodoTotalFavoritas = "getTotalCircularesFavoritas.php"
    var idUsuario:String=""
    var totalItems=0
     var db: OpaquePointer?
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet var tableViewMenu: UITableView!
     var menu = [MenuCirculares]()
    var totalNoLeidas:Int=0
    var totalFavoritas:Int=0
    var totalNotificaciones:Int=0
    override func viewWillAppear(_ animated: Bool){
        
        self.totalNoLeidas = getTotalNoLeidas()
        self.totalFavoritas = getTotalFavoritas()
        self.totalNotificaciones = getTotalNotificaciones()
        self.tableViewMenu.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          menu.append(MenuCirculares(id: 1, nombre: "Entrada", imagen:#imageLiteral(resourceName: "appmenu03")))
          menu.append(MenuCirculares(id: 2, nombre: "Favoritos", imagen:#imageLiteral(resourceName: "appmenu06")))
          menu.append(MenuCirculares(id: 3, nombre: "No leídos", imagen:#imageLiteral(resourceName: "appmenu05")))
          menu.append(MenuCirculares(id: 4, nombre: "Papelera", imagen:#imageLiteral(resourceName: "appmenu07")))
          menu.append(MenuCirculares(id: 5, nombre: "Notificaciones", imagen:#imageLiteral(resourceName: "campana")))
          menu.append(MenuCirculares(id: 6, nombre: "Menú principal", imagen:#imageLiteral(resourceName: "appmenu09")))
        
               var nombre = UserDefaults.standard.string(forKey: "nombreUsuario") ?? ""
                var email = UserDefaults.standard.string(forKey: "email") ?? ""
               var familia = UserDefaults.standard.string(forKey: "numeroUsuario") ?? ""
               idUsuario = UserDefaults.standard.string(forKey: "idUsuario") ?? "0"
        lblUsuario.text=nombre
        lblNumFamilia.text=familia
        lblCorreo.text=email
         
        var fotoUrl = UserDefaults.standard.string(forKey: "fotoUrl") ?? ""
        print("FOTO: \(fotoUrl)")
        if(ConexionRed.isConnectedToNetwork()){
            
          
            let address=self.urlBase+self.cifrarMetodo+"?idUsuario=\(self.idUsuario)"
            guard let _url = URL(string: address) else { return };
            let imageURL = URL(string: fotoUrl.replacingOccurrences(of: " ", with: "%20"))!
            
            
            
            Alamofire.request(imageURL).responseJSON {
              response in

              let status = response.response?.statusCode
                print("FOTO: \(status)")
                if(status!>200){
                    
                    //let imageURL = URL(string: self.urlFotos+"sinfoto.png")!
                    //self.imgFotoPerfil.cargar(url:imageURL)
                    let imageURL = URL(string: self.urlFotos+"sinfoto.png")!
                    self.imgFotoPerfil.cargar(url: imageURL)
                    
                    
                }else{
                    let imageURL = URL(string: fotoUrl.replacingOccurrences(of: " ", with: "%20"))
                    self.imgFotoPerfil.cargar(url: imageURL!)
                    //let placeholderImageURL = URL(string: self.urlFotos+"sinfoto.png")!
                // self.imgFotoPerfil.cargar(url:placeholderImageURL)
                }

            }
         }else{
            
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        
}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let valor = menu[indexPath.row]
           
        if (valor.id==1){
            performSegue(withIdentifier: "circularesSegue", sender: self)
        }
        if (valor.id==2){
            performSegue(withIdentifier: "favSegue", sender: self)
        }
        if (valor.id==3){
            performSegue(withIdentifier: "noLeidasSegue", sender: self)
        }
        if (valor.id==4){
            performSegue(withIdentifier: "eliminadasSegue", sender: self)
        }
        if (valor.id==5){
            performSegue(withIdentifier: "notificacionSegue", sender: self)
        }
        if (valor.id==6){
              self.performSegue(withIdentifier: "unwindToPrincipal", sender: self)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
           as! MenuCircularTableViewCell
        
 
           let m = menu[indexPath.row]
           cell.lblMenu.text?=m.nombre
           cell.imgMenu.image=m.imagen
        
           cell.lblTotales.layer.cornerRadius=8.0
        
       if(indexPath.row==0 || indexPath.row==3 || indexPath.row==5){
        cell.lblTotales.isHidden=true
        }
        
        if(indexPath.row==1){
            if(totalFavoritas>0){
            cell.lblTotales.text="\(totalFavoritas)"
            }else{
              cell.lblTotales.isHidden=true
            }
        }
           
        if(indexPath.row==2){
            if(totalNoLeidas>0){
               cell.lblTotales.text="\(totalNoLeidas)"
            }else{
               cell.lblTotales.isHidden=true
            }
            
        }
        
        
        if(indexPath.row==4){
            if(totalNotificaciones>0){
            cell.lblTotales.text="\(totalNotificaciones)"
            }else{
              cell.lblTotales.isHidden=true
            }
        }
           
            
        
        return cell
    }
    
    
    func getTotalFavoritas()->Int{
      print("Leer desde la base de datos local")
      let fileUrl = try!
                 FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("chmd.sqlite")
      
      if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
          print("error opening database")
      }
    
         let consulta = "SELECT COUNT(*) FROM appCircularCHMD WHERE favorita=1"
     var queryStatement: OpaquePointer? = nil
         
          if sqlite3_prepare_v2(db, consulta, -1, &queryStatement, nil) == SQLITE_OK {
                while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                       let id = sqlite3_column_int(queryStatement, 0)
                    totalItems=Int(id)
               }
            }
            else {
               print("SELECT statement could not be prepared")
             }

             sqlite3_finalize(queryStatement)
        
        return totalItems
     }
    
    
    func getTotalNotificaciones()->Int{
      print("Leer desde la base de datos local")
      let fileUrl = try!
                 FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("chmd.sqlite")
      
      if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
          print("error opening database")
      }
    
         let consulta = "SELECT COUNT(*) FROM appNotificacionCHMD WHERE leida=0"
     var queryStatement: OpaquePointer? = nil
         
          if sqlite3_prepare_v2(db, consulta, -1, &queryStatement, nil) == SQLITE_OK {
                while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                       let id = sqlite3_column_int(queryStatement, 0)
                    totalItems=Int(id)
               }
            }
            else {
               print("SELECT statement could not be prepared")
             }

             sqlite3_finalize(queryStatement)
        
        return totalItems
     }
    
    
    func getTotalNoLeidas()->Int{
         print("Leer desde la base de datos local")
         let fileUrl = try!
                    FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("chmd.sqlite")
         
         if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
             print("error opening database")
         }
       
            let consulta = "SELECT COUNT(*) FROM appCircularCHMD WHERE leida=0"
        var queryStatement: OpaquePointer? = nil
            
             if sqlite3_prepare_v2(db, consulta, -1, &queryStatement, nil) == SQLITE_OK {
                   while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                          let id = sqlite3_column_int(queryStatement, 0)
                       totalItems=Int(id)
                  }
               }
               else {
                  print("SELECT statement could not be prepared")
                }

                sqlite3_finalize(queryStatement)
           
           return totalItems
        }
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToMenuPrincipal(segue:UIStoryboardSegue) {
           
       }
    
     
    
    
    
    
    
}
