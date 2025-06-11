-- Create users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add role check constraint
ALTER TABLE users ADD CONSTRAINT chk_users_role
    CHECK (role IN ('PATIENT', 'DOCTOR', 'ADMIN'));

-- Create hospitals table
CREATE TABLE hospitals (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create doctors table
CREATE TABLE doctors (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    hospital_id BIGINT,
    specialty VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add foreign keys for doctors
ALTER TABLE doctors
    ADD CONSTRAINT fk_doctors_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE;

ALTER TABLE doctors
    ADD CONSTRAINT fk_doctors_hospital_id
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id)
    ON DELETE SET NULL;

-- Create appointments table
CREATE TABLE appointments (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add appointment constraints
ALTER TABLE appointments
    ADD CONSTRAINT chk_appointments_status
    CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED'));

ALTER TABLE appointments
    ADD CONSTRAINT unique_appointment
    UNIQUE (doctor_id, appointment_date);

ALTER TABLE appointments
    ADD CONSTRAINT fk_appointments_patient_id
    FOREIGN KEY (patient_id) REFERENCES users(id)
    ON DELETE CASCADE;

ALTER TABLE appointments
    ADD CONSTRAINT fk_appointments_doctor_id
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
    ON DELETE CASCADE;

-- Create payments table
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add payment constraints
ALTER TABLE payments
    ADD CONSTRAINT chk_payments_payment_status
    CHECK (payment_status IN ('PENDING', 'COMPLETED', 'FAILED'));

ALTER TABLE payments
    ADD CONSTRAINT fk_payments_appointment_id
    FOREIGN KEY (appointment_id) REFERENCES appointments(id)
    ON DELETE CASCADE;
