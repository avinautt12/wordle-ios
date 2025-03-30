import UIKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
          super.viewDidLoad()
          cargarRecordsSiEsNecesario()
          configurarSwitches()
          AudioManager.shared.playBackgroundMusic()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // Actualizar switches cuando se vuelve a esta pantalla
          configurarSwitches()
      }
      
      private func configurarSwitches() {
          // Configurar switches con los valores actuales
          MusicaSwitch.isOn = AudioManager.shared.isMusicEnabled
          EfectosSwitch.isOn = AudioManager.shared.isSoundEnabled
          
          // Añadir acciones
          MusicaSwitch.addTarget(self, action: #selector(musicaSwitchChanged), for: .valueChanged)
          EfectosSwitch.addTarget(self, action: #selector(efectosSwitchChanged), for: .valueChanged)
      }
      
      @objc private func musicaSwitchChanged(_ sender: UISwitch) {
          AudioManager.shared.isMusicEnabled = sender.isOn
      }
      
      @objc private func efectosSwitchChanged(_ sender: UISwitch) {
          AudioManager.shared.isSoundEnabled = sender.isOn
      }
      
      func cargarRecordsSiEsNecesario() {
          if UserDefaults.standard.data(forKey: "records") == nil {
              // Si no hay récords, crea los falsos
              let recordsIniciales = [
                  Record(nombre: "Aquilino", puntuacion: 500, tiempo: "00:05:00", fecha: Date()),
                  Record(nombre: "María", puntuacion: 400, tiempo: "00:06:30", fecha: Date()),
                  Record(nombre: "Juan", puntuacion: 300, tiempo: "00:07:45", fecha: Date()),
                  Record(nombre: "Ana", puntuacion: 200, tiempo: "00:08:20", fecha: Date()),
                  Record(nombre: "Pedro", puntuacion: 100, tiempo: "00:10:00", fecha: Date())
              ]
              
              if let data = try? JSONEncoder().encode(recordsIniciales) {
                  UserDefaults.standard.set(data, forKey: "records")
              }
          }
      }
}
