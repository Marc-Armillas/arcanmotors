import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import "../stylesheets/application.scss";

// Application JS FILES
import './mobile_menu';
import './flash_messages'

// Admin JS FILES
import './admin/contact_request_modal';
import './admin/car_imgs_upload';

Rails.start()
Turbolinks.start();
