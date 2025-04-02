//
//  RecordsManager.swift
//  Wordle-5B
//
//  Created by mac on 30/03/25.
//

import Foundation

class RecordsManager {
    static let shared = RecordsManager()
    private let maxRecords = 5
    private let plistFileName = "Records.plist"
    
    private var recordsIniciales: [Record] = [
        Record(nombre: "Aquilino", puntuacion: 500, tiempo: "00:05:00", fecha: Date()),
        Record(nombre: "María", puntuacion: 400, tiempo: "00:06:30", fecha: Date()),
        Record(nombre: "Juan", puntuacion: 300, tiempo: "00:07:45", fecha: Date()),
        Record(nombre: "Ana", puntuacion: 200, tiempo: "00:08:20", fecha: Date()),
        Record(nombre: "Pedro", puntuacion: 100, tiempo: "00:10:00", fecha: Date())
    ]
    
    
    private init() {}
    
    // Records hardcodeados iniciales
    
    func cargarRecords() -> [Record] {
        if let records = cargarDesdePlist() {
            return ordenarRecords(records)
        } else {
            // Si no existe el archivo, creamos uno con records iniciales
            guardarRecords(recordsIniciales)
            return recordsIniciales
        }
    }
    
    func guardarRecords(_ records: [Record]) {
        let recordsOrdenados = ordenarRecords(records)
        let topRecords = Array(recordsOrdenados.prefix(maxRecords))
        guardarEnPlist(topRecords)
    }
    
    func agregarRecord(nombre: String, puntuacion: Int, tiempo: String) {
        var records = cargarRecords()
        let nuevoRecord = Record(nombre: nombre, puntuacion: puntuacion, tiempo: tiempo, fecha: Date())
        records.append(nuevoRecord)
        guardarRecords(records)
    }
    
    func esNuevoRecord(puntuacion: Int, tiempo: String) -> Bool {
        let records = cargarRecords()
        
        // Si aún no hay 5 records, siempre es nuevo
        if records.count < maxRecords {
            return true
        }
        
        // Comparamos con el peor record actual
        guard let peorRecord = records.last else { return true }
        
        // Primero por puntuación
        if puntuacion > peorRecord.puntuacion {
            return true
        }
        // Si igual puntuación, por tiempo
        else if puntuacion == peorRecord.puntuacion {
            let tiempoActual = Record(nombre: "", puntuacion: 0, tiempo: tiempo, fecha: Date()).tiempoEnSegundos()
            return tiempoActual < peorRecord.tiempoEnSegundos()
        }
        
        return false
    }
    
    // MARK: - Métodos privados
    
    private func ordenarRecords(_ records: [Record]) -> [Record] {
        return records.sorted {
            if $0.puntuacion != $1.puntuacion {
                return $0.puntuacion > $1.puntuacion // Mayor puntuación primero
            } else {
                return $0.tiempoEnSegundos() < $1.tiempoEnSegundos() // Menor tiempo primero
            }
        }
    }
    
    private func guardarEnPlist(_ records: [Record]) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        do {
            let data = try encoder.encode(records)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let archiveURL = documentsDirectory.appendingPathComponent(plistFileName)
            try data.write(to: archiveURL)
        } catch {
            print("Error al guardar records en plist: \(error)")
        }
    }
    
    private func cargarDesdePlist() -> [Record]? {
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           let archiveURL = documentsDirectory.appendingPathComponent(plistFileName)
           
           guard FileManager.default.fileExists(atPath: archiveURL.path) else {
               return nil
           }
           
           do {
               let data = try Data(contentsOf: archiveURL)
               return try PropertyListDecoder().decode([Record].self, from: data)
           } catch {
               print("Error al cargar records desde plist: \(error)")
               return nil
           }
       }
   }
