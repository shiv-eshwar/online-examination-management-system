package edu.exam;
import org.springframework.boot.*;import org.springframework.boot.autoconfigure.*;
@SpringBootApplication public class Application {public static void main(String[] a){java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("UTC"));SpringApplication.run(Application.class,a);}}
