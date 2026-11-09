package edu.exam;
import org.springframework.context.annotation.Profile;import org.springframework.stereotype.Component;import org.springframework.boot.CommandLineRunner;import org.springframework.transaction.annotation.Transactional;import org.springframework.core.io.ClassPathResource;import java.nio.charset.StandardCharsets;
@Component @Profile("local") public class Demo implements CommandLineRunner {
 final Store db;final org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder;final Portal p;Demo(Portal p,Store db,org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder){this.p=p;this.db=db;this.encoder=encoder;}
 @Transactional public void run(String... args)throws Exception {if(db.rows("SELECT user_id FROM users LIMIT 1").isEmpty()){String sql=new ClassPathResource("demo.sql").getContentAsString(StandardCharsets.UTF_8);for(String statement:sql.replaceAll("(?m)^--.*$","").split(";"))if(!statement.isBlank())db.exec(statement);}
 for(var u:db.rows("SELECT user_id,role FROM users WHERE password_hash='BOOTSTRAP_WITH_BCRYPT'")){String pw=switch(u.get("role").toString()){case "ADMIN"->"Admin@123";case "FACULTY"->"Faculty@123";default->"Student@123";};db.exec("UPDATE users SET password_hash=? WHERE user_id=?",encoder.encode(pw),u.get("user_id"));}}
}
