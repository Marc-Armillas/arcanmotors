namespace :deploy do
  desc "Deploy app to arcanmotors-vm1 EC2"
  task(to_ec2: :environment) do
    server_ip = Rails.application.credentials.dig(:ssh, :server_ip) || "13.37.206.190"
    app_path = "/home/ubuntu/arcanmotors"
    log_file = "/home/ubuntu/arcanmotors/deploy.log"

    commands = <<-SSH
      cd #{app_path}
      echo "---- Despliegue iniciado: $(date) ----" > #{log_file}
      rm public/sitemap.xml.gz >> #{log_file} 2>&1
      git pull origin production >> #{log_file} 2>&1
      bundle install >> #{log_file} 2>&1
      yarn install --production >> #{log_file} 2>&1
      RAILS_ENV=production rails assets:precompile >> #{log_file} 2>&1
      RAILS_ENV=production rake sitemap:refresh >> #{log_file} 2>&1
      RAILS_ENV=production rails db:migrate >> #{log_file} 2>&1
      sudo systemctl restart arcanmotors.service >> #{log_file} 2>&1
      echo "---- Despliegue finalizado: $(date) ----" >> #{log_file}
    SSH

    puts "Desplegando a EC2 en #{server_ip}..."
    system("ssh -o StrictHostKeyChecking=no ubuntu@#{server_ip} '#{commands}'")

    if $?.success?
      puts "Despliegue completado con éxito. Revisa los logs en #{log_file}."
    else
      puts "Hubo un error en el despliegue. Revisa los logs en #{log_file}."
      exit(1)
    end
  end
end