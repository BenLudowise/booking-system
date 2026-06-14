package com.ben.bookingsystem.repository;

import com.ben.bookingsystem.entity.StaffTimeOff;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface StaffTimeOffRepository extends JpaRepository<StaffTimeOff, Long> {
    List<StaffTimeOff> findByStaffIdAndStartDatetimeLessThanAndEndDatetimeGreaterThan(
            Long staffId, LocalDateTime end, LocalDateTime start
    );
}