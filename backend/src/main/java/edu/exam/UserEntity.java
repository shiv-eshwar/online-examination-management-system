package edu.exam;
import jakarta.persistence.*;
@Entity @Table(name="users") public class UserEntity {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) @Column(name="user_id") Long id;
 @Column(name="full_name",nullable=false,length=100) String fullName;
 @Column(nullable=false,length=150) String email;
 @Column(name="password_hash",nullable=false) String passwordHash;
}
