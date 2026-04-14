# f_crypto

A high-performance, reactive Flutter application for tracking cryptocurrency quotes in real-time using the Binance API. This project demonstrates advanced stream management, efficient UI rendering, and architectural patterns.

<table align="center">
  <tr>
    <td align="center">
      <video src="https://github.com/user-attachments/assets/cfc3f2bb-7102-458d-805d-d2d03d298b11.webm" width="320" autoplay="autoplay" loop="loop" muted="muted" playsinline="playsinline"></video>
    </td>
    <td align="center">
      <video src="https://github.com/user-attachments/assets/d5ea4420-f48e-4a6a-b1b4-e6b86542e967.webm" width="320" autoplay="autoplay" loop="loop" muted="muted" playsinline="playsinline"></video>
    </td>
  </tr>
</table>

## 🚀 Key Features

*   **Real-time Streaming**: Live price updates via Binance WebSockets with an automated reconnection system.
*   **High Performance**: 
    *   **Isolate Execution**: Heavy JSON parsing is offloaded to background isolates using `worker_manager` to keep the UI thread jank-free.
    *   **Granular Rebuilds**: Optimized Riverpod providers ensure only specific text fields update when prices change.
    *   **Layer Isolation**: Uses `RepaintBoundary` to minimize GPU draw calls during frequent price updates.
*   **Smart Filtering & Sorting**: Instant search by symbol and multi-criteria sorting (Price, 24h Change, Volume).
*   **Resilient Connectivity**: Integrated internet connection monitoring to gracefully handle offline states and service restarts.

## 🛠 Tech Stack

### Reactive Data Pipeline
The application implements a robust data synchronization strategy:
1. **Initial Snapshot**: Fetches current market state via REST API.
2. **Real-time Sync**: Switches to WebSockets for live updates.
3. **Resilience**: Integrated `AppReconnector` uses an **Exponential Backoff** algorithm to handle rate limits and network instability.
4. **Data Integrity**: The pipeline is guarded by `Rx.retryWhen` and monitors internet status to ensure zero data loss during transitions.

### Core Architecture
- **State Management**: `flutter_riverpod` 
- **Reactive Programming**: `rxdart` for complex stream manipulation.
- **Concurrency**: `worker_manager` for multi-threaded data processing.
- **Networking**: `web_socket_channel` & `http`.

### UI & UX
- **Image Caching**: `cached_network_image` for cryptocurrency logos.
- **Connectivity**: `internet_connection_checker_plus`.
- **Localization & Formatting**: `intl` for precise currency and number formatting.

### Testing Suite
- **Framework**: `flutter_test` & `mocktail`.
- **Logic Testing**: `state_notifier_test` for validating business logic transitions.
- **Async Utility**: `fake_async` for deterministic testing of time-dependent streams.

## 🏗 Architectural Layers

* **Service Layer:**
    * **BinanceCryptoService:** Manages the WebSocket lifecycle, REST snapshots, and stream piping.
    * **Data Mapping:**  `BinanceMapper` transforms DTOs (`BinanceCurrencyFromSocket/Api`) into clean Domain Entities.
    * **BinanceStorage:** Acts as an in-memory cache, performing "upsert" operations to avoid redundant UI notifications.

- **Presentation Layer**: A chain of computed Providers (`Filtered` -> `Sorted` -> `Single currency`) ensures that each row in the list is independent and highly optimized.

## 📦 Getting Started

1. **Clone the repository**:

   ```bash

   git clone https://github.com/Fednov/f_crypto.git

   ```

2. **Install dependencies**:

   ```bash

   flutter pub get

   ```

3. **Run the app**:
   ```bash

   flutter run

   ```



