package com.ben.bookingsystem.repository;

import com.ben.bookingsystem.entity.StaffAvailability;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StaffAvailabilityRepository extends JpaRepository<StaffAvailability, Long> {
    List<StaffAvailability> findByStaffIdAndDayOfWeek(Long staffId, Integer dayOfWeek);
    List<StaffAvailability> findByStaffId(Long staffId);
}