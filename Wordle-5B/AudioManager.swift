import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?
    
    var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "soundEnabled")
        }
    }
    
    var isMusicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isMusicEnabled, forKey: "musicEnabled")
            if !isMusicEnabled {
                stopBackgroundMusic()
            } else {
                playBackgroundMusic()
            }
        }
    }
    
    private init() {
        // Cargar configuración guardada o usar valores por defecto
        isSoundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        isMusicEnabled = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
    }
    
    // Cargar sonidos
    private func loadSound(named fileName: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("Error: Archivo \(fileName) no encontrado")
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("Error al cargar sonido \(fileName): \(error.localizedDescription)")
            return nil
        }
    }
    
    // Música de fondo
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }
        
        if backgroundPlayer == nil {
            backgroundPlayer = loadSound(named: "musica_inicio.mp3")
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.volume = 0.5
        }
        
        if backgroundPlayer?.isPlaying == false {
            backgroundPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }
    
    // Efectos de sonido
    func playWinSound() {
        guard isSoundEnabled else { return }
        
        effectPlayer = loadSound(named: "logro.mp3")
        effectPlayer?.play()
    }
    
    func playLoseSound() {
        guard isSoundEnabled else { return }
        
        effectPlayer = loadSound(named: "error.mp3")
        effectPlayer?.play()
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
    }
    
    func toggleSoundEffects() {
        isSoundEnabled.toggle()
    }
}
