package edu.exam; public class Failure extends RuntimeException {public final int status;public Failure(int s,String m){super(m);status=s;}}
