package com.niyiment.appointment;

import org.springframework.boot.SpringApplication;

public class TestAppointmentApplication {

	public static void main(String[] args) {
		SpringApplication.from(AppointmentApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
