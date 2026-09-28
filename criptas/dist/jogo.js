(()=>{var Kf=0,Iu=1,jf=2;var Cs=1,Qf=2,Cr=3,rs=0,di=1,Re=2,Yi=0,as=1,Xe=2,Lu=3,Du=4,t0=5;var Ps=100,e0=101,i0=102,n0=103,s0=104,r0=200,a0=201,o0=202,l0=203,Nu=204,Uu=205,c0=206,h0=207,u0=208,d0=209,f0=210,p0=211,m0=212,g0=213,x0=214,gl=0,xl=1,vl=2,or=3,yl=4,_l=5,lr=6,bl=7,Kl=0,v0=1,y0=2,ln=0,ja=1,Qa=2,to=3,Is=4,eo=5,io=6,no=7;var Fu=300,os=301,Ls=302,jl=303,Ql=304,so=306,Nn=1e3,gn=1001,Ml=1002,oi=1003,_0=1004;var ro=1005;var Ye=1006,tc=1007;var Oi=1008;var Ci=1009,zu=1010,Ou=1011,Pr=1012,ec=1013,cn=1014,Zi=1015,qe=1016,ic=1017,nc=1018,Ir=1020,ku=35902,Bu=35899,Hu=1021,Gu=1022,Ji=1023,vn=1026,ls=1027,sc=1028,rc=1029,cs=1030,ac=1031;var oc=1033,ao=33776,oo=33777,lo=33778,co=33779,lc=35840,cc=35841,hc=35842,uc=35843,dc=36196,fc=37492,pc=37496,mc=37488,gc=37489,ho=37490,xc=37491,vc=37808,yc=37809,_c=37810,bc=37811,Mc=37812,Sc=37813,wc=37814,Tc=37815,Ec=37816,Ac=37817,Rc=37818,Cc=37819,Pc=37820,Ic=37821,Lc=36492,Dc=36494,Nc=36495,Uc=36283,Fc=36284,uo=36285,zc=36286;var va=2300,Sl=2301,pl=2302,xu=2303,vu=2400,yu=2401,_u=2402;var b0=3200;var fo=0,M0=1,Ki="",Oe="srgb",ya="srgb-linear",_a="linear",_e="srgb";var ml=7680;var S0=519,w0=512,T0=513,E0=514,Oc=515,A0=516,R0=517,kc=518,C0=519,Vu=35044,po=35048;var Wu="300 es",an=2e3,cr=2001;function vm(n){for(let t=n.length-1;t>=0;--t)if(n[t]>=65535)return!0;return!1}function ym(n){return ArrayBuffer.isView(n)&&!(n instanceof DataView)}function ba(n){return document.createElementNS("http://www.w3.org/1999/xhtml",n)}function P0(){let n=ba("canvas");return n.style.display="block",n}var uf={},hr=null;function Ma(...n){let t="THREE."+n.shift();hr?hr("log",t,...n):console.log(t,...n)}function I0(n){let t=n[0];if(typeof t=="string"&&t.startsWith("TSL:")){let e=n[1];e&&e.isStackTrace?n[0]+=" "+e.getLocation():n[1]='Stack trace not available. Enable "THREE.Node.captureStackTrace" to capture stack traces.'}return n}function te(...n){n=I0(n);let t="THREE."+n.shift();if(hr)hr("warn",t,...n);else{let e=n[0];e&&e.isStackTrace?console.warn(e.getError(t)):console.warn(t,...n)}}function ee(...n){n=I0(n);let t="THREE."+n.shift();if(hr)hr("error",t,...n);else{let e=n[0];e&&e.isStackTrace?console.error(e.getError(t)):console.error(t,...n)}}function ws(...n){let t=n.join(" ");t in uf||(uf[t]=!0,te(...n))}function L0(n,t,e){return new Promise(function(i,s){function r(){switch(n.clientWaitSync(t,n.SYNC_FLUSH_COMMANDS_BIT,0)){case n.WAIT_FAILED:s();break;case n.TIMEOUT_EXPIRED:setTimeout(r,e);break;default:i()}}setTimeout(r,e)})}var D0={[gl]:xl,[vl]:lr,[yl]:bl,[or]:_l,[xl]:gl,[lr]:vl,[bl]:yl,[_l]:or},yn=class{addEventListener(t,e){this._listeners===void 0&&(this._listeners={});let i=this._listeners;i[t]===void 0&&(i[t]=[]),i[t].indexOf(e)===-1&&i[t].push(e)}hasEventListener(t,e){let i=this._listeners;return i===void 0?!1:i[t]!==void 0&&i[t].indexOf(e)!==-1}removeEventListener(t,e){let i=this._listeners;if(i===void 0)return;let s=i[t];if(s!==void 0){let r=s.indexOf(e);r!==-1&&s.splice(r,1)}}dispatchEvent(t){let e=this._listeners;if(e===void 0)return;let i=e[t.type];if(i!==void 0){t.target=this;let s=i.slice(0);for(let r=0,a=s.length;r<a;r++)s[r].call(this,t);t.target=null}}},mi=["00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f","10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f","20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f","30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d","3e","3f","40","41","42","43","44","45","46","47","48","49","4a","4b","4c","4d","4e","4f","50","51","52","53","54","55","56","57","58","59","5a","5b","5c","5d","5e","5f","60","61","62","63","64","65","66","67","68","69","6a","6b","6c","6d","6e","6f","70","71","72","73","74","75","76","77","78","79","7a","7b","7c","7d","7e","7f","80","81","82","83","84","85","86","87","88","89","8a","8b","8c","8d","8e","8f","90","91","92","93","94","95","96","97","98","99","9a","9b","9c","9d","9e","9f","a0","a1","a2","a3","a4","a5","a6","a7","a8","a9","aa","ab","ac","ad","ae","af","b0","b1","b2","b3","b4","b5","b6","b7","b8","b9","ba","bb","bc","bd","be","bf","c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf","d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df","e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff"],df=1234567,pa=Math.PI/180,ur=180/Math.PI;function xn(){let n=Math.random()*4294967295|0,t=Math.random()*4294967295|0,e=Math.random()*4294967295|0,i=Math.random()*4294967295|0;return(mi[n&255]+mi[n>>8&255]+mi[n>>16&255]+mi[n>>24&255]+"-"+mi[t&255]+mi[t>>8&255]+"-"+mi[t>>16&15|64]+mi[t>>24&255]+"-"+mi[e&63|128]+mi[e>>8&255]+"-"+mi[e>>16&255]+mi[e>>24&255]+mi[i&255]+mi[i>>8&255]+mi[i>>16&255]+mi[i>>24&255]).toLowerCase()}function oe(n,t,e){return Math.max(t,Math.min(e,n))}function Xu(n,t){return(n%t+t)%t}function _m(n,t,e,i,s){return i+(n-t)*(s-i)/(e-t)}function bm(n,t,e){return n!==t?(e-n)/(t-n):0}function ma(n,t,e){return(1-e)*n+e*t}function Mm(n,t,e,i){return ma(n,t,1-Math.exp(-e*i))}function Sm(n,t=1){return t-Math.abs(Xu(n,t*2)-t)}function wm(n,t,e){return n<=t?0:n>=e?1:(n=(n-t)/(e-t),n*n*(3-2*n))}function Tm(n,t,e){return n<=t?0:n>=e?1:(n=(n-t)/(e-t),n*n*n*(n*(n*6-15)+10))}function Em(n,t){return n+Math.floor(Math.random()*(t-n+1))}function Am(n,t){return n+Math.random()*(t-n)}function Rm(n){return n*(.5-Math.random())}function Cm(n){n!==void 0&&(df=n);let t=df+=1831565813;return t=Math.imul(t^t>>>15,t|1),t^=t+Math.imul(t^t>>>7,t|61),((t^t>>>14)>>>0)/4294967296}function Pm(n){return n*pa}function Im(n){return n*ur}function Lm(n){return n>0&&Number.isInteger(n)&&2**Math.round(Math.log2(n))===n}function Dm(n){return Math.pow(2,Math.ceil(Math.log(n)/Math.LN2))}function Nm(n){return Math.pow(2,Math.floor(Math.log(n)/Math.LN2))}function Um(n,t,e,i,s){let r=Math.cos,a=Math.sin,o=r(e/2),c=a(e/2),l=r((t+i)/2),h=a((t+i)/2),u=r((t-i)/2),d=a((t-i)/2),f=r((i-t)/2),p=a((i-t)/2);switch(s){case"XYX":n.set(o*h,c*u,c*d,o*l);break;case"YZY":n.set(c*d,o*h,c*u,o*l);break;case"ZXZ":n.set(c*u,c*d,o*h,o*l);break;case"XZX":n.set(o*h,c*p,c*f,o*l);break;case"YXY":n.set(c*f,o*h,c*p,o*l);break;case"ZYZ":n.set(c*p,c*f,o*h,o*l);break;default:te("MathUtils: .setQuaternionFromProperEuler() encountered an unknown order: "+s)}}function rn(n,t){switch(t.constructor){case Float32Array:return n;case Uint32Array:return n/4294967295;case Uint16Array:return n/65535;case Uint8Array:case Uint8ClampedArray:return n/255;case Int32Array:return Math.max(n/2147483647,-1);case Int16Array:return Math.max(n/32767,-1);case Int8Array:return Math.max(n/127,-1);default:throw new Error("THREE.MathUtils: Invalid component type.")}}function Te(n,t){switch(t.constructor){case Float32Array:return n;case Uint32Array:return Math.round(n*4294967295);case Uint16Array:return Math.round(n*65535);case Uint8Array:case Uint8ClampedArray:return Math.round(n*255);case Int32Array:return Math.round(n*2147483647);case Int16Array:return Math.round(n*32767);case Int8Array:return Math.round(n*127);default:throw new Error("THREE.MathUtils: Invalid component type.")}}var qu={DEG2RAD:pa,RAD2DEG:ur,generateUUID:xn,clamp:oe,euclideanModulo:Xu,mapLinear:_m,inverseLerp:bm,lerp:ma,damp:Mm,pingpong:Sm,smoothstep:wm,smootherstep:Tm,randInt:Em,randFloat:Am,randFloatSpread:Rm,seededRandom:Cm,degToRad:Pm,radToDeg:Im,isPowerOfTwo:Lm,ceilPowerOfTwo:Dm,floorPowerOfTwo:Nm,setQuaternionFromProperEuler:Um,normalize:Te,denormalize:rn},ju=class ju{constructor(t=0,e=0){this.x=t,this.y=e}get width(){return this.x}set width(t){this.x=t}get height(){return this.y}set height(t){this.y=t}set(t,e){return this.x=t,this.y=e,this}setScalar(t){return this.x=t,this.y=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;default:throw new Error("THREE.Vector2: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;default:throw new Error("THREE.Vector2: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y)}copy(t){return this.x=t.x,this.y=t.y,this}add(t){return this.x+=t.x,this.y+=t.y,this}addScalar(t){return this.x+=t,this.y+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this}subScalar(t){return this.x-=t,this.y-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this}multiply(t){return this.x*=t.x,this.y*=t.y,this}multiplyScalar(t){return this.x*=t,this.y*=t,this}divide(t){return this.x/=t.x,this.y/=t.y,this}divideScalar(t){return this.multiplyScalar(1/t)}applyMatrix3(t){let e=this.x,i=this.y,s=t.elements;return this.x=s[0]*e+s[3]*i+s[6],this.y=s[1]*e+s[4]*i+s[7],this}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this}clamp(t,e){return this.x=oe(this.x,t.x,e.x),this.y=oe(this.y,t.y,e.y),this}clampScalar(t,e){return this.x=oe(this.x,t,e),this.y=oe(this.y,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(oe(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this}negate(){return this.x=-this.x,this.y=-this.y,this}dot(t){return this.x*t.x+this.y*t.y}cross(t){return this.x*t.y-this.y*t.x}lengthSq(){return this.x*this.x+this.y*this.y}length(){return Math.sqrt(this.x*this.x+this.y*this.y)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)}normalize(){return this.divideScalar(this.length()||1)}angle(){return Math.atan2(-this.y,-this.x)+Math.PI}angleTo(t){let e=Math.sqrt(this.lengthSq()*t.lengthSq());if(e===0)return Math.PI/2;let i=this.dot(t)/e;return Math.acos(oe(i,-1,1))}distanceTo(t){return Math.sqrt(this.distanceToSquared(t))}distanceToSquared(t){let e=this.x-t.x,i=this.y-t.y;return e*e+i*i}manhattanDistanceTo(t){return Math.abs(this.x-t.x)+Math.abs(this.y-t.y)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this}equals(t){return t.x===this.x&&t.y===this.y}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this}rotateAround(t,e){let i=Math.cos(e),s=Math.sin(e),r=this.x-t.x,a=this.y-t.y;return this.x=r*i-a*s+t.x,this.y=r*s+a*i+t.y,this}random(){return this.x=Math.random(),this.y=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y}};ju.prototype.isVector2=!0;var ot=ju,Ei=class{constructor(t=0,e=0,i=0,s=1){this.isQuaternion=!0,this._x=t,this._y=e,this._z=i,this._w=s}static slerpFlat(t,e,i,s,r,a,o){let c=i[s+0],l=i[s+1],h=i[s+2],u=i[s+3],d=r[a+0],f=r[a+1],p=r[a+2],x=r[a+3];if(u!==x||c!==d||l!==f||h!==p){let m=c*d+l*f+h*p+u*x;m<0&&(d=-d,f=-f,p=-p,x=-x,m=-m);let g=1-o;if(m<.9995){let _=Math.acos(m),T=Math.sin(_);g=Math.sin(g*_)/T,o=Math.sin(o*_)/T,c=c*g+d*o,l=l*g+f*o,h=h*g+p*o,u=u*g+x*o}else{c=c*g+d*o,l=l*g+f*o,h=h*g+p*o,u=u*g+x*o;let _=1/Math.sqrt(c*c+l*l+h*h+u*u);c*=_,l*=_,h*=_,u*=_}}t[e]=c,t[e+1]=l,t[e+2]=h,t[e+3]=u}static multiplyQuaternionsFlat(t,e,i,s,r,a){let o=i[s],c=i[s+1],l=i[s+2],h=i[s+3],u=r[a],d=r[a+1],f=r[a+2],p=r[a+3];return t[e]=o*p+h*u+c*f-l*d,t[e+1]=c*p+h*d+l*u-o*f,t[e+2]=l*p+h*f+o*d-c*u,t[e+3]=h*p-o*u-c*d-l*f,t}get x(){return this._x}set x(t){this._x=t,this._onChangeCallback()}get y(){return this._y}set y(t){this._y=t,this._onChangeCallback()}get z(){return this._z}set z(t){this._z=t,this._onChangeCallback()}get w(){return this._w}set w(t){this._w=t,this._onChangeCallback()}set(t,e,i,s){return this._x=t,this._y=e,this._z=i,this._w=s,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._w)}copy(t){return this._x=t.x,this._y=t.y,this._z=t.z,this._w=t.w,this._onChangeCallback(),this}setFromEuler(t,e=!0){let i=t._x,s=t._y,r=t._z,a=t._order,o=Math.cos,c=Math.sin,l=o(i/2),h=o(s/2),u=o(r/2),d=c(i/2),f=c(s/2),p=c(r/2);switch(a){case"XYZ":this._x=d*h*u+l*f*p,this._y=l*f*u-d*h*p,this._z=l*h*p+d*f*u,this._w=l*h*u-d*f*p;break;case"YXZ":this._x=d*h*u+l*f*p,this._y=l*f*u-d*h*p,this._z=l*h*p-d*f*u,this._w=l*h*u+d*f*p;break;case"ZXY":this._x=d*h*u-l*f*p,this._y=l*f*u+d*h*p,this._z=l*h*p+d*f*u,this._w=l*h*u-d*f*p;break;case"ZYX":this._x=d*h*u-l*f*p,this._y=l*f*u+d*h*p,this._z=l*h*p-d*f*u,this._w=l*h*u+d*f*p;break;case"YZX":this._x=d*h*u+l*f*p,this._y=l*f*u+d*h*p,this._z=l*h*p-d*f*u,this._w=l*h*u-d*f*p;break;case"XZY":this._x=d*h*u-l*f*p,this._y=l*f*u-d*h*p,this._z=l*h*p+d*f*u,this._w=l*h*u+d*f*p;break;default:te("Quaternion: .setFromEuler() encountered an unknown order: "+a)}return e===!0&&this._onChangeCallback(),this}setFromAxisAngle(t,e){let i=e/2,s=Math.sin(i);return this._x=t.x*s,this._y=t.y*s,this._z=t.z*s,this._w=Math.cos(i),this._onChangeCallback(),this}setFromRotationMatrix(t){let e=t.elements,i=e[0],s=e[4],r=e[8],a=e[1],o=e[5],c=e[9],l=e[2],h=e[6],u=e[10],d=i+o+u;if(d>0){let f=.5/Math.sqrt(d+1);this._w=.25/f,this._x=(h-c)*f,this._y=(r-l)*f,this._z=(a-s)*f}else if(i>o&&i>u){let f=2*Math.sqrt(1+i-o-u);this._w=(h-c)/f,this._x=.25*f,this._y=(s+a)/f,this._z=(r+l)/f}else if(o>u){let f=2*Math.sqrt(1+o-i-u);this._w=(r-l)/f,this._x=(s+a)/f,this._y=.25*f,this._z=(c+h)/f}else{let f=2*Math.sqrt(1+u-i-o);this._w=(a-s)/f,this._x=(r+l)/f,this._y=(c+h)/f,this._z=.25*f}return this._onChangeCallback(),this}setFromUnitVectors(t,e){let i=t.dot(e)+1;return i<1e-8?(i=0,Math.abs(t.x)>Math.abs(t.z)?(this._x=-t.y,this._y=t.x,this._z=0,this._w=i):(this._x=0,this._y=-t.z,this._z=t.y,this._w=i)):(this._x=t.y*e.z-t.z*e.y,this._y=t.z*e.x-t.x*e.z,this._z=t.x*e.y-t.y*e.x,this._w=i),this.normalize()}angleTo(t){return 2*Math.acos(Math.abs(oe(this.dot(t),-1,1)))}rotateTowards(t,e){let i=this.angleTo(t);if(i===0)return this;let s=Math.min(1,e/i);return this.slerp(t,s),this}identity(){return this.set(0,0,0,1)}invert(){return this.conjugate()}conjugate(){return this._x*=-1,this._y*=-1,this._z*=-1,this._onChangeCallback(),this}dot(t){return this._x*t._x+this._y*t._y+this._z*t._z+this._w*t._w}lengthSq(){return this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w}length(){return Math.sqrt(this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w)}normalize(){let t=this.length();return t===0?(this._x=0,this._y=0,this._z=0,this._w=1):(t=1/t,this._x=this._x*t,this._y=this._y*t,this._z=this._z*t,this._w=this._w*t),this._onChangeCallback(),this}multiply(t){return this.multiplyQuaternions(this,t)}premultiply(t){return this.multiplyQuaternions(t,this)}multiplyQuaternions(t,e){let i=t._x,s=t._y,r=t._z,a=t._w,o=e._x,c=e._y,l=e._z,h=e._w;return this._x=i*h+a*o+s*l-r*c,this._y=s*h+a*c+r*o-i*l,this._z=r*h+a*l+i*c-s*o,this._w=a*h-i*o-s*c-r*l,this._onChangeCallback(),this}slerp(t,e){let i=t._x,s=t._y,r=t._z,a=t._w,o=this.dot(t);o<0&&(i=-i,s=-s,r=-r,a=-a,o=-o);let c=1-e;if(o<.9995){let l=Math.acos(o),h=Math.sin(l);c=Math.sin(c*l)/h,e=Math.sin(e*l)/h,this._x=this._x*c+i*e,this._y=this._y*c+s*e,this._z=this._z*c+r*e,this._w=this._w*c+a*e,this._onChangeCallback()}else this._x=this._x*c+i*e,this._y=this._y*c+s*e,this._z=this._z*c+r*e,this._w=this._w*c+a*e,this.normalize();return this}slerpQuaternions(t,e,i){return this.copy(t).slerp(e,i)}random(){let t=2*Math.PI*Math.random(),e=2*Math.PI*Math.random(),i=Math.random(),s=Math.sqrt(1-i),r=Math.sqrt(i);return this.set(s*Math.sin(t),s*Math.cos(t),r*Math.sin(e),r*Math.cos(e))}equals(t){return t._x===this._x&&t._y===this._y&&t._z===this._z&&t._w===this._w}fromArray(t,e=0){return this._x=t[e],this._y=t[e+1],this._z=t[e+2],this._w=t[e+3],this._onChangeCallback(),this}toArray(t=[],e=0){return t[e]=this._x,t[e+1]=this._y,t[e+2]=this._z,t[e+3]=this._w,t}fromBufferAttribute(t,e){return this._x=t.getX(e),this._y=t.getY(e),this._z=t.getZ(e),this._w=t.getW(e),this._onChangeCallback(),this}toJSON(){return this.toArray()}_onChange(t){return this._onChangeCallback=t,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._w}},Qu=class Qu{constructor(t=0,e=0,i=0){this.x=t,this.y=e,this.z=i}set(t,e,i){return i===void 0&&(i=this.z),this.x=t,this.y=e,this.z=i,this}setScalar(t){return this.x=t,this.y=t,this.z=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setZ(t){return this.z=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;case 2:this.z=e;break;default:throw new Error("THREE.Vector3: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;case 2:return this.z;default:throw new Error("THREE.Vector3: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y,this.z)}copy(t){return this.x=t.x,this.y=t.y,this.z=t.z,this}add(t){return this.x+=t.x,this.y+=t.y,this.z+=t.z,this}addScalar(t){return this.x+=t,this.y+=t,this.z+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this.z=t.z+e.z,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this.z+=t.z*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this.z-=t.z,this}subScalar(t){return this.x-=t,this.y-=t,this.z-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this.z=t.z-e.z,this}multiply(t){return this.x*=t.x,this.y*=t.y,this.z*=t.z,this}multiplyScalar(t){return this.x*=t,this.y*=t,this.z*=t,this}multiplyVectors(t,e){return this.x=t.x*e.x,this.y=t.y*e.y,this.z=t.z*e.z,this}applyEuler(t){return this.applyQuaternion(ff.setFromEuler(t))}applyAxisAngle(t,e){return this.applyQuaternion(ff.setFromAxisAngle(t,e))}applyMatrix3(t){let e=this.x,i=this.y,s=this.z,r=t.elements;return this.x=r[0]*e+r[3]*i+r[6]*s,this.y=r[1]*e+r[4]*i+r[7]*s,this.z=r[2]*e+r[5]*i+r[8]*s,this}applyNormalMatrix(t){return this.applyMatrix3(t).normalize()}applyMatrix4(t){let e=this.x,i=this.y,s=this.z,r=t.elements,a=1/(r[3]*e+r[7]*i+r[11]*s+r[15]);return this.x=(r[0]*e+r[4]*i+r[8]*s+r[12])*a,this.y=(r[1]*e+r[5]*i+r[9]*s+r[13])*a,this.z=(r[2]*e+r[6]*i+r[10]*s+r[14])*a,this}applyQuaternion(t){let e=this.x,i=this.y,s=this.z,r=t.x,a=t.y,o=t.z,c=t.w,l=2*(a*s-o*i),h=2*(o*e-r*s),u=2*(r*i-a*e);return this.x=e+c*l+a*u-o*h,this.y=i+c*h+o*l-r*u,this.z=s+c*u+r*h-a*l,this}project(t){return this.applyMatrix4(t.matrixWorldInverse).applyMatrix4(t.projectionMatrix)}unproject(t){return this.applyMatrix4(t.projectionMatrixInverse).applyMatrix4(t.matrixWorld)}transformDirection(t){let e=this.x,i=this.y,s=this.z,r=t.elements;return this.x=r[0]*e+r[4]*i+r[8]*s,this.y=r[1]*e+r[5]*i+r[9]*s,this.z=r[2]*e+r[6]*i+r[10]*s,this.normalize()}divide(t){return this.x/=t.x,this.y/=t.y,this.z/=t.z,this}divideScalar(t){return this.multiplyScalar(1/t)}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this.z=Math.min(this.z,t.z),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this.z=Math.max(this.z,t.z),this}clamp(t,e){return this.x=oe(this.x,t.x,e.x),this.y=oe(this.y,t.y,e.y),this.z=oe(this.z,t.z,e.z),this}clampScalar(t,e){return this.x=oe(this.x,t,e),this.y=oe(this.y,t,e),this.z=oe(this.z,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(oe(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this}dot(t){return this.x*t.x+this.y*t.y+this.z*t.z}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)}normalize(){return this.divideScalar(this.length()||1)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this.z+=(t.z-this.z)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this.z=t.z+(e.z-t.z)*i,this}cross(t){return this.crossVectors(this,t)}crossVectors(t,e){let i=t.x,s=t.y,r=t.z,a=e.x,o=e.y,c=e.z;return this.x=s*c-r*o,this.y=r*a-i*c,this.z=i*o-s*a,this}projectOnVector(t){let e=t.lengthSq();if(e===0)return this.set(0,0,0);let i=t.dot(this)/e;return this.copy(t).multiplyScalar(i)}projectOnPlane(t){return Xh.copy(this).projectOnVector(t),this.sub(Xh)}reflect(t){return this.sub(Xh.copy(t).multiplyScalar(2*this.dot(t)))}angleTo(t){let e=Math.sqrt(this.lengthSq()*t.lengthSq());if(e===0)return Math.PI/2;let i=this.dot(t)/e;return Math.acos(oe(i,-1,1))}distanceTo(t){return Math.sqrt(this.distanceToSquared(t))}distanceToSquared(t){let e=this.x-t.x,i=this.y-t.y,s=this.z-t.z;return e*e+i*i+s*s}manhattanDistanceTo(t){return Math.abs(this.x-t.x)+Math.abs(this.y-t.y)+Math.abs(this.z-t.z)}setFromSpherical(t){return this.setFromSphericalCoords(t.radius,t.phi,t.theta)}setFromSphericalCoords(t,e,i){let s=Math.sin(e)*t;return this.x=s*Math.sin(i),this.y=Math.cos(e)*t,this.z=s*Math.cos(i),this}setFromCylindrical(t){return this.setFromCylindricalCoords(t.radius,t.theta,t.y)}setFromCylindricalCoords(t,e,i){return this.x=t*Math.sin(e),this.y=i,this.z=t*Math.cos(e),this}setFromMatrixPosition(t){let e=t.elements;return this.x=e[12],this.y=e[13],this.z=e[14],this}setFromMatrixScale(t){let e=this.setFromMatrixColumn(t,0).length(),i=this.setFromMatrixColumn(t,1).length(),s=this.setFromMatrixColumn(t,2).length();return this.x=e,this.y=i,this.z=s,this}setFromMatrixColumn(t,e){return this.fromArray(t.elements,e*4)}setFromMatrix3Column(t,e){return this.fromArray(t.elements,e*3)}setFromEuler(t){return this.x=t._x,this.y=t._y,this.z=t._z,this}setFromColor(t){return this.x=t.r,this.y=t.g,this.z=t.b,this}equals(t){return t.x===this.x&&t.y===this.y&&t.z===this.z}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this.z=t[e+2],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t[e+2]=this.z,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this.z=t.getZ(e),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this}randomDirection(){let t=Math.random()*Math.PI*2,e=Math.random()*2-1,i=Math.sqrt(1-e*e);return this.x=i*Math.cos(t),this.y=e,this.z=i*Math.sin(t),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z}};Qu.prototype.isVector3=!0;var D=Qu,Xh=new D,ff=new Ei,td=class td{constructor(t,e,i,s,r,a,o,c,l){this.elements=[1,0,0,0,1,0,0,0,1],t!==void 0&&this.set(t,e,i,s,r,a,o,c,l)}set(t,e,i,s,r,a,o,c,l){let h=this.elements;return h[0]=t,h[1]=s,h[2]=o,h[3]=e,h[4]=r,h[5]=c,h[6]=i,h[7]=a,h[8]=l,this}identity(){return this.set(1,0,0,0,1,0,0,0,1),this}copy(t){let e=this.elements,i=t.elements;return e[0]=i[0],e[1]=i[1],e[2]=i[2],e[3]=i[3],e[4]=i[4],e[5]=i[5],e[6]=i[6],e[7]=i[7],e[8]=i[8],this}extractBasis(t,e,i){return t.setFromMatrix3Column(this,0),e.setFromMatrix3Column(this,1),i.setFromMatrix3Column(this,2),this}setFromMatrix4(t){let e=t.elements;return this.set(e[0],e[4],e[8],e[1],e[5],e[9],e[2],e[6],e[10]),this}multiply(t){return this.multiplyMatrices(this,t)}premultiply(t){return this.multiplyMatrices(t,this)}multiplyMatrices(t,e){let i=t.elements,s=e.elements,r=this.elements,a=i[0],o=i[3],c=i[6],l=i[1],h=i[4],u=i[7],d=i[2],f=i[5],p=i[8],x=s[0],m=s[3],g=s[6],_=s[1],T=s[4],v=s[7],S=s[2],M=s[5],A=s[8];return r[0]=a*x+o*_+c*S,r[3]=a*m+o*T+c*M,r[6]=a*g+o*v+c*A,r[1]=l*x+h*_+u*S,r[4]=l*m+h*T+u*M,r[7]=l*g+h*v+u*A,r[2]=d*x+f*_+p*S,r[5]=d*m+f*T+p*M,r[8]=d*g+f*v+p*A,this}multiplyScalar(t){let e=this.elements;return e[0]*=t,e[3]*=t,e[6]*=t,e[1]*=t,e[4]*=t,e[7]*=t,e[2]*=t,e[5]*=t,e[8]*=t,this}determinant(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],c=t[6],l=t[7],h=t[8];return e*a*h-e*o*l-i*r*h+i*o*c+s*r*l-s*a*c}invert(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],c=t[6],l=t[7],h=t[8],u=h*a-o*l,d=o*c-h*r,f=l*r-a*c,p=e*u+i*d+s*f;if(p===0)return this.set(0,0,0,0,0,0,0,0,0);let x=1/p;return t[0]=u*x,t[1]=(s*l-h*i)*x,t[2]=(o*i-s*a)*x,t[3]=d*x,t[4]=(h*e-s*c)*x,t[5]=(s*r-o*e)*x,t[6]=f*x,t[7]=(i*c-l*e)*x,t[8]=(a*e-i*r)*x,this}transpose(){let t,e=this.elements;return t=e[1],e[1]=e[3],e[3]=t,t=e[2],e[2]=e[6],e[6]=t,t=e[5],e[5]=e[7],e[7]=t,this}getNormalMatrix(t){return this.setFromMatrix4(t).invert().transpose()}transposeIntoArray(t){let e=this.elements;return t[0]=e[0],t[1]=e[3],t[2]=e[6],t[3]=e[1],t[4]=e[4],t[5]=e[7],t[6]=e[2],t[7]=e[5],t[8]=e[8],this}setUvTransform(t,e,i,s,r,a,o){let c=Math.cos(r),l=Math.sin(r);return this.set(i*c,i*l,-i*(c*a+l*o)+a+t,-s*l,s*c,-s*(-l*a+c*o)+o+e,0,0,1),this}scale(t,e){return ws("Matrix3: .scale() is deprecated. Use .makeScale() instead."),this.premultiply(qh.makeScale(t,e)),this}rotate(t){return ws("Matrix3: .rotate() is deprecated. Use .makeRotation() instead."),this.premultiply(qh.makeRotation(-t)),this}translate(t,e){return ws("Matrix3: .translate() is deprecated. Use .makeTranslation() instead."),this.premultiply(qh.makeTranslation(t,e)),this}makeTranslation(t,e){return t.isVector2?this.set(1,0,t.x,0,1,t.y,0,0,1):this.set(1,0,t,0,1,e,0,0,1),this}makeRotation(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,-i,0,i,e,0,0,0,1),this}makeScale(t,e){return this.set(t,0,0,0,e,0,0,0,1),this}equals(t){let e=this.elements,i=t.elements;for(let s=0;s<9;s++)if(e[s]!==i[s])return!1;return!0}fromArray(t,e=0){for(let i=0;i<9;i++)this.elements[i]=t[i+e];return this}toArray(t=[],e=0){let i=this.elements;return t[e]=i[0],t[e+1]=i[1],t[e+2]=i[2],t[e+3]=i[3],t[e+4]=i[4],t[e+5]=i[5],t[e+6]=i[6],t[e+7]=i[7],t[e+8]=i[8],t}clone(){return new this.constructor().fromArray(this.elements)}};td.prototype.isMatrix3=!0;var ie=td,qh=new ie,pf=new ie().set(.4123908,.3575843,.1804808,.212639,.7151687,.0721923,.0193308,.1191948,.9505322),mf=new ie().set(3.2409699,-1.5373832,-.4986108,-.9692436,1.8759675,.0415551,.0556301,-.203977,1.0569715);function Fm(){let n={enabled:!0,workingColorSpace:ya,spaces:{},convert:function(s,r,a){return this.enabled===!1||r===a||!r||!a||(this.spaces[r].transfer===_e&&(s.r=Dn(s.r),s.g=Dn(s.g),s.b=Dn(s.b)),this.spaces[r].primaries!==this.spaces[a].primaries&&(s.applyMatrix3(this.spaces[r].toXYZ),s.applyMatrix3(this.spaces[a].fromXYZ)),this.spaces[a].transfer===_e&&(s.r=ar(s.r),s.g=ar(s.g),s.b=ar(s.b))),s},workingToColorSpace:function(s,r){return this.convert(s,this.workingColorSpace,r)},colorSpaceToWorking:function(s,r){return this.convert(s,r,this.workingColorSpace)},getPrimaries:function(s){return this.spaces[s].primaries},getTransfer:function(s){return s===Ki?_a:this.spaces[s].transfer},getToneMappingMode:function(s){return this.spaces[s].outputColorSpaceConfig.toneMappingMode||"standard"},getLuminanceCoefficients:function(s,r=this.workingColorSpace){return s.fromArray(this.spaces[r].luminanceCoefficients)},define:function(s){Object.assign(this.spaces,s)},_getMatrix:function(s,r,a){return s.copy(this.spaces[r].toXYZ).multiply(this.spaces[a].fromXYZ)},_getDrawingBufferColorSpace:function(s){return this.spaces[s].outputColorSpaceConfig.drawingBufferColorSpace},_getUnpackColorSpace:function(s=this.workingColorSpace){return this.spaces[s].workingColorSpaceConfig.unpackColorSpace},fromWorkingColorSpace:function(s,r){return ws("ColorManagement: .fromWorkingColorSpace() has been renamed to .workingToColorSpace()."),n.workingToColorSpace(s,r)},toWorkingColorSpace:function(s,r){return ws("ColorManagement: .toWorkingColorSpace() has been renamed to .colorSpaceToWorking()."),n.colorSpaceToWorking(s,r)}},t=[.64,.33,.3,.6,.15,.06],e=[.2126,.7152,.0722],i=[.3127,.329];return n.define({[ya]:{primaries:t,whitePoint:i,transfer:_a,toXYZ:pf,fromXYZ:mf,luminanceCoefficients:e,workingColorSpaceConfig:{unpackColorSpace:Oe},outputColorSpaceConfig:{drawingBufferColorSpace:Oe}},[Oe]:{primaries:t,whitePoint:i,transfer:_e,toXYZ:pf,fromXYZ:mf,luminanceCoefficients:e,outputColorSpaceConfig:{drawingBufferColorSpace:Oe}}}),n}var he=Fm();function Dn(n){return n<.04045?n*.0773993808:Math.pow(n*.9478672986+.0521327014,2.4)}function ar(n){return n<.0031308?n*12.92:1.055*Math.pow(n,.41666)-.055}var Gs,wl=class{static getDataURL(t,e="image/png"){if(/^data:/i.test(t.src)||typeof HTMLCanvasElement>"u")return t.src;let i;if(t instanceof HTMLCanvasElement)i=t;else{Gs===void 0&&(Gs=ba("canvas")),Gs.width=t.width,Gs.height=t.height;let s=Gs.getContext("2d");t instanceof ImageData?s.putImageData(t,0,0):s.drawImage(t,0,0,t.width,t.height),i=Gs}return i.toDataURL(e)}static sRGBToLinear(t){if(typeof HTMLImageElement<"u"&&t instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&t instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&t instanceof ImageBitmap){let e=ba("canvas");e.width=t.width,e.height=t.height;let i=e.getContext("2d");i.drawImage(t,0,0,t.width,t.height);let s=i.getImageData(0,0,t.width,t.height),r=s.data;for(let a=0;a<r.length;a++)r[a]=Dn(r[a]/255)*255;return i.putImageData(s,0,0),e}else if(t.data){let e=t.data.slice(0);for(let i=0;i<e.length;i++)e instanceof Uint8Array||e instanceof Uint8ClampedArray?e[i]=Math.floor(Dn(e[i]/255)*255):e[i]=Dn(e[i]);return{data:e,width:t.width,height:t.height}}else return te("ImageUtils.sRGBToLinear(): Unsupported image type. No color space conversion applied."),t}},zm=0,dr=class{constructor(t=null){this.isTextureSource=!0,Object.defineProperty(this,"id",{value:zm++}),this.uuid=xn(),this.data=t,this.dataReady=!0,this.version=0}getSize(t){let e=this.data;return typeof HTMLVideoElement<"u"&&e instanceof HTMLVideoElement?t.set(e.videoWidth,e.videoHeight,0):typeof VideoFrame<"u"&&e instanceof VideoFrame?t.set(e.displayWidth,e.displayHeight,0):e!==null?t.set(e.width,e.height,e.depth||0):t.set(0,0,0),t}set needsUpdate(t){t===!0&&this.version++}toJSON(t){let e=t===void 0||typeof t=="string";if(!e&&t.images[this.uuid]!==void 0)return t.images[this.uuid];let i={uuid:this.uuid,url:""},s=this.data;if(s!==null){let r;if(Array.isArray(s)){r=[];for(let a=0,o=s.length;a<o;a++)s[a].isDataTexture?r.push($h(s[a].image)):r.push($h(s[a]))}else r=$h(s);i.url=r}return e||(t.images[this.uuid]=i),i}};function $h(n){return typeof HTMLImageElement<"u"&&n instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&n instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&n instanceof ImageBitmap?wl.getDataURL(n):n.data?{data:Array.from(n.data),width:n.width,height:n.height,type:n.data.constructor.name}:(te("Texture: Unable to serialize Texture."),{})}var Om=0,Yh=new D,wi=class n extends yn{constructor(t=n.DEFAULT_IMAGE,e=n.DEFAULT_MAPPING,i=gn,s=gn,r=Ye,a=Oi,o=Ji,c=Ci,l=n.DEFAULT_ANISOTROPY,h=Ki){super(),this.isTexture=!0,Object.defineProperty(this,"id",{value:Om++}),this.uuid=xn(),this.name="",this.source=new dr(t),this.mipmaps=[],this.mapping=e,this.channel=0,this.wrapS=i,this.wrapT=s,this.magFilter=r,this.minFilter=a,this.anisotropy=l,this.format=o,this.internalFormat=null,this.type=c,this.offset=new ot(0,0),this.repeat=new ot(1,1),this.center=new ot(0,0),this.rotation=0,this.matrixAutoUpdate=!0,this.matrix=new ie,this.generateMipmaps=!0,this.premultiplyAlpha=!1,this.flipY=!0,this.unpackAlignment=4,this.colorSpace=h,this.userData={},this.updateRanges=[],this.version=0,this.onUpdate=null,this.renderTarget=null,this.isRenderTargetTexture=!1,this.isArrayTexture=!!(t&&t.depth&&t.depth>1),this.pmremVersion=0,this.normalized=!1}get width(){return this.source.getSize(Yh).x}get height(){return this.source.getSize(Yh).y}get depth(){return this.source.getSize(Yh).z}get image(){return this.source.data}set image(t){this.source.data=t}updateMatrix(){this.matrix.setUvTransform(this.offset.x,this.offset.y,this.repeat.x,this.repeat.y,this.rotation,this.center.x,this.center.y)}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}clone(){return new this.constructor().copy(this)}copy(t){return this.name=t.name,this.source=t.source,this.mipmaps=t.mipmaps.slice(0),this.mapping=t.mapping,this.channel=t.channel,this.wrapS=t.wrapS,this.wrapT=t.wrapT,this.magFilter=t.magFilter,this.minFilter=t.minFilter,this.anisotropy=t.anisotropy,this.format=t.format,this.internalFormat=t.internalFormat,this.type=t.type,this.normalized=t.normalized,this.offset.copy(t.offset),this.repeat.copy(t.repeat),this.center.copy(t.center),this.rotation=t.rotation,this.matrixAutoUpdate=t.matrixAutoUpdate,this.matrix.copy(t.matrix),this.generateMipmaps=t.generateMipmaps,this.premultiplyAlpha=t.premultiplyAlpha,this.flipY=t.flipY,this.unpackAlignment=t.unpackAlignment,this.colorSpace=t.colorSpace,this.renderTarget=t.renderTarget,this.isRenderTargetTexture=t.isRenderTargetTexture,this.isArrayTexture=t.isArrayTexture,this.userData=JSON.parse(JSON.stringify(t.userData)),this.needsUpdate=!0,this}setValues(t){for(let e in t){let i=t[e];if(i===void 0){te(`Texture.setValues(): parameter '${e}' has value of undefined.`);continue}let s=this[e];if(s===void 0){te(`Texture.setValues(): property '${e}' does not exist.`);continue}s&&i&&s.isVector2&&i.isVector2||s&&i&&s.isVector3&&i.isVector3||s&&i&&s.isMatrix3&&i.isMatrix3?s.copy(i):this[e]=i}}toJSON(t){let e=t===void 0||typeof t=="string";if(!e&&t.textures[this.uuid]!==void 0)return t.textures[this.uuid];let i={metadata:{version:4.7,type:"Texture",generator:"Texture.toJSON"},uuid:this.uuid,name:this.name,image:this.source.toJSON(t).uuid,mapping:this.mapping,channel:this.channel,repeat:[this.repeat.x,this.repeat.y],offset:[this.offset.x,this.offset.y],center:[this.center.x,this.center.y],rotation:this.rotation,wrap:[this.wrapS,this.wrapT],format:this.format,internalFormat:this.internalFormat,type:this.type,normalized:this.normalized,colorSpace:this.colorSpace,minFilter:this.minFilter,magFilter:this.magFilter,anisotropy:this.anisotropy,flipY:this.flipY,generateMipmaps:this.generateMipmaps,premultiplyAlpha:this.premultiplyAlpha,unpackAlignment:this.unpackAlignment};return Object.keys(this.userData).length>0&&(i.userData=this.userData),e||(t.textures[this.uuid]=i),i}dispose(){this.dispatchEvent({type:"dispose"})}transformUv(t){if(this.mapping!==Fu)return t;if(t.applyMatrix3(this.matrix),t.x<0||t.x>1)switch(this.wrapS){case Nn:t.x=t.x-Math.floor(t.x);break;case gn:t.x=t.x<0?0:1;break;case Ml:Math.abs(Math.floor(t.x)%2)===1?t.x=Math.ceil(t.x)-t.x:t.x=t.x-Math.floor(t.x);break}if(t.y<0||t.y>1)switch(this.wrapT){case Nn:t.y=t.y-Math.floor(t.y);break;case gn:t.y=t.y<0?0:1;break;case Ml:Math.abs(Math.floor(t.y)%2)===1?t.y=Math.ceil(t.y)-t.y:t.y=t.y-Math.floor(t.y);break}return this.flipY&&(t.y=1-t.y),t}set needsUpdate(t){t===!0&&(this.version++,this.source.needsUpdate=!0)}set needsPMREMUpdate(t){t===!0&&this.pmremVersion++}};wi.DEFAULT_IMAGE=null;wi.DEFAULT_MAPPING=Fu;wi.DEFAULT_ANISOTROPY=1;var ed=class ed{constructor(t=0,e=0,i=0,s=1){this.x=t,this.y=e,this.z=i,this.w=s}get width(){return this.z}set width(t){this.z=t}get height(){return this.w}set height(t){this.w=t}set(t,e,i,s){return this.x=t,this.y=e,this.z=i,this.w=s,this}setScalar(t){return this.x=t,this.y=t,this.z=t,this.w=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setZ(t){return this.z=t,this}setW(t){return this.w=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;case 2:this.z=e;break;case 3:this.w=e;break;default:throw new Error("THREE.Vector4: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;case 2:return this.z;case 3:return this.w;default:throw new Error("THREE.Vector4: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y,this.z,this.w)}copy(t){return this.x=t.x,this.y=t.y,this.z=t.z,this.w=t.w!==void 0?t.w:1,this}add(t){return this.x+=t.x,this.y+=t.y,this.z+=t.z,this.w+=t.w,this}addScalar(t){return this.x+=t,this.y+=t,this.z+=t,this.w+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this.z=t.z+e.z,this.w=t.w+e.w,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this.z+=t.z*e,this.w+=t.w*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this.z-=t.z,this.w-=t.w,this}subScalar(t){return this.x-=t,this.y-=t,this.z-=t,this.w-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this.z=t.z-e.z,this.w=t.w-e.w,this}multiply(t){return this.x*=t.x,this.y*=t.y,this.z*=t.z,this.w*=t.w,this}multiplyScalar(t){return this.x*=t,this.y*=t,this.z*=t,this.w*=t,this}applyMatrix4(t){let e=this.x,i=this.y,s=this.z,r=this.w,a=t.elements;return this.x=a[0]*e+a[4]*i+a[8]*s+a[12]*r,this.y=a[1]*e+a[5]*i+a[9]*s+a[13]*r,this.z=a[2]*e+a[6]*i+a[10]*s+a[14]*r,this.w=a[3]*e+a[7]*i+a[11]*s+a[15]*r,this}divide(t){return this.x/=t.x,this.y/=t.y,this.z/=t.z,this.w/=t.w,this}divideScalar(t){return this.multiplyScalar(1/t)}setAxisAngleFromQuaternion(t){this.w=2*Math.acos(t.w);let e=Math.sqrt(1-t.w*t.w);return e<1e-4?(this.x=1,this.y=0,this.z=0):(this.x=t.x/e,this.y=t.y/e,this.z=t.z/e),this}setAxisAngleFromRotationMatrix(t){let e,i,s,r,c=t.elements,l=c[0],h=c[4],u=c[8],d=c[1],f=c[5],p=c[9],x=c[2],m=c[6],g=c[10];if(Math.abs(h-d)<.01&&Math.abs(u-x)<.01&&Math.abs(p-m)<.01){if(Math.abs(h+d)<.1&&Math.abs(u+x)<.1&&Math.abs(p+m)<.1&&Math.abs(l+f+g-3)<.1)return this.set(1,0,0,0),this;e=Math.PI;let T=(l+1)/2,v=(f+1)/2,S=(g+1)/2,M=(h+d)/4,A=(u+x)/4,y=(p+m)/4;return T>v&&T>S?T<.01?(i=0,s=.707106781,r=.707106781):(i=Math.sqrt(T),s=M/i,r=A/i):v>S?v<.01?(i=.707106781,s=0,r=.707106781):(s=Math.sqrt(v),i=M/s,r=y/s):S<.01?(i=.707106781,s=.707106781,r=0):(r=Math.sqrt(S),i=A/r,s=y/r),this.set(i,s,r,e),this}let _=Math.sqrt((m-p)*(m-p)+(u-x)*(u-x)+(d-h)*(d-h));return Math.abs(_)<.001&&(_=1),this.x=(m-p)/_,this.y=(u-x)/_,this.z=(d-h)/_,this.w=Math.acos((l+f+g-1)/2),this}setFromMatrixPosition(t){let e=t.elements;return this.x=e[12],this.y=e[13],this.z=e[14],this.w=e[15],this}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this.z=Math.min(this.z,t.z),this.w=Math.min(this.w,t.w),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this.z=Math.max(this.z,t.z),this.w=Math.max(this.w,t.w),this}clamp(t,e){return this.x=oe(this.x,t.x,e.x),this.y=oe(this.y,t.y,e.y),this.z=oe(this.z,t.z,e.z),this.w=oe(this.w,t.w,e.w),this}clampScalar(t,e){return this.x=oe(this.x,t,e),this.y=oe(this.y,t,e),this.z=oe(this.z,t,e),this.w=oe(this.w,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(oe(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this.w=Math.floor(this.w),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this.w=Math.ceil(this.w),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this.w=Math.round(this.w),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this.w=Math.trunc(this.w),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this.w=-this.w,this}dot(t){return this.x*t.x+this.y*t.y+this.z*t.z+this.w*t.w}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)+Math.abs(this.w)}normalize(){return this.divideScalar(this.length()||1)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this.z+=(t.z-this.z)*e,this.w+=(t.w-this.w)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this.z=t.z+(e.z-t.z)*i,this.w=t.w+(e.w-t.w)*i,this}equals(t){return t.x===this.x&&t.y===this.y&&t.z===this.z&&t.w===this.w}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this.z=t[e+2],this.w=t[e+3],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t[e+2]=this.z,t[e+3]=this.w,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this.z=t.getZ(e),this.w=t.getW(e),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this.w=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z,yield this.w}};ed.prototype.isVector4=!0;var Le=ed,Tl=class extends yn{constructor(t=1,e=1,i={}){super(),i=Object.assign({generateMipmaps:!1,internalFormat:null,minFilter:Ye,depthBuffer:!0,stencilBuffer:!1,resolveColorBuffer:!0,resolveDepthBuffer:!0,resolveStencilBuffer:!0,storeMultisampledColorBuffer:!0,storeMultisampledDepthBuffer:!0,storeMultisampledStencilBuffer:!0,depthTexture:null,samples:0,count:1,depth:1,multiview:!1,useArrayDepthTexture:!1},i),this.isRenderTarget=!0,this.width=t,this.height=e,this.depth=i.depth,this.scissor=new Le(0,0,t,e),this.scissorTest=!1,this.viewport=new Le(0,0,t,e),this.textures=[];let s={width:t,height:e,depth:i.depth},r=new wi(s),a=i.count;for(let o=0;o<a;o++)this.textures[o]=r.clone(),this.textures[o].isRenderTargetTexture=!0,this.textures[o].renderTarget=this;this._setTextureOptions(i),this.depthBuffer=i.depthBuffer,this.stencilBuffer=i.stencilBuffer,this.resolveColorBuffer=i.resolveColorBuffer,this.resolveDepthBuffer=i.resolveDepthBuffer,this.resolveStencilBuffer=i.resolveStencilBuffer,this.storeMultisampledColorBuffer=i.storeMultisampledColorBuffer,this.storeMultisampledDepthBuffer=i.storeMultisampledDepthBuffer,this.storeMultisampledStencilBuffer=i.storeMultisampledStencilBuffer,this._depthTexture=null,this.depthTexture=i.depthTexture,this.samples=i.samples,this.multiview=i.multiview,this.useArrayDepthTexture=i.useArrayDepthTexture}_setTextureOptions(t={}){let e={minFilter:Ye,generateMipmaps:!1,flipY:!1,internalFormat:null};t.mapping!==void 0&&(e.mapping=t.mapping),t.wrapS!==void 0&&(e.wrapS=t.wrapS),t.wrapT!==void 0&&(e.wrapT=t.wrapT),t.wrapR!==void 0&&(e.wrapR=t.wrapR),t.magFilter!==void 0&&(e.magFilter=t.magFilter),t.minFilter!==void 0&&(e.minFilter=t.minFilter),t.format!==void 0&&(e.format=t.format),t.type!==void 0&&(e.type=t.type),t.anisotropy!==void 0&&(e.anisotropy=t.anisotropy),t.colorSpace!==void 0&&(e.colorSpace=t.colorSpace),t.flipY!==void 0&&(e.flipY=t.flipY),t.generateMipmaps!==void 0&&(e.generateMipmaps=t.generateMipmaps),t.internalFormat!==void 0&&(e.internalFormat=t.internalFormat);for(let i=0;i<this.textures.length;i++)this.textures[i].setValues(e)}get texture(){return this.textures[0]}set texture(t){this.textures[0]=t}set depthTexture(t){this._depthTexture!==null&&this._depthTexture.renderTarget===this&&(this._depthTexture.renderTarget=null),t!==null&&t.renderTarget===null&&(t.renderTarget=this),this._depthTexture=t}get depthTexture(){return this._depthTexture}setSize(t,e,i=1){if(this.width!==t||this.height!==e||this.depth!==i){this.width=t,this.height=e,this.depth=i;for(let s=0,r=this.textures.length;s<r;s++)this.textures[s].image.width=t,this.textures[s].image.height=e,this.textures[s].image.depth=i,this.textures[s].isData3DTexture!==!0&&(this.textures[s].isArrayTexture=this.textures[s].image.depth>1);this.dispose()}this.viewport.set(0,0,t,e),this.scissor.set(0,0,t,e)}clone(){return new this.constructor().copy(this)}copy(t){this.width=t.width,this.height=t.height,this.depth=t.depth,this.scissor.copy(t.scissor),this.scissorTest=t.scissorTest,this.viewport.copy(t.viewport),this.textures.length=0;for(let e=0,i=t.textures.length;e<i;e++){this.textures[e]=t.textures[e].clone(),this.textures[e].isRenderTargetTexture=!0,this.textures[e].renderTarget=this;let s=Object.assign({},t.textures[e].image);this.textures[e].source=new dr(s)}if(this.depthBuffer=t.depthBuffer,this.stencilBuffer=t.stencilBuffer,this.resolveColorBuffer=t.resolveColorBuffer,this.resolveDepthBuffer=t.resolveDepthBuffer,this.resolveStencilBuffer=t.resolveStencilBuffer,this.storeMultisampledColorBuffer=t.storeMultisampledColorBuffer,this.storeMultisampledDepthBuffer=t.storeMultisampledDepthBuffer,this.storeMultisampledStencilBuffer=t.storeMultisampledStencilBuffer,t.depthTexture!==null)if(t.depthTexture.renderTarget===t){let e=t.depthTexture.clone();e.renderTarget=null,this.depthTexture=e}else this.depthTexture=t.depthTexture;return this.samples=t.samples,this.multiview=t.multiview,this.useArrayDepthTexture=t.useArrayDepthTexture,this}dispose(){this.dispatchEvent({type:"dispose"})}},ke=class extends Tl{constructor(t=1,e=1,i={}){super(t,e,i),this.isWebGLRenderTarget=!0}},Sa=class extends wi{constructor(t=null,e=1,i=1,s=1){super(null),this.isDataArrayTexture=!0,this.image={data:t,width:e,height:i,depth:s},this.magFilter=oi,this.minFilter=oi,this.wrapR=gn,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1,this.layerUpdates=new Set}copy(t){return super.copy(t),this.wrapR=t.wrapR,this}addLayerUpdate(t){this.layerUpdates.add(t)}clearLayerUpdates(){this.layerUpdates.clear()}};var El=class extends wi{constructor(t=null,e=1,i=1,s=1){super(null),this.isData3DTexture=!0,this.image={data:t,width:e,height:i,depth:s},this.magFilter=oi,this.minFilter=oi,this.wrapR=gn,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}copy(t){return super.copy(t),this.wrapR=t.wrapR,this}};var Jl=class Jl{constructor(t,e,i,s,r,a,o,c,l,h,u,d,f,p,x,m){this.elements=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],t!==void 0&&this.set(t,e,i,s,r,a,o,c,l,h,u,d,f,p,x,m)}set(t,e,i,s,r,a,o,c,l,h,u,d,f,p,x,m){let g=this.elements;return g[0]=t,g[4]=e,g[8]=i,g[12]=s,g[1]=r,g[5]=a,g[9]=o,g[13]=c,g[2]=l,g[6]=h,g[10]=u,g[14]=d,g[3]=f,g[7]=p,g[11]=x,g[15]=m,this}identity(){return this.set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),this}clone(){return new Jl().fromArray(this.elements)}copy(t){let e=this.elements,i=t.elements;return e[0]=i[0],e[1]=i[1],e[2]=i[2],e[3]=i[3],e[4]=i[4],e[5]=i[5],e[6]=i[6],e[7]=i[7],e[8]=i[8],e[9]=i[9],e[10]=i[10],e[11]=i[11],e[12]=i[12],e[13]=i[13],e[14]=i[14],e[15]=i[15],this}copyPosition(t){let e=this.elements,i=t.elements;return e[12]=i[12],e[13]=i[13],e[14]=i[14],this}setFromMatrix3(t){let e=t.elements;return this.set(e[0],e[3],e[6],0,e[1],e[4],e[7],0,e[2],e[5],e[8],0,0,0,0,1),this}extractBasis(t,e,i){return this.determinantAffine()===0?(t.set(1,0,0),e.set(0,1,0),i.set(0,0,1),this):(t.setFromMatrixColumn(this,0),e.setFromMatrixColumn(this,1),i.setFromMatrixColumn(this,2),this)}makeBasis(t,e,i){return this.set(t.x,e.x,i.x,0,t.y,e.y,i.y,0,t.z,e.z,i.z,0,0,0,0,1),this}extractRotation(t){if(t.determinantAffine()===0)return this.identity();let e=this.elements,i=t.elements,s=1/Vs.setFromMatrixColumn(t,0).length(),r=1/Vs.setFromMatrixColumn(t,1).length(),a=1/Vs.setFromMatrixColumn(t,2).length();return e[0]=i[0]*s,e[1]=i[1]*s,e[2]=i[2]*s,e[3]=0,e[4]=i[4]*r,e[5]=i[5]*r,e[6]=i[6]*r,e[7]=0,e[8]=i[8]*a,e[9]=i[9]*a,e[10]=i[10]*a,e[11]=0,e[12]=0,e[13]=0,e[14]=0,e[15]=1,this}makeRotationFromEuler(t){let e=this.elements,i=t.x,s=t.y,r=t.z,a=Math.cos(i),o=Math.sin(i),c=Math.cos(s),l=Math.sin(s),h=Math.cos(r),u=Math.sin(r);if(t.order==="XYZ"){let d=a*h,f=a*u,p=o*h,x=o*u;e[0]=c*h,e[4]=-c*u,e[8]=l,e[1]=f+p*l,e[5]=d-x*l,e[9]=-o*c,e[2]=x-d*l,e[6]=p+f*l,e[10]=a*c}else if(t.order==="YXZ"){let d=c*h,f=c*u,p=l*h,x=l*u;e[0]=d+x*o,e[4]=p*o-f,e[8]=a*l,e[1]=a*u,e[5]=a*h,e[9]=-o,e[2]=f*o-p,e[6]=x+d*o,e[10]=a*c}else if(t.order==="ZXY"){let d=c*h,f=c*u,p=l*h,x=l*u;e[0]=d-x*o,e[4]=-a*u,e[8]=p+f*o,e[1]=f+p*o,e[5]=a*h,e[9]=x-d*o,e[2]=-a*l,e[6]=o,e[10]=a*c}else if(t.order==="ZYX"){let d=a*h,f=a*u,p=o*h,x=o*u;e[0]=c*h,e[4]=p*l-f,e[8]=d*l+x,e[1]=c*u,e[5]=x*l+d,e[9]=f*l-p,e[2]=-l,e[6]=o*c,e[10]=a*c}else if(t.order==="YZX"){let d=a*c,f=a*l,p=o*c,x=o*l;e[0]=c*h,e[4]=x-d*u,e[8]=p*u+f,e[1]=u,e[5]=a*h,e[9]=-o*h,e[2]=-l*h,e[6]=f*u+p,e[10]=d-x*u}else if(t.order==="XZY"){let d=a*c,f=a*l,p=o*c,x=o*l;e[0]=c*h,e[4]=-u,e[8]=l*h,e[1]=d*u+x,e[5]=a*h,e[9]=f*u-p,e[2]=p*u-f,e[6]=o*h,e[10]=x*u+d}return e[3]=0,e[7]=0,e[11]=0,e[12]=0,e[13]=0,e[14]=0,e[15]=1,this}makeRotationFromQuaternion(t){return this.compose(km,t,Bm)}lookAt(t,e,i){let s=this.elements;return Di.subVectors(t,e),Di.lengthSq()===0&&(Di.z=1),Di.normalize(),qn.crossVectors(i,Di),qn.lengthSq()===0&&(Math.abs(i.z)===1?Di.x+=1e-4:Di.z+=1e-4,Di.normalize(),qn.crossVectors(i,Di)),qn.normalize(),ko.crossVectors(Di,qn),s[0]=qn.x,s[4]=ko.x,s[8]=Di.x,s[1]=qn.y,s[5]=ko.y,s[9]=Di.y,s[2]=qn.z,s[6]=ko.z,s[10]=Di.z,this}multiply(t){return this.multiplyMatrices(this,t)}premultiply(t){return this.multiplyMatrices(t,this)}multiplyMatrices(t,e){let i=t.elements,s=e.elements,r=this.elements,a=i[0],o=i[4],c=i[8],l=i[12],h=i[1],u=i[5],d=i[9],f=i[13],p=i[2],x=i[6],m=i[10],g=i[14],_=i[3],T=i[7],v=i[11],S=i[15],M=s[0],A=s[4],y=s[8],E=s[12],P=s[1],N=s[5],F=s[9],B=s[13],I=s[2],H=s[6],W=s[10],U=s[14],X=s[3],G=s[7],j=s[11],et=s[15];return r[0]=a*M+o*P+c*I+l*X,r[4]=a*A+o*N+c*H+l*G,r[8]=a*y+o*F+c*W+l*j,r[12]=a*E+o*B+c*U+l*et,r[1]=h*M+u*P+d*I+f*X,r[5]=h*A+u*N+d*H+f*G,r[9]=h*y+u*F+d*W+f*j,r[13]=h*E+u*B+d*U+f*et,r[2]=p*M+x*P+m*I+g*X,r[6]=p*A+x*N+m*H+g*G,r[10]=p*y+x*F+m*W+g*j,r[14]=p*E+x*B+m*U+g*et,r[3]=_*M+T*P+v*I+S*X,r[7]=_*A+T*N+v*H+S*G,r[11]=_*y+T*F+v*W+S*j,r[15]=_*E+T*B+v*U+S*et,this}multiplyScalar(t){let e=this.elements;return e[0]*=t,e[4]*=t,e[8]*=t,e[12]*=t,e[1]*=t,e[5]*=t,e[9]*=t,e[13]*=t,e[2]*=t,e[6]*=t,e[10]*=t,e[14]*=t,e[3]*=t,e[7]*=t,e[11]*=t,e[15]*=t,this}determinant(){let t=this.elements,e=t[0],i=t[4],s=t[8],r=t[12],a=t[1],o=t[5],c=t[9],l=t[13],h=t[2],u=t[6],d=t[10],f=t[14],p=t[3],x=t[7],m=t[11],g=t[15],_=c*f-l*d,T=o*f-l*u,v=o*d-c*u,S=a*f-l*h,M=a*d-c*h,A=a*u-o*h;return e*(x*_-m*T+g*v)-i*(p*_-m*S+g*M)+s*(p*T-x*S+g*A)-r*(p*v-x*M+m*A)}determinantAffine(){let t=this.elements,e=t[0],i=t[4],s=t[8],r=t[1],a=t[5],o=t[9],c=t[2],l=t[6],h=t[10];return e*(a*h-o*l)-i*(r*h-o*c)+s*(r*l-a*c)}transpose(){let t=this.elements,e;return e=t[1],t[1]=t[4],t[4]=e,e=t[2],t[2]=t[8],t[8]=e,e=t[6],t[6]=t[9],t[9]=e,e=t[3],t[3]=t[12],t[12]=e,e=t[7],t[7]=t[13],t[13]=e,e=t[11],t[11]=t[14],t[14]=e,this}setPosition(t,e,i){let s=this.elements;return t.isVector3?(s[12]=t.x,s[13]=t.y,s[14]=t.z):(s[12]=t,s[13]=e,s[14]=i),this}invert(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],c=t[6],l=t[7],h=t[8],u=t[9],d=t[10],f=t[11],p=t[12],x=t[13],m=t[14],g=t[15],_=e*o-i*a,T=e*c-s*a,v=e*l-r*a,S=i*c-s*o,M=i*l-r*o,A=s*l-r*c,y=h*x-u*p,E=h*m-d*p,P=h*g-f*p,N=u*m-d*x,F=u*g-f*x,B=d*g-f*m,I=_*B-T*F+v*N+S*P-M*E+A*y;if(I===0)return this.set(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);let H=1/I;return t[0]=(o*B-c*F+l*N)*H,t[1]=(s*F-i*B-r*N)*H,t[2]=(x*A-m*M+g*S)*H,t[3]=(d*M-u*A-f*S)*H,t[4]=(c*P-a*B-l*E)*H,t[5]=(e*B-s*P+r*E)*H,t[6]=(m*v-p*A-g*T)*H,t[7]=(h*A-d*v+f*T)*H,t[8]=(a*F-o*P+l*y)*H,t[9]=(i*P-e*F-r*y)*H,t[10]=(p*M-x*v+g*_)*H,t[11]=(u*v-h*M-f*_)*H,t[12]=(o*E-a*N-c*y)*H,t[13]=(e*N-i*E+s*y)*H,t[14]=(x*T-p*S-m*_)*H,t[15]=(h*S-u*T+d*_)*H,this}scale(t){let e=this.elements,i=t.x,s=t.y,r=t.z;return e[0]*=i,e[4]*=s,e[8]*=r,e[1]*=i,e[5]*=s,e[9]*=r,e[2]*=i,e[6]*=s,e[10]*=r,e[3]*=i,e[7]*=s,e[11]*=r,this}getMaxScaleOnAxis(){let t=this.elements,e=t[0]*t[0]+t[1]*t[1]+t[2]*t[2],i=t[4]*t[4]+t[5]*t[5]+t[6]*t[6],s=t[8]*t[8]+t[9]*t[9]+t[10]*t[10];return Math.sqrt(Math.max(e,i,s))}makeTranslation(t,e,i){return t.isVector3?this.set(1,0,0,t.x,0,1,0,t.y,0,0,1,t.z,0,0,0,1):this.set(1,0,0,t,0,1,0,e,0,0,1,i,0,0,0,1),this}makeRotationX(t){let e=Math.cos(t),i=Math.sin(t);return this.set(1,0,0,0,0,e,-i,0,0,i,e,0,0,0,0,1),this}makeRotationY(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,0,i,0,0,1,0,0,-i,0,e,0,0,0,0,1),this}makeRotationZ(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,-i,0,0,i,e,0,0,0,0,1,0,0,0,0,1),this}makeRotationAxis(t,e){let i=Math.cos(e),s=Math.sin(e),r=1-i,a=t.x,o=t.y,c=t.z,l=r*a,h=r*o;return this.set(l*a+i,l*o-s*c,l*c+s*o,0,l*o+s*c,h*o+i,h*c-s*a,0,l*c-s*o,h*c+s*a,r*c*c+i,0,0,0,0,1),this}makeScale(t,e,i){return this.set(t,0,0,0,0,e,0,0,0,0,i,0,0,0,0,1),this}makeShear(t,e,i,s,r,a){return this.set(1,i,r,0,t,1,a,0,e,s,1,0,0,0,0,1),this}compose(t,e,i){let s=this.elements,r=e._x,a=e._y,o=e._z,c=e._w,l=r+r,h=a+a,u=o+o,d=r*l,f=r*h,p=r*u,x=a*h,m=a*u,g=o*u,_=c*l,T=c*h,v=c*u,S=i.x,M=i.y,A=i.z;return s[0]=(1-(x+g))*S,s[1]=(f+v)*S,s[2]=(p-T)*S,s[3]=0,s[4]=(f-v)*M,s[5]=(1-(d+g))*M,s[6]=(m+_)*M,s[7]=0,s[8]=(p+T)*A,s[9]=(m-_)*A,s[10]=(1-(d+x))*A,s[11]=0,s[12]=t.x,s[13]=t.y,s[14]=t.z,s[15]=1,this}decompose(t,e,i){let s=this.elements;t.x=s[12],t.y=s[13],t.z=s[14];let r=this.determinantAffine();if(r===0)return i.set(1,1,1),e.identity(),this;let a=Vs.set(s[0],s[1],s[2]).length(),o=Vs.set(s[4],s[5],s[6]).length(),c=Vs.set(s[8],s[9],s[10]).length();r<0&&(a=-a),en.copy(this);let l=1/a,h=1/o,u=1/c;return en.elements[0]*=l,en.elements[1]*=l,en.elements[2]*=l,en.elements[4]*=h,en.elements[5]*=h,en.elements[6]*=h,en.elements[8]*=u,en.elements[9]*=u,en.elements[10]*=u,e.setFromRotationMatrix(en),i.x=a,i.y=o,i.z=c,this}makePerspective(t,e,i,s,r,a,o=an,c=!1){let l=this.elements,h=2*r/(e-t),u=2*r/(i-s),d=(e+t)/(e-t),f=(i+s)/(i-s),p,x;if(c)p=r/(a-r),x=a*r/(a-r);else if(o===an)p=-(a+r)/(a-r),x=-2*a*r/(a-r);else if(o===cr)p=-a/(a-r),x=-a*r/(a-r);else throw new Error("THREE.Matrix4.makePerspective(): Invalid coordinate system: "+o);return l[0]=h,l[4]=0,l[8]=d,l[12]=0,l[1]=0,l[5]=u,l[9]=f,l[13]=0,l[2]=0,l[6]=0,l[10]=p,l[14]=x,l[3]=0,l[7]=0,l[11]=-1,l[15]=0,this}makeOrthographic(t,e,i,s,r,a,o=an,c=!1){let l=this.elements,h=2/(e-t),u=2/(i-s),d=-(e+t)/(e-t),f=-(i+s)/(i-s),p,x;if(c)p=1/(a-r),x=a/(a-r);else if(o===an)p=-2/(a-r),x=-(a+r)/(a-r);else if(o===cr)p=-1/(a-r),x=-r/(a-r);else throw new Error("THREE.Matrix4.makeOrthographic(): Invalid coordinate system: "+o);return l[0]=h,l[4]=0,l[8]=0,l[12]=d,l[1]=0,l[5]=u,l[9]=0,l[13]=f,l[2]=0,l[6]=0,l[10]=p,l[14]=x,l[3]=0,l[7]=0,l[11]=0,l[15]=1,this}equals(t){let e=this.elements,i=t.elements;for(let s=0;s<16;s++)if(e[s]!==i[s])return!1;return!0}fromArray(t,e=0){for(let i=0;i<16;i++)this.elements[i]=t[i+e];return this}toArray(t=[],e=0){let i=this.elements;return t[e]=i[0],t[e+1]=i[1],t[e+2]=i[2],t[e+3]=i[3],t[e+4]=i[4],t[e+5]=i[5],t[e+6]=i[6],t[e+7]=i[7],t[e+8]=i[8],t[e+9]=i[9],t[e+10]=i[10],t[e+11]=i[11],t[e+12]=i[12],t[e+13]=i[13],t[e+14]=i[14],t[e+15]=i[15],t}};Jl.prototype.isMatrix4=!0;var me=Jl,Vs=new D,en=new me,km=new D(0,0,0),Bm=new D(1,1,1),qn=new D,ko=new D,Di=new D,gf=new me,xf=new Ei,Ai=class n{constructor(t=0,e=0,i=0,s=n.DEFAULT_ORDER){this.isEuler=!0,this._x=t,this._y=e,this._z=i,this._order=s}get x(){return this._x}set x(t){this._x=t,this._onChangeCallback()}get y(){return this._y}set y(t){this._y=t,this._onChangeCallback()}get z(){return this._z}set z(t){this._z=t,this._onChangeCallback()}get order(){return this._order}set order(t){this._order=t,this._onChangeCallback()}set(t,e,i,s=this._order){return this._x=t,this._y=e,this._z=i,this._order=s,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._order)}copy(t){return this._x=t._x,this._y=t._y,this._z=t._z,this._order=t._order,this._onChangeCallback(),this}setFromRotationMatrix(t,e=this._order,i=!0){let s=t.elements,r=s[0],a=s[4],o=s[8],c=s[1],l=s[5],h=s[9],u=s[2],d=s[6],f=s[10];switch(e){case"XYZ":this._y=Math.asin(oe(o,-1,1)),Math.abs(o)<.9999999?(this._x=Math.atan2(-h,f),this._z=Math.atan2(-a,r)):(this._x=Math.atan2(d,l),this._z=0);break;case"YXZ":this._x=Math.asin(-oe(h,-1,1)),Math.abs(h)<.9999999?(this._y=Math.atan2(o,f),this._z=Math.atan2(c,l)):(this._y=Math.atan2(-u,r),this._z=0);break;case"ZXY":this._x=Math.asin(oe(d,-1,1)),Math.abs(d)<.9999999?(this._y=Math.atan2(-u,f),this._z=Math.atan2(-a,l)):(this._y=0,this._z=Math.atan2(c,r));break;case"ZYX":this._y=Math.asin(-oe(u,-1,1)),Math.abs(u)<.9999999?(this._x=Math.atan2(d,f),this._z=Math.atan2(c,r)):(this._x=0,this._z=Math.atan2(-a,l));break;case"YZX":this._z=Math.asin(oe(c,-1,1)),Math.abs(c)<.9999999?(this._x=Math.atan2(-h,l),this._y=Math.atan2(-u,r)):(this._x=0,this._y=Math.atan2(o,f));break;case"XZY":this._z=Math.asin(-oe(a,-1,1)),Math.abs(a)<.9999999?(this._x=Math.atan2(d,l),this._y=Math.atan2(o,r)):(this._x=Math.atan2(-h,f),this._y=0);break;default:te("Euler: .setFromRotationMatrix() encountered an unknown order: "+e)}return this._order=e,i===!0&&this._onChangeCallback(),this}setFromQuaternion(t,e,i){return gf.makeRotationFromQuaternion(t),this.setFromRotationMatrix(gf,e,i)}setFromVector3(t,e=this._order){return this.set(t.x,t.y,t.z,e)}reorder(t){return xf.setFromEuler(this),this.setFromQuaternion(xf,t)}equals(t){return t._x===this._x&&t._y===this._y&&t._z===this._z&&t._order===this._order}fromArray(t){return this._x=t[0],this._y=t[1],this._z=t[2],t[3]!==void 0&&(this._order=t[3]),this._onChangeCallback(),this}toArray(t=[],e=0){return t[e]=this._x,t[e+1]=this._y,t[e+2]=this._z,t[e+3]=this._order,t}_onChange(t){return this._onChangeCallback=t,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._order}};Ai.DEFAULT_ORDER="XYZ";var fr=class{constructor(){this.mask=1}set(t){this.mask=(1<<t|0)>>>0}enable(t){this.mask|=1<<t|0}enableAll(){this.mask=-1}toggle(t){this.mask^=1<<t|0}disable(t){this.mask&=~(1<<t|0)}disableAll(){this.mask=0}test(t){return(this.mask&t.mask)!==0}isEnabled(t){return(this.mask&(1<<t|0))!==0}},Hm=0,vf=new D,Ws=new Ei,An=new me,Bo=new D,na=new D,Gm=new D,Vm=new Ei,yf=new D(1,0,0),_f=new D(0,1,0),bf=new D(0,0,1),Mf={type:"added"},Wm={type:"removed"},Xs={type:"childadded",child:null},Zh={type:"childremoved",child:null},Ze=class n extends yn{constructor(){super(),this.isObject3D=!0,Object.defineProperty(this,"id",{value:Hm++}),this.uuid=xn(),this.name="",this.type="Object3D",this.parent=null,this.children=[],this.up=n.DEFAULT_UP.clone();let t=new D,e=new Ai,i=new Ei,s=new D(1,1,1);function r(){i.setFromEuler(e,!1)}function a(){e.setFromQuaternion(i,void 0,!1)}e._onChange(r),i._onChange(a),Object.defineProperties(this,{position:{configurable:!0,enumerable:!0,value:t},rotation:{configurable:!0,enumerable:!0,value:e},quaternion:{configurable:!0,enumerable:!0,value:i},scale:{configurable:!0,enumerable:!0,value:s},modelViewMatrix:{value:new me},normalMatrix:{value:new ie}}),this.matrix=new me,this.matrixWorld=new me,this.matrixAutoUpdate=n.DEFAULT_MATRIX_AUTO_UPDATE,this.matrixWorldAutoUpdate=n.DEFAULT_MATRIX_WORLD_AUTO_UPDATE,this.matrixWorldNeedsUpdate=!1,this.layers=new fr,this.visible=!0,this.castShadow=!1,this.receiveShadow=!1,this.frustumCulled=!0,this.renderOrder=0,this.animations=[],this.customDepthMaterial=void 0,this.customDistanceMaterial=void 0,this.static=!1,this.userData={},this.pivot=null}onBeforeShadow(){}onAfterShadow(){}onBeforeRender(){}onAfterRender(){}applyMatrix4(t){this.matrixAutoUpdate&&this.updateMatrix(),this.matrix.premultiply(t),this.matrix.decompose(this.position,this.quaternion,this.scale)}applyQuaternion(t){return this.quaternion.premultiply(t),this}setRotationFromAxisAngle(t,e){this.quaternion.setFromAxisAngle(t,e)}setRotationFromEuler(t){this.quaternion.setFromEuler(t,!0)}setRotationFromMatrix(t){this.quaternion.setFromRotationMatrix(t)}setRotationFromQuaternion(t){this.quaternion.copy(t)}rotateOnAxis(t,e){return Ws.setFromAxisAngle(t,e),this.quaternion.multiply(Ws),this}rotateOnWorldAxis(t,e){return Ws.setFromAxisAngle(t,e),this.quaternion.premultiply(Ws),this}rotateX(t){return this.rotateOnAxis(yf,t)}rotateY(t){return this.rotateOnAxis(_f,t)}rotateZ(t){return this.rotateOnAxis(bf,t)}translateOnAxis(t,e){return vf.copy(t).applyQuaternion(this.quaternion),this.position.add(vf.multiplyScalar(e)),this}translateX(t){return this.translateOnAxis(yf,t)}translateY(t){return this.translateOnAxis(_f,t)}translateZ(t){return this.translateOnAxis(bf,t)}localToWorld(t){return this.updateWorldMatrix(!0,!1),t.applyMatrix4(this.matrixWorld)}worldToLocal(t){return this.updateWorldMatrix(!0,!1),t.applyMatrix4(An.copy(this.matrixWorld).invert())}lookAt(t,e,i){t.isVector3?Bo.copy(t):Bo.set(t,e,i);let s=this.parent;this.updateWorldMatrix(!0,!1),na.setFromMatrixPosition(this.matrixWorld),this.isCamera||this.isLight?An.lookAt(na,Bo,this.up):An.lookAt(Bo,na,this.up),this.quaternion.setFromRotationMatrix(An),s&&(An.extractRotation(s.matrixWorld),Ws.setFromRotationMatrix(An),this.quaternion.premultiply(Ws.invert()))}add(t){if(arguments.length>1){for(let e=0;e<arguments.length;e++)this.add(arguments[e]);return this}return t===this?(ee("Object3D.add: object can't be added as a child of itself.",t),this):(t&&t.isObject3D?(t.removeFromParent(),t.parent=this,this.children.push(t),t.dispatchEvent(Mf),Xs.child=t,this.dispatchEvent(Xs),Xs.child=null):ee("Object3D.add: object not an instance of THREE.Object3D.",t),this)}remove(t){if(arguments.length>1){for(let i=0;i<arguments.length;i++)this.remove(arguments[i]);return this}let e=this.children.indexOf(t);return e!==-1&&(t.parent=null,this.children.splice(e,1),t.dispatchEvent(Wm),Zh.child=t,this.dispatchEvent(Zh),Zh.child=null),this}removeFromParent(){let t=this.parent;return t!==null&&t.remove(this),this}clear(){return this.remove(...this.children)}attach(t){return this.updateWorldMatrix(!0,!1),An.copy(this.matrixWorld).invert(),t.parent!==null&&(t.parent.updateWorldMatrix(!0,!1),An.multiply(t.parent.matrixWorld)),t.applyMatrix4(An),t.removeFromParent(),t.parent=this,this.children.push(t),t.updateWorldMatrix(!1,!0),t.dispatchEvent(Mf),Xs.child=t,this.dispatchEvent(Xs),Xs.child=null,this}getObjectById(t){return this.getObjectByProperty("id",t)}getObjectByName(t){return this.getObjectByProperty("name",t)}getObjectByProperty(t,e){if(this[t]===e)return this;for(let i=0,s=this.children.length;i<s;i++){let a=this.children[i].getObjectByProperty(t,e);if(a!==void 0)return a}}getObjectsByProperty(t,e,i=[]){this[t]===e&&i.push(this);let s=this.children;for(let r=0,a=s.length;r<a;r++)s[r].getObjectsByProperty(t,e,i);return i}getWorldPosition(t){return this.updateWorldMatrix(!0,!1),t.setFromMatrixPosition(this.matrixWorld)}getWorldQuaternion(t){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(na,t,Gm),t}getWorldScale(t){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(na,Vm,t),t}getWorldDirection(t){this.updateWorldMatrix(!0,!1);let e=this.matrixWorld.elements;return t.set(e[8],e[9],e[10]).normalize()}raycast(){}intersectsFrustum(){}traverse(t){t(this);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].traverse(t)}traverseVisible(t){if(this.visible===!1)return;t(this);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].traverseVisible(t)}traverseAncestors(t){let e=this.parent;e!==null&&(t(e),e.traverseAncestors(t))}updateMatrix(){this.matrix.compose(this.position,this.quaternion,this.scale);let t=this.pivot;if(t!==null){let e=t.x,i=t.y,s=t.z,r=this.matrix.elements;r[12]+=e-r[0]*e-r[4]*i-r[8]*s,r[13]+=i-r[1]*e-r[5]*i-r[9]*s,r[14]+=s-r[2]*e-r[6]*i-r[10]*s}this.matrixWorldNeedsUpdate=!0}updateMatrixWorld(t){this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||t)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,t=!0);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].updateMatrixWorld(t)}updateWorldMatrix(t,e,i=!1){let s=this.parent;if(t===!0&&s!==null&&s.updateWorldMatrix(!0,!1),this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||i)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,i=!0),e===!0){let r=this.children;for(let a=0,o=r.length;a<o;a++)r[a].updateWorldMatrix(!1,!0,i)}}toJSON(t){let e=t===void 0||typeof t=="string",i={};e&&(t={geometries:{},materials:{},textures:{},images:{},shapes:{},skeletons:{},animations:{},nodes:{}},i.metadata={version:4.7,type:"Object",generator:"Object3D.toJSON"});let s={};s.uuid=this.uuid,s.type=this.type,s.name=this.name,s.castShadow=this.castShadow,s.receiveShadow=this.receiveShadow,s.visible=this.visible,s.frustumCulled=this.frustumCulled,s.renderOrder=this.renderOrder,s.static=this.static,s.matrixAutoUpdate=this.matrixAutoUpdate,Object.keys(this.userData).length>0&&(s.userData=this.userData),s.layers=this.layers.mask,s.matrix=this.matrix.toArray(),s.up=this.up.toArray(),this.pivot!==null&&(s.pivot=this.pivot.toArray()),this.morphTargetDictionary!==void 0&&(s.morphTargetDictionary=Object.assign({},this.morphTargetDictionary)),this.morphTargetInfluences!==void 0&&(s.morphTargetInfluences=this.morphTargetInfluences.slice()),this.isInstancedMesh&&(s.type="InstancedMesh",s.count=this.count,s.instanceMatrix=this.instanceMatrix.toJSON(),this.instanceColor!==null&&(s.instanceColor=this.instanceColor.toJSON())),this.isBatchedMesh&&(s.type="BatchedMesh",s.perObjectFrustumCulled=this.perObjectFrustumCulled,s.sortObjects=this.sortObjects,s.drawRanges=this._drawRanges,s.reservedRanges=this._reservedRanges,s.geometryInfo=this._geometryInfo.map(o=>({...o,boundingBox:o.boundingBox?o.boundingBox.toJSON():void 0,boundingSphere:o.boundingSphere?o.boundingSphere.toJSON():void 0})),s.instanceInfo=this._instanceInfo.map(o=>({...o})),s.availableInstanceIds=this._availableInstanceIds.slice(),s.availableGeometryIds=this._availableGeometryIds.slice(),s.nextIndexStart=this._nextIndexStart,s.nextVertexStart=this._nextVertexStart,s.geometryCount=this._geometryCount,s.maxInstanceCount=this._maxInstanceCount,s.maxVertexCount=this._maxVertexCount,s.maxIndexCount=this._maxIndexCount,s.geometryInitialized=this._geometryInitialized,s.matricesTexture=this._matricesTexture.toJSON(t),s.indirectTexture=this._indirectTexture.toJSON(t),this._colorsTexture!==null&&(s.colorsTexture=this._colorsTexture.toJSON(t)),this.boundingSphere!==null&&(s.boundingSphere=this.boundingSphere.toJSON()),this.boundingBox!==null&&(s.boundingBox=this.boundingBox.toJSON()));function r(o,c){return o[c.uuid]===void 0&&(o[c.uuid]=c.toJSON(t)),c.uuid}if(this.isScene)this.background&&(this.background.isColor?s.background=this.background.toJSON():this.background.isTexture&&(s.background=this.background.toJSON(t).uuid)),this.environment&&this.environment.isTexture&&this.environment.isRenderTargetTexture!==!0&&(s.environment=this.environment.toJSON(t).uuid);else if(this.isMesh||this.isLine||this.isPoints){s.geometry=r(t.geometries,this.geometry);let o=this.geometry.parameters;if(o!==void 0&&o.shapes!==void 0){let c=o.shapes;if(Array.isArray(c))for(let l=0,h=c.length;l<h;l++){let u=c[l];r(t.shapes,u)}else r(t.shapes,c)}}if(this.isSkinnedMesh&&(s.bindMode=this.bindMode,s.bindMatrix=this.bindMatrix.toArray(),this.skeleton!==void 0&&(r(t.skeletons,this.skeleton),s.skeleton=this.skeleton.uuid)),this.material!==void 0)if(Array.isArray(this.material)){let o=[];for(let c=0,l=this.material.length;c<l;c++)o.push(r(t.materials,this.material[c]));s.material=o}else s.material=r(t.materials,this.material);if(this.children.length>0){s.children=[];for(let o=0;o<this.children.length;o++)s.children.push(this.children[o].toJSON(t).object)}if(this.animations.length>0){s.animations=[];for(let o=0;o<this.animations.length;o++){let c=this.animations[o];s.animations.push(r(t.animations,c))}}if(e){let o=a(t.geometries),c=a(t.materials),l=a(t.textures),h=a(t.images),u=a(t.shapes),d=a(t.skeletons),f=a(t.animations),p=a(t.nodes);o.length>0&&(i.geometries=o),c.length>0&&(i.materials=c),l.length>0&&(i.textures=l),h.length>0&&(i.images=h),u.length>0&&(i.shapes=u),d.length>0&&(i.skeletons=d),f.length>0&&(i.animations=f),p.length>0&&(i.nodes=p)}return i.object=s,i;function a(o){let c=[];for(let l in o){let h=o[l];delete h.metadata,c.push(h)}return c}}clone(t){return new this.constructor().copy(this,t)}copy(t,e=!0){if(this.name=t.name,this.up.copy(t.up),this.position.copy(t.position),this.rotation.order=t.rotation.order,this.quaternion.copy(t.quaternion),this.scale.copy(t.scale),this.pivot=t.pivot!==null?t.pivot.clone():null,this.matrix.copy(t.matrix),this.matrixWorld.copy(t.matrixWorld),this.matrixAutoUpdate=t.matrixAutoUpdate,this.matrixWorldAutoUpdate=t.matrixWorldAutoUpdate,this.matrixWorldNeedsUpdate=t.matrixWorldNeedsUpdate,this.layers.mask=t.layers.mask,this.visible=t.visible,this.castShadow=t.castShadow,this.receiveShadow=t.receiveShadow,this.frustumCulled=t.frustumCulled,this.renderOrder=t.renderOrder,this.static=t.static,this.animations=t.animations.slice(),this.userData=JSON.parse(JSON.stringify(t.userData)),e===!0)for(let i=0;i<t.children.length;i++){let s=t.children[i];this.add(s.clone())}return this}dispose(){this.dispatchEvent({type:"dispose"})}};Ze.DEFAULT_UP=new D(0,1,0);Ze.DEFAULT_MATRIX_AUTO_UPDATE=!0;Ze.DEFAULT_MATRIX_WORLD_AUTO_UPDATE=!0;var xe=class extends Ze{constructor(){super(),this.isGroup=!0,this.type="Group"}},Xm={type:"move"},pr=class{constructor(){this._targetRay=null,this._grip=null,this._hand=null}getHandSpace(){return this._hand===null&&(this._hand=new xe,this._hand.matrixAutoUpdate=!1,this._hand.visible=!1,this._hand.joints={},this._hand.inputState={pinching:!1}),this._hand}getTargetRaySpace(){return this._targetRay===null&&(this._targetRay=new xe,this._targetRay.matrixAutoUpdate=!1,this._targetRay.visible=!1,this._targetRay.hasLinearVelocity=!1,this._targetRay.linearVelocity=new D,this._targetRay.hasAngularVelocity=!1,this._targetRay.angularVelocity=new D),this._targetRay}getGripSpace(){return this._grip===null&&(this._grip=new xe,this._grip.matrixAutoUpdate=!1,this._grip.visible=!1,this._grip.hasLinearVelocity=!1,this._grip.linearVelocity=new D,this._grip.hasAngularVelocity=!1,this._grip.angularVelocity=new D,this._grip.eventsEnabled=!1),this._grip}dispatchEvent(t){return this._targetRay!==null&&this._targetRay.dispatchEvent(t),this._grip!==null&&this._grip.dispatchEvent(t),this._hand!==null&&this._hand.dispatchEvent(t),this}connect(t){if(t&&t.hand){let e=this._hand;if(e)for(let i of t.hand.values())this._getHandJoint(e,i)}return this.dispatchEvent({type:"connected",data:t}),this}disconnect(t){return this.dispatchEvent({type:"disconnected",data:t}),this._targetRay!==null&&(this._targetRay.visible=!1),this._grip!==null&&(this._grip.visible=!1),this._hand!==null&&(this._hand.visible=!1),this}update(t,e,i){let s=null,r=null,a=null,o=this._targetRay,c=this._grip,l=this._hand;if(t&&e.session.visibilityState!=="visible-blurred"){if(l&&t.hand){a=!0;for(let x of t.hand.values()){let m=e.getJointPose(x,i),g=this._getHandJoint(l,x);m!==null&&(g.matrix.fromArray(m.transform.matrix),g.matrix.decompose(g.position,g.rotation,g.scale),g.matrixWorldNeedsUpdate=!0,g.jointRadius=m.radius),g.visible=m!==null}let h=l.joints["index-finger-tip"],u=l.joints["thumb-tip"],d=h.position.distanceTo(u.position),f=.02,p=.005;l.inputState.pinching&&d>f+p?(l.inputState.pinching=!1,this.dispatchEvent({type:"pinchend",handedness:t.handedness,target:this})):!l.inputState.pinching&&d<=f-p&&(l.inputState.pinching=!0,this.dispatchEvent({type:"pinchstart",handedness:t.handedness,target:this}))}else c!==null&&t.gripSpace&&(r=e.getPose(t.gripSpace,i),r!==null&&(c.matrix.fromArray(r.transform.matrix),c.matrix.decompose(c.position,c.rotation,c.scale),c.matrixWorldNeedsUpdate=!0,r.linearVelocity?(c.hasLinearVelocity=!0,c.linearVelocity.copy(r.linearVelocity)):c.hasLinearVelocity=!1,r.angularVelocity?(c.hasAngularVelocity=!0,c.angularVelocity.copy(r.angularVelocity)):c.hasAngularVelocity=!1,c.eventsEnabled&&c.dispatchEvent({type:"gripUpdated",data:t,target:this})));o!==null&&(s=e.getPose(t.targetRaySpace,i),s===null&&r!==null&&(s=r),s!==null&&(o.matrix.fromArray(s.transform.matrix),o.matrix.decompose(o.position,o.rotation,o.scale),o.matrixWorldNeedsUpdate=!0,s.linearVelocity?(o.hasLinearVelocity=!0,o.linearVelocity.copy(s.linearVelocity)):o.hasLinearVelocity=!1,s.angularVelocity?(o.hasAngularVelocity=!0,o.angularVelocity.copy(s.angularVelocity)):o.hasAngularVelocity=!1,this.dispatchEvent(Xm)))}return o!==null&&(o.visible=s!==null),c!==null&&(c.visible=r!==null),l!==null&&(l.visible=a!==null),this}_getHandJoint(t,e){if(t.joints[e.jointName]===void 0){let i=new xe;i.matrixAutoUpdate=!1,i.visible=!1,t.joints[e.jointName]=i,t.add(i)}return t.joints[e.jointName]}},N0={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074},$n={h:0,s:0,l:0},Ho={h:0,s:0,l:0};function Jh(n,t,e){return e<0&&(e+=1),e>1&&(e-=1),e<1/6?n+(t-n)*6*e:e<1/2?t:e<2/3?n+(t-n)*6*(2/3-e):n}var Nt=class{constructor(t,e,i){return this.isColor=!0,this.r=1,this.g=1,this.b=1,this.set(t,e,i)}set(t,e,i){if(e===void 0&&i===void 0){let s=t;s&&s.isColor?this.copy(s):typeof s=="number"?this.setHex(s):typeof s=="string"&&this.setStyle(s)}else this.setRGB(t,e,i);return this}setScalar(t){return this.r=t,this.g=t,this.b=t,this}setHex(t,e=Oe){return t=Math.floor(t),this.r=(t>>16&255)/255,this.g=(t>>8&255)/255,this.b=(t&255)/255,he.colorSpaceToWorking(this,e),this}setRGB(t,e,i,s=he.workingColorSpace){return this.r=t,this.g=e,this.b=i,he.colorSpaceToWorking(this,s),this}setHSL(t,e,i,s=he.workingColorSpace){if(t=Xu(t,1),e=oe(e,0,1),i=oe(i,0,1),e===0)this.r=this.g=this.b=i;else{let r=i<=.5?i*(1+e):i+e-i*e,a=2*i-r;this.r=Jh(a,r,t+1/3),this.g=Jh(a,r,t),this.b=Jh(a,r,t-1/3)}return he.colorSpaceToWorking(this,s),this}setStyle(t,e=Oe){function i(r){r!==void 0&&parseFloat(r)<1&&te("Color: Alpha component of "+t+" will be ignored.")}let s;if(s=/^(\w+)\(([^\)]*)\)/.exec(t)){let r,a=s[1],o=s[2];switch(a){case"rgb":case"rgba":if(r=/^\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setRGB(Math.min(255,parseInt(r[1],10))/255,Math.min(255,parseInt(r[2],10))/255,Math.min(255,parseInt(r[3],10))/255,e);if(r=/^\s*(\d+)\%\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setRGB(Math.min(100,parseInt(r[1],10))/100,Math.min(100,parseInt(r[2],10))/100,Math.min(100,parseInt(r[3],10))/100,e);break;case"hsl":case"hsla":if(r=/^\s*(\d*\.?\d+)\s*,\s*(\d*\.?\d+)\%\s*,\s*(\d*\.?\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setHSL(parseFloat(r[1])/360,parseFloat(r[2])/100,parseFloat(r[3])/100,e);break;default:te("Color: Unknown color model "+t)}}else if(s=/^\#([A-Fa-f\d]+)$/.exec(t)){let r=s[1],a=r.length;if(a===3)return this.setRGB(parseInt(r.charAt(0),16)/15,parseInt(r.charAt(1),16)/15,parseInt(r.charAt(2),16)/15,e);if(a===6)return this.setHex(parseInt(r,16),e);te("Color: Invalid hex color "+t)}else if(t&&t.length>0)return this.setColorName(t,e);return this}setColorName(t,e=Oe){let i=N0[t.toLowerCase()];return i!==void 0?this.setHex(i,e):te("Color: Unknown color "+t),this}clone(){return new this.constructor(this.r,this.g,this.b)}copy(t){return this.r=t.r,this.g=t.g,this.b=t.b,this}copySRGBToLinear(t){return this.r=Dn(t.r),this.g=Dn(t.g),this.b=Dn(t.b),this}copyLinearToSRGB(t){return this.r=ar(t.r),this.g=ar(t.g),this.b=ar(t.b),this}convertSRGBToLinear(){return this.copySRGBToLinear(this),this}convertLinearToSRGB(){return this.copyLinearToSRGB(this),this}getHex(t=Oe){return he.workingToColorSpace(gi.copy(this),t),Math.round(oe(gi.r*255,0,255))*65536+Math.round(oe(gi.g*255,0,255))*256+Math.round(oe(gi.b*255,0,255))}getHexString(t=Oe){return("000000"+this.getHex(t).toString(16)).slice(-6)}getHSL(t,e=he.workingColorSpace){he.workingToColorSpace(gi.copy(this),e);let i=gi.r,s=gi.g,r=gi.b,a=Math.max(i,s,r),o=Math.min(i,s,r),c,l,h=(o+a)/2;if(o===a)c=0,l=0;else{let u=a-o;switch(l=h<=.5?u/(a+o):u/(2-a-o),a){case i:c=(s-r)/u+(s<r?6:0);break;case s:c=(r-i)/u+2;break;case r:c=(i-s)/u+4;break}c/=6}return t.h=c,t.s=l,t.l=h,t}getRGB(t,e=he.workingColorSpace){return he.workingToColorSpace(gi.copy(this),e),t.r=gi.r,t.g=gi.g,t.b=gi.b,t}getStyle(t=Oe){he.workingToColorSpace(gi.copy(this),t);let e=gi.r,i=gi.g,s=gi.b;return t!==Oe?`color(${t} ${e.toFixed(3)} ${i.toFixed(3)} ${s.toFixed(3)})`:`rgb(${Math.round(e*255)},${Math.round(i*255)},${Math.round(s*255)})`}offsetHSL(t,e,i){return this.getHSL($n),this.setHSL($n.h+t,$n.s+e,$n.l+i)}add(t){return this.r+=t.r,this.g+=t.g,this.b+=t.b,this}addColors(t,e){return this.r=t.r+e.r,this.g=t.g+e.g,this.b=t.b+e.b,this}addScalar(t){return this.r+=t,this.g+=t,this.b+=t,this}sub(t){return this.r=Math.max(0,this.r-t.r),this.g=Math.max(0,this.g-t.g),this.b=Math.max(0,this.b-t.b),this}multiply(t){return this.r*=t.r,this.g*=t.g,this.b*=t.b,this}multiplyScalar(t){return this.r*=t,this.g*=t,this.b*=t,this}lerp(t,e){return this.r+=(t.r-this.r)*e,this.g+=(t.g-this.g)*e,this.b+=(t.b-this.b)*e,this}lerpColors(t,e,i){return this.r=t.r+(e.r-t.r)*i,this.g=t.g+(e.g-t.g)*i,this.b=t.b+(e.b-t.b)*i,this}lerpHSL(t,e){this.getHSL($n),t.getHSL(Ho);let i=ma($n.h,Ho.h,e),s=ma($n.s,Ho.s,e),r=ma($n.l,Ho.l,e);return this.setHSL(i,s,r),this}setFromVector3(t){return this.r=t.x,this.g=t.y,this.b=t.z,this}applyMatrix3(t){let e=this.r,i=this.g,s=this.b,r=t.elements;return this.r=r[0]*e+r[3]*i+r[6]*s,this.g=r[1]*e+r[4]*i+r[7]*s,this.b=r[2]*e+r[5]*i+r[8]*s,this}equals(t){return t.r===this.r&&t.g===this.g&&t.b===this.b}fromArray(t,e=0){return this.r=t[e],this.g=t[e+1],this.b=t[e+2],this}toArray(t=[],e=0){return t[e]=this.r,t[e+1]=this.g,t[e+2]=this.b,t}fromBufferAttribute(t,e){return this.r=t.getX(e),this.g=t.getY(e),this.b=t.getZ(e),this}toJSON(){return this.getHex()}*[Symbol.iterator](){yield this.r,yield this.g,yield this.b}},gi=new Nt;Nt.NAMES=N0;var wa=class n{constructor(t,e=25e-5){this.isFogExp2=!0,this.name="",this.color=new Nt(t),this.density=e}clone(){return new n(this.color,this.density)}toJSON(){return{type:"FogExp2",name:this.name,color:this.color.getHex(),density:this.density}}};var Kn=class extends Ze{constructor(){super(),this.isScene=!0,this.type="Scene",this.background=null,this.environment=null,this.fog=null,this.backgroundBlurriness=0,this.backgroundIntensity=1,this.backgroundRotation=new Ai,this.environmentIntensity=1,this.environmentRotation=new Ai,this.overrideMaterial=null,typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}copy(t,e){return super.copy(t,e),t.background!==null&&(this.background=t.background.clone()),t.environment!==null&&(this.environment=t.environment.clone()),t.fog!==null&&(this.fog=t.fog.clone()),this.backgroundBlurriness=t.backgroundBlurriness,this.backgroundIntensity=t.backgroundIntensity,this.backgroundRotation.copy(t.backgroundRotation),this.environmentIntensity=t.environmentIntensity,this.environmentRotation.copy(t.environmentRotation),t.overrideMaterial!==null&&(this.overrideMaterial=t.overrideMaterial.clone()),this.matrixAutoUpdate=t.matrixAutoUpdate,this}toJSON(t){let e=super.toJSON(t);return this.fog!==null&&(e.object.fog=this.fog.toJSON()),e.object.backgroundBlurriness=this.backgroundBlurriness,e.object.backgroundIntensity=this.backgroundIntensity,e.object.backgroundRotation=this.backgroundRotation.toArray(),e.object.environmentIntensity=this.environmentIntensity,e.object.environmentRotation=this.environmentRotation.toArray(),e}},nn=new D,Rn=new D,Kh=new D,Cn=new D,qs=new D,$s=new D,Sf=new D,jh=new D,Qh=new D,tu=new D,eu=new Le,iu=new Le,nu=new Le,Ln=class n{constructor(t=new D,e=new D,i=new D){this.a=t,this.b=e,this.c=i}static getNormal(t,e,i,s){s.subVectors(i,e),nn.subVectors(t,e),s.cross(nn);let r=s.lengthSq();return r>0?s.multiplyScalar(1/Math.sqrt(r)):s.set(0,0,0)}static getBarycoord(t,e,i,s,r){nn.subVectors(s,e),Rn.subVectors(i,e),Kh.subVectors(t,e);let a=nn.dot(nn),o=nn.dot(Rn),c=nn.dot(Kh),l=Rn.dot(Rn),h=Rn.dot(Kh),u=a*l-o*o;if(u===0)return r.set(0,0,0),null;let d=1/u,f=(l*c-o*h)*d,p=(a*h-o*c)*d;return r.set(1-f-p,p,f)}static containsPoint(t,e,i,s){return this.getBarycoord(t,e,i,s,Cn)===null?!1:Cn.x>=0&&Cn.y>=0&&Cn.x+Cn.y<=1}static getInterpolation(t,e,i,s,r,a,o,c){return this.getBarycoord(t,e,i,s,Cn)===null?(c.x=0,c.y=0,"z"in c&&(c.z=0),"w"in c&&(c.w=0),null):(c.setScalar(0),c.addScaledVector(r,Cn.x),c.addScaledVector(a,Cn.y),c.addScaledVector(o,Cn.z),c)}static getInterpolatedAttribute(t,e,i,s,r,a){return eu.setScalar(0),iu.setScalar(0),nu.setScalar(0),eu.fromBufferAttribute(t,e),iu.fromBufferAttribute(t,i),nu.fromBufferAttribute(t,s),a.setScalar(0),a.addScaledVector(eu,r.x),a.addScaledVector(iu,r.y),a.addScaledVector(nu,r.z),a}static isFrontFacing(t,e,i,s){return nn.subVectors(i,e),Rn.subVectors(t,e),nn.cross(Rn).dot(s)<0}set(t,e,i){return this.a.copy(t),this.b.copy(e),this.c.copy(i),this}setFromPointsAndIndices(t,e,i,s){return this.a.copy(t[e]),this.b.copy(t[i]),this.c.copy(t[s]),this}setFromAttributeAndIndices(t,e,i,s){return this.a.fromBufferAttribute(t,e),this.b.fromBufferAttribute(t,i),this.c.fromBufferAttribute(t,s),this}clone(){return new this.constructor().copy(this)}copy(t){return this.a.copy(t.a),this.b.copy(t.b),this.c.copy(t.c),this}getArea(){return nn.subVectors(this.c,this.b),Rn.subVectors(this.a,this.b),nn.cross(Rn).length()*.5}getMidpoint(t){return t.addVectors(this.a,this.b).add(this.c).multiplyScalar(1/3)}getNormal(t){return n.getNormal(this.a,this.b,this.c,t)}getPlane(t){return t.setFromCoplanarPoints(this.a,this.b,this.c)}getBarycoord(t,e){return n.getBarycoord(t,this.a,this.b,this.c,e)}getInterpolation(t,e,i,s,r){return n.getInterpolation(t,this.a,this.b,this.c,e,i,s,r)}containsPoint(t){return n.containsPoint(t,this.a,this.b,this.c)}isFrontFacing(t){return n.isFrontFacing(this.a,this.b,this.c,t)}intersectsBox(t){return t.intersectsTriangle(this)}closestPointToPoint(t,e){let i=this.a,s=this.b,r=this.c,a,o;qs.subVectors(s,i),$s.subVectors(r,i),jh.subVectors(t,i);let c=qs.dot(jh),l=$s.dot(jh);if(c<=0&&l<=0)return e.copy(i);Qh.subVectors(t,s);let h=qs.dot(Qh),u=$s.dot(Qh);if(h>=0&&u<=h)return e.copy(s);let d=c*u-h*l;if(d<=0&&c>=0&&h<=0)return a=c/(c-h),e.copy(i).addScaledVector(qs,a);tu.subVectors(t,r);let f=qs.dot(tu),p=$s.dot(tu);if(p>=0&&f<=p)return e.copy(r);let x=f*l-c*p;if(x<=0&&l>=0&&p<=0)return o=l/(l-p),e.copy(i).addScaledVector($s,o);let m=h*p-f*u;if(m<=0&&u-h>=0&&f-p>=0)return Sf.subVectors(r,s),o=(u-h)/(u-h+(f-p)),e.copy(s).addScaledVector(Sf,o);let g=1/(m+x+d);return a=x*g,o=d*g,e.copy(i).addScaledVector(qs,a).addScaledVector($s,o)}equals(t){return t.a.equals(this.a)&&t.b.equals(this.b)&&t.c.equals(this.c)}},_n=class{constructor(t=new D(1/0,1/0,1/0),e=new D(-1/0,-1/0,-1/0)){this.isBox3=!0,this.min=t,this.max=e}set(t,e){return this.min.copy(t),this.max.copy(e),this}setFromArray(t){this.makeEmpty();for(let e=0,i=t.length;e<i;e+=3)this.expandByPoint(sn.fromArray(t,e));return this}setFromBufferAttribute(t){this.makeEmpty();for(let e=0,i=t.count;e<i;e++)this.expandByPoint(sn.fromBufferAttribute(t,e));return this}setFromPoints(t){this.makeEmpty();for(let e=0,i=t.length;e<i;e++)this.expandByPoint(t[e]);return this}setFromCenterAndSize(t,e){let i=sn.copy(e).multiplyScalar(.5);return this.min.copy(t).sub(i),this.max.copy(t).add(i),this}setFromObject(t,e=!1){return this.makeEmpty(),this.expandByObject(t,e)}clone(){return new this.constructor().copy(this)}copy(t){return this.min.copy(t.min),this.max.copy(t.max),this}makeEmpty(){return this.min.x=this.min.y=this.min.z=1/0,this.max.x=this.max.y=this.max.z=-1/0,this}isEmpty(){return this.max.x<this.min.x||this.max.y<this.min.y||this.max.z<this.min.z}getCenter(t){return this.isEmpty()?t.set(0,0,0):t.addVectors(this.min,this.max).multiplyScalar(.5)}getSize(t){return this.isEmpty()?t.set(0,0,0):t.subVectors(this.max,this.min)}expandByPoint(t){return this.min.min(t),this.max.max(t),this}expandByVector(t){return this.min.sub(t),this.max.add(t),this}expandByScalar(t){return this.min.addScalar(-t),this.max.addScalar(t),this}expandByObject(t,e=!1){t.updateWorldMatrix(!1,!1);let i=t.geometry;if(i!==void 0){let r=i.getAttribute("position");if(e===!0&&r!==void 0&&t.isInstancedMesh!==!0)for(let a=0,o=r.count;a<o;a++)t.isMesh===!0?t.getVertexPosition(a,sn):sn.fromBufferAttribute(r,a),sn.applyMatrix4(t.matrixWorld),this.expandByPoint(sn);else t.boundingBox!==void 0?(t.boundingBox===null&&t.computeBoundingBox(),Go.copy(t.boundingBox)):(i.boundingBox===null&&i.computeBoundingBox(),Go.copy(i.boundingBox)),Go.applyMatrix4(t.matrixWorld),this.union(Go)}let s=t.children;for(let r=0,a=s.length;r<a;r++)this.expandByObject(s[r],e);return this}containsPoint(t){return t.x>=this.min.x&&t.x<=this.max.x&&t.y>=this.min.y&&t.y<=this.max.y&&t.z>=this.min.z&&t.z<=this.max.z}containsBox(t){return this.min.x<=t.min.x&&t.max.x<=this.max.x&&this.min.y<=t.min.y&&t.max.y<=this.max.y&&this.min.z<=t.min.z&&t.max.z<=this.max.z}getParameter(t,e){return e.set((t.x-this.min.x)/(this.max.x-this.min.x),(t.y-this.min.y)/(this.max.y-this.min.y),(t.z-this.min.z)/(this.max.z-this.min.z))}intersectsBox(t){return t.max.x>=this.min.x&&t.min.x<=this.max.x&&t.max.y>=this.min.y&&t.min.y<=this.max.y&&t.max.z>=this.min.z&&t.min.z<=this.max.z}intersectsSphere(t){return this.clampPoint(t.center,sn),sn.distanceToSquared(t.center)<=t.radius*t.radius}intersectsPlane(t){let e,i;return t.normal.x>0?(e=t.normal.x*this.min.x,i=t.normal.x*this.max.x):(e=t.normal.x*this.max.x,i=t.normal.x*this.min.x),t.normal.y>0?(e+=t.normal.y*this.min.y,i+=t.normal.y*this.max.y):(e+=t.normal.y*this.max.y,i+=t.normal.y*this.min.y),t.normal.z>0?(e+=t.normal.z*this.min.z,i+=t.normal.z*this.max.z):(e+=t.normal.z*this.max.z,i+=t.normal.z*this.min.z),e<=-t.constant&&i>=-t.constant}intersectsTriangle(t){if(this.isEmpty())return!1;this.getCenter(sa),Vo.subVectors(this.max,sa),Ys.subVectors(t.a,sa),Zs.subVectors(t.b,sa),Js.subVectors(t.c,sa),Yn.subVectors(Zs,Ys),Zn.subVectors(Js,Zs),ys.subVectors(Ys,Js);let e=[0,-Yn.z,Yn.y,0,-Zn.z,Zn.y,0,-ys.z,ys.y,Yn.z,0,-Yn.x,Zn.z,0,-Zn.x,ys.z,0,-ys.x,-Yn.y,Yn.x,0,-Zn.y,Zn.x,0,-ys.y,ys.x,0];return!su(e,Ys,Zs,Js,Vo)||(e=[1,0,0,0,1,0,0,0,1],!su(e,Ys,Zs,Js,Vo))?!1:(Wo.crossVectors(Yn,Zn),e=[Wo.x,Wo.y,Wo.z],su(e,Ys,Zs,Js,Vo))}clampPoint(t,e){return e.copy(t).clamp(this.min,this.max)}distanceToPoint(t){return this.clampPoint(t,sn).distanceTo(t)}getBoundingSphere(t){return this.isEmpty()?t.makeEmpty():(this.getCenter(t.center),t.radius=this.getSize(sn).length()*.5),t}intersect(t){return this.min.max(t.min),this.max.min(t.max),this.isEmpty()&&this.makeEmpty(),this}union(t){return this.min.min(t.min),this.max.max(t.max),this}applyMatrix4(t){return this.isEmpty()?this:(Pn[0].set(this.min.x,this.min.y,this.min.z).applyMatrix4(t),Pn[1].set(this.min.x,this.min.y,this.max.z).applyMatrix4(t),Pn[2].set(this.min.x,this.max.y,this.min.z).applyMatrix4(t),Pn[3].set(this.min.x,this.max.y,this.max.z).applyMatrix4(t),Pn[4].set(this.max.x,this.min.y,this.min.z).applyMatrix4(t),Pn[5].set(this.max.x,this.min.y,this.max.z).applyMatrix4(t),Pn[6].set(this.max.x,this.max.y,this.min.z).applyMatrix4(t),Pn[7].set(this.max.x,this.max.y,this.max.z).applyMatrix4(t),this.setFromPoints(Pn),this)}translate(t){return this.min.add(t),this.max.add(t),this}equals(t){return t.min.equals(this.min)&&t.max.equals(this.max)}toJSON(){return{min:this.min.toArray(),max:this.max.toArray()}}fromJSON(t){return this.min.fromArray(t.min),this.max.fromArray(t.max),this}},Pn=[new D,new D,new D,new D,new D,new D,new D,new D],sn=new D,Go=new _n,Ys=new D,Zs=new D,Js=new D,Yn=new D,Zn=new D,ys=new D,sa=new D,Vo=new D,Wo=new D,_s=new D;function su(n,t,e,i,s){for(let r=0,a=n.length-3;r<=a;r+=3){_s.fromArray(n,r);let o=s.x*Math.abs(_s.x)+s.y*Math.abs(_s.y)+s.z*Math.abs(_s.z),c=t.dot(_s),l=e.dot(_s),h=i.dot(_s);if(Math.max(-Math.max(c,l,h),Math.min(c,l,h))>o)return!1}return!0}var Qe=new D,Xo=new ot,qm=0,ti=class extends yn{constructor(t,e,i=!1){if(super(),Array.isArray(t))throw new TypeError("THREE.BufferAttribute: array should be a Typed Array.");this.isBufferAttribute=!0,Object.defineProperty(this,"id",{value:qm++}),this.name="",this.array=t,this.itemSize=e,this.count=t!==void 0?t.length/e:0,this.normalized=i,this.usage=Vu,this.updateRanges=[],this.gpuType=Zi,this.version=0}onUploadCallback(){}set needsUpdate(t){t===!0&&this.version++}setUsage(t){return this.usage=t,this}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}copy(t){return this.name=t.name,this.array=new t.array.constructor(t.array),this.itemSize=t.itemSize,this.count=t.count,this.normalized=t.normalized,this.usage=t.usage,this.gpuType=t.gpuType,this}copyAt(t,e,i){t*=this.itemSize,i*=e.itemSize;for(let s=0,r=this.itemSize;s<r;s++)this.array[t+s]=e.array[i+s];return this}copyArray(t){return this.array.set(t),this}applyMatrix3(t){if(this.itemSize===2)for(let e=0,i=this.count;e<i;e++)Xo.fromBufferAttribute(this,e),Xo.applyMatrix3(t),this.setXY(e,Xo.x,Xo.y);else if(this.itemSize===3)for(let e=0,i=this.count;e<i;e++)Qe.fromBufferAttribute(this,e),Qe.applyMatrix3(t),this.setXYZ(e,Qe.x,Qe.y,Qe.z);return this}applyMatrix4(t){for(let e=0,i=this.count;e<i;e++)Qe.fromBufferAttribute(this,e),Qe.applyMatrix4(t),this.setXYZ(e,Qe.x,Qe.y,Qe.z);return this}applyNormalMatrix(t){for(let e=0,i=this.count;e<i;e++)Qe.fromBufferAttribute(this,e),Qe.applyNormalMatrix(t),this.setXYZ(e,Qe.x,Qe.y,Qe.z);return this}transformDirection(t){for(let e=0,i=this.count;e<i;e++)Qe.fromBufferAttribute(this,e),Qe.transformDirection(t),this.setXYZ(e,Qe.x,Qe.y,Qe.z);return this}set(t,e=0){return this.array.set(t,e),this}getComponent(t,e){let i=this.array[t*this.itemSize+e];return this.normalized&&(i=rn(i,this.array)),i}setComponent(t,e,i){return this.normalized&&(i=Te(i,this.array)),this.array[t*this.itemSize+e]=i,this}getX(t){let e=this.array[t*this.itemSize];return this.normalized&&(e=rn(e,this.array)),e}setX(t,e){return this.normalized&&(e=Te(e,this.array)),this.array[t*this.itemSize]=e,this}getY(t){let e=this.array[t*this.itemSize+1];return this.normalized&&(e=rn(e,this.array)),e}setY(t,e){return this.normalized&&(e=Te(e,this.array)),this.array[t*this.itemSize+1]=e,this}getZ(t){let e=this.array[t*this.itemSize+2];return this.normalized&&(e=rn(e,this.array)),e}setZ(t,e){return this.normalized&&(e=Te(e,this.array)),this.array[t*this.itemSize+2]=e,this}getW(t){let e=this.array[t*this.itemSize+3];return this.normalized&&(e=rn(e,this.array)),e}setW(t,e){return this.normalized&&(e=Te(e,this.array)),this.array[t*this.itemSize+3]=e,this}setXY(t,e,i){return t*=this.itemSize,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array)),this.array[t+0]=e,this.array[t+1]=i,this}setXYZ(t,e,i,s){return t*=this.itemSize,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array),s=Te(s,this.array)),this.array[t+0]=e,this.array[t+1]=i,this.array[t+2]=s,this}setXYZW(t,e,i,s,r){return t*=this.itemSize,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array),s=Te(s,this.array),r=Te(r,this.array)),this.array[t+0]=e,this.array[t+1]=i,this.array[t+2]=s,this.array[t+3]=r,this}onUpload(t){return this.onUploadCallback=t,this}clone(){return new this.constructor(this.array,this.itemSize).copy(this)}toJSON(){let t={itemSize:this.itemSize,type:this.array.constructor.name,array:Array.from(this.array),normalized:this.normalized};return t.name=this.name,t.usage=this.usage,t.gpuType=this.gpuType,t}dispose(){this.dispatchEvent({type:"dispose"})}};var Ta=class extends ti{constructor(t,e,i){super(new Uint16Array(t),e,i)}};var Ea=class extends ti{constructor(t,e,i){super(new Uint32Array(t),e,i)}};var qt=class extends ti{constructor(t,e,i){super(new Float32Array(t),e,i)}},$m=new _n,ra=new D,ru=new D,Xi=class{constructor(t=new D,e=-1){this.isSphere=!0,this.center=t,this.radius=e}set(t,e){return this.center.copy(t),this.radius=e,this}setFromPoints(t,e){let i=this.center;e!==void 0?i.copy(e):$m.setFromPoints(t).getCenter(i);let s=0;for(let r=0,a=t.length;r<a;r++)s=Math.max(s,i.distanceToSquared(t[r]));return this.radius=Math.sqrt(s),this}copy(t){return this.center.copy(t.center),this.radius=t.radius,this}isEmpty(){return this.radius<0}makeEmpty(){return this.center.set(0,0,0),this.radius=-1,this}containsPoint(t){return t.distanceToSquared(this.center)<=this.radius*this.radius}distanceToPoint(t){return t.distanceTo(this.center)-this.radius}intersectsSphere(t){let e=this.radius+t.radius;return t.center.distanceToSquared(this.center)<=e*e}intersectsBox(t){return t.intersectsSphere(this)}intersectsPlane(t){return Math.abs(t.distanceToPoint(this.center))<=this.radius}clampPoint(t,e){let i=this.center.distanceToSquared(t);return e.copy(t),i>this.radius*this.radius&&(e.sub(this.center).normalize(),e.multiplyScalar(this.radius).add(this.center)),e}getBoundingBox(t){return this.isEmpty()?(t.makeEmpty(),t):(t.set(this.center,this.center),t.expandByScalar(this.radius),t)}applyMatrix4(t){return this.center.applyMatrix4(t),this.radius=this.radius*t.getMaxScaleOnAxis(),this}translate(t){return this.center.add(t),this}expandByPoint(t){if(this.isEmpty())return this.center.copy(t),this.radius=0,this;ra.subVectors(t,this.center);let e=ra.lengthSq();if(e>this.radius*this.radius){let i=Math.sqrt(e),s=(i-this.radius)*.5;this.center.addScaledVector(ra,s/i),this.radius+=s}return this}union(t){return t.isEmpty()?this:this.isEmpty()?(this.copy(t),this):(this.center.equals(t.center)===!0?this.radius=Math.max(this.radius,t.radius):(ru.subVectors(t.center,this.center).setLength(t.radius),this.expandByPoint(ra.copy(t.center).add(ru)),this.expandByPoint(ra.copy(t.center).sub(ru))),this)}equals(t){return t.center.equals(this.center)&&t.radius===this.radius}clone(){return new this.constructor().copy(this)}toJSON(){return{radius:this.radius,center:this.center.toArray()}}fromJSON(t){return this.radius=t.radius,this.center.fromArray(t.center),this}},Ym=0,Wi=new me,au=new Ze,Ks=new D,Ni=new _n,aa=new _n,ai=new D,ge=class n extends yn{constructor(){super(),this.isBufferGeometry=!0,Object.defineProperty(this,"id",{value:Ym++}),this.uuid=xn(),this.name="",this.type="BufferGeometry",this.index=null,this.indirect=null,this.indirectOffset=0,this.attributes={},this.morphAttributes={},this.morphTargetsRelative=!1,this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.drawRange={start:0,count:1/0},this.userData={},this._transformed=!1}getIndex(){return this.index}setIndex(t){return Array.isArray(t)?this.index=new(vm(t)?Ea:Ta)(t,1):this.index=t,this}setIndirect(t,e=0){return this.indirect=t,this.indirectOffset=e,this}getIndirect(){return this.indirect}getAttribute(t){return this.attributes[t]}setAttribute(t,e){return this.attributes[t]=e,this}deleteAttribute(t){return delete this.attributes[t],this}hasAttribute(t){return this.attributes[t]!==void 0}addGroup(t,e,i=0){this.groups.push({start:t,count:e,materialIndex:i})}clearGroups(){this.groups=[]}setDrawRange(t,e){this.drawRange.start=t,this.drawRange.count=e}applyMatrix4(t){let e=this.attributes.position;e!==void 0&&(e.applyMatrix4(t),e.needsUpdate=!0);let i=this.attributes.normal;if(i!==void 0){let r=new ie().getNormalMatrix(t);i.applyNormalMatrix(r),i.needsUpdate=!0}let s=this.attributes.tangent;return s!==void 0&&(s.transformDirection(t),s.needsUpdate=!0),this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this._transformed=!0,this}applyQuaternion(t){return Wi.makeRotationFromQuaternion(t),this.applyMatrix4(Wi),this}rotateX(t){return Wi.makeRotationX(t),this.applyMatrix4(Wi),this}rotateY(t){return Wi.makeRotationY(t),this.applyMatrix4(Wi),this}rotateZ(t){return Wi.makeRotationZ(t),this.applyMatrix4(Wi),this}translate(t,e,i){return Wi.makeTranslation(t,e,i),this.applyMatrix4(Wi),this}scale(t,e,i){return Wi.makeScale(t,e,i),this.applyMatrix4(Wi),this}lookAt(t){return au.lookAt(t),au.updateMatrix(),this.applyMatrix4(au.matrix),this}center(){return this.computeBoundingBox(),this.boundingBox.getCenter(Ks).negate(),this.translate(Ks.x,Ks.y,Ks.z),this}setFromPoints(t){let e=this.getAttribute("position");if(e===void 0){let i=[];for(let s=0,r=t.length;s<r;s++){let a=t[s];i.push(a.x,a.y,a.z||0)}this.setAttribute("position",new qt(i,3))}else{let i=Math.min(t.length,e.count);for(let s=0;s<i;s++){let r=t[s];e.setXYZ(s,r.x,r.y,r.z||0)}t.length>e.count&&te("BufferGeometry: Buffer size too small for points data. Use .dispose() and create a new geometry."),e.needsUpdate=!0}return this}computeBoundingBox(){this.boundingBox===null&&(this.boundingBox=new _n);let t=this.attributes.position,e=this.morphAttributes.position;if(t&&t.isGLBufferAttribute){ee("BufferGeometry.computeBoundingBox(): GLBufferAttribute requires a manual bounding box.",this),this.boundingBox.set(new D(-1/0,-1/0,-1/0),new D(1/0,1/0,1/0));return}if(t!==void 0){if(this.boundingBox.setFromBufferAttribute(t),e)for(let i=0,s=e.length;i<s;i++){let r=e[i];Ni.setFromBufferAttribute(r),this.morphTargetsRelative?(ai.addVectors(this.boundingBox.min,Ni.min),this.boundingBox.expandByPoint(ai),ai.addVectors(this.boundingBox.max,Ni.max),this.boundingBox.expandByPoint(ai)):(this.boundingBox.expandByPoint(Ni.min),this.boundingBox.expandByPoint(Ni.max))}}else this.boundingBox.makeEmpty();(isNaN(this.boundingBox.min.x)||isNaN(this.boundingBox.min.y)||isNaN(this.boundingBox.min.z))&&ee('BufferGeometry.computeBoundingBox(): Computed min/max have NaN values. The "position" attribute is likely to have NaN values.',this)}computeBoundingSphere(){this.boundingSphere===null&&(this.boundingSphere=new Xi);let t=this.attributes.position,e=this.morphAttributes.position;if(t&&t.isGLBufferAttribute){ee("BufferGeometry.computeBoundingSphere(): GLBufferAttribute requires a manual bounding sphere.",this),this.boundingSphere.set(new D,1/0);return}if(t){let i=this.boundingSphere.center;if(Ni.setFromBufferAttribute(t),e)for(let r=0,a=e.length;r<a;r++){let o=e[r];aa.setFromBufferAttribute(o),this.morphTargetsRelative?(ai.addVectors(Ni.min,aa.min),Ni.expandByPoint(ai),ai.addVectors(Ni.max,aa.max),Ni.expandByPoint(ai)):(Ni.expandByPoint(aa.min),Ni.expandByPoint(aa.max))}Ni.getCenter(i);let s=0;for(let r=0,a=t.count;r<a;r++)ai.fromBufferAttribute(t,r),s=Math.max(s,i.distanceToSquared(ai));if(e)for(let r=0,a=e.length;r<a;r++){let o=e[r],c=this.morphTargetsRelative;for(let l=0,h=o.count;l<h;l++)ai.fromBufferAttribute(o,l),c&&(Ks.fromBufferAttribute(t,l),ai.add(Ks)),s=Math.max(s,i.distanceToSquared(ai))}this.boundingSphere.radius=Math.sqrt(s),isNaN(this.boundingSphere.radius)&&ee('BufferGeometry.computeBoundingSphere(): Computed radius is NaN. The "position" attribute is likely to have NaN values.',this)}}computeTangents(){let t=this.index,e=this.attributes;if(t===null||e.position===void 0||e.normal===void 0||e.uv===void 0){ee("BufferGeometry: .computeTangents() failed. Missing required attributes (index, position, normal or uv)");return}let i=e.position,s=e.normal,r=e.uv,a=this.getAttribute("tangent");(a===void 0||a.count!==i.count)&&(a=new ti(new Float32Array(4*i.count),4),this.setAttribute("tangent",a));let o=[],c=[];for(let y=0;y<i.count;y++)o[y]=new D,c[y]=new D;let l=new D,h=new D,u=new D,d=new ot,f=new ot,p=new ot,x=new D,m=new D;function g(y,E,P){l.fromBufferAttribute(i,y),h.fromBufferAttribute(i,E),u.fromBufferAttribute(i,P),d.fromBufferAttribute(r,y),f.fromBufferAttribute(r,E),p.fromBufferAttribute(r,P),h.sub(l),u.sub(l),f.sub(d),p.sub(d);let N=1/(f.x*p.y-p.x*f.y);isFinite(N)&&(x.copy(h).multiplyScalar(p.y).addScaledVector(u,-f.y).multiplyScalar(N),m.copy(u).multiplyScalar(f.x).addScaledVector(h,-p.x).multiplyScalar(N),o[y].add(x),o[E].add(x),o[P].add(x),c[y].add(m),c[E].add(m),c[P].add(m))}let _=this.groups;_.length===0&&(_=[{start:0,count:t.count}]);for(let y=0,E=_.length;y<E;++y){let P=_[y],N=P.start,F=P.count;for(let B=N,I=N+F;B<I;B+=3)g(t.getX(B+0),t.getX(B+1),t.getX(B+2))}let T=new D,v=new D,S=new D,M=new D;function A(y){S.fromBufferAttribute(s,y),M.copy(S);let E=o[y];T.copy(E),T.sub(S.multiplyScalar(S.dot(E))).normalize(),v.crossVectors(M,E);let N=v.dot(c[y])<0?-1:1;a.setXYZW(y,T.x,T.y,T.z,N)}for(let y=0,E=_.length;y<E;++y){let P=_[y],N=P.start,F=P.count;for(let B=N,I=N+F;B<I;B+=3)A(t.getX(B+0)),A(t.getX(B+1)),A(t.getX(B+2))}this._transformed=!0}computeVertexNormals(){let t=this.index,e=this.getAttribute("position");if(e!==void 0){let i=this.getAttribute("normal");if(i===void 0||i.count!==e.count)i=new ti(new Float32Array(e.count*3),3),this.setAttribute("normal",i);else for(let d=0,f=i.count;d<f;d++)i.setXYZ(d,0,0,0);let s=new D,r=new D,a=new D,o=new D,c=new D,l=new D,h=new D,u=new D;if(t)for(let d=0,f=t.count;d<f;d+=3){let p=t.getX(d+0),x=t.getX(d+1),m=t.getX(d+2);s.fromBufferAttribute(e,p),r.fromBufferAttribute(e,x),a.fromBufferAttribute(e,m),h.subVectors(a,r),u.subVectors(s,r),h.cross(u),o.fromBufferAttribute(i,p),c.fromBufferAttribute(i,x),l.fromBufferAttribute(i,m),o.add(h),c.add(h),l.add(h),i.setXYZ(p,o.x,o.y,o.z),i.setXYZ(x,c.x,c.y,c.z),i.setXYZ(m,l.x,l.y,l.z)}else for(let d=0,f=e.count;d<f;d+=3)s.fromBufferAttribute(e,d+0),r.fromBufferAttribute(e,d+1),a.fromBufferAttribute(e,d+2),h.subVectors(a,r),u.subVectors(s,r),h.cross(u),i.setXYZ(d+0,h.x,h.y,h.z),i.setXYZ(d+1,h.x,h.y,h.z),i.setXYZ(d+2,h.x,h.y,h.z);this.normalizeNormals(),i.needsUpdate=!0}}normalizeNormals(){let t=this.attributes.normal;for(let e=0,i=t.count;e<i;e++)ai.fromBufferAttribute(t,e),ai.normalize(),t.setXYZ(e,ai.x,ai.y,ai.z)}toNonIndexed(){function t(o,c){let l=o.array,h=o.itemSize,u=o.normalized,d=new l.constructor(c.length*h),f=0,p=0;for(let x=0,m=c.length;x<m;x++){o.isInterleavedBufferAttribute?f=c[x]*o.data.stride+o.offset:f=c[x]*h;for(let g=0;g<h;g++)d[p++]=l[f++]}return new ti(d,h,u)}if(this.index===null)return te("BufferGeometry.toNonIndexed(): BufferGeometry is already non-indexed."),this;let e=new n,i=this.index.array,s=this.attributes;for(let o in s){let c=s[o],l=t(c,i);e.setAttribute(o,l)}let r=this.morphAttributes;for(let o in r){let c=[],l=r[o];for(let h=0,u=l.length;h<u;h++){let d=l[h],f=t(d,i);c.push(f)}e.morphAttributes[o]=c}e.morphTargetsRelative=this.morphTargetsRelative;let a=this.groups;for(let o=0,c=a.length;o<c;o++){let l=a[o];e.addGroup(l.start,l.count,l.materialIndex)}return e}toJSON(){let t={metadata:{version:4.7,type:"BufferGeometry",generator:"BufferGeometry.toJSON"}};if(t.uuid=this.uuid,t.type=this.parameters!==void 0&&this._transformed===!0?"BufferGeometry":this.type,t.name=this.name,Object.keys(this.userData).length>0&&(t.userData=this.userData),this.parameters!==void 0&&this._transformed!==!0){let c=this.parameters;for(let l in c)c[l]!==void 0&&(t[l]=c[l]);return t}t.data={attributes:{}};let e=this.index;e!==null&&(t.data.index={type:e.array.constructor.name,array:Array.prototype.slice.call(e.array)});let i=this.attributes;for(let c in i){let l=i[c];t.data.attributes[c]=l.toJSON(t.data)}let s={},r=!1;for(let c in this.morphAttributes){let l=this.morphAttributes[c],h=[];for(let u=0,d=l.length;u<d;u++){let f=l[u];h.push(f.toJSON(t.data))}h.length>0&&(s[c]=h,r=!0)}r&&(t.data.morphAttributes=s,t.data.morphTargetsRelative=this.morphTargetsRelative);let a=this.groups;a.length>0&&(t.data.groups=JSON.parse(JSON.stringify(a)));let o=this.boundingSphere;return o!==null&&(t.data.boundingSphere=o.toJSON()),t}clone(){return new this.constructor().copy(this)}copy(t){this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null;let e={};this.name=t.name;let i=t.index;i!==null&&this.setIndex(i.clone());let s=t.attributes;for(let l in s){let h=s[l];this.setAttribute(l,h.clone(e))}let r=t.morphAttributes;for(let l in r){let h=[],u=r[l];for(let d=0,f=u.length;d<f;d++)h.push(u[d].clone(e));this.morphAttributes[l]=h}this.morphTargetsRelative=t.morphTargetsRelative;let a=t.groups;for(let l=0,h=a.length;l<h;l++){let u=a[l];this.addGroup(u.start,u.count,u.materialIndex)}let o=t.boundingBox;o!==null&&(this.boundingBox=o.clone());let c=t.boundingSphere;return c!==null&&(this.boundingSphere=c.clone()),this.drawRange.start=t.drawRange.start,this.drawRange.count=t.drawRange.count,this.userData=t.userData,this._transformed=t._transformed,this}dispose(){this.dispatchEvent({type:"dispose"})}},Aa=class{constructor(t,e){this.isInterleavedBuffer=!0,this.array=t,this.stride=e,this.count=t!==void 0?t.length/e:0,this.usage=Vu,this.updateRanges=[],this.version=0,this.uuid=xn()}onUploadCallback(){}set needsUpdate(t){t===!0&&this.version++}setUsage(t){return this.usage=t,this}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}copy(t){return this.array=new t.array.constructor(t.array),this.count=t.count,this.stride=t.stride,this.usage=t.usage,this}copyAt(t,e,i){t*=this.stride,i*=e.stride;for(let s=0,r=this.stride;s<r;s++)this.array[t+s]=e.array[i+s];return this}set(t,e=0){return this.array.set(t,e),this}clone(t){t.arrayBuffers===void 0&&(t.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=xn()),t.arrayBuffers[this.array.buffer._uuid]===void 0&&(t.arrayBuffers[this.array.buffer._uuid]=this.array.slice(0).buffer);let e=new this.array.constructor(t.arrayBuffers[this.array.buffer._uuid]),i=new this.constructor(e,this.stride);return i.setUsage(this.usage),i}onUpload(t){return this.onUploadCallback=t,this}toJSON(t){t.arrayBuffers===void 0&&(t.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=xn()),t.arrayBuffers[this.array.buffer._uuid]===void 0&&(t.arrayBuffers[this.array.buffer._uuid]=Array.from(new Uint32Array(this.array.buffer)));let e={uuid:this.uuid,buffer:this.array.buffer._uuid,type:this.array.constructor.name,stride:this.stride};return e.usage=this.usage,e}},Mi=new D,mr=class n{constructor(t,e,i,s=!1){this.isInterleavedBufferAttribute=!0,this.name="",this.data=t,this.itemSize=e,this.offset=i,this.normalized=s}get count(){return this.data.count}get array(){return this.data.array}set needsUpdate(t){this.data.needsUpdate=t}applyMatrix4(t){for(let e=0,i=this.data.count;e<i;e++)Mi.fromBufferAttribute(this,e),Mi.applyMatrix4(t),this.setXYZ(e,Mi.x,Mi.y,Mi.z);return this}applyNormalMatrix(t){for(let e=0,i=this.count;e<i;e++)Mi.fromBufferAttribute(this,e),Mi.applyNormalMatrix(t),this.setXYZ(e,Mi.x,Mi.y,Mi.z);return this}transformDirection(t){for(let e=0,i=this.count;e<i;e++)Mi.fromBufferAttribute(this,e),Mi.transformDirection(t),this.setXYZ(e,Mi.x,Mi.y,Mi.z);return this}getComponent(t,e){let i=this.array[t*this.data.stride+this.offset+e];return this.normalized&&(i=rn(i,this.array)),i}setComponent(t,e,i){return this.normalized&&(i=Te(i,this.array)),this.data.array[t*this.data.stride+this.offset+e]=i,this}setX(t,e){return this.normalized&&(e=Te(e,this.array)),this.data.array[t*this.data.stride+this.offset]=e,this}setY(t,e){return this.normalized&&(e=Te(e,this.array)),this.data.array[t*this.data.stride+this.offset+1]=e,this}setZ(t,e){return this.normalized&&(e=Te(e,this.array)),this.data.array[t*this.data.stride+this.offset+2]=e,this}setW(t,e){return this.normalized&&(e=Te(e,this.array)),this.data.array[t*this.data.stride+this.offset+3]=e,this}getX(t){let e=this.data.array[t*this.data.stride+this.offset];return this.normalized&&(e=rn(e,this.array)),e}getY(t){let e=this.data.array[t*this.data.stride+this.offset+1];return this.normalized&&(e=rn(e,this.array)),e}getZ(t){let e=this.data.array[t*this.data.stride+this.offset+2];return this.normalized&&(e=rn(e,this.array)),e}getW(t){let e=this.data.array[t*this.data.stride+this.offset+3];return this.normalized&&(e=rn(e,this.array)),e}setXY(t,e,i){return t=t*this.data.stride+this.offset,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this}setXYZ(t,e,i,s){return t=t*this.data.stride+this.offset,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array),s=Te(s,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this.data.array[t+2]=s,this}setXYZW(t,e,i,s,r){return t=t*this.data.stride+this.offset,this.normalized&&(e=Te(e,this.array),i=Te(i,this.array),s=Te(s,this.array),r=Te(r,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this.data.array[t+2]=s,this.data.array[t+3]=r,this}clone(t){if(t===void 0){Ma("InterleavedBufferAttribute.clone(): Cloning an interleaved buffer attribute will de-interleave buffer data.");let e=[];for(let i=0;i<this.count;i++){let s=i*this.data.stride+this.offset;for(let r=0;r<this.itemSize;r++)e.push(this.data.array[s+r])}return new ti(new this.array.constructor(e),this.itemSize,this.normalized)}else return t.interleavedBuffers===void 0&&(t.interleavedBuffers={}),t.interleavedBuffers[this.data.uuid]===void 0&&(t.interleavedBuffers[this.data.uuid]=this.data.clone(t)),new n(t.interleavedBuffers[this.data.uuid],this.itemSize,this.offset,this.normalized)}toJSON(t){if(t===void 0){Ma("InterleavedBufferAttribute.toJSON(): Serializing an interleaved buffer attribute will de-interleave buffer data.");let e=[];for(let i=0;i<this.count;i++){let s=i*this.data.stride+this.offset;for(let r=0;r<this.itemSize;r++)e.push(this.data.array[s+r])}return{itemSize:this.itemSize,type:this.array.constructor.name,array:e,normalized:this.normalized}}else return t.interleavedBuffers===void 0&&(t.interleavedBuffers={}),t.interleavedBuffers[this.data.uuid]===void 0&&(t.interleavedBuffers[this.data.uuid]=this.data.toJSON(t)),{isInterleavedBufferAttribute:!0,itemSize:this.itemSize,data:this.data.uuid,offset:this.offset,normalized:this.normalized}}},ou=new D,Zm=new D,Jm=new ie,Si=class{constructor(t=new D(1,0,0),e=0){this.isPlane=!0,this.normal=t,this.constant=e}set(t,e){return this.normal.copy(t),this.constant=e,this}setComponents(t,e,i,s){return this.normal.set(t,e,i),this.constant=s,this}setFromNormalAndCoplanarPoint(t,e){return this.normal.copy(t),this.constant=-e.dot(this.normal),this}setFromCoplanarPoints(t,e,i){let s=ou.subVectors(i,e).cross(Zm.subVectors(t,e)).normalize();return this.setFromNormalAndCoplanarPoint(s,t),this}copy(t){return this.normal.copy(t.normal),this.constant=t.constant,this}normalize(){let t=1/this.normal.length();return this.normal.multiplyScalar(t),this.constant*=t,this}negate(){return this.constant*=-1,this.normal.negate(),this}distanceToPoint(t){return this.normal.dot(t)+this.constant}distanceToSphere(t){return this.distanceToPoint(t.center)-t.radius}projectPoint(t,e){return e.copy(t).addScaledVector(this.normal,-this.distanceToPoint(t))}intersectLine(t,e,i=!0){let s=t.delta(ou),r=this.normal.dot(s);if(r===0)return this.distanceToPoint(t.start)===0?e.copy(t.start):null;let a=-(t.start.dot(this.normal)+this.constant)/r;return i===!0&&(a<0||a>1)?null:e.copy(t.start).addScaledVector(s,a)}intersectsLine(t){let e=this.distanceToPoint(t.start),i=this.distanceToPoint(t.end);return e<0&&i>0||i<0&&e>0}intersectsBox(t){return t.intersectsPlane(this)}intersectsSphere(t){return t.intersectsPlane(this)}coplanarPoint(t){return t.copy(this.normal).multiplyScalar(-this.constant)}applyMatrix4(t,e){let i=e||Jm.getNormalMatrix(t),s=this.coplanarPoint(ou).applyMatrix4(t),r=this.normal.applyMatrix3(i).normalize();return this.constant=-s.dot(r),this}translate(t){return this.constant-=t.dot(this.normal),this}equals(t){return t.normal.equals(this.normal)&&t.constant===this.constant}clone(){return new this.constructor().copy(this)}toJSON(){return{normal:this.normal.toArray(),constant:this.constant}}fromJSON(t){return this.normal.fromArray(t.normal),this.constant=t.constant,this}},Km=0,qi=class extends yn{constructor(){super(),this.isMaterial=!0,Object.defineProperty(this,"id",{value:Km++}),this.uuid=xn(),this.name="",this.type="Material",this.blending=as,this.side=rs,this.vertexColors=!1,this.opacity=1,this.transparent=!1,this.alphaHash=!1,this.blendSrc=Nu,this.blendDst=Uu,this.blendEquation=Ps,this.blendSrcAlpha=null,this.blendDstAlpha=null,this.blendEquationAlpha=null,this.blendColor=new Nt(0,0,0),this.blendAlpha=0,this.depthFunc=or,this.depthTest=!0,this.depthWrite=!0,this.stencilWriteMask=255,this.stencilFunc=S0,this.stencilRef=0,this.stencilFuncMask=255,this.stencilFail=ml,this.stencilZFail=ml,this.stencilZPass=ml,this.stencilWrite=!1,this.clippingPlanes=null,this.clipIntersection=!1,this.clipShadows=!1,this.shadowSide=null,this.colorWrite=!0,this.precision=null,this.polygonOffset=!1,this.polygonOffsetFactor=0,this.polygonOffsetUnits=0,this.dithering=!1,this.alphaToCoverage=!1,this.premultipliedAlpha=!1,this.forceSinglePass=!1,this.allowOverride=!0,this.visible=!0,this.toneMapped=!0,this.userData={},this.version=0,this._alphaTest=0}get alphaTest(){return this._alphaTest}set alphaTest(t){this._alphaTest>0!=t>0&&this.version++,this._alphaTest=t}onBeforeRender(){}onBeforeCompile(){}customProgramCacheKey(){return this.onBeforeCompile.toString()}setValues(t){if(t!==void 0)for(let e in t){let i=t[e];if(i===void 0){te(`Material: parameter '${e}' has value of undefined.`);continue}let s=this[e];if(s===void 0){te(`Material: '${e}' is not a property of THREE.${this.type}.`);continue}s&&s.isColor?s.set(i):s&&s.isVector2&&i&&i.isVector2||s&&s.isEuler&&i&&i.isEuler||s&&s.isVector3&&i&&i.isVector3?s.copy(i):this[e]=i}}toJSON(t){let e=t===void 0||typeof t=="string";e&&(t={textures:{},images:{}});let i={metadata:{version:4.7,type:"Material",generator:"Material.toJSON"}};i.uuid=this.uuid,i.type=this.type,i.blending=this.blending,i.side=this.side,i.shadowSide=this.shadowSide,i.vertexColors=this.vertexColors,i.opacity=this.opacity,i.transparent=this.transparent,i.blendSrc=this.blendSrc,i.blendDst=this.blendDst,i.blendEquation=this.blendEquation,i.blendSrcAlpha=this.blendSrcAlpha,i.blendDstAlpha=this.blendDstAlpha,i.blendEquationAlpha=this.blendEquationAlpha,i.blendColor=this.blendColor.getHex(),i.blendAlpha=this.blendAlpha,i.depthFunc=this.depthFunc,i.depthTest=this.depthTest,i.depthWrite=this.depthWrite,i.colorWrite=this.colorWrite,i.clipIntersection=this.clipIntersection,i.clipShadows=this.clipShadows,i.stencilWriteMask=this.stencilWriteMask,i.stencilFunc=this.stencilFunc,i.stencilRef=this.stencilRef,i.stencilFuncMask=this.stencilFuncMask,i.stencilFail=this.stencilFail,i.stencilZFail=this.stencilZFail,i.stencilZPass=this.stencilZPass,i.stencilWrite=this.stencilWrite,i.polygonOffset=this.polygonOffset,i.polygonOffsetFactor=this.polygonOffsetFactor,i.polygonOffsetUnits=this.polygonOffsetUnits,i.dithering=this.dithering,i.alphaTest=this.alphaTest,i.alphaHash=this.alphaHash,i.alphaToCoverage=this.alphaToCoverage,i.premultipliedAlpha=this.premultipliedAlpha,i.forceSinglePass=this.forceSinglePass,i.allowOverride=this.allowOverride,i.visible=this.visible,i.toneMapped=this.toneMapped,i.name=this.name,this.color&&this.color.isColor&&(i.color=this.color.getHex()),this.roughness!==void 0&&(i.roughness=this.roughness),this.metalness!==void 0&&(i.metalness=this.metalness),this.sheen!==void 0&&(i.sheen=this.sheen),this.sheenColor&&this.sheenColor.isColor&&(i.sheenColor=this.sheenColor.getHex()),this.sheenRoughness!==void 0&&(i.sheenRoughness=this.sheenRoughness),this.emissive&&this.emissive.isColor&&(i.emissive=this.emissive.getHex()),this.emissiveIntensity!==void 0&&(i.emissiveIntensity=this.emissiveIntensity),this.specular&&this.specular.isColor&&(i.specular=this.specular.getHex()),this.specularIntensity!==void 0&&(i.specularIntensity=this.specularIntensity),this.specularColor&&this.specularColor.isColor&&(i.specularColor=this.specularColor.getHex()),this.shininess!==void 0&&(i.shininess=this.shininess),this.clearcoat!==void 0&&(i.clearcoat=this.clearcoat),this.clearcoatRoughness!==void 0&&(i.clearcoatRoughness=this.clearcoatRoughness),this.clearcoatMap&&this.clearcoatMap.isTexture&&(i.clearcoatMap=this.clearcoatMap.toJSON(t).uuid),this.clearcoatRoughnessMap&&this.clearcoatRoughnessMap.isTexture&&(i.clearcoatRoughnessMap=this.clearcoatRoughnessMap.toJSON(t).uuid),this.clearcoatNormalMap&&this.clearcoatNormalMap.isTexture&&(i.clearcoatNormalMap=this.clearcoatNormalMap.toJSON(t).uuid,i.clearcoatNormalScale=this.clearcoatNormalScale.toArray()),this.sheenColorMap&&this.sheenColorMap.isTexture&&(i.sheenColorMap=this.sheenColorMap.toJSON(t).uuid),this.sheenRoughnessMap&&this.sheenRoughnessMap.isTexture&&(i.sheenRoughnessMap=this.sheenRoughnessMap.toJSON(t).uuid),this.dispersion!==void 0&&(i.dispersion=this.dispersion),this.retroreflectivity!==void 0&&(i.retroreflectivity=this.retroreflectivity),this.iridescence!==void 0&&(i.iridescence=this.iridescence),this.iridescenceIOR!==void 0&&(i.iridescenceIOR=this.iridescenceIOR),this.iridescenceThicknessRange!==void 0&&(i.iridescenceThicknessRange=this.iridescenceThicknessRange),this.iridescenceMap&&this.iridescenceMap.isTexture&&(i.iridescenceMap=this.iridescenceMap.toJSON(t).uuid),this.iridescenceThicknessMap&&this.iridescenceThicknessMap.isTexture&&(i.iridescenceThicknessMap=this.iridescenceThicknessMap.toJSON(t).uuid),this.anisotropy!==void 0&&(i.anisotropy=this.anisotropy),this.anisotropyRotation!==void 0&&(i.anisotropyRotation=this.anisotropyRotation),this.anisotropyMap&&this.anisotropyMap.isTexture&&(i.anisotropyMap=this.anisotropyMap.toJSON(t).uuid),this.map&&this.map.isTexture&&(i.map=this.map.toJSON(t).uuid),this.matcap&&this.matcap.isTexture&&(i.matcap=this.matcap.toJSON(t).uuid),this.alphaMap&&this.alphaMap.isTexture&&(i.alphaMap=this.alphaMap.toJSON(t).uuid),this.lightMap&&this.lightMap.isTexture&&(i.lightMap=this.lightMap.toJSON(t).uuid,i.lightMapIntensity=this.lightMapIntensity),this.aoMap&&this.aoMap.isTexture&&(i.aoMap=this.aoMap.toJSON(t).uuid,i.aoMapIntensity=this.aoMapIntensity),this.bumpMap&&this.bumpMap.isTexture&&(i.bumpMap=this.bumpMap.toJSON(t).uuid,i.bumpScale=this.bumpScale),this.normalMap&&this.normalMap.isTexture&&(i.normalMap=this.normalMap.toJSON(t).uuid,i.normalMapType=this.normalMapType,i.normalScale=this.normalScale.toArray()),this.displacementMap&&this.displacementMap.isTexture&&(i.displacementMap=this.displacementMap.toJSON(t).uuid,i.displacementScale=this.displacementScale,i.displacementBias=this.displacementBias),this.roughnessMap&&this.roughnessMap.isTexture&&(i.roughnessMap=this.roughnessMap.toJSON(t).uuid),this.metalnessMap&&this.metalnessMap.isTexture&&(i.metalnessMap=this.metalnessMap.toJSON(t).uuid),this.emissiveMap&&this.emissiveMap.isTexture&&(i.emissiveMap=this.emissiveMap.toJSON(t).uuid),this.specularMap&&this.specularMap.isTexture&&(i.specularMap=this.specularMap.toJSON(t).uuid),this.specularIntensityMap&&this.specularIntensityMap.isTexture&&(i.specularIntensityMap=this.specularIntensityMap.toJSON(t).uuid),this.specularColorMap&&this.specularColorMap.isTexture&&(i.specularColorMap=this.specularColorMap.toJSON(t).uuid),this.envMap&&this.envMap.isTexture&&(i.envMap=this.envMap.toJSON(t).uuid,this.combine!==void 0&&(i.combine=this.combine)),this.envMapRotation!==void 0&&(i.envMapRotation=this.envMapRotation.toArray()),this.envMapIntensity!==void 0&&(i.envMapIntensity=this.envMapIntensity),this.reflectivity!==void 0&&(i.reflectivity=this.reflectivity),this.refractionRatio!==void 0&&(i.refractionRatio=this.refractionRatio),this.gradientMap&&this.gradientMap.isTexture&&(i.gradientMap=this.gradientMap.toJSON(t).uuid),this.transmission!==void 0&&(i.transmission=this.transmission),this.transmissionMap&&this.transmissionMap.isTexture&&(i.transmissionMap=this.transmissionMap.toJSON(t).uuid),this.thickness!==void 0&&(i.thickness=this.thickness),this.thicknessMap&&this.thicknessMap.isTexture&&(i.thicknessMap=this.thicknessMap.toJSON(t).uuid),this.attenuationDistance!==void 0&&(i.attenuationDistance=this.attenuationDistance),this.attenuationColor!==void 0&&(i.attenuationColor=this.attenuationColor.getHex()),this.size!==void 0&&(i.size=this.size),this.sizeAttenuation!==void 0&&(i.sizeAttenuation=this.sizeAttenuation),Array.isArray(this.clippingPlanes)&&this.clippingPlanes.length>0&&(i.clippingPlanes=this.clippingPlanes.map(r=>r.toJSON())),this.rotation!==void 0&&(i.rotation=this.rotation),this.depthPacking!==void 0&&(i.depthPacking=this.depthPacking),this.linewidth!==void 0&&(i.linewidth=this.linewidth),this.linecap!==void 0&&(i.linecap=this.linecap),this.linejoin!==void 0&&(i.linejoin=this.linejoin),this.dashSize!==void 0&&(i.dashSize=this.dashSize),this.gapSize!==void 0&&(i.gapSize=this.gapSize),this.scale!==void 0&&(i.scale=this.scale),this.wireframe!==void 0&&(i.wireframe=this.wireframe),this.wireframeLinewidth!==void 0&&(i.wireframeLinewidth=this.wireframeLinewidth),this.wireframeLinecap!==void 0&&(i.wireframeLinecap=this.wireframeLinecap),this.wireframeLinejoin!==void 0&&(i.wireframeLinejoin=this.wireframeLinejoin),this.flatShading!==void 0&&(i.flatShading=this.flatShading),this.fog!==void 0&&(i.fog=this.fog),Object.keys(this.userData).length>0&&(i.userData=this.userData);function s(r){let a=[];for(let o in r){let c=r[o];delete c.metadata,a.push(c)}return a}if(e){let r=s(t.textures),a=s(t.images);r.length>0&&(i.textures=r),a.length>0&&(i.images=a)}return i}fromJSON(t,e){if(t.uuid!==void 0&&(this.uuid=t.uuid),t.name!==void 0&&(this.name=t.name),t.color!==void 0&&this.color!==void 0&&this.color.setHex(t.color),t.roughness!==void 0&&(this.roughness=t.roughness),t.metalness!==void 0&&(this.metalness=t.metalness),t.sheen!==void 0&&(this.sheen=t.sheen),t.sheenColor!==void 0&&(this.sheenColor=new Nt().setHex(t.sheenColor)),t.sheenRoughness!==void 0&&(this.sheenRoughness=t.sheenRoughness),t.emissive!==void 0&&this.emissive!==void 0&&this.emissive.setHex(t.emissive),t.specular!==void 0&&this.specular!==void 0&&this.specular.setHex(t.specular),t.specularIntensity!==void 0&&(this.specularIntensity=t.specularIntensity),t.specularColor!==void 0&&this.specularColor!==void 0&&this.specularColor.setHex(t.specularColor),t.shininess!==void 0&&(this.shininess=t.shininess),t.clearcoat!==void 0&&(this.clearcoat=t.clearcoat),t.clearcoatRoughness!==void 0&&(this.clearcoatRoughness=t.clearcoatRoughness),t.dispersion!==void 0&&(this.dispersion=t.dispersion),t.retroreflectivity!==void 0&&(this.retroreflectivity=t.retroreflectivity),t.iridescence!==void 0&&(this.iridescence=t.iridescence),t.iridescenceIOR!==void 0&&(this.iridescenceIOR=t.iridescenceIOR),t.iridescenceThicknessRange!==void 0&&(this.iridescenceThicknessRange=t.iridescenceThicknessRange),t.transmission!==void 0&&(this.transmission=t.transmission),t.thickness!==void 0&&(this.thickness=t.thickness),t.attenuationDistance!==void 0&&(this.attenuationDistance=t.attenuationDistance),t.attenuationColor!==void 0&&this.attenuationColor!==void 0&&this.attenuationColor.setHex(t.attenuationColor),t.anisotropy!==void 0&&(this.anisotropy=t.anisotropy),t.anisotropyRotation!==void 0&&(this.anisotropyRotation=t.anisotropyRotation),t.fog!==void 0&&(this.fog=t.fog),t.flatShading!==void 0&&(this.flatShading=t.flatShading),t.blending!==void 0&&(this.blending=t.blending),t.combine!==void 0&&(this.combine=t.combine),t.side!==void 0&&(this.side=t.side),t.shadowSide!==void 0&&(this.shadowSide=t.shadowSide),t.opacity!==void 0&&(this.opacity=t.opacity),t.transparent!==void 0&&(this.transparent=t.transparent),t.alphaTest!==void 0&&(this.alphaTest=t.alphaTest),t.alphaHash!==void 0&&(this.alphaHash=t.alphaHash),t.depthFunc!==void 0&&(this.depthFunc=t.depthFunc),t.depthTest!==void 0&&(this.depthTest=t.depthTest),t.depthWrite!==void 0&&(this.depthWrite=t.depthWrite),t.colorWrite!==void 0&&(this.colorWrite=t.colorWrite),t.clippingPlanes!==void 0&&(this.clippingPlanes=t.clippingPlanes.map(i=>new Si().fromJSON(i))),t.clipIntersection!==void 0&&(this.clipIntersection=t.clipIntersection),t.clipShadows!==void 0&&(this.clipShadows=t.clipShadows),t.depthPacking!==void 0&&(this.depthPacking=t.depthPacking),t.blendSrc!==void 0&&(this.blendSrc=t.blendSrc),t.blendDst!==void 0&&(this.blendDst=t.blendDst),t.blendEquation!==void 0&&(this.blendEquation=t.blendEquation),t.blendSrcAlpha!==void 0&&(this.blendSrcAlpha=t.blendSrcAlpha),t.blendDstAlpha!==void 0&&(this.blendDstAlpha=t.blendDstAlpha),t.blendEquationAlpha!==void 0&&(this.blendEquationAlpha=t.blendEquationAlpha),t.blendColor!==void 0&&this.blendColor!==void 0&&this.blendColor.setHex(t.blendColor),t.blendAlpha!==void 0&&(this.blendAlpha=t.blendAlpha),t.stencilWriteMask!==void 0&&(this.stencilWriteMask=t.stencilWriteMask),t.stencilFunc!==void 0&&(this.stencilFunc=t.stencilFunc),t.stencilRef!==void 0&&(this.stencilRef=t.stencilRef),t.stencilFuncMask!==void 0&&(this.stencilFuncMask=t.stencilFuncMask),t.stencilFail!==void 0&&(this.stencilFail=t.stencilFail),t.stencilZFail!==void 0&&(this.stencilZFail=t.stencilZFail),t.stencilZPass!==void 0&&(this.stencilZPass=t.stencilZPass),t.stencilWrite!==void 0&&(this.stencilWrite=t.stencilWrite),t.wireframe!==void 0&&(this.wireframe=t.wireframe),t.wireframeLinewidth!==void 0&&(this.wireframeLinewidth=t.wireframeLinewidth),t.wireframeLinecap!==void 0&&(this.wireframeLinecap=t.wireframeLinecap),t.wireframeLinejoin!==void 0&&(this.wireframeLinejoin=t.wireframeLinejoin),t.rotation!==void 0&&(this.rotation=t.rotation),t.linewidth!==void 0&&(this.linewidth=t.linewidth),t.linecap!==void 0&&(this.linecap=t.linecap),t.linejoin!==void 0&&(this.linejoin=t.linejoin),t.dashSize!==void 0&&(this.dashSize=t.dashSize),t.gapSize!==void 0&&(this.gapSize=t.gapSize),t.scale!==void 0&&(this.scale=t.scale),t.polygonOffset!==void 0&&(this.polygonOffset=t.polygonOffset),t.polygonOffsetFactor!==void 0&&(this.polygonOffsetFactor=t.polygonOffsetFactor),t.polygonOffsetUnits!==void 0&&(this.polygonOffsetUnits=t.polygonOffsetUnits),t.dithering!==void 0&&(this.dithering=t.dithering),t.alphaToCoverage!==void 0&&(this.alphaToCoverage=t.alphaToCoverage),t.premultipliedAlpha!==void 0&&(this.premultipliedAlpha=t.premultipliedAlpha),t.forceSinglePass!==void 0&&(this.forceSinglePass=t.forceSinglePass),t.allowOverride!==void 0&&(this.allowOverride=t.allowOverride),t.visible!==void 0&&(this.visible=t.visible),t.toneMapped!==void 0&&(this.toneMapped=t.toneMapped),t.userData!==void 0&&(this.userData=t.userData),t.vertexColors!==void 0&&(typeof t.vertexColors=="number"?this.vertexColors=t.vertexColors>0:this.vertexColors=t.vertexColors),t.size!==void 0&&(this.size=t.size),t.sizeAttenuation!==void 0&&(this.sizeAttenuation=t.sizeAttenuation),t.map!==void 0&&(this.map=e[t.map]||null),t.matcap!==void 0&&(this.matcap=e[t.matcap]||null),t.alphaMap!==void 0&&(this.alphaMap=e[t.alphaMap]||null),t.bumpMap!==void 0&&(this.bumpMap=e[t.bumpMap]||null),t.bumpScale!==void 0&&(this.bumpScale=t.bumpScale),t.normalMap!==void 0&&(this.normalMap=e[t.normalMap]||null),t.normalMapType!==void 0&&(this.normalMapType=t.normalMapType),t.normalScale!==void 0){let i=t.normalScale;Array.isArray(i)===!1&&(i=[i,i]),this.normalScale=new ot().fromArray(i)}return t.displacementMap!==void 0&&(this.displacementMap=e[t.displacementMap]||null),t.displacementScale!==void 0&&(this.displacementScale=t.displacementScale),t.displacementBias!==void 0&&(this.displacementBias=t.displacementBias),t.roughnessMap!==void 0&&(this.roughnessMap=e[t.roughnessMap]||null),t.metalnessMap!==void 0&&(this.metalnessMap=e[t.metalnessMap]||null),t.emissiveMap!==void 0&&(this.emissiveMap=e[t.emissiveMap]||null),t.emissiveIntensity!==void 0&&(this.emissiveIntensity=t.emissiveIntensity),t.specularMap!==void 0&&(this.specularMap=e[t.specularMap]||null),t.specularIntensityMap!==void 0&&(this.specularIntensityMap=e[t.specularIntensityMap]||null),t.specularColorMap!==void 0&&(this.specularColorMap=e[t.specularColorMap]||null),t.envMap!==void 0&&(this.envMap=e[t.envMap]||null),t.envMapRotation!==void 0&&this.envMapRotation.fromArray(t.envMapRotation),t.envMapIntensity!==void 0&&(this.envMapIntensity=t.envMapIntensity),t.reflectivity!==void 0&&(this.reflectivity=t.reflectivity),t.refractionRatio!==void 0&&(this.refractionRatio=t.refractionRatio),t.lightMap!==void 0&&(this.lightMap=e[t.lightMap]||null),t.lightMapIntensity!==void 0&&(this.lightMapIntensity=t.lightMapIntensity),t.aoMap!==void 0&&(this.aoMap=e[t.aoMap]||null),t.aoMapIntensity!==void 0&&(this.aoMapIntensity=t.aoMapIntensity),t.gradientMap!==void 0&&(this.gradientMap=e[t.gradientMap]||null),t.clearcoatMap!==void 0&&(this.clearcoatMap=e[t.clearcoatMap]||null),t.clearcoatRoughnessMap!==void 0&&(this.clearcoatRoughnessMap=e[t.clearcoatRoughnessMap]||null),t.clearcoatNormalMap!==void 0&&(this.clearcoatNormalMap=e[t.clearcoatNormalMap]||null),t.clearcoatNormalScale!==void 0&&(this.clearcoatNormalScale=new ot().fromArray(t.clearcoatNormalScale)),t.iridescenceMap!==void 0&&(this.iridescenceMap=e[t.iridescenceMap]||null),t.iridescenceThicknessMap!==void 0&&(this.iridescenceThicknessMap=e[t.iridescenceThicknessMap]||null),t.transmissionMap!==void 0&&(this.transmissionMap=e[t.transmissionMap]||null),t.thicknessMap!==void 0&&(this.thicknessMap=e[t.thicknessMap]||null),t.anisotropyMap!==void 0&&(this.anisotropyMap=e[t.anisotropyMap]||null),t.sheenColorMap!==void 0&&(this.sheenColorMap=e[t.sheenColorMap]||null),t.sheenRoughnessMap!==void 0&&(this.sheenRoughnessMap=e[t.sheenRoughnessMap]||null),this}clone(){return new this.constructor().copy(this)}copy(t){this.name=t.name,this.blending=t.blending,this.side=t.side,this.vertexColors=t.vertexColors,this.opacity=t.opacity,this.transparent=t.transparent,this.blendSrc=t.blendSrc,this.blendDst=t.blendDst,this.blendEquation=t.blendEquation,this.blendSrcAlpha=t.blendSrcAlpha,this.blendDstAlpha=t.blendDstAlpha,this.blendEquationAlpha=t.blendEquationAlpha,this.blendColor.copy(t.blendColor),this.blendAlpha=t.blendAlpha,this.depthFunc=t.depthFunc,this.depthTest=t.depthTest,this.depthWrite=t.depthWrite,this.stencilWriteMask=t.stencilWriteMask,this.stencilFunc=t.stencilFunc,this.stencilRef=t.stencilRef,this.stencilFuncMask=t.stencilFuncMask,this.stencilFail=t.stencilFail,this.stencilZFail=t.stencilZFail,this.stencilZPass=t.stencilZPass,this.stencilWrite=t.stencilWrite;let e=t.clippingPlanes,i=null;if(e!==null){let s=e.length;i=new Array(s);for(let r=0;r!==s;++r)i[r]=e[r].clone()}return this.clippingPlanes=i,this.clipIntersection=t.clipIntersection,this.clipShadows=t.clipShadows,this.shadowSide=t.shadowSide,this.colorWrite=t.colorWrite,this.precision=t.precision,this.polygonOffset=t.polygonOffset,this.polygonOffsetFactor=t.polygonOffsetFactor,this.polygonOffsetUnits=t.polygonOffsetUnits,this.dithering=t.dithering,this.alphaTest=t.alphaTest,this.alphaHash=t.alphaHash,this.alphaToCoverage=t.alphaToCoverage,this.premultipliedAlpha=t.premultipliedAlpha,this.forceSinglePass=t.forceSinglePass,this.allowOverride=t.allowOverride,this.visible=t.visible,this.toneMapped=t.toneMapped,this.userData=JSON.parse(JSON.stringify(t.userData)),this}dispose(){this.dispatchEvent({type:"dispose"})}set needsUpdate(t){t===!0&&this.version++}},gr=class extends qi{constructor(t){super(),this.isSpriteMaterial=!0,this.type="SpriteMaterial",this.color=new Nt(16777215),this.map=null,this.alphaMap=null,this.rotation=0,this.sizeAttenuation=!0,this.transparent=!0,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.alphaMap=t.alphaMap,this.rotation=t.rotation,this.sizeAttenuation=t.sizeAttenuation,this.fog=t.fog,this}},js,oa=new D,Qs=new D,tr=new D,er=new ot,la=new ot,U0=new me,qo=new D,ca=new D,$o=new D,wf=new ot,lu=new ot,Tf=new ot,Ra=class extends Ze{constructor(t=new gr){if(super(),this.isSprite=!0,this.type="Sprite",js===void 0){js=new ge;let e=new Float32Array([-.5,-.5,0,0,0,.5,-.5,0,1,0,.5,.5,0,1,1,-.5,.5,0,0,1]),i=new Aa(e,5);js.setIndex([0,1,2,0,2,3]),js.setAttribute("position",new mr(i,3,0,!1)),js.setAttribute("uv",new mr(i,2,3,!1))}this.geometry=js,this.material=t,this.center=new ot(.5,.5),this.count=1}intersectsFrustum(t){return t.intersectsSprite(this)}raycast(t,e){t.camera===null&&ee('Sprite: "Raycaster.camera" needs to be set in order to raycast against sprites.'),Qs.setFromMatrixScale(this.matrixWorld),U0.copy(t.camera.matrixWorld),this.modelViewMatrix.multiplyMatrices(t.camera.matrixWorldInverse,this.matrixWorld),tr.setFromMatrixPosition(this.modelViewMatrix),t.camera.isPerspectiveCamera&&this.material.sizeAttenuation===!1&&Qs.multiplyScalar(-tr.z);let i=this.material.rotation,s,r;i!==0&&(r=Math.cos(i),s=Math.sin(i));let a=this.center;Yo(qo.set(-.5,-.5,0),tr,a,Qs,s,r),Yo(ca.set(.5,-.5,0),tr,a,Qs,s,r),Yo($o.set(.5,.5,0),tr,a,Qs,s,r),wf.set(0,0),lu.set(1,0),Tf.set(1,1);let o=t.ray.intersectTriangle(qo,ca,$o,!1,oa);if(o===null&&(Yo(ca.set(-.5,.5,0),tr,a,Qs,s,r),lu.set(0,1),o=t.ray.intersectTriangle(qo,$o,ca,!1,oa),o===null))return;let c=t.ray.origin.distanceTo(oa);c<t.near||c>t.far||e.push({distance:c,point:oa.clone(),uv:Ln.getInterpolation(oa,qo,ca,$o,wf,lu,Tf,new ot),face:null,object:this})}copy(t,e){return super.copy(t,e),t.center!==void 0&&this.center.copy(t.center),this.material=t.material,this}};function Yo(n,t,e,i,s,r){er.subVectors(n,e).addScalar(.5).multiply(i),s!==void 0?(la.x=r*er.x-s*er.y,la.y=s*er.x+r*er.y):la.copy(er),n.copy(t),n.x+=la.x,n.y+=la.y,n.applyMatrix4(U0)}var In=new D,cu=new D,Zo=new D,Jo=new D,Ts=class{constructor(t=new D,e=new D(0,0,-1)){this.origin=t,this.direction=e}set(t,e){return this.origin.copy(t),this.direction.copy(e),this}copy(t){return this.origin.copy(t.origin),this.direction.copy(t.direction),this}at(t,e){return e.copy(this.origin).addScaledVector(this.direction,t)}lookAt(t){return this.direction.copy(t).sub(this.origin).normalize(),this}recast(t){return this.origin.copy(this.at(t,In)),this}closestPointToPoint(t,e){e.subVectors(t,this.origin);let i=e.dot(this.direction);return i<0?e.copy(this.origin):e.copy(this.origin).addScaledVector(this.direction,i)}distanceToPoint(t){return Math.sqrt(this.distanceSqToPoint(t))}distanceSqToPoint(t){let e=In.subVectors(t,this.origin).dot(this.direction);return e<0?this.origin.distanceToSquared(t):(In.copy(this.origin).addScaledVector(this.direction,e),In.distanceToSquared(t))}distanceSqToSegment(t,e,i,s){cu.copy(t).add(e).multiplyScalar(.5),Zo.copy(e).sub(t).normalize(),Jo.copy(this.origin).sub(cu);let r=t.distanceTo(e)*.5,a=-this.direction.dot(Zo),o=Jo.dot(this.direction),c=-Jo.dot(Zo),l=Jo.lengthSq(),h=Math.abs(1-a*a),u,d,f,p;if(h>0)if(u=a*c-o,d=a*o-c,p=r*h,u>=0)if(d>=-p)if(d<=p){let x=1/h;u*=x,d*=x,f=u*(u+a*d+2*o)+d*(a*u+d+2*c)+l}else d=r,u=Math.max(0,-(a*d+o)),f=-u*u+d*(d+2*c)+l;else d=-r,u=Math.max(0,-(a*d+o)),f=-u*u+d*(d+2*c)+l;else d<=-p?(u=Math.max(0,-(-a*r+o)),d=u>0?-r:Math.min(Math.max(-r,-c),r),f=-u*u+d*(d+2*c)+l):d<=p?(u=0,d=Math.min(Math.max(-r,-c),r),f=d*(d+2*c)+l):(u=Math.max(0,-(a*r+o)),d=u>0?r:Math.min(Math.max(-r,-c),r),f=-u*u+d*(d+2*c)+l);else d=a>0?-r:r,u=Math.max(0,-(a*d+o)),f=-u*u+d*(d+2*c)+l;return i&&i.copy(this.origin).addScaledVector(this.direction,u),s&&s.copy(cu).addScaledVector(Zo,d),f}intersectSphere(t,e){if(t.radius<0)return null;In.subVectors(t.center,this.origin);let i=In.dot(this.direction),s=In.dot(In)-i*i,r=t.radius*t.radius;if(s>r)return null;let a=Math.sqrt(r-s),o=i-a,c=i+a;return c<0?null:o<0?this.at(c,e):this.at(o,e)}intersectsSphere(t){return t.radius<0?!1:this.distanceSqToPoint(t.center)<=t.radius*t.radius}distanceToPlane(t){let e=t.normal.dot(this.direction);if(e===0)return t.distanceToPoint(this.origin)===0?0:null;let i=-(this.origin.dot(t.normal)+t.constant)/e;return i>=0?i:null}intersectPlane(t,e){let i=this.distanceToPlane(t);return i===null?null:this.at(i,e)}intersectsPlane(t){let e=t.distanceToPoint(this.origin);return e===0||t.normal.dot(this.direction)*e<0}intersectBox(t,e){let i,s,r,a,o,c,l=1/this.direction.x,h=1/this.direction.y,u=1/this.direction.z,d=this.origin;return l>=0?(i=(t.min.x-d.x)*l,s=(t.max.x-d.x)*l):(i=(t.max.x-d.x)*l,s=(t.min.x-d.x)*l),h>=0?(r=(t.min.y-d.y)*h,a=(t.max.y-d.y)*h):(r=(t.max.y-d.y)*h,a=(t.min.y-d.y)*h),i>a||r>s||((r>i||isNaN(i))&&(i=r),(a<s||isNaN(s))&&(s=a),u>=0?(o=(t.min.z-d.z)*u,c=(t.max.z-d.z)*u):(o=(t.max.z-d.z)*u,c=(t.min.z-d.z)*u),i>c||o>s)||((o>i||i!==i)&&(i=o),(c<s||s!==s)&&(s=c),s<0)?null:this.at(i>=0?i:s,e)}intersectsBox(t){return this.intersectBox(t,In)!==null}intersectTriangle(t,e,i,s,r){let a=this.origin,o=this.direction,c=o.x,l=o.y,h=o.z,u=t.x-a.x,d=t.y-a.y,f=t.z-a.z,p=e.x-a.x,x=e.y-a.y,m=e.z-a.z,g=i.x-a.x,_=i.y-a.y,T=i.z-a.z,v=Math.abs(c),S=Math.abs(l),M=Math.abs(h),A,y,E,P,N,F,B,I,H,W,U,X;if(v>=S&&v>=M?(E=c,F=u,H=p,X=g,c>=0?(A=l,y=h,P=d,N=f,B=x,I=m,W=_,U=T):(A=h,y=l,P=f,N=d,B=m,I=x,W=T,U=_)):S>=M?(E=l,F=d,H=x,X=_,l>=0?(A=h,y=c,P=f,N=u,B=m,I=p,W=T,U=g):(A=c,y=h,P=u,N=f,B=p,I=m,W=g,U=T)):(E=h,F=f,H=m,X=T,h>=0?(A=c,y=l,P=u,N=d,B=p,I=x,W=g,U=_):(A=l,y=c,P=d,N=u,B=x,I=p,W=_,U=g)),E===0)return null;let G=A/E,j=y/E,et=1/E,vt=P-G*F,ht=N-j*F,Ut=B-G*H,$t=I-j*H,Kt=W-G*X,$=U-j*X,rt=Kt*$t-$*Ut,_t=vt*$-ht*Kt,Jt=Ut*ht-$t*vt;if(s){if(rt<0||_t<0||Jt<0)return null}else if((rt<0||_t<0||Jt<0)&&(rt>0||_t>0||Jt>0))return null;let At=rt+_t+Jt;if(At===0)return null;let Yt=et*(rt*F+_t*H+Jt*X);return(At>0?Yt<0:Yt>0)?null:this.at(Yt/At,r)}applyMatrix4(t){return this.origin.applyMatrix4(t),this.direction.transformDirection(t),this}equals(t){return t.origin.equals(this.origin)&&t.direction.equals(this.direction)}clone(){return new this.constructor().copy(this)}},He=class extends qi{constructor(t){super(),this.isMeshBasicMaterial=!0,this.type="MeshBasicMaterial",this.color=new Nt(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Ai,this.combine=Kl,this.reflectivity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.specularMap=t.specularMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.combine=t.combine,this.reflectivity=t.reflectivity,this.refractionRatio=t.refractionRatio,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.fog=t.fog,this}},Ef=new me,bs=new Ts,Ko=new Xi,Af=new D,jo=new D,Qo=new D,tl=new D,hu=new D,el=new D,Rf=new D,il=new D,Pt=class extends Ze{constructor(t=new ge,e=new He){super(),this.isMesh=!0,this.type="Mesh",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.count=1,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),t.morphTargetInfluences!==void 0&&(this.morphTargetInfluences=t.morphTargetInfluences.slice()),t.morphTargetDictionary!==void 0&&(this.morphTargetDictionary=Object.assign({},t.morphTargetDictionary)),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}getVertexPosition(t,e){let i=this.geometry,s=i.attributes.position,r=i.morphAttributes.position,a=i.morphTargetsRelative;e.fromBufferAttribute(s,t);let o=this.morphTargetInfluences;if(r&&o){el.set(0,0,0);for(let c=0,l=r.length;c<l;c++){let h=o[c],u=r[c];h!==0&&(hu.fromBufferAttribute(u,t),a?el.addScaledVector(hu,h):el.addScaledVector(hu.sub(e),h))}e.add(el)}return e}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.material,r=this.matrixWorld;s!==void 0&&(i.boundingSphere===null&&i.computeBoundingSphere(),Ko.copy(i.boundingSphere),Ko.applyMatrix4(r),bs.copy(t.ray).recast(t.near),!(Ko.containsPoint(bs.origin)===!1&&(bs.intersectSphere(Ko,Af)===null||bs.origin.distanceToSquared(Af)>(t.far-t.near)**2))&&(Ef.copy(r).invert(),bs.copy(t.ray).applyMatrix4(Ef),!(i.boundingBox!==null&&bs.intersectsBox(i.boundingBox)===!1)&&this._computeIntersections(t,e,bs)))}_computeIntersections(t,e,i){let s,r=this.geometry,a=this.material,o=r.index,c=r.attributes.position,l=r.attributes.uv,h=r.attributes.uv1,u=r.attributes.normal,d=r.groups,f=r.drawRange;if(o!==null)if(Array.isArray(a))for(let p=0,x=d.length;p<x;p++){let m=d[p],g=a[m.materialIndex],_=Math.max(m.start,f.start),T=Math.min(o.count,Math.min(m.start+m.count,f.start+f.count));for(let v=_,S=T;v<S;v+=3){let M=o.getX(v),A=o.getX(v+1),y=o.getX(v+2);s=nl(this,g,t,i,l,h,u,M,A,y),s&&(s.faceIndex=Math.floor(v/3),s.face.materialIndex=m.materialIndex,e.push(s))}}else{let p=Math.max(0,f.start),x=Math.min(o.count,f.start+f.count);for(let m=p,g=x;m<g;m+=3){let _=o.getX(m),T=o.getX(m+1),v=o.getX(m+2);s=nl(this,a,t,i,l,h,u,_,T,v),s&&(s.faceIndex=Math.floor(m/3),e.push(s))}}else if(c!==void 0)if(Array.isArray(a))for(let p=0,x=d.length;p<x;p++){let m=d[p],g=a[m.materialIndex],_=Math.max(m.start,f.start),T=Math.min(c.count,Math.min(m.start+m.count,f.start+f.count));for(let v=_,S=T;v<S;v+=3){let M=v,A=v+1,y=v+2;s=nl(this,g,t,i,l,h,u,M,A,y),s&&(s.faceIndex=Math.floor(v/3),s.face.materialIndex=m.materialIndex,e.push(s))}}else{let p=Math.max(0,f.start),x=Math.min(c.count,f.start+f.count);for(let m=p,g=x;m<g;m+=3){let _=m,T=m+1,v=m+2;s=nl(this,a,t,i,l,h,u,_,T,v),s&&(s.faceIndex=Math.floor(m/3),e.push(s))}}}};function jm(n,t,e,i,s,r,a,o){let c;if(t.side===di?c=i.intersectTriangle(a,r,s,!0,o):c=i.intersectTriangle(s,r,a,t.side===rs,o),c===null)return null;il.copy(o),il.applyMatrix4(n.matrixWorld);let l=e.ray.origin.distanceTo(il);return l<e.near||l>e.far?null:{distance:l,point:il.clone(),object:n}}function nl(n,t,e,i,s,r,a,o,c,l){n.getVertexPosition(o,jo),n.getVertexPosition(c,Qo),n.getVertexPosition(l,tl);let h=jm(n,t,e,i,jo,Qo,tl,Rf);if(h){let u=new D;Ln.getBarycoord(Rf,jo,Qo,tl,u),s&&(h.uv=Ln.getInterpolatedAttribute(s,o,c,l,u,new ot)),r&&(h.uv1=Ln.getInterpolatedAttribute(r,o,c,l,u,new ot)),a&&(h.normal=Ln.getInterpolatedAttribute(a,o,c,l,u,new D),h.normal.dot(i.direction)>0&&h.normal.multiplyScalar(-1));let d={a:o,b:c,c:l,normal:new D,materialIndex:0};Ln.getNormal(jo,Qo,tl,d.normal),h.face=d,h.barycoord=u}return h}var Ca=class extends wi{constructor(t=null,e=1,i=1,s,r,a,o,c,l=oi,h=oi,u,d){super(null,a,o,c,l,h,s,r,u,d),this.isDataTexture=!0,this.image={data:t,width:e,height:i},this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}};var xr=class extends ti{constructor(t,e,i,s=1){super(t,e,i),this.isInstancedBufferAttribute=!0,this.meshPerAttribute=s}copy(t){return super.copy(t),this.meshPerAttribute=t.meshPerAttribute,this}toJSON(){let t=super.toJSON();return t.meshPerAttribute=this.meshPerAttribute,t.isInstancedBufferAttribute=!0,t}},ir=new me,Cf=new me,sl=[],Pf=new _n,Qm=new me,ha=new Pt,ua=new Xi,Pa=class extends Pt{constructor(t,e,i){super(t,e),this.isInstancedMesh=!0,this.instanceMatrix=new xr(new Float32Array(i*16),16),this.instanceColor=null,this.morphTexture=null,this.count=i,this.boundingBox=null,this.boundingSphere=null;for(let s=0;s<i;s++)this.setMatrixAt(s,Qm)}computeBoundingBox(){let t=this.geometry,e=this.count;this.boundingBox===null&&(this.boundingBox=new _n),t.boundingBox===null&&t.computeBoundingBox(),this.boundingBox.makeEmpty();for(let i=0;i<e;i++)this.getMatrixAt(i,ir),Pf.copy(t.boundingBox).applyMatrix4(ir),this.boundingBox.union(Pf)}computeBoundingSphere(){let t=this.geometry,e=this.count;this.boundingSphere===null&&(this.boundingSphere=new Xi),t.boundingSphere===null&&t.computeBoundingSphere(),this.boundingSphere.makeEmpty();for(let i=0;i<e;i++)this.getMatrixAt(i,ir),ua.copy(t.boundingSphere).applyMatrix4(ir),this.boundingSphere.union(ua)}copy(t,e){return super.copy(t,e),this.instanceMatrix.copy(t.instanceMatrix),t.morphTexture!==null&&(this.morphTexture=t.morphTexture.clone()),t.instanceColor!==null&&(this.instanceColor=t.instanceColor.clone()),this.count=t.count,t.boundingBox!==null&&(this.boundingBox=t.boundingBox.clone()),t.boundingSphere!==null&&(this.boundingSphere=t.boundingSphere.clone()),this}getColorAt(t,e){return this.instanceColor===null?e.setRGB(1,1,1):e.fromArray(this.instanceColor.array,t*3)}getMatrixAt(t,e){return e.fromArray(this.instanceMatrix.array,t*16)}getMorphAt(t,e){let i=e.morphTargetInfluences,s=this.morphTexture.source.data.data,r=i.length+1,a=t*r+1;for(let o=0;o<i.length;o++)i[o]=s[a+o]}raycast(t,e){let i=this.matrixWorld,s=this.count;if(ha.geometry=this.geometry,ha.material=this.material,ha.material!==void 0&&(this.boundingSphere===null&&this.computeBoundingSphere(),ua.copy(this.boundingSphere),ua.applyMatrix4(i),t.ray.intersectsSphere(ua)!==!1))for(let r=0;r<s;r++){this.getMatrixAt(r,ir),Cf.multiplyMatrices(i,ir),ha.matrixWorld=Cf,ha.raycast(t,sl);for(let a=0,o=sl.length;a<o;a++){let c=sl[a];c.instanceId=r,c.object=this,e.push(c)}sl.length=0}}setColorAt(t,e){return this.instanceColor===null&&(this.instanceColor=new xr(new Float32Array(this.instanceMatrix.count*3).fill(1),3)),e.toArray(this.instanceColor.array,t*3),this}setMatrixAt(t,e){return e.toArray(this.instanceMatrix.array,t*16),this}setMorphAt(t,e){let i=e.morphTargetInfluences,s=i.length+1;this.morphTexture===null&&(this.morphTexture=new Ca(new Float32Array(s*this.count),s,this.count,sc,Zi));let r=this.morphTexture.source.data.data,a=0;for(let l=0;l<i.length;l++)a+=i[l];let o=this.geometry.morphTargetsRelative?1:1-a,c=s*t;return r[c]=o,r.set(i,c+1),this}updateMorphTargets(){}dispose(){super.dispose(),this.morphTexture!==null&&(this.morphTexture.dispose(),this.morphTexture=null)}},Ms=new Xi,tg=new ot(.5,.5),rl=new D,vr=class{constructor(t=new Si,e=new Si,i=new Si,s=new Si,r=new Si,a=new Si){this.planes=[t,e,i,s,r,a]}set(t,e,i,s,r,a){let o=this.planes;return o[0].copy(t),o[1].copy(e),o[2].copy(i),o[3].copy(s),o[4].copy(r),o[5].copy(a),this}copy(t){let e=this.planes;for(let i=0;i<6;i++)e[i].copy(t.planes[i]);return this}setFromProjectionMatrix(t,e=an,i=!1){let s=this.planes,r=t.elements,a=r[0],o=r[1],c=r[2],l=r[3],h=r[4],u=r[5],d=r[6],f=r[7],p=r[8],x=r[9],m=r[10],g=r[11],_=r[12],T=r[13],v=r[14],S=r[15];if(s[0].setComponents(l-a,f-h,g-p,S-_).normalize(),s[1].setComponents(l+a,f+h,g+p,S+_).normalize(),s[2].setComponents(l+o,f+u,g+x,S+T).normalize(),s[3].setComponents(l-o,f-u,g-x,S-T).normalize(),i)s[4].setComponents(c,d,m,v).normalize(),s[5].setComponents(l-c,f-d,g-m,S-v).normalize();else if(s[4].setComponents(l-c,f-d,g-m,S-v).normalize(),e===an)s[5].setComponents(l+c,f+d,g+m,S+v).normalize();else if(e===cr)s[5].setComponents(c,d,m,v).normalize();else throw new Error("THREE.Frustum.setFromProjectionMatrix(): Invalid coordinate system: "+e);return this}intersectsObject(t){if(t.boundingSphere!==void 0)t.boundingSphere===null&&t.computeBoundingSphere(),Ms.copy(t.boundingSphere).applyMatrix4(t.matrixWorld);else{let e=t.geometry;e.boundingSphere===null&&e.computeBoundingSphere(),Ms.copy(e.boundingSphere).applyMatrix4(t.matrixWorld)}return this.intersectsSphere(Ms)}intersectsSprite(t){Ms.center.set(0,0,0);let e=tg.distanceTo(t.center);return Ms.radius=.7071067811865476+e,Ms.applyMatrix4(t.matrixWorld),this.intersectsSphere(Ms)}intersectsSphere(t){let e=this.planes,i=t.center,s=-t.radius;for(let r=0;r<6;r++)if(e[r].distanceToPoint(i)<s)return!1;return!0}intersectsBox(t){let e=this.planes;for(let i=0;i<6;i++){let s=e[i];if(rl.x=s.normal.x>0?t.max.x:t.min.x,rl.y=s.normal.y>0?t.max.y:t.min.y,rl.z=s.normal.z>0?t.max.z:t.min.z,s.distanceToPoint(rl)<0)return!1}return!0}containsPoint(t){let e=this.planes;for(let i=0;i<6;i++)if(e[i].distanceToPoint(t)<0)return!1;return!0}clone(){return new this.constructor().copy(this)}};var yr=class extends qi{constructor(t){super(),this.isLineBasicMaterial=!0,this.type="LineBasicMaterial",this.color=new Nt(16777215),this.map=null,this.linewidth=1,this.linecap="round",this.linejoin="round",this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.linewidth=t.linewidth,this.linecap=t.linecap,this.linejoin=t.linejoin,this.fog=t.fog,this}},Al=new D,Rl=new D,If=new me,da=new Ts,al=new Xi,uu=new D,Lf=new D,Cl=class extends Ze{constructor(t=new ge,e=new yr){super(),this.isLine=!0,this.type="Line",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}computeLineDistances(){let t=this.geometry;if(t.index===null){let e=t.attributes.position,i=[0];for(let s=1,r=e.count;s<r;s++)Al.fromBufferAttribute(e,s-1),Rl.fromBufferAttribute(e,s),i[s]=i[s-1],i[s]+=Al.distanceTo(Rl);t.setAttribute("lineDistance",new qt(i,1))}else te("Line.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.matrixWorld,r=t.params.Line.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),al.copy(i.boundingSphere),al.applyMatrix4(s),al.radius+=r,t.ray.intersectsSphere(al)===!1)return;If.copy(s).invert(),da.copy(t.ray).applyMatrix4(If);let o=r/((this.scale.x+this.scale.y+this.scale.z)/3),c=o*o,l=this.isLineSegments?2:1,h=i.index,d=i.attributes.position;if(h!==null){let f=Math.max(0,a.start),p=Math.min(h.count,a.start+a.count);for(let x=f,m=p-1;x<m;x+=l){let g=h.getX(x),_=h.getX(x+1),T=ol(this,t,da,c,g,_,x);T&&e.push(T)}if(this.isLineLoop){let x=h.getX(p-1),m=h.getX(f),g=ol(this,t,da,c,x,m,p-1);g&&e.push(g)}}else{let f=Math.max(0,a.start),p=Math.min(d.count,a.start+a.count);for(let x=f,m=p-1;x<m;x+=l){let g=ol(this,t,da,c,x,x+1,x);g&&e.push(g)}if(this.isLineLoop){let x=ol(this,t,da,c,p-1,f,p-1);x&&e.push(x)}}}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}};function ol(n,t,e,i,s,r,a){let o=n.geometry.attributes.position;if(Al.fromBufferAttribute(o,s),Rl.fromBufferAttribute(o,r),e.distanceSqToSegment(Al,Rl,uu,Lf)>i)return;uu.applyMatrix4(n.matrixWorld);let l=t.ray.origin.distanceTo(uu);if(!(l<t.near||l>t.far))return{distance:l,point:Lf.clone().applyMatrix4(n.matrixWorld),index:a,face:null,faceIndex:null,barycoord:null,object:n}}var Df=new D,Nf=new D,Ia=class extends Cl{constructor(t,e){super(t,e),this.isLineSegments=!0,this.type="LineSegments"}computeLineDistances(){let t=this.geometry;if(t.index===null){let e=t.attributes.position,i=[];for(let s=0,r=e.count;s<r;s+=2)Df.fromBufferAttribute(e,s),Nf.fromBufferAttribute(e,s+1),i[s]=s===0?0:i[s-1],i[s+1]=i[s]+Df.distanceTo(Nf);t.setAttribute("lineDistance",new qt(i,1))}else te("LineSegments.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}};var Pl=class extends qi{constructor(t){super(),this.isPointsMaterial=!0,this.type="PointsMaterial",this.color=new Nt(16777215),this.map=null,this.alphaMap=null,this.size=1,this.sizeAttenuation=!0,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.alphaMap=t.alphaMap,this.size=t.size,this.sizeAttenuation=t.sizeAttenuation,this.fog=t.fog,this}},Uf=new me,bu=new Ts,ll=new Xi,cl=new D,La=class extends Ze{constructor(t=new ge,e=new Pl){super(),this.isPoints=!0,this.type="Points",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.matrixWorld,r=t.params.Points.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),ll.copy(i.boundingSphere),ll.applyMatrix4(s),ll.radius+=r,t.ray.intersectsSphere(ll)===!1)return;Uf.copy(s).invert(),bu.copy(t.ray).applyMatrix4(Uf);let o=r/((this.scale.x+this.scale.y+this.scale.z)/3),c=o*o,l=i.index,u=i.attributes.position;if(l!==null){let d=Math.max(0,a.start),f=Math.min(l.count,a.start+a.count);for(let p=d,x=f;p<x;p++){let m=l.getX(p);cl.fromBufferAttribute(u,m),Ff(cl,m,c,s,t,e,this)}}else{let d=Math.max(0,a.start),f=Math.min(u.count,a.start+a.count);for(let p=d,x=f;p<x;p++)cl.fromBufferAttribute(u,p),Ff(cl,p,c,s,t,e,this)}}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}};function Ff(n,t,e,i,s,r,a){let o=bu.distanceSqToPoint(n);if(o<e){let c=new D;bu.closestPointToPoint(n,c),c.applyMatrix4(i);let l=s.ray.origin.distanceTo(c);if(l<s.near||l>s.far)return;r.push({distance:l,distanceToRay:Math.sqrt(o),point:c,index:t,face:null,faceIndex:null,barycoord:null,object:a})}}var Da=class extends wi{constructor(t=[],e=os,i,s,r,a,o,c,l,h){super(t,e,i,s,r,a,o,c,l,h),this.isCubeTexture=!0,this.flipY=!1}get images(){return this.image}set images(t){this.image=t}},ui=class extends wi{constructor(t,e,i,s,r,a,o,c,l){super(t,e,i,s,r,a,o,c,l),this.isCanvasTexture=!0,this.needsUpdate=!0}};var jn=class extends wi{constructor(t,e,i=cn,s,r,a,o=oi,c=oi,l,h=vn,u=1){if(h!==vn&&h!==ls)throw new Error("THREE.DepthTexture: format must be either THREE.DepthFormat or THREE.DepthStencilFormat");let d={width:t,height:e,depth:u};super(d,s,r,a,o,c,h,i,l),this.isDepthTexture=!0,this.flipY=!1,this.generateMipmaps=!1,this.compareFunction=null}copy(t){return super.copy(t),this.source=new dr(Object.assign({},t.image)),this.compareFunction=t.compareFunction,this}toJSON(t){let e=super.toJSON(t);return e.compareFunction=this.compareFunction,e}},Il=class extends jn{constructor(t,e=cn,i=os,s,r,a=oi,o=oi,c,l=vn){let h={width:t,height:t,depth:1},u=[h,h,h,h,h,h];super(t,t,e,i,s,r,a,o,c,l),this.image=u,this.isCubeDepthTexture=!0,this.isCubeTexture=!0}get images(){return this.image}set images(t){this.image=t}},Na=class extends wi{constructor(t=null){super(),this.sourceTexture=t,this.isExternalTexture=!0}copy(t){return super.copy(t),this.sourceTexture=t.sourceTexture,this}},$i=class n extends ge{constructor(t=1,e=1,i=1,s=1,r=1,a=1){super(),this.type="BoxGeometry",this.parameters={width:t,height:e,depth:i,widthSegments:s,heightSegments:r,depthSegments:a};let o=this;s=Math.floor(s),r=Math.floor(r),a=Math.floor(a);let c=[],l=[],h=[],u=[],d=0,f=0;p("z","y","x",-1,-1,i,e,t,a,r,0),p("z","y","x",1,-1,i,e,-t,a,r,1),p("x","z","y",1,1,t,i,e,s,a,2),p("x","z","y",1,-1,t,i,-e,s,a,3),p("x","y","z",1,-1,t,e,i,s,r,4),p("x","y","z",-1,-1,t,e,-i,s,r,5),this.setIndex(c),this.setAttribute("position",new qt(l,3)),this.setAttribute("normal",new qt(h,3)),this.setAttribute("uv",new qt(u,2));function p(x,m,g,_,T,v,S,M,A,y,E){let P=v/A,N=S/y,F=v/2,B=S/2,I=M/2,H=A+1,W=y+1,U=0,X=0,G=new D;for(let j=0;j<W;j++){let et=j*N-B;for(let vt=0;vt<H;vt++){let ht=vt*P-F;G[x]=ht*_,G[m]=et*T,G[g]=I,l.push(G.x,G.y,G.z),G[x]=0,G[m]=0,G[g]=M>0?1:-1,h.push(G.x,G.y,G.z),u.push(vt/A),u.push(1-j/y),U+=1}}for(let j=0;j<y;j++)for(let et=0;et<A;et++){let vt=d+et+H*j,ht=d+et+H*(j+1),Ut=d+(et+1)+H*(j+1),$t=d+(et+1)+H*j;c.push(vt,ht,$t),c.push(ht,Ut,$t),X+=6}o.addGroup(f,X,E),f+=X,d+=U}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.width,t.height,t.depth,t.widthSegments,t.heightSegments,t.depthSegments)}},Es=class n extends ge{constructor(t=1,e=1,i=4,s=8,r=1){super(),this.type="CapsuleGeometry",this.parameters={radius:t,height:e,capSegments:i,radialSegments:s,heightSegments:r},e=Math.max(0,e),i=Math.max(1,Math.floor(i)),s=Math.max(3,Math.floor(s)),r=Math.max(1,Math.floor(r));let a=[],o=[],c=[],l=[],h=e/2,u=Math.PI/2*t,d=e,f=2*u+d,p=i*2+r,x=s+1,m=new D,g=new D;for(let _=0;_<=p;_++){let T=0,v=0,S=0,M=0;if(_<=i){let E=_/i,P=E*Math.PI/2;v=-h-t*Math.cos(P),S=t*Math.sin(P),M=-t*Math.cos(P),T=E*u}else if(_<=i+r){let E=(_-i)/r;v=-h+E*e,S=t,M=0,T=u+E*d}else{let E=(_-i-r)/i,P=E*Math.PI/2;v=h+t*Math.sin(P),S=t*Math.cos(P),M=t*Math.sin(P),T=u+d+E*u}let A=Math.max(0,Math.min(1,T/f)),y=0;_===0?y=.5/s:_===p&&(y=-.5/s);for(let E=0;E<=s;E++){let P=E/s,N=P*Math.PI*2,F=Math.sin(N),B=Math.cos(N);g.x=-S*B,g.y=v,g.z=S*F,o.push(g.x,g.y,g.z),m.set(-S*B,M,S*F),m.normalize(),c.push(m.x,m.y,m.z),l.push(P+y,A)}if(_>0){let E=(_-1)*x;for(let P=0;P<s;P++){let N=E+P,F=E+P+1,B=_*x+P,I=_*x+P+1;a.push(N,F,B),a.push(F,I,B)}}}this.setIndex(a),this.setAttribute("position",new qt(o,3)),this.setAttribute("normal",new qt(c,3)),this.setAttribute("uv",new qt(l,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.height,t.capSegments,t.radialSegments,t.heightSegments)}},on=class n extends ge{constructor(t=1,e=32,i=0,s=Math.PI*2){super(),this.type="CircleGeometry",this.parameters={radius:t,segments:e,thetaStart:i,thetaLength:s},e=Math.max(3,e);let r=[],a=[],o=[],c=[],l=new D,h=new ot;a.push(0,0,0),o.push(0,0,1),c.push(.5,.5);for(let u=0,d=3;u<=e;u++,d+=3){let f=i+u/e*s;l.x=t*Math.cos(f),l.y=t*Math.sin(f),a.push(l.x,l.y,l.z),o.push(0,0,1),h.x=(a[d]/t+1)/2,h.y=(a[d+1]/t+1)/2,c.push(h.x,h.y)}for(let u=1;u<=e;u++)r.push(u,u+1,0);this.setIndex(r),this.setAttribute("position",new qt(a,3)),this.setAttribute("normal",new qt(o,3)),this.setAttribute("uv",new qt(c,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.segments,t.thetaStart,t.thetaLength)}},Ge=class n extends ge{constructor(t=1,e=1,i=1,s=32,r=1,a=!1,o=0,c=Math.PI*2){super(),this.type="CylinderGeometry",this.parameters={radiusTop:t,radiusBottom:e,height:i,radialSegments:s,heightSegments:r,openEnded:a,thetaStart:o,thetaLength:c};let l=this;s=Math.floor(s),r=Math.floor(r);let h=[],u=[],d=[],f=[],p=0,x=[],m=i/2,g=0;_(),a===!1&&(t>0&&T(!0),e>0&&T(!1)),this.setIndex(h),this.setAttribute("position",new qt(u,3)),this.setAttribute("normal",new qt(d,3)),this.setAttribute("uv",new qt(f,2));function _(){let v=new D,S=new D,M=0,A=(e-t)/i;for(let y=0;y<=r;y++){let E=[],P=y/r,N=P*(e-t)+t;for(let F=0;F<=s;F++){let B=F/s,I=B*c+o,H=Math.sin(I),W=Math.cos(I);S.x=N*H,S.y=-P*i+m,S.z=N*W,u.push(S.x,S.y,S.z),v.set(H,A,W).normalize(),d.push(v.x,v.y,v.z),f.push(B,1-P),E.push(p++)}x.push(E)}for(let y=0;y<s;y++)for(let E=0;E<r;E++){let P=x[E][y],N=x[E+1][y],F=x[E+1][y+1],B=x[E][y+1];(t>0||E!==0)&&(h.push(P,N,B),M+=3),(e>0||E!==r-1)&&(h.push(N,F,B),M+=3)}l.addGroup(g,M,0),g+=M}function T(v){let S=p,M=new ot,A=new D,y=0,E=v===!0?t:e,P=v===!0?1:-1;for(let F=1;F<=s;F++)u.push(0,m*P,0),d.push(0,P,0),f.push(.5,.5),p++;let N=p;for(let F=0;F<=s;F++){let I=F/s*c+o,H=Math.cos(I),W=Math.sin(I);A.x=E*W,A.y=m*P,A.z=E*H,u.push(A.x,A.y,A.z),d.push(0,P,0),M.x=H*.5+.5,M.y=W*.5*P+.5,f.push(M.x,M.y),p++}for(let F=0;F<s;F++){let B=S+F,I=N+F;v===!0?h.push(I,I+1,B):h.push(I+1,I,B),y+=3}l.addGroup(g,y,v===!0?1:2),g+=y}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radiusTop,t.radiusBottom,t.height,t.radialSegments,t.heightSegments,t.openEnded,t.thetaStart,t.thetaLength)}},xi=class n extends Ge{constructor(t=1,e=1,i=32,s=1,r=!1,a=0,o=Math.PI*2){super(0,t,e,i,s,r,a,o),this.type="ConeGeometry",this.parameters={radius:t,height:e,radialSegments:i,heightSegments:s,openEnded:r,thetaStart:a,thetaLength:o}}static fromJSON(t){return new n(t.radius,t.height,t.radialSegments,t.heightSegments,t.openEnded,t.thetaStart,t.thetaLength)}},_r=class n extends ge{constructor(t=[],e=[],i=1,s=0){super(),this.type="PolyhedronGeometry",this.parameters={vertices:t,indices:e,radius:i,detail:s};let r=[],a=[];o(s),l(i),h(),this.setAttribute("position",new qt(r,3)),this.setAttribute("normal",new qt(r.slice(),3)),this.setAttribute("uv",new qt(a,2)),s===0?this.computeVertexNormals():this.normalizeNormals();function o(_){let T=new D,v=new D,S=new D;for(let M=0;M<e.length;M+=3)f(e[M+0],T),f(e[M+1],v),f(e[M+2],S),c(T,v,S,_)}function c(_,T,v,S){let M=S+1,A=[];for(let y=0;y<=M;y++){A[y]=[];let E=_.clone().lerp(v,y/M),P=T.clone().lerp(v,y/M),N=M-y;for(let F=0;F<=N;F++)F===0&&y===M?A[y][F]=E:A[y][F]=E.clone().lerp(P,F/N)}for(let y=0;y<M;y++)for(let E=0;E<2*(M-y)-1;E++){let P=Math.floor(E/2);E%2===0?(d(A[y][P+1]),d(A[y+1][P]),d(A[y][P])):(d(A[y][P+1]),d(A[y+1][P+1]),d(A[y+1][P]))}}function l(_){let T=new D;for(let v=0;v<r.length;v+=3)T.x=r[v+0],T.y=r[v+1],T.z=r[v+2],T.normalize().multiplyScalar(_),r[v+0]=T.x,r[v+1]=T.y,r[v+2]=T.z}function h(){let _=new D;for(let T=0;T<r.length;T+=3){_.x=r[T+0],_.y=r[T+1],_.z=r[T+2];let v=m(_)/2/Math.PI+.5,S=g(_)/Math.PI+.5;a.push(v,1-S)}p(),u()}function u(){for(let _=0;_<a.length;_+=6){let T=a[_+0],v=a[_+2],S=a[_+4],M=Math.max(T,v,S),A=Math.min(T,v,S);M>.9&&A<.1&&(T<.2&&(a[_+0]+=1),v<.2&&(a[_+2]+=1),S<.2&&(a[_+4]+=1))}}function d(_){r.push(_.x,_.y,_.z)}function f(_,T){let v=_*3;T.x=t[v+0],T.y=t[v+1],T.z=t[v+2]}function p(){let _=new D,T=new D,v=new D,S=new D,M=new ot,A=new ot,y=new ot;for(let E=0,P=0;E<r.length;E+=9,P+=6){_.set(r[E+0],r[E+1],r[E+2]),T.set(r[E+3],r[E+4],r[E+5]),v.set(r[E+6],r[E+7],r[E+8]),M.set(a[P+0],a[P+1]),A.set(a[P+2],a[P+3]),y.set(a[P+4],a[P+5]),S.copy(_).add(T).add(v).divideScalar(3);let N=m(S);x(M,P+0,_,N),x(A,P+2,T,N),x(y,P+4,v,N)}}function x(_,T,v,S){S<0&&_.x===1&&(a[T]=_.x-1),v.x===0&&v.z===0&&(a[T]=S/2/Math.PI+.5)}function m(_){return Math.atan2(_.z,-_.x)}function g(_){return Math.atan2(-_.y,Math.sqrt(_.x*_.x+_.z*_.z))}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.vertices,t.indices,t.radius,t.detail)}},Ua=class n extends _r{constructor(t=1,e=0){let i=(1+Math.sqrt(5))/2,s=1/i,r=[-1,-1,-1,-1,-1,1,-1,1,-1,-1,1,1,1,-1,-1,1,-1,1,1,1,-1,1,1,1,0,-s,-i,0,-s,i,0,s,-i,0,s,i,-s,-i,0,-s,i,0,s,-i,0,s,i,0,-i,0,-s,i,0,-s,-i,0,s,i,0,s],a=[3,11,7,3,7,15,3,15,13,7,19,17,7,17,6,7,6,15,17,4,8,17,8,10,17,10,6,8,0,16,8,16,2,8,2,10,0,12,1,0,1,18,0,18,16,6,10,2,6,2,13,6,13,15,2,16,18,2,18,3,2,3,13,18,1,9,18,9,11,18,11,3,4,14,12,4,12,0,4,0,8,11,9,5,11,5,19,11,19,7,19,5,14,19,14,4,19,4,17,1,12,14,1,14,5,1,5,9];super(r,a,t,e),this.type="DodecahedronGeometry",this.parameters={radius:t,detail:e}}static fromJSON(t){return new n(t.radius,t.detail)}};var Ui=class{constructor(){this.type="Curve",this.arcLengthDivisions=200,this.needsUpdate=!1,this.cacheArcLengths=null}getPoint(){te("Curve: .getPoint() not implemented.")}getPointAt(t,e){let i=this.getUtoTmapping(t);return this.getPoint(i,e)}getPoints(t=5){let e=[];for(let i=0;i<=t;i++)e.push(this.getPoint(i/t));return e}getSpacedPoints(t=5){let e=[];for(let i=0;i<=t;i++)e.push(this.getPointAt(i/t));return e}getLength(){let t=this.getLengths();return t[t.length-1]}getLengths(t=this.arcLengthDivisions){if(this.cacheArcLengths&&this.cacheArcLengths.length===t+1&&!this.needsUpdate)return this.cacheArcLengths;this.needsUpdate=!1;let e=[],i,s=this.getPoint(0),r=0;e.push(0);for(let a=1;a<=t;a++)i=this.getPoint(a/t),r+=i.distanceTo(s),e.push(r),s=i;return this.cacheArcLengths=e,e}updateArcLengths(){this.needsUpdate=!0,this.getLengths()}getUtoTmapping(t,e=null){let i=this.getLengths(),s=0,r=i.length,a;e?a=e:a=t*i[r-1];let o=0,c=r-1,l;for(;o<=c;)if(s=Math.floor(o+(c-o)/2),l=i[s]-a,l<0)o=s+1;else if(l>0)c=s-1;else{c=s;break}if(s=c,i[s]===a)return s/(r-1);let h=i[s],d=i[s+1]-h,f=(a-h)/d;return(s+f)/(r-1)}getTangent(t,e){let s=t-1e-4,r=t+1e-4;s<0&&(s=0),r>1&&(r=1);let a=this.getPoint(s),o=this.getPoint(r),c=e||(a.isVector2?new ot:new D);return c.copy(o).sub(a).normalize(),c}getTangentAt(t,e){let i=this.getUtoTmapping(t);return this.getTangent(i,e)}computeFrenetFrames(t,e=!1){let i=new D,s=[],r=[],a=[],o=new D,c=new me;for(let f=0;f<=t;f++){let p=f/t;s[f]=this.getTangentAt(p,new D)}r[0]=new D,a[0]=new D;let l=Number.MAX_VALUE,h=Math.abs(s[0].x),u=Math.abs(s[0].y),d=Math.abs(s[0].z);h<=l&&(l=h,i.set(1,0,0)),u<=l&&(l=u,i.set(0,1,0)),d<=l&&i.set(0,0,1),o.crossVectors(s[0],i).normalize(),r[0].crossVectors(s[0],o),a[0].crossVectors(s[0],r[0]);for(let f=1;f<=t;f++){if(r[f]=r[f-1].clone(),a[f]=a[f-1].clone(),o.crossVectors(s[f-1],s[f]),o.length()>Number.EPSILON){o.normalize();let p=Math.acos(oe(s[f-1].dot(s[f]),-1,1));r[f].applyMatrix4(c.makeRotationAxis(o,p))}a[f].crossVectors(s[f],r[f])}if(e===!0){let f=Math.acos(oe(r[0].dot(r[t]),-1,1));f/=t,s[0].dot(o.crossVectors(r[0],r[t]))>0&&(f=-f);for(let p=1;p<=t;p++)r[p].applyMatrix4(c.makeRotationAxis(s[p],f*p)),a[p].crossVectors(s[p],r[p])}return{tangents:s,normals:r,binormals:a}}clone(){return new this.constructor().copy(this)}copy(t){return this.arcLengthDivisions=t.arcLengthDivisions,this}toJSON(){let t={metadata:{version:4.7,type:"Curve",generator:"Curve.toJSON"}};return t.arcLengthDivisions=this.arcLengthDivisions,t.type=this.type,t}fromJSON(t){return this.arcLengthDivisions=t.arcLengthDivisions,this}},br=class extends Ui{constructor(t=0,e=0,i=1,s=1,r=0,a=Math.PI*2,o=!1,c=0){super(),this.isEllipseCurve=!0,this.type="EllipseCurve",this.aX=t,this.aY=e,this.xRadius=i,this.yRadius=s,this.aStartAngle=r,this.aEndAngle=a,this.aClockwise=o,this.aRotation=c}getPoint(t,e=new ot){let i=e,s=Math.PI*2,r=this.aEndAngle-this.aStartAngle,a=Math.abs(r)<Number.EPSILON;for(;r<0;)r+=s;for(;r>s;)r-=s;r<Number.EPSILON&&(a?r=0:r=s),this.aClockwise===!0&&!a&&(r===s?r=-s:r=r-s);let o=this.aStartAngle+t*r,c=this.aX+this.xRadius*Math.cos(o),l=this.aY+this.yRadius*Math.sin(o);if(this.aRotation!==0){let h=Math.cos(this.aRotation),u=Math.sin(this.aRotation),d=c-this.aX,f=l-this.aY;c=d*h-f*u+this.aX,l=d*u+f*h+this.aY}return i.set(c,l)}copy(t){return super.copy(t),this.aX=t.aX,this.aY=t.aY,this.xRadius=t.xRadius,this.yRadius=t.yRadius,this.aStartAngle=t.aStartAngle,this.aEndAngle=t.aEndAngle,this.aClockwise=t.aClockwise,this.aRotation=t.aRotation,this}toJSON(){let t=super.toJSON();return t.aX=this.aX,t.aY=this.aY,t.xRadius=this.xRadius,t.yRadius=this.yRadius,t.aStartAngle=this.aStartAngle,t.aEndAngle=this.aEndAngle,t.aClockwise=this.aClockwise,t.aRotation=this.aRotation,t}fromJSON(t){return super.fromJSON(t),this.aX=t.aX,this.aY=t.aY,this.xRadius=t.xRadius,this.yRadius=t.yRadius,this.aStartAngle=t.aStartAngle,this.aEndAngle=t.aEndAngle,this.aClockwise=t.aClockwise,this.aRotation=t.aRotation,this}},Ll=class extends br{constructor(t,e,i,s,r,a){super(t,e,i,i,s,r,a),this.isArcCurve=!0,this.type="ArcCurve"}};function $u(){let n=0,t=0,e=0,i=0;function s(r,a,o,c){n=r,t=o,e=-3*r+3*a-2*o-c,i=2*r-2*a+o+c}return{initCatmullRom:function(r,a,o,c,l){s(a,o,l*(o-r),l*(c-a))},initNonuniformCatmullRom:function(r,a,o,c,l,h,u){let d=(a-r)/l-(o-r)/(l+h)+(o-a)/h,f=(o-a)/h-(c-a)/(h+u)+(c-o)/u;d*=h,f*=h,s(a,o,d,f)},calc:function(r){let a=r*r,o=a*r;return n+t*r+e*a+i*o}}}var zf=new D,Of=new D,du=new $u,fu=new $u,pu=new $u,Mr=class extends Ui{constructor(t=[],e=!1,i="centripetal",s=.5){super(),this.isCatmullRomCurve3=!0,this.type="CatmullRomCurve3",this.points=t,this.closed=e,this.curveType=i,this.tension=s}getPoint(t,e=new D){let i=e,s=this.points,r=s.length,a=(r-(this.closed?0:1))*t,o=Math.floor(a),c=a-o;this.closed?o+=o>0?0:(Math.floor(Math.abs(o)/r)+1)*r:c===0&&o===r-1&&(o=r-2,c=1);let l,h;this.closed||o>0?l=s[(o-1)%r]:(Of.subVectors(s[0],s[1]).add(s[0]),l=Of);let u=s[o%r],d=s[(o+1)%r];if(this.closed||o+2<r?h=s[(o+2)%r]:(zf.subVectors(s[r-1],s[r-2]).add(s[r-1]),h=zf),this.curveType==="centripetal"||this.curveType==="chordal"){let f=this.curveType==="chordal"?.5:.25,p=Math.pow(l.distanceToSquared(u),f),x=Math.pow(u.distanceToSquared(d),f),m=Math.pow(d.distanceToSquared(h),f);x<1e-4&&(x=1),p<1e-4&&(p=x),m<1e-4&&(m=x),du.initNonuniformCatmullRom(l.x,u.x,d.x,h.x,p,x,m),fu.initNonuniformCatmullRom(l.y,u.y,d.y,h.y,p,x,m),pu.initNonuniformCatmullRom(l.z,u.z,d.z,h.z,p,x,m)}else this.curveType==="catmullrom"&&(du.initCatmullRom(l.x,u.x,d.x,h.x,this.tension),fu.initCatmullRom(l.y,u.y,d.y,h.y,this.tension),pu.initCatmullRom(l.z,u.z,d.z,h.z,this.tension));return i.set(du.calc(c),fu.calc(c),pu.calc(c)),i}copy(t){super.copy(t),this.points=[];for(let e=0,i=t.points.length;e<i;e++){let s=t.points[e];this.points.push(s.clone())}return this.closed=t.closed,this.curveType=t.curveType,this.tension=t.tension,this}toJSON(){let t=super.toJSON();t.points=[];for(let e=0,i=this.points.length;e<i;e++){let s=this.points[e];t.points.push(s.toArray())}return t.closed=this.closed,t.curveType=this.curveType,t.tension=this.tension,t}fromJSON(t){super.fromJSON(t),this.points=[];for(let e=0,i=t.points.length;e<i;e++){let s=t.points[e];this.points.push(new D().fromArray(s))}return this.closed=t.closed,this.curveType=t.curveType,this.tension=t.tension,this}};function kf(n,t,e,i,s){let r=(i-t)*.5,a=(s-e)*.5,o=n*n,c=n*o;return(2*e-2*i+r+a)*c+(-3*e+3*i-2*r-a)*o+r*n+e}function eg(n,t){let e=1-n;return e*e*t}function ig(n,t){return 2*(1-n)*n*t}function ng(n,t){return n*n*t}function ga(n,t,e,i){return eg(n,t)+ig(n,e)+ng(n,i)}function sg(n,t){let e=1-n;return e*e*e*t}function rg(n,t){let e=1-n;return 3*e*e*n*t}function ag(n,t){return 3*(1-n)*n*n*t}function og(n,t){return n*n*n*t}function xa(n,t,e,i,s){return sg(n,t)+rg(n,e)+ag(n,i)+og(n,s)}var Fa=class extends Ui{constructor(t=new ot,e=new ot,i=new ot,s=new ot){super(),this.isCubicBezierCurve=!0,this.type="CubicBezierCurve",this.v0=t,this.v1=e,this.v2=i,this.v3=s}getPoint(t,e=new ot){let i=e,s=this.v0,r=this.v1,a=this.v2,o=this.v3;return i.set(xa(t,s.x,r.x,a.x,o.x),xa(t,s.y,r.y,a.y,o.y)),i}copy(t){return super.copy(t),this.v0.copy(t.v0),this.v1.copy(t.v1),this.v2.copy(t.v2),this.v3.copy(t.v3),this}toJSON(){let t=super.toJSON();return t.v0=this.v0.toArray(),t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t.v3=this.v3.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v0.fromArray(t.v0),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this.v3.fromArray(t.v3),this}},Dl=class extends Ui{constructor(t=new D,e=new D,i=new D,s=new D){super(),this.isCubicBezierCurve3=!0,this.type="CubicBezierCurve3",this.v0=t,this.v1=e,this.v2=i,this.v3=s}getPoint(t,e=new D){let i=e,s=this.v0,r=this.v1,a=this.v2,o=this.v3;return i.set(xa(t,s.x,r.x,a.x,o.x),xa(t,s.y,r.y,a.y,o.y),xa(t,s.z,r.z,a.z,o.z)),i}copy(t){return super.copy(t),this.v0.copy(t.v0),this.v1.copy(t.v1),this.v2.copy(t.v2),this.v3.copy(t.v3),this}toJSON(){let t=super.toJSON();return t.v0=this.v0.toArray(),t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t.v3=this.v3.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v0.fromArray(t.v0),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this.v3.fromArray(t.v3),this}},za=class extends Ui{constructor(t=new ot,e=new ot){super(),this.isLineCurve=!0,this.type="LineCurve",this.v1=t,this.v2=e}getPoint(t,e=new ot){let i=e;return t===1?i.copy(this.v2):(i.copy(this.v2).sub(this.v1),i.multiplyScalar(t).add(this.v1)),i}getPointAt(t,e){return this.getPoint(t,e)}getTangent(t,e=new ot){return e.subVectors(this.v2,this.v1).normalize()}getTangentAt(t,e){return this.getTangent(t,e)}copy(t){return super.copy(t),this.v1.copy(t.v1),this.v2.copy(t.v2),this}toJSON(){let t=super.toJSON();return t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this}},Nl=class extends Ui{constructor(t=new D,e=new D){super(),this.isLineCurve3=!0,this.type="LineCurve3",this.v1=t,this.v2=e}getPoint(t,e=new D){let i=e;return t===1?i.copy(this.v2):(i.copy(this.v2).sub(this.v1),i.multiplyScalar(t).add(this.v1)),i}getPointAt(t,e){return this.getPoint(t,e)}getTangent(t,e=new D){return e.subVectors(this.v2,this.v1).normalize()}getTangentAt(t,e){return this.getTangent(t,e)}copy(t){return super.copy(t),this.v1.copy(t.v1),this.v2.copy(t.v2),this}toJSON(){let t=super.toJSON();return t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this}},Oa=class extends Ui{constructor(t=new ot,e=new ot,i=new ot){super(),this.isQuadraticBezierCurve=!0,this.type="QuadraticBezierCurve",this.v0=t,this.v1=e,this.v2=i}getPoint(t,e=new ot){let i=e,s=this.v0,r=this.v1,a=this.v2;return i.set(ga(t,s.x,r.x,a.x),ga(t,s.y,r.y,a.y)),i}copy(t){return super.copy(t),this.v0.copy(t.v0),this.v1.copy(t.v1),this.v2.copy(t.v2),this}toJSON(){let t=super.toJSON();return t.v0=this.v0.toArray(),t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v0.fromArray(t.v0),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this}},Ul=class extends Ui{constructor(t=new D,e=new D,i=new D){super(),this.isQuadraticBezierCurve3=!0,this.type="QuadraticBezierCurve3",this.v0=t,this.v1=e,this.v2=i}getPoint(t,e=new D){let i=e,s=this.v0,r=this.v1,a=this.v2;return i.set(ga(t,s.x,r.x,a.x),ga(t,s.y,r.y,a.y),ga(t,s.z,r.z,a.z)),i}copy(t){return super.copy(t),this.v0.copy(t.v0),this.v1.copy(t.v1),this.v2.copy(t.v2),this}toJSON(){let t=super.toJSON();return t.v0=this.v0.toArray(),t.v1=this.v1.toArray(),t.v2=this.v2.toArray(),t}fromJSON(t){return super.fromJSON(t),this.v0.fromArray(t.v0),this.v1.fromArray(t.v1),this.v2.fromArray(t.v2),this}},ka=class extends Ui{constructor(t=[]){super(),this.isSplineCurve=!0,this.type="SplineCurve",this.points=t}getPoint(t,e=new ot){let i=e,s=this.points,r=(s.length-1)*t,a=Math.floor(r),o=r-a,c=s[a===0?a:a-1],l=s[a],h=s[a>s.length-2?s.length-1:a+1],u=s[a>s.length-3?s.length-1:a+2];return i.set(kf(o,c.x,l.x,h.x,u.x),kf(o,c.y,l.y,h.y,u.y)),i}copy(t){super.copy(t),this.points=[];for(let e=0,i=t.points.length;e<i;e++){let s=t.points[e];this.points.push(s.clone())}return this}toJSON(){let t=super.toJSON();t.points=[];for(let e=0,i=this.points.length;e<i;e++){let s=this.points[e];t.points.push(s.toArray())}return t}fromJSON(t){super.fromJSON(t),this.points=[];for(let e=0,i=t.points.length;e<i;e++){let s=t.points[e];this.points.push(new ot().fromArray(s))}return this}},Mu=Object.freeze({__proto__:null,ArcCurve:Ll,CatmullRomCurve3:Mr,CubicBezierCurve:Fa,CubicBezierCurve3:Dl,EllipseCurve:br,LineCurve:za,LineCurve3:Nl,QuadraticBezierCurve:Oa,QuadraticBezierCurve3:Ul,SplineCurve:ka}),Fl=class extends Ui{constructor(){super(),this.type="CurvePath",this.curves=[],this.autoClose=!1}add(t){this.curves.push(t)}closePath(){let t=this.curves[0].getPoint(0),e=this.curves[this.curves.length-1].getPoint(1);if(!t.equals(e)){let i=t.isVector2===!0?"LineCurve":"LineCurve3";this.curves.push(new Mu[i](e,t))}return this}getPoint(t,e){let i=t*this.getLength(),s=this.getCurveLengths(),r=0;for(;r<s.length;){if(s[r]>=i){let a=s[r]-i,o=this.curves[r],c=o.getLength(),l=c===0?0:1-a/c;return o.getPointAt(l,e)}r++}return null}getLength(){let t=this.getCurveLengths();return t[t.length-1]}updateArcLengths(){this.needsUpdate=!0,this.cacheLengths=null,this.getCurveLengths()}getCurveLengths(){if(this.cacheLengths&&this.cacheLengths.length===this.curves.length)return this.cacheLengths;let t=[],e=0;for(let i=0,s=this.curves.length;i<s;i++)e+=this.curves[i].getLength(),t.push(e);return this.cacheLengths=t,t}getSpacedPoints(t=40){let e=[];for(let i=0;i<=t;i++)e.push(this.getPoint(i/t));return this.autoClose&&e.push(e[0]),e}getPoints(t=12){let e=[],i;for(let s=0,r=this.curves;s<r.length;s++){let a=r[s],o=a.isEllipseCurve?t*2:a.isLineCurve||a.isLineCurve3?1:a.isSplineCurve?t*a.points.length:t,c=a.getPoints(o);for(let l=0;l<c.length;l++){let h=c[l];i&&i.equals(h)||(e.push(h),i=h)}}return this.autoClose&&e.length>1&&!e[e.length-1].equals(e[0])&&e.push(e[0]),e}copy(t){super.copy(t),this.curves=[];for(let e=0,i=t.curves.length;e<i;e++){let s=t.curves[e];this.curves.push(s.clone())}return this.autoClose=t.autoClose,this}toJSON(){let t=super.toJSON();t.autoClose=this.autoClose,t.curves=[];for(let e=0,i=this.curves.length;e<i;e++){let s=this.curves[e];t.curves.push(s.toJSON())}return t}fromJSON(t){super.fromJSON(t),this.autoClose=t.autoClose,this.curves=[];for(let e=0,i=t.curves.length;e<i;e++){let s=t.curves[e];this.curves.push(new Mu[s.type]().fromJSON(s))}return this}},Ba=class extends Fl{constructor(t){super(),this.type="Path",this.currentPoint=new ot,t&&this.setFromPoints(t)}setFromPoints(t){this.moveTo(t[0].x,t[0].y);for(let e=1,i=t.length;e<i;e++)this.lineTo(t[e].x,t[e].y);return this}moveTo(t,e){return this.currentPoint.set(t,e),this}lineTo(t,e){let i=new za(this.currentPoint.clone(),new ot(t,e));return this.curves.push(i),this.currentPoint.set(t,e),this}quadraticCurveTo(t,e,i,s){let r=new Oa(this.currentPoint.clone(),new ot(t,e),new ot(i,s));return this.curves.push(r),this.currentPoint.set(i,s),this}bezierCurveTo(t,e,i,s,r,a){let o=new Fa(this.currentPoint.clone(),new ot(t,e),new ot(i,s),new ot(r,a));return this.curves.push(o),this.currentPoint.set(r,a),this}splineThru(t){let e=[this.currentPoint.clone()].concat(t),i=new ka(e);return this.curves.push(i),this.currentPoint.copy(t[t.length-1]),this}arc(t,e,i,s,r,a){let o=this.currentPoint.x,c=this.currentPoint.y;return this.absarc(t+o,e+c,i,s,r,a),this}absarc(t,e,i,s,r,a){return this.absellipse(t,e,i,i,s,r,a),this}ellipse(t,e,i,s,r,a,o,c){let l=this.currentPoint.x,h=this.currentPoint.y;return this.absellipse(t+l,e+h,i,s,r,a,o,c),this}absellipse(t,e,i,s,r,a,o,c){let l=new br(t,e,i,s,r,a,o,c);if(this.curves.length>0){let u=l.getPoint(0);u.equals(this.currentPoint)||this.lineTo(u.x,u.y)}this.curves.push(l);let h=l.getPoint(1);return this.currentPoint.copy(h),this}copy(t){return super.copy(t),this.currentPoint.copy(t.currentPoint),this}toJSON(){let t=super.toJSON();return t.currentPoint=this.currentPoint.toArray(),t}fromJSON(t){return super.fromJSON(t),this.currentPoint.fromArray(t.currentPoint),this}},As=class extends Ba{constructor(t){super(t),this.uuid=xn(),this.type="Shape",this.holes=[]}getPointsHoles(t){let e=[];for(let i=0,s=this.holes.length;i<s;i++)e[i]=this.holes[i].getPoints(t);return e}extractPoints(t){return{shape:this.getPoints(t),holes:this.getPointsHoles(t)}}copy(t){super.copy(t),this.holes=[];for(let e=0,i=t.holes.length;e<i;e++){let s=t.holes[e];this.holes.push(s.clone())}return this}toJSON(){let t=super.toJSON();t.uuid=this.uuid,t.holes=[];for(let e=0,i=this.holes.length;e<i;e++){let s=this.holes[e];t.holes.push(s.toJSON())}return t}fromJSON(t){super.fromJSON(t),this.uuid=t.uuid,this.holes=[];for(let e=0,i=t.holes.length;e<i;e++){let s=t.holes[e];this.holes.push(new Ba().fromJSON(s))}return this}};function lg(n,t,e=2){let i=t&&t.length,s=i?t[0]*e:n.length,r=F0(n,0,s,e,!0),a=[];if(!r||r.next===r.prev)return a;let o,c,l;if(i&&(r=fg(n,t,r,e)),n.length>80*e){o=n[0],c=n[1];let h=o,u=c;for(let d=e;d<s;d+=e){let f=n[d],p=n[d+1];f<o&&(o=f),p<c&&(c=p),f>h&&(h=f),p>u&&(u=p)}l=Math.max(h-o,u-c),l=l!==0?32767/l:0}return Ha(r,a,e,o,c,l,0),a}function F0(n,t,e,i,s){let r;if(s===wg(n,t,e,i)>0)for(let a=t;a<e;a+=i)r=Bf(a/i|0,n[a],n[a+1],r);else for(let a=e-i;a>=t;a-=i)r=Bf(a/i|0,n[a],n[a+1],r);return r&&Sr(r,r.next)&&(Va(r),r=r.next),r}function Rs(n,t){if(!n)return n;t||(t=n);let e=n,i;do if(i=!1,!e.steiner&&(Sr(e,e.next)||Be(e.prev,e,e.next)===0)){if(Va(e),e=t=e.prev,e===e.next)break;i=!0}else e=e.next;while(i||e!==t);return t}function Ha(n,t,e,i,s,r,a){if(!n)return;!a&&r&&vg(n,i,s,r);let o=n;for(;n.prev!==n.next;){let c=n.prev,l=n.next;if(r?hg(n,i,s,r):cg(n)){t.push(c.i,n.i,l.i),Va(n),n=l.next,o=l.next;continue}if(n=l,n===o){a?a===1?(n=ug(Rs(n),t),Ha(n,t,e,i,s,r,2)):a===2&&dg(n,t,e,i,s,r):Ha(Rs(n),t,e,i,s,r,1);break}}}function cg(n){let t=n.prev,e=n,i=n.next;if(Be(t,e,i)>=0)return!1;let s=t.x,r=e.x,a=i.x,o=t.y,c=e.y,l=i.y,h=Math.min(s,r,a),u=Math.min(o,c,l),d=Math.max(s,r,a),f=Math.max(o,c,l),p=i.next;for(;p!==t;){if(p.x>=h&&p.x<=d&&p.y>=u&&p.y<=f&&fa(s,o,r,c,a,l,p.x,p.y)&&Be(p.prev,p,p.next)>=0)return!1;p=p.next}return!0}function hg(n,t,e,i){let s=n.prev,r=n,a=n.next;if(Be(s,r,a)>=0)return!1;let o=s.x,c=r.x,l=a.x,h=s.y,u=r.y,d=a.y,f=Math.min(o,c,l),p=Math.min(h,u,d),x=Math.max(o,c,l),m=Math.max(h,u,d),g=Su(f,p,t,e,i),_=Su(x,m,t,e,i),T=n.prevZ,v=n.nextZ;for(;T&&T.z>=g&&v&&v.z<=_;){if(T.x>=f&&T.x<=x&&T.y>=p&&T.y<=m&&T!==s&&T!==a&&fa(o,h,c,u,l,d,T.x,T.y)&&Be(T.prev,T,T.next)>=0||(T=T.prevZ,v.x>=f&&v.x<=x&&v.y>=p&&v.y<=m&&v!==s&&v!==a&&fa(o,h,c,u,l,d,v.x,v.y)&&Be(v.prev,v,v.next)>=0))return!1;v=v.nextZ}for(;T&&T.z>=g;){if(T.x>=f&&T.x<=x&&T.y>=p&&T.y<=m&&T!==s&&T!==a&&fa(o,h,c,u,l,d,T.x,T.y)&&Be(T.prev,T,T.next)>=0)return!1;T=T.prevZ}for(;v&&v.z<=_;){if(v.x>=f&&v.x<=x&&v.y>=p&&v.y<=m&&v!==s&&v!==a&&fa(o,h,c,u,l,d,v.x,v.y)&&Be(v.prev,v,v.next)>=0)return!1;v=v.nextZ}return!0}function ug(n,t){let e=n;do{let i=e.prev,s=e.next.next;!Sr(i,s)&&O0(i,e,e.next,s)&&Ga(i,s)&&Ga(s,i)&&(t.push(i.i,e.i,s.i),Va(e),Va(e.next),e=n=s),e=e.next}while(e!==n);return Rs(e)}function dg(n,t,e,i,s,r){let a=n;do{let o=a.next.next;for(;o!==a.prev;){if(a.i!==o.i&&bg(a,o)){let c=k0(a,o);a=Rs(a,a.next),c=Rs(c,c.next),Ha(a,t,e,i,s,r,0),Ha(c,t,e,i,s,r,0);return}o=o.next}a=a.next}while(a!==n)}function fg(n,t,e,i){let s=[];for(let r=0,a=t.length;r<a;r++){let o=t[r]*i,c=r<a-1?t[r+1]*i:n.length,l=F0(n,o,c,i,!1);l===l.next&&(l.steiner=!0),s.push(_g(l))}s.sort(pg);for(let r=0;r<s.length;r++)e=mg(s[r],e);return e}function pg(n,t){let e=n.x-t.x;if(e===0&&(e=n.y-t.y,e===0)){let i=(n.next.y-n.y)/(n.next.x-n.x),s=(t.next.y-t.y)/(t.next.x-t.x);e=i-s}return e}function mg(n,t){let e=gg(n,t);if(!e)return t;let i=k0(e,n);return Rs(i,i.next),Rs(e,e.next)}function gg(n,t){let e=t,i=n.x,s=n.y,r=-1/0,a;if(Sr(n,e))return e;do{if(Sr(n,e.next))return e.next;if(s<=e.y&&s>=e.next.y&&e.next.y!==e.y){let u=e.x+(s-e.y)*(e.next.x-e.x)/(e.next.y-e.y);if(u<=i&&u>r&&(r=u,a=e.x<e.next.x?e:e.next,u===i))return a}e=e.next}while(e!==t);if(!a)return null;let o=a,c=a.x,l=a.y,h=1/0;e=a;do{if(i>=e.x&&e.x>=c&&i!==e.x&&z0(s<l?i:r,s,c,l,s<l?r:i,s,e.x,e.y)){let u=Math.abs(s-e.y)/(i-e.x);Ga(e,n)&&(u<h||u===h&&(e.x>a.x||e.x===a.x&&xg(a,e)))&&(a=e,h=u)}e=e.next}while(e!==o);return a}function xg(n,t){return Be(n.prev,n,t.prev)<0&&Be(t.next,n,n.next)<0}function vg(n,t,e,i){let s=n;do s.z===0&&(s.z=Su(s.x,s.y,t,e,i)),s.prevZ=s.prev,s.nextZ=s.next,s=s.next;while(s!==n);s.prevZ.nextZ=null,s.prevZ=null,yg(s)}function yg(n){let t,e=1;do{let i=n,s;n=null;let r=null;for(t=0;i;){t++;let a=i,o=0;for(let l=0;l<e&&(o++,a=a.nextZ,!!a);l++);let c=e;for(;o>0||c>0&&a;)o!==0&&(c===0||!a||i.z<=a.z)?(s=i,i=i.nextZ,o--):(s=a,a=a.nextZ,c--),r?r.nextZ=s:n=s,s.prevZ=r,r=s;i=a}r.nextZ=null,e*=2}while(t>1);return n}function Su(n,t,e,i,s){return n=(n-e)*s|0,t=(t-i)*s|0,n=(n|n<<8)&16711935,n=(n|n<<4)&252645135,n=(n|n<<2)&858993459,n=(n|n<<1)&1431655765,t=(t|t<<8)&16711935,t=(t|t<<4)&252645135,t=(t|t<<2)&858993459,t=(t|t<<1)&1431655765,n|t<<1}function _g(n){let t=n,e=n;do(t.x<e.x||t.x===e.x&&t.y<e.y)&&(e=t),t=t.next;while(t!==n);return e}function z0(n,t,e,i,s,r,a,o){return(s-a)*(t-o)>=(n-a)*(r-o)&&(n-a)*(i-o)>=(e-a)*(t-o)&&(e-a)*(r-o)>=(s-a)*(i-o)}function fa(n,t,e,i,s,r,a,o){return!(n===a&&t===o)&&z0(n,t,e,i,s,r,a,o)}function bg(n,t){return n.next.i!==t.i&&n.prev.i!==t.i&&!Mg(n,t)&&(Ga(n,t)&&Ga(t,n)&&Sg(n,t)&&(Be(n.prev,n,t.prev)||Be(n,t.prev,t))||Sr(n,t)&&Be(n.prev,n,n.next)>0&&Be(t.prev,t,t.next)>0)}function Be(n,t,e){return(t.y-n.y)*(e.x-t.x)-(t.x-n.x)*(e.y-t.y)}function Sr(n,t){return n.x===t.x&&n.y===t.y}function O0(n,t,e,i){let s=ul(Be(n,t,e)),r=ul(Be(n,t,i)),a=ul(Be(e,i,n)),o=ul(Be(e,i,t));return!!(s!==r&&a!==o||s===0&&hl(n,e,t)||r===0&&hl(n,i,t)||a===0&&hl(e,n,i)||o===0&&hl(e,t,i))}function hl(n,t,e){return t.x<=Math.max(n.x,e.x)&&t.x>=Math.min(n.x,e.x)&&t.y<=Math.max(n.y,e.y)&&t.y>=Math.min(n.y,e.y)}function ul(n){return n>0?1:n<0?-1:0}function Mg(n,t){let e=n;do{if(e.i!==n.i&&e.next.i!==n.i&&e.i!==t.i&&e.next.i!==t.i&&O0(e,e.next,n,t))return!0;e=e.next}while(e!==n);return!1}function Ga(n,t){return Be(n.prev,n,n.next)<0?Be(n,t,n.next)>=0&&Be(n,n.prev,t)>=0:Be(n,t,n.prev)<0||Be(n,n.next,t)<0}function Sg(n,t){let e=n,i=!1,s=(n.x+t.x)/2,r=(n.y+t.y)/2;do e.y>r!=e.next.y>r&&e.next.y!==e.y&&s<(e.next.x-e.x)*(r-e.y)/(e.next.y-e.y)+e.x&&(i=!i),e=e.next;while(e!==n);return i}function k0(n,t){let e=wu(n.i,n.x,n.y),i=wu(t.i,t.x,t.y),s=n.next,r=t.prev;return n.next=t,t.prev=n,e.next=s,s.prev=e,i.next=e,e.prev=i,r.next=i,i.prev=r,i}function Bf(n,t,e,i){let s=wu(n,t,e);return i?(s.next=i.next,s.prev=i,i.next.prev=s,i.next=s):(s.prev=s,s.next=s),s}function Va(n){n.next.prev=n.prev,n.prev.next=n.next,n.prevZ&&(n.prevZ.nextZ=n.nextZ),n.nextZ&&(n.nextZ.prevZ=n.prevZ)}function wu(n,t,e){return{i:n,x:t,y:e,prev:null,next:null,z:0,prevZ:null,nextZ:null,steiner:!1}}function wg(n,t,e,i){let s=0;for(let r=t,a=e-i;r<e;r+=i)s+=(n[a]-n[r])*(n[r+1]+n[a+1]),a=r;return s}var Tu=class{static triangulate(t,e,i=2){return lg(t,e,i)}},Ss=class n{static area(t){let e=t.length,i=0;for(let s=e-1,r=0;r<e;s=r++)i+=t[s].x*t[r].y-t[r].x*t[s].y;return i*.5}static isClockWise(t){return n.area(t)<0}static triangulateShape(t,e){let i=[],s=[],r=[];Hf(t),Gf(i,t);let a=t.length;e.forEach(Hf);for(let c=0;c<e.length;c++)s.push(a),a+=e[c].length,Gf(i,e[c]);let o=Tu.triangulate(i,s);for(let c=0;c<o.length;c+=3)r.push(o.slice(c,c+3));return r}};function Hf(n){let t=n.length;t>2&&n[t-1].equals(n[0])&&n.pop()}function Gf(n,t){for(let e=0;e<t.length;e++)n.push(t[e].x),n.push(t[e].y)}var wr=class n extends ge{constructor(t=new As([new ot(.5,.5),new ot(-.5,.5),new ot(-.5,-.5),new ot(.5,-.5)]),e={}){super(),this.type="ExtrudeGeometry",this.parameters={shapes:t,options:e},t=Array.isArray(t)?t:[t];let i=this,s=[],r=[];for(let o=0,c=t.length;o<c;o++){let l=t[o];a(l)}this.setAttribute("position",new qt(s,3)),this.setAttribute("uv",new qt(r,2)),this.computeVertexNormals();function a(o){let c=[],l=e.curveSegments!==void 0?e.curveSegments:12,h=e.steps!==void 0?e.steps:1,u=e.depth!==void 0?e.depth:1,d=e.bevelEnabled!==void 0?e.bevelEnabled:!0,f=e.bevelThickness!==void 0?e.bevelThickness:.2,p=e.bevelSize!==void 0?e.bevelSize:f-.1,x=e.bevelOffset!==void 0?e.bevelOffset:0,m=e.bevelSegments!==void 0?e.bevelSegments:3,g=e.extrudePath,_=e.UVGenerator!==void 0?e.UVGenerator:Tg,T,v=!1,S,M,A,y;if(g){T=g.getSpacedPoints(h),v=!0,d=!1;let at=g.isCatmullRomCurve3?g.closed:!1;S=g.computeFrenetFrames(h,at),M=new D,A=new D,y=new D}d||(m=0,f=0,p=0,x=0);let E=o.extractPoints(l),P=E.shape,N=E.holes;if(!Ss.isClockWise(P)){P=P.reverse();for(let at=0,ut=N.length;at<ut;at++){let pt=N[at];Ss.isClockWise(pt)&&(N[at]=pt.reverse())}}function B(at){let pt=10000000000000001e-36,mt=at[0];for(let w=1;w<=at.length;w++){let J=w%at.length,Q=at[J],st=Q.x-mt.x,nt=Q.y-mt.y,L=st*st+nt*nt,yt=Math.max(Math.abs(Q.x),Math.abs(Q.y),Math.abs(mt.x),Math.abs(mt.y)),zt=pt*yt*yt;if(L<=zt){at.splice(J,1),w--;continue}mt=Q}}B(P),N.forEach(B);let I=N.length,H=P;for(let at=0;at<I;at++){let ut=N[at];P=P.concat(ut)}function W(at,ut,pt){return ut||ee("ExtrudeGeometry: vec does not exist"),at.clone().addScaledVector(ut,pt)}let U=P.length;function X(at,ut,pt){let mt,w,J,Q=at.x-ut.x,st=at.y-ut.y,nt=pt.x-at.x,L=pt.y-at.y,yt=Q*Q+st*st,zt=Q*L-st*nt;if(Math.abs(zt)>Number.EPSILON){let C=Math.sqrt(yt),b=Math.sqrt(nt*nt+L*L),O=ut.x-st/C,V=ut.y+Q/C,K=pt.x-L/b,gt=pt.y+nt/b,xt=((K-O)*L-(gt-V)*nt)/(Q*L-st*nt);mt=O+Q*xt-at.x,w=V+st*xt-at.y;let it=mt*mt+w*w;if(it<=2)return new ot(mt,w);J=Math.sqrt(it/2)}else{let C=!1;Q>Number.EPSILON?nt>Number.EPSILON&&(C=!0):Q<-Number.EPSILON?nt<-Number.EPSILON&&(C=!0):Math.sign(st)===Math.sign(L)&&(C=!0),C?(mt=-st,w=Q,J=Math.sqrt(yt)):(mt=Q,w=st,J=Math.sqrt(yt/2))}return new ot(mt/J,w/J)}let G=[];for(let at=0,ut=H.length,pt=ut-1,mt=at+1;at<ut;at++,pt++,mt++)pt===ut&&(pt=0),mt===ut&&(mt=0),G[at]=X(H[at],H[pt],H[mt]);let j=[],et,vt=G.concat();for(let at=0,ut=I;at<ut;at++){let pt=N[at];et=[];for(let mt=0,w=pt.length,J=w-1,Q=mt+1;mt<w;mt++,J++,Q++)J===w&&(J=0),Q===w&&(Q=0),et[mt]=X(pt[mt],pt[J],pt[Q]);j.push(et),vt=vt.concat(et)}let ht;if(m===0)ht=Ss.triangulateShape(H,N);else{let at=[],ut=[];for(let pt=0;pt<m;pt++){let mt=pt/m,w=f*Math.cos(mt*Math.PI/2),J=p*Math.sin(mt*Math.PI/2)+x;for(let Q=0,st=H.length;Q<st;Q++){let nt=W(H[Q],G[Q],J);_t(nt.x,nt.y,-w),mt===0&&at.push(nt)}for(let Q=0,st=I;Q<st;Q++){let nt=N[Q];et=j[Q];let L=[];for(let yt=0,zt=nt.length;yt<zt;yt++){let C=W(nt[yt],et[yt],J);_t(C.x,C.y,-w),mt===0&&L.push(C)}mt===0&&ut.push(L)}}ht=Ss.triangulateShape(at,ut)}let Ut=ht.length,$t=p+x;for(let at=0;at<U;at++){let ut=d?W(P[at],vt[at],$t):P[at];v?(A.copy(S.normals[0]).multiplyScalar(ut.x),M.copy(S.binormals[0]).multiplyScalar(ut.y),y.copy(T[0]).add(A).add(M),_t(y.x,y.y,y.z)):_t(ut.x,ut.y,0)}for(let at=1;at<=h;at++)for(let ut=0;ut<U;ut++){let pt=d?W(P[ut],vt[ut],$t):P[ut];v?(A.copy(S.normals[at]).multiplyScalar(pt.x),M.copy(S.binormals[at]).multiplyScalar(pt.y),y.copy(T[at]).add(A).add(M),_t(y.x,y.y,y.z)):_t(pt.x,pt.y,u/h*at)}for(let at=m-1;at>=0;at--){let ut=at/m,pt=f*Math.cos(ut*Math.PI/2),mt=p*Math.sin(ut*Math.PI/2)+x;for(let w=0,J=H.length;w<J;w++){let Q=W(H[w],G[w],mt);_t(Q.x,Q.y,u+pt)}for(let w=0,J=N.length;w<J;w++){let Q=N[w];et=j[w];for(let st=0,nt=Q.length;st<nt;st++){let L=W(Q[st],et[st],mt);v?_t(L.x,L.y+T[h-1].y,T[h-1].x+pt):_t(L.x,L.y,u+pt)}}}Kt(),$();function Kt(){let at=s.length/3;if(d){let ut=0,pt=U*ut;for(let mt=0;mt<Ut;mt++){let w=ht[mt];Jt(w[2]+pt,w[1]+pt,w[0]+pt)}ut=h+m*2,pt=U*ut;for(let mt=0;mt<Ut;mt++){let w=ht[mt];Jt(w[0]+pt,w[1]+pt,w[2]+pt)}}else{for(let ut=0;ut<Ut;ut++){let pt=ht[ut];Jt(pt[2],pt[1],pt[0])}for(let ut=0;ut<Ut;ut++){let pt=ht[ut];Jt(pt[0]+U*h,pt[1]+U*h,pt[2]+U*h)}}i.addGroup(at,s.length/3-at,0)}function $(){let at=s.length/3,ut=0;rt(H,ut),ut+=H.length;for(let pt=0,mt=N.length;pt<mt;pt++){let w=N[pt];rt(w,ut),ut+=w.length}i.addGroup(at,s.length/3-at,1)}function rt(at,ut){let pt=at.length;for(;--pt>=0;){let mt=pt,w=pt-1;w<0&&(w=at.length-1);for(let J=0,Q=h+m*2;J<Q;J++){let st=U*J,nt=U*(J+1),L=ut+mt+st,yt=ut+w+st,zt=ut+w+nt,C=ut+mt+nt;At(L,yt,zt,C)}}}function _t(at,ut,pt){c.push(at),c.push(ut),c.push(pt)}function Jt(at,ut,pt){Yt(at),Yt(ut),Yt(pt);let mt=s.length/3,w=_.generateTopUV(i,s,mt-3,mt-2,mt-1);fe(w[0]),fe(w[1]),fe(w[2])}function At(at,ut,pt,mt){Yt(at),Yt(ut),Yt(mt),Yt(ut),Yt(pt),Yt(mt);let w=s.length/3,J=_.generateSideWallUV(i,s,w-6,w-3,w-2,w-1);fe(J[0]),fe(J[1]),fe(J[3]),fe(J[1]),fe(J[2]),fe(J[3])}function Yt(at){s.push(c[at*3+0]),s.push(c[at*3+1]),s.push(c[at*3+2])}function fe(at){r.push(at.x),r.push(at.y)}}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}toJSON(){let t=super.toJSON(),e=this.parameters.shapes,i=this.parameters.options;return Eg(e,i,t)}static fromJSON(t,e){let i=[];for(let r=0,a=t.shapes.length;r<a;r++){let o=e[t.shapes[r]];i.push(o)}let s=t.options.extrudePath;return s!==void 0&&(t.options.extrudePath=new Mu[s.type]().fromJSON(s)),new n(i,t.options)}},Tg={generateTopUV:function(n,t,e,i,s){let r=t[e*3],a=t[e*3+1],o=t[i*3],c=t[i*3+1],l=t[s*3],h=t[s*3+1];return[new ot(r,a),new ot(o,c),new ot(l,h)]},generateSideWallUV:function(n,t,e,i,s,r){let a=t[e*3],o=t[e*3+1],c=t[e*3+2],l=t[i*3],h=t[i*3+1],u=t[i*3+2],d=t[s*3],f=t[s*3+1],p=t[s*3+2],x=t[r*3],m=t[r*3+1],g=t[r*3+2];return Math.abs(o-h)<Math.abs(a-l)?[new ot(a,1-c),new ot(l,1-u),new ot(d,1-p),new ot(x,1-g)]:[new ot(o,1-c),new ot(h,1-u),new ot(f,1-p),new ot(m,1-g)]}};function Eg(n,t,e){if(e.shapes=[],Array.isArray(n))for(let i=0,s=n.length;i<s;i++){let r=n[i];e.shapes.push(r.uuid)}else e.shapes.push(n.uuid);return e.options=Object.assign({},t),t.extrudePath!==void 0&&(e.options.extrudePath=t.extrudePath.toJSON()),e}var Tr=class n extends _r{constructor(t=1,e=0){let i=(1+Math.sqrt(5))/2,s=[-1,i,0,1,i,0,-1,-i,0,1,-i,0,0,-1,i,0,1,i,0,-1,-i,0,1,-i,i,0,-1,i,0,1,-i,0,-1,-i,0,1],r=[0,11,5,0,5,1,0,1,7,0,7,10,0,10,11,1,5,9,5,11,4,11,10,2,10,7,6,7,1,8,3,9,4,3,4,2,3,2,6,3,6,8,3,8,9,4,9,5,2,4,11,6,2,10,8,6,7,9,8,1];super(s,r,t,e),this.type="IcosahedronGeometry",this.parameters={radius:t,detail:e}}static fromJSON(t){return new n(t.radius,t.detail)}},Qn=class n extends ge{constructor(t=[new ot(0,-.5),new ot(.5,0),new ot(0,.5)],e=12,i=0,s=Math.PI*2){super(),this.type="LatheGeometry",this.parameters={points:t,segments:e,phiStart:i,phiLength:s},e=Math.floor(e),s=oe(s,0,Math.PI*2);let r=[],a=[],o=[],c=[],l=[],h=1/e,u=new D,d=new ot,f=new D,p=new D,x=new D,m=0,g=0;for(let _=0;_<=t.length-1;_++)switch(_){case 0:m=t[_+1].x-t[_].x,g=t[_+1].y-t[_].y,f.x=g*1,f.y=-m,f.z=g*0,x.copy(f),f.normalize(),c.push(f.x,f.y,f.z);break;case t.length-1:c.push(x.x,x.y,x.z);break;default:m=t[_+1].x-t[_].x,g=t[_+1].y-t[_].y,f.x=g*1,f.y=-m,f.z=g*0,p.copy(f),f.x+=x.x,f.y+=x.y,f.z+=x.z,f.normalize(),c.push(f.x,f.y,f.z),x.copy(p)}for(let _=0;_<=e;_++){let T=i+_*h*s,v=Math.sin(T),S=Math.cos(T);for(let M=0;M<=t.length-1;M++){u.x=t[M].x*v,u.y=t[M].y,u.z=t[M].x*S,a.push(u.x,u.y,u.z),d.x=_/e,d.y=M/(t.length-1),o.push(d.x,d.y);let A=c[3*M+0]*v,y=c[3*M+1],E=c[3*M+0]*S;l.push(A,y,E)}}for(let _=0;_<e;_++)for(let T=0;T<t.length-1;T++){let v=T+_*t.length,S=v,M=v+t.length,A=v+t.length+1,y=v+1;r.push(S,M,y),r.push(A,y,M)}this.setIndex(r),this.setAttribute("position",new qt(a,3)),this.setAttribute("uv",new qt(o,2)),this.setAttribute("normal",new qt(l,3))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.points,t.segments,t.phiStart,t.phiLength)}},vi=class n extends _r{constructor(t=1,e=0){let i=[1,0,0,-1,0,0,0,1,0,0,-1,0,0,0,1,0,0,-1],s=[0,2,4,0,4,3,0,3,5,0,5,2,1,2,5,1,5,3,1,3,4,1,4,2];super(i,s,t,e),this.type="OctahedronGeometry",this.parameters={radius:t,detail:e}}static fromJSON(t){return new n(t.radius,t.detail)}},Ti=class n extends ge{constructor(t=1,e=1,i=1,s=1){super(),this.type="PlaneGeometry",this.parameters={width:t,height:e,widthSegments:i,heightSegments:s};let r=t/2,a=e/2,o=Math.floor(i),c=Math.floor(s),l=o+1,h=c+1,u=t/o,d=e/c,f=[],p=[],x=[],m=[];for(let g=0;g<h;g++){let _=g*d-a;for(let T=0;T<l;T++){let v=T*u-r;p.push(v,-_,0),x.push(0,0,1),m.push(T/o),m.push(1-g/c)}}for(let g=0;g<c;g++)for(let _=0;_<o;_++){let T=_+l*g,v=_+l*(g+1),S=_+1+l*(g+1),M=_+1+l*g;f.push(T,v,M),f.push(v,S,M)}this.setIndex(f),this.setAttribute("position",new qt(p,3)),this.setAttribute("normal",new qt(x,3)),this.setAttribute("uv",new qt(m,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.width,t.height,t.widthSegments,t.heightSegments)}},bn=class n extends ge{constructor(t=.5,e=1,i=32,s=1,r=0,a=Math.PI*2){super(),this.type="RingGeometry",this.parameters={innerRadius:t,outerRadius:e,thetaSegments:i,phiSegments:s,thetaStart:r,thetaLength:a},i=Math.max(3,i),s=Math.max(1,s);let o=[],c=[],l=[],h=[],u=t,d=(e-t)/s,f=new D,p=new ot;for(let x=0;x<=s;x++){for(let m=0;m<=i;m++){let g=r+m/i*a;f.x=u*Math.cos(g),f.y=u*Math.sin(g),c.push(f.x,f.y,f.z),l.push(0,0,1),p.x=(f.x/e+1)/2,p.y=(f.y/e+1)/2,h.push(p.x,p.y)}u+=d}for(let x=0;x<s;x++){let m=x*(i+1);for(let g=0;g<i;g++){let _=g+m,T=_,v=_+i+1,S=_+i+2,M=_+1;o.push(T,v,M),o.push(v,S,M)}}this.setIndex(o),this.setAttribute("position",new qt(c,3)),this.setAttribute("normal",new qt(l,3)),this.setAttribute("uv",new qt(h,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.innerRadius,t.outerRadius,t.thetaSegments,t.phiSegments,t.thetaStart,t.thetaLength)}};var li=class n extends ge{constructor(t=1,e=32,i=16,s=0,r=Math.PI*2,a=0,o=Math.PI){super(),this.type="SphereGeometry",this.parameters={radius:t,widthSegments:e,heightSegments:i,phiStart:s,phiLength:r,thetaStart:a,thetaLength:o},e=Math.max(3,Math.floor(e)),i=Math.max(2,Math.floor(i));let c=Math.min(a+o,Math.PI),l=0,h=[],u=new D,d=new D,f=[],p=[],x=[],m=[];for(let g=0;g<=i;g++){let _=[],T=g/i,v=a+T*o,S=t*Math.cos(v),M=Math.sqrt(t*t-S*S),A=0;g===0&&a===0?A=.5/e:g===i&&c===Math.PI&&(A=-.5/e);for(let y=0;y<=e;y++){let E=y/e,P=s+E*r;u.x=-M*Math.cos(P),u.y=S,u.z=M*Math.sin(P),p.push(u.x,u.y,u.z),d.copy(u).normalize(),x.push(d.x,d.y,d.z),m.push(E+A,1-T),_.push(l++)}h.push(_)}for(let g=0;g<i;g++)for(let _=0;_<e;_++){let T=h[g][_+1],v=h[g][_],S=h[g+1][_],M=h[g+1][_+1];(g!==0||a>0)&&f.push(T,v,M),(g!==i-1||c<Math.PI)&&f.push(v,S,M)}this.setIndex(f),this.setAttribute("position",new qt(p,3)),this.setAttribute("normal",new qt(x,3)),this.setAttribute("uv",new qt(m,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.widthSegments,t.heightSegments,t.phiStart,t.phiLength,t.thetaStart,t.thetaLength)}};var Fi=class n extends ge{constructor(t=1,e=.4,i=12,s=48,r=Math.PI*2,a=0,o=Math.PI*2){super(),this.type="TorusGeometry",this.parameters={radius:t,tube:e,radialSegments:i,tubularSegments:s,arc:r,thetaStart:a,thetaLength:o},i=Math.floor(i),s=Math.floor(s);let c=[],l=[],h=[],u=[],d=new D,f=new D,p=new D;for(let x=0;x<=i;x++){let m=a+x/i*o;for(let g=0;g<=s;g++){let _=g/s*r;f.x=(t+e*Math.cos(m))*Math.cos(_),f.y=(t+e*Math.cos(m))*Math.sin(_),f.z=e*Math.sin(m),l.push(f.x,f.y,f.z),d.x=t*Math.cos(_),d.y=t*Math.sin(_),p.subVectors(f,d).normalize(),h.push(p.x,p.y,p.z),u.push(g/s),u.push(x/i)}}for(let x=1;x<=i;x++)for(let m=1;m<=s;m++){let g=(s+1)*x+m-1,_=(s+1)*(x-1)+m-1,T=(s+1)*(x-1)+m,v=(s+1)*x+m;c.push(g,_,v),c.push(_,T,v)}this.setIndex(c),this.setAttribute("position",new qt(l,3)),this.setAttribute("normal",new qt(h,3)),this.setAttribute("uv",new qt(u,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.tube,t.radialSegments,t.tubularSegments,t.arc,t.thetaStart,t.thetaLength)}};function Ds(n){let t={};for(let e in n){t[e]={};for(let i in n[e]){let s=n[e][i];if(Vf(s))s.isRenderTargetTexture?(te("UniformsUtils: Textures of render targets cannot be cloned via cloneUniforms() or mergeUniforms()."),t[e][i]=null):t[e][i]=s.clone();else if(Array.isArray(s))if(Vf(s[0])){let r=[];for(let a=0,o=s.length;a<o;a++)r[a]=s[a].clone();t[e][i]=r}else t[e][i]=s.slice();else t[e][i]=s}}return t}function yi(n){let t={};for(let e=0;e<n.length;e++){let i=Ds(n[e]);for(let s in i)t[s]=i[s]}return t}function Vf(n){return n&&(n.isColor||n.isMatrix3||n.isMatrix4||n.isVector2||n.isVector3||n.isVector4||n.isTexture||n.isQuaternion)}function Ag(n){let t=[];for(let e=0;e<n.length;e++)t.push(n[e].clone());return t}function Yu(n){let t=n.getRenderTarget();return t===null?n.outputColorSpace:t.isXRRenderTarget===!0?t.texture.colorSpace:he.workingColorSpace}var Un={clone:Ds,merge:yi},Rg=`void main() {
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}`,Cg=`void main() {
	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}`,ze=class extends qi{constructor(t){super(),this.isShaderMaterial=!0,this.type="ShaderMaterial",this.defines={},this.uniforms={},this.uniformsGroups=[],this.vertexShader=Rg,this.fragmentShader=Cg,this.linewidth=1,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.clipping=!1,this.forceSinglePass=!0,this.extensions={clipCullDistance:!1,multiDraw:!1},this.defaultAttributeValues={color:[1,1,1],uv:[0,0],uv1:[0,0]},this.index0AttributeName=void 0,this.uniformsNeedUpdate=!1,this.glslVersion=null,t!==void 0&&this.setValues(t)}copy(t){return super.copy(t),this.fragmentShader=t.fragmentShader,this.vertexShader=t.vertexShader,this.uniforms=Ds(t.uniforms),this.uniformsGroups=Ag(t.uniformsGroups),this.defines=Object.assign({},t.defines),this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.fog=t.fog,this.lights=t.lights,this.clipping=t.clipping,this.extensions=Object.assign({},t.extensions),this.glslVersion=t.glslVersion,this.defaultAttributeValues=Object.assign({},t.defaultAttributeValues),this.index0AttributeName=t.index0AttributeName,this.uniformsNeedUpdate=t.uniformsNeedUpdate,this}toJSON(t){let e=super.toJSON(t);e.glslVersion=this.glslVersion,e.uniforms={};for(let s in this.uniforms){let a=this.uniforms[s].value;a&&a.isTexture?e.uniforms[s]={type:"t",value:a.toJSON(t).uuid}:a&&a.isColor?e.uniforms[s]={type:"c",value:a.getHex()}:a&&a.isVector2?e.uniforms[s]={type:"v2",value:a.toArray()}:a&&a.isVector3?e.uniforms[s]={type:"v3",value:a.toArray()}:a&&a.isVector4?e.uniforms[s]={type:"v4",value:a.toArray()}:a&&a.isMatrix3?e.uniforms[s]={type:"m3",value:a.toArray()}:a&&a.isMatrix4?e.uniforms[s]={type:"m4",value:a.toArray()}:e.uniforms[s]={value:a}}Object.keys(this.defines).length>0&&(e.defines=this.defines),e.vertexShader=this.vertexShader,e.fragmentShader=this.fragmentShader,e.lights=this.lights,e.clipping=this.clipping;let i={};for(let s in this.extensions)this.extensions[s]===!0&&(i[s]=!0);return Object.keys(i).length>0&&(e.extensions=i),e}fromJSON(t,e){if(super.fromJSON(t,e),t.uniforms!==void 0)for(let i in t.uniforms){let s=t.uniforms[i];switch(this.uniforms[i]={},s.type){case"t":this.uniforms[i].value=e[s.value]||null;break;case"c":this.uniforms[i].value=new Nt().setHex(s.value);break;case"v2":this.uniforms[i].value=new ot().fromArray(s.value);break;case"v3":this.uniforms[i].value=new D().fromArray(s.value);break;case"v4":this.uniforms[i].value=new Le().fromArray(s.value);break;case"m3":this.uniforms[i].value=new ie().fromArray(s.value);break;case"m4":this.uniforms[i].value=new me().fromArray(s.value);break;default:this.uniforms[i].value=s.value}}if(t.defines!==void 0&&(this.defines=t.defines),t.vertexShader!==void 0&&(this.vertexShader=t.vertexShader),t.fragmentShader!==void 0&&(this.fragmentShader=t.fragmentShader),t.glslVersion!==void 0&&(this.glslVersion=t.glslVersion),t.extensions!==void 0)for(let i in t.extensions)this.extensions[i]=t.extensions[i];return t.lights!==void 0&&(this.lights=t.lights),t.clipping!==void 0&&(this.clipping=t.clipping),this}},Er=class extends ze{constructor(t){super(t),this.isRawShaderMaterial=!0,this.type="RawShaderMaterial"}},Ve=class extends qi{constructor(t){super(),this.isMeshStandardMaterial=!0,this.type="MeshStandardMaterial",this.defines={STANDARD:""},this.color=new Nt(16777215),this.roughness=1,this.metalness=0,this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.emissive=new Nt(0),this.emissiveIntensity=1,this.emissiveMap=null,this.bumpMap=null,this.bumpScale=1,this.normalMap=null,this.normalMapType=fo,this.normalScale=new ot(1,1),this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.roughnessMap=null,this.metalnessMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Ai,this.envMapIntensity=1,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.flatShading=!1,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.defines={STANDARD:""},this.color.copy(t.color),this.roughness=t.roughness,this.metalness=t.metalness,this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.emissive.copy(t.emissive),this.emissiveMap=t.emissiveMap,this.emissiveIntensity=t.emissiveIntensity,this.bumpMap=t.bumpMap,this.bumpScale=t.bumpScale,this.normalMap=t.normalMap,this.normalMapType=t.normalMapType,this.normalScale.copy(t.normalScale),this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.roughnessMap=t.roughnessMap,this.metalnessMap=t.metalnessMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.envMapIntensity=t.envMapIntensity,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.flatShading=t.flatShading,this.fog=t.fog,this}},Ri=class extends Ve{constructor(t){super(),this.isMeshPhysicalMaterial=!0,this.defines={STANDARD:"",PHYSICAL:""},this.type="MeshPhysicalMaterial",this.anisotropyRotation=0,this.anisotropyMap=null,this.clearcoatMap=null,this.clearcoatRoughness=0,this.clearcoatRoughnessMap=null,this.clearcoatNormalScale=new ot(1,1),this.clearcoatNormalMap=null,this.ior=1.5,Object.defineProperty(this,"reflectivity",{get:function(){return oe(2.5*(this.ior-1)/(this.ior+1),0,1)},set:function(e){this.ior=(1+.4*e)/(1-.4*e)}}),this.iridescenceMap=null,this.iridescenceIOR=1.3,this.iridescenceThicknessRange=[100,400],this.iridescenceThicknessMap=null,this.sheenColor=new Nt(0),this.sheenColorMap=null,this.sheenRoughness=1,this.sheenRoughnessMap=null,this.transmissionMap=null,this.thickness=0,this.thicknessMap=null,this.attenuationDistance=1/0,this.attenuationColor=new Nt(1,1,1),this.specularIntensity=1,this.specularIntensityMap=null,this.specularColor=new Nt(1,1,1),this.specularColorMap=null,this._anisotropy=0,this._clearcoat=0,this._dispersion=0,this._iridescence=0,this._retroreflectivity=0,this._sheen=0,this._transmission=0,this.setValues(t)}get anisotropy(){return this._anisotropy}set anisotropy(t){this._anisotropy>0!=t>0&&this.version++,this._anisotropy=t}get clearcoat(){return this._clearcoat}set clearcoat(t){this._clearcoat>0!=t>0&&this.version++,this._clearcoat=t}get iridescence(){return this._iridescence}set iridescence(t){this._iridescence>0!=t>0&&this.version++,this._iridescence=t}get dispersion(){return this._dispersion}set dispersion(t){this._dispersion>0!=t>0&&this.version++,this._dispersion=t}get retroreflectivity(){return this._retroreflectivity}set retroreflectivity(t){this._retroreflectivity>0!=t>0&&this.version++,this._retroreflectivity=t}get sheen(){return this._sheen}set sheen(t){this._sheen>0!=t>0&&this.version++,this._sheen=t}get transmission(){return this._transmission}set transmission(t){this._transmission>0!=t>0&&this.version++,this._transmission=t}copy(t){return super.copy(t),this.defines={STANDARD:"",PHYSICAL:""},this.anisotropy=t.anisotropy,this.anisotropyRotation=t.anisotropyRotation,this.anisotropyMap=t.anisotropyMap,this.clearcoat=t.clearcoat,this.clearcoatMap=t.clearcoatMap,this.clearcoatRoughness=t.clearcoatRoughness,this.clearcoatRoughnessMap=t.clearcoatRoughnessMap,this.clearcoatNormalMap=t.clearcoatNormalMap,this.clearcoatNormalScale.copy(t.clearcoatNormalScale),this.dispersion=t.dispersion,this.ior=t.ior,this.iridescence=t.iridescence,this.iridescenceMap=t.iridescenceMap,this.iridescenceIOR=t.iridescenceIOR,this.iridescenceThicknessRange=[...t.iridescenceThicknessRange],this.iridescenceThicknessMap=t.iridescenceThicknessMap,this.retroreflectivity=t.retroreflectivity,this.sheen=t.sheen,this.sheenColor.copy(t.sheenColor),this.sheenColorMap=t.sheenColorMap,this.sheenRoughness=t.sheenRoughness,this.sheenRoughnessMap=t.sheenRoughnessMap,this.transmission=t.transmission,this.transmissionMap=t.transmissionMap,this.thickness=t.thickness,this.thicknessMap=t.thicknessMap,this.attenuationDistance=t.attenuationDistance,this.attenuationColor.copy(t.attenuationColor),this.specularIntensity=t.specularIntensity,this.specularIntensityMap=t.specularIntensityMap,this.specularColor.copy(t.specularColor),this.specularColorMap=t.specularColorMap,this}};var Wa=class extends qi{constructor(t){super(),this.isMeshLambertMaterial=!0,this.type="MeshLambertMaterial",this.color=new Nt(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.emissive=new Nt(0),this.emissiveIntensity=1,this.emissiveMap=null,this.bumpMap=null,this.bumpScale=1,this.normalMap=null,this.normalMapType=fo,this.normalScale=new ot(1,1),this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Ai,this.combine=Kl,this.reflectivity=1,this.envMapIntensity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.flatShading=!1,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.emissive.copy(t.emissive),this.emissiveMap=t.emissiveMap,this.emissiveIntensity=t.emissiveIntensity,this.bumpMap=t.bumpMap,this.bumpScale=t.bumpScale,this.normalMap=t.normalMap,this.normalMapType=t.normalMapType,this.normalScale.copy(t.normalScale),this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.specularMap=t.specularMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.combine=t.combine,this.reflectivity=t.reflectivity,this.envMapIntensity=t.envMapIntensity,this.refractionRatio=t.refractionRatio,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.flatShading=t.flatShading,this.fog=t.fog,this}},zl=class extends qi{constructor(t){super(),this.isMeshDepthMaterial=!0,this.type="MeshDepthMaterial",this.depthPacking=b0,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.wireframe=!1,this.wireframeLinewidth=1,this.setValues(t)}copy(t){return super.copy(t),this.depthPacking=t.depthPacking,this.map=t.map,this.alphaMap=t.alphaMap,this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this}},Ol=class extends qi{constructor(t){super(),this.isMeshDistanceMaterial=!0,this.type="MeshDistanceMaterial",this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.setValues(t)}copy(t){return super.copy(t),this.map=t.map,this.alphaMap=t.alphaMap,this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this}};function nr(n,t){return!n||n.constructor===t?n:typeof t.BYTES_PER_ELEMENT=="number"?new t(n):Array.prototype.slice.call(n)}function mu(n){return n!==void 0&&n.inTangents!==void 0&&n.outTangents!==void 0}var ts=class{constructor(t,e,i,s){this.parameterPositions=t,this._cachedIndex=0,this.resultBuffer=s!==void 0?s:new e.constructor(i),this.sampleValues=e,this.valueSize=i,this.settings=null,this.DefaultSettings_={}}evaluate(t){let e=this.parameterPositions,i=this._cachedIndex,s=e[i],r=e[i-1];i:{t:{let a;e:{n:if(!(t<s)){for(let o=i+2;;){if(s===void 0){if(t<r)break n;return i=e.length,this._cachedIndex=i,this.copySampleValue_(i-1)}if(i===o)break;if(r=s,s=e[++i],t<s)break t}a=e.length;break e}if(!(t>=r)){let o=e[1];t<o&&(i=2,r=o);for(let c=i-2;;){if(r===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(i===c)break;if(s=r,r=e[--i-1],t>=r)break t}a=i,i=0;break e}break i}for(;i<a;){let o=i+a>>>1;t<e[o]?a=o:i=o+1}if(s=e[i],r=e[i-1],r===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(s===void 0)return i=e.length,this._cachedIndex=i,this.copySampleValue_(i-1)}this._cachedIndex=i,this.intervalChanged_(i,r,s)}return this.interpolate_(i,r,t,s)}getSettings_(){return this.settings||this.DefaultSettings_}copySampleValue_(t){let e=this.resultBuffer,i=this.sampleValues,s=this.valueSize,r=t*s;for(let a=0;a!==s;++a)e[a]=i[r+a];return e}interpolate_(){throw new Error("THREE.Interpolant: Call to abstract method.")}intervalChanged_(){}},kl=class extends ts{constructor(t,e,i,s){super(t,e,i,s),this._weightPrev=-0,this._offsetPrev=-0,this._weightNext=-0,this._offsetNext=-0,this.DefaultSettings_={endingStart:vu,endingEnd:vu}}intervalChanged_(t,e,i){let s=this.parameterPositions,r=t-2,a=t+1,o=s[r],c=s[a];if(o===void 0)switch(this.getSettings_().endingStart){case yu:r=t,o=2*e-i;break;case _u:r=s.length-2,o=e+s[r]-s[r+1];break;default:r=t,o=i}if(c===void 0)switch(this.getSettings_().endingEnd){case yu:a=t,c=2*i-e;break;case _u:a=1,c=i+s[1]-s[0];break;default:a=t-1,c=e}let l=(i-e)*.5,h=this.valueSize;this._weightPrev=l/(e-o),this._weightNext=l/(c-i),this._offsetPrev=r*h,this._offsetNext=a*h}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=t*o,l=c-o,h=this._offsetPrev,u=this._offsetNext,d=this._weightPrev,f=this._weightNext,p=(i-e)/(s-e),x=p*p,m=x*p,g=-d*m+2*d*x-d*p,_=(1+d)*m+(-1.5-2*d)*x+(-.5+d)*p+1,T=(-1-f)*m+(1.5+f)*x+.5*p,v=f*m-f*x;for(let S=0;S!==o;++S)r[S]=g*a[h+S]+_*a[l+S]+T*a[c+S]+v*a[u+S];return r}},Bl=class extends ts{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=t*o,l=c-o,h=(i-e)/(s-e),u=1-h;for(let d=0;d!==o;++d)r[d]=a[l+d]*u+a[c+d]*h;return r}},Hl=class extends ts{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t){return this.copySampleValue_(t-1)}},Gl=class extends ts{interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=t*o,l=c-o,h=this.inTangents,u=this.outTangents;if(!h||!u){let p=(i-e)/(s-e),x=1-p;for(let m=0;m!==o;++m)r[m]=a[l+m]*x+a[c+m]*p;return r}let d=o*2,f=t-1;for(let p=0;p!==o;++p){let x=a[l+p],m=a[c+p],g=f*d+p*2,_=u[g],T=u[g+1],v=t*d+p*2,S=h[v],M=h[v+1],A=Ig(i,e,_,S,s);r[p]=B0(A,x,T,M,m)}return r}};function B0(n,t,e,i,s){let r=1-n;return r*r*r*t+3*r*r*n*e+3*r*n*n*i+n*n*n*s}function Pg(n,t,e,i,s){let r=1-n;return 3*r*r*(e-t)+6*r*n*(i-e)+3*n*n*(s-i)}function Ig(n,t,e,i,s){let r=(n-t)/(s-t);for(let a=0;a<8;a++){let o=B0(r,t,e,i,s)-n;if(Math.abs(o)<1e-10)break;let c=Pg(r,t,e,i,s);if(Math.abs(c)<1e-10)break;r=Math.max(0,Math.min(1,r-o/c))}return r}var zi=class{constructor(t,e,i,s){if(t===void 0)throw new Error("THREE.KeyframeTrack: track name is undefined");if(e===void 0||e.length===0)throw new Error("THREE.KeyframeTrack: no keyframes in track named "+t);this.name=t,this.times=nr(e,this.TimeBufferType),this.values=nr(i,this.ValueBufferType),this.setInterpolation(s||this.DefaultInterpolation)}static toJSON(t){let e=t.constructor,i;if(e.toJSON!==this.toJSON)i=e.toJSON(t);else{i={name:t.name,times:nr(t.times,Array),values:nr(t.values,Array)};let s=t.getInterpolation();s!==t.DefaultInterpolation&&(i.interpolation=s),mu(t.settings)&&(i.settings={inTangents:nr(t.settings.inTangents,Array),outTangents:nr(t.settings.outTangents,Array)})}return i.type=t.ValueTypeName,i}InterpolantFactoryMethodDiscrete(t){return new Hl(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodLinear(t){return new Bl(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodSmooth(t){return new kl(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodBezier(t){let e=new Gl(this.times,this.values,this.getValueSize(),t);return this.settings&&(e.inTangents=this.settings.inTangents,e.outTangents=this.settings.outTangents),e}setInterpolation(t){let e;switch(t){case va:e=this.InterpolantFactoryMethodDiscrete;break;case Sl:e=this.InterpolantFactoryMethodLinear;break;case pl:e=this.InterpolantFactoryMethodSmooth;break;case xu:e=this.InterpolantFactoryMethodBezier;break}if(e===void 0){let i="unsupported interpolation for "+this.ValueTypeName+" keyframe track named "+this.name;if(this.createInterpolant===void 0)if(t!==this.DefaultInterpolation)this.setInterpolation(this.DefaultInterpolation);else throw new Error(i);return te("KeyframeTrack:",i),this}return this.createInterpolant=e,this}getInterpolation(){switch(this.createInterpolant){case this.InterpolantFactoryMethodDiscrete:return va;case this.InterpolantFactoryMethodLinear:return Sl;case this.InterpolantFactoryMethodSmooth:return pl;case this.InterpolantFactoryMethodBezier:return xu}}getValueSize(){return this.values.length/this.times.length}shift(t){if(t!==0){let e=this.times;for(let i=0,s=e.length;i!==s;++i)e[i]+=t}return this}scale(t){if(t!==1){let e=this.times;for(let i=0,s=e.length;i!==s;++i)e[i]*=t;mu(this.settings)&&(Wf(this.settings.inTangents,t),Wf(this.settings.outTangents,t))}return this}trim(t,e){let i=this.times,s=i.length,r=0,a=s-1;for(;r!==s&&i[r]<t;)++r;for(;a!==-1&&i[a]>e;)--a;if(++a,r!==0||a!==s){r>=a&&(a=Math.max(a,1),r=a-1);let o=this.getValueSize();this.times=i.slice(r,a),this.values=this.values.slice(r*o,a*o)}return this}validate(){let t=!0,e=this.getValueSize();e-Math.floor(e)!==0&&(ee("KeyframeTrack: Invalid value size in track.",this),t=!1);let i=this.times,s=this.values,r=i.length;r===0&&(ee("KeyframeTrack: Track is empty.",this),t=!1);let a=null;for(let o=0;o!==r;o++){let c=i[o];if(typeof c=="number"&&isNaN(c)){ee("KeyframeTrack: Time is not a valid number.",this,o,c),t=!1;break}if(a!==null&&a>c){ee("KeyframeTrack: Out of order keys.",this,o,c,a),t=!1;break}a=c}if(s!==void 0&&ym(s))for(let o=0,c=s.length;o!==c;++o){let l=s[o];if(isNaN(l)){ee("KeyframeTrack: Value is not a valid number.",this,o,l),t=!1;break}}return t}optimize(){let t=this.times.slice(),e=this.values.slice(),i=this.getValueSize(),s=this.getInterpolation()===pl,r=t.length-1,a=1;for(let o=1;o<r;++o){let c=!1,l=t[o],h=t[o+1];if(l!==h&&(o!==1||l!==t[0]))if(s)c=!0;else{let u=o*i,d=u-i,f=u+i;for(let p=0;p!==i;++p){let x=e[u+p];if(x!==e[d+p]||x!==e[f+p]){c=!0;break}}}if(c){if(o!==a){t[a]=t[o];let u=o*i,d=a*i;for(let f=0;f!==i;++f)e[d+f]=e[u+f]}++a}}if(r>0){t[a]=t[r];for(let o=r*i,c=a*i,l=0;l!==i;++l)e[c+l]=e[o+l];++a}return a!==t.length?(this.times=t.slice(0,a),this.values=e.slice(0,a*i)):(this.times=t,this.values=e),this}clone(){let t=this.times.slice(),e=this.values.slice(),i=this.constructor,s=new i(this.name,t,e);return s.createInterpolant=this.createInterpolant,mu(this.settings)&&(s.settings={inTangents:this.settings.inTangents.slice(),outTangents:this.settings.outTangents.slice()}),s}};function Wf(n,t){for(let e=0,i=n.length;e!==i;e+=2)n[e]*=t}zi.prototype.ValueTypeName="";zi.prototype.TimeBufferType=Float32Array;zi.prototype.ValueBufferType=Float32Array;zi.prototype.DefaultInterpolation=Sl;var es=class extends zi{constructor(t,e,i){super(t,e,i)}};es.prototype.ValueTypeName="bool";es.prototype.ValueBufferType=Array;es.prototype.DefaultInterpolation=va;es.prototype.InterpolantFactoryMethodLinear=void 0;es.prototype.InterpolantFactoryMethodSmooth=void 0;var Vl=class extends zi{constructor(t,e,i,s){super(t,e,i,s)}};Vl.prototype.ValueTypeName="color";var Wl=class extends zi{constructor(t,e,i,s){super(t,e,i,s)}};Wl.prototype.ValueTypeName="number";var Xl=class extends ts{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=(i-e)/(s-e),l=t*o;for(let h=l+o;l!==h;l+=4)Ei.slerpFlat(r,0,a,l-o,a,l,c);return r}},Xa=class extends zi{constructor(t,e,i,s){super(t,e,i,s)}InterpolantFactoryMethodLinear(t){return new Xl(this.times,this.values,this.getValueSize(),t)}};Xa.prototype.ValueTypeName="quaternion";Xa.prototype.InterpolantFactoryMethodSmooth=void 0;var is=class extends zi{constructor(t,e,i){super(t,e,i)}};is.prototype.ValueTypeName="string";is.prototype.ValueBufferType=Array;is.prototype.DefaultInterpolation=va;is.prototype.InterpolantFactoryMethodLinear=void 0;is.prototype.InterpolantFactoryMethodSmooth=void 0;var ql=class extends zi{constructor(t,e,i,s){super(t,e,i,s)}};ql.prototype.ValueTypeName="vector";var $l=class{constructor(t,e,i){let s=this,r=!1,a=0,o=0,c,l=[];this.onStart=void 0,this.onLoad=t,this.onProgress=e,this.onError=i,this._abortController=null,this.itemStart=function(h){o++,r===!1&&s.onStart!==void 0&&s.onStart(h,a,o),r=!0},this.itemEnd=function(h){a++,s.onProgress!==void 0&&s.onProgress(h,a,o),a===o&&(r=!1,s.onLoad!==void 0&&s.onLoad())},this.itemError=function(h){s.onError!==void 0&&s.onError(h)},this.resolveURL=function(h){return h=h.normalize("NFC"),c?c(h):h},this.setURLModifier=function(h){return c=h,this},this.addHandler=function(h,u){return l.push(h,u),this},this.removeHandler=function(h){let u=l.indexOf(h);return u!==-1&&l.splice(u,2),this},this.getHandler=function(h){for(let u=0,d=l.length;u<d;u+=2){let f=l[u],p=l[u+1];if(f.global&&(f.lastIndex=0),f.test(h))return p}return null},this.abort=function(){return this.abortController.abort(),this._abortController=null,this}}get abortController(){return this._abortController||(this._abortController=new AbortController),this._abortController}},H0=new $l,Yl=class{constructor(t){this.manager=t!==void 0?t:H0,this.crossOrigin="anonymous",this.withCredentials=!1,this.path="",this.resourcePath="",this.requestHeader={},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}load(){}loadAsync(t,e){let i=this;return new Promise(function(s,r){i.load(t,s,e,r)})}parse(){}setCrossOrigin(t){return this.crossOrigin=t,this}setWithCredentials(t){return this.withCredentials=t,this}setPath(t){return this.path=t,this}setResourcePath(t){return this.resourcePath=t,this}setRequestHeader(t){return this.requestHeader=t,this}abort(){return this}};Yl.DEFAULT_MATERIAL_NAME="__DEFAULT";var Ar=class extends Ze{constructor(t,e=1){super(),this.isLight=!0,this.type="Light",this.color=new Nt(t),this.intensity=e}copy(t,e){return super.copy(t,e),this.color.copy(t.color),this.intensity=t.intensity,this}toJSON(t){let e=super.toJSON(t);return e.object.color=this.color.getHex(),e.object.intensity=this.intensity,e}},qa=class extends Ar{constructor(t,e,i){super(t,i),this.isHemisphereLight=!0,this.type="HemisphereLight",this.position.copy(Ze.DEFAULT_UP),this.updateMatrix(),this.groundColor=new Nt(e)}copy(t,e){return super.copy(t,e),this.groundColor.copy(t.groundColor),this}toJSON(t){let e=super.toJSON(t);return e.object.groundColor=this.groundColor.getHex(),e}},gu=new me,Xf=new D,qf=new D,$a=class{constructor(t){this.camera=t,this.intensity=1,this.bias=0,this.biasNode=null,this.normalBias=0,this.radius=1,this.blurSamples=8,this.mapSize=new ot(512,512),this.mapType=Ci,this.map=null,this.mapPass=null,this.matrix=new me,this.autoUpdate=!0,this.needsUpdate=!1,this._frustum=new vr,this._frameExtents=new ot(1,1),this._viewportCount=1,this._viewports=[new Le(0,0,1,1)]}getViewportCount(){return this._viewportCount}getCamera(){return this.camera}getFrustum(){return this._frustum}updateMatrices(t){let e=this.camera;Xf.setFromMatrixPosition(t.matrixWorld),e.position.copy(Xf),qf.setFromMatrixPosition(t.target.matrixWorld),e.lookAt(qf),e.updateMatrixWorld(),this._updateMatrix(e,this.matrix,this._frustum)}_updateMatrix(t,e,i,s){gu.multiplyMatrices(t.projectionMatrix,t.matrixWorldInverse),i.setFromProjectionMatrix(gu,t.coordinateSystem,t.reversedDepth);let r=this._frameExtents,a=s?s.z/r.x:1,o=s?s.w/r.y:1,c=s?s.x/r.x:0,l=s?s.y/r.y:0;t.coordinateSystem===cr||t.reversedDepth?e.set(.5*a,0,0,.5*a+c,0,.5*o,0,.5*o+l,0,0,1,0,0,0,0,1):e.set(.5*a,0,0,.5*a+c,0,.5*o,0,.5*o+l,0,0,.5,.5,0,0,0,1),e.multiply(gu)}getViewport(t){return this._viewports[t]}getFrameExtents(){return this._frameExtents}dispose(){this.map&&this.map.dispose(),this.mapPass&&this.mapPass.dispose()}copy(t){return this.camera=t.camera.clone(),this.intensity=t.intensity,this.bias=t.bias,this.radius=t.radius,this.autoUpdate=t.autoUpdate,this.needsUpdate=t.needsUpdate,this.normalBias=t.normalBias,this.blurSamples=t.blurSamples,this.mapSize.copy(t.mapSize),this.biasNode=t.biasNode,this}clone(){return new this.constructor().copy(this)}toJSON(){let t={};return t.intensity=this.intensity,t.bias=this.bias,t.normalBias=this.normalBias,t.radius=this.radius,t.blurSamples=this.blurSamples,t.mapSize=this.mapSize.toArray(),t.camera=this.camera.toJSON(!1).object,delete t.camera.matrix,t}},dl=new D,fl=new Ei,mn=new D,Ya=class extends Ze{constructor(){super(),this.isCamera=!0,this.type="Camera",this.matrixWorldInverse=new me,this.projectionMatrix=new me,this.projectionMatrixInverse=new me,this.coordinateSystem=an,this._reversedDepth=!1}get reversedDepth(){return this._reversedDepth}copy(t,e){return super.copy(t,e),this.matrixWorldInverse.copy(t.matrixWorldInverse),this.projectionMatrix.copy(t.projectionMatrix),this.projectionMatrixInverse.copy(t.projectionMatrixInverse),this.coordinateSystem=t.coordinateSystem,this}getWorldDirection(t){return super.getWorldDirection(t).negate()}updateMatrixWorld(t){super.updateMatrixWorld(t),this.matrixWorld.decompose(dl,fl,mn),mn.x===1&&mn.y===1&&mn.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(dl,fl,mn.set(1,1,1)).invert()}updateWorldMatrix(t,e,i=!1){super.updateWorldMatrix(t,e,i),this.matrixWorld.decompose(dl,fl,mn),mn.x===1&&mn.y===1&&mn.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(dl,fl,mn.set(1,1,1)).invert()}clone(){return new this.constructor().copy(this)}},Jn=new D,$f=new ot,Yf=new ot,ni=class extends Ya{constructor(t=50,e=1,i=.1,s=2e3){super(),this.isPerspectiveCamera=!0,this.type="PerspectiveCamera",this.fov=t,this.zoom=1,this.near=i,this.far=s,this.focus=10,this.aspect=e,this.view=null,this.filmGauge=35,this.filmOffset=0,this.updateProjectionMatrix()}copy(t,e){return super.copy(t,e),this.fov=t.fov,this.zoom=t.zoom,this.near=t.near,this.far=t.far,this.focus=t.focus,this.aspect=t.aspect,this.view=t.view===null?null:Object.assign({},t.view),this.filmGauge=t.filmGauge,this.filmOffset=t.filmOffset,this}setFocalLength(t){let e=.5*this.getFilmHeight()/t;this.fov=ur*2*Math.atan(e),this.updateProjectionMatrix()}getFocalLength(){let t=Math.tan(pa*.5*this.fov);return .5*this.getFilmHeight()/t}getEffectiveFOV(){return ur*2*Math.atan(Math.tan(pa*.5*this.fov)/this.zoom)}getFilmWidth(){return this.filmGauge*Math.min(this.aspect,1)}getFilmHeight(){return this.filmGauge/Math.max(this.aspect,1)}getViewBounds(t,e,i){Jn.set(-1,-1,.5).applyMatrix4(this.projectionMatrixInverse),e.set(Jn.x,Jn.y).multiplyScalar(-t/Jn.z),Jn.set(1,1,.5).applyMatrix4(this.projectionMatrixInverse),i.set(Jn.x,Jn.y).multiplyScalar(-t/Jn.z)}getViewSize(t,e){return this.getViewBounds(t,$f,Yf),e.subVectors(Yf,$f)}setViewOffset(t,e,i,s,r,a){this.aspect=t/e,this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=t,this.view.fullHeight=e,this.view.offsetX=i,this.view.offsetY=s,this.view.width=r,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let t=this.near,e=t*Math.tan(pa*.5*this.fov)/this.zoom,i=2*e,s=this.aspect*i,r=-.5*s,a=this.view;if(this.view!==null&&this.view.enabled){let c=a.fullWidth,l=a.fullHeight;r+=a.offsetX*s/c,e-=a.offsetY*i/l,s*=a.width/c,i*=a.height/l}let o=this.filmOffset;o!==0&&(r+=t*o/this.getFilmWidth()),this.projectionMatrix.makePerspective(r,r+s,e,e-i,t,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(t){let e=super.toJSON(t);return e.object.fov=this.fov,e.object.zoom=this.zoom,e.object.near=this.near,e.object.far=this.far,e.object.focus=this.focus,e.object.aspect=this.aspect,this.view!==null&&(e.object.view=Object.assign({},this.view)),e.object.filmGauge=this.filmGauge,e.object.filmOffset=this.filmOffset,e}};var Eu=class extends $a{constructor(){super(new ni(90,1,.5,500)),this.isPointLightShadow=!0}},ns=class extends Ar{constructor(t,e,i=0,s=2){super(t,e),this.isPointLight=!0,this.type="PointLight",this.distance=i,this.decay=s,this.shadow=new Eu}get power(){return this.intensity*4*Math.PI}set power(t){this.intensity=t/(4*Math.PI)}dispose(){super.dispose(),this.shadow.dispose()}copy(t,e){return super.copy(t,e),this.distance=t.distance,this.decay=t.decay,this.shadow=t.shadow.clone(),this}toJSON(t){let e=super.toJSON(t);return e.object.distance=this.distance,e.object.decay=this.decay,e.object.shadow=this.shadow.toJSON(),e}},ss=class extends Ya{constructor(t=-1,e=1,i=1,s=-1,r=.1,a=2e3){super(),this.isOrthographicCamera=!0,this.type="OrthographicCamera",this.zoom=1,this.view=null,this.left=t,this.right=e,this.top=i,this.bottom=s,this.near=r,this.far=a,this.updateProjectionMatrix()}copy(t,e){return super.copy(t,e),this.left=t.left,this.right=t.right,this.top=t.top,this.bottom=t.bottom,this.near=t.near,this.far=t.far,this.zoom=t.zoom,this.view=t.view===null?null:Object.assign({},t.view),this}setViewOffset(t,e,i,s,r,a){this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=t,this.view.fullHeight=e,this.view.offsetX=i,this.view.offsetY=s,this.view.width=r,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let t=(this.right-this.left)/(2*this.zoom),e=(this.top-this.bottom)/(2*this.zoom),i=(this.right+this.left)/2,s=(this.top+this.bottom)/2,r=i-t,a=i+t,o=s+e,c=s-e;if(this.view!==null&&this.view.enabled){let l=(this.right-this.left)/this.view.fullWidth/this.zoom,h=(this.top-this.bottom)/this.view.fullHeight/this.zoom;r+=l*this.view.offsetX,a=r+l*this.view.width,o-=h*this.view.offsetY,c=o-h*this.view.height}this.projectionMatrix.makeOrthographic(r,a,o,c,this.near,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(t){let e=super.toJSON(t);return e.object.zoom=this.zoom,e.object.left=this.left,e.object.right=this.right,e.object.top=this.top,e.object.bottom=this.bottom,e.object.near=this.near,e.object.far=this.far,this.view!==null&&(e.object.view=Object.assign({},this.view)),e}},Au=class extends $a{constructor(){super(new ss(-5,5,5,-5,.5,500)),this.isDirectionalLightShadow=!0}},Za=class extends Ar{constructor(t,e){super(t,e),this.isDirectionalLight=!0,this.type="DirectionalLight",this.position.copy(Ze.DEFAULT_UP),this.updateMatrix(),this.target=new Ze,this.shadow=new Au}dispose(){super.dispose(),this.shadow.dispose()}copy(t){return super.copy(t),this.target=t.target.clone(),this.shadow=t.shadow.clone(),this}toJSON(t){let e=super.toJSON(t);return e.object.shadow=this.shadow.toJSON(),e.object.target=this.target.uuid,e}};var sr=-90,rr=1,Rr=class extends Ze{constructor(t,e,i){super(),this.type="CubeCamera",this.renderTarget=i,this.coordinateSystem=null,this.activeMipmapLevel=0;let s=new ni(sr,rr,t,e);s.layers=this.layers,this.add(s);let r=new ni(sr,rr,t,e);r.layers=this.layers,this.add(r);let a=new ni(sr,rr,t,e);a.layers=this.layers,this.add(a);let o=new ni(sr,rr,t,e);o.layers=this.layers,this.add(o);let c=new ni(sr,rr,t,e);c.layers=this.layers,this.add(c);let l=new ni(sr,rr,t,e);l.layers=this.layers,this.add(l)}updateCoordinateSystem(){let t=this.coordinateSystem,e=this.children.concat(),[i,s,r,a,o,c]=e;for(let l of e)this.remove(l);if(t===an)i.up.set(0,1,0),i.lookAt(1,0,0),s.up.set(0,1,0),s.lookAt(-1,0,0),r.up.set(0,0,-1),r.lookAt(0,1,0),a.up.set(0,0,1),a.lookAt(0,-1,0),o.up.set(0,1,0),o.lookAt(0,0,1),c.up.set(0,1,0),c.lookAt(0,0,-1);else if(t===cr)i.up.set(0,-1,0),i.lookAt(-1,0,0),s.up.set(0,-1,0),s.lookAt(1,0,0),r.up.set(0,0,1),r.lookAt(0,1,0),a.up.set(0,0,-1),a.lookAt(0,-1,0),o.up.set(0,-1,0),o.lookAt(0,0,1),c.up.set(0,-1,0),c.lookAt(0,0,-1);else throw new Error("THREE.CubeCamera.updateCoordinateSystem(): Invalid coordinate system: "+t);for(let l of e)this.add(l),l.updateMatrixWorld()}update(t,e){this.parent===null&&this.updateMatrixWorld();let{renderTarget:i,activeMipmapLevel:s}=this;this.coordinateSystem!==t.coordinateSystem&&(this.coordinateSystem=t.coordinateSystem,this.updateCoordinateSystem());let[r,a,o,c,l,h]=this.children,u=t.getRenderTarget(),d=t.getActiveCubeFace(),f=t.getActiveMipmapLevel(),p=t.xr.enabled;t.xr.enabled=!1;let x=i.texture.generateMipmaps;i.texture.generateMipmaps=!1;let m=!1;t.isWebGLRenderer===!0?m=t.state.buffers.depth.getReversed():m=t.reversedDepthBuffer,t.setRenderTarget(i,0,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,r),t.setRenderTarget(i,1,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,a),t.setRenderTarget(i,2,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,o),t.setRenderTarget(i,3,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,c),t.setRenderTarget(i,4,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,l),i.texture.generateMipmaps=x,t.setRenderTarget(i,5,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,h),t.setRenderTarget(u,d,f),t.xr.enabled=p,i.texture.needsPMREMUpdate=!0}},Zl=class extends ni{constructor(t=[]){super(),this.isArrayCamera=!0,this.isMultiViewCamera=!1,this.cameras=t}},Ja=class{constructor(){this._previousTime=0,this._currentTime=0,this._startTime=performance.now(),this._delta=0,this._elapsed=0,this._timescale=1,this._document=null,this._pageVisibilityHandler=null}connect(t){this._document=t,t.hidden!==void 0&&(this._pageVisibilityHandler=Lg.bind(this),t.addEventListener("visibilitychange",this._pageVisibilityHandler,!1))}disconnect(){this._pageVisibilityHandler!==null&&(this._document.removeEventListener("visibilitychange",this._pageVisibilityHandler),this._pageVisibilityHandler=null),this._document=null}getDelta(){return this._delta/1e3}getElapsed(){return this._elapsed/1e3}getTimescale(){return this._timescale}setTimescale(t){return this._timescale=t,this}reset(){return this._currentTime=performance.now()-this._startTime,this}dispose(){this.disconnect()}update(t){return this._pageVisibilityHandler!==null&&this._document.hidden===!0?this._delta=0:(this._previousTime=this._currentTime,this._currentTime=(t!==void 0?t:performance.now())-this._startTime,this._delta=(this._currentTime-this._previousTime)*this._timescale,this._elapsed+=this._delta),this}};function Lg(){this._document.hidden===!1&&this.reset()}var Zu="\\[\\]\\.:\\/",Dg=new RegExp("["+Zu+"]","g"),Ju="[^"+Zu+"]",Ng="[^"+Zu.replace("\\.","")+"]",Ug=/((?:WC+[\/:])*)/.source.replace("WC",Ju),Fg=/(WCOD+)?/.source.replace("WCOD",Ng),zg=/(?:\.(WC+)(?:\[(.+)\])?)?/.source.replace("WC",Ju),Og=/\.(WC+)(?:\[(.+)\])?/.source.replace("WC",Ju),kg=new RegExp("^"+Ug+Fg+zg+Og+"$"),Bg=["material","materials","bones","map"],Ru=class{constructor(t,e,i){let s=i||Fe.parseTrackName(e);this._targetGroup=t,this._bindings=t.subscribe_(e,s)}getValue(t,e){this.bind();let i=this._targetGroup.nCachedObjects_,s=this._bindings[i];s!==void 0&&s.getValue(t,e)}setValue(t,e){let i=this._bindings;for(let s=this._targetGroup.nCachedObjects_,r=i.length;s!==r;++s)i[s].setValue(t,e)}bind(){let t=this._bindings;for(let e=this._targetGroup.nCachedObjects_,i=t.length;e!==i;++e)t[e].bind()}unbind(){let t=this._bindings;for(let e=this._targetGroup.nCachedObjects_,i=t.length;e!==i;++e)t[e].unbind()}},Fe=class n{constructor(t,e,i){this.path=e,this.parsedPath=i||n.parseTrackName(e),this.node=n.findNode(t,this.parsedPath.nodeName),this.rootNode=t,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}static create(t,e,i){return t&&t.isAnimationObjectGroup?new n.Composite(t,e,i):new n(t,e,i)}static sanitizeNodeName(t){return t.replace(/\s/g,"_").replace(Dg,"")}static parseTrackName(t){let e=kg.exec(t);if(e===null)throw new Error("THREE.PropertyBinding: Cannot parse trackName: "+t);let i={nodeName:e[2],objectName:e[3],objectIndex:e[4],propertyName:e[5],propertyIndex:e[6]},s=i.nodeName&&i.nodeName.lastIndexOf(".");if(s!==void 0&&s!==-1){let r=i.nodeName.substring(s+1);Bg.indexOf(r)!==-1&&(i.nodeName=i.nodeName.substring(0,s),i.objectName=r)}if(i.propertyName===null||i.propertyName.length===0)throw new Error("THREE.PropertyBinding: can not parse propertyName from trackName: "+t);return i}static findNode(t,e){if(e===void 0||e===""||e==="."||e===-1||e===t.name||e===t.uuid)return t;if(t.skeleton){let i=t.skeleton.getBoneByName(e);if(i!==void 0)return i}if(t.children){let i=function(r){for(let a=0;a<r.length;a++){let o=r[a];if(o.name===e||o.uuid===e)return o;let c=i(o.children);if(c)return c}return null},s=i(t.children);if(s)return s}return null}_getValue_unavailable(){}_setValue_unavailable(){}_getValue_direct(t,e){t[e]=this.targetObject[this.propertyName]}_getValue_array(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)t[e++]=i[s]}_getValue_arrayElement(t,e){t[e]=this.resolvedProperty[this.propertyIndex]}_getValue_toArray(t,e){this.resolvedProperty.toArray(t,e)}_setValue_direct(t,e){this.targetObject[this.propertyName]=t[e]}_setValue_direct_setNeedsUpdate(t,e){this.targetObject[this.propertyName]=t[e],this.targetObject.needsUpdate=!0}_setValue_direct_setMatrixWorldNeedsUpdate(t,e){this.targetObject[this.propertyName]=t[e],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_array(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++]}_setValue_array_setNeedsUpdate(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++];this.targetObject.needsUpdate=!0}_setValue_array_setMatrixWorldNeedsUpdate(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++];this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_arrayElement(t,e){this.resolvedProperty[this.propertyIndex]=t[e]}_setValue_arrayElement_setNeedsUpdate(t,e){this.resolvedProperty[this.propertyIndex]=t[e],this.targetObject.needsUpdate=!0}_setValue_arrayElement_setMatrixWorldNeedsUpdate(t,e){this.resolvedProperty[this.propertyIndex]=t[e],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_fromArray(t,e){this.resolvedProperty.fromArray(t,e)}_setValue_fromArray_setNeedsUpdate(t,e){this.resolvedProperty.fromArray(t,e),this.targetObject.needsUpdate=!0}_setValue_fromArray_setMatrixWorldNeedsUpdate(t,e){this.resolvedProperty.fromArray(t,e),this.targetObject.matrixWorldNeedsUpdate=!0}_getValue_unbound(t,e){this.bind(),this.getValue(t,e)}_setValue_unbound(t,e){this.bind(),this.setValue(t,e)}bind(){let t=this.node,e=this.parsedPath,i=e.objectName,s=e.propertyName,r=e.propertyIndex;if(t||(t=n.findNode(this.rootNode,e.nodeName),this.node=t),this.getValue=this._getValue_unavailable,this.setValue=this._setValue_unavailable,!t){te("PropertyBinding: No target node found for track: "+this.path+".");return}if(i){let l=e.objectIndex;switch(i){case"materials":if(!t.material){ee("PropertyBinding: Can not bind to material as node does not have a material.",this);return}if(!t.material.materials){ee("PropertyBinding: Can not bind to material.materials as node.material does not have a materials array.",this);return}t=t.material.materials;break;case"bones":if(!t.skeleton){ee("PropertyBinding: Can not bind to bones as node does not have a skeleton.",this);return}t=t.skeleton.bones;for(let h=0;h<t.length;h++)if(t[h].name===l){l=h;break}break;case"map":if("map"in t){t=t.map;break}if(!t.material){ee("PropertyBinding: Can not bind to material as node does not have a material.",this);return}if(!t.material.map){ee("PropertyBinding: Can not bind to material.map as node.material does not have a map.",this);return}t=t.material.map;break;default:if(t[i]===void 0){ee("PropertyBinding: Can not bind to objectName of node undefined.",this);return}t=t[i]}if(l!==void 0){if(t[l]===void 0){ee("PropertyBinding: Trying to bind to objectIndex of objectName, but is undefined.",this,t);return}t=t[l]}}let a=t[s];if(a===void 0){let l=e.nodeName;ee("PropertyBinding: Trying to update property for track: "+l+"."+s+" but it wasn't found.",t);return}let o=this.Versioning.None;this.targetObject=t,t.isMaterial===!0?o=this.Versioning.NeedsUpdate:t.isObject3D===!0&&(o=this.Versioning.MatrixWorldNeedsUpdate);let c=this.BindingType.Direct;if(r!==void 0){if(s==="morphTargetInfluences"){if(!t.geometry){ee("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.",this);return}if(!t.geometry.morphAttributes){ee("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.morphAttributes.",this);return}t.morphTargetDictionary[r]!==void 0&&(r=t.morphTargetDictionary[r])}c=this.BindingType.ArrayElement,this.resolvedProperty=a,this.propertyIndex=r}else a.fromArray!==void 0&&a.toArray!==void 0?(c=this.BindingType.HasFromToArray,this.resolvedProperty=a):Array.isArray(a)?(c=this.BindingType.EntireArray,this.resolvedProperty=a):this.propertyName=s;this.getValue=this.GetterByBindingType[c],this.setValue=this.SetterByBindingTypeAndVersioning[c][o]}unbind(){this.node=null,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}};Fe.Composite=Ru;Fe.prototype.BindingType={Direct:0,EntireArray:1,ArrayElement:2,HasFromToArray:3};Fe.prototype.Versioning={None:0,NeedsUpdate:1,MatrixWorldNeedsUpdate:2};Fe.prototype.GetterByBindingType=[Fe.prototype._getValue_direct,Fe.prototype._getValue_array,Fe.prototype._getValue_arrayElement,Fe.prototype._getValue_toArray];Fe.prototype.SetterByBindingTypeAndVersioning=[[Fe.prototype._setValue_direct,Fe.prototype._setValue_direct_setNeedsUpdate,Fe.prototype._setValue_direct_setMatrixWorldNeedsUpdate],[Fe.prototype._setValue_array,Fe.prototype._setValue_array_setNeedsUpdate,Fe.prototype._setValue_array_setMatrixWorldNeedsUpdate],[Fe.prototype._setValue_arrayElement,Fe.prototype._setValue_arrayElement_setNeedsUpdate,Fe.prototype._setValue_arrayElement_setMatrixWorldNeedsUpdate],[Fe.prototype._setValue_fromArray,Fe.prototype._setValue_fromArray_setNeedsUpdate,Fe.prototype._setValue_fromArray_setMatrixWorldNeedsUpdate]];var Ab=new Float32Array(1);var Zf=new me,Ka=class{constructor(t,e,i=0,s=1/0){this.ray=new Ts(t,e),this.near=i,this.far=s,this.camera=null,this.layers=new fr,this.params={Mesh:{},Line:{threshold:1},LOD:{},Points:{threshold:1},Sprite:{}}}set(t,e){this.ray.set(t,e)}setFromCamera(t,e){e.isPerspectiveCamera?(this.ray.origin.setFromMatrixPosition(e.matrixWorld),this.ray.direction.set(t.x,t.y,.5).unproject(e).sub(this.ray.origin).normalize(),this.camera=e):e.isOrthographicCamera?(this.ray.origin.set(t.x,t.y,e.projectionMatrix.elements[14]).unproject(e),this.ray.direction.set(0,0,-1).transformDirection(e.matrixWorld),this.camera=e):ee("Raycaster: Unsupported camera type: "+e.type)}setFromXRController(t){return Zf.identity().extractRotation(t.matrixWorld),this.ray.origin.setFromMatrixPosition(t.matrixWorld),this.ray.direction.set(0,0,-1).applyMatrix4(Zf),this}intersectObject(t,e=!0,i=[]){return Cu(t,this,i,e),i.sort(Jf),i}intersectObjects(t,e=!0,i=[]){for(let s=0,r=t.length;s<r;s++)Cu(t[s],this,i,e);return i.sort(Jf),i}};function Jf(n,t){return n.distance-t.distance}function Cu(n,t,e,i){let s=!0;if(n.layers.test(t.layers)&&n.raycast(t,e)===!1&&(s=!1),s===!0&&i===!0){let r=n.children;for(let a=0,o=r.length;a<o;a++)Cu(r[a],t,e,!0)}}var id=class id{constructor(t,e,i,s){this.elements=[1,0,0,1],t!==void 0&&this.set(t,e,i,s)}identity(){return this.set(1,0,0,1),this}fromArray(t,e=0){for(let i=0;i<4;i++)this.elements[i]=t[i+e];return this}set(t,e,i,s){let r=this.elements;return r[0]=t,r[2]=e,r[1]=i,r[3]=s,this}};id.prototype.isMatrix2=!0;var Pu=id;function Ku(n,t,e,i){let s=Hg(i);switch(e){case Hu:return n*t;case sc:return n*t/s.components*s.byteLength;case rc:return n*t/s.components*s.byteLength;case cs:return n*t*2/s.components*s.byteLength;case ac:return n*t*2/s.components*s.byteLength;case Gu:return n*t*3/s.components*s.byteLength;case Ji:return n*t*4/s.components*s.byteLength;case oc:return n*t*4/s.components*s.byteLength;case ao:case oo:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*8;case lo:case co:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case cc:case uc:return Math.max(n,16)*Math.max(t,8)/4;case lc:case hc:return Math.max(n,8)*Math.max(t,8)/2;case dc:case fc:case mc:case gc:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*8;case pc:case ho:case xc:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case vc:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case yc:return Math.floor((n+4)/5)*Math.floor((t+3)/4)*16;case _c:return Math.floor((n+4)/5)*Math.floor((t+4)/5)*16;case bc:return Math.floor((n+5)/6)*Math.floor((t+4)/5)*16;case Mc:return Math.floor((n+5)/6)*Math.floor((t+5)/6)*16;case Sc:return Math.floor((n+7)/8)*Math.floor((t+4)/5)*16;case wc:return Math.floor((n+7)/8)*Math.floor((t+5)/6)*16;case Tc:return Math.floor((n+7)/8)*Math.floor((t+7)/8)*16;case Ec:return Math.floor((n+9)/10)*Math.floor((t+4)/5)*16;case Ac:return Math.floor((n+9)/10)*Math.floor((t+5)/6)*16;case Rc:return Math.floor((n+9)/10)*Math.floor((t+7)/8)*16;case Cc:return Math.floor((n+9)/10)*Math.floor((t+9)/10)*16;case Pc:return Math.floor((n+11)/12)*Math.floor((t+9)/10)*16;case Ic:return Math.floor((n+11)/12)*Math.floor((t+11)/12)*16;case Lc:case Dc:case Nc:return Math.ceil(n/4)*Math.ceil(t/4)*16;case Uc:case Fc:return Math.ceil(n/4)*Math.ceil(t/4)*8;case uo:case zc:return Math.ceil(n/4)*Math.ceil(t/4)*16}throw new Error(`Unable to determine texture byte length for ${e} format.`)}function Hg(n){switch(n){case Ci:case zu:return{byteLength:1,components:1};case Pr:case Ou:case qe:return{byteLength:2,components:1};case ic:case nc:return{byteLength:2,components:4};case cn:case ec:case Zi:return{byteLength:4,components:1};case ku:case Bu:return{byteLength:4,components:3}}throw new Error(`THREE.TextureUtils: Unknown texture type ${n}.`)}typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("register",{detail:{revision:"186"}}));typeof window<"u"&&(window.__THREE__?te("WARNING: Multiple instances of Three.js being imported."):window.__THREE__="186");function cp(){let n=null,t=!1,e=null,i=null;function s(r,a){i=n.requestAnimationFrame(s),e(r,a)}return{start:function(){t!==!0&&e!==null&&n!==null&&(i=n.requestAnimationFrame(s),t=!0)},stop:function(){n!==null&&n.cancelAnimationFrame(i),t=!1},setAnimationLoop:function(r){e=r},setContext:function(r){n=r}}}function qg(n){let t=new WeakMap;function e(o,c){let l=o.array,h=o.usage,u=l.byteLength,d=n.createBuffer();n.bindBuffer(c,d),n.bufferData(c,l,h),o.onUploadCallback();let f;if(l instanceof Float32Array)f=n.FLOAT;else if(typeof Float16Array<"u"&&l instanceof Float16Array)f=n.HALF_FLOAT;else if(l instanceof Uint16Array)o.isFloat16BufferAttribute?f=n.HALF_FLOAT:f=n.UNSIGNED_SHORT;else if(l instanceof Int16Array)f=n.SHORT;else if(l instanceof Uint32Array)f=n.UNSIGNED_INT;else if(l instanceof Int32Array)f=n.INT;else if(l instanceof Int8Array)f=n.BYTE;else if(l instanceof Uint8Array)f=n.UNSIGNED_BYTE;else if(l instanceof Uint8ClampedArray)f=n.UNSIGNED_BYTE;else throw new Error("THREE.WebGLAttributes: Unsupported buffer data format: "+l);return{buffer:d,type:f,bytesPerElement:l.BYTES_PER_ELEMENT,version:o.version,size:u}}function i(o,c,l){let h=c.array,u=c.updateRanges;if(n.bindBuffer(l,o),u.length===0)n.bufferSubData(l,0,h);else{u.sort((f,p)=>f.start-p.start);let d=0;for(let f=1;f<u.length;f++){let p=u[d],x=u[f];x.start<=p.start+p.count+1?p.count=Math.max(p.count,x.start+x.count-p.start):(++d,u[d]=x)}u.length=d+1;for(let f=0,p=u.length;f<p;f++){let x=u[f];n.bufferSubData(l,x.start*h.BYTES_PER_ELEMENT,h,x.start,x.count)}c.clearUpdateRanges()}c.onUploadCallback()}function s(o){return o.isInterleavedBufferAttribute&&(o=o.data),t.get(o)}function r(o){o.isInterleavedBufferAttribute&&(o=o.data);let c=t.get(o);c&&(n.deleteBuffer(c.buffer),t.delete(o))}function a(o,c){if(o.isInterleavedBufferAttribute&&(o=o.data),o.isGLBufferAttribute){let h=t.get(o);(!h||h.version<o.version)&&t.set(o,{buffer:o.buffer,type:o.type,bytesPerElement:o.elementSize,version:o.version});return}let l=t.get(o);if(l===void 0)t.set(o,e(o,c));else if(l.version<o.version){if(l.size!==o.array.byteLength)throw new Error("THREE.WebGLAttributes: The size of the buffer attribute's array buffer does not match the original size. Resizing buffer attributes is not supported.");i(l.buffer,o,c),l.version=o.version}}return{get:s,remove:r,update:a}}var $g=`#ifdef USE_ALPHAHASH
	if ( diffuseColor.a < getAlphaHashThreshold( vPosition ) ) discard;
#endif`,Yg=`#ifdef USE_ALPHAHASH
	const float ALPHA_HASH_SCALE = 0.05;
	float hash2D( vec2 value ) {
		return fract( 1.0e4 * sin( 17.0 * value.x + 0.1 * value.y ) * ( 0.1 + abs( sin( 13.0 * value.y + value.x ) ) ) );
	}
	float hash3D( vec3 value ) {
		return hash2D( vec2( hash2D( value.xy ), value.z ) );
	}
	float getAlphaHashThreshold( vec3 position ) {
		float maxDeriv = max(
			length( dFdx( position.xyz ) ),
			length( dFdy( position.xyz ) )
		);
		float pixScale = 1.0 / ( ALPHA_HASH_SCALE * maxDeriv );
		vec2 pixScales = vec2(
			exp2( floor( log2( pixScale ) ) ),
			exp2( ceil( log2( pixScale ) ) )
		);
		vec2 alpha = vec2(
			hash3D( floor( pixScales.x * position.xyz ) ),
			hash3D( floor( pixScales.y * position.xyz ) )
		);
		float lerpFactor = fract( log2( pixScale ) );
		float x = ( 1.0 - lerpFactor ) * alpha.x + lerpFactor * alpha.y;
		float a = min( lerpFactor, 1.0 - lerpFactor );
		vec3 cases = vec3(
			x * x / ( 2.0 * a * ( 1.0 - a ) ),
			( x - 0.5 * a ) / ( 1.0 - a ),
			1.0 - ( ( 1.0 - x ) * ( 1.0 - x ) / ( 2.0 * a * ( 1.0 - a ) ) )
		);
		float threshold = ( x < ( 1.0 - a ) )
			? ( ( x < a ) ? cases.x : cases.y )
			: cases.z;
		return clamp( threshold , 1.0e-6, 1.0 );
	}
#endif`,Zg=`#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, vAlphaMapUv ).g;
#endif`,Jg=`#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,Kg=`#ifdef USE_ALPHATEST
	#ifdef ALPHA_TO_COVERAGE
	diffuseColor.a = smoothstep( alphaTest, alphaTest + fwidth( diffuseColor.a ), diffuseColor.a );
	if ( diffuseColor.a == 0.0 ) discard;
	#else
	if ( diffuseColor.a < alphaTest ) discard;
	#endif
#endif`,jg=`#ifdef USE_ALPHATEST
	uniform float alphaTest;
#endif`,Qg=`#ifdef USE_AOMAP
	float ambientOcclusion = ( texture2D( aoMap, vAoMapUv ).r - 1.0 ) * aoMapIntensity + 1.0;
	reflectedLight.indirectDiffuse *= ambientOcclusion;
	#if defined( USE_CLEARCOAT ) 
		clearcoatSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_SHEEN ) 
		sheenSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_ENVMAP ) && defined( STANDARD )
		float dotNV = saturate( dot( geometryNormal, geometryViewDir ) );
		reflectedLight.indirectSpecular *= computeSpecularOcclusion( dotNV, ambientOcclusion, material.roughness );
	#endif
#endif`,tx=`#ifdef USE_AOMAP
	uniform sampler2D aoMap;
	uniform float aoMapIntensity;
#endif`,ex=`#ifdef USE_BATCHING
	#if ! defined( GL_ANGLE_multi_draw )
	#define gl_DrawID _gl_DrawID
	uniform int _gl_DrawID;
	#endif
	uniform highp sampler2D batchingTexture;
	uniform highp usampler2D batchingIdTexture;
	mat4 getBatchingMatrix( const in float i ) {
		int size = textureSize( batchingTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( batchingTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( batchingTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( batchingTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( batchingTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
	float getIndirectIndex( const in int i ) {
		int size = textureSize( batchingIdTexture, 0 ).x;
		int x = i % size;
		int y = i / size;
		return float( texelFetch( batchingIdTexture, ivec2( x, y ), 0 ).r );
	}
#endif
#ifdef USE_BATCHING_COLOR
	uniform sampler2D batchingColorTexture;
	vec4 getBatchingColor( const in float i ) {
		int size = textureSize( batchingColorTexture, 0 ).x;
		int j = int( i );
		int x = j % size;
		int y = j / size;
		return texelFetch( batchingColorTexture, ivec2( x, y ), 0 );
	}
#endif`,ix=`#ifdef USE_BATCHING
	mat4 batchingMatrix = getBatchingMatrix( getIndirectIndex( gl_DrawID ) );
#endif`,nx=`vec3 transformed = vec3( position );
#ifdef USE_ALPHAHASH
	vPosition = vec3( position );
#endif`,sx=`vec3 objectNormal = vec3( normal );
#ifdef USE_TANGENT
	vec3 objectTangent = vec3( tangent.xyz );
#endif`,rx=`float G_BlinnPhong_Implicit( ) {
	return 0.25;
}
float D_BlinnPhong( const in float shininess, const in float dotNH ) {
	return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess );
}
vec3 BRDF_BlinnPhong( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in vec3 specularColor, const in float shininess ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( specularColor, 1.0, dotVH );
	float G = G_BlinnPhong_Implicit( );
	float D = D_BlinnPhong( shininess, dotNH );
	return F * ( G * D );
} // validated`,ax=`#ifdef USE_IRIDESCENCE
	const mat3 XYZ_TO_REC709 = mat3(
		 3.2404542, -0.9692660,  0.0556434,
		-1.5371385,  1.8760108, -0.2040259,
		-0.4985314,  0.0415560,  1.0572252
	);
	vec3 Fresnel0ToIor( vec3 fresnel0 ) {
		vec3 sqrtF0 = sqrt( fresnel0 );
		return ( vec3( 1.0 ) + sqrtF0 ) / ( vec3( 1.0 ) - sqrtF0 );
	}
	vec3 IorToFresnel0( vec3 transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - vec3( incidentIor ) ) / ( transmittedIor + vec3( incidentIor ) ) );
	}
	float IorToFresnel0( float transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - incidentIor ) / ( transmittedIor + incidentIor ));
	}
	vec3 evalSensitivity( float OPD, vec3 shift ) {
		float phase = 2.0 * PI * OPD * 1.0e-9;
		vec3 val = vec3( 5.4856e-13, 4.4201e-13, 5.2481e-13 );
		vec3 pos = vec3( 1.6810e+06, 1.7953e+06, 2.2084e+06 );
		vec3 var = vec3( 4.3278e+09, 9.3046e+09, 6.6121e+09 );
		vec3 xyz = val * sqrt( 2.0 * PI * var ) * cos( pos * phase + shift ) * exp( - pow2( phase ) * var );
		xyz.x += 9.7470e-14 * sqrt( 2.0 * PI * 4.5282e+09 ) * cos( 2.2399e+06 * phase + shift[ 0 ] ) * exp( - 4.5282e+09 * pow2( phase ) );
		xyz /= 1.0685e-7;
		vec3 rgb = XYZ_TO_REC709 * xyz;
		return rgb;
	}
	vec3 evalIridescence( float outsideIOR, float eta2, float cosTheta1, float thinFilmThickness, vec3 baseF0 ) {
		vec3 I;
		float iridescenceIOR = mix( outsideIOR, eta2, smoothstep( 0.0, 0.03, thinFilmThickness ) );
		float sinTheta2Sq = pow2( outsideIOR / iridescenceIOR ) * ( 1.0 - pow2( cosTheta1 ) );
		float cosTheta2Sq = 1.0 - sinTheta2Sq;
		if ( cosTheta2Sq < 0.0 ) {
			return vec3( 1.0 );
		}
		float cosTheta2 = sqrt( cosTheta2Sq );
		float R0 = IorToFresnel0( iridescenceIOR, outsideIOR );
		float R12 = F_Schlick( R0, 1.0, cosTheta1 );
		float T121 = 1.0 - R12;
		float phi12 = 0.0;
		if ( iridescenceIOR < outsideIOR ) phi12 = PI;
		float phi21 = PI - phi12;
		vec3 baseIOR = Fresnel0ToIor( clamp( baseF0, 0.0, 0.9999 ) );		vec3 R1 = IorToFresnel0( baseIOR, iridescenceIOR );
		vec3 R23 = F_Schlick( R1, 1.0, cosTheta2 );
		vec3 phi23 = vec3( 0.0 );
		if ( baseIOR[ 0 ] < iridescenceIOR ) phi23[ 0 ] = PI;
		if ( baseIOR[ 1 ] < iridescenceIOR ) phi23[ 1 ] = PI;
		if ( baseIOR[ 2 ] < iridescenceIOR ) phi23[ 2 ] = PI;
		float OPD = 2.0 * iridescenceIOR * thinFilmThickness * cosTheta2;
		vec3 phi = vec3( phi21 ) + phi23;
		vec3 R123 = clamp( R12 * R23, 1e-5, 0.9999 );
		vec3 r123 = sqrt( R123 );
		vec3 Rs = pow2( T121 ) * R23 / ( vec3( 1.0 ) - R123 );
		vec3 C0 = R12 + Rs;
		I = C0;
		vec3 Cm = Rs - T121;
		for ( int m = 1; m <= 2; ++ m ) {
			Cm *= r123;
			vec3 Sm = 2.0 * evalSensitivity( float( m ) * OPD, float( m ) * phi );
			I += Cm * Sm;
		}
		return max( I, vec3( 0.0 ) );
	}
#endif`,ox=`#ifdef USE_BUMPMAP
	uniform sampler2D bumpMap;
	uniform float bumpScale;
	vec2 dHdxy_fwd() {
		vec2 dSTdx = dFdx( vBumpMapUv );
		vec2 dSTdy = dFdy( vBumpMapUv );
		float Hll = bumpScale * texture2D( bumpMap, vBumpMapUv ).x;
		float dBx = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdx ).x - Hll;
		float dBy = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdy ).x - Hll;
		return vec2( dBx, dBy );
	}
	vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy, float faceDirection ) {
		vec3 vSigmaX = normalize( dFdx( surf_pos.xyz ) );
		vec3 vSigmaY = normalize( dFdy( surf_pos.xyz ) );
		vec3 vN = surf_norm;
		vec3 R1 = cross( vSigmaY, vN );
		vec3 R2 = cross( vN, vSigmaX );
		float fDet = dot( vSigmaX, R1 ) * faceDirection;
		vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );
		return normalize( abs( fDet ) * surf_norm - vGrad );
	}
#endif`,lx=`#if NUM_CLIPPING_PLANES > 0
	vec4 plane;
	#ifdef ALPHA_TO_COVERAGE
		float distanceToPlane, distanceGradient;
		float clipOpacity = 1.0;
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
			distanceGradient = fwidth( distanceToPlane ) / 2.0;
			clipOpacity *= smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			if ( clipOpacity == 0.0 ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			float unionClipOpacity = 1.0;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
				distanceGradient = fwidth( distanceToPlane ) / 2.0;
				unionClipOpacity *= 1.0 - smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			}
			#pragma unroll_loop_end
			clipOpacity *= 1.0 - unionClipOpacity;
		#endif
		diffuseColor.a *= clipOpacity;
		if ( diffuseColor.a == 0.0 ) discard;
	#else
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			if ( dot( vClipPosition, plane.xyz ) > plane.w ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			bool clipped = true;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				clipped = ( dot( vClipPosition, plane.xyz ) > plane.w ) && clipped;
			}
			#pragma unroll_loop_end
			if ( clipped ) discard;
		#endif
	#endif
#endif`,cx=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];
#endif`,hx=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
#endif`,ux=`#if NUM_CLIPPING_PLANES > 0
	vClipPosition = - mvPosition.xyz;
#endif`,dx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	diffuseColor *= vColor;
#endif`,fx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	varying vec4 vColor;
#endif`,px=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	varying vec4 vColor;
#endif`,mx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	vColor = vec4( 1.0 );
#endif
#ifdef USE_COLOR_ALPHA
	vColor *= color;
#elif defined( USE_COLOR )
	vColor.rgb *= color;
#endif
#ifdef USE_INSTANCING_COLOR
	vColor.rgb *= instanceColor.rgb;
#endif
#ifdef USE_BATCHING_COLOR
	vColor *= getBatchingColor( getIndirectIndex( gl_DrawID ) );
#endif`,gx=`#define PI 3.141592653589793
#define PI2 6.283185307179586
#define PI_HALF 1.5707963267948966
#define RECIPROCAL_PI 0.3183098861837907
#define RECIPROCAL_PI2 0.15915494309189535
#define EPSILON 1e-6
#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
#define whiteComplement( a ) ( 1.0 - saturate( a ) )
float pow2( const in float x ) { return x*x; }
vec3 pow2( const in vec3 x ) { return x*x; }
float pow3( const in float x ) { return x*x*x; }
float pow4( const in float x ) { float x2 = x*x; return x2*x2; }
float max3( const in vec3 v ) { return max( max( v.x, v.y ), v.z ); }
float average( const in vec3 v ) { return dot( v, vec3( 0.3333333 ) ); }
highp float rand( const in vec2 uv ) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract( sin( sn ) * c );
}
#ifdef HIGH_PRECISION
	float precisionSafeLength( vec3 v ) { return length( v ); }
#else
	float precisionSafeLength( vec3 v ) {
		float maxComponent = max3( abs( v ) );
		return length( v / maxComponent ) * maxComponent;
	}
#endif
struct IncidentLight {
	vec3 color;
	vec3 direction;
	bool visible;
};
struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};
#ifdef USE_ALPHAHASH
	varying vec3 vPosition;
#endif
vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}
#define inverseTransformDirection transformDirectionByInverseViewMatrix
vec3 transformNormalByInverseViewMatrix( in vec3 normal, in mat4 viewMatrix ) {
	return normalize( ( vec4( normal, 0.0 ) * viewMatrix ).xyz );
}
vec3 transformDirectionByInverseViewMatrix( in vec3 dir, in mat4 viewMatrix ) {
	return normalize( ( vec4( dir, 0.0 ) * viewMatrix ).xyz );
}
bool isPerspectiveMatrix( mat4 m ) {
	return m[ 2 ][ 3 ] == - 1.0;
}
vec2 equirectUv( in vec3 dir ) {
	float u = atan( dir.z, dir.x ) * RECIPROCAL_PI2 + 0.5;
	float v = asin( clamp( dir.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;
	return vec2( u, v );
}
vec3 BRDF_Lambert( const in vec3 diffuseColor ) {
	return RECIPROCAL_PI * diffuseColor;
}
vec3 F_Schlick( const in vec3 f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
}
float F_Schlick( const in float f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
} // validated`,xx=`#ifdef ENVMAP_TYPE_CUBE_UV
	#define cubeUV_minMipLevel 4.0
	#define cubeUV_minTileSize 16.0
	float getFace( vec3 direction ) {
		vec3 absDirection = abs( direction );
		float face = - 1.0;
		if ( absDirection.x > absDirection.z ) {
			if ( absDirection.x > absDirection.y )
				face = direction.x > 0.0 ? 0.0 : 3.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		} else {
			if ( absDirection.z > absDirection.y )
				face = direction.z > 0.0 ? 2.0 : 5.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		}
		return face;
	}
	vec2 getUV( vec3 direction, float face ) {
		vec2 uv;
		if ( face == 0.0 ) {
			uv = vec2( direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 1.0 ) {
			uv = vec2( - direction.x, - direction.z ) / abs( direction.y );
		} else if ( face == 2.0 ) {
			uv = vec2( - direction.x, direction.y ) / abs( direction.z );
		} else if ( face == 3.0 ) {
			uv = vec2( - direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 4.0 ) {
			uv = vec2( - direction.x, direction.z ) / abs( direction.y );
		} else {
			uv = vec2( direction.x, direction.y ) / abs( direction.z );
		}
		return 0.5 * ( uv + 1.0 );
	}
	vec3 bilinearCubeUV( sampler2D envMap, vec3 direction, float mipInt ) {
		float face = getFace( direction );
		float filterInt = max( cubeUV_minMipLevel - mipInt, 0.0 );
		mipInt = max( mipInt, cubeUV_minMipLevel );
		float faceSize = exp2( mipInt );
		highp vec2 uv = getUV( direction, face ) * ( faceSize - 2.0 ) + 1.0;
		if ( face > 2.0 ) {
			uv.y += faceSize;
			face -= 3.0;
		}
		uv.x += face * faceSize;
		uv.x += filterInt * 3.0 * cubeUV_minTileSize;
		uv.y += 4.0 * ( exp2( CUBEUV_MAX_MIP ) - faceSize );
		uv.x *= CUBEUV_TEXEL_WIDTH;
		uv.y *= CUBEUV_TEXEL_HEIGHT;
		#ifdef texture2DGradEXT
			return texture2DGradEXT( envMap, uv, vec2( 0.0 ), vec2( 0.0 ) ).rgb;
		#else
			return texture2D( envMap, uv ).rgb;
		#endif
	}
	#define cubeUV_r0 1.0
	#define cubeUV_m0 - 2.0
	#define cubeUV_r1 0.8
	#define cubeUV_m1 - 1.0
	#define cubeUV_r4 0.4
	#define cubeUV_m4 2.0
	#define cubeUV_r5 0.305
	#define cubeUV_m5 3.0
	#define cubeUV_r6 0.21
	#define cubeUV_m6 4.0
	float roughnessToMip( float roughness ) {
		float mip = 0.0;
		if ( roughness >= cubeUV_r1 ) {
			mip = ( cubeUV_r0 - roughness ) * ( cubeUV_m1 - cubeUV_m0 ) / ( cubeUV_r0 - cubeUV_r1 ) + cubeUV_m0;
		} else if ( roughness >= cubeUV_r4 ) {
			mip = ( cubeUV_r1 - roughness ) * ( cubeUV_m4 - cubeUV_m1 ) / ( cubeUV_r1 - cubeUV_r4 ) + cubeUV_m1;
		} else if ( roughness >= cubeUV_r5 ) {
			mip = ( cubeUV_r4 - roughness ) * ( cubeUV_m5 - cubeUV_m4 ) / ( cubeUV_r4 - cubeUV_r5 ) + cubeUV_m4;
		} else if ( roughness >= cubeUV_r6 ) {
			mip = ( cubeUV_r5 - roughness ) * ( cubeUV_m6 - cubeUV_m5 ) / ( cubeUV_r5 - cubeUV_r6 ) + cubeUV_m5;
		} else {
			mip = - 2.0 * log2( 1.16 * roughness );		}
		return mip;
	}
	vec4 textureCubeUV( sampler2D envMap, vec3 sampleDir, float roughness ) {
		float mip = clamp( roughnessToMip( roughness ), cubeUV_m0, CUBEUV_MAX_MIP );
		float mipF = fract( mip );
		float mipInt = floor( mip );
		vec3 color0 = bilinearCubeUV( envMap, sampleDir, mipInt );
		if ( mipF == 0.0 ) {
			return vec4( color0, 1.0 );
		} else {
			vec3 color1 = bilinearCubeUV( envMap, sampleDir, mipInt + 1.0 );
			return vec4( mix( color0, color1, mipF ), 1.0 );
		}
	}
#endif`,vx=`vec3 transformedNormal = objectNormal;
#ifdef USE_TANGENT
	vec3 transformedTangent = objectTangent;
#endif
#ifdef USE_BATCHING
	mat3 bm = mat3( batchingMatrix );
	transformedNormal /= vec3( dot( bm[ 0 ], bm[ 0 ] ), dot( bm[ 1 ], bm[ 1 ] ), dot( bm[ 2 ], bm[ 2 ] ) );
	transformedNormal = bm * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = bm * transformedTangent;
	#endif
#endif
#ifdef USE_INSTANCING
	mat3 im = mat3( instanceMatrix );
	transformedNormal /= vec3( dot( im[ 0 ], im[ 0 ] ), dot( im[ 1 ], im[ 1 ] ), dot( im[ 2 ], im[ 2 ] ) );
	transformedNormal = im * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = im * transformedTangent;
	#endif
#endif
transformedNormal = normalMatrix * transformedNormal;
#ifdef FLIP_SIDED
	transformedNormal = - transformedNormal;
#endif
#ifdef USE_TANGENT
	transformedTangent = ( modelViewMatrix * vec4( transformedTangent, 0.0 ) ).xyz;
#endif`,yx=`#ifdef USE_DISPLACEMENTMAP
	uniform sampler2D displacementMap;
	uniform float displacementScale;
	uniform float displacementBias;
#endif`,_x=`#ifdef USE_DISPLACEMENTMAP
	transformed += normalize( objectNormal ) * ( texture2D( displacementMap, vDisplacementMapUv ).x * displacementScale + displacementBias );
#endif`,bx=`#ifdef USE_EMISSIVEMAP
	vec4 emissiveColor = texture2D( emissiveMap, vEmissiveMapUv );
	#ifdef DECODE_VIDEO_TEXTURE_EMISSIVE
		emissiveColor = sRGBTransferEOTF( emissiveColor );
	#endif
	totalEmissiveRadiance *= emissiveColor.rgb;
#endif`,Mx=`#ifdef USE_EMISSIVEMAP
	uniform sampler2D emissiveMap;
#endif`,Sx="gl_FragColor = linearToOutputTexel( gl_FragColor );",wx=`vec4 LinearTransferOETF( in vec4 value ) {
	return value;
}
vec4 sRGBTransferEOTF( in vec4 value ) {
	return vec4( mix( pow( value.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), value.rgb * 0.0773993808, vec3( lessThanEqual( value.rgb, vec3( 0.04045 ) ) ) ), value.a );
}
vec4 sRGBTransferOETF( in vec4 value ) {
	return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}`,Tx=`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vec3 cameraToFrag;
		if ( isOrthographic ) {
			cameraToFrag = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToFrag = normalize( vWorldPosition - cameraPosition );
		}
		vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vec3 reflectVec = reflect( cameraToFrag, worldNormal );
		#else
			vec3 reflectVec = refract( cameraToFrag, worldNormal, refractionRatio );
		#endif
	#else
		vec3 reflectVec = vReflect;
	#endif
	#ifdef ENVMAP_TYPE_CUBE
		vec4 envColor = textureCube( envMap, envMapRotation * reflectVec );
		#ifdef ENVMAP_BLENDING_MULTIPLY
			outgoingLight = mix( outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_MIX )
			outgoingLight = mix( outgoingLight, envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_ADD )
			outgoingLight += envColor.xyz * specularStrength * reflectivity;
		#endif
	#endif
#endif`,Ex=`#ifdef USE_ENVMAP
	uniform float envMapIntensity;
	uniform mat3 envMapRotation;
	#ifdef ENVMAP_TYPE_CUBE
		uniform samplerCube envMap;
	#else
		uniform sampler2D envMap;
	#endif
#endif`,Ax=`#ifdef USE_ENVMAP
	uniform float reflectivity;
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		varying vec3 vWorldPosition;
		uniform float refractionRatio;
	#else
		varying vec3 vReflect;
	#endif
#endif`,Rx=`#ifdef USE_ENVMAP
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		
		varying vec3 vWorldPosition;
	#else
		varying vec3 vReflect;
		uniform float refractionRatio;
	#endif
#endif`,Cx=`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vWorldPosition = worldPosition.xyz;
	#else
		vec3 cameraToVertex;
		if ( isOrthographic ) {
			cameraToVertex = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToVertex = normalize( worldPosition.xyz - cameraPosition );
		}
		vec3 worldNormal = transformNormalByInverseViewMatrix( transformedNormal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vReflect = reflect( cameraToVertex, worldNormal );
		#else
			vReflect = refract( cameraToVertex, worldNormal, refractionRatio );
		#endif
	#endif
#endif`,Px=`#ifdef USE_FOG
	vFogDepth = - mvPosition.z;
#endif`,Ix=`#ifdef USE_FOG
	varying float vFogDepth;
#endif`,Lx=`#ifdef USE_FOG
	#ifdef FOG_EXP2
		float fogFactor = 1.0 - exp( - fogDensity * fogDensity * vFogDepth * vFogDepth );
	#else
		float fogFactor = smoothstep( fogNear, fogFar, vFogDepth );
	#endif
	gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );
#endif`,Dx=`#ifdef USE_FOG
	uniform vec3 fogColor;
	varying float vFogDepth;
	#ifdef FOG_EXP2
		uniform float fogDensity;
	#else
		uniform float fogNear;
		uniform float fogFar;
	#endif
#endif`,Nx=`#ifdef USE_GRADIENTMAP
	uniform sampler2D gradientMap;
#endif
vec3 getGradientIrradiance( vec3 normal, vec3 lightDirection ) {
	float dotNL = dot( normal, lightDirection );
	vec2 coord = vec2( dotNL * 0.5 + 0.5, 0.0 );
	#ifdef USE_GRADIENTMAP
		return vec3( texture2D( gradientMap, coord ).r );
	#else
		vec2 fw = fwidth( coord ) * 0.5;
		return mix( vec3( 0.7 ), vec3( 1.0 ), smoothstep( 0.7 - fw.x, 0.7 + fw.x, coord.x ) );
	#endif
}`,Ux=`#ifdef USE_LIGHTMAP
	uniform sampler2D lightMap;
	uniform float lightMapIntensity;
#endif`,Fx=`LambertMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularStrength = specularStrength;`,zx=`varying vec3 vViewPosition;
struct LambertMaterial {
	vec3 diffuseColor;
	float specularStrength;
};
void RE_Direct_Lambert( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Lambert( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Lambert
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Lambert`,Ox=`uniform bool receiveShadow;
uniform vec3 ambientLightColor;
#if defined( USE_LIGHT_PROBES )
	uniform vec3 lightProbe[ 9 ];
#endif
vec3 shGetIrradianceAt( in vec3 normal, in vec3 shCoefficients[ 9 ] ) {
	float x = normal.x, y = normal.y, z = normal.z;
	vec3 result = shCoefficients[ 0 ] * 0.886227;
	result += shCoefficients[ 1 ] * 2.0 * 0.511664 * y;
	result += shCoefficients[ 2 ] * 2.0 * 0.511664 * z;
	result += shCoefficients[ 3 ] * 2.0 * 0.511664 * x;
	result += shCoefficients[ 4 ] * 2.0 * 0.429043 * x * y;
	result += shCoefficients[ 5 ] * 2.0 * 0.429043 * y * z;
	result += shCoefficients[ 6 ] * ( 0.743125 * z * z - 0.247708 );
	result += shCoefficients[ 7 ] * 2.0 * 0.429043 * x * z;
	result += shCoefficients[ 8 ] * 0.429043 * ( x * x - y * y );
	return result;
}
vec3 getLightProbeIrradiance( const in vec3 lightProbe[ 9 ], const in vec3 normal ) {
	vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
	vec3 irradiance = shGetIrradianceAt( worldNormal, lightProbe );
	return irradiance;
}
vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) {
	vec3 irradiance = ambientLightColor;
	return irradiance;
}
float getDistanceAttenuation( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) {
	float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 );
	if ( cutoffDistance > 0.0 ) {
		distanceFalloff *= pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) );
	}
	return distanceFalloff;
}
float getSpotAttenuation( const in float coneCosine, const in float penumbraCosine, const in float angleCosine ) {
	return smoothstep( coneCosine, penumbraCosine, angleCosine );
}
#if NUM_SUN_LIGHTS > 0
	struct SunLight {
		vec3 direction;
		vec3 color;
	};
	uniform SunLight sunLights[ NUM_SUN_LIGHTS ];
	void getSunLightInfo( const in SunLight sunLight, out IncidentLight light ) {
		light.color = sunLight.color;
		light.direction = sunLight.direction;
		light.visible = true;
	}
#endif
#if NUM_DIR_LIGHTS > 0
	struct DirectionalLight {
		vec3 direction;
		vec3 color;
	};
	uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ];
	void getDirectionalLightInfo( const in DirectionalLight directionalLight, out IncidentLight light ) {
		light.color = directionalLight.color;
		light.direction = directionalLight.direction;
		light.visible = true;
	}
#endif
#if NUM_POINT_LIGHTS > 0
	struct PointLight {
		vec3 position;
		vec3 color;
		float distance;
		float decay;
	};
	uniform PointLight pointLights[ NUM_POINT_LIGHTS ];
	void getPointLightInfo( const in PointLight pointLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = pointLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float lightDistance = length( lVector );
		light.color = pointLight.color;
		light.color *= getDistanceAttenuation( lightDistance, pointLight.distance, pointLight.decay );
		light.visible = ( light.color != vec3( 0.0 ) );
	}
#endif
#if NUM_SPOT_LIGHTS > 0
	struct SpotLight {
		vec3 position;
		vec3 direction;
		vec3 color;
		float distance;
		float decay;
		float coneCos;
		float penumbraCos;
	};
	uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ];
	void getSpotLightInfo( const in SpotLight spotLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = spotLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float angleCos = dot( light.direction, spotLight.direction );
		float spotAttenuation = getSpotAttenuation( spotLight.coneCos, spotLight.penumbraCos, angleCos );
		if ( spotAttenuation > 0.0 ) {
			float lightDistance = length( lVector );
			light.color = spotLight.color * spotAttenuation;
			light.color *= getDistanceAttenuation( lightDistance, spotLight.distance, spotLight.decay );
			light.visible = ( light.color != vec3( 0.0 ) );
		} else {
			light.color = vec3( 0.0 );
			light.visible = false;
		}
	}
#endif
#if NUM_RECT_AREA_LIGHTS > 0
	struct RectAreaLight {
		vec3 color;
		vec3 position;
		vec3 halfWidth;
		vec3 halfHeight;
	};
	uniform sampler2D ltc_1;	uniform sampler2D ltc_2;
	uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ];
#endif
#if NUM_HEMI_LIGHTS > 0
	struct HemisphereLight {
		vec3 direction;
		vec3 skyColor;
		vec3 groundColor;
	};
	uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ];
	vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in vec3 normal ) {
		float dotNL = dot( normal, hemiLight.direction );
		float hemiDiffuseWeight = 0.5 * dotNL + 0.5;
		vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight );
		return irradiance;
	}
#endif
#include <lightprobes_pars_fragment>`,kx=`#ifdef USE_ENVMAP
	vec3 getIBLIrradiance( const in vec3 normal ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * worldNormal, 1.0 );
			return PI * envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	vec3 getIBLRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 reflectVec = reflect( - viewDir, normal );
			reflectVec = normalize( mix( reflectVec, normal, pow4( roughness ) ) );
			reflectVec = transformDirectionByInverseViewMatrix( reflectVec, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * reflectVec, roughness );
			return envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	#ifdef USE_RETROREFLECTION
		vec3 getIBLRetroRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness ) {
			#ifdef ENVMAP_TYPE_CUBE_UV
				vec3 retroVec = normalize( mix( viewDir, normal, pow4( roughness ) ) );
				retroVec = transformDirectionByInverseViewMatrix( retroVec, viewMatrix );
				vec4 envMapColor = textureCubeUV( envMap, envMapRotation * retroVec, roughness );
				return envMapColor.rgb * envMapIntensity;
			#else
				return vec3( 0.0 );
			#endif
		}
	#endif
	#ifdef USE_ANISOTROPY
		vec3 getIBLAnisotropyRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness, const in vec3 bitangent, const in float anisotropy ) {
			#ifdef ENVMAP_TYPE_CUBE_UV
				vec3 bentNormal = cross( bitangent, viewDir );
				bentNormal = normalize( cross( bentNormal, bitangent ) );
				bentNormal = normalize( mix( bentNormal, normal, pow2( pow2( 1.0 - anisotropy * ( 1.0 - roughness ) ) ) ) );
				return getIBLRadiance( viewDir, bentNormal, roughness );
			#else
				return vec3( 0.0 );
			#endif
		}
		#ifdef USE_RETROREFLECTION
			vec3 getIBLAnisotropyRetroRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness, const in vec3 bitangent, const in float anisotropy ) {
				#ifdef ENVMAP_TYPE_CUBE_UV
					vec3 bentNormal = cross( bitangent, viewDir );
					bentNormal = normalize( cross( bentNormal, bitangent ) );
					bentNormal = normalize( mix( bentNormal, normal, pow2( pow2( 1.0 - anisotropy * ( 1.0 - roughness ) ) ) ) );
					return getIBLRetroRadiance( viewDir, bentNormal, roughness );
				#else
					return vec3( 0.0 );
				#endif
			}
		#endif
	#endif
#endif`,Bx=`ToonMaterial material;
material.diffuseColor = diffuseColor.rgb;`,Hx=`varying vec3 vViewPosition;
struct ToonMaterial {
	vec3 diffuseColor;
};
void RE_Direct_Toon( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 irradiance = getGradientIrradiance( geometryNormal, directLight.direction ) * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Toon( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Toon
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Toon`,Gx=`BlinnPhongMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularColor = specular;
material.specularShininess = shininess;
material.specularStrength = specularStrength;`,Vx=`varying vec3 vViewPosition;
struct BlinnPhongMaterial {
	vec3 diffuseColor;
	vec3 specularColor;
	float specularShininess;
	float specularStrength;
};
void RE_Direct_BlinnPhong( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
	reflectedLight.directSpecular += irradiance * BRDF_BlinnPhong( directLight.direction, geometryViewDir, geometryNormal, material.specularColor, material.specularShininess ) * material.specularStrength;
}
void RE_IndirectDiffuse_BlinnPhong( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong`,Wx=`PhysicalMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.diffuseContribution = diffuseColor.rgb * ( 1.0 - metalnessFactor );
material.metalness = metalnessFactor;
vec3 dxy = max( abs( dFdx( nonPerturbedNormal ) ), abs( dFdy( nonPerturbedNormal ) ) );
float geometryRoughness = max( max( dxy.x, dxy.y ), dxy.z );
material.roughness = max( roughnessFactor, 0.0525 );material.roughness += geometryRoughness;
material.roughness = min( material.roughness, 1.0 );
#ifdef IOR
	material.ior = ior;
	#ifdef USE_SPECULAR
		float specularIntensityFactor = specularIntensity;
		vec3 specularColorFactor = specularColor;
		#ifdef USE_SPECULAR_COLORMAP
			specularColorFactor *= texture2D( specularColorMap, vSpecularColorMapUv ).rgb;
		#endif
		#ifdef USE_SPECULAR_INTENSITYMAP
			specularIntensityFactor *= texture2D( specularIntensityMap, vSpecularIntensityMapUv ).a;
		#endif
		material.specularF90 = mix( specularIntensityFactor, 1.0, metalnessFactor );
	#else
		float specularIntensityFactor = 1.0;
		vec3 specularColorFactor = vec3( 1.0 );
		material.specularF90 = 1.0;
	#endif
	material.specularColor = min( pow2( ( material.ior - 1.0 ) / ( material.ior + 1.0 ) ) * specularColorFactor, vec3( 1.0 ) ) * specularIntensityFactor;
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
#else
	material.specularColor = vec3( 0.04 );
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
	material.specularF90 = 1.0;
#endif
#ifdef USE_CLEARCOAT
	material.clearcoat = clearcoat;
	material.clearcoatRoughness = clearcoatRoughness;
	material.clearcoatF0 = vec3( 0.04 );
	material.clearcoatF90 = 1.0;
	#ifdef USE_CLEARCOATMAP
		material.clearcoat *= texture2D( clearcoatMap, vClearcoatMapUv ).x;
	#endif
	#ifdef USE_CLEARCOAT_ROUGHNESSMAP
		material.clearcoatRoughness *= texture2D( clearcoatRoughnessMap, vClearcoatRoughnessMapUv ).y;
	#endif
	material.clearcoat = saturate( material.clearcoat );	material.clearcoatRoughness = max( material.clearcoatRoughness, 0.0525 );
	material.clearcoatRoughness += geometryRoughness;
	material.clearcoatRoughness = min( material.clearcoatRoughness, 1.0 );
#endif
#ifdef USE_DISPERSION
	material.dispersion = dispersion;
#endif
#ifdef USE_RETROREFLECTION
	material.retroreflectivity = retroreflectivity;
#endif
#ifdef USE_IRIDESCENCE
	material.iridescence = iridescence;
	material.iridescenceIOR = iridescenceIOR;
	#ifdef USE_IRIDESCENCEMAP
		material.iridescence *= texture2D( iridescenceMap, vIridescenceMapUv ).r;
	#endif
	#ifdef USE_IRIDESCENCE_THICKNESSMAP
		material.iridescenceThickness = (iridescenceThicknessMaximum - iridescenceThicknessMinimum) * texture2D( iridescenceThicknessMap, vIridescenceThicknessMapUv ).g + iridescenceThicknessMinimum;
	#else
		material.iridescenceThickness = iridescenceThicknessMaximum;
	#endif
#endif
#ifdef USE_SHEEN
	material.sheenColor = sheenColor;
	#ifdef USE_SHEEN_COLORMAP
		material.sheenColor *= texture2D( sheenColorMap, vSheenColorMapUv ).rgb;
	#endif
	material.sheenRoughness = clamp( sheenRoughness, 0.0001, 1.0 );
	#ifdef USE_SHEEN_ROUGHNESSMAP
		material.sheenRoughness *= texture2D( sheenRoughnessMap, vSheenRoughnessMapUv ).a;
	#endif
#endif
#ifdef USE_ANISOTROPY
	#ifdef USE_ANISOTROPYMAP
		mat2 anisotropyMat = mat2( anisotropyVector.x, anisotropyVector.y, - anisotropyVector.y, anisotropyVector.x );
		vec3 anisotropyPolar = texture2D( anisotropyMap, vAnisotropyMapUv ).rgb;
		vec2 anisotropyV = anisotropyMat * normalize( 2.0 * anisotropyPolar.rg - vec2( 1.0 ) ) * anisotropyPolar.b;
	#else
		vec2 anisotropyV = anisotropyVector;
	#endif
	material.anisotropy = length( anisotropyV );
	if( material.anisotropy == 0.0 ) {
		anisotropyV = vec2( 1.0, 0.0 );
	} else {
		anisotropyV /= material.anisotropy;
		material.anisotropy = saturate( material.anisotropy );
	}
	material.alphaT = mix( pow2( material.roughness ), 1.0, pow2( material.anisotropy ) );
	material.anisotropyT = tbn[ 0 ] * anisotropyV.x + tbn[ 1 ] * anisotropyV.y;
	material.anisotropyB = tbn[ 1 ] * anisotropyV.x - tbn[ 0 ] * anisotropyV.y;
#endif`,Xx=`uniform sampler2D dfgLUT;
struct PhysicalMaterial {
	vec3 diffuseColor;
	vec3 diffuseContribution;
	vec3 specularColor;
	vec3 specularColorBlended;
	float roughness;
	float metalness;
	float specularF90;
	float dispersion;
	vec2 dfg;
	vec3 multiScatteringCompensation;
	#ifdef USE_RETROREFLECTION
		float retroreflectivity;
	#endif
	#ifdef USE_CLEARCOAT
		float clearcoat;
		float clearcoatRoughness;
		vec3 clearcoatF0;
		float clearcoatF90;
	#endif
	#ifdef USE_IRIDESCENCE
		float iridescence;
		float iridescenceIOR;
		float iridescenceThickness;
		vec3 iridescenceFresnel;
		vec3 iridescenceF0Dielectric;
		vec3 iridescenceF0Metallic;
	#endif
	#ifdef USE_SHEEN
		vec3 sheenColor;
		float sheenRoughness;
	#endif
	#ifdef IOR
		float ior;
	#endif
	#ifdef USE_TRANSMISSION
		float transmission;
		float transmissionAlpha;
		float thickness;
		float attenuationDistance;
		vec3 attenuationColor;
	#endif
	#ifdef USE_ANISOTROPY
		float anisotropy;
		float alphaT;
		vec3 anisotropyT;
		vec3 anisotropyB;
	#endif
};
vec3 clearcoatSpecularDirect = vec3( 0.0 );
vec3 clearcoatSpecularIndirect = vec3( 0.0 );
vec3 sheenSpecularDirect = vec3( 0.0 );
vec3 sheenSpecularIndirect = vec3(0.0 );
vec3 Schlick_to_F0( const in vec3 f, const in float f90, const in float dotVH ) {
    float x = clamp( 1.0 - dotVH, 0.0, 1.0 );
    float x2 = x * x;
    float x5 = clamp( x * x2 * x2, 0.0, 0.9999 );
    return ( f - vec3( f90 ) * x5 ) / ( 1.0 - x5 );
}
float V_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) {
	float a2 = pow2( alpha );
	float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );
	float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );
	return 0.5 / max( gv + gl, EPSILON );
}
float D_GGX( const in float alpha, const in float dotNH ) {
	float a2 = pow2( alpha );
	float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0;
	return RECIPROCAL_PI * a2 / pow2( denom );
}
#ifdef USE_ANISOTROPY
	float V_GGX_SmithCorrelated_Anisotropic( const in float alphaT, const in float alphaB, const in float dotTV, const in float dotBV, const in float dotTL, const in float dotBL, const in float dotNV, const in float dotNL ) {
		float gv = dotNL * length( vec3( alphaT * dotTV, alphaB * dotBV, dotNV ) );
		float gl = dotNV * length( vec3( alphaT * dotTL, alphaB * dotBL, dotNL ) );
		return 0.5 / max( gv + gl, EPSILON );
	}
	float D_GGX_Anisotropic( const in float alphaT, const in float alphaB, const in float dotNH, const in float dotTH, const in float dotBH ) {
		float a2 = alphaT * alphaB;
		highp vec3 v = vec3( alphaB * dotTH, alphaT * dotBH, a2 * dotNH );
		highp float v2 = dot( v, v );
		float w2 = a2 / v2;
		return RECIPROCAL_PI * a2 * pow2 ( w2 );
	}
#endif
#ifdef USE_CLEARCOAT
	vec3 BRDF_GGX_Clearcoat( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material) {
		vec3 f0 = material.clearcoatF0;
		float f90 = material.clearcoatF90;
		float roughness = material.clearcoatRoughness;
		float alpha = pow2( roughness );
		vec3 halfDir = normalize( lightDir + viewDir );
		float dotNL = saturate( dot( normal, lightDir ) );
		float dotNV = saturate( dot( normal, viewDir ) );
		float dotNH = saturate( dot( normal, halfDir ) );
		float dotVH = saturate( dot( viewDir, halfDir ) );
		vec3 F = F_Schlick( f0, f90, dotVH );
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
		return F * ( V * D );
	}
#endif
vec3 BRDF_GGX( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material ) {
	vec3 f0 = material.specularColorBlended;
	float f90 = material.specularF90;
	float roughness = material.roughness;
	float alpha = pow2( roughness );
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( f0, f90, dotVH );
	#ifdef USE_IRIDESCENCE
		F = mix( F, material.iridescenceFresnel, material.iridescence );
	#endif
	#ifdef USE_ANISOTROPY
		float dotTL = dot( material.anisotropyT, lightDir );
		float dotTV = dot( material.anisotropyT, viewDir );
		float dotTH = dot( material.anisotropyT, halfDir );
		float dotBL = dot( material.anisotropyB, lightDir );
		float dotBV = dot( material.anisotropyB, viewDir );
		float dotBH = dot( material.anisotropyB, halfDir );
		float V = V_GGX_SmithCorrelated_Anisotropic( material.alphaT, alpha, dotTV, dotBV, dotTL, dotBL, dotNV, dotNL );
		float D = D_GGX_Anisotropic( material.alphaT, alpha, dotNH, dotTH, dotBH );
	#else
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
	#endif
	return F * ( V * D );
}
vec2 LTC_Uv( const in vec3 N, const in vec3 V, const in float roughness ) {
	const float LUT_SIZE = 64.0;
	const float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	const float LUT_BIAS = 0.5 / LUT_SIZE;
	float dotNV = saturate( dot( N, V ) );
	vec2 uv = vec2( roughness, sqrt( 1.0 - dotNV ) );
	uv = uv * LUT_SCALE + LUT_BIAS;
	return uv;
}
float LTC_ClippedSphereFormFactor( const in vec3 f ) {
	float l = length( f );
	return max( ( l * l + f.z ) / ( l + 1.0 ), 0.0 );
}
vec3 LTC_EdgeVectorFormFactor( const in vec3 v1, const in vec3 v2 ) {
	float x = dot( v1, v2 );
	float y = abs( x );
	float a = 0.8543985 + ( 0.4965155 + 0.0145206 * y ) * y;
	float b = 3.4175940 + ( 4.1616724 + y ) * y;
	float v = a / b;
	float theta_sintheta = ( x > 0.0 ) ? v : 0.5 * inversesqrt( max( 1.0 - x * x, 1e-7 ) ) - v;
	return cross( v1, v2 ) * theta_sintheta;
}
vec3 LTC_Evaluate( const in vec3 N, const in vec3 V, const in vec3 P, const in mat3 mInv, const in vec3 rectCoords[ 4 ] ) {
	vec3 v1 = rectCoords[ 1 ] - rectCoords[ 0 ];
	vec3 v2 = rectCoords[ 3 ] - rectCoords[ 0 ];
	vec3 lightNormal = cross( v1, v2 );
	if( dot( lightNormal, P - rectCoords[ 0 ] ) < 0.0 ) return vec3( 0.0 );
	vec3 T1, T2;
	T1 = normalize( V - N * dot( V, N ) );
	T2 = - cross( N, T1 );
	mat3 mat = mInv * transpose( mat3( T1, T2, N ) );
	vec3 coords[ 4 ];
	coords[ 0 ] = mat * ( rectCoords[ 0 ] - P );
	coords[ 1 ] = mat * ( rectCoords[ 1 ] - P );
	coords[ 2 ] = mat * ( rectCoords[ 2 ] - P );
	coords[ 3 ] = mat * ( rectCoords[ 3 ] - P );
	coords[ 0 ] = normalize( coords[ 0 ] );
	coords[ 1 ] = normalize( coords[ 1 ] );
	coords[ 2 ] = normalize( coords[ 2 ] );
	coords[ 3 ] = normalize( coords[ 3 ] );
	vec3 vectorFormFactor = vec3( 0.0 );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 0 ], coords[ 1 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 1 ], coords[ 2 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 2 ], coords[ 3 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 3 ], coords[ 0 ] );
	float result = LTC_ClippedSphereFormFactor( vectorFormFactor );
	return vec3( result );
}
#if defined( USE_SHEEN )
float D_Charlie( float roughness, float dotNH ) {
	float alpha = pow2( roughness );
	float invAlpha = 1.0 / alpha;
	float cos2h = dotNH * dotNH;
	float sin2h = max( 1.0 - cos2h, 0.0078125 );
	return ( 2.0 + invAlpha ) * pow( sin2h, invAlpha * 0.5 ) / ( 2.0 * PI );
}
float V_Neubelt( float dotNV, float dotNL ) {
	return saturate( 1.0 / ( 4.0 * ( dotNL + dotNV - dotNL * dotNV ) ) );
}
vec3 BRDF_Sheen( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, vec3 sheenColor, const in float sheenRoughness ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float D = D_Charlie( sheenRoughness, dotNH );
	float V = V_Neubelt( dotNV, dotNL );
	return sheenColor * ( D * V );
}
#endif
float IBLSheenBRDF( const in vec3 normal, const in vec3 viewDir, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	float r2 = roughness * roughness;
	float rInv = 1.0 / ( roughness + 0.1 );
	float a = -1.9362 + 1.0678 * roughness + 0.4573 * r2 - 0.8469 * rInv;
	float b = -0.6014 + 0.5538 * roughness - 0.4670 * r2 - 0.1255 * rInv;
	float DG = exp( a * dotNV + b );
	return saturate( DG );
}
vec3 EnvironmentBRDF( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 fab = texture2D( dfgLUT, vec2( roughness, dotNV ) ).rg;
	return specularColor * fab.x + specularF90 * fab.y;
}
#ifdef USE_IRIDESCENCE
void computeMultiscatteringIridescence( const in vec2 fab, const in vec3 specularColor, const in float specularF90, const in float iridescence, const in vec3 iridescenceF0, inout vec3 singleScatter, inout vec3 multiScatter ) {
#else
void computeMultiscattering( const in vec2 fab, const in vec3 specularColor, const in float specularF90, inout vec3 singleScatter, inout vec3 multiScatter ) {
#endif
	#ifdef USE_IRIDESCENCE
		vec3 Fr = mix( specularColor, iridescenceF0, iridescence );
	#else
		vec3 Fr = specularColor;
	#endif
	vec3 FssEss = Fr * fab.x + specularF90 * fab.y;
	float Ess = fab.x + fab.y;
	float Ems = 1.0 - Ess;
	vec3 Favg = Fr + ( 1.0 - Fr ) * 0.047619;	vec3 Fms = FssEss * Favg / ( 1.0 - Ems * Favg );
	singleScatter += FssEss;
	multiScatter += Fms * Ems;
}
#if NUM_RECT_AREA_LIGHTS > 0
	void RE_Direct_RectArea_Physical( const in RectAreaLight rectAreaLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
		vec3 normal = geometryNormal;
		vec3 viewDir = geometryViewDir;
		vec3 position = geometryPosition;
		vec3 lightPos = rectAreaLight.position;
		vec3 halfWidth = rectAreaLight.halfWidth;
		vec3 halfHeight = rectAreaLight.halfHeight;
		vec3 lightColor = rectAreaLight.color;
		float roughness = material.roughness;
		vec3 rectCoords[ 4 ];
		rectCoords[ 0 ] = lightPos + halfWidth - halfHeight;		rectCoords[ 1 ] = lightPos - halfWidth - halfHeight;
		rectCoords[ 2 ] = lightPos - halfWidth + halfHeight;
		rectCoords[ 3 ] = lightPos + halfWidth + halfHeight;
		vec2 uv = LTC_Uv( normal, viewDir, roughness );
		vec4 t1 = texture2D( ltc_1, uv );
		vec4 t2 = texture2D( ltc_2, uv );
		mat3 mInv = mat3(
			vec3( t1.x, 0, t1.y ),
			vec3(    0, 1,    0 ),
			vec3( t1.z, 0, t1.w )
		);
		vec3 fresnel = ( material.specularColorBlended * t2.x + ( material.specularF90 - material.specularColorBlended ) * t2.y );
		reflectedLight.directSpecular += lightColor * fresnel * LTC_Evaluate( normal, viewDir, position, mInv, rectCoords );
		reflectedLight.directDiffuse += lightColor * material.diffuseContribution * LTC_Evaluate( normal, viewDir, position, mat3( 1.0 ), rectCoords );
		#ifdef USE_CLEARCOAT
			vec3 Ncc = geometryClearcoatNormal;
			vec2 uvClearcoat = LTC_Uv( Ncc, viewDir, material.clearcoatRoughness );
			vec4 t1Clearcoat = texture2D( ltc_1, uvClearcoat );
			vec4 t2Clearcoat = texture2D( ltc_2, uvClearcoat );
			mat3 mInvClearcoat = mat3(
				vec3( t1Clearcoat.x, 0, t1Clearcoat.y ),
				vec3(             0, 1,             0 ),
				vec3( t1Clearcoat.z, 0, t1Clearcoat.w )
			);
			vec3 fresnelClearcoat = material.clearcoatF0 * t2Clearcoat.x + ( material.clearcoatF90 - material.clearcoatF0 ) * t2Clearcoat.y;
			clearcoatSpecularDirect += lightColor * fresnelClearcoat * LTC_Evaluate( Ncc, viewDir, position, mInvClearcoat, rectCoords );
		#endif
	}
#endif
void RE_Direct_Physical( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	#ifdef USE_CLEARCOAT
		float dotNLcc = saturate( dot( geometryClearcoatNormal, directLight.direction ) );
		vec3 ccIrradiance = dotNLcc * directLight.color;
		clearcoatSpecularDirect += ccIrradiance * BRDF_GGX_Clearcoat( directLight.direction, geometryViewDir, geometryClearcoatNormal, material );
	#endif
	#ifdef USE_SHEEN
 
 		sheenSpecularDirect += irradiance * BRDF_Sheen( directLight.direction, geometryViewDir, geometryNormal, material.sheenColor, material.sheenRoughness );
 
 		float sheenAlbedoV = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
 		float sheenAlbedoL = IBLSheenBRDF( geometryNormal, directLight.direction, material.sheenRoughness );
 
 		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * max( sheenAlbedoV, sheenAlbedoL );
 
 		irradiance *= sheenEnergyComp;
 
 	#endif
	vec3 specularBRDF = BRDF_GGX( directLight.direction, geometryViewDir, geometryNormal, material );
	#ifdef USE_RETROREFLECTION
		vec3 retroViewDir = reflect( - geometryViewDir, geometryNormal );
		vec3 retroSpecularBRDF = BRDF_GGX( directLight.direction, retroViewDir, geometryNormal, material );
		specularBRDF = mix( specularBRDF, retroSpecularBRDF, saturate( material.retroreflectivity ) );
	#endif
	reflectedLight.directSpecular += irradiance * specularBRDF * material.multiScatteringCompensation;
	vec3 halfDir = normalize( directLight.direction + geometryViewDir );
	float dotVH = saturate( dot( geometryViewDir, halfDir ) );
	vec3 F = F_Schlick( material.specularColor, material.specularF90, dotVH );
	#ifdef USE_RETROREFLECTION
		vec3 retroHalfDir = normalize( directLight.direction + retroViewDir );
		float dotRetroVH = saturate( dot( retroViewDir, retroHalfDir ) );
		vec3 retroF = F_Schlick( material.specularColor, material.specularF90, dotRetroVH );
		F = mix( F, retroF, saturate( material.retroreflectivity ) );
	#endif
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseContribution ) * ( 1.0 - F );
}
void RE_IndirectDiffuse_Physical( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 singleScattering = vec3( 0.0 );
	vec3 multiScattering = vec3( 0.0 );
	#ifdef USE_IRIDESCENCE
		computeMultiscatteringIridescence( material.dfg, material.specularColor, material.specularF90, material.iridescence, material.iridescenceF0Dielectric, singleScattering, multiScattering );
	#else
		computeMultiscattering( material.dfg, material.specularColor, material.specularF90, singleScattering, multiScattering );
	#endif
	vec3 diffuse = irradiance * BRDF_Lambert( material.diffuseContribution ) * ( 1.0 - singleScattering - multiScattering );
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		sheenSpecularIndirect += irradiance * material.sheenColor * sheenAlbedo * RECIPROCAL_PI;
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		diffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectDiffuse += diffuse;
}
void RE_IndirectSpecular_Physical( const in vec3 radiance, const in vec3 irradiance, const in vec3 clearcoatRadiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight) {
	#ifdef USE_CLEARCOAT
		clearcoatSpecularIndirect += clearcoatRadiance * EnvironmentBRDF( geometryClearcoatNormal, geometryViewDir, material.clearcoatF0, material.clearcoatF90, material.clearcoatRoughness );
	#endif
	#ifdef USE_SHEEN
		sheenSpecularIndirect += irradiance * material.sheenColor * IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness ) * RECIPROCAL_PI;
 	#endif
	vec3 singleScatteringDielectric = vec3( 0.0 );
	vec3 multiScatteringDielectric = vec3( 0.0 );
	vec3 singleScatteringMetallic = vec3( 0.0 );
	vec3 multiScatteringMetallic = vec3( 0.0 );
	#ifdef USE_IRIDESCENCE
		computeMultiscatteringIridescence( material.dfg, material.specularColor, material.specularF90, material.iridescence, material.iridescenceF0Dielectric, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscatteringIridescence( material.dfg, material.diffuseColor, material.specularF90, material.iridescence, material.iridescenceF0Metallic, singleScatteringMetallic, multiScatteringMetallic );
	#else
		computeMultiscattering( material.dfg, material.specularColor, material.specularF90, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscattering( material.dfg, material.diffuseColor, material.specularF90, singleScatteringMetallic, multiScatteringMetallic );
	#endif
	vec3 singleScattering = mix( singleScatteringDielectric, singleScatteringMetallic, material.metalness );
	vec3 multiScattering = mix( multiScatteringDielectric, multiScatteringMetallic, material.metalness );
	vec3 totalScatteringDielectric = singleScatteringDielectric + multiScatteringDielectric;
	vec3 diffuse = material.diffuseContribution * ( 1.0 - totalScatteringDielectric );
	vec3 cosineWeightedIrradiance = irradiance * RECIPROCAL_PI;
	vec3 indirectSpecular = radiance * singleScattering;
	indirectSpecular += multiScattering * cosineWeightedIrradiance;
	vec3 indirectDiffuse = diffuse * cosineWeightedIrradiance;
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		indirectSpecular *= sheenEnergyComp;
		indirectDiffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectSpecular += indirectSpecular;
	reflectedLight.indirectDiffuse += indirectDiffuse;
}
#define RE_Direct				RE_Direct_Physical
#define RE_Direct_RectArea		RE_Direct_RectArea_Physical
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Physical
#define RE_IndirectSpecular		RE_IndirectSpecular_Physical
float computeSpecularOcclusion( const in float dotNV, const in float ambientOcclusion, const in float roughness ) {
	return saturate( pow( dotNV + ambientOcclusion, exp2( - 16.0 * roughness - 1.0 ) ) - 1.0 + ambientOcclusion );
}`,qx=`
vec3 geometryPosition = - vViewPosition;
vec3 geometryNormal = normal;
vec3 geometryViewDir = ( isOrthographic ) ? vec3( 0, 0, 1 ) : normalize( vViewPosition );
vec3 geometryClearcoatNormal = vec3( 0.0 );
#ifdef USE_CLEARCOAT
	geometryClearcoatNormal = clearcoatNormal;
#endif
#ifdef USE_IRIDESCENCE
	float dotNVi = saturate( dot( normal, geometryViewDir ) );
	if ( material.iridescenceThickness == 0.0 ) {
		material.iridescence = 0.0;
	} else {
		material.iridescence = saturate( material.iridescence );
	}
	if ( material.iridescence > 0.0 ) {
		vec3 iridescenceFresnelDielectric = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.specularColor );
		vec3 iridescenceFresnelMetallic = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.diffuseColor );
		material.iridescenceFresnel = mix( iridescenceFresnelDielectric, iridescenceFresnelMetallic, material.metalness );
		material.iridescenceF0Dielectric = Schlick_to_F0( iridescenceFresnelDielectric, 1.0, dotNVi );
		material.iridescenceF0Metallic = Schlick_to_F0( iridescenceFresnelMetallic, 1.0, dotNVi );
	}
#endif
#ifdef STANDARD
	float dotNVms = saturate( dot( geometryNormal, geometryViewDir ) );
	material.dfg = texture2D( dfgLUT, vec2( material.roughness, dotNVms ) ).rg;
	#if ( NUM_SUN_LIGHTS > 0 || NUM_DIR_LIGHTS > 0 || NUM_POINT_LIGHTS > 0 || NUM_SPOT_LIGHTS > 0 )
		float EssMs = material.dfg.x + material.dfg.y;
		material.multiScatteringCompensation = 1.0 + material.specularColorBlended * ( 1.0 / EssMs - 1.0 );
	#endif
#endif
IncidentLight directLight;
#if ( NUM_POINT_LIGHTS > 0 ) && defined( RE_Direct )
	PointLight pointLight;
	#if defined( USE_SHADOWMAP ) && NUM_POINT_LIGHT_SHADOWS > 0
	PointLightShadow pointLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {
		pointLight = pointLights[ i ];
		getPointLightInfo( pointLight, geometryPosition, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_POINT_LIGHT_SHADOWS ) && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
		pointLightShadow = pointLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getPointShadow( pointShadowMap[ i ], pointLightShadow.shadowMapSize, pointLightShadow.shadowIntensity, pointLightShadow.shadowBias, pointLightShadow.shadowRadius, vPointShadowCoord[ i ], pointLightShadow.shadowCameraNear, pointLightShadow.shadowCameraFar ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_SPOT_LIGHTS > 0 ) && defined( RE_Direct )
	SpotLight spotLight;
	vec4 spotColor;
	vec3 spotLightCoord;
	bool inSpotLightMap;
	#if defined( USE_SHADOWMAP ) && NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {
		spotLight = spotLights[ i ];
		getSpotLightInfo( spotLight, geometryPosition, directLight );
		#if ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#define SPOT_LIGHT_MAP_INDEX UNROLLED_LOOP_INDEX
		#elif ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		#define SPOT_LIGHT_MAP_INDEX NUM_SPOT_LIGHT_MAPS
		#else
		#define SPOT_LIGHT_MAP_INDEX ( UNROLLED_LOOP_INDEX - NUM_SPOT_LIGHT_SHADOWS + NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#endif
		#if ( SPOT_LIGHT_MAP_INDEX < NUM_SPOT_LIGHT_MAPS )
			spotLightCoord = vSpotLightCoord[ i ].xyz / vSpotLightCoord[ i ].w;
			inSpotLightMap = all( lessThan( abs( spotLightCoord * 2. - 1. ), vec3( 1.0 ) ) );
			spotColor = texture2D( spotLightMap[ SPOT_LIGHT_MAP_INDEX ], spotLightCoord.xy );
			directLight.color = inSpotLightMap ? directLight.color * spotColor.rgb : directLight.color;
		#endif
		#undef SPOT_LIGHT_MAP_INDEX
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		spotLightShadow = spotLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( spotShadowMap[ i ], spotLightShadow.shadowMapSize, spotLightShadow.shadowIntensity, spotLightShadow.shadowBias, spotLightShadow.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_SUN_LIGHTS > 0 ) && defined( RE_Direct )
	SunLight sunLight;
	#if defined( USE_SHADOWMAP ) && NUM_SUN_LIGHT_SHADOWS > 0
	SunLightShadow sunLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SUN_LIGHTS; i ++ ) {
		sunLight = sunLights[ i ];
		getSunLightInfo( sunLight, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_SUN_LIGHT_SHADOWS )
		sunLightShadow = sunLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getSunShadow( sunShadowMap[ i ], sunLightShadow, UNROLLED_LOOP_INDEX ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_DIR_LIGHTS > 0 ) && defined( RE_Direct )
	DirectionalLight directionalLight;
	#if defined( USE_SHADOWMAP ) && NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {
		directionalLight = directionalLights[ i ];
		getDirectionalLightInfo( directionalLight, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_DIR_LIGHT_SHADOWS )
		directionalLightShadow = directionalLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( directionalShadowMap[ i ], directionalLightShadow.shadowMapSize, directionalLightShadow.shadowIntensity, directionalLightShadow.shadowBias, directionalLightShadow.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_RECT_AREA_LIGHTS > 0 ) && defined( RE_Direct_RectArea )
	RectAreaLight rectAreaLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {
		rectAreaLight = rectAreaLights[ i ];
		RE_Direct_RectArea( rectAreaLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if defined( RE_IndirectDiffuse )
	vec3 iblIrradiance = vec3( 0.0 );
	vec3 irradiance = getAmbientLightIrradiance( ambientLightColor );
	#if defined( USE_LIGHT_PROBES )
		irradiance += getLightProbeIrradiance( lightProbe, geometryNormal );
	#endif
	#if ( NUM_HEMI_LIGHTS > 0 )
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {
			irradiance += getHemisphereLightIrradiance( hemisphereLights[ i ], geometryNormal );
		}
		#pragma unroll_loop_end
	#endif
	#ifdef USE_LIGHT_PROBES_GRID
		vec3 probeWorldPos = ( ( vec4( geometryPosition, 1.0 ) - viewMatrix[ 3 ] ) * viewMatrix ).xyz;
		vec3 probeWorldNormal = transformNormalByInverseViewMatrix( geometryNormal, viewMatrix );
		irradiance += getLightProbeGridIrradiance( probeWorldPos, probeWorldNormal );
	#endif
#endif
#if defined( RE_IndirectSpecular )
	vec3 radiance = vec3( 0.0 );
	vec3 clearcoatRadiance = vec3( 0.0 );
#endif`,$x=`#if defined( RE_IndirectDiffuse )
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		vec3 lightMapIrradiance = lightMapTexel.rgb * lightMapIntensity;
		irradiance += lightMapIrradiance;
	#endif
	#if defined( USE_ENVMAP ) && defined( ENVMAP_TYPE_CUBE_UV )
		#if defined( STANDARD ) || defined( LAMBERT ) || defined( PHONG )
			iblIrradiance += getIBLIrradiance( geometryNormal );
		#endif
	#endif
#endif
#if defined( USE_ENVMAP ) && defined( RE_IndirectSpecular )
	#ifdef USE_ANISOTROPY
		vec3 iblRadiance = getIBLAnisotropyRadiance( geometryViewDir, geometryNormal, material.roughness, material.anisotropyB, material.anisotropy );
	#else
		vec3 iblRadiance = getIBLRadiance( geometryViewDir, geometryNormal, material.roughness );
	#endif
	#ifdef USE_RETROREFLECTION
		#ifdef USE_ANISOTROPY
			vec3 retroIBLRadiance = getIBLAnisotropyRetroRadiance( geometryViewDir, geometryNormal, material.roughness, material.anisotropyB, material.anisotropy );
		#else
			vec3 retroIBLRadiance = getIBLRetroRadiance( geometryViewDir, geometryNormal, material.roughness );
		#endif
		iblRadiance = mix( iblRadiance, retroIBLRadiance, saturate( material.retroreflectivity ) );
	#endif
	radiance += iblRadiance;
	#ifdef USE_CLEARCOAT
		clearcoatRadiance += getIBLRadiance( geometryViewDir, geometryClearcoatNormal, material.clearcoatRoughness );
	#endif
#endif`,Yx=`#if defined( RE_IndirectDiffuse )
	#if defined( LAMBERT ) || defined( PHONG )
		irradiance += iblIrradiance;
	#endif
	RE_IndirectDiffuse( irradiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif
#if defined( RE_IndirectSpecular )
	RE_IndirectSpecular( radiance, iblIrradiance, clearcoatRadiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif`,Zx=`#ifdef USE_LIGHT_PROBES_GRID
uniform highp sampler3D probesSH;
uniform vec3 probesMin;
uniform vec3 probesMax;
uniform vec3 probesResolution;
vec3 getLightProbeGridIrradiance( vec3 worldPos, vec3 worldNormal ) {
	vec3 res = probesResolution;
	vec3 gridRange = probesMax - probesMin;
	vec3 resMinusOne = res - 1.0;
	vec3 probeSpacing = gridRange / resMinusOne;
	vec3 samplePos = worldPos + worldNormal * probeSpacing * 0.5;
	vec3 uvw = clamp( ( samplePos - probesMin ) / gridRange, 0.0, 1.0 );
	uvw = uvw * resMinusOne / res + 0.5 / res;
	float nz          = res.z;
	float paddedSlices = nz + 2.0;
	float atlasDepth  = 7.0 * paddedSlices;
	float uvZBase     = uvw.z * nz + 1.0;
	vec4 s0 = texture( probesSH, vec3( uvw.xy, ( uvZBase                       ) / atlasDepth ) );
	vec4 s1 = texture( probesSH, vec3( uvw.xy, ( uvZBase +       paddedSlices   ) / atlasDepth ) );
	vec4 s2 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 2.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s3 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 3.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s4 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 4.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s5 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 5.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s6 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 6.0 * paddedSlices   ) / atlasDepth ) );
	vec3 c0 = s0.xyz;
	vec3 c1 = vec3( s0.w, s1.xy );
	vec3 c2 = vec3( s1.zw, s2.x );
	vec3 c3 = s2.yzw;
	vec3 c4 = s3.xyz;
	vec3 c5 = vec3( s3.w, s4.xy );
	vec3 c6 = vec3( s4.zw, s5.x );
	vec3 c7 = s5.yzw;
	vec3 c8 = s6.xyz;
	float x = worldNormal.x, y = worldNormal.y, z = worldNormal.z;
	vec3 result = c0 * 0.886227;
	result += c1 * 2.0 * 0.511664 * y;
	result += c2 * 2.0 * 0.511664 * z;
	result += c3 * 2.0 * 0.511664 * x;
	result += c4 * 2.0 * 0.429043 * x * y;
	result += c5 * 2.0 * 0.429043 * y * z;
	result += c6 * ( 0.743125 * z * z - 0.247708 );
	result += c7 * 2.0 * 0.429043 * x * z;
	result += c8 * 0.429043 * ( x * x - y * y );
	return max( result, vec3( 0.0 ) );
}
#endif`,Jx=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	gl_FragDepth = vIsPerspective == 0.0 ? gl_FragCoord.z : log2( vFragDepth ) * logDepthBufFC * 0.5;
#endif`,Kx=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	uniform float logDepthBufFC;
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,jx=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,Qx=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	vFragDepth = 1.0 + gl_Position.w;
	vIsPerspective = float( isPerspectiveMatrix( projectionMatrix ) );
#endif`,t1=`#ifdef USE_MAP
	vec4 sampledDiffuseColor = texture2D( map, vMapUv );
	#ifdef DECODE_VIDEO_TEXTURE
		sampledDiffuseColor = sRGBTransferEOTF( sampledDiffuseColor );
	#endif
	diffuseColor *= sampledDiffuseColor;
#endif`,e1=`#ifdef USE_MAP
	uniform sampler2D map;
#endif`,i1=`#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
	#if defined( USE_POINTS_UV )
		vec2 uv = vUv;
	#else
		vec2 uv = ( uvTransform * vec3( gl_PointCoord.x, 1.0 - gl_PointCoord.y, 1 ) ).xy;
	#endif
#endif
#ifdef USE_MAP
	diffuseColor *= texture2D( map, uv );
#endif
#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, uv ).g;
#endif`,n1=`#if defined( USE_POINTS_UV )
	varying vec2 vUv;
#else
	#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
		uniform mat3 uvTransform;
	#endif
#endif
#ifdef USE_MAP
	uniform sampler2D map;
#endif
#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,s1=`float metalnessFactor = metalness;
#ifdef USE_METALNESSMAP
	vec4 texelMetalness = texture2D( metalnessMap, vMetalnessMapUv );
	metalnessFactor *= texelMetalness.b;
#endif`,r1=`#ifdef USE_METALNESSMAP
	uniform sampler2D metalnessMap;
#endif`,a1=`#ifdef USE_INSTANCING_MORPH
	float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	float morphTargetBaseInfluence = texelFetch( morphTexture, ivec2( 0, gl_InstanceID ), 0 ).r;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		morphTargetInfluences[i] =  texelFetch( morphTexture, ivec2( i + 1, gl_InstanceID ), 0 ).r;
	}
#endif`,o1=`#if defined( USE_MORPHCOLORS )
	vColor *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		#if defined( USE_COLOR_ALPHA )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ) * morphTargetInfluences[ i ];
		#elif defined( USE_COLOR )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ).rgb * morphTargetInfluences[ i ];
		#endif
	}
#endif`,l1=`#ifdef USE_MORPHNORMALS
	objectNormal *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) objectNormal += getMorph( gl_VertexID, i, 1 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,c1=`#ifdef USE_MORPHTARGETS
	#ifndef USE_INSTANCING_MORPH
		uniform float morphTargetBaseInfluence;
		uniform float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	#endif
	uniform sampler2DArray morphTargetsTexture;
	uniform ivec2 morphTargetsTextureSize;
	vec4 getMorph( const in int vertexIndex, const in int morphTargetIndex, const in int offset ) {
		int texelIndex = vertexIndex * MORPHTARGETS_TEXTURE_STRIDE + offset;
		int y = texelIndex / morphTargetsTextureSize.x;
		int x = texelIndex - y * morphTargetsTextureSize.x;
		ivec3 morphUV = ivec3( x, y, morphTargetIndex );
		return texelFetch( morphTargetsTexture, morphUV, 0 );
	}
#endif`,h1=`#ifdef USE_MORPHTARGETS
	transformed *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) transformed += getMorph( gl_VertexID, i, 0 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,u1=`float faceDirection = gl_FrontFacing ? 1.0 : - 1.0;
#ifdef FLAT_SHADED
	vec3 fdx = dFdx( vViewPosition );
	vec3 fdy = dFdy( vViewPosition );
	vec3 normal = normalize( cross( fdx, fdy ) );
#else
	vec3 normal = normalize( vNormal );
	#ifdef DOUBLE_SIDED
		normal *= faceDirection;
	#endif
#endif
#if defined( USE_NORMALMAP_TANGENTSPACE ) || defined( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY )
	#ifdef USE_TANGENT
		mat3 tbn = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn = getTangentFrame( - vViewPosition, normal,
		#if defined( USE_NORMALMAP )
			vNormalMapUv
		#elif defined( USE_CLEARCOAT_NORMALMAP )
			vClearcoatNormalMapUv
		#else
			vUv
		#endif
		);
	#endif
	#ifdef DOUBLE_SIDED
		tbn[0] *= faceDirection;
		tbn[1] *= faceDirection;
	#endif
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	#ifdef USE_TANGENT
		mat3 tbn2 = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn2 = getTangentFrame( - vViewPosition, normal, vClearcoatNormalMapUv );
	#endif
	#ifdef DOUBLE_SIDED
		tbn2[0] *= faceDirection;
		tbn2[1] *= faceDirection;
	#endif
#endif
vec3 nonPerturbedNormal = normal;`,d1=`#ifdef USE_NORMALMAP_OBJECTSPACE
	normal = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#ifdef FLIP_SIDED
		normal = - normal;
	#endif
	#ifdef DOUBLE_SIDED
		normal = normal * faceDirection;
	#endif
	normal = normalize( normalMatrix * normal );
#elif defined( USE_NORMALMAP_TANGENTSPACE )
	vec3 mapN = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#if defined( USE_PACKED_NORMALMAP )
		mapN = vec3( mapN.xy, sqrt( saturate( 1.0 - dot( mapN.xy, mapN.xy ) ) ) );
	#endif
	mapN.xy *= normalScale;
	normal = normalize( tbn * mapN );
#elif defined( USE_BUMPMAP )
	normal = perturbNormalArb( - vViewPosition, normal, dHdxy_fwd(), faceDirection );
#endif`,f1=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,p1=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,m1=`#ifndef FLAT_SHADED
	vNormal = normalize( transformedNormal );
	#ifdef USE_TANGENT
		vTangent = normalize( transformedTangent );
		vBitangent = normalize( cross( vNormal, vTangent ) * tangent.w );
		#ifdef FLIP_SIDED
			vBitangent = - vBitangent;
		#endif
	#endif
#endif`,g1=`#ifdef USE_NORMALMAP
	uniform sampler2D normalMap;
	uniform vec2 normalScale;
#endif
#ifdef USE_NORMALMAP_OBJECTSPACE
	uniform mat3 normalMatrix;
#endif
#if ! defined ( USE_TANGENT ) && ( defined ( USE_NORMALMAP_TANGENTSPACE ) || defined ( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY ) )
	mat3 getTangentFrame( vec3 eye_pos, vec3 surf_norm, vec2 uv ) {
		vec3 q0 = dFdx( eye_pos.xyz );
		vec3 q1 = dFdy( eye_pos.xyz );
		vec2 st0 = dFdx( uv.st );
		vec2 st1 = dFdy( uv.st );
		vec3 N = surf_norm;
		vec3 q1perp = cross( q1, N );
		vec3 q0perp = cross( N, q0 );
		vec3 T = q1perp * st0.x + q0perp * st1.x;
		vec3 B = q1perp * st0.y + q0perp * st1.y;
		float det = max( dot( T, T ), dot( B, B ) );
		float scale = ( det == 0.0 ) ? 0.0 : inversesqrt( det );
		return mat3( T * scale, B * scale, N );
	}
#endif`,x1=`#ifdef USE_CLEARCOAT
	vec3 clearcoatNormal = nonPerturbedNormal;
#endif`,v1=`#ifdef USE_CLEARCOAT_NORMALMAP
	vec3 clearcoatMapN = texture2D( clearcoatNormalMap, vClearcoatNormalMapUv ).xyz * 2.0 - 1.0;
	clearcoatMapN.xy *= clearcoatNormalScale;
	clearcoatNormal = normalize( tbn2 * clearcoatMapN );
#endif`,y1=`#ifdef USE_CLEARCOATMAP
	uniform sampler2D clearcoatMap;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform sampler2D clearcoatNormalMap;
	uniform vec2 clearcoatNormalScale;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform sampler2D clearcoatRoughnessMap;
#endif`,_1=`#ifdef USE_IRIDESCENCEMAP
	uniform sampler2D iridescenceMap;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform sampler2D iridescenceThicknessMap;
#endif`,b1=`#ifdef OPAQUE
diffuseColor.a = 1.0;
#endif
#ifdef USE_TRANSMISSION
diffuseColor.a *= material.transmissionAlpha;
#endif
gl_FragColor = vec4( outgoingLight, diffuseColor.a );`,M1=`vec3 packNormalToRGB( const in vec3 normal ) {
	return normalize( normal ) * 0.5 + 0.5;
}
vec3 unpackRGBToNormal( const in vec3 rgb ) {
	return 2.0 * rgb.xyz - 1.0;
}
const float PackUpscale = 256. / 255.;const float UnpackDownscale = 255. / 256.;const float ShiftRight8 = 1. / 256.;
const float Inv255 = 1. / 255.;
const vec4 PackFactors = vec4( 1.0, 256.0, 256.0 * 256.0, 256.0 * 256.0 * 256.0 );
const vec2 UnpackFactors2 = vec2( UnpackDownscale, 1.0 / PackFactors.g );
const vec3 UnpackFactors3 = vec3( UnpackDownscale / PackFactors.rg, 1.0 / PackFactors.b );
const vec4 UnpackFactors4 = vec4( UnpackDownscale / PackFactors.rgb, 1.0 / PackFactors.a );
vec4 packDepthToRGBA( const in float v ) {
	if( v <= 0.0 )
		return vec4( 0., 0., 0., 0. );
	if( v >= 1.0 )
		return vec4( 1., 1., 1., 1. );
	float vuf;
	float af = modf( v * PackFactors.a, vuf );
	float bf = modf( vuf * ShiftRight8, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec4( vuf * Inv255, gf * PackUpscale, bf * PackUpscale, af );
}
vec3 packDepthToRGB( const in float v ) {
	if( v <= 0.0 )
		return vec3( 0., 0., 0. );
	if( v >= 1.0 )
		return vec3( 1., 1., 1. );
	float vuf;
	float bf = modf( v * PackFactors.b, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec3( vuf * Inv255, gf * PackUpscale, bf );
}
vec2 packDepthToRG( const in float v ) {
	if( v <= 0.0 )
		return vec2( 0., 0. );
	if( v >= 1.0 )
		return vec2( 1., 1. );
	float vuf;
	float gf = modf( v * 256., vuf );
	return vec2( vuf * Inv255, gf );
}
float unpackRGBAToDepth( const in vec4 v ) {
	return dot( v, UnpackFactors4 );
}
float unpackRGBToDepth( const in vec3 v ) {
	return dot( v, UnpackFactors3 );
}
float unpackRGToDepth( const in vec2 v ) {
	return v.r * UnpackFactors2.r + v.g * UnpackFactors2.g;
}
vec4 pack2HalfToRGBA( const in vec2 v ) {
	vec4 r = vec4( v.x, fract( v.x * 255.0 ), v.y, fract( v.y * 255.0 ) );
	return vec4( r.x - r.y / 255.0, r.y, r.z - r.w / 255.0, r.w );
}
vec2 unpackRGBATo2Half( const in vec4 v ) {
	return vec2( v.x + ( v.y / 255.0 ), v.z + ( v.w / 255.0 ) );
}
float viewZToOrthographicDepth( const in float viewZ, const in float near, const in float far ) {
	return ( viewZ + near ) / ( near - far );
}
float orthographicDepthToViewZ( const in float depth, const in float near, const in float far ) {
	#ifdef USE_REVERSED_DEPTH_BUFFER
	
		return depth * ( far - near ) - far;
	#else
		return depth * ( near - far ) - near;
	#endif
}
float viewZToPerspectiveDepth( const in float viewZ, const in float near, const in float far ) {
	return ( ( near + viewZ ) * far ) / ( ( far - near ) * viewZ );
}
float perspectiveDepthToViewZ( const in float depth, const in float near, const in float far ) {
	
	#ifdef USE_REVERSED_DEPTH_BUFFER
		return ( near * far ) / ( ( near - far ) * depth - near );
	#else
		return ( near * far ) / ( ( far - near ) * depth - far );
	#endif
}`,S1=`#ifdef PREMULTIPLIED_ALPHA
	gl_FragColor.rgb *= gl_FragColor.a;
#endif`,w1=`vec4 mvPosition = vec4( transformed, 1.0 );
#ifdef USE_BATCHING
	mvPosition = batchingMatrix * mvPosition;
#endif
#ifdef USE_INSTANCING
	mvPosition = instanceMatrix * mvPosition;
#endif
mvPosition = modelViewMatrix * mvPosition;
gl_Position = projectionMatrix * mvPosition;`,T1=`#ifdef DITHERING
	gl_FragColor.rgb = dithering( gl_FragColor.rgb );
#endif`,E1=`#ifdef DITHERING
	vec3 dithering( vec3 color ) {
		float grid_position = rand( gl_FragCoord.xy );
		vec3 dither_shift_RGB = vec3( 0.25 / 255.0, -0.25 / 255.0, 0.25 / 255.0 );
		dither_shift_RGB = mix( 2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position );
		return color + dither_shift_RGB;
	}
#endif`,A1=`float roughnessFactor = roughness;
#ifdef USE_ROUGHNESSMAP
	vec4 texelRoughness = texture2D( roughnessMap, vRoughnessMapUv );
	roughnessFactor *= texelRoughness.g;
#endif`,R1=`#ifdef USE_ROUGHNESSMAP
	uniform sampler2D roughnessMap;
#endif`,C1=`#if NUM_SPOT_LIGHT_COORDS > 0
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#if NUM_SPOT_LIGHT_MAPS > 0
	uniform sampler2D spotLightMap[ NUM_SPOT_LIGHT_MAPS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_SUN_LIGHT_SHADOWS > 0
		#define SUN_LIGHT_CASCADES 2
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow sunShadowMap[ NUM_SUN_LIGHT_SHADOWS ];
		#else
			uniform sampler2D sunShadowMap[ NUM_SUN_LIGHT_SHADOWS ];
		#endif
		uniform mat4 sunShadowMatrix[ NUM_SUN_LIGHT_SHADOWS * SUN_LIGHT_CASCADES ];
		uniform vec4 sunShadowCascade[ NUM_SUN_LIGHT_SHADOWS * SUN_LIGHT_CASCADES ];
		varying vec4 vSunShadowWorldPosition;
		varying vec3 vSunShadowWorldNormal;
		struct SunLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SunLightShadow sunLightShadows[ NUM_SUN_LIGHT_SHADOWS ];
	#endif
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#else
			uniform sampler2D directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#endif
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#else
			uniform sampler2D spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#endif
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform samplerCubeShadow pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#elif defined( SHADOWMAP_TYPE_BASIC )
			uniform samplerCube pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#endif
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float interleavedGradientNoise( vec2 position ) {
			return fract( 52.9829189 * fract( dot( position, vec2( 0.06711056, 0.00583715 ) ) ) );
		}
		vec2 vogelDiskSample( int sampleIndex, int samplesCount, float phi ) {
			const float goldenAngle = 2.399963229728653;
			float r = sqrt( ( float( sampleIndex ) + 0.5 ) / float( samplesCount ) );
			float theta = float( sampleIndex ) * goldenAngle + phi;
			return vec2( cos( theta ), sin( theta ) ) * r;
		}
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float getShadow( sampler2DShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			shadowCoord.z += shadowBias;
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 texelSize = vec2( 1.0 ) / shadowMapSize;
				float radius = shadowRadius * texelSize.x;
				float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
				shadow = (
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 0, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 1, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 2, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 3, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 4, 5, phi ) * radius, shadowCoord.z ) )
				) * 0.2;
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#elif defined( SHADOWMAP_TYPE_VSM )
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 distribution = texture2D( shadowMap, shadowCoord.xy ).rg;
				float mean = distribution.x;
				float variance = distribution.y * distribution.y;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					float hard_shadow = step( mean, shadowCoord.z );
				#else
					float hard_shadow = step( shadowCoord.z, mean );
				#endif
				
				if ( hard_shadow == 1.0 ) {
					shadow = 1.0;
				} else {
					variance = max( variance, 0.0000001 );
					float d = shadowCoord.z - mean;
					float p_max = variance / ( variance + d * d );
					p_max = clamp( ( p_max - 0.3 ) / 0.65, 0.0, 1.0 );
					shadow = max( hard_shadow, p_max );
				}
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#else
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				float depth = texture2D( shadowMap, shadowCoord.xy ).r;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					shadow = step( depth, shadowCoord.z );
				#else
					shadow = step( shadowCoord.z, depth );
				#endif
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#endif
	#if NUM_SUN_LIGHT_SHADOWS > 0
		float getSunShadow(
			#if defined( SHADOWMAP_TYPE_PCF )
				sampler2DShadow shadowMap,
			#else
				sampler2D shadowMap,
			#endif
			SunLightShadow sunLightShadow,
			int shadowIndex
		) {
			vec4 shadowWorldPosition = vec4( vSunShadowWorldPosition.xyz + vSunShadowWorldNormal * sunLightShadow.shadowNormalBias, 1.0 );
			float viewDepth = vSunShadowWorldPosition.w;
			int cascadeOffset = shadowIndex * SUN_LIGHT_CASCADES;
			float shadow = 1.0;
			for ( int i = SUN_LIGHT_CASCADES - 1; i >= 0; i -- ) {
				vec4 cascade = sunShadowCascade[ cascadeOffset + i ];
				if ( viewDepth >= cascade.x && viewDepth < cascade.y ) {
					float cascadeShadow = getShadow(
						shadowMap,
						sunLightShadow.shadowMapSize,
						sunLightShadow.shadowIntensity,
						sunLightShadow.shadowBias,
						sunLightShadow.shadowRadius,
						sunShadowMatrix[ cascadeOffset + i ] * shadowWorldPosition
					);
					shadow = mix( cascadeShadow, shadow, smoothstep( cascade.z, cascade.y, viewDepth ) );
				}
			}
			return shadow;
		}
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
	#if defined( SHADOWMAP_TYPE_PCF )
	float getPointShadow( samplerCubeShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 bd3D = normalize( lightToPosition );
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			#ifdef USE_REVERSED_DEPTH_BUFFER
				float dp = ( shadowCameraNear * ( shadowCameraFar - viewSpaceZ ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp -= shadowBias;
			#else
				float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp += shadowBias;
			#endif
			float texelSize = shadowRadius / shadowMapSize.x;
			vec3 absDir = abs( bd3D );
			vec3 tangent = absDir.x > absDir.z ? vec3( 0.0, 1.0, 0.0 ) : vec3( 1.0, 0.0, 0.0 );
			tangent = normalize( cross( bd3D, tangent ) );
			vec3 bitangent = cross( bd3D, tangent );
			float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
			vec2 sample0 = vogelDiskSample( 0, 5, phi );
			vec2 sample1 = vogelDiskSample( 1, 5, phi );
			vec2 sample2 = vogelDiskSample( 2, 5, phi );
			vec2 sample3 = vogelDiskSample( 3, 5, phi );
			vec2 sample4 = vogelDiskSample( 4, 5, phi );
			shadow = (
				texture( shadowMap, vec4( bd3D + ( tangent * sample0.x + bitangent * sample0.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample1.x + bitangent * sample1.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample2.x + bitangent * sample2.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample3.x + bitangent * sample3.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample4.x + bitangent * sample4.y ) * texelSize, dp ) )
			) * 0.2;
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#elif defined( SHADOWMAP_TYPE_BASIC )
	float getPointShadow( samplerCube shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
			dp += shadowBias;
			vec3 bd3D = normalize( lightToPosition );
			float depth = textureCube( shadowMap, bd3D ).r;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				depth = 1.0 - depth;
			#endif
			shadow = step( dp, depth );
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#endif
	#endif
#endif`,P1=`#if NUM_SPOT_LIGHT_COORDS > 0
	uniform mat4 spotLightMatrix[ NUM_SPOT_LIGHT_COORDS ];
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_SUN_LIGHT_SHADOWS > 0
		varying vec4 vSunShadowWorldPosition;
		varying vec3 vSunShadowWorldNormal;
	#endif
	#if NUM_DIR_LIGHT_SHADOWS > 0
		uniform mat4 directionalShadowMatrix[ NUM_DIR_LIGHT_SHADOWS ];
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		uniform mat4 pointShadowMatrix[ NUM_POINT_LIGHT_SHADOWS ];
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
#endif`,I1=`#if ( defined( USE_SHADOWMAP ) && ( NUM_DIR_LIGHT_SHADOWS > 0 || NUM_SUN_LIGHT_SHADOWS > 0 || NUM_POINT_LIGHT_SHADOWS > 0 ) ) || ( NUM_SPOT_LIGHT_COORDS > 0 )
	#ifdef HAS_NORMAL
		vec3 shadowWorldNormal = transformNormalByInverseViewMatrix( transformedNormal, viewMatrix );
	#else
		vec3 shadowWorldNormal = vec3( 0.0 );
	#endif
	vec4 shadowWorldPosition;
#endif
#if defined( USE_SHADOWMAP )
	#if NUM_SUN_LIGHT_SHADOWS > 0
		vSunShadowWorldPosition = vec4( worldPosition.xyz, - mvPosition.z );
		vSunShadowWorldNormal = shadowWorldNormal;
	#endif
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * directionalLightShadows[ i ].shadowNormalBias, 0 );
			vDirectionalShadowCoord[ i ] = directionalShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * pointLightShadows[ i ].shadowNormalBias, 0 );
			vPointShadowCoord[ i ] = pointShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
#endif
#if NUM_SPOT_LIGHT_COORDS > 0
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_COORDS; i ++ ) {
		shadowWorldPosition = worldPosition;
		#if ( defined( USE_SHADOWMAP ) && UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
			shadowWorldPosition.xyz += shadowWorldNormal * spotLightShadows[ i ].shadowNormalBias;
		#endif
		vSpotLightCoord[ i ] = spotLightMatrix[ i ] * shadowWorldPosition;
	}
	#pragma unroll_loop_end
#endif`,L1=`float getShadowMask() {
	float shadow = 1.0;
	#ifdef USE_SHADOWMAP
	#if NUM_SUN_LIGHT_SHADOWS > 0
	SunLightShadow sunLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SUN_LIGHT_SHADOWS; i ++ ) {
		sunLight = sunLightShadows[ i ];
		shadow *= receiveShadow ? getSunShadow( sunShadowMap[ i ], sunLight, UNROLLED_LOOP_INDEX ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
		directionalLight = directionalLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( directionalShadowMap[ i ], directionalLight.shadowMapSize, directionalLight.shadowIntensity, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_SHADOWS; i ++ ) {
		spotLight = spotLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( spotShadowMap[ i ], spotLight.shadowMapSize, spotLight.shadowIntensity, spotLight.shadowBias, spotLight.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0 && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
	PointLightShadow pointLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
		pointLight = pointLightShadows[ i ];
		shadow *= receiveShadow ? getPointShadow( pointShadowMap[ i ], pointLight.shadowMapSize, pointLight.shadowIntensity, pointLight.shadowBias, pointLight.shadowRadius, vPointShadowCoord[ i ], pointLight.shadowCameraNear, pointLight.shadowCameraFar ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#endif
	return shadow;
}`,D1=`#ifdef USE_SKINNING
	mat4 boneMatX = getBoneMatrix( skinIndex.x );
	mat4 boneMatY = getBoneMatrix( skinIndex.y );
	mat4 boneMatZ = getBoneMatrix( skinIndex.z );
	mat4 boneMatW = getBoneMatrix( skinIndex.w );
#endif`,N1=`#ifdef USE_SKINNING
	uniform mat4 bindMatrix;
	uniform mat4 bindMatrixInverse;
	uniform highp sampler2D boneTexture;
	mat4 getBoneMatrix( const in float i ) {
		int size = textureSize( boneTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( boneTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( boneTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( boneTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( boneTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
#endif`,U1=`#ifdef USE_SKINNING
	vec4 skinVertex = bindMatrix * vec4( transformed, 1.0 );
	vec4 skinned = vec4( 0.0 );
	skinned += boneMatX * skinVertex * skinWeight.x;
	skinned += boneMatY * skinVertex * skinWeight.y;
	skinned += boneMatZ * skinVertex * skinWeight.z;
	skinned += boneMatW * skinVertex * skinWeight.w;
	transformed = ( bindMatrixInverse * skinned ).xyz;
#endif`,F1=`#ifdef USE_SKINNING
	mat4 skinMatrix = mat4( 0.0 );
	skinMatrix += skinWeight.x * boneMatX;
	skinMatrix += skinWeight.y * boneMatY;
	skinMatrix += skinWeight.z * boneMatZ;
	skinMatrix += skinWeight.w * boneMatW;
	skinMatrix = bindMatrixInverse * skinMatrix * bindMatrix;
	objectNormal = vec4( skinMatrix * vec4( objectNormal, 0.0 ) ).xyz;
	#ifdef USE_TANGENT
		objectTangent = vec4( skinMatrix * vec4( objectTangent, 0.0 ) ).xyz;
	#endif
#endif`,z1=`float specularStrength;
#ifdef USE_SPECULARMAP
	vec4 texelSpecular = texture2D( specularMap, vSpecularMapUv );
	specularStrength = texelSpecular.r;
#else
	specularStrength = 1.0;
#endif`,O1=`#ifdef USE_SPECULARMAP
	uniform sampler2D specularMap;
#endif`,k1=`#if defined( TONE_MAPPING )
	gl_FragColor.rgb = toneMapping( gl_FragColor.rgb );
#endif`,B1=`#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
uniform float toneMappingExposure;
vec3 LinearToneMapping( vec3 color ) {
	return saturate( toneMappingExposure * color );
}
vec3 ReinhardToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	return saturate( color / ( vec3( 1.0 ) + color ) );
}
vec3 CineonToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	color = max( vec3( 0.0 ), color - 0.004 );
	return pow( ( color * ( 6.2 * color + 0.5 ) ) / ( color * ( 6.2 * color + 1.7 ) + 0.06 ), vec3( 2.2 ) );
}
vec3 RRTAndODTFit( vec3 v ) {
	vec3 a = v * ( v + 0.0245786 ) - 0.000090537;
	vec3 b = v * ( 0.983729 * v + 0.4329510 ) + 0.238081;
	return a / b;
}
vec3 ACESFilmicToneMapping( vec3 color ) {
	const mat3 ACESInputMat = mat3(
		vec3( 0.59719, 0.07600, 0.02840 ),		vec3( 0.35458, 0.90834, 0.13383 ),
		vec3( 0.04823, 0.01566, 0.83777 )
	);
	const mat3 ACESOutputMat = mat3(
		vec3(  1.60475, -0.10208, -0.00327 ),		vec3( -0.53108,  1.10813, -0.07276 ),
		vec3( -0.07367, -0.00605,  1.07602 )
	);
	color *= toneMappingExposure / 0.6;
	color = ACESInputMat * color;
	color = RRTAndODTFit( color );
	color = ACESOutputMat * color;
	return saturate( color );
}
const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
	vec3( 1.6605, - 0.1246, - 0.0182 ),
	vec3( - 0.5876, 1.1329, - 0.1006 ),
	vec3( - 0.0728, - 0.0083, 1.1187 )
);
const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
	vec3( 0.6274, 0.0691, 0.0164 ),
	vec3( 0.3293, 0.9195, 0.0880 ),
	vec3( 0.0433, 0.0113, 0.8956 )
);
vec3 agxDefaultContrastApprox( vec3 x ) {
	vec3 x2 = x * x;
	vec3 x4 = x2 * x2;
	return + 15.5 * x4 * x2
		- 40.14 * x4 * x
		+ 31.96 * x4
		- 6.868 * x2 * x
		+ 0.4298 * x2
		+ 0.1191 * x
		- 0.00232;
}
vec3 AgXToneMapping( vec3 color ) {
	const mat3 AgXInsetMatrix = mat3(
		vec3( 0.856627153315983, 0.137318972929847, 0.11189821299995 ),
		vec3( 0.0951212405381588, 0.761241990602591, 0.0767994186031903 ),
		vec3( 0.0482516061458583, 0.101439036467562, 0.811302368396859 )
	);
	const mat3 AgXOutsetMatrix = mat3(
		vec3( 1.1271005818144368, - 0.1413297634984383, - 0.14132976349843826 ),
		vec3( - 0.11060664309660323, 1.157823702216272, - 0.11060664309660294 ),
		vec3( - 0.016493938717834573, - 0.016493938717834257, 1.2519364065950405 )
	);
	const float AgxMinEv = - 12.47393;	const float AgxMaxEv = 4.026069;
	color *= toneMappingExposure;
	color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;
	color = AgXInsetMatrix * color;
	color = max( color, 1e-10 );	color = log2( color );
	color = ( color - AgxMinEv ) / ( AgxMaxEv - AgxMinEv );
	color = clamp( color, 0.0, 1.0 );
	color = agxDefaultContrastApprox( color );
	color = AgXOutsetMatrix * color;
	color = pow( max( vec3( 0.0 ), color ), vec3( 2.2 ) );
	color = LINEAR_REC2020_TO_LINEAR_SRGB * color;
	color = clamp( color, 0.0, 1.0 );
	return color;
}
vec3 NeutralToneMapping( vec3 color ) {
	const float StartCompression = 0.8 - 0.04;
	const float Desaturation = 0.15;
	color *= toneMappingExposure;
	float x = min( color.r, min( color.g, color.b ) );
	float offset = x < 0.08 ? x - 6.25 * x * x : 0.04;
	color -= offset;
	float peak = max( color.r, max( color.g, color.b ) );
	if ( peak < StartCompression ) return color;
	float d = 1. - StartCompression;
	float newPeak = 1. - d * d / ( peak + d - StartCompression );
	color *= newPeak / peak;
	float g = 1. - 1. / ( Desaturation * ( peak - newPeak ) + 1. );
	return mix( color, vec3( newPeak ), g );
}
vec3 CustomToneMapping( vec3 color ) { return color; }`,H1=`#ifdef USE_TRANSMISSION
	material.transmission = transmission;
	material.transmissionAlpha = 1.0;
	material.thickness = thickness;
	material.attenuationDistance = attenuationDistance;
	material.attenuationColor = attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		material.transmission *= texture2D( transmissionMap, vTransmissionMapUv ).r;
	#endif
	#ifdef USE_THICKNESSMAP
		material.thickness *= texture2D( thicknessMap, vThicknessMapUv ).g;
	#endif
	vec3 pos = vWorldPosition;
	vec3 v = normalize( cameraPosition - pos );
	vec3 n = transformNormalByInverseViewMatrix( normal, viewMatrix );
	vec4 transmitted = getIBLVolumeRefraction(
		n, v, material.roughness, material.diffuseContribution, material.specularColorBlended, material.specularF90,
		pos, modelMatrix, viewMatrix, projectionMatrix, material.dispersion, material.ior, material.thickness,
		material.attenuationColor, material.attenuationDistance );
	material.transmissionAlpha = mix( material.transmissionAlpha, transmitted.a, material.transmission );
	totalDiffuse = mix( totalDiffuse, transmitted.rgb, material.transmission );
#endif`,G1=`#ifdef USE_TRANSMISSION
	uniform float transmission;
	uniform float thickness;
	uniform float attenuationDistance;
	uniform vec3 attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		uniform sampler2D transmissionMap;
	#endif
	#ifdef USE_THICKNESSMAP
		uniform sampler2D thicknessMap;
	#endif
	uniform vec2 transmissionSamplerSize;
	uniform sampler2D transmissionSamplerMap;
	uniform mat4 modelMatrix;
	uniform mat4 projectionMatrix;
	varying vec3 vWorldPosition;
	float w0( float a ) {
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - a + 3.0 ) - 3.0 ) + 1.0 );
	}
	float w1( float a ) {
		return ( 1.0 / 6.0 ) * ( a *  a * ( 3.0 * a - 6.0 ) + 4.0 );
	}
	float w2( float a ){
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - 3.0 * a + 3.0 ) + 3.0 ) + 1.0 );
	}
	float w3( float a ) {
		return ( 1.0 / 6.0 ) * ( a * a * a );
	}
	float g0( float a ) {
		return w0( a ) + w1( a );
	}
	float g1( float a ) {
		return w2( a ) + w3( a );
	}
	float h0( float a ) {
		return - 1.0 + w1( a ) / ( w0( a ) + w1( a ) );
	}
	float h1( float a ) {
		return 1.0 + w3( a ) / ( w2( a ) + w3( a ) );
	}
	vec4 bicubic( sampler2D tex, vec2 uv, vec4 texelSize, float lod ) {
		uv = uv * texelSize.zw + 0.5;
		vec2 iuv = floor( uv );
		vec2 fuv = fract( uv );
		float g0x = g0( fuv.x );
		float g1x = g1( fuv.x );
		float h0x = h0( fuv.x );
		float h1x = h1( fuv.x );
		float h0y = h0( fuv.y );
		float h1y = h1( fuv.y );
		vec2 p0 = ( vec2( iuv.x + h0x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p1 = ( vec2( iuv.x + h1x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p2 = ( vec2( iuv.x + h0x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		vec2 p3 = ( vec2( iuv.x + h1x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		return g0( fuv.y ) * ( g0x * textureLod( tex, p0, lod ) + g1x * textureLod( tex, p1, lod ) ) +
			g1( fuv.y ) * ( g0x * textureLod( tex, p2, lod ) + g1x * textureLod( tex, p3, lod ) );
	}
	vec4 textureBicubic( sampler2D sampler, vec2 uv, float lod ) {
		vec2 fLodSize = vec2( textureSize( sampler, int( lod ) ) );
		vec2 cLodSize = vec2( textureSize( sampler, int( lod + 1.0 ) ) );
		vec2 fLodSizeInv = 1.0 / fLodSize;
		vec2 cLodSizeInv = 1.0 / cLodSize;
		vec4 fSample = bicubic( sampler, uv, vec4( fLodSizeInv, fLodSize ), floor( lod ) );
		vec4 cSample = bicubic( sampler, uv, vec4( cLodSizeInv, cLodSize ), ceil( lod ) );
		return mix( fSample, cSample, fract( lod ) );
	}
	vec3 getVolumeTransmissionRay( const in vec3 n, const in vec3 v, const in float thickness, const in float ior, const in mat4 modelMatrix ) {
		vec3 refractionVector = refract( - v, normalize( n ), 1.0 / ior );
		vec3 modelScale;
		modelScale.x = length( vec3( modelMatrix[ 0 ].xyz ) );
		modelScale.y = length( vec3( modelMatrix[ 1 ].xyz ) );
		modelScale.z = length( vec3( modelMatrix[ 2 ].xyz ) );
		return normalize( refractionVector ) * thickness * modelScale;
	}
	float applyIorToRoughness( const in float roughness, const in float ior ) {
		return roughness * clamp( ior * 2.0 - 2.0, 0.0, 1.0 );
	}
	vec4 getTransmissionSample( const in vec2 fragCoord, const in float roughness, const in float ior ) {
		float lod = log2( transmissionSamplerSize.x ) * applyIorToRoughness( roughness, ior );
		return textureBicubic( transmissionSamplerMap, fragCoord.xy, lod );
	}
	vec3 volumeAttenuation( const in float transmissionDistance, const in vec3 attenuationColor, const in float attenuationDistance ) {
		if ( isinf( attenuationDistance ) ) {
			return vec3( 1.0 );
		} else {
			vec3 attenuationCoefficient = -log( attenuationColor ) / attenuationDistance;
			vec3 transmittance = exp( - attenuationCoefficient * transmissionDistance );			return transmittance;
		}
	}
	vec4 getIBLVolumeRefraction( const in vec3 n, const in vec3 v, const in float roughness, const in vec3 diffuseColor,
		const in vec3 specularColor, const in float specularF90, const in vec3 position, const in mat4 modelMatrix,
		const in mat4 viewMatrix, const in mat4 projMatrix, const in float dispersion, const in float ior, const in float thickness,
		const in vec3 attenuationColor, const in float attenuationDistance ) {
		vec4 transmittedLight;
		vec3 transmittance;
		#ifdef USE_DISPERSION
			float halfSpread = ( ior - 1.0 ) * 0.025 * dispersion;
			vec3 iors = vec3( ior - halfSpread, ior, ior + halfSpread );
			for ( int i = 0; i < 3; i ++ ) {
				vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, iors[ i ], modelMatrix );
				vec3 refractedRayExit = position + transmissionRay;
				vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
				vec2 refractionCoords = ndcPos.xy / ndcPos.w;
				refractionCoords += 1.0;
				refractionCoords /= 2.0;
				vec4 transmissionSample = getTransmissionSample( refractionCoords, roughness, iors[ i ] );
				transmittedLight[ i ] = transmissionSample[ i ];
				transmittedLight.a += transmissionSample.a;
				transmittance[ i ] = diffuseColor[ i ] * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance )[ i ];
			}
			transmittedLight.a /= 3.0;
		#else
			vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, ior, modelMatrix );
			vec3 refractedRayExit = position + transmissionRay;
			vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
			vec2 refractionCoords = ndcPos.xy / ndcPos.w;
			refractionCoords += 1.0;
			refractionCoords /= 2.0;
			transmittedLight = getTransmissionSample( refractionCoords, roughness, ior );
			transmittance = diffuseColor * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance );
		#endif
		vec3 attenuatedColor = transmittance * transmittedLight.rgb;
		vec3 F = EnvironmentBRDF( n, v, specularColor, specularF90, roughness );
		float transmittanceFactor = ( transmittance.r + transmittance.g + transmittance.b ) / 3.0;
		return vec4( ( 1.0 - F ) * attenuatedColor, 1.0 - ( 1.0 - transmittedLight.a ) * transmittanceFactor );
	}
#endif`,V1=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_SPECULARMAP
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,W1=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	uniform mat3 mapTransform;
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	uniform mat3 alphaMapTransform;
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	uniform mat3 lightMapTransform;
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	uniform mat3 aoMapTransform;
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	uniform mat3 bumpMapTransform;
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	uniform mat3 normalMapTransform;
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_DISPLACEMENTMAP
	uniform mat3 displacementMapTransform;
	varying vec2 vDisplacementMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	uniform mat3 emissiveMapTransform;
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	uniform mat3 metalnessMapTransform;
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	uniform mat3 roughnessMapTransform;
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	uniform mat3 anisotropyMapTransform;
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	uniform mat3 clearcoatMapTransform;
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform mat3 clearcoatNormalMapTransform;
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform mat3 clearcoatRoughnessMapTransform;
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	uniform mat3 sheenColorMapTransform;
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	uniform mat3 sheenRoughnessMapTransform;
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	uniform mat3 iridescenceMapTransform;
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform mat3 iridescenceThicknessMapTransform;
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SPECULARMAP
	uniform mat3 specularMapTransform;
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	uniform mat3 specularColorMapTransform;
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	uniform mat3 specularIntensityMapTransform;
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,X1=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	vUv = vec3( uv, 1 ).xy;
#endif
#ifdef USE_MAP
	vMapUv = ( mapTransform * vec3( MAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ALPHAMAP
	vAlphaMapUv = ( alphaMapTransform * vec3( ALPHAMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_LIGHTMAP
	vLightMapUv = ( lightMapTransform * vec3( LIGHTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_AOMAP
	vAoMapUv = ( aoMapTransform * vec3( AOMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_BUMPMAP
	vBumpMapUv = ( bumpMapTransform * vec3( BUMPMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_NORMALMAP
	vNormalMapUv = ( normalMapTransform * vec3( NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_DISPLACEMENTMAP
	vDisplacementMapUv = ( displacementMapTransform * vec3( DISPLACEMENTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_EMISSIVEMAP
	vEmissiveMapUv = ( emissiveMapTransform * vec3( EMISSIVEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_METALNESSMAP
	vMetalnessMapUv = ( metalnessMapTransform * vec3( METALNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ROUGHNESSMAP
	vRoughnessMapUv = ( roughnessMapTransform * vec3( ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ANISOTROPYMAP
	vAnisotropyMapUv = ( anisotropyMapTransform * vec3( ANISOTROPYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOATMAP
	vClearcoatMapUv = ( clearcoatMapTransform * vec3( CLEARCOATMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	vClearcoatNormalMapUv = ( clearcoatNormalMapTransform * vec3( CLEARCOAT_NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	vClearcoatRoughnessMapUv = ( clearcoatRoughnessMapTransform * vec3( CLEARCOAT_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCEMAP
	vIridescenceMapUv = ( iridescenceMapTransform * vec3( IRIDESCENCEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	vIridescenceThicknessMapUv = ( iridescenceThicknessMapTransform * vec3( IRIDESCENCE_THICKNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_COLORMAP
	vSheenColorMapUv = ( sheenColorMapTransform * vec3( SHEEN_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	vSheenRoughnessMapUv = ( sheenRoughnessMapTransform * vec3( SHEEN_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULARMAP
	vSpecularMapUv = ( specularMapTransform * vec3( SPECULARMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_COLORMAP
	vSpecularColorMapUv = ( specularColorMapTransform * vec3( SPECULAR_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	vSpecularIntensityMapUv = ( specularIntensityMapTransform * vec3( SPECULAR_INTENSITYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_TRANSMISSIONMAP
	vTransmissionMapUv = ( transmissionMapTransform * vec3( TRANSMISSIONMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_THICKNESSMAP
	vThicknessMapUv = ( thicknessMapTransform * vec3( THICKNESSMAP_UV, 1 ) ).xy;
#endif`,q1=`#if defined( USE_ENVMAP ) || defined( DISTANCE ) || defined ( USE_SHADOWMAP ) || defined ( USE_TRANSMISSION ) || NUM_SPOT_LIGHT_COORDS > 0
	vec4 worldPosition = vec4( transformed, 1.0 );
	#ifdef USE_BATCHING
		worldPosition = batchingMatrix * worldPosition;
	#endif
	#ifdef USE_INSTANCING
		worldPosition = instanceMatrix * worldPosition;
	#endif
	worldPosition = modelMatrix * worldPosition;
#endif`,$1=`varying vec2 vUv;
uniform mat3 uvTransform;
void main() {
	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	gl_Position = vec4( position.xy, 1.0, 1.0 );
}`,Y1=`uniform sampler2D t2D;
uniform float backgroundIntensity;
varying vec2 vUv;
void main() {
	vec4 texColor = texture2D( t2D, vUv );
	#ifdef DECODE_VIDEO_TEXTURE
		texColor = vec4( mix( pow( texColor.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), texColor.rgb * 0.0773993808, vec3( lessThanEqual( texColor.rgb, vec3( 0.04045 ) ) ) ), texColor.w );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,Z1=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,J1=`#ifdef ENVMAP_TYPE_CUBE
	uniform samplerCube envMap;
#elif defined( ENVMAP_TYPE_CUBE_UV )
	uniform sampler2D envMap;
#endif
uniform float backgroundBlurriness;
uniform float backgroundIntensity;
uniform mat3 backgroundRotation;
varying vec3 vWorldDirection;
#include <cube_uv_reflection_fragment>
void main() {
	#ifdef ENVMAP_TYPE_CUBE
		vec4 texColor = textureCube( envMap, backgroundRotation * vWorldDirection );
	#elif defined( ENVMAP_TYPE_CUBE_UV )
		vec4 texColor = textureCubeUV( envMap, backgroundRotation * vWorldDirection, backgroundBlurriness );
	#else
		vec4 texColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,K1=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,j1=`uniform samplerCube tCube;
uniform float tFlip;
uniform float opacity;
varying vec3 vWorldDirection;
void main() {
	vec4 texColor = textureCube( tCube, vec3( tFlip * vWorldDirection.x, vWorldDirection.yz ) );
	gl_FragColor = texColor;
	gl_FragColor.a *= opacity;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,Q1=`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
varying vec2 vHighPrecisionZW;
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vHighPrecisionZW = gl_Position.zw;
}`,tv=`#if DEPTH_PACKING == 3200
	uniform float opacity;
#endif
#include <common>
#include <packing>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
varying vec2 vHighPrecisionZW;
void main() {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#if DEPTH_PACKING == 3200
		diffuseColor.a = opacity;
	#endif
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <logdepthbuf_fragment>
	#ifdef USE_REVERSED_DEPTH_BUFFER
		float fragCoordZ = vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ];
	#else
		float fragCoordZ = 0.5 * vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ] + 0.5;
	#endif
	#if DEPTH_PACKING == 3200
		gl_FragColor = vec4( vec3( 1.0 - fragCoordZ ), opacity );
	#elif DEPTH_PACKING == 3201
		gl_FragColor = packDepthToRGBA( fragCoordZ );
	#elif DEPTH_PACKING == 3202
		gl_FragColor = vec4( packDepthToRGB( fragCoordZ ), 1.0 );
	#elif DEPTH_PACKING == 3203
		gl_FragColor = vec4( packDepthToRG( fragCoordZ ), 0.0, 1.0 );
	#endif
}`,ev=`#define DISTANCE
varying vec3 vWorldPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <worldpos_vertex>
	#include <clipping_planes_vertex>
	vWorldPosition = worldPosition.xyz;
}`,iv=`#define DISTANCE
uniform vec3 referencePosition;
uniform float nearDistance;
uniform float farDistance;
varying vec3 vWorldPosition;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	float dist = length( vWorldPosition - referencePosition );
	dist = ( dist - nearDistance ) / ( farDistance - nearDistance );
	dist = saturate( dist );
	gl_FragColor = vec4( dist, 0.0, 0.0, 1.0 );
}`,nv=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
}`,sv=`uniform sampler2D tEquirect;
varying vec3 vWorldDirection;
#include <common>
void main() {
	vec3 direction = normalize( vWorldDirection );
	vec2 sampleUV = equirectUv( direction );
	gl_FragColor = texture2D( tEquirect, sampleUV );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,rv=`uniform float scale;
attribute float lineDistance;
varying float vLineDistance;
#include <common>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	vLineDistance = scale * lineDistance;
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,av=`uniform vec3 diffuse;
uniform float opacity;
uniform float dashSize;
uniform float totalSize;
varying float vLineDistance;
#include <common>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	if ( mod( vLineDistance, totalSize ) > dashSize ) {
		discard;
	}
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,ov=`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#if defined ( USE_ENVMAP ) || defined ( USE_SKINNING )
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinbase_vertex>
		#include <skinnormal_vertex>
		#include <defaultnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <fog_vertex>
}`,lv=`uniform vec3 diffuse;
uniform float opacity;
#ifndef FLAT_SHADED
	varying vec3 vNormal;
#endif
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <fog_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		reflectedLight.indirectDiffuse += lightMapTexel.rgb * lightMapIntensity * RECIPROCAL_PI;
	#else
		reflectedLight.indirectDiffuse += vec3( 1.0 );
	#endif
	#include <aomap_fragment>
	reflectedLight.indirectDiffuse *= diffuseColor.rgb;
	vec3 outgoingLight = reflectedLight.indirectDiffuse;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,cv=`#define LAMBERT
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,hv=`#define LAMBERT
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_lambert_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_lambert_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,uv=`#define MATCAP
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <displacementmap_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
	vViewPosition = - mvPosition.xyz;
}`,dv=`#define MATCAP
uniform vec3 diffuse;
uniform float opacity;
uniform sampler2D matcap;
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	vec3 viewDir = normalize( vViewPosition );
	vec3 x = normalize( vec3( viewDir.z, 0.0, - viewDir.x ) );
	vec3 y = cross( viewDir, x );
	vec2 uv = vec2( dot( x, normal ), dot( y, normal ) ) * 0.495 + 0.5;
	#ifdef USE_MATCAP
		vec4 matcapColor = texture2D( matcap, uv );
	#else
		vec4 matcapColor = vec4( vec3( mix( 0.2, 0.8, uv.y ) ), 1.0 );
	#endif
	vec3 outgoingLight = diffuseColor.rgb * matcapColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,fv=`#define NORMAL
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	vViewPosition = - mvPosition.xyz;
#endif
}`,pv=`#define NORMAL
uniform float opacity;
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <uv_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( 0.0, 0.0, 0.0, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	gl_FragColor = vec4( normalize( normal ) * 0.5 + 0.5, diffuseColor.a );
	#ifdef OPAQUE
		gl_FragColor.a = 1.0;
	#endif
}`,mv=`#define PHONG
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,gv=`#define PHONG
uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_phong_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_phong_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,xv=`#define STANDARD
varying vec3 vViewPosition;
#ifdef USE_TRANSMISSION
	varying vec3 vWorldPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
#ifdef USE_TRANSMISSION
	vWorldPosition = worldPosition.xyz;
#endif
}`,vv=`#define STANDARD
#ifdef PHYSICAL
	#define IOR
	#define USE_SPECULAR
#endif
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float roughness;
uniform float metalness;
uniform float opacity;
#ifdef IOR
	uniform float ior;
#endif
#ifdef USE_SPECULAR
	uniform float specularIntensity;
	uniform vec3 specularColor;
	#ifdef USE_SPECULAR_COLORMAP
		uniform sampler2D specularColorMap;
	#endif
	#ifdef USE_SPECULAR_INTENSITYMAP
		uniform sampler2D specularIntensityMap;
	#endif
#endif
#ifdef USE_CLEARCOAT
	uniform float clearcoat;
	uniform float clearcoatRoughness;
#endif
#ifdef USE_DISPERSION
	uniform float dispersion;
#endif
#ifdef USE_RETROREFLECTION
	uniform float retroreflectivity;
#endif
#ifdef USE_IRIDESCENCE
	uniform float iridescence;
	uniform float iridescenceIOR;
	uniform float iridescenceThicknessMinimum;
	uniform float iridescenceThicknessMaximum;
#endif
#ifdef USE_SHEEN
	uniform vec3 sheenColor;
	uniform float sheenRoughness;
	#ifdef USE_SHEEN_COLORMAP
		uniform sampler2D sheenColorMap;
	#endif
	#ifdef USE_SHEEN_ROUGHNESSMAP
		uniform sampler2D sheenRoughnessMap;
	#endif
#endif
#ifdef USE_ANISOTROPY
	uniform vec2 anisotropyVector;
	#ifdef USE_ANISOTROPYMAP
		uniform sampler2D anisotropyMap;
	#endif
#endif
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <iridescence_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_physical_pars_fragment>
#include <transmission_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <clearcoat_pars_fragment>
#include <iridescence_pars_fragment>
#include <roughnessmap_pars_fragment>
#include <metalnessmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <roughnessmap_fragment>
	#include <metalnessmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <clearcoat_normal_fragment_begin>
	#include <clearcoat_normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_physical_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 totalDiffuse = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse;
	vec3 totalSpecular = reflectedLight.directSpecular + reflectedLight.indirectSpecular;
	#include <transmission_fragment>
	vec3 outgoingLight = totalDiffuse + totalSpecular + totalEmissiveRadiance;
	#ifdef USE_SHEEN
 
		outgoingLight = outgoingLight + sheenSpecularDirect + sheenSpecularIndirect;
 
 	#endif
	#ifdef USE_CLEARCOAT
		float dotNVcc = saturate( dot( geometryClearcoatNormal, geometryViewDir ) );
		vec3 Fcc = F_Schlick( material.clearcoatF0, material.clearcoatF90, dotNVcc );
		outgoingLight = outgoingLight * ( 1.0 - material.clearcoat * Fcc ) + ( clearcoatSpecularDirect + clearcoatSpecularIndirect ) * material.clearcoat;
	#endif
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,yv=`#define TOON
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,_v=`#define TOON
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <gradientmap_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_toon_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_toon_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,bv=`uniform float size;
uniform float scale;
#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
#ifdef USE_POINTS_UV
	varying vec2 vUv;
	uniform mat3 uvTransform;
#endif
void main() {
	#ifdef USE_POINTS_UV
		vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	#endif
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	gl_PointSize = size;
	#ifdef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) gl_PointSize *= ( scale / - mvPosition.z );
	#endif
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <fog_vertex>
}`,Mv=`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <color_pars_fragment>
#include <map_particle_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_particle_fragment>
	#include <color_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,Sv=`#include <common>
#include <batching_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <shadowmap_pars_vertex>
void main() {
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,wv=`uniform vec3 color;
uniform float opacity;
#include <common>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <logdepthbuf_pars_fragment>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>
void main() {
	#include <logdepthbuf_fragment>
	gl_FragColor = vec4( color, opacity * ( 1.0 - getShadowMask() ) );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,Tv=`uniform float rotation;
uniform vec2 center;
#include <common>
#include <uv_pars_vertex>
#include <fog_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	vec4 mvPosition = modelViewMatrix[ 3 ];
	vec2 scale = vec2( length( modelMatrix[ 0 ].xyz ), length( modelMatrix[ 1 ].xyz ) );
	#ifndef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) scale *= - mvPosition.z;
	#endif
	vec2 alignedPosition = ( position.xy - ( center - vec2( 0.5 ) ) ) * scale;
	vec2 rotatedPosition;
	rotatedPosition.x = cos( rotation ) * alignedPosition.x - sin( rotation ) * alignedPosition.y;
	rotatedPosition.y = sin( rotation ) * alignedPosition.x + cos( rotation ) * alignedPosition.y;
	mvPosition.xy += rotatedPosition;
	gl_Position = projectionMatrix * mvPosition;
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,Ev=`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
}`,le={alphahash_fragment:$g,alphahash_pars_fragment:Yg,alphamap_fragment:Zg,alphamap_pars_fragment:Jg,alphatest_fragment:Kg,alphatest_pars_fragment:jg,aomap_fragment:Qg,aomap_pars_fragment:tx,batching_pars_vertex:ex,batching_vertex:ix,begin_vertex:nx,beginnormal_vertex:sx,bsdfs:rx,iridescence_fragment:ax,bumpmap_pars_fragment:ox,clipping_planes_fragment:lx,clipping_planes_pars_fragment:cx,clipping_planes_pars_vertex:hx,clipping_planes_vertex:ux,color_fragment:dx,color_pars_fragment:fx,color_pars_vertex:px,color_vertex:mx,common:gx,cube_uv_reflection_fragment:xx,defaultnormal_vertex:vx,displacementmap_pars_vertex:yx,displacementmap_vertex:_x,emissivemap_fragment:bx,emissivemap_pars_fragment:Mx,colorspace_fragment:Sx,colorspace_pars_fragment:wx,envmap_fragment:Tx,envmap_common_pars_fragment:Ex,envmap_pars_fragment:Ax,envmap_pars_vertex:Rx,envmap_physical_pars_fragment:kx,envmap_vertex:Cx,fog_vertex:Px,fog_pars_vertex:Ix,fog_fragment:Lx,fog_pars_fragment:Dx,gradientmap_pars_fragment:Nx,lightmap_pars_fragment:Ux,lights_lambert_fragment:Fx,lights_lambert_pars_fragment:zx,lights_pars_begin:Ox,lights_toon_fragment:Bx,lights_toon_pars_fragment:Hx,lights_phong_fragment:Gx,lights_phong_pars_fragment:Vx,lights_physical_fragment:Wx,lights_physical_pars_fragment:Xx,lights_fragment_begin:qx,lights_fragment_maps:$x,lights_fragment_end:Yx,lightprobes_pars_fragment:Zx,logdepthbuf_fragment:Jx,logdepthbuf_pars_fragment:Kx,logdepthbuf_pars_vertex:jx,logdepthbuf_vertex:Qx,map_fragment:t1,map_pars_fragment:e1,map_particle_fragment:i1,map_particle_pars_fragment:n1,metalnessmap_fragment:s1,metalnessmap_pars_fragment:r1,morphinstance_vertex:a1,morphcolor_vertex:o1,morphnormal_vertex:l1,morphtarget_pars_vertex:c1,morphtarget_vertex:h1,normal_fragment_begin:u1,normal_fragment_maps:d1,normal_pars_fragment:f1,normal_pars_vertex:p1,normal_vertex:m1,normalmap_pars_fragment:g1,clearcoat_normal_fragment_begin:x1,clearcoat_normal_fragment_maps:v1,clearcoat_pars_fragment:y1,iridescence_pars_fragment:_1,opaque_fragment:b1,packing:M1,premultiplied_alpha_fragment:S1,project_vertex:w1,dithering_fragment:T1,dithering_pars_fragment:E1,roughnessmap_fragment:A1,roughnessmap_pars_fragment:R1,shadowmap_pars_fragment:C1,shadowmap_pars_vertex:P1,shadowmap_vertex:I1,shadowmask_pars_fragment:L1,skinbase_vertex:D1,skinning_pars_vertex:N1,skinning_vertex:U1,skinnormal_vertex:F1,specularmap_fragment:z1,specularmap_pars_fragment:O1,tonemapping_fragment:k1,tonemapping_pars_fragment:B1,transmission_fragment:H1,transmission_pars_fragment:G1,uv_pars_fragment:V1,uv_pars_vertex:W1,uv_vertex:X1,worldpos_vertex:q1,background_vert:$1,background_frag:Y1,backgroundCube_vert:Z1,backgroundCube_frag:J1,cube_vert:K1,cube_frag:j1,depth_vert:Q1,depth_frag:tv,distance_vert:ev,distance_frag:iv,equirect_vert:nv,equirect_frag:sv,linedashed_vert:rv,linedashed_frag:av,meshbasic_vert:ov,meshbasic_frag:lv,meshlambert_vert:cv,meshlambert_frag:hv,meshmatcap_vert:uv,meshmatcap_frag:dv,meshnormal_vert:fv,meshnormal_frag:pv,meshphong_vert:mv,meshphong_frag:gv,meshphysical_vert:xv,meshphysical_frag:vv,meshtoon_vert:yv,meshtoon_frag:_v,points_vert:bv,points_frag:Mv,shadow_vert:Sv,shadow_frag:wv,sprite_vert:Tv,sprite_frag:Ev},Rt={common:{diffuse:{value:new Nt(16777215)},opacity:{value:1},map:{value:null},mapTransform:{value:new ie},alphaMap:{value:null},alphaMapTransform:{value:new ie},alphaTest:{value:0}},specularmap:{specularMap:{value:null},specularMapTransform:{value:new ie}},envmap:{envMap:{value:null},envMapRotation:{value:new ie},reflectivity:{value:1},ior:{value:1.5},refractionRatio:{value:.98},dfgLUT:{value:null}},aomap:{aoMap:{value:null},aoMapIntensity:{value:1},aoMapTransform:{value:new ie}},lightmap:{lightMap:{value:null},lightMapIntensity:{value:1},lightMapTransform:{value:new ie}},bumpmap:{bumpMap:{value:null},bumpMapTransform:{value:new ie},bumpScale:{value:1}},normalmap:{normalMap:{value:null},normalMapTransform:{value:new ie},normalScale:{value:new ot(1,1)}},displacementmap:{displacementMap:{value:null},displacementMapTransform:{value:new ie},displacementScale:{value:1},displacementBias:{value:0}},emissivemap:{emissiveMap:{value:null},emissiveMapTransform:{value:new ie}},metalnessmap:{metalnessMap:{value:null},metalnessMapTransform:{value:new ie}},roughnessmap:{roughnessMap:{value:null},roughnessMapTransform:{value:new ie}},gradientmap:{gradientMap:{value:null}},fog:{fogDensity:{value:25e-5},fogNear:{value:1},fogFar:{value:2e3},fogColor:{value:new Nt(16777215)}},lights:{ambientLightColor:{value:[]},lightProbe:{value:[]},sunLights:{value:[],properties:{direction:{},color:{}}},sunLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},sunShadowMatrix:{value:[]},sunShadowCascade:{value:[]},directionalLights:{value:[],properties:{direction:{},color:{}}},directionalLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},directionalShadowMatrix:{value:[]},spotLights:{value:[],properties:{color:{},position:{},direction:{},distance:{},coneCos:{},penumbraCos:{},decay:{}}},spotLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},spotLightMap:{value:[]},spotLightMatrix:{value:[]},pointLights:{value:[],properties:{color:{},position:{},decay:{},distance:{}}},pointLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{},shadowCameraNear:{},shadowCameraFar:{}}},pointShadowMatrix:{value:[]},hemisphereLights:{value:[],properties:{direction:{},skyColor:{},groundColor:{}}},rectAreaLights:{value:[],properties:{color:{},position:{},width:{},height:{}}},ltc_1:{value:null},ltc_2:{value:null},probesSH:{value:null},probesMin:{value:new D},probesMax:{value:new D},probesResolution:{value:new D}},points:{diffuse:{value:new Nt(16777215)},opacity:{value:1},size:{value:1},scale:{value:1},map:{value:null},alphaMap:{value:null},alphaMapTransform:{value:new ie},alphaTest:{value:0},uvTransform:{value:new ie}},sprite:{diffuse:{value:new Nt(16777215)},opacity:{value:1},center:{value:new ot(.5,.5)},rotation:{value:0},map:{value:null},mapTransform:{value:new ie},alphaMap:{value:null},alphaMapTransform:{value:new ie},alphaTest:{value:0}}},Sn={basic:{uniforms:yi([Rt.common,Rt.specularmap,Rt.envmap,Rt.aomap,Rt.lightmap,Rt.fog]),vertexShader:le.meshbasic_vert,fragmentShader:le.meshbasic_frag},lambert:{uniforms:yi([Rt.common,Rt.specularmap,Rt.envmap,Rt.aomap,Rt.lightmap,Rt.emissivemap,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,Rt.fog,Rt.lights,{emissive:{value:new Nt(0)},envMapIntensity:{value:1}}]),vertexShader:le.meshlambert_vert,fragmentShader:le.meshlambert_frag},phong:{uniforms:yi([Rt.common,Rt.specularmap,Rt.envmap,Rt.aomap,Rt.lightmap,Rt.emissivemap,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,Rt.fog,Rt.lights,{emissive:{value:new Nt(0)},specular:{value:new Nt(1118481)},shininess:{value:30},envMapIntensity:{value:1}}]),vertexShader:le.meshphong_vert,fragmentShader:le.meshphong_frag},standard:{uniforms:yi([Rt.common,Rt.envmap,Rt.aomap,Rt.lightmap,Rt.emissivemap,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,Rt.roughnessmap,Rt.metalnessmap,Rt.fog,Rt.lights,{emissive:{value:new Nt(0)},roughness:{value:1},metalness:{value:0},envMapIntensity:{value:1}}]),vertexShader:le.meshphysical_vert,fragmentShader:le.meshphysical_frag},toon:{uniforms:yi([Rt.common,Rt.aomap,Rt.lightmap,Rt.emissivemap,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,Rt.gradientmap,Rt.fog,Rt.lights,{emissive:{value:new Nt(0)}}]),vertexShader:le.meshtoon_vert,fragmentShader:le.meshtoon_frag},matcap:{uniforms:yi([Rt.common,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,Rt.fog,{matcap:{value:null}}]),vertexShader:le.meshmatcap_vert,fragmentShader:le.meshmatcap_frag},points:{uniforms:yi([Rt.points,Rt.fog]),vertexShader:le.points_vert,fragmentShader:le.points_frag},dashed:{uniforms:yi([Rt.common,Rt.fog,{scale:{value:1},dashSize:{value:1},totalSize:{value:2}}]),vertexShader:le.linedashed_vert,fragmentShader:le.linedashed_frag},depth:{uniforms:yi([Rt.common,Rt.displacementmap]),vertexShader:le.depth_vert,fragmentShader:le.depth_frag},normal:{uniforms:yi([Rt.common,Rt.bumpmap,Rt.normalmap,Rt.displacementmap,{opacity:{value:1}}]),vertexShader:le.meshnormal_vert,fragmentShader:le.meshnormal_frag},sprite:{uniforms:yi([Rt.sprite,Rt.fog]),vertexShader:le.sprite_vert,fragmentShader:le.sprite_frag},background:{uniforms:{uvTransform:{value:new ie},t2D:{value:null},backgroundIntensity:{value:1}},vertexShader:le.background_vert,fragmentShader:le.background_frag},backgroundCube:{uniforms:{envMap:{value:null},backgroundBlurriness:{value:0},backgroundIntensity:{value:1},backgroundRotation:{value:new ie}},vertexShader:le.backgroundCube_vert,fragmentShader:le.backgroundCube_frag},cube:{uniforms:{tCube:{value:null},tFlip:{value:-1},opacity:{value:1}},vertexShader:le.cube_vert,fragmentShader:le.cube_frag},equirect:{uniforms:{tEquirect:{value:null}},vertexShader:le.equirect_vert,fragmentShader:le.equirect_frag},distance:{uniforms:yi([Rt.common,Rt.displacementmap,{referencePosition:{value:new D},nearDistance:{value:1},farDistance:{value:1e3}}]),vertexShader:le.distance_vert,fragmentShader:le.distance_frag},shadow:{uniforms:yi([Rt.lights,Rt.fog,{color:{value:new Nt(0)},opacity:{value:1}}]),vertexShader:le.shadow_vert,fragmentShader:le.shadow_frag}};Sn.physical={uniforms:yi([Sn.standard.uniforms,{clearcoat:{value:0},clearcoatMap:{value:null},clearcoatMapTransform:{value:new ie},clearcoatNormalMap:{value:null},clearcoatNormalMapTransform:{value:new ie},clearcoatNormalScale:{value:new ot(1,1)},clearcoatRoughness:{value:0},clearcoatRoughnessMap:{value:null},clearcoatRoughnessMapTransform:{value:new ie},dispersion:{value:0},retroreflectivity:{value:0},iridescence:{value:0},iridescenceMap:{value:null},iridescenceMapTransform:{value:new ie},iridescenceIOR:{value:1.3},iridescenceThicknessMinimum:{value:100},iridescenceThicknessMaximum:{value:400},iridescenceThicknessMap:{value:null},iridescenceThicknessMapTransform:{value:new ie},sheen:{value:0},sheenColor:{value:new Nt(0)},sheenColorMap:{value:null},sheenColorMapTransform:{value:new ie},sheenRoughness:{value:1},sheenRoughnessMap:{value:null},sheenRoughnessMapTransform:{value:new ie},transmission:{value:0},transmissionMap:{value:null},transmissionMapTransform:{value:new ie},transmissionSamplerSize:{value:new ot},transmissionSamplerMap:{value:null},thickness:{value:0},thicknessMap:{value:null},thicknessMapTransform:{value:new ie},attenuationDistance:{value:0},attenuationColor:{value:new Nt(0)},specularColor:{value:new Nt(1,1,1)},specularColorMap:{value:null},specularColorMapTransform:{value:new ie},specularIntensity:{value:1},specularIntensityMap:{value:null},specularIntensityMapTransform:{value:new ie},anisotropyVector:{value:new ot},anisotropyMap:{value:null},anisotropyMapTransform:{value:new ie}}]),vertexShader:le.meshphysical_vert,fragmentShader:le.meshphysical_frag};var Bc={r:0,b:0,g:0},Av=new me,hp=new ie;hp.set(-1,0,0,0,1,0,0,0,1);function Rv(n,t,e,i,s,r){let a=new Nt(0),o=s===!0?0:1,c,l,h=null,u=0,d=null;function f(_){let T=_.isScene===!0?_.background:null;if(T&&T.isTexture){let v=_.backgroundBlurriness>0;T=t.get(T,v)}return T}function p(_){let T=!1,v=f(_);v===null?m(a,o):v&&v.isColor&&(m(v,1),T=!0);let S=n.xr.getEnvironmentBlendMode();S==="additive"?e.buffers.color.setClear(0,0,0,1,r):S==="alpha-blend"&&e.buffers.color.setClear(0,0,0,0,r),(n.autoClear||T)&&(e.buffers.depth.setTest(!0),e.buffers.depth.setMask(!0),e.buffers.color.setMask(!0),n.clear(n.autoClearColor,n.autoClearDepth,n.autoClearStencil))}function x(_,T){let v=f(T);v&&(v.isCubeTexture||v.mapping===so)?(l===void 0&&(l=new Pt(new $i(1,1,1),new ze({name:"BackgroundCubeMaterial",uniforms:Ds(Sn.backgroundCube.uniforms),vertexShader:Sn.backgroundCube.vertexShader,fragmentShader:Sn.backgroundCube.fragmentShader,side:di,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),l.geometry.deleteAttribute("normal"),l.geometry.deleteAttribute("uv"),l.onBeforeRender=function(S,M,A){this.matrixWorld.copyPosition(A.matrixWorld)},Object.defineProperty(l.material,"envMap",{get:function(){return this.uniforms.envMap.value}}),i.update(l)),l.material.uniforms.envMap.value=v,l.material.uniforms.backgroundBlurriness.value=T.backgroundBlurriness,l.material.uniforms.backgroundIntensity.value=T.backgroundIntensity,l.material.uniforms.backgroundRotation.value.setFromMatrix4(Av.makeRotationFromEuler(T.backgroundRotation)).transpose(),v.isCubeTexture&&v.isRenderTargetTexture===!1&&l.material.uniforms.backgroundRotation.value.premultiply(hp),l.material.toneMapped=he.getTransfer(v.colorSpace)!==_e,(h!==v||u!==v.version||d!==n.toneMapping)&&(l.material.needsUpdate=!0,h=v,u=v.version,d=n.toneMapping),l.layers.enableAll(),_.unshift(l,l.geometry,l.material,0,0,null)):v&&v.isTexture&&(c===void 0&&(c=new Pt(new Ti(2,2),new ze({name:"BackgroundMaterial",uniforms:Ds(Sn.background.uniforms),vertexShader:Sn.background.vertexShader,fragmentShader:Sn.background.fragmentShader,side:rs,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),c.geometry.deleteAttribute("normal"),Object.defineProperty(c.material,"map",{get:function(){return this.uniforms.t2D.value}}),i.update(c)),c.material.uniforms.t2D.value=v,c.material.uniforms.backgroundIntensity.value=T.backgroundIntensity,c.material.toneMapped=he.getTransfer(v.colorSpace)!==_e,v.matrixAutoUpdate===!0&&v.updateMatrix(),c.material.uniforms.uvTransform.value.copy(v.matrix),(h!==v||u!==v.version||d!==n.toneMapping)&&(c.material.needsUpdate=!0,h=v,u=v.version,d=n.toneMapping),c.layers.enableAll(),_.unshift(c,c.geometry,c.material,0,0,null))}function m(_,T){_.getRGB(Bc,Yu(n)),e.buffers.color.setClear(Bc.r,Bc.g,Bc.b,T,r)}function g(){l!==void 0&&(l.geometry.dispose(),l.material.dispose(),l=void 0),c!==void 0&&(c.geometry.dispose(),c.material.dispose(),c=void 0)}return{getClearColor:function(){return a},setClearColor:function(_,T=1){a.set(_),o=T,m(a,o)},getClearAlpha:function(){return o},setClearAlpha:function(_){o=_,m(a,o)},render:p,addToRenderList:x,dispose:g}}function Cv(n,t){let e=n.getParameter(n.MAX_VERTEX_ATTRIBS),i={},s=d(null),r=s,a=!1;function o(N,F,B,I,H){let W=!1,U=u(N,I,B,F);r!==U&&(r=U,l(r.object)),W=f(N,I,B,H),W&&p(N,I,B,H),H!==null&&t.update(H,n.ELEMENT_ARRAY_BUFFER),(W||a)&&(a=!1,v(N,F,B,I),H!==null&&n.bindBuffer(n.ELEMENT_ARRAY_BUFFER,t.get(H).buffer))}function c(){return n.createVertexArray()}function l(N){return n.bindVertexArray(N)}function h(N){return n.deleteVertexArray(N)}function u(N,F,B,I){let H=I.wireframe===!0,W=i[F.id];W===void 0&&(W={},i[F.id]=W);let U=N.isInstancedMesh===!0?N.id:0,X=W[U];X===void 0&&(X={},W[U]=X);let G=X[B.id];G===void 0&&(G={},X[B.id]=G);let j=G[H];return j===void 0&&(j=d(c()),G[H]=j),j}function d(N){let F=[],B=[],I=[];for(let H=0;H<e;H++)F[H]=0,B[H]=0,I[H]=0;return{geometry:null,program:null,wireframe:!1,newAttributes:F,enabledAttributes:B,attributeDivisors:I,object:N,attributes:{},index:null}}function f(N,F,B,I){let H=r.attributes,W=F.attributes,U=0,X=B.getAttributes();for(let G in X)if(X[G].location>=0){let et=H[G],vt=W[G];if(vt===void 0&&(G==="instanceMatrix"&&N.instanceMatrix&&(vt=N.instanceMatrix),G==="instanceColor"&&N.instanceColor&&(vt=N.instanceColor)),et===void 0||et.attribute!==vt||vt&&et.data!==vt.data)return!0;U++}return r.attributesNum!==U||r.index!==I}function p(N,F,B,I){let H={},W=F.attributes,U=0,X=B.getAttributes();for(let G in X)if(X[G].location>=0){let et=W[G];et===void 0&&(G==="instanceMatrix"&&N.instanceMatrix&&(et=N.instanceMatrix),G==="instanceColor"&&N.instanceColor&&(et=N.instanceColor));let vt={};vt.attribute=et,et&&et.data&&(vt.data=et.data),H[G]=vt,U++}r.attributes=H,r.attributesNum=U,r.index=I}function x(){let N=r.newAttributes;for(let F=0,B=N.length;F<B;F++)N[F]=0}function m(N){g(N,0)}function g(N,F){let B=r.newAttributes,I=r.enabledAttributes,H=r.attributeDivisors;B[N]=1,I[N]===0&&(n.enableVertexAttribArray(N),I[N]=1),H[N]!==F&&(n.vertexAttribDivisor(N,F),H[N]=F)}function _(){let N=r.newAttributes,F=r.enabledAttributes;for(let B=0,I=F.length;B<I;B++)F[B]!==N[B]&&(n.disableVertexAttribArray(B),F[B]=0)}function T(N,F,B,I,H,W,U){U===!0?n.vertexAttribIPointer(N,F,B,H,W):n.vertexAttribPointer(N,F,B,I,H,W)}function v(N,F,B,I){x();let H=I.attributes,W=B.getAttributes(),U=F.defaultAttributeValues;for(let X in W){let G=W[X];if(G.location>=0){let j=H[X];if(j===void 0&&(X==="instanceMatrix"&&N.instanceMatrix&&(j=N.instanceMatrix),X==="instanceColor"&&N.instanceColor&&(j=N.instanceColor)),j!==void 0){let et=j.normalized,vt=j.itemSize,ht=t.get(j);if(ht===void 0)continue;let Ut=ht.buffer,$t=ht.type,Kt=ht.bytesPerElement,$=$t===n.INT||$t===n.UNSIGNED_INT||j.gpuType===ec;if(j.isInterleavedBufferAttribute){let rt=j.data,_t=rt.stride,Jt=j.offset;if(rt.isInstancedInterleavedBuffer){for(let At=0;At<G.locationSize;At++)g(G.location+At,rt.meshPerAttribute);N.isInstancedMesh!==!0&&I._maxInstanceCount===void 0&&(I._maxInstanceCount=rt.meshPerAttribute*rt.count)}else for(let At=0;At<G.locationSize;At++)m(G.location+At);n.bindBuffer(n.ARRAY_BUFFER,Ut);for(let At=0;At<G.locationSize;At++)T(G.location+At,vt/G.locationSize,$t,et,_t*Kt,(Jt+vt/G.locationSize*At)*Kt,$)}else{if(j.isInstancedBufferAttribute){for(let rt=0;rt<G.locationSize;rt++)g(G.location+rt,j.meshPerAttribute);N.isInstancedMesh!==!0&&I._maxInstanceCount===void 0&&(I._maxInstanceCount=j.meshPerAttribute*j.count)}else for(let rt=0;rt<G.locationSize;rt++)m(G.location+rt);n.bindBuffer(n.ARRAY_BUFFER,Ut);for(let rt=0;rt<G.locationSize;rt++)T(G.location+rt,vt/G.locationSize,$t,et,vt*Kt,vt/G.locationSize*rt*Kt,$)}}else if(U!==void 0){let et=U[X];if(et!==void 0)switch(et.length){case 2:n.vertexAttrib2fv(G.location,et);break;case 3:n.vertexAttrib3fv(G.location,et);break;case 4:n.vertexAttrib4fv(G.location,et);break;default:n.vertexAttrib1fv(G.location,et)}}}}_()}function S(){E();for(let N in i){let F=i[N];for(let B in F){let I=F[B];for(let H in I){let W=I[H];for(let U in W)h(W[U].object),delete W[U];delete I[H]}}delete i[N]}}function M(N){if(i[N.id]===void 0)return;let F=i[N.id];for(let B in F){let I=F[B];for(let H in I){let W=I[H];for(let U in W)h(W[U].object),delete W[U];delete I[H]}}delete i[N.id]}function A(N){for(let F in i){let B=i[F];for(let I in B){let H=B[I];if(H[N.id]===void 0)continue;let W=H[N.id];for(let U in W)h(W[U].object),delete W[U];delete H[N.id]}}}function y(N){for(let F in i){let B=i[F],I=N.isInstancedMesh===!0?N.id:0,H=B[I];if(H!==void 0){for(let W in H){let U=H[W];for(let X in U)h(U[X].object),delete U[X];delete H[W]}delete B[I],Object.keys(B).length===0&&delete i[F]}}}function E(){P(),a=!0,r!==s&&(r=s,l(r.object))}function P(){s.geometry=null,s.program=null,s.wireframe=!1}return{setup:o,reset:E,resetDefaultState:P,dispose:S,releaseStatesOfGeometry:M,releaseStatesOfObject:y,releaseStatesOfProgram:A,initAttributes:x,enableAttribute:m,disableUnusedAttributes:_}}function Pv(n,t,e){let i;function s(c){i=c}function r(c,l){n.drawArrays(i,c,l),e.update(l,i,1)}function a(c,l,h){h!==0&&(n.drawArraysInstanced(i,c,l,h),e.update(l,i,h))}function o(c,l,h){if(h===0)return;t.get("WEBGL_multi_draw").multiDrawArraysWEBGL(i,c,0,l,0,h);let d=0;for(let f=0;f<h;f++)d+=l[f];e.update(d,i,1)}this.setMode=s,this.render=r,this.renderInstances=a,this.renderMultiDraw=o}function Iv(n,t,e,i){let s;function r(){if(s!==void 0)return s;if(t.has("EXT_texture_filter_anisotropic")===!0){let A=t.get("EXT_texture_filter_anisotropic");s=n.getParameter(A.MAX_TEXTURE_MAX_ANISOTROPY_EXT)}else s=0;return s}function a(A){return!(A!==Ji&&i.convert(A)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_FORMAT))}function o(A){let y=A===qe&&(t.has("EXT_color_buffer_half_float")||t.has("EXT_color_buffer_float"));return!(A!==Ci&&A!==Zi&&!y&&i.convert(A)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_TYPE))}function c(A){if(A==="highp"){if(n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.HIGH_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.HIGH_FLOAT).precision>0)return"highp";A="mediump"}return A==="mediump"&&n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.MEDIUM_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.MEDIUM_FLOAT).precision>0?"mediump":"lowp"}let l=e.precision!==void 0?e.precision:"highp",h=c(l);h!==l&&(te("WebGLRenderer:",l,"not supported, using",h,"instead."),l=h);let u=e.logarithmicDepthBuffer===!0,d=e.reversedDepthBuffer===!0&&t.has("EXT_clip_control");e.reversedDepthBuffer===!0&&d===!1&&te("WebGLRenderer: Unable to use reversed depth buffer due to missing EXT_clip_control extension. Fallback to default depth buffer.");let f=n.getParameter(n.MAX_TEXTURE_IMAGE_UNITS),p=n.getParameter(n.MAX_VERTEX_TEXTURE_IMAGE_UNITS),x=n.getParameter(n.MAX_TEXTURE_SIZE),m=n.getParameter(n.MAX_CUBE_MAP_TEXTURE_SIZE),g=n.getParameter(n.MAX_VERTEX_ATTRIBS),_=n.getParameter(n.MAX_VERTEX_UNIFORM_VECTORS),T=n.getParameter(n.MAX_VARYING_VECTORS),v=n.getParameter(n.MAX_FRAGMENT_UNIFORM_VECTORS),S=n.getParameter(n.MAX_SAMPLES),M=n.getParameter(n.SAMPLES);return{isWebGL2:!0,getMaxAnisotropy:r,getMaxPrecision:c,textureFormatReadable:a,textureTypeReadable:o,precision:l,logarithmicDepthBuffer:u,reversedDepthBuffer:d,maxTextures:f,maxVertexTextures:p,maxTextureSize:x,maxCubemapSize:m,maxAttributes:g,maxVertexUniforms:_,maxVaryings:T,maxFragmentUniforms:v,maxSamples:S,samples:M}}function Lv(n){let t=this,e=null,i=0,s=!1,r=!1,a=new Si,o=new ie,c={value:null,needsUpdate:!1};this.uniform=c,this.numPlanes=0,this.numIntersection=0,this.init=function(u,d){let f=u.length!==0||d||i!==0||s;return s=d,i=u.length,f},this.beginShadows=function(){r=!0,h(null)},this.endShadows=function(){r=!1},this.setGlobalState=function(u,d){e=h(u,d,0)},this.setState=function(u,d,f){let p=u.clippingPlanes,x=u.clipIntersection,m=u.clipShadows,g=n.get(u);if(!s||p===null||p.length===0||r&&!m)r?h(null):l();else{let _=r?0:i,T=_*4,v=g.clippingState||null;c.value=v,v=h(p,d,T,f);for(let S=0;S!==T;++S)v[S]=e[S];g.clippingState=v,this.numIntersection=x?this.numPlanes:0,this.numPlanes+=_}};function l(){c.value!==e&&(c.value=e,c.needsUpdate=i>0),t.numPlanes=i,t.numIntersection=0}function h(u,d,f,p){let x=u!==null?u.length:0,m=null;if(x!==0){if(m=c.value,p!==!0||m===null){let g=f+x*4,_=d.matrixWorldInverse;o.getNormalMatrix(_),(m===null||m.length<g)&&(m=new Float32Array(g));for(let T=0,v=f;T!==x;++T,v+=4)a.copy(u[T]).applyMatrix4(_,o),a.normal.toArray(m,v),m[v+3]=a.constant}c.value=m,c.needsUpdate=!0}return t.numPlanes=x,t.numIntersection=0,m}}var Dr=4,Dv=6,Nv=20,Uv=256,mo=new ss,G0=new Nt,nd=null,sd=0,rd=0,ad=!1,Fv=new D,Ns=new D,Ur=class{constructor(t){this._renderer=t,this._pingPongRenderTarget=null,this._lodMax=0,this._cubeSize=0,this._sizeLods=[],this._lodMeshes=[],this._backgroundBox=null,this._cubemapMaterial=null,this._equirectMaterial=null,this._blurMaterial=null,this._ggxMaterial=null}fromScene(t,e=0,i=.1,s=100,r={}){let{size:a=256,position:o=Fv}=r;nd=this._renderer.getRenderTarget(),sd=this._renderer.getActiveCubeFace(),rd=this._renderer.getActiveMipmapLevel(),ad=this._renderer.xr.enabled,this._renderer.xr.enabled=!1,this._setSize(a);let c=this._allocateTargets();return c.depthBuffer=!0,this._sceneToCubeUV(t,i,s,c,o),e>0&&this._blur(c,0,0,e),this._applyPMREM(c),this._cleanup(c),c}fromEquirectangular(t,e=null){return this._fromTexture(t,e)}fromCubemap(t,e=null){return this._fromTexture(t,e)}compileCubemapShader(){this._cubemapMaterial===null&&(this._cubemapMaterial=X0(),this._compileMaterial(this._cubemapMaterial))}compileEquirectangularShader(){this._equirectMaterial===null&&(this._equirectMaterial=W0(),this._compileMaterial(this._equirectMaterial))}dispose(){this._dispose(),this._cubemapMaterial!==null&&this._cubemapMaterial.dispose(),this._equirectMaterial!==null&&this._equirectMaterial.dispose(),this._backgroundBox!==null&&(this._backgroundBox.geometry.dispose(),this._backgroundBox.material.dispose())}_setSize(t){this._lodMax=Math.floor(Math.log2(t)),this._cubeSize=Math.pow(2,this._lodMax)}_dispose(){this._blurMaterial!==null&&this._blurMaterial.dispose(),this._ggxMaterial!==null&&this._ggxMaterial.dispose(),this._pingPongRenderTarget!==null&&this._pingPongRenderTarget.dispose();for(let t=0;t<this._lodMeshes.length;t++)this._lodMeshes[t].geometry.dispose()}_cleanup(t){this._renderer.setRenderTarget(nd,sd,rd),this._renderer.xr.enabled=ad,t.scissorTest=!1,Lr(t,0,0,t.width,t.height)}_fromTexture(t,e){t.mapping===os||t.mapping===Ls?this._setSize(t.image.length===0?16:t.image[0].width||t.image[0].image.width):this._setSize(t.image.width/4),nd=this._renderer.getRenderTarget(),sd=this._renderer.getActiveCubeFace(),rd=this._renderer.getActiveMipmapLevel(),ad=this._renderer.xr.enabled,this._renderer.xr.enabled=!1;let i=e||this._allocateTargets();return this._textureToCubeUV(t,i),this._applyPMREM(i),this._cleanup(i),i}_allocateTargets(){let t=3*Math.max(this._cubeSize,112),e=4*this._cubeSize,i={magFilter:Ye,minFilter:Ye,generateMipmaps:!1,type:qe,format:Ji,colorSpace:ya,depthBuffer:!1},s=V0(t,e,i);if(this._pingPongRenderTarget===null||this._pingPongRenderTarget.width!==t||this._pingPongRenderTarget.height!==e){this._pingPongRenderTarget!==null&&this._dispose(),this._pingPongRenderTarget=V0(t,e,i);let{_lodMax:r}=this;({lodMeshes:this._lodMeshes,sizeLods:this._sizeLods}=zv(r)),this._blurMaterial=kv(r,t,e),this._ggxMaterial=Ov(r,t,e)}return s}_compileMaterial(t){let e=new Pt(new ge,t);this._renderer.compile(e,mo)}_sceneToCubeUV(t,e,i,s,r){let c=new ni(90,1,e,i),l=[1,-1,1,1,1,1],h=[1,1,1,-1,-1,-1],u=this._renderer,d=u.autoClear,f=u.toneMapping;u.getClearColor(G0),u.toneMapping=ln,u.autoClear=!1,u.state.buffers.depth.getReversed()&&(u.setRenderTarget(s),u.clearDepth(),u.setRenderTarget(null)),this._backgroundBox===null&&(this._backgroundBox=new Pt(new $i,new He({name:"PMREM.Background",side:di,depthWrite:!1,depthTest:!1})));let x=this._backgroundBox,m=x.material,g=!1,_=t.background;_?_.isColor&&(m.color.copy(_),t.background=null,g=!0):(m.color.copy(G0),g=!0);for(let T=0;T<6;T++){let v=T%3;v===0?(c.up.set(0,l[T],0),c.position.set(r.x,r.y,r.z),c.lookAt(r.x+h[T],r.y,r.z)):v===1?(c.up.set(0,0,l[T]),c.position.set(r.x,r.y,r.z),c.lookAt(r.x,r.y+h[T],r.z)):(c.up.set(0,l[T],0),c.position.set(r.x,r.y,r.z),c.lookAt(r.x,r.y,r.z+h[T]));let S=this._cubeSize;Lr(s,v*S,T>2?S:0,S,S),u.setRenderTarget(s),g&&u.render(x,c),u.render(t,c)}u.toneMapping=f,u.autoClear=d,t.background=_}_textureToCubeUV(t,e){let i=this._renderer,s=t.mapping===os||t.mapping===Ls;s?(this._cubemapMaterial===null&&(this._cubemapMaterial=X0()),this._cubemapMaterial.uniforms.flipEnvMap.value=t.isRenderTargetTexture===!1?-1:1):this._equirectMaterial===null&&(this._equirectMaterial=W0());let r=s?this._cubemapMaterial:this._equirectMaterial,a=this._lodMeshes[0];a.material=r;let o=r.uniforms;o.envMap.value=t;let c=this._cubeSize;Lr(e,0,0,3*c,2*c),i.setRenderTarget(e),i.render(a,mo)}_applyPMREM(t){let e=this._renderer,i=e.autoClear;e.autoClear=!1;let s=this._lodMeshes.length;for(let r=1;r<s;r++)this._applyGGXFilter(t,r-1,r);e.autoClear=i}_applyGGXFilter(t,e,i){let s=this._renderer,r=this._pingPongRenderTarget,a=this._ggxMaterial,o=this._lodMeshes[i];o.material=a;let c=a.uniforms,l=i/(this._lodMeshes.length-1),h=e/(this._lodMeshes.length-1),u=Math.sqrt(l*l-h*h),d=l*1.25,f=u*d,{_lodMax:p}=this,x=this._sizeLods[i],m=3*x*(i>p-Dr?i-p+Dr:0),g=4*(this._cubeSize-x);c.envMap.value=t.texture,c.roughness.value=f,c.mipInt.value=p-e,Lr(r,m,g,3*x,2*x),s.setRenderTarget(r),s.render(o,mo),c.envMap.value=r.texture,c.roughness.value=0,c.mipInt.value=p-i,Lr(t,m,g,3*x,2*x),s.setRenderTarget(t),s.render(o,mo)}_blur(t,e,i,s){let r=this._pingPongRenderTarget,a=Math.min(s,Math.PI)/Math.SQRT2;this._blurPass(t,r,e,i,a),this._blurPass(r,t,i,i,a)}_blurPass(t,e,i,s,r){let a=this._renderer,o=this._blurMaterial,c=this._lodMeshes[s];c.material=o;let l=o.uniforms;l.envMap.value=t.texture,l.sigma.value=r,l.mipInt.value=this._lodMax-i;let h=this._sizeLods[s],u=3*h*(s>this._lodMax-Dr?s-this._lodMax+Dr:0),d=4*(this._cubeSize-h);Lr(e,u,d,3*h,2*h),a.setRenderTarget(e),a.render(c,mo)}};function zv(n){let t=[],e=[],i=n,s=n-Dr+1+Dv;for(let r=0;r<s;r++){let a=Math.pow(2,i);t.push(a);let o=1/(a-2),c=-o,l=1+o,h=[c,c,l,c,l,l,c,c,l,l,c,l],u=6,d=6,f=3,p=new Float32Array(f*d*u),x=new Float32Array(f*d*u);for(let g=0;g<u;g++){let _=g%3*2/3-1,T=g>2?0:-1,v=[_,T,0,_+2/3,T,0,_+2/3,T+1,0,_,T,0,_+2/3,T+1,0,_,T+1,0];p.set(v,f*d*g);for(let S=0;S<d;S++){let M=h[S*2]*2-1,A=h[S*2+1]*2-1;g===0?Ns.set(1,A,M):g===1?Ns.set(-M,1,-A):g===2?Ns.set(-M,A,1):g===3?Ns.set(-1,A,-M):g===4?Ns.set(-M,-1,A):Ns.set(M,A,-1),Ns.toArray(x,(g*d+S)*f)}}let m=new ge;m.setAttribute("position",new ti(p,f)),m.setAttribute("outputDirection",new ti(x,f)),e.push(new Pt(m,null)),i>Dr&&i--}return{lodMeshes:e,sizeLods:t}}function V0(n,t,e){let i=new ke(n,t,e);return i.texture.mapping=so,i.texture.name="PMREM.cubeUv",i.scissorTest=!0,i}function Lr(n,t,e,i,s){n.viewport.set(t,e,i,s),n.scissor.set(t,e,i,s)}function Ov(n,t,e){return new ze({name:"PMREMGGXConvolution",defines:{GGX_SAMPLES:Uv,CUBEUV_TEXEL_WIDTH:1/t,CUBEUV_TEXEL_HEIGHT:1/e,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},roughness:{value:0},mipInt:{value:0}},vertexShader:Vc(),fragmentShader:`

			precision highp float;
			precision highp int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform float roughness;
			uniform float mipInt;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			#define PI 3.14159265359

			// Van der Corput radical inverse
			float radicalInverse_VdC(uint bits) {
				bits = (bits << 16u) | (bits >> 16u);
				bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
				bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
				bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
				bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
				return float(bits) * 2.3283064365386963e-10; // / 0x100000000
			}

			// Hammersley sequence
			vec2 hammersley(uint i, uint N) {
				return vec2(float(i) / float(N), radicalInverse_VdC(i));
			}

			// GGX VNDF importance sampling (Eric Heitz 2018)
			// "Sampling the GGX Distribution of Visible Normals"
			// https://jcgt.org/published/0007/04/01/
			vec3 importanceSampleGGX_VNDF(vec2 Xi, vec3 V, float roughness) {
				float alpha = roughness * roughness;

				// Section 4.1: Orthonormal basis
				vec3 T1 = vec3(1.0, 0.0, 0.0);
				vec3 T2 = cross(V, T1);

				// Section 4.2: Parameterization of projected area
				float r = sqrt(Xi.x);
				float phi = 2.0 * PI * Xi.y;
				float t1 = r * cos(phi);
				float t2 = r * sin(phi);
				float s = 0.5 * (1.0 + V.z);
				t2 = (1.0 - s) * sqrt(1.0 - t1 * t1) + s * t2;

				// Section 4.3: Reprojection onto hemisphere
				vec3 Nh = t1 * T1 + t2 * T2 + sqrt(max(0.0, 1.0 - t1 * t1 - t2 * t2)) * V;

				// Section 3.4: Transform back to ellipsoid configuration
				return normalize(vec3(alpha * Nh.x, alpha * Nh.y, max(0.0, Nh.z)));
			}

			void main() {
				vec3 N = normalize(vOutputDirection);
				vec3 V = N; // Assume view direction equals normal for pre-filtering

				vec3 prefilteredColor = vec3(0.0);
				float totalWeight = 0.0;

				// For very low roughness, just sample the environment directly
				if (roughness < 0.001) {
					gl_FragColor = vec4(bilinearCubeUV(envMap, N, mipInt), 1.0);
					return;
				}

				// Tangent space basis for VNDF sampling
				vec3 up = abs(N.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
				vec3 tangent = normalize(cross(up, N));
				vec3 bitangent = cross(N, tangent);

				for(uint i = 0u; i < uint(GGX_SAMPLES); i++) {
					vec2 Xi = hammersley(i, uint(GGX_SAMPLES));

					// For PMREM, V = N, so in tangent space V is always (0, 0, 1)
					vec3 H_tangent = importanceSampleGGX_VNDF(Xi, vec3(0.0, 0.0, 1.0), roughness);

					// Transform H back to world space
					vec3 H = normalize(tangent * H_tangent.x + bitangent * H_tangent.y + N * H_tangent.z);
					vec3 L = normalize(2.0 * dot(V, H) * H - V);

					float NdotL = max(dot(N, L), 0.0);

					if(NdotL > 0.0) {
						// Sample environment at fixed mip level
						// VNDF importance sampling handles the distribution filtering
						vec3 sampleColor = bilinearCubeUV(envMap, L, mipInt);

						// Weight by NdotL for the split-sum approximation
						// VNDF PDF naturally accounts for the visible microfacet distribution
						prefilteredColor += sampleColor * NdotL;
						totalWeight += NdotL;
					}
				}

				if (totalWeight > 0.0) {
					prefilteredColor = prefilteredColor / totalWeight;
				}

				gl_FragColor = vec4(prefilteredColor, 1.0);
			}
		`,blending:Yi,depthTest:!1,depthWrite:!1})}function kv(n,t,e){return new ze({name:"SphericalGaussianBlur",defines:{SAMPLES:Nv,CUBEUV_TEXEL_WIDTH:1/t,CUBEUV_TEXEL_HEIGHT:1/e,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},sigma:{value:0},mipInt:{value:0}},vertexShader:Vc(),fragmentShader:`

			precision highp float;
			precision highp int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform float sigma;
			uniform float mipInt;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			#define PI 3.14159265359
			#define GOLDEN_ANGLE 2.39996322973

			void main() {

				if ( sigma == 0.0 ) {

					gl_FragColor = vec4( bilinearCubeUV( envMap, vOutputDirection, mipInt ), 1.0 );
					return;

				}

				vec3 outputDirection = normalize( vOutputDirection );

				vec3 up = abs( outputDirection.z ) < 0.999 ? vec3( 0.0, 0.0, 1.0 ) : vec3( 1.0, 0.0, 0.0 );
				vec3 tangent = normalize( cross( up, outputDirection ) );
				vec3 bitangent = cross( outputDirection, tangent );

				// Truncate the kernel at three standard deviations or at the antipode.
				float thetaMax = min( 3.0 * sigma, PI );
				float truncation = 1.0 - exp( - 0.5 * thetaMax * thetaMax / ( sigma * sigma ) );

				vec3 accumColor = vec3( 0.0 );
				float accumWeight = 0.0;

				for ( int i = 0; i < SAMPLES; i ++ ) {

					// Stratified inverse-CDF sampling of the Gaussian, placed on a golden-angle spiral.
					float stratum = ( float( i ) + 0.5 ) / float( SAMPLES );
					float theta = sigma * sqrt( - 2.0 * log( 1.0 - stratum * truncation ) );
					float phi = float( i ) * GOLDEN_ANGLE;

					vec3 offset = cos( phi ) * tangent + sin( phi ) * bitangent;
					vec3 sampleDirection = cos( theta ) * outputDirection + sin( theta ) * offset;

					// Correct the planar sample density to solid angle.
					float weight = sin( theta ) / theta;

					accumColor += weight * bilinearCubeUV( envMap, sampleDirection, mipInt );
					accumWeight += weight;

				}

				gl_FragColor = vec4( accumColor / accumWeight, 1.0 );

			}
		`,blending:Yi,depthTest:!1,depthWrite:!1})}function W0(){return new ze({name:"EquirectangularToCubeUV",uniforms:{envMap:{value:null}},vertexShader:Vc(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;

			#include <common>

			void main() {

				vec3 outputDirection = normalize( vOutputDirection );
				vec2 uv = equirectUv( outputDirection );

				gl_FragColor = vec4( texture2D ( envMap, uv ).rgb, 1.0 );

			}
		`,blending:Yi,depthTest:!1,depthWrite:!1})}function X0(){return new ze({name:"CubemapToCubeUV",uniforms:{envMap:{value:null},flipEnvMap:{value:-1}},vertexShader:Vc(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			uniform float flipEnvMap;

			varying vec3 vOutputDirection;

			uniform samplerCube envMap;

			void main() {

				gl_FragColor = textureCube( envMap, vec3( flipEnvMap * vOutputDirection.x, vOutputDirection.yz ) );

			}
		`,blending:Yi,depthTest:!1,depthWrite:!1})}function Vc(){return`

		precision mediump float;
		precision mediump int;

		attribute vec3 outputDirection;

		varying vec3 vOutputDirection;

		void main() {

			vOutputDirection = outputDirection;
			gl_Position = vec4( position, 1.0 );

		}
	`}var Fr=class extends ke{constructor(t=1,e={}){super(t,t,e),this.isWebGLCubeRenderTarget=!0;let i={width:t,height:t,depth:1},s=[i,i,i,i,i,i];this.texture=new Da(s),this._setTextureOptions(e),this.texture.isRenderTargetTexture=!0}fromEquirectangularTexture(t,e){this.texture.type=e.type,this.texture.colorSpace=e.colorSpace,this.texture.generateMipmaps=e.generateMipmaps,this.texture.minFilter=e.minFilter,this.texture.magFilter=e.magFilter;let i={uniforms:{tEquirect:{value:null}},vertexShader:`

				varying vec3 vWorldDirection;

				vec3 transformDirection( in vec3 dir, in mat4 matrix ) {

					return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );

				}

				void main() {

					vWorldDirection = transformDirection( position, modelMatrix );

					#include <begin_vertex>
					#include <project_vertex>

				}
			`,fragmentShader:`

				uniform sampler2D tEquirect;

				varying vec3 vWorldDirection;

				#include <common>

				void main() {

					vec3 direction = normalize( vWorldDirection );

					vec2 sampleUV = equirectUv( direction );

					gl_FragColor = texture2D( tEquirect, sampleUV );

				}
			`},s=new $i(5,5,5),r=new ze({name:"CubemapFromEquirect",uniforms:Ds(i.uniforms),vertexShader:i.vertexShader,fragmentShader:i.fragmentShader,side:di,blending:Yi});r.uniforms.tEquirect.value=e;let a=new Pt(s,r),o=e.minFilter;return e.minFilter===Oi&&(e.minFilter=Ye),new Rr(1,10,this).update(t,a),e.minFilter=o,a.geometry.dispose(),a.material.dispose(),this}clear(t,e=!0,i=!0,s=!0){let r=t.getRenderTarget();for(let a=0;a<6;a++)t.setRenderTarget(this,a),t.clear(e,i,s);t.setRenderTarget(r)}};function Bv(n){let t=new WeakMap,e=new WeakMap,i=null;function s(d,f=!1){return d==null?null:f?a(d):r(d)}function r(d){if(d&&d.isTexture){let f=d.mapping;if(f===jl||f===Ql)if(t.has(d)){let p=t.get(d).texture;return o(p,d.mapping)}else{let p=d.image;if(p&&p.height>0){let x=new Fr(p.height);return x.fromEquirectangularTexture(n,d),t.set(d,x),d.addEventListener("dispose",l),o(x.texture,d.mapping)}else return null}}return d}function a(d){if(d&&d.isTexture){let f=d.mapping,p=f===jl||f===Ql,x=f===os||f===Ls;if(p||x){let m=e.get(d),g=m!==void 0?m.texture.pmremVersion:0;if(d.isRenderTargetTexture&&d.pmremVersion!==g)return i===null&&(i=new Ur(n)),m=p?i.fromEquirectangular(d,m):i.fromCubemap(d,m),m.texture.pmremVersion=d.pmremVersion,e.set(d,m),m.texture;if(m!==void 0)return m.texture;{let _=d.image;return p&&_&&_.height>0||x&&_&&c(_)?(i===null&&(i=new Ur(n)),m=p?i.fromEquirectangular(d):i.fromCubemap(d),m.texture.pmremVersion=d.pmremVersion,e.set(d,m),d.addEventListener("dispose",h),m.texture):null}}}return d}function o(d,f){return f===jl?d.mapping=os:f===Ql&&(d.mapping=Ls),d}function c(d){let f=0,p=6;for(let x=0;x<p;x++)d[x]!==void 0&&f++;return f===p}function l(d){let f=d.target;f.removeEventListener("dispose",l);let p=t.get(f);p!==void 0&&(t.delete(f),p.dispose())}function h(d){let f=d.target;f.removeEventListener("dispose",h);let p=e.get(f);p!==void 0&&(e.delete(f),p.dispose())}function u(){t=new WeakMap,e=new WeakMap,i!==null&&(i.dispose(),i=null)}return{get:s,dispose:u}}function Hv(n){let t={};function e(i){if(t[i]!==void 0)return t[i];let s=n.getExtension(i);return t[i]=s,s}return{has:function(i){return e(i)!==null},init:function(){e("EXT_color_buffer_float"),e("WEBGL_clip_cull_distance"),e("OES_texture_float_linear"),e("EXT_color_buffer_half_float"),e("WEBGL_multisampled_render_to_texture"),e("WEBGL_render_shared_exponent")},get:function(i){let s=e(i);return s===null&&ws("WebGLRenderer: "+i+" extension not supported."),s}}}function Gv(n,t,e,i){let s={},r=new WeakMap;function a(u){let d=u.target;d.index!==null&&t.remove(d.index);for(let p in d.attributes)t.remove(d.attributes[p]);d.removeEventListener("dispose",a),delete s[d.id];let f=r.get(d);f&&(t.remove(f),r.delete(d)),i.releaseStatesOfGeometry(d),d.isInstancedBufferGeometry===!0&&delete d._maxInstanceCount,e.memory.geometries--}function o(u,d){return s[d.id]===!0||(d.addEventListener("dispose",a),s[d.id]=!0,e.memory.geometries++),d}function c(u){let d=u.attributes;for(let f in d)t.update(d[f],n.ARRAY_BUFFER)}function l(u){let d=[],f=u.index,p=u.attributes.position,x=0;if(p===void 0)return;if(f!==null){let _=f.array;x=f.version;for(let T=0,v=_.length;T<v;T+=3){let S=_[T+0],M=_[T+1],A=_[T+2];d.push(S,M,M,A,A,S)}}else{let _=p.array;x=p.version;for(let T=0,v=_.length/3-1;T<v;T+=3){let S=T+0,M=T+1,A=T+2;d.push(S,M,M,A,A,S)}}let m=new(p.count>=65535?Ea:Ta)(d,1);m.version=x;let g=r.get(u);g&&t.remove(g),r.set(u,m)}function h(u){let d=r.get(u);if(d){let f=u.index;f!==null&&d.version<f.version&&l(u)}else l(u);return r.get(u)}return{get:o,update:c,getWireframeAttribute:h}}function Vv(n,t,e){let i;function s(u){i=u}let r,a;function o(u){r=u.type,a=u.bytesPerElement}function c(u,d){n.drawElements(i,d,r,u*a),e.update(d,i,1)}function l(u,d,f){f!==0&&(n.drawElementsInstanced(i,d,r,u*a,f),e.update(d,i,f))}function h(u,d,f){if(f===0)return;t.get("WEBGL_multi_draw").multiDrawElementsWEBGL(i,d,0,r,u,0,f);let x=0;for(let m=0;m<f;m++)x+=d[m];e.update(x,i,1)}this.setMode=s,this.setIndex=o,this.render=c,this.renderInstances=l,this.renderMultiDraw=h}function Wv(n){let t={geometries:0,textures:0},e={frame:0,calls:0,triangles:0,points:0,lines:0};function i(r,a,o){switch(e.calls++,a){case n.TRIANGLES:e.triangles+=o*(r/3);break;case n.LINES:e.lines+=o*(r/2);break;case n.LINE_STRIP:e.lines+=o*(r-1);break;case n.LINE_LOOP:e.lines+=o*r;break;case n.POINTS:e.points+=o*r;break;default:ee("WebGLInfo: Unknown draw mode:",a);break}}function s(){e.calls=0,e.triangles=0,e.points=0,e.lines=0}return{memory:t,render:e,programs:null,autoReset:!0,reset:s,update:i}}function Xv(n,t,e){let i=new WeakMap,s=new Le;function r(a,o,c){let l=a.morphTargetInfluences,h=o.morphAttributes.position||o.morphAttributes.normal||o.morphAttributes.color,u=h!==void 0?h.length:0,d=i.get(o);if(d===void 0||d.count!==u){let E=function(){A.dispose(),i.delete(o),o.removeEventListener("dispose",E)};d!==void 0&&d.texture.dispose();let f=o.morphAttributes.position!==void 0,p=o.morphAttributes.normal!==void 0,x=o.morphAttributes.color!==void 0,m=o.morphAttributes.position||[],g=o.morphAttributes.normal||[],_=o.morphAttributes.color||[],T=0;f===!0&&(T=1),p===!0&&(T=2),x===!0&&(T=3);let v=o.attributes.position.count*T,S=1;v>t.maxTextureSize&&(S=Math.ceil(v/t.maxTextureSize),v=t.maxTextureSize);let M=new Float32Array(v*S*4*u),A=new Sa(M,v,S,u);A.type=Zi,A.needsUpdate=!0;let y=T*4;for(let P=0;P<u;P++){let N=m[P],F=g[P],B=_[P],I=v*S*4*P;for(let H=0;H<N.count;H++){let W=H*y;f===!0&&(s.fromBufferAttribute(N,H),M[I+W+0]=s.x,M[I+W+1]=s.y,M[I+W+2]=s.z,M[I+W+3]=0),p===!0&&(s.fromBufferAttribute(F,H),M[I+W+4]=s.x,M[I+W+5]=s.y,M[I+W+6]=s.z,M[I+W+7]=0),x===!0&&(s.fromBufferAttribute(B,H),M[I+W+8]=s.x,M[I+W+9]=s.y,M[I+W+10]=s.z,M[I+W+11]=B.itemSize===4?s.w:1)}}d={count:u,texture:A,size:new ot(v,S)},i.set(o,d),o.addEventListener("dispose",E)}if(a.isInstancedMesh===!0&&a.morphTexture!==null)c.getUniforms().setValue(n,"morphTexture",a.morphTexture,e);else{let f=0;for(let x=0;x<l.length;x++)f+=l[x];let p=o.morphTargetsRelative?1:1-f;c.getUniforms().setValue(n,"morphTargetBaseInfluence",p),c.getUniforms().setValue(n,"morphTargetInfluences",l)}c.getUniforms().setValue(n,"morphTargetsTexture",d.texture,e),c.getUniforms().setValue(n,"morphTargetsTextureSize",d.size)}return{update:r}}function qv(n,t,e,i,s){let r=new WeakMap;function a(l){let h=s.render.frame,u=l.geometry,d=t.get(l,u);if(r.get(d)!==h&&(t.update(d),r.set(d,h)),l.isInstancedMesh&&(l.hasEventListener("dispose",c)===!1&&l.addEventListener("dispose",c),r.get(l)!==h&&(e.update(l.instanceMatrix,n.ARRAY_BUFFER),l.instanceColor!==null&&e.update(l.instanceColor,n.ARRAY_BUFFER),r.set(l,h))),l.isSkinnedMesh){let f=l.skeleton;r.get(f)!==h&&(f.update(),r.set(f,h))}return d}function o(){r=new WeakMap}function c(l){let h=l.target;h.removeEventListener("dispose",c),i.releaseStatesOfObject(h),e.remove(h.instanceMatrix),h.instanceColor!==null&&e.remove(h.instanceColor)}return{update:a,dispose:o}}var $v={[ja]:"LINEAR_TONE_MAPPING",[Qa]:"REINHARD_TONE_MAPPING",[to]:"CINEON_TONE_MAPPING",[Is]:"ACES_FILMIC_TONE_MAPPING",[io]:"AGX_TONE_MAPPING",[no]:"NEUTRAL_TONE_MAPPING",[eo]:"CUSTOM_TONE_MAPPING"};function Yv(n,t,e,i,s,r){let a=new ke(t,e,{type:n,depthBuffer:s,stencilBuffer:r,samples:i?4:0,storeMultisampledDepthBuffer:!1,storeMultisampledStencilBuffer:!1,resolveDepthBuffer:!1,resolveStencilBuffer:!1}),o=null,c=null,l=new ge;l.setAttribute("position",new qt([-1,3,0,-1,-1,0,3,-1,0],3)),l.setAttribute("uv",new qt([0,2,0,0,2,0],2));let h=new Er({uniforms:{tDiffuse:{value:null}},vertexShader:`
			precision highp float;

			uniform mat4 modelViewMatrix;
			uniform mat4 projectionMatrix;

			attribute vec3 position;
			attribute vec2 uv;

			varying vec2 vUv;

			void main() {
				vUv = uv;
				gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
			}`,fragmentShader:`
			precision highp float;

			uniform sampler2D tDiffuse;

			varying vec2 vUv;

			#include <tonemapping_pars_fragment>
			#include <colorspace_pars_fragment>

			void main() {
				gl_FragColor = texture2D( tDiffuse, vUv );

				#ifdef LINEAR_TONE_MAPPING
					gl_FragColor.rgb = LinearToneMapping( gl_FragColor.rgb );
				#elif defined( REINHARD_TONE_MAPPING )
					gl_FragColor.rgb = ReinhardToneMapping( gl_FragColor.rgb );
				#elif defined( CINEON_TONE_MAPPING )
					gl_FragColor.rgb = CineonToneMapping( gl_FragColor.rgb );
				#elif defined( ACES_FILMIC_TONE_MAPPING )
					gl_FragColor.rgb = ACESFilmicToneMapping( gl_FragColor.rgb );
				#elif defined( AGX_TONE_MAPPING )
					gl_FragColor.rgb = AgXToneMapping( gl_FragColor.rgb );
				#elif defined( NEUTRAL_TONE_MAPPING )
					gl_FragColor.rgb = NeutralToneMapping( gl_FragColor.rgb );
				#elif defined( CUSTOM_TONE_MAPPING )
					gl_FragColor.rgb = CustomToneMapping( gl_FragColor.rgb );
				#endif

				#ifdef SRGB_TRANSFER
					gl_FragColor = sRGBTransferOETF( gl_FragColor );
				#endif
			}`,depthTest:!1,depthWrite:!1}),u=new Pt(l,h),d=new ss(-1,1,1,-1,0,1),f=null,p=null,x=!1,m,g=null,_=[],T=!1;this.setSize=function(v,S){a.setSize(v,S),o!==null&&o.setSize(v,S),c!==null&&c.setSize(v,S);for(let M=0;M<_.length;M++){let A=_[M];A.setSize&&A.setSize(v,S)}},this.setEffects=function(v){_=v,T=_.length>0&&_[0].isRenderPass===!0;let S=a.width,M=a.height;_.length>0&&o===null&&(o=new ke(S,M,{type:qe,depthBuffer:!1,stencilBuffer:!1}),c=new ke(S,M,{type:qe,depthBuffer:!1,stencilBuffer:!1}));for(let A=0;A<_.length;A++){let y=_[A];y.setSize&&y.setSize(S,M)}},this.begin=function(v,S){if(x||v.toneMapping===ln&&_.length===0)return!1;if(g=S,S!==null){let M=S.width,A=S.height;(a.width!==M||a.height!==A)&&this.setSize(M,A)}return T===!1&&v.setRenderTarget(a),m=v.toneMapping,v.toneMapping=ln,!0},this.hasRenderPass=function(){return T},this.end=function(v,S){v.toneMapping=m,x=!0;let M=a,A=o;for(let y=0;y<_.length;y++){let E=_[y];E.enabled!==!1&&(E.render(v,A,M,S),E.needsSwap!==!1&&(M=A,A=A===o?c:o))}if(f!==v.outputColorSpace||p!==v.toneMapping){f=v.outputColorSpace,p=v.toneMapping,h.defines={},he.getTransfer(f)===_e&&(h.defines.SRGB_TRANSFER="");let y=$v[p];y&&(h.defines[y]=""),h.needsUpdate=!0}h.uniforms.tDiffuse.value=M.texture,v.setRenderTarget(g),v.render(u,d),g=null,x=!1},this.isCompositing=function(){return x},this.dispose=function(){a.dispose(),o!==null&&o.dispose(),c!==null&&c.dispose(),l.dispose(),h.dispose()}}var up=new wi,cd=new jn(1,1),dp=new Sa,fp=new El,pp=new Da,q0=[],$0=[],Y0=new Float32Array(16),Z0=new Float32Array(9),J0=new Float32Array(4);function zr(n,t,e){let i=n[0];if(i<=0||i>0)return n;let s=t*e,r=q0[s];if(r===void 0&&(r=new Float32Array(s),q0[s]=r),t!==0){i.toArray(r,0);for(let a=1,o=0;a!==t;++a)o+=e,n[a].toArray(r,o)}return r}function si(n,t){if(n.length!==t.length)return!1;for(let e=0,i=n.length;e<i;e++)if(n[e]!==t[e])return!1;return!0}function ri(n,t){for(let e=0,i=t.length;e<i;e++)n[e]=t[e]}function Wc(n,t){let e=$0[t];e===void 0&&(e=new Int32Array(t),$0[t]=e);for(let i=0;i!==t;++i)e[i]=n.allocateTextureUnit();return e}function Zv(n,t){let e=this.cache;e[0]!==t&&(n.uniform1f(this.addr,t),e[0]=t)}function Jv(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2f(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(si(e,t))return;n.uniform2fv(this.addr,t),ri(e,t)}}function Kv(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3f(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else if(t.r!==void 0)(e[0]!==t.r||e[1]!==t.g||e[2]!==t.b)&&(n.uniform3f(this.addr,t.r,t.g,t.b),e[0]=t.r,e[1]=t.g,e[2]=t.b);else{if(si(e,t))return;n.uniform3fv(this.addr,t),ri(e,t)}}function jv(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4f(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(si(e,t))return;n.uniform4fv(this.addr,t),ri(e,t)}}function Qv(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(si(e,t))return;n.uniformMatrix2fv(this.addr,!1,t),ri(e,t)}else{if(si(e,i))return;J0.set(i),n.uniformMatrix2fv(this.addr,!1,J0),ri(e,i)}}function ty(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(si(e,t))return;n.uniformMatrix3fv(this.addr,!1,t),ri(e,t)}else{if(si(e,i))return;Z0.set(i),n.uniformMatrix3fv(this.addr,!1,Z0),ri(e,i)}}function ey(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(si(e,t))return;n.uniformMatrix4fv(this.addr,!1,t),ri(e,t)}else{if(si(e,i))return;Y0.set(i),n.uniformMatrix4fv(this.addr,!1,Y0),ri(e,i)}}function iy(n,t){let e=this.cache;e[0]!==t&&(n.uniform1i(this.addr,t),e[0]=t)}function ny(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2i(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(si(e,t))return;n.uniform2iv(this.addr,t),ri(e,t)}}function sy(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3i(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else{if(si(e,t))return;n.uniform3iv(this.addr,t),ri(e,t)}}function ry(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4i(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(si(e,t))return;n.uniform4iv(this.addr,t),ri(e,t)}}function ay(n,t){let e=this.cache;e[0]!==t&&(n.uniform1ui(this.addr,t),e[0]=t)}function oy(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2ui(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(si(e,t))return;n.uniform2uiv(this.addr,t),ri(e,t)}}function ly(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3ui(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else{if(si(e,t))return;n.uniform3uiv(this.addr,t),ri(e,t)}}function cy(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4ui(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(si(e,t))return;n.uniform4uiv(this.addr,t),ri(e,t)}}function hy(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s);let r;this.type===n.SAMPLER_2D_SHADOW?(cd.compareFunction=e.isReversedDepthBuffer()?kc:Oc,r=cd):r=up,e.setTexture2D(t||r,s)}function uy(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTexture3D(t||fp,s)}function dy(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTextureCube(t||pp,s)}function fy(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTexture2DArray(t||dp,s)}function py(n){switch(n){case 5126:return Zv;case 35664:return Jv;case 35665:return Kv;case 35666:return jv;case 35674:return Qv;case 35675:return ty;case 35676:return ey;case 5124:case 35670:return iy;case 35667:case 35671:return ny;case 35668:case 35672:return sy;case 35669:case 35673:return ry;case 5125:return ay;case 36294:return oy;case 36295:return ly;case 36296:return cy;case 35678:case 36198:case 36298:case 36306:case 35682:return hy;case 35679:case 36299:case 36307:return uy;case 35680:case 36300:case 36308:case 36293:return dy;case 36289:case 36303:case 36311:case 36292:return fy}}function my(n,t){n.uniform1fv(this.addr,t)}function gy(n,t){let e=zr(t,this.size,2);n.uniform2fv(this.addr,e)}function xy(n,t){let e=zr(t,this.size,3);n.uniform3fv(this.addr,e)}function vy(n,t){let e=zr(t,this.size,4);n.uniform4fv(this.addr,e)}function yy(n,t){let e=zr(t,this.size,4);n.uniformMatrix2fv(this.addr,!1,e)}function _y(n,t){let e=zr(t,this.size,9);n.uniformMatrix3fv(this.addr,!1,e)}function by(n,t){let e=zr(t,this.size,16);n.uniformMatrix4fv(this.addr,!1,e)}function My(n,t){n.uniform1iv(this.addr,t)}function Sy(n,t){n.uniform2iv(this.addr,t)}function wy(n,t){n.uniform3iv(this.addr,t)}function Ty(n,t){n.uniform4iv(this.addr,t)}function Ey(n,t){n.uniform1uiv(this.addr,t)}function Ay(n,t){n.uniform2uiv(this.addr,t)}function Ry(n,t){n.uniform3uiv(this.addr,t)}function Cy(n,t){n.uniform4uiv(this.addr,t)}function Py(n,t,e){let i=this.cache,s=t.length,r=Wc(e,s);si(i,r)||(n.uniform1iv(this.addr,r),ri(i,r));let a;this.type===n.SAMPLER_2D_SHADOW?a=cd:a=up;for(let o=0;o!==s;++o)e.setTexture2D(t[o]||a,r[o])}function Iy(n,t,e){let i=this.cache,s=t.length,r=Wc(e,s);si(i,r)||(n.uniform1iv(this.addr,r),ri(i,r));for(let a=0;a!==s;++a)e.setTexture3D(t[a]||fp,r[a])}function Ly(n,t,e){let i=this.cache,s=t.length,r=Wc(e,s);si(i,r)||(n.uniform1iv(this.addr,r),ri(i,r));for(let a=0;a!==s;++a)e.setTextureCube(t[a]||pp,r[a])}function Dy(n,t,e){let i=this.cache,s=t.length,r=Wc(e,s);si(i,r)||(n.uniform1iv(this.addr,r),ri(i,r));for(let a=0;a!==s;++a)e.setTexture2DArray(t[a]||dp,r[a])}function Ny(n){switch(n){case 5126:return my;case 35664:return gy;case 35665:return xy;case 35666:return vy;case 35674:return yy;case 35675:return _y;case 35676:return by;case 5124:case 35670:return My;case 35667:case 35671:return Sy;case 35668:case 35672:return wy;case 35669:case 35673:return Ty;case 5125:return Ey;case 36294:return Ay;case 36295:return Ry;case 36296:return Cy;case 35678:case 36198:case 36298:case 36306:case 35682:return Py;case 35679:case 36299:case 36307:return Iy;case 35680:case 36300:case 36308:case 36293:return Ly;case 36289:case 36303:case 36311:case 36292:return Dy}}var hd=class{constructor(t,e,i){this.id=t,this.addr=i,this.cache=[],this.type=e.type,this.setValue=py(e.type)}},ud=class{constructor(t,e,i){this.id=t,this.addr=i,this.cache=[],this.type=e.type,this.size=e.size,this.setValue=Ny(e.type)}},dd=class{constructor(t){this.id=t,this.seq=[],this.map={}}setValue(t,e,i){let s=this.seq;for(let r=0,a=s.length;r!==a;++r){let o=s[r];o.setValue(t,e[o.id],i)}}},od=/(\w+)(\])?(\[|\.)?/g;function K0(n,t){n.seq.push(t),n.map[t.id]=t}function Uy(n,t,e){let i=n.name,s=i.length;for(od.lastIndex=0;;){let r=od.exec(i),a=od.lastIndex,o=r[1],c=r[2]==="]",l=r[3];if(c&&(o=o|0),l===void 0||l==="["&&a+2===s){K0(e,l===void 0?new hd(o,n,t):new ud(o,n,t));break}else{let u=e.map[o];u===void 0&&(u=new dd(o),K0(e,u)),e=u}}}var Nr=class{constructor(t,e){this.seq=[],this.map={};let i=t.getProgramParameter(e,t.ACTIVE_UNIFORMS);for(let a=0;a<i;++a){let o=t.getActiveUniform(e,a),c=t.getUniformLocation(e,o.name);Uy(o,c,this)}let s=[],r=[];for(let a of this.seq)a.type===t.SAMPLER_2D_SHADOW||a.type===t.SAMPLER_CUBE_SHADOW||a.type===t.SAMPLER_2D_ARRAY_SHADOW?s.push(a):r.push(a);s.length>0&&(this.seq=s.concat(r))}setValue(t,e,i,s){let r=this.map[e];r!==void 0&&r.setValue(t,i,s)}setOptional(t,e,i){let s=e[i];s!==void 0&&this.setValue(t,i,s)}static upload(t,e,i,s){for(let r=0,a=e.length;r!==a;++r){let o=e[r],c=i[o.id];c.needsUpdate!==!1&&o.setValue(t,c.value,s)}}static seqWithValue(t,e){let i=[];for(let s=0,r=t.length;s!==r;++s){let a=t[s];a.id in e&&i.push(a)}return i}};function j0(n,t,e){let i=n.createShader(t);return n.shaderSource(i,e),n.compileShader(i),i}var Fy=37297,zy=0;function Oy(n,t){let e=n.split(`
`),i=[],s=Math.max(t-6,0),r=Math.min(t+6,e.length);for(let a=s;a<r;a++){let o=a+1;i.push(`${o===t?">":" "} ${o}: ${e[a]}`)}return i.join(`
`)}var Q0=new ie;function ky(n){he._getMatrix(Q0,he.workingColorSpace,n);let t=`mat3( ${Q0.elements.map(e=>e.toFixed(4))} )`;switch(he.getTransfer(n)){case _a:return[t,"LinearTransferOETF"];case _e:return[t,"sRGBTransferOETF"];default:return te("WebGLProgram: Unsupported color space: ",n),[t,"LinearTransferOETF"]}}function tp(n,t,e){let i=n.getShaderParameter(t,n.COMPILE_STATUS),r=(n.getShaderInfoLog(t)||"").trim();if(i&&r==="")return"";let a=/ERROR: 0:(\d+)/.exec(r);if(a){let o=parseInt(a[1]);return e.toUpperCase()+`

`+r+`

`+Oy(n.getShaderSource(t),o)}else return r}function By(n,t){let e=ky(t);return[`vec4 ${n}( vec4 value ) {`,`	return ${e[1]}( vec4( value.rgb * ${e[0]}, value.a ) );`,"}"].join(`
`)}var Hy={[ja]:"Linear",[Qa]:"Reinhard",[to]:"Cineon",[Is]:"ACESFilmic",[io]:"AgX",[no]:"Neutral",[eo]:"Custom"};function Gy(n,t){let e=Hy[t];return e===void 0?(te("WebGLProgram: Unsupported toneMapping:",t),"vec3 "+n+"( vec3 color ) { return LinearToneMapping( color ); }"):"vec3 "+n+"( vec3 color ) { return "+e+"ToneMapping( color ); }"}var Hc=new D;function Vy(){he.getLuminanceCoefficients(Hc);let n=Hc.x.toFixed(4),t=Hc.y.toFixed(4),e=Hc.z.toFixed(4);return["float luminance( const in vec3 rgb ) {",`	const vec3 weights = vec3( ${n}, ${t}, ${e} );`,"	return dot( weights, rgb );","}"].join(`
`)}function Wy(n){return[n.extensionClipCullDistance?"#extension GL_ANGLE_clip_cull_distance : require":"",n.extensionMultiDraw?"#extension GL_ANGLE_multi_draw : require":""].filter(xo).join(`
`)}function Xy(n){let t=[];for(let e in n){let i=n[e];i!==!1&&t.push("#define "+e+" "+i)}return t.join(`
`)}function qy(n,t){let e={},i=n.getProgramParameter(t,n.ACTIVE_ATTRIBUTES);for(let s=0;s<i;s++){let r=n.getActiveAttrib(t,s),a=r.name,o=1;r.type===n.FLOAT_MAT2&&(o=2),r.type===n.FLOAT_MAT3&&(o=3),r.type===n.FLOAT_MAT4&&(o=4),e[a]={type:r.type,location:n.getAttribLocation(t,a),locationSize:o}}return e}function xo(n){return n!==""}function ep(n,t){let e=t.numSpotLightShadows+t.numSpotLightMaps-t.numSpotLightShadowsWithMaps;return n.replace(/NUM_SUN_LIGHTS/g,t.numSunLights).replace(/NUM_DIR_LIGHTS/g,t.numDirLights).replace(/NUM_SPOT_LIGHTS/g,t.numSpotLights).replace(/NUM_SPOT_LIGHT_MAPS/g,t.numSpotLightMaps).replace(/NUM_SPOT_LIGHT_COORDS/g,e).replace(/NUM_RECT_AREA_LIGHTS/g,t.numRectAreaLights).replace(/NUM_POINT_LIGHTS/g,t.numPointLights).replace(/NUM_HEMI_LIGHTS/g,t.numHemiLights).replace(/NUM_SUN_LIGHT_SHADOWS/g,t.numSunLightShadows).replace(/NUM_DIR_LIGHT_SHADOWS/g,t.numDirLightShadows).replace(/NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS/g,t.numSpotLightShadowsWithMaps).replace(/NUM_SPOT_LIGHT_SHADOWS/g,t.numSpotLightShadows).replace(/NUM_POINT_LIGHT_SHADOWS/g,t.numPointLightShadows)}function ip(n,t){return n.replace(/NUM_CLIPPING_PLANES/g,t.numClippingPlanes).replace(/UNION_CLIPPING_PLANES/g,t.numClippingPlanes-t.numClipIntersection)}var $y=/^[ \t]*#include +<([\w\d./]+)>/gm;function fd(n){return n.replace($y,Zy)}var Yy=new Map;function Zy(n,t){let e=le[t];if(e===void 0){let i=Yy.get(t);if(i!==void 0)e=le[i],te('WebGLRenderer: Shader chunk "%s" has been deprecated. Use "%s" instead.',t,i);else throw new Error("THREE.WebGLProgram: Can not resolve #include <"+t+">")}return fd(e)}var Jy=/#pragma unroll_loop_start\s+for\s*\(\s*int\s+i\s*=\s*(\d+)\s*;\s*i\s*<\s*(\d+)\s*;\s*i\s*\+\+\s*\)\s*{([\s\S]+?)}\s+#pragma unroll_loop_end/g;function np(n){return n.replace(Jy,Ky)}function Ky(n,t,e,i){let s="";for(let r=parseInt(t);r<parseInt(e);r++)s+=i.replace(/\[\s*i\s*\]/g,"[ "+r+" ]").replace(/UNROLLED_LOOP_INDEX/g,r);return s}function sp(n){let t=`precision ${n.precision} float;
	precision ${n.precision} int;
	precision ${n.precision} sampler2D;
	precision ${n.precision} samplerCube;
	precision ${n.precision} sampler3D;
	precision ${n.precision} sampler2DArray;
	precision ${n.precision} sampler2DShadow;
	precision ${n.precision} samplerCubeShadow;
	precision ${n.precision} sampler2DArrayShadow;
	precision ${n.precision} isampler2D;
	precision ${n.precision} isampler3D;
	precision ${n.precision} isamplerCube;
	precision ${n.precision} isampler2DArray;
	precision ${n.precision} usampler2D;
	precision ${n.precision} usampler3D;
	precision ${n.precision} usamplerCube;
	precision ${n.precision} usampler2DArray;
	`;return n.precision==="highp"?t+=`
#define HIGH_PRECISION`:n.precision==="mediump"?t+=`
#define MEDIUM_PRECISION`:n.precision==="lowp"&&(t+=`
#define LOW_PRECISION`),t}var jy={[Cs]:"SHADOWMAP_TYPE_PCF",[Cr]:"SHADOWMAP_TYPE_VSM"};function Qy(n){return jy[n.shadowMapType]||"SHADOWMAP_TYPE_BASIC"}var t_={[os]:"ENVMAP_TYPE_CUBE",[Ls]:"ENVMAP_TYPE_CUBE",[so]:"ENVMAP_TYPE_CUBE_UV"};function e_(n){return n.envMap===!1?"ENVMAP_TYPE_CUBE":t_[n.envMapMode]||"ENVMAP_TYPE_CUBE"}var i_={[Ls]:"ENVMAP_MODE_REFRACTION"};function n_(n){return n.envMap===!1?"ENVMAP_MODE_REFLECTION":i_[n.envMapMode]||"ENVMAP_MODE_REFLECTION"}var s_={[Kl]:"ENVMAP_BLENDING_MULTIPLY",[v0]:"ENVMAP_BLENDING_MIX",[y0]:"ENVMAP_BLENDING_ADD"};function r_(n){return n.envMap===!1?"ENVMAP_BLENDING_NONE":s_[n.combine]||"ENVMAP_BLENDING_NONE"}function a_(n){let t=n.envMapCubeUVHeight;if(t===null)return null;let e=Math.log2(t)-2,i=1/t;return{texelWidth:1/(3*Math.max(Math.pow(2,e),112)),texelHeight:i,maxMip:e}}function o_(n,t,e,i){let s=n.getContext(),r=e.defines,a=e.vertexShader,o=e.fragmentShader,c=Qy(e),l=e_(e),h=n_(e),u=r_(e),d=a_(e),f=Wy(e),p=Xy(r),x=s.createProgram(),m,g,_=e.glslVersion?"#version "+e.glslVersion+`
`:"";e.isRawShaderMaterial?(m=["#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,p].filter(xo).join(`
`),m.length>0&&(m+=`
`),g=["#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,p].filter(xo).join(`
`),g.length>0&&(g+=`
`)):(m=[sp(e),"#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,p,e.extensionClipCullDistance?"#define USE_CLIP_DISTANCE":"",e.batching?"#define USE_BATCHING":"",e.batchingColor?"#define USE_BATCHING_COLOR":"",e.instancing?"#define USE_INSTANCING":"",e.instancingColor?"#define USE_INSTANCING_COLOR":"",e.instancingMorph?"#define USE_INSTANCING_MORPH":"",e.useFog&&e.fog?"#define USE_FOG":"",e.useFog&&e.fogExp2?"#define FOG_EXP2":"",e.map?"#define USE_MAP":"",e.envMap?"#define USE_ENVMAP":"",e.envMap?"#define "+h:"",e.lightMap?"#define USE_LIGHTMAP":"",e.aoMap?"#define USE_AOMAP":"",e.bumpMap?"#define USE_BUMPMAP":"",e.normalMap?"#define USE_NORMALMAP":"",e.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",e.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",e.displacementMap?"#define USE_DISPLACEMENTMAP":"",e.emissiveMap?"#define USE_EMISSIVEMAP":"",e.anisotropy?"#define USE_ANISOTROPY":"",e.anisotropyMap?"#define USE_ANISOTROPYMAP":"",e.clearcoatMap?"#define USE_CLEARCOATMAP":"",e.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",e.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",e.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",e.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",e.specularMap?"#define USE_SPECULARMAP":"",e.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",e.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",e.roughnessMap?"#define USE_ROUGHNESSMAP":"",e.metalnessMap?"#define USE_METALNESSMAP":"",e.alphaMap?"#define USE_ALPHAMAP":"",e.alphaHash?"#define USE_ALPHAHASH":"",e.transmission?"#define USE_TRANSMISSION":"",e.transmissionMap?"#define USE_TRANSMISSIONMAP":"",e.thicknessMap?"#define USE_THICKNESSMAP":"",e.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",e.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",e.mapUv?"#define MAP_UV "+e.mapUv:"",e.alphaMapUv?"#define ALPHAMAP_UV "+e.alphaMapUv:"",e.lightMapUv?"#define LIGHTMAP_UV "+e.lightMapUv:"",e.aoMapUv?"#define AOMAP_UV "+e.aoMapUv:"",e.emissiveMapUv?"#define EMISSIVEMAP_UV "+e.emissiveMapUv:"",e.bumpMapUv?"#define BUMPMAP_UV "+e.bumpMapUv:"",e.normalMapUv?"#define NORMALMAP_UV "+e.normalMapUv:"",e.displacementMapUv?"#define DISPLACEMENTMAP_UV "+e.displacementMapUv:"",e.metalnessMapUv?"#define METALNESSMAP_UV "+e.metalnessMapUv:"",e.roughnessMapUv?"#define ROUGHNESSMAP_UV "+e.roughnessMapUv:"",e.anisotropyMapUv?"#define ANISOTROPYMAP_UV "+e.anisotropyMapUv:"",e.clearcoatMapUv?"#define CLEARCOATMAP_UV "+e.clearcoatMapUv:"",e.clearcoatNormalMapUv?"#define CLEARCOAT_NORMALMAP_UV "+e.clearcoatNormalMapUv:"",e.clearcoatRoughnessMapUv?"#define CLEARCOAT_ROUGHNESSMAP_UV "+e.clearcoatRoughnessMapUv:"",e.iridescenceMapUv?"#define IRIDESCENCEMAP_UV "+e.iridescenceMapUv:"",e.iridescenceThicknessMapUv?"#define IRIDESCENCE_THICKNESSMAP_UV "+e.iridescenceThicknessMapUv:"",e.sheenColorMapUv?"#define SHEEN_COLORMAP_UV "+e.sheenColorMapUv:"",e.sheenRoughnessMapUv?"#define SHEEN_ROUGHNESSMAP_UV "+e.sheenRoughnessMapUv:"",e.specularMapUv?"#define SPECULARMAP_UV "+e.specularMapUv:"",e.specularColorMapUv?"#define SPECULAR_COLORMAP_UV "+e.specularColorMapUv:"",e.specularIntensityMapUv?"#define SPECULAR_INTENSITYMAP_UV "+e.specularIntensityMapUv:"",e.transmissionMapUv?"#define TRANSMISSIONMAP_UV "+e.transmissionMapUv:"",e.thicknessMapUv?"#define THICKNESSMAP_UV "+e.thicknessMapUv:"",e.vertexTangents&&e.flatShading===!1?"#define USE_TANGENT":"",e.vertexNormals?"#define HAS_NORMAL":"",e.vertexColors?"#define USE_COLOR":"",e.vertexAlphas?"#define USE_COLOR_ALPHA":"",e.vertexUv1s?"#define USE_UV1":"",e.vertexUv2s?"#define USE_UV2":"",e.vertexUv3s?"#define USE_UV3":"",e.pointsUvs?"#define USE_POINTS_UV":"",e.flatShading?"#define FLAT_SHADED":"",e.skinning?"#define USE_SKINNING":"",e.morphTargets?"#define USE_MORPHTARGETS":"",e.morphNormals&&e.flatShading===!1?"#define USE_MORPHNORMALS":"",e.morphColors?"#define USE_MORPHCOLORS":"",e.morphTargetsCount>0?"#define MORPHTARGETS_TEXTURE_STRIDE "+e.morphTextureStride:"",e.morphTargetsCount>0?"#define MORPHTARGETS_COUNT "+e.morphTargetsCount:"",e.doubleSided?"#define DOUBLE_SIDED":"",e.flipSided?"#define FLIP_SIDED":"",e.shadowMapEnabled?"#define USE_SHADOWMAP":"",e.shadowMapEnabled?"#define "+c:"",e.sizeAttenuation?"#define USE_SIZEATTENUATION":"",e.numLightProbes>0?"#define USE_LIGHT_PROBES":"",e.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",e.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 modelMatrix;","uniform mat4 modelViewMatrix;","uniform mat4 projectionMatrix;","uniform mat4 viewMatrix;","uniform mat3 normalMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;","#ifdef USE_INSTANCING","	attribute mat4 instanceMatrix;","#endif","#ifdef USE_INSTANCING_COLOR","	attribute vec3 instanceColor;","#endif","#ifdef USE_INSTANCING_MORPH","	uniform sampler2D morphTexture;","#endif","attribute vec3 position;","attribute vec3 normal;","attribute vec2 uv;","#ifdef USE_UV1","	attribute vec2 uv1;","#endif","#ifdef USE_UV2","	attribute vec2 uv2;","#endif","#ifdef USE_UV3","	attribute vec2 uv3;","#endif","#ifdef USE_TANGENT","	attribute vec4 tangent;","#endif","#if defined( USE_COLOR_ALPHA )","	attribute vec4 color;","#elif defined( USE_COLOR )","	attribute vec3 color;","#endif","#ifdef USE_SKINNING","	attribute vec4 skinIndex;","	attribute vec4 skinWeight;","#endif",`
`].filter(xo).join(`
`),g=[sp(e),"#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,p,e.useFog&&e.fog?"#define USE_FOG":"",e.useFog&&e.fogExp2?"#define FOG_EXP2":"",e.alphaToCoverage?"#define ALPHA_TO_COVERAGE":"",e.map?"#define USE_MAP":"",e.matcap?"#define USE_MATCAP":"",e.envMap?"#define USE_ENVMAP":"",e.envMap?"#define "+l:"",e.envMap?"#define "+h:"",e.envMap?"#define "+u:"",d?"#define CUBEUV_TEXEL_WIDTH "+d.texelWidth:"",d?"#define CUBEUV_TEXEL_HEIGHT "+d.texelHeight:"",d?"#define CUBEUV_MAX_MIP "+d.maxMip+".0":"",e.lightMap?"#define USE_LIGHTMAP":"",e.aoMap?"#define USE_AOMAP":"",e.bumpMap?"#define USE_BUMPMAP":"",e.normalMap?"#define USE_NORMALMAP":"",e.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",e.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",e.packedNormalMap?"#define USE_PACKED_NORMALMAP":"",e.emissiveMap?"#define USE_EMISSIVEMAP":"",e.anisotropy?"#define USE_ANISOTROPY":"",e.anisotropyMap?"#define USE_ANISOTROPYMAP":"",e.clearcoat?"#define USE_CLEARCOAT":"",e.clearcoatMap?"#define USE_CLEARCOATMAP":"",e.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",e.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",e.dispersion?"#define USE_DISPERSION":"",e.retroreflection?"#define USE_RETROREFLECTION":"",e.iridescence?"#define USE_IRIDESCENCE":"",e.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",e.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",e.specularMap?"#define USE_SPECULARMAP":"",e.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",e.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",e.roughnessMap?"#define USE_ROUGHNESSMAP":"",e.metalnessMap?"#define USE_METALNESSMAP":"",e.alphaMap?"#define USE_ALPHAMAP":"",e.alphaTest?"#define USE_ALPHATEST":"",e.alphaHash?"#define USE_ALPHAHASH":"",e.sheen?"#define USE_SHEEN":"",e.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",e.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",e.transmission?"#define USE_TRANSMISSION":"",e.transmissionMap?"#define USE_TRANSMISSIONMAP":"",e.thicknessMap?"#define USE_THICKNESSMAP":"",e.vertexTangents&&e.flatShading===!1?"#define USE_TANGENT":"",e.vertexColors||e.instancingColor?"#define USE_COLOR":"",e.vertexAlphas||e.batchingColor?"#define USE_COLOR_ALPHA":"",e.vertexUv1s?"#define USE_UV1":"",e.vertexUv2s?"#define USE_UV2":"",e.vertexUv3s?"#define USE_UV3":"",e.pointsUvs?"#define USE_POINTS_UV":"",e.gradientMap?"#define USE_GRADIENTMAP":"",e.flatShading?"#define FLAT_SHADED":"",e.doubleSided?"#define DOUBLE_SIDED":"",e.flipSided?"#define FLIP_SIDED":"",e.shadowMapEnabled?"#define USE_SHADOWMAP":"",e.shadowMapEnabled?"#define "+c:"",e.premultipliedAlpha?"#define PREMULTIPLIED_ALPHA":"",e.numLightProbes>0?"#define USE_LIGHT_PROBES":"",e.numLightProbeGrids>0?"#define USE_LIGHT_PROBES_GRID":"",e.decodeVideoTexture?"#define DECODE_VIDEO_TEXTURE":"",e.decodeVideoTextureEmissive?"#define DECODE_VIDEO_TEXTURE_EMISSIVE":"",e.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",e.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 viewMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;",e.toneMapping!==ln?"#define TONE_MAPPING":"",e.toneMapping!==ln?le.tonemapping_pars_fragment:"",e.toneMapping!==ln?Gy("toneMapping",e.toneMapping):"",e.dithering?"#define DITHERING":"",e.opaque?"#define OPAQUE":"",le.colorspace_pars_fragment,By("linearToOutputTexel",e.outputColorSpace),Vy(),e.useDepthPacking?"#define DEPTH_PACKING "+e.depthPacking:"",`
`].filter(xo).join(`
`)),a=fd(a),a=ep(a,e),a=ip(a,e),o=fd(o),o=ep(o,e),o=ip(o,e),a=np(a),o=np(o),e.isRawShaderMaterial!==!0&&(_=`#version 300 es
`,m=[f,"#define attribute in","#define varying out","#define texture2D texture"].join(`
`)+`
`+m,g=["#define varying in",e.glslVersion===Wu?"":"layout(location = 0) out highp vec4 pc_fragColor;",e.glslVersion===Wu?"":"#define gl_FragColor pc_fragColor","#define gl_FragDepthEXT gl_FragDepth","#define texture2D texture","#define textureCube texture","#define texture2DProj textureProj","#define texture2DLodEXT textureLod","#define texture2DProjLodEXT textureProjLod","#define textureCubeLodEXT textureLod","#define texture2DGradEXT textureGrad","#define texture2DProjGradEXT textureProjGrad","#define textureCubeGradEXT textureGrad"].join(`
`)+`
`+g);let T=_+m+a,v=_+g+o,S=j0(s,s.VERTEX_SHADER,T),M=j0(s,s.FRAGMENT_SHADER,v);s.attachShader(x,S),s.attachShader(x,M),e.index0AttributeName!==void 0?s.bindAttribLocation(x,0,e.index0AttributeName):e.hasPositionAttribute===!0&&s.bindAttribLocation(x,0,"position"),s.linkProgram(x);function A(N){if(n.debug.checkShaderErrors){let F=s.getProgramInfoLog(x)||"",B=s.getShaderInfoLog(S)||"",I=s.getShaderInfoLog(M)||"",H=F.trim(),W=B.trim(),U=I.trim(),X=!0,G=!0;if(s.getProgramParameter(x,s.LINK_STATUS)===!1)if(X=!1,typeof n.debug.onShaderError=="function")n.debug.onShaderError(s,x,S,M);else{let j=tp(s,S,"vertex"),et=tp(s,M,"fragment");ee("WebGLProgram: Shader Error "+s.getError()+" - VALIDATE_STATUS "+s.getProgramParameter(x,s.VALIDATE_STATUS)+`

Material Name: `+N.name+`
Material Type: `+N.type+`

Program Info Log: `+H+`
`+j+`
`+et)}else H!==""?te("WebGLProgram: Program Info Log:",H):(W===""||U==="")&&(G=!1);G&&(N.diagnostics={runnable:X,programLog:H,vertexShader:{log:W,prefix:m},fragmentShader:{log:U,prefix:g}})}s.deleteShader(S),s.deleteShader(M),y=new Nr(s,x),E=qy(s,x)}let y;this.getUniforms=function(){return y===void 0&&A(this),y};let E;this.getAttributes=function(){return E===void 0&&A(this),E};let P=e.rendererExtensionParallelShaderCompile===!1;return this.isReady=function(){return P===!1&&(P=s.getProgramParameter(x,Fy)),P},this.destroy=function(){i.releaseStatesOfProgram(this),s.deleteProgram(x),this.program=void 0},this.type=e.shaderType,this.name=e.shaderName,this.id=zy++,this.cacheKey=t,this.usedTimes=1,this.program=x,this.vertexShader=S,this.fragmentShader=M,this}var l_=0,pd=class{constructor(){this.shaderCache=new Map,this.materialCache=new Map}update(t,e,i){let s=this._getShaderCacheForMaterial(t);return s.has(e)===!1&&(s.add(e),e.usedTimes++),s.has(i)===!1&&(s.add(i),i.usedTimes++),this}remove(t){let e=this.materialCache.get(t);for(let i of e)i.usedTimes--,i.usedTimes===0&&this.shaderCache.delete(i.code);return this.materialCache.delete(t),this}getVertexShaderStage(t){return this._getShaderStage(t.vertexShader)}getFragmentShaderStage(t){return this._getShaderStage(t.fragmentShader)}dispose(){this.shaderCache.clear(),this.materialCache.clear()}_getShaderCacheForMaterial(t){let e=this.materialCache,i=e.get(t);return i===void 0&&(i=new Set,e.set(t,i)),i}_getShaderStage(t){let e=this.shaderCache,i=e.get(t);return i===void 0&&(i=new md(t),e.set(t,i)),i}},md=class{constructor(t){this.id=l_++,this.code=t,this.usedTimes=0}};function c_(n){return n===cs||n===ho||n===uo}function h_(n,t,e,i,s,r){let a=new fr,o=new pd,c=new Set,l=[],h=new Map,u=i.logarithmicDepthBuffer,d=i.precision,f={MeshDepthMaterial:"depth",MeshDistanceMaterial:"distance",MeshNormalMaterial:"normal",MeshBasicMaterial:"basic",MeshLambertMaterial:"lambert",MeshPhongMaterial:"phong",MeshToonMaterial:"toon",MeshStandardMaterial:"physical",MeshPhysicalMaterial:"physical",MeshMatcapMaterial:"matcap",LineBasicMaterial:"basic",LineDashedMaterial:"dashed",PointsMaterial:"points",ShadowMaterial:"shadow",SpriteMaterial:"sprite"};function p(y){return c.add(y),y===0?"uv":`uv${y}`}function x(y,E,P,N,F,B){let I=N.fog,H=F.geometry,W=y.isMeshStandardMaterial||y.isMeshLambertMaterial||y.isMeshPhongMaterial?N.environment:null,U=y.isMeshStandardMaterial||y.isMeshLambertMaterial&&!y.envMap||y.isMeshPhongMaterial&&!y.envMap,X=t.get(y.envMap||W,U),G=X&&X.mapping===so?X.image.height:null,j=f[y.type];y.precision!==null&&(d=i.getMaxPrecision(y.precision),d!==y.precision&&te("WebGLProgram.getParameters:",y.precision,"not supported, using",d,"instead."));let et=H.morphAttributes.position||H.morphAttributes.normal||H.morphAttributes.color,vt=et!==void 0?et.length:0,ht=0;H.morphAttributes.position!==void 0&&(ht=1),H.morphAttributes.normal!==void 0&&(ht=2),H.morphAttributes.color!==void 0&&(ht=3);let Ut,$t,Kt,$;if(j){let De=Sn[j];Ut=De.vertexShader,$t=De.fragmentShader}else{Ut=y.vertexShader,$t=y.fragmentShader;let De=o.getVertexShaderStage(y),Me=o.getFragmentShaderStage(y);o.update(y,De,Me),Kt=De.id,$=Me.id}let rt=n.getRenderTarget(),_t=n.state.buffers.depth.getReversed(),Jt=F.isInstancedMesh===!0,At=F.isBatchedMesh===!0,Yt=!!y.map,fe=!!y.matcap,at=!!X,ut=!!y.aoMap,pt=!!y.lightMap,mt=!!y.bumpMap&&y.wireframe===!1,w=!!y.normalMap,J=!!y.displacementMap,Q=!!y.emissiveMap,st=!!y.metalnessMap,nt=!!y.roughnessMap,L=y.anisotropy>0,yt=y.clearcoat>0,zt=y.dispersion>0,C=y.retroreflectivity>0,b=y.iridescence>0,O=y.sheen>0,V=y.transmission>0,K=L&&!!y.anisotropyMap,gt=yt&&!!y.clearcoatMap,xt=yt&&!!y.clearcoatNormalMap,it=yt&&!!y.clearcoatRoughnessMap,ct=b&&!!y.iridescenceMap,wt=b&&!!y.iridescenceThicknessMap,kt=O&&!!y.sheenColorMap,Mt=O&&!!y.sheenRoughnessMap,bt=!!y.specularMap,Bt=!!y.specularColorMap,jt=!!y.specularIntensityMap,ne=V&&!!y.transmissionMap,k=V&&!!y.thicknessMap,Tt=!!y.gradientMap,lt=!!y.alphaMap,Et=y.alphaTest>0,Dt=!!y.alphaHash,ft=!!y.extensions,Zt=ln;y.toneMapped&&(rt===null||rt.isXRRenderTarget===!0)&&(Zt=n.toneMapping);let Wt={shaderID:j,shaderType:y.type,shaderName:y.name,vertexShader:Ut,fragmentShader:$t,defines:y.defines,customVertexShaderID:Kt,customFragmentShaderID:$,isRawShaderMaterial:y.isRawShaderMaterial===!0,glslVersion:y.glslVersion,precision:d,batching:At,batchingColor:At&&F._colorsTexture!==null,instancing:Jt,instancingColor:Jt&&F.instanceColor!==null,instancingMorph:Jt&&F.morphTexture!==null,outputColorSpace:rt===null?n.outputColorSpace:rt.isXRRenderTarget===!0?rt.texture.colorSpace:he.workingColorSpace,alphaToCoverage:!!y.alphaToCoverage,map:Yt,matcap:fe,envMap:at,envMapMode:at&&X.mapping,envMapCubeUVHeight:G,aoMap:ut,lightMap:pt,bumpMap:mt,normalMap:w,displacementMap:J,emissiveMap:Q,normalMapObjectSpace:w&&y.normalMapType===M0,normalMapTangentSpace:w&&y.normalMapType===fo,packedNormalMap:w&&y.normalMapType===fo&&c_(y.normalMap.format),metalnessMap:st,roughnessMap:nt,anisotropy:L,anisotropyMap:K,clearcoat:yt,clearcoatMap:gt,clearcoatNormalMap:xt,clearcoatRoughnessMap:it,dispersion:zt,retroreflection:C,iridescence:b,iridescenceMap:ct,iridescenceThicknessMap:wt,sheen:O,sheenColorMap:kt,sheenRoughnessMap:Mt,specularMap:bt,specularColorMap:Bt,specularIntensityMap:jt,transmission:V,transmissionMap:ne,thicknessMap:k,gradientMap:Tt,opaque:y.transparent===!1&&y.blending===as&&y.alphaToCoverage===!1,alphaMap:lt,alphaTest:Et,alphaHash:Dt,combine:y.combine,mapUv:Yt&&p(y.map.channel),aoMapUv:ut&&p(y.aoMap.channel),lightMapUv:pt&&p(y.lightMap.channel),bumpMapUv:mt&&p(y.bumpMap.channel),normalMapUv:w&&p(y.normalMap.channel),displacementMapUv:J&&p(y.displacementMap.channel),emissiveMapUv:Q&&p(y.emissiveMap.channel),metalnessMapUv:st&&p(y.metalnessMap.channel),roughnessMapUv:nt&&p(y.roughnessMap.channel),anisotropyMapUv:K&&p(y.anisotropyMap.channel),clearcoatMapUv:gt&&p(y.clearcoatMap.channel),clearcoatNormalMapUv:xt&&p(y.clearcoatNormalMap.channel),clearcoatRoughnessMapUv:it&&p(y.clearcoatRoughnessMap.channel),iridescenceMapUv:ct&&p(y.iridescenceMap.channel),iridescenceThicknessMapUv:wt&&p(y.iridescenceThicknessMap.channel),sheenColorMapUv:kt&&p(y.sheenColorMap.channel),sheenRoughnessMapUv:Mt&&p(y.sheenRoughnessMap.channel),specularMapUv:bt&&p(y.specularMap.channel),specularColorMapUv:Bt&&p(y.specularColorMap.channel),specularIntensityMapUv:jt&&p(y.specularIntensityMap.channel),transmissionMapUv:ne&&p(y.transmissionMap.channel),thicknessMapUv:k&&p(y.thicknessMap.channel),alphaMapUv:lt&&p(y.alphaMap.channel),vertexTangents:!!H.attributes.tangent&&(w||L),vertexNormals:!!H.attributes.normal,vertexColors:y.vertexColors,vertexAlphas:y.vertexColors===!0&&!!H.attributes.color&&H.attributes.color.itemSize===4,pointsUvs:F.isPoints===!0&&!!H.attributes.uv&&(Yt||lt),fog:!!I,useFog:y.fog===!0,fogExp2:!!I&&I.isFogExp2,flatShading:y.wireframe===!1&&(y.flatShading===!0||H.attributes.normal===void 0&&w===!1&&(y.isMeshLambertMaterial||y.isMeshPhongMaterial||y.isMeshStandardMaterial||y.isMeshPhysicalMaterial)),sizeAttenuation:y.sizeAttenuation===!0,logarithmicDepthBuffer:u,reversedDepthBuffer:_t,skinning:F.isSkinnedMesh===!0,hasPositionAttribute:H.attributes.position!==void 0,morphTargets:H.morphAttributes.position!==void 0,morphNormals:H.morphAttributes.normal!==void 0,morphColors:H.morphAttributes.color!==void 0,morphTargetsCount:vt,morphTextureStride:ht,numSunLights:E.sun.length,numDirLights:E.directional.length,numPointLights:E.point.length,numSpotLights:E.spot.length,numSpotLightMaps:E.spotLightMap.length,numRectAreaLights:E.rectArea.length,numHemiLights:E.hemi.length,numSunLightShadows:E.sunShadowMap.length,numDirLightShadows:E.directionalShadowMap.length,numPointLightShadows:E.pointShadowMap.length,numSpotLightShadows:E.spotShadowMap.length,numSpotLightShadowsWithMaps:E.numSpotLightShadowsWithMaps,numLightProbes:E.numLightProbes,numLightProbeGrids:B.length,numClippingPlanes:r.numPlanes,numClipIntersection:r.numIntersection,dithering:y.dithering,shadowMapEnabled:n.shadowMap.enabled&&P.length>0,shadowMapType:n.shadowMap.type,toneMapping:Zt,decodeVideoTexture:Yt&&y.map.isVideoTexture===!0&&he.getTransfer(y.map.colorSpace)===_e,decodeVideoTextureEmissive:Q&&y.emissiveMap.isVideoTexture===!0&&he.getTransfer(y.emissiveMap.colorSpace)===_e,premultipliedAlpha:y.premultipliedAlpha,doubleSided:y.side===Re,flipSided:y.side===di,useDepthPacking:y.depthPacking>=0,depthPacking:y.depthPacking||0,index0AttributeName:y.index0AttributeName,extensionClipCullDistance:ft&&y.extensions.clipCullDistance===!0&&e.has("WEBGL_clip_cull_distance"),extensionMultiDraw:(ft&&y.extensions.multiDraw===!0||At)&&e.has("WEBGL_multi_draw"),rendererExtensionParallelShaderCompile:e.has("KHR_parallel_shader_compile"),customProgramCacheKey:y.customProgramCacheKey()};return Wt.vertexUv1s=c.has(1),Wt.vertexUv2s=c.has(2),Wt.vertexUv3s=c.has(3),c.clear(),Wt}function m(y){let E=[];if(y.shaderID?E.push(y.shaderID):(E.push(y.customVertexShaderID),E.push(y.customFragmentShaderID)),y.defines!==void 0)for(let P in y.defines)E.push(P),E.push(y.defines[P]);return y.isRawShaderMaterial===!1&&(g(E,y),_(E,y),E.push(n.outputColorSpace)),E.push(y.customProgramCacheKey),E.join()}function g(y,E){y.push(E.precision),y.push(E.outputColorSpace),y.push(E.envMapMode),y.push(E.envMapCubeUVHeight),y.push(E.mapUv),y.push(E.alphaMapUv),y.push(E.lightMapUv),y.push(E.aoMapUv),y.push(E.bumpMapUv),y.push(E.normalMapUv),y.push(E.displacementMapUv),y.push(E.emissiveMapUv),y.push(E.metalnessMapUv),y.push(E.roughnessMapUv),y.push(E.anisotropyMapUv),y.push(E.clearcoatMapUv),y.push(E.clearcoatNormalMapUv),y.push(E.clearcoatRoughnessMapUv),y.push(E.iridescenceMapUv),y.push(E.iridescenceThicknessMapUv),y.push(E.sheenColorMapUv),y.push(E.sheenRoughnessMapUv),y.push(E.specularMapUv),y.push(E.specularColorMapUv),y.push(E.specularIntensityMapUv),y.push(E.transmissionMapUv),y.push(E.thicknessMapUv),y.push(E.combine),y.push(E.fogExp2),y.push(E.sizeAttenuation),y.push(E.morphTargetsCount),y.push(E.morphAttributeCount),y.push(E.numSunLights),y.push(E.numDirLights),y.push(E.numPointLights),y.push(E.numSpotLights),y.push(E.numSpotLightMaps),y.push(E.numHemiLights),y.push(E.numRectAreaLights),y.push(E.numSunLightShadows),y.push(E.numDirLightShadows),y.push(E.numPointLightShadows),y.push(E.numSpotLightShadows),y.push(E.numSpotLightShadowsWithMaps),y.push(E.numLightProbes),y.push(E.shadowMapType),y.push(E.toneMapping),y.push(E.numClippingPlanes),y.push(E.numClipIntersection),y.push(E.depthPacking)}function _(y,E){a.disableAll(),E.instancing&&a.enable(0),E.instancingColor&&a.enable(1),E.instancingMorph&&a.enable(2),E.matcap&&a.enable(3),E.envMap&&a.enable(4),E.normalMapObjectSpace&&a.enable(5),E.normalMapTangentSpace&&a.enable(6),E.clearcoat&&a.enable(7),E.iridescence&&a.enable(8),E.alphaTest&&a.enable(9),E.vertexColors&&a.enable(10),E.vertexAlphas&&a.enable(11),E.vertexUv1s&&a.enable(12),E.vertexUv2s&&a.enable(13),E.vertexUv3s&&a.enable(14),E.vertexTangents&&a.enable(15),E.anisotropy&&a.enable(16),E.alphaHash&&a.enable(17),E.batching&&a.enable(18),E.dispersion&&a.enable(19),E.retroreflection&&a.enable(24),E.batchingColor&&a.enable(20),E.gradientMap&&a.enable(21),E.packedNormalMap&&a.enable(22),E.vertexNormals&&a.enable(23),y.push(a.mask),a.disableAll(),E.fog&&a.enable(0),E.useFog&&a.enable(1),E.flatShading&&a.enable(2),E.logarithmicDepthBuffer&&a.enable(3),E.reversedDepthBuffer&&a.enable(4),E.skinning&&a.enable(5),E.morphTargets&&a.enable(6),E.morphNormals&&a.enable(7),E.morphColors&&a.enable(8),E.premultipliedAlpha&&a.enable(9),E.shadowMapEnabled&&a.enable(10),E.doubleSided&&a.enable(11),E.flipSided&&a.enable(12),E.useDepthPacking&&a.enable(13),E.dithering&&a.enable(14),E.transmission&&a.enable(15),E.sheen&&a.enable(16),E.opaque&&a.enable(17),E.pointsUvs&&a.enable(18),E.decodeVideoTexture&&a.enable(19),E.decodeVideoTextureEmissive&&a.enable(20),E.alphaToCoverage&&a.enable(21),E.numLightProbeGrids>0&&a.enable(22),E.hasPositionAttribute&&a.enable(23),y.push(a.mask)}function T(y){let E=f[y.type],P;if(E){let N=Sn[E];P=Un.clone(N.uniforms)}else P=y.uniforms;return P}function v(y,E){let P=h.get(E);return P!==void 0?++P.usedTimes:(P=new o_(n,E,y,s),l.push(P),h.set(E,P)),P}function S(y){if(--y.usedTimes===0){let E=l.indexOf(y);l[E]=l[l.length-1],l.pop(),h.delete(y.cacheKey),y.destroy()}}function M(y){o.remove(y)}function A(){o.dispose()}return{getParameters:x,getProgramCacheKey:m,getUniforms:T,acquireProgram:v,releaseProgram:S,releaseShaderCache:M,programs:l,dispose:A}}function u_(){let n=new WeakMap;function t(a){return n.has(a)}function e(a){let o=n.get(a);return o===void 0&&(o={},n.set(a,o)),o}function i(a){n.delete(a)}function s(a,o,c){n.get(a)[o]=c}function r(){n=new WeakMap}return{has:t,get:e,remove:i,update:s,dispose:r}}function d_(n,t){return n.groupOrder!==t.groupOrder?n.groupOrder-t.groupOrder:n.renderOrder!==t.renderOrder?n.renderOrder-t.renderOrder:n.material.id!==t.material.id?n.material.id-t.material.id:n.materialVariant!==t.materialVariant?n.materialVariant-t.materialVariant:n.z!==t.z?n.z-t.z:n.id-t.id}function rp(n,t){return n.groupOrder!==t.groupOrder?n.groupOrder-t.groupOrder:n.renderOrder!==t.renderOrder?n.renderOrder-t.renderOrder:n.z!==t.z?t.z-n.z:n.id-t.id}function ap(){let n=[],t=0,e=[],i=[],s=[];function r(){t=0,e.length=0,i.length=0,s.length=0}function a(d){let f=0;return d.isInstancedMesh&&(f+=2),d.isSkinnedMesh&&(f+=1),f}function o(d,f,p,x,m,g){let _=n[t];return _===void 0?(_={id:d.id,object:d,geometry:f,material:p,materialVariant:a(d),groupOrder:x,renderOrder:d.renderOrder,z:m,group:g},n[t]=_):(_.id=d.id,_.object=d,_.geometry=f,_.material=p,_.materialVariant=a(d),_.groupOrder=x,_.renderOrder=d.renderOrder,_.z=m,_.group=g),t++,_}function c(d,f,p,x,m,g,_){_.reversedDepth===!0&&(m=-m);let T=o(d,f,p,x,m,g);p.transmission>0?i.push(T):p.transparent===!0?s.push(T):e.push(T)}function l(d,f,p,x,m,g){let _=o(d,f,p,x,m,g);p.transmission>0?i.unshift(_):p.transparent===!0?s.unshift(_):e.unshift(_)}function h(d,f){e.length>1&&e.sort(d||d_),i.length>1&&i.sort(f||rp),s.length>1&&s.sort(f||rp)}function u(){for(let d=t,f=n.length;d<f;d++){let p=n[d];if(p.id===null)break;p.id=null,p.object=null,p.geometry=null,p.material=null,p.group=null}}return{opaque:e,transmissive:i,transparent:s,init:r,push:c,unshift:l,finish:u,sort:h}}function f_(){let n=new WeakMap;function t(i,s){let r=n.get(i),a;return r===void 0?(a=new ap,n.set(i,[a])):s>=r.length?(a=new ap,r.push(a)):a=r[s],a}function e(){n=new WeakMap}return{get:t,dispose:e}}function p_(){let n={};return{get:function(t){if(n[t.id]!==void 0)return n[t.id];let e;switch(t.type){case"SunLight":case"DirectionalLight":e={direction:new D,color:new Nt};break;case"SpotLight":e={position:new D,direction:new D,color:new Nt,distance:0,coneCos:0,penumbraCos:0,decay:0};break;case"PointLight":e={position:new D,color:new Nt,distance:0,decay:0};break;case"HemisphereLight":e={direction:new D,skyColor:new Nt,groundColor:new Nt};break;case"RectAreaLight":e={color:new Nt,position:new D,halfWidth:new D,halfHeight:new D};break}return n[t.id]=e,e}}}function m_(){let n={};return{get:function(t){if(n[t.id]!==void 0)return n[t.id];let e;switch(t.type){case"SunLight":case"DirectionalLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new ot};break;case"SpotLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new ot};break;case"PointLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new ot,shadowCameraNear:1,shadowCameraFar:1e3};break}return n[t.id]=e,e}}}var g_=0;function x_(n,t){return(t.castShadow?2:0)-(n.castShadow?2:0)+(t.map?1:0)-(n.map?1:0)}function v_(n){let t=new p_,e=m_(),i={version:0,hash:{sunLength:-1,directionalLength:-1,pointLength:-1,spotLength:-1,rectAreaLength:-1,hemiLength:-1,numSunShadows:-1,numDirectionalShadows:-1,numPointShadows:-1,numSpotShadows:-1,numSpotMaps:-1,numLightProbes:-1},ambient:[0,0,0],probe:[],sun:[],sunShadow:[],sunShadowMap:[],sunShadowMatrix:[],sunShadowCascade:[],directional:[],directionalShadow:[],directionalShadowMap:[],directionalShadowMatrix:[],spot:[],spotLightMap:[],spotShadow:[],spotShadowMap:[],spotLightMatrix:[],rectArea:[],rectAreaLTC1:null,rectAreaLTC2:null,point:[],pointShadow:[],pointShadowMap:[],pointShadowMatrix:[],hemi:[],numSpotLightShadowsWithMaps:0,numLightProbes:0};for(let l=0;l<9;l++)i.probe.push(new D);let s=new D,r=new me,a=new me;function o(l){let h=0,u=0,d=0;for(let F=0;F<9;F++)i.probe[F].set(0,0,0);let f=0,p=0,x=0,m=0,g=0,_=0,T=0,v=0,S=0,M=0,A=0,y=0,E=0,P=0;l.sort(x_);for(let F=0,B=l.length;F<B;F++){let I=l[F],H=I.color,W=I.intensity,U=I.distance,X=null;if(I.shadow&&I.shadow.map&&(I.shadow.map.texture.format===cs?X=I.shadow.map.texture:X=I.shadow.map.depthTexture||I.shadow.map.texture),I.isAmbientLight)h+=H.r*W,u+=H.g*W,d+=H.b*W;else if(I.isLightProbe){for(let G=0;G<9;G++)i.probe[G].addScaledVector(I.sh.coefficients[G],W);P++}else if(I.isSunLight){let G=t.get(I);if(G.color.copy(I.color).multiplyScalar(I.intensity),I.castShadow){let j=I.shadow,et=e.get(I);et.shadowIntensity=j.intensity,et.shadowBias=j.bias,et.shadowNormalBias=j.normalBias,et.shadowRadius=j.radius,et.shadowMapSize.copy(j.mapSize).multiply(j.getFrameExtents()),i.sunShadow[p]=et,i.sunShadowMap[p]=X;let vt=j.getViewportCount();for(let ht=0;ht<vt;ht++)i.sunShadowMatrix[x+ht]=j.getMatrix(ht),i.sunShadowCascade[x+ht]=j._cascadeData[ht];x+=vt,p++}i.sun[f]=G,f++}else if(I.isDirectionalLight){let G=t.get(I);if(G.color.copy(I.color).multiplyScalar(I.intensity),I.castShadow){let j=I.shadow,et=e.get(I);et.shadowIntensity=j.intensity,et.shadowBias=j.bias,et.shadowNormalBias=j.normalBias,et.shadowRadius=j.radius,et.shadowMapSize=j.mapSize,i.directionalShadow[m]=et,i.directionalShadowMap[m]=X,i.directionalShadowMatrix[m]=I.shadow.matrix,S++}i.directional[m]=G,m++}else if(I.isSpotLight){let G=t.get(I);G.position.setFromMatrixPosition(I.matrixWorld),G.color.copy(H).multiplyScalar(W),G.distance=U,G.coneCos=Math.cos(I.angle),G.penumbraCos=Math.cos(I.angle*(1-I.penumbra)),G.decay=I.decay,i.spot[_]=G;let j=I.shadow;if(I.map&&(i.spotLightMap[y]=I.map,y++,j.updateMatrices(I),I.castShadow&&E++),i.spotLightMatrix[_]=j.matrix,I.castShadow){let et=e.get(I);et.shadowIntensity=j.intensity,et.shadowBias=j.bias,et.shadowNormalBias=j.normalBias,et.shadowRadius=j.radius,et.shadowMapSize=j.mapSize,i.spotShadow[_]=et,i.spotShadowMap[_]=X,A++}_++}else if(I.isRectAreaLight){let G=t.get(I);G.color.copy(H).multiplyScalar(W),G.halfWidth.set(I.width*.5,0,0),G.halfHeight.set(0,I.height*.5,0),i.rectArea[T]=G,T++}else if(I.isPointLight){let G=t.get(I);if(G.color.copy(I.color).multiplyScalar(I.intensity),G.distance=I.distance,G.decay=I.decay,I.castShadow){let j=I.shadow,et=e.get(I);et.shadowIntensity=j.intensity,et.shadowBias=j.bias,et.shadowNormalBias=j.normalBias,et.shadowRadius=j.radius,et.shadowMapSize=j.mapSize,et.shadowCameraNear=j.camera.near,et.shadowCameraFar=j.camera.far,i.pointShadow[g]=et,i.pointShadowMap[g]=X,i.pointShadowMatrix[g]=I.shadow.matrix,M++}i.point[g]=G,g++}else if(I.isHemisphereLight){let G=t.get(I);G.skyColor.copy(I.color).multiplyScalar(W),G.groundColor.copy(I.groundColor).multiplyScalar(W),i.hemi[v]=G,v++}}T>0&&(n.has("OES_texture_float_linear")===!0?(i.rectAreaLTC1=Rt.LTC_FLOAT_1,i.rectAreaLTC2=Rt.LTC_FLOAT_2):(i.rectAreaLTC1=Rt.LTC_HALF_1,i.rectAreaLTC2=Rt.LTC_HALF_2)),i.ambient[0]=h,i.ambient[1]=u,i.ambient[2]=d;let N=i.hash;(N.sunLength!==f||N.directionalLength!==m||N.pointLength!==g||N.spotLength!==_||N.rectAreaLength!==T||N.hemiLength!==v||N.numSunShadows!==p||N.numDirectionalShadows!==S||N.numPointShadows!==M||N.numSpotShadows!==A||N.numSpotMaps!==y||N.numLightProbes!==P)&&(i.sun.length=f,i.directional.length=m,i.spot.length=_,i.rectArea.length=T,i.point.length=g,i.hemi.length=v,i.sunShadow.length=p,i.sunShadowMap.length=p,i.sunShadowMatrix.length=x,i.sunShadowCascade.length=x,i.directionalShadow.length=S,i.directionalShadowMap.length=S,i.directionalShadowMatrix.length=S,i.pointShadow.length=M,i.pointShadowMap.length=M,i.pointShadowMatrix.length=M,i.spotShadow.length=A,i.spotShadowMap.length=A,i.spotLightMatrix.length=A+y-E,i.spotLightMap.length=y,i.numSpotLightShadowsWithMaps=E,i.numLightProbes=P,N.sunLength=f,N.directionalLength=m,N.pointLength=g,N.spotLength=_,N.rectAreaLength=T,N.hemiLength=v,N.numSunShadows=p,N.numDirectionalShadows=S,N.numPointShadows=M,N.numSpotShadows=A,N.numSpotMaps=y,N.numLightProbes=P,i.version=g_++)}function c(l,h){let u=0,d=0,f=0,p=0,x=0,m=0,g=h.matrixWorldInverse;for(let _=0,T=l.length;_<T;_++){let v=l[_];if(v.isSunLight){let S=i.sun[u];S.direction.setFromMatrixPosition(v.matrixWorld),S.direction.transformDirection(g),u++}else if(v.isDirectionalLight){let S=i.directional[d];S.direction.setFromMatrixPosition(v.matrixWorld),s.setFromMatrixPosition(v.target.matrixWorld),S.direction.sub(s),S.direction.transformDirection(g),d++}else if(v.isSpotLight){let S=i.spot[p];S.position.setFromMatrixPosition(v.matrixWorld),S.position.applyMatrix4(g),S.direction.setFromMatrixPosition(v.matrixWorld),s.setFromMatrixPosition(v.target.matrixWorld),S.direction.sub(s),S.direction.transformDirection(g),p++}else if(v.isRectAreaLight){let S=i.rectArea[x];S.position.setFromMatrixPosition(v.matrixWorld),S.position.applyMatrix4(g),a.identity(),r.copy(v.matrixWorld),r.premultiply(g),a.extractRotation(r),S.halfWidth.set(v.width*.5,0,0),S.halfHeight.set(0,v.height*.5,0),S.halfWidth.applyMatrix4(a),S.halfHeight.applyMatrix4(a),x++}else if(v.isPointLight){let S=i.point[f];S.position.setFromMatrixPosition(v.matrixWorld),S.position.applyMatrix4(g),f++}else if(v.isHemisphereLight){let S=i.hemi[m];S.direction.setFromMatrixPosition(v.matrixWorld),S.direction.transformDirection(g),m++}}}return{setup:o,setupView:c,state:i}}function op(n){let t=new v_(n),e=[],i=[],s=[];function r(d){u.camera=d,e.length=0,i.length=0,s.length=0}function a(d){e.push(d)}function o(d){i.push(d)}function c(d){s.push(d)}function l(){t.setup(e)}function h(d){t.setupView(e,d)}let u={lightsArray:e,shadowsArray:i,lightProbeGridArray:s,camera:null,lights:t,transmissionRenderTarget:{},textureUnits:0};return{init:r,state:u,setupLights:l,setupLightsView:h,pushLight:a,pushShadow:o,pushLightProbeGrid:c}}function y_(n){let t=new WeakMap;function e(s,r=0){let a=t.get(s),o;return a===void 0?(o=new op(n),t.set(s,[o])):r>=a.length?(o=new op(n),a.push(o)):o=a[r],o}function i(){t=new WeakMap}return{get:e,dispose:i}}var __=`void main() {
	gl_Position = vec4( position, 1.0 );
}`,b_=`uniform sampler2D shadow_pass;
uniform vec2 resolution;
uniform float radius;
void main() {
	const float samples = float( VSM_SAMPLES );
	float mean = 0.0;
	float squared_mean = 0.0;
	float uvStride = samples <= 1.0 ? 0.0 : 2.0 / ( samples - 1.0 );
	float uvStart = samples <= 1.0 ? 0.0 : - 1.0;
	for ( float i = 0.0; i < samples; i ++ ) {
		float uvOffset = uvStart + i * uvStride;
		#ifdef HORIZONTAL_PASS
			vec2 distribution = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( uvOffset, 0.0 ) * radius ) / resolution ).rg;
			mean += distribution.x;
			squared_mean += distribution.y * distribution.y + distribution.x * distribution.x;
		#else
			float depth = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( 0.0, uvOffset ) * radius ) / resolution ).r;
			mean += depth;
			squared_mean += depth * depth;
		#endif
	}
	mean = mean / samples;
	squared_mean = squared_mean / samples;
	float std_dev = sqrt( max( 0.0, squared_mean - mean * mean ) );
	gl_FragColor = vec4( mean, std_dev, 0.0, 1.0 );
}`,M_=[new D(1,0,0),new D(-1,0,0),new D(0,1,0),new D(0,-1,0),new D(0,0,1),new D(0,0,-1)],S_=[new D(0,-1,0),new D(0,-1,0),new D(0,0,1),new D(0,0,-1),new D(0,-1,0),new D(0,-1,0)],lp=new me,go=new D,ld=new D;function w_(n,t,e){let i=new vr,s=new ot,r=new ot,a=new Le,o=new zl,c=new Ol,l={},h=e.maxTextureSize,u={[rs]:di,[di]:rs,[Re]:Re},d=new ze({defines:{VSM_SAMPLES:8},uniforms:{shadow_pass:{value:null},resolution:{value:new ot},radius:{value:4}},vertexShader:__,fragmentShader:b_}),f=d.clone();f.defines.HORIZONTAL_PASS=1;let p=new ge;p.setAttribute("position",new ti(new Float32Array([-1,-1,.5,3,-1,.5,-1,3,.5]),3));let x=new Pt(p,d),m=this;this.enabled=!1,this.autoUpdate=!0,this.needsUpdate=!1,this.type=Cs;let g=this.type;this.render=function(M,A,y){if(m.enabled===!1||m.autoUpdate===!1&&m.needsUpdate===!1||M.length===0)return;this.type===Qf&&(te("WebGLShadowMap: PCFSoftShadowMap has been removed. Using PCFShadowMap instead."),this.type=Cs);let E=n.getRenderTarget(),P=n.getActiveCubeFace(),N=n.getActiveMipmapLevel(),F=n.state;F.setBlending(Yi),F.buffers.depth.getReversed()===!0?F.buffers.color.setClear(0,0,0,0):F.buffers.color.setClear(1,1,1,1),F.buffers.depth.setTest(!0),F.setScissorTest(!1);let B=g!==this.type;B&&A.traverse(function(I){I.material&&(Array.isArray(I.material)?I.material.forEach(H=>H.needsUpdate=!0):I.material.needsUpdate=!0)});for(let I=0,H=M.length;I<H;I++){let W=M[I],U=W.shadow;if(U===void 0){te("WebGLShadowMap:",W,"has no shadow.");continue}if(U.autoUpdate===!1&&U.needsUpdate===!1)continue;s.copy(U.mapSize);let X=U.getFrameExtents();s.multiply(X),r.copy(U.mapSize),(s.x>h||s.y>h)&&(s.x>h&&(r.x=Math.floor(h/X.x),s.x=r.x*X.x,U.mapSize.x=r.x),s.y>h&&(r.y=Math.floor(h/X.y),s.y=r.y*X.y,U.mapSize.y=r.y));let G=n.state.buffers.depth.getReversed();if(U.camera._reversedDepth=G,U.map===null||B===!0){if(U.map!==null&&(U.map.depthTexture!==null&&(U.map.depthTexture.dispose(),U.map.depthTexture=null),U.map.dispose()),this.type===Cr){if(W.isPointLight){te("WebGLShadowMap: VSM shadow maps are not supported for PointLights. Use PCF or BasicShadowMap instead.");continue}U.map=new ke(s.x,s.y,{format:cs,type:qe,minFilter:Ye,magFilter:Ye,generateMipmaps:!1}),U.map.texture.name=W.name+".shadowMap",U.map.depthTexture=new jn(s.x,s.y,Zi),U.map.depthTexture.name=W.name+".shadowMapDepth",U.map.depthTexture.format=vn,U.map.depthTexture.compareFunction=null,U.map.depthTexture.minFilter=oi,U.map.depthTexture.magFilter=oi}else W.isPointLight?(U.map=new Fr(s.x),U.map.depthTexture=new Il(s.x,cn)):(U.map=new ke(s.x,s.y),U.map.depthTexture=new jn(s.x,s.y,cn)),U.map.depthTexture.name=W.name+".shadowMap",U.map.depthTexture.format=vn,this.type===Cs?(U.map.depthTexture.compareFunction=G?kc:Oc,U.map.depthTexture.minFilter=Ye,U.map.depthTexture.magFilter=Ye):(U.map.depthTexture.compareFunction=null,U.map.depthTexture.minFilter=oi,U.map.depthTexture.magFilter=oi);U.camera.updateProjectionMatrix()}U.map.isWebGLCubeRenderTarget!==!0&&(U.map.width!==s.x||U.map.height!==s.y)&&U.map.setSize(s.x,s.y);let j=U.map.isWebGLCubeRenderTarget?6:U.getViewportCount();W.isPointLight!==!0&&U.updateMatrices(W,y);for(let et=0;et<j;et++){let vt=U.getCamera(et);if(W.isPointLight){let ht=U.camera,Ut=U.matrix,$t=W.distance||ht.far;$t!==ht.far&&(ht.far=$t,ht.updateProjectionMatrix()),go.setFromMatrixPosition(W.matrixWorld),ht.position.copy(go),ld.copy(ht.position),ld.add(M_[et]),ht.up.copy(S_[et]),ht.lookAt(ld),ht.updateMatrixWorld(),Ut.makeTranslation(-go.x,-go.y,-go.z),lp.multiplyMatrices(ht.projectionMatrix,ht.matrixWorldInverse),U._frustum.setFromProjectionMatrix(lp,ht.coordinateSystem,ht.reversedDepth)}if(U.map.isWebGLCubeRenderTarget)n.setRenderTarget(U.map,et),n.clear();else{et===0&&(n.setRenderTarget(U.map),n.clear());let ht=U.getViewport(et);a.set(r.x*ht.x,r.y*ht.y,r.x*ht.z,r.y*ht.w),F.viewport(a)}i=U.getFrustum(et),v(A,y,vt,W,this.type)}U.isPointLightShadow!==!0&&this.type===Cr&&_(U,y),U.needsUpdate=!1}g=this.type,m.needsUpdate=!1,n.setRenderTarget(E,P,N)};function _(M,A){let y=t.update(x);d.defines.VSM_SAMPLES!==M.blurSamples&&(d.defines.VSM_SAMPLES=M.blurSamples,f.defines.VSM_SAMPLES=M.blurSamples,d.needsUpdate=!0,f.needsUpdate=!0),M.mapPass===null?M.mapPass=new ke(s.x,s.y,{format:cs,type:qe}):(M.mapPass.width!==M.map.width||M.mapPass.height!==M.map.height)&&M.mapPass.setSize(M.map.width,M.map.height),d.uniforms.shadow_pass.value=M.map.depthTexture,d.uniforms.resolution.value.set(M.map.width,M.map.height),d.uniforms.radius.value=M.radius,n.setRenderTarget(M.mapPass),n.clear(),n.renderBufferDirect(A,null,y,d,x,null),f.uniforms.shadow_pass.value=M.mapPass.texture,f.uniforms.resolution.value.set(M.map.width,M.map.height),f.uniforms.radius.value=M.radius,n.setRenderTarget(M.map),n.clear(),n.renderBufferDirect(A,null,y,f,x,null)}function T(M,A,y,E){let P=null,N=y.isPointLight===!0?M.customDistanceMaterial:M.customDepthMaterial;if(N!==void 0)P=N;else if(P=y.isPointLight===!0?c:o,n.localClippingEnabled&&A.clipShadows===!0&&Array.isArray(A.clippingPlanes)&&A.clippingPlanes.length!==0||A.displacementMap&&A.displacementScale!==0||A.alphaMap&&A.alphaTest>0||A.map&&A.alphaTest>0||A.alphaToCoverage===!0){let F=P.uuid,B=A.uuid,I=l[F];I===void 0&&(I={},l[F]=I);let H=I[B];H===void 0&&(H=P.clone(),I[B]=H,A.addEventListener("dispose",S)),P=H}if(P.visible=A.visible,P.wireframe=A.wireframe,E===Cr?P.side=A.shadowSide!==null?A.shadowSide:A.side:P.side=A.shadowSide!==null?A.shadowSide:u[A.side],P.alphaMap=A.alphaMap,P.alphaTest=A.alphaToCoverage===!0?.5:A.alphaTest,P.map=A.map,P.clipShadows=A.clipShadows,P.clippingPlanes=A.clippingPlanes,P.clipIntersection=A.clipIntersection,P.displacementMap=A.displacementMap,P.displacementScale=A.displacementScale,P.displacementBias=A.displacementBias,P.wireframeLinewidth=A.wireframeLinewidth,P.linewidth=A.linewidth,y.isPointLight===!0&&P.isMeshDistanceMaterial===!0){let F=n.properties.get(P);F.light=y}return P}function v(M,A,y,E,P){if(M.visible===!1)return;if(M.layers.test(A.layers)&&(M.isMesh||M.isLine||M.isPoints)&&(M.castShadow||M.receiveShadow&&P===Cr)&&(!M.frustumCulled||M.intersectsFrustum(i))){M.modelViewMatrix.multiplyMatrices(y.matrixWorldInverse,M.matrixWorld);let B=t.update(M),I=M.material;if(Array.isArray(I)){let H=B.groups;for(let W=0,U=H.length;W<U;W++){let X=H[W],G=I[X.materialIndex];if(G&&G.visible){let j=T(M,G,E,P);M.onBeforeShadow(n,M,A,y,B,j,X),n.renderBufferDirect(y,null,B,j,M,X),M.onAfterShadow(n,M,A,y,B,j,X)}}}else if(I.visible){let H=T(M,I,E,P);M.onBeforeShadow(n,M,A,y,B,H,null),n.renderBufferDirect(y,null,B,H,M,null),M.onAfterShadow(n,M,A,y,B,H,null)}}let F=M.children;for(let B=0,I=F.length;B<I;B++)v(F[B],A,y,E,P)}function S(M){M.target.removeEventListener("dispose",S);for(let y in l){let E=l[y],P=M.target.uuid;P in E&&(E[P].dispose(),delete E[P])}}}function T_(n,t){function e(){let k=!1,Tt=new Le,lt=null,Et=new Le(0,0,0,0);return{setMask:function(Dt){lt!==Dt&&!k&&(n.colorMask(Dt,Dt,Dt,Dt),lt=Dt)},setLocked:function(Dt){k=Dt},setClear:function(Dt,ft,Zt,Wt,De){De===!0&&(Dt*=Wt,ft*=Wt,Zt*=Wt),Tt.set(Dt,ft,Zt,Wt),Et.equals(Tt)===!1&&(n.clearColor(Dt,ft,Zt,Wt),Et.copy(Tt))},reset:function(){k=!1,lt=null,Et.set(-1,0,0,0)}}}function i(){let k=!1,Tt=!1,lt=null,Et=null,Dt=null;return{setReversed:function(ft){if(Tt!==ft){let Zt=t.get("EXT_clip_control");ft?Zt.clipControlEXT(Zt.LOWER_LEFT_EXT,Zt.ZERO_TO_ONE_EXT):Zt.clipControlEXT(Zt.LOWER_LEFT_EXT,Zt.NEGATIVE_ONE_TO_ONE_EXT),Tt=ft;let Wt=Dt;Dt=null,this.setClear(Wt)}},getReversed:function(){return Tt},setTest:function(ft){ft?rt(n.DEPTH_TEST):_t(n.DEPTH_TEST)},setMask:function(ft){lt!==ft&&!k&&(n.depthMask(ft),lt=ft)},setFunc:function(ft){if(Tt&&(ft=D0[ft]),Et!==ft){switch(ft){case gl:n.depthFunc(n.NEVER);break;case xl:n.depthFunc(n.ALWAYS);break;case vl:n.depthFunc(n.LESS);break;case or:n.depthFunc(n.LEQUAL);break;case yl:n.depthFunc(n.EQUAL);break;case _l:n.depthFunc(n.GEQUAL);break;case lr:n.depthFunc(n.GREATER);break;case bl:n.depthFunc(n.NOTEQUAL);break;default:n.depthFunc(n.LEQUAL)}Et=ft}},setLocked:function(ft){k=ft},setClear:function(ft){Dt!==ft&&(Dt=ft,Tt&&(ft=1-ft),n.clearDepth(ft))},reset:function(){k=!1,lt=null,Et=null,Dt=null,Tt=!1}}}function s(){let k=!1,Tt=null,lt=null,Et=null,Dt=null,ft=null,Zt=null,Wt=null,De=null;return{setTest:function(Me){k||(Me?rt(n.STENCIL_TEST):_t(n.STENCIL_TEST))},setMask:function(Me){Tt!==Me&&!k&&(n.stencilMask(Me),Tt=Me)},setFunc:function(Me,tn,fn){(lt!==Me||Et!==tn||Dt!==fn)&&(n.stencilFunc(Me,tn,fn),lt=Me,Et=tn,Dt=fn)},setOp:function(Me,tn,fn){(ft!==Me||Zt!==tn||Wt!==fn)&&(n.stencilOp(Me,tn,fn),ft=Me,Zt=tn,Wt=fn)},setLocked:function(Me){k=Me},setClear:function(Me){De!==Me&&(n.clearStencil(Me),De=Me)},reset:function(){k=!1,Tt=null,lt=null,Et=null,Dt=null,ft=null,Zt=null,Wt=null,De=null}}}let r=new e,a=new i,o=new s,c=new WeakMap,l=new WeakMap,h={},u={},d={},f=new WeakMap,p=[],x=null,m=!1,g=null,_=null,T=null,v=null,S=null,M=null,A=null,y=new Nt(0,0,0),E=0,P=!1,N=null,F=null,B=null,I=null,H=null,W=n.getParameter(n.MAX_COMBINED_TEXTURE_IMAGE_UNITS),U=!1,X=0,G=n.getParameter(n.VERSION);G.indexOf("WebGL")!==-1?(X=parseFloat(/^WebGL (\d)/.exec(G)[1]),U=X>=1):G.indexOf("OpenGL ES")!==-1&&(X=parseFloat(/^OpenGL ES (\d)/.exec(G)[1]),U=X>=2);let j=null,et={},vt=n.getParameter(n.SCISSOR_BOX),ht=n.getParameter(n.VIEWPORT),Ut=new Le().fromArray(vt),$t=new Le().fromArray(ht);function Kt(k,Tt,lt,Et){let Dt=new Uint8Array(4),ft=n.createTexture();n.bindTexture(k,ft),n.texParameteri(k,n.TEXTURE_MIN_FILTER,n.NEAREST),n.texParameteri(k,n.TEXTURE_MAG_FILTER,n.NEAREST);for(let Zt=0;Zt<lt;Zt++)k===n.TEXTURE_3D||k===n.TEXTURE_2D_ARRAY?n.texImage3D(Tt,0,n.RGBA,1,1,Et,0,n.RGBA,n.UNSIGNED_BYTE,Dt):n.texImage2D(Tt+Zt,0,n.RGBA,1,1,0,n.RGBA,n.UNSIGNED_BYTE,Dt);return ft}let $={};$[n.TEXTURE_2D]=Kt(n.TEXTURE_2D,n.TEXTURE_2D,1),$[n.TEXTURE_CUBE_MAP]=Kt(n.TEXTURE_CUBE_MAP,n.TEXTURE_CUBE_MAP_POSITIVE_X,6),$[n.TEXTURE_2D_ARRAY]=Kt(n.TEXTURE_2D_ARRAY,n.TEXTURE_2D_ARRAY,1,1),$[n.TEXTURE_3D]=Kt(n.TEXTURE_3D,n.TEXTURE_3D,1,1),r.setClear(0,0,0,1),a.setClear(1),o.setClear(0),rt(n.DEPTH_TEST),a.setFunc(or),mt(!1),w(Iu),rt(n.CULL_FACE),ut(Yi);function rt(k){h[k]!==!0&&(n.enable(k),h[k]=!0)}function _t(k){h[k]!==!1&&(n.disable(k),h[k]=!1)}function Jt(k,Tt){return d[k]!==Tt?(n.bindFramebuffer(k,Tt),d[k]=Tt,k===n.DRAW_FRAMEBUFFER&&(d[n.FRAMEBUFFER]=Tt),k===n.FRAMEBUFFER&&(d[n.DRAW_FRAMEBUFFER]=Tt),!0):!1}function At(k,Tt){let lt=p,Et=!1;if(k){lt=f.get(Tt),lt===void 0&&(lt=[],f.set(Tt,lt));let Dt=k.textures;if(lt.length!==Dt.length||lt[0]!==n.COLOR_ATTACHMENT0){for(let ft=0,Zt=Dt.length;ft<Zt;ft++)lt[ft]=n.COLOR_ATTACHMENT0+ft;lt.length=Dt.length,Et=!0}}else lt[0]!==n.BACK&&(lt[0]=n.BACK,Et=!0);Et&&n.drawBuffers(lt)}function Yt(k){return x!==k?(n.useProgram(k),x=k,!0):!1}let fe={[Ps]:n.FUNC_ADD,[e0]:n.FUNC_SUBTRACT,[i0]:n.FUNC_REVERSE_SUBTRACT};fe[n0]=n.MIN,fe[s0]=n.MAX;let at={[r0]:n.ZERO,[a0]:n.ONE,[o0]:n.SRC_COLOR,[Nu]:n.SRC_ALPHA,[f0]:n.SRC_ALPHA_SATURATE,[u0]:n.DST_COLOR,[c0]:n.DST_ALPHA,[l0]:n.ONE_MINUS_SRC_COLOR,[Uu]:n.ONE_MINUS_SRC_ALPHA,[d0]:n.ONE_MINUS_DST_COLOR,[h0]:n.ONE_MINUS_DST_ALPHA,[p0]:n.CONSTANT_COLOR,[m0]:n.ONE_MINUS_CONSTANT_COLOR,[g0]:n.CONSTANT_ALPHA,[x0]:n.ONE_MINUS_CONSTANT_ALPHA};function ut(k,Tt,lt,Et,Dt,ft,Zt,Wt,De,Me){if(k===Yi){m===!0&&(_t(n.BLEND),m=!1);return}if(m===!1&&(rt(n.BLEND),m=!0),k!==t0){if(k!==g||Me!==P){if((_!==Ps||S!==Ps)&&(n.blendEquation(n.FUNC_ADD),_=Ps,S=Ps),Me)switch(k){case as:n.blendFuncSeparate(n.ONE,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Xe:n.blendFunc(n.ONE,n.ONE);break;case Lu:n.blendFuncSeparate(n.ZERO,n.ONE_MINUS_SRC_COLOR,n.ZERO,n.ONE);break;case Du:n.blendFuncSeparate(n.DST_COLOR,n.ONE_MINUS_SRC_ALPHA,n.ZERO,n.ONE);break;default:ee("WebGLState: Invalid blending: ",k);break}else switch(k){case as:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Xe:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE,n.ONE,n.ONE);break;case Lu:ee("WebGLState: SubtractiveBlending requires material.premultipliedAlpha = true");break;case Du:ee("WebGLState: MultiplyBlending requires material.premultipliedAlpha = true");break;default:ee("WebGLState: Invalid blending: ",k);break}T=null,v=null,M=null,A=null,y.set(0,0,0),E=0,g=k,P=Me}return}Dt=Dt||Tt,ft=ft||lt,Zt=Zt||Et,(Tt!==_||Dt!==S)&&(n.blendEquationSeparate(fe[Tt],fe[Dt]),_=Tt,S=Dt),(lt!==T||Et!==v||ft!==M||Zt!==A)&&(n.blendFuncSeparate(at[lt],at[Et],at[ft],at[Zt]),T=lt,v=Et,M=ft,A=Zt),(Wt.equals(y)===!1||De!==E)&&(n.blendColor(Wt.r,Wt.g,Wt.b,De),y.copy(Wt),E=De),g=k,P=!1}function pt(k,Tt){k.side===Re?_t(n.CULL_FACE):rt(n.CULL_FACE);let lt=k.side===di;Tt&&(lt=!lt),mt(lt),k.blending===as&&k.transparent===!1?ut(Yi):ut(k.blending,k.blendEquation,k.blendSrc,k.blendDst,k.blendEquationAlpha,k.blendSrcAlpha,k.blendDstAlpha,k.blendColor,k.blendAlpha,k.premultipliedAlpha),a.setFunc(k.depthFunc),a.setTest(k.depthTest),a.setMask(k.depthWrite),r.setMask(k.colorWrite);let Et=k.stencilWrite;o.setTest(Et),Et&&(o.setMask(k.stencilWriteMask),o.setFunc(k.stencilFunc,k.stencilRef,k.stencilFuncMask),o.setOp(k.stencilFail,k.stencilZFail,k.stencilZPass)),Q(k.polygonOffset,k.polygonOffsetFactor,k.polygonOffsetUnits),k.alphaToCoverage===!0?rt(n.SAMPLE_ALPHA_TO_COVERAGE):_t(n.SAMPLE_ALPHA_TO_COVERAGE)}function mt(k){N!==k&&(k?n.frontFace(n.CW):n.frontFace(n.CCW),N=k)}function w(k){k!==Kf?(rt(n.CULL_FACE),k!==F&&(k===Iu?n.cullFace(n.BACK):k===jf?n.cullFace(n.FRONT):n.cullFace(n.FRONT_AND_BACK))):_t(n.CULL_FACE),F=k}function J(k){k!==B&&(U&&n.lineWidth(k),B=k)}function Q(k,Tt,lt){k?(rt(n.POLYGON_OFFSET_FILL),(I!==Tt||H!==lt)&&(I=Tt,H=lt,a.getReversed()&&(Tt=-Tt),n.polygonOffset(Tt,lt))):_t(n.POLYGON_OFFSET_FILL)}function st(k){k?rt(n.SCISSOR_TEST):_t(n.SCISSOR_TEST)}function nt(k){k===void 0&&(k=n.TEXTURE0+W-1),j!==k&&(n.activeTexture(k),j=k)}function L(k,Tt,lt){lt===void 0&&(j===null?lt=n.TEXTURE0+W-1:lt=j);let Et=et[lt];Et===void 0&&(Et={type:void 0,texture:void 0},et[lt]=Et),(Et.type!==k||Et.texture!==Tt)&&(j!==lt&&(n.activeTexture(lt),j=lt),n.bindTexture(k,Tt||$[k]),Et.type=k,Et.texture=Tt)}function yt(){let k=et[j];k!==void 0&&k.type!==void 0&&(n.bindTexture(k.type,null),k.type=void 0,k.texture=void 0)}function zt(){try{n.compressedTexImage2D(...arguments)}catch(k){ee("WebGLState:",k)}}function C(){try{n.compressedTexImage3D(...arguments)}catch(k){ee("WebGLState:",k)}}function b(){try{n.texSubImage2D(...arguments)}catch(k){ee("WebGLState:",k)}}function O(){try{n.texSubImage3D(...arguments)}catch(k){ee("WebGLState:",k)}}function V(){try{n.compressedTexSubImage2D(...arguments)}catch(k){ee("WebGLState:",k)}}function K(){try{n.compressedTexSubImage3D(...arguments)}catch(k){ee("WebGLState:",k)}}function gt(){try{n.texStorage2D(...arguments)}catch(k){ee("WebGLState:",k)}}function xt(){try{n.texStorage3D(...arguments)}catch(k){ee("WebGLState:",k)}}function it(){try{n.texImage2D(...arguments)}catch(k){ee("WebGLState:",k)}}function ct(){try{n.texImage3D(...arguments)}catch(k){ee("WebGLState:",k)}}function wt(k){return u[k]!==void 0?u[k]:n.getParameter(k)}function kt(k,Tt){u[k]!==Tt&&(n.pixelStorei(k,Tt),u[k]=Tt)}function Mt(k){Ut.equals(k)===!1&&(n.scissor(k.x,k.y,k.z,k.w),Ut.copy(k))}function bt(k){$t.equals(k)===!1&&(n.viewport(k.x,k.y,k.z,k.w),$t.copy(k))}function Bt(k,Tt){let lt=l.get(Tt);lt===void 0&&(lt=new WeakMap,l.set(Tt,lt));let Et=lt.get(k);Et===void 0&&(Et=n.getUniformBlockIndex(Tt,k.name),lt.set(k,Et))}function jt(k,Tt){let Et=l.get(Tt).get(k);c.get(Tt)!==Et&&(n.uniformBlockBinding(Tt,Et,k.__bindingPointIndex),c.set(Tt,Et))}function ne(){n.disable(n.BLEND),n.disable(n.CULL_FACE),n.disable(n.DEPTH_TEST),n.disable(n.POLYGON_OFFSET_FILL),n.disable(n.SCISSOR_TEST),n.disable(n.STENCIL_TEST),n.disable(n.SAMPLE_ALPHA_TO_COVERAGE),n.blendEquation(n.FUNC_ADD),n.blendFunc(n.ONE,n.ZERO),n.blendFuncSeparate(n.ONE,n.ZERO,n.ONE,n.ZERO),n.blendColor(0,0,0,0),n.colorMask(!0,!0,!0,!0),n.clearColor(0,0,0,0),n.depthMask(!0),n.depthFunc(n.LESS),a.setReversed(!1),n.clearDepth(1),n.stencilMask(4294967295),n.stencilFunc(n.ALWAYS,0,4294967295),n.stencilOp(n.KEEP,n.KEEP,n.KEEP),n.clearStencil(0),n.cullFace(n.BACK),n.frontFace(n.CCW),n.polygonOffset(0,0),n.activeTexture(n.TEXTURE0),n.bindFramebuffer(n.FRAMEBUFFER,null),n.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),n.bindFramebuffer(n.READ_FRAMEBUFFER,null),n.useProgram(null),n.lineWidth(1),n.scissor(0,0,n.canvas.width,n.canvas.height),n.viewport(0,0,n.canvas.width,n.canvas.height),n.pixelStorei(n.PACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,!1),n.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,!1),n.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,n.BROWSER_DEFAULT_WEBGL),n.pixelStorei(n.PACK_ROW_LENGTH,0),n.pixelStorei(n.PACK_SKIP_PIXELS,0),n.pixelStorei(n.PACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_ROW_LENGTH,0),n.pixelStorei(n.UNPACK_IMAGE_HEIGHT,0),n.pixelStorei(n.UNPACK_SKIP_PIXELS,0),n.pixelStorei(n.UNPACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_SKIP_IMAGES,0),h={},u={},j=null,et={},d={},f=new WeakMap,p=[],x=null,m=!1,g=null,_=null,T=null,v=null,S=null,M=null,A=null,y=new Nt(0,0,0),E=0,P=!1,N=null,F=null,B=null,I=null,H=null,Ut.set(0,0,n.canvas.width,n.canvas.height),$t.set(0,0,n.canvas.width,n.canvas.height),r.reset(),a.reset(),o.reset()}return{buffers:{color:r,depth:a,stencil:o},enable:rt,disable:_t,bindFramebuffer:Jt,drawBuffers:At,useProgram:Yt,setBlending:ut,setMaterial:pt,setFlipSided:mt,setCullFace:w,setLineWidth:J,setPolygonOffset:Q,setScissorTest:st,activeTexture:nt,bindTexture:L,unbindTexture:yt,compressedTexImage2D:zt,compressedTexImage3D:C,texImage2D:it,texImage3D:ct,pixelStorei:kt,getParameter:wt,updateUBOMapping:Bt,uniformBlockBinding:jt,texStorage2D:gt,texStorage3D:xt,texSubImage2D:b,texSubImage3D:O,compressedTexSubImage2D:V,compressedTexSubImage3D:K,scissor:Mt,viewport:bt,reset:ne}}function E_(n,t,e,i,s,r,a){let o=t.has("WEBGL_multisampled_render_to_texture")?t.get("WEBGL_multisampled_render_to_texture"):null,c=typeof navigator>"u"?!1:/OculusBrowser/g.test(navigator.userAgent),l=new ot,h=new WeakMap,u=new Set,d,f=new WeakMap,p=!1;try{p=typeof OffscreenCanvas<"u"&&new OffscreenCanvas(1,1).getContext("2d")!==null}catch{}function x(C,b){return p?new OffscreenCanvas(C,b):ba("canvas")}function m(C,b,O){let V=1,K=zt(C);if((K.width>O||K.height>O)&&(V=O/Math.max(K.width,K.height)),V<1)if(typeof HTMLImageElement<"u"&&C instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&C instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&C instanceof ImageBitmap||typeof VideoFrame<"u"&&C instanceof VideoFrame){let gt=Math.floor(V*K.width),xt=Math.floor(V*K.height);d===void 0&&(d=x(gt,xt));let it=b?x(gt,xt):d;return it.width=gt,it.height=xt,it.getContext("2d").drawImage(C,0,0,gt,xt),te("WebGLRenderer: Texture has been resized from ("+K.width+"x"+K.height+") to ("+gt+"x"+xt+")."),it}else return"data"in C&&te("WebGLRenderer: Image in DataTexture is too big ("+K.width+"x"+K.height+")."),C;return C}function g(C){return C.generateMipmaps}function _(C){n.generateMipmap(C)}function T(C){return C.isWebGLCubeRenderTarget?n.TEXTURE_CUBE_MAP:C.isWebGL3DRenderTarget?n.TEXTURE_3D:C.isWebGLArrayRenderTarget||C.isCompressedArrayTexture?n.TEXTURE_2D_ARRAY:n.TEXTURE_2D}function v(C,b,O,V,K,gt=!1){if(C!==null){if(n[C]!==void 0)return n[C];te("WebGLRenderer: Attempt to use non-existing WebGL internal format '"+C+"'")}let xt;V&&(xt=t.get("EXT_texture_norm16"),xt||te("WebGLRenderer: Unable to use normalized textures without EXT_texture_norm16 extension"));let it=b;if(b===n.RED&&(O===n.FLOAT&&(it=n.R32F),O===n.HALF_FLOAT&&(it=n.R16F),O===n.UNSIGNED_BYTE&&(it=n.R8),O===n.UNSIGNED_SHORT&&xt&&(it=xt.R16_EXT),O===n.SHORT&&xt&&(it=xt.R16_SNORM_EXT)),b===n.RED_INTEGER&&(O===n.UNSIGNED_BYTE&&(it=n.R8UI),O===n.UNSIGNED_SHORT&&(it=n.R16UI),O===n.UNSIGNED_INT&&(it=n.R32UI),O===n.BYTE&&(it=n.R8I),O===n.SHORT&&(it=n.R16I),O===n.INT&&(it=n.R32I)),b===n.RG&&(O===n.FLOAT&&(it=n.RG32F),O===n.HALF_FLOAT&&(it=n.RG16F),O===n.UNSIGNED_BYTE&&(it=n.RG8),O===n.UNSIGNED_SHORT&&xt&&(it=xt.RG16_EXT),O===n.SHORT&&xt&&(it=xt.RG16_SNORM_EXT)),b===n.RG_INTEGER&&(O===n.UNSIGNED_BYTE&&(it=n.RG8UI),O===n.UNSIGNED_SHORT&&(it=n.RG16UI),O===n.UNSIGNED_INT&&(it=n.RG32UI),O===n.BYTE&&(it=n.RG8I),O===n.SHORT&&(it=n.RG16I),O===n.INT&&(it=n.RG32I)),b===n.RGB_INTEGER&&(O===n.UNSIGNED_BYTE&&(it=n.RGB8UI),O===n.UNSIGNED_SHORT&&(it=n.RGB16UI),O===n.UNSIGNED_INT&&(it=n.RGB32UI),O===n.BYTE&&(it=n.RGB8I),O===n.SHORT&&(it=n.RGB16I),O===n.INT&&(it=n.RGB32I)),b===n.RGBA_INTEGER&&(O===n.UNSIGNED_BYTE&&(it=n.RGBA8UI),O===n.UNSIGNED_SHORT&&(it=n.RGBA16UI),O===n.UNSIGNED_INT&&(it=n.RGBA32UI),O===n.BYTE&&(it=n.RGBA8I),O===n.SHORT&&(it=n.RGBA16I),O===n.INT&&(it=n.RGBA32I)),b===n.RGB&&(O===n.UNSIGNED_SHORT&&xt&&(it=xt.RGB16_EXT),O===n.SHORT&&xt&&(it=xt.RGB16_SNORM_EXT),O===n.UNSIGNED_INT_5_9_9_9_REV&&(it=n.RGB9_E5),O===n.UNSIGNED_INT_10F_11F_11F_REV&&(it=n.R11F_G11F_B10F)),b===n.RGBA){let ct=gt?_a:he.getTransfer(K);O===n.FLOAT&&(it=n.RGBA32F),O===n.HALF_FLOAT&&(it=n.RGBA16F),O===n.UNSIGNED_BYTE&&(it=ct===_e?n.SRGB8_ALPHA8:n.RGBA8),O===n.UNSIGNED_SHORT&&xt&&(it=xt.RGBA16_EXT),O===n.SHORT&&xt&&(it=xt.RGBA16_SNORM_EXT),O===n.UNSIGNED_SHORT_4_4_4_4&&(it=n.RGBA4),O===n.UNSIGNED_SHORT_5_5_5_1&&(it=n.RGB5_A1)}return(it===n.R16F||it===n.R32F||it===n.RG16F||it===n.RG32F||it===n.RGBA16F||it===n.RGBA32F)&&t.get("EXT_color_buffer_float"),it}function S(C,b){let O;return C?b===null||b===cn||b===Ir?O=n.DEPTH24_STENCIL8:b===Zi?O=n.DEPTH32F_STENCIL8:b===Pr&&(O=n.DEPTH24_STENCIL8,te("DepthTexture: 16 bit depth attachment is not supported with stencil. Using 24-bit attachment.")):b===null||b===cn||b===Ir?O=n.DEPTH_COMPONENT24:b===Zi?O=n.DEPTH_COMPONENT32F:b===Pr&&(O=n.DEPTH_COMPONENT16),O}function M(C,b){return g(C)===!0||C.isFramebufferTexture&&C.minFilter!==oi&&C.minFilter!==Ye?Math.log2(Math.max(b.width,b.height))+1:C.mipmaps!==void 0&&C.mipmaps.length>0?C.mipmaps.length:C.isCompressedTexture&&Array.isArray(C.image)?b.mipmaps.length:1}function A(C){let b=C.target;b.removeEventListener("dispose",A),E(b),b.isVideoTexture&&h.delete(b),b.isHTMLTexture&&u.delete(b)}function y(C){let b=C.target;b.removeEventListener("dispose",y),N(b)}function E(C){let b=i.get(C);if(b.__webglInit===void 0)return;let O=C.source,V=f.get(O);if(V){let K=V[b.__cacheKey];K.usedTimes--,K.usedTimes===0&&P(C),Object.keys(V).length===0&&f.delete(O)}i.remove(C)}function P(C){let b=i.get(C);n.deleteTexture(b.__webglTexture);let O=C.source,V=f.get(O);delete V[b.__cacheKey],a.memory.textures--}function N(C){let b=i.get(C);if(C.depthTexture&&(C.depthTexture.dispose(),i.remove(C.depthTexture)),C.isWebGLCubeRenderTarget)for(let V=0;V<6;V++){if(Array.isArray(b.__webglFramebuffer[V]))for(let K=0;K<b.__webglFramebuffer[V].length;K++)n.deleteFramebuffer(b.__webglFramebuffer[V][K]);else n.deleteFramebuffer(b.__webglFramebuffer[V]);b.__webglDepthbuffer&&n.deleteRenderbuffer(b.__webglDepthbuffer[V])}else{if(Array.isArray(b.__webglFramebuffer))for(let V=0;V<b.__webglFramebuffer.length;V++)n.deleteFramebuffer(b.__webglFramebuffer[V]);else n.deleteFramebuffer(b.__webglFramebuffer);if(b.__webglDepthbuffer&&n.deleteRenderbuffer(b.__webglDepthbuffer),b.__webglMultisampledFramebuffer&&n.deleteFramebuffer(b.__webglMultisampledFramebuffer),b.__webglColorRenderbuffer)for(let V=0;V<b.__webglColorRenderbuffer.length;V++)b.__webglColorRenderbuffer[V]&&n.deleteRenderbuffer(b.__webglColorRenderbuffer[V]);b.__webglDepthRenderbuffer&&n.deleteRenderbuffer(b.__webglDepthRenderbuffer)}let O=C.textures;for(let V=0,K=O.length;V<K;V++){let gt=i.get(O[V]);gt.__webglTexture&&(n.deleteTexture(gt.__webglTexture),a.memory.textures--),i.remove(O[V])}i.remove(C)}let F=0;function B(){F=0}function I(){return F}function H(C){F=C}function W(){let C=F;return C>=s.maxTextures&&te("WebGLTextures: Trying to use "+(C+1)+" texture units while this GPU supports only "+s.maxTextures),F+=1,C}function U(C){let b=[];return b.push(C.wrapS),b.push(C.wrapT),b.push(C.wrapR||0),b.push(C.magFilter),b.push(C.minFilter),b.push(C.anisotropy),b.push(C.internalFormat),b.push(C.format),b.push(C.type),b.push(C.generateMipmaps),b.push(C.premultiplyAlpha),b.push(C.flipY),b.push(C.unpackAlignment),b.push(C.colorSpace),b.join()}function X(C,b){let O=i.get(C);if(C.isVideoTexture&&L(C),C.isRenderTargetTexture===!1&&C.isExternalTexture!==!0&&C.version>0&&O.__version!==C.version){let V=C.image;if(V===null)te("WebGLRenderer: Texture marked for update but no image data found.");else if(V.complete===!1)te("WebGLRenderer: Texture marked for update but image is incomplete");else{_t(O,C,b);return}}else C.isExternalTexture&&(O.__webglTexture=C.sourceTexture?C.sourceTexture:null);e.bindTexture(n.TEXTURE_2D,O.__webglTexture,n.TEXTURE0+b)}function G(C,b){let O=i.get(C);if(C.isRenderTargetTexture===!1&&C.version>0&&O.__version!==C.version){_t(O,C,b);return}else C.isExternalTexture&&(O.__webglTexture=C.sourceTexture?C.sourceTexture:null);e.bindTexture(n.TEXTURE_2D_ARRAY,O.__webglTexture,n.TEXTURE0+b)}function j(C,b){let O=i.get(C);if(C.isRenderTargetTexture===!1&&C.version>0&&O.__version!==C.version){_t(O,C,b);return}e.bindTexture(n.TEXTURE_3D,O.__webglTexture,n.TEXTURE0+b)}function et(C,b){let O=i.get(C);if(C.isCubeDepthTexture!==!0&&C.version>0&&O.__version!==C.version){Jt(O,C,b);return}e.bindTexture(n.TEXTURE_CUBE_MAP,O.__webglTexture,n.TEXTURE0+b)}let vt={[Nn]:n.REPEAT,[gn]:n.CLAMP_TO_EDGE,[Ml]:n.MIRRORED_REPEAT},ht={[oi]:n.NEAREST,[_0]:n.NEAREST_MIPMAP_NEAREST,[ro]:n.NEAREST_MIPMAP_LINEAR,[Ye]:n.LINEAR,[tc]:n.LINEAR_MIPMAP_NEAREST,[Oi]:n.LINEAR_MIPMAP_LINEAR},Ut={[w0]:n.NEVER,[C0]:n.ALWAYS,[T0]:n.LESS,[Oc]:n.LEQUAL,[E0]:n.EQUAL,[kc]:n.GEQUAL,[A0]:n.GREATER,[R0]:n.NOTEQUAL};function $t(C,b){if(b.type===Zi&&t.has("OES_texture_float_linear")===!1&&(b.magFilter===Ye||b.magFilter===tc||b.magFilter===ro||b.magFilter===Oi||b.minFilter===Ye||b.minFilter===tc||b.minFilter===ro||b.minFilter===Oi)&&te("WebGLRenderer: Unable to use linear filtering with floating point textures. OES_texture_float_linear not supported on this device."),n.texParameteri(C,n.TEXTURE_WRAP_S,vt[b.wrapS]),n.texParameteri(C,n.TEXTURE_WRAP_T,vt[b.wrapT]),(C===n.TEXTURE_3D||C===n.TEXTURE_2D_ARRAY)&&n.texParameteri(C,n.TEXTURE_WRAP_R,vt[b.wrapR]),n.texParameteri(C,n.TEXTURE_MAG_FILTER,ht[b.magFilter]),n.texParameteri(C,n.TEXTURE_MIN_FILTER,ht[b.minFilter]),b.compareFunction&&(n.texParameteri(C,n.TEXTURE_COMPARE_MODE,n.COMPARE_REF_TO_TEXTURE),n.texParameteri(C,n.TEXTURE_COMPARE_FUNC,Ut[b.compareFunction])),t.has("EXT_texture_filter_anisotropic")===!0){if(b.magFilter===oi||b.minFilter!==ro&&b.minFilter!==Oi||b.type===Zi&&t.has("OES_texture_float_linear")===!1)return;if(b.anisotropy>1||i.get(b).__currentAnisotropy){let O=t.get("EXT_texture_filter_anisotropic");n.texParameterf(C,O.TEXTURE_MAX_ANISOTROPY_EXT,Math.min(b.anisotropy,s.getMaxAnisotropy())),i.get(b).__currentAnisotropy=b.anisotropy}}}function Kt(C,b){let O=!1;C.__webglInit===void 0&&(C.__webglInit=!0,b.addEventListener("dispose",A));let V=b.source,K=f.get(V);K===void 0&&(K={},f.set(V,K));let gt=U(b);if(gt!==C.__cacheKey){K[gt]===void 0&&(K[gt]={texture:n.createTexture(),usedTimes:0},a.memory.textures++,O=!0),K[gt].usedTimes++;let xt=K[C.__cacheKey];xt!==void 0&&(K[C.__cacheKey].usedTimes--,xt.usedTimes===0&&P(b)),C.__cacheKey=gt,C.__webglTexture=K[gt].texture}return O}function $(C,b,O){return Math.floor(Math.floor(C/O)/b)}function rt(C,b,O,V){let gt=C.updateRanges;if(gt.length===0)e.texSubImage2D(n.TEXTURE_2D,0,0,0,b.width,b.height,O,V,b.data);else{gt.sort((kt,Mt)=>kt.start-Mt.start);let xt=0;for(let kt=1;kt<gt.length;kt++){let Mt=gt[xt],bt=gt[kt],Bt=Mt.start+Mt.count,jt=$(bt.start,b.width,4),ne=$(Mt.start,b.width,4);bt.start<=Bt+1&&jt===ne&&$(bt.start+bt.count-1,b.width,4)===jt?Mt.count=Math.max(Mt.count,bt.start+bt.count-Mt.start):(++xt,gt[xt]=bt)}gt.length=xt+1;let it=e.getParameter(n.UNPACK_ROW_LENGTH),ct=e.getParameter(n.UNPACK_SKIP_PIXELS),wt=e.getParameter(n.UNPACK_SKIP_ROWS);e.pixelStorei(n.UNPACK_ROW_LENGTH,b.width);for(let kt=0,Mt=gt.length;kt<Mt;kt++){let bt=gt[kt],Bt=Math.floor(bt.start/4),jt=Math.ceil(bt.count/4),ne=Bt%b.width,k=Math.floor(Bt/b.width),Tt=jt,lt=1;e.pixelStorei(n.UNPACK_SKIP_PIXELS,ne),e.pixelStorei(n.UNPACK_SKIP_ROWS,k),e.texSubImage2D(n.TEXTURE_2D,0,ne,k,Tt,lt,O,V,b.data)}C.clearUpdateRanges(),e.pixelStorei(n.UNPACK_ROW_LENGTH,it),e.pixelStorei(n.UNPACK_SKIP_PIXELS,ct),e.pixelStorei(n.UNPACK_SKIP_ROWS,wt)}}function _t(C,b,O){let V=n.TEXTURE_2D;(b.isDataArrayTexture||b.isCompressedArrayTexture)&&(V=n.TEXTURE_2D_ARRAY),b.isData3DTexture&&(V=n.TEXTURE_3D);let K=Kt(C,b),gt=b.source;e.bindTexture(V,C.__webglTexture,n.TEXTURE0+O);let xt=i.get(gt);if(gt.version!==xt.__version||K===!0){if(e.activeTexture(n.TEXTURE0+O),(typeof ImageBitmap<"u"&&b.image instanceof ImageBitmap)===!1){let lt=he.getPrimaries(he.workingColorSpace),Et=b.colorSpace===Ki?null:he.getPrimaries(b.colorSpace),Dt=b.colorSpace===Ki||lt===Et?n.NONE:n.BROWSER_DEFAULT_WEBGL;e.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,b.flipY),e.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,b.premultiplyAlpha),e.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,Dt)}e.pixelStorei(n.UNPACK_ALIGNMENT,b.unpackAlignment);let ct=m(b.image,!1,s.maxTextureSize);ct=yt(b,ct);let wt=r.convert(b.format,b.colorSpace),kt=r.convert(b.type),Mt=v(b.internalFormat,wt,kt,b.normalized,b.colorSpace,b.isVideoTexture);$t(V,b);let bt,Bt=b.mipmaps,jt=b.isVideoTexture!==!0,ne=xt.__version===void 0||K===!0,k=gt.dataReady,Tt=M(b,ct);if(b.isDepthTexture)Mt=S(b.format===ls,b.type),ne&&(jt?e.texStorage2D(n.TEXTURE_2D,1,Mt,ct.width,ct.height):e.texImage2D(n.TEXTURE_2D,0,Mt,ct.width,ct.height,0,wt,kt,null));else if(b.isDataTexture)if(Bt.length>0){jt&&ne&&e.texStorage2D(n.TEXTURE_2D,Tt,Mt,Bt[0].width,Bt[0].height);for(let lt=0,Et=Bt.length;lt<Et;lt++)bt=Bt[lt],jt?k&&e.texSubImage2D(n.TEXTURE_2D,lt,0,0,bt.width,bt.height,wt,kt,bt.data):e.texImage2D(n.TEXTURE_2D,lt,Mt,bt.width,bt.height,0,wt,kt,bt.data);b.generateMipmaps=!1}else jt?(ne&&e.texStorage2D(n.TEXTURE_2D,Tt,Mt,ct.width,ct.height),k&&rt(b,ct,wt,kt)):e.texImage2D(n.TEXTURE_2D,0,Mt,ct.width,ct.height,0,wt,kt,ct.data);else if(b.isCompressedTexture)if(b.isCompressedArrayTexture){jt&&ne&&e.texStorage3D(n.TEXTURE_2D_ARRAY,Tt,Mt,Bt[0].width,Bt[0].height,ct.depth);for(let lt=0,Et=Bt.length;lt<Et;lt++)if(bt=Bt[lt],b.format!==Ji)if(wt!==null)if(jt){if(k)if(b.layerUpdates.size>0){let Dt=Ku(bt.width,bt.height,b.format,b.type);for(let ft of b.layerUpdates){let Zt=bt.data.subarray(ft*Dt/bt.data.BYTES_PER_ELEMENT,(ft+1)*Dt/bt.data.BYTES_PER_ELEMENT);e.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,lt,0,0,ft,bt.width,bt.height,1,wt,Zt)}}else e.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,lt,0,0,0,bt.width,bt.height,ct.depth,wt,bt.data)}else e.compressedTexImage3D(n.TEXTURE_2D_ARRAY,lt,Mt,bt.width,bt.height,ct.depth,0,bt.data,0,0);else te("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()");else jt?k&&e.texSubImage3D(n.TEXTURE_2D_ARRAY,lt,0,0,0,bt.width,bt.height,ct.depth,wt,kt,bt.data):e.texImage3D(n.TEXTURE_2D_ARRAY,lt,Mt,bt.width,bt.height,ct.depth,0,wt,kt,bt.data);b.layerUpdates.size>0&&b.clearLayerUpdates()}else{jt&&ne&&e.texStorage2D(n.TEXTURE_2D,Tt,Mt,Bt[0].width,Bt[0].height);for(let lt=0,Et=Bt.length;lt<Et;lt++)bt=Bt[lt],b.format!==Ji?wt!==null?jt?k&&e.compressedTexSubImage2D(n.TEXTURE_2D,lt,0,0,bt.width,bt.height,wt,bt.data):e.compressedTexImage2D(n.TEXTURE_2D,lt,Mt,bt.width,bt.height,0,bt.data):te("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()"):jt?k&&e.texSubImage2D(n.TEXTURE_2D,lt,0,0,bt.width,bt.height,wt,kt,bt.data):e.texImage2D(n.TEXTURE_2D,lt,Mt,bt.width,bt.height,0,wt,kt,bt.data)}else if(b.isDataArrayTexture)if(jt){if(ne&&e.texStorage3D(n.TEXTURE_2D_ARRAY,Tt,Mt,ct.width,ct.height,ct.depth),k)if(b.layerUpdates.size>0){let lt=Ku(ct.width,ct.height,b.format,b.type);for(let Et of b.layerUpdates){let Dt=ct.data.subarray(Et*lt/ct.data.BYTES_PER_ELEMENT,(Et+1)*lt/ct.data.BYTES_PER_ELEMENT);e.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,Et,ct.width,ct.height,1,wt,kt,Dt)}b.clearLayerUpdates()}else e.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,0,ct.width,ct.height,ct.depth,wt,kt,ct.data)}else e.texImage3D(n.TEXTURE_2D_ARRAY,0,Mt,ct.width,ct.height,ct.depth,0,wt,kt,ct.data);else if(b.isData3DTexture)jt?(ne&&e.texStorage3D(n.TEXTURE_3D,Tt,Mt,ct.width,ct.height,ct.depth),k&&e.texSubImage3D(n.TEXTURE_3D,0,0,0,0,ct.width,ct.height,ct.depth,wt,kt,ct.data)):e.texImage3D(n.TEXTURE_3D,0,Mt,ct.width,ct.height,ct.depth,0,wt,kt,ct.data);else if(b.isFramebufferTexture){if(ne)if(jt)e.texStorage2D(n.TEXTURE_2D,Tt,Mt,ct.width,ct.height);else{let lt=ct.width,Et=ct.height;for(let Dt=0;Dt<Tt;Dt++)e.texImage2D(n.TEXTURE_2D,Dt,Mt,lt,Et,0,wt,kt,null),lt>>=1,Et>>=1}}else if(b.isHTMLTexture){if("texElementImage2D"in n){let lt=n.canvas;if(lt.hasAttribute("layoutsubtree")||lt.setAttribute("layoutsubtree","true"),ct.parentNode!==lt){lt.appendChild(ct),u.add(b),lt.onpaint=Et=>{let Dt=Et.changedElements;for(let ft of u)Dt.includes(ft.image)&&(ft.needsUpdate=!0)},lt.requestPaint();return}if(n.texElementImage2D.length===3)n.texElementImage2D(n.TEXTURE_2D,n.RGBA8,ct);else{let Dt=n.RGBA,ft=n.RGBA,Zt=n.UNSIGNED_BYTE;n.texElementImage2D(n.TEXTURE_2D,0,Dt,ft,Zt,ct)}n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MIN_FILTER,n.LINEAR),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_S,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_T,n.CLAMP_TO_EDGE)}}else if(Bt.length>0){if(jt&&ne){let lt=zt(Bt[0]);e.texStorage2D(n.TEXTURE_2D,Tt,Mt,lt.width,lt.height)}for(let lt=0,Et=Bt.length;lt<Et;lt++)bt=Bt[lt],jt?k&&e.texSubImage2D(n.TEXTURE_2D,lt,0,0,wt,kt,bt):e.texImage2D(n.TEXTURE_2D,lt,Mt,wt,kt,bt);b.generateMipmaps=!1}else if(jt){if(ne){let lt=zt(ct);e.texStorage2D(n.TEXTURE_2D,Tt,Mt,lt.width,lt.height)}k&&e.texSubImage2D(n.TEXTURE_2D,0,0,0,wt,kt,ct)}else e.texImage2D(n.TEXTURE_2D,0,Mt,wt,kt,ct);g(b)&&_(V),xt.__version=gt.version,b.onUpdate&&b.onUpdate(b)}C.__version=b.version}function Jt(C,b,O){if(b.image.length!==6)return;let V=Kt(C,b),K=b.source;e.bindTexture(n.TEXTURE_CUBE_MAP,C.__webglTexture,n.TEXTURE0+O);let gt=i.get(K);if(K.version!==gt.__version||V===!0){e.activeTexture(n.TEXTURE0+O);let xt=he.getPrimaries(he.workingColorSpace),it=b.colorSpace===Ki?null:he.getPrimaries(b.colorSpace),ct=b.colorSpace===Ki||xt===it?n.NONE:n.BROWSER_DEFAULT_WEBGL;e.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,b.flipY),e.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,b.premultiplyAlpha),e.pixelStorei(n.UNPACK_ALIGNMENT,b.unpackAlignment),e.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,ct);let wt=b.isCompressedTexture||b.image[0].isCompressedTexture,kt=b.image[0]&&b.image[0].isDataTexture,Mt=[];for(let ft=0;ft<6;ft++)!wt&&!kt?Mt[ft]=m(b.image[ft],!0,s.maxCubemapSize):Mt[ft]=kt?b.image[ft].image:b.image[ft],Mt[ft]=yt(b,Mt[ft]);let bt=Mt[0],Bt=r.convert(b.format,b.colorSpace),jt=r.convert(b.type),ne=v(b.internalFormat,Bt,jt,b.normalized,b.colorSpace),k=b.isVideoTexture!==!0,Tt=gt.__version===void 0||V===!0,lt=K.dataReady,Et=M(b,bt);$t(n.TEXTURE_CUBE_MAP,b);let Dt;if(wt){k&&Tt&&e.texStorage2D(n.TEXTURE_CUBE_MAP,Et,ne,bt.width,bt.height);for(let ft=0;ft<6;ft++){Dt=Mt[ft].mipmaps;for(let Zt=0;Zt<Dt.length;Zt++){let Wt=Dt[Zt];b.format!==Ji?Bt!==null?k?lt&&e.compressedTexSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt,0,0,Wt.width,Wt.height,Bt,Wt.data):e.compressedTexImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt,ne,Wt.width,Wt.height,0,Wt.data):te("WebGLRenderer: Attempt to load unsupported compressed texture format in .setTextureCube()"):k?lt&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt,0,0,Wt.width,Wt.height,Bt,jt,Wt.data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt,ne,Wt.width,Wt.height,0,Bt,jt,Wt.data)}}}else{if(Dt=b.mipmaps,k&&Tt){Dt.length>0&&Et++;let ft=zt(Mt[0]);e.texStorage2D(n.TEXTURE_CUBE_MAP,Et,ne,ft.width,ft.height)}for(let ft=0;ft<6;ft++)if(kt){k?lt&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,0,0,0,Mt[ft].width,Mt[ft].height,Bt,jt,Mt[ft].data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,0,ne,Mt[ft].width,Mt[ft].height,0,Bt,jt,Mt[ft].data);for(let Zt=0;Zt<Dt.length;Zt++){let De=Dt[Zt].image[ft].image;k?lt&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt+1,0,0,De.width,De.height,Bt,jt,De.data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt+1,ne,De.width,De.height,0,Bt,jt,De.data)}}else{k?lt&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,0,0,0,Bt,jt,Mt[ft]):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,0,ne,Bt,jt,Mt[ft]);for(let Zt=0;Zt<Dt.length;Zt++){let Wt=Dt[Zt];k?lt&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt+1,0,0,Bt,jt,Wt.image[ft]):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ft,Zt+1,ne,Bt,jt,Wt.image[ft])}}}g(b)&&_(n.TEXTURE_CUBE_MAP),gt.__version=K.version,b.onUpdate&&b.onUpdate(b)}C.__version=b.version}function At(C,b,O,V,K,gt){let xt=r.convert(O.format,O.colorSpace),it=r.convert(O.type),ct=v(O.internalFormat,xt,it,O.normalized,O.colorSpace),wt=i.get(b),kt=i.get(O);if(kt.__renderTarget=b,!wt.__hasExternalTextures){let Mt=Math.max(1,b.width>>gt),bt=Math.max(1,b.height>>gt);K===n.TEXTURE_3D||K===n.TEXTURE_2D_ARRAY?e.texImage3D(K,gt,ct,Mt,bt,b.depth,0,xt,it,null):e.texImage2D(K,gt,ct,Mt,bt,0,xt,it,null)}e.bindFramebuffer(n.FRAMEBUFFER,C),nt(b)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,V,K,kt.__webglTexture,0,st(b)):(K===n.TEXTURE_2D||K>=n.TEXTURE_CUBE_MAP_POSITIVE_X&&K<=n.TEXTURE_CUBE_MAP_NEGATIVE_Z)&&n.framebufferTexture2D(n.FRAMEBUFFER,V,K,kt.__webglTexture,gt),e.bindFramebuffer(n.FRAMEBUFFER,null)}function Yt(C,b,O){if(n.bindRenderbuffer(n.RENDERBUFFER,C),b.depthBuffer){let V=b.depthTexture,K=V&&V.isDepthTexture?V.type:null,gt=S(b.stencilBuffer,K),xt=b.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;nt(b)?o.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,st(b),gt,b.width,b.height):O?n.renderbufferStorageMultisample(n.RENDERBUFFER,st(b),gt,b.width,b.height):n.renderbufferStorage(n.RENDERBUFFER,gt,b.width,b.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,xt,n.RENDERBUFFER,C)}else{let V=b.textures;for(let K=0;K<V.length;K++){let gt=V[K],xt=r.convert(gt.format,gt.colorSpace),it=r.convert(gt.type),ct=v(gt.internalFormat,xt,it,gt.normalized,gt.colorSpace);nt(b)?o.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,st(b),ct,b.width,b.height):O?n.renderbufferStorageMultisample(n.RENDERBUFFER,st(b),ct,b.width,b.height):n.renderbufferStorage(n.RENDERBUFFER,ct,b.width,b.height)}}n.bindRenderbuffer(n.RENDERBUFFER,null)}function fe(C,b,O){let V=b.isWebGLCubeRenderTarget===!0;if(e.bindFramebuffer(n.FRAMEBUFFER,C),!(b.depthTexture&&b.depthTexture.isDepthTexture))throw new Error("THREE.WebGLTextures: renderTarget.depthTexture must be an instance of THREE.DepthTexture.");let K=i.get(b.depthTexture);if(K.__renderTarget=b,(!K.__webglTexture||b.depthTexture.image.width!==b.width||b.depthTexture.image.height!==b.height)&&(b.depthTexture.image.width=b.width,b.depthTexture.image.height=b.height,b.depthTexture.needsUpdate=!0),V){if(K.__webglInit===void 0&&(K.__webglInit=!0,b.depthTexture.addEventListener("dispose",A)),K.__webglTexture===void 0){K.__webglTexture=n.createTexture(),e.bindTexture(n.TEXTURE_CUBE_MAP,K.__webglTexture),$t(n.TEXTURE_CUBE_MAP,b.depthTexture);let wt=r.convert(b.depthTexture.format),kt=r.convert(b.depthTexture.type),Mt;b.depthTexture.format===vn?Mt=n.DEPTH_COMPONENT24:b.depthTexture.format===ls&&(Mt=n.DEPTH24_STENCIL8);for(let bt=0;bt<6;bt++)n.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+bt,0,Mt,b.width,b.height,0,wt,kt,null)}}else X(b.depthTexture,0);let gt=K.__webglTexture,xt=st(b),it=V?n.TEXTURE_CUBE_MAP_POSITIVE_X+O:n.TEXTURE_2D,ct=b.depthTexture.format===ls?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;if(b.depthTexture.format===vn)nt(b)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,ct,it,gt,0,xt):n.framebufferTexture2D(n.FRAMEBUFFER,ct,it,gt,0);else if(b.depthTexture.format===ls)nt(b)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,ct,it,gt,0,xt):n.framebufferTexture2D(n.FRAMEBUFFER,ct,it,gt,0);else throw new Error("THREE.WebGLTextures: Unknown depthTexture format.")}function at(C){let b=i.get(C),O=C.isWebGLCubeRenderTarget===!0;if(b.__boundDepthTexture!==C.depthTexture){let V=C.depthTexture;if(b.__depthDisposeCallback&&b.__depthDisposeCallback(),V){let K=()=>{delete b.__boundDepthTexture,delete b.__depthDisposeCallback,V.removeEventListener("dispose",K)};V.addEventListener("dispose",K),b.__depthDisposeCallback=K}b.__boundDepthTexture=V}if(C.depthTexture&&!b.__autoAllocateDepthBuffer)if(O)for(let V=0;V<6;V++)fe(b.__webglFramebuffer[V],C,V);else{let V=C.texture.mipmaps;V&&V.length>0?fe(b.__webglFramebuffer[0],C,0):fe(b.__webglFramebuffer,C,0)}else if(O){b.__webglDepthbuffer=[];for(let V=0;V<6;V++)if(e.bindFramebuffer(n.FRAMEBUFFER,b.__webglFramebuffer[V]),b.__webglDepthbuffer[V]===void 0)b.__webglDepthbuffer[V]=n.createRenderbuffer(),Yt(b.__webglDepthbuffer[V],C,!1);else{let K=C.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,gt=b.__webglDepthbuffer[V];n.bindRenderbuffer(n.RENDERBUFFER,gt),n.framebufferRenderbuffer(n.FRAMEBUFFER,K,n.RENDERBUFFER,gt)}}else{let V=C.texture.mipmaps;if(V&&V.length>0?e.bindFramebuffer(n.FRAMEBUFFER,b.__webglFramebuffer[0]):e.bindFramebuffer(n.FRAMEBUFFER,b.__webglFramebuffer),b.__webglDepthbuffer===void 0)b.__webglDepthbuffer=n.createRenderbuffer(),Yt(b.__webglDepthbuffer,C,!1);else{let K=C.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,gt=b.__webglDepthbuffer;n.bindRenderbuffer(n.RENDERBUFFER,gt),n.framebufferRenderbuffer(n.FRAMEBUFFER,K,n.RENDERBUFFER,gt)}}e.bindFramebuffer(n.FRAMEBUFFER,null)}function ut(C,b,O){let V=i.get(C);b!==void 0&&At(V.__webglFramebuffer,C,C.texture,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,0),O!==void 0&&at(C)}function pt(C){let b=C.texture,O=i.get(C),V=i.get(b);C.addEventListener("dispose",y);let K=C.textures,gt=C.isWebGLCubeRenderTarget===!0,xt=K.length>1;if(xt||(V.__webglTexture===void 0&&(V.__webglTexture=n.createTexture()),V.__version=b.version,a.memory.textures++),gt){O.__webglFramebuffer=[];for(let it=0;it<6;it++)if(b.mipmaps&&b.mipmaps.length>0){O.__webglFramebuffer[it]=[];for(let ct=0;ct<b.mipmaps.length;ct++)O.__webglFramebuffer[it][ct]=n.createFramebuffer()}else O.__webglFramebuffer[it]=n.createFramebuffer()}else{if(b.mipmaps&&b.mipmaps.length>0){O.__webglFramebuffer=[];for(let it=0;it<b.mipmaps.length;it++)O.__webglFramebuffer[it]=n.createFramebuffer()}else O.__webglFramebuffer=n.createFramebuffer();if(xt)for(let it=0,ct=K.length;it<ct;it++){let wt=i.get(K[it]);wt.__webglTexture===void 0&&(wt.__webglTexture=n.createTexture(),a.memory.textures++)}if(C.samples>0&&nt(C)===!1){O.__webglMultisampledFramebuffer=n.createFramebuffer(),O.__webglColorRenderbuffer=[],e.bindFramebuffer(n.FRAMEBUFFER,O.__webglMultisampledFramebuffer);for(let it=0;it<K.length;it++){let ct=K[it];O.__webglColorRenderbuffer[it]=n.createRenderbuffer(),n.bindRenderbuffer(n.RENDERBUFFER,O.__webglColorRenderbuffer[it]);let wt=r.convert(ct.format,ct.colorSpace),kt=r.convert(ct.type),Mt=v(ct.internalFormat,wt,kt,ct.normalized,ct.colorSpace,C.isXRRenderTarget===!0),bt=st(C);n.renderbufferStorageMultisample(n.RENDERBUFFER,bt,Mt,C.width,C.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+it,n.RENDERBUFFER,O.__webglColorRenderbuffer[it])}n.bindRenderbuffer(n.RENDERBUFFER,null),C.depthBuffer&&(O.__webglDepthRenderbuffer=n.createRenderbuffer(),Yt(O.__webglDepthRenderbuffer,C,!0)),e.bindFramebuffer(n.FRAMEBUFFER,null)}}if(gt){e.bindTexture(n.TEXTURE_CUBE_MAP,V.__webglTexture),$t(n.TEXTURE_CUBE_MAP,b);for(let it=0;it<6;it++)if(b.mipmaps&&b.mipmaps.length>0)for(let ct=0;ct<b.mipmaps.length;ct++)At(O.__webglFramebuffer[it][ct],C,b,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+it,ct);else At(O.__webglFramebuffer[it],C,b,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+it,0);g(b)&&_(n.TEXTURE_CUBE_MAP),e.unbindTexture()}else if(xt){for(let it=0,ct=K.length;it<ct;it++){let wt=K[it],kt=i.get(wt),Mt=n.TEXTURE_2D;(C.isWebGL3DRenderTarget||C.isWebGLArrayRenderTarget)&&(Mt=C.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),e.bindTexture(Mt,kt.__webglTexture),$t(Mt,wt),At(O.__webglFramebuffer,C,wt,n.COLOR_ATTACHMENT0+it,Mt,0),g(wt)&&_(Mt)}e.unbindTexture()}else{let it=n.TEXTURE_2D;if((C.isWebGL3DRenderTarget||C.isWebGLArrayRenderTarget)&&(it=C.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),e.bindTexture(it,V.__webglTexture),$t(it,b),b.mipmaps&&b.mipmaps.length>0)for(let ct=0;ct<b.mipmaps.length;ct++)At(O.__webglFramebuffer[ct],C,b,n.COLOR_ATTACHMENT0,it,ct);else At(O.__webglFramebuffer,C,b,n.COLOR_ATTACHMENT0,it,0);g(b)&&_(it),e.unbindTexture()}C.depthBuffer&&at(C)}function mt(C){let b=C.textures;for(let O=0,V=b.length;O<V;O++){let K=b[O];if(g(K)){let gt=T(C),xt=i.get(K).__webglTexture;e.bindTexture(gt,xt),_(gt),e.unbindTexture()}}}let w=[],J=[];function Q(C){if(C.samples>0){if(nt(C)===!1){let b=C.textures,O=C.width,V=C.height,K=n.COLOR_BUFFER_BIT,gt=C.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,xt=i.get(C),it=b.length>1;if(it)for(let wt=0;wt<b.length;wt++)e.bindFramebuffer(n.FRAMEBUFFER,xt.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+wt,n.RENDERBUFFER,null),e.bindFramebuffer(n.FRAMEBUFFER,xt.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+wt,n.TEXTURE_2D,null,0);e.bindFramebuffer(n.READ_FRAMEBUFFER,xt.__webglMultisampledFramebuffer);let ct=C.texture.mipmaps;ct&&ct.length>0?e.bindFramebuffer(n.DRAW_FRAMEBUFFER,xt.__webglFramebuffer[0]):e.bindFramebuffer(n.DRAW_FRAMEBUFFER,xt.__webglFramebuffer);for(let wt=0;wt<b.length;wt++){if(C.resolveDepthBuffer&&(C.depthBuffer&&(K|=n.DEPTH_BUFFER_BIT),C.stencilBuffer&&C.resolveStencilBuffer&&(K|=n.STENCIL_BUFFER_BIT)),it){n.framebufferRenderbuffer(n.READ_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.RENDERBUFFER,xt.__webglColorRenderbuffer[wt]);let kt=i.get(b[wt]).__webglTexture;n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,kt,0)}n.blitFramebuffer(0,0,O,V,0,0,O,V,K,n.NEAREST),c===!0&&(w.length=0,J.length=0,w.push(n.COLOR_ATTACHMENT0+wt),C.depthBuffer&&C.storeMultisampledDepthBuffer===!1&&(w.push(gt),J.push(gt),n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,J)),n.invalidateFramebuffer(n.READ_FRAMEBUFFER,w))}if(e.bindFramebuffer(n.READ_FRAMEBUFFER,null),e.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),it)for(let wt=0;wt<b.length;wt++){e.bindFramebuffer(n.FRAMEBUFFER,xt.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+wt,n.RENDERBUFFER,xt.__webglColorRenderbuffer[wt]);let kt=i.get(b[wt]).__webglTexture;e.bindFramebuffer(n.FRAMEBUFFER,xt.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+wt,n.TEXTURE_2D,kt,0)}e.bindFramebuffer(n.DRAW_FRAMEBUFFER,xt.__webglMultisampledFramebuffer)}else if(C.depthBuffer&&C.storeMultisampledDepthBuffer===!1&&c){let b=C.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,[b])}}}function st(C){return Math.min(s.maxSamples,C.samples)}function nt(C){let b=i.get(C);return C.samples>0&&t.has("WEBGL_multisampled_render_to_texture")===!0&&b.__useRenderToTexture!==!1}function L(C){let b=a.render.frame;h.get(C)!==b&&(h.set(C,b),C.update())}function yt(C,b){let O=C.colorSpace,V=C.format,K=C.type;return C.isCompressedTexture===!0||C.isVideoTexture===!0||O!==ya&&O!==Ki&&(he.getTransfer(O)===_e?(V!==Ji||K!==Ci)&&te("WebGLTextures: sRGB encoded textures have to use RGBAFormat and UnsignedByteType."):ee("WebGLTextures: Unsupported texture color space:",O)),b}function zt(C){return typeof HTMLImageElement<"u"&&C instanceof HTMLImageElement?(l.width=C.naturalWidth||C.width,l.height=C.naturalHeight||C.height):typeof VideoFrame<"u"&&C instanceof VideoFrame?(l.width=C.displayWidth,l.height=C.displayHeight):(l.width=C.width,l.height=C.height),l}this.allocateTextureUnit=W,this.resetTextureUnits=B,this.getTextureUnits=I,this.setTextureUnits=H,this.setTexture2D=X,this.setTexture2DArray=G,this.setTexture3D=j,this.setTextureCube=et,this.rebindTextures=ut,this.setupRenderTarget=pt,this.updateRenderTargetMipmap=mt,this.updateMultisampleRenderTarget=Q,this.setupDepthRenderbuffer=at,this.setupFrameBufferTexture=At,this.useMultisampledRTT=nt,this.isReversedDepthBuffer=function(){return e.buffers.depth.getReversed()}}function A_(n,t){function e(i,s=Ki){let r,a=he.getTransfer(s);if(i===Ci)return n.UNSIGNED_BYTE;if(i===ic)return n.UNSIGNED_SHORT_4_4_4_4;if(i===nc)return n.UNSIGNED_SHORT_5_5_5_1;if(i===ku)return n.UNSIGNED_INT_5_9_9_9_REV;if(i===Bu)return n.UNSIGNED_INT_10F_11F_11F_REV;if(i===zu)return n.BYTE;if(i===Ou)return n.SHORT;if(i===Pr)return n.UNSIGNED_SHORT;if(i===ec)return n.INT;if(i===cn)return n.UNSIGNED_INT;if(i===Zi)return n.FLOAT;if(i===qe)return n.HALF_FLOAT;if(i===Hu)return n.ALPHA;if(i===Gu)return n.RGB;if(i===Ji)return n.RGBA;if(i===vn)return n.DEPTH_COMPONENT;if(i===ls)return n.DEPTH_STENCIL;if(i===sc)return n.RED;if(i===rc)return n.RED_INTEGER;if(i===cs)return n.RG;if(i===ac)return n.RG_INTEGER;if(i===oc)return n.RGBA_INTEGER;if(i===ao||i===oo||i===lo||i===co)if(a===_e)if(r=t.get("WEBGL_compressed_texture_s3tc_srgb"),r!==null){if(i===ao)return r.COMPRESSED_SRGB_S3TC_DXT1_EXT;if(i===oo)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT;if(i===lo)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT;if(i===co)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT}else return null;else if(r=t.get("WEBGL_compressed_texture_s3tc"),r!==null){if(i===ao)return r.COMPRESSED_RGB_S3TC_DXT1_EXT;if(i===oo)return r.COMPRESSED_RGBA_S3TC_DXT1_EXT;if(i===lo)return r.COMPRESSED_RGBA_S3TC_DXT3_EXT;if(i===co)return r.COMPRESSED_RGBA_S3TC_DXT5_EXT}else return null;if(i===lc||i===cc||i===hc||i===uc)if(r=t.get("WEBGL_compressed_texture_pvrtc"),r!==null){if(i===lc)return r.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;if(i===cc)return r.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;if(i===hc)return r.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;if(i===uc)return r.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG}else return null;if(i===dc||i===fc||i===pc||i===mc||i===gc||i===ho||i===xc)if(r=t.get("WEBGL_compressed_texture_etc"),r!==null){if(i===dc||i===fc)return a===_e?r.COMPRESSED_SRGB8_ETC2:r.COMPRESSED_RGB8_ETC2;if(i===pc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ETC2_EAC:r.COMPRESSED_RGBA8_ETC2_EAC;if(i===mc)return r.COMPRESSED_R11_EAC;if(i===gc)return r.COMPRESSED_SIGNED_R11_EAC;if(i===ho)return r.COMPRESSED_RG11_EAC;if(i===xc)return r.COMPRESSED_SIGNED_RG11_EAC}else return null;if(i===vc||i===yc||i===_c||i===bc||i===Mc||i===Sc||i===wc||i===Tc||i===Ec||i===Ac||i===Rc||i===Cc||i===Pc||i===Ic)if(r=t.get("WEBGL_compressed_texture_astc"),r!==null){if(i===vc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR:r.COMPRESSED_RGBA_ASTC_4x4_KHR;if(i===yc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR:r.COMPRESSED_RGBA_ASTC_5x4_KHR;if(i===_c)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR:r.COMPRESSED_RGBA_ASTC_5x5_KHR;if(i===bc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR:r.COMPRESSED_RGBA_ASTC_6x5_KHR;if(i===Mc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR:r.COMPRESSED_RGBA_ASTC_6x6_KHR;if(i===Sc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR:r.COMPRESSED_RGBA_ASTC_8x5_KHR;if(i===wc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR:r.COMPRESSED_RGBA_ASTC_8x6_KHR;if(i===Tc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR:r.COMPRESSED_RGBA_ASTC_8x8_KHR;if(i===Ec)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR:r.COMPRESSED_RGBA_ASTC_10x5_KHR;if(i===Ac)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR:r.COMPRESSED_RGBA_ASTC_10x6_KHR;if(i===Rc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR:r.COMPRESSED_RGBA_ASTC_10x8_KHR;if(i===Cc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR:r.COMPRESSED_RGBA_ASTC_10x10_KHR;if(i===Pc)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR:r.COMPRESSED_RGBA_ASTC_12x10_KHR;if(i===Ic)return a===_e?r.COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR:r.COMPRESSED_RGBA_ASTC_12x12_KHR}else return null;if(i===Lc||i===Dc||i===Nc)if(r=t.get("EXT_texture_compression_bptc"),r!==null){if(i===Lc)return a===_e?r.COMPRESSED_SRGB_ALPHA_BPTC_UNORM_EXT:r.COMPRESSED_RGBA_BPTC_UNORM_EXT;if(i===Dc)return r.COMPRESSED_RGB_BPTC_SIGNED_FLOAT_EXT;if(i===Nc)return r.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_EXT}else return null;if(i===Uc||i===Fc||i===uo||i===zc)if(r=t.get("EXT_texture_compression_rgtc"),r!==null){if(i===Uc)return r.COMPRESSED_RED_RGTC1_EXT;if(i===Fc)return r.COMPRESSED_SIGNED_RED_RGTC1_EXT;if(i===uo)return r.COMPRESSED_RED_GREEN_RGTC2_EXT;if(i===zc)return r.COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT}else return null;return i===Ir?n.UNSIGNED_INT_24_8:n[i]!==void 0?n[i]:null}return{convert:e}}var R_=`
void main() {

	gl_Position = vec4( position, 1.0 );

}`,C_=`
uniform sampler2DArray depthColor;
uniform float depthWidth;
uniform float depthHeight;

void main() {

	vec2 coord = vec2( gl_FragCoord.x / depthWidth, gl_FragCoord.y / depthHeight );

	if ( coord.x >= 1.0 ) {

		gl_FragDepth = texture( depthColor, vec3( coord.x - 1.0, coord.y, 1 ) ).r;

	} else {

		gl_FragDepth = texture( depthColor, vec3( coord.x, coord.y, 0 ) ).r;

	}

}`,gd=class{constructor(){this.texture=null,this.mesh=null,this.depthNear=0,this.depthFar=0}init(t,e){if(this.texture===null){let i=new Na(t.texture);(t.depthNear!==e.depthNear||t.depthFar!==e.depthFar)&&(this.depthNear=t.depthNear,this.depthFar=t.depthFar),this.texture=i}}getMesh(t){if(this.texture!==null&&this.mesh===null){let e=t.cameras[0].viewport,i=new ze({vertexShader:R_,fragmentShader:C_,uniforms:{depthColor:{value:this.texture},depthWidth:{value:e.z},depthHeight:{value:e.w}}});this.mesh=new Pt(new Ti(20,20),i)}return this.mesh}reset(){this.texture=null,this.mesh=null}getDepthTexture(){return this.texture}},xd=class extends yn{constructor(t,e){super();let i=this,s=null,r=1,a=null,o="local-floor",c=1,l=null,h=null,u=null,d=null,f=null,p=null,x=typeof XRWebGLBinding<"u",m=new gd,g={},_=e.getContextAttributes(),T=null,v=null,S=[],M=[],A=new ot,y=null,E=null,P=new ni;P.viewport=new Le;let N=new ni;N.viewport=new Le;let F=[P,N],B=new Zl,I=null,H=null;this.cameraAutoUpdate=!0,this.enabled=!1,this.isPresenting=!1,this.getController=function($){let rt=S[$];return rt===void 0&&(rt=new pr,S[$]=rt),rt.getTargetRaySpace()},this.getControllerGrip=function($){let rt=S[$];return rt===void 0&&(rt=new pr,S[$]=rt),rt.getGripSpace()},this.getHand=function($){let rt=S[$];return rt===void 0&&(rt=new pr,S[$]=rt),rt.getHandSpace()};function W($){let rt=M.indexOf($.inputSource);if(rt===-1)return;let _t=S[rt];_t!==void 0&&(_t.update($.inputSource,$.frame,l||a),_t.dispatchEvent({type:$.type,data:$.inputSource}))}function U(){s.removeEventListener("select",W),s.removeEventListener("selectstart",W),s.removeEventListener("selectend",W),s.removeEventListener("squeeze",W),s.removeEventListener("squeezestart",W),s.removeEventListener("squeezeend",W),s.removeEventListener("end",U),s.removeEventListener("inputsourceschange",X);for(let $=0;$<S.length;$++){let rt=M[$];rt!==null&&(M[$]=null,S[$].disconnect(rt))}I=null,H=null,m.reset();for(let $ in g)delete g[$];if(t.setRenderTarget(T),f=null,d=null,u=null,s=null,v=null,Kt.stop(),i.isPresenting=!1,t.setPixelRatio(y),t.setSize(A.width,A.height,!1),E!==null){let $=E.camera;$.fov=E.fov,$.zoom=E.zoom,$.updateProjectionMatrix(),E=null}i.dispatchEvent({type:"sessionend"})}this.setFramebufferScaleFactor=function($){r=$,i.isPresenting===!0&&te("WebXRManager: Cannot change framebuffer scale while presenting.")},this.setReferenceSpaceType=function($){o=$,i.isPresenting===!0&&te("WebXRManager: Cannot change reference space type while presenting.")},this.getReferenceSpace=function(){return l||a},this.setReferenceSpace=function($){l=$},this.getBaseLayer=function(){return d!==null?d:f},this.getBinding=function(){return u===null&&x&&(u=new XRWebGLBinding(s,e)),u},this.getFrame=function(){return p},this.getSession=function(){return s},this.setSession=async function($){if(s=$,s!==null){if(T=t.getRenderTarget(),s.addEventListener("select",W),s.addEventListener("selectstart",W),s.addEventListener("selectend",W),s.addEventListener("squeeze",W),s.addEventListener("squeezestart",W),s.addEventListener("squeezeend",W),s.addEventListener("end",U),s.addEventListener("inputsourceschange",X),_.xrCompatible!==!0&&await e.makeXRCompatible(),y=t.getPixelRatio(),t.getSize(A),x&&"createProjectionLayer"in XRWebGLBinding.prototype){let _t=null,Jt=null,At=null;_.depth&&(At=_.stencil?e.DEPTH24_STENCIL8:e.DEPTH_COMPONENT24,_t=_.stencil?ls:vn,Jt=_.stencil?Ir:cn);let Yt={colorFormat:e.RGBA8,depthFormat:At,scaleFactor:r};u=this.getBinding(),d=u.createProjectionLayer(Yt),s.updateRenderState({layers:[d]}),t.setPixelRatio(1),t.setSize(d.textureWidth,d.textureHeight,!1),v=new ke(d.textureWidth,d.textureHeight,{format:Ji,type:Ci,depthTexture:new jn(d.textureWidth,d.textureHeight,Jt,void 0,void 0,void 0,void 0,void 0,void 0,_t),stencilBuffer:_.stencil,colorSpace:t.outputColorSpace,samples:_.antialias?4:0,resolveDepthBuffer:d.ignoreDepthValues===!1,resolveStencilBuffer:d.ignoreDepthValues===!1,storeMultisampledDepthBuffer:d.ignoreDepthValues===!1,storeMultisampledStencilBuffer:d.ignoreDepthValues===!1})}else{let _t={antialias:_.antialias,alpha:!0,depth:_.depth,stencil:_.stencil,framebufferScaleFactor:r};f=new XRWebGLLayer(s,e,_t),s.updateRenderState({baseLayer:f}),t.setPixelRatio(1),t.setSize(f.framebufferWidth,f.framebufferHeight,!1),v=new ke(f.framebufferWidth,f.framebufferHeight,{format:Ji,type:Ci,colorSpace:t.outputColorSpace,stencilBuffer:_.stencil,resolveDepthBuffer:f.ignoreDepthValues===!1,resolveStencilBuffer:f.ignoreDepthValues===!1,storeMultisampledDepthBuffer:f.ignoreDepthValues===!1,storeMultisampledStencilBuffer:f.ignoreDepthValues===!1})}v.isXRRenderTarget=!0,this.setFoveation(c),l=null,a=await s.requestReferenceSpace(o),Kt.setContext(s),Kt.start(),i.isPresenting=!0,i.dispatchEvent({type:"sessionstart"})}},this.getEnvironmentBlendMode=function(){if(s!==null)return s.environmentBlendMode},this.getDepthTexture=function(){return m.getDepthTexture()};function X($){for(let rt=0;rt<$.removed.length;rt++){let _t=$.removed[rt],Jt=M.indexOf(_t);Jt>=0&&(M[Jt]=null,S[Jt].disconnect(_t))}for(let rt=0;rt<$.added.length;rt++){let _t=$.added[rt],Jt=M.indexOf(_t);if(Jt===-1){for(let Yt=0;Yt<S.length;Yt++)if(Yt>=M.length){M.push(_t),Jt=Yt;break}else if(M[Yt]===null){M[Yt]=_t,Jt=Yt;break}if(Jt===-1)break}let At=S[Jt];At&&At.connect(_t)}}let G=new D,j=new D;function et($,rt,_t){G.setFromMatrixPosition(rt.matrixWorld),j.setFromMatrixPosition(_t.matrixWorld);let Jt=G.distanceTo(j),At=rt.projectionMatrix.elements,Yt=_t.projectionMatrix.elements,fe=At[14]/(At[10]-1),at=At[14]/(At[10]+1),ut=(At[9]+1)/At[5],pt=(At[9]-1)/At[5],mt=(At[8]-1)/At[0],w=(Yt[8]+1)/Yt[0],J=fe*mt,Q=fe*w,st=Jt/(-mt+w),nt=st*-mt;if(rt.matrixWorld.decompose($.position,$.quaternion,$.scale),$.translateX(nt),$.translateZ(st),$.matrixWorld.compose($.position,$.quaternion,$.scale),$.matrixWorldInverse.copy($.matrixWorld).invert(),At[10]===-1)$.projectionMatrix.copy(rt.projectionMatrix),$.projectionMatrixInverse.copy(rt.projectionMatrixInverse);else{let L=fe+st,yt=at+st,zt=J-nt,C=Q+(Jt-nt),b=ut*at/yt*L,O=pt*at/yt*L;$.projectionMatrix.makePerspective(zt,C,b,O,L,yt),$.projectionMatrixInverse.copy($.projectionMatrix).invert()}}function vt($,rt){rt===null?$.matrixWorld.copy($.matrix):$.matrixWorld.multiplyMatrices(rt.matrixWorld,$.matrix),$.matrixWorldInverse.copy($.matrixWorld).invert()}this.updateCamera=function($){if(s===null)return;let rt=$.near,_t=$.far;m.texture!==null&&(m.depthNear>0&&(rt=m.depthNear),m.depthFar>0&&(_t=m.depthFar)),B.near=N.near=P.near=rt,B.far=N.far=P.far=_t,(I!==B.near||H!==B.far)&&(s.updateRenderState({depthNear:B.near,depthFar:B.far}),I=B.near,H=B.far),B.layers.mask=$.layers.mask|6,P.layers.mask=B.layers.mask&-5,N.layers.mask=B.layers.mask&-3;let Jt=$.parent,At=B.cameras;vt(B,Jt);for(let Yt=0;Yt<At.length;Yt++)vt(At[Yt],Jt);At.length===2?et(B,P,N):B.projectionMatrix.copy(P.projectionMatrix),E===null&&$.isPerspectiveCamera&&(E={camera:$,fov:$.fov,zoom:$.zoom}),ht($,B,Jt)};function ht($,rt,_t){_t===null?$.matrix.copy(rt.matrixWorld):($.matrix.copy(_t.matrixWorld),$.matrix.invert(),$.matrix.multiply(rt.matrixWorld)),$.matrix.decompose($.position,$.quaternion,$.scale),$.updateMatrixWorld(!0),$.projectionMatrix.copy(rt.projectionMatrix),$.projectionMatrixInverse.copy(rt.projectionMatrixInverse),$.isPerspectiveCamera&&($.fov=ur*2*Math.atan(1/$.projectionMatrix.elements[5]),$.zoom=1)}this.getCamera=function(){return B},this.getFoveation=function(){if(!(d===null&&f===null))return c},this.setFoveation=function($){c=$,d!==null&&(d.fixedFoveation=$),f!==null&&f.fixedFoveation!==void 0&&(f.fixedFoveation=$)},this.hasDepthSensing=function(){return m.texture!==null},this.getDepthSensingMesh=function(){return m.getMesh(B)},this.getCameraTexture=function($){return g[$]};let Ut=null;function $t($,rt){if(h=rt.getViewerPose(l||a),p=rt,h!==null){let _t=h.views;f!==null&&(t.setRenderTargetFramebuffer(v,f.framebuffer),t.setRenderTarget(v));let Jt=!1;_t.length!==B.cameras.length&&(B.cameras.length=0,Jt=!0);for(let at=0;at<_t.length;at++){let ut=_t[at],pt=null;if(f!==null)pt=f.getViewport(ut);else{let w=u.getViewSubImage(d,ut);pt=w.viewport,at===0&&(t.setRenderTargetTextures(v,w.colorTexture,w.depthStencilTexture),t.setRenderTarget(v))}let mt=F[at];mt===void 0&&(mt=new ni,mt.layers.enable(at),mt.viewport=new Le,F[at]=mt),mt.matrix.fromArray(ut.transform.matrix),mt.matrix.decompose(mt.position,mt.quaternion,mt.scale),mt.projectionMatrix.fromArray(ut.projectionMatrix),mt.projectionMatrixInverse.copy(mt.projectionMatrix).invert(),mt.viewport.set(pt.x,pt.y,pt.width,pt.height),at===0&&(B.matrix.copy(mt.matrix),B.matrix.decompose(B.position,B.quaternion,B.scale)),Jt===!0&&B.cameras.push(mt)}let At=s.enabledFeatures;if(At&&At.includes("depth-sensing")&&s.depthUsage=="gpu-optimized"&&x){u=i.getBinding();let at=u.getDepthInformation(_t[0]);at&&at.isValid&&at.texture&&m.init(at,s.renderState)}if(At&&At.includes("camera-access")&&x){t.state.unbindTexture(),u=i.getBinding();for(let at=0;at<_t.length;at++){let ut=_t[at].camera;if(ut){let pt=g[ut];pt||(pt=new Na,g[ut]=pt);let mt=u.getCameraImage(ut);pt.sourceTexture=mt}}}}for(let _t=0;_t<S.length;_t++){let Jt=M[_t],At=S[_t];Jt!==null&&At!==void 0&&At.update(Jt,rt,l||a)}Ut&&Ut($,rt),rt.detectedPlanes&&i.dispatchEvent({type:"planesdetected",data:rt}),p=null}let Kt=new cp;Kt.setAnimationLoop($t),this.setAnimationLoop=function($){Ut=$},this.dispose=function(){}}},P_=new me,mp=new ie;mp.set(-1,0,0,0,1,0,0,0,1);function I_(n,t){function e(m,g){m.matrixAutoUpdate===!0&&m.updateMatrix(),g.value.copy(m.matrix)}function i(m,g){g.color.getRGB(m.fogColor.value,Yu(n)),g.isFog?(m.fogNear.value=g.near,m.fogFar.value=g.far):g.isFogExp2&&(m.fogDensity.value=g.density)}function s(m,g,_,T,v){g.isNodeMaterial?g.uniformsNeedUpdate=!1:g.isMeshBasicMaterial?r(m,g):g.isMeshLambertMaterial?(r(m,g),g.envMap&&(m.envMapIntensity.value=g.envMapIntensity)):g.isMeshToonMaterial?(r(m,g),u(m,g)):g.isMeshPhongMaterial?(r(m,g),h(m,g),g.envMap&&(m.envMapIntensity.value=g.envMapIntensity)):g.isMeshStandardMaterial?(r(m,g),d(m,g),g.isMeshPhysicalMaterial&&f(m,g,v)):g.isMeshMatcapMaterial?(r(m,g),p(m,g)):g.isMeshDepthMaterial?r(m,g):g.isMeshDistanceMaterial?(r(m,g),x(m,g)):g.isMeshNormalMaterial?r(m,g):g.isLineBasicMaterial?(a(m,g),g.isLineDashedMaterial&&o(m,g)):g.isPointsMaterial?c(m,g,_,T):g.isSpriteMaterial?l(m,g):g.isShadowMaterial?(m.color.value.copy(g.color),m.opacity.value=g.opacity):g.isShaderMaterial&&(g.uniformsNeedUpdate=!1)}function r(m,g){m.opacity.value=g.opacity,g.color&&m.diffuse.value.copy(g.color),g.emissive&&m.emissive.value.copy(g.emissive).multiplyScalar(g.emissiveIntensity),g.map&&(m.map.value=g.map,e(g.map,m.mapTransform)),g.alphaMap&&(m.alphaMap.value=g.alphaMap,e(g.alphaMap,m.alphaMapTransform)),g.bumpMap&&(m.bumpMap.value=g.bumpMap,e(g.bumpMap,m.bumpMapTransform),m.bumpScale.value=g.bumpScale,g.side===di&&(m.bumpScale.value*=-1)),g.normalMap&&(m.normalMap.value=g.normalMap,e(g.normalMap,m.normalMapTransform),m.normalScale.value.copy(g.normalScale),g.side===di&&m.normalScale.value.negate()),g.displacementMap&&(m.displacementMap.value=g.displacementMap,e(g.displacementMap,m.displacementMapTransform),m.displacementScale.value=g.displacementScale,m.displacementBias.value=g.displacementBias),g.emissiveMap&&(m.emissiveMap.value=g.emissiveMap,e(g.emissiveMap,m.emissiveMapTransform)),g.specularMap&&(m.specularMap.value=g.specularMap,e(g.specularMap,m.specularMapTransform)),g.alphaTest>0&&(m.alphaTest.value=g.alphaTest);let _=t.get(g),T=_.envMap,v=_.envMapRotation;T&&(m.envMap.value=T,m.envMapRotation.value.setFromMatrix4(P_.makeRotationFromEuler(v)).transpose(),T.isCubeTexture&&T.isRenderTargetTexture===!1&&m.envMapRotation.value.premultiply(mp),m.reflectivity.value=g.reflectivity,m.ior.value=g.ior,m.refractionRatio.value=g.refractionRatio),g.lightMap&&(m.lightMap.value=g.lightMap,m.lightMapIntensity.value=g.lightMapIntensity,e(g.lightMap,m.lightMapTransform)),g.aoMap&&(m.aoMap.value=g.aoMap,m.aoMapIntensity.value=g.aoMapIntensity,e(g.aoMap,m.aoMapTransform))}function a(m,g){m.diffuse.value.copy(g.color),m.opacity.value=g.opacity,g.map&&(m.map.value=g.map,e(g.map,m.mapTransform))}function o(m,g){m.dashSize.value=g.dashSize,m.totalSize.value=g.dashSize+g.gapSize,m.scale.value=g.scale}function c(m,g,_,T){m.diffuse.value.copy(g.color),m.opacity.value=g.opacity,m.size.value=g.size*_,m.scale.value=T*.5,g.map&&(m.map.value=g.map,e(g.map,m.uvTransform)),g.alphaMap&&(m.alphaMap.value=g.alphaMap,e(g.alphaMap,m.alphaMapTransform)),g.alphaTest>0&&(m.alphaTest.value=g.alphaTest)}function l(m,g){m.diffuse.value.copy(g.color),m.opacity.value=g.opacity,m.rotation.value=g.rotation,g.map&&(m.map.value=g.map,e(g.map,m.mapTransform)),g.alphaMap&&(m.alphaMap.value=g.alphaMap,e(g.alphaMap,m.alphaMapTransform)),g.alphaTest>0&&(m.alphaTest.value=g.alphaTest)}function h(m,g){m.specular.value.copy(g.specular),m.shininess.value=Math.max(g.shininess,1e-4)}function u(m,g){g.gradientMap&&(m.gradientMap.value=g.gradientMap)}function d(m,g){m.metalness.value=g.metalness,g.metalnessMap&&(m.metalnessMap.value=g.metalnessMap,e(g.metalnessMap,m.metalnessMapTransform)),m.roughness.value=g.roughness,g.roughnessMap&&(m.roughnessMap.value=g.roughnessMap,e(g.roughnessMap,m.roughnessMapTransform)),g.envMap&&(m.envMapIntensity.value=g.envMapIntensity)}function f(m,g,_){m.ior.value=g.ior,g.sheen>0&&(m.sheenColor.value.copy(g.sheenColor).multiplyScalar(g.sheen),m.sheenRoughness.value=g.sheenRoughness,g.sheenColorMap&&(m.sheenColorMap.value=g.sheenColorMap,e(g.sheenColorMap,m.sheenColorMapTransform)),g.sheenRoughnessMap&&(m.sheenRoughnessMap.value=g.sheenRoughnessMap,e(g.sheenRoughnessMap,m.sheenRoughnessMapTransform))),g.clearcoat>0&&(m.clearcoat.value=g.clearcoat,m.clearcoatRoughness.value=g.clearcoatRoughness,g.clearcoatMap&&(m.clearcoatMap.value=g.clearcoatMap,e(g.clearcoatMap,m.clearcoatMapTransform)),g.clearcoatRoughnessMap&&(m.clearcoatRoughnessMap.value=g.clearcoatRoughnessMap,e(g.clearcoatRoughnessMap,m.clearcoatRoughnessMapTransform)),g.clearcoatNormalMap&&(m.clearcoatNormalMap.value=g.clearcoatNormalMap,e(g.clearcoatNormalMap,m.clearcoatNormalMapTransform),m.clearcoatNormalScale.value.copy(g.clearcoatNormalScale),g.side===di&&m.clearcoatNormalScale.value.negate())),g.dispersion>0&&(m.dispersion.value=g.dispersion),g.retroreflectivity>0&&(m.retroreflectivity.value=g.retroreflectivity),g.iridescence>0&&(m.iridescence.value=g.iridescence,m.iridescenceIOR.value=g.iridescenceIOR,m.iridescenceThicknessMinimum.value=g.iridescenceThicknessRange[0],m.iridescenceThicknessMaximum.value=g.iridescenceThicknessRange[1],g.iridescenceMap&&(m.iridescenceMap.value=g.iridescenceMap,e(g.iridescenceMap,m.iridescenceMapTransform)),g.iridescenceThicknessMap&&(m.iridescenceThicknessMap.value=g.iridescenceThicknessMap,e(g.iridescenceThicknessMap,m.iridescenceThicknessMapTransform))),g.transmission>0&&(m.transmission.value=g.transmission,m.transmissionSamplerMap.value=_.texture,m.transmissionSamplerSize.value.set(_.width,_.height),g.transmissionMap&&(m.transmissionMap.value=g.transmissionMap,e(g.transmissionMap,m.transmissionMapTransform)),m.thickness.value=g.thickness,g.thicknessMap&&(m.thicknessMap.value=g.thicknessMap,e(g.thicknessMap,m.thicknessMapTransform)),m.attenuationDistance.value=g.attenuationDistance,m.attenuationColor.value.copy(g.attenuationColor)),g.anisotropy>0&&(m.anisotropyVector.value.set(g.anisotropy*Math.cos(g.anisotropyRotation),g.anisotropy*Math.sin(g.anisotropyRotation)),g.anisotropyMap&&(m.anisotropyMap.value=g.anisotropyMap,e(g.anisotropyMap,m.anisotropyMapTransform))),m.specularIntensity.value=g.specularIntensity,m.specularColor.value.copy(g.specularColor),g.specularColorMap&&(m.specularColorMap.value=g.specularColorMap,e(g.specularColorMap,m.specularColorMapTransform)),g.specularIntensityMap&&(m.specularIntensityMap.value=g.specularIntensityMap,e(g.specularIntensityMap,m.specularIntensityMapTransform))}function p(m,g){g.matcap&&(m.matcap.value=g.matcap)}function x(m,g){let _=t.get(g).light;m.referencePosition.value.setFromMatrixPosition(_.matrixWorld),m.nearDistance.value=_.shadow.camera.near,m.farDistance.value=_.shadow.camera.far}return{refreshFogUniforms:i,refreshMaterialUniforms:s}}function L_(n,t,e,i){let s={},r={},a=[],o=n.getParameter(n.MAX_UNIFORM_BUFFER_BINDINGS);function c(v,S){let M=S.program;i.uniformBlockBinding(v,M)}function l(v,S){let M=s[v.id];M===void 0&&(m(v),M=h(v),s[v.id]=M,v.addEventListener("dispose",_));let A=S.program;i.updateUBOMapping(v,A);let y=t.render.frame;r[v.id]!==y&&(d(v),r[v.id]=y)}function h(v){let S=u();v.__bindingPointIndex=S;let M=n.createBuffer(),A=v.__size,y=v.usage;return n.bindBuffer(n.UNIFORM_BUFFER,M),n.bufferData(n.UNIFORM_BUFFER,A,y),n.bindBuffer(n.UNIFORM_BUFFER,null),n.bindBufferBase(n.UNIFORM_BUFFER,S,M),M}function u(){for(let v=0;v<o;v++)if(a.indexOf(v)===-1)return a.push(v),v;return ee("WebGLRenderer: Maximum number of simultaneously usable uniforms groups reached."),0}function d(v){let S=s[v.id],M=v.uniforms,A=v.__cache;n.bindBuffer(n.UNIFORM_BUFFER,S);for(let y=0,E=M.length;y<E;y++){let P=M[y];if(Array.isArray(P))for(let N=0,F=P.length;N<F;N++)f(P[N],y,N,A);else f(P,y,0,A)}n.bindBuffer(n.UNIFORM_BUFFER,null)}function f(v,S,M,A){if(x(v,S,M,A)===!0){let y=v.__offset,E=v.value;if(Array.isArray(E)){let P=0;for(let N=0;N<E.length;N++){let F=E[N],B=g(F);p(F,v.__data,P),typeof F!="number"&&typeof F!="boolean"&&!F.isMatrix3&&!ArrayBuffer.isView(F)&&(P+=B.storage/Float32Array.BYTES_PER_ELEMENT)}}else p(E,v.__data,0);n.bufferSubData(n.UNIFORM_BUFFER,y,v.__data)}}function p(v,S,M){typeof v=="number"||typeof v=="boolean"?S[0]=v:v.isMatrix3?(S[0]=v.elements[0],S[1]=v.elements[1],S[2]=v.elements[2],S[3]=0,S[4]=v.elements[3],S[5]=v.elements[4],S[6]=v.elements[5],S[7]=0,S[8]=v.elements[6],S[9]=v.elements[7],S[10]=v.elements[8],S[11]=0):ArrayBuffer.isView(v)?S.set(new v.constructor(v.buffer,v.byteOffset,S.length)):v.toArray(S,M)}function x(v,S,M,A){let y=v.value,E=S+"_"+M;if(A[E]===void 0)return typeof y=="number"||typeof y=="boolean"?A[E]=y:ArrayBuffer.isView(y)?A[E]=y.slice():A[E]=y.clone(),!0;{let P=A[E];if(typeof y=="number"||typeof y=="boolean"){if(P!==y)return A[E]=y,!0}else{if(ArrayBuffer.isView(y))return!0;if(P.equals(y)===!1)return P.copy(y),!0}}return!1}function m(v){let S=v.uniforms,M=0,A=16;for(let E=0,P=S.length;E<P;E++){let N=Array.isArray(S[E])?S[E]:[S[E]];for(let F=0,B=N.length;F<B;F++){let I=N[F],H=Array.isArray(I.value)?I.value:[I.value];for(let W=0,U=H.length;W<U;W++){let X=H[W],G=g(X),j=M%A,et=j%G.boundary,vt=j+et;M+=et,vt!==0&&A-vt<G.storage&&(M+=A-vt),I.__data=new Float32Array(G.storage/Float32Array.BYTES_PER_ELEMENT),I.__offset=M,M+=G.storage}}}let y=M%A;return y>0&&(M+=A-y),v.__size=M,v.__cache={},this}function g(v){let S={boundary:0,storage:0};return typeof v=="number"||typeof v=="boolean"?(S.boundary=4,S.storage=4):v.isVector2?(S.boundary=8,S.storage=8):v.isVector3||v.isColor?(S.boundary=16,S.storage=12):v.isVector4?(S.boundary=16,S.storage=16):v.isMatrix3?(S.boundary=48,S.storage=48):v.isMatrix4?(S.boundary=64,S.storage=64):v.isTexture?te("WebGLRenderer: Texture samplers can not be part of an uniforms group."):ArrayBuffer.isView(v)?(S.boundary=16,S.storage=v.byteLength):te("WebGLRenderer: Unsupported uniform value type.",v),S}function _(v){let S=v.target;S.removeEventListener("dispose",_);let M=a.indexOf(S.__bindingPointIndex);a.splice(M,1),n.deleteBuffer(s[S.id]),delete s[S.id],delete r[S.id]}function T(){for(let v in s)n.deleteBuffer(s[v]);a=[],s={},r={}}return{bind:c,update:l,dispose:T}}var D_=new Uint16Array([12469,15057,12620,14925,13266,14620,13807,14376,14323,13990,14545,13625,14713,13328,14840,12882,14931,12528,14996,12233,15039,11829,15066,11525,15080,11295,15085,10976,15082,10705,15073,10495,13880,14564,13898,14542,13977,14430,14158,14124,14393,13732,14556,13410,14702,12996,14814,12596,14891,12291,14937,11834,14957,11489,14958,11194,14943,10803,14921,10506,14893,10278,14858,9960,14484,14039,14487,14025,14499,13941,14524,13740,14574,13468,14654,13106,14743,12678,14818,12344,14867,11893,14889,11509,14893,11180,14881,10751,14852,10428,14812,10128,14765,9754,14712,9466,14764,13480,14764,13475,14766,13440,14766,13347,14769,13070,14786,12713,14816,12387,14844,11957,14860,11549,14868,11215,14855,10751,14825,10403,14782,10044,14729,9651,14666,9352,14599,9029,14967,12835,14966,12831,14963,12804,14954,12723,14936,12564,14917,12347,14900,11958,14886,11569,14878,11247,14859,10765,14828,10401,14784,10011,14727,9600,14660,9289,14586,8893,14508,8533,15111,12234,15110,12234,15104,12216,15092,12156,15067,12010,15028,11776,14981,11500,14942,11205,14902,10752,14861,10393,14812,9991,14752,9570,14682,9252,14603,8808,14519,8445,14431,8145,15209,11449,15208,11451,15202,11451,15190,11438,15163,11384,15117,11274,15055,10979,14994,10648,14932,10343,14871,9936,14803,9532,14729,9218,14645,8742,14556,8381,14461,8020,14365,7603,15273,10603,15272,10607,15267,10619,15256,10631,15231,10614,15182,10535,15118,10389,15042,10167,14963,9787,14883,9447,14800,9115,14710,8665,14615,8318,14514,7911,14411,7507,14279,7198,15314,9675,15313,9683,15309,9712,15298,9759,15277,9797,15229,9773,15166,9668,15084,9487,14995,9274,14898,8910,14800,8539,14697,8234,14590,7790,14479,7409,14367,7067,14178,6621,15337,8619,15337,8631,15333,8677,15325,8769,15305,8871,15264,8940,15202,8909,15119,8775,15022,8565,14916,8328,14804,8009,14688,7614,14569,7287,14448,6888,14321,6483,14088,6171,15350,7402,15350,7419,15347,7480,15340,7613,15322,7804,15287,7973,15229,8057,15148,8012,15046,7846,14933,7611,14810,7357,14682,7069,14552,6656,14421,6316,14251,5948,14007,5528,15356,5942,15356,5977,15353,6119,15348,6294,15332,6551,15302,6824,15249,7044,15171,7122,15070,7050,14949,6861,14818,6611,14679,6349,14538,6067,14398,5651,14189,5311,13935,4958,15359,4123,15359,4153,15356,4296,15353,4646,15338,5160,15311,5508,15263,5829,15188,6042,15088,6094,14966,6001,14826,5796,14678,5543,14527,5287,14377,4985,14133,4586,13869,4257,15360,1563,15360,1642,15358,2076,15354,2636,15341,3350,15317,4019,15273,4429,15203,4732,15105,4911,14981,4932,14836,4818,14679,4621,14517,4386,14359,4156,14083,3795,13808,3437,15360,122,15360,137,15358,285,15355,636,15344,1274,15322,2177,15281,2765,15215,3223,15120,3451,14995,3569,14846,3567,14681,3466,14511,3305,14344,3121,14037,2800,13753,2467,15360,0,15360,1,15359,21,15355,89,15346,253,15325,479,15287,796,15225,1148,15133,1492,15008,1749,14856,1882,14685,1886,14506,1783,14324,1608,13996,1398,13702,1183]),Mn=null;function N_(){return Mn===null&&(Mn=new Ca(D_,16,16,cs,qe),Mn.name="DFG_LUT",Mn.minFilter=Ye,Mn.magFilter=Ye,Mn.wrapS=gn,Mn.wrapT=gn,Mn.generateMipmaps=!1,Mn.needsUpdate=!0),Mn}var Gc=class{constructor(t={}){let{canvas:e=P0(),context:i=null,depth:s=!0,stencil:r=!1,alpha:a=!1,antialias:o=!1,premultipliedAlpha:c=!0,preserveDrawingBuffer:l=!1,powerPreference:h="default",failIfMajorPerformanceCaveat:u=!1,reversedDepthBuffer:d=!1,outputBufferType:f=Ci}=t;this.isWebGLRenderer=!0;let p;if(i!==null){if(typeof WebGLRenderingContext<"u"&&i instanceof WebGLRenderingContext)throw new Error("THREE.WebGLRenderer: WebGL 1 is not supported since r163.");p=i.getContextAttributes().alpha}else p=a;let x=f,m=new Set([oc,ac,rc]),g=new Set([Ci,cn,Pr,Ir,ic,nc]),_=new Uint32Array(4),T=new Int32Array(4),v=new D,S=null,M=null,A=[],y=[],E=null;this.domElement=e,this.debug={checkShaderErrors:!0,diagnostics:{keywords:!1},onShaderError:null},this.autoClear=!0,this.autoClearColor=!0,this.autoClearDepth=!0,this.autoClearStencil=!0,this.sortObjects=!0,this.clippingPlanes=[],this.localClippingEnabled=!1,this.toneMapping=ln,this.toneMappingExposure=1,this.transmissionResolutionScale=1;let P=this,N=!1,F=null,B=null,I=null,H=null;this._outputColorSpace=Oe;let W=0,U=0,X=null,G=-1,j=null,et=new Le,vt=new Le,ht=null,Ut=new Nt(0),$t=0,Kt=e.width,$=e.height,rt=1,_t=null,Jt=null,At=new Le(0,0,Kt,$),Yt=new Le(0,0,Kt,$),fe=!1,at=new vr,ut=!1,pt=!1,mt=new me,w=new D,J=new Le,Q={background:null,fog:null,environment:null,overrideMaterial:null,isScene:!0},st=!1;function nt(){return X===null?rt:1}let L=i;function yt(R,z){return e.getContext(R,z)}let zt,C,b,O,V,K,gt,xt,it,ct,wt,kt,Mt,bt,Bt,jt,ne,k,Tt,lt,Et,Dt,ft;try{let R={alpha:!0,depth:s,stencil:r,antialias:o,premultipliedAlpha:c,preserveDrawingBuffer:l,powerPreference:h,failIfMajorPerformanceCaveat:u};if("setAttribute"in e&&e.setAttribute("data-engine",`three.js r${"186"}`),e.addEventListener("webglcontextlost",De,!1),e.addEventListener("webglcontextrestored",Me,!1),e.addEventListener("webglcontextcreationerror",tn,!1),L===null){let z="webgl2";if(L=yt(z,R),L===null)throw yt(z)?new Error("THREE.WebGLRenderer: Error creating WebGL context with your selected attributes."):new Error("THREE.WebGLRenderer: Error creating WebGL context.")}Zt()}catch(R){throw e.removeEventListener("webglcontextlost",De,!1),e.removeEventListener("webglcontextrestored",Me,!1),e.removeEventListener("webglcontextcreationerror",tn,!1),ee("WebGLRenderer: "+R.message),R}function Zt(){zt=new Hv(L),zt.init(),Et=new A_(L,zt),C=new Iv(L,zt,t,Et),b=new T_(L,zt),C.reversedDepthBuffer&&d&&b.buffers.depth.setReversed(!0),B=L.createFramebuffer(),I=L.createFramebuffer(),H=L.createFramebuffer(),O=new Wv(L),V=new u_,K=new E_(L,zt,b,V,C,Et,O),gt=new Bv(P),xt=new qg(L),Dt=new Cv(L,xt),it=new Gv(L,xt,O,Dt),ct=new qv(L,it,xt,Dt,O),k=new Xv(L,C,K),Bt=new Lv(V),wt=new h_(P,gt,zt,C,Dt,Bt),kt=new I_(P,V),Mt=new f_,bt=new y_(zt),ne=new Rv(P,gt,b,ct,p,c),jt=new w_(P,ct,C),ft=new L_(L,O,C,b),Tt=new Pv(L,zt,O),lt=new Vv(L,zt,O),O.programs=wt.programs,P.capabilities=C,P.extensions=zt,P.properties=V,P.renderLists=Mt,P.shadowMap=jt,P.state=b,P.info=O}x!==Ci&&(E=new Yv(x,e.width,e.height,o,s,r));let Wt=new xd(P,L);this.xr=Wt,this.getContext=function(){return L},this.getContextAttributes=function(){return L.getContextAttributes()},this.forceContextLoss=function(){let R=zt.get("WEBGL_lose_context");R&&R.loseContext()},this.forceContextRestore=function(){let R=zt.get("WEBGL_lose_context");R&&R.restoreContext()},this.getPixelRatio=function(){return rt},this.setPixelRatio=function(R){R!==void 0&&(rt=R,this.setSize(Kt,$,!1))},this.getSize=function(R){return R.set(Kt,$)},this.setSize=function(R,z,tt=!0){if(Wt.isPresenting){te("WebGLRenderer: Can't change size while VR device is presenting.");return}Kt=R,$=z,e.width=Math.floor(R*rt),e.height=Math.floor(z*rt),tt===!0&&(e.style.width=R+"px",e.style.height=z+"px"),E!==null&&E.setSize(e.width,e.height),this.setViewport(0,0,R,z)},this.getDrawingBufferSize=function(R){return R.set(Kt*rt,$*rt).floor()},this.setDrawingBufferSize=function(R,z,tt){Kt=R,$=z,rt=tt,e.width=Math.floor(R*tt),e.height=Math.floor(z*tt),this.setViewport(0,0,R,z)},this.setEffects=function(R){if(x===Ci){ee("WebGLRenderer: setEffects() requires outputBufferType set to HalfFloatType or FloatType.");return}if(R){for(let z=0;z<R.length;z++)if(R[z].isOutputPass===!0){te("WebGLRenderer: OutputPass is not needed in setEffects(). Tone mapping and color space conversion are applied automatically.");break}}E.setEffects(R||[])},this.getCurrentViewport=function(R){return R.copy(et)},this.getViewport=function(R){return R.copy(At)},this.setViewport=function(R,z,tt,Y){R.isVector4?At.set(R.x,R.y,R.z,R.w):At.set(R,z,tt,Y),b.viewport(et.copy(At).multiplyScalar(rt).round())},this.getScissor=function(R){return R.copy(Yt)},this.setScissor=function(R,z,tt,Y){R.isVector4?Yt.set(R.x,R.y,R.z,R.w):Yt.set(R,z,tt,Y),b.scissor(vt.copy(Yt).multiplyScalar(rt).round())},this.getScissorTest=function(){return fe},this.setScissorTest=function(R){b.setScissorTest(fe=R)},this.setOpaqueSort=function(R){_t=R},this.setTransparentSort=function(R){Jt=R},this.getClearColor=function(R){return R.copy(ne.getClearColor())},this.setClearColor=function(){ne.setClearColor(...arguments)},this.getClearAlpha=function(){return ne.getClearAlpha()},this.setClearAlpha=function(){ne.setClearAlpha(...arguments)},this.clear=function(R=!0,z=!0,tt=!0){let Y=0;if(R){let Z=!1;if(X!==null){let It=X.texture.format;Z=m.has(It)}if(Z){let It=X.texture.type,Ot=g.has(It),Ct=ne.getClearColor(),Ht=ne.getClearAlpha(),Xt=Ct.r,ae=Ct.g,ue=Ct.b;Ot?(_[0]=Xt,_[1]=ae,_[2]=ue,_[3]=Ht,L.clearBufferuiv(L.COLOR,0,_)):(T[0]=Xt,T[1]=ae,T[2]=ue,T[3]=Ht,L.clearBufferiv(L.COLOR,0,T))}else Y|=L.COLOR_BUFFER_BIT}z&&(Y|=L.DEPTH_BUFFER_BIT,this.state.buffers.depth.setMask(!0)),tt&&(Y|=L.STENCIL_BUFFER_BIT,this.state.buffers.stencil.setMask(4294967295)),Y!==0&&L.clear(Y)},this.clearColor=function(){this.clear(!0,!1,!1)},this.clearDepth=function(){this.clear(!1,!0,!1)},this.clearStencil=function(){this.clear(!1,!1,!0)},this.setNodesHandler=function(R){R.setRenderer(this),F=R},this.dispose=function(){e.removeEventListener("webglcontextlost",De,!1),e.removeEventListener("webglcontextrestored",Me,!1),e.removeEventListener("webglcontextcreationerror",tn,!1),ne.dispose(),Mt.dispose(),bt.dispose(),V.dispose(),gt.dispose(),ct.dispose(),Dt.dispose(),ft.dispose(),wt.dispose(),Wt.dispose(),Wt.removeEventListener("sessionstart",ef),Wt.removeEventListener("sessionend",nf),vs.stop()};function De(R){R.preventDefault(),Ma("WebGLRenderer: Context Lost."),N=!0}function Me(){Ma("WebGLRenderer: Context Restored."),N=!1;let R=O.autoReset,z=jt.enabled,tt=jt.autoUpdate,Y=jt.needsUpdate,Z=jt.type;Zt(),O.autoReset=R,jt.enabled=z,jt.autoUpdate=tt,jt.needsUpdate=Y,jt.type=Z}function tn(R){ee("WebGLRenderer: A WebGL context could not be created. Reason: ",R.statusMessage)}function fn(R){let z=R.target;z.removeEventListener("dispose",fn),um(z)}function um(R){dm(R),V.remove(R)}function dm(R){let z=V.get(R).programs;z!==void 0&&(z.forEach(function(tt){wt.releaseProgram(tt)}),R.isShaderMaterial&&wt.releaseShaderCache(R))}this.renderBufferDirect=function(R,z,tt,Y,Z,It){z===null&&(z=Q);let Ot=Z.isMesh&&Z.matrixWorld.determinantAffine()<0,Ct=mm(R,z,tt,Y,Z);b.setMaterial(Y,Ot);let Ht=tt.index,Xt=1;if(Y.wireframe===!0){if(Ht=it.getWireframeAttribute(tt),Ht===void 0)return;Xt=2}let ae=tt.drawRange,ue=tt.attributes.position,Gt=ae.start*Xt,Se=(ae.start+ae.count)*Xt;It!==null&&(Gt=Math.max(Gt,It.start*Xt),Se=Math.min(Se,(It.start+It.count)*Xt)),Ht!==null?(Gt=Math.max(Gt,0),Se=Math.min(Se,Ht.count)):ue!=null&&(Gt=Math.max(Gt,0),Se=Math.min(Se,ue.count));let je=Se-Gt;if(je<0||je===1/0)return;Dt.setup(Z,Y,Ct,tt,Ht);let Ue,Ie=Tt;if(Ht!==null&&(Ue=xt.get(Ht),Ie=lt,Ie.setIndex(Ue)),Z.isMesh)Y.wireframe===!0?(b.setLineWidth(Y.wireframeLinewidth*nt()),Ie.setMode(L.LINES)):Ie.setMode(L.TRIANGLES);else if(Z.isLine){let pi=Y.linewidth;pi===void 0&&(pi=1),b.setLineWidth(pi*nt()),Z.isLineSegments?Ie.setMode(L.LINES):Z.isLineLoop?Ie.setMode(L.LINE_LOOP):Ie.setMode(L.LINE_STRIP)}else Z.isPoints?Ie.setMode(L.POINTS):Z.isSprite&&Ie.setMode(L.TRIANGLES);if(Z.isBatchedMesh)if(zt.get("WEBGL_multi_draw"))Ie.renderMultiDraw(Z._multiDrawStarts,Z._multiDrawCounts,Z._multiDrawCount);else{let pi=Z._multiDrawStarts,Ft=Z._multiDrawCounts,bi=Z._multiDrawCount,ye=Ht?xt.get(Ht).bytesPerElement:1,Vi=V.get(Y).currentProgram.getUniforms();for(let pn=0;pn<bi;pn++)Vi.setValue(L,"_gl_DrawID",pn),Ie.render(pi[pn]/ye,Ft[pn])}else if(Z.isInstancedMesh)Ie.renderInstances(Gt,je,Z.count);else if(tt.isInstancedBufferGeometry){let pi=tt._maxInstanceCount!==void 0?tt._maxInstanceCount:1/0,Ft=Math.min(tt.instanceCount,pi);Ie.renderInstances(Gt,je,Ft)}else Ie.render(Gt,je)};function tf(R,z,tt,Y){F!==null&&R.isNodeMaterial&&F.setObject(Y,R),ut===!0&&Bt.setState(R,tt,!1),R.transparent===!0&&R.side===Re&&R.forceSinglePass===!1?(R.side=di,R.needsUpdate=!0,Oo(R,z,Y),R.side=rs,R.needsUpdate=!0,Oo(R,z,Y),R.side=Re):Oo(R,z,Y)}this.compile=function(R,z,tt=null){tt===null&&(tt=R),F!==null&&F.renderStart(R,z,tt),M=bt.get(tt),M.init(z),y.push(M),tt.traverseVisible(function(Z){Z.isLight&&Z.layers.test(z.layers)&&(M.pushLight(Z),Z.castShadow&&M.pushShadow(Z))}),R!==tt&&R.traverseVisible(function(Z){Z.isLight&&Z.layers.test(z.layers)&&(M.pushLight(Z),Z.castShadow&&M.pushShadow(Z))}),M.setupLights(),F!==null&&F.updateLights(M.state.lightsArray),pt=this.localClippingEnabled,ut=Bt.init(this.clippingPlanes,pt),ut===!0&&Bt.setGlobalState(this.clippingPlanes,z),F!==null&&jt.render(M.state.shadowsArray,tt,z);let Y=new Set;return R.traverse(function(Z){if(!(Z.isMesh||Z.isPoints||Z.isLine||Z.isSprite))return;let It=Z.material;if(It)if(Array.isArray(It))for(let Ot=0;Ot<It.length;Ot++){let Ct=It[Ot];tf(Ct,tt,z,Z),Y.add(Ct)}else tf(It,tt,z,Z),Y.add(It)}),M=y.pop(),F!==null&&F.renderEnd(),Y},this.compileAsync=function(R,z,tt=null){let Y=this.compile(R,z,tt);return new Promise(Z=>{function It(){if(Y.forEach(function(Ot){let Ht=V.get(Ot).currentProgram;(Ht===void 0||Ht.isReady())&&Y.delete(Ot)}),Y.size===0){Z(R);return}setTimeout(It,10)}zt.get("KHR_parallel_shader_compile")!==null?It():setTimeout(It,10)})};let Vh=null;function fm(R){Vh&&Vh(R)}function ef(){vs.stop()}function nf(){vs.start()}let vs=new cp;vs.setAnimationLoop(fm),typeof self<"u"&&vs.setContext(self),this.setAnimationLoop=function(R){Vh=R,Wt.setAnimationLoop(R),R===null?vs.stop():vs.start()},Wt.addEventListener("sessionstart",ef),Wt.addEventListener("sessionend",nf),this.render=function(R,z){if(z!==void 0&&z.isCamera!==!0){ee("WebGLRenderer.render: camera is not an instance of THREE.Camera.");return}if(N===!0)return;F!==null&&F.renderStart(R,z);let tt=Wt.enabled===!0&&Wt.isPresenting===!0,Y=E!==null&&(X===null||tt)&&E.begin(P,X);if(R.matrixWorldAutoUpdate===!0&&R.updateMatrixWorld(),z.parent===null&&z.matrixWorldAutoUpdate===!0&&z.updateMatrixWorld(),Wt.enabled===!0&&Wt.isPresenting===!0&&(E===null||E.isCompositing()===!1)&&(Wt.cameraAutoUpdate===!0&&Wt.updateCamera(z),z=Wt.getCamera()),R.isScene===!0&&R.onBeforeRender(P,R,z,X),M=bt.get(R,y.length),M.init(z),M.state.textureUnits=K.getTextureUnits(),y.push(M),mt.multiplyMatrices(z.projectionMatrix,z.matrixWorldInverse),at.setFromProjectionMatrix(mt,an,z.reversedDepth),pt=this.localClippingEnabled,ut=Bt.init(this.clippingPlanes,pt),S=Mt.get(R,A.length),S.init(),A.push(S),Wt.enabled===!0&&Wt.isPresenting===!0){let Ot=P.xr.getDepthSensingMesh();Ot!==null&&Wh(Ot,z,-1/0,P.sortObjects)}Wh(R,z,0,P.sortObjects),S.finish(),F!==null&&F.updateLights(M.state.lightsArray),P.sortObjects===!0&&S.sort(_t,Jt),st=Wt.enabled===!1||Wt.isPresenting===!1||Wt.hasDepthSensing()===!1,st&&ne.addToRenderList(S,R),this.info.render.frame++,this.info.autoReset===!0&&this.info.reset(),ut===!0&&Bt.beginShadows();let Z=M.state.shadowsArray;if(jt.render(Z,R,z),ut===!0&&Bt.endShadows(),(Y&&E.hasRenderPass())===!1){let Ot=S.opaque,Ct=S.transmissive;if(M.setupLights(),z.isArrayCamera){let Ht=z.cameras;if(Ct.length>0)for(let Xt=0,ae=Ht.length;Xt<ae;Xt++){let ue=Ht[Xt];rf(Ot,Ct,R,ue)}st&&ne.render(R);for(let Xt=0,ae=Ht.length;Xt<ae;Xt++){let ue=Ht[Xt];sf(S,R,ue,ue.viewport)}}else Ct.length>0&&rf(Ot,Ct,R,z),st&&ne.render(R),sf(S,R,z)}X!==null&&U===0&&(K.updateMultisampleRenderTarget(X),K.updateRenderTargetMipmap(X)),Y&&E.end(P),R.isScene===!0&&R.onAfterRender(P,R,z),Dt.resetDefaultState(),G=-1,j=null,y.pop(),y.length>0?(M=y[y.length-1],K.setTextureUnits(M.state.textureUnits),ut===!0&&Bt.setGlobalState(P.clippingPlanes,M.state.camera)):M=null,A.pop(),A.length>0?S=A[A.length-1]:S=null,F!==null&&F.renderEnd()};function Wh(R,z,tt,Y){if(R.visible===!1)return;if(R.layers.test(z.layers)){if(R.isGroup)tt=R.renderOrder;else if(R.isLOD)R.autoUpdate===!0&&R.update(z);else if(R.isLightProbeGrid)M.pushLightProbeGrid(R);else if(R.isLight)M.pushLight(R),R.castShadow&&M.pushShadow(R);else if(R.isSprite){if(!R.frustumCulled||R.intersectsFrustum(at)){Y&&J.setFromMatrixPosition(R.matrixWorld).applyMatrix4(mt);let Ot=ct.update(R),Ct=R.material;Ct.visible&&S.push(R,Ot,Ct,tt,J.z,null,z)}}else if((R.isMesh||R.isLine||R.isPoints)&&(!R.frustumCulled||R.intersectsFrustum(at))){let Ot=ct.update(R),Ct=R.material;if(Y&&(R.boundingSphere!==void 0?(R.boundingSphere===null&&R.computeBoundingSphere(),J.copy(R.boundingSphere.center)):(Ot.boundingSphere===null&&Ot.computeBoundingSphere(),J.copy(Ot.boundingSphere.center)),J.applyMatrix4(R.matrixWorld).applyMatrix4(mt)),Array.isArray(Ct)){let Ht=Ot.groups;for(let Xt=0,ae=Ht.length;Xt<ae;Xt++){let ue=Ht[Xt],Gt=Ct[ue.materialIndex];Gt&&Gt.visible&&S.push(R,Ot,Gt,tt,J.z,ue,z)}}else Ct.visible&&S.push(R,Ot,Ct,tt,J.z,null,z)}}let It=R.children;for(let Ot=0,Ct=It.length;Ot<Ct;Ot++)Wh(It[Ot],z,tt,Y)}function sf(R,z,tt,Y){let{opaque:Z,transmissive:It,transparent:Ot}=R;M.setupLightsView(tt),ut===!0&&Bt.setGlobalState(P.clippingPlanes,tt),Y&&b.viewport(et.copy(Y)),Z.length>0&&zo(Z,z,tt),It.length>0&&zo(It,z,tt),Ot.length>0&&zo(Ot,z,tt),b.buffers.depth.setTest(!0),b.buffers.depth.setMask(!0),b.buffers.color.setMask(!0),b.setPolygonOffset(!1)}function rf(R,z,tt,Y){if((tt.isScene===!0?tt.overrideMaterial:null)!==null)return;if(M.state.transmissionRenderTarget[Y.id]===void 0){let Gt=zt.has("EXT_color_buffer_half_float")||zt.has("EXT_color_buffer_float");M.state.transmissionRenderTarget[Y.id]=new ke(1,1,{generateMipmaps:!0,type:Gt?qe:Ci,minFilter:Oi,samples:Math.max(4,C.samples),stencilBuffer:r,resolveDepthBuffer:!1,resolveStencilBuffer:!1,storeMultisampledDepthBuffer:!1,storeMultisampledStencilBuffer:!1,colorSpace:he.workingColorSpace})}let It=M.state.transmissionRenderTarget[Y.id],Ot=Y.viewport||et;It.setSize(Ot.z*P.transmissionResolutionScale,Ot.w*P.transmissionResolutionScale);let Ct=P.getRenderTarget(),Ht=P.getActiveCubeFace(),Xt=P.getActiveMipmapLevel();P.setRenderTarget(It),P.getClearColor(Ut),$t=P.getClearAlpha(),$t<1&&P.setClearColor(16777215,.5),P.clear(),st&&ne.render(tt);let ae=P.toneMapping;P.toneMapping=ln;let ue=Y.viewport;if(Y.viewport!==void 0&&(Y.viewport=void 0),M.setupLightsView(Y),ut===!0&&Bt.setGlobalState(P.clippingPlanes,Y),zo(R,tt,Y),K.updateMultisampleRenderTarget(It),K.updateRenderTargetMipmap(It),zt.has("WEBGL_multisampled_render_to_texture")===!1){let Gt=!1;for(let Se=0,je=z.length;Se<je;Se++){let Ue=z[Se],{object:Ie,geometry:pi,material:Ft,group:bi}=Ue;if(Ft.side===Re&&Ie.layers.test(Y.layers)){let ye=Ft.side;Ft.side=di,Ft.needsUpdate=!0,af(Ie,tt,Y,pi,Ft,bi),Ft.side=ye,Ft.needsUpdate=!0,Gt=!0}}Gt===!0&&(K.updateMultisampleRenderTarget(It),K.updateRenderTargetMipmap(It))}P.setRenderTarget(Ct,Ht,Xt),P.setClearColor(Ut,$t),ue!==void 0&&(Y.viewport=ue),P.toneMapping=ae}function zo(R,z,tt){let Y=z.isScene===!0?z.overrideMaterial:null;for(let Z=0,It=R.length;Z<It;Z++){let Ot=R[Z],{object:Ct,geometry:Ht,group:Xt}=Ot,ae=Ot.material;ae.allowOverride===!0&&Y!==null&&(ae=Y),Ct.layers.test(tt.layers)&&af(Ct,z,tt,Ht,ae,Xt)}}function af(R,z,tt,Y,Z,It){F!==null&&Z.isNodeMaterial&&F.setObject(R,Z),R.onBeforeRender(P,z,tt,Y,Z,It),R.modelViewMatrix.multiplyMatrices(tt.matrixWorldInverse,R.matrixWorld),R.normalMatrix.getNormalMatrix(R.modelViewMatrix),Z.onBeforeRender(P,z,tt,Y,R,It),Z.transparent===!0&&Z.side===Re&&Z.forceSinglePass===!1?(Z.side=di,Z.needsUpdate=!0,P.renderBufferDirect(tt,z,Y,Z,R,It),Z.side=rs,Z.needsUpdate=!0,P.renderBufferDirect(tt,z,Y,Z,R,It),Z.side=Re):P.renderBufferDirect(tt,z,Y,Z,R,It),R.onAfterRender(P,z,tt,Y,Z,It)}function Oo(R,z,tt){z.isScene!==!0&&(z=Q);let Y=V.get(R),Z=M.state.lights,It=M.state.shadowsArray,Ot=Z.state.version,Ct=wt.getParameters(R,Z.state,It,z,tt,M.state.lightProbeGridArray),Ht=wt.getProgramCacheKey(Ct),Xt=Y.programs;Y.environment=R.isMeshStandardMaterial||R.isMeshLambertMaterial||R.isMeshPhongMaterial?z.environment:null,Y.fog=z.fog;let ae=R.isMeshStandardMaterial||R.isMeshLambertMaterial&&!R.envMap||R.isMeshPhongMaterial&&!R.envMap;Y.envMap=gt.get(R.envMap||Y.environment,ae),Y.envMapRotation=Y.environment!==null&&R.envMap===null?z.environmentRotation:R.envMapRotation,Xt===void 0&&(R.addEventListener("dispose",fn),Xt=new Map,Y.programs=Xt);let ue=Xt.get(Ht);if(ue!==void 0){if(Y.currentProgram===ue&&Y.lightsStateVersion===Ot)return lf(R,Ct),ue}else Ct.uniforms=wt.getUniforms(R),F!==null&&R.isNodeMaterial&&F.build(R,tt,Ct),R.onBeforeCompile(Ct,P),ue=wt.acquireProgram(Ct,Ht),Xt.set(Ht,ue),Y.uniforms=Ct.uniforms;let Gt=Y.uniforms;return(!R.isShaderMaterial&&!R.isRawShaderMaterial||R.clipping===!0)&&(Gt.clippingPlanes=Bt.uniform),lf(R,Ct),Y.needsLights=xm(R),Y.lightsStateVersion=Ot,Y.needsLights&&(Gt.ambientLightColor.value=Z.state.ambient,Gt.lightProbe.value=Z.state.probe,Gt.sunLights.value=Z.state.sun,Gt.sunLightShadows.value=Z.state.sunShadow,Gt.directionalLights.value=Z.state.directional,Gt.directionalLightShadows.value=Z.state.directionalShadow,Gt.spotLights.value=Z.state.spot,Gt.spotLightShadows.value=Z.state.spotShadow,Gt.rectAreaLights.value=Z.state.rectArea,Gt.ltc_1.value=Z.state.rectAreaLTC1,Gt.ltc_2.value=Z.state.rectAreaLTC2,Gt.pointLights.value=Z.state.point,Gt.pointLightShadows.value=Z.state.pointShadow,Gt.hemisphereLights.value=Z.state.hemi,Gt.sunShadowMatrix.value=Z.state.sunShadowMatrix,Gt.sunShadowCascade.value=Z.state.sunShadowCascade,Gt.directionalShadowMatrix.value=Z.state.directionalShadowMatrix,Gt.spotLightMatrix.value=Z.state.spotLightMatrix,Gt.spotLightMap.value=Z.state.spotLightMap,Gt.pointShadowMatrix.value=Z.state.pointShadowMatrix),Y.lightProbeGrid=M.state.lightProbeGridArray.length>0,Y.currentProgram=ue,Y.uniformsList=null,ue}function of(R){if(R.uniformsList===null){let z=R.currentProgram.getUniforms();R.uniformsList=Nr.seqWithValue(z.seq,R.uniforms)}return R.uniformsList}function lf(R,z){let tt=V.get(R);tt.outputColorSpace=z.outputColorSpace,tt.batching=z.batching,tt.batchingColor=z.batchingColor,tt.instancing=z.instancing,tt.instancingColor=z.instancingColor,tt.instancingMorph=z.instancingMorph,tt.skinning=z.skinning,tt.morphTargets=z.morphTargets,tt.morphNormals=z.morphNormals,tt.morphColors=z.morphColors,tt.morphTargetsCount=z.morphTargetsCount,tt.numClippingPlanes=z.numClippingPlanes,tt.numIntersection=z.numClipIntersection,tt.vertexAlphas=z.vertexAlphas,tt.vertexTangents=z.vertexTangents,tt.toneMapping=z.toneMapping}function pm(R,z){if(R.length===0)return null;if(R.length===1)return R[0].texture!==null?R[0]:null;v.setFromMatrixPosition(z.matrixWorld);for(let tt=0,Y=R.length;tt<Y;tt++){let Z=R[tt];if(Z.texture!==null&&Z.boundingBox.containsPoint(v))return Z}return null}function mm(R,z,tt,Y,Z){z.isScene!==!0&&(z=Q),K.resetTextureUnits();let It=z.fog,Ot=Y.isMeshStandardMaterial||Y.isMeshLambertMaterial||Y.isMeshPhongMaterial?z.environment:null,Ct=X===null?P.outputColorSpace:X.isXRRenderTarget===!0?X.texture.colorSpace:he.workingColorSpace,Ht=Y.isMeshStandardMaterial||Y.isMeshLambertMaterial&&!Y.envMap||Y.isMeshPhongMaterial&&!Y.envMap,Xt=gt.get(Y.envMap||Ot,Ht),ae=Y.vertexColors===!0&&!!tt.attributes.color&&tt.attributes.color.itemSize===4,ue=!!tt.attributes.tangent&&(!!Y.normalMap||Y.anisotropy>0),Gt=!!tt.morphAttributes.position,Se=!!tt.morphAttributes.normal,je=!!tt.morphAttributes.color,Ue=ln;Y.toneMapped&&(X===null||X.isXRRenderTarget===!0)&&(Ue=P.toneMapping);let Ie=tt.morphAttributes.position||tt.morphAttributes.normal||tt.morphAttributes.color,pi=Ie!==void 0?Ie.length:0,Ft=V.get(Y),bi=M.state.lights;if(ut===!0&&(pt===!0||R!==j)){let Ne=R===j&&Y.id===G;Bt.setState(Y,R,Ne)}let ye=!1;Y.version===Ft.__version?(Ft.needsLights&&Ft.lightsStateVersion!==bi.state.version||Ft.outputColorSpace!==Ct||Z.isBatchedMesh&&Ft.batching===!1||!Z.isBatchedMesh&&Ft.batching===!0||Z.isBatchedMesh&&Ft.batchingColor===!0&&Z._colorsTexture===null||Z.isBatchedMesh&&Ft.batchingColor===!1&&Z._colorsTexture!==null||Z.isInstancedMesh&&Ft.instancing===!1||!Z.isInstancedMesh&&Ft.instancing===!0||Z.isSkinnedMesh&&Ft.skinning===!1||!Z.isSkinnedMesh&&Ft.skinning===!0||Z.isInstancedMesh&&Ft.instancingColor===!0&&Z.instanceColor===null||Z.isInstancedMesh&&Ft.instancingColor===!1&&Z.instanceColor!==null||Z.isInstancedMesh&&Ft.instancingMorph===!0&&Z.morphTexture===null||Z.isInstancedMesh&&Ft.instancingMorph===!1&&Z.morphTexture!==null||Ft.envMap!==Xt||Y.fog===!0&&Ft.fog!==It||Ft.numClippingPlanes!==void 0&&(Ft.numClippingPlanes!==Bt.numPlanes||Ft.numIntersection!==Bt.numIntersection)||Ft.vertexAlphas!==ae||Ft.vertexTangents!==ue||Ft.morphTargets!==Gt||Ft.morphNormals!==Se||Ft.morphColors!==je||Ft.toneMapping!==Ue||Ft.morphTargetsCount!==pi||!!Ft.lightProbeGrid!=M.state.lightProbeGridArray.length>0)&&(ye=!0):(ye=!0,Ft.__version=Y.version);let Vi=Ft.currentProgram;ye===!0&&(Vi=Oo(Y,z,Z),F&&Y.isNodeMaterial&&F.onUpdateProgram(Y,Vi,Ft));let pn=!1,Vn=!1,Bs=!1,Ae=Vi.getUniforms(),$e=Ft.uniforms;if(b.useProgram(Vi.program)&&(pn=!0,Vn=!0,Bs=!0),Y.id!==G&&(G=Y.id,Vn=!0),Ft.needsLights){let Ne=pm(M.state.lightProbeGridArray,Z);Ft.lightProbeGrid!==Ne&&(Ft.lightProbeGrid=Ne,Vn=!0)}if(pn||j!==R){b.buffers.depth.getReversed()&&R.reversedDepth!==!0&&(R._reversedDepth=!0,R.updateProjectionMatrix()),Ae.setValue(L,"projectionMatrix",R.projectionMatrix),Ae.setValue(L,"viewMatrix",R.matrixWorldInverse);let Xn=Ae.map.cameraPosition;Xn!==void 0&&Xn.setValue(L,w.setFromMatrixPosition(R.matrixWorld)),C.logarithmicDepthBuffer&&Ae.setValue(L,"logDepthBufFC",2/(Math.log(R.far+1)/Math.LN2)),(Y.isMeshPhongMaterial||Y.isMeshToonMaterial||Y.isMeshLambertMaterial||Y.isMeshBasicMaterial||Y.isMeshStandardMaterial||Y.isShaderMaterial)&&Ae.setValue(L,"isOrthographic",R.isOrthographicCamera===!0),j!==R&&(j=R,Vn=!0,Bs=!0)}if(Ft.needsLights&&(bi.state.sunShadowMap.length>0&&Ae.setValue(L,"sunShadowMap",bi.state.sunShadowMap,K),bi.state.directionalShadowMap.length>0&&Ae.setValue(L,"directionalShadowMap",bi.state.directionalShadowMap,K),bi.state.spotShadowMap.length>0&&Ae.setValue(L,"spotShadowMap",bi.state.spotShadowMap,K),bi.state.pointShadowMap.length>0&&Ae.setValue(L,"pointShadowMap",bi.state.pointShadowMap,K)),Z.isSkinnedMesh){Ae.setOptional(L,Z,"bindMatrix"),Ae.setOptional(L,Z,"bindMatrixInverse");let Ne=Z.skeleton;Ne&&(Ne.boneTexture===null&&Ne.computeBoneTexture(),Ae.setValue(L,"boneTexture",Ne.boneTexture,K))}Z.isBatchedMesh&&(Ae.setOptional(L,Z,"batchingTexture"),Ae.setValue(L,"batchingTexture",Z._matricesTexture,K),Ae.setOptional(L,Z,"batchingIdTexture"),Ae.setValue(L,"batchingIdTexture",Z._indirectTexture,K),Ae.setOptional(L,Z,"batchingColorTexture"),Z._colorsTexture!==null&&Ae.setValue(L,"batchingColorTexture",Z._colorsTexture,K));let Wn=tt.morphAttributes;if((Wn.position!==void 0||Wn.normal!==void 0||Wn.color!==void 0)&&k.update(Z,tt,Vi),(Vn||Ft.receiveShadow!==Z.receiveShadow)&&(Ft.receiveShadow=Z.receiveShadow,Ae.setValue(L,"receiveShadow",Z.receiveShadow)),(Y.isMeshStandardMaterial||Y.isMeshLambertMaterial||Y.isMeshPhongMaterial)&&Y.envMap===null&&z.environment!==null&&($e.envMapIntensity.value=z.environmentIntensity),$e.dfgLUT!==void 0&&($e.dfgLUT.value=N_()),Vn){if(Ae.setValue(L,"toneMappingExposure",P.toneMappingExposure),Ft.needsLights&&gm($e,Bs),It&&Y.fog===!0&&kt.refreshFogUniforms($e,It),kt.refreshMaterialUniforms($e,Y,rt,$,M.state.transmissionRenderTarget[R.id]),Ft.needsLights&&Ft.lightProbeGrid){let Ne=Ft.lightProbeGrid;$e.probesSH.value=Ne.texture,$e.probesMin.value.copy(Ne.boundingBox.min),$e.probesMax.value.copy(Ne.boundingBox.max),$e.probesResolution.value.copy(Ne.resolution)}Nr.upload(L,of(Ft),$e,K)}if(Y.isShaderMaterial&&Y.uniformsNeedUpdate===!0&&(Nr.upload(L,of(Ft),$e,K),Y.uniformsNeedUpdate=!1),Y.isSpriteMaterial&&Ae.setValue(L,"center",Z.center),Ae.setValue(L,"modelViewMatrix",Z.modelViewMatrix),Ae.setValue(L,"normalMatrix",Z.normalMatrix),Ae.setValue(L,"modelMatrix",Z.matrixWorld),Y.uniformsGroups!==void 0){let Ne=Y.uniformsGroups;for(let Xn=0,Hs=Ne.length;Xn<Hs;Xn++){let hf=Ne[Xn];ft.update(hf,Vi),ft.bind(hf,Vi)}}return Vi}function gm(R,z){R.ambientLightColor.needsUpdate=z,R.lightProbe.needsUpdate=z,R.sunLights.needsUpdate=z,R.sunLightShadows.needsUpdate=z,R.directionalLights.needsUpdate=z,R.directionalLightShadows.needsUpdate=z,R.pointLights.needsUpdate=z,R.pointLightShadows.needsUpdate=z,R.spotLights.needsUpdate=z,R.spotLightShadows.needsUpdate=z,R.rectAreaLights.needsUpdate=z,R.hemisphereLights.needsUpdate=z}function xm(R){return R.isMeshLambertMaterial||R.isMeshToonMaterial||R.isMeshPhongMaterial||R.isMeshStandardMaterial||R.isShadowMaterial||R.isShaderMaterial&&R.lights===!0}this.getActiveCubeFace=function(){return W},this.getActiveMipmapLevel=function(){return U},this.getRenderTarget=function(){return X},this.setRenderTargetTextures=function(R,z,tt){let Y=V.get(R);Y.__autoAllocateDepthBuffer=R.resolveDepthBuffer===!1,Y.__autoAllocateDepthBuffer===!1&&(Y.__useRenderToTexture=!1),V.get(R.texture).__webglTexture=z,V.get(R.depthTexture).__webglTexture=Y.__autoAllocateDepthBuffer?void 0:tt,Y.__hasExternalTextures=!0},this.setRenderTargetFramebuffer=function(R,z){let tt=V.get(R);tt.__webglFramebuffer=z,tt.__useDefaultFramebuffer=z===void 0},this.setRenderTarget=function(R,z=0,tt=0){X=R,W=z,U=tt;let Y=null,Z=!1,It=!1;if(R){let Ct=V.get(R);if(Ct.__useDefaultFramebuffer!==void 0){b.bindFramebuffer(L.FRAMEBUFFER,Ct.__webglFramebuffer),et.copy(R.viewport),vt.copy(R.scissor),ht=R.scissorTest,b.viewport(et),b.scissor(vt),b.setScissorTest(ht),G=-1;return}else if(Ct.__webglFramebuffer===void 0)K.setupRenderTarget(R);else if(Ct.__hasExternalTextures)K.rebindTextures(R,V.get(R.texture).__webglTexture,V.get(R.depthTexture).__webglTexture);else if(R.depthBuffer){let ae=R.depthTexture;if(Ct.__boundDepthTexture!==ae){if(ae!==null&&V.has(ae)&&(R.width!==ae.image.width||R.height!==ae.image.height))throw new Error("THREE.WebGLRenderer: Attached DepthTexture is initialized to the incorrect size.");K.setupDepthRenderbuffer(R)}}let Ht=R.texture;(Ht.isData3DTexture||Ht.isDataArrayTexture||Ht.isCompressedArrayTexture)&&(It=!0);let Xt=V.get(R).__webglFramebuffer;R.isWebGLCubeRenderTarget?(Array.isArray(Xt[z])?Y=Xt[z][tt]:Y=Xt[z],Z=!0):R.samples>0&&K.useMultisampledRTT(R)===!1?Y=V.get(R).__webglMultisampledFramebuffer:Array.isArray(Xt)?Y=Xt[tt]:Y=Xt,et.copy(R.viewport),vt.copy(R.scissor),ht=R.scissorTest}else et.copy(At).multiplyScalar(rt).floor(),vt.copy(Yt).multiplyScalar(rt).floor(),ht=fe;if(tt!==0&&(Y=B),b.bindFramebuffer(L.FRAMEBUFFER,Y)&&b.drawBuffers(R,Y),b.viewport(et),b.scissor(vt),b.setScissorTest(ht),Z){let Ct=V.get(R.texture);L.framebufferTexture2D(L.FRAMEBUFFER,L.COLOR_ATTACHMENT0,L.TEXTURE_CUBE_MAP_POSITIVE_X+z,Ct.__webglTexture,tt)}else if(It){let Ct=z;for(let Ht=0;Ht<R.textures.length;Ht++){let Xt=V.get(R.textures[Ht]);L.framebufferTextureLayer(L.FRAMEBUFFER,L.COLOR_ATTACHMENT0+Ht,Xt.__webglTexture,tt,Ct)}}else if(R!==null&&tt!==0){let Ct=V.get(R.texture);L.framebufferTexture2D(L.FRAMEBUFFER,L.COLOR_ATTACHMENT0,L.TEXTURE_2D,Ct.__webglTexture,tt)}G=-1};function cf(R){let z=V.get(R);return(z.__readFormat!==R.format||z.__readType!==R.type)&&(z.__readFormat=R.format,z.__readType=R.type,z.__formatReadable=C.textureFormatReadable(R.format),z.__typeReadable=C.textureTypeReadable(R.type)),z}this.readRenderTargetPixels=function(R,z,tt,Y,Z,It,Ot,Ct=0){if(!(R&&R.isWebGLRenderTarget)){ee("WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");return}let Ht=V.get(R).__webglFramebuffer;if(R.isWebGLCubeRenderTarget&&Ot!==void 0&&(Ht=Ht[Ot]),Ht){b.bindFramebuffer(L.FRAMEBUFFER,Ht);try{let Xt=R.textures[Ct],ae=Xt.format,ue=Xt.type;R.textures.length>1&&L.readBuffer(L.COLOR_ATTACHMENT0+Ct);let Gt=cf(Xt);if(Gt.__formatReadable===!1){ee("WebGLRenderer.readRenderTargetPixels: renderTarget is not in RGBA or implementation defined format.");return}if(Gt.__typeReadable===!1){ee("WebGLRenderer.readRenderTargetPixels: renderTarget is not in UnsignedByteType or implementation defined type.");return}z>=0&&z<=R.width-Y&&tt>=0&&tt<=R.height-Z&&L.readPixels(z,tt,Y,Z,Et.convert(ae),Et.convert(ue),It)}finally{let Xt=X!==null?V.get(X).__webglFramebuffer:null;b.bindFramebuffer(L.FRAMEBUFFER,Xt)}}},this.readRenderTargetPixelsAsync=async function(R,z,tt,Y,Z,It,Ot,Ct=0){if(!(R&&R.isWebGLRenderTarget))throw new Error("THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");let Ht=V.get(R).__webglFramebuffer;if(R.isWebGLCubeRenderTarget&&Ot!==void 0&&(Ht=Ht[Ot]),Ht)if(z>=0&&z<=R.width-Y&&tt>=0&&tt<=R.height-Z){b.bindFramebuffer(L.FRAMEBUFFER,Ht);let Xt=R.textures[Ct],ae=Xt.format,ue=Xt.type;R.textures.length>1&&L.readBuffer(L.COLOR_ATTACHMENT0+Ct);let Gt=cf(Xt);if(Gt.__formatReadable===!1)throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in RGBA or implementation defined format.");if(Gt.__typeReadable===!1)throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in UnsignedByteType or implementation defined type.");let Se=L.createBuffer();L.bindBuffer(L.PIXEL_PACK_BUFFER,Se),L.bufferData(L.PIXEL_PACK_BUFFER,It.byteLength,L.STREAM_READ),L.readPixels(z,tt,Y,Z,Et.convert(ae),Et.convert(ue),0),L.bindBuffer(L.PIXEL_PACK_BUFFER,null);let je=X!==null?V.get(X).__webglFramebuffer:null;b.bindFramebuffer(L.FRAMEBUFFER,je);let Ue=L.fenceSync(L.SYNC_GPU_COMMANDS_COMPLETE,0);return L.flush(),await L0(L,Ue,4),L.bindBuffer(L.PIXEL_PACK_BUFFER,Se),L.getBufferSubData(L.PIXEL_PACK_BUFFER,0,It),L.bindBuffer(L.PIXEL_PACK_BUFFER,null),L.deleteBuffer(Se),L.deleteSync(Ue),It}else throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: requested read bounds are out of range.")},this.copyFramebufferToTexture=function(R,z=null,tt=0){let Y=Math.pow(2,-tt),Z=Math.floor(R.image.width*Y),It=Math.floor(R.image.height*Y),Ot=z!==null?z.x:0,Ct=z!==null?z.y:0;K.setTexture2D(R,0),L.copyTexSubImage2D(L.TEXTURE_2D,tt,0,0,Ot,Ct,Z,It),b.unbindTexture()},this.copyTextureToTexture=function(R,z,tt=null,Y=null,Z=0,It=0){let Ot,Ct,Ht,Xt,ae,ue,Gt,Se,je,Ue=R.isCompressedTexture?R.mipmaps[It]:R.image;if(tt!==null)Ot=tt.max.x-tt.min.x,Ct=tt.max.y-tt.min.y,Ht=tt.isBox3?tt.max.z-tt.min.z:1,Xt=tt.min.x,ae=tt.min.y,ue=tt.isBox3?tt.min.z:0;else{let $e=Math.pow(2,-Z);Ot=Math.floor(Ue.width*$e),Ct=Math.floor(Ue.height*$e),R.isDataArrayTexture?Ht=Ue.depth:R.isData3DTexture?Ht=Math.floor(Ue.depth*$e):Ht=1,Xt=0,ae=0,ue=0}Y!==null?(Gt=Y.x,Se=Y.y,je=Y.z):(Gt=0,Se=0,je=0);let Ie=Et.convert(z.format),pi=Et.convert(z.type),Ft;z.isData3DTexture?(K.setTexture3D(z,0),Ft=L.TEXTURE_3D):z.isDataArrayTexture||z.isCompressedArrayTexture?(K.setTexture2DArray(z,0),Ft=L.TEXTURE_2D_ARRAY):(K.setTexture2D(z,0),Ft=L.TEXTURE_2D),b.activeTexture(L.TEXTURE0),b.pixelStorei(L.UNPACK_FLIP_Y_WEBGL,z.flipY),b.pixelStorei(L.UNPACK_PREMULTIPLY_ALPHA_WEBGL,z.premultiplyAlpha),b.pixelStorei(L.UNPACK_ALIGNMENT,z.unpackAlignment);let bi=b.getParameter(L.UNPACK_ROW_LENGTH),ye=b.getParameter(L.UNPACK_IMAGE_HEIGHT),Vi=b.getParameter(L.UNPACK_SKIP_PIXELS),pn=b.getParameter(L.UNPACK_SKIP_ROWS),Vn=b.getParameter(L.UNPACK_SKIP_IMAGES);b.pixelStorei(L.UNPACK_ROW_LENGTH,Ue.width),b.pixelStorei(L.UNPACK_IMAGE_HEIGHT,Ue.height),b.pixelStorei(L.UNPACK_SKIP_PIXELS,Xt),b.pixelStorei(L.UNPACK_SKIP_ROWS,ae),b.pixelStorei(L.UNPACK_SKIP_IMAGES,ue);let Bs=R.isDataArrayTexture||R.isData3DTexture,Ae=z.isDataArrayTexture||z.isData3DTexture;if(R.isDepthTexture){let $e=V.get(R),Wn=V.get(z),Ne=V.get($e.__renderTarget),Xn=V.get(Wn.__renderTarget);b.bindFramebuffer(L.READ_FRAMEBUFFER,Ne.__webglFramebuffer),b.bindFramebuffer(L.DRAW_FRAMEBUFFER,Xn.__webglFramebuffer);for(let Hs=0;Hs<Ht;Hs++)Bs&&(L.framebufferTextureLayer(L.READ_FRAMEBUFFER,L.COLOR_ATTACHMENT0,V.get(R).__webglTexture,Z,ue+Hs),L.framebufferTextureLayer(L.DRAW_FRAMEBUFFER,L.COLOR_ATTACHMENT0,V.get(z).__webglTexture,It,je+Hs)),L.blitFramebuffer(Xt,ae,Ot,Ct,Gt,Se,Ot,Ct,L.DEPTH_BUFFER_BIT,L.NEAREST);b.bindFramebuffer(L.READ_FRAMEBUFFER,null),b.bindFramebuffer(L.DRAW_FRAMEBUFFER,null)}else if(Z!==0||R.isRenderTargetTexture||V.has(R)){let $e=V.get(R),Wn=V.get(z);b.bindFramebuffer(L.READ_FRAMEBUFFER,I),b.bindFramebuffer(L.DRAW_FRAMEBUFFER,H);for(let Ne=0;Ne<Ht;Ne++)Bs?L.framebufferTextureLayer(L.READ_FRAMEBUFFER,L.COLOR_ATTACHMENT0,$e.__webglTexture,Z,ue+Ne):L.framebufferTexture2D(L.READ_FRAMEBUFFER,L.COLOR_ATTACHMENT0,L.TEXTURE_2D,$e.__webglTexture,Z),Ae?L.framebufferTextureLayer(L.DRAW_FRAMEBUFFER,L.COLOR_ATTACHMENT0,Wn.__webglTexture,It,je+Ne):L.framebufferTexture2D(L.DRAW_FRAMEBUFFER,L.COLOR_ATTACHMENT0,L.TEXTURE_2D,Wn.__webglTexture,It),Z!==0?L.blitFramebuffer(Xt,ae,Ot,Ct,Gt,Se,Ot,Ct,L.COLOR_BUFFER_BIT,L.NEAREST):Ae?L.copyTexSubImage3D(Ft,It,Gt,Se,je+Ne,Xt,ae,Ot,Ct):L.copyTexSubImage2D(Ft,It,Gt,Se,Xt,ae,Ot,Ct);b.bindFramebuffer(L.READ_FRAMEBUFFER,null),b.bindFramebuffer(L.DRAW_FRAMEBUFFER,null)}else Ae?R.isDataTexture||R.isData3DTexture?L.texSubImage3D(Ft,It,Gt,Se,je,Ot,Ct,Ht,Ie,pi,Ue.data):z.isCompressedArrayTexture?L.compressedTexSubImage3D(Ft,It,Gt,Se,je,Ot,Ct,Ht,Ie,Ue.data):L.texSubImage3D(Ft,It,Gt,Se,je,Ot,Ct,Ht,Ie,pi,Ue):R.isDataTexture?L.texSubImage2D(L.TEXTURE_2D,It,Gt,Se,Ot,Ct,Ie,pi,Ue.data):R.isCompressedTexture?L.compressedTexSubImage2D(L.TEXTURE_2D,It,Gt,Se,Ue.width,Ue.height,Ie,Ue.data):L.texSubImage2D(L.TEXTURE_2D,It,Gt,Se,Ot,Ct,Ie,pi,Ue);b.pixelStorei(L.UNPACK_ROW_LENGTH,bi),b.pixelStorei(L.UNPACK_IMAGE_HEIGHT,ye),b.pixelStorei(L.UNPACK_SKIP_PIXELS,Vi),b.pixelStorei(L.UNPACK_SKIP_ROWS,pn),b.pixelStorei(L.UNPACK_SKIP_IMAGES,Vn),It===0&&z.generateMipmaps&&L.generateMipmap(Ft),b.unbindTexture()},this.initRenderTarget=function(R){V.get(R).__webglFramebuffer===void 0&&K.setupRenderTarget(R)},this.initTexture=function(R){R.isCubeTexture?K.setTextureCube(R,0):R.isData3DTexture?K.setTexture3D(R,0):R.isDataArrayTexture||R.isCompressedArrayTexture?K.setTexture2DArray(R,0):K.setTexture2D(R,0),b.unbindTexture()},this.resetState=function(){W=0,U=0,X=null,b.reset(),Dt.reset()},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}get coordinateSystem(){return an}get outputColorSpace(){return this._outputColorSpace}set outputColorSpace(t){this._outputColorSpace=t;let e=this.getContext();e.drawingBufferColorSpace=he._getDrawingBufferColorSpace(t),e.unpackColorSpace=he._getUnpackColorSpace()}};var Or={name:"CopyShader",uniforms:{tDiffuse:{value:null},opacity:{value:1}},vertexShader:`

		varying vec2 vUv;

		void main() {

			vUv = uv;
			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

		}`,fragmentShader:`

		uniform float opacity;

		uniform sampler2D tDiffuse;

		varying vec2 vUv;

		void main() {

			vec4 texel = texture2D( tDiffuse, vUv );
			gl_FragColor = opacity * texel;


		}`};var ki=class{constructor(){this.isPass=!0,this.enabled=!0,this.needsSwap=!0,this.clear=!1,this.renderToScreen=!1}setSize(){}render(){console.error("THREE.Pass: .render() must be implemented in derived pass.")}dispose(){}},U_=new ss(-1,1,1,-1,0,1),vd=class extends ge{constructor(){super(),this.setAttribute("position",new qt([-1,3,0,-1,-1,0,3,-1,0],3)),this.setAttribute("uv",new qt([0,2,0,0,2,0],2))}},F_=new vd,hs=class{constructor(t){this._mesh=new Pt(F_,t)}dispose(){this._mesh.geometry.dispose()}render(t){t.render(this._mesh,U_)}get material(){return this._mesh.material}set material(t){this._mesh.material=t}};var kr=class extends ki{constructor(t,e="tDiffuse"){super(),this.textureID=e,this.uniforms=null,this.material=null,t instanceof ze?(this.uniforms=t.uniforms,this.material=t):t&&(this.uniforms=Un.clone(t.uniforms),this.material=new ze({name:t.name!==void 0?t.name:"unspecified",defines:Object.assign({},t.defines),uniforms:this.uniforms,vertexShader:t.vertexShader,fragmentShader:t.fragmentShader})),this._fsQuad=new hs(this.material)}render(t,e,i){this.uniforms[this.textureID]&&(this.uniforms[this.textureID].value=i.texture),this._fsQuad.material=this.material,this.renderToScreen?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(e),this.clear&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),this._fsQuad.render(t))}dispose(){this.material.dispose(),this._fsQuad.dispose()}};var vo=class extends ki{constructor(t,e){super(),this.scene=t,this.camera=e,this.clear=!0,this.needsSwap=!1,this.inverse=!1}render(t,e,i){let s=t.getContext(),r=t.state;r.buffers.color.setMask(!1),r.buffers.depth.setMask(!1),r.buffers.color.setLocked(!0),r.buffers.depth.setLocked(!0);let a,o;this.inverse?(a=0,o=1):(a=1,o=0),r.buffers.stencil.setTest(!0),r.buffers.stencil.setOp(s.REPLACE,s.REPLACE,s.REPLACE),r.buffers.stencil.setFunc(s.ALWAYS,a,4294967295),r.buffers.stencil.setClear(o),r.buffers.stencil.setLocked(!0),t.setRenderTarget(i),this.clear&&t.clear(),t.render(this.scene,this.camera),t.setRenderTarget(e),this.clear&&t.clear(),t.render(this.scene,this.camera),r.buffers.color.setLocked(!1),r.buffers.depth.setLocked(!1),r.buffers.color.setMask(!0),r.buffers.depth.setMask(!0),r.buffers.stencil.setLocked(!1),r.buffers.stencil.setFunc(s.EQUAL,1,4294967295),r.buffers.stencil.setOp(s.KEEP,s.KEEP,s.KEEP),r.buffers.stencil.setLocked(!0)}},Xc=class extends ki{constructor(){super(),this.needsSwap=!1}render(t){t.state.buffers.stencil.setLocked(!1),t.state.buffers.stencil.setTest(!1)}};var qc=class{constructor(t,e){if(this.renderer=t,this._pixelRatio=t.getPixelRatio(),e===void 0){let i=t.getSize(new ot);this._width=i.width,this._height=i.height,e=new ke(this._width*this._pixelRatio,this._height*this._pixelRatio,{type:qe}),e.texture.name="EffectComposer.rt1"}else this._width=e.width,this._height=e.height;this.renderTarget1=e,this.renderTarget2=e.clone(),this.renderTarget2.texture.name="EffectComposer.rt2",this.writeBuffer=this.renderTarget1,this.readBuffer=this.renderTarget2,this.renderToScreen=!0,this.passes=[],this.copyPass=new kr(Or),this.copyPass.material.blending=Yi,this.timer=new Ja}swapBuffers(){let t=this.readBuffer;this.readBuffer=this.writeBuffer,this.writeBuffer=t}addPass(t){this.passes.push(t),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}insertPass(t,e){this.passes.splice(e,0,t),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}removePass(t){let e=this.passes.indexOf(t);e!==-1&&this.passes.splice(e,1)}isLastEnabledPass(t){for(let e=t+1;e<this.passes.length;e++)if(this.passes[e].enabled)return!1;return!0}render(t){this.timer.update(),t===void 0&&(t=this.timer.getDelta());let e=this.renderer.getRenderTarget(),i=!1;for(let s=0,r=this.passes.length;s<r;s++){let a=this.passes[s];if(a.enabled!==!1){if(a.renderToScreen=this.renderToScreen&&this.isLastEnabledPass(s),a.render(this.renderer,this.writeBuffer,this.readBuffer,t,i),a.needsSwap){if(i){let o=this.renderer.getContext(),c=this.renderer.state.buffers.stencil;c.setFunc(o.NOTEQUAL,1,4294967295),this.copyPass.render(this.renderer,this.writeBuffer,this.readBuffer,t),c.setFunc(o.EQUAL,1,4294967295)}this.swapBuffers()}vo!==void 0&&(a instanceof vo?i=!0:a instanceof Xc&&(i=!1))}}this.renderer.setRenderTarget(e)}reset(t){if(t===void 0){let e=this.renderer.getSize(new ot);this._pixelRatio=this.renderer.getPixelRatio(),this._width=e.width,this._height=e.height,t=this.renderTarget1.clone(),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}this.renderTarget1.dispose(),this.renderTarget2.dispose(),this.renderTarget1=t,this.renderTarget2=t.clone(),this.writeBuffer=this.renderTarget1,this.readBuffer=this.renderTarget2}setSize(t,e){this._width=t,this._height=e;let i=this._width*this._pixelRatio,s=this._height*this._pixelRatio;this.renderTarget1.setSize(i,s),this.renderTarget2.setSize(i,s);for(let r=0;r<this.passes.length;r++)this.passes[r].setSize(i,s)}setPixelRatio(t){this._pixelRatio=t,this.setSize(this._width,this._height)}dispose(){this.renderTarget1.dispose(),this.renderTarget2.dispose(),this.copyPass.dispose()}};var $c=class extends ki{constructor(t,e,i=null,s=null,r=null){super(),this.scene=t,this.camera=e,this.overrideMaterial=i,this.clearColor=s,this.clearAlpha=r,this.clear=!0,this.clearDepth=!1,this.needsSwap=!1,this.isRenderPass=!0,this._oldClearColor=new Nt}render(t,e,i){let s=t.autoClear;t.autoClear=!1;let r,a;this.overrideMaterial!==null&&(a=this.scene.overrideMaterial,this.scene.overrideMaterial=this.overrideMaterial),this.clearColor!==null&&(t.getClearColor(this._oldClearColor),t.setClearColor(this.clearColor,t.getClearAlpha())),this.clearAlpha!==null&&(r=t.getClearAlpha(),t.setClearAlpha(this.clearAlpha)),this.clearDepth==!0&&t.clearDepth(),t.setRenderTarget(this.renderToScreen?null:i),this.clear===!0&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),t.render(this.scene,this.camera),this.clearColor!==null&&t.setClearColor(this._oldClearColor),this.clearAlpha!==null&&t.setClearAlpha(r),this.overrideMaterial!==null&&(this.scene.overrideMaterial=a),t.autoClear=s}};var gp={name:"LuminosityHighPassShader",uniforms:{tDiffuse:{value:null},luminosityThreshold:{value:1},smoothWidth:{value:1},defaultColor:{value:new Nt(0)},defaultOpacity:{value:0}},vertexShader:`

		varying vec2 vUv;

		void main() {

			vUv = uv;

			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

		}`,fragmentShader:`

		uniform sampler2D tDiffuse;
		uniform vec3 defaultColor;
		uniform float defaultOpacity;
		uniform float luminosityThreshold;
		uniform float smoothWidth;

		varying vec2 vUv;

		void main() {

			vec4 texel = texture2D( tDiffuse, vUv );

			float v = luminance( texel.xyz );

			vec4 outputColor = vec4( defaultColor.rgb, defaultOpacity );

			float alpha = smoothstep( luminosityThreshold, luminosityThreshold + smoothWidth, v );

			gl_FragColor = mix( outputColor, texel, alpha );

		}`};var Br=class n extends ki{constructor(t,e=1,i,s){super(),this.strength=e,this.radius=i,this.threshold=s,this.resolution=t!==void 0?new ot(t.x,t.y):new ot(256,256),this.clearColor=new Nt(0,0,0),this.needsSwap=!1,this.renderTargetsHorizontal=[],this.renderTargetsVertical=[],this.nMips=5;let r=Math.round(this.resolution.x/2),a=Math.round(this.resolution.y/2);this.renderTargetBright=new ke(r,a,{type:qe,depthBuffer:!1}),this.renderTargetBright.texture.name="UnrealBloomPass.bright",this.renderTargetBright.texture.generateMipmaps=!1;for(let h=0;h<this.nMips;h++){let u=new ke(r,a,{type:qe,depthBuffer:!1});u.texture.name="UnrealBloomPass.h"+h,u.texture.generateMipmaps=!1,this.renderTargetsHorizontal.push(u);let d=new ke(r,a,{type:qe,depthBuffer:!1});d.texture.name="UnrealBloomPass.v"+h,d.texture.generateMipmaps=!1,this.renderTargetsVertical.push(d),r=Math.round(r/2),a=Math.round(a/2)}let o=gp;this.highPassUniforms=Un.clone(o.uniforms),this.highPassUniforms.luminosityThreshold.value=s,this.highPassUniforms.smoothWidth.value=.01,this.materialHighPassFilter=new ze({uniforms:this.highPassUniforms,vertexShader:o.vertexShader,fragmentShader:o.fragmentShader}),this.separableBlurMaterials=[];let c=[6,10,14,18,22];r=Math.round(this.resolution.x/2),a=Math.round(this.resolution.y/2);for(let h=0;h<this.nMips;h++)this.separableBlurMaterials.push(this._getSeparableBlurMaterial(c[h])),this.separableBlurMaterials[h].uniforms.invSize.value=new ot(1/r,1/a),r=Math.round(r/2),a=Math.round(a/2);this.compositeMaterial=this._getCompositeMaterial(this.nMips),this.compositeMaterial.uniforms.blurTexture1.value=this.renderTargetsVertical[0].texture,this.compositeMaterial.uniforms.blurTexture2.value=this.renderTargetsVertical[1].texture,this.compositeMaterial.uniforms.blurTexture3.value=this.renderTargetsVertical[2].texture,this.compositeMaterial.uniforms.blurTexture4.value=this.renderTargetsVertical[3].texture,this.compositeMaterial.uniforms.blurTexture5.value=this.renderTargetsVertical[4].texture,this.compositeMaterial.uniforms.bloomStrength.value=e,this.compositeMaterial.uniforms.bloomRadius.value=.1;let l=[1,.8,.6,.4,.2];this.compositeMaterial.uniforms.bloomFactors.value=l,this.bloomTintColors=[new D(1,1,1),new D(1,1,1),new D(1,1,1),new D(1,1,1),new D(1,1,1)],this.compositeMaterial.uniforms.bloomTintColors.value=this.bloomTintColors,this.copyUniforms=Un.clone(Or.uniforms),this.blendMaterial=new ze({uniforms:this.copyUniforms,vertexShader:Or.vertexShader,fragmentShader:Or.fragmentShader,premultipliedAlpha:!0,blending:Xe,depthTest:!1,depthWrite:!1,transparent:!0}),this._oldClearColor=new Nt,this._oldClearAlpha=1,this._basic=new He,this._fsQuad=new hs(null)}dispose(){for(let t=0;t<this.renderTargetsHorizontal.length;t++)this.renderTargetsHorizontal[t].dispose();for(let t=0;t<this.renderTargetsVertical.length;t++)this.renderTargetsVertical[t].dispose();this.renderTargetBright.dispose();for(let t=0;t<this.separableBlurMaterials.length;t++)this.separableBlurMaterials[t].dispose();this.compositeMaterial.dispose(),this.blendMaterial.dispose(),this._basic.dispose(),this._fsQuad.dispose()}setSize(t,e){let i=Math.round(t/2),s=Math.round(e/2);this.renderTargetBright.setSize(i,s);for(let r=0;r<this.nMips;r++)this.renderTargetsHorizontal[r].setSize(i,s),this.renderTargetsVertical[r].setSize(i,s),this.separableBlurMaterials[r].uniforms.invSize.value=new ot(1/i,1/s),i=Math.round(i/2),s=Math.round(s/2)}render(t,e,i,s,r){t.getClearColor(this._oldClearColor),this._oldClearAlpha=t.getClearAlpha();let a=t.autoClear;t.autoClear=!1,t.setClearColor(this.clearColor,0),r&&t.state.buffers.stencil.setTest(!1),this.renderToScreen&&(this._fsQuad.material=this._basic,this._basic.map=i.texture,t.setRenderTarget(null),t.clear(),this._fsQuad.render(t)),this.highPassUniforms.tDiffuse.value=i.texture,this.highPassUniforms.luminosityThreshold.value=this.threshold,this._fsQuad.material=this.materialHighPassFilter,t.setRenderTarget(this.renderTargetBright),t.clear(),this._fsQuad.render(t);let o=this.renderTargetBright;for(let c=0;c<this.nMips;c++)this._fsQuad.material=this.separableBlurMaterials[c],this.separableBlurMaterials[c].uniforms.colorTexture.value=o.texture,this.separableBlurMaterials[c].uniforms.direction.value=n.BlurDirectionX,t.setRenderTarget(this.renderTargetsHorizontal[c]),t.clear(),this._fsQuad.render(t),this.separableBlurMaterials[c].uniforms.colorTexture.value=this.renderTargetsHorizontal[c].texture,this.separableBlurMaterials[c].uniforms.direction.value=n.BlurDirectionY,t.setRenderTarget(this.renderTargetsVertical[c]),t.clear(),this._fsQuad.render(t),o=this.renderTargetsVertical[c];this._fsQuad.material=this.compositeMaterial,this.compositeMaterial.uniforms.bloomStrength.value=this.strength,this.compositeMaterial.uniforms.bloomRadius.value=this.radius,this.compositeMaterial.uniforms.bloomTintColors.value=this.bloomTintColors,t.setRenderTarget(this.renderTargetsHorizontal[0]),t.clear(),this._fsQuad.render(t),this._fsQuad.material=this.blendMaterial,this.copyUniforms.tDiffuse.value=this.renderTargetsHorizontal[0].texture,r&&t.state.buffers.stencil.setTest(!0),this.renderToScreen?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(i),this._fsQuad.render(t)),t.setClearColor(this._oldClearColor,this._oldClearAlpha),t.autoClear=a}_getSeparableBlurMaterial(t){let e=[],i=t/3;for(let a=0;a<t;a++)e.push(.39894*Math.exp(-.5*a*a/(i*i))/i);let s=[],r=[];for(let a=1;a<t;a+=2){let o=e[a],c=a+1<t?e[a+1]:0,l=o+c;s.push((a*o+(a+1)*c)/l),r.push(l)}return new ze({defines:{KERNEL_PAIRS:s.length},uniforms:{colorTexture:{value:null},invSize:{value:new ot(.5,.5)},direction:{value:new ot(.5,.5)},centerWeight:{value:e[0]},gaussianOffsets:{value:s},gaussianWeights:{value:r}},vertexShader:`

				varying vec2 vUv;

				void main() {

					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

				}`,fragmentShader:`

				#include <common>

				varying vec2 vUv;

				uniform sampler2D colorTexture;
				uniform vec2 invSize;
				uniform vec2 direction;
				uniform float centerWeight;
				uniform float gaussianOffsets[KERNEL_PAIRS];
				uniform float gaussianWeights[KERNEL_PAIRS];

				void main() {

					vec3 diffuseSum = texture2D( colorTexture, vUv ).rgb * centerWeight;

					for ( int i = 0; i < KERNEL_PAIRS; i ++ ) {

						vec2 uvOffset = direction * invSize * gaussianOffsets[ i ];
						vec3 sample1 = texture2D( colorTexture, vUv + uvOffset ).rgb;
						vec3 sample2 = texture2D( colorTexture, vUv - uvOffset ).rgb;
						diffuseSum += ( sample1 + sample2 ) * gaussianWeights[ i ];

					}

					gl_FragColor = vec4( diffuseSum, 1.0 );

				}`})}_getCompositeMaterial(t){return new ze({defines:{NUM_MIPS:t},uniforms:{blurTexture1:{value:null},blurTexture2:{value:null},blurTexture3:{value:null},blurTexture4:{value:null},blurTexture5:{value:null},bloomStrength:{value:1},bloomFactors:{value:null},bloomTintColors:{value:null},bloomRadius:{value:0}},vertexShader:`

				varying vec2 vUv;

				void main() {

					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

				}`,fragmentShader:`

				varying vec2 vUv;

				uniform sampler2D blurTexture1;
				uniform sampler2D blurTexture2;
				uniform sampler2D blurTexture3;
				uniform sampler2D blurTexture4;
				uniform sampler2D blurTexture5;
				uniform float bloomStrength;
				uniform float bloomRadius;
				uniform float bloomFactors[NUM_MIPS];
				uniform vec3 bloomTintColors[NUM_MIPS];

				float lerpBloomFactor( const in float factor ) {

					float mirrorFactor = 1.2 - factor;
					return mix( factor, mirrorFactor, bloomRadius );

				}

				void main() {

					// 3.0 for backwards compatibility with previous alpha-based intensity
					vec3 bloom = 3.0 * bloomStrength * (
						lerpBloomFactor( bloomFactors[ 0 ] ) * bloomTintColors[ 0 ] * texture2D( blurTexture1, vUv ).rgb +
						lerpBloomFactor( bloomFactors[ 1 ] ) * bloomTintColors[ 1 ] * texture2D( blurTexture2, vUv ).rgb +
						lerpBloomFactor( bloomFactors[ 2 ] ) * bloomTintColors[ 2 ] * texture2D( blurTexture3, vUv ).rgb +
						lerpBloomFactor( bloomFactors[ 3 ] ) * bloomTintColors[ 3 ] * texture2D( blurTexture4, vUv ).rgb +
						lerpBloomFactor( bloomFactors[ 4 ] ) * bloomTintColors[ 4 ] * texture2D( blurTexture5, vUv ).rgb
					);

					float bloomAlpha = max( bloom.r, max( bloom.g, bloom.b ) );
					gl_FragColor = vec4( bloom, bloomAlpha );

				}`})}};Br.BlurDirectionX=new ot(1,0);Br.BlurDirectionY=new ot(0,1);var yo={name:"OutputShader",uniforms:{tDiffuse:{value:null},toneMappingExposure:{value:1}},vertexShader:`
		precision highp float;

		uniform mat4 modelViewMatrix;
		uniform mat4 projectionMatrix;

		attribute vec3 position;
		attribute vec2 uv;

		varying vec2 vUv;

		void main() {

			vUv = uv;
			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

		}`,fragmentShader:`

		precision highp float;

		uniform sampler2D tDiffuse;

		#include <tonemapping_pars_fragment>
		#include <colorspace_pars_fragment>

		varying vec2 vUv;

		void main() {

			gl_FragColor = texture2D( tDiffuse, vUv );

			// tone mapping

			#ifdef LINEAR_TONE_MAPPING

				gl_FragColor.rgb = LinearToneMapping( gl_FragColor.rgb );

			#elif defined( REINHARD_TONE_MAPPING )

				gl_FragColor.rgb = ReinhardToneMapping( gl_FragColor.rgb );

			#elif defined( CINEON_TONE_MAPPING )

				gl_FragColor.rgb = CineonToneMapping( gl_FragColor.rgb );

			#elif defined( ACES_FILMIC_TONE_MAPPING )

				gl_FragColor.rgb = ACESFilmicToneMapping( gl_FragColor.rgb );

			#elif defined( AGX_TONE_MAPPING )

				gl_FragColor.rgb = AgXToneMapping( gl_FragColor.rgb );

			#elif defined( NEUTRAL_TONE_MAPPING )

				gl_FragColor.rgb = NeutralToneMapping( gl_FragColor.rgb );

			#elif defined( CUSTOM_TONE_MAPPING )

				gl_FragColor.rgb = CustomToneMapping( gl_FragColor.rgb );

			#endif

			// color space

			#ifdef SRGB_TRANSFER

				gl_FragColor = sRGBTransferOETF( gl_FragColor );

			#endif

		}`};var Yc=class extends ki{constructor(){super(),this.isOutputPass=!0,this.uniforms=Un.clone(yo.uniforms),this.material=new Er({name:yo.name,uniforms:this.uniforms,vertexShader:yo.vertexShader,fragmentShader:yo.fragmentShader}),this._fsQuad=new hs(this.material),this._outputColorSpace=null,this._toneMapping=null}render(t,e,i){this.uniforms.tDiffuse.value=i.texture,this.uniforms.toneMappingExposure.value=t.toneMappingExposure,(this._outputColorSpace!==t.outputColorSpace||this._toneMapping!==t.toneMapping)&&(this._outputColorSpace=t.outputColorSpace,this._toneMapping=t.toneMapping,this.material.defines={},he.getTransfer(this._outputColorSpace)===_e&&(this.material.defines.SRGB_TRANSFER=""),this._toneMapping===ja?this.material.defines.LINEAR_TONE_MAPPING="":this._toneMapping===Qa?this.material.defines.REINHARD_TONE_MAPPING="":this._toneMapping===to?this.material.defines.CINEON_TONE_MAPPING="":this._toneMapping===Is?this.material.defines.ACES_FILMIC_TONE_MAPPING="":this._toneMapping===io?this.material.defines.AGX_TONE_MAPPING="":this._toneMapping===no?this.material.defines.NEUTRAL_TONE_MAPPING="":this._toneMapping===eo&&(this.material.defines.CUSTOM_TONE_MAPPING=""),this.material.needsUpdate=!0),this.renderToScreen===!0?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(e),this.clear&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),this._fsQuad.render(t))}dispose(){this.material.dispose(),this._fsQuad.dispose()}};var Zc=class extends Kn{constructor(){super(),this.name="RoomEnvironment",this.position.y=-3.5;let t=new $i;t.deleteAttribute("uv");let e=new Ve({side:di}),i=new Ve,s=new ns(16777215,900,28,2);s.position.set(.418,16.199,.3),this.add(s);let r=new Pt(t,e);r.position.set(-.757,13.219,.717),r.scale.set(31.713,28.305,28.591),this.add(r);let a=new Pa(t,i,6),o=new Ze;o.position.set(-10.906,2.009,1.846),o.rotation.set(0,-.195,0),o.scale.set(2.328,7.905,4.651),o.updateMatrix(),a.setMatrixAt(0,o.matrix),o.position.set(-5.607,-.754,-.758),o.rotation.set(0,.994,0),o.scale.set(1.97,1.534,3.955),o.updateMatrix(),a.setMatrixAt(1,o.matrix),o.position.set(6.167,.857,7.803),o.rotation.set(0,.561,0),o.scale.set(3.927,6.285,3.687),o.updateMatrix(),a.setMatrixAt(2,o.matrix),o.position.set(-2.017,.018,6.124),o.rotation.set(0,.333,0),o.scale.set(2.002,4.566,2.064),o.updateMatrix(),a.setMatrixAt(3,o.matrix),o.position.set(2.291,-.756,-2.621),o.rotation.set(0,-.286,0),o.scale.set(1.546,1.552,1.496),o.updateMatrix(),a.setMatrixAt(4,o.matrix),o.position.set(-2.193,-.369,-5.547),o.rotation.set(0,.516,0),o.scale.set(3.875,3.487,2.986),o.updateMatrix(),a.setMatrixAt(5,o.matrix),this.add(a);let c=new Pt(t,Hr(50));c.position.set(-16.116,14.37,8.208),c.scale.set(.1,2.428,2.739),this.add(c);let l=new Pt(t,Hr(50));l.position.set(-16.109,18.021,-8.207),l.scale.set(.1,2.425,2.751),this.add(l);let h=new Pt(t,Hr(17));h.position.set(14.904,12.198,-1.832),h.scale.set(.15,4.265,6.331),this.add(h);let u=new Pt(t,Hr(43));u.position.set(-.462,8.89,14.52),u.scale.set(4.38,5.441,.088),this.add(u);let d=new Pt(t,Hr(20));d.position.set(3.235,11.486,-12.541),d.scale.set(2.5,2,.1),this.add(d);let f=new Pt(t,Hr(100));f.position.set(0,20,0),f.scale.set(1,.1,1),this.add(f)}dispose(){let t=new Set;this.traverse(e=>{e.isMesh&&(t.add(e.geometry),t.add(e.material))});for(let e of t)e.dispose()}};function Hr(n){return new Wa({color:0,emissive:16777215,emissiveIntensity:n})}function z_(n){return function(){n|=0,n=n+1831565813|0;let t=Math.imul(n^n>>>15,1|n);return t=t+Math.imul(t^t>>>7,61|t)^t,((t^t>>>14)>>>0)/4294967296}}var Ii=class{constructor(t){this.f=z_(t>>>0)}next(){return this.f()}range(t,e){return t+(e-t)*this.f()}int(t,e){return Math.floor(t+(e-t+1)*this.f())}pick(t){return t[Math.floor(this.f()*t.length)]}chance(t){return this.f()<t}shuffle(t){for(let e=t.length-1;e>0;e--){let i=Math.floor(this.f()*(e+1));[t[e],t[i]]=[t[i],t[e]]}return t}weighted(t){let e=0;for(let[,s]of t)e+=s;let i=this.f()*e;for(let[s,r]of t)if(i-=r,i<=0)return s;return t[t.length-1][0]}};function se(n,t,e=0){let i=n*374761393+t*668265263+e*982451653|0;return i=Math.imul(i^i>>>13,1274126177),i=i^i>>>16,(i>>>0)/4294967296}var Gr=(n,t)=>(n%t+t)%t;function ji(n,t,e,i,s){let r=Math.floor(n),a=Math.floor(t),o=n-r,c=t-a,l=o*o*(3-2*o),h=c*c*(3-2*c),u=Gr(r,i),d=Gr(r+1,i),f=Gr(a,s),p=Gr(a+1,s),x=se(u,f,e),m=se(d,f,e),g=se(u,p,e),_=se(d,p,e);return x+(m-x)*l+(g-x)*h+(x-m-g+_)*l*h}function de(n,t,e,i=4,s=4){let r=0,a=.5,o=1,c=0;for(let l=0;l<s;l++){let h=i*o;r+=a*ji(n*h,t*h,e+l*31,h,h),c+=a,a*=.5,o*=2}return r/c}function ei(n,t,e,i,s=.9){let r=n*i,a=t*i,o=Math.floor(r),c=Math.floor(a),l=9,h=9,u=0;for(let d=-1;d<=1;d++)for(let f=-1;f<=1;f++){let p=o+f,x=c+d,m=Gr(p,i),g=Gr(x,i),_=p+.5+(se(m,g,e)-.5)*s,T=x+.5+(se(m,g,e+7)-.5)*s,v=_-r,S=T-a,M=Math.sqrt(v*v+S*S);M<l?(h=l,l=M,u=m+g*131):M<h&&(h=M)}return[l,h,u]}var Je=(n,t,e)=>n<t?t:n>e?e:n,re=(n,t,e)=>n+(t-n)*e,pe=(n,t,e)=>{let i=Je((e-n)/(t-n),0,1);return i*i*(3-2*i)},Bi=(n,t,e,i)=>re(n,t,1-Math.exp(-e*i));function us(n,t){let e=t-n;for(;e>Math.PI;)e-=Math.PI*2;for(;e<-Math.PI;)e+=Math.PI*2;return e}function Fn(n,t,e,i){return n+us(n,t)*(1-Math.exp(-e*i))}var Jc={noun:"braseiro ancestral",plural:"braseiros ancestrais",verb:"Acender",done:"aceso"},zn={catacumbas:{name:"Catacumbas Esquecidas",walls:[["brick",5],["brick_mossy",3],["brick_cracked",2],["bone_wall",1]],floor:[["flagstone",6],["cobble",2]],corridor:"cobble",raised:"polished",cap:"slate",pillar:"brick",foundation:"brick",pillarStyle:"stone",pool:"pit",bridge:"planks",fog:460812,fogD:.026,hemiSky:6254484,hemiGround:1775122,hemi:.55,moon:9413590,moonI:.9,torch:16751178,wet:.3,gloss:0,enemies:[["rastejante",6],["cardo",3],["mariposa",2],["vidente",1],["serpe",1]],boss:"gorran",props:["bones","bones","skull","cobweb","candles","pot","pot","barrel","banner","rubble","coffin","urn"],obj:Jc,ambient:"dust"},minas:{name:"Minas de Ferro Negro",walls:[["stone",6],["stone_ore",2]],floor:[["dirt",5],["gravel",3]],corridor:"gravel",raised:"planks",cap:"stone",pillar:"log_side",foundation:"stone",pillarStyle:"wood",pool:"water",bridge:"planks",fog:461066,fogD:.024,hemiSky:8096392,hemiGround:2958360,hemi:.72,moon:10466496,moonI:.75,torch:16756832,wet:.45,gloss:0,water:729638,enemies:[["serpe",5],["couracado",2],["medusa",3],["rastejante",2],["mariposa",2]],boss:"veshkara",props:["crate","crate","barrel","barrel","beam","crystal","crystal","rubble","pot","cart","stalagmite","stalagmite"],obj:Jc,ambient:"drip"},forja:{name:"Forja Profunda",walls:[["darkbrick",5],["basalt",3],["obsidian",1]],floor:[["basalt",5],["basalt_glow",1]],corridor:"basalt",raised:"obsidian",cap:"obsidian",pillar:"darkbrick",foundation:"basalt",pillarStyle:"basalt",pool:"lava",bridge:"basalt",fog:788230,fogD:.026,hemiSky:8018512,hemiGround:1707016,hemi:.45,moon:13668464,moonI:.55,torch:16742960,wet:.12,gloss:.15,enemies:[["couracado_magma",3],["medusa",3],["vidente",2],["cardo",2],["rastejante",2]],boss:"colosso",props:["anvil","barrel","crate","rubble","rubble","banner","pot","chains","rock"],obj:Jc,ambient:"embers"},geleira:{name:"Geleira Eterna",dimension:!0,walls:[["icewall",5],["frost",3]],floor:[["ice",5],["snow",3]],corridor:"snow",raised:"ice",cap:"snow",pillar:"icewall",foundation:"frost",pillarStyle:"ice",pool:"ice",bridge:"ice",fog:659480,fogD:.022,hemiSky:10139872,hemiGround:2634816,hemi:.85,moon:12244223,moonI:1.2,torch:10148095,wet:0,gloss:.85,slippery:!0,enemies:[["lobo_gelo",5],["casco",3],["aparicao",2],["mariposa_neve",2],["cardo_gelo",2]],boss:"ysra",props:["icespike","icespike","rock","crystal","pot","rubble","frozenbody"],obj:{noun:"cristal de ancoragem",plural:"cristais de ancoragem",verb:"Despertar",done:"desperto"},ambient:"snow"},pantano:{name:"P\xE2ntano Afogado",dimension:!0,walls:[["swampwall",5],["mossstone",3]],floor:[["mud",5],["mossstone",3]],corridor:"mud",raised:"planks",cap:"mossstone",pillar:"log_side",foundation:"mossstone",pillarStyle:"tree",pool:"swamp",bridge:"planks",shallow:!0,fog:658952,fogD:.03,hemiSky:8030826,hemiGround:1711120,hemi:.6,moon:11061392,moonI:.65,torch:14735504,wet:.7,gloss:0,water:1713168,enemies:[["afogado",5],["serpe",3],["medusa",3],["cardo",3],["mariposa",2]],boss:"flor",props:["mushroom","mushroom","reeds","reeds","deadtree","rock","pot","lily","bones"],obj:{noun:"totem de ra\xEDzes",plural:"totens de ra\xEDzes",verb:"Purificar",done:"purificado"},ambient:"spores"},vazio:{name:"Vazio Estelar",dimension:!0,walls:[["voidcrystal",5],["voidtile",2]],floor:[["voidtile",6],["voidcrystal",1]],corridor:"voidtile",raised:"voidcrystal",cap:"voidcrystal",pillar:"voidcrystal",foundation:"voidcrystal",pillarStyle:"crystal",pool:"void",bridge:"voidtile",fog:393996,fogD:.02,hemiSky:8018608,hemiGround:1050648,hemi:.6,moon:11571455,moonI:.8,torch:12615935,wet:0,gloss:.7,enemies:[["espreitador",5],["vidente",2],["medusa_vazio",3],["couracado",2],["mariposa",1]],boss:"arauto",props:["floatcrystal","floatcrystal","crystal","rock","pot","obelisk"],obj:{noun:"selo estelar",plural:"selos estelares",verb:"Romper",done:"rompido"},ambient:"stars",voidPits:!0},refugio:{name:"Ref\xFAgio da \xDAltima Chama",hub:!0,walls:[["stone",5],["brick",2]],floor:[["flagstone",5],["cobble",2]],corridor:"cobble",raised:"planks",cap:"stone",pillar:"log_side",foundation:"stone",pillarStyle:"wood",pool:"water",bridge:"planks",fog:657414,fogD:.016,hemiSky:10127992,hemiGround:3811866,hemi:1.05,moon:16765088,moonI:.6,torch:16752720,wet:.35,gloss:0,water:662562,enemies:[],boss:null,props:[],obj:Jc,ambient:"embers"}},O_=["catacumbas","minas","forja"],_o=["geleira","pantano","vazio"],Kc=n=>O_[(n-1)%3];var St={VOID:0,FLOOR:1,WALL:2,PIT:3,LAVA:4,WATER:5,PILLAR:6},xp=new Set(["barrel","crate","coffin","crystal","cart","anvil","stalagmite","rock","icespike","deadtree","obelisk","frozenbody"]),_d=class{constructor(){this.a=[]}push(t,e){let i=this.a;i.push([t,e]);let s=i.length-1;for(;s>0;){let r=s-1>>1;if(i[r][1]<=i[s][1])break;[i[s],i[r]]=[i[r],i[s]],s=r}}pop(){let t=this.a,e=t[0],i=t.pop();if(t.length){t[0]=i;let s=0;for(;;){let r=s*2+1,a=r+1,o=s;if(r<t.length&&t[r][1]<t[o][1]&&(o=r),a<t.length&&t[a][1]<t[o][1]&&(o=a),o===s)break;[t[s],t[o]]=[t[o],t[s]],s=o}}return e[0]}get size(){return this.a.length}};function yd(n,t){let e=0;for(let[,i]of n)e+=i;t*=e;for(let[i,s]of n)if(t-=s,t<=0)return i;return n[0][0]}function vp(n,t){let e=n*t;return{W:n,D:t,N:e,idx:(i,s)=>i+s*n,inb:(i,s)=>i>=0&&s>=0&&i<n&&s<t,cell:new Uint8Array(e),h:new Int8Array(e),mat:new Array(e).fill(null),room:new Int16Array(e).fill(-1),corr:new Uint8Array(e),solid:new Uint8Array(e),thin:new Uint8Array(e),wallH:new Uint8Array(e)}}function yp(n,t,e,i){let{W:s,D:r,cell:a,h:o,mat:c,wallH:l,corr:h,solid:u,room:d,idx:f,inb:p}=n,x=(M,A)=>{if(!p(M,A))return!1;let y=a[f(M,A)];return y!==St.VOID&&y!==St.WALL};for(let M=0;M<r;M++)for(let A=0;A<s;A++){if(a[f(A,M)]!==St.VOID)continue;let y=!1;for(let E=-1;E<=1&&!y;E++)for(let P=-1;P<=1;P++)if(x(A+P,M+E)){y=!0;break}y&&(a[f(A,M)]=St.WALL)}for(let M=0;M<r;M++)for(let A=0;A<s;A++){let y=f(A,M);a[y]===St.WALL&&(l[y]=x(A-1,M)||x(A,M-1)||x(A-1,M-1)?2:4),a[y]===St.PILLAR&&(l[y]=4)}let m=(M,A,y)=>ji(M*.17,A*.17,e+y,4096,4096)*.8+se(M,A,e+y)*.2;for(let M=0;M<r;M++)for(let A=0;A<s;A++){let y=f(A,M);a[y]===St.FLOOR&&!c[y]&&(h[y]?c[y]=m(A,M,1)<.62?t.corridor:yd(t.floor,m(M,A,2)):c[y]=yd(t.floor,m(A,M,2))),a[y]===St.WALL&&(c[y]=yd(t.walls,m(A,M,3))),a[y]===St.PILLAR&&(c[y]=t.pillar)}let g=[],_=(M,A,y,E)=>M.some(P=>Math.hypot(P.cx-A,P.cz-y)<E);for(let M=1;M<r-1;M++)for(let A=1;A<s-1;A++){let y=f(A,M);if(!(a[y]!==St.WALL||l[y]!==4))for(let[E,P]of[[1,0],[0,1]]){let N=f(A+E,M+P);if(!(a[N]!==St.FLOOR||u[N])&&!(se(A,M,e+9)<.35||_(g,A,M,6))){g.push({cx:A,cz:M,x:A+.5+E*.62,y:o[N]+2.1,z:M+.5+P*.62,nx:E,nz:P});break}}}let T=[];if(t.props.includes("banner")||t.hub)for(let M=1;M<r-1;M++)for(let A=1;A<s-1;A++){let y=f(A,M);if(!(a[y]!==St.WALL||l[y]!==4||h[y]))for(let[E,P]of[[1,0],[0,1]]){let N=f(A+E,M+P);if(!(a[N]!==St.FLOOR||h[N]||d[N]<0)&&!(se(A,M,e+19)<.8||_(g,A,M,2)||_(T,A,M,7))){T.push({cx:A,cz:M,x:A+.5+E*.53,y:o[N]+2.4,z:M+.5+P*.53,nx:E,nz:P});break}}}let v=[];if(t.props.includes("cobweb"))for(let M=1;M<r-1;M++)for(let A=1;A<s-1;A++){let y=f(A,M);if(a[y]!==St.FLOOR||u[y])continue;let E=f(A-1,M),P=f(A,M-1);a[E]===St.WALL&&l[E]===4&&a[P]===St.WALL&&l[P]===4&&se(A,M,e+29)<.55&&v.push({x:A,z:M,y:o[y]})}let S=[];for(let M=0;M<r;M++)for(let A=0;A<s;A++)a[f(A,M)]===St.PILLAR&&S.push({x:A+.5,z:M+.5,y:o[f(A,M)]});return{torches:g,banners:T,cobwebs:v,pillars:S}}function bd(n,t,e){for(let i=0;i<24;i++){let s=k_(n+i*7919,t,e);if(s)return s}throw new Error("falha ao gerar masmorra")}function k_(n,t,e){let i=new Ii(n),s=zn[e],r=140,a=140,o=vp(r,a),{N:c,idx:l,inb:h,cell:u,h:d,mat:f,room:p,corr:x,solid:m,thin:g}=o,_=[],T=(w,J)=>{for(let Q=0;Q<400;Q++){let st=i.int(3,r-w-4),nt=i.int(3,a-J-4),L=!0;for(let yt of _)if(st<yt.x+yt.w+5&&st+w+5>yt.x&&nt<yt.z+yt.d+5&&nt+J+5>yt.z){L=!1;break}if(L){let yt={x:st,z:nt,w,d:J,cx:st+w/2,cz:nt+J/2,type:"normal",id:_.length};return _.push(yt),yt}}return null},v=T(22,22);v.type="boss";for(let w=0;w<260&&_.length<22;w++)T(i.int(8,16),i.int(8,16));if(_.length<14)return null;for(let w of _)for(let J=w.z;J<w.z+w.d;J++)for(let Q=w.x;Q<w.x+w.w;Q++)u[l(Q,J)]=St.FLOOR,p[l(Q,J)]=w.id;for(let w of _)if(w.type!=="boss")for(let[J,Q,st,nt]of[[w.x,w.z,1,1],[w.x+w.w-1,w.z,-1,1],[w.x,w.z+w.d-1,1,-1],[w.x+w.w-1,w.z+w.d-1,-1,-1]]){let L=i.int(0,2);for(let yt=0;yt<L;yt++)for(let zt=0;zt<L-yt;zt++){let C=l(J+st*yt,Q+nt*zt);u[C]=St.VOID,p[C]=-1}}let S=_.filter(w=>w!==v),M=(w,J)=>Math.hypot(w.cx-J.cx,w.cz-J.cz),A=S[0];for(let w of S)M(w,v)>M(A,v)&&(A=w);A.type="start";let y=[],E=new Set([A]);for(;E.size<S.length;){let w=null,J=1e9;for(let Q of E)for(let st of S)if(!E.has(st)){let nt=M(Q,st);nt<J&&(J=nt,w=[Q,st])}E.add(w[1]),y.push(w)}for(let w=0;w<S.length;w++)for(let J=w+1;J<S.length;J++){let Q=S[w],st=S[J];M(Q,st)<30&&!y.some(nt=>nt[0]===Q&&nt[1]===st||nt[0]===st&&nt[1]===Q)&&i.chance(.2)&&y.push([Q,st])}let P=3,N=(w,J)=>w>=v.x-P&&w<v.x+v.w+P&&J>=v.z-P&&J<v.z+v.d+P,F=(w,J,Q,st,nt)=>{let L=new Float32Array(c).fill(1e9),yt=new Int32Array(c).fill(-1),zt=new Int8Array(c).fill(-1),C=new _d,b=l(w,J),O=l(Q,st);L[b]=0,C.push(b,0);let V=[1,-1,0,0],K=[0,0,1,-1];for(;C.size;){let it=C.pop();if(it===O)break;let ct=it%r,wt=it/r|0;for(let kt=0;kt<4;kt++){let Mt=ct+V[kt],bt=wt+K[kt];if(Mt<3||bt<3||Mt>r-4||bt>a-4||nt&&N(Mt,bt))continue;let Bt=l(Mt,bt),jt=u[Bt]===St.FLOOR?.6:1;zt[it]!==-1&&zt[it]!==kt&&(jt+=2.5);let ne=L[it]+jt;ne<L[Bt]&&(L[Bt]=ne,yt[Bt]=it,zt[Bt]=kt,C.push(Bt,ne+Math.abs(Mt-Q)+Math.abs(bt-st)))}}let gt=[],xt=O;if(yt[xt]===-1&&xt!==b)return null;for(;xt!==-1&&(gt.push(xt),xt!==b);)xt=yt[xt];return gt},B=w=>{for(let J of w){let Q=J%r,st=J/r|0;for(let nt=-1;nt<=1;nt++)for(let L=-1;L<=1;L++){let yt=l(Q+L,st+nt);u[yt]===St.VOID&&(u[yt]=St.FLOOR,x[yt]=1)}}};for(let[w,J]of y){let Q=F(Math.floor(w.cx),Math.floor(w.cz),Math.floor(J.cx),Math.floor(J.cz),!0);if(!Q)return null;B(Q)}let I=S[0];for(let w of S)w!==A&&M(w,v)<M(I,v)&&(I=w);let H=F(Math.floor(I.cx),Math.floor(I.cz),Math.floor(v.cx),Math.floor(v.cz),!1);if(!H)return null;B(H);let W=[];for(let w=v.z-1;w<=v.z+v.d;w++)for(let J=v.x-1;J<=v.x+v.w;J++)(J===v.x-1||J===v.x+v.w||w===v.z-1||w===v.z+v.d)&&u[l(J,w)]===St.FLOOR&&W.push({x:J,z:w});if(W.length===0||W.length>8)return null;let U=S.filter(w=>w!==A),X=[],G=[];for(let w=0;w<3;w++){let J=null,Q=-1;for(let st of U){if(st.type!=="normal")continue;let nt=M(st,A)*.6;for(let L of G)nt=Math.min(nt,M(st,L));nt+=i.range(0,4),nt>Q&&(Q=nt,J=st)}if(!J)return null;J.type="brazier",G.push(J)}let j=U.filter(w=>w.type==="normal");j.length&&(j.sort((w,J)=>J.w*J.d-w.w*w.d)[0].type="treasure");let et=U.filter(w=>w.type==="normal");et.length>=2&&(i.pick(et).type="altar");let vt=(w,J,Q)=>{for(let st=-Q;st<=Q;st++)for(let nt=-Q;nt<=Q;nt++){let L=l(w+nt,J+st);if(h(w+nt,J+st)&&x[L])return!0}return!1},ht=(w,J)=>{let Q=l(w,J);u[Q]===St.FLOOR&&!vt(w,J,2)&&(u[Q]=St.PILLAR,m[Q]=1)},Ut=s.pool,$t=Ut==="lava"?St.LAVA:Ut==="water"||Ut==="swamp"?St.WATER:Ut==="ice"?St.FLOOR:St.PIT,Kt=w=>{Ut==="ice"?(u[w]=St.FLOOR,f[w]="ice"):u[w]=$t},$={chests:[],pots:[],altar:null,spawns:[]},rt=[],_t=w=>({x:Math.floor(w.cx),z:Math.floor(w.cz)});for(let w of _){if(w.type==="boss"){for(let nt=w.z+3;nt<w.z+w.d-3;nt+=4)ht(w.x+3,nt),ht(w.x+w.w-4,nt);for(let nt=w.x+7;nt<w.x+w.w-7;nt+=4)ht(nt,w.z+3),ht(nt,w.z+w.d-4);if($t!==St.WATER&&Ut!=="ice")for(let[nt,L]of[[1,1],[w.w-3,1],[1,w.d-3],[w.w-3,w.d-3]])for(let yt=0;yt<2;yt++)for(let zt=0;zt<2;zt++){let C=w.x+nt+zt,b=w.z+L+yt;vt(C,b,2)||Kt(l(C,b))}continue}if(w.type==="start")continue;let J=w.w>=11&&w.d>=11;if(w.type==="brazier"||w.type==="treasure"||w.type==="altar"||!J&&i.chance(.3)){let nt=Math.min(3,Math.floor(w.w/3)),L=Math.min(3,Math.floor(w.d/3));for(let yt=w.z+L;yt<w.z+w.d-L;yt++)for(let zt=w.x+nt;zt<w.x+w.w-nt;zt++){let C=l(zt,yt);u[C]===St.FLOOR&&(d[C]=1,f[C]=s.raised)}}else if(J&&i.chance(Ut==="swamp"?.8:.55)){let nt=w.cx,L=w.cz,yt=w.w/2-2.5,zt=w.d/2-2.5;for(let C=w.z+2;C<w.z+w.d-2;C++)for(let b=w.x+2;b<w.x+w.w-2;b++){let O=(b+.5-nt)/yt,V=(C+.5-L)/zt,K=ji(b*.3,C*.3,n+71,4096,4096)*.5;O*O+V*V<.75+K&&Kt(l(b,C))}if(Ut!=="ice"&&($t!==St.WATER||i.chance(.5))){let C=w.w>=w.d,b=Math.floor(C?w.cz:w.cx);for(let O=0;O<2;O++)if(C)for(let V=w.x+1;V<w.x+w.w-1;V++){let K=l(V,b-1+O);u[K]!==St.FLOOR&&(u[K]=St.FLOOR,g[K]=1,f[K]=s.bridge)}else for(let V=w.z+1;V<w.z+w.d-1;V++){let K=l(b-1+O,V);u[K]!==St.FLOOR&&(u[K]=St.FLOOR,g[K]=1,f[K]=s.bridge)}}}else if(J)for(let nt=w.z+2;nt<w.z+w.d-2;nt+=3)ht(w.x+2,nt),ht(w.x+w.w-3,nt);let st=_t(w);w.type==="brazier"&&X.push({x:st.x+.5,z:st.z+.5}),w.type==="treasure"&&$.chests.push({x:st.x+.5,z:st.z+.5,big:!0}),w.type==="altar"&&($.altar={x:st.x+.5,z:st.z+.5})}if(Ut==="swamp")for(let w=2;w<a-2;w++)for(let J=2;J<r-2;J++){let Q=l(J,w);u[Q]!==St.FLOOR||d[Q]||g[Q]||N(J,w)||ji(J*.21,w*.21,n+91,4096,4096)>.72&&(u[Q]=St.WATER)}for(let w of X)m[l(Math.floor(w.x),Math.floor(w.z))]=1;for(let w of $.chests)m[l(Math.floor(w.x),Math.floor(w.z))]=1;$.altar&&(m[l(Math.floor($.altar.x),Math.floor($.altar.z))]=1);let Jt=yp(o,s,n,i),At=[],Yt=(w,J)=>{let Q=l(w,J);return u[Q]===St.FLOOR&&!m[Q]&&!g[Q]&&!x[Q]};for(let w of _){if(w.type==="boss")continue;let J=Math.floor(w.w*w.d/14);for(let Q=0;Q<J;Q++){let st,nt,L=i.int(0,3);if(L===0?(st=w.x,nt=i.int(w.z,w.z+w.d-1)):L===1?(st=w.x+w.w-1,nt=i.int(w.z,w.z+w.d-1)):L===2?(nt=w.z,st=i.int(w.x,w.x+w.w-1)):(nt=w.z+w.d-1,st=i.int(w.x,w.x+w.w-1)),i.chance(.25)&&(st=i.int(w.x+1,w.x+w.w-2),nt=i.int(w.z+1,w.z+w.d-2)),!Yt(st,nt)||vt(st,nt,2))continue;let yt=i.pick(s.props);if(!(yt==="banner"||yt==="cobweb"||yt==="chains"||yt==="beam"||yt==="lily")){if(yt==="pot"){$.pots.push({x:st+.5,z:nt+.5}),m[l(st,nt)]=2;continue}w.type==="start"&&xp.has(yt)&&i.chance(.5)||(rt.push({type:yt,x:st+.5,z:nt+.5,y:d[l(st,nt)],rot:i.range(0,Math.PI*2),s:i.range(.85,1.15),seed:i.int(0,1e6)}),m[l(st,nt)]=xp.has(yt)?1:2)}}if(w.type==="normal"&&i.chance(.3)){let Q=i.chance(.5)?w.x+1:w.x+w.w-2,st=i.chance(.5)?w.z+1:w.z+w.d-2;Yt(Q,st)&&!vt(Q,st,2)&&($.chests.push({x:Q+.5,z:st+.5,big:!1}),m[l(Q,st)]=1)}for(let Q=0;Q<2;Q++){let st=i.int(w.x,w.x+w.w-1),nt=i.int(w.z,w.z+w.d-1);Yt(st,nt)&&!vt(st,nt,1)&&($.pots.push({x:st+.5,z:nt+.5}),m[l(st,nt)]=2)}}if(s.props.includes("lily"))for(let w=1;w<a-1;w++)for(let J=1;J<r-1;J++){let Q=l(J,w);u[Q]===St.WATER&&se(J,w,n+41)<.12?rt.push({type:"lily",x:J+.3+se(w,J,3)*.4,z:w+.3+se(J,w,4)*.4,y:-.3,rot:se(J,w,5)*6.28,s:.8+se(J,w,6)*.5}):u[Q]===St.FLOOR&&!m[Q]&&!x[Q]&&se(J,w,n+43)<.25&&[[1,0],[-1,0],[0,1],[0,-1]].some(([st,nt])=>u[l(J+st,w+nt)]===St.WATER)&&(rt.push({type:"reeds",x:J+.5,z:w+.5,y:d[Q],rot:se(J,w,7)*6.28,s:.8+se(J,w,8)*.4}),m[Q]=2)}for(let w of rt)(w.type==="crystal"||w.type==="floatcrystal")&&At.push({x:w.x,y:w.y+.9,z:w.z,color:s.dimension?11563263:6281471,intensity:3,dist:6});for(let w of rt)w.type==="mushroom"&&At.push({x:w.x,y:w.y+.6,z:w.z,color:10152112,intensity:1.2,dist:4});let fe=(w,J)=>{let Q=u[l(w,J)];return(Q===St.FLOOR||Q===St.WATER)&&m[l(w,J)]!==1};for(let w of _){if(w.type==="start"||w.type==="boss")continue;let J=w.type==="treasure"?2:1+(w.w*w.d>150?1:0);for(let Q=0;Q<J;Q++){let st=Math.min(8,i.int(2,4)+Math.floor((t-1)*.6)),nt=i.int(w.x+1,w.x+w.w-2),L=i.int(w.z+1,w.z+w.d-2);for(let yt=0;yt<st;yt++)for(let zt=0;zt<12;zt++){let C=nt+i.int(-2,2),b=L+i.int(-2,2);if(C>=w.x&&b>=w.z&&C<w.x+w.w&&b<w.z+w.d&&fe(C,b)){$.spawns.push({type:i.weighted(s.enemies),x:C+i.range(.3,.7),z:b+i.range(.3,.7)});break}}}}for(let w=0;w<45;w++){let J=i.int(3,r-4),Q=i.int(3,a-4),st=l(J,Q);x[st]&&fe(J,Q)&&Math.hypot(J-A.cx,Q-A.cz)>18&&!N(J,Q)&&i.chance(.4)&&$.spawns.push({type:i.weighted(s.enemies),x:J+.5,z:Q+.5})}let at=new Uint8Array(c),ut=[l(Math.floor(A.cx),Math.floor(A.cz))];if(!fe(ut[0]%r,ut[0]/r|0))return null;for(at[ut[0]]=1;ut.length;){let w=ut.pop(),J=w%r,Q=w/r|0;for(let[st,nt]of[[1,0],[-1,0],[0,1],[0,-1]]){let L=J+st,yt=Q+nt,zt=l(L,yt);!h(L,yt)||at[zt]||!fe(L,yt)||Math.abs(d[zt]-d[w])>1||(at[zt]=1,ut.push(zt))}}let pt=(w,J)=>{for(let[Q,st]of[[1,0],[-1,0],[0,1],[0,-1]])if(at[l(w+Q,J+st)])return!0;return!1};for(let w of X)if(!pt(Math.floor(w.x),Math.floor(w.z)))return null;if(!W.some(w=>at[l(w.x,w.z)]))return null;for(let w of $.chests)pt(Math.floor(w.x),Math.floor(w.z))||(m[l(Math.floor(w.x),Math.floor(w.z))]=0,w.dead=!0);$.chests=$.chests.filter(w=>!w.dead),$.altar&&!pt(Math.floor($.altar.x),Math.floor($.altar.z))&&($.altar=null),$.spawns=$.spawns.filter(w=>at[l(Math.floor(w.x),Math.floor(w.z))]);let mt=[];for(let w of i.shuffle?i.shuffle(S.slice()):S)if(w.type==="normal")for(let J=0;J<20;J++){let Q=i.int(w.x+1,w.x+w.w-2),st=i.int(w.z+1,w.z+w.d-2),nt=l(Q,st);if(at[nt]&&Yt(Q,st)&&!vt(Q,st,1)){mt.push({x:Q+.5,z:st+.5,room:w.id});break}}return{...o,seed:n,level:t,themeKey:e,theme:s,rooms:_,boss:v,start:A,gates:W,braziers:X,...Jt,props:rt,lightsExtra:At,...$,spots:mt}}function jc(n){let t=zn.refugio,e=new Ii(n),i=52,s=52,r=vp(i,s),{idx:a,cell:o,h:c,mat:l,room:h,solid:u}=r,d=26,f=26;for(let v=4;v<s-4;v++)for(let S=4;S<i-4;S++){let M=(S+.5-d)/19,A=(v+.5-f)/18,y=ji(S*.25,v*.25,n,4096,4096)*.35;M*M+A*A<.9+y&&(o[a(S,v)]=St.FLOOR,h[a(S,v)]=0)}for(let v=f-3;v<=f+3;v++)for(let S=d-3;S<=d+3;S++)Math.hypot(S+.5-d,v+.5-f)<3.4&&(l[a(S,v)]="cobble");for(let v=f+8;v<f+13;v++)for(let S=d-5;S<d+5;S++){let M=(S+.5-d)/5,A=(v+.5-(f+10.5))/2.6;M*M+A*A<1&&(o[a(S,v)]=St.WATER)}let p=(v,S,M,A,y)=>{for(let E=S;E<S+A;E++)for(let P=v;P<v+M;P++){let N=a(P,E);o[N]===St.FLOOR&&(c[N]=1,l[N]=y)}};p(d-13,f-9,6,5,"planks"),p(d+7,f-9,6,5,"polished");let x=(v,S,M,A=0,y=1)=>{let E=a(Math.floor(S),Math.floor(M));return{type:v,x:S,z:M,y:c[E],rot:A,s:y,seed:e.int(0,1e6)}},m=[x("tent",d-10,f-10.2,0,1.1),x("tent",d+10,f-10.2,0,1.1),x("crate",d-12.5,f-5.8,.3),x("barrel",d-7.6,f-5.6,0),x("crate",d-13.2,f-7.8,1.1),x("anvil",d+8.5,f-6.2,.2),x("forge",d+11.5,f-7.5,0),x("barrel",d+7.5,f-8.8,0),x("board",d,f-12.5,0,1),x("bench",d-3.2,f+3.6,.6),x("bench",d+3.2,f+3.6,-.6),x("bedroll",d-14,f+2,1.2),x("bedroll",d-13,f+5.5,1.6),x("barrel",d+15,f+3,0),x("crate",d+14.6,f+5,.5),x("rock",d-16,f-2,0,1.4),x("rock",d+16.5,f-1,1,1.2),x("reeds",d-5.5,f+10.5,0),x("reeds",d+5.3,f+11,1),x("mushroom",d-15,f+9,0),x("mushroom",d+15.5,f+8,1),x("candles",d-1.5,f-12,0),x("banner",d,f,0)].filter(v=>v.type!=="banner");for(let v of m)if(["crate","barrel","anvil","forge","board","rock","tent"].includes(v.type)){let S=v.type==="tent"?2:v.type==="board"?1:0;for(let M=-S;M<=S;M++)for(let A=-S;A<=S;A++)v.type==="tent"&&M>0||(u[a(Math.floor(v.x)+A,Math.floor(v.z)+M)]=1)}let g={campfire:{x:d+.5,z:f+.5},board:{x:d+.5,z:f-11.8},stall:{x:d-9.5,z:f-6.6},forge:{x:d+10.5,z:f-6.6},dimPortal:{x:d-11.5,z:f+3.5},descent:{x:d+11.5,z:f+3.5}};u[a(d,f)]=1;for(let v of["dimPortal","descent"]){let S=g[v];for(let M=-1;M<=1;M++)u[a(Math.floor(S.x)+M,Math.floor(S.z)-1)]=1}let _=[{kind:"mercadora",x:d-9.5,z:f-7.6,rot:0,role:"shop",name:"Ilsa, a Mercadora"},{kind:"ferreiro",x:d+10.5,z:f-7.6,rot:0,role:"smith",name:"Brom, o Ferreiro"},{kind:"escriba",x:d-1.8,z:f-10.6,rot:.3,role:"quests",name:"Oren, o Escriba"}];for(let v of _)u[a(Math.floor(v.x),Math.floor(v.z))]=1;let T=yp(r,t,n,e);return{...r,seed:n,level:1,themeKey:"refugio",theme:t,hub:!0,rooms:[{x:4,z:4,w:i-8,d:s-8,cx:d,cz:f,type:"hub",id:0}],boss:null,start:{cx:d+.5,cz:f+5.5},gates:[],braziers:[],...T,props:m,lightsExtra:[{x:d+.5,y:1.2,z:f+.5,color:16751168,intensity:26,dist:16}],chests:[],pots:[],altar:null,spawns:[],spots:[],npcs:_,hubObj:g}}var Qt=64,bo=8,ds=Qt+bo*2,Vr=8,nh={},ih=[],Ce=(n,t)=>{nh[n]=ih.length,ih.push({name:n,gen:t})};function Hi(n,t,e){n.r=re(n.r,t[0],e),n.g=re(n.g,t[1],e),n.b=re(n.b,t[2],e)}function bp(n,t=3){let e=new Float32Array(Qt*Qt),i=new Ii(n);for(let s=0;s<t;s++){let r=i.range(0,Qt),a=i.range(0,Qt),o=i.range(0,Math.PI*2),c=i.int(18,40);for(let l=0;l<c;l++){o+=i.range(-.6,.6),r+=Math.cos(o),a+=Math.sin(o);for(let h=-1;h<=1;h++)for(let u=-1;u<=1;u++){let d=((Math.round(r)+u)%Qt+Qt)%Qt,f=((Math.round(a)+h)%Qt+Qt)%Qt,p=u===0&&h===0?1:.35*(1-l/c);e[f*Qt+d]=Math.max(e[f*Qt+d],p)}i.chance(.06)&&(o+=i.range(-1.2,1.2))}}return e}function Mo(n){let t=n.crack?bp(n.seed+99,n.crack):null,e=n.bw||32,i=n.bh||16;return(s,r,a,o,c)=>{let l=Math.floor(c/i),h=l%2*(e/2),u=(o+h)%Qt,d=Math.floor(u/e),f=u-d*e,p=c-l*i,x=de(s,r,n.seed,8,4),m=Math.min(f+.5,e-f-.5,p+.5,i-p-.5)+(x-.5)*2.2,g=pe(.6,3,m),T=1+(se(d,l,n.seed)-.5)*n.var+(x-.5)*.4,v=se(o,c,n.seed+3)<.05?.82:1,S=n.mortar;a.r=re(S[0],n.base[0]*T*v,g),a.g=re(S[1],n.base[1]*T*v,g),a.b=re(S[2],n.base[2]*T*v,g);let M=de(s,r,n.seed+11,16,2);if(a.h=.12+g*(.62+M*.18)+(x-.5)*.2,a.ro=re(.97,.78+x*.15,g),n.moss){let A=de(s,r,n.seed+50,4,5)+(1-g)*.14+c/Qt*.08,y=pe(.66-n.moss*.2,.72-n.moss*.2,A);if(y>0){let E=de(s,r,n.seed+80,16,3);Hi(a,[.15+E*.1,.25+E*.15,.07+E*.04],y),a.h=re(a.h,.75+E*.2,y),a.ro=re(a.ro,1,y)}}if(t){let A=t[c*Qt+o];A>0&&(a.r*=1-.75*A,a.g*=1-.75*A,a.b*=1-.75*A,a.h-=.55*A)}}}function Wr(n){return(t,e,i)=>{let[s,r,a]=ei(t,e,n.seed,n.n,n.jit||.8),o=de(t,e,n.seed+5,8,4),c=r-s+(o-.5)*.06,l=pe(.02,n.soft||.12,c),h=1+(se(a,3,n.seed)-.5)*n.var+(o-.5)*.35;i.r=re(n.grout[0],n.base[0]*h,l),i.g=re(n.grout[1],n.base[1]*h,l),i.b=re(n.grout[2],n.base[2]*h,l),i.h=.1+l*.6+(o-.5)*.2+(n.dome?(1-s*1.5)*n.dome:0),i.ro=re(.98,n.rough||.8,l)}}function Mp(n,t,e){return ji(n*3,t*40,e,3,40)*.6+ji(n*6,t*90,e+1,6,90)*.4}Ce("brick",Mo({seed:11,base:[.46,.45,.43],var:.3,mortar:[.2,.19,.18]}));Ce("brick_mossy",Mo({seed:11,base:[.44,.44,.4],var:.3,mortar:[.18,.2,.15],moss:1}));Ce("brick_cracked",Mo({seed:12,base:[.43,.42,.41],var:.35,mortar:[.19,.18,.17],crack:4}));Ce("flagstone",Wr({seed:21,n:3,base:[.42,.4,.37],grout:[.13,.12,.11],var:.3}));Ce("cobble",Wr({seed:23,n:6,base:[.47,.46,.44],grout:[.14,.13,.12],var:.45,dome:.35,soft:.2}));Ce("slate",(n,t,e)=>{let[i,s,r]=ei(n,t,31,2,.6),a=de(n,t,32,8,5),o=pe(.01,.06,s-i),c=.85+se(r,1,31)*.3+(a-.5)*.3;e.r=.2*c*(.6+.4*o),e.g=.21*c*(.6+.4*o),e.b=.24*c*(.6+.4*o),e.h=.3+o*.4+a*.3,e.ro=.75+a*.2});function Sd(n,t,e,i){let s=de(n,t,i,4,6),[r,a]=ei(n,t,i+3,5,1),o=1-pe(0,.05,a-r),c=.7+s*.6;e.r=.42*c,e.g=.38*c,e.b=.34*c,e.r*=1-o*.5,e.g*=1-o*.5,e.b*=1-o*.5,e.h=s*.8-o*.4+de(n,t,i+9,16,2)*.2,e.ro=.88}Ce("stone",(n,t,e)=>Sd(n,t,e,41));Ce("stone_ore",(n,t,e)=>{Sd(n,t,e,43);let[i,,s]=ei(n,t,45,7,.9);if(se(s,9,45)<.35&&i<.2){let a=pe(.2,.1,i);Hi(e,[.95,.72,.25],a),e.h+=a*.3,e.ro=re(e.ro,.25,a)}});Ce("dirt",(n,t,e)=>{let i=de(n,t,51,6,5),s=.65+i*.7;e.r=.34*s,e.g=.25*s,e.b=.17*s,e.h=i*.6,e.ro=.97;let[r,,a]=ei(n,t,53,10,1);if(r<.22&&se(a,2,53)<.5){let o=pe(.22,.12,r);Hi(e,[.45*(.8+se(a,5,1)*.4),.42,.38],o),e.h+=o*.35}});Ce("gravel",Wr({seed:61,n:12,base:[.4,.38,.36],grout:[.14,.13,.12],var:.6,dome:.5,soft:.25,jit:1}));Ce("planks",(n,t,e,i,s)=>{let r=Math.floor(s/16),a=s-r*16,o=Math.floor(se(r,1,71)*Qt),c=Math.min(Math.abs(i-o),Qt-Math.abs(i-o)),l=Mp(n+r*.37,t,71+r),h=(.8+se(r,2,71)*.35)*(.7+l*.6);e.r=.46*h,e.g=.31*h,e.b=.18*h;let u=Math.min(a+.5,16-a-.5,c+.5),d=pe(.4,1.6,u);e.r*=.35+.65*d,e.g*=.35+.65*d,e.b*=.35+.65*d,e.h=.2+d*.5+l*.2,e.ro=.8;let f=(o+3)%Qt,p=(o-4+Qt)%Qt;(i===f||i===p)&&(a===4||a===11)&&(e.r=e.g=e.b=.12,e.ro=.4,e.h=.8)});Ce("log_side",(n,t,e)=>{let i=ji(n*14,t*3,81,14,3)*.7+ji(n*28,t*6,82,28,6)*.3,s=Math.pow(Math.abs(i*2-1),.6),r=.55+s*.6;e.r=.3*r,e.g=.21*r,e.b=.13*r,e.h=s*.8,e.ro=.95});Ce("log_top",(n,t,e)=>{let i=n-.5,s=t-.5,r=Math.sqrt(i*i+s*s),a=de(n,t,91,4,3),o=.5+.5*Math.sin((r+a*.05)*90),c=.75+o*.3;if(e.r=.55*c,e.g=.4*c,e.b=.24*c,e.h=o*.3,e.ro=.85,r>.42){let l=pe(.42,.46,r);Hi(e,[.2,.14,.09],l),e.h=.2+l*.4}});Ce("darkbrick",Mo({seed:101,base:[.3,.2,.17],var:.35,mortar:[.08,.06,.06],crack:2}));Ce("basalt",Wr({seed:111,n:4,base:[.19,.18,.18],grout:[.05,.05,.05],var:.3,soft:.08,rough:.9}));Ce("basalt_glow",(n,t,e)=>{let[i,s,r]=ei(n,t,121,4,.8),a=de(n,t,122,8,4),o=s-i+(a-.5)*.05,c=.8+se(r,1,121)*.4;e.r=.17*c,e.g=.15*c,e.b=.14*c,e.h=.2+pe(0,.1,o)*.6+a*.2,e.ro=.9;let l=pe(.06,0,o)*(.6+.4*a);l>0&&(Hi(e,[1,.45,.1],l),e.er=1*l,e.eg=.32*l,e.eb=.04*l,e.h-=l*.3)});Ce("obsidian",(n,t,e)=>{let i=de(n,t,131,3,6),s=Math.pow(1-Math.abs(i*2-1),6),[r]=ei(n,t,133,3,1);e.r=.06+s*.12,e.g=.045+s*.05,e.b=.09+s*.16,e.h=r*.35+s*.1,e.ro=.38+(1-s)*.2});Ce("polished",(n,t,e,i,s)=>{let r=Math.floor(i/32),a=Math.floor(s/32),o=(r+a)%2===0,c=de(n,t,141+(o?0:5),3,6),l=Math.pow(1-Math.abs(c*2-1),10),h=o?[.14,.13,.16]:[.46,.44,.41],u=o?[.4,.38,.42]:[.2,.19,.2];e.r=h[0],e.g=h[1],e.b=h[2],Hi(e,u,l*.8);let d=i%32,f=s%32,p=Math.min(d+.5,32-d-.5,f+.5,32-f-.5),x=pe(.4,1.4,p);e.r*=.4+.6*x,e.g*=.4+.6*x,e.b*=.4+.6*x,e.h=.3+x*.5,e.ro=re(.9,.28,x)});Ce("bone_wall",(n,t,e)=>{let[i,s,r]=ei(n,t,151,5,.9),a=de(n,t,152,8,3),o=pe(0,.18,s-i),c=se(r,4,151)<.25,l=.75+se(r,2,151)*.3+a*.2;if(e.r=.72*l*(.3+.7*o),e.g=.66*l*(.3+.7*o),e.b=.54*l*(.3+.7*o),e.h=o*.6+(1-i*1.6)*.3,e.ro=.8,c&&i<.3){let h=se(r,8,151)*.1,[u]=ei(n+.03,t+h*.1,151,5,.9);Math.abs(u-i)<.02&&i>.06&&i<.16&&(e.r*=.2,e.g*=.2,e.b*=.2,e.h-=.3)}});Ce("ice",(n,t,e)=>{let i=de(n,t,161,3,5),[s,r]=ei(n,t,163,3,1),a=pe(.025,0,r-s),o=de(n,t,165,2,3);e.r=.42+i*.12+o*.08,e.g=.6+i*.12+o*.06,e.b=.74+i*.1,Hi(e,[.92,.97,1],a*.7),(se(Math.floor(n*64),Math.floor(t*64),167)<.012||!1)&&Hi(e,[.9,.96,1],.6),e.h=.55-a*.35+i*.08,e.ro=.05+a*.25+i*.05});Ce("snow",(n,t,e)=>{let i=de(n,t,171,6,5),s=de(n,t,172,24,2),r=.86+i*.1+s*.05;e.r=r*.94,e.g=r*.97,e.b=r,e.h=i*.6+s*.2,e.ro=.92-s*.2,se(Math.floor(n*64),Math.floor(t*64),173)<.03&&(e.ro=.2,e.r=e.g=e.b=1)});Ce("icewall",Wr({seed:181,n:3,base:[.46,.64,.78],grout:[.24,.36,.48],var:.25,soft:.1,rough:.12,dome:.3}));Ce("frost",(n,t,e)=>{Sd(n,t,e,191),e.r=e.r*.7+.08,e.g=e.g*.8+.12,e.b=e.b*.95+.2;let i=pe(.55,.7,de(n,t,193,4,4));Hi(e,[.85,.92,.98],i),e.ro=re(e.ro,.3,i)});Ce("mud",(n,t,e)=>{let i=de(n,t,201,5,5),s=de(n,t,202,20,2),r=.6+i*.7;e.r=.2*r,e.g=.15*r,e.b=.1*r;let a=pe(.5,.62,de(n,t,203,3,3));e.r*=1-a*.35,e.g*=1-a*.3,e.b*=1-a*.25,e.h=i*.5+s*.2-a*.2,e.ro=re(.9,.18,a);let[o,,c]=ei(n,t,205,9,1);if(o<.16&&se(c,3,205)<.4){let l=pe(.16,.08,o);Hi(e,[.32,.3,.26],l),e.h+=l*.4,e.ro=re(e.ro,.8,l)}});Ce("mossstone",(n,t,e)=>{Wr({seed:211,n:5,base:[.36,.38,.33],grout:[.1,.12,.08],var:.4,dome:.35,soft:.2})(n,t,e);let i=pe(.52,.62,de(n,t,213,4,5));if(i>0){let s=de(n,t,214,16,3);Hi(e,[.14+s*.1,.26+s*.14,.06],i),e.h+=i*.15,e.ro=re(e.ro,1,i)}});Ce("swampwall",Mo({seed:221,base:[.3,.34,.27],var:.35,mortar:[.1,.12,.08],moss:2,crack:2}));Ce("voidtile",(n,t,e,i,s)=>{let r=de(n,t,231,3,5);e.r=.05+r*.04,e.g=.035+r*.03,e.b=.09+r*.06;let a=Math.min(i+.5,64-i-.5,s+.5,64-s-.5),o=pe(1.4,.3,a)*.6;o>0&&(e.er=.3*o,e.eg=.12*o,e.eb=.6*o,Hi(e,[.45,.28,.8],o)),se(i,s,233)<.006&&(e.er=e.eg=e.eb=.9),e.h=.5-o*.3,e.ro=.08+r*.05});Ce("voidcrystal",(n,t,e)=>{let[i,s,r]=ei(n,t,241,4,.9),a=de(n,t,242,6,3),o=pe(0,.06,s-i),c=.7+se(r,1,241)*.5;e.r=.2*c,e.g=.1*c,e.b=.36*c;let l=pe(.035,0,s-i)*pe(.4,.6,a);l>0&&(e.er=.7*l,e.eg=.3*l,e.eb=1*l,Hi(e,[.75,.45,1],l)),e.h=o*.5+(1-i)*.3,e.ro=.12+(1-o)*.25});function B_(n){let t=Qt*Qt,e=new Float32Array(t*3),i=new Float32Array(t),s=new Float32Array(t),r=new Float32Array(t*3),a={};for(let l=0;l<Qt;l++)for(let h=0;h<Qt;h++){a.r=a.g=a.b=.5,a.h=.5,a.ro=.9,a.er=a.eg=a.eb=0,n((h+.5)/Qt,(l+.5)/Qt,a,h,l);let u=l*Qt+h;e[u*3]=a.r,e[u*3+1]=a.g,e[u*3+2]=a.b,i[u]=a.h,s[u]=a.ro,r[u*3]=a.er,r[u*3+1]=a.eg,r[u*3+2]=a.eb}let o=new Float32Array(t*3),c=2.4;for(let l=0;l<Qt;l++)for(let h=0;h<Qt;h++){let u=i[l*Qt+(h+Qt-1)%Qt],d=i[l*Qt+(h+1)%Qt],f=i[(l+Qt-1)%Qt*Qt+h],p=i[(l+1)%Qt*Qt+h],x=-(d-u)*c,m=(p-f)*c,g=1,_=Math.hypot(x,m,g);x/=_,m/=_,g/=_;let T=(l*Qt+h)*3;o[T]=x*.5+.5,o[T+1]=m*.5+.5,o[T+2]=g*.5+.5}return{alb:e,hgt:i,rou:s,emi:r,nor:o}}var Qc=null,Md=null;function Sp(){return Md||(Md=ih.map(n=>B_(n.gen))),Md}function fs(n,t,e){let i=document.createElement("canvas");i.width=n,i.height=t;let s=i.getContext("2d"),r=s.createImageData(n,t);return e(r.data),s.putImageData(r,0,0),i}function wp(){if(Qc)return Qc;let n=Sp(),t=Math.ceil(ih.length/Vr),e=Vr*ds,i=t*ds,s=(u,d)=>{let f=fs(e,i,x=>{for(let m=0;m<n.length;m++){let g=m%Vr*ds,_=Math.floor(m/Vr)*ds;for(let T=0;T<ds;T++)for(let v=0;v<ds;v++){let S=((v-bo)%Qt+Qt)%Qt,M=((T-bo)%Qt+Qt)%Qt,A=u(n[m],M*Qt+S),y=((_+T)*e+g+v)*4;x[y]=Je(A[0],0,1)*255,x[y+1]=Je(A[1],0,1)*255,x[y+2]=Je(A[2],0,1)*255,x[y+3]=255}}}),p=new ui(f);return p.colorSpace=d?Oe:Ki,p.anisotropy=8,p.minFilter=Oi,p.magFilter=Ye,p},r=[0,0,0],a=s((u,d)=>(r[0]=u.alb[d*3],r[1]=u.alb[d*3+1],r[2]=u.alb[d*3+2],r),!0),o=s((u,d)=>(r[0]=u.nor[d*3],r[1]=u.nor[d*3+1],r[2]=u.nor[d*3+2],r),!1),c=s((u,d)=>(r[0]=r[1]=r[2]=u.rou[d],r),!1),l=s((u,d)=>(r[0]=u.emi[d*3],r[1]=u.emi[d*3+1],r[2]=u.emi[d*3+2],r),!0);return Qc={map:a,normalMap:o,roughnessMap:c,emissiveMap:l,uv:u=>{let d=u%Vr*ds+bo,f=Math.floor(u/Vr)*ds+bo,p=.5;return[(d+p)/e,1-(f+Qt-p)/i,(d+Qt-p)/e,1-(f+p)/i]}},Qc}var th={};function ps(n,t=1){let e=n+":"+t;if(th[e])return th[e];let i=Sp()[nh[n]],s=(r,a,o)=>{let c=fs(Qt,Qt,h=>{for(let u=0;u<Qt*Qt;u++)o?h[u*4]=h[u*4+1]=h[u*4+2]=Je(r[u],0,1)*255:(h[u*4]=Je(r[u*3],0,1)*255,h[u*4+1]=Je(r[u*3+1],0,1)*255,h[u*4+2]=Je(r[u*3+2],0,1)*255),h[u*4+3]=255}),l=new ui(c);return l.wrapS=l.wrapT=Nn,l.repeat.set(t,t),l.colorSpace=a?Oe:Ki,l.anisotropy=4,l};return th[e]={map:s(i.alb,!0),normalMap:s(i.nor,!1),roughnessMap:s(i.rou,!1,!0)},th[e]}var eh={},_p={steel:{base:[.58,.6,.63],var:.18,sc:6,scratch:!0,hammer:!0},steel_dark:{base:[.26,.27,.3],var:.2,sc:6,scratch:!0,hammer:!0},gold:{base:[.88,.68,.3],var:.16,sc:6,scratch:!0},iron:{base:[.24,.23,.23],var:.3,sc:8,rust:!0,hammer:!0},chain:{base:[.5,.52,.55],var:.15,sc:8,rings:!0},cloth_blue:{base:[.1,.18,.4],var:.22,sc:16,weave:!0},cloth_red:{base:[.48,.07,.06],var:.22,sc:16,weave:!0},cloth_green:{base:[.13,.26,.15],var:.22,sc:16,weave:!0},cloth_purple:{base:[.24,.09,.32],var:.28,sc:16,weave:!0},cloth_white:{base:[.72,.68,.6],var:.18,sc:16,weave:!0},cloth_brown:{base:[.3,.2,.12],var:.25,sc:16,weave:!0},leather:{base:[.36,.22,.12],var:.3,sc:8,leather:!0},leather_dark:{base:[.16,.11,.08],var:.3,sc:8,leather:!0},skin:{base:[.78,.56,.44],var:.1,sc:6,skin:!0},skin_dark:{base:[.46,.3,.22],var:.1,sc:6,skin:!0},skin_pale:{base:[.66,.66,.6],var:.16,sc:5,veins:[.32,.36,.42],skin:!0},skin_drowned:{base:[.36,.44,.4],var:.22,sc:5,veins:[.14,.2,.18],skin:!0},rags:{base:[.3,.26,.2],var:.5,sc:10,weave:!0,holes:!0},bone:{base:[.82,.78,.66],var:.18,sc:8,pores:!0},robe:{base:[.1,.09,.12],var:.25,sc:12,weave:!0},hair:{base:[.14,.09,.05],var:.4,sc:24,fiber:!0},hair_grey:{base:[.45,.43,.4],var:.3,sc:24,fiber:!0},wood:{base:[.42,.28,.16],var:.3,sc:4,grain:!0},plant:{base:[.2,.3,.13],var:.3,sc:6,fiber:!0},plant_dark:{base:[.12,.16,.08],var:.3,sc:6,fiber:!0},petal:{base:[.5,.1,.18],var:.25,sc:6,veins:[.8,.3,.35]},scales:{base:[.22,.27,.2],var:.25,sc:6,scales:!0},scales_red:{base:[.35,.12,.1],var:.25,sc:6,scales:!0},fur:{base:[.34,.29,.24],var:.3,sc:28,fiber:!0},fur_white:{base:[.82,.86,.9],var:.18,sc:28,fiber:!0},cloth_ice:{base:[.66,.78,.88],var:.16,sc:16,weave:!0},hide:{base:[.2,.2,.24],var:.25,sc:6,leather:!0},belly:{base:[.56,.46,.4],var:.3,sc:5,blotch:[.42,.26,.28],skin:!0,stitches:!0},porcelain:{base:[.9,.88,.84],var:.04,sc:4,porcelain:!0},ice:{base:[.62,.82,.92],var:.14,sc:5,cracksLight:!0},crystal_void:{base:[.16,.1,.3],var:.25,sc:4,veinGlow:[.65,.3,1]},carapace:{base:[.13,.11,.15],var:.25,sc:4,plates:!0},carapace_ice:{base:[.5,.66,.78],var:.2,sc:4,plates:!0},chitin:{base:[.3,.24,.2],var:.3,sc:5,plates:!0},obsidian:{base:[.08,.06,.1],var:.3,sc:4,lava:!0},moth:{base:[.5,.44,.36],var:.3,sc:24,fiber:!0},jelly:{base:[.55,.8,.5],var:.2,sc:5,veins:[.8,1,.6]}};function sh(n){if(eh[n])return eh[n];let t=_p[n]||_p.steel,e=128,i=n.length*97+n.charCodeAt(0)*7+n.charCodeAt(n.length-1),s=new Float32Array(e*e),r=new Float32Array(e*e*3),a=new Float32Array(e*e),o=!1,c=t.scratch?bp(i,5):null,l=fs(e,e,g=>{for(let _=0;_<e;_++)for(let T=0;T<e;T++){let v=(T+.5)/e,S=(_+.5)/e,M=_*e+T,A=de(v,S,i,t.sc,4);t.grain&&(A=Mp(v,S,i)),t.fiber&&(A=ji(v*t.sc,S*t.sc*.25,i,t.sc,t.sc*.25)*.6+de(v,S,i+1,t.sc,2)*.4);let y=1+(A-.5)*t.var*2,E=t.base[0]*y,P=t.base[1]*y,N=t.base[2]*y,F=.8,B=A*.5;if(t.weave){let I=((T+_)%4<2?1:.88)*((T-_+256)%4<2?1:.93);E*=I,P*=I,N*=I,F=.95,B=I*.6}if(t.hammer){let[I]=ei(v,S,i+2,7,1);B=.5+I*.35}if(t.scratch){F=.26+A*.18;let I=c[M%4096]||0;I>0&&(E*=1+I*.3,P*=1+I*.3,N*=1+I*.3,B-=I*.2)}if(t.rings){let I=(T+Math.floor(_/6)%2*3)%6-2.5,H=_%6-2.5,W=Math.hypot(I,H),U=pe(1.4,2,W)*pe(3.2,2.5,W),X=.35+U*.75;E*=X,P*=X,N*=X,B=U,F=.35+(1-U)*.4}if(t.leather){let I=de(v,S,i+3,24,2);B=A*.4+I*.3,F=.62+I*.2}if(t.skin&&(F=.55+A*.1,B=A*.2+de(v,S,i+9,32,2)*.1),t.rust){let I=pe(.55,.7,de(v,S,i+4,4,4));E=re(E,.4,I),P=re(P,.2,I),N=re(N,.1,I),F=.45+I*.45}if(t.blotch){let I=pe(.58,.7,de(v,S,i+6,4,4));E=re(E,t.blotch[0],I),P=re(P,t.blotch[1],I),N=re(N,t.blotch[2],I)}if(t.stitches){let I=Math.abs(_-e*.5);I<1.5&&(E*=.35,P*=.3,N*=.3,B-=.3),I<5&&T%10<2&&(E=.1,P=.08,N=.07,B+=.2)}if(t.veins){let[I,H]=ei(v,S,i+7,4,1),W=pe(.04,0,H-I)*pe(.3,.6,de(v,S,i+8,6,3));E=re(E,t.veins[0],W),P=re(P,t.veins[1],W),N=re(N,t.veins[2],W),B+=W*.2}if(t.holes&&de(v,S,i+8,6,3)>.7&&(E*=.3,P*=.3,N*=.3),t.pores&&(se(T,_,i)<.05&&(E*=.7,P*=.7,N*=.7,B-=.2),F=.7),t.plates){let[I,H]=ei(v,S,i,3,.7),W=pe(0,.08,H-I);E=E*(.4+.6*W)+(1-I)*.05,P*=.4+.6*W,N*=.4+.6*W,F=.22+(1-W)*.4,B=W*.8+(1-I)*.2}if(t.scales){let I=Math.floor(_/8),H=T+I%2*4,W=Math.floor(H/8)*8+4-I%2*4,U=I*8,X=Math.hypot(T-W,(_-U)*1.2)/6.5,G=pe(1,.8,X),j=.55+G*.5+(1-X)*.2;E*=j,P*=j,N*=j,B=G*(1-X*.5),F=.35+(1-G)*.3}if(t.porcelain){F=.12,B=.5;let I=0}if(t.cracksLight){let[I,H]=ei(v,S,i+3,5,1),W=pe(.03,0,H-I);E=re(E,.95,W*.6),P=re(P,1,W*.6),N=re(N,1,W*.6),F=.06+W*.2,B=.5-W*.3}if(t.spots){let[I,,H]=ei(v,S,i,5,1);if(I<.25&&se(H,1,i)<.6){let W=pe(.25,.18,I);E=re(E,t.spots[0],W),P=re(P,t.spots[1],W),N=re(N,t.spots[2],W)}}if(t.lava||t.veinGlow){let I=t.veinGlow||[1,.4,.05],[H,W]=ei(v,S,i,4,.9),U=pe(.035,0,W-H);F=.18+(1-U)*.2,U>0&&(o=!0,E=re(E,I[0],U),P=re(P,I[1],U),N=re(N,I[2],U),r[M*3]=U*I[0],r[M*3+1]=U*I[1]*.9,r[M*3+2]=U*I[2],B-=U*.3)}s[M]=F,a[M]=B,g[M*4]=Je(E,0,1)*255,g[M*4+1]=Je(P,0,1)*255,g[M*4+2]=Je(N,0,1)*255,g[M*4+3]=255}}),h=g=>(g.wrapS=g.wrapT=Nn,g.anisotropy=4,g),u=h(new ui(l));u.colorSpace=Oe;let d=fs(e,e,g=>{for(let _=0;_<e*e;_++)g[_*4]=g[_*4+1]=g[_*4+2]=Je(s[_],0,1)*255,g[_*4+3]=255}),f=h(new ui(d)),p=fs(e,e,g=>{for(let T=0;T<e;T++)for(let v=0;v<e;v++){let S=(a[T*e+(v+1)%e]-a[T*e+(v+e-1)%e])*3,M=(a[(T+1)%e*e+v]-a[(T+e-1)%e*e+v])*3,A=Math.hypot(S,M,1),y=(T*e+v)*4;g[y]=(-S/A*.5+.5)*255,g[y+1]=(M/A*.5+.5)*255,g[y+2]=(1/A*.5+.5)*255,g[y+3]=255}}),x=h(new ui(p)),m=null;if(o){let g=fs(e,e,_=>{for(let T=0;T<e*e;T++)_[T*4]=Je(r[T*3],0,1)*255,_[T*4+1]=Je(r[T*3+1],0,1)*255,_[T*4+2]=Je(r[T*3+2],0,1)*255,_[T*4+3]=255});m=h(new ui(g)),m.colorSpace=Oe}return eh[n]={map:u,roughnessMap:f,normalMap:x,emissiveMap:m},eh[n]}var Tp=(n,t)=>So(128,128,(e,i,s)=>{e.clearRect(0,0,i,s),e.fillStyle=n,e.beginPath(),e.moveTo(4,64),e.bezierCurveTo(20,4,110,0,124,30),e.bezierCurveTo(128,70,90,120,40,110),e.bezierCurveTo(20,104,6,84,4,64),e.fill();for(let c=0;c<900;c++)e.fillStyle=`rgba(${Math.random()<.5?"0,0,0":"255,240,220"},${Math.random()*.08})`,e.fillRect(Math.random()*i,Math.random()*s,2,2);e.strokeStyle="rgba(40,30,20,0.5)",e.lineWidth=1.2;for(let c=0;c<6;c++)e.beginPath(),e.moveTo(6,64),e.quadraticCurveTo(50,40+c*8,120-c*6,20+c*16),e.stroke();let r=80,a=58,o=e.createRadialGradient(r,a,2,r,a,20);o.addColorStop(0,"#111"),o.addColorStop(.3,t),o.addColorStop(.55,"#f4e6c8"),o.addColorStop(.7,"#2a1a10"),o.addColorStop(1,"rgba(0,0,0,0)"),e.globalCompositeOperation="source-atop",e.fillStyle=o,e.beginPath(),e.arc(r,a,20,0,Math.PI*2),e.fill(),e.globalCompositeOperation="source-over"});function Ep(){let t=fs(128,128,i=>{for(let s=0;s<128;s++)for(let r=0;r<128;r++){let a=r/128,o=s/128,c=de(a,o,201,4,5),[l,h]=ei(a,o,203,5,1),d=1-pe(.02,.2,h-l)*pe(.35,.65,c),f=re(.1,1,d),p=re(.02,.22+.4*d*d,d),x=re(.01,.02+.12*Math.pow(d,4),d),m=(s*128+r)*4;i[m]=f*255,i[m+1]=p*255,i[m+2]=x*255,i[m+3]=255}}),e=new ui(t);return e.colorSpace=Oe,e.wrapS=e.wrapT=Nn,e}function Ap(){let t=new Float32Array(16384);for(let s=0;s<128;s++)for(let r=0;r<128;r++)t[s*128+r]=de(r/128,s/128,301,4,5);let e=fs(128,128,s=>{for(let r=0;r<128;r++)for(let a=0;a<128;a++){let o=(t[r*128+(a+1)%128]-t[r*128+(a+128-1)%128])*6,c=(t[(r+1)%128*128+a]-t[(r+128-1)%128*128+a])*6,l=Math.hypot(o,c,1),h=(r*128+a)*4;s[h]=(-o/l*.5+.5)*255,s[h+1]=(c/l*.5+.5)*255,s[h+2]=(1/l*.5+.5)*255,s[h+3]=255}}),i=new ui(e);return i.wrapS=i.wrapT=Nn,i}function So(n,t,e){let i=document.createElement("canvas");i.width=n,i.height=t,e(i.getContext("2d"),n,t);let s=new ui(i);return s.colorSpace=Oe,s}var Rp=()=>So(64,64,(n,t)=>{let e=n.createRadialGradient(t/2,t/2,0,t/2,t/2,t/2);e.addColorStop(0,"rgba(255,255,255,1)"),e.addColorStop(.35,"rgba(255,255,255,0.6)"),e.addColorStop(1,"rgba(255,255,255,0)"),n.fillStyle=e,n.fillRect(0,0,t,t)}),Cp=()=>So(128,128,n=>{n.strokeStyle="rgba(230,230,235,0.55)",n.lineWidth=1;let t=0,e=0;for(let i=0;i<=8;i++){let s=i/8*Math.PI/2;n.beginPath(),n.moveTo(t,e),n.lineTo(Math.cos(s)*128,Math.sin(s)*128),n.stroke()}for(let i=12;i<128;i+=11+i*.08){n.beginPath();for(let s=0;s<=8;s++){let r=s/8*Math.PI/2,a=i*(.92+.08*Math.sin(s*3+i)),o=Math.cos(r)*a,c=Math.sin(r)*a;s?n.lineTo(o,c):n.moveTo(o,c)}n.stroke()}}),Pp=()=>So(128,128,(n,t)=>{let e=n.createRadialGradient(t/2,t/2,0,t/2,t/2,t/2);e.addColorStop(0,"rgba(255,255,255,0.15)"),e.addColorStop(.82,"rgba(255,255,255,0.35)"),e.addColorStop(.92,"rgba(255,255,255,1)"),e.addColorStop(1,"rgba(255,255,255,0)"),n.fillStyle=e,n.fillRect(0,0,t,t)}),Ip=(n,t)=>So(64,128,(e,i,s)=>{e.fillStyle=n,e.fillRect(0,0,i,s);for(let r=0;r<400;r++)e.fillStyle=`rgba(0,0,0,${Math.random()*.12})`,e.fillRect(Math.random()*i,Math.random()*s,2,2);e.fillStyle="rgba(210,170,70,0.9)",e.fillRect(4,4,i-8,3),e.fillRect(4,s-26,i-8,3),e.save(),e.translate(i/2,s*.42),e.fillStyle="rgba(215,180,80,0.95)",t===0?(e.beginPath(),e.moveTo(0,-18),e.lineTo(14,0),e.lineTo(0,18),e.lineTo(-14,0),e.closePath(),e.fill(),e.fillStyle=n,e.fillRect(-3,-8,6,16)):t===1?(e.beginPath(),e.arc(0,0,14,0,Math.PI*2),e.fill(),e.fillStyle=n,e.beginPath(),e.arc(4,-3,11,0,Math.PI*2),e.fill()):(e.fillRect(-2,-20,4,34),e.fillRect(-12,-10,24,4)),e.restore(),e.clearRect(0,s-20,i,20),e.fillStyle=n;for(let r=0;r<i;r+=8)e.beginPath(),e.moveTo(r,s-21),e.lineTo(r+8,s-21),e.lineTo(r+4,s-4-Math.random()*8),e.fill()});var ci={tMirror:{value:null},uMirrorMat:{value:new me},uMirrorOn:{value:0},uPlaneY:{value:0},uWet:{value:.35},uGloss:{value:0},uTime:{value:0},uRes:{value:new ot(1,1)}},H_=`
float mh(vec2 p){ return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float mn(vec2 p){ vec2 i = floor(p), f = fract(p); f = f * f * (3.0 - 2.0 * f);
  return mix(mix(mh(i), mh(i + vec2(1, 0)), f.x), mix(mh(i + vec2(0, 1)), mh(i + vec2(1, 1)), f.x), f.y); }
float puddle(vec2 p){ return mn(p * 0.23) * 0.62 + mn(p * 0.71 + 7.3) * 0.28 + mn(p * 2.3) * 0.1; }
`;function wd(n,t={}){let e=!!t.water;return n.onBeforeCompile=i=>{Object.assign(i.uniforms,ci),i.vertexShader=i.vertexShader.replace("#include <common>",`#include <common>
varying vec3 vWPos; varying vec3 vWNor;`).replace("#include <project_vertex>",`#include <project_vertex>
vWPos = (modelMatrix * vec4(transformed, 1.0)).xyz; vWNor = normalize(mat3(modelMatrix) * objectNormal);`),i.fragmentShader=i.fragmentShader.replace("#include <common>",`#include <common>
varying vec3 vWPos; varying vec3 vWNor;
uniform sampler2D tMirror; uniform mat4 uMirrorMat; uniform float uMirrorOn, uPlaneY, uWet, uGloss, uTime;
${H_}`).replace("#include <roughnessmap_fragment>",`#include <roughnessmap_fragment>
float mTop = smoothstep(0.8, 0.95, vWNor.y) * (1.0 - smoothstep(0.03, 0.14, abs(vWPos.y - uPlaneY)));
float mWet = ${e?"1.0":"mTop * smoothstep(1.0 - uWet, 1.0 - uWet + 0.07, puddle(vWPos.xz))"};
float mGloss = ${e?"1.0":"mTop * uGloss"};
roughnessFactor = mix(roughnessFactor, ${e?"0.04":"0.05"}, max(mWet, mGloss * 0.85));`).replace("#include <lights_fragment_end>",`#include <lights_fragment_end>
{
  float mStr = max(mWet, mGloss) * uMirrorOn;
  if (mStr > 0.001) {
    vec4 mp = uMirrorMat * vec4(vWPos, 1.0);
    vec2 ripple = ${e?"vec2(mn(vWPos.xz * 3.0 + uTime * 0.8) - 0.5, mn(vWPos.zx * 3.0 - uTime * 0.7) - 0.5) * 0.035":"vec2(mn(vWPos.xz * 6.0 + uTime * 0.3) - 0.5, mn(vWPos.zx * 6.0) - 0.5) * 0.006 * mWet"};
    vec2 muv = mp.xy / mp.w + normal.xy * ${e?"0.02":"0.012"} + ripple;
    float lod = mix(4.5, 0.0, max(mWet, mGloss * (1.0 - roughnessFactor)));
    vec4 rs = textureLod(tMirror, clamp(muv, 0.001, 0.999), lod);
    vec3 refl = rs.rgb / max(rs.a, 0.001);
    vec3 vd = normalize(vViewPosition);
    float fr = 0.04 + 0.96 * pow(1.0 - clamp(dot(normal, vd), 0.0, 1.0), 5.0);
    float k = mStr * mix(${e?"0.55":"0.42"}, 1.0, fr) * smoothstep(0.0, 0.6, rs.a);
    reflectedLight.indirectSpecular = mix(reflectedLight.indirectSpecular, refl, k);
    reflectedLight.directDiffuse *= 1.0 - mWet * ${e?"0.0":"0.45"};
    reflectedLight.indirectDiffuse *= 1.0 - mWet * ${e?"0.0":"0.5"};
  }
}`)},n.customProgramCacheKey=()=>e?"mirror-water":"mirror-floor",n.needsUpdate=!0,n}var rh=class{constructor(t){this.renderer=t,this.cam=new ni,this.cam.layers.set(0),this.rt=null,this.scale=.5,this.enabled=!1,this._v=new D,this._t=new D,this._q=new Le,this._p=new Si,this._c=new Le}setup(t,e){this.enabled=t,this.scale=e,ci.uMirrorOn.value=t?1:0,this.resize()}resize(){if(!this.enabled){this.rt&&(this.rt.dispose(),this.rt=null),ci.tMirror.value=null;return}let t=this.renderer.getPixelRatio(),e=Math.max(64,Math.round(innerWidth*t*this.scale)),i=Math.max(64,Math.round(innerHeight*t*this.scale));this.rt&&this.rt.width===e&&this.rt.height===i||(this.rt&&this.rt.dispose(),this.rt=new ke(e,i,{type:qe,generateMipmaps:!0,minFilter:Oi,magFilter:Ye,samples:0}),ci.tMirror.value=this.rt.texture)}render(t,e,i=0){if(!this.enabled||!this.rt)return;let s=this.renderer,r=this.cam;e.updateMatrixWorld();let a=this._v.setFromMatrixPosition(e.matrixWorld),o=this._t.set(0,0,-1).applyMatrix3(new ie().setFromMatrix4(e.matrixWorld)).add(a);r.position.set(a.x,2*i-a.y,a.z),r.up.set(0,1,0).applyQuaternion(e.quaternion),r.up.y=-r.up.y,r.lookAt(o.x,2*i-o.y,o.z),r.far=e.far,r.near=e.near,r.updateMatrixWorld(),r.projectionMatrix.copy(e.projectionMatrix),ci.uMirrorMat.value.set(.5,0,0,.5,0,.5,0,.5,0,0,.5,.5,0,0,0,1).multiply(r.projectionMatrix).multiply(r.matrixWorldInverse),ci.uPlaneY.value=i;let c=this._p.setFromNormalAndCoplanarPoint(new D(0,1,0),new D(0,i+.02,0));c.applyMatrix4(r.matrixWorldInverse);let l=this._c.set(c.normal.x,c.normal.y,c.normal.z,c.constant),h=r.projectionMatrix,u=this._q;u.x=(Math.sign(l.x)+h.elements[8])/h.elements[0],u.y=(Math.sign(l.y)+h.elements[9])/h.elements[5],u.z=-1,u.w=(1+h.elements[10])/h.elements[14],l.multiplyScalar(2/l.dot(u)),h.elements[2]=l.x,h.elements[6]=l.y,h.elements[10]=l.z+1,h.elements[14]=l.w;let d=ci.uMirrorOn.value;ci.uMirrorOn.value=0,ci.tMirror.value=null;let f=t.background,p=s.getClearColor(new Nt),x=s.getClearAlpha();t.background=null,s.setClearColor(0,0),s.setRenderTarget(this.rt),s.clear(),s.render(t,r),s.setRenderTarget(null),s.setClearColor(p,x),t.background=f,ci.tMirror.value=this.rt.texture,ci.uMirrorOn.value=d}},ah=class{constructor(t,e=128){this.renderer=t,this.rt=new Fr(e,{type:qe,generateMipmaps:!0,minFilter:Oi}),this.cam=new Rr(.3,45,this.rt),this.cam.layers.set(0),this.every=4,this.n=0,this.enabled=!0}get texture(){return this.rt.texture}update(t,e,i,s,r){if(!this.enabled||this.n++%this.every)return;let a=r?r.visible:!0;r&&(r.visible=!1);let o=ci.uMirrorOn.value;ci.uMirrorOn.value=0,this.cam.position.set(e,i,s),this.cam.update(this.renderer,t),ci.uMirrorOn.value=o,r&&(r.visible=a)}};var On=5,oh=On+5,lh=16,G_=[{dir:[-1,0,0],c:[[0,1,0,0,1],[0,0,0,0,0],[0,1,1,1,1],[0,0,1,1,0]]},{dir:[1,0,0],c:[[1,1,1,0,1],[1,0,1,0,0],[1,1,0,1,1],[1,0,0,1,0]]},{dir:[0,1,0],c:[[0,1,1,1,1],[1,1,1,0,1],[0,1,0,1,0],[1,1,0,0,0]],top:!0},{dir:[0,0,-1],c:[[1,0,0,0,0],[0,0,0,1,0],[1,1,0,0,1],[0,1,0,1,1]]},{dir:[0,0,1],c:[[0,0,1,0,0],[1,0,1,1,0],[0,1,1,0,1],[1,1,1,1,1]]}],V_=[.34,.56,.78,1];function W_(n,t){let e=0;for(let[,i]of n)e+=i;t*=e;for(let[i,s]of n)if(t-=s,t<=0)return i;return n[0][0]}function Lp(n){let{W:t,D:e,cell:i,h:s,mat:r,thin:a,wallH:o,theme:c,seed:l}=n,h=new Uint8Array(t*e*oh),u=new Uint8Array(t*e*oh),d=(U,X,G)=>U+G*t+X*t*e,f=U=>nh[U]+1,p=(U,X,G,j,et)=>{let vt=d(U,X,G);h[vt]=j,u[vt]=et||j};for(let U=0;U<e;U++)for(let X=0;X<t;X++){let G=X+U*t,j=i[G],et=f(c.foundation);if(j===St.FLOOR){let vt=On-1+s[G],ht=f(r[G]);if(a[G]){p(X,vt,U,ht,ht);continue}for(let Ut=0;Ut<vt;Ut++)p(X,Ut,U,et);p(X,vt,U,s[G]>0?ht:et,ht)}else if(j===St.WATER||j===St.LAVA){let vt=j===St.LAVA?f("basalt"):f((c.themeKey==="minas","gravel"));for(let ht=0;ht<On-1;ht++)p(X,ht,U,et,vt)}else if(j===St.PIT)c.voidPits||p(X,0,U,et,f("gravel"));else if(j===St.WALL){let vt=On-1+o[G];for(let ht=0;ht<=vt;ht++){let Ut=ht<On-1?et:f(W_(c.walls,se(X*13+ht*7,U,l+3)));p(X,ht,U,Ut,ht===vt?f(c.cap):Ut)}}else if(j===St.PILLAR){let vt=On-1+s[G],ht=f(r[G]&&r[G]!==c.pillar?r[G]:c.floor[0][0]);for(let Ut=0;Ut<vt;Ut++)p(X,Ut,U,et);p(X,vt,U,s[G]>0?ht:et,ht)}}let x=(U,X,G)=>U<0||G<0||U>=t||G>=e||X>=oh?!1:X<0?!0:h[d(U,X,G)]!==0,m=(U,X)=>U<0||X<0||U>=t||X>=e||i[U+X*t]===St.VOID,g=(U,X,G,j)=>{let et=U*374761393+X*668265263+G*2147483647+j*1274126177|0;return et=(et^et>>>13)*1274126177,((et^et>>>16)>>>0)/4294967296-.5},_=c.hub?.1:.16,T=.22,v=(U,X,G,j)=>{let et=X>On+1;return j[0]=U+g(U,X,G,1)*_*(et?1.25:1),j[1]=X-On+(et?g(U,X,G,2)*T:0),j[2]=G+g(U,X,G,3)*_*(et?1.25:1),j},S=[0,0,0],M=wp(),A=new Ve({map:M.map,normalMap:M.normalMap,roughnessMap:M.roughnessMap,emissiveMap:M.emissiveMap,emissive:16777215,emissiveIntensity:1.6,vertexColors:!0,metalness:0,normalScale:new ot(1.1,1.1)});wd(A);let y=new xe;for(let U=0;U<e;U+=lh)for(let X=0;X<t;X+=lh){let G=[],j=[],et=[],vt=[];for(let $t=U;$t<Math.min(e,U+lh);$t++)for(let Kt=X;Kt<Math.min(t,X+lh);Kt++)for(let $=0;$<oh;$++){let rt=d(Kt,$,$t);if(h[rt])for(let _t of G_){let[Jt,At,Yt]=_t.dir;if(x(Kt+Jt,$+At,$t+Yt))continue;let fe=(_t.top?u[rt]:h[rt])-1,[at,ut,pt,mt]=M.uv(fe),w=.88+se(Kt*3+$,$t*5+$,l)*.18;!_t.top&&m(Kt+Jt,$t+Yt)&&(w*=.28),_t.top||(w*=.78+.22*Math.min(1,Math.max(0,($-On+1)/3)));let J=_t.dir[0]?0:_t.dir[1]?1:2,Q=(J+1)%3,st=(J+2)%3,nt=[],L=G.length/3;for(let yt of _t.c){let zt=[yt[0],yt[1],yt[2]],C=[Kt+Jt,$+At,$t+Yt],b=[0,0,0],O=[0,0,0];b[Q]=zt[Q]?1:-1,O[st]=zt[st]?1:-1;let V=x(C[0]+b[0],C[1]+b[1],C[2]+b[2])?1:0,K=x(C[0]+O[0],C[1]+O[1],C[2]+O[2])?1:0,gt=x(C[0]+b[0]+O[0],C[1]+b[1]+O[1],C[2]+b[2]+O[2])?1:0,xt=V&&K?0:3-(V+K+gt);nt.push(xt),v(Kt+yt[0],$+yt[1],$t+yt[2],O),G.push(O[0],O[1],O[2]),j.push(at+yt[3]*(pt-at),ut+yt[4]*(mt-ut));let it=V_[xt]*w;et.push(it,it,it)}nt[0]+nt[3]>nt[1]+nt[2]?vt.push(L,L+1,L+3,L,L+3,L+2):vt.push(L,L+1,L+2,L+2,L+1,L+3)}}if(!G.length)continue;let ht=new ge;ht.setAttribute("position",new qt(G,3)),ht.setAttribute("uv",new qt(j,2)),ht.setAttribute("color",new qt(et,3)),ht.setIndex(vt),ht.computeVertexNormals(),ht.computeBoundingSphere();let Ut=new Pt(ht,A);Ut.castShadow=!0,Ut.receiveShadow=!0,y.add(Ut)}let E=[],P=(U,X)=>{let G=[],j=[],et=[];for(let ht=0;ht<e;ht++)for(let Ut=0;Ut<t;Ut++){if(i[Ut+ht*t]!==U)continue;let $t=G.length/3,Kt=.22;G.push(Ut-Kt,X,ht+1+Kt,Ut+1+Kt,X,ht+1+Kt,Ut-Kt,X,ht-Kt,Ut+1+Kt,X,ht-Kt),j.push(Ut*.25,(ht+1)*.25,(Ut+1)*.25,(ht+1)*.25,Ut*.25,ht*.25,(Ut+1)*.25,ht*.25),et.push($t,$t+1,$t+2,$t+2,$t+1,$t+3)}if(!G.length)return null;let vt=new ge;return vt.setAttribute("position",new qt(G,3)),vt.setAttribute("uv",new qt(j,2)),vt.setIndex(et),vt.computeVertexNormals(),vt.computeBoundingSphere(),vt},N=null,F=null,B=P(St.LAVA,-.82);if(B){let U=Ep();N=new Ve({map:U,emissiveMap:U,emissive:16777215,emissiveIntensity:.95,roughness:.7});let X=new Pt(B,N);X.receiveShadow=!1,y.add(X),E.push(X)}let I=P(St.WATER,c.shallow?-.12:-.32);if(I){let U=Ap();U.repeat.set(.6,.6),F=new Ve({color:c.water||730152,roughness:.05,metalness:0,normalMap:U,normalScale:new ot(.35,.35)}),wd(F,{water:!0});let X=new Pt(I,F);X.receiveShadow=!0,y.add(X),E.push(X)}return{group:y,update:U=>{N&&(N.map.offset.set(Math.sin(U*.05)*.3,U*.02),N.emissiveIntensity=.95+Math.sin(U*1.3)*.12),F&&F.normalMap.offset.set(U*.02,U*.013)},dispose:()=>{y.traverse(U=>{U.geometry&&U.geometry.dispose()}),A.dispose(),N&&(N.map.dispose(),N.dispose()),F&&(F.normalMap.dispose(),F.dispose())},material:A}}function ch(n,t=!1){let e=n[0].index!==null,i=new Set(Object.keys(n[0].attributes)),s=new Set(Object.keys(n[0].morphAttributes)),r={},a={},o=n[0].morphTargetsRelative,c=new ge,l=0;for(let h=0;h<n.length;++h){let u=n[h],d=0;if(e!==(u.index!==null))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". All geometries must have compatible attributes; make sure index attribute exists among all geometries, or in none of them."),null;for(let f in u.attributes){if(!i.has(f))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+'. All geometries must have compatible attributes; make sure "'+f+'" attribute exists among all geometries, or in none of them.'),null;r[f]===void 0&&(r[f]=[]),r[f].push(u.attributes[f]),d++}if(d!==i.size)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". Make sure all geometries have the same number of attributes."),null;if(o!==u.morphTargetsRelative)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". .morphTargetsRelative must be consistent throughout all geometries."),null;for(let f in u.morphAttributes){if(!s.has(f))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+".  .morphAttributes must be consistent throughout all geometries."),null;a[f]===void 0&&(a[f]=[]),a[f].push(u.morphAttributes[f])}if(t){let f;if(e)f=u.index.count;else if(u.attributes.position!==void 0)f=u.attributes.position.count;else return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". The geometry must have either an index or a position attribute"),null;c.addGroup(l,f,h),l+=f}}if(e){let h=0,u=[];for(let d=0;d<n.length;++d){let f=n[d].index;for(let p=0;p<f.count;++p)u.push(f.getX(p)+h);h+=n[d].attributes.position.count}c.setIndex(u)}for(let h in r){let u=Dp(r[h]);if(!u)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed while trying to merge the "+h+" attribute."),null;c.setAttribute(h,u)}for(let h in a){let u=a[h][0].length;if(u!==0){c.morphAttributes=c.morphAttributes||{},c.morphAttributes[h]=[];for(let d=0;d<u;++d){let f=[];for(let x=0;x<a[h].length;++x)f.push(a[h][x][d]);let p=Dp(f);if(!p)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed while trying to merge the "+h+" morphAttribute."),null;c.morphAttributes[h].push(p)}}}return c}function Dp(n){let t,e,i,s=-1,r=0;for(let l=0;l<n.length;++l){let h=n[l];if(t===void 0&&(t=h.array.constructor),t!==h.array.constructor)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.array must be of consistent array types across matching attributes."),null;if(e===void 0&&(e=h.itemSize),e!==h.itemSize)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.itemSize must be consistent across matching attributes."),null;if(i===void 0&&(i=h.normalized),i!==h.normalized)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.normalized must be consistent across matching attributes."),null;if(s===-1&&(s=h.gpuType),s!==h.gpuType)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.gpuType must be consistent across matching attributes."),null;r+=h.count*e}let a=new t(r),o=new ti(a,e,i),c=0;for(let l=0;l<n.length;++l){let h=n[l];if(h.isInterleavedBufferAttribute){let u=c/e;for(let d=0,f=h.count;d<f;d++)for(let p=0;p<e;p++){let x=h.getComponent(d,p);o.setComponent(d+u,p,x)}}else a.set(h.array,c);c+=h.count*e}return s!==void 0&&(o.gpuType=s),o}var wo=new D;function Qi(n,t,e,i,s,r){let a=2*Math.PI*s/4,o=Math.max(r-2*s,0),c=Math.PI/4;wo.copy(t),wo[i]=0,wo.normalize();let l=.5*a/(a+o),h=1-wo.angleTo(n)/c;return Math.sign(wo[e])===1?h*l:o/(a+o)+l+l*(1-h)}var hh=class n extends $i{constructor(t=1,e=1,i=1,s=2,r=.1){let a=s*2+1;if(r=Math.min(t/2,e/2,i/2,r),super(1,1,1,a,a,a),this.type="RoundedBoxGeometry",this.parameters={width:t,height:e,depth:i,segments:s,radius:r},a===1)return;let o=this.toNonIndexed();this.index=null,this.attributes.position=o.attributes.position,this.attributes.normal=o.attributes.normal,this.attributes.uv=o.attributes.uv;let c=new D,l=new D,h=new D(t,e,i).divideScalar(2).subScalar(r),u=this.attributes.position.array,d=this.attributes.normal.array,f=this.attributes.uv.array,p=u.length/6,x=new D,m=.5/a;for(let g=0,_=0;g<u.length;g+=3,_+=2)switch(c.fromArray(u,g),l.copy(c),l.x-=Math.sign(l.x)*m,l.y-=Math.sign(l.y)*m,l.z-=Math.sign(l.z)*m,l.normalize(),u[g+0]=h.x*Math.sign(c.x)+l.x*r,u[g+1]=h.y*Math.sign(c.y)+l.y*r,u[g+2]=h.z*Math.sign(c.z)+l.z*r,d[g+0]=l.x,d[g+1]=l.y,d[g+2]=l.z,Math.floor(g/p)){case 0:x.set(1,0,0),f[_+0]=Qi(x,l,"z","y",r,i),f[_+1]=1-Qi(x,l,"y","z",r,e);break;case 1:x.set(-1,0,0),f[_+0]=1-Qi(x,l,"z","y",r,i),f[_+1]=1-Qi(x,l,"y","z",r,e);break;case 2:x.set(0,1,0),f[_+0]=1-Qi(x,l,"x","z",r,t),f[_+1]=Qi(x,l,"z","x",r,i);break;case 3:x.set(0,-1,0),f[_+0]=1-Qi(x,l,"x","z",r,t),f[_+1]=1-Qi(x,l,"z","x",r,i);break;case 4:x.set(0,0,1),f[_+0]=1-Qi(x,l,"x","y",r,t),f[_+1]=1-Qi(x,l,"y","x",r,e);break;case 5:x.set(0,0,-1),f[_+0]=Qi(x,l,"x","y",r,t),f[_+1]=1-Qi(x,l,"y","x",r,e);break}}static fromJSON(t){return new n(t.width,t.height,t.depth,t.segments,t.radius)}};var Td=new Map,hi=(n,t)=>(Td.has(n)||Td.set(n,t()),Td.get(n)),uh=(n,t)=>new ot(n,t),dt={sphere:()=>hi("sphere",()=>new li(1,24,16)),sphereLo:()=>hi("sphereLo",()=>new li(1,12,8)),hemi:()=>hi("hemi",()=>new li(1,24,10,0,Math.PI*2,0,Math.PI/2)),hemiShell:()=>hi("hemiShell",()=>new li(1,24,12,0,Math.PI*2,0,Math.PI*.62)),cyl:(n=1,t=1,e=18,i=!1)=>hi(`cyl${n.toFixed(3)},${t.toFixed(3)},${e},${i}`,()=>new Ge(n,t,1,e,1,i)),cone:(n=12)=>hi("cone"+n,()=>new xi(1,1,n)),torus:(n=.25,t=24,e=Math.PI*2)=>hi(`torus${n},${t},${e.toFixed(2)}`,()=>new Fi(1,n,10,t,e)),rbox:(n,t,e,i=.04)=>hi(`rbox${n},${t},${e},${i}`,()=>new hh(n,t,e,3,i)),plane:()=>hi("plane",()=>new Ti(1,1)),ico:(n=1)=>hi("ico"+n,()=>new Tr(1,n)),capsule:(n,t)=>hi(`cap${n},${t}`,()=>new Es(n,t,6,16))};function ce(n,t,e=20){return hi("lathe:"+n,()=>new Qn(t.map(i=>uh(i[0],i[1])),e))}function Ee(n,t,e,i=16){return hi(`limb${n.toFixed(3)},${t.toFixed(3)},${e.toFixed(3)},${i}`,()=>{let s=[];for(let a=0;a<=5;a++){let o=a/5*Math.PI/2;s.push(uh(Math.sin(o)*t,-e-Math.cos(o)*t*.6+t*.6))}for(let a=1;a<=6;a++){let o=a/7,c=t+(n-t)*o,l=Math.sin(o*Math.PI)*(n+t)*.06;s.push(uh(c+l,-e*(1-o)))}for(let a=0;a<=5;a++){let o=Math.PI/2-a/5*Math.PI/2;s.push(uh(Math.sin(o)*n,Math.cos(o)*n*.6))}return s[0].x=0,s[s.length-1].x=0,new Qn(s,i)})}function dh(n,t,e,i,s={}){return hi("blade:"+n,()=>{let r=new As,a=e/2,o=s.tip??t*.18,c=s.leaf;r.moveTo(-a*.8,0),c?(r.bezierCurveTo(-a*1.4,t*.35,-a*1.2,t*.7,0,t),r.bezierCurveTo(a*1.2,t*.7,a*1.4,t*.35,a*.8,0)):(r.lineTo(-a,t*.12),r.lineTo(-a*.92,t-o),r.lineTo(0,t),r.lineTo(a*.92,t-o),r.lineTo(a,t*.12),r.lineTo(a*.8,0)),r.lineTo(-a*.8,0);let l=new wr(r,{depth:i*.25,bevelEnabled:!0,bevelThickness:i*.38,bevelSize:a*.35,bevelSegments:2,steps:1,curveSegments:10});return l.translate(0,0,-i*.125),l.computeVertexNormals(),l})}function Xr(n,t,e,i=.02){return hi("ext:"+n,()=>{let s=new As;t(s);let r=new wr(s,{depth:e,bevelEnabled:i>0,bevelThickness:i,bevelSize:i,bevelSegments:2,curveSegments:12});return r.translate(0,0,-e/2),r.computeVertexNormals(),r})}function be(n,t,e,i,s=24,r=10,a=!0){return hi("tube:"+n,()=>{let o=new Mr(t.map(p=>new D(p[0],p[1],p[2]))),c=o.computeFrenetFrames(s,!1),l=[],h=[],u=[],d=[];for(let p=0;p<=s;p++){let x=p/s,m=o.getPointAt(x),g=c.normals[p],_=c.binormals[p],T=e+(i-e)*x;for(let v=0;v<=r;v++){let S=v/r*Math.PI*2,M=Math.cos(S),A=Math.sin(S),y=M*g.x+A*_.x,E=M*g.y+A*_.y,P=M*g.z+A*_.z;l.push(m.x+y*T,m.y+E*T,m.z+P*T),h.push(y,E,P),u.push(v/r,x)}}for(let p=0;p<s;p++)for(let x=0;x<r;x++){let m=p*(r+1)+x,g=m+r+1;d.push(m,g,m+1,g,g+1,m+1)}if(a){let p=o.getPointAt(0),x=l.length/3;l.push(p.x,p.y,p.z),h.push(0,-1,0),u.push(.5,0);for(let m=0;m<r;m++)d.push(x,m+1,m)}let f=new ge;return f.setAttribute("position",new qt(l,3)),f.setAttribute("normal",new qt(h,3)),f.setAttribute("uv",new qt(u,2)),f.setIndex(d),f})}function qr(n,t=2,e=.28){return hi(`rock${n},${t},${e}`,()=>{let i=new Tr(1,t),s=new Ii(n),r=Array.from({length:6},()=>[s.range(-1,1),s.range(-1,1),s.range(-1,1),s.range(1.5,4),s.range(0,6)]),a=i.attributes.position,o=new D;for(let c=0;c<a.count;c++){o.fromBufferAttribute(a,c).normalize();let l=0;for(let h of r)l+=Math.sin((o.x*h[0]+o.y*h[1]+o.z*h[2])*h[3]+h[4]);o.multiplyScalar(1+l/r.length*e*2),a.setXYZ(c,o.x,o.y,o.z)}return i.computeVertexNormals(),i})}function Np(n,t,e,i=.15){return hi("wing:"+n,()=>{let s=new Ti(t,e,8,8),r=s.attributes.position;for(let a=0;a<r.count;a++){let o=r.getX(a);r.setZ(a,-Math.pow(Math.abs(o)/t,2)*i)}return s.translate(t/2,0,0),s.computeVertexNormals(),s})}function Up(n){let t=[];n.traverse(e=>t.push(e));for(let e of t){let i=new Map;for(let s of e.children)!s.isMesh||s.children.length||s.userData.keep||s.isSkinnedMesh||(i.has(s.material)||i.set(s.material,[]),i.get(s.material).push(s));for(let[s,r]of i){if(r.length<2)continue;let a=r.map(l=>{l.updateMatrix();let h=l.geometry.index?l.geometry.toNonIndexed():l.geometry.clone();for(let u of Object.keys(h.attributes))["position","normal","uv"].includes(u)||h.deleteAttribute(u);return h.attributes.uv||h.setAttribute("uv",new qt(new Float32Array(h.attributes.position.count*2),2)),h.applyMatrix4(l.matrix),h}),o=ch(a,!1);if(a.forEach(l=>l.dispose()),!o)continue;let c=new Pt(o,s);c.castShadow=!0,c.receiveShadow=!0,c.userData.baked=!0;for(let l of r)e.remove(l);e.add(c)}}}var fh=null;function fi(){if(fh)return fh;let n=g=>new Ve(g),t=g=>new Ri(g),e=g=>sh(g),i=ps("planks"),s=ps("log_side"),r=ps("brick"),a=ps("stone"),o=ps("basalt"),c=ps("mossstone"),l=ps("voidcrystal"),h=e("iron"),u=e("bone"),d=e("gold"),f=e("cloth_white"),p=e("cloth_red"),x=e("plant"),m=e("plant_dark");return fh={wood:n({map:i.map,normalMap:i.normalMap,roughnessMap:i.roughnessMap}),darkwood:n({map:s.map,normalMap:s.normalMap,color:9075306,roughness:.9}),log:n({map:s.map,normalMap:s.normalMap,roughness:.92}),iron:n({map:h.map,roughnessMap:h.roughnessMap,normalMap:h.normalMap,metalness:.75}),bone:n({map:u.map,normalMap:u.normalMap,roughness:.7}),stone:n({map:r.map,normalMap:r.normalMap,roughnessMap:r.roughnessMap}),rock:n({map:a.map,normalMap:a.normalMap,roughness:.95}),basalt:n({map:o.map,normalMap:o.normalMap,roughness:.8}),moss:n({map:c.map,normalMap:c.normalMap,roughness:.95}),gold:n({map:d.map,roughnessMap:d.roughnessMap,normalMap:d.normalMap,metalness:1}),wax:t({color:15129020,roughness:.45,sheen:.5}),clay:n({color:9062954,roughness:.8}),clay2:n({color:7232062,roughness:.8}),bronze:n({color:9071162,metalness:.85,roughness:.35}),crystal:t({color:6276847,emissive:1739974,emissiveIntensity:.9,roughness:.08,clearcoat:1,transparent:!0,opacity:.9}),crystalV:t({map:l.map,color:11567359,emissive:6957776,emissiveIntensity:1.1,roughness:.1,clearcoat:1}),ice:t({color:12576504,roughness:.05,clearcoat:1,clearcoatRoughness:.03,transparent:!0,opacity:.82,emissive:1718864,emissiveIntensity:.3}),ore:n({color:14198336,metalness:.9,roughness:.35}),dark:n({color:328965,roughness:1}),cloth:n({map:f.map,normalMap:f.normalMap,roughness:.95,side:Re}),clothRed:n({map:p.map,normalMap:p.normalMap,roughness:.95,side:Re}),paper:n({color:15260864,roughness:.9,side:Re}),plant:n({map:x.map,normalMap:x.normalMap,roughness:.85,side:Re}),plantDark:n({map:m.map,normalMap:m.normalMap,roughness:.9}),reed:n({color:5925418,roughness:.8}),shroom:n({color:9099440,emissive:3197056,emissiveIntensity:.55,roughness:.5}),shroomStem:n({color:14209208,roughness:.7}),rune:n({color:12615935,emissive:10506495,emissiveIntensity:3}),ember:n({color:16738848,emissive:16732176,emissiveIntensity:3}),thorn:n({color:2767384,roughness:.6}),web:new He({map:Cp(),transparent:!0,depthWrite:!1,side:Re,opacity:.8}),banners:[0,1,2].map(g=>n({map:Ip(["#6d1510","#1b2d5e","#2a3d1c"][g],g),transparent:!0,alphaTest:.5,side:Re,roughness:.95}))},fh}var To=null;function X_(){if(To)return To;let n=document.createElement("canvas");n.width=64,n.height=128;let t=n.getContext("2d"),e=t.createRadialGradient(32,88,2,32,76,40);return e.addColorStop(0,"rgba(255,250,220,1)"),e.addColorStop(.25,"rgba(255,200,90,0.95)"),e.addColorStop(.55,"rgba(255,110,20,0.55)"),e.addColorStop(1,"rgba(255,60,0,0)"),t.fillStyle=e,t.beginPath(),t.moveTo(32,4),t.bezierCurveTo(58,60,60,110,32,124),t.bezierCurveTo(4,110,6,60,32,4),t.fill(),To=new ui(n),To.colorSpace=Oe,To}function Us(n=1,t=16777215){let e=new gr({map:X_(),color:t,blending:Xe,depthWrite:!1,transparent:!0}),i=new Ra(e);return i.scale.set(.34*n,.6*n,1),i.userData.base=n,i}var Ed=class{constructor(){this.parts=new Map,this.m=new me,this.q=new Ei,this.e=new Ai,this.p=new D,this.s=new D}add(t,e,i,s,r,a=0,o=0,c=0,l=1,h=1,u=1){let d=t.index?t.toNonIndexed():t.clone();this.e.set(a,o,c,"YXZ"),this.m.compose(this.p.set(i,s,r),this.q.setFromEuler(this.e),this.s.set(l,h,u)),d.applyMatrix4(this.m),this.parts.has(e)||this.parts.set(e,[]),this.parts.get(e).push(d)}local(t,e,i,s,r,a,o,c,l,h=0,u=0,d=0){let f=Math.cos(i.rot),p=Math.sin(i.rot),x=i.s||1,m=i.x+(s*f+a*p)*x,g=i.z+(-s*p+a*f)*x;this.add(t,e,m,i.y+r*x,g,h,i.rot+u,d,o*x,c*x,l*x)}bake(t){let e=new xe;for(let[i,s]of this.parts){for(let c of s){for(let l of Object.keys(c.attributes))["position","normal","uv"].includes(l)||c.deleteAttribute(l);c.attributes.uv||c.setAttribute("uv",new qt(new Float32Array(c.attributes.position.count*2),2))}let r=ch(s,!1),a=i.startsWith("banner")?t.banners[+i.slice(6)]:t[i],o=new Pt(r,a);o.castShadow=!["web","shroom","rune","ember"].includes(i)&&!i.startsWith("banner"),o.receiveShadow=!0,o.userData.propKey=i,e.add(o),s.forEach(c=>c.dispose())}return e}},Vt={box:new $i(1,1,1),cyl:new Ge(.5,.5,1,16),cyl6:new Ge(.5,.5,1,6),cone:new xi(.5,1,12),cone6:new xi(.5,1,6),plane:new Ti(1,1),sphere:new li(.5,16,12),torus:new Fi(.5,.06,8,24),capsule:new Es(.5,1,4,10),circle:new on(.5,16),rbox:dt.rbox(1,1,1,.08),rbox2:dt.rbox(1,1,1,.2)},q_=ce("barrel",[[0,0],[.27,0],[.3,.12],[.33,.41],[.3,.7],[.27,.82],[0,.82]],18),$_=ce("urn",[[0,0],[.12,0],[.16,.06],[.22,.22],[.2,.4],[.1,.52],[.09,.6],[.13,.64],[0,.64]],16),Y_=ce("plinth",[[0,0],[.5,0],[.5,.12],[.42,.18],[.42,.26],[.36,.32],[0,.32]],20),Z_=ce("capital",[[0,0],[.34,0],[.4,.08],[.48,.14],[.5,.24],[0,.24]],20),J_=ce("shaft",[[0,0],[.36,0],[.37,.8],[.35,2.2],[.32,3.2],[0,3.2]],20),K_=ce("shroomcap",[[0,.02],[.3,0],[.34,.05],[.3,.14],[.18,.22],[0,.25]],18),j_=ce("forge",[[0,0],[.7,0],[.75,.3],[.68,.9],[.4,1.3],[.25,1.6],[.25,2.4],[0,2.4]],16),Fp=Xr("coffin",n=>{n.moveTo(0,-.8),n.lineTo(.22,-.8),n.lineTo(.36,.25),n.lineTo(.26,.8),n.lineTo(-.26,.8),n.lineTo(-.36,.25),n.lineTo(-.22,-.8),n.lineTo(0,-.8)},.4,.03),Q_=Xr("anvil",n=>{n.moveTo(-.15,0),n.lineTo(.15,0),n.lineTo(.12,.12),n.lineTo(.3,.2),n.lineTo(.3,.3),n.lineTo(.55,.3),n.quadraticCurveTo(.35,.22,.2,.2),n.lineTo(-.3,.2),n.lineTo(-.35,.3),n.lineTo(-.3,.2),n.lineTo(-.12,.12),n.lineTo(-.15,0)},.22,.02);function Op(n){let t=new Ed,e=new Ii(n.seed+555),i=[],s=[],r=(l,h,u,d,f,p,x=1)=>s.push({x:l,y:h,z:u,color:d,intensity:f,dist:p,flicker:x,phase:e.range(0,100)}),a=n.theme;for(let l of n.torches){let h=Math.atan2(l.nx,l.nz),u={x:l.x-l.nx*.08,y:l.y-.45,z:l.z-l.nz*.08,rot:h,s:1};t.local(be("bracket",[[0,.1,-.16],[0,0,-.05],[0,.12,.04],[0,.3,.05]],.02,.018,12,6,!1),"iron",u,0,0,0,1,1,1),t.local(Vt.cyl,"darkwood",u,0,.35,.05,.07,.42,.07,.25,0,0),t.local(Vt.torus,"clothRed",u,0,.52,.1,.12,.12,.2,Math.PI/2+.25,0,0),t.local(Vt.sphere,"darkwood",u,0,.58,.11,.13,.1,.13);let d=Us(1,16769200);d.position.set(l.x+l.nx*.03,l.y+.35,l.z+l.nz*.03),i.push(d),r(l.x+l.nx*.35,l.y+.35,l.z+l.nz*.35,a.torch,14,10)}for(let l of n.banners){let h=Math.atan2(l.nx,l.nz),u=e.int(0,2);t.add(Vt.plane,"banner"+u,l.x,l.y-.7,l.z,0,h,0,.8,1.6,1),t.add(Vt.cyl,"iron",l.x+l.nx*.03,l.y+.12,l.z+l.nz*.03,0,h,Math.PI/2,.05,1,.05);for(let d of[-1,1])t.add(Vt.sphere,"gold",l.x+l.nx*.03+Math.cos(h)*d*.5,l.y+.12,l.z+l.nz*.03-Math.sin(h)*d*.5,0,0,0,.08,.08,.08)}for(let l of n.cobwebs)t.add(Vt.plane,"web",l.x+.4,l.y+2.9,l.z+.4,-.6,Math.PI/4,0,1.3,1.3,1);let o=a.pillarStyle||"stone";for(let l of n.pillars){let h={x:l.x,y:l.y,z:l.z,rot:e.range(0,6.28),s:1};if(o==="stone")t.local(Y_,"stone",h,0,0,0,1,1,1),t.local(J_,"rock",h,0,.3,0,1,1,1),t.local(Z_,"stone",h,0,3.5,0,1,1,1),t.local(Vt.rbox,"stone",h,0,3.8,0,1.05,.2,1.05);else if(o==="wood"){t.local(Vt.cyl,"log",h,0,2,0,.62,4,.62);for(let u of[.4,3.2])t.local(Vt.torus,"iron",h,0,u,0,.66,.66,1.2,Math.PI/2,0,0);t.local(Vt.rbox,"wood",h,0,3.75,0,1.2,.22,.3);for(let u of[-1,1])t.local(Vt.rbox,"wood",h,u*.35,3.35,0,.12,.7,.12,0,0,u*.7)}else if(o==="basalt"){for(let u=0;u<3;u++){let d=u*2.1,f=3.2+e.range(0,1);t.local(Vt.cyl6,"basalt",h,Math.cos(d)*.2,f/2,Math.sin(d)*.2,.46,f,.46,0,d,0)}t.local(Vt.cyl6,"ember",h,0,1.2,0,.6,.04,.6)}else if(o==="ice"){t.local(ce("icecol",[[0,0],[.55,0],[.4,.6],[.3,2],[.36,3.2],[.5,3.9],[0,3.95]],12),"ice",h,0,0,0,1,1,1);for(let u=0;u<4;u++){let d=u*1.6+.3;t.local(Vt.cone6,"ice",h,Math.cos(d)*.45,.35,Math.sin(d)*.45,.18,.8,.18,Math.sin(d)*.5,0,-Math.cos(d)*.5)}}else if(o==="tree"){t.local(be("trunk"+(l.x|0)%3,[[0,0,0],[.1,1.2,.05],[-.1,2.5,0],[.05,4,.1]],.42,.26,16,12),"log",h,0,0,0,1,1,1);for(let u=0;u<5;u++){let d=u*1.26;t.local(be("root"+u,[[0,.5,0],[Math.cos(d)*.45,.2,Math.sin(d)*.45],[Math.cos(d)*.8,-.05,Math.sin(d)*.8]],.14,.03,8,6),"log",h,0,0,0,1,1,1)}for(let u=0;u<3;u++){let d=u*2.1+.5;t.local(be("branch"+u,[[0,3.2,0],[Math.cos(d)*.5,3.6,Math.sin(d)*.5],[Math.cos(d)*1.1,3.9,Math.sin(d)*1.1]],.12,.02,10,6),"log",h,0,0,0,1,1,1)}t.local(Vt.sphere,"plant",h,0,3.9,0,1.6,.5,1.6)}else if(o==="crystal"){for(let u=0;u<4;u++){let d=u*1.57+.4,f=2.6+(u===0?1.3:e.range(0,1)),p=u===0?0:.25,x=Math.sin(d)*.25*(u?1:0),m=Math.cos(d)*.25*(u?1:0);t.local(Vt.cyl6,"crystalV",h,Math.cos(d)*p,f/2,Math.sin(d)*p,u?.32:.5,f,u?.32:.5,m*.4,0,-x*.4),t.local(Vt.cone6,"crystalV",h,Math.cos(d)*p+x*f*.2,f+.25,Math.sin(d)*p+m*f*.2,u?.32:.5,.5,u?.32:.5,m*.4,0,-x*.4)}r(l.x,l.y+2.5,l.z,10510591,5,7,.2)}}for(let l of n.props){let h=new Ii(l.seed||1);switch(l.type){case"barrel":t.local(q_,"wood",l,0,0,0,1,1,1);for(let u of[.14,.68])t.local(Vt.torus,"iron",l,0,u,0,.62,.62,.9,Math.PI/2,0,0);t.local(Vt.cyl,"darkwood",l,0,.815,0,.54,.02,.54);break;case"crate":t.local(Vt.rbox,"wood",l,0,.36,0,.72,.72,.72);for(let[u,d]of[[-1,-1],[1,-1],[-1,1],[1,1]])t.local(Vt.rbox,"darkwood",l,u*.33,.36,d*.33,.1,.75,.1);t.local(Vt.rbox,"darkwood",l,0,.36,.36,.9,.08,.03,0,0,.78);break;case"bones":for(let u=0;u<5;u++){let d=h.range(0,Math.PI*2),f=h.range(0,.3),p=h.range(.2,.36);t.local(Vt.capsule,"bone",l,Math.cos(d)*f,.03,Math.sin(d)*f,.035,p*.7,.035,Math.PI/2,h.range(0,3),0)}h.chance(.6)&&zp(t,l,h.range(-.2,.2),h.range(-.2,.2));break;case"skull":zp(t,l,0,0);break;case"candles":{let u=h.int(3,5),d=Math.cos(l.rot),f=Math.sin(l.rot);for(let p=0;p<u;p++){let x=h.range(0,Math.PI*2),m=h.range(.05,.3),g=h.range(.15,.4),_=Math.cos(x)*m,T=Math.sin(x)*m;t.local(Vt.cyl,"wax",l,_,g/2,T,.07,g,.07),t.local(Vt.sphere,"wax",l,_+.02,g*.7,T,.03,.06,.03);let v=Us(.28,16773312);v.position.set(l.x+(_*d+T*f)*l.s,l.y+(g+.07)*l.s,l.z+(-_*f+T*d)*l.s),i.push(v)}t.local(Vt.cyl,"wax",l,0,.01,0,.5,.02,.5),r(l.x,l.y+.6,l.z,16760944,4,5,.6);break}case"rubble":for(let u=0;u<6;u++){let d=h.range(.1,.24);t.local(qr(h.int(1,12),1),"rock",l,h.range(-.35,.35),d*.6,h.range(-.35,.35),d,d*.8,d,h.range(0,3),h.range(0,3),0)}break;case"rock":t.local(qr(h.int(1,12),2),a.dimension&&l.type==="rock"&&a.pillarStyle==="crystal"?"crystalV":"rock",l,0,.3,0,.5,.42,.45,0,h.range(0,3),0),t.local(qr(h.int(13,20),1),"rock",l,.3,.12,.2,.2,.16,.2,0,h.range(0,3),0);break;case"coffin":t.local(Fp,"darkwood",l,0,.2,0,1,1,1,Math.PI/2,0,0),t.local(Fp,"darkwood",l,.04,.45,.03,1.04,1.02,.25,Math.PI/2,.1,.04),t.local(Vt.rbox,"iron",l,.04,.5,.18,.06,.02,.5,0,.1,.04),t.local(Vt.rbox,"iron",l,.04,.5,.28,.3,.02,.06,0,.1,.04);break;case"urn":t.local($_,h.chance(.5)?"bronze":"clay2",l,0,0,0,1,1,1);break;case"crystal":{let u=h.int(3,6),d=a.pillarStyle==="crystal"?"crystalV":"crystal";for(let f=0;f<u;f++){let p=h.range(0,Math.PI*2),x=h.range(.4,1.1),m=h.range(.12,.2),g=h.range(.1,.5),_=Math.cos(p)*g,T=Math.sin(p)*g;t.local(Vt.cyl6,d,l,Math.cos(p)*.12+_*x*.4,x/2,Math.sin(p)*.12+T*x*.4,m,x,m,T,0,-_),t.local(Vt.cone6,d,l,Math.cos(p)*.12+_*x*.95,x+m*.6,Math.sin(p)*.12+T*x*.95,m,m*2,m,T,0,-_)}t.local(qr(3,1),"rock",l,0,.05,0,.35,.12,.35);break}case"floatcrystal":t.local(dt.ico(0),"crystalV",l,0,1.3,0,.25,.5,.25,.2,h.range(0,3),.1),t.local(dt.ico(0),"crystalV",l,.35,.9,.1,.1,.2,.1,.5,0,.3),t.local(Vt.torus,"rune",l,0,.03,0,1.1,1.1,.3,Math.PI/2,0,0);break;case"obelisk":t.local(ce("obelisk",[[0,0],[.34,0],[.3,.3],[.22,2.6],[0,3]],4),"basalt",l,0,0,0,1,1,1),t.local(Vt.box,"rune",l,0,1.4,.2,.06,1.6,.04,-.03,0,0);break;case"cart":t.local(Vt.rbox,"wood",l,0,.5,0,1,.45,.7);for(let[u,d]of[[-.35,.38],[.35,.38],[-.35,-.38],[.35,-.38]])t.local(Vt.torus,"iron",l,u,.2,d,.4,.4,.9),t.local(Vt.cyl,"darkwood",l,u,.2,d,.08,.06,.08,Math.PI/2,0,0);for(let u=0;u<6;u++)t.local(qr(u+3,1),"ore",l,h.range(-.3,.3),.76,h.range(-.2,.2),.15,.13,.15);break;case"anvil":t.local(Vt.cyl,"log",l,0,.2,0,.55,.4,.55),t.local(Q_,"iron",l,0,.4,0,1,1,1);break;case"stalagmite":for(let u=0;u<3;u++){let d=h.range(0,6.28),f=h.range(.6,1.8),p=h.range(.18,.32);t.local(ce("stal"+u,[[0,0],[1,0],[.7,.3],[.35,.7],[0,1]],10),"rock",l,Math.cos(d)*.2*(u?1:0),0,Math.sin(d)*.2*(u?1:0),p,f,p,h.range(-.1,.1),0,h.range(-.1,.1))}break;case"icespike":for(let u=0;u<5;u++){let d=h.range(0,6.28),f=h.range(.5,1.6),p=h.range(0,.5);t.local(Vt.cone6,"ice",l,Math.cos(d)*.2,f/2-.05,Math.sin(d)*.2,h.range(.12,.24),f,.2,Math.sin(d)*p,0,-Math.cos(d)*p)}break;case"frozenbody":t.local(Vt.rbox2,"ice",l,0,.55,0,.7,1.1,.6,0,0,.08),t.local(Vt.capsule,"dark",l,0,.55,0,.14,.45,.12,0,0,.15),t.local(Vt.sphere,"dark",l,.03,.95,0,.16,.18,.16);break;case"mushroom":for(let u=0;u<h.int(2,4);u++){let d=h.range(0,6.28),f=u?h.range(.15,.3):0,p=h.range(.25,.6),x=h.range(.5,1.1);t.local(Vt.cyl,"shroomStem",l,Math.cos(d)*f,p/2,Math.sin(d)*f,.07*x,p,.07*x),t.local(K_,"shroom",l,Math.cos(d)*f,p-.03,Math.sin(d)*f,x,x,x)}break;case"reeds":for(let u=0;u<9;u++){let d=h.range(0,6.28),f=h.range(0,.3),p=h.range(.5,1.1);t.local(Vt.cone,"reed",l,Math.cos(d)*f,p/2,Math.sin(d)*f,.03,p,.03,h.range(-.2,.2),0,h.range(-.2,.2)),u%3===0&&t.local(Vt.capsule,"darkwood",l,Math.cos(d)*f,p*.85,Math.sin(d)*f,.03,.08,.03)}break;case"lily":t.local(Vt.circle,"plant",l,0,.005,0,.6,.6,1,-Math.PI/2,0,0),h.chance(.3)&&t.local(Vt.sphere,"clothRed",l,.05,.05,0,.1,.07,.1);break;case"deadtree":t.local(be("dtree",[[0,0,0],[.1,.9,.05],[-.05,1.8,.1],[.15,2.6,0]],.2,.05,14,8),"log",l,0,0,0,1,1,1);for(let u=0;u<4;u++){let d=u*1.57+.3,f=1+u*.35;t.local(be("dbr"+u,[[0,0,0],[Math.cos(d)*.4,.3,Math.sin(d)*.4],[Math.cos(d)*.8,.45,Math.sin(d)*.8]],.07,.01,8,5),"log",l,0,f,0,1,1,1)}break;case"tent":t.local(ce("tent",[[1.9,0],[1.3,1.2],[.4,2.4],[.06,2.7],[0,2.72]],8),"cloth",l,0,0,0,1,1,.8),t.local(Vt.cyl,"darkwood",l,0,1.5,0,.08,3,.08);for(let u=0;u<4;u++){let d=u*1.57+.78;t.local(Vt.cyl,"darkwood",l,Math.cos(d)*1.7,.2,Math.sin(d)*1.35,.05,.5,.05)}t.local(Vt.plane,"clothRed",l,0,2.9,.3,.4,.3,1,0,0,0);break;case"forge":t.local(j_,"stone",l,0,0,0,1,1,1),t.local(Vt.sphere,"ember",l,0,.55,.55,.55,.35,.3);{let u=Us(1.6,16760960);u.position.set(l.x,l.y+.8,l.z+.62),i.push(u)}r(l.x,l.y+1,l.z+1,16742960,16,9,.6);break;case"board":for(let u of[-.9,.9])t.local(Vt.cyl,"darkwood",l,u,1.1,0,.1,2.2,.1);t.local(Vt.rbox,"wood",l,0,1.45,.02,1.9,1.1,.08),t.local(Vt.rbox,"darkwood",l,0,2.1,.02,2.1,.15,.2);for(let u=0;u<6;u++)t.local(Vt.plane,"paper",l,-.6+u%3*.6+h.range(-.08,.08),1.2+Math.floor(u/3)*.48,.075,.38,.42,1,0,0,h.range(-.15,.15));break;case"bench":t.local(Vt.rbox,"wood",l,0,.42,0,1.6,.12,.45);for(let u of[-.6,.6])t.local(Vt.rbox,"darkwood",l,u,.2,0,.12,.4,.4);break;case"bedroll":t.local(Vt.capsule,"clothRed",l,0,.1,0,.35,1.1,.12,Math.PI/2,0,0),t.local(Vt.capsule,"cloth",l,0,.15,-.75,.16,.4,.16,0,0,Math.PI/2);break}}return{group:t.bake(fi()),flames:i,lights:s}}function zp(n,t,e,i){let s={...t,rot:t.rot+.5};n.local(Vt.sphere,"bone",s,e,.12,i-.02,.2,.19,.23),n.local(Vt.sphere,"bone",s,e,.06,i+.06,.13,.08,.12),n.local(Vt.sphere,"dark",s,e-.045,.12,i+.085,.055,.05,.03),n.local(Vt.sphere,"dark",s,e+.045,.12,i+.085,.055,.05,.03)}var tb=`
attribute float size; attribute vec4 pcolor;
varying vec4 vColor;
uniform float uScale;
void main(){
  vColor = pcolor;
  vec4 mv = modelViewMatrix * vec4(position, 1.0);
  gl_PointSize = size * uScale / -mv.z;
  gl_Position = projectionMatrix * mv;
}`,eb=`
uniform sampler2D map; varying vec4 vColor;
void main(){
  vec4 t = texture2D(map, gl_PointCoord);
  gl_FragColor = vec4(vColor.rgb, vColor.a * t.a);
  if (gl_FragColor.a < 0.004) discard;
}`,ph=class{constructor(t,e,i){this.max=t,this.n=0,this.p=new Float32Array(t*3),this.v=new Float32Array(t*3),this.c=new Float32Array(t*4),this.s=new Float32Array(t),this.life=new Float32Array(t),this.maxLife=new Float32Array(t),this.size0=new Float32Array(t),this.size1=new Float32Array(t),this.grav=new Float32Array(t),this.drag=new Float32Array(t),this.col0=new Float32Array(t*4);let s=new ge;this.aPos=new ti(this.p,3),this.aPos.setUsage(po),this.aCol=new ti(this.c,4),this.aCol.setUsage(po),this.aSize=new ti(this.s,1),this.aSize.setUsage(po),s.setAttribute("position",this.aPos),s.setAttribute("pcolor",this.aCol),s.setAttribute("size",this.aSize),s.boundingSphere=new Xi(new D,1e5),this.uniforms={map:{value:i},uScale:{value:400}};let r=new ze({uniforms:this.uniforms,vertexShader:tb,fragmentShader:eb,transparent:!0,depthWrite:!1,blending:e?Xe:as});this.points=new La(s,r),this.points.frustumCulled=!1,this.points.renderOrder=5,s.setDrawRange(0,0)}emit(t,e,i,s,r,a,o,c,l,h,u,d,f,p=0,x=0){let m=this.n;m>=this.max?m=Math.floor(Math.random()*this.max):this.n++,this.p[m*3]=t,this.p[m*3+1]=e,this.p[m*3+2]=i,this.v[m*3]=s,this.v[m*3+1]=r,this.v[m*3+2]=a,this.life[m]=o,this.maxLife[m]=o,this.size0[m]=c,this.size1[m]=l,this.col0[m*4]=h,this.col0[m*4+1]=u,this.col0[m*4+2]=d,this.col0[m*4+3]=f,this.grav[m]=p,this.drag[m]=x}update(t){let e=0;for(;e<this.n;){if(this.life[e]-=t,this.life[e]<=0){this.copy(this.n-1,e),this.n--;continue}let s=1-this.life[e]/this.maxLife[e],r=Math.exp(-this.drag[e]*t);this.v[e*3]*=r,this.v[e*3+2]*=r,this.v[e*3+1]=this.v[e*3+1]*r-this.grav[e]*t,this.p[e*3]+=this.v[e*3]*t,this.p[e*3+1]+=this.v[e*3+1]*t,this.p[e*3+2]+=this.v[e*3+2]*t,this.p[e*3+1]<-.95&&this.grav[e]>0&&(this.p[e*3+1]=-.95,this.v[e*3+1]*=-.3),this.s[e]=this.size0[e]+(this.size1[e]-this.size0[e])*s;let a=s<.1?s/.1:1-(s-.1)/.9;this.c[e*4]=this.col0[e*4],this.c[e*4+1]=this.col0[e*4+1],this.c[e*4+2]=this.col0[e*4+2],this.c[e*4+3]=this.col0[e*4+3]*a,e++}this.points.geometry.setDrawRange(0,this.n),this.aPos.needsUpdate=!0,this.aCol.needsUpdate=!0,this.aSize.needsUpdate=!0}copy(t,e){if(t!==e){for(let i=0;i<3;i++)this.p[e*3+i]=this.p[t*3+i],this.v[e*3+i]=this.v[t*3+i];for(let i=0;i<4;i++)this.c[e*4+i]=this.c[t*4+i],this.col0[e*4+i]=this.col0[t*4+i];this.s[e]=this.s[t],this.life[e]=this.life[t],this.maxLife[e]=this.maxLife[t],this.size0[e]=this.size0[t],this.size1[e]=this.size1[t],this.grav[e]=this.grav[t],this.drag[e]=this.drag[t]}}clear(){this.n=0,this.points.geometry.setDrawRange(0,0)}},mh=class{constructor(t){let e=Rp();this.add=new ph(3e3,!0,e),this.norm=new ph(2e3,!1,e),t.add(this.add.points),t.add(this.norm.points)}setScale(t){this.add.uniforms.uScale.value=t,this.norm.uniforms.uScale.value=t}update(t){this.add.update(t),this.norm.update(t)}clear(){this.add.clear(),this.norm.clear()}attach(t){t.add(this.add.points),t.add(this.norm.points)}sparks(t,e,i,s=10,r=[1,.7,.3],a=5){for(let o=0;o<s;o++){let c=Math.random()*Math.PI*2,l=Math.random()*.8+.2,h=a*(.4+Math.random());this.add.emit(t,e,i,Math.cos(c)*h*(1-l*.5),l*h,Math.sin(c)*h*(1-l*.5),.3+Math.random()*.4,.12,.02,r[0],r[1],r[2],1,12,2)}}blood(t,e,i,s=8,r=[.35,.05,.04]){for(let a=0;a<s;a++){let o=Math.random()*Math.PI*2,c=1+Math.random()*3;this.norm.emit(t,e,i,Math.cos(o)*c,1+Math.random()*3,Math.sin(o)*c,.5+Math.random()*.5,.14,.08,r[0],r[1],r[2],1,12,1)}}dust(t,e,i,s=10,r=[.45,.42,.38],a=.5,o=1){for(let c=0;c<s;c++){let l=Math.random()*Math.PI*2,h=Math.random()*1.5*a;this.norm.emit(t+Math.cos(l)*a*.5,e,i+Math.sin(l)*a*.5,Math.cos(l)*h,Math.random()*o,Math.sin(l)*h,.8+Math.random()*.8,.3,.9,r[0],r[1],r[2],.35,-.2,2)}}fire(t,e,i,s=1,r=.1,a=[1,.5,.15],o=.5){for(let c=0;c<s;c++)this.add.emit(t+(Math.random()-.5)*r,e,i+(Math.random()-.5)*r,(Math.random()-.5)*.3,.8+Math.random()*1.2,(Math.random()-.5)*.3,.35+Math.random()*.4,o,.05,a[0],a[1],a[2],.6,-.5,1)}ember(t,e,i,s=[1,.55,.2]){this.add.emit(t,e,i,(Math.random()-.5)*.4,.6+Math.random()*.8,(Math.random()-.5)*.4,1.2+Math.random()*1.5,.06,.02,s[0],s[1],s[2],1,-.1,.5)}ring(t,e,i,s,r,a,o=4,c=.3){for(let l=0;l<r;l++){let h=l/r*Math.PI*2;this.add.emit(t+Math.cos(h)*s*.2,e,i+Math.sin(h)*s*.2,Math.cos(h)*o,.3+Math.random()*.5,Math.sin(h)*o,s/o,c,c*.3,a[0],a[1],a[2],1,0,0)}}burst(t,e,i,s,r,a=3,o=.6,c=.25,l=0){for(let h=0;h<s;h++){let u=Math.random()*Math.PI*2,d=Math.random()*Math.PI-Math.PI/2,f=a*(.3+Math.random()*.7);this.add.emit(t,e,i,Math.cos(u)*Math.cos(d)*f,Math.sin(d)*f+1,Math.sin(u)*Math.cos(d)*f,o*(.6+Math.random()*.6),c,c*.1,r[0],r[1],r[2],1,l,1.5)}}mote(t,e,i){this.norm.emit(t,e,i,(Math.random()-.5)*.15,(Math.random()-.3)*.1,(Math.random()-.5)*.15,4+Math.random()*4,.05,.05,.8,.75,.65,.35,0,0)}};var ib={steel:.92,steel_dark:.9,gold:1,iron:.7,chain:.85},Ad=new Map;function q(n,t={}){let e=n+JSON.stringify(t);if(Ad.has(e))return Ad.get(e);let i;if(n==="glow")i=new Ve({color:t.color??16724e3,emissive:t.color??16724e3,emissiveIntensity:t.intensity??4,roughness:.4});else if(n==="dark")i=new Ve({color:t.color??394501,roughness:1});else if(n==="eye")i=new Ri({color:t.color??657414,roughness:.08,clearcoat:1,clearcoatRoughness:.05});else if(n==="plain")i=new Ve({color:t.color??16777215,roughness:t.rough??.6,metalness:t.metal??0});else{let s=sh(n),r=["porcelain","carapace","carapace_ice","jelly","ice","crystal_void","scales","scales_red","obsidian"].includes(n),a={map:s.map,roughnessMap:s.roughnessMap,normalMap:s.normalMap,metalness:ib[n]??0,color:t.color??16777215,normalScale:new ot(t.ns??.8,t.ns??.8)};i=r?new Ri(a):new Ve(a),t.rough!==void 0&&(i.roughness=t.rough),n==="porcelain"&&(i.clearcoat=1,i.clearcoatRoughness=.08,i.roughness=.35),(n==="carapace"||n==="carapace_ice")&&(i.clearcoat=1,i.clearcoatRoughness=.15,i.iridescence=.9,i.iridescenceIOR=1.6,i.iridescenceThicknessRange=[200,600]),(n==="scales"||n==="scales_red")&&(i.clearcoat=.6,i.clearcoatRoughness=.3),n==="obsidian"&&(i.clearcoat=.8,i.clearcoatRoughness=.1),n==="jelly"&&(i.transparent=!0,i.opacity=t.opacity??.55,i.roughness=.1,i.clearcoat=1,i.emissive=new Nt(t.emi??7012160),i.emissiveIntensity=.35,i.side=Re,i.depthWrite=!1),n==="ice"&&(i.transparent=!0,i.opacity=.88,i.roughness=.08,i.clearcoat=1,i.clearcoatRoughness=.02,i.metalness=.05),s.emissiveMap&&(i.emissiveMap=s.emissiveMap,i.emissive=new Nt(16777215),i.emissiveIntensity=t.emi??2),t.side&&(i.side=t.side)}return t.double&&(i.side=Re),Ad.set(e,i),i}var kn=class{constructor(t){this.type=t,this.root=new xe,this.props={}}piv(t,e,i=0,s=0,r=0){let a=new xe;return a.name=e||"",a.position.set(i,s,r),(t||this.root).add(a),a}mesh(t,e,i,s=[0,0,0],r=[1,1,1],a=[0,0,0],o=!1){let c=new Pt(typeof e=="function"?e():e,i);return c.position.set(s[0],s[1],s[2]),typeof r=="number"?c.scale.setScalar(r):c.scale.set(r[0],r[1],r[2]),c.rotation.set(a[0],a[1],a[2]),c.castShadow=!0,c.receiveShadow=!0,o&&(c.userData.keep=!0),(t||this.root).add(c),c}ball(t,e,i,s,r){return this.mesh(t,dt.sphere,e,i,s,r)}},Rd=new Map;function Yr(n,t){if(!Rd.has(n)){let e=t();Up(e.root),e.root.updateMatrixWorld(!0),Rd.set(n,e)}return Rd.get(n)}var $r=class n{constructor(t){this.type=t,this.root=new xe,this.mats=[],this.meshes=[],this.flashT=0}static from(t){let e=new n(t.type);e.root=t.root.clone(!0);let i=new Map;e.root.traverse(s=>{if(s.isMesh){let r=i.get(s.material);r||(r=s.material.clone(),r.userData.baseEmissive=r.emissive?r.emissive.clone():null,r.userData.baseEI=r.emissiveIntensity,r.userData.baseOpacity=r.opacity,r.userData.baseTransparent=r.transparent,i.set(s.material,r)),s.material=r,s.userData.ownGeo&&(s.geometry=s.geometry.clone(),s.userData.base=s.geometry.attributes.position.array.slice()),e.meshes.push(s)}if(s.name){let r=s.name.indexOf(".");if(r>0){let a=s.name.slice(0,r);(e[a]||(e[a]=[]))[+s.name.slice(r+1)]=s}else e[s.name]=s}}),e.mats=[...i.values()],Object.assign(e,t.props);for(let s of Object.keys(t.props))Array.isArray(t.props[s])&&(e[s]=t.props[s].slice());return e}flash(t){for(let e of this.mats)e.userData.baseEmissive&&(t>0?(e.emissive.setRGB(t,t*.95,t*.9),e.emissiveIntensity=1):(e.emissive.copy(e.userData.baseEmissive),e.emissiveIntensity=e.userData.baseEI))}tint(t,e){for(let i of this.mats)i.userData.baseColor||(i.userData.baseColor=i.color.clone()),i.color.copy(i.userData.baseColor).lerp(t,e)}fade(t){for(let e of this.mats){let i=e.userData.baseOpacity??1;e.transparent=t<1||e.userData.baseTransparent,e.opacity=i*t,e.depthWrite=t>.5&&!e.userData.baseTransparent}}dispose(){for(let t of this.mats)t.dispose()}},Gi={};var we=Math.PI;function Cd(n,t){let e=q(t.skin),i=q("bone",{color:10129536}),s=q("dark"),r=n.piv(null,"body",0,.62,0);n.ball(r,e,[0,.02,.06],[.2,.17,.3]),n.ball(r,e,[0,-.02,-.28],[.15,.13,.17]);for(let c=0;c<7;c++)n.mesh(r,dt.cone(8),i,[0,.16-Math.abs(c-2)*.012,-.3+c*.09],[.025,.07,.03],[-.3,0,0]);for(let c=0;c<4;c++)for(let l of[-1,1])n.mesh(r,dt.torus(.14,14,we*.7),e,[l*.02,-.02,-.05+c*.08],[.2,.16,.2],[0,l*we/2,-we*.1]);let a=n.piv(r,"head",0,.06,.34);n.ball(a,e,[0,.02,.1],[.09,.1,.17]),n.ball(a,e,[0,.07,.02],[.08,.06,.1]);for(let c of[-1,1])n.ball(a,s,[c*.07,.04,.16],[.012,.03,.05]);let o=n.piv(a,"jaw",0,-.04,.03);n.ball(o,e,[0,-.01,.1],[.075,.035,.15]),n.ball(o,q("plain",{color:3149844,rough:.4}),[0,.012,.1],[.062,.018,.13]);for(let c=0;c<6;c++){let l=(c/5-.5)*1.8;n.mesh(a,dt.cone(6),i,[Math.sin(l)*.06,-.035,.1+Math.cos(l)*.14],[.01,.045,.01],[we,0,0])}for(let c=0;c<2;c++){let l=c?1:-1,h=n.piv(r,"fl."+c,l*.16,0,.26);n.mesh(h,Ee(.05,.036,.36),e);let u=n.piv(h,"fe."+c,0,-.36,0);n.mesh(u,Ee(.036,.028,.38),e);let d=n.piv(u,"fh."+c,0,-.38,0);for(let m=0;m<3;m++)n.mesh(d,be("claw"+m,[[0,0,0],[(m-1)*.03,-.05,.05],[(m-1)*.04,-.07,.13]],.012,.002,8,6,!1),i);let f=n.piv(r,"bl."+c,l*.13,-.05,-.3);n.mesh(f,Ee(.062,.045,.32),e);let p=n.piv(f,"bk."+c,0,-.32,0);n.mesh(p,Ee(.045,.03,.33),e);let x=n.piv(p,"bf."+c,0,-.33,0);n.mesh(x,Ee(.03,.024,.17),e),n.ball(x,e,[0,-.17,.04],[.035,.02,.07])}n.props={anim:"crawler"}}Gi.crawler=(n,t,e,i)=>{for(let s=0;s<2;s++){let r=s?we:0,a=t+r,o=t+r+we;n.fl[s].rotation.set(-.55+Math.sin(a)*.42*e,0,(s?1:-1)*.12),n.fe[s].rotation.set(.75+Math.max(0,Math.cos(a))*.55*e,0,0),n.fh[s].rotation.set(-.2,0,0),n.bl[s].rotation.set(-.62+Math.sin(o)*.38*e,0,0),n.bk[s].rotation.set(1.3+Math.max(0,Math.cos(o))*.45*e,0,0),n.bf[s].rotation.set(-.78,0,0)}n.body.position.y=.6+Math.abs(Math.sin(t))*.04*e+Math.sin(i*2)*.01,n.body.rotation.set(Math.sin(t*2)*.03*e,0,Math.sin(t)*.06*e),n.head.rotation.set(.15+Math.sin(i*1.3)*.08,Math.sin(i*.9)*.3*(1-e),0),n.jaw.rotation.x=.1+Math.max(0,Math.sin(i*2.3))*.2};function kp(n,t,e=1){let i=q(t.bark),s=q("bone",{color:t.thorn||3813408}),r=q(t.petal,{double:!0}),a=n.piv(null,"body",0,0,0);for(let h=0;h<4;h++){let u=h*we/2+we/4,d=n.piv(a,"legs."+h,Math.sin(u)*.15,.32,Math.cos(u)*.15);d.rotation.y=u,n.mesh(d,be("root",[[0,0,0],[0,-.1,.12],[0,-.26,.26],[0,-.33,.36]],.07,.015,12,8,!1),i)}let o=n.piv(a,"stem",0,0,0);n.mesh(o,ce("bulb",[[0,.22],[.2,.28],[.31,.52],[.29,.82],[.17,1.02],[.1,1.12],[0,1.15]],20),i);let c=h=>Math.abs(Math.sin(h*12.9898)*43758.5453)%1;for(let h=0;h<24;h++){let u=.35+c(h)*.6,d=c(h+50)*we*2,f=u<.55?.28:u<.85?.29:.18,p=new D(Math.sin(d),.25,Math.cos(d)).normalize(),x=new Ei().setFromUnitVectors(new D(0,1,0),p),m=new Ai().setFromQuaternion(x);n.mesh(o,dt.cone(6),s,[Math.sin(d)*f,u,Math.cos(d)*f],[.022,.13,.022],[m.x,m.y,m.z])}let l=n.piv(o,"head",0,1.12,0);for(let h=0;h<5;h++){let u=n.piv(l,"",0,0,0);u.rotation.y=h*we*2/5;let d=n.piv(u,"petals."+h,0,0,.04);n.ball(d,r,[0,.01,.2],[.12,.025,.23])}n.ball(l,q("glow",{color:t.core||16760896,intensity:3}),[0,.04,0],.09);for(let h=0;h<7;h++){let u=h*.9;n.mesh(l,be("stamen"+h,[[0,.02,0],[Math.sin(u)*.05,.12,Math.cos(u)*.05],[Math.sin(u)*.07,.2,Math.cos(u)*.07]],.008,.004,6,5,!1),q("plain",{color:15257712}))}n.root.scale.setScalar(e),n.props={anim:"plant"}}Gi.plant=(n,t,e,i)=>{n.legs.forEach((r,a)=>{r.rotation.x=Math.sin(t*2+a*1.6)*.3*e}),n.stem.rotation.set(Math.sin(i*1.3)*.04+Math.sin(t*2)*.05*e,0,Math.sin(i*1.1)*.05),n.stem.position.y=Math.abs(Math.sin(t*2))*.03*e;let s=n.petalOpen??.3;n.petals.forEach((r,a)=>{r.rotation.x=-1.25+s*1.2+Math.sin(i*2+a)*.05})};var Eo=14;function Pd(n,t,e=1,i=!1){let s=q(t.scales),r=q("plain",{color:t.belly||9075290,rough:.5}),a=q("glow",{color:t.eye||16764976,intensity:4});for(let l=0;l<Eo;l++){let h=n.piv(null,"seg."+l,0,0,0),u=.17*(1-l/Eo*.72);n.ball(h,s,[0,0,0],[u,u*.82,u*1.45]),n.ball(h,r,[0,-u*.35,0],[u*.82,u*.5,u*1.3]),l%2===0&&l<Eo-2&&n.mesh(h,dt.cone(6),q("bone",{color:t.fin||4864554}),[0,u*.85,0],[u*.18,u*.6,u*.5],[-.4,0,0])}let o=n.piv(null,"head",0,.3,.3);n.ball(o,s,[0,.02,.08],[.13,.09,.2]),n.ball(o,s,[0,.04,-.05],[.14,.1,.12]);for(let l of[-1,1])n.ball(o,a,[l*.085,.07,.13],[.025,.02,.03]),n.mesh(o,dt.cone(6),q("bone"),[l*.04,-.05,.22],[.012,.06,.012],[we-.2,0,0]),n.mesh(o,ce("frill",[[0,0],[.1,.02],[.16,.1],[.18,.2],[0,.25]],10),q(t.frill||"petal",{double:!0}),[l*.11,.05,-.08],[.5,1,.12],[.3,0,l*-1.1]),i&&n.mesh(o,be("crest"+l,[[l*.06,.1,-.02],[l*.1,.2,-.1],[l*.1,.26,-.24]],.03,.005,12,6),q("bone",{color:6967360}));let c=n.piv(o,"jaw",0,-.03,0);n.ball(c,s,[0,-.02,.08],[.11,.04,.18]),n.ball(c,q("plain",{color:4198424,rough:.35}),[0,.005,.08],[.09,.02,.15]),n.root.scale.setScalar(e),n.props={anim:"serpent"}}Gi.serpent=(n,t,e,i)=>{let s=n.ext||0,r=.2,a=0,o=0;for(let h=0;h<Eo;h++){let u=n.seg[h],d=.1-h*r*(1-s*.35)+s*.5,f=(.03+h*.012)*(.35+e*.8),p=Math.sin(t*1.1-h*.55+i*(e<.1?1.2:0))*f,x=.17*(1-h/Eo*.72);u.position.set(p,x*.8,d),h>0&&(u.rotation.y=Math.atan2(a-p,o-d)),a=p,o=d}let c=n.seg[0],l=.25+(1-e)*.18+s*.1;n.head.position.set(c.position.x*.6,l+Math.sin(i*2)*.02,c.position.z+.22),n.head.rotation.set(.25-(1-e)*.3+s*.2,Math.sin(t*1.1+.55)*.25*e+Math.sin(i*.8)*.2*(1-e),0),n.jaw.rotation.x=n.jawOpen??.05+Math.max(0,Math.sin(i*1.7))*.12};function Bp(n,t){let e=q("jelly",{emi:t.emi,opacity:.5}),i=q("glow",{color:t.core,intensity:3}),s=q("glow",{color:t.core,intensity:.9}),r=n.piv(null,"body",0,1.25,0),a=n.piv(r,"bell",0,0,0),o=n.mesh(a,ce("bell",[[0,.34],[.18,.32],[.32,.22],[.41,.05],[.4,-.04],[.33,-.01],[.2,.04],[0,.06]],28),e);o.userData.keep=!0,o.castShadow=!1,n.ball(a,i,[0,.14,0],.11);for(let c=0;c<4;c++){let l=c*we/2;n.ball(a,s,[Math.sin(l)*.13,.1,Math.cos(l)*.13],[.06,.035,.1],[0,l,0])}for(let c=0;c<10;c++){let l=c*we/5;n.ball(a,e,[Math.sin(l)*.38,-.03,Math.cos(l)*.38],.04)}for(let c=0;c<8;c++){let l=c*we/4+.2,h=n.piv(r,"ten."+c,Math.sin(l)*.3,-.03,Math.cos(l)*.3),u=n.mesh(h,Ee(.028,.02,.45,8),e);u.castShadow=!1;let d=n.piv(h,"tent."+c,0,-.45,0),f=n.mesh(d,Ee(.02,.008,.5,8),e);f.castShadow=!1}for(let c=0;c<3;c++){let l=c*2.1,h=n.piv(r,"oral."+c,Math.sin(l)*.06,0,Math.cos(l)*.06),u=n.mesh(h,be("oral",[[0,0,0],[.05,-.25,0],[-.04,-.5,.03],[.03,-.75,0]],.05,.012,16,8,!1),q("jelly",{emi:t.emi,opacity:.7}));u.castShadow=!1}n.props={anim:"jelly"}}Gi.jelly=(n,t,e,i)=>{let s=Math.sin(i*3.2+t*.2),r=n.swell||0;n.body.position.y=1.2+Math.sin(i*1.6)*.1,n.bell.scale.set(1+s*.06+r*.45,1-s*.08+r*.35,1+s*.06+r*.45),n.body.rotation.set(.12*e,0,Math.sin(i*.9)*.05);for(let a=0;a<8;a++)n.ten[a].rotation.set(.3*e+Math.sin(i*2.1+a)*.18,0,Math.cos(i*1.7+a*1.3)*.15),n.tent[a].rotation.set(Math.sin(i*2.6+a*.7)*.35+.2*e,0,Math.sin(i*2+a)*.2);n.oral.forEach((a,o)=>{a.rotation.set(Math.sin(i*1.5+o)*.15+.2*e,i*.3,0)})};function gh(n,t,e=1,i={}){let s=q(t.robe,{double:!0}),r=q(t.mask),a=q(t.skin||"skin_pale"),o=q("gold"),c=q("glow",{color:t.glow,intensity:4}),l=n.piv(null,"body",0,.12,0);n.mesh(l,ce("robe",[[.06,1.62],[.16,1.56],[.21,1.42],[.22,1.2],[.26,.8],[.34,.4],[.44,.06],[.47,-.02],[.4,0]],28),s),n.mesh(l,dt.torus(.25,24),o,[0,1.12,0],[.225,.225,.2],[we/2,0,0]);for(let p=0;p<7;p++)n.mesh(l,dt.cone(4),s,[Math.sin(p*.9)*.42,.02,Math.cos(p*.9)*.42],[.06,.16,.02],[we,p*.9,0]);let h=n.piv(l,"head",0,1.62,.02);if(n.mesh(h,dt.hemiShell,s,[0,.12,-.03],[.15,.18,.16],[-.3,0,0]),n.ball(h,r,[0,.12,.03],[.095,.125,.1]),n.mesh(h,dt.rbox(.006,.12,.01,.002),c,[0,.12,.13]),i.crown)for(let p=0;p<7;p++){let x=(p-3)*.32;n.mesh(h,dt.cone(6),q("ice"),[Math.sin(x)*.1,.24+(3-Math.abs(p-3))*.02,Math.cos(x)*.04-.02],[.022,.16+(3-Math.abs(p-3))*.05,.022],[-.15,0,-x*.6])}let u=n.piv(l,"halo",0,1.78,-.2);n.mesh(u,dt.torus(.06,40),o,[0,0,0],.26);for(let p=0;p<8;p++){let x=p*we/4;n.mesh(u,dt.rbox(.04,.06,.012,.005),c,[Math.cos(x)*.26,Math.sin(x)*.26,0],1,[0,0,x])}let d=[[.19,1.46,0],[.17,1.28,.04]],f=0;for(let[p,x,m]of d)for(let g of[-1,1]){let _=n.piv(l,"arms."+f,g*p,x,m);n.mesh(_,Ee(.045,.036,.4),s);let T=n.piv(_,"fore."+f,0,-.4,0);n.mesh(T,Ee(.03,.022,.38),a);let v=n.piv(T,"hand."+f,0,-.38,0);for(let S=0;S<3;S++)n.mesh(v,be("finger"+S,[[0,0,0],[(S-1)*.02,-.06,.01],[(S-1)*.025,-.15,.04]],.009,.003,8,5,!1),a);f++}if(i.orbit){let p=n.piv(l,"orbit",0,1.1,0);for(let x=0;x<6;x++){let m=x*we/3;n.mesh(p,dt.ico(0),q("crystal_void",{emi:3}),[Math.cos(m)*.75,Math.sin(m*2)*.15,Math.sin(m)*.75],[.07,.16,.07],[0,m,.3])}}n.root.scale.setScalar(e),n.props={anim:"seer"}}Gi.seer=(n,t,e,i)=>{n.body.position.y=.16+Math.sin(i*2)*.06,n.body.rotation.set(.08*e,0,Math.sin(i*1.1)*.03),n.halo.rotation.z=i*.8,n.orbit&&(n.orbit.rotation.y=i*1.2);let s=n.cast||0;n.arms.forEach((r,a)=>{let o=a%2?1:-1,c=a>=2;r.rotation.set(-.25-s*(c?1.2:2.6)+Math.sin(i*1.5+a)*.12,0,o*(.25+(c?.2:0))+o*s*.4),n.fore[a].rotation.set(-.5-Math.sin(i*1.8+a*.7)*.2+s*.3,0,0)}),n.head.rotation.set(Math.sin(i*.7)*.08,Math.sin(i*.5)*.25,Math.sin(i*.9)*.1)};function Id(n,t,e=1){let i=q(t.shell,t.shellOpt||{}),s=q(t.hide||"hide"),r=q("bone",{color:t.horn||2761760}),a=q("glow",{color:t.eye||16732192,intensity:3}),o=n.piv(null,"body",0,.48,0);n.mesh(o,dt.hemi,i,[0,-.02,-.16],[.5,.4,.46]),n.mesh(o,dt.hemi,i,[0,0,.16],[.44,.34,.3],[.15,0,0]),n.ball(o,s,[0,-.06,0],[.42,.16,.56]);let c=n.piv(o,"head",0,.02,.44);n.mesh(c,dt.hemi,i,[0,-.04,.02],[.26,.2,.22],[.5,0,0]),n.ball(c,s,[0,-.08,.06],[.2,.12,.18]),n.mesh(c,be("horn",[[0,.02,.1],[0,.16,.24],[0,.34,.3],[0,.46,.2]],.08,.008,18,10),r);for(let l of[-1,1])n.ball(c,a,[l*.13,-.02,.16],.028),n.mesh(c,be("mand"+l,[[l*.08,-.1,.17],[l*.12,-.12,.3],[l*.04,-.13,.38]],.028,.006,10,6),r),n.mesh(c,dt.cone(8),r,[l*.16,.08,.02],[.03,.14,.03],[.4,0,-l*.5]);if(t.spikes)for(let l=0;l<7;l++)n.mesh(o,dt.cone(6),q(t.spikes),[(l%3-1)*.16,.32+l%2*.04,-.3+l*.09],[.04,.22,.04],[-.3,0,(l%3-1)*.3]);for(let l=0;l<6;l++){let h=l%2?1:-1,u=.26-Math.floor(l/2)*.26,d=n.piv(o,"legs."+l,h*.34,-.08,u);n.mesh(d,Ee(.05,.036,.3,10),s);let f=n.piv(d,"lk."+l,0,-.3,0);n.mesh(f,Ee(.036,.016,.34,10),r)}n.root.scale.setScalar(e),n.props={anim:"beetle"}}Gi.beetle=(n,t,e,i)=>{for(let s=0;s<6;s++){let r=s%2?1:-1,a=s===0||s===3||s===4?0:we,o=t*1.6+a;n.legs[s].rotation.set(0,Math.sin(o)*.35*e*r,r*(1.05+Math.max(0,Math.cos(o))*.25*e)),n.lk[s].rotation.set(0,0,-r*1.75)}n.body.position.y=.48+Math.abs(Math.sin(t*1.6))*.02*e,n.body.rotation.set(n.lean||0,0,Math.sin(t*1.6)*.03*e),n.head.rotation.set(Math.sin(i*1.4)*.06+(n.lean||0)*.8,Math.sin(i*.8)*.15*(1-e),0)};function Hp(n,t,e=1){let i=q(t.fur),s=q("eye",{color:1706504}),r=q("plain",{color:2760728,rough:.8}),a=n.piv(null,"body",0,1.4,0);n.ball(a,i,[0,0,0],[.09,.09,.12]);for(let u=0;u<4;u++)n.ball(a,i,[0,-.01-u*.01,-.13-u*.07],[.075-u*.012,.07-u*.01,.06]);n.ball(a,i,[0,.01,.12],.065);for(let u of[-1,1])n.ball(a,s,[u*.045,.02,.16],.036),n.mesh(a,be("ant"+u,[[u*.02,.05,.16],[u*.08,.14,.24],[u*.14,.18,.3]],.008,.004,10,5,!1),r);let o=q("plain"),c=new Ve({map:Tp(t.wing,t.eyespot),transparent:!0,alphaTest:.4,side:Re,roughness:.9}),l=[[.02,.03,.55,.42,.1],[0,-.08,.42,.34,-.4]],h=0;for(let[u,d,f,p,x]of l)for(let m of[-1,1]){let g=n.piv(a,"wings."+h,m*.06,d+.04,u),_=n.mesh(g,Np("moth"+f,f,p,.08),c,[0,0,0],[m,1,1],[-we/2,0,m*x]);_.userData.keep=!0,h++}for(let u=0;u<6;u++){let d=u%2?1:-1;n.mesh(a,be("mleg"+u,[[0,0,0],[d*.08,-.08,0],[d*.1,-.18,.02]],.008,.004,6,4,!1),r,[0,-.05,.05-Math.floor(u/2)*.05])}n.root.scale.setScalar(e),n.props={anim:"moth"}}Gi.moth=(n,t,e,i)=>{let s=Math.sin(i*24+t);n.wings.forEach((r,a)=>{let o=a%2?1:-1;r.rotation.set(0,0,o*(s*.85+.15))}),n.body.position.y=1.35+Math.sin(i*3.1+t)*.18+(n.dive||0)*-.9,n.body.rotation.set(.15+Math.sin(i*2)*.1+(n.dive||0)*.6,0,Math.sin(i*2.7)*.2)};function Gp(n,t,e=1){let i=q(t.hide),s=q(t.spike,{emi:2.5}),r=q("glow",{color:t.eye,intensity:5}),a=q("bone",{color:14209216}),o=n.piv(null,"body",0,.68,0);n.ball(o,i,[0,.03,.14],[.19,.23,.3]),n.ball(o,i,[0,.02,-.26],[.15,.17,.25]);for(let u=0;u<6;u++)n.mesh(o,dt.cone(5),s,[0,.2+Math.sin(u*.6)*.03,-.35+u*.12],[.03,.16+u%2*.06,.04],[-.35,0,(u%2?1:-1)*.2]);let c=n.piv(o,"tail",0,.05,-.46);n.mesh(c,be("tail",[[0,0,0],[0,-.05,-.2],[0,-.2,-.4],[0,-.28,-.55]],.05,.01,14,8),i);let l=n.piv(o,"head",0,.18,.4);n.mesh(l,Ee(.08,.07,.18),i,[0,0,-.05],1,[-1.1,0,0]),n.ball(l,i,[0,.05,.12],[.1,.1,.13]),n.ball(l,i,[0,.02,.24],[.06,.055,.12]);for(let u of[-1,1])n.ball(l,r,[u*.055,.08,.2],[.018,.012,.02]),n.mesh(l,dt.cone(5),s,[u*.06,.16,.06],[.025,.14,.025],[-.6,0,u*.35]);let h=n.piv(l,"jaw",0,-.02,.12);n.ball(h,i,[0,-.02,.1],[.05,.03,.11]);for(let u=0;u<4;u++)n.mesh(l,dt.cone(5),a,[(u-1.5)*.025,-.02,.3],[.007,.03,.007],[we,0,0]);for(let u=0;u<2;u++){let d=u?1:-1,f=n.piv(o,"fl."+u,d*.12,-.05,.26);n.mesh(f,Ee(.06,.042,.33),i);let p=n.piv(f,"fe."+u,0,-.33,0);n.mesh(p,Ee(.042,.03,.3),i),n.ball(p,i,[0,-.32,.03],[.04,.025,.06]);let x=n.piv(o,"bl."+u,d*.12,-.02,-.33);n.mesh(x,Ee(.075,.05,.3),i);let m=n.piv(x,"bk."+u,0,-.3,0);n.mesh(m,Ee(.045,.032,.28),i);let g=n.piv(m,"bf."+u,0,-.28,0);n.mesh(g,Ee(.03,.024,.18),i),n.ball(g,i,[0,-.19,.03],[.04,.025,.06])}n.root.scale.setScalar(e),n.props={anim:"beast"}}Gi.beast=(n,t,e,i)=>{for(let s=0;s<2;s++){let r=s?we:0,a=t*1.2+r,o=a+we*.85;n.fl[s].rotation.set(Math.sin(a)*.55*e,0,0),n.fe[s].rotation.set(Math.max(0,Math.cos(a))*.9*e,0,0),n.bl[s].rotation.set(-.4+Math.sin(o)*.5*e,0,0),n.bk[s].rotation.set(1+Math.max(0,-Math.cos(o))*.4*e,0,0),n.bf[s].rotation.set(-.72,0,0)}n.body.position.y=.66+Math.abs(Math.sin(t*1.2))*.05*e,n.body.rotation.set(Math.sin(t*2.4)*.04*e+(n.crouch||0),0,0),n.tail.rotation.set(Math.sin(i*2)*.1,Math.sin(i*3+t)*.4,0),n.head.rotation.set(-.05+Math.sin(i*1.2)*.05-(n.crouch||0)*.6,Math.sin(i*.7)*.2*(1-e),0),n.jaw.rotation.x=n.jawOpen??.08};function Vp(n,t){let e=t==="colosso",i=e?q("obsidian",{emi:1.3}):q("skin_pale",{color:12107944}),s=e?i:q("belly"),r=q("bone",{color:e?3814456:13155496}),a=n.piv(null,"hips",0,.62,0);n.ball(a,i,[0,0,0],[.24,.16,.18]);for(let l of[-1,1]){let h=l<0?"L":"R",u=n.piv(a,"leg"+h,l*.15,-.02,0);n.mesh(u,Ee(.12,.09,.32),i);let d=n.piv(u,"knee"+h,0,-.32,0);n.mesh(d,Ee(.09,.08,.3),i);let f=n.piv(d,"foot"+h,0,-.3,0);n.ball(f,i,[0,-.02,.05],[.1,.06,.16])}let o=n.piv(a,"torso",0,.06,0);n.mesh(o,ce("bruteTorso",[[0,-.05],[.22,-.04],[.26,.12],[.3,.32],[.36,.5],[.34,.6],[.22,.7],[0,.72]],24),i,[0,0,0],[1.05,1,.8]),e?n.ball(o,q("glow",{color:16742944,intensity:4}),[0,.44,.22],[.1,.1,.06]):n.ball(o,s,[0,.16,.12],[.27,.25,.22]);for(let l=0;l<6;l++)n.mesh(o,e?dt.ico(0):dt.cone(6),r,[(l%3-1)*.16,.58+(l>2?-.14:0),-.2],e?[.07,.14,.07]:[.04,.22,.04],[-.8,0,(l%3-1)*.4]);let c=n.piv(o,"head",0,.62,.14);if(e)n.mesh(c,dt.ico(1),i,[0,.12,0],[.16,.15,.15]),n.mesh(c,dt.rbox(.18,.025,.04,.01),q("glow",{color:16752704,intensity:6}),[0,.13,.13]);else{n.ball(c,i,[0,.1,.02],[.14,.13,.14]),n.ball(c,i,[0,.03,.08],[.12,.06,.1]);for(let l of[-1,1])n.ball(c,q("glow",{color:13172576,intensity:3}),[l*.05,.13,.13],.018);for(let l=0;l<5;l++)n.mesh(c,dt.cone(5),r,[(l-2)*.03,.02,.17],[.012,.045,.012],[.2,0,0])}for(let l of[-1,1]){let h=l<0?"L":"R",u=n.piv(o,"arm"+h,l*.4,.56,0);n.ball(u,i,[0,0,0],[.17,.15,.16]),n.mesh(u,Ee(.14,.11,.42),i);let d=n.piv(u,"elbow"+h,0,-.42,0);n.mesh(d,Ee(.12,.13,.42),i);let f=n.piv(d,"hand"+h,0,-.5,0);n.ball(f,i,[0,0,0],[.13,.12,.12]);for(let p=0;p<3;p++)n.mesh(f,dt.cone(6),r,[(p-1)*.06,-.1,.07],[.022,.1,.022],[we-.4,0,0]);if(e)for(let p=0;p<3;p++)n.mesh(u,dt.ico(0),r,[l*.1,.1-p*.14,-.05],[.07,.1,.07],[0,p,l])}n.root.scale.setScalar(e?2.1:2.2),n.props={anim:"humanoid",legLen:.62,baseArm:-.15}}function nb(n){let t=q("plant_dark"),e=q("petal",{double:!0}),i=q("bone",{color:3813408}),s=n.piv(null,"body",0,0,0);for(let c=0;c<7;c++){let l=c*we*2/7;n.mesh(s,be("broot"+c,[[0,.5,0],[Math.sin(l)*.5,.3,Math.cos(l)*.5],[Math.sin(l)*1.1,.05,Math.cos(l)*1.1],[Math.sin(l)*1.5,-.1,Math.cos(l)*1.5]],.22,.04,16,10),t)}let r=n.piv(s,"stem",0,0,0);n.mesh(r,ce("fstem",[[0,.2],[.55,.4],[.62,1],[.45,1.7],[.35,2.2],[0,2.3]],24),t);for(let c=0;c<30;c++){let l=c*2.4,h=.5+c%10*.16;n.mesh(r,dt.cone(6),i,[Math.sin(l)*.55*(1-h/3),h,Math.cos(l)*.55*(1-h/3)],[.05,.3,.05],[Math.cos(l)*1.2,0,-Math.sin(l)*1.2])}let a=n.piv(r,"head",0,2.25,.1);for(let c=0;c<8;c++){let l=n.piv(a,"",0,0,0);l.rotation.y=c*we/4;let h=n.piv(l,"petals."+c,0,0,.3);n.ball(h,e,[0,0,.55],[.36,.06,.62])}let o=n.piv(a,"jaw",0,.1,0);n.mesh(a,dt.hemi,q("plant"),[0,.1,0],[.55,.45,.55],[we,0,0]),n.mesh(o,dt.hemi,q("plant"),[0,0,0],[.55,.45,.55]),n.ball(a,q("glow",{color:16724064,intensity:3}),[0,.1,0],.35);for(let c=0;c<12;c++){let l=c*we/6;n.mesh(o,dt.cone(5),q("bone"),[Math.sin(l)*.48,.02,Math.cos(l)*.48],[.04,.16,.04],[0,0,0]),n.mesh(a,dt.cone(5),q("bone"),[Math.sin(l)*.48,.08,Math.cos(l)*.48],[.04,.16,.04],[we,0,0])}for(let c=0;c<4;c++){let l=c*we/2+.4,h=n.piv(r,"vines."+c,Math.sin(l)*.45,1.3,Math.cos(l)*.45);h.rotation.y=l,n.mesh(h,be("vine",[[0,0,0],[0,.4,.5],[0,.3,1.2],[0,-.2,1.8],[0,-.6,2.2]],.12,.03,24,8),t)}n.props={anim:"flower"}}Gi.flower=(n,t,e,i)=>{n.stem.rotation.set(Math.sin(i*.8)*.04,0,Math.sin(i*.6)*.05),n.jaw.rotation.x=-(n.jawOpen??.15+Math.sin(i*1.3)*.08),n.petals.forEach((s,r)=>{s.rotation.x=-.35+Math.sin(i*1.2+r)*.08-(n.jawOpen||0)*.3}),n.vines.forEach((s,r)=>{s.rotation.x=Math.sin(i*1.4+r*1.7)*.25+(n.lash===r?-.9:0),s.rotation.z=Math.sin(i*1.1+r)*.2})};var Ke={rastejante:{skin:"skin_pale"},afogado:{skin:"skin_drowned"},cardo:{bark:"plant",petal:"petal",core:16760896},cardo_gelo:{bark:"plant_dark",petal:"ice",core:10479871,thorn:13625584},serpe:{scales:"scales",frill:"petal",eye:16764976},serpe_rubra:{scales:"scales_red",frill:"petal",eye:16724e3,belly:5913130},jelly:{emi:7012160,core:12123984},jelly_void:{emi:10109183,core:12615935},seer:{robe:"robe",mask:"porcelain",glow:12607743},seer_ice:{robe:"cloth_ice",mask:"ice",glow:8448255,skin:"ice"},seer_void:{robe:"crystal_void",mask:"porcelain",glow:10506495,skin:"crystal_void"},beetle:{shell:"carapace",hide:"hide",eye:16732192},beetle_ice:{shell:"carapace_ice",hide:"hide",eye:8446207,spikes:"ice",horn:10535120},beetle_magma:{shell:"obsidian",shellOpt:{emi:1.5},hide:"hide",eye:16752672},moth:{fur:"moth",wing:"#7a6a52",eyespot:"#c05030"},moth_snow:{fur:"cloth_white",wing:"#d8dce0",eyespot:"#5a8ab0"},beast_void:{hide:"hide",spike:"crystal_void",eye:12611839},beast_ice:{hide:"fur_white",spike:"ice",eye:8448255}};function Wp(n){let t=new kn(n);switch(n){case"rastejante":Cd(t,Ke.rastejante),t.root.scale.setScalar(1.15);break;case"afogado":Cd(t,Ke.afogado),t.root.scale.setScalar(1.2);break;case"cardo":kp(t,Ke.cardo);break;case"cardo_gelo":kp(t,Ke.cardo_gelo);break;case"serpe":Pd(t,Ke.serpe,1);break;case"serpezinha":Pd(t,Ke.serpe,.55);break;case"veshkara":Pd(t,Ke.serpe_rubra,2.7,!0);break;case"medusa":Bp(t,Ke.jelly);break;case"medusa_vazio":Bp(t,Ke.jelly_void);break;case"vidente":gh(t,Ke.seer);break;case"aparicao":gh(t,Ke.seer_ice,.95);break;case"ysra":gh(t,Ke.seer_ice,2.1,{crown:!0});break;case"arauto":gh(t,Ke.seer_void,2,{orbit:!0});break;case"couracado":Id(t,Ke.beetle);break;case"casco":Id(t,Ke.beetle_ice);break;case"couracado_magma":Id(t,Ke.beetle_magma);break;case"mariposa":Hp(t,Ke.moth);break;case"mariposa_neve":Hp(t,Ke.moth_snow);break;case"espreitador":Gp(t,Ke.beast_void);break;case"lobo_gelo":Gp(t,Ke.beast_ice,1.05);break;case"gorran":Vp(t,"gorran");break;case"colosso":Vp(t,"colosso");break;case"flor":nb(t);break;default:Cd(t,Ke.rastejante)}return t}function Xp(n,t,e,i,s){switch(n.anim){case"crawler":{let r=i?Math.max(0,1-i*5):e;n.body.rotation.x=-.75*r+(i?.25*Math.max(0,1-i*3):0),n.body.position.y+=.25*r;for(let a=0;a<2;a++)n.fl[a].rotation.x=-.55-1.4*r+(i?.8:0),n.fe[a].rotation.x=.3;n.jaw.rotation.x=.2+r*.5;break}case"plant":n.petalOpen=t==="shoot"?.3+Math.min(1,e)*.9:.3,t==="shoot"&&(n.stem.rotation.x=-.15*Math.min(1,e)+(i?.25:0));break;case"serpent":n.ext=i?Math.max(0,1-i*3):-.4*e,n.jawOpen=.1+e*.6;break;case"jelly":n.swell=e;break;case"seer":n.cast=t==="summon"?1:Math.min(1,e*1.3);break;case"beetle":n.lean=t==="charge"?.18:.12*e;break;case"moth":n.dive=i?Math.max(0,1-i*3):e*.3;break;case"beast":n.crouch=i?0:.2*e,n.jawOpen=.1+e*.5;break;default:return!1}return!0}function xh(n){n.petalOpen=.3,n.ext=0,n.jawOpen=void 0,n.swell=0,n.cast=0,n.lean=0,n.dive=0,n.crouch=0,n.lash=-1}var Dd=[[0,-.07],[.12,-.07],[.14,.03],[.148,.14],[.172,.27],[.188,.37],[.184,.44],[.16,.5],[.105,.545],[.055,.565],[0,.57]],sb=[[0,-.07],[.14,-.07],[.15,.03],[.13,.15],[.15,.28],[.165,.36],[.16,.44],[.14,.49],[.095,.53],[.05,.55],[0,.555]];function Bn(n,t,e){let i={},s=t.fem;i.hips=n.piv(null,"hips",0,t.legLen,0),n.ball(i.hips,e.legs,[0,.01,0],[s?.17:.155,.11,.11]);for(let r of[-1,1]){let a=r<0?"L":"R",o=i["leg"+a]=n.piv(i.hips,"leg"+a,r*t.hipX,-.02,0);n.mesh(o,Ee(t.thighR,t.thighR*.7,t.thigh),e.legs);let c=i["knee"+a]=n.piv(o,"knee"+a,0,-t.thigh,0);n.mesh(c,Ee(t.thighR*.7,t.shinR*.66,t.shin),e.legs),n.ball(c,e.legs,[0,0,.008],[t.thighR*.74,t.thighR*.74,t.thighR*.78]);let l=i["foot"+a]=n.piv(c,"foot"+a,0,-t.shin,0);n.ball(l,e.boots,[0,-.035,.045],[.052,.042,.115]),n.mesh(c,dt.cyl(1,.92,16),e.boots,[0,-t.shin+.09,.004],[t.shinR*.95,.2,t.shinR])}i.torso=n.piv(i.hips,"torso",0,.05,0),n.mesh(i.torso,ce(s?"torsoF":"torso",s?sb:Dd,24),e.top,[0,0,0],[t.bulk*.96,1,t.bulk*.7]),i.head=n.piv(i.torso,"head",0,t.torsoH,.01),n.mesh(i.head,dt.cyl(.9,1,14),e.skin,[0,.02,0],[.047,.1,.047]),t.noFace||rb(n,i.head,e,t);for(let r of[-1,1]){let a=r<0?"L":"R",o=i["arm"+a]=n.piv(i.torso,"arm"+a,r*t.shX,t.torsoH-.075,0);n.ball(o,e.top,[0,0,0],[.068*t.bulk,.066,.068]),n.mesh(o,Ee(t.armR,t.armR*.84,t.upper),e.arms);let c=i["elbow"+a]=n.piv(o,"elbow"+a,0,-t.upper,0);n.mesh(c,Ee(t.armR*.84,t.armR*.64,t.fore),e.fore||e.arms);let l=i["hand"+a]=n.piv(c,"hand"+a,0,-t.fore-.035,.005);n.ball(l,e.hands,[0,.005,0],[.036,.052,.027]),n.ball(l,e.hands,[-r*.028,.012,.018],[.014,.03,.014],[.4,0,r*.5])}return i}function rb(n,t,e,i){n.ball(t,e.skin,[0,.145,0],[.097,.117,.106]),n.ball(t,e.skin,[0,.085,.018],[.078,.06,.088]),n.mesh(t,dt.cone(10),e.skin,[0,.13,.103],[.017,.045,.02],[Math.PI/2+.25,0,0]);for(let s of[-1,1])n.ball(t,e.eye||q("eye"),[s*.035,.152,.087],[.013,.011,.01]),n.ball(t,e.brow||e.hair||e.skin,[s*.036,.172,.09],[.024,.007,.012],[0,0,s*-.15]),n.ball(t,e.skin,[s*.097,.14,-.005],[.014,.03,.022]);n.ball(t,q("plain",{color:8010292,rough:.5}),[0,.083,.098],[.022,.005,.008]),i.hair==="short"&&n.mesh(t,dt.hemiShell,e.hair,[0,.155,-.01],[.105,.126,.116],[-.45,0,0]),i.hair==="long"&&(n.mesh(t,dt.hemiShell,e.hair,[0,.155,-.01],[.107,.128,.117],[-.45,0,0]),n.mesh(t,Ee(.07,.05,.22),e.hair,[0,.16,-.06],[1.1,1,.7],[.15,0,0])),i.hair==="bun"&&(n.mesh(t,dt.hemiShell,e.hair,[0,.155,-.01],[.105,.127,.116],[-.45,0,0]),n.ball(t,e.hair,[0,.2,-.09],[.05,.05,.05])),i.beard&&(n.ball(t,e.hair,[0,.07,.035],[.082,i.beard==="long"?.085:.058,.08]),n.ball(t,e.hair,[0,.1,.09],[.04,.012,.015]))}function Ld(n,t,e,i,s,r,a){let o=new Ti(i,s,6,12);o.translate(0,-s/2,0);let c=n.piv(t,"cape",0,r,a),l=n.mesh(c,o,e,[0,0,0],1,[0,0,0],!0);return l.userData.ownGeo=!0,l.userData.cloth={w:i,h:s},l.castShadow=!0,c}function qp(n,t,e,i=0){for(let s of n.meshes){let r=s.userData.cloth;if(!r)continue;let a=s.geometry.attributes.position,o=s.userData.base;for(let c=0;c<a.count;c++){let l=o[c*3],h=o[c*3+1],u=-h/r.h,d=Math.pow(u,1.35),f=Math.sin(e*4.2+u*5+l*4)*.028*u*(.35+t);a.setXYZ(c,l*(.72+.28*u)+Math.sin(e*3+u*3)*.012*u,h*(1-.05*t),-d*(.05+t*.36+i)-f-Math.abs(l)*.12*(1-u))}a.needsUpdate=!0,s.geometry.computeVertexNormals()}}var $p={legLen:.9,thigh:.44,shin:.42,hipX:.095,torsoH:.56,shX:.225,upper:.29,fore:.26,thighR:.085,shinR:.066,armR:.058,bulk:1};function ab(n){let t=new kn("hero"),e=q("skin"),i=q("hair"),s,r={...$p},a;if(n==="couro"){s={skin:e,hair:i,legs:q("cloth_brown"),boots:q("leather_dark"),top:q("leather"),arms:q("cloth_brown"),fore:q("leather"),hands:q("leather_dark")},r.hair="short",r.beard="short",a=Bn(t,r,s),t.mesh(a.torso,dt.torus(.3,28),q("leather_dark"),[0,.02,0],[.15,.108,.3],[Math.PI/2,0,0]),t.mesh(a.torso,dt.rbox(.05,.04,.02,.008),q("gold"),[0,.02,.105]),t.mesh(a.torso,dt.torus(.45,24),q("cloth_green"),[0,.53,-.01],[.085,.07,.2],[Math.PI/2+.2,0,0]),t.mesh(a.torso,dt.cyl(1,1,14),q("leather_dark"),[.08,.33,-.15],[.055,.46,.055],[.2,0,-.5]);for(let o=0;o<5;o++)t.mesh(a.torso,dt.cone(6),q("cloth_white"),[.17+o%3*.018-.02,.6+o%2*.02,-.12+o%2*.02],[.012,.06,.004],[.2,0,-.5]);for(let o of[-1,1])t.mesh(a["arm"+(o<0?"L":"R")],dt.hemi,q("leather"),[0,.01,0],[.078,.06,.08],[0,0,o*.25])}else if(n==="malha")s={skin:e,hair:i,legs:q("chain"),boots:q("leather_dark"),top:q("chain"),arms:q("chain"),hands:q("leather_dark")},r.beard="short",a=Bn(t,r,s),t.mesh(a.torso,ce("surcoat",[[.155,-.08],[.2,-.3],[.235,-.44],[.24,-.45]],24),q("cloth_blue",{double:!0}),[0,.03,0],[1,1,.72]),t.mesh(a.torso,ce("tabard",Dd.slice(1,8).map(([o,c])=>[o+.012,c]),24),q("cloth_blue"),[0,0,.004],[.97,1,.73]),t.mesh(a.torso,Xr("lion",o=>{o.moveTo(0,.07),o.lineTo(.05,.03),o.lineTo(.035,-.06),o.lineTo(0,-.08),o.lineTo(-.035,-.06),o.lineTo(-.05,.03),o.lineTo(0,.07)},.01,.004),q("gold"),[0,.33,.132]),t.mesh(a.torso,dt.torus(.3,28),q("leather_dark"),[0,.02,0],[.155,.11,.3],[Math.PI/2,0,0]),t.mesh(a.head,dt.hemiShell,q("chain"),[0,.14,-.005],[.116,.13,.122],[-.5,0,0]),t.mesh(a.head,dt.cyl(.8,1.25,16,!0),q("chain",{double:!0}),[0,.03,-.005],[.085,.11,.09]),Ld(t,a.torso,q("cloth_blue",{double:!0}),.46,.95,.52,-.13);else if(n==="placas"){let o=q("steel"),c=q("steel_dark");s={skin:e,hair:i,legs:o,boots:o,top:o,arms:o,hands:c,fore:o},r.noFace=!0,a=Bn(t,r,s);for(let l=0;l<3;l++)t.mesh(a.torso,dt.torus(.18,28),c,[0,.06+l*.05,0],[.152+l*.004,.107,.12],[Math.PI/2,0,0]);t.mesh(a.hips,dt.cyl(.155,.2,20,!0),q("steel",{double:!0}),[0,-.1,0],[1,.17,.78]),t.mesh(a.head,ce("greathelm",[[0,.02],[.1,.02],[.112,.08],[.114,.17],[.108,.23],[.08,.27],[.03,.29],[0,.29]],24),o,[0,0,0],[1,1,1.06]),t.mesh(a.head,dt.rbox(.17,.014,.03,.006),q("dark"),[0,.165,.106]),t.mesh(a.head,dt.rbox(.014,.1,.03,.006),q("dark"),[0,.12,.112]),t.mesh(a.head,dt.rbox(.02,.2,.03,.008),q("gold"),[0,.19,.116]),t.mesh(a.head,be("plume",[[0,.28,0],[0,.36,-.04],[0,.39,-.14],[0,.34,-.26],[0,.26,-.32]],.035,.012,20,8),q("cloth_red"),[0,0,0]);for(let l of[-1,1]){let h=a["arm"+(l<0?"L":"R")];t.mesh(h,dt.hemi,o,[l*.012,.02,0],[.1,.085,.105],[0,0,l*.35]),t.mesh(h,dt.hemi,o,[l*.02,-.035,0],[.095,.07,.1],[0,0,l*.55]),t.mesh(h,dt.torus(.3,20),q("gold"),[l*.012,.018,0],[.098,.1,.08],[Math.PI/2,0,l*.35]),t.ball(a["elbow"+(l<0?"L":"R")],o,[0,0,-.01],[.06,.06,.066]),t.mesh(a["knee"+(l<0?"L":"R")],dt.hemi,o,[0,.01,.03],[.085,.07,.08],[Math.PI/2-.3,0,0])}Ld(t,a.torso,q("cloth_red",{double:!0}),.5,1,.52,-.14)}else if(n==="andarilho")s={skin:e,hair:i,legs:q("cloth_brown"),boots:q("leather_dark"),top:q("cloth_green"),arms:q("cloth_green"),fore:q("leather"),hands:q("leather_dark")},r.beard="short",r.hair="short",a=Bn(t,r,s),t.mesh(a.torso,ce("cloak",[[.2,.47],[.215,.3],[.23,.05],[.27,-.3],[.31,-.5],[.315,-.52]],24),q("cloth_green",{double:!0}),[0,0,-.02],[1,1,.78]),t.mesh(a.head,dt.hemiShell,q("cloth_green",{double:!0}),[0,.15,-.03],[.13,.15,.14],[-.75,0,0]),t.mesh(a.torso,dt.torus(.4,24),q("cloth_brown"),[0,.54,0],[.09,.08,.2],[Math.PI/2+.1,0,0]),t.mesh(a.torso,dt.torus(.3,28),q("leather_dark"),[0,.03,0],[.155,.11,.25],[Math.PI/2,0,0]);else{let o=q("obsidian",{emi:1.6});s={skin:e,hair:i,legs:o,boots:o,top:o,arms:o,hands:q("steel_dark")},r.noFace=!0,a=Bn(t,r,s),t.mesh(a.head,ce("obhelm",[[0,.02],[.098,.02],[.112,.1],[.11,.2],[.07,.27],[0,.28]],20),o,[0,0,0],[1,1,1.08]),t.mesh(a.head,dt.rbox(.13,.016,.03,.006),q("glow",{color:16738848,intensity:5}),[0,.165,.106]);for(let c of[-1,1]){t.mesh(a.head,be("horn"+c,[[c*.08,.22,0],[c*.16,.28,-.02],[c*.2,.37,-.06],[c*.19,.45,-.12]],.03,.004,16,8),q("bone",{color:5918792}),[0,0,0]);let l=a["arm"+(c<0?"L":"R")];t.mesh(l,dt.hemi,o,[c*.012,.02,0],[.105,.09,.11],[0,0,c*.35]);for(let h=0;h<3;h++)t.mesh(l,dt.cone(8),o,[c*(.03+h*.02),.08-h*.012,-.03+h*.03],[.02,.09,.02],[0,0,-c*(.4+h*.2)])}t.mesh(a.hips,dt.cyl(.155,.21,20,!0),q("obsidian",{emi:1.6,double:!0}),[0,-.1,0],[1,.18,.78]),Ld(t,a.torso,q("cloth_purple",{double:!0}),.5,1,.52,-.14)}return t.props={legLen:r.legLen,baseArm:0,look:n},t}function Nd(n="couro"){return $r.from(Yr("hero:"+n,()=>ab(n)))}function ob(n){let t=new kn("npc"),e={...$p},i,s;if(n==="mercadora")e.fem=!0,e.hair="bun",e.shX=.2,e.bulk=.9,e.armR=.05,e.thighR=.08,i={skin:q("skin_dark"),hair:q("hair"),legs:q("cloth_purple"),boots:q("leather_dark"),top:q("cloth_purple"),arms:q("cloth_white"),hands:q("skin_dark")},s=Bn(t,e,i),t.mesh(s.hips,ce("dress",[[.16,.05],[.19,-.2],[.25,-.55],[.3,-.86],[.3,-.88]],24),q("cloth_purple",{double:!0}),[0,0,0],[1,1,.85]),t.mesh(s.torso,dt.torus(.5,24),q("gold"),[0,.5,.02],[.1,.09,.08],[Math.PI/2+.3,0,0]),t.mesh(s.torso,dt.torus(.35,28),q("cloth_red"),[0,.04,0],[.15,.11,.3],[Math.PI/2,0,0]);else if(n==="ferreiro")e.bulk=1.18,e.shX=.25,e.armR=.07,e.beard="long",i={skin:q("skin"),hair:q("hair_grey"),legs:q("cloth_brown"),boots:q("leather_dark"),top:q("skin"),arms:q("skin"),hands:q("skin")},s=Bn(t,e,i),t.mesh(s.torso,ce("apron",Dd.slice(0,7).map(([r,a])=>[r+.014,a]).concat([[.12,.5]]),24),q("leather"),[0,0,.01],[1.14,1,.8]),t.mesh(s.hips,ce("apronLow",[[.16,0],[.18,-.3],[.19,-.5],[.19,-.52]],20),q("leather",{double:!0}),[0,0,.03],[1,1,.7]),t.props.tool="martelo";else if(n==="escriba")e.hair="short",e.beard="long",e.bulk=.92,i={skin:q("skin"),hair:q("hair_grey"),legs:q("cloth_white"),boots:q("leather_dark"),top:q("cloth_white"),arms:q("cloth_white"),hands:q("skin")},s=Bn(t,e,i),t.mesh(s.hips,ce("robeLow",[[.16,.05],[.2,-.3],[.26,-.86],[.26,-.88]],24),q("cloth_white",{double:!0}),[0,0,0],[1,1,.85]),t.mesh(s.torso,ce("stole",[[.19,.48],[.2,.2],[.21,-.1],[.21,-.12]],20,!0),q("cloth_blue",{double:!0}),[0,0,.02],[1,1,.75]),t.mesh(s.handL,dt.rbox(.16,.2,.04,.01),q("leather_dark"),[0,-.02,.05],1,[.3,0,0]);else{e.hair="short",e.beard="short",i={skin:q("skin"),hair:q("hair"),legs:q("rags"),boots:q("skin"),top:q("rags"),arms:q("skin"),hands:q("skin")},s=Bn(t,e,i);for(let r of["L","R"])t.mesh(s["hand"+r],dt.torus(.3,16),q("iron"),[0,.04,0],[.045,.045,.045],[Math.PI/2,0,0])}return Object.assign(t.props,{legLen:e.legLen,baseArm:0}),t}function Ud(n){let t=$r.from(Yr("npc:"+n,()=>ob(n)));if(t.tool){let e=Ao(t.tool);e.rotation.x=Math.PI/2,t.handR.add(e)}return t}function lb(n,t){let e=new kn("weapon"),i=e.root,s=q("steel"),r=q("leather_dark"),a=q("gold"),o=q("wood"),c=q("iron"),l=t?q("glow",{color:t,intensity:1.4}):s,h=(u,d=.018)=>{e.mesh(i,dt.cyl(1,1.06,12),r,[0,0,0],[d,u,d]);for(let f=0;f<4;f++)e.mesh(i,dt.torus(.35,12),r,[0,-u/2+(f+.5)*u/4,0],[d*1.05,d*1.05,d*1.05],[Math.PI/2,0,0])};if(n==="espada"||n==="adagas"){let u=n==="espada";h(u?.2:.12),e.ball(i,a,[0,u?-.125:-.08,0],u?.032:.024);let d=u?.17:.1;e.mesh(i,be("guard"+n,[[-d,u?.13:.09,.02],[-d*.4,u?.115:.075,0],[0,u?.11:.07,0],[d*.4,u?.115:.075,0],[d,u?.13:.09,.02]],.017,.017,16,8,!1),a);for(let f of[-1,1])e.ball(i,a,[f*d,u?.13:.09,.02],.022);e.mesh(i,u?dh("espada",.86,.074,.022):dh("adaga",.38,.062,.02,{leaf:!0}),l,[0,u?.12:.08,0])}else if(n==="machado")e.mesh(i,dt.cyl(.85,1,12),o,[0,.3,0],[.026,1,.026]),e.ball(i,c,[0,-.2,0],.032),e.mesh(i,Xr("axe",u=>{u.moveTo(.02,-.06),u.lineTo(.12,-.09),u.quadraticCurveTo(.24,-.16,.3,-.22),u.quadraticCurveTo(.36,0,.3,.22),u.quadraticCurveTo(.24,.16,.12,.09),u.lineTo(.02,.06),u.lineTo(.02,-.06)},.018,.01),l,[0,.68,0]),e.mesh(i,dt.cyl(1,1,14),c,[0,.68,0],[.04,.16,.04]),e.mesh(i,dt.cone(8),c,[-.09,.68,0],[.025,.12,.018],[0,0,Math.PI/2]);else if(n==="martelo"){e.mesh(i,dt.cyl(.85,1,12),o,[0,.35,0],[.03,1.1,.03]),e.mesh(i,dt.cyl(1,1,22),c,[0,.9,0],[.1,.36,.1],[0,0,Math.PI/2]);for(let u of[-1,1])e.mesh(i,dt.torus(.18,22),a,[u*.14,.9,0],[.1,.1,.1],[0,Math.PI/2,0]),e.mesh(i,dt.cyl(1,1,22),c,[u*.19,.9,0],[.108,.02,.108],[0,0,Math.PI/2]);e.mesh(i,dt.cone(10),c,[0,1.08,0],[.035,.16,.035])}else if(n==="lanca")e.mesh(i,dt.cyl(.9,1,10),o,[0,.45,0],[.022,1.8,.022]),e.mesh(i,dh("lanca",.34,.1,.022,{leaf:!0}),l,[0,1.34,0]),e.mesh(i,dt.cyl(.8,1,12),a,[0,1.32,0],[.032,.07,.032]),e.mesh(i,dt.cone(8),q("cloth_red"),[0,1.24,0],[.04,.12,.04],[Math.PI,0,0]);else if(n==="cajado"){e.mesh(i,be("staff",[[0,-.4,0],[.02,.2,.01],[-.02,.7,-.01],[.01,1.1,0],[.06,1.3,0]],.03,.022,30,8),o),e.ball(i,q("glow",{color:t||11555071,intensity:5}),[.03,1.42,0],.09);for(let u=0;u<3;u++){let d=u*2.1;e.mesh(i,be("prong"+u,[[.05,1.28,0],[.05+Math.cos(d)*.09,1.4,Math.sin(d)*.09],[.03+Math.cos(d)*.06,1.52,Math.sin(d)*.06]],.014,.004,10,6),o)}}return e}function Ao(n,t=null){return Yr(`w:${n}:${t}`,()=>lb(n,t)).root.clone(!0)}function cb(n){let t=new kn("bow"),e=t.root,i=q("wood"),s=q("plain",{color:14209216,rough:.8});return n?(t.mesh(e,dt.rbox(.07,.08,.62,.025),i,[0,0,.1]),t.mesh(e,be("prod",[[-.34,0,.26],[-.18,0,.34],[0,0,.36],[.18,0,.34],[.34,0,.26]],.02,.02,20,8,!1),q("iron")),t.mesh(e,dt.cyl(1,1,6),s,[0,0,.26],[.004,.68,.004],[0,0,Math.PI/2]),t.mesh(e,dt.rbox(.05,.1,.06,.015),q("iron"),[0,-.07,.02])):(t.mesh(e,be("bowlimbs",[[0,-.46,-.1],[0,-.32,-.01],[0,-.1,.03],[0,.1,.03],[0,.32,-.01],[0,.46,-.1]],.016,.016,30,8,!1),i),t.mesh(e,dt.cyl(1,1,12),q("leather_dark"),[0,0,.03],[.022,.14,.022]),t.mesh(e,dt.cyl(1,1,6),s,[0,0,-.1],[.0035,.92,.0035])),t}function Fd(n=!1){return Yr("bow:"+n,()=>cb(n)).root.clone(!0)}function zd(n,t,e){n.weapon&&n.handR.remove(n.weapon),n.weapon2&&(n.handL.remove(n.weapon2),n.weapon2=null),n.weaponKind=t,n.weaponGlow=e,n.weapon=Ao(t,e),n.weapon.rotation.x=Math.PI/2,n.handR.add(n.weapon),t==="adagas"&&(n.weapon2=Ao("adagas",e),n.weapon2.rotation.x=Math.PI/2,n.handL.add(n.weapon2))}function Od(n,t){n.bow&&n.handL.remove(n.bow),n.bowCross=t,n.bow=Fd(t),n.bow.visible=!1,n.handL.add(n.bow)}function Ro(n,t=3832789){let e=n.silMat||new He({color:t,depthFunc:lr,depthWrite:!1});n.silMat=e,n.root.traverse(i=>{if(!i.isMesh||i.userData.sil||i.children.some(r=>r.userData.sil))return;let s=new Pt(i.geometry,e);s.renderOrder=1,s.userData.sil=!0,s.raycast=()=>{},s.layers.set(1),i.add(s),i.renderOrder=2})}function Yp(n){return $r.from(Yr("c:"+n,()=>Wp(n)))}function hb(n,t,e,i){let s=Math.sin(t),r=Math.cos(t);n.legL.rotation.set(s*.62*e,0,-.02),n.legR.rotation.set(-s*.62*e,0,.02),n.kneeL.rotation.set(.06+Math.max(0,-r)*1.1*e,0,0),n.kneeR.rotation.set(.06+Math.max(0,r)*1.1*e,0,0),n.footL.rotation.x=-(n.legL.rotation.x+n.kneeL.rotation.x)*.55,n.footR.rotation.x=-(n.legR.rotation.x+n.kneeR.rotation.x)*.55;let a=Math.sin(i*1.7);n.armL.rotation.set((n.baseArm||0)-s*.45*e,0,-.08-a*.012*(1-e)),n.armR.rotation.set((n.baseArm||0)+s*.45*e,0,.08+a*.012*(1-e)),n.armL.position.z=0,n.armR.position.z=0,n.elbowL.rotation.set(-(.18+Math.max(0,s)*.5*e),0,0),n.elbowR.rotation.set(-(.18+Math.max(0,-s)*.5*e),0,0),n.hips.position.set(0,n.legLen-.015+Math.abs(r)*.035*e-.015*e,0),n.hips.rotation.set(0,s*.09*e,0),n.torso.rotation.set(.05*e+a*.012*(1-e),-s*.15*e,0),n.head.rotation.set(-.03*e,s*.08*e,0)}Gi.humanoid=hb;function hn(n,t,e,i){let s=Gi[n.anim||"humanoid"];s&&s(n,t,e,i)}var Li={comum:{name:"Comum",color:"#cfc8b8",hex:13617336,mult:1,affixes:0},raro:{name:"Raro",color:"#4fb3ff",hex:4169983,mult:1.25,affixes:1},unico:{name:"\xDAnico",color:"#ffb92e",hex:16752670,mult:1.55,affixes:2}},Fs={espada:{name:"Espada",dmg:11,cd:.42,range:2,arc:2,combo:3},machado:{name:"Machado",dmg:18,cd:.66,range:2.1,arc:2.3,combo:2},adagas:{name:"Adagas G\xEAmeas",dmg:6.5,cd:.24,range:1.7,arc:1.6,combo:4},martelo:{name:"Martelo de Guerra",dmg:30,cd:1,range:2.4,arc:2.9,combo:1,knock:2.5},lanca:{name:"Lan\xE7a",dmg:14,cd:.55,range:3.1,arc:.9,combo:2}},Co={arco:{name:"Arco Curto",dmg:9,cd:.38,speed:24,pierce:0},arcolongo:{name:"Arco Longo",dmg:17,cd:.78,speed:30,pierce:1},besta:{name:"Besta Pesada",dmg:25,cd:1.1,speed:34,pierce:2}},Zr={couro:{name:"Gib\xE3o de Couro",hp:10,dr:.05,speed:.05,look:"couro"},malha:{name:"Cota de Malha",hp:25,dr:.12,speed:0,look:"malha"},placas:{name:"Armadura de Placas",hp:45,dr:.2,speed:-.06,look:"placas"},andarilho:{name:"Manto do Andarilho",hp:15,dr:.06,speed:.1,look:"andarilho"},obsidiana:{name:"Coura\xE7a de Obsidiana",hp:35,dr:.17,speed:-.02,look:"obsidiana"}},Jr={chamas:{name:"Tomo das Chamas",cd:12,desc:"Libera um anel de fogo que queima os inimigos pr\xF3ximos.",color:"#ff7a2e"},raio:{name:"Rel\xE2mpago Engarrafado",cd:10,desc:"Um raio salta entre at\xE9 6 inimigos.",color:"#8fd8ff"},estandarte:{name:"Estandarte de Guerra",cd:24,desc:"Finca um estandarte: +40% de dano e cura cont\xEDnua na \xE1rea.",color:"#ff4a4a"},vendaval:{name:"Chifre do Vendaval",cd:8,desc:"Empurra e atordoa todos os inimigos ao redor.",color:"#c8e8d0"},laminas:{name:"L\xE2minas Espectrais",cd:18,desc:"Tr\xEAs l\xE2minas fantasmas giram ao seu redor por 8 s.",color:"#9a8cff"},gelo:{name:"Totem G\xE9lido",cd:16,desc:"Congela os inimigos pr\xF3ximos por 3 segundos.",color:"#8ff0ff"}},kd={melee:[["chamas","Chamejante","Golpes incendeiam o alvo"],["vampiro","Vamp\xEDrico|Vamp\xEDrica","Cada golpe recupera vida"],["critico","Afiado|Afiada","+15% de chance de cr\xEDtico"],["veloz","Ligeiro|Ligeira","Ataques 20% mais r\xE1pidos"],["trovao","do Trov\xE3o","20% de chance de lan\xE7ar um raio"]],bow:[["multi","Tr\xEDplice","Dispara tr\xEAs flechas em leque"],["perfura","Perfurante","Flechas atravessam +2 inimigos"],["explosiva","Explosivo|Explosiva","Flechas explodem ao acertar"],["chamas","\xCDgneo|\xCDgnea","Flechas incendeiam o alvo"]],armor:[["espinhos","de Espinhos","Devolve 40% do dano corpo a corpo"],["regen","Restaurador|Restauradora","Regenera 1,5 de vida por segundo"],["agil","\xC1gil","Rolamento recarrega 40% mais r\xE1pido"],["guarda","Guardi\xE3o|Guardi\xE3","+6% de redu\xE7\xE3o de dano"]],artifact:[["poder","Potente","+35% de poder"],["recarga","Veloz","Recarga 25% menor"]]},Zp={espada:["L\xE2mina do Crep\xFAsculo","Presa de Valdor","Juramento Partido"],machado:["Machado do Carrasco","Racha-Ossos","F\xFAria do Norte"],adagas:["Garras da V\xEDbora","Sussurros G\xEAmeos","Ferroada Noturna"],martelo:["Martelo do Trov\xE3o","Quebra-Montanhas","Sino do Ju\xEDzo"],lanca:["Lan\xE7a do Alvorecer","Presa do Drag\xE3o","Vigia Eterna"],arco:["Arco Sussurrante","Corda do Vento","Asa de Corvo"],arcolongo:["Arco das Estrelas","Longa Vig\xEDlia","Arco do Ca\xE7ador P\xE1lido"],besta:["Besta do Inquisidor","Punho de Ferro","Vi\xFAva Negra"],couro:["Pele do Lobo Sombrio","Gib\xE3o do Ladino"],malha:["Cota do Cruzado","Malha de Mithral"],placas:["\xC9gide R\xFAnica","Basti\xE3o de Valdor"],andarilho:["Manto do Viajante Eterno","V\xE9u da N\xE9voa"],obsidiana:["Cora\xE7\xE3o da Forja","Carapa\xE7a do Vulc\xE3o"]};function ub(n,t=0){let e=n.next();return e<.05+t*.15?"unico":e<.3+t*.3?"raro":"comum"}function zs(n,t,e={}){let i=e.cat||n.weighted([["melee",4],["bow",2],["armor",3],["artifact",2]]),s=e.rarity||ub(n,e.bonus||0),r=Li[s],a=(1+.32*(t-1))*n.range(.92,1.1)*r.mult,o={melee:Fs,bow:Co,armor:Zr,artifact:Jr}[i],c=e.kind||n.pick(Object.keys(o)),l=o[c],h=[],u=[...kd[i]];for(let f=0;f<r.affixes&&u.length;f++)h.push(u.splice(Math.floor(n.next()*u.length),1)[0][0]);let d={id:Math.floor(n.next()*1e9),cat:i,kind:c,rarity:s,pw:a,affixes:h,floor:t};return i==="melee"&&(d.dmg=Math.round(l.dmg*a*10)/10),i==="bow"&&(d.dmg=Math.round(l.dmg*a*10)/10),i==="armor"&&(d.hp=Math.round(l.hp*a),d.dr=Math.min(.45,l.dr*(.9+.1*a)+(h.includes("guarda")?.06:0))),i==="artifact"&&(d.power=a*(h.includes("poder")?1.35:1)),d.up=0,d.baseName=db(d,n),d.name=d.baseName,d}var Po=5;function Jp(n){if((n.up||0)>=Po)return!1;n.up=(n.up||0)+1;let t=(1+.12*n.up)/(1+.12*(n.up-1));return n.dmg&&(n.dmg=Math.round(n.dmg*t*10)/10),n.hp&&(n.hp=Math.round(n.hp*t)),n.dr&&(n.dr=Math.min(.5,n.dr+.01)),n.power&&(n.power*=t),n.name=(n.baseName||n.name.replace(/ \+\d$/,""))+" +"+n.up,!0}function vh(n){return Math.round((45+30*(n.floor||1))*(1+(n.up||0))*Li[n.rarity].mult)}function Kr(n){return Math.round({comum:45,raro:120,unico:280}[n.rarity]*(1+.35*((n.floor||1)-1))*(1+.2*(n.up||0)))}function Io(n){return Math.max(3,Math.round(Kr(n)*.35))}function db(n,t){let e={melee:Fs,bow:Co,armor:Zr,artifact:Jr}[n.cat][n.kind].name;if(n.rarity==="unico"&&Zp[n.kind])return t.pick(Zp[n.kind]);if(n.rarity==="raro"&&n.affixes.length){let i=kd[n.cat].find(c=>c[0]===n.affixes[0]);if(n.cat==="artifact")return e+" ("+i[1]+")";let[s,r]=i[1].includes("|")?i[1].split("|"):[i[1],i[1]],o=/^(Espada|Lança|Cota|Armadura|Couraça|Besta|Adagas)/.test(e)?r:s;return e.startsWith("Adagas")&&!o.startsWith("d")&&(o+="s"),e+" "+o}return e}function un(n){return n.cat==="melee"?Fs[n.kind].cd*(n.affixes.includes("veloz")?.8:1):n.cat==="bow"?Co[n.kind].cd:n.cat==="artifact"?Jr[n.kind].cd*(n.affixes.includes("recarga")?.75:1):0}function Lo(n){return n.affixes.map(t=>kd[n.cat].find(e=>e[0]===t)[2])}function Do(n){let t=[];if(n.up&&t.push(["Aprimoramento","+"+n.up]),n.cat==="melee"){let e=Fs[n.kind];t.push(["Dano",n.dmg.toFixed(1)],["Velocidade",(1/un(n)).toFixed(1)+"/s"],["Alcance",e.range.toFixed(1)])}else if(n.cat==="bow")t.push(["Dano",n.dmg.toFixed(1)],["Velocidade",(1/un(n)).toFixed(1)+"/s"]);else if(n.cat==="armor"){let e=Zr[n.kind];t.push(["Vida","+"+n.hp],["Prote\xE7\xE3o",Math.round(n.dr*100)+"%"]),e.speed&&t.push(["Movimento",(e.speed>0?"+":"")+Math.round(e.speed*100)+"%"])}else t.push(["Poder",Math.round(n.power*100)+"%"],["Recarga",un(n).toFixed(0)+" s"]);return t}function wn(n){return n?n.cat==="melee"||n.cat==="bow"?n.dmg/un(n)*(1+n.affixes.length*.12):n.cat==="armor"?n.hp+n.dr*200+n.affixes.length*8:n.power*10+n.affixes.length*3:0}function yh(n){return{melee:"Arma corpo a corpo",bow:"Arma \xE0 dist\xE2ncia",armor:"Armadura",artifact:"Artefato"}[n]}var Kp=null,fb=()=>Kp||(Kp=Pp()),Bd=(n,t,e,i)=>{let s=new Pt(dt.rbox(n,t,e,Math.min(n,t,e)*.2),i);return s.castShadow=!0,s.receiveShadow=!0,s},ve=(n,t)=>{let e=new Pt(n,t);return e.castShadow=!0,e.receiveShadow=!0,e},dn=(n,t)=>q(n,t),Mh=class{constructor(t,e,i,s){this.game=t,this.x=e,this.z=i,this.big=s,this.opened=!1,this.t=0;let r=fi(),a=new xe,o=s?1.15:.9,c=s?r.gold:r.iron,l=ve(dt.rbox(.9,.48,.6,.05),r.wood);l.position.y=.24,a.add(l);for(let d of[-.42,.42]){let f=ve(dt.rbox(.07,.5,.63,.02),c);f.position.set(d,.25,0),a.add(f)}this.lid=new xe,this.lid.position.set(0,.48,-.3),a.add(this.lid);let h=ve(new Ge(.3,.3,.9,16,1,!1,0,Math.PI),r.wood);h.rotation.z=Math.PI/2,h.rotation.y=Math.PI/2,h.position.set(0,0,.3),h.scale.set(1,1,.55),this.lid.add(h);for(let d of[-.42,.42]){let f=ve(new Fi(.3,.025,6,16,Math.PI),c);f.rotation.y=Math.PI/2,f.position.set(d,0,.3),f.scale.set(1,.55,1),this.lid.add(f)}let u=ve(dt.rbox(.12,.14,.05,.02),r.gold);u.position.set(0,.46,.31),a.add(u),a.scale.setScalar(o),a.position.set(e,t.floorAt(e,i),i),a.rotation.y=Math.PI/4+(Math.random()-.5)*.4,this.mesh=a,t.scene.add(a),this.glow=t.addLight(e,a.position.y+.9,i,16760928,0,3)}get prompt(){return this.opened?null:"Abrir ba\xFA"}interact(){if(this.opened)return;this.opened=!0,this.t=0;let t=this.game;t.audio.play("chest");let e=this.big?22+Math.floor(Math.random()*12):8+Math.floor(Math.random()*8);t.spawnGold(this.x,this.z,e,3),t.dropItem(this.x,this.z,{bonus:this.big?.7:.25}),this.big&&t.dropItem(this.x,this.z,{bonus:.3}),Math.random()<.6&&t.spawnLoot("arrows",this.x,this.z),this.glow.intensity=4,t.onChestOpened(this)}update(t){this.opened&&this.t<1&&(this.t+=t*2,this.lid.rotation.x=-1.9*Math.min(1,this.t)*(1+Math.sin(Math.min(1,this.t)*Math.PI)*.15),this.game.particles.sparks(this.x,this.mesh.position.y+.7,this.z,2,[1,.85,.4],3)),this.opened&&(this.glow.intensity=Math.max(0,this.glow.intensity-t*1.5))}},pb=new Qn([[0,0],[.16,0],[.24,.1],[.27,.25],[.22,.42],[.12,.5],[.13,.58],[.16,.6],[0,.6]].map(n=>new ot(n[0],n[1])),16),Sh=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.dead=!1,this.r=.3;let s=fi();this.mesh=new Pt(pb,Math.random()<.5?s.clay:s.clay2),this.mesh.castShadow=!0,this.mesh.receiveShadow=!0;let r=.8+Math.random()*.5;this.mesh.scale.setScalar(r),this.mesh.position.set(e,t.floorAt(e,i),i),t.scene.add(this.mesh)}smash(){if(this.dead)return;this.dead=!0;let t=this.game;t.scene.remove(this.mesh),t.audio.play("pot"),t.particles.blood(this.x,this.mesh.position.y+.3,this.z,12,[.45,.25,.15]),t.particles.dust(this.x,this.mesh.position.y+.2,this.z,6);let e=Math.random();e<.45?t.spawnGold(this.x,this.z,1+Math.floor(Math.random()*4),1.5):e<.62?t.spawnLoot("arrows",this.x,this.z):e<.72&&t.spawnLoot("heart",this.x,this.z);let i=t.dg.idx(Math.floor(this.x),Math.floor(this.z));t.dg.solid[i]===2&&(t.dg.solid[i]=0)}},jp={catacumbas:[16747066,16765088],minas:[16747066,16765088],forja:[16738848,16760960],geleira:[7395583,12644607],pantano:[7405408,12648352],vazio:[11559167,14729471]},wh=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.lit=!1,this.t=0;let s=fi(),r=t.dg.themeKey,[a,o]=jp[r]||jp.catacumbas;this.col=a;let c=new xe;if(r==="geleira"||r==="vazio"){let h=r==="geleira"?s.ice:s.crystalV;c.add(ve(ce("bzped",[[0,0],[.55,0],[.5,.2],[.3,.35],[.3,.6],[.45,.7],[0,.72]],16),r==="geleira"?s.rock:s.basalt));let u=ve(new vi(.4,0),h);u.scale.set(.8,1.6,.8),u.position.y=1.5,c.add(u),this.spin=u,this.coal=u}else if(r==="pantano"){let h=ve(be("totem",[[0,0,0],[.05,.6,0],[-.03,1.2,.02],[0,1.7,0]],.28,.2,12,10),s.log);c.add(h);for(let d=0;d<3;d++){let f=ve(new Fi(.26,.03,6,16),s.rune);f.rotation.x=Math.PI/2,f.position.y=.5+d*.4,c.add(f)}let u=ve(new li(.2,12,10),s.bone);u.scale.set(1,1.2,.6),u.position.set(0,1.35,.18),c.add(u),this.coal=u}else{c.add(ve(ce("bzped2",[[0,0],[.5,0],[.48,.12],[.3,.25],[.24,.7],[.34,.85],[.3,.9],[0,.9]],18),s.stone));let h=ve(ce("bzbowl",[[.1,0],[.34,.02],[.55,.26],[.58,.34],[.5,.3],[.3,.1],[0,.08]],18),s.iron);h.position.y=.88,c.add(h);let u=ve(new Ge(.48,.48,.05,16),dn("glow",{color:4198405,intensity:.4}));u.position.y=1.12,c.add(u),this.coal=u}let l=new Pt(new bn(.9,1.1,40),new He({color:a,transparent:!0,opacity:.35,blending:Xe,depthWrite:!1}));l.rotation.x=-Math.PI/2,l.position.y=.03,c.add(l),this.rune=l,c.position.set(e,t.floorAt(e,i),i),this.mesh=c,t.scene.add(c),this.flame=Us(3.2,o),this.flame.position.set(e,c.position.y+1.8,i),this.flame.visible=!1,t.scene.add(this.flame),this.light=t.addLight(e,c.position.y+2,i,a,0,14,1,!0)}get prompt(){let t=this.game.theme.obj;return this.lit?null:`${t.verb} o ${t.noun}`}interact(){if(this.lit)return;this.lit=!0,this.t=0,this.flame.visible=!0,this.coal.material.emissiveIntensity!==void 0&&(this.coal.material=this.coal.material.clone(),this.coal.material.emissive=new Nt(this.col),this.coal.material.emissiveIntensity=4),this.game.audio.play("brazier");let t=new Nt(this.col);this.game.particles.burst(this.x,this.mesh.position.y+1.3,this.z,60,[t.r,t.g,t.b],6,.9,.4),this.game.onBrazierLit(this)}update(t,e){this.rune.material.opacity=this.lit?.7:.25+Math.sin(e*2)*.1,this.spin&&(this.spin.rotation.y+=t*(this.lit?2:.4),this.spin.position.y=1.5+Math.sin(e*1.5)*.08);let i=new Nt(this.col);if(!this.lit){Math.random()<t*4&&this.game.particles.ember(this.x+(Math.random()-.5)*.6,this.mesh.position.y+1.15,this.z+(Math.random()-.5)*.6,[i.r,i.g,i.b]);return}this.t+=t,this.light.intensity=Math.min(30,this.t*40)*(.9+Math.sin(e*13)*.05+Math.sin(e*7.3)*.05);let s=1+Math.sin(e*17)*.06;this.flame.scale.set(1.1*s,1.9/s,1),Math.random()<t*30&&this.game.particles.fire(this.x,this.mesh.position.y+1.2,this.z,1,.7,[i.r,i.g,i.b],.8),Math.random()<t*8&&this.game.particles.ember(this.x,this.mesh.position.y+1.6,this.z,[i.r,i.g,i.b])}},Th=class{constructor(t,e){this.game=t,this.cells=e,this.closed=!0,this.h=0,this.target=0;let i=fi();this.group=new xe;let s=new Ge(.045,.045,3,6),r=new Set(e.map(a=>a.x+","+a.z));for(let a of e){let o=new xe,c=r.has(a.x+1+","+a.z)||r.has(a.x-1+","+a.z);for(let u=0;u<4;u++){let d=new Pt(s,i.iron);d.castShadow=!0;let f=-.375+u*.25;c?d.position.set(f,1.5,0):d.position.set(0,1.5,f),o.add(d)}let l=Bd(c?1:.08,.1,c?.08:1,i.iron);l.position.y=2.2,o.add(l);let h=Bd(c?1:.08,.1,c?.08:1,i.iron);h.position.y=.6,o.add(h),o.position.set(a.x+.5,t.floorAt(a.x+.5,a.z+.5),a.z+.5),this.group.add(o)}t.scene.add(this.group),this.key=new Set(e.map(a=>t.dg.idx(a.x,a.z)))}blocks(t){return this.closed&&this.key.has(t)}open(){this.closed&&(this.closed=!1,this.target=-3.1,this.game.audio.play("gate"),this.game.shake(.3))}close(){this.closed||(this.closed=!0,this.target=0,this.game.audio.play("gate"),this.game.shake(.4))}update(t){let e=this.h;if(this.h+=Math.sign(this.target-this.h)*Math.min(Math.abs(this.target-this.h),t*2.2),this.group.position.y=this.h,Math.abs(e-this.h)>.001&&Math.random()<.5){let i=this.cells[Math.floor(Math.random()*this.cells.length)];this.game.particles.dust(i.x+.5,this.game.floorAt(i.x+.5,i.z+.5),i.z+.5,2)}}},mb="varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }",gb=`
uniform float t; uniform float hue; varying vec2 vUv;
void main(){
  vec2 p = vUv*2.0-1.0; float r = length(p); if (r>1.0) discard;
  float a = atan(p.y,p.x);
  float s = sin(a*5.0 + r*12.0 - t*3.0)*0.5+0.5;
  float s2 = sin(a*3.0 - r*20.0 + t*2.0)*0.5+0.5;
  vec3 c = mix(vec3(0.25,0.05,0.6), mix(vec3(0.3,0.9,1.0), vec3(1.0,0.45,0.9), hue), s*s2);
  c += vec3(1.0)*pow(1.0-r,4.0);
  float alpha = smoothstep(1.0,0.8,r);
  gl_FragColor = vec4(c*1.6, alpha);
}`,jr=class{constructor(t,e,i,s="exit",r="Entrar no portal"){this.game=t,this.x=e,this.z=i,this.t=0,this.kind=s,this.label=r;let a=new xe,o=t.floorAt(e,i);this.uni={t:{value:0},hue:{value:0}};let c=new Pt(new on(1.2,48),new ze({uniforms:this.uni,vertexShader:mb,fragmentShader:gb,transparent:!0,side:Re,depthWrite:!1}));c.position.y=1.5,a.add(c),this.disc=c;let l=fi(),h=new Pt(new Fi(1.3,.16,12,40),l.stone);h.position.y=1.5,h.castShadow=!0,a.add(h);for(let d=0;d<12;d++){let f=d/12*Math.PI*2,p=ve(dt.rbox(.32,.26,.4,.06),l.rock);p.position.set(Math.cos(f)*1.32,1.5+Math.sin(f)*1.32,0),p.rotation.z=f,a.add(p)}for(let d=0;d<8;d++){let f=d/8*Math.PI*2,p=new Pt(new vi(.1),dn("glow",{color:7397631,intensity:4}));p.position.set(Math.cos(f)*1.3,1.5+Math.sin(f)*1.3,.12),a.add(p)}let u=Bd(2.8,.22,.9,l.stone);u.position.y=.11,a.add(u),a.position.set(e,o,i),a.rotation.y=Math.PI/4,this.mesh=a,t.scene.add(a),this.light=t.addLight(e,o+1.5,i,s==="dim"?11563263:7385343,20,12,.2,!0),s==="dim"&&(this.uni.hue.value=1)}get prompt(){return this.label}interact(){this.game.usePortal(this)}update(t){this.t+=t,this.uni.t.value=this.t;let e=Math.min(1,this.t*1.5);if(this.mesh.scale.setScalar(e),Math.random()<t*25){let i=Math.random()*Math.PI*2;this.game.particles.add.emit(this.x+Math.cos(i)*1.3*.7,this.mesh.position.y+1.5+Math.sin(i)*1.3,this.z-Math.cos(i)*1.3*.7,0,.5,0,1,.2,.02,.4,.8,1,1,0,0)}}},Eh=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.uses=0,this.price=50+25*t.floorNum;let s=fi(),r=new xe;r.add(ve(ce("altar",[[0,0],[.62,0],[.6,.12],[.42,.25],[.36,.8],[.6,.92],[.64,1],[0,1]],20),s.stone));let a=ve(ce("altarbowl",[[.05,0],[.2,.02],[.32,.14],[.34,.2],[.28,.17],[0,.1]],18),s.gold);a.position.y=1,r.add(a),this.orb=new Pt(new vi(.16),dn("glow",{color:16760896,intensity:5})),this.orb.position.y=1.55,r.add(this.orb),r.position.set(e,t.floorAt(e,i),i),r.rotation.y=Math.PI/4,this.mesh=r,t.scene.add(r),t.addLight(e,r.position.y+1.7,i,16760928,6,6,.3)}get prompt(){return`Oferenda: ${this.price} de ouro por um item`}interact(){let t=this.game,e=t.player;if(e.gold<this.price){t.audio.play("deny"),t.ui.toast("Ouro insuficiente para a oferenda.");return}e.gold-=this.price,this.uses++,t.audio.play("chest"),t.particles.burst(this.x,this.mesh.position.y+1.5,this.z,40,[1,.8,.3],4,.8,.3),t.dropItem(this.x,this.z,{bonus:.6}),this.price=Math.round(this.price*1.5)}update(t,e){this.orb.rotation.y+=t*2,this.orb.position.y=1.55+Math.sin(e*2)*.08}},_h={coin:new Ge(.1,.1,.03,16),heart:new li(.15,16,12),frag:new vi(.2,0),beam:new Ge(.1,.25,5,10,1,!0)},bh=null;function xb(){if(bh)return bh;let n=document.createElement("canvas");n.width=4,n.height=64;let t=n.getContext("2d"),e=t.createLinearGradient(0,0,0,64);return e.addColorStop(0,"rgba(255,255,255,0)"),e.addColorStop(.7,"rgba(255,255,255,0.5)"),e.addColorStop(1,"rgba(255,255,255,1)"),t.fillStyle=e,t.fillRect(0,0,4,64),bh=new ui(n),bh}function vb(n){let t=new xe,e=n.affixes.includes("chamas")?16738848:n.affixes.includes("trovao")?8442111:null;if(n.cat==="melee"){let i=Ao(n.kind,n.rarity==="unico"?e:null);i.rotation.z=.6,i.position.y=-.3,t.add(i),t.scale.setScalar(.9)}else if(n.cat==="bow"){let i=Fd(n.kind==="besta");i.rotation.z=.3,t.add(i)}else if(n.cat==="armor"){let i={couro:"leather",malha:"chain",placas:"steel",andarilho:"cloth_green",obsidiana:"obsidian"}[n.kind],s=dn(i);t.add(ve(ce("itemtorso",[[0,-.28],[.2,-.28],[.22,-.05],[.26,.15],[.24,.26],[.1,.3],[0,.3]],16),s));for(let r of[-1,1]){let a=ve(dt.hemi(),s);a.scale.set(.13,.1,.14),a.position.set(r*.26,.22,0),a.rotation.z=r*.4,t.add(a)}t.children[0].scale.z=.6}else{let i={chamas:16738848,raio:8442111,estandarte:16724016,vendaval:12648400,laminas:10128639,gelo:9433343}[n.kind],s=dn("glow",{color:i,intensity:4});if(n.kind==="raio"){t.add(ve(ce("bottle",[[0,0],[.14,0],[.18,.12],[.16,.26],[.06,.34],[.05,.44],[0,.44]],16),new Ri({color:11196671,roughness:.05,transparent:!0,opacity:.45,clearcoat:1})));let r=ve(new li(.1,12,10),s);r.position.y=.14,t.add(r),t.position.y=-.2}else if(n.kind==="vendaval")t.add(ve(be("horn",[[0,-.2,0],[.12,0,0],[.1,.2,.05],[-.05,.3,.1]],.12,.03,16,10),dn("bone")));else if(n.kind==="gelo"){let r=ve(new vi(.2,0),dn("ice"));r.scale.set(.7,1.4,.7),t.add(r)}else{t.add(ve(dt.rbox(.34,.44,.1,.03),dn("leather")));let r=ve(dt.rbox(.3,.4,.11,.02),dn("bone",{color:15788240}));r.position.x=.015,t.add(r);let a=ve(new vi(.1),s);a.position.z=.08,t.add(a)}}return t}var Ah=class{constructor(t,e,i,s,r){this.game=t,this.kind=e,this.x=i,this.z=s,this.data=r,this.y=t.floorAt(i,s)+.6,this.vy=3+Math.random()*2;let a=Math.random()*Math.PI*2,o=e==="item"?1.2:1+Math.random()*2.5;this.vx=Math.cos(a)*o,this.vz=Math.sin(a)*o,this.t=0,this.dead=!1,this.grounded=!1;let c=fi();if(e==="gold")this.mesh=new Pt(_h.coin,c.gold),this.mesh.rotation.x=Math.PI/2;else if(e==="heart")this.mesh=new Pt(_h.heart,dn("glow",{color:16722490,intensity:3}));else if(e==="fragment")this.mesh=new Pt(_h.frag,c.crystalV),this.mesh.scale.set(.8,1.4,.8),this.light=t.addLight(i,this.y,s,11563263,4,4,.2);else if(e==="arrows"){this.mesh=new xe;for(let h=0;h<5;h++){let u=ve(new Ge(.014,.014,.6,6),c.wood);u.position.x=(h-2)*.05,u.rotation.z=(h-2)*.08,this.mesh.add(u)}let l=ve(new Fi(.1,.025,6,16),c.leather||c.iron);l.rotation.x=Math.PI/2,l.scale.set(1.1,.5,1),this.mesh.add(l),this.mesh.rotation.z=Math.PI/2.3}else if(e==="item"){this.mesh=new xe,this.model=vb(r),this.mesh.add(this.model);let l=Li[r.rarity],h=new He({color:l.hex,map:xb(),transparent:!0,blending:Xe,depthWrite:!1,side:Re,opacity:.8});this.beam=new Pt(_h.beam,h),this.beam.position.y=2,this.beam.rotation.x=Math.PI,this.mesh.add(this.beam),this.light=t.addLight(i,this.y,s,l.hex,r.rarity==="comum"?0:4,4,.1)}this.mesh.traverse(l=>{l.isMesh&&l!==this.beam&&(l.castShadow=!0)}),this.mesh.position.set(i,this.y,s),t.scene.add(this.mesh)}get prompt(){return this.kind==="item"?"item":null}update(t,e){let i=this.game,s=i.player;this.t+=t;let r=i.floorAt(this.x,this.z);if(!this.grounded){this.vy-=18*t;let o=this.x+this.vx*t,c=this.z+this.vz*t;i.walkable(o,c)?(this.x=o,this.z=c):(this.vx*=-.4,this.vz*=-.4),this.y+=this.vy*t;let l=r+(this.kind==="item"?.55:.12);this.y<l&&(this.y=l,Math.abs(this.vy)<2?(this.grounded=!0,this.vy=0):(this.vy*=-.35,this.vx*=.6,this.vz*=.6,this.kind==="gold"&&i.audio.play("coin",.25)))}let a=Math.hypot(s.x-this.x,s.z-this.z);if(this.kind!=="item"&&this.t>.5&&!s.dead){let o=this.kind==="gold"?3.5:2.2;if(a<o){let c=(1-a/o)*14+4;this.x+=(s.x-this.x)/a*c*t,this.z+=(s.z-this.z)/a*c*t,this.y+=(s.y+.8-this.y)*Math.min(1,t*6),this.grounded=!0}if(a<.5){this.collect();return}}this.mesh.position.set(this.x,this.y+(this.grounded?Math.sin(e*3+this.x)*.06:0),this.z),this.kind==="gold"?this.mesh.rotation.z+=t*4:this.kind==="fragment"?(this.mesh.rotation.y+=t*2,this.light&&(this.light.x=this.x,this.light.z=this.z)):this.kind==="item"?(this.model.rotation.y+=t*1.5,this.beam.material.opacity=.55+Math.sin(e*3)*.2,this.light&&(this.light.x=this.x,this.light.z=this.z)):this.mesh.rotation.y+=t*2,this.kind==="heart"&&Math.random()<t*5&&i.particles.add.emit(this.x,this.y,this.z,0,.6,0,.6,.12,.02,1,.2,.3,1,0,0)}collect(){let t=this.game,e=t.player;this.remove(),this.kind==="gold"&&(e.gold+=this.data||1,t.audio.play("coin",.6)),this.kind==="arrows"&&(e.arrows=Math.min(e.maxArrows,e.arrows+8),t.audio.play("pickup"),t.floatText(e.x,e.y+2,e.z,"+8 flechas","#d8d0b0")),this.kind==="heart"&&(e.heal(e.maxHp*.2),t.audio.play("potion",.6)),this.kind==="fragment"&&(e.fragments+=this.data||1,t.audio.play("levelup",.6),t.floatText(e.x,e.y+2,e.z,"+"+(this.data||1)+" fragmento","#c9a0ff"),t.ui.toast("Fragmento dimensional obtido! Use-o no Portal das Dimens\xF5es do Ref\xFAgio.","#c9a0ff"))}remove(){this.dead=!0,this.game.scene.remove(this.mesh),this.light&&this.game.removeLight(this.light)}};function Hn(n,t,e,i,s,r=16724e3){let a=new Pt(new on(1,40),new He({map:fb(),color:r,transparent:!0,blending:Xe,depthWrite:!1,opacity:0}));a.rotation.x=-Math.PI/2,a.position.set(t,n.floorAt(t,e)+.04,e),a.scale.setScalar(i),a.renderOrder=3,n.scene.add(a);let o=new Pt(new on(1,40),new He({color:r,transparent:!0,blending:Xe,depthWrite:!1,opacity:.25}));o.rotation.x=-Math.PI/2,o.position.copy(a.position),o.position.y+=.005,o.scale.setScalar(.01),n.scene.add(o);let c=0;n.effects.push({update(l){c+=l;let h=Math.min(1,c/s);return a.material.opacity=Math.min(1,c*5)*.9,o.scale.setScalar(i*h),c>=s?(n.scene.remove(a),n.scene.remove(o),a.geometry.dispose(),a.material.dispose(),o.geometry.dispose(),o.material.dispose(),!1):!0}})}function Hd(n,t,e,i,s,r,a,o=16724e3){let c=new Pt(new Ti(r,s),new He({color:o,transparent:!0,blending:Xe,depthWrite:!1,opacity:.35}));c.rotation.x=-Math.PI/2,c.rotation.z=-i;let l=t+Math.sin(i)*s/2,h=e+Math.cos(i)*s/2;c.rotation.order="YXZ",c.rotation.set(-Math.PI/2,0,0),c.rotateOnWorldAxis(new D(0,1,0),i),c.position.set(l,n.floorAt(t,e)+.05,h),n.scene.add(c);let u=0;n.effects.push({update(d){return u+=d,c.material.opacity=.2+.3*Math.abs(Math.sin(u*12)),u>=a?(n.scene.remove(c),c.geometry.dispose(),c.material.dispose(),!1):!0}})}function Qp(n,t,e=10476799){let i=[];for(let l=0;l<t.length-1;l++){let h=t[l],u=t[l+1],d=h,f=6;for(let p=1;p<=f;p++){let x=p/f,m=p===f?u:new D(h.x+(u.x-h.x)*x+(Math.random()-.5)*.5,h.y+(u.y-h.y)*x+(Math.random()-.5)*.5,h.z+(u.z-h.z)*x+(Math.random()-.5)*.5);i.push(d.x,d.y,d.z,m.x,m.y,m.z),d=m}}let s=new ge;s.setAttribute("position",new qt(i,3));let r=new yr({color:e,transparent:!0,blending:Xe,depthWrite:!1}),a=new Ia(s,r);n.scene.add(a);let o=n.addLight(t[0].x,t[0].y,t[0].z,e,25,10,0,!0),c=0;n.effects.push({update(l){return c+=l,r.opacity=1-c/.3,o.intensity=25*(1-c/.3),c>.3?(n.scene.remove(a),s.dispose(),r.dispose(),n.removeLight(o),!1):!0}})}function Gd(){let n=fi(),t=new xe,e=new Pt(new Ge(.04,.04,2.6,6),n.darkwood);e.position.y=1.3,e.castShadow=!0,t.add(e);let i=new Pt(new Ti(.7,1.2),n.banners[0]);i.position.set(.37,1.9,0),i.castShadow=!0,t.add(i);let s=new Pt(new vi(.1),n.gold);return s.position.y=2.65,t.add(s),t}var Rh=class{constructor(t,e){this.game=t,this.x=e.x,this.z=e.z,this.role=e.role,this.name=e.name,this.baseRot=e.rot||0,this.rig=Ud(e.kind),this.rig.root.position.set(e.x,t.floorAt(e.x,e.z),e.z),this.rig.root.rotation.y=this.baseRot,t.scene.add(this.rig.root),this.t=Math.random()*10}get prompt(){return{shop:`Falar com ${this.name} (loja)`,smith:`Falar com ${this.name} (aprimorar)`,quests:`Falar com ${this.name} (miss\xF5es)`}[this.role]}interact(){this.game.openStation(this.role)}update(t){this.t+=t;let e=this.game.player,s=Math.hypot(e.x-this.x,e.z-this.z)<5?Math.atan2(e.x-this.x,e.z-this.z):this.baseRot,r=this.rig.root.rotation.y,a=Math.atan2(Math.sin(s-r),Math.cos(s-r));if(this.rig.root.rotation.y=r+a*Math.min(1,t*3),hn(this.rig,0,0,this.t),this.role==="smith"){let o=Math.max(0,Math.sin(this.t*2.2));this.rig.armR.rotation.x=-.4-o*1.6,this.rig.elbowR.rotation.x=-.6,o>.98&&!this.hit&&(this.hit=!0,this.game.particles.sparks(this.x-1.9,this.game.floorAt(this.x,this.z)+1.05,this.z+1.3,5,[1,.7,.3],2)),o<.5&&(this.hit=!1)}}},No=class{constructor(t,e,i,s,r,a=2.2){this.game=t,this.x=e,this.z=i,this.role=s,this.label=r,this.range=a}get prompt(){return this.label}interact(){this.game.openStation(this.role)}},Ch=class{constructor(t,e,i,s){this.game=t,this.x=e,this.z=i,this.quest=s,this.freed=!1,this.t=0,this.rig=Ud("prisioneiro");let r=t.floorAt(e,i);this.rig.root.position.set(e,r,i),t.scene.add(this.rig.root);let a=fi(),o=new xe;for(let l=0;l<12;l++){let h=l/12*Math.PI*2,u=ve(new Ge(.025,.025,2.2,6),a.iron);u.position.set(Math.cos(h)*.62,1.1,Math.sin(h)*.62),o.add(u)}for(let l of[.05,2.2]){let h=ve(new Fi(.62,.04,6,24),a.iron);h.rotation.x=Math.PI/2,h.position.y=l,o.add(h)}let c=ve(new xi(.66,.4,16),a.iron);c.position.y=2.4,o.add(c),o.position.set(e,r,i),t.scene.add(o),this.cage=o,this.light=t.addLight(e,r+2.5,i,16769184,5,5,.3),t.dg.solid[t.dg.idx(Math.floor(e),Math.floor(i))]=1}get prompt(){return this.freed?null:"Libertar o prisioneiro"}interact(){if(this.freed)return;this.freed=!0;let t=this.game;t.audio.play("gate"),t.particles.dust(this.x,this.cage.position.y+1,this.z,20,[.5,.45,.4],2,1),t.ui.toast('"Obrigado, aventureiro! Que a \xFAltima chama te guie."',"#e8dcc0"),t.onQuestEvent("rescue",this.quest)}update(t){this.t+=t,hn(this.rig,0,0,this.t),this.freed?this.cage.position.y>-3&&(this.cage.position.y-=t*1.5,this.rig.armR.rotation.x=-2.6+Math.sin(this.t*8)*.3):(this.rig.armL.rotation.x=this.rig.armR.rotation.x=-.6,this.rig.elbowL.rotation.x=this.rig.elbowR.rotation.x=-1.4)}},Ph=class{constructor(t,e,i,s){this.game=t,this.x=e,this.z=i,this.quest=s,this.taken=!1;let r=fi(),a=new xe;a.add(ve(ce("relped",[[0,0],[.4,0],[.36,.1],[.2,.2],[.18,.8],[.34,.9],[0,.92]],16),r.stone));let o=ve(dt.rbox(.36,.28,.26,.05),r.gold);o.position.y=1.08,a.add(o);let c=ve(new Ge(.13,.13,.36,12,1,!1,0,Math.PI),r.gold);c.rotation.z=Math.PI/2,c.rotation.y=Math.PI/2,c.position.y=1.22,a.add(c);let l=ve(new vi(.07),dn("glow",{color:16728160,intensity:5}));l.position.set(0,1.1,.14),a.add(l);let h=t.floorAt(e,i);a.position.set(e,h,i),t.scene.add(a),this.mesh=a,this.light=t.addLight(e,h+1.6,i,16765040,7,6,.2,!0),t.dg.solid[t.dg.idx(Math.floor(e),Math.floor(i))]=1}get prompt(){return this.taken?null:`Pegar: ${this.quest.relicName}`}interact(){if(this.taken)return;this.taken=!0;let t=this.game;this.mesh.children.slice(1).forEach(e=>e.visible=!1),t.removeLight(this.light),t.audio.play("levelup",.7),t.particles.burst(this.x,this.mesh.position.y+1.2,this.z,40,[1,.85,.4],3,.8,.3),t.onQuestEvent("relic",this.quest)}update(t,e){this.taken||(this.mesh.children[1].position.y=1.08+Math.sin(e*2)*.03,Math.random()<t*6&&this.game.particles.add.emit(this.x,this.mesh.position.y+1.3,this.z,(Math.random()-.5)*.4,.8,(Math.random()-.5)*.4,1,.1,.02,1,.85,.4,1,0,0))}};var Ih=[-Math.SQRT1_2,-Math.SQRT1_2],Lh=[Math.SQRT1_2,-Math.SQRT1_2],ms=n=>1-Math.pow(1-Je(n,0,1),3),Qr=class{constructor(t){this.game=t,this.look="couro",this.rig=Nd(this.look),this.x=0,this.z=0,this.y=0,this.rot=0,this.r=.35,this.fh=0,this.level=1,this.xp=0,this.xpNext=60,this.gold=0,this.arrows=40,this.maxArrows=99,this.fragments=0,this.bag=[],this.potionLvl=0,this.flaskLvl=0,this.equip={melee:null,bow:null,armor:null,arts:[null,null,null]},this.artCd=[0,0,0],this.atkCd=0,this.shootCd=0,this.rollCd=0,this.potionCd=0,this.rollT=0,this.rollDir=[0,1],this.invuln=0,this.flashT=0,this.swingT=-1,this.shootT=0,this.combo=0,this.comboT=0,this.phase=0,this.moveAmt=0,this.healLeft=0,this.bannerBuff=0,this.dead=!1,this.deadT=0,this.bladesT=0,this.blades=null,this.stepT=0,this.aimRot=0,this.lastAimT=0,this.slowT=0,this.poisonT=0,this.hp=100}get potionMax(){return 25-2.5*this.flaskLvl}attach(){this.game.scene.add(this.rig.root),Ro(this.rig)}swapRig(t){if(t===this.look&&this.rig)return;let e=this.rig,i=e.root.parent;this.look=t,this.rig=Nd(t),e.weaponKind&&zd(this.rig,e.weaponKind,e.weaponGlow),e.bow&&Od(this.rig,e.bowCross),i&&(i.remove(e.root),i.add(this.rig.root),Ro(this.rig)),e.dispose()}setEquip(t,e){if(t==="melee"&&(this.equip.melee=e,zd(this.rig,e.kind,e.affixes.includes("chamas")?16736288:e.affixes.includes("trovao")?7391487:null),Ro(this.rig)),t==="bow"&&(this.equip.bow=e,Od(this.rig,e.kind==="besta"),Ro(this.rig)),t==="armor"){let i=this.hp/this.maxHp;this.equip.armor=e,this.swapRig(Zr[e.kind].look),this.hp=Math.min(this.maxHp,Math.max(1,i*this.maxHp))}}get maxHp(){return 100+(this.level-1)*12+(this.equip.armor?this.equip.armor.hp:0)}get dr(){return this.equip.armor?this.equip.armor.dr:0}has(t,e){let i=this.equip[t];return!!(i&&i.affixes.includes(e))}get dmgMult(){return(1+.07*(this.level-1))*(this.bannerBuff>0?1.4:1)}get speed(){let t=this.equip.armor;return 4.7*(1+(t?Zr[t.kind].speed:0))}get rollMax(){return 1.1*(this.has("armor","agil")?.6:1)*(this.equip.armor&&this.equip.armor.kind==="andarilho"?.75:1)}heal(t){if(this.dead)return;let e=this.hp;this.hp=Math.min(this.maxHp,this.hp+t);let i=Math.round(this.hp-e);i>0&&this.game.floatText(this.x,this.y+2.1,this.z,"+"+i,"#6dff7a")}gainXp(t){for(this.xp+=t;this.xp>=this.xpNext;)this.xp-=this.xpNext,this.level++,this.xpNext=Math.round(this.xpNext*1.3+20),this.hp=this.maxHp,this.game.audio.play("levelup"),this.game.ui.toast(`N\xEDvel ${this.level}! Vida e dano aumentados.`,"#ffd76a"),this.game.particles.burst(this.x,this.y+1,this.z,50,[1,.85,.3],4,1,.3,-2)}hurt(t,e,i={}){if(this.dead||this.rollT>0||this.invuln>0||this.game.state!=="play")return!1;t*=1-this.dr,this.hp-=t,i.dot||(this.invuln=.45,this.flashT=.15);let s=this.game;return i.dot||(s.audio.play("hurt"),s.shake(.18),s.ui.hurtFlash(),s.particles.blood(this.x,this.y+1.1,this.z,6)),s.floatText(this.x,this.y+2,this.z,"-"+Math.max(1,Math.round(t)),i.dot?"#b8ff6a":"#ff5a4a"),e&&e.hurt&&this.has("armor","espinhos")&&e.melee&&e.hurt(t*.4*(1/(1-this.dr)),{thorns:!0}),i.slow&&(this.slowT=Math.max(this.slowT,i.slow)),this.hp<=0&&(this.hp=0,this.dead=!0,this.deadT=0,s.onPlayerDead()),!0}aimAssist(t,e){let i=null,s=1e9;for(let r of this.game.enemies){if(r.dead)continue;let a=r.x-this.x,o=r.z-this.z,c=Math.hypot(a,o);if(c>t+r.r)continue;let l=Math.abs(us(this.aimRot,Math.atan2(a,o)));if(l>e)continue;let h=c+l*2;h<s&&(s=h,i=r)}return i}update(t,e,i){let s=this.game,r=this.rig;if(this.flashT-=t,r.flash(this.flashT>0?1.5:0),this.dead){this.deadT+=t;let f=ms(this.deadT*2);r.hips.rotation.x=-f*Math.PI/2,r.hips.position.y=r.legLen*(1-f*.72),r.kneeL.rotation.x=r.kneeR.rotation.x=f*.3;return}for(let f of["atkCd","shootCd","rollCd","potionCd","invuln","comboT","bannerBuff"])this[f]=Math.max(0,this[f]-t);for(let f=0;f<3;f++)this.artCd[f]=Math.max(0,this.artCd[f]-t);if(this.healLeft>0){let f=Math.min(this.healLeft,this.maxHp*.6*t);this.healLeft-=f,this.hp=Math.min(this.maxHp,this.hp+f)}this.has("armor","regen")&&(this.hp=Math.min(this.maxHp,this.hp+1.5*t));let a=e.ax*Lh[0]+e.ay*Ih[0],o=e.ax*Lh[1]+e.ay*Ih[1],c=Math.hypot(a,o);if(c>1&&(a/=c,o/=c),e.aim){let f=e.aim.x-this.x,p=e.aim.z-this.z;Math.hypot(f,p)>.3&&(this.aimRot=Math.atan2(f,p))}else if(e.aimStick)this.aimRot=Math.atan2(e.aimStick[0]*Lh[0]+e.aimStick[1]*Ih[0],e.aimStick[0]*Lh[1]+e.aimStick[1]*Ih[1]);else{let f=this.nearestEnemy(9);f?this.aimRot=Math.atan2(f.x-this.x,f.z-this.z):c>.1&&(this.aimRot=Math.atan2(a,o))}let l=this.speed,h=s.cellType(this.x,this.z);if(h===5&&(l*=s.theme.shallow?.85:.65),this.slowT>0&&(this.slowT-=t,l*=.55),s.theme.slippery&&h!==5?this.ice=!0:this.ice=!1,this.rollT>0)this.rollT-=t,s.moveEntity(this,this.rollDir[0]*11.5*t,this.rollDir[1]*11.5*t),this.rot=Math.atan2(this.rollDir[0],this.rollDir[1]),Math.random()<.5&&s.particles.dust(this.x,this.y+.1,this.z,1,[.4,.38,.35],.3,.3);else{if(e.pressed("roll")&&this.rollCd<=0&&!s.inHub&&(this.rollT=.34,this.rollCd=this.rollMax,this.swingT=-1,this.rollDir=c>.1?[a/Math.max(c,.001),o/Math.max(c,.001)]:[Math.sin(this.rot),Math.cos(this.rot)],s.audio.play("roll")),!s.inHub){e.down("attack")&&this.atkCd<=0&&this.swingT<0?this.melee():e.down("shoot")&&this.shootCd<=0&&this.swingT<0&&this.shoot(),e.pressed("potion")&&this.usePotion();for(let g=0;g<3;g++)e.pressed("art"+(g+1))&&s.useArtifact(g)}let f=this.swingT>=0||this.shootT>0,p=f?.35:1,x=a*l*p,m=o*l*p;this.ice&&(this.ivx=Bi(this.ivx||0,x,3,t),this.ivz=Bi(this.ivz||0,m,3,t),x=this.ivx,m=this.ivz),s.moveEntity(this,x*t,m*t),f||i-this.lastAimT<.4?this.rot=Fn(this.rot,this.aimRot,25,t):c>.1&&(this.rot=Fn(this.rot,Math.atan2(a,o),14,t))}this.swingT>=0&&(this.swingT+=t,!this.swingHit&&this.swingT>=this.swingDur*.45&&(this.swingHit=!0,this.doMeleeHit()),this.swingT>=this.swingDur&&(this.swingT=-1)),this.shootT=Math.max(0,this.shootT-t);let u=s.floorAt(this.x,this.z);this.fh=s.cellH(this.x,this.z),this.y=Bi(this.y,u,18,t);let d=this.rollT<=0&&c>.1;this.moveAmt=Bi(this.moveAmt,d?c*(l/4.7):0,10,t),this.phase+=t*l*1.9*(d?1:.3),d&&(this.stepT-=t,this.stepT<=0&&(this.stepT=.34,s.audio.play("step"),h===5&&(s.particles.dust(this.x,this.y,this.z,2,[.5,.6,.65],.3,.8),s.ripple(this.x,this.z)))),this.animate(t,i),r.root.position.set(this.x,this.y,this.z),r.root.rotation.y=this.rot,this.updateBlades(t,i)}nearestEnemy(t){let e=null,i=t;for(let s of this.game.enemies){if(s.dead||!s.awake)continue;let r=Math.hypot(s.x-this.x,s.z-this.z);r<i&&this.game.los(this.x,this.z,s.x,s.z)&&(i=r,e=s)}return e}animate(t,e){let i=this.rig;if(hn(i,this.phase,Math.min(1,this.moveAmt),e),qp(i,Math.min(1,this.moveAmt),e,this.rollT>0?.3:0),i.bow&&(i.bow.visible=this.shootT>0),i.weapon&&(i.weapon.visible=!(this.shootT>0&&this.equip.melee&&this.equip.melee.kind==="lanca")),this.rollT>0){let s=1-this.rollT/.34;i.hips.rotation.x=s*Math.PI*2,i.hips.position.y=i.legLen*.62,i.legL.rotation.x=i.legR.rotation.x=-1.5,i.kneeL.rotation.x=i.kneeR.rotation.x=2.1,i.armL.rotation.x=i.armR.rotation.x=-1.2,i.elbowL.rotation.x=i.elbowR.rotation.x=-1.4,i.torso.rotation.x=.5;return}if(this.game.inHub){i.elbowR.rotation.x-=.2;return}if(i.armR.rotation.x=Math.min(i.armR.rotation.x,-.3),i.elbowR.rotation.x=-.75,this.swingT>=0){let s=ms(this.swingT/this.swingDur),r=this.equip.melee.kind;if(i.elbowR.rotation.x=-.2,r==="lanca"){let a=Math.sin(s*Math.PI);i.armR.rotation.x=-1.57,i.torso.rotation.y=-.4+a*.4,i.hips.position.z=a*.25,i.armR.position.z=a*.3,i.armL.rotation.x=-1.3,i.elbowL.rotation.x=-.6}else if(r==="martelo"||this.combo===2)i.armR.rotation.x=-3+s*2.6,i.armL.rotation.x=-3+s*2.6,i.elbowL.rotation.x=-.4,i.torso.rotation.x=-.2+s*.5,i.kneeL.rotation.x+=.3*s,i.kneeR.rotation.x+=.3*s;else if(r==="adagas"){let a=this.combo%2,o=a?i.armL:i.armR,c=a?i.elbowL:i.elbowR;o.rotation.x=-1.5,o.rotation.y=(a?-1:1)*(1-s*2)*.9,c.rotation.x=-.15,i.torso.rotation.y=(a?-1:1)*(.6-s*1.2)}else{let a=this.combo===1?-1:1;i.armR.rotation.x=-1.45,i.armR.rotation.z=.3,i.torso.rotation.y=a*(1.1-s*2.3)}}else i.armR.position.z=0,i.hips.position.z=0;this.shootT>0&&(i.armL.rotation.set(-1.55,.2,0),i.elbowL.rotation.x=-.05,i.armR.rotation.set(-1.45,-.5,0),i.elbowR.rotation.x=-1.6,i.torso.rotation.y=.35,i.bow&&i.bow.rotation.set(Math.PI/2,0,0))}melee(){let t=this.game,e=this.equip.melee,i=Fs[e.kind],s=un(e);this.combo=this.comboT>0?(this.combo+1)%i.combo:0,this.comboT=s+.4,this.atkCd=s,this.swingT=0,this.swingDur=Math.min(.36,s*.85),this.swingHit=!1,this.lastAimT=t.time;let r=this.aimAssist(i.range+1.2,1);r&&(this.aimRot=Math.atan2(r.x-this.x,r.z-this.z)),this.rot=Fn(this.rot,this.aimRot,60,.05),t.audio.play(i.dmg>20?"swingHeavy":"swing")}doMeleeHit(){let t=this.game,e=this.equip.melee,i=Fs[e.kind],s=i.combo>1&&this.combo===i.combo-1,r=i.range*(s?1.15:1),a=i.arc,o=e.dmg*this.dmgMult*(s?1.5:1),c=0;t.slashFx(this,r,a,s);for(let l of t.enemies){if(l.dead)continue;let h=l.x-this.x,u=l.z-this.z,d=Math.hypot(h,u);if(d>r+l.r||Math.abs(us(this.rot,Math.atan2(h,u)))>a/2&&d>l.r+.3)continue;let f=Math.random()<.08+(this.has("melee","critico")?.15:0),p=(i.knock||1)*(s?1.6:1);l.hurt(o*(f?2:1),{crit:f,kx:h/(d||1)*5*p,kz:u/(d||1)*5*p,burn:this.has("melee","chamas"),melee:!0}),c++,this.has("melee","vampiro")&&this.heal(1+o*.06),this.has("melee","trovao")&&Math.random()<.2&&t.chainLightning(l,o*.8,3)}for(let l of t.pots){if(l.dead)continue;let h=l.x-this.x,u=l.z-this.z;Math.hypot(h,u)<r+.3&&Math.abs(us(this.rot,Math.atan2(h,u)))<a/2+.3&&l.smash()}c&&(t.hitstop(s?.07:.035),t.shake(s?.12:.05))}shoot(){let t=this.game,e=this.equip.bow,i=Co[e.kind];if(this.arrows<=0){t.audio.play("deny"),t.ui.toast("Sem flechas!"),this.shootCd=.5;return}this.arrows--,this.shootCd=un(e),this.shootT=.32,this.lastAimT=t.time;let s=this.aimAssist(16,.35);s&&(this.aimRot=Math.atan2(s.x-this.x,s.z-this.z)),this.rot=this.aimRot;let r=this.has("bow","multi")?[-.18,0,.18]:[0];for(let a of r){let o=this.aimRot+a;t.spawnProjectile({type:"arrow",owner:"player",x:this.x+Math.sin(o)*.5,y:this.y+1.3,z:this.z+Math.cos(o)*.5,dir:o,speed:i.speed,dmg:e.dmg*this.dmgMult,pierce:i.pierce+(this.has("bow","perfura")?2:0),explosive:this.has("bow","explosiva"),burn:this.has("bow","chamas"),range:22})}t.audio.play("bow")}usePotion(){let t=this.game;if(this.potionCd>0){t.audio.play("deny");return}this.potionCd=this.potionMax,this.healLeft+=this.maxHp*.6*(1+.12*this.potionLvl),t.audio.play("potion"),t.particles.burst(this.x,this.y+1,this.z,30,[1,.3,.35],2,.8,.25,-3)}updateBlades(t,e){let i=this.game;if(this.bladesT>0){if(this.bladesT-=t,!this.blades){this.blades=[];let r=new Ve({color:11577599,emissive:8022783,emissiveIntensity:3,transparent:!0,opacity:.85}),a=new xi(.07,1,4);a.rotateX(Math.PI/2);for(let o=0;o<3;o++){let c=new Pt(a,r);i.scene.add(c),this.blades.push(c)}this.bladeHit=new Map}let s=this.bladePower||1;this.blades.forEach((r,a)=>{let o=e*5+a/3*Math.PI*2,c=this.x+Math.sin(o)*1.7,l=this.z+Math.cos(o)*1.7;r.position.set(c,this.y+1,l),r.rotation.y=o+Math.PI/2,Math.random()<.5&&i.particles.add.emit(c,this.y+1,l,0,0,0,.3,.2,.02,.6,.55,1,.8,0,0);for(let h of i.enemies)if(!h.dead&&Math.hypot(h.x-c,h.z-l)<h.r+.5){let u=this.bladeHit.get(h)||0;e-u>.35&&(this.bladeHit.set(h,e),h.hurt(9*s*this.dmgMult,{kx:Math.sin(o)*2,kz:Math.cos(o)*2}))}})}else if(this.blades){for(let s of this.blades)i.scene.remove(s);this.blades[0].geometry.dispose(),this.blades[0].material.dispose(),this.blades=null}}},Gn={rastejante:{name:"Rastejante P\xE1lido",model:"rastejante",ai:"melee",hp:42,dmg:10,speed:2.8,r:.45,range:1.45,windup:.45,cd:1.25,xp:10,blood:[.5,.08,.08],sound:"hit",mass:1},afogado:{name:"Afogado do P\xE2ntano",model:"afogado",ai:"melee",hp:52,dmg:12,speed:2.4,r:.47,range:1.5,windup:.5,cd:1.3,xp:12,blood:[.2,.3,.2],sound:"hit",mass:1.1},cardo:{name:"Cardo Sepulcral",model:"cardo",ai:"ranged",hp:34,dmg:7,speed:1.4,r:.45,prefer:7.5,windup:.8,cd:2.4,xp:12,blood:[.3,.55,.15],sound:"plantHit",mass:1.5,proj:"thorn",volley:3},cardo_gelo:{name:"Cardo Glacial",model:"cardo_gelo",ai:"ranged",hp:38,dmg:8,speed:1.3,r:.45,prefer:7.5,windup:.8,cd:2.4,xp:14,blood:[.7,.9,1],sound:"plantHit",mass:1.5,proj:"shard",volley:3},serpe:{name:"Serpe das Fendas",model:"serpe",ai:"lunge",hp:32,dmg:10,speed:3.6,r:.45,range:3.6,windup:.4,cd:1.7,xp:12,blood:[.45,.12,.08],sound:"hit",mass:.8},serpezinha:{name:"Filhote de Serpe",model:"serpezinha",ai:"melee",hp:12,dmg:5,speed:4.2,r:.3,range:1.1,windup:.25,cd:1,xp:3,blood:[.45,.12,.08],sound:"hit",mass:.5},medusa:{name:"Bulbo de Miasma",model:"medusa",ai:"fuse",hp:24,dmg:24,speed:2.5,r:.45,range:2,windup:1.1,cd:1,xp:9,blood:[.6,.95,.4],sound:"squish",mass:.7,flying:!0,cloud:[.55,1,.3]},medusa_vazio:{name:"Bulbo do Vazio",model:"medusa_vazio",ai:"fuse",hp:28,dmg:28,speed:2.6,r:.45,range:2,windup:1,cd:1,xp:11,blood:[.7,.4,1],sound:"squish",mass:.7,flying:!0,cloud:[.7,.35,1]},vidente:{name:"Vidente Sem-Rosto",model:"vidente",ai:"caster",hp:55,dmg:12,speed:2,r:.45,prefer:8,windup:.8,cd:2.6,xp:28,blood:[.4,.1,.5],sound:"hit",mass:1,flying:!0,proj:"bolt",summon:"rastejante"},aparicao:{name:"Apari\xE7\xE3o Glacial",model:"aparicao",ai:"caster",hp:50,dmg:11,speed:2.1,r:.45,prefer:8,windup:.75,cd:2.4,xp:26,blood:[.7,.9,1],sound:"glass",mass:1,flying:!0,proj:"shard",summon:"mariposa_neve"},couracado:{name:"Coura\xE7ado",model:"couracado",ai:"charger",hp:95,dmg:16,speed:1.9,r:.62,range:1.6,windup:.8,cd:3.2,xp:24,blood:[.35,.3,.15],sound:"shell",mass:3},casco:{name:"Casco Glacial",model:"casco",ai:"charger",hp:105,dmg:17,speed:1.9,r:.62,range:1.6,windup:.8,cd:3,xp:26,blood:[.7,.9,1],sound:"glass",mass:3},couracado_magma:{name:"Coura\xE7ado de Magma",model:"couracado_magma",ai:"charger",hp:110,dmg:18,speed:1.9,r:.62,range:1.6,windup:.8,cd:3,xp:28,blood:[1,.5,.1],sound:"shell",mass:3,burnTrail:!0},mariposa:{name:"Mariposa Cin\xE9rea",model:"mariposa",ai:"lunge",hp:14,dmg:6,speed:3.9,r:.35,range:3,windup:.35,cd:1.5,xp:5,blood:[.6,.55,.45],sound:"squish",mass:.4,flying:!0},mariposa_neve:{name:"Mariposa da Neve",model:"mariposa_neve",ai:"lunge",hp:16,dmg:7,speed:3.9,r:.35,range:3,windup:.35,cd:1.5,xp:6,blood:[.9,.95,1],sound:"squish",mass:.4,flying:!0},espreitador:{name:"Espreitador do Vazio",model:"espreitador",ai:"lunge",hp:44,dmg:13,speed:4,r:.45,range:4.2,windup:.45,cd:1.6,xp:16,blood:[.6,.3,.9],sound:"hit",mass:1},lobo_gelo:{name:"Lobo de Geada",model:"lobo_gelo",ai:"lunge",hp:46,dmg:13,speed:4.1,r:.45,range:4.2,windup:.42,cd:1.5,xp:16,blood:[.55,.1,.1],sound:"hit",mass:1}},Xd={gorran:{name:"Gorran, o Devorador",hp:950,dmg:22,speed:2.4,r:1,attacks:["slam","charge","swipe","swipe"],summon:"rastejante",blood:[.5,.1,.1],baseFloor:1,light:13696944},veshkara:{name:"Vesh'kara, a Serpente-M\xE3e",hp:1050,dmg:20,speed:3,r:1.1,attacks:["leap","spit","bite","bite"],summon:"serpezinha",spit:"venom",blood:[.45,.12,.08],baseFloor:2,light:16760976},colosso:{name:"Colosso de Obsidiana",hp:1400,dmg:26,speed:2,r:1.1,attacks:["slam","meteor","charge","swipe"],summon:"medusa",blood:[1,.5,.1],baseFloor:3,light:16752736},ysra:{name:"Ysra, a Rainha Hibernal",hp:1500,dmg:24,speed:2.3,r:1,attacks:["nova","spit","meteor","blink"],summon:"aparicao",spit:"shard",blood:[.7,.9,1],baseFloor:3,light:11593983,flying:!0,ice:!0},flor:{name:"M\xF3rbida, a Flor Ancestral",hp:1700,dmg:24,speed:0,r:1.5,attacks:["roots","spit","lash","roots","lash"],summon:"cardo",spit:"thorn",blood:[.3,.55,.15],baseFloor:3,light:16748720,stationary:!0},arauto:{name:"Arauto do Vazio",hp:1800,dmg:26,speed:2.6,r:1,attacks:["blink","meteor","nova","spit"],summon:"espreitador",spit:"bolt",blood:[.6,.3,.9],baseFloor:3,light:12620031,flying:!0}},Vd=n=>1+.45*(n-1),Wd=n=>1+.3*(n-1),ta=class{constructor(t,e,i,s,r={}){this.game=t,this.type=e;let a=this.S=Gn[e],o=t.level;this.maxHp=this.hp=a.hp*Vd(o)*(r.elite?2.2:1),this.dmg=a.dmg*Wd(o)*(r.elite?1.3:1),this.r=a.r,this.x=i,this.z=s,this.y=t.floorAt(i,s),this.fh=t.cellH(i,s),this.rot=Math.random()*Math.PI*2,this.kx=0,this.kz=0,this.awake=!!r.awake,this.dead=!1,this.deadT=0,this.state="move",this.atkT=0,this.cd=1+Math.random(),this.summonCd=6,this.burnT=0,this.burnDps=0,this.freezeT=0,this.stunT=0,this.flashT=0,this.slowT=0,this.phase=Math.random()*10,this.moveAmt=0,this.strafe=Math.random()<.5?1:-1,this.melee=a.ai==="melee"||a.ai==="lunge"||a.ai==="charger",this.rig=Yp(a.model||e),this.baseScale=this.rig.root.scale.x,r.elite&&(this.rig.root.scale.multiplyScalar(1.35),this.r*=1.3,this.elite=!0),this.rig.root.position.set(i,this.y,s),t.scene.add(this.rig.root),this.spawnT=r.spawnFx?0:1,xh(this.rig)}get name(){return this.S.name}hurt(t,e={}){if(this.dead)return;let i=this.game;this.hp-=t,this.flashT=.12,this.wake();let s=1/(this.S.mass||1);e.kx&&!(this.state==="attack"&&this.atkKind==="charge")&&(this.kx+=e.kx*s,this.kz+=e.kz*s),e.burn&&(this.burnT=3,this.burnDps=Math.max(this.burnDps,t*.18)),e.stun&&(this.stunT=Math.max(this.stunT,e.stun)),e.freeze&&(this.freezeT=Math.max(this.freezeT,e.freeze)),i.floatText(this.x,this.y+1.2*this.rig.root.scale.y+.9,this.z,Math.round(t)+(e.crit?"!":""),e.crit?"#ffd23a":e.fire?"#ff9a3a":e.dot?"#ffae5a":"#ffffff",e.crit),e.dot||(i.particles.blood(this.x,this.y+(this.S.flying?1.3:.7),this.z,e.crit?14:7,this.S.blood),i.audio.play(e.crit?"crit":this.S.sound,.8)),this.hp<=0&&this.die()}wake(){if(!this.awake){this.awake=!0;for(let t of this.game.enemies)!t.awake&&!t.dead&&!t.isBoss&&Math.hypot(t.x-this.x,t.z-this.z)<7&&(t.awake=!0)}}die(){let t=this.game;this.dead=!0,this.deadT=0,this.hp=0,t.player.gainXp(this.S.xp*(this.elite?3:1)*(1+.2*(t.level-1))),t.stats.kills++,t.onEnemyKilled(this),t.audio.play("die",.7),this.S.flying&&t.particles.burst(this.x,this.y+1.2,this.z,18,this.S.blood,2,.8,.3),Math.random()<.75&&t.spawnGold(this.x,this.z,1+Math.floor(Math.random()*3),1.5),Math.random()<.07&&t.spawnLoot("heart",this.x,this.z),Math.random()<.12&&t.spawnLoot("arrows",this.x,this.z),Math.random()<(this.elite?.6:.03)&&t.dropItem(this.x,this.z,{bonus:this.elite?.4:0})}deathAnim(t){let e=this.rig,i=ms(this.deadT*2.5);switch(e.anim){case"humanoid":e.hips.rotation.x=-i*Math.PI/2,e.hips.position.y=e.legLen*(1-i*.72);break;case"jelly":e.bell.scale.setScalar(1+i*.6),e.body.position.y=1.2-i*1.1;break;case"seer":e.body.position.y=.16-i*.5,e.body.rotation.x=i*.6,e.root.scale.y=this.baseScale*(1-i*.6);break;case"moth":e.body.position.y=Math.max(.15,1.35-i*1.3),e.body.rotation.z=i*1.4;break;case"plant":e.root.scale.y=this.baseScale*(1-i*.7),e.stem.rotation.z=i*.6;break;case"serpent":e.head.position.y=.3*(1-i)+.1,e.head.rotation.x=i*.5;break;case"beetle":e.root.rotation.z=i*Math.PI,e.root.position.y=this.y+i*.5;break;default:e.root.rotation.z=i*Math.PI/2,e.root.position.y=this.y+i*.25}}update(t,e){let i=this.game,s=i.player,r=this.S,a=this.rig;if(this.dead){this.deadT+=t,this.deathAnim(t),this.deadT>1.2&&(a.fade(Math.max(0,1-(this.deadT-1.2)*2)),a.root.position.y-=t*.4),this.deadT>1.8&&(i.scene.remove(a.root),a.dispose(),this.removed=!0);return}if(this.spawnT<1){this.spawnT+=t*1.5,a.root.scale.setScalar(ms(this.spawnT)*(this.elite?1.35:1)*this.baseScale),a.root.position.set(this.x,this.y-(1-this.spawnT)*1.2,this.z),hn(a,this.phase,0,e);return}if(this.flashT-=t,a.flash(this.flashT>0?2:this.state==="attack"&&r.ai==="fuse"&&Math.sin(this.atkT*30)>0?1.2:0),this.burnT>0){if(this.burnT-=t,this.burnAcc=(this.burnAcc||0)+t,this.burnAcc>.5&&(this.burnAcc=0,this.hurt(this.burnDps*.5,{dot:!0,fire:!0}),this.dead))return;Math.random()<t*20&&i.particles.fire(this.x,this.y+.3+Math.random()*1.2,this.z,1,.6)}else this.burnDps=0;if(this.freezeT>0){this.freezeT-=t,a.tint(new Nt(8444159),.7),this.freezeT<=0&&a.tint(new Nt(16777215),0),Math.random()<t*5&&i.particles.add.emit(this.x+(Math.random()-.5)*.6,this.y+Math.random()*1.5,this.z+(Math.random()-.5)*.6,0,.2,0,.6,.12,.02,.6,.9,1,1,0,0),this.applyKnock(t);return}this.applyKnock(t);let o=s.x-this.x,c=s.z-this.z,l=Math.hypot(o,c);if(!this.awake){l<11&&i.los(this.x,this.z,s.x,s.z)&&this.wake(),hn(a,this.phase,0,e),this.place(t);return}if(this.stunT>0){this.stunT-=t,hn(a,this.phase,0,e),this.place(t),Math.random()<t*6&&i.particles.add.emit(this.x,this.y+2,this.z,Math.random()-.5,.5,Math.random()-.5,.5,.15,.02,1,1,.5,1,0,0);return}this.cd-=t,this.summonCd-=t;let h=0,u=0,d=Math.atan2(o,c),f=l<16&&i.los(this.x,this.z,s.x,s.z),p=r.ai==="ranged"||r.ai==="caster";if(this.state==="attack"){if(this.atkT+=t,!(this.atkKind==="charge"&&this.atkT>r.windup)&&!(this.atkKind==="lunge"&&this.lunging)&&(this.rot=Fn(this.rot,d,6,t)),this.attackUpdate(t,l,o,c),this.dead||this.removed)return}else s.dead||(p?(l<r.prefer-2.5&&f?(h=-o/l,u=-c/l):l>r.prefer+1||!f?[h,u]=i.flowDir(this):(h=c/l*this.strafe*.5,u=-o/l*this.strafe*.5,Math.random()<t*.4&&(this.strafe*=-1)),r.summon&&this.summonCd<=0&&f&&l<12?this.startAttack("summon"):this.cd<=0&&f&&l<r.prefer+5&&this.startAttack("shoot")):(l<2.2&&f?(h=o/l,u=c/l):[h,u]=i.flowDir(this),r.ai==="charger"&&this.cd<=0&&f&&l>3&&l<10?this.startAttack("charge"):this.cd<=0&&l<(r.ai==="charger",r.range+s.r+.2)&&f&&this.startAttack(r.ai==="fuse"?"fuse":r.ai==="lunge"?"lunge":"melee")));{let _=this.x-s.x,T=this.z-s.z,v=Math.hypot(_,T),S=this.r+s.r;if(v<S&&v>.001&&!s.dead){let M=(S-v)/S;h+=_/v*M*2,u+=T/v*M*2}}for(let _ of i.enemies){if(_===this||_.dead)continue;let T=this.x-_.x,v=this.z-_.z;if(Math.abs(T)>1.5||Math.abs(v)>1.5)continue;let S=Math.hypot(T,v),M=this.r+_.r;if(S<M&&S>.001){let A=(M-S)/M;h+=T/S*A*1.5,u+=v/S*A*1.5}}let x=Math.hypot(h,u),m=r.speed*(this.slowT>0?.5:1)*(!r.flying&&i.cellType(this.x,this.z)===5?.7:1);if(this.slowT>0&&(this.slowT-=t),x>.01&&this.state!=="attack"){let _=Math.min(1,x);i.moveEntity(this,h/x*m*_*t,u/x*m*_*t);let T=p&&f&&l<r.prefer+3?d:Math.atan2(h,u);this.rot=Fn(this.rot,T,8,t)}else this.state!=="attack"&&f&&(this.rot=Fn(this.rot,d,6,t));let g=x>.05&&this.state!=="attack";this.moveAmt=Bi(this.moveAmt,g?1:0,8,t),this.phase+=t*m*2.4*(g?1:0),hn(a,this.phase,this.moveAmt,e),this.attackPose(),this.place(t)}applyKnock(t){if(Math.abs(this.kx)+Math.abs(this.kz)>.05){this.game.moveEntity(this,this.kx*t,this.kz*t);let e=Math.exp(-8*t);this.kx*=e,this.kz*=e}}place(t){this.y=Bi(this.y,this.game.floorAt(this.x,this.z)+(this.S.flying&&this.game.cellType(this.x,this.z)===5?.3:0),15,t),this.fh=this.game.cellH(this.x,this.z),this.rig.root.position.set(this.x,this.y+(this.hover||0),this.z),this.rig.root.rotation.y=this.rot}startAttack(t){let e=this.game;if(this.state="attack",this.atkKind=t,this.atkT=0,this.did=!1,this.lunging=!1,t==="fuse"&&e.audio.play("fuse"),t==="summon"&&e.audio.play("summon",.7),t==="lunge"&&e.audio.play("hiss",.6),t==="charge"){let i=e.player;this.chargeAng=Math.atan2(i.x-this.x,i.z-this.z),Hd(e,this.x,this.z,this.chargeAng,9,1.4,this.S.windup),e.audio.play("roar",.35)}}endAttack(t){this.state="move",this.cd=t,this.lunging=!1,xh(this.rig)}attackUpdate(t,e,i,s){let r=this.game,a=r.player,o=this.S,c=this.atkKind==="summon"?1:o.windup;if(this.atkKind==="melee"){if(!this.did&&this.atkT>=c){this.did=!0,r.audio.play("swing",.6);let l=Math.abs(us(this.rot,Math.atan2(i,s)));e<o.range+a.r+.35&&l<1.3&&a.hurt(this.dmg,this)}this.atkT>=c+.35&&this.endAttack(o.cd)}else if(this.atkKind==="lunge")this.atkT>=c&&this.atkT<c+.3&&(this.lunging=!0,r.moveEntity(this,Math.sin(this.rot)*10*t,Math.cos(this.rot)*10*t),!this.did&&e<this.r+a.r+.35&&(this.did=!0,a.hurt(this.dmg,this))),this.atkT>=c+.6&&this.endAttack(o.cd);else if(this.atkKind==="charge"){if(this.atkT>=c)if(this.chargeDone)this.chargeDone=!1,this.endAttack(o.cd);else{let l=this.x,h=this.z,u=11*t;if(r.moveEntity(this,Math.sin(this.chargeAng)*u,Math.cos(this.chargeAng)*u),this.rot=this.chargeAng,Math.random()<.7&&r.particles.dust(this.x,this.y+.1,this.z,2,[.45,.4,.35],.6,.5),o.burnTrail&&Math.random()<.5&&r.particles.fire(this.x,this.y+.2,this.z,1,.4),!this.did&&e<this.r+a.r+.4&&(this.did=!0,a.hurt(this.dmg*1.3,this)&&(a.slowT=.4,r.shake(.25))),Math.hypot(this.x-l,this.z-h)<u*.3){this.chargeDone=!0,this.stunT=1.3,r.shake(.3),r.audio.play("slam",.6),r.particles.dust(this.x,this.y+.6,this.z,16,[.5,.45,.4],1.5,1),this.endAttack(o.cd),this.chargeDone=!1;return}this.atkT>c+.85&&(this.chargeDone=!0)}}else if(this.atkKind==="shoot"){if(!this.did&&this.atkT>=c){this.did=!0;let l=e/14,h=a.x+(a.vx||0)*l*.5,u=a.z+(a.vz||0)*l*.5,d=Math.atan2(h-this.x,u-this.z),f=o.volley||1;for(let p=0;p<f;p++){let x=d+(p-(f-1)/2)*.2,m=o.proj;r.spawnProjectile({type:m,owner:"enemy",x:this.x+Math.sin(x)*.6,y:this.y+(o.flying?1.5:1.1),z:this.z+Math.cos(x)*.6,dir:x,speed:m==="bolt"?7.5:12,dmg:this.dmg,homing:m==="bolt"?1.4:0,slow:m==="shard"?1.2:0,range:18})}r.audio.play(o.proj==="bolt"?"bolt":o.proj==="shard"?"glass":"thorn",.8)}this.atkT>=c+.3&&this.endAttack(o.cd*(.8+Math.random()*.4))}else if(this.atkKind==="summon"){if(Math.random()<.6&&r.particles.add.emit(this.x+(Math.random()-.5)*2,this.y+.1,this.z+(Math.random()-.5)*2,0,2,0,.6,.3,.05,.6,.2,1,1,0,0),!this.did&&this.atkT>=c){this.did=!0;let l=r.enemies.filter(h=>!h.dead).length<34?2:0;for(let h=0;h<l;h++)r.spawnEnemyNear(this.x,this.z,o.summon,2.5,!0);this.summonCd=11}this.atkT>=c+.3&&this.endAttack(1.2)}else this.atkKind==="fuse"&&this.atkT>=c&&this.explode()}explode(){let t=this.game,e=t.player,i=this.S,s=2.7;t.explosion(this.x,this.y+1,this.z,s,i.cloud||[.9,.8,.3]);let r=Math.hypot(e.x-this.x,e.z-this.z);r<s+e.r&&e.hurt(this.dmg*(1-.5*r/s),this);for(let a of t.enemies)a!==this&&!a.dead&&Math.hypot(a.x-this.x,a.z-this.z)<s&&a.hurt(this.dmg*.5,{kx:(a.x-this.x)*3,kz:(a.z-this.z)*3});for(let a of t.pots)!a.dead&&Math.hypot(a.x-this.x,a.z-this.z)<s&&a.smash();i.cloud&&t.toxicCloud(this.x,this.z,2.4,this.dmg*.25,4,i.cloud),this.hp=0,this.die(),this.rig.root.visible=!1,this.deadT=1.5}attackPose(){if(this.state!=="attack")return;let t=this.atkKind==="summon"?1:this.S.windup,e=Math.min(1,this.atkT/t),i=this.atkT>t?this.atkT-t:0;Xp(this.rig,this.atkKind,e,i,this.game.time)}remove(){this.game.scene.remove(this.rig.root),this.rig.dispose(),this.removed=!0}},Nh=class extends ta{constructor(t,e,i,s){let r=Xd[e];Gn[e]={name:r.name,model:e,ai:"boss",hp:r.hp,dmg:r.dmg,speed:r.speed,r:r.r,windup:.5,cd:1.6,xp:400,blood:r.blood,sound:"hit",mass:12,flying:r.flying},super(t,e,i,s,{});let a=t.level;this.maxHp=this.hp=r.hp*Vd(a)/Vd(r.baseFloor)*(a>r.baseFloor?1+.1*(a-r.baseFloor):1),this.dmg=r.dmg*Wd(a)/Wd(r.baseFloor),this.B=r,this.isBoss=!0,this.phase2=!1,this.cd=2,this.summonCd=14,this.light=t.addLight(i,5,s,r.light,0,16,.05,!0),this.rot=Math.PI/4}hurt(t,e={}){this.hidden||(e.freeze&&(e.freeze*=.25),e.stun&&(e.stun=0),super.hurt(t,e),!this.phase2&&this.hp<this.maxHp*.5&&!this.dead&&(this.phase2=!0,this.game.audio.play("roar"),this.game.shake(.5),this.game.ui.toast(`${this.B.name} est\xE1 enfurecido!`,"#ff6a4a"),this.summonCd=0))}wake(){this.game.bossActive&&(this.awake=!0)}die(){let t=this.game;this.dead=!0,this.deadT=0,this.hp=0,this.hidden=!1,this.rig.root.visible=!0,t.player.gainXp(300*(1+.25*(t.level-1))),t.stats.kills++,t.audio.play("roar"),t.audio.play("explode"),t.shake(.8),t.particles.burst(this.x,this.y+2,this.z,120,[1,.7,.3],8,1.5,.5,4),t.spawnGold(this.x,this.z,40+t.level*10,5),t.dropItem(this.x,this.z,{rarity:"unico"}),t.dropItem(this.x,this.z,{bonus:.6}),t.spawnLoot("heart",this.x,this.z),t.spawnLoot("arrows",this.x,this.z),t.onBossDead(this),t.removeLight(this.light)}update(t,e){let i=this.game,s=i.player,r=this.rig;if(this.dead||this.freezeT>0){super.update(t,e);return}if(!this.awake){hn(r,this.phase,0,e),this.place(t);return}if(this.light.intensity=Math.min(22,this.light.intensity+t*20),this.light.x=this.x+1.5,this.light.y=this.y+5.5,this.light.z=this.z+1.5,this.flashT-=t,r.flash(this.flashT>0?1.2:0),this.burnT>0){if(this.burnT-=t,this.burnAcc=(this.burnAcc||0)+t,this.burnAcc>.5&&(this.burnAcc=0,this.hurt(this.burnDps*.5,{dot:!0,fire:!0}),this.dead))return;Math.random()<t*25&&i.particles.fire(this.x,this.y+Math.random()*3,this.z,1,1.2)}this.B.stationary?this.kx=this.kz=0:this.applyKnock(t);let a=s.x-this.x,o=s.z-this.z,c=Math.hypot(a,o),l=Math.atan2(a,o),h=this.S.speed*(this.phase2?1.25:1);this.cd-=t,this.summonCd-=t,this.type==="colosso"&&Math.random()<t*6&&i.particles.ember(this.x+(Math.random()-.5)*2,this.y+1+Math.random()*3,this.z+(Math.random()-.5)*2),this.type==="ysra"&&Math.random()<t*8&&i.particles.add.emit(this.x+(Math.random()-.5)*2,this.y+1+Math.random()*3,this.z+(Math.random()-.5)*2,0,-.3,0,1.2,.08,.02,.8,.95,1,1,0,0);let u=!1;if(this.atk)this.bossAttack(t,c,a,o,l);else if(!s.dead){if(c>2.2&&!this.B.stationary){let[f,p]=c<6?[a/c,o/c]:i.flowDir(this);i.moveEntity(this,f*h*t,p*h*t),u=!0}this.rot=Fn(this.rot,l,5,t),this.cd<=0&&this.chooseAttack(c)}let d=Math.hypot(s.x-this.x,s.z-this.z);if(!s.dead&&d<this.r+s.r&&!this.hover&&!this.hidden){let f=(this.r+s.r-d)*Math.min(1,t*12),p=d>.001?(s.x-this.x)/d:1,x=d>.001?(s.z-this.z)/d:0;i.moveEntity(s,p*f,x*f)}this.moveAmt=Bi(this.moveAmt,u?1:0,6,t),this.phase+=t*h*2*(u?1:0),hn(r,this.phase,this.moveAmt,e),this.bossPose(),this.place(t)}chooseAttack(t){let e=this.B,i=this.game,s=i.player;if(this.summonCd<=0&&(this.phase2||Math.random()<.3)){this.atk={name:"summon",t:0},this.summonCd=this.phase2?12:18,i.audio.play("summon");return}let r=["swipe","bite","slam","lash"],a=["charge","leap","spit","meteor","roots","blink","nova"],o=e.attacks.filter(h=>r.includes(h)?t<4.8:!0);t>6&&(o=e.attacks.filter(h=>a.includes(h))),o.length||(o=e.attacks);let c=o[Math.floor(Math.random()*o.length)];this.atk={name:c,t:0,did:0,ang:this.rot};let l=e.ice;if(c==="slam"&&Hn(i,this.x,this.z,4,1),(c==="swipe"||c==="bite")&&Hn(i,this.x+Math.sin(this.rot)*1.6,this.z+Math.cos(this.rot)*1.6,2.3,c==="bite"?.45:.6),c==="lash"&&(this.atk.vine=Math.floor(Math.random()*4),Hn(i,this.x+Math.sin(this.rot)*2.6,this.z+Math.cos(this.rot)*2.6,3,.7,7405376)),c==="charge"){let h=Math.atan2(s.x-this.x,s.z-this.z);this.atk.ang=h,Hd(i,this.x,this.z,h,12,2.2,.8),i.audio.play("roar",.6)}if(c==="leap"&&(this.atk.tx=s.x,this.atk.tz=s.z,this.atk.sx=this.x,this.atk.sz=this.z,Hn(i,s.x,s.z,3.2,1.1,12599551),i.audio.play("hiss")),c==="nova"&&(Hn(i,this.x,this.z,9,1,l?8444159:11563263),i.audio.play(l?"freeze":"summon",.7)),c==="blink"&&i.audio.play("portal",.5),c==="roots"){this.atk.pts=[];let h=Math.atan2(s.x-this.x,s.z-this.z),u=this.phase2?3:1;for(let d=0;d<u;d++){let f=h+(d-(u-1)/2)*.45;for(let p=1;p<=9;p++){let x=this.x+Math.sin(f)*(1.2+p*1.1),m=this.z+Math.cos(f)*(1.2+p*1.1);if(!i.walkable(x,m))break;this.atk.pts.push({x,z:m,t:.6+p*.12,done:!1}),Dh(i,p*.12,()=>Hn(i,x,m,.95,.6,7405376))}}i.audio.play("roar",.4)}if(c==="meteor"){this.atk.targets=[];let h=this.phase2?8:6;for(let u=0;u<h;u++){let d=Math.random()*Math.PI*2,f=u===0?0:1.5+Math.random()*5,p=s.x+Math.cos(d)*f,x=s.z+Math.sin(d)*f;if(!i.walkable(p,x))continue;let m=.2+u*.12;this.atk.targets.push({x:p,z:x,t:1.3+m,done:!1}),Dh(i,m,()=>Hn(i,p,x,1.7,1.3,l?8444159:this.type==="arauto"?11563263:16738832))}i.audio.play("roar",.5)}}bossAttack(t,e,i,s,r){let a=this.game,o=a.player,c=this.atk;c.t+=t;let l=this.phase2?1.2:1,h=d=>{this.atk=null,this.cd=d/l,xh(this.rig)},u=this.B.ice;switch(c.name){case"swipe":case"bite":{let d=c.name==="bite"?.45:.6;!c.did&&c.t>=d&&(c.did=1,a.audio.play("swingHeavy"),e<3.4+o.r&&Math.abs(us(this.rot,r))<1.4&&o.hurt(this.dmg*.8,this),a.shake(.1)),c.t>=d+.4&&h(1.1);break}case"lash":{if(!c.did&&c.t>=.7){c.did=1,a.audio.play("swingHeavy"),a.shake(.2);let d=this.x+Math.sin(this.rot)*2.6,f=this.z+Math.cos(this.rot)*2.6;Math.hypot(o.x-d,o.z-f)<3+o.r&&o.hurt(this.dmg,this),a.particles.dust(d,a.floorAt(d,f)+.1,f,20,[.3,.4,.2],3,1)}c.t>=1.2&&h(1);break}case"slam":{!c.did&&c.t>=1&&(c.did=1,a.audio.play("slam"),a.shake(.6),a.particles.dust(this.x,this.y+.2,this.z,40,[.5,.45,.4],4,1.5),this.type==="colosso"&&a.particles.burst(this.x,this.y+.3,this.z,50,[1,.5,.1],6,.8,.4,5),e<4+o.r&&o.hurt(this.dmg*1.2,this),a.shockwave(this.x,this.z,this.type==="colosso"?11:9,this.dmg*.6,this.type==="colosso"?16738848:13676672),this.phase2&&Dh(a,.45,()=>a.shockwave(this.x,this.z,9,this.dmg*.6,16728096))),c.t>=1.7&&h(1.4);break}case"nova":{!c.did&&c.t>=1&&(c.did=1,a.shake(.4),a.audio.play(u?"freeze":"explode",.8),a.shockwave(this.x,this.z,10,this.dmg*.8,u?10152191:11563263,u?{slow:2}:{}),a.particles.ring(this.x,this.y+.5,this.z,2,80,u?[.7,.95,1]:[.7,.4,1],12,.4),this.phase2&&Dh(a,.5,()=>a.shockwave(this.x,this.z,10,this.dmg*.6,u?10152191:11563263,u?{slow:2}:{}))),c.t>=1.6&&h(1.3);break}case"blink":{if(c.t<.45){this.rig.fade(1-c.t/.45);break}if(!c.moved){c.moved=!0,this.hidden=!0,this.rig.root.visible=!1;for(let d=0;d<12;d++){let f=Math.random()*Math.PI*2,p=2.2+Math.random(),x=o.x+Math.sin(f)*p,m=o.z+Math.cos(f)*p;if(a.walkable(x,m)){c.tx=x,c.tz=m;break}}c.tx===void 0&&(c.tx=this.x,c.tz=this.z),Hn(a,c.tx,c.tz,3.2,.7,u?8444159:11563263),a.particles.burst(this.x,this.y+1.5,this.z,40,u?[.7,.95,1]:[.6,.3,1],4,.6,.3)}!c.did&&c.t>=1.15&&(c.did=1,this.x=c.tx,this.z=c.tz,this.hidden=!1,this.rig.root.visible=!0,this.rig.fade(1),this.rot=Math.atan2(o.x-this.x,o.z-this.z),a.audio.play("slam"),a.shake(.45),a.particles.burst(this.x,this.y+.5,this.z,50,u?[.7,.95,1]:[.6,.3,1],5,.6,.35,3),Math.hypot(o.x-this.x,o.z-this.z)<3.2+o.r&&o.hurt(this.dmg*1.1,this,u?{slow:1.5}:{})),c.t>=1.8&&h(1.2);break}case"roots":{for(let d of c.pts)!d.done&&c.t>=d.t&&(d.done=!0,a.spike(d.x,d.z,3824160),Math.hypot(o.x-d.x,o.z-d.z)<.95+o.r&&o.hurt(this.dmg*.8,this));c.t>=2.4&&h(1.2);break}case"charge":{if(c.t<.8){this.rot=Fn(this.rot,c.ang,10,t);break}if(c.t<1.65&&!c.stopped){let d=Math.sin(c.ang)*15*t,f=Math.cos(c.ang)*15*t,p=this.x,x=this.z;a.moveEntity(this,d,f),Math.random()<.8&&a.particles.dust(this.x,this.y+.1,this.z,2,[.5,.45,.4],.8,.5),!c.did&&e<this.r+o.r+.4&&(c.did=1,o.hurt(this.dmg*1.1,this),o.slowT=.3),Math.hypot(this.x-p,this.z-x)<Math.hypot(d,f)*.3&&(c.stopped=!0,c.stopT=c.t,a.shake(.5),a.audio.play("slam"),a.particles.dust(this.x,this.y+1,this.z,25,[.5,.45,.4],2,2),this.stunT=0)}else c.stopped||(c.stopped=!0,c.stopT=c.t);c.stopped&&c.t>c.stopT+(c.did?.5:1.2)&&h(1.2);break}case"leap":{if(c.t>.3&&c.t<1.1){let p=(c.t-.3)/.8;this.x=c.sx+(c.tx-c.sx)*p,this.z=c.sz+(c.tz-c.sz)*p,this.hover=Math.sin(p*Math.PI)*3,this.rot=Math.atan2(c.tx-c.sx,c.tz-c.sz)}!c.did&&c.t>=1.1&&(c.did=1,this.hover=0,a.walkable(this.x,this.z)||(this.x=c.sx,this.z=c.sz),a.audio.play("slam"),a.shake(.5),a.particles.dust(this.x,this.y+.2,this.z,35,[.4,.35,.4],3.2,1.2),Math.hypot(o.x-this.x,o.z-this.z)<3.2+o.r&&o.hurt(this.dmg*1.1,this)),c.t>=1.1+.6&&h(1.2);break}case"spit":{let d=Math.floor(c.t/.45);if(d>c.did&&d<=3){c.did=d;let f=this.phase2?7:5,p=this.B.spit||"venom";for(let x=0;x<f;x++){let m=r+(x-(f-1)/2)*.22;a.spawnProjectile({type:p,owner:"enemy",x:this.x+Math.sin(m)*1.3,y:this.y+1.2,z:this.z+Math.cos(m)*1.3,dir:m,speed:p==="bolt"?8:9.5,dmg:this.dmg*.45,slow:p==="shard"||p==="venom"?1.3:0,homing:p==="bolt"?.6:0,poison:p==="venom",range:16})}a.audio.play(p==="shard"?"glass":p==="bolt"?"bolt":"hiss")}c.t>=1.8&&h(1.3);break}case"meteor":{for(let d of c.targets)if(!d.done&&c.t>=d.t){d.done=!0;let f=u?[.7,.95,1]:this.type==="arauto"?[.7,.4,1]:[1,.5,.1];a.explosion(d.x,a.floorAt(d.x,d.z)+.3,d.z,1.7,f,!0),u&&a.spike(d.x,d.z,10543359,!0),Math.hypot(o.x-d.x,o.z-d.z)<1.7+o.r&&o.hurt(this.dmg*.9,this,u?{slow:1.2}:{})}else if(!d.done&&c.t>=d.t-.5){let f=(d.t-c.t)/.5,p=u?[.8,.95,1]:this.type==="arauto"?[.8,.5,1]:[1,.5,.15];a.particles.add.emit(d.x+f*3,a.floorAt(d.x,d.z)+f*12,d.z+f*3,-6,-24,-6,.1,1.2,.8,p[0],p[1],p[2],1,0,0)}c.t>=3.2&&h(1.5);break}case"summon":{if(Math.random()<.8&&a.particles.add.emit(this.x+(Math.random()-.5)*4,this.y+.1,this.z+(Math.random()-.5)*4,0,3,0,.7,.4,.05,.8,.3,1,1,0,0),!c.did&&c.t>=1.1){c.did=1;let d=this.B.summon==="serpezinha"?5:3;for(let f=0;f<d;f++)a.spawnEnemyNear(this.x,this.z,this.B.summon,3.5,!0);a.audio.play("roar",.5)}c.t>=1.6&&h(1.2);break}}}bossPose(){let t=this.rig,e=this.atk;if(e){if(t.anim==="serpent"){e.name==="leap"?t.ext=e.t<.3?-.4:.6:e.name==="bite"?(t.ext=e.t<.45?-.4*(e.t/.45):Math.max(0,1-(e.t-.45)*3),t.jawOpen=.7):e.name==="spit"&&(t.jawOpen=.6+Math.sin(e.t*14)*.1,t.ext=.2);return}if(t.anim==="seer"){t.cast=e.name==="summon"||e.name==="nova"?1:e.name==="blink"?.4:Math.min(1,e.t*2);return}if(t.anim==="flower"){t.jawOpen=e.name==="spit"||e.name==="summon"?.9:e.name==="roots"?.5:.2,t.lash=e.name==="lash"?e.t<.7?-1:e.vine:-1,e.name==="lash"&&e.t>=.7&&(t.vines[e.vine].rotation.x=-1.1);return}if(e.name==="slam"){let i=e.t<1?ms(e.t):1-ms((e.t-1)*5);t.armL.rotation.x=t.armR.rotation.x=-.3-i*2.8,t.torso.rotation.x=e.t<1?-.25*i:.45}else if(e.name==="swipe"){let i=e.t/.6;t.armR.rotation.x=-1.5,t.armR.rotation.z=.2,t.torso.rotation.y=i<1?1*ms(i):1-ms((e.t-.6)*5)*2.2}else e.name==="charge"?(t.torso.rotation.x=.5,t.armL.rotation.x=t.armR.rotation.x=.6,t.head.rotation.x=-.4):(e.name==="summon"||e.name==="meteor")&&(t.armL.rotation.x=t.armR.rotation.x=-2.9,t.armL.rotation.z=-.5,t.armR.rotation.z=.5)}}};function Dh(n,t,e){n.after(t,e)}var Uo={shaft:new Ge(.018,.018,.7,6).rotateX(Math.PI/2),tip:new xi(.045,.14,8),orb:new li(.16,14,10),thorn:new xi(.05,.42,6).rotateX(Math.PI/2),shard:new vi(.16,0).scale(.6,.6,1.8)},Uh=class{constructor(t,e){Object.assign(this,e),this.game=t,this.dead=!1,this.hitSet=new Set,this.dist=0,this.vx=Math.sin(e.dir)*e.speed,this.vz=Math.cos(e.dir)*e.speed;let i=fi();if(e.type==="arrow"){this.mesh=new xe,this.mesh.add(new Pt(Uo.shaft,i.wood));let s=new Pt(Uo.tip,i.iron);s.rotation.x=Math.PI/2,s.position.z=.4,this.mesh.add(s),e.burn||e.explosive?this.trail=[1,.5,.15]:e.owner==="player"&&(this.trail=[.9,.85,.7])}else if(e.type==="thorn")this.mesh=new Pt(Uo.thorn,i.thorn),this.trail=null,this.ownMat=!1;else if(e.type==="shard")this.mesh=new Pt(Uo.shard,new Ri({color:12578815,emissive:3844320,emissiveIntensity:1.2,roughness:.05,clearcoat:1,transparent:!0,opacity:.9})),this.trail=[.7,.95,1],this.ownMat=!0;else{let s=e.type==="bolt"?12603647:e.type==="venom"?9109296:16738832,r=new Ve({color:s,emissive:s,emissiveIntensity:e.type==="venom"?1.5:4});this.mesh=new Pt(Uo.orb,r),this.ownMat=!0,e.type==="venom"&&this.mesh.scale.set(.8,.8,1.2),this.trail=e.type==="bolt"?[.7,.3,1]:e.type==="venom"?[.5,1,.2]:[1,.5,.1],e.type==="bolt"&&(this.light=t.addLight(e.x,e.y,e.z,11555071,6,5,.2,!0))}this.mesh.position.set(e.x,e.y,e.z),this.mesh.rotation.y=e.dir,this.mesh.castShadow=!0,t.scene.add(this.mesh)}update(t){let e=this.game,i=e.player;if(this.homing&&!i.dead){let r=Math.atan2(i.x-this.x,i.z-this.z);this.dir=this.dir+Je(us(this.dir,r),-this.homing*t,this.homing*t),this.vx=Math.sin(this.dir)*this.speed,this.vz=Math.cos(this.dir)*this.speed}let s=2;for(let r=0;r<s&&!this.dead;r++){if(this.x+=this.vx*t/s,this.z+=this.vz*t/s,this.dist+=this.speed*t/s,e.blocksProjectile(this.x,this.z,this.y)){e.particles.sparks(this.x,this.y,this.z,5,[1,.8,.5],2),this.type==="arrow"&&e.audio.play("arrowHit",.4),this.explosive&&this.boom(),this.kill();return}if(this.owner==="player"){for(let a of e.enemies){if(a.dead||this.hitSet.has(a)||a.hidden)continue;let o=a.r+.25+(a.isBoss?.5:0);if(Math.hypot(a.x-this.x,a.z-this.z)<o){this.hitSet.add(a);let c=Math.random()<.1;if(a.hurt(this.dmg*(c?2:1),{crit:c,kx:this.vx*.12,kz:this.vz*.12,burn:this.burn}),this.explosive&&this.boom(),this.pierce--<=0){this.kill();return}}}for(let a of e.pots)!a.dead&&Math.hypot(a.x-this.x,a.z-this.z)<.4&&a.smash()}else if(!i.dead&&Math.hypot(i.x-this.x,i.z-this.z)<i.r+.2&&i.hurt(this.dmg,null,{slow:this.slow})){this.poison&&e.poison(i,this.dmg*.3,3),this.kill();return}}if(this.dist>this.range){this.kill();return}this.mesh.position.set(this.x,this.y,this.z),this.mesh.rotation.y=this.dir,this.type==="shard"&&(this.mesh.rotation.z+=t*8),this.trail&&Math.random()<.8&&e.particles.add.emit(this.x,this.y,this.z,0,0,0,.25,this.type==="arrow"?.1:.35,.02,this.trail[0],this.trail[1],this.trail[2],.7,0,0),this.light&&(this.light.x=this.x,this.light.y=this.y,this.light.z=this.z)}boom(){let t=this.game;t.explosion(this.x,this.y,this.z,1.8,[1,.6,.2],!0,.35);for(let e of t.enemies)!e.dead&&Math.hypot(e.x-this.x,e.z-this.z)<1.8+e.r&&e.hurt(this.dmg*.6,{kx:(e.x-this.x)*2,kz:(e.z-this.z)*2,fire:!0});this.explosive=!1}kill(){this.dead=!0,this.game.scene.remove(this.mesh),this.ownMat&&this.mesh.material.dispose(),this.light&&this.game.removeLight(this.light)}};var yb=["Relic\xE1rio de S\xE3o Valdor","C\xE1lice Partido de Orn","Coroa de Espinhos Dourados","Tomo dos Nomes Perdidos","Sino da Primeira Chama"],_b=["o batedor Kael","a ca\xE7adora Mirela","o monge Tobias","a cart\xF3grafa Yvaine","o ferreiro-aprendiz Dario"],bb=1;function tm(n,t,e=[]){let i=zn[Kc(t)],s=["hunt","hunt","elite","chests","boss","relic","rescue","dimension"],r=[],a=new Set(e.map(o=>o.type));for(let o=0;o<30&&r.length<3;o++){let c=n.pick(s);if((c==="relic"||c==="rescue"||c==="boss"||c==="dimension")&&(a.has(c)||r.some(d=>d.type===c)))continue;let l={id:bb+++Math.floor(n.next()*1e6),type:c,have:0,done:!1,depth:t},h=t,u=d=>Math.round(d*(1+.3*(h-1)));if(c==="hunt"){let d=i.enemies.map(f=>f[0]).filter(f=>Gn[f]);l.target=n.pick(d),l.need=n.int(8,15),l.title=`Ca\xE7ada: ${Gn[l.target].name}`,l.desc=`Derrote ${l.need} criaturas do tipo ${Gn[l.target].name} (em qualquer andar ou dimens\xE3o).`,l.reward={gold:u(l.need*9),xp:60*h}}else if(c==="elite")l.need=n.int(2,4),l.title="Ca\xE7ador de campe\xF5es",l.desc=`Derrote ${l.need} inimigos de elite (os de barra dourada).`,l.reward={gold:u(120),xp:90*h,item:"raro"};else if(c==="chests")l.need=n.int(3,5),l.title="Saqueador de tumbas",l.desc=`Abra ${l.need} ba\xFAs.`,l.reward={gold:u(90),xp:50*h};else if(c==="boss"){let d=Xd[i.boss];l.target=i.boss,l.need=1,l.title=`Guardi\xE3o: ${d.name.split(",")[0]}`,l.desc=`Derrote ${d.name}, guardi\xE3o do Andar ${t}.`,l.reward={gold:u(200),xp:150*h,fragments:1}}else c==="relic"?(l.relicName=n.pick(yb),l.need=1,l.title="Rel\xEDquia perdida",l.desc=`Encontre o ${l.relicName} no pr\xF3ximo andar (brilha em dourado no minimapa).`,l.reward={gold:u(160),xp:100*h,item:n.chance(.35)?"unico":"raro"}):c==="rescue"?(l.scout=n.pick(_b),l.need=1,l.title="Resgate",l.desc=`Liberte ${l.scout}, preso numa jaula no pr\xF3ximo andar.`,l.reward={gold:u(140),xp:110*h,fragments:1}):(l.need=1,l.title="Al\xE9m do v\xE9u",l.desc=`Derrote o guardi\xE3o de qualquer dimens\xE3o (${_o.map(d=>zn[d].name).join(", ")}).`,l.reward={gold:u(260),xp:220*h,item:"unico",fragments:1});r.push(l)}return r}function ea(n){let t=[];return n.gold&&t.push(`${n.gold} ouro`),n.xp&&t.push(`${n.xp} XP`),n.item&&t.push(n.item==="unico"?"item \xDAnico":"item Raro"),n.fragments&&t.push(`${n.fragments} fragmento${n.fragments>1?"s":""} dimensional`),t.join(" \xB7 ")}var qd=24,$d=new D(11,19.5,11),Yd=18,Zd="criptas-save-v2",Os=class{constructor(t,e,i,s){this.renderer=t,this.ui=e,this.input=i,this.audio=s,this.camera=new ni(32,innerWidth/innerHeight,.5,150),this.camera.layers.enable(1),this.hemi=new qa(6254484,1775122,.55),this.moon=new Za(9413590,.9),this.moon.castShadow=!0,this.moon.shadow.mapSize.set(2048,2048);let r=this.moon.shadow.camera;r.left=-24,r.right=24,r.top=24,r.bottom=-24,r.near=1,r.far=70,this.moon.shadow.bias=-6e-4,this.moon.shadow.normalBias=.03,this.pool=[];for(let a=0;a<qd;a++){let o=new ns(16777215,0,10,2);this.pool.push(o)}this.poolSize=16,this.shadowLights=0,this.playerLight=new ns(16767152,9,10,2),this.scene=new Kn,this.particles=new mh(this.scene),this.player=new Qr(this),this.state="title",this.time=0,this.hitstopT=0,this.shakeAmt=0,this.zoom=1,this.camTarget=new D,this.lights=[],this.effects=[],this.enemies=[],this.projectiles=[],this.loot=[],this.pots=[],this.chests=[],this.braziers=[],this.floatTexts=[],this.npcs=[],this.stations=[],this.questObjs=[],this.portals=[],this.floorNum=1,this.depth=1,this.level=1,this.mode="hub",this.dimKey=null,this.dimsDone={},this.quests=[],this.offers=[],this.stock=[],this.boughtFrag=!1,this.stats={kills:0,gold:0,time:0,quests:0},this.raycaster=new Ka,this.aimPlane=new Si(new D(0,1,0),0),this.rng=new Ii(Date.now()&16777215)}get inHub(){return this.mode==="hub"}setLightQuality(t,e){this.poolSize=Math.min(qd,t),e!==this.shadowLights&&(this.shadowLights=e,this.pool.forEach((i,s)=>{i.castShadow=s<e,i.castShadow&&(i.shadow.mapSize.set(512,512),i.shadow.bias=-.004,i.shadow.normalBias=.03,i.shadow.camera.near=.15,i.shadow.camera.far=12,i.shadow.map&&(i.shadow.map.dispose(),i.shadow.map=null))}))}newGame(){let t=this.player=new Qr(this),e=this.rng;this.depth=1,this.dimsDone={},this.quests=[],this.offers=[],this.stats={kills:0,gold:0,time:0,quests:0},t.setEquip("melee",zs(e,1,{cat:"melee",kind:"espada",rarity:"comum"})),t.setEquip("bow",zs(e,1,{cat:"bow",kind:"arco",rarity:"comum"})),t.setEquip("armor",zs(e,1,{cat:"armor",kind:"couro",rarity:"comum"})),t.equip.arts[0]=zs(e,1,{cat:"artifact",kind:"chamas",rarity:"comum"}),t.hp=t.maxHp,this.toHub(!0),this.after(2.5,()=>this.ui.toast("Bem-vindo ao Ref\xFAgio. Fale com Oren (miss\xF5es), Ilsa (loja) e Brom (ferreiro).","#e8dcc0")),this.after(7,()=>this.ui.toast(this.input.isTouch?"Quando estiver pronto, v\xE1 at\xE9 o portal azul \xE0 direita para descer.":"WASD move \xB7 E interage \xB7 I abre a bolsa \xB7 O abre as miss\xF5es. O portal azul leva \xE0s Criptas.","#d8ccb0"))}snap(){let t=this.player;return JSON.stringify({level:t.level,xp:t.xp,xpNext:t.xpNext,gold:t.gold,arrows:t.arrows,equip:t.equip,bag:t.bag,fragments:t.fragments,potionLvl:t.potionLvl,flaskLvl:t.flaskLvl,quests:this.quests})}restore(t){let e=typeof t=="string"?JSON.parse(t):t,i=this.player=new Qr(this);Object.assign(i,{level:e.level,xp:e.xp,xpNext:e.xpNext,gold:e.gold,arrows:e.arrows,bag:e.bag||[],fragments:e.fragments||0,potionLvl:e.potionLvl||0,flaskLvl:e.flaskLvl||0}),i.setEquip("armor",e.equip.armor),i.setEquip("melee",e.equip.melee),i.setEquip("bow",e.equip.bow),i.equip.arts=e.equip.arts,i.hp=i.maxHp,e.quests&&(this.quests=e.quests)}save(){try{localStorage.setItem(Zd,JSON.stringify({v:2,snap:this.snap(),depth:this.depth,dimsDone:this.dimsDone,offers:this.offers,stats:this.stats}))}catch{}}static hasSave(){try{return!!localStorage.getItem(Zd)}catch{return!1}}loadSave(){let t=null;try{t=JSON.parse(localStorage.getItem(Zd))}catch{t=null}return t?(this.restore(t.snap),this.depth=t.depth||1,this.dimsDone=t.dimsDone||{},this.offers=t.offers||[],this.stats=t.stats||this.stats,this.toHub(!1),!0):!1}toHub(t=!1){this.mode="hub",this.dimKey=null;for(let e of this.quests)e.placed=!1;(!this.offers.length||!t)&&(this.offers=tm(this.rng,this.depth,this.quests)),this.makeStock(),this.player.hp=this.player.maxHp,this.loadLevel(jc(this.rng.next()*1e9|0),!1),this.save()}startFloor(t){this.mode="floor",this.floorNum=t,this.level=t,this.snapshot=this.snap();let e=Kc(t);this.loadLevel(bd(this.rng.next()*1e9|0,t,e),!1)}startDimension(t){this.mode="dim",this.dimKey=t,this.level=Math.max(3,this.depth)+1,this.snapshot=this.snap(),this.loadLevel(bd(this.rng.next()*1e9|0,this.level,t),!1)}retryLevel(){this.restore(this.snapshot),this.mode==="dim"?this.startDimension(this.dimKey):this.startFloor(this.floorNum)}deathToHub(){this.restore(this.snapshot),this.toHub(!1)}levelComplete(){this.mode==="floor"&&this.floorNum>=this.depth&&(this.depth=this.floorNum+1),this.mode==="dim"&&(this.dimsDone[this.dimKey]=(this.dimsDone[this.dimKey]||0)+1),this.toHub(!1)}loadLevel(t,e){this.disposeLevel();let i=this.theme=t.theme;this.dg=t,t.hub||(this.level=this.mode==="dim"?this.level:t.level);let s=this.scene=new Kn;s.background=new Nt(i.fog),s.fog=new wa(i.fog,i.fogD||.026),s.environment=this.liveEnv&&this.liveEnv.enabled?this.liveEnv.texture:this.envMap||null,s.environmentIntensity=this.liveEnv&&this.liveEnv.enabled?.9:.35,s.add(this.hemi,this.moon,this.moon.target,this.playerLight),this.hemi.color.set(i.hemiSky),this.hemi.groundColor.set(i.hemiGround),this.hemi.intensity=i.hemi,this.moon.color.set(i.moon),this.moon.intensity=i.moonI;for(let o of this.pool)s.add(o);ci.uWet.value=i.wet||0,ci.uGloss.value=i.gloss||0,this.particles.clear(),this.particles.attach(s),this.world=Lp(t),s.add(this.world.group);let r=Op(t);this.staticProps=r,s.add(r.group);for(let o of r.flames)s.add(o);this.flames=r.flames,this.lights=[];for(let o of r.lights)this.addLight(o.x,o.y,o.z,o.color,o.intensity,o.dist,o.flicker);for(let o of t.lightsExtra)this.addLight(o.x,o.y,o.z,o.color,o.intensity,o.dist,.2);t.cell.some(o=>o===St.LAVA)&&this.addLavaLights(),this.enemies=[],this.projectiles=[],this.loot=[],this.effects=[],this.floatTexts.forEach(o=>o.el.remove()),this.floatTexts=[],this.npcs=[],this.stations=[],this.questObjs=[],this.portals=[],this.pots=t.pots.map(o=>new Sh(this,o.x,o.z)),this.chests=t.chests.map(o=>new Mh(this,o.x,o.z,o.big)),this.braziers=t.braziers.map(o=>new wh(this,o.x,o.z)),this.altar=t.altar?new Eh(this,t.altar.x,t.altar.z):null,this.gates=new Th(this,t.gates),this.portal=null,this.boss=null;for(let o of t.spawns)Gn[o.type]&&this.enemies.push(new ta(this,o.type,o.x,o.z,{elite:this.rng.chance(.03+this.level*.01)}));if(t.boss){let o=t.boss;this.boss=new Nh(this,i.boss,o.x+o.w/2,o.z+o.d/2),this.enemies.push(this.boss)}this.bossActive=!1,this.bossDead=!1,this.litCount=0,t.hub?this.buildHub(t):this.placeQuestObjects(t);let a=this.player;a.x=Math.floor(t.start.cx)+.5,a.z=Math.floor(t.start.cz)+.5,a.y=this.floorAt(a.x,a.z),a.fh=this.cellH(a.x,a.z),a.dead=!1,a.rollT=0,a.swingT=-1,a.bladesT=0,a.blades=null,a.rot=t.hub?Math.PI:Math.PI/4,a.slowT=0,a.rig.hips.rotation.set(0,0,0),a.attach(),this.explored=new Uint8Array(t.W*t.D),t.hub&&this.explored.fill(1),this.flow=new Int16Array(t.W*t.D).fill(-1),this.flowT=0,this.flowCell=-1,this.camTarget.set(a.x,a.y,a.z),this.stats.floorStart=this.stats.time,this.state="play",this.ui.setBoss(null),this.audio.setBoss(!1),this.ui.buildMinimap(this),!e&&(this.ui.floorTitle(this.levelLabel(),i.name),this.mode==="floor"&&this.floorNum===1&&this.after(5,()=>this.ui.toast(`Acenda os 3 ${i.obj.plural} \u2014 eles aparecem em laranja no minimapa.`,"#ffb45a")),this.mode==="dim"&&this.after(5,()=>this.ui.toast(`${i.obj.verb} os 3 ${i.obj.plural} para abrir a arena do guardi\xE3o.`,"#c9a0ff")))}levelLabel(){return this.mode==="hub"?"Ref\xFAgio":this.mode==="dim"?"Dimens\xE3o":`Andar ${this.floorNum}`}buildHub(t){for(let l of t.npcs)this.npcs.push(new Rh(this,l));let e=t.hubObj;this.stations.push(new No(this,e.board.x,e.board.z,"quests","Ler o quadro de miss\xF5es",2.4)),this.stations.push(new No(this,e.campfire.x,e.campfire.z,"rest","Descansar na fogueira (salva o progresso)",2.2));let i=new jr(this,e.descent.x,e.descent.z,"descent",`Descer \xE0s Criptas: Andar ${this.depth}`),s=new jr(this,e.dimPortal.x,e.dimPortal.z,"dim","Portal das Dimens\xF5es");i.mesh.rotation.y=-Math.PI/4,s.mesh.rotation.y=Math.PI/4,this.portals.push(i,s);let r=fi(),a=new xe;for(let l=0;l<9;l++){let h=l/9*Math.PI*2,u=new Pt(new Ua(.2,1),r.rock);u.position.set(Math.cos(h)*.75,.1,Math.sin(h)*.75),u.scale.set(1,.7,1),u.castShadow=!0,a.add(u)}for(let l=0;l<4;l++){let h=new Pt(new Ge(.08,.09,1.1,10),r.log);h.rotation.set(Math.PI/2-.5,l*Math.PI/2,0),h.position.set(Math.sin(l*Math.PI/2)*.2,.3,Math.cos(l*Math.PI/2)*.2),h.castShadow=!0,a.add(h)}let o=new Pt(new li(.35,12,8),r.ember);o.scale.y=.3,o.position.y=.08,a.add(o),a.position.set(e.campfire.x,this.floorAt(e.campfire.x,e.campfire.z),e.campfire.z),this.scene.add(a);let c=Us(2.6,16765088);c.position.set(e.campfire.x,a.position.y+.9,e.campfire.z),this.scene.add(c),this.flames.push(c),this.campfire=e.campfire}placeQuestObjects(t){let e=t.spots.slice();for(let i of this.quests){if(i.done||i.placed||i.type!=="relic"&&i.type!=="rescue")continue;let s=e.shift();if(!s)break;i.placed=!0,this.questObjs.push(i.type==="relic"?new Ph(this,s.x,s.z,i):new Ch(this,s.x,s.z,i))}}addLavaLights(){let t=this.dg,e=new Set;for(let i=0;i<t.D;i+=4)for(let s=0;s<t.W;s+=4){let r=null;for(let a=0;a<4&&!r;a++)for(let o=0;o<4;o++)if(t.cell[t.idx(s+o,i+a)]===St.LAVA){r=[s+o,i+a];break}r&&!e.has(r.join())&&(e.add(r.join()),this.addLight(r[0]+.5,.6,r[1]+.5,16734736,12,9,.5))}}disposeLevel(){this.world&&(this.world.dispose(),this.world=null),this.staticProps&&(this.staticProps.group.traverse(t=>t.geometry&&t.geometry.dispose()),this.staticProps=null);for(let t of this.enemies)t.removed||t.rig.dispose();for(let t of this.npcs)t.rig.dispose()}addLight(t,e,i,s,r,a,o=1,c=!1){let l={x:t,y:e,z:i,color:new Nt(s),intensity:r,dist:a,flicker:o,phase:Math.random()*100,priority:c};return this.lights.push(l),l}removeLight(t){let e=this.lights.indexOf(t);e>=0&&this.lights.splice(e,1)}updateLights(){let t=this.time,e=this.camTarget.x,i=this.camTarget.z,s=[];for(let u of this.lights){if(u.intensity<=.01)continue;let d=Math.hypot(u.x-e,u.z-i);d>32||s.push([d-(u.priority?8:0),u])}s.sort((u,d)=>u[0]-d[0]);let r=this.poolSize,a=this.shadowLights,o=s.filter(u=>u[1].flicker>=.5&&!u[1].priority).slice(0,a),c=s.filter(u=>!o.includes(u)),l=o.concat(c);for(let u=0;u<qd;u++){let d=this.pool[u],f=u<a?o[u]:l[u-a+o.length];if(u<r&&f){let p=f[1],x=1+p.flicker*(Math.sin(t*9+p.phase)*.07+Math.sin(t*23+p.phase*3)*.05+Math.sin(t*3.1+p.phase)*.04);d.position.set(p.x,p.y,p.z),d.color.copy(p.color);let m=Je((32-f[0])/6,0,1);d.intensity=p.intensity*x*m,d.distance=p.dist,d.castShadow&&(d.shadow.autoUpdate=!0)}else d.intensity=0,d.castShadow&&(d.shadow.autoUpdate=!1)}let h=this.player;this.playerLight.position.set(h.x,h.y+2.2,h.z)}ci(t,e){let i=Math.floor(t),s=Math.floor(e);return i<0||s<0||i>=this.dg.W||s>=this.dg.D?-1:i+s*this.dg.W}cellType(t,e){let i=this.ci(t,e);return i<0?0:this.dg.cell[i]}cellH(t,e){let i=this.ci(t,e);return i<0?0:this.dg.h[i]}floorAt(t,e){let i=this.ci(t,e);if(i<0)return 0;let s=this.dg.cell[i];return s===St.WATER?this.theme.shallow?-.22:-.55:s===St.PIT?-4:s===St.LAVA?-.85:this.dg.h[i]}walkIdx(t){if(t<0)return!1;let e=this.dg.cell[t];return(e===St.FLOOR||e===St.WATER)&&this.dg.solid[t]!==1&&!(this.gates&&this.gates.blocks(t))}walkable(t,e){return this.walkIdx(this.ci(t,e))}canStand(t,e,i,s){let r=this.dg;for(let[a,o]of[[-i,-i],[i,-i],[-i,i],[i,i]]){let c=this.ci(t+a,e+o);if(!this.walkIdx(c)||Math.abs(r.h[c]-s)>1)return!1}return!0}moveEntity(t,e,i){let s=Math.min(t.r,.55)*.9,r=!1;return e&&this.canStand(t.x+e,t.z,s,t.fh)&&(t.x+=e,r=!0),i&&this.canStand(t.x,t.z+i,s,t.fh)&&(t.z+=i,r=!0),r&&(t.fh=this.cellH(t.x,t.z)),r}los(t,e,i,s){let r=Math.hypot(i-t,s-e),a=Math.ceil(r/.35);for(let o=1;o<a;o++){let c=o/a,l=this.cellType(t+(i-t)*c,e+(s-e)*c);if(l===St.WALL||l===St.PILLAR||l===St.VOID)return!1}return!0}blocksProjectile(t,e,i){let s=this.ci(t,e);if(s<0)return!0;let r=this.dg.cell[s];return!!(r===St.WALL||r===St.PILLAR||r===St.VOID||this.dg.solid[s]===1&&i<this.dg.h[s]+1.1||this.gates&&this.gates.blocks(s))}computeFlow(){let t=this.dg,e=this.player,i=this.ci(e.x,e.z);if(i<0||(this.flowT-=this.dtLogic,this.flowT>0&&i===this.flowCell))return;this.flowT=.25,this.flowCell=i;let s=t.W,r=this.flow;r.fill(-1);let a=this.flowQ&&this.flowQ.length===s*t.D?this.flowQ:this.flowQ=new Int32Array(s*t.D),o=0,c=0;for(a[c++]=i,r[i]=0;o<c;){let l=a[o++],h=r[l];if(h>60)continue;let u=l%s,d=l/s|0;for(let f=-1;f<=1;f++)for(let p=-1;p<=1;p++){if(!p&&!f)continue;let x=u+p+(d+f)*s;r[x]!==-1||!this.walkIdx(x)||Math.abs(t.h[x]-t.h[l])>1||p&&f&&(!this.walkIdx(u+p+d*s)||!this.walkIdx(u+(d+f)*s))||(r[x]=h+1,a[c++]=x)}}}flowDir(t){let e=this.dg,i=e.W,s=this.player,r=this.ci(t.x,t.z);if(r<0)return[0,0];let a=this.flow[r];if(a<=0){if(a===0||this.los(t.x,t.z,s.x,s.z)){let m=s.x-t.x,g=s.z-t.z,_=Math.hypot(m,g)||1;return[m/_,g/_]}return[0,0]}let o=-1,c=a,l=r%i,h=r/i|0;for(let m=-1;m<=1;m++)for(let g=-1;g<=1;g++){if(!g&&!m)continue;let _=l+g+(h+m)*i,T=this.flow[_];T>=0&&T<c&&(c=T,o=_)}if(o<0)return[0,0];let u=o%i+.5,d=(o/i|0)+.5,f=u-t.x,p=d-t.z,x=Math.hypot(f,p)||1;return[f/x,p/x]}spawnProjectile(t){this.projectiles.push(new Uh(this,t))}spawnLoot(t,e,i,s){let r=new Ah(this,t,e,i,s);return this.loot.push(r),r}spawnGold(t,e,i,s){let r=1+Math.floor((this.level-1)/2),a=Math.min(i,14),o=Math.max(1,Math.round(i*r/a));for(let c=0;c<a;c++)this.spawnLoot("gold",t,e,o)}dropItem(t,e,i={}){return this.spawnLoot("item",t,e,zs(this.rng,this.level,i))}spawnEnemyNear(t,e,i,s,r,a=!1){if(!Gn[i])return null;for(let o=0;o<14;o++){let c=Math.random()*Math.PI*2,l=s*(.5+Math.random()*.5),h=t+Math.cos(c)*l,u=e+Math.sin(c)*l;if(!this.walkable(h,u)||Math.abs(this.cellH(h,u)-this.cellH(t,e))>1)continue;let d=new ta(this,i,h,u,{awake:r,spawnFx:!0,elite:a});return this.enemies.push(d),this.particles.burst(h,this.floorAt(h,u)+.2,u,25,[.6,.2,1],2.5,.7,.3,-2),d}return null}floatText(t,e,i,s,r,a=!1){let o=this.ui.makeFloat(s,r,a);this.floatTexts.push({wx:t,y:e,wz:i,el:o,t:0,jx:(Math.random()-.5)*.6,big:a})}hitstop(t){this.hitstopT=Math.max(this.hitstopT,t)}shake(t){if(this.reducedMotion===void 0)try{this.reducedMotion=matchMedia("(prefers-reduced-motion: reduce)").matches}catch{this.reducedMotion=!1}this.reducedMotion&&(t*=.25),this.shakeAmt=Math.min(1,Math.max(this.shakeAmt,t))}slashFx(t,e,i,s){let r=t.has("melee","chamas")?16747066:t.has("melee","trovao")?10148095:16773852,a=new bn(e*.3,e,24,1,-Math.PI/2-i/2,i),o=new He({color:r,transparent:!0,opacity:s?.6:.4,blending:Xe,depthWrite:!1,side:Re}),c=new Pt(a,o);c.rotation.order="YXZ",c.rotation.x=-Math.PI/2,c.rotation.y=t.rot,c.position.set(t.x,t.y+.95,t.z),this.scene.add(c);let l=0;this.effects.push({update:h=>(l+=h,o.opacity=(s?.6:.4)*(1-l/.18),c.scale.setScalar(1+l*1.2),l>.18?(this.scene.remove(c),a.dispose(),o.dispose(),!1):!0)})}explosion(t,e,i,s,r,a=!1,o=1){this.particles.burst(t,e,i,a?24:50,r,s*2.2,.7,a?.28:.4,2),this.particles.dust(t,e,i,a?8:20,[.3,.28,.25],s,1.5),this.particles.ring(t,e,i,s,30,r,s*2.5,.3);let c=new Nt(r[0],r[1],r[2]),l=this.addLight(t,e+1,i,c.getHex(),40*o,s*4,0,!0),h=0;this.effects.push({update:u=>(h+=u,l.intensity=40*o*Math.max(0,1-h/.35),h>.35?(this.removeLight(l),!1):!0)}),this.audio.play("explode",o*(a?.5:1)),this.shake(a?.15:.45)}shockwave(t,e,i,s,r,a={}){let o=new bn(.8,1,48),c=new He({color:r,transparent:!0,blending:Xe,depthWrite:!1,side:Re}),l=new Pt(o,c);l.rotation.x=-Math.PI/2;let h=this.floorAt(t,e)+.15;l.position.set(t,h,e),this.scene.add(l);let u=.5,d=!1;this.effects.push({update:f=>{u+=f*8,l.scale.setScalar(u),c.opacity=1-u/i;let p=this.player,x=Math.hypot(p.x-t,p.z-e);!d&&Math.abs(x-u)<.5&&Math.abs(p.y-h)<1.2&&p.hurt(s,null,a)&&(d=!0);for(let m=0;m<3;m++){let g=Math.random()*Math.PI*2;this.particles.dust(t+Math.cos(g)*u,h,e+Math.sin(g)*u,1,[.5,.45,.4],.2,.5)}return u>i?(this.scene.remove(l),o.dispose(),c.dispose(),!1):!0}})}toxicCloud(t,e,i,s,r,a){let o=this.floorAt(t,e),c=new He({color:new Nt(a[0],a[1],a[2]),transparent:!0,opacity:.18,blending:Xe,depthWrite:!1}),l=new Pt(new on(i,32),c);l.rotation.x=-Math.PI/2,l.position.set(t,o+.06,e),this.scene.add(l);let h=0,u=0;this.effects.push({update:d=>{h+=d,u+=d,c.opacity=.18*Math.min(1,(r-h)*2);for(let p=0;p<2;p++){let x=Math.random()*6.28,m=Math.random()*i;this.particles.dust(t+Math.cos(x)*m,o+.2,e+Math.sin(x)*m,1,a,.3,1.2)}let f=this.player;return u>.5&&(u=0,Math.hypot(f.x-t,f.z-e)<i+f.r&&f.hurt(s*.5,null,{dot:!0})),h>r?(this.scene.remove(l),l.geometry.dispose(),c.dispose(),!1):!0}})}poison(t,e,i){let s=0,r=0;this.effects.push({update:a=>(s+=a,r+=a,r>.5&&(r=0,t.hurt(e/i*.5,null,{dot:!0})),s<i&&!t.dead)})}spike(t,e,i,s=!1){let r=this.floorAt(t,e),a=fi(),o=new xe;for(let l=0;l<4;l++){let h=new Pt(new xi(.14+Math.random()*.1,1+Math.random()*.7,6),s?a.ice:a.plantDark),u=Math.random()*6.28;h.position.set(Math.cos(u)*.25,.4,Math.sin(u)*.25),h.rotation.set(Math.sin(u)*.3,0,-Math.cos(u)*.3),h.castShadow=!0,o.add(h)}o.position.set(t,r-1.2,e),this.scene.add(o),this.particles.dust(t,r+.1,e,10,s?[.8,.9,1]:[.35,.3,.2],1.2,.8),this.audio.play("slam",.25);let c=0;this.effects.push({update:l=>(c+=l,o.position.y=r-1.2+Math.min(1,c*8)*1.2-Math.max(0,c-1)*2,c>1.6?(this.scene.remove(o),o.children.forEach(h=>h.geometry.dispose()),!1):!0)})}ripple(t,e){let i=this.floorAt(t,e)+(this.theme.shallow?.11:.24),s=new He({color:13625599,transparent:!0,opacity:.35,blending:Xe,depthWrite:!1}),r=new Pt(new bn(.2,.26,24),s);r.rotation.x=-Math.PI/2,r.position.set(t,i,e),this.scene.add(r);let a=0;this.effects.push({update:o=>(a+=o,r.scale.setScalar(1+a*4),s.opacity=.35*(1-a/.8),a>.8?(this.scene.remove(r),r.geometry.dispose(),s.dispose(),!1):!0)})}chainLightning(t,e,i){let s=[new D(this.player.x,this.player.y+1.4,this.player.z)],r=new Set,a=t;for(let o=0;o<i&&a;o++){r.add(a),s.push(new D(a.x,a.y+1,a.z)),a.hurt(e,{stun:.3});let c=null,l=5.5;for(let h of this.enemies){if(h.dead||r.has(h))continue;let u=Math.hypot(h.x-a.x,h.z-a.z);u<l&&(l=u,c=h)}a=c}Qp(this,s),this.audio.play("zap")}useArtifact(t){let e=this.player,i=e.equip.arts[t];if(!i)return;if(e.artCd[t]>0){this.audio.play("deny");return}e.artCd[t]=un(i);let s=i.power*e.dmgMult,r=e.x,a=e.z,o=e.y;switch(i.kind){case"chamas":{this.audio.play("fire");let c=0,l=4.8,h=new Set,u=this.addLight(r,o+1,a,16740384,18,12,0,!0);this.effects.push({update:d=>{c+=d*12;for(let f=0;f<7;f++){let p=Math.random()*Math.PI*2;this.particles.fire(r+Math.cos(p)*c,o+.25,a+Math.sin(p)*c,1,.3,[.9,.3,.05],.5)}for(let f of this.enemies)!f.dead&&!h.has(f)&&Math.hypot(f.x-r,f.z-a)<c+f.r&&(h.add(f),f.hurt(30*s,{burn:!0,fire:!0,kx:(f.x-r)*2,kz:(f.z-a)*2}));return u.intensity=18*(1-c/l),c>=l?(this.removeLight(u),!1):!0}});for(let d of this.pots)!d.dead&&Math.hypot(d.x-r,d.z-a)<l&&d.smash();break}case"raio":{let c=null,l=10;for(let h of this.enemies){if(h.dead)continue;let u=Math.hypot(h.x-r,h.z-a);u<l&&this.los(r,a,h.x,h.z)&&(l=u,c=h)}if(!c){e.artCd[t]=.5,this.audio.play("deny"),this.ui.toast("Nenhum inimigo por perto.");return}this.chainLightning(c,24*s,6);break}case"estandarte":{let c=Gd();c.position.set(r,o,a),this.scene.add(c);let l=new Pt(new bn(4.6,5,48),new He({color:16730682,transparent:!0,opacity:.4,blending:Xe,depthWrite:!1}));l.rotation.x=-Math.PI/2,l.position.set(r,o+.05,a),this.scene.add(l);let h=this.addLight(r,o+2.5,a,16736320,10,8,.1,!0);this.audio.play("banner");let u=0;this.effects.push({update:d=>{if(u+=d,Math.hypot(e.x-r,e.z-a)<5&&(e.bannerBuff=.25,e.hp=Math.min(e.maxHp,e.hp+3*d*i.power)),Math.random()<d*10){let f=Math.random()*Math.PI*2;this.particles.add.emit(r+Math.cos(f)*4.8,o+.1,a+Math.sin(f)*4.8,0,1,0,.8,.25,.05,1,.35,.25,1,0,0)}return l.material.opacity=.3+Math.sin(u*4)*.1,u>8*Math.min(1.6,i.power)?(this.scene.remove(c),this.scene.remove(l),this.removeLight(h),!1):!0}});break}case"vendaval":{this.audio.play("wind"),this.particles.ring(r,o+.6,a,5,60,[.8,.95,.85],10,.35),this.particles.dust(r,o+.2,a,20,[.6,.6,.55],3,1);for(let c of this.enemies){if(c.dead)continue;let l=c.x-r,h=c.z-a,u=Math.hypot(l,h);u<5.5&&c.hurt(8*s,{kx:l/(u||1)*16,kz:h/(u||1)*16,stun:1.3})}for(let c of this.projectiles)c.owner==="enemy"&&Math.hypot(c.x-r,c.z-a)<5&&c.kill();this.shake(.2);break}case"laminas":e.bladesT=8,e.bladePower=s,this.audio.play("summon");break;case"gelo":{this.audio.play("freeze"),this.particles.ring(r,o+.4,a,6,70,[.6,.9,1],12,.3),this.particles.burst(r,o+1,a,40,[.7,.95,1],3,1,.2);let c=new Pt(new vi(.5),new Ri({color:11463423,emissive:3844320,emissiveIntensity:1.2,roughness:.05,clearcoat:1,transparent:!0,opacity:.85}));c.scale.set(.7,1.6,.7),c.position.set(r,o+.9,a),this.scene.add(c);for(let h of this.enemies)!h.dead&&Math.hypot(h.x-r,h.z-a)<6.5&&h.hurt(10*s,{freeze:3*Math.min(1.5,i.power)});let l=0;this.effects.push({update:h=>(l+=h,c.rotation.y+=h,l>3?(this.scene.remove(c),c.geometry.dispose(),c.material.dispose(),this.particles.burst(r,o+1,a,20,[.7,.95,1],2,.6,.2,5),!1):!0)});break}}}after(t,e){let i=0;this.effects.push({update:s=>(i+=s,i>=t?(e(),!1):!0)})}onBrazierLit(t){this.litCount++;let i=this.braziers.length-this.litCount,s=this.theme.obj;this.ui.toast(i>0?`${s.noun[0].toUpperCase()+s.noun.slice(1)} ${s.done}! Faltam ${i}.`:`Todos os ${s.plural} foram ${s.done.endsWith("o")?s.done.slice(0,-1)+"os":s.done}! O port\xE3o do guardi\xE3o se abriu.`,"#ffb45a");let r=3+Math.min(5,this.level);for(let a=0;a<r;a++){let o=this.rng.weighted(this.theme.enemies),c=a===0&&this.level>=2&&i===0;this.after(.6+a*.25,()=>this.spawnEnemyNear(t.x,t.z,o,5,!0,c))}i===0&&this.after(1.5,()=>this.gates.open())}onEnemyKilled(t){for(let e of this.quests)e.done||(e.type==="hunt"&&(t.type===e.target||t.S.model===e.target)&&this.progressQuest(e),e.type==="elite"&&t.elite&&this.progressQuest(e))}onChestOpened(){for(let t of this.quests)!t.done&&t.type==="chests"&&this.progressQuest(t)}onQuestEvent(t,e){e&&!e.done&&this.progressQuest(e)}progressQuest(t,e=1){t.have=Math.min(t.need,t.have+e),t.have>=t.need?this.completeQuest(t):t.need>3&&this.floatText(this.player.x,this.player.y+2.4,this.player.z,`${t.have}/${t.need}`,"#ffd76a")}completeQuest(t){t.done=!0;let e=this.player,i=t.reward;this.audio.play("levelup"),this.ui.toast(`Miss\xE3o conclu\xEDda: ${t.title}`,"#ffd76a",!0),this.after(1.2,()=>this.ui.toast(`Recompensa: ${ea(i)}`,"#ffe8a0")),i.gold&&(e.gold+=i.gold),i.xp&&e.gainXp(i.xp),i.fragments&&(e.fragments+=i.fragments),i.item&&this.dropItem(e.x,e.z,{rarity:i.item}),this.particles.burst(e.x,e.y+1.5,e.z,60,[1,.85,.35],4,1,.3,-2),this.stats.quests=(this.stats.quests||0)+1,this.quests=this.quests.filter(s=>s!==t)}onBossDead(t){this.bossDead=!0,this.bossActive=!1,this.audio.setBoss(!1),this.ui.toast(`${t.B.name} foi derrotado!`,"#ffd76a");let e=this.mode==="dim"?2:1;for(let i=0;i<e;i++)this.spawnLoot("fragment",t.x,t.z,1);for(let i of this.quests)i.done||(i.type==="boss"&&i.target===t.type&&this.progressQuest(i),i.type==="dimension"&&this.mode==="dim"&&this.progressQuest(i));this.after(2.5,()=>{this.ui.setBoss(null),this.gates.open()}),this.after(3.2,()=>{let i=this.dg.boss;this.portal=new jr(this,i.x+i.w/2+.5,i.z+i.d/2+.5,"exit","Voltar ao Ref\xFAgio"),this.audio.play("portal"),this.ui.toast("Um portal para o Ref\xFAgio se abriu no centro da arena.","#8fd8ff")})}onPlayerDead(){this.audio.play("die"),this.after(1.8,()=>{this.player.dead&&(this.state="dead",this.ui.showDeath(this))})}enterPortal(){this.state==="play"&&(this.state="floorDone",this.audio.play("portal"),this.ui.showFloorDone(this))}usePortal(t){t.kind==="exit"?this.enterPortal():t.kind==="descent"?(this.audio.play("portal"),this.startFloor(this.depth)):t.kind==="dim"&&this.openStation("dims")}openStation(t){if(t==="rest"){let e=this.player;e.hp=e.maxHp,e.potionCd=0,this.save(),this.audio.play("brazier",.5),this.ui.toast("Voc\xEA descansa junto \xE0 fogueira. Vida restaurada e progresso salvo.","#ffd0a0");return}this.state="menu",this.ui.openStation(this,t)}closeMenu(){this.state="play",this.ui.hidePanels()}makeStock(){let t=this.rng,e=Math.max(1,this.depth);this.stock=[];for(let i=0;i<6;i++)this.stock.push(zs(t,e,{bonus:.45}));this.boughtFrag=!1}consumables(){let t=this.player,e=Math.max(1,this.depth);return[{id:"arrows",name:"Aljava de flechas (+30)",desc:"Enche sua aljava.",price:18+4*e,ok:t.arrows<t.maxArrows},{id:"potion",name:`Elixir de Vitalidade ${t.potionLvl+1}/5`,desc:"A po\xE7\xE3o passa a curar 12% a mais (permanente).",price:120*(t.potionLvl+1),ok:t.potionLvl<5},{id:"flask",name:`Frasco \xC1gil ${t.flaskLvl+1}/5`,desc:"A po\xE7\xE3o recarrega 2,5 s mais r\xE1pido (permanente).",price:150*(t.flaskLvl+1),ok:t.flaskLvl<5},{id:"fragment",name:"Fragmento Dimensional",desc:"Abre uma viagem pelo Portal das Dimens\xF5es. Um por visita.",price:380+90*e,ok:!this.boughtFrag}]}buyConsumable(t){let e=this.player,i=this.consumables().find(s=>s.id===t);return!i||!i.ok?"Indispon\xEDvel.":e.gold<i.price?"Ouro insuficiente.":(e.gold-=i.price,t==="arrows"&&(e.arrows=Math.min(e.maxArrows,e.arrows+30)),t==="potion"&&e.potionLvl++,t==="flask"&&e.flaskLvl++,t==="fragment"&&(e.fragments++,this.boughtFrag=!0),this.audio.play("coin"),null)}buyItem(t){let e=this.player,i=this.stock[t];if(!i)return"Indispon\xEDvel.";let s=Kr(i)*2;return e.gold<s?"Ouro insuficiente.":e.bag.length>=Yd?"Sua bolsa est\xE1 cheia.":(e.gold-=s,e.bag.push(i),this.stock.splice(t,1),this.audio.play("coin"),null)}sellItem(t){let e=this.player,i=e.bag[t];i&&(e.gold+=Io(i),e.bag.splice(t,1),this.audio.play("coin"))}upgrade(t,e){let i=this.player,s=t==="art"?i.equip.arts[e]:i.equip[t];if(!s)return"Nada equipado.";if((s.up||0)>=Po)return"J\xE1 est\xE1 no m\xE1ximo (+5).";let r=vh(s);if(i.gold<r)return"Ouro insuficiente.";if(i.gold-=r,Jp(s),t==="armor"){let a=i.hp/i.maxHp;i.hp=a*i.maxHp}return this.audio.play("anvil"),null}equipFromBag(t,e){let i=this.player,s=i.bag[t];if(!s)return;i.bag.splice(t,1);let r;if(s.cat==="artifact"){let a=e??i.equip.arts.findIndex(o=>!o);a<0&&(a=0),r=i.equip.arts[a],i.equip.arts[a]=s}else r=i.equip[s.cat],i.setEquip(s.cat,s);r&&i.bag.push(r),this.audio.play("pickup")}discard(t){this.player.bag.splice(t,1),this.audio.play("deny",.5)}acceptQuest(t){if(this.quests.length>=3)return"Voc\xEA j\xE1 tem 3 miss\xF5es ativas.";let e=this.offers.splice(t,1)[0];return e&&(this.quests.push(e),this.audio.play("pickup")),null}abandonQuest(t){let e=this.quests.splice(t,1)[0];e&&(e.have=0,e.placed=!1,this.offers.push(e))}travelDimension(t){let e=this.player;return e.fragments<1?"Voc\xEA precisa de 1 fragmento dimensional.":(e.fragments--,this.ui.hidePanels(),this.audio.play("portal"),this.startDimension(t),null)}nearestInteract(){let t=this.player,e=null,i=1/0,s=(r,a=1.9)=>{if(!r||!r.prompt)return;let o=Math.hypot(r.x-t.x,r.z-t.z);o<a&&o<i&&(i=o,e=r)};for(let r of this.chests)s(r);for(let r of this.braziers)s(r,2.1);s(this.altar,2.1),s(this.portal,2.4);for(let r of this.npcs)s(r,2.2);for(let r of this.stations)s(r,r.range);for(let r of this.portals)s(r,2.6);for(let r of this.questObjs)s(r,1.9);for(let r of this.loot)r.kind==="item"&&!r.dead&&s(r,1.6);return e}pickupItem(t,e,i=!1){let s=this.player,r=t.data;if(i){if(s.bag.length>=Yd){this.audio.play("deny"),this.ui.toast("Sua bolsa est\xE1 cheia.");return}t.remove(),s.bag.push(r),this.audio.play("pickup"),this.ui.toast(`Guardado na bolsa: ${r.name}`,"#d8d0c0");return}t.remove(),this.audio.play("pickup");let a=null;if(r.cat==="artifact"){let o=e;if(o===void 0&&(o=s.equip.arts.findIndex(c=>!c),o<0)){let c=1e9;s.equip.arts.forEach((l,h)=>{let u=wn(l);u<c&&(c=u,o=h)})}a=s.equip.arts[o],s.equip.arts[o]=r,s.artCd[o]=Math.min(s.artCd[o],2)}else a=s.equip[r.cat],s.setEquip(r.cat,r);if(this.ui.toast(`Equipado: ${r.name}`,r.rarity==="unico"?"#ffb92e":r.rarity==="raro"?"#4fb3ff":"#e8e0d0"),a)if(s.bag.length<Yd)s.bag.push(a),this.ui.toast(`${a.name} foi para a bolsa.`,"#a8a090");else{let o=this.spawnLoot("item",s.x,s.z,a);o.vx*=.3,o.vz*=.3,o.t=0}}update(t){let e=this.input;if(this.time+=t,ci.uTime.value=this.time,this.state==="title"){this.titleCam(t),this.world&&this.world.update(this.time);for(let l of this.npcs)l.update(t);this.updateLights(),this.particles.update(t),this.animateFlames(t),this.ambient(t);return}if(this.state==="menu"){(e.pressed("pause")||e.pressed("bag")||e.pressed("journal"))&&this.closeMenu(),this.world.update(this.time),this.animateFlames(t),this.particles.update(t*.2),e.endFrame();return}if(e.pressed("pause")&&(this.state==="play"||this.state==="pause")&&(this.state==="play"?(this.state="pause",this.ui.showPause(this)):(this.state="play",this.ui.hidePanels())),this.state==="play"&&!this.player.dead){if(e.pressed("bag")){this.openStation("bag"),e.endFrame();return}if(e.pressed("journal")){this.openStation("journal"),e.endFrame();return}}if(this.state!=="play"&&this.state!=="dead"&&this.state!=="floorDone"){e.endFrame();return}let i=t;this.hitstopT>0&&(this.hitstopT-=t,i*=.08),this.dtLogic=i,this.state==="play"&&(this.stats.time+=t);let s=this.player;if(e.aim=null,e.mouseActive){this.raycaster.setFromCamera(e.mouseNdc,this.camera),this.aimPlane.constant=-(s.y+1);let l=new D;this.raycaster.ray.intersectPlane(this.aimPlane,l)&&(e.aim=l)}let r=this.state==="play"&&!s.dead?this.nearestInteract():null;if(this.near=r,r&&r.kind==="item"&&r.data.cat==="artifact"&&e.down("interact"))for(let l=0;l<3;l++)e.pressed("art"+(l+1))&&(e.consume("art"+(l+1)),e.consume("interact"),this.pickupItem(r,l),this.near=null);if(this.near&&this.near.kind==="item"&&e.pressed("store")&&(this.pickupItem(this.near,void 0,!0),this.near=null),this.near&&e.pressed("interact")&&(this.near.kind==="item"?this.pickupItem(this.near):this.near.interact()),this.state==="menu"){e.endFrame();return}if(this.state==="play"||s.dead){let l=s.x,h=s.z;s.update(i,e,this.time),s.vx=(s.x-l)/Math.max(i,1e-4),s.vz=(s.z-h)/Math.max(i,1e-4)}this.inHub||this.computeFlow();let a=this.dg.boss;a&&!this.bossActive&&!this.bossDead&&!this.gates.closed&&s.x>a.x+1.5&&s.x<a.x+a.w-1.5&&s.z>a.z+1.5&&s.z<a.z+a.d-1.5&&(this.bossActive=!0,this.gates.close(),this.boss.awake=!0,this.audio.play("roar"),this.audio.setBoss(!0),this.ui.setBoss(this.boss),this.ui.toast(this.boss.B.name,"#ff6a4a",!0),this.shake(.4));for(let l of this.enemies){if(!l.awake&&!l.dead&&Math.abs(l.x-s.x)+Math.abs(l.z-s.z)>40){l.rig.root.visible=!1;continue}l.rig.root.visible=(!l.dead||l.deadT<1.5)&&!l.hidden,l.update(i,this.time)}this.enemies=this.enemies.filter(l=>!l.removed);for(let l of this.projectiles)l.update(i);this.projectiles=this.projectiles.filter(l=>!l.dead);for(let l of this.loot)l.update(i,this.time);this.loot=this.loot.filter(l=>!l.dead);for(let l of this.chests)l.update(i);for(let l of this.braziers)l.update(i,this.time);for(let l of this.npcs)l.update(i);for(let l of this.questObjs)l.update(i,this.time);for(let l of this.portals)l.update(i);this.altar&&this.altar.update(i,this.time),this.gates.update(i),this.portal&&(this.portal.update(i),Math.hypot(s.x-this.portal.x,s.z-this.portal.z)<1&&this.state==="play"&&this.enterPortal());let o=this.effects;this.effects=[];let c=o.filter(l=>l.update(i));this.effects=c.concat(this.effects),this.world.update(this.time),this.animateFlames(i),this.ambient(i),this.particles.update(i),this.updateCamera(t),this.updateLights(),this.updateExplored(),this.updateFloats(t),this.audio.update(),this.ui.update(this),e.endFrame()}animateFlames(){let t=this.time;if(this.flames)for(let e=0;e<this.flames.length;e++){let i=this.flames[e],s=i.userData.base,r=1+Math.sin(t*15+e*1.7)*.08+Math.sin(t*27+e)*.05;i.scale.set(.34*s*(2-r),.6*s*r,1)}}ambient(t){let e=this.player,i=this.theme.ambient,s=()=>e.x+(Math.random()-.5)*24,r=()=>e.z+(Math.random()-.5)*24;Math.random()<t*25&&this.particles.mote(s(),e.y+Math.random()*4,r());for(let a of this.dg.torches)Math.abs(a.x-e.x)+Math.abs(a.z-e.z)>22||(Math.random()<t*2.5&&this.particles.ember(a.x+a.nx*.02,a.y+.45,a.z+a.nz*.02),Math.random()<t*10&&this.particles.fire(a.x+a.nx*.02,a.y+.2,a.z+a.nz*.02,1,.08,[1,.5,.15],.28));if(i==="embers"&&Math.random()<t*12&&this.particles.ember(s(),-.5,r(),[1,.45,.1]),i==="snow")for(let a=0;a<3;a++)Math.random()<t*20&&this.particles.add.emit(s(),e.y+6,r(),(Math.random()-.5)*.5,-1.2,(Math.random()-.5)*.5,5,.08,.02,.95,.97,1,1,0,0);if(i==="spores"&&Math.random()<t*14&&this.particles.add.emit(s(),e.y+Math.random()*2,r(),(Math.random()-.5)*.3,.25,(Math.random()-.5)*.3,4,.06,.02,.6,1,.5,1,0,0),i==="stars"&&Math.random()<t*20&&this.particles.add.emit(s(),-2-Math.random()*6,r(),0,.3,0,3,.1,.02,.8,.6,1,1,0,0),i==="drip"&&Math.random()<t*4&&this.particles.add.emit(s(),e.y+4.5,r(),0,-7,0,.6,.05,.02,.7,.8,.9,1,0,0),this.inHub&&this.campfire){let a=this.campfire;Math.random()<t*30&&this.particles.fire(a.x,this.floorAt(a.x,a.z)+.3,a.z,1,.35,[1,.5,.15],.6),Math.random()<t*6&&this.particles.ember(a.x,this.floorAt(a.x,a.z)+1,a.z)}}updateCamera(t){let e=this.player,i=this.input.aim&&!this.inHub?.12:0,s=e.x+(this.input.aim?(this.input.aim.x-e.x)*i:0),r=e.z+(this.input.aim?(this.input.aim.z-e.z)*i:0);this.camTarget.x=Bi(this.camTarget.x,s,6,t),this.camTarget.z=Bi(this.camTarget.z,r,6,t),this.camTarget.y=Bi(this.camTarget.y,e.y,5,t);let a=(this.bossActive?1.2:this.inHub?.85:1)*this.input.zoom;this.zoom=Bi(this.zoom,a,3,t);let o=this.shakeAmt;this.shakeAmt=Math.max(0,this.shakeAmt-t*2.2);let c=(Math.random()-.5)*o*.6,l=(Math.random()-.5)*o*.6;this.camera.position.set(this.camTarget.x+$d.x*this.zoom+c,this.camTarget.y+$d.y*this.zoom+l,this.camTarget.z+$d.z*this.zoom-c),this.camera.lookAt(this.camTarget.x,this.camTarget.y+.8,this.camTarget.z);let h=48/this.moon.shadow.mapSize.x,u=Math.round(this.camTarget.x/h)*h,d=Math.round(this.camTarget.z/h)*h;this.moon.position.set(u-12,26,d+4),this.moon.target.position.set(u,0,d)}titleCam(){if(!this.dg)return;let t=this.dg.start,e=this.time*.05,i=17,s=t.cx,r=t.cz-5;this.camera.position.set(s+Math.cos(e)*i,12,r+Math.sin(e)*i),this.camera.lookAt(s,.5,r),this.camTarget.set(s,0,r),this.moon.position.set(s-12,26,r+4),this.moon.target.position.set(s,0,r);let a=this.player;a.rig.root.position.set(a.x,a.y,a.z)}updateExplored(){if(this.expT=(this.expT||0)-this.dtLogic,this.expT>0)return;this.expT=.15;let t=this.player,e=this.dg,i=9,s=!1,r=Math.floor(t.x),a=Math.floor(t.z);for(let o=-i;o<=i;o++)for(let c=-i;c<=i;c++){if(c*c+o*o>i*i)continue;let l=r+c,h=a+o;if(l<0||h<0||l>=e.W||h>=e.D)continue;let u=l+h*e.W;this.explored[u]||(this.explored[u]=1,s=!0)}s&&(this.ui.minimapDirty=!0)}updateFloats(t){let e=new D,i=innerWidth,s=innerHeight;this.floatTexts=this.floatTexts.filter(r=>(r.t+=t,r.t>.9?(r.el.remove(),!1):!0));for(let r of this.floatTexts)e.set(r.wx,r.y+r.t*1.4,r.wz).project(this.camera),r.el.style.opacity=String(Math.max(0,1-Math.max(0,r.t-.5)*2.5)),r.el.style.transform=`translate(${(e.x*.5+.5)*i+r.jx*30}px, ${(-e.y*.5+.5)*s}px) translate(-50%, -50%) scale(${r.big?1.3:1})`}};var Pe=(n,t=document)=>t.querySelector(n),Fh=(n,t,e)=>{let i=document.createElement(n);return t&&(i.className=t),e!==void 0&&(i.innerHTML=e),i},We={chamas:'<svg viewBox="0 0 32 32"><path d="M16 3c2 6 9 9 9 17a9 9 0 0 1-18 0c0-5 3-7 4-11 1 3 2 4 4 5-1-4 0-8 1-11z" fill="#ff7a2e"/><path d="M16 14c1 3 5 5 5 9a5 5 0 0 1-10 0c0-3 3-5 5-9z" fill="#ffd36a"/></svg>',raio:'<svg viewBox="0 0 32 32"><path d="M19 2L6 18h8l-3 12 15-18h-9z" fill="#8fd8ff" stroke="#fff" stroke-width="1"/></svg>',estandarte:'<svg viewBox="0 0 32 32"><rect x="7" y="3" width="2.5" height="27" fill="#a07850"/><path d="M9.5 5h15l-4 6 4 6h-15z" fill="#d8352a"/><circle cx="15" cy="11" r="2.2" fill="#ffd36a"/></svg>',vendaval:'<svg viewBox="0 0 32 32" fill="none" stroke="#c8e8d0" stroke-width="2.5" stroke-linecap="round"><path d="M4 11h15a4 4 0 1 0-4-4"/><path d="M4 17h21a4 4 0 1 1-4 4"/><path d="M4 23h10"/></svg>',laminas:'<svg viewBox="0 0 32 32"><g fill="#a89cff"><path d="M16 2l2 12-2 2-2-2z"/><path d="M29 22l-11-5-.5-2.7 2.7-.8z" /><path d="M5 24l7-10 2.7.6.3 2.8z"/></g><circle cx="16" cy="16" r="2.5" fill="#fff"/></svg>',gelo:'<svg viewBox="0 0 32 32" stroke="#8ff0ff" stroke-width="2.4" stroke-linecap="round"><path d="M16 3v26M4.7 9.5l22.6 13M4.7 22.5l22.6-13"/><path d="M12 5l4 4 4-4M12 27l4-4 4 4" fill="none"/></svg>',pocao:'<svg viewBox="0 0 32 32"><rect x="12" y="2" width="8" height="5" rx="1" fill="#a07850"/><path d="M13 7h6v5l6 7a8 8 0 1 1-18 0l6-7z" fill="#c8d0d8" opacity=".5"/><path d="M8.5 19h15a8 8 0 1 1-15 0z" fill="#e0303a"/><circle cx="13" cy="21" r="1.6" fill="#ff9a9a"/></svg>',flecha:'<svg viewBox="0 0 32 32"><path d="M5 27L25 7" stroke="#d8c8a0" stroke-width="2.5"/><path d="M25 7l-7 1 6 6z" fill="#c0c8d0"/><path d="M5 27l1-6 2 4 4 2z" fill="#e05040"/></svg>',frag:'<svg viewBox="0 0 32 32"><path d="M16 2l8 12-8 16-8-16z" fill="#b070ff" stroke="#e8d0ff" stroke-width="1.2"/><path d="M16 2l3 12-3 16" fill="#d8b0ff" opacity=".6"/></svg>',bag:'<svg viewBox="0 0 32 32"><path d="M9 11h14l2 17H7z" fill="#8a5a30" stroke="#3a2410" stroke-width="1.5"/><path d="M12 11c0-6 8-6 8 0" fill="none" stroke="#c8a060" stroke-width="2"/><rect x="13" y="16" width="6" height="4" rx="1" fill="#e3b95c"/></svg>',book:'<svg viewBox="0 0 32 32"><path d="M6 5h9c1 0 1 1 1 2v21c0-1-1-2-2-2H6z" fill="#e8dcc0"/><path d="M26 5h-9c-1 0-1 1-1 2v21c0-1 1-2 2-2h8z" fill="#d8ccb0"/><path d="M6 5v21M26 5v21" stroke="#6a4a2a" stroke-width="2"/></svg>',ouro:'<svg viewBox="0 0 32 32"><circle cx="16" cy="16" r="11" fill="#e8b440" stroke="#8a6010" stroke-width="2"/><circle cx="16" cy="16" r="6" fill="none" stroke="#fff3b0" stroke-width="1.5" opacity=".7"/></svg>',melee:'<svg viewBox="0 0 32 32"><path d="M24 3l5 0 0 5-15 15-5-5z" fill="#d0d6de"/><path d="M8 17l7 7-2 2-7-7z" fill="#e0b050"/><path d="M8 24l-4 4" stroke="#8a5a30" stroke-width="3"/></svg>',bow:'<svg viewBox="0 0 32 32" fill="none"><path d="M8 4c14 4 14 20 0 24" stroke="#b08050" stroke-width="3"/><path d="M8 4v24" stroke="#ddd" stroke-width="1"/></svg>',armor:'<svg viewBox="0 0 32 32"><path d="M6 6l6-3h8l6 3-2 8v13H8V14z" fill="#b8c0c8"/><path d="M12 3h8v6h-8z" fill="#606870"/></svg>'};var zh=class{constructor(t,e){this.root=t,this.input=e,this.on={},this.cache={},t.innerHTML=`
      <div id="hurt"></div>
      <div id="bars"></div>
      <div id="floats"></div>
      <div id="hud" class="hidden">
        <div id="floorinfo"><div id="floorname"></div><div id="objective"></div><div id="qtrack"></div>
          <div id="hudbtns"><div class="hb" data-act="bag" title="Bolsa (I)">${We.bag}</div><div class="hb" data-act="journal" title="Miss\xF5es (O)">${We.book}</div></div></div>
        <div id="mapwrap"><canvas id="minimap" width="200" height="200"></canvas><div class="mapn">N</div></div>
        <div id="bossbar" class="hidden"><div id="bossname"></div><div class="bar"><div id="bossfill"></div><div id="bossghost"></div></div></div>
        <div id="toasts"></div>
        <div id="prompt" class="hidden"></div>
        <div id="bottom">
          <div id="xpbar"><div id="xpfill"></div><span id="lvl"></span></div>
          <div id="hotbar">
            <div class="slot big" id="s-potion" data-act="potion"><div class="ico">${We.pocao}</div><div class="cd"></div><kbd>Q</kbd></div>
            <div id="orb"><div id="orbfill"></div><div id="orbshine"></div><span id="hptext"></span><div id="rollpip"></div></div>
            <div class="slot" id="s-art0" data-act="art1"><div class="ico"></div><div class="cd"></div><kbd>1</kbd></div>
            <div class="slot" id="s-art1" data-act="art2"><div class="ico"></div><div class="cd"></div><kbd>2</kbd></div>
            <div class="slot" id="s-art2" data-act="art3"><div class="ico"></div><div class="cd"></div><kbd>3</kbd></div>
          </div>
          <div id="res"><span class="r">${We.flecha}<b id="arrows"></b></span><span class="r">${We.ouro}<b id="gold"></b></span><span class="r">${We.frag}<b id="frags"></b></span></div>
          <div id="gear"></div>
        </div>
      </div>
      <div id="touch" class="hidden">
        <div class="tb" data-act="attack" style="right:20px;bottom:110px;width:84px;height:84px">\u2694</div>
        <div class="tb" data-act="shoot" style="right:118px;bottom:40px">\u{1F3F9}</div>
        <div class="tb" data-act="roll" style="right:118px;bottom:140px">\u27F2</div>
        <div class="tb" data-act="interact" style="right:30px;bottom:210px">E</div>
        <div class="tb small" data-act="store" style="right:104px;bottom:236px;width:48px;height:48px;font-size:15px">G</div>
        <div class="tb" data-act="pause" style="right:16px;top:230px;width:44px;height:44px">\u275A\u275A</div>
      </div>
      <div id="panel" class="hidden"></div>`,this.hud=Pe("#hud"),this.panel=Pe("#panel"),this.floats=Pe("#floats"),this.mm=Pe("#minimap"),this.mctx=this.mm.getContext("2d");for(let i of t.querySelectorAll("[data-act]")){let s=i.dataset.act,r=o=>{o.preventDefault(),e.setTouch(s,!0),i.classList.add("down")},a=o=>{o.preventDefault(),e.setTouch(s,!1),i.classList.remove("down")};i.addEventListener("touchstart",r,{passive:!1}),i.addEventListener("touchend",a),i.addEventListener("touchcancel",a),i.addEventListener("mousedown",o=>{(i.classList.contains("slot")||i.classList.contains("hb"))&&(e.setTouch(s,!0),setTimeout(()=>e.setTouch(s,!1),60),o.stopPropagation())})}("ontouchstart"in window||navigator.maxTouchPoints>0)&&Pe("#touch").classList.remove("hidden")}showPanel(t,e=""){this.panel.className=e,this.panel.innerHTML=`<div class="card">${t}</div>`;for(let i of this.panel.querySelectorAll("[data-go]"))i.addEventListener("click",s=>{s.stopPropagation(),this.on[i.dataset.go]&&this.on[i.dataset.go](i)})}hidePanels(){this.panel.className="hidden",this.panel.innerHTML=""}showTitle(t,e){this.hud.classList.add("hidden"),this.showPanel(`
      <div class="logo"><span>Criptas</span><small>de</small><span>Valdor</span></div>
      <p class="sub">Des\xE7a \xE0s profundezas, cumpra contratos do Ref\xFAgio, atravesse dimens\xF5es<br>e derrote os guardi\xF5es que dormem sob a pedra.</p>
      ${e?'<button data-go="continue" class="primary">Continuar</button>':""}
      <button data-go="play" class="${e?"":"primary"}">Novo jogo</button>
      <button data-go="controls">Controles</button>
      ${t>1?`<p class="best">Andar mais profundo alcan\xE7ado: <b>${t}</b></p>`:""}
      <p class="tiny">Tudo neste jogo \u2014 texturas, modelos, m\xFAsica e efeitos \u2014 \xE9 gerado por c\xF3digo.</p>`,"title")}controlsHtml(){return`<h2>Controles</h2>
      <table class="keys">
        <tr><td><kbd>W</kbd><kbd>A</kbd><kbd>S</kbd><kbd>D</kbd> / setas</td><td>Mover</td></tr>
        <tr><td>Mouse</td><td>Mirar</td></tr>
        <tr><td>Bot\xE3o esquerdo / <kbd>J</kbd></td><td>Ataque corpo a corpo (segure para combo)</td></tr>
        <tr><td>Bot\xE3o direito / <kbd>K</kbd></td><td>Atirar com o arco</td></tr>
        <tr><td><kbd>Espa\xE7o</kbd> / <kbd>Shift</kbd></td><td>Rolar (invulner\xE1vel)</td></tr>
        <tr><td><kbd>Q</kbd></td><td>Po\xE7\xE3o de vida</td></tr>
        <tr><td><kbd>1</kbd> <kbd>2</kbd> <kbd>3</kbd></td><td>Artefatos</td></tr>
        <tr><td><kbd>E</kbd></td><td>Interagir / equipar item (segure <kbd>E</kbd> + <kbd>1-3</kbd> para escolher o slot do artefato)</td></tr>
        <tr><td><kbd>G</kbd></td><td>Guardar o item do ch\xE3o na bolsa</td></tr>
        <tr><td><kbd>I</kbd> / <kbd>Tab</kbd></td><td>Bolsa (invent\xE1rio)</td></tr>
        <tr><td><kbd>O</kbd></td><td>Di\xE1rio de miss\xF5es</td></tr>
        <tr><td>Roda do mouse</td><td>Zoom</td></tr>
        <tr><td><kbd>Esc</kbd> / <kbd>P</kbd></td><td>Pausa</td></tr>
      </table>
      <p class="tiny">Controle (gamepad): anal\xF3gico esquerdo move, direito mira, X ataca, RT atira, A rola, B po\xE7\xE3o, Y interage, LB/LT/RB artefatos.<br>No celular: arraste no lado esquerdo para andar e use os bot\xF5es \xE0 direita (a mira \xE9 autom\xE1tica).</p>
      <button data-go="back">Voltar</button>`}showControls(t){this.on.back=t,this.showPanel(this.controlsHtml(),"title")}showPause(t){let e=t.quality;this.showPanel(`<h2>Pausado</h2>
      <button data-go="resume" class="primary">Continuar</button>
      <button data-go="controlsP">Controles</button>
      <button data-go="mute">Som: ${t.audio.muted?"desligado":"ligado"}</button>
      <button data-go="quality">Gr\xE1ficos: ${e}</button>
      ${t.inHub?"":'<button data-go="retry">Reiniciar este n\xEDvel</button><button data-go="hub">Desistir e voltar ao Ref\xFAgio</button>'}
      <button data-go="menu">Salvar e sair ao menu</button>
      ${this.statsHtml(t)}`)}statsHtml(t){let e=t.player,i=s=>s?`<span style="color:${Li[s.rarity].color}">${s.name}</span>`:"\u2014";return`<div class="gearlist">
      <div>${We.melee}${i(e.equip.melee)}</div><div>${We.bow}${i(e.equip.bow)}</div><div>${We.armor}${i(e.equip.armor)}</div>
      ${e.equip.arts.map(s=>`<div>${s?We[s.kind]:'<span class="ph"></span>'}${i(s)}</div>`).join("")}
      <div class="lv">N\xEDvel ${e.level} \xB7 Vida ${Math.round(e.maxHp)} \xB7 Prote\xE7\xE3o ${Math.round(e.dr*100)}% \xB7 Andar mais fundo ${t.depth}</div></div>`}showDeath(t){this.showPanel(`<h2 class="red">Voc\xEA caiu</h2>
      <p class="sub">As sombras de ${t.theme.name} reclamam mais um aventureiro.</p>
      <div class="stats"><div><b>${t.level}</b>n\xEDvel do lugar</div><div><b>${t.stats.kills}</b>inimigos</div><div><b>${t.player.level}</b>seu n\xEDvel</div></div>
      <button data-go="retry" class="primary">Tentar de novo</button>
      <button data-go="hub">Voltar ao Ref\xFAgio</button>
      <p class="tiny">Nas duas op\xE7\xF5es voc\xEA volta com o equipamento, o ouro e as miss\xF5es que tinha ao entrar neste lugar.</p>`)}showFloorDone(t){let e=Math.round(t.stats.time-(t.stats.floorStart||0)),i=t.mode==="floor"&&t.floorNum%3===0,s=t.mode==="dim"?`${t.theme.name} conquistada!`:i?"Vit\xF3ria!":`Andar ${t.floorNum} conclu\xEDdo`,r=t.mode==="dim"?"O guardi\xE3o da dimens\xE3o caiu. Os fragmentos que ele guardava agora s\xE3o seus.":i?"O Colosso de Obsidiana caiu e o cora\xE7\xE3o da Forja Profunda se apagou. Mais abaixo, as profundezas continuam, cada vez mais cru\xE9is.":"O portal pulsa com uma luz quente: ele leva de volta ao Ref\xFAgio. O pr\xF3ximo andar espera por voc\xEA.";this.showPanel(`<h2>${s}</h2><p class="sub">${r}</p>
      <div class="stats"><div><b>${t.stats.kills}</b>inimigos</div><div><b>${t.player.gold}</b>ouro</div><div><b>${t.player.fragments}</b>fragmentos</div><div><b>${Math.floor(e/60)}:${String(e%60).padStart(2,"0")}</b>tempo</div></div>
      <button data-go="next" class="primary">Voltar ao Ref\xFAgio</button>`)}openStation(t,e,i={}){this.station=e,this.stationOpt=i;let s=t.player,r=`<div class="res2">${We.ouro}<b>${s.gold}</b> ${We.frag}<b>${s.fragments}</b> ${We.bag}<b>${s.bag.length}/18</b></div>`,a=i.msg?`<div class="smsg">${i.msg}</div>`:"",o="";if(e==="shop"){let c=i.tab||"buy";o=`<h2>Ilsa, a Mercadora</h2>${r}
        <div class="tabs"><button data-go="stab" data-tab="buy" class="${c==="buy"?"on":""}">Comprar</button><button data-go="stab" data-tab="sell" class="${c==="sell"?"on":""}">Vender</button></div>${a}`,c==="buy"?o+=`<div class="list">${t.consumables().map(l=>`<div class="row"><div class="rl"><b>${l.name}</b><small>${l.desc}</small></div><button data-go="buyc" data-id="${l.id}" ${l.ok&&s.gold>=l.price?"":"disabled"}>${l.price} ${We.ouro}</button></div>`).join("")}</div>
          <h3>Equipamentos</h3><div class="list">${t.stock.length?t.stock.map((l,h)=>this.itemRow(t,l,`<button data-go="buyi" data-i="${h}" ${s.gold>=Kr(l)*2?"":"disabled"}>${Kr(l)*2} ${We.ouro}</button>`)).join(""):'<p class="tiny">Esgotado. Volte depois de explorar mais.</p>'}</div>`:o+=`<div class="list">${s.bag.length?s.bag.map((l,h)=>this.itemRow(t,l,`<button data-go="sell" data-i="${h}">Vender ${Io(l)} ${We.ouro}</button>`)).join(""):'<p class="tiny">Sua bolsa est\xE1 vazia. Itens trocados v\xE3o para a bolsa; aperte G para guardar itens do ch\xE3o.</p>'}</div>`}else if(e==="smith")o=`<h2>Brom, o Ferreiro</h2>${r}<p class="sub">"Traga ouro e eu deixo seu a\xE7o 12% mais forte por golpe de martelo. At\xE9 +5."</p>${a}
        <div class="list">${[["melee",null,"Arma"],["bow",null,"Arco"],["armor",null,"Armadura"],["art",0,"Artefato 1"],["art",1,"Artefato 2"],["art",2,"Artefato 3"]].map(([l,h,u])=>{let d=l==="art"?s.equip.arts[h]:s.equip[l];if(!d)return`<div class="row"><div class="rl"><b>${u}</b><small>vazio</small></div></div>`;let f=(d.up||0)>=Po,p=vh(d);return this.itemRow(t,d,`<button data-go="upg" data-s="${l}" data-i="${h??""}" ${f||s.gold<p?"disabled":""}>${f?"M\xE1ximo":`+${(d.up||0)+1} \xB7 ${p} ${We.ouro}`}</button>`)}).join("")}</div>`;else if(e==="quests")o=`<h2>Quadro de Miss\xF5es</h2>${r}<p class="sub">Oren anota os contratos dos sobreviventes. Aceite at\xE9 3 de cada vez; a recompensa \xE9 entregue assim que voc\xEA cumprir.</p>${a}
        <h3>Ativas (${t.quests.length}/3)</h3><div class="list">${t.quests.length?t.quests.map((c,l)=>`<div class="row"><div class="rl"><b>${c.title}</b><small>${c.desc}</small><small class="rw">${ea(c.reward)}</small></div><div class="rr"><span class="prog">${c.have}/${c.need}</span><button data-go="qab" data-i="${l}" class="small">Abandonar</button></div></div>`).join(""):'<p class="tiny">Nenhuma miss\xE3o ativa.</p>'}</div>
        <h3>Contratos dispon\xEDveis</h3><div class="list">${t.offers.length?t.offers.map((c,l)=>`<div class="row"><div class="rl"><b>${c.title}</b><small>${c.desc}</small><small class="rw">${ea(c.reward)}</small></div><button data-go="qacc" data-i="${l}" ${t.quests.length>=3?"disabled":""}>Aceitar</button></div>`).join(""):'<p class="tiny">N\xE3o h\xE1 novos contratos. Volte depois da pr\xF3xima expedi\xE7\xE3o.</p>'}</div>`;else if(e==="bag"){let c=i.sel,l=c!==void 0?s.bag[c]:null;o=`<h2>Bolsa</h2>${r}${a}
        <div class="equipped">${["melee","bow","armor"].map(h=>this.tile(s.equip[h],`eq-${h}`)).join("")}${s.equip.arts.map((h,u)=>this.tile(h,`eq-a${u}`)).join("")}</div>
        <div class="grid">${Array.from({length:18},(h,u)=>this.tile(s.bag[u],u,c===u)).join("")}</div>
        ${l?`<div class="detail">${this.itemDetail(t,l)}<div class="acts">${l.cat==="artifact"?[0,1,2].map(h=>`<button data-go="equip" data-i="${c}" data-a="${h}">Equipar no slot ${h+1}</button>`).join(""):`<button data-go="equip" data-i="${c}" class="primary">Equipar</button>`}${t.inHub&&Math.hypot(s.x-t.npcs[0]?.x,s.z-t.npcs[0]?.z)<4?`<button data-go="sell" data-i="${c}" data-back="bag">Vender ${Io(l)}</button>`:""}<button data-go="disc" data-i="${c}">Descartar</button></div></div>`:'<p class="tiny">Clique num item para ver detalhes e equipar. No Ref\xFAgio, venda itens para Ilsa.</p>'}`}else if(e==="journal"){let c=t.theme.obj;o=`<h2>Di\xE1rio</h2>${r}
        <h3>Objetivo</h3><p class="sub">${t.inHub?`Descer ao Andar ${t.depth} pelo portal azul, ou viajar a uma dimens\xE3o pelo portal roxo.`:`${c.verb} os 3 ${c.plural} (${t.litCount}/3), abrir a arena e derrotar o guardi\xE3o.`}</p>
        <h3>Miss\xF5es (${t.quests.length}/3)</h3><div class="list">${t.quests.length?t.quests.map(l=>`<div class="row"><div class="rl"><b>${l.title}</b><small>${l.desc}</small><small class="rw">${ea(l.reward)}</small></div><span class="prog">${l.have}/${l.need}</span></div>`).join(""):'<p class="tiny">Aceite contratos no quadro de miss\xF5es do Ref\xFAgio.</p>'}</div>
        <div class="stats"><div><b>${t.stats.kills}</b>inimigos</div><div><b>${t.stats.quests||0}</b>miss\xF5es</div><div><b>${t.depth}</b>andar mais fundo</div><div><b>${Object.values(t.dimsDone).reduce((l,h)=>l+h,0)}</b>dimens\xF5es</div></div>`}else if(e==="dims"){let c=Math.max(3,t.depth)+1,l={geleira:["Uma fortaleza de gelo polido onde tudo reflete. O ch\xE3o escorrega; lobos de geada ca\xE7am em bando.","Ysra, a Rainha Hibernal"],pantano:["Ru\xEDnas afundadas numa \xE1gua rasa e escura, cheia de juncos e cogumelos que brilham.","M\xF3rbida, a Flor Ancestral"],vazio:["Plataformas de cristal flutuando sobre um abismo de estrelas. Um passo em falso \xE9 o fim.","Arauto do Vazio"]};o=`<h2>Portal das Dimens\xF5es</h2>${r}<p class="sub">Cada viagem consome 1 fragmento dimensional. N\xEDvel das dimens\xF5es: <b>${c}</b>. Guardi\xF5es de dimens\xE3o deixam 2 fragmentos e itens melhores.</p>${a}
        <div class="dims">${_o.map(h=>`<div class="dim dim-${h}"><h3>${zn[h].name}</h3><p>${l[h][0]}</p><small>Guardi\xE3o: ${l[h][1]}</small>${t.dimsDone[h]?`<small class="ok">Conquistada ${t.dimsDone[h]}\xD7</small>`:""}<button data-go="travel" data-k="${h}" ${s.fragments<1?"disabled":""}>Viajar (1 ${We.frag})</button></div>`).join("")}</div>`}this.showPanel(o+'<button data-go="close" class="closeb">Fechar (Esc)</button>',"station");for(let c of this.panel.querySelectorAll("[data-sel]"))c.addEventListener("click",()=>this.openStation(t,"bag",{sel:+c.dataset.sel}))}itemDetail(t,e){let i=Li[e.rarity],s=t.player,r=e.cat==="artifact"?null:s.equip[e.cat],a=r?wn(e)-wn(r):1;return`<div class="ititle" style="color:${i.color}">${e.name}</div><div class="icat">${i.name} \xB7 ${yh(e.cat)} \xB7 n\xEDvel ${e.floor||1}</div>
      ${e.cat==="artifact"?`<div class="desc">${Jr[e.kind].desc}</div>`:""}
      <table>${Do(e).map(([o,c])=>`<tr><td>${o}</td><td>${c}</td></tr>`).join("")}</table>
      ${Lo(e).length?`<ul>${Lo(e).map(o=>`<li>${o}</li>`).join("")}</ul>`:""}
      ${r?`<div class="vs">Equipado: <span style="color:${Li[r.rarity].color}">${r.name}</span> ${a>.5?'<i class="up">melhor</i>':a<-.5?'<i class="dn">pior</i>':""}</div>`:""}`}itemRow(t,e,i){let s=Li[e.rarity],r=t.player,a=e.cat==="artifact"?null:r.equip[e.cat],o=a&&a!==e?wn(e)-wn(a):0,c=e.cat==="artifact"?We[e.kind]:We[e.cat],l=Do(e).filter(h=>h[0]!=="Aprimoramento").slice(0,2).map(([h,u])=>`${h} ${u}`).join(" \xB7 ");return`<div class="row"><div class="ri">${c}</div><div class="rl"><b style="color:${s.color}">${e.name}</b><small>${s.name} \xB7 ${yh(e.cat)} \xB7 ${l} ${o>.5?'<i class="up">\u25B2 melhor</i>':o<-.5?'<i class="dn">\u25BC pior</i>':""}</small>${e.affixes.length?`<small class="aff">${Lo(e).join(" \xB7 ")}</small>`:""}</div>${i}</div>`}tile(t,e,i){if(!t)return'<div class="tile empty"></div>';let s=Li[t.rarity],r=t.cat==="artifact"?We[t.kind]:We[t.cat],a=typeof e=="number"?`data-sel="${e}"`:"";return`<div class="tile ${i?"sel":""} ${typeof e=="number"?"click":"eq"}" ${a} title="${t.name}" style="border-color:${s.color}">${r}${t.up?`<i>+${t.up}</i>`:""}</div>`}floorTitle(t,e){this.hud.classList.remove("hidden"),Pe("#floorname").textContent=`${t} \xB7 ${e}`,this.bigTitle(t,e)}bigTitle(t,e){let i=Fh("div","bigtitle",`<small>${t}</small>${e}`);this.root.appendChild(i),setTimeout(()=>i.remove(),4200)}toast(t,e="#e8e0d0",i=!1){let s=Fh("div","toast"+(i?" big":""),t);s.style.color=e;let r=Pe("#toasts");for(r.appendChild(s);r.children.length>4;)r.firstChild.remove();setTimeout(()=>{s.classList.add("out"),setTimeout(()=>s.remove(),600)},i?3200:2600)}hurtFlash(){let t=Pe("#hurt");t.classList.remove("on"),t.offsetWidth,t.classList.add("on")}makeFloat(t,e,i){let s=Fh("div","float"+(i?" big":""),t);return s.style.color=e,this.floats.appendChild(s),s}setBoss(t){this.boss=t,Pe("#bossbar").classList.toggle("hidden",!t),t&&(Pe("#bossname").textContent=t.B.name,this.bossGhost=1)}set(t,e,i){this.cache[t]!==e&&(this.cache[t]=e,i(e))}update(t){let e=t.player,i=Math.max(0,e.hp/e.maxHp);this.set("hp",Math.round(i*200),()=>{Pe("#orbfill").style.transform=`translateY(${(1-i)*100}%)`,Pe("#orb").classList.toggle("low",i<.3)}),this.set("hpt",`${Math.ceil(e.hp)}/${Math.round(e.maxHp)}`,u=>Pe("#hptext").textContent=u),this.set("xp",Math.round(e.xp/e.xpNext*100),u=>Pe("#xpfill").style.width=u+"%"),this.set("lvl",e.level,u=>Pe("#lvl").textContent="N\xEDvel "+u),this.set("arrows",e.arrows,u=>{Pe("#arrows").textContent=u,Pe("#arrows").classList.toggle("empty",u===0)}),this.set("gold",e.gold,u=>Pe("#gold").textContent=u),this.set("frags",e.fragments,u=>Pe("#frags").textContent=u);let s=t.quests.map(u=>u.id+":"+u.have).join();this.set("qtrack",s,()=>{Pe("#qtrack").innerHTML=t.quests.map(u=>`<div class="${u.done?"qd":""}">${u.title} <b>${u.have}/${u.need}</b></div>`).join("")}),this.set("roll",e.rollCd>0?Math.round(e.rollCd/e.rollMax*20):0,u=>{Pe("#rollpip").style.opacity=u?.35:1}),this.cool("#s-potion",e.potionCd/e.potionMax,e.potionCd);for(let u=0;u<3;u++){let d=e.equip.arts[u];this.set("art"+u,d?d.id:0,()=>{let f=Pe("#s-art"+u);f.querySelector(".ico").innerHTML=d?We[d.kind]:"",f.classList.toggle("empty",!d),f.style.borderColor=d?Li[d.rarity].color:"",f.title=d?d.name:""}),this.cool("#s-art"+u,d?e.artCd[u]/un(d):0,e.artCd[u])}let r=t.litCount,a=t.braziers.length,o=t.theme.obj,c=t.inHub?`Prepare-se. O portal azul leva ao Andar ${t.depth}; o roxo, \xE0s dimens\xF5es.`:t.bossDead?t.portal?"Entre no portal para voltar ao Ref\xFAgio.":"O guardi\xE3o caiu!":t.bossActive?`Derrote ${t.boss.B.name}.`:r<a?`${o.verb} os ${o.plural}: ${r}/${a}`:"Enfrente o guardi\xE3o na grande arena.";if(this.set("obj",c,u=>Pe("#objective").textContent=u),this.boss){let u=Math.max(0,this.boss.hp/this.boss.maxHp);this.bossGhost=Math.max(u,(this.bossGhost||1)-.004),Pe("#bossfill").style.width=u*100+"%",Pe("#bossghost").style.width=this.bossGhost*100+"%"}let l=t.near,h=l?l.kind==="item"?"i"+l.data.id+":"+t.player.equip.arts.map(u=>u&&u.id).join():l.prompt:"";this.set("prompt",h,()=>this.renderPrompt(t,l)),this.drawMinimap(t),this.enemyBars(t)}enemyBars(t){let e=this.barsBox||(this.barsBox=Pe("#bars"));this.barPool=this.barPool||[];let i=t.camera,s=t.player,r=innerWidth,a=innerHeight,o=[];for(let l of t.enemies)if(!(l.dead||l.isBoss||!l.awake||l.hp>=l.maxHp||!l.rig.root.visible)&&!(Math.abs(l.x-s.x)+Math.abs(l.z-s.z)>26)&&(o.push(l),o.length>=24))break;let c=this._v||(this._v=i.position.clone());for(let l=0;l<Math.max(o.length,this.barPool.length);l++){let h=this.barPool[l];h||(h=Fh("div","ebar","<i></i>"),e.appendChild(h),this.barPool.push(h));let u=o[l];if(!u){h._on&&(h.style.display="none",h._on=!1);continue}h._on||(h.style.display="",h._on=!0),c.set(u.x,u.y+1.35*u.rig.root.scale.y+.75,u.z).project(i),h.style.transform=`translate(${(c.x*.5+.5)*r}px, ${(-c.y*.5+.5)*a}px) translate(-50%, -50%)`,h.firstChild.style.width=Math.max(0,u.hp/u.maxHp*100)+"%",h.classList.toggle("elite",!!u.elite)}}cool(t,e,i){let s=Pe(t),r=Math.round(Math.max(0,e)*60);s._v!==r&&(s._v=r,s.querySelector(".cd").style.height=Math.max(0,Math.min(1,e))*100+"%",s.classList.toggle("ready",r===0))}renderPrompt(t,e){let i=Pe("#prompt");if(!e){i.classList.add("hidden");return}if(i.classList.remove("hidden"),e.kind!=="item"){i.className="simple",i.innerHTML=`<kbd>E</kbd> ${e.prompt}`;return}let s=e.data,r=Li[s.rarity],a=t.player,o=null,c="";if(s.cat==="artifact"){if(a.equip.arts.findIndex(g=>!g)<0){let g=1e9,_=0;a.equip.arts.forEach((T,v)=>{let S=wn(T);S<g&&(g=S,_=v)}),o=a.equip.arts[_],c=`<div class="hint">Substitui o slot ${_+1}. Segure <kbd>E</kbd> e aperte <kbd>1</kbd>-<kbd>3</kbd> para escolher outro.</div>`}}else o=a.equip[s.cat];let l=Do(s),h=o&&o.cat===s.cat?Do(o):null,u=m=>parseFloat(String(m).replace(",",".").replace("+","")),d=l.map(([m,g],_)=>{let T="";if(h&&h[_]&&h[_][0]===m){let v=u(g),S=u(h[_][1]);if(!isNaN(v)&&!isNaN(S)&&Math.abs(v-S)>.01){let M=m==="Recarga"?v<S:v>S;T=`<i class="${M?"up":"dn"}">${M?"\u25B2":"\u25BC"}</i>`}}return`<tr><td>${m}</td><td>${g} ${T}</td></tr>`}).join(""),f=Lo(s).map(m=>`<li>${m}</li>`).join(""),p=s.cat==="artifact"?`<div class="desc">${Jr[s.kind].desc}</div>`:"",x=o?wn(s)-wn(o):1;i.className="item",i.innerHTML=`<div class="ititle" style="color:${r.color}">${s.name}</div>
      <div class="icat">${r.name} \xB7 ${yh(s.cat)}</div>${p}
      <table>${d}</table>${f?`<ul>${f}</ul>`:""}
      ${o?`<div class="vs">Equipado: <span style="color:${Li[o.rarity].color}">${o.name}</span> ${x>.5?'<i class="up">melhor</i>':x<-.5?'<i class="dn">pior</i>':""}</div>`:""}
      ${c}<div class="act"><kbd>E</kbd> Equipar &nbsp; <kbd>G</kbd> Guardar na bolsa</div>`,i.style.borderColor=r.color}buildMinimap(t){let e=t.dg,i=3;this.off=document.createElement("canvas"),this.off.width=e.W*i,this.off.height=e.D*i,this.minimapDirty=!0}drawMinimap(t){let e=t.dg,i=3,s=this.off;if(!s)return;if(this.minimapDirty){this.minimapDirty=!1;let d=s.getContext("2d");d.clearRect(0,0,s.width,s.height);let f=e.boss;for(let p=0;p<e.D;p++)for(let x=0;x<e.W;x++){let m=x+p*e.W;if(!t.explored[m])continue;let g=e.cell[m],_=null;g===St.FLOOR||g===St.PILLAR?_=f&&x>=f.x&&x<f.x+f.w&&p>=f.z&&p<f.z+f.d?"#8a5a50":e.h[m]>0?"#a89a86":"#857a6c":g===St.WALL?_="#2e2925":g===St.PILLAR?_="#3a342e":g===St.WATER?_="#2c5a68":g===St.LAVA?_="#d05a1a":g===St.PIT&&(_="#0c0b0a"),_&&(d.fillStyle=_,d.fillRect(x*i,p*i,i,i))}}let r=this.mctx,a=this.mm.width,o=t.player;r.clearRect(0,0,a,a),r.save(),r.beginPath(),r.arc(a/2,a/2,a/2-2,0,Math.PI*2),r.clip(),r.fillStyle="rgba(8,7,6,0.8)",r.fillRect(0,0,a,a),r.translate(a/2,a/2),r.rotate(Math.PI/4),r.scale(1.15,1.15),r.translate(-o.x*i,-o.z*i),r.drawImage(s,0,0);let c=(d,f,p,x,m)=>{r.beginPath(),r.arc(d*i,f*i,p,0,Math.PI*2),r.fillStyle=x,r.fill(),m&&(r.strokeStyle=m,r.lineWidth=1.5,r.stroke())},l=(d,f)=>t.explored[Math.floor(d)+Math.floor(f)*e.W];for(let d of t.chests)!d.opened&&l(d.x,d.z)&&c(d.x,d.z,3,"#e8b440");for(let d of t.loot)d.kind==="item"&&c(d.x,d.z,2.5,Li[d.data.rarity].color);t.altar&&l(t.altar.x,t.altar.z)&&c(t.altar.x,t.altar.z,3.5,"#ffd36a","#fff");for(let d of t.enemies)!d.dead&&d.awake&&!d.isBoss&&Math.hypot(d.x-o.x,d.z-o.z)<24&&c(d.x,d.z,2,"#e04030");let h=performance.now()/1e3;for(let d of t.braziers)c(d.x,d.z,d.lit?4.5:3.5+Math.sin(h*4),d.lit?"#ffcc50":"#ff7a20",d.lit?"#fff":"#3a1a08");for(let d of t.questObjs)!d.freed&&!d.taken&&c(d.x,d.z,4+Math.sin(h*5)*.8,"#ffd24a","#fff");for(let d of t.npcs)c(d.x,d.z,3.5,"#6ad0ff","#fff");for(let d of t.portals)c(d.x,d.z,4.5,d.kind==="dim"?"#c070ff":"#6fd8ff","#fff");let u=e.boss;if(u&&t.litCount>=t.braziers.length&&!t.bossDead&&(r.save(),r.translate((u.x+u.w/2)*i,(u.z+u.d/2)*i),r.rotate(-Math.PI/4),r.font="bold 16px serif",r.textAlign="center",r.textBaseline="middle",r.fillStyle="#ff5a40",r.fillText("\u2620",0,0),r.restore()),t.boss&&t.bossActive&&c(t.boss.x,t.boss.z,5,"#ff3020","#fff"),t.portal&&c(t.portal.x,t.portal.z,5+Math.sin(h*5),"#6fd8ff","#fff"),t.gates.closed&&e.gates.length){r.fillStyle="#c03020";for(let d of e.gates)l(d.x,d.z)&&r.fillRect(d.x*i,d.z*i,i,i)}r.save(),r.translate(o.x*i,o.z*i),r.rotate(Math.atan2(Math.cos(o.rot),Math.sin(o.rot))),r.beginPath(),r.moveTo(7,0),r.lineTo(-4,4.5),r.lineTo(-2,0),r.lineTo(-4,-4.5),r.closePath(),r.fillStyle="#fff",r.fill(),r.strokeStyle="#1a3a7a",r.lineWidth=1.5,r.stroke(),r.restore(),r.restore()}};var Mb={up:["KeyW","ArrowUp"],down:["KeyS","ArrowDown"],left:["KeyA","ArrowLeft"],right:["KeyD","ArrowRight"],attack:["M0","KeyJ"],shoot:["M2","KeyK","KeyL"],roll:["Space","ShiftLeft","ShiftRight"],potion:["KeyQ","KeyH"],art1:["Digit1","Numpad1"],art2:["Digit2","Numpad2"],art3:["Digit3","Numpad3"],interact:["KeyE","KeyF","Enter"],pause:["Escape","KeyP"],bag:["KeyI","KeyB","Tab"],journal:["KeyO"],store:["KeyG"]},Sb={roll:[0],potion:[1],attack:[2,5],interact:[3],shoot:[7],art1:[4],art2:[6],art3:[8],pause:[9]},Oh=class{constructor(t){this.keys=new Set,this.pressedSet=new Set,this.consumed=new Set,this.mouseNdc=new ot,this.mouseActive=!1,this.zoom=1,this.ax=0,this.ay=0,this.aim=null,this.aimStick=null,this.touch={id:null,ox:0,oy:0,x:0,y:0},this.touchActions=new Set,this.isTouch=!1,this.padPrev=new Set;let e=r=>{this.keys.has(r)||this.pressedSet.add(r),this.keys.add(r)},i=r=>this.keys.delete(r);addEventListener("keydown",r=>{(r.code==="Tab"||r.code==="Space"||r.code.startsWith("Arrow"))&&r.preventDefault(),r.repeat||e(r.code)}),addEventListener("keyup",r=>i(r.code)),addEventListener("blur",()=>{this.keys.clear(),this.touchActions.clear()}),t.addEventListener("mousedown",r=>{this.mouseActive=!0,e("M"+r.button)}),addEventListener("mouseup",r=>i("M"+r.button)),addEventListener("mousemove",r=>{this.mouseNdc.set(r.clientX/innerWidth*2-1,-(r.clientY/innerHeight)*2+1),this.isTouch||(this.mouseActive=!0)}),t.addEventListener("contextmenu",r=>r.preventDefault()),addEventListener("wheel",r=>{this.zoom=Math.min(1.35,Math.max(.7,this.zoom+Math.sign(r.deltaY)*.06))},{passive:!0}),t.addEventListener("touchstart",r=>{this.isTouch=!0,this.mouseActive=!1;for(let a of r.changedTouches)a.clientX<innerWidth*.5&&this.touch.id===null&&(this.touch={id:a.identifier,ox:a.clientX,oy:a.clientY,x:a.clientX,y:a.clientY});r.preventDefault()},{passive:!1}),t.addEventListener("touchmove",r=>{for(let a of r.changedTouches)a.identifier===this.touch.id&&(this.touch.x=a.clientX,this.touch.y=a.clientY);r.preventDefault()},{passive:!1});let s=r=>{for(let a of r.changedTouches)a.identifier===this.touch.id&&(this.touch.id=null)};t.addEventListener("touchend",s),t.addEventListener("touchcancel",s)}setTouch(t,e){e?(this.touchActions.has(t)||this.pressedSet.add("T:"+t),this.touchActions.add(t)):this.touchActions.delete(t)}codes(t){return Mb[t]||[]}down(t){return this.touchActions.has(t)||this.padDown&&this.padDown.has(t)?!0:this.codes(t).some(e=>this.keys.has(e))}pressed(t){return this.consumed.has(t)?!1:this.pressedSet.has("T:"+t)||this.pressedSet.has("P:"+t)?!0:this.codes(t).some(e=>this.pressedSet.has(e))}consume(t){this.consumed.add(t)}poll(){let t=0,e=0;if(this.down("left")&&(t-=1),this.down("right")&&(t+=1),this.down("up")&&(e+=1),this.down("down")&&(e-=1),this.touch.id!==null){let r=this.touch.x-this.touch.ox,a=this.touch.y-this.touch.oy,o=55,c=Math.hypot(r,a);if(c>8){let l=Math.min(1,c/o)/c;t+=r*l,e-=a*l}}this.aimStick=null,this.padDown=new Set;let i=[];try{i=navigator.getGamepads?navigator.getGamepads():[]}catch{i=[]}for(let r of i){if(!r)continue;let a=l=>Math.abs(l)<.18?0:l;t+=a(r.axes[0]),e-=a(r.axes[1]);let o=a(r.axes[2]||0),c=a(r.axes[3]||0);Math.hypot(o,c)>.35&&(this.aimStick=[o,-c],this.mouseActive=!1);for(let[l,h]of Object.entries(Sb))h.some(u=>r.buttons[u]&&r.buttons[u].pressed)&&(this.padDown.add(l),this.padPrev.has(l)||this.pressedSet.add("P:"+l));r.buttons[12]&&r.buttons[12].pressed&&(e+=1),r.buttons[13]&&r.buttons[13].pressed&&(e-=1),r.buttons[14]&&r.buttons[14].pressed&&(t-=1),r.buttons[15]&&r.buttons[15].pressed&&(t+=1),(this.padDown.size||Math.abs(r.axes[0])>.3||Math.abs(r.axes[1])>.3)&&(this.mouseActive=!1);break}this.padPrev=this.padDown;let s=Math.hypot(t,e);s>1&&(t/=s,e/=s),this.ax=t,this.ay=e}endFrame(){this.pressedSet.clear(),this.consumed.clear()}};var kh=class{constructor(){this.ctx=null,this.muted=!1,this.vol=.8}init(){if(this.ctx){this.ctx.state==="suspended"&&this.ctx.resume();return}try{this.ctx=new(window.AudioContext||window.webkitAudioContext)}catch{return}let t=this.ctx;this.master=t.createGain(),this.master.gain.value=this.vol;let e=t.createDynamicsCompressor();e.threshold.value=-14,e.ratio.value=4,this.master.connect(e),e.connect(t.destination),this.sfx=t.createGain(),this.sfx.gain.value=.9,this.sfx.connect(this.master),this.music=t.createGain(),this.music.gain.value=.35,this.music.connect(this.master),this.rev=t.createConvolver();let i=t.sampleRate*2.2,s=t.createBuffer(2,i,t.sampleRate);for(let o=0;o<2;o++){let c=s.getChannelData(o);for(let l=0;l<i;l++)c[l]=(Math.random()*2-1)*Math.pow(1-l/i,3)}this.rev.buffer=s;let r=t.createGain();r.gain.value=.35,this.rev.connect(r),r.connect(this.master),this.noise=t.createBuffer(1,t.sampleRate,t.sampleRate);let a=this.noise.getChannelData(0);for(let o=0;o<a.length;o++)a[o]=Math.random()*2-1;this.startAmbient()}setMuted(t){this.muted=t,this.master&&(this.master.gain.value=t?0:this.vol)}get t(){return this.ctx.currentTime}ok(){return this.ctx&&!this.muted}env(t,e,i,s,r){t.gain.setValueAtTime(1e-4,e),t.gain.exponentialRampToValueAtTime(s,e+i),t.gain.exponentialRampToValueAtTime(1e-4,e+i+r)}osc(t,e,i,s,r,a,o=0,c=.2){let l=this.ctx,h=this.t+o,u=l.createOscillator(),d=l.createGain();if(u.type=t,u.frequency.setValueAtTime(e,h),i!==e&&u.frequency.exponentialRampToValueAtTime(Math.max(1,i),h+s),this.env(d,h,.005,r,s),u.connect(d),d.connect(a||this.sfx),c){let f=l.createGain();f.gain.value=c,d.connect(f),f.connect(this.rev)}u.start(h),u.stop(h+s+.05)}nz(t,e,i,s,r,a=1,o=0,c=.25){let l=this.ctx,h=this.t+o,u=l.createBufferSource();u.buffer=this.noise,u.loop=!0;let d=l.createBiquadFilter();d.type=i,d.Q.value=a,d.frequency.setValueAtTime(s,h),d.frequency.exponentialRampToValueAtTime(Math.max(20,r),h+t);let f=l.createGain();if(this.env(f,h,.004,e,t),u.connect(d),d.connect(f),f.connect(this.sfx),c){let p=l.createGain();p.gain.value=c,f.connect(p),p.connect(this.rev)}u.start(h,Math.random()*.5),u.stop(h+t+.05)}play(t,e=1){if(!this.ok())return;let i=()=>.9+Math.random()*.2;switch(t){case"swing":this.nz(.16,.35*e,"bandpass",900*i(),3500,1.5);break;case"swingHeavy":this.nz(.3,.45*e,"bandpass",400*i(),1500,1.2);break;case"hit":this.osc("sine",180*i(),60,.12,.5*e),this.nz(.08,.35*e,"lowpass",3e3,400);break;case"crit":this.osc("square",900,300,.1,.12*e),this.osc("sine",200,50,.2,.6*e),this.nz(.12,.4*e,"highpass",2e3,800);break;case"boneHit":this.nz(.07,.4*e,"bandpass",2500*i(),1200,4),this.osc("triangle",500*i(),200,.06,.2*e);break;case"bow":this.osc("triangle",260*i(),90,.12,.25*e),this.nz(.14,.15*e,"highpass",3e3,6e3);break;case"arrowHit":this.nz(.05,.3*e,"bandpass",1800,900,3);break;case"hurt":this.osc("sawtooth",220,110,.18,.18*e),this.nz(.15,.3*e,"lowpass",1500,300);break;case"roll":this.nz(.25,.25*e,"bandpass",500,1400,.8);break;case"plantHit":this.nz(.09,.4*e,"bandpass",700*i(),300,2),this.osc("triangle",160*i(),80,.1,.3*e);break;case"squish":this.nz(.14,.35*e,"lowpass",1200*i(),200,3),this.osc("sine",300*i(),90,.12,.25*e);break;case"glass":this.osc("sine",2200*i(),1800,.18,.1*e,null,0,.5),this.osc("sine",3300*i(),2600,.12,.06*e,null,.02,.5),this.nz(.06,.2*e,"highpass",4e3,6e3);break;case"shell":this.nz(.08,.45*e,"bandpass",1400*i(),700,5),this.osc("square",220*i(),120,.06,.08*e);break;case"thorn":this.nz(.1,.25*e,"highpass",2500,5e3),this.osc("triangle",500*i(),250,.08,.12*e);break;case"anvil":this.osc("sine",880,870,.8,.25*e,null,0,.5),this.osc("sine",1320,1300,.6,.12*e,null,0,.5),this.osc("sine",2210,2200,.4,.06*e,null,0,.5),this.nz(.05,.4*e,"highpass",3e3,5e3);break;case"coin":this.osc("sine",1800*i(),1800,.06,.12*e,null,0,.3),this.osc("sine",2400*i(),2400,.12,.1*e,null,.05,.3);break;case"pickup":this.osc("triangle",520,520,.1,.2*e),this.osc("triangle",780,780,.2,.2*e,null,.08);break;case"potion":for(let s=0;s<5;s++)this.osc("sine",300+Math.random()*500,800,.08,.15*e,null,s*.06);break;case"die":this.osc("sawtooth",160*i(),40,.45,.15*e),this.nz(.3,.2*e,"lowpass",900,100);break;case"explode":this.nz(.9,.9*e,"lowpass",1800,60,.7),this.osc("sine",90,30,.6,.8*e);break;case"fire":this.nz(.7,.5*e,"lowpass",400,2400,.7),this.osc("sawtooth",80,160,.5,.1*e);break;case"zap":for(let s=0;s<6;s++)this.nz(.05,.4*e,"highpass",3e3+Math.random()*3e3,1500,1,s*.035);this.osc("square",120,60,.3,.12*e);break;case"freeze":this.osc("sine",2e3,900,.5,.12*e),this.nz(.6,.25*e,"highpass",5e3,2500);break;case"wind":this.nz(.7,.5*e,"bandpass",300,1400,.6);break;case"chest":this.osc("triangle",150,120,.3,.3*e),this.nz(.4,.15*e,"bandpass",700,300,3),[660,880,1100,1320].forEach((s,r)=>this.osc("sine",s,s,.3,.1*e,null,.25+r*.07,.5));break;case"pot":this.nz(.2,.5*e,"bandpass",1500,600,1.5),this.osc("triangle",700*i(),300,.1,.2*e);break;case"brazier":this.nz(1.2,.6*e,"lowpass",300,3e3,.6),[220,330,440].forEach((s,r)=>this.osc("sine",s,s,1.2,.1*e,null,r*.1,.6));break;case"gate":this.nz(1.4,.5*e,"lowpass",200,90,1);for(let s=0;s<8;s++)this.osc("square",60+Math.random()*20,50,.06,.1*e,null,s*.15);break;case"levelup":[392,523,659,784,1046].forEach((s,r)=>this.osc("triangle",s,s,.35,.18*e,null,r*.09,.5));break;case"roar":this.osc("sawtooth",90,50,1.4,.3*e),this.osc("sawtooth",93,48,1.4,.3*e),this.nz(1.3,.5*e,"lowpass",600,150,.6);break;case"slam":this.osc("sine",70,25,.7,1*e),this.nz(.6,.7*e,"lowpass",800,60);break;case"summon":this.osc("sine",200,600,.6,.15*e,null,0,.8),this.osc("sine",300,900,.6,.1*e,null,.1,.8);break;case"bolt":this.osc("sine",700,200,.3,.15*e),this.nz(.25,.15*e,"bandpass",1200,400,3);break;case"fuse":for(let s=0;s<6;s++)this.osc("square",500+s*120,500+s*120,.05,.08*e,null,s*.18);break;case"hiss":this.nz(.35,.3*e,"highpass",4e3,2e3,1);break;case"portal":this.osc("sine",110,440,1.5,.2*e,null,0,.8),this.osc("sine",165,660,1.5,.15*e,null,.2,.8);break;case"step":this.nz(.05,.05*e,"lowpass",600*i(),200,1,0,.05);break;case"deny":this.osc("square",180,150,.15,.1*e);break;case"banner":[262,330,392].forEach((s,r)=>this.osc("sawtooth",s,s,.5,.08*e,null,r*.05,.4));break}}startAmbient(){let t=this.ctx,e=t.createBiquadFilter();e.type="lowpass",e.frequency.value=500,e.connect(this.music);let i=t.createOscillator(),s=t.createGain();i.frequency.value=.07,s.gain.value=200,i.connect(s),s.connect(e.frequency),i.start(),this.drone=[];for(let a of[55,55.4,82.4]){let o=t.createOscillator();o.type="sawtooth",o.frequency.value=a;let c=t.createGain();c.gain.value=.08,o.connect(c),c.connect(e),o.start(),this.drone.push(o)}this.padBus=t.createGain(),this.padBus.gain.value=.6,this.padBus.connect(e);let r=t.createGain();r.gain.value=.5,this.padBus.connect(r),r.connect(this.rev),this.chords=[[220,261.6,329.6],[174.6,220,261.6],[196,246.9,293.7],[164.8,196,246.9]],this.chordI=0,this.nextChord=0,this.nextDrip=2,this.bossMode=!1,this.beat=0,this.nextBeat=0}setBoss(t){this.bossMode=t}update(){if(!this.ctx||this.muted)return;let t=this.t;if(t>this.nextChord){let e=this.chords[this.chordI++%this.chords.length];for(let i of e){let s=this.ctx.createOscillator(),r=this.ctx.createGain();s.type="triangle",s.frequency.value=i*(this.bossMode?.5:1),r.gain.setValueAtTime(1e-4,t),r.gain.exponentialRampToValueAtTime(.06,t+2.5),r.gain.exponentialRampToValueAtTime(1e-4,t+8.5),s.connect(r),r.connect(this.padBus),s.start(t),s.stop(t+9)}this.nextChord=t+8}if(t>this.nextDrip&&!this.bossMode&&(this.osc("sine",1200+Math.random()*900,700,.12,.05,this.music,0,1),this.nextDrip=t+2+Math.random()*6),this.bossMode&&t>this.nextBeat){let e=this.beat++%8;(e===0||e===3||e===5)&&this.osc("sine",80,35,.35,.5,this.music,0,.3),e===4&&this.nz(.2,.25,"bandpass",1200,500,1),e%2===1&&this.nz(.04,.06,"highpass",7e3,6e3,1,0,0),this.nextBeat=t+.22}}};var wb={uniforms:{tDiffuse:{value:null},uTime:{value:0}},vertexShader:"varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }",fragmentShader:`
    uniform sampler2D tDiffuse; uniform float uTime; varying vec2 vUv;
    float rnd(vec2 p){ return fract(sin(dot(p, vec2(12.9898,78.233)) + uTime) * 43758.5453); }
    void main(){
      vec3 c = texture2D(tDiffuse, vUv).rgb;
      float l = dot(c, vec3(0.299,0.587,0.114));
      c = mix(vec3(l), c, 1.08);                                   // saturacao
      c = mix(c * vec3(0.92,0.98,1.06), c * vec3(1.05,1.0,0.94), smoothstep(0.1,0.6,l)); // sombras frias, luzes quentes
      float v = smoothstep(0.95, 0.3, length((vUv - 0.5) * vec2(1.25, 1.0)));
      c *= mix(0.42, 1.0, v);
      c += (rnd(vUv * 731.0) - 0.5) * 0.018;
      gl_FragColor = vec4(c, 1.0);
    }`},sm=document.getElementById("c"),_i=new Gc({canvas:sm,antialias:!1,powerPreference:"high-performance"});_i.shadowMap.enabled=!0;_i.shadowMap.type=Cs;_i.toneMapping=Is;_i.toneMappingExposure=1.2;_i.outputColorSpace=Oe;_i.shadowMap.autoUpdate=!1;var Qd=new Oh(sm),ii=new zh(document.getElementById("ui"),Qd),ia=new kh,Lt=new Os(_i,ii,Qd,ia),Tb=new Ur(_i);Lt.envMap=Tb.fromScene(new Zc,.04).texture;var Gh=new rh(_i);Lt.mirror=Gh;var Bh=["Ultra","Alta","M\xE9dia","Baixa"],Eb={Ultra:{pr:2,msaa:4,bloom:!0,mirror:.6,env:256,envEvery:2,pool:20,shadows:4,sun:4096},Alta:{pr:1.5,msaa:4,bloom:!0,mirror:.45,env:128,envEvery:5,pool:16,shadows:2,sun:2048},M\u00E9dia:{pr:1,msaa:2,bloom:!0,mirror:.33,env:64,envEvery:15,pool:12,shadows:0,sun:1024},Baixa:{pr:.75,msaa:0,bloom:!1,mirror:0,env:0,envEvery:0,pool:8,shadows:0,sun:512}},xs="Ultra";try{xs=localStorage.getItem("criptas-quality-v2")||"Ultra"}catch{}Bh.includes(xs)||(xs="Ultra");Lt.quality=xs;var En,Kd,em,jd,Jd;function rm(){En&&(En.dispose(),Jd.dispose());let n=Eb[xs],t=Math.min(devicePixelRatio,n.pr);_i.setPixelRatio(t),_i.setSize(innerWidth,innerHeight,!1),Jd=new ke(innerWidth*t,innerHeight*t,{type:qe,samples:n.msaa}),En=new qc(_i,Jd),Kd=new $c(Lt.scene,Lt.camera),En.addPass(Kd),n.bloom&&(em=new Br(new ot(innerWidth/2,innerHeight/2),.55,.5,.82),En.addPass(em)),En.addPass(new Yc),jd=new kr(wb),En.addPass(jd),Lt.moon.shadow.mapSize.x!==n.sun&&(Lt.moon.shadow.mapSize.set(n.sun,n.sun),Lt.moon.shadow.map&&(Lt.moon.shadow.map.dispose(),Lt.moon.shadow.map=null)),Lt.setLightQuality(n.pool,n.shadows),Gh.setup(n.mirror>0,n.mirror),Lt.liveEnv&&(Lt.liveEnv.rt.dispose(),Lt.liveEnv=null),n.env&&(Lt.liveEnv=new ah(_i,n.env),Lt.liveEnv.every=n.envEvery),Lt.scene&&(Lt.scene.environment=Lt.liveEnv?Lt.liveEnv.texture:Lt.envMap,Lt.scene.environmentIntensity=Lt.liveEnv?.9:.35),am()}function am(){let n=_i.getPixelRatio();_i.setSize(innerWidth,innerHeight,!1),En.setSize(innerWidth,innerHeight),Lt.camera.aspect=innerWidth/innerHeight,Lt.camera.fov=innerWidth<innerHeight?44:32,Lt.camera.updateProjectionMatrix(),Lt.particles.setScale(innerHeight*n/(2*Math.tan(qu.degToRad(Lt.camera.fov)/2))),Gh.resize()}addEventListener("resize",()=>En&&am());function om(n){xs=n,Lt.quality=n;try{localStorage.setItem("criptas-quality-v2",n)}catch{}rm()}var Hh=1;function lm(){Lt.mode="hub",Lt.loadLevel(jc(1234),!0),Lt.player.rig.root.visible=!1,Lt.state="title",ii.setBoss(null),Hh=1;try{let n=JSON.parse(localStorage.getItem("criptas-save-v2"));n&&(Hh=n.depth||1)}catch{}ii.showTitle(Hh,Os.hasSave())}var Tn=null,ks=(n,t={})=>ii.openStation(Lt,n,t),Fo=(n,t,e={})=>i=>{let s=t(i);ks(n,{...e(i),msg:s||""})};ii.on={play:()=>{ia.init(),ii.hidePanels(),Lt.newGame(),Tn={t:0,frames:0}},continue:()=>{ia.init(),ii.hidePanels(),Lt.loadSave()||Lt.newGame(),Tn={t:0,frames:0}},controls:()=>ii.showControls(()=>ii.showTitle(Hh,Os.hasSave())),controlsP:()=>ii.showControls(()=>ii.showPause(Lt)),resume:()=>{Lt.state="play",ii.hidePanels()},mute:()=>{ia.setMuted(!ia.muted),ii.showPause(Lt)},quality:()=>{om(Bh[(Bh.indexOf(xs)+1)%Bh.length]),ii.showPause(Lt)},retry:()=>{ii.hidePanels(),Lt.retryLevel()},hub:()=>{ii.hidePanels(),Lt.deathToHub()},menu:()=>{ii.hidePanels(),Lt.inHub&&Lt.save(),lm()},next:()=>{ii.hidePanels(),Lt.levelComplete()},close:()=>Lt.closeMenu(),stab:n=>ks("shop",{tab:n.dataset.tab}),buyc:Fo("shop",n=>Lt.buyConsumable(n.dataset.id),()=>({tab:"buy"})),buyi:Fo("shop",n=>Lt.buyItem(+n.dataset.i),()=>({tab:"buy"})),sell:n=>{Lt.sellItem(+n.dataset.i),n.dataset.back==="bag"?ks("bag"):ks("shop",{tab:"sell"})},upg:Fo("smith",n=>Lt.upgrade(n.dataset.s,n.dataset.i===""?void 0:+n.dataset.i),()=>({})),qacc:Fo("quests",n=>Lt.acceptQuest(+n.dataset.i),()=>({})),qab:Fo("quests",n=>{Lt.abandonQuest(+n.dataset.i)},()=>({})),equip:n=>{Lt.equipFromBag(+n.dataset.i,n.dataset.a!==void 0?+n.dataset.a:void 0),ks("bag")},disc:n=>{Lt.discard(+n.dataset.i),ks("bag")},travel:n=>{let t=Lt.travelDimension(n.dataset.k);t&&ks("dims",{msg:t})}};rm();var cm=()=>{Lt.state!=="title"&&ia.init()};addEventListener("pointerdown",cm);addEventListener("keydown",cm);var gs=window.claude&&window.claude.hot;gs&&gs.snapshot&&gs.snapshot(()=>(Lt.state!=="title"&&Lt.inHub&&Lt.save(),{resume:Lt.state!=="title"}));var im=n=>{if(n&&n.resume&&Os.hasSave())try{if(Lt.loadSave()){ii.hidePanels();return}}catch{}lm()};gs&&gs.ready?gs.ready(im):im(gs&&gs.data||{});var nm=performance.now();function hm(n){requestAnimationFrame(hm);let t=Math.min(.05,(n-nm)/1e3);if(nm=n,Qd.poll(),Lt.update(t),_i.shadowMap.needsUpdate=!0,Gh.render(Lt.scene,Lt.camera,0),Lt.liveEnv){let e=Lt.player;Lt.liveEnv.update(Lt.scene,e.x,e.y+1.3,e.z,e.rig.root)}if(Kd.scene=Lt.scene,jd.uniforms.uTime.value=n*.001%100,En.render(),Tn&&Lt.state==="play"&&(Tn.t+=t,Tn.frames++,Tn.t>6)){let e=Tn.frames/Tn.t;e<24&&xs==="Ultra"?(om("Alta"),ii.toast(`Gr\xE1ficos ajustados para "Alta" (${Math.round(e)} FPS). Pode voltar ao Ultra no menu de pausa.`),Tn={t:0,frames:0}):Tn=null}}requestAnimationFrame(hm);window.__game=Lt;})();
/*! Bundled license information:

three/build/three.core.js:
three/build/three.module.js:
  (**
   * @license
   * Copyright 2010-2026 Three.js Authors
   * SPDX-License-Identifier: MIT
   *)
*/
