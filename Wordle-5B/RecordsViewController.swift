//
//  RecordsViewController.swift
//  Wordle-5B
//
//  Created by mac on 29/03/25.
//

import UIKit

class RecordsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var records: [Record] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           let recordsCargados = RecordsManager.shared.cargarRecords()
           print("Records cargados: \(recordsCargados)")
           
           cargarRecords()
           tableView.dataSource = self
           
           // Configuración para eliminar scroll y ajustar altura
           tableView.isScrollEnabled = false // Desactiva el scroll
           tableView.reloadData()
           tableView.layoutIfNeeded()
           
           // Ajusta la altura de la tabla al contenido
           let height = tableView.contentSize.height
           tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
       }
       
    func cargarRecords() {
        records = RecordsManager.shared.cargarRecords()
    }
       
       // MARK: - UITableViewDataSource
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return records.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        let record = records[indexPath.row]
        
        // Configurar el contenido
        var content = cell.defaultContentConfiguration()
        content.text = "\(indexPath.row + 1). \(record.nombre) - \(record.puntuacion) pts"
        content.textProperties.color = .black // Texto principal en negro
        content.secondaryText = "Tiempo: \(record.tiempo)"
        content.secondaryTextProperties.color = .darkGray // Texto secundario en gris oscuro
        
        // Fondo de la celda
        cell.backgroundColor = .white // Fondo blanco
        cell.contentConfiguration = content
        cell.layer.masksToBounds = true

        
        return cell
    }
}
