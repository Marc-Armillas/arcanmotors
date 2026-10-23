# ArCan Motors

Web de ArCan Motors, concesionario especializado en Porsche de ocasión. Tiene dos partes:

- **Web pública** (`/`, `/coches`, `/about_us`): catálogo de coches en stock con ficha técnica, galería de fotos y contacto por WhatsApp. Incluye SEO técnico (meta etiquetas, Open Graph, JSON-LD y sitemap).
- **Panel de administración** (`/admin`): alta y edición de coches, fotos, categorías y solicitudes de contacto. Se entra por `/admin22`.

## Stack

| | Versión |
|---|---|
| Ruby | 3.3.5 (`.ruby-version`, gemset RVM `arcanmotors` en `.ruby-gemset`) |
| Rails | 7.2 |
| PostgreSQL | 14 o superior |
| Node.js | 18.20.4 |
| Yarn | 1.22.19 |
| Front | Webpacker 5 (webpack 4), Tailwind 2 en el admin, SCSS propio en la web pública |
| Imágenes | Active Storage + libvips, en S3 en producción |

## Puesta en marcha en local

### 1. Dependencias del sistema

```sh
# Ubuntu / WSL
sudo apt install -y postgresql libpq-dev libvips42

# macOS
brew install postgresql@16 vips
```

### 2. Ruby con RVM

```sh
rvm install 3.3.5
cd arcanmotors   # RVM selecciona Ruby 3.3.5 y el gemset arcanmotors automáticamente
bundle install
```

### 3. Node y Yarn

```sh
nvm install 18.20.4 && nvm use 18.20.4
npm install -g yarn@1.22.19
yarn install
```

### 4. Base de datos

```sh
bin/rails db:create db:migrate db:seed
```

Las semillas crean países, marcas, categorías y un usuario administrador de prueba (ver `db/seeds.rb`).

Si Postgres corre en Docker en lugar de en local:

```sh
docker run -d --name arcan-pg -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16
export DATABASE_URL=postgres://postgres@localhost:5432/arcanmotors_development
```

### 5. Arrancar

```sh
bin/rails s -b 0.0.0.0
```

Abre http://localhost:3000. CSS y JS se compilan en la primera petición. Para recompilar al guardar, lanza en otra terminal:

```sh
NODE_OPTIONS=--openssl-legacy-provider bin/webpack-dev-server
```

`NODE_OPTIONS=--openssl-legacy-provider` solo hace falta con Node 17 o superior, porque webpack 4 usa un algoritmo de hash que OpenSSL 3 ya no permite.

Para entrar desde otro equipo (por ejemplo, por Tailscale), usa la IP de la máquina: `http://<ip>:3000`. Si quieres usar un nombre de host, añádelo a `config.hosts` en `config/environments/development.rb`.

## Credenciales

Las claves están cifradas en `config/credentials.yml.enc`. Para leerlas necesitas `config/master.key`, que no está en el repositorio: pídesela a quien mantenga el proyecto.

```sh
EDITOR="vi" bin/rails credentials:edit
```

```yaml
whatsapp:
  phone_number: "34600000000"   # sin + ni espacios; se usa en todos los enlaces de WhatsApp y teléfono
aws:
  access_key_id: ...
  secret_access_key: ...
  region: ...
  bucket: ...
unami:
  arcanmotors_id: ...           # id del sitio en Umami Analytics
```

**Sin `master.key`:** la app arranca igualmente. En desarrollo, Active Storage guarda las imágenes en `storage/` en lugar de S3, y los botones de WhatsApp no llevan número.

En producción, además, la base de datos lee la contraseña de `ARCANMOTORS_DATABASE_PASSWORD`.

## Administración

- Inicia sesión en `/admin22` con un usuario con rol `admin`.
- Desde `/admin/cars` se crean y editan coches. Cada coche necesita al menos una foto.
- **Mostrar en la web de cliente?:** si está en "No", el coche no aparece en la web pública ni en el sitemap.
- **Mostrar en Página Principal:** el coche aparece en el carrusel "Recién llegados" de la portada.
- **Estado venta = Vendido:** al marcarlo, el coche se oculta automáticamente de la web y de la home.

Para dar rol de administrador a un usuario existente:

```sh
bin/rails runner 'User.find_by(email: "tu@email.com").update!(role: :admin)'
```

## SEO

- Título, descripción, canonical y Open Graph de cada página se definen en la vista con el helper `seo` (`app/helpers/seo_helper.rb`).
- Datos estructurados JSON-LD: `AutoDealer` en todas las páginas, y `Car` con `Offer` y `BreadcrumbList` en cada ficha.
- Sitemap generado con `sitemap_generator` (`config/sitemap.rb`):

  ```sh
  RAILS_ENV=production bin/rake sitemap:refresh
  ```

## Estructura del front público

| Ruta | Contenido |
|---|---|
| `app/javascript/stylesheets/site.scss` | Sistema de diseño de la web pública (colores, tipografía, componentes) |
| `app/views/layouts/application.html.erb` | Layout público con meta etiquetas y JSON-LD |
| `app/views/shared/` | Header, footer y botón flotante de WhatsApp |
| `app/views/components/_car_card.html.erb` | Tarjeta de coche del carrusel y del listado |
| `app/helpers/cars_helper.rb` | Precios, traducción de enums, ficha técnica y variantes de imagen |
| `app/javascript/packs/` | Menú móvil, galería (Swiper) y carrusel de la home |

## Tests y calidad

```sh
bin/rails test
bin/rubocop
bin/brakeman
```

## Despliegue

La app corre en una instancia EC2 como servicio `systemd` (`arcanmotors.service`). El despliegue sale de la rama `production`.

- **GitHub Actions:** lanza a mano el workflow **Deploy to EC2** (`.github/workflows/aws.yml`).
- **Desde tu máquina:**

  ```sh
  bin/rake deploy:to_ec2
  ```

Ambos hacen `git pull`, instalan dependencias, compilan los assets, regeneran el sitemap, migran la base de datos y reinician el servicio.
