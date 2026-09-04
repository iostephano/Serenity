# Serenity — Maqueta de una app de meditación con reproductor simulado

Serenity es una app de iOS con dos pantallas: un onboarding y una pantalla de cursos
con un dashboard, un filtro de categorías (Mantras, Meditación, Sueño) y una lista de
pistas con un reproductor compacto (progreso, adelantar/retroceder 15 s, bucle). No
reproduce audio: un reloj simulado avanza el tiempo para que la interfaz tenga algo
que mostrar. Existe como proyecto de portafolio para enseñar composición de interfaz
en SwiftUI, un sistema de diseño propio, estado con `@Observable`, y lógica de
transporte de reproducción aislada y probada.

<img width="1259" height="665" alt="Serenity" src="https://github.com/user-attachments/assets/7a7bdc6b-71b3-4d56-a880-4cb25e07bb7e" />

---

## Tecnologías usadas

- Swift 6 (con verificación estricta de concurrencia activada)
- SwiftUI + `@Observable` para el estado
- `async/await` (`Task` / `Task.sleep`) para el reloj del reproductor, sin Combine
- Portadas generadas por código (degradados), sin imágenes de terceros
- Swift Testing para las pruebas
- Integración continua con GitHub Actions (compila y corre los tests en cada push/PR)
- Cero dependencias externas

---

## Cómo está organizado el proyecto

```
Serenity/
├── App/
│   ├── SerenityApp.swift          # @main; enruta onboarding ↔ cursos
│   └── AppRouter.swift            # @Observable: pantalla actual
├── DesignSystem/
│   ├── Colors / Spacing / Radius  # tokens
│   ├── Background/Backgrounds.swift
│   ├── Cover/CoverArt.swift       # portada procedural por categoría + semilla
│   ├── Extensions/Color+Hex.swift
│   └── Components/                # FilterChip, PrimaryButton, SecondaryButton,
│       │                         #   TagChip, LotusMark (el logo, dibujado con Path)
├── Features/
│   ├── Onboarding/OnboardingView.swift
│   └── Courses/
│       ├── CoursesView.swift
│       ├── CoursesViewModel.swift # @Observable; expone el reproductor y el filtro
│       ├── Models/Track.swift
│       └── Components/            # TrackRow, MiniPlayerView, PlanOfDayCard,
│                                  #   SleepMeditationPromoCard, PlanCard
└── Services/
    ├── MeditationService.swift    # protocolo
    ├── MockMeditationService.swift# catálogo de ejemplo (15 pistas)
    └── SimulatedPlayer.swift      # reloj simulado: avance, seek, bucle, fin
```

`SimulatedPlayer`, `Track` y `MockMeditationService` no dependen de SwiftUI y son lo
que cubren las pruebas.

---

## Cómo funciona / flujo principal

1. `AppRouter` empieza en `.onboarding`. Al pulsar "Empezar" pasa a `.courses`.
2. `CoursesViewModel` recibe un `MeditationServiceProtocol` (aquí el mock) y crea un
   `SimulatedPlayer`.
3. Sin categoría seleccionada se ve el dashboard (plan del día, promo, afirmaciones,
   card de sueño). Al elegir una categoría se muestra su lista de `TrackRow`.
4. Al tocar una pista, `SimulatedPlayer.play(_:)` fija la duración a partir de los
   minutos de la pista y arranca un bucle `Task` que llama a `advance(by:)` cada 50 ms.
5. `advance(by:)` suma el tiempo y, al llegar al final, o vuelve a 0 (si el bucle está
   activo) o para y fija el tiempo a la duración.
6. El `MiniPlayerView` muestra el progreso; su barra es arrastrable y llama a
   `seek(toFraction:)`; los botones ±15 s llaman a `seek(by:)` con recorte.

---

## Funcionalidades / qué demuestra

- Sistema de diseño propio (tokens de color/espaciado/radio, chips, botones) y un logo
  vectorial dibujado con `Path` en vez de una imagen.
- Portadas procedurales: `CoverArt` genera un degradado cuya paleta depende de la
  categoría y cuyo ángulo depende de una semilla — sin ningún archivo de imagen.
- Estado con `@Observable` inyectado por valor, sin `ObservableObject` ni singletons.
- Lógica de transporte del reproductor (avance de tiempo, límites, fin de pista,
  bucle) separada de la interfaz y probada.
- Navegación entre pantallas con un router `@Observable`.

---

## Pruebas

`SerenityTests` (Swift Testing):

- **`SimulatedPlayer`**: no suena nada antes de `play`; `play` fija la duración y
  arranca en 0; `advance` mueve el reloj mientras se reproduce y lo ignora en pausa;
  sin bucle, llegar al final para y fija el tiempo; con bucle, vuelve a 0 y sigue;
  `seek(by:)` y `seek(toFraction:)` recortan en ambos extremos; volver a reproducir la
  misma pista no reinicia su posición.
- **`MockMeditationService` / `Track`**: cinco pistas por categoría; `tracks(for:)`
  filtra exacto; las semillas de portada son únicas; `durationText` / `totalSeconds`
  se derivan de los minutos; una pista de 0 minutos sigue teniendo duración positiva.
- **`CoursesViewModel`**: seleccionar y limpiar categoría hace ida y vuelta; reproducir
  una pista nueva la fija como actual desde 0; volver a tocarla alterna la pausa.

Correr los tests:

```bash
xcodebuild test \
  -project Serenity.xcodeproj \
  -scheme Serenity \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Cómo correr el proyecto

1. Clona el repo:
   ```bash
   git clone https://github.com/iostephano/Serenity.git
   ```
2. Abre `Serenity.xcodeproj` con **Xcode 26** (ver `.xcode-version`).
3. El objetivo mínimo es **iOS 26**. Elige un simulador de iPhone o un dispositivo y
   ejecuta (Cmd-R).

---

## Cosas pendientes o limitadas (a propósito)

- **No hay reproducción de audio.** `SimulatedPlayer` solo lleva un reloj; no hay
  `AVAudioPlayer` ni archivos de sonido. El progreso, el seek y el bucle son sobre ese
  reloj simulado.
- **Botones y controles puramente visuales** (alternan su estado local pero no hacen
  nada más):
  - En el dashboard: el **corazón de recordatorio** y las **franjas horarias**
    (Mañana / Tarde / Noche) de "Plan del día"; los **chips** (15 min / Tarde / Relax)
    y el **botón de play** de la tarjeta de afirmaciones; el **botón de play** de la
    tarjeta "Meditación para dormir" y de la promo lateral.
  - En el onboarding: el botón **"Explorar"**.
  - El buscador y "Ver todo" no existen en esta versión.
- **Los datos están en código** (`MockMeditationService`): títulos, subtítulos y
  duraciones son de ejemplo; no se cargan de red ni de disco.
- **Las portadas son degradados generados**, no ilustraciones; la paleta cambia por
  categoría y por la semilla de cada pista.
- **El onboarding usa medidas fijas** para colocar el logo y el título; está pensado
  para iPhone en vertical.

---

## Autor

Stephano Portella

