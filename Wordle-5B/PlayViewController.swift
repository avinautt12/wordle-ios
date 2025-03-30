import UIKit

struct Record: Codable {
    let nombre: String
    let puntuacion: Int
    let tiempo: String
    let fecha: Date
}


class PlayViewController: UIViewController {

    @IBOutlet weak var vidasLabel: UILabel!
    @IBOutlet weak var tecladoStackView: UIStackView!
    @IBOutlet weak var borrarButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!

    @IBOutlet weak var tiempoLabel: UILabel!
    @IBOutlet weak var puntosLabel: UILabel!

    private var filasTablero: [UIStackView] = []
    private var contenedorTablero: UIStackView!
    
    // Variables del juego
    var vidas = 3
    var ronda = 1
    var palabra: String = ""
    var intentos: [[Character?]] = []
    var intentoActual = 0
    var posicionActual = 0
    var letrasIntentadas: [Character: UIColor] = [:]
    var puntos = 0
    var tiempoInicio: Date?
    var timer: Timer?
    var tiempoTranscurrido: TimeInterval = 0
    var tiempoPausado: TimeInterval = 0
    
    // Variables de record
    private var records: [Record] = []
    private let maxRecords = 5
    
    let letras = "QWERTYUIOPASDFGHJKLZXCVBNM"
    let maxIntentos = 5
    
    // Colores personalizados
    let verdeCorrecto = UIColor(red: 0.26, green: 0.63, blue: 0.28, alpha: 1.0)
    let amarilloPosicionIncorrecta = UIColor(red: 0.89, green: 0.66, blue: 0.11, alpha: 1.0)
    let grisIncorrecto = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 1.0)
    let colorTecladoNormal = UIColor(red: 0.37, green: 0.42, blue: 0.48  , alpha: 1.0)
    let colorTecladoIncorrecto = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarRecords()
        palabra = palabraAleatoria().lowercased()
        print("Palabra a adivinar: \(palabra)")
        
        
        iniciarTemporizador()
        
        inicializarJuego()
        configurarTeclado()
        configurarBotones()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detenerTemporizador()
    }
    
    // MARK: - Configuración del juego
    
    func iniciarTemporizador() {
        tiempoInicio = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.actualizarTiempo()
        }
    }
    
    func pausarTemporizador() {
        tiempoPausado = Date().timeIntervalSince(tiempoInicio ?? Date())
        timer?.invalidate()
    }
    
    func detenerTemporizador() {
        timer?.invalidate()
    }
    
    func reanudarTemporizador() {
        tiempoInicio = Date().addingTimeInterval(-tiempoPausado)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.actualizarTiempo()
        }
    }
    
    func actualizarTiempo() {
        guard let inicio = tiempoInicio else { return }
        tiempoTranscurrido = Date().timeIntervalSince(inicio)
        
        let horas = Int(tiempoTranscurrido) / 3600
        let minutos = (Int(tiempoTranscurrido) % 3600) / 60
        let segundos = Int(tiempoTranscurrido) % 60
        
        tiempoLabel.text = String(format: "%02d:%02d:%02d", horas, minutos, segundos)
    }
    
    func sumarPuntos(cantidad: Int) {
        puntos += cantidad
        puntosLabel.text = "Puntos: \(puntos)"
    }
    
    func inicializarJuego() {
        filasTablero.forEach { $0.removeFromSuperview() }
        filasTablero.removeAll()
        letrasIntentadas.removeAll()
        
        contenedorTablero = UIStackView()
        contenedorTablero.axis = .vertical
        contenedorTablero.spacing = 8
        contenedorTablero.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contenedorTablero)
        
        NSLayoutConstraint.activate([
            contenedorTablero.topAnchor.constraint(equalTo: vidasLabel.bottomAnchor, constant: 50),
            contenedorTablero.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        for _ in 0..<maxIntentos {
            let filaStackView = UIStackView()
            filaStackView.axis = .horizontal
            filaStackView.spacing = 5
            
            for _ in 0..<palabra.count {
                let label = UILabel()
                label.text = ""
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
                label.textColor = .white
                label.backgroundColor = UIColor.systemGray
                label.layer.borderColor = UIColor.black.cgColor
                label.layer.borderWidth = 2
                label.layer.cornerRadius = 8
                label.clipsToBounds = true
                label.widthAnchor.constraint(equalToConstant: 50).isActive = true
                label.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                filaStackView.addArrangedSubview(label)
            }
            
            contenedorTablero.addArrangedSubview(filaStackView)
            filasTablero.append(filaStackView)
        }
        
        intentos = Array(repeating: Array(repeating: nil, count: palabra.count),
                        count: maxIntentos)
    }
    
    func configurarTeclado() {
        let filas = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
        
        tecladoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for filaLetras in filas {
            let filaStackView = UIStackView()
            filaStackView.axis = .horizontal
            filaStackView.distribution = .fillEqually
            filaStackView.spacing = 5
            filaStackView.alignment = .center

            for letra in filaLetras {
                let boton = UIButton(type: .system)
                boton.setTitle(String(letra), for: .normal)
                boton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                
                if let color = letrasIntentadas[letra] {
                    boton.backgroundColor = color
                } else {
                    boton.backgroundColor = colorTecladoNormal
                }
                
                boton.setTitleColor(.white, for: .normal)
                boton.layer.cornerRadius = 5
                boton.addTarget(self, action: #selector(letraPresionada(_:)), for: .touchUpInside)
                
                boton.widthAnchor.constraint(equalToConstant: 35).isActive = true
                boton.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
                filaStackView.addArrangedSubview(boton)
            }
            tecladoStackView.addArrangedSubview(filaStackView)
        }
    }
    
    func configurarBotones() {
        borrarButton.addTarget(self, action: #selector(borrarUltimaLetra), for: .touchUpInside)
        borrarButton.layer.cornerRadius = 5
        
        enterButton.addTarget(self, action: #selector(verificarPalabra), for: .touchUpInside)
        enterButton.layer.cornerRadius = 5
    }
    
    // MARK: - Lógica del juego
    
    @objc func letraPresionada(_ sender: UIButton) {
        guard let letra = sender.titleLabel?.text?.lowercased().first else { return }
        
        if posicionActual < palabra.count && intentoActual < maxIntentos {
            intentos[intentoActual][posicionActual] = letra
            posicionActual += 1
            actualizarTablero()
        }
    }
    
    @objc func borrarUltimaLetra() {
        if posicionActual > 0 {
            posicionActual -= 1
            intentos[intentoActual][posicionActual] = nil
            actualizarTablero()
        }
    }
    
    @objc func verificarPalabra() {
        guard posicionActual == palabra.count else {
            mostrarAlerta(titulo: "Incompleto", mensaje: "La palabra debe tener \(palabra.count) letras")
            return
        }
        
        let palabraIntento = String(intentos[intentoActual].compactMap { $0 })
        
        if palabraIntento == palabra {
            let puntosGanados = (maxIntentos - intentoActual) * 100
            sumarPuntos(cantidad: puntosGanados)
            
            marcarLetrasCorrectas()
            mostrarMensajeVictoria()
        } else {
            marcarLetrasSegunEstado()
            intentoActual += 1
            posicionActual = 0
            
            if intentoActual >= maxIntentos {
                perderVida()
            }
        }
        
        actualizarColoresTeclado()
    }
    
    func marcarLetrasCorrectas() {
        let fila = filasTablero[intentoActual]
        
        for (index, view) in fila.arrangedSubviews.enumerated() {
            if let label = view as? UILabel, let letra = intentos[intentoActual][index] {
                label.backgroundColor = verdeCorrecto
                label.text = String(letra).uppercased()
                
                letrasIntentadas[Character(letra.uppercased())] = verdeCorrecto
            }
        }
    }
    
    func marcarLetrasSegunEstado() {
        let fila = filasTablero[intentoActual]
        let palabraArray = Array(palabra)
        let intentoArray = intentos[intentoActual].compactMap { $0 }
        
        var letrasMarcadas: [Character: Int] = [:]
        var conteoLetrasOculta = contarLetras(palabra)
        
        // Primera pasada: marcar verdes
        for (index, view) in fila.arrangedSubviews.enumerated() {
            if let label = view as? UILabel,
               index < intentoArray.count,
               intentoArray[index] == palabraArray[index] {
                
                let letra = intentoArray[index]
                label.backgroundColor = verdeCorrecto
                label.text = String(letra).uppercased()
                
                letrasMarcadas[letra] = (letrasMarcadas[letra] ?? 0) + 1
                conteoLetrasOculta[letra]! -= 1
                
                letrasIntentadas[Character(letra.uppercased())] = verdeCorrecto
            }
        }
        
        // Segunda pasada: marcar amarillos/grises
        for (index, view) in fila.arrangedSubviews.enumerated() {
            if let label = view as? UILabel,
               index < intentoArray.count,
               intentoArray[index] != palabraArray[index] {
                
                let letra = intentoArray[index]
                
                if let conteo = conteoLetrasOculta[letra], conteo > 0 {
                    label.backgroundColor = amarilloPosicionIncorrecta
                    conteoLetrasOculta[letra]! -= 1
                    
                    if letrasIntentadas[Character(letra.uppercased())] != verdeCorrecto {
                        letrasIntentadas[Character(letra.uppercased())] = amarilloPosicionIncorrecta
                    }
                } else {
                    label.backgroundColor = grisIncorrecto
                    if letrasIntentadas[Character(letra.uppercased())] == nil {
                        letrasIntentadas[Character(letra.uppercased())] = colorTecladoIncorrecto
                    }
                }
                
                label.text = String(letra).uppercased()
            }
        }
    }
    
    func actualizarColoresTeclado() {
        for fila in tecladoStackView.arrangedSubviews {
            if let filaStack = fila as? UIStackView {
                for view in filaStack.arrangedSubviews {
                    if let boton = view as? UIButton, let letra = boton.titleLabel?.text?.first {
                        if let color = letrasIntentadas[letra] {
                            boton.backgroundColor = color
                        }
                    }
                }
            }
        }
    }
    
    func actualizarTablero() {
        guard intentoActual < maxIntentos else { return }
        
        let fila = filasTablero[intentoActual]
        for (index, view) in fila.arrangedSubviews.enumerated() {
            if let label = view as? UILabel {
                if index < posicionActual, let letra = intentos[intentoActual][index] {
                    label.text = String(letra).uppercased()
                } else {
                    label.text = ""
                }
            }
        }
    }
    
    func contarLetras(_ palabra: String) -> [Character: Int] {
        var conteo: [Character: Int] = [:]
        for letra in palabra {
            conteo[letra] = (conteo[letra] ?? 0) + 1
        }
        return conteo
    }
    
    func perderVida() {
        vidas -= 1
        actualizarVidas()
        
        if vidas == 0 {
            gameOver()
        } else {
            intentoActual = 0
            posicionActual = 0
            intentos = Array(repeating: Array(repeating: nil, count: palabra.count),
                           count: maxIntentos)
            inicializarJuego()
            configurarTeclado()
            self.palabra = self.palabraAleatoria().lowercased()
            print("Nueva palabra por perder: \(self.palabra)")
        }
    }
    
    func actualizarVidas() {
        let corazones = String(repeating: "❤️ ", count: vidas).trimmingCharacters(in: .whitespaces)
        vidasLabel.text = corazones
    }
    
    // MARK: - Manejo de Records

    func cargarRecords() {
        if let data = UserDefaults.standard.data(forKey: "records"),
           let recordsDecodificados = try? JSONDecoder().decode([Record].self, from: data) {
            records = recordsDecodificados.sorted { $0.puntuacion > $1.puntuacion }
        }
    }

    func guardarRecords() {
        let recordsOrdenados = records.sorted { $0.puntuacion > $1.puntuacion }
        let topRecords = Array(recordsOrdenados.prefix(maxRecords))
        
        if let data = try? JSONEncoder().encode(topRecords) {
            UserDefaults.standard.set(data, forKey: "records")
        }
    }

    func esNuevoRecord() -> Bool {
        return records.count < maxRecords || puntos > records.last?.puntuacion ?? 0
    }
    
    // MARK: - Alertas y reinicio
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func palabraAleatoria() -> String {
        let palabras: [String] = ["aviso", "bingo", "campo", "dardo", "elote", "fruta", "globo", "hongo", "ideas", "jugar", "koala", "lente", "mismo", "nieve", "orden", "pluma", "quiso", "rueda", "salto", "tango", "datos", "verde", "error", "yogur", "zorro", "trama", "robot", "nudos", "brisa"]
        return palabras.randomElement() ?? "error"
    }
    
    func gameOver() {
        AudioManager.shared.playLoseSound()
        if esNuevoRecord() {
            mostrarInputNombre()
        } else {
            mostrarAlertaGameOver()
        }
    }

    func mostrarInputNombre() {
        let alert = UIAlertController(
            title: "¡Nuevo Récord!",
            message: "Ingresa tu nombre para guardar tu puntuación:",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Tu nombre"
        }
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let nombre = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !nombre.isEmpty else {
                self.mostrarAlertaGameOver()
                return
            }
            
            let nuevoRecord = Record(
                nombre: nombre,
                puntuacion: self.puntos,
                tiempo: self.tiempoLabel.text ?? "00:00:00",
                fecha: Date()
            )
            
            self.records.append(nuevoRecord)
            self.guardarRecords()
            self.mostrarAlertaGameOver()
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            self.mostrarAlertaGameOver()
        })
        
        present(alert, animated: true)
    }

    func mostrarAlertaGameOver() {
        let alert = UIAlertController(
            title: "Game Over",
            message: """
            Ronda: \(ronda)
            Puntos: \(puntos)
            Tiempo: \(tiempoLabel.text ?? "")
            La palabra era: \(palabra.uppercased())
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Volver al Menú", style: .default) { _ in
            self.volverAlMenu()
        })
        
        present(alert, animated: true)
    }
    
    func volverAlMenu() {
        irAMenu()
    }
    
    func mostrarMensajeVictoria() {
        pausarTemporizador()
        AudioManager.shared.playWinSound()

        
        let puntosGanados = (maxIntentos - intentoActual) * 100
        let alert = UIAlertController(
            title: "¡Victoria!",
            message: """
            ¡Ronda \(ronda) completada!
            Puntos ganados: \(puntosGanados)
            Tiempo: \(tiempoLabel.text ?? "")
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Siguiente Ronda", style: .default, handler: { _ in
            self.ronda += 1
            self.palabra = self.palabraAleatoria().lowercased()
            print("Nueva palabra: \(self.palabra)")
            self.intentoActual = 0
            self.posicionActual = 0
            self.inicializarJuego()
            self.configurarTeclado()
            self.reanudarTemporizador()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func siguienteRonda() {
        palabra = palabraAleatoria().lowercased()
        print("Nueva palabra: \(palabra)")
        intentoActual = 0
        posicionActual = 0
        inicializarJuego()
        configurarTeclado()
    }
    
    func reiniciarJuego() {
        vidas = 3
        ronda = 1
        puntos = 0
        tiempoTranscurrido = 0
        tiempoPausado = 0
        tiempoInicio = Date()
        puntosLabel.text = "Puntos: 0"
        
        palabra = palabraAleatoria().lowercased()
        print("Nueva palabra: \(palabra)")
        intentoActual = 0
        posicionActual = 0
        letrasIntentadas.removeAll()
        inicializarJuego()
        configurarTeclado()
    }
    
    @objc func irAMenu() {
        navegarA(pantalla: "GameVC")
    }

    func navegarA(pantalla: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: pantalla)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
