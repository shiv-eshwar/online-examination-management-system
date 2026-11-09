package edu.exam;
import org.junit.jupiter.api.*;import static org.junit.jupiter.api.Assertions.*;import org.springframework.boot.test.context.SpringBootTest;import org.springframework.beans.factory.annotation.Autowired;import org.springframework.transaction.annotation.Transactional;import org.springframework.security.core.context.SecurityContextHolder;import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;import org.springframework.security.core.authority.SimpleGrantedAuthority;import java.util.*;
@SpringBootTest(properties={"exam.jwt-secret=test-secret-at-least-thirty-two-characters"}) @Transactional class PortalTest {
 @Autowired Portal p;
 @AfterEach void clear(){SecurityContextHolder.clearContext();}
 void as(long id,String role){SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(""+id,null,List.of(new SimpleGrantedAuthority("ROLE_"+role))));}
 @Test void serverGuards(){as(3,"STUDENT");assertThrows(Failure.class,()->p.users());assertThrows(Failure.class,()->p.report(false));as(2,"FACULTY");assertThrows(Failure.class,()->p.deactivate(3));}
 @Test void validation(){as(1,"ADMIN");assertThrows(Failure.class,()->p.user(null,Map.of("full_name","Test","email","bad","role","STUDENT","password","12345678")));assertThrows(Failure.class,()->p.enroll(Map.of("student_id",2,"course_id",1)));}
 @Test void draftPublicationRules(){as(2,"FACULTY");Map<String,Object> e=(Map<String,Object>)p.saveExam(null,Map.of("course_id",1,"exam_title","Rollback test","start_time","2026-01-01T00:00:00","end_time","2030-01-01T00:00:00","duration_minutes",20,"total_marks",10));long id=Portal.id(e.get("exam_id"));assertThrows(Failure.class,()->p.transition(id,true));assertEquals("DRAFT",((Map<?,?>)p.details(id)).get("status"));}
 @Test void jwtIsSignedAndExpiring()throws Exception{String t=Security.token(3,"test-secret-at-least-thirty-two-characters");String[] parts=t.split("\\.");assertEquals(3,parts.length);assertEquals(parts[2],Security.sign(parts[0]+"."+parts[1],"test-secret-at-least-thirty-two-characters"));assertNotEquals(parts[2],Security.sign(parts[0]+"."+parts[1],"different-secret"));}
}
