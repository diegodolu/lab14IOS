//
//  viewControllerBuscar.swift
//  JSONRESTful
//
//  Created by Diego Bejarano on 6/11/24.
//

import UIKit

class viewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaPeliculas: UITableView!
    @IBOutlet weak var txtBuscar: UITextField!
    var peliculas = [Peliculas]()
    var usuario: Users?
    
    @IBAction func btnEdit(_ sender: Any) {
        if let usuario = usuario {
            print("--- desde el btnEdit ----- \(usuario)")
                performSegue(withIdentifier: "editarPerfil", sender: usuario)
            } else {
                print("El usuario es nil, no se puede hacer el segue")
            }
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty{
            let ruta  = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta) {
                self.tablaPeliculas.reloadData()
            }
        } else {
            cargarPeliculas(ruta: crearURL) {
                if self.peliculas.count <= 0{
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraton coincidencias para: \(nombre)", accion: "cancel")
                }else {
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error == nil {
                do {
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("Error en JSON, \(error)")
                }
            }
        }.resume()
    }
    
    func mostrarAlerta(titulo:String , mensaje:String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text? = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text? = "Género: \(peliculas[indexPath.row].genero) Duracion: \(peliculas[indexPath.row].duracion)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditar" {
            let siguienteVC = segue.destination as! viewControllerAgregar
            siguienteVC.pelicula = sender as? Peliculas
        } else if segue.identifier == "editarPerfil" {
            let siguienteVC = segue.destination as! editarPerfilViewController
            if let usuario = sender as? Users {
                siguienteVC.usuario = usuario
                print("Usuario recibido en el siguiente VC: \(usuario)")
            } else {
                print("El usuario es nil o no se pasó correctamente.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alerta = UIAlertController(title: "Eliminar Película", message: "¿Seguro de eliminar esta película?", preferredStyle: .alert)
            let accionEliminar = UIAlertAction(title: "Sí", style: .destructive) { _ in
                self.peliculas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let accionCancelar = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alerta.addAction(accionEliminar)
            alerta.addAction(accionCancelar)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(usuario)
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
    }

}
