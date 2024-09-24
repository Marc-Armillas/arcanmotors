# Arcan Motors

Arcan Motors is a web application built with Ruby on Rails. It provides a platform for managing motor-related services and products.

## Prerequisites

- Ruby 3.3.0
- Rails 7.2.1
- PostgreSQL
- Node.js
- Yarn

## Getting Started

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Marc-Armillas/arcan-motors.git
    cd arcan-motors
    ```

2. Install dependencies:
    ```sh
    bundle install
    yarn install
    ```

3. Set up the database:
    ```sh
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Set up credentials:
    ```sh
    EDITOR="vim" bin/rails credentials:edit
    ```

    Add your WhatsApp phone number under `whatsapp`:
    ```yaml
    whatsapp:
      phone_number: 'your_phone_number'
    ```

5. Set up environment variables:
    ```sh
    export ARCANMOTORS_DATABASE_PASSWORD='your_database_password'
    ```

### Running the Application

1. Start the Rails server:
    ```sh
    rails server
    ```

2. Open your browser and navigate to `http://localhost:3000`.

## Testing
TODO:


# Arcan Motors

Arcan Motors is a web application built with Ruby on Rails. It provides a platform for managing motor-related services and products.

## Prerequisites

- Ruby 3.3.0
- Rails 7.2.1
- PostgreSQL
- Node.js
- Yarn

## Getting Started

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Marc-Armillas/arcan-motors.git
    cd arcan-motors
    ```

2. Install dependencies:
    ```sh
    bundle install
    yarn install
    ```

3. Set up the database:
    ```sh
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Set up credentials:
    ```sh
    EDITOR="vim" bin/rails credentials:edit
    ```

    Add your WhatsApp phone number under `whatsapp`:
    ```yaml
    whatsapp:
      phone_number: 'your_phone_number'
    ```

5. Set up environment variables:
    ```sh
    export ARCANMOTORS_DATABASE_PASSWORD='your_database_password'
    ```

### Running the Application

1. Start the Rails server:
    ```sh
    rails server
    ```

2. Open your browser and navigate to `http://localhost:3000`.

## Testing

To run the test suite, execute:
```sh
rails test
