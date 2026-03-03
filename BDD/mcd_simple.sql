CREATE TABLE absences (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  reason VARCHAR(255) NOT NULL,
  comment TEXT NULL,
  start_at TIMESTAMP NOT NULL,
  end_at TIMESTAMP NOT NULL,
  medical_certificate TINYINT(1) NULL,
  user_id INT UNSIGNED NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE activities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  log_name VARCHAR(255) NULL,
  causer_id BIGINT UNSIGNED NULL,
  causer_type VARCHAR(255) NULL,
  text VARCHAR(255) NOT NULL,
  source_type VARCHAR(255) NOT NULL,
  source_id BIGINT UNSIGNED NULL,
  ip_address VARCHAR(64) NOT NULL,
  properties LONGTEXT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE appointments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL,
  source_type VARCHAR(255) NULL,
  source_id BIGINT UNSIGNED NULL,
  color VARCHAR(10) NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  client_id INT UNSIGNED NULL,
  start_at TIMESTAMP NULL,
  end_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE business_hours (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  day VARCHAR(255) NOT NULL,
  open_time TIME NULL,
  close_time TIME NULL,
  settings_id INT UNSIGNED NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE clients (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  address VARCHAR(255) NULL,
  zipcode VARCHAR(255) NULL,
  city VARCHAR(255) NULL,
  company_name VARCHAR(255) NOT NULL,
  vat VARCHAR(255) NULL,
  company_type VARCHAR(255) NULL,
  client_number BIGINT NULL,
  user_id INT UNSIGNED NOT NULL,
  industry_id INT UNSIGNED NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE comments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  description LONGTEXT NULL,
  source_type VARCHAR(255) NOT NULL,
  source_id BIGINT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE contacts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  primary_number VARCHAR(255) NULL,
  secondary_number VARCHAR(255) NULL,
  client_id INT UNSIGNED NOT NULL,
  is_primary TINYINT(1) NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE departments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE department_user (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE documents (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  size VARCHAR(255) NOT NULL,
  path VARCHAR(255) NOT NULL,
  original_filename VARCHAR(255) NOT NULL,
  mime VARCHAR(255) NOT NULL,
  integration_id VARCHAR(255) NULL,
  integration_type VARCHAR(255) NOT NULL,
  source_type VARCHAR(255) NOT NULL,
  source_id BIGINT UNSIGNED NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE industries (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE integrations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  client_id INT NULL,
  user_id INT NULL,
  client_secret INT NULL,
  api_key VARCHAR(255) NULL,
  api_type VARCHAR(255) NULL,
  org_id VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE invoices (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL,
  invoice_number BIGINT NULL,
  sent_at DATETIME NULL,
  due_at DATETIME NULL,
  integration_invoice_id VARCHAR(255) NULL,
  integration_type VARCHAR(255) NULL,
  source_type VARCHAR(255) NULL,
  source_id BIGINT UNSIGNED NULL,
  client_id INT UNSIGNED NOT NULL,
  offer_id INT UNSIGNED NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE invoice_lines (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  comment TEXT NOT NULL,
  price INT NOT NULL,
  invoice_id INT UNSIGNED NULL,
  offer_id INT UNSIGNED NULL,
  type VARCHAR(255) NULL,
  quantity INT NULL,
  product_id VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE leads (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status_id INT UNSIGNED NOT NULL,
  user_assigned_id INT UNSIGNED NOT NULL,
  client_id INT UNSIGNED NOT NULL,
  user_created_id INT UNSIGNED NOT NULL,
  qualified TINYINT(1) NOT NULL,
  result VARCHAR(255) NULL,
  deadline DATETIME NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE mails (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  subject VARCHAR(255) NOT NULL,
  body VARCHAR(255) NULL,
  template VARCHAR(255) NULL,
  email VARCHAR(255) NULL,
  user_id INT UNSIGNED NULL,
  send_at TIMESTAMP NULL,
  sent_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE notifications (
  id CHAR(36) NOT NULL,
  type VARCHAR(255) NOT NULL,
  notifiable_type VARCHAR(255) NOT NULL,
  notifiable_id BIGINT UNSIGNED NOT NULL,
  data TEXT NOT NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE offers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  sent_at DATETIME NULL,
  source_type VARCHAR(255) NULL,
  source_id BIGINT UNSIGNED NULL,
  client_id INT UNSIGNED NOT NULL,
  status VARCHAR(255) NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE password_resets (
  email VARCHAR(255) NOT NULL,
  token VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  amount INT NOT NULL,
  description VARCHAR(255) NOT NULL,
  payment_source VARCHAR(255) NOT NULL,
  payment_date DATE NOT NULL,
  integration_payment_id VARCHAR(255) NULL,
  integration_type VARCHAR(255) NULL,
  invoice_id INT UNSIGNED NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE permissions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  display_name VARCHAR(255) NULL,
  description VARCHAR(255) NULL,
  grouping VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE permission_role (
  permission_id INT UNSIGNED NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (permission_id, role_id)
);

CREATE TABLE products (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  external_id VARCHAR(255) NOT NULL,
  description TEXT NULL,
  number VARCHAR(255) NOT NULL,
  default_type VARCHAR(255) NOT NULL,
  archived TINYINT(1) NOT NULL,
  integration_type VARCHAR(255) NULL,
  integration_id BIGINT UNSIGNED NULL,
  price INT NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE projects (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status_id INT UNSIGNED NOT NULL,
  user_assigned_id INT UNSIGNED NOT NULL,
  user_created_id INT UNSIGNED NOT NULL,
  client_id INT UNSIGNED NOT NULL,
  invoice_id INT UNSIGNED NULL,
  deadline DATE NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE roles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  display_name VARCHAR(255) NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE role_user (
  user_id INT UNSIGNED NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE settings (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  client_number INT NOT NULL,
  invoice_number INT NOT NULL,
  country VARCHAR(255) NULL,
  company VARCHAR(255) NULL,
  currency VARCHAR(3) NOT NULL,
  vat SMALLINT NOT NULL,
  max_users INT NOT NULL,
  language VARCHAR(2) NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  source_type VARCHAR(255) NOT NULL,
  color VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE subscriptions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  stripe_id VARCHAR(255) NOT NULL,
  stripe_status VARCHAR(255) NOT NULL,
  stripe_plan VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  trial_ends_at TIMESTAMP NULL,
  ends_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE tasks (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status_id INT UNSIGNED NOT NULL,
  user_assigned_id INT UNSIGNED NOT NULL,
  user_created_id INT UNSIGNED NOT NULL,
  client_id INT UNSIGNED NOT NULL,
  project_id INT UNSIGNED NULL,
  deadline DATE NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  external_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(60) NOT NULL,
  address VARCHAR(255) NULL,
  primary_number VARCHAR(255) NULL,
  secondary_number VARCHAR(255) NULL,
  image_path VARCHAR(255) NULL,
  remember_token VARCHAR(100) NULL,
  language VARCHAR(2) NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);

ALTER TABLE absences
  ADD CONSTRAINT absences_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE appointments
  ADD CONSTRAINT appointments_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
  ADD CONSTRAINT appointments_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE business_hours
  ADD CONSTRAINT business_hours_settings_id_foreign FOREIGN KEY (settings_id) REFERENCES settings (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE clients
  ADD CONSTRAINT clients_industry_id_foreign FOREIGN KEY (industry_id) REFERENCES industries (id),
  ADD CONSTRAINT clients_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE comments
  ADD CONSTRAINT comments_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE contacts
  ADD CONSTRAINT contacts_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE;

ALTER TABLE department_user
  ADD CONSTRAINT department_user_department_id_foreign FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE CASCADE,
  ADD CONSTRAINT department_user_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE invoices
  ADD CONSTRAINT invoices_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
  ADD CONSTRAINT invoices_offer_id_foreign FOREIGN KEY (offer_id) REFERENCES offers (id) ON DELETE SET NULL;

ALTER TABLE invoice_lines
  ADD CONSTRAINT invoice_lines_invoice_id_foreign FOREIGN KEY (invoice_id) REFERENCES invoices (id) ON DELETE CASCADE,
  ADD CONSTRAINT invoice_lines_offer_id_foreign FOREIGN KEY (offer_id) REFERENCES offers (id) ON DELETE CASCADE;

ALTER TABLE leads
  ADD CONSTRAINT leads_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
  ADD CONSTRAINT leads_status_id_foreign FOREIGN KEY (status_id) REFERENCES statuses (id),
  ADD CONSTRAINT leads_user_assigned_id_foreign FOREIGN KEY (user_assigned_id) REFERENCES users (id),
  ADD CONSTRAINT leads_user_created_id_foreign FOREIGN KEY (user_created_id) REFERENCES users (id);

ALTER TABLE mails
  ADD CONSTRAINT mails_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE offers
  ADD CONSTRAINT offers_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE;

ALTER TABLE payments
  ADD CONSTRAINT payments_invoice_id_foreign FOREIGN KEY (invoice_id) REFERENCES invoices (id) ON DELETE CASCADE;

ALTER TABLE permission_role
  ADD CONSTRAINT permission_role_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT permission_role_role_id_foreign FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE projects
  ADD CONSTRAINT projects_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
  ADD CONSTRAINT projects_invoice_id_foreign FOREIGN KEY (invoice_id) REFERENCES invoices (id),
  ADD CONSTRAINT projects_status_id_foreign FOREIGN KEY (status_id) REFERENCES statuses (id),
  ADD CONSTRAINT projects_user_assigned_id_foreign FOREIGN KEY (user_assigned_id) REFERENCES users (id),
  ADD CONSTRAINT projects_user_created_id_foreign FOREIGN KEY (user_created_id) REFERENCES users (id);

ALTER TABLE role_user
  ADD CONSTRAINT role_user_role_id_foreign FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT role_user_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tasks
  ADD CONSTRAINT tasks_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
  ADD CONSTRAINT tasks_project_id_foreign FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE SET NULL,
  ADD CONSTRAINT tasks_status_id_foreign FOREIGN KEY (status_id) REFERENCES statuses (id),
  ADD CONSTRAINT tasks_user_assigned_id_foreign FOREIGN KEY (user_assigned_id) REFERENCES users (id),
  ADD CONSTRAINT tasks_user_created_id_foreign FOREIGN KEY (user_created_id) REFERENCES users (id);
