import{describe,it,expect}from'vitest';import{countdown}from'./timer';
describe('server deadline countdown',()=>{it('uses server time and elapsed time rather than browser wall clock',()=>expect(countdown('2026-11-08T10:30:00Z','2026-11-08T10:00:00Z',120000)).toBe(1680));it('never displays negative time',()=>expect(countdown('2026-11-08T10:00:00Z','2026-11-08T10:30:00Z',0)).toBe(0));});
