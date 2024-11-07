//
//  editarPerfilViewController.swift
//  JSONRESTful
//
//  Created by Diego Bejarano on 7/11/24.
//

import UIKit

class editarPerfilViewController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var usuario: Users?
    
    @IBOutlet weak var botonActualizar: UIButton!
    
    @IBAction func btnActualizar(_ sender: Any) {
        let id = usuario?.id ?? 0
        let nombre = txtNombre.text!
        let clave = txtClave.text!
        let email = txtEmail.text!
        let datos = ["usuarioId": id, "nombre": "\(nombre)", "clave": "\(clave)", "email": "\(email)"] as Dictionary<String, Any>
        let ruta = "http://localhost:3000/usuarios/\(id)"
        print(datos)
        metodoPUT(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
        
    }
    
    func metodoPUT(ruta:String, datos:[String:Any]) {
        let url : URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        // this is you inpout paramter dictionary
        let params = datos
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            // catch any exception here
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (data == nil) {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict)
                } catch {
                    // catch any exception here
                }
            }
        })
        task.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(usuario)
        if usuario != nil {
            botonActualizar.isEnabled = true
            txtNombre.text = usuario!.nombre
            txtClave.text = usuario!.clave
            txtEmail.text = usuario!.email
        }

        // Do any additional setup after loading the view.
    }

}
