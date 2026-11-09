"""Runs against the actual running Spring Boot/MySQL application. Creates unique retained demo records."""
import json,urllib.request,urllib.error,time,datetime,pathlib,os,shutil
base=os.environ.get('API_BASE_URL','http://localhost:8080/api/v1'); checks=[]
def call(path,method='GET',body=None,token='',expect=200):
 req=urllib.request.Request(base+path,data=json.dumps(body).encode() if body is not None else None,method=method,headers={'Content-Type':'application/json','Authorization':'Bearer '+token})
 try:
  with urllib.request.urlopen(req) as r: status=r.status;data=json.load(r)
 except urllib.error.HTTPError as e:status=e.code;data=json.load(e)
 assert status==expect,(path,status,data,expect)
 checks.append(f'{method} {path}: {status}')
 return data
def login(email,pw):return call('/auth/login','POST',dict(email=email,password=pw))['accessToken']
a=login('admin@demo.edu','Admin@123');f=login('maya.faculty@demo.edu','Faculty@123');s=login('roshan.student@demo.edu','Student@123')
call('/auth/login','POST',dict(email='admin@demo.edu',password='wrong'),expect=401)
call('/admin/users',token=s,expect=403)
nonce=str(time.time_ns())
def user(role):return call('/admin/users','POST',dict(full_name='Acceptance '+role,email=role.lower()+str(time.time_ns())+'@test.edu',password='Acceptance@123',role=role),a)
u=user('STUDENT');other=user('FACULTY');outsider=user('STUDENT');o=login(outsider['email'],'Acceptance@123');fo=login(other['email'],'Acceptance@123')
call('/admin/users','POST',dict(full_name='Duplicate',email=u['email'],password='Acceptance@123',role='STUDENT'),a,409)
call('/admin/users','POST',dict(full_name='Invalid',email='bad',password='short',role='STUDENT'),a,400)
c=call('/admin/courses','POST',dict(course_code='T'+nonce[-12:],course_name='Acceptance course',faculty_id=2),a)
call('/admin/courses','POST',dict(course_code=c['course_code'],course_name='Duplicate',faculty_id=2),a,409)
n=dict(student_id=u['user_id'],course_id=c['course_id']);call('/admin/enrollments','POST',n,a);call('/admin/enrollments','POST',n,a,409)
call('/admin/enrollments','POST',dict(student_id=2,course_id=c['course_id']),a,400)
t=login(u['email'],'Acceptance@123')
ebody=dict(course_id=c['course_id'],exam_title='Acceptance examination',start_time='2026-01-01T00:00:00',end_time='2030-01-01T00:00:00',duration_minutes=30,total_marks=20)
call('/faculty/exams','POST',ebody,fo,403)
e=call('/faculty/exams','POST',ebody,f);eid=e['exam_id'];ep='/faculty/exams/'+str(eid)
call('/student/exams/'+str(eid)+'/attempts','POST',{},t,409)
call(ep+'/publish','POST',{},f,400)
for i in range(2):call(ep+'/questions','POST',dict(question_text='Question '+str(i),marks=10,options=[dict(option_text='Option '+str(j),is_correct=j==0) for j in range(4)]),f)
detail=call(ep,token=f);qs=detail['questions']
call(ep,token=fo,expect=403)
call(ep+'/publish','POST',{},f)
call(ep,'PUT',ebody,f,409)
call('/student/exams/'+str(eid)+'/attempts','POST',{},o,404)
at=call('/student/exams/'+str(eid)+'/attempts','POST',{},t);aid=at['attempt_id'];ap='/student/attempts/'+str(aid)
assert all('is_correct' not in op for q in at['questions'] for op in q['options'])
call('/student/exams/'+str(eid)+'/attempts','POST',{},t,409)
call(ap,token=o,expect=404)
valid=dict(question_id=qs[0]['question_id'],selected_option_id=qs[0]['options'][0]['option_id'])
bad=dict(question_id=qs[1]['question_id'],selected_option_id=qs[0]['options'][0]['option_id'])
call(ap+'/submit','POST',dict(responses=[valid,bad]),t,404)
unchanged=call(ap,token=t);assert unchanged['status']=='IN_PROGRESS' and unchanged['responses']==[],unchanged
# Cross-exam question rejected after an earlier valid write; transaction must roll back.
call(ap+'/submit','POST',dict(responses=[valid,dict(question_id=1,selected_option_id=1)]),t,404)
assert call(ap,token=t)['responses']==[]
rs=[dict(question_id=q['question_id'],selected_option_id=q['options'][0]['option_id']) for q in qs]
call(ap+'/responses','PUT',dict(responses=rs),t)
result=call(ap+'/submit','POST',dict(responses=rs),t);assert float(result['score'])==20 and result['status']=='SUBMITTED'
call(ap+'/submit','POST',dict(responses=rs),t,409)
call(ap+'/responses','PUT',dict(responses=rs),t,409)
call('/student/results/'+str(aid),token=t)
call(ep+'/results',token=f);call(ep+'/results',token=fo,expect=403)
rep=call('/admin/reports/exam-performance',token=a);row=next(x for x in rep if x['exam_id']==eid);assert row['submitted_attempts']==1 and float(row['average_score'])==20 and float(row['pass_percentage'])==100
call('/faculty/reports/course-performance',token=f)
call('/admin/enrollments/'+str(u['user_id'])+'/'+str(c['course_id']),'DELETE',token=a,expect=409)
# Expired server deadline.
v=user('STUDENT');vt=login(v['email'],'Acceptance@123');call('/admin/enrollments','POST',dict(student_id=v['user_id'],course_id=c['course_id']),a)
late=call('/student/exams/'+str(eid)+'/attempts','POST',{},vt)
import subprocess
mysql_cli=os.environ.get('MYSQL_CLI') or shutil.which('mysql')
if not mysql_cli and pathlib.Path('/opt/homebrew/opt/mysql@8.4/bin/mysql').exists():
 mysql_cli='/opt/homebrew/opt/mysql@8.4/bin/mysql'
if not mysql_cli: raise RuntimeError('Install the MySQL client or set MYSQL_CLI for the deadline test')
subprocess.run([mysql_cli,'--host='+os.environ.get('MYSQL_HOST','127.0.0.1'),'--port='+os.environ.get('MYSQL_PORT','3306'),'--user='+os.environ.get('DB_USERNAME','exam_app'),os.environ.get('MYSQL_DATABASE','online_exam_system'),'-e',f"UPDATE attempts SET started_at='2026-01-01' WHERE attempt_id={late['attempt_id']}"],env={**os.environ,'MYSQL_PWD':os.environ.get('DB_PASSWORD','')},check=True)
call('/student/attempts/'+str(late['attempt_id'])+'/submit','POST',dict(responses=[]),vt,409)
call(ep+'/close','POST',{},f);call(ep+'/close','POST',{},f,409)
pathlib.Path('/tmp/exam-persistence.json').write_text(json.dumps(dict(user=u,exam=eid,attempt=aid)))
pathlib.Path(__file__).resolve().parents[1].joinpath('docs/acceptance-results.txt').write_text('\n'.join(checks)+'\nAtomic rollback, hidden correctness, score and SQL aggregates assertions passed.\n')
print(f'PASS: {len(checks)} HTTP checks plus rollback, scoring, secrecy and aggregate assertions')
