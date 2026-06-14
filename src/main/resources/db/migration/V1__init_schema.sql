-- Users (admins, staff, customers)
CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,
                       full_name VARCHAR(255) NOT NULL,
                       role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER')),
                       created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Services offered (e.g., "Haircut - 30 min", "Oil Change - 45 min")
CREATE TABLE services (
                          id BIGSERIAL PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
                          price_cents INT NOT NULL,
                          active BOOLEAN NOT NULL DEFAULT true
);

-- Staff working hours (recurring weekly availability)
CREATE TABLE staff_availability (
                                    id BIGSERIAL PRIMARY KEY,
                                    staff_id BIGINT NOT NULL REFERENCES users(id),
                                    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday
                                    start_time TIME NOT NULL,
                                    end_time TIME NOT NULL,
                                    CHECK (end_time > start_time)
);

-- Time off / exceptions to regular availability
CREATE TABLE staff_time_off (
                                id BIGSERIAL PRIMARY KEY,
                                staff_id BIGINT NOT NULL REFERENCES users(id),
                                start_datetime TIMESTAMP NOT NULL,
                                end_datetime TIMESTAMP NOT NULL,
                                reason VARCHAR(255),
                                CHECK (end_datetime > start_datetime)
);

-- Appointments (the core booking table)
CREATE TABLE appointments (
                              id BIGSERIAL PRIMARY KEY,
                              customer_id BIGINT NOT NULL REFERENCES users(id),
                              staff_id BIGINT NOT NULL REFERENCES users(id),
                              service_id BIGINT NOT NULL REFERENCES services(id),
                              start_time TIMESTAMP NOT NULL,
                              end_time TIMESTAMP NOT NULL,
                              status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED'
                                  CHECK (status IN ('CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW')),
                              created_at TIMESTAMP NOT NULL DEFAULT now(),
                              CHECK (end_time > start_time)
);

-- Prevent double-booking at the database level
CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE appointments
    ADD CONSTRAINT no_overlapping_appointments
    EXCLUDE USING gist (
    staff_id WITH =,
    tsrange(start_time, end_time) WITH &&
) WHERE (status = 'CONFIRMED');

-- Audit log
CREATE TABLE audit_log (
                           id BIGSERIAL PRIMARY KEY,
                           user_id BIGINT REFERENCES users(id),
                           action VARCHAR(100) NOT NULL,
                           entity_type VARCHAR(50) NOT NULL,
                           entity_id BIGINT NOT NULL,
                           details JSONB,
                           created_at TIMESTAMP NOT NULL DEFAULT now()
);