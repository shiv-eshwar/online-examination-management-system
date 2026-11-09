export function countdown(deadline:string,server:string,elapsed:number){return Math.max(0,Math.floor((Date.parse(deadline)-Date.parse(server)-elapsed)/1000));}
