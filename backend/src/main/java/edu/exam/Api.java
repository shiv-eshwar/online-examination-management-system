package edu.exam;
import org.springframework.web.bind.annotation.*;import org.springframework.beans.factory.annotation.Value;import jakarta.validation.Valid;import jakarta.validation.constraints.*;import java.util.*;
@RestController @RequestMapping("/api/v1") public class Api {
 final Store db;final org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder;final Portal p;@Value("${exam.jwt-secret}")String secret;Api(Portal p,Store db,org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder){this.p=p;this.db=db;this.encoder=encoder;}
 record Login(@Email @NotBlank String email,@NotBlank String password){}
 @GetMapping("/health")Object health(){return Map.of("status","UP");}
 @PostMapping("/auth/login")Object login(@Valid @RequestBody Login l)throws Exception {Map<String,Object> u;try{u=db.one("SELECT * FROM users WHERE email=? AND is_active=1",l.email().toLowerCase());}catch(Failure e){throw new Failure(401,"Invalid credentials");}if(!encoder.matches(l.password(),u.get("password_hash").toString()))throw new Failure(401,"Invalid credentials");return Map.of("accessToken",Security.token(Portal.id(u.get("user_id")),secret),"user",p.safe(Portal.id(u.get("user_id"))));}
 @GetMapping("/auth/me")Object me(){return p.safe(p.me());}
 @PostMapping("/auth/logout")Object logout(){return Map.of("message","Signed out; discard access token");}
 @GetMapping("/admin/users")Object users(@RequestParam(defaultValue="") String search,@RequestParam(defaultValue="0") int page,@RequestParam(defaultValue="100") int size){return p.users(search,page,size);}
 @GetMapping("/admin/users/{id}")Object user(@PathVariable long id){p.require("ADMIN");return p.safe(id);}
 @PostMapping("/admin/users")Object createUser(@RequestBody Map<String,Object> m){return p.user(null,m);}
 @PutMapping("/admin/users/{id}")Object updateUser(@PathVariable long id,@RequestBody Map<String,Object> m){return p.user(id,m);}
 @PatchMapping("/admin/users/{id}/deactivate")Object deactivate(@PathVariable long id){return p.deactivate(id);}
 @GetMapping({"/admin/courses","/faculty/courses","/student/courses"})Object courses(){return p.courses();}
 @PostMapping("/admin/courses")Object course(@RequestBody Map<String,Object> m){return p.saveCourse(null,m);}
 @PutMapping("/admin/courses/{id}")Object course(@PathVariable long id,@RequestBody Map<String,Object> m){return p.saveCourse(id,m);}
 @GetMapping("/admin/enrollments")Object enrollments(){p.require("ADMIN");return p.enrollments(null);}
 @GetMapping("/faculty/courses/{id}/enrollments")Object enrollments(@PathVariable long id){p.require("FACULTY");return p.enrollments(id);}
 @PostMapping("/admin/enrollments")Object enroll(@RequestBody Map<String,Object> m){return p.enroll(m);}
 @DeleteMapping("/admin/enrollments/{s}/{c}")Object remove(@PathVariable long s,@PathVariable long c){p.remove(s,c);return Map.of("message","Enrollment removed");}
 @GetMapping({"/faculty/exams","/student/exams","/admin/exams"})Object exams(){return p.exams();}
 @PostMapping("/faculty/exams")Object exam(@RequestBody Map<String,Object> m){return p.saveExam(null,m);}
 @PutMapping("/faculty/exams/{id}")Object exam(@PathVariable long id,@RequestBody Map<String,Object> m){return p.saveExam(id,m);}
 @GetMapping({"/faculty/exams/{id}","/admin/exams/{id}"})Object exam(@PathVariable long id){if(p.role().equals("STUDENT"))throw new Failure(403,"Faculty or admin required");return p.details(id);}
 @PostMapping("/faculty/exams/{id}/questions")Object question(@PathVariable long id,@RequestBody Map<String,Object> m){return p.question(id,null,m);}
 @PutMapping("/faculty/exams/{id}/questions/{q}")Object question(@PathVariable long id,@PathVariable long q,@RequestBody Map<String,Object> m){return p.question(id,q,m);}
 @DeleteMapping("/faculty/exams/{id}/questions/{q}")Object delete(@PathVariable long id,@PathVariable long q){p.deleteQuestion(id,q);return Map.of("message","Question deleted");}
 @PostMapping("/faculty/exams/{id}/publish")Object publish(@PathVariable long id){return p.transition(id,true);}
 @PostMapping("/faculty/exams/{id}/close")Object close(@PathVariable long id){return p.transition(id,false);}
 @PostMapping("/student/exams/{id}/attempts")Object start(@PathVariable long id){return p.start(id);}
 @GetMapping("/student/attempts/{id}")Object attempt(@PathVariable long id){return p.attempt(id,false);}
 @PutMapping("/student/attempts/{id}/responses")Object save(@PathVariable long id,@RequestBody Map<String,Object> m){return p.respond(id,m,false);}
 @PostMapping("/student/attempts/{id}/submit")Object submit(@PathVariable long id,@RequestBody Map<String,Object> m){return p.respond(id,m,true);}
 @GetMapping("/student/results")Object results(){p.require("STUDENT");return p.results(null);}
 @GetMapping("/student/results/{id}")Object result(@PathVariable long id){return p.attempt(id,true);}
 @GetMapping("/faculty/exams/{id}/results")Object results(@PathVariable long id){p.require("FACULTY");return p.results(id);}
 @GetMapping({"/admin/reports/overview","/admin/reports/exam-performance","/admin/reports/pass-rates","/faculty/reports/exam-performance"})Object report(){return p.report(false);}
 @GetMapping({"/admin/reports/course-performance","/faculty/reports/course-performance"})Object courseReport(){return p.report(true);}
 @GetMapping({"/admin/results","/faculty/results"})Object history(){return p.results(null);}
}
