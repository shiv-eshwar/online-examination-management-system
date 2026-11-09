package edu.exam;
import jakarta.persistence.*;import org.springframework.stereotype.Repository;import java.util.*;
@Repository public class Store {
 @PersistenceContext EntityManager em;
 public List<Map<String,Object>> rows(String sql,Object... args){Query q=em.createNativeQuery(sql,Tuple.class);bind(q,args);List<Tuple> ts=q.getResultList();return ts.stream().map(t->{Map<String,Object> m=new LinkedHashMap<>();for(TupleElement<?> e:t.getElements())m.put(e.getAlias(),t.get(e));return m;}).toList();}
 public Map<String,Object> one(String sql,Object... args){var r=rows(sql,args);if(r.isEmpty())throw new Failure(404,"Record not found");return r.getFirst();}
 public int exec(String sql,Object... args){Query q=em.createNativeQuery(sql);bind(q,args);return q.executeUpdate();}
 public long insert(String sql,Object... args){exec(sql,args);return ((Number)em.createNativeQuery("SELECT LAST_INSERT_ID()").getSingleResult()).longValue();}
 void bind(Query q,Object[] args){for(int i=0;i<args.length;i++)q.setParameter(i+1,args[i]);}
}
