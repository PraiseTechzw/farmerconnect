# **Farmer Connect** 🌾🚜

[![Demo Video]([demo-video-link](https://youtu.be/FM7KA57-1dE?si=YFPB2HftXOTHJvns))][(demo-video-link](https://youtu.be/FM7KA57-1dE?si=YFPB2HftXOTHJvns))  
*Click the image above to watch a demo video of the app!*

## **Overview**
Farmer Connect is an AI-powered farming assistant designed to help farmers optimize crop management and make informed decisions. By leveraging advanced AI and real-time data, this app provides personalized crop recommendations, disease identification, and weather-based insights.

---

## **Table of Contents**
- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Technology Stack](#technology-stack)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## **Features**
### 🌱 **Farmer AI Screen**
- **Interactive Chat**: Ask farming-related questions and receive expert advice through AI.
- **Disease Identification**: Upload crop images (from gallery or camera) to instantly identify diseases. The AI provides details such as disease name, symptoms, recommended treatments, and preventative measures.

### 🌦️ **Home Screen**
- **Weather Card**: Displays real-time weather information based on your current location, including temperature, conditions, wind speed, humidity, rainfall, and pressure. Shows an error message if weather data cannot be fetched.
- **Crop Recommendations**: Provides crop suggestions based on current weather conditions, along with expected harvest dates and yield potential. Displays an error message if recommendations cannot be generated due to missing weather data.
- **Detailed Crop Info**: Access a detailed screen with tips and comprehensive information about the recommended crops (functionality depends on API response for specific crops).

---

## **Screenshots**
![Farmer AI Screen](./screenshots/farmer_ai_screen.png)
*Farmer AI Screen where users can chat with AI and upload crop images for disease identification.*

![Home Screen](./screenshots/home_screen.png)
*Home Screen featuring the weather card and crop recommendations.*

---

## **Installation**

### **Requirements**
- **Flutter SDK**: Ensure you have Flutter installed. You can download it from [Flutter’s official website](https://flutter.dev/docs/get-started/install).
- **Dependencies**: The app uses several Flutter packages. You can install these by running the command:

```bash
flutter pub get
```

### **Clone Repository**
Clone this repository to your local machine using:

```bash
git clone https://github.com/yourusername/farmerconnect.git
cd farmerconnect
```

### **Run the App**
To run the app on an emulator or a physical device, execute:

```bash
flutter run
```

---

## **Configuration**

### **API Key Setup**
To use the AI features (including crop analysis and recommendations), you need to set up your Gemini API key:
1. Create a new file named `.env` in the root directory of the project.
2. Open the `.env.example` file (also in the root directory).
3. Copy the entire content from `.env.example` and paste it into your newly created `.env` file.
4. In the `.env` file, replace `YOUR_API_KEY_HERE` with your actual Gemini API key.

**Example `.env` file:**
```env
GEMINI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxx
```
**Important:** The `.env` file is listed in `.gitignore`, so your API key will not be committed to version control. Do not share your API key publicly.

---

## **Usage**
1. **Farmer AI Screen**: Start a conversation with the AI by typing a message, or upload a crop image (using the camera or gallery option) for disease identification and advice.
2. **Home Screen**: View current weather conditions and explore crop recommendations tailored to your local weather.
3. **Crop Details**: Tap on a crop recommendation to learn more about it (details may vary based on information availability).

---

## **Technology Stack**
- **Flutter**: Frontend development for cross-platform mobile application.
- **Dart**: Programming language for Flutter.
- **Gemini AI API (Google Generative AI)**: Powers the AI chat, crop disease identification from images, and generation of crop details and recommendations.
- **Visual Crossing Weather API**: Provides weather data for the home screen and crop recommendations.
- **Geolocator Plugin**: Fetches the device's current location for weather data.
- **Flutter DotEnv**: Manages API keys securely.
- **Mockito**: Used for creating mocks for unit testing.

---

## **Testing**
The project includes unit tests for services to ensure their reliability and correctness. These tests cover the core business logic within the services, such as API interactions, data parsing, and error handling.

### **Running Tests**
To run all unit tests, execute the following command in your terminal from the project root directory:

```bash
flutter test
```
This command will discover and run all files ending with `_test.dart` in the `test` directory. Ensure all dependencies are fetched (using `flutter pub get`) before running tests.

---

## **Contributing**
We welcome contributions to enhance the app’s functionality! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit (`git commit -m 'Add a feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

---

## **License**
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## **Contact**
If you have any questions, feel free to contact us at:
- Email: [praisetechzw@gmail.com](mailto:praisetechzw@gmail.com)
