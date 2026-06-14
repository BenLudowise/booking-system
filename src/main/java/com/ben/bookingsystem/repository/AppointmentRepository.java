package com.ben.bookingsystem.repository;

import com.ben.bookingsystem.entity.Appointment;
import com.ben.bookingsystem.entity.AppointmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    List<Appointment> findByStaffIdAndStatus(Long staffId, AppointmentStatus status);

    List<Appointment> findByCustomerId(Long customerId);

    // Used to check for conflicts in the application layer (the DB constraint
    // is the real source of truth, but this lets us return a friendly error)
    List<Appointment> findByStaffIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
            Long staffId, AppointmentStatus status, LocalDateTime end, LocalDateTime start
    );
}