//
//  ViewController.swift
//  JSONRESTful
//
//  Created by Diego Bejarano on 6/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    var users = [Users]()
    
    func validarUsuario(ruta:String, completed: @escaping () -> ()) {
        let url = URL (string:ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
          if error == nil {
            do {
                self.users = try JSONDecoder().decode([Users].self, from: data!)
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print("Error en JSON")
            }
        }
        }.resume()
    }
    
    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: "", with: "%20")
        validarUsuario(ruta: crearURL) {
            if self.users.count <= 0 {
                print("Nombre de usuario y/o contraseña es incorrecto")
            } else {
                print("Logueo exitoso")
                if let user = self.users.first {
                    // Enviar el ID del usuario en el sender
                    self.performSegue(withIdentifier: "segueLogeo", sender: user)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogeo" {
            if let navController = segue.destination as? UINavigationController,
               let siguienteVC = navController.topViewController as? viewControllerBuscar {
                if let usuario = sender as? Users {
                    siguienteVC.usuario = usuario
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

