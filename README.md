# Weather Forecast App (Ruby on Rails)

This is a Ruby on Rails application that retrieves and caches weather forecast data based on an address input. The app uses the OpenWeather API and caches results for 30 minutes.

---

## Features
- Accepts an address as input (city or ZIP code)
- Fetches weather details using OpenWeather API
- Displays temperature, high/low, and weather conditions
- Caches weather data for 30 minutes
- Displays an indicator when data is retrieved from the cache

---

## Prerequisites
Make sure you have the following installed:

- **Ruby** (>= 3.0.0)
- **Rails** (>= 7.0.0)
- **Bundler**
- **Git**

---

## Installation & Setup

### 1. Clone the Repository
```sh
git clone https://github.com/your-username/weather-forecast-app.git
cd weather-forecast-app
```

### 2. Install Dependencies
```sh
bundle install
```

### 3. Set Up the `.env` File
This project uses an **environment file (.env)** to store API keys securely. To set up your API key:

1. Install the `dotenv-rails` gem (already included in `Gemfile`).
2. Create a `.env` file in the root directory:

```sh
touch .env
```

3. Open the `.env` file and add your **OpenWeather API key**:

```
OPENWEATHER_API_KEY=your_api_key_here
```

4. Ensure `.env` is ignored by Git by checking the `.gitignore` file:

```
# Ignore environment variables
.env
```

---

## Database Setup
Project doesn't require a database as the project was created using skip active record parameter.

---

## Running the Application

### Start the Server
```sh
rails server
```
The app will be available at: **http://localhost:3000/**

### Stop the Server
Press `CTRL + C` in the terminal.

---

## How to Use the App
1. Open the app in your browser (`http://localhost:3000/`).
2. Enter a city or ZIP code in the search bar.
3. Click **Get Weather**.
4. The weather details will be displayed on a new page.
5. If the result is cached, a message will indicate that the data was retrieved from the cache.

---