(()=>{var $u=0,Qc=1,Zu=2;var Qn=1,Ju=2,Ws=3,Dn=0,Ze=1,ke=2,Mi=0,Nn=1,Be=2,jc=3,th=4,Ku=5;var jn=100,Qu=101,ju=102,td=103,ed=104,id=200,nd=201,sd=202,rd=203,eh=204,ih=205,ad=206,od=207,ld=208,cd=209,hd=210,ud=211,dd=212,fd=213,pd=214,so=0,ro=1,ao=2,Cs=3,oo=4,lo=5,Is=6,co=7,zo=0,md=1,gd=2,Ui=0,Jr=1,Kr=2,Qr=3,ts=4,jr=5,ta=6,ea=7;var nh=300,Un=301,es=302,Bo=303,Oo=304,ia=306,Tn=1e3,Vi=1001,ho=1002,qe=1003,xd=1004;var na=1005;var Oe=1006,ko=1007;var Yi=1008;var oi=1009,sh=1010,rh=1011,Xs=1012,Ho=1013,Fi=1014,bi=1015,He=1016,Vo=1017,Go=1018,qs=1020,ah=35902,oh=35899,lh=1021,ch=1022,Si=1023,Gi=1026,Fn=1027,Wo=1028,Xo=1029,zn=1030,qo=1031;var Yo=1033,sa=33776,ra=33777,aa=33778,oa=33779,$o=35840,Zo=35841,Jo=35842,Ko=35843,Qo=36196,jo=37492,tl=37496,el=37488,il=37489,la=37490,nl=37491,sl=37808,rl=37809,al=37810,ol=37811,ll=37812,cl=37813,hl=37814,ul=37815,dl=37816,fl=37817,pl=37818,ml=37819,gl=37820,xl=37821,_l=36492,vl=36494,yl=36495,Ml=36283,bl=36284,ca=36285,Sl=36286;var Sr=2300,uo=2301,io=2302,Vc=2303,Gc=2400,Wc=2401,Xc=2402;var _d=3200;var ha=0,vd=1,wi="",Ee="srgb",wr="srgb-linear",Tr="linear",ae="srgb";var no=7680;var yd=519,Md=512,bd=513,Sd=514,wl=515,wd=516,Td=517,Tl=518,Ed=519,hh=35044,ua=35048;var uh="300 es",Di=2e3,Ps=2001;function lp(n){for(let t=n.length-1;t>=0;--t)if(n[t]>=65535)return!0;return!1}function cp(n){return ArrayBuffer.isView(n)&&!(n instanceof DataView)}function Er(n){return document.createElementNS("http://www.w3.org/1999/xhtml",n)}function Ad(){let n=Er("canvas");return n.style.display="block",n}var pu={},Ls=null;function Ar(...n){let t="THREE."+n.shift();Ls?Ls("log",t,...n):console.log(t,...n)}function Rd(n){let t=n[0];if(typeof t=="string"&&t.startsWith("TSL:")){let e=n[1];e&&e.isStackTrace?n[0]+=" "+e.getLocation():n[1]='Stack trace not available. Enable "THREE.Node.captureStackTrace" to capture stack traces.'}return n}function kt(...n){n=Rd(n);let t="THREE."+n.shift();if(Ls)Ls("warn",t,...n);else{let e=n[0];e&&e.isStackTrace?console.warn(e.getError(t)):console.warn(t,...n)}}function Ht(...n){n=Rd(n);let t="THREE."+n.shift();if(Ls)Ls("error",t,...n);else{let e=n[0];e&&e.isStackTrace?console.error(e.getError(t)):console.error(t,...n)}}function $n(...n){let t=n.join(" ");t in pu||(pu[t]=!0,kt(...n))}function Cd(n,t,e){return new Promise(function(i,s){function r(){switch(n.clientWaitSync(t,n.SYNC_FLUSH_COMMANDS_BIT,0)){case n.WAIT_FAILED:s();break;case n.TIMEOUT_EXPIRED:setTimeout(r,e);break;default:i()}}setTimeout(r,e)})}var Id={[so]:ro,[ao]:Is,[oo]:co,[Cs]:lo,[ro]:so,[Is]:ao,[co]:oo,[lo]:Cs},Wi=class{addEventListener(t,e){this._listeners===void 0&&(this._listeners={});let i=this._listeners;i[t]===void 0&&(i[t]=[]),i[t].indexOf(e)===-1&&i[t].push(e)}hasEventListener(t,e){let i=this._listeners;return i===void 0?!1:i[t]!==void 0&&i[t].indexOf(e)!==-1}removeEventListener(t,e){let i=this._listeners;if(i===void 0)return;let s=i[t];if(s!==void 0){let r=s.indexOf(e);r!==-1&&s.splice(r,1)}}dispatchEvent(t){let e=this._listeners;if(e===void 0)return;let i=e[t.type];if(i!==void 0){t.target=this;let s=i.slice(0);for(let r=0,a=s.length;r<a;r++)s[r].call(this,t);t.target=null}}},Qe=["00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f","10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f","20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f","30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d","3e","3f","40","41","42","43","44","45","46","47","48","49","4a","4b","4c","4d","4e","4f","50","51","52","53","54","55","56","57","58","59","5a","5b","5c","5d","5e","5f","60","61","62","63","64","65","66","67","68","69","6a","6b","6c","6d","6e","6f","70","71","72","73","74","75","76","77","78","79","7a","7b","7c","7d","7e","7f","80","81","82","83","84","85","86","87","88","89","8a","8b","8c","8d","8e","8f","90","91","92","93","94","95","96","97","98","99","9a","9b","9c","9d","9e","9f","a0","a1","a2","a3","a4","a5","a6","a7","a8","a9","aa","ab","ac","ad","ae","af","b0","b1","b2","b3","b4","b5","b6","b7","b8","b9","ba","bb","bc","bd","be","bf","c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf","d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df","e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff"],mu=1234567,Mr=Math.PI/180,Ds=180/Math.PI;function ln(){let n=Math.random()*4294967295|0,t=Math.random()*4294967295|0,e=Math.random()*4294967295|0,i=Math.random()*4294967295|0;return(Qe[n&255]+Qe[n>>8&255]+Qe[n>>16&255]+Qe[n>>24&255]+"-"+Qe[t&255]+Qe[t>>8&255]+"-"+Qe[t>>16&15|64]+Qe[t>>24&255]+"-"+Qe[e&63|128]+Qe[e>>8&255]+"-"+Qe[e>>16&255]+Qe[e>>24&255]+Qe[i&255]+Qe[i>>8&255]+Qe[i>>16&255]+Qe[i>>24&255]).toLowerCase()}function te(n,t,e){return Math.max(t,Math.min(e,n))}function dh(n,t){return(n%t+t)%t}function hp(n,t,e,i,s){return i+(n-t)*(s-i)/(e-t)}function up(n,t,e){return n!==t?(e-n)/(t-n):0}function br(n,t,e){return(1-e)*n+e*t}function dp(n,t,e,i){return br(n,t,1-Math.exp(-e*i))}function fp(n,t=1){return t-Math.abs(dh(n,t*2)-t)}function pp(n,t,e){return n<=t?0:n>=e?1:(n=(n-t)/(e-t),n*n*(3-2*n))}function mp(n,t,e){return n<=t?0:n>=e?1:(n=(n-t)/(e-t),n*n*n*(n*(n*6-15)+10))}function gp(n,t){return n+Math.floor(Math.random()*(t-n+1))}function xp(n,t){return n+Math.random()*(t-n)}function _p(n){return n*(.5-Math.random())}function vp(n){n!==void 0&&(mu=n);let t=mu+=1831565813;return t=Math.imul(t^t>>>15,t|1),t^=t+Math.imul(t^t>>>7,t|61),((t^t>>>14)>>>0)/4294967296}function yp(n){return n*Mr}function Mp(n){return n*Ds}function bp(n){return n>0&&Number.isInteger(n)&&2**Math.round(Math.log2(n))===n}function Sp(n){return Math.pow(2,Math.ceil(Math.log(n)/Math.LN2))}function wp(n){return Math.pow(2,Math.floor(Math.log(n)/Math.LN2))}function Tp(n,t,e,i,s){let r=Math.cos,a=Math.sin,o=r(e/2),l=a(e/2),c=r((t+i)/2),h=a((t+i)/2),d=r((t-i)/2),u=a((t-i)/2),f=r((i-t)/2),g=a((i-t)/2);switch(s){case"XYX":n.set(o*h,l*d,l*u,o*c);break;case"YZY":n.set(l*u,o*h,l*d,o*c);break;case"ZXZ":n.set(l*d,l*u,o*h,o*c);break;case"XZX":n.set(o*h,l*g,l*f,o*c);break;case"YXY":n.set(l*f,o*h,l*g,o*c);break;case"ZYZ":n.set(l*g,l*f,o*h,o*c);break;default:kt("MathUtils: .setQuaternionFromProperEuler() encountered an unknown order: "+s)}}function Li(n,t){switch(t.constructor){case Float32Array:return n;case Uint32Array:return n/4294967295;case Uint16Array:return n/65535;case Uint8Array:case Uint8ClampedArray:return n/255;case Int32Array:return Math.max(n/2147483647,-1);case Int16Array:return Math.max(n/32767,-1);case Int8Array:return Math.max(n/127,-1);default:throw new Error("THREE.MathUtils: Invalid component type.")}}function me(n,t){switch(t.constructor){case Float32Array:return n;case Uint32Array:return Math.round(n*4294967295);case Uint16Array:return Math.round(n*65535);case Uint8Array:case Uint8ClampedArray:return Math.round(n*255);case Int32Array:return Math.round(n*2147483647);case Int16Array:return Math.round(n*32767);case Int8Array:return Math.round(n*127);default:throw new Error("THREE.MathUtils: Invalid component type.")}}var fh={DEG2RAD:Mr,RAD2DEG:Ds,generateUUID:ln,clamp:te,euclideanModulo:dh,mapLinear:hp,inverseLerp:up,lerp:br,damp:dp,pingpong:fp,smoothstep:pp,smootherstep:mp,randInt:gp,randFloat:xp,randFloatSpread:_p,seededRandom:vp,degToRad:yp,radToDeg:Mp,isPowerOfTwo:bp,ceilPowerOfTwo:Sp,floorPowerOfTwo:wp,setQuaternionFromProperEuler:Tp,normalize:me,denormalize:Li},_h=class _h{constructor(t=0,e=0){this.x=t,this.y=e}get width(){return this.x}set width(t){this.x=t}get height(){return this.y}set height(t){this.y=t}set(t,e){return this.x=t,this.y=e,this}setScalar(t){return this.x=t,this.y=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;default:throw new Error("THREE.Vector2: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;default:throw new Error("THREE.Vector2: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y)}copy(t){return this.x=t.x,this.y=t.y,this}add(t){return this.x+=t.x,this.y+=t.y,this}addScalar(t){return this.x+=t,this.y+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this}subScalar(t){return this.x-=t,this.y-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this}multiply(t){return this.x*=t.x,this.y*=t.y,this}multiplyScalar(t){return this.x*=t,this.y*=t,this}divide(t){return this.x/=t.x,this.y/=t.y,this}divideScalar(t){return this.multiplyScalar(1/t)}applyMatrix3(t){let e=this.x,i=this.y,s=t.elements;return this.x=s[0]*e+s[3]*i+s[6],this.y=s[1]*e+s[4]*i+s[7],this}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this}clamp(t,e){return this.x=te(this.x,t.x,e.x),this.y=te(this.y,t.y,e.y),this}clampScalar(t,e){return this.x=te(this.x,t,e),this.y=te(this.y,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(te(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this}negate(){return this.x=-this.x,this.y=-this.y,this}dot(t){return this.x*t.x+this.y*t.y}cross(t){return this.x*t.y-this.y*t.x}lengthSq(){return this.x*this.x+this.y*this.y}length(){return Math.sqrt(this.x*this.x+this.y*this.y)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)}normalize(){return this.divideScalar(this.length()||1)}angle(){return Math.atan2(-this.y,-this.x)+Math.PI}angleTo(t){let e=Math.sqrt(this.lengthSq()*t.lengthSq());if(e===0)return Math.PI/2;let i=this.dot(t)/e;return Math.acos(te(i,-1,1))}distanceTo(t){return Math.sqrt(this.distanceToSquared(t))}distanceToSquared(t){let e=this.x-t.x,i=this.y-t.y;return e*e+i*i}manhattanDistanceTo(t){return Math.abs(this.x-t.x)+Math.abs(this.y-t.y)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this}equals(t){return t.x===this.x&&t.y===this.y}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this}rotateAround(t,e){let i=Math.cos(e),s=Math.sin(e),r=this.x-t.x,a=this.y-t.y;return this.x=r*i-a*s+t.x,this.y=r*s+a*i+t.y,this}random(){return this.x=Math.random(),this.y=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y}};_h.prototype.isVector2=!0;var xt=_h,xi=class{constructor(t=0,e=0,i=0,s=1){this.isQuaternion=!0,this._x=t,this._y=e,this._z=i,this._w=s}static slerpFlat(t,e,i,s,r,a,o){let l=i[s+0],c=i[s+1],h=i[s+2],d=i[s+3],u=r[a+0],f=r[a+1],g=r[a+2],_=r[a+3];if(d!==_||l!==u||c!==f||h!==g){let m=l*u+c*f+h*g+d*_;m<0&&(u=-u,f=-f,g=-g,_=-_,m=-m);let p=1-o;if(m<.9995){let M=Math.acos(m),R=Math.sin(M);p=Math.sin(p*M)/R,o=Math.sin(o*M)/R,l=l*p+u*o,c=c*p+f*o,h=h*p+g*o,d=d*p+_*o}else{l=l*p+u*o,c=c*p+f*o,h=h*p+g*o,d=d*p+_*o;let M=1/Math.sqrt(l*l+c*c+h*h+d*d);l*=M,c*=M,h*=M,d*=M}}t[e]=l,t[e+1]=c,t[e+2]=h,t[e+3]=d}static multiplyQuaternionsFlat(t,e,i,s,r,a){let o=i[s],l=i[s+1],c=i[s+2],h=i[s+3],d=r[a],u=r[a+1],f=r[a+2],g=r[a+3];return t[e]=o*g+h*d+l*f-c*u,t[e+1]=l*g+h*u+c*d-o*f,t[e+2]=c*g+h*f+o*u-l*d,t[e+3]=h*g-o*d-l*u-c*f,t}get x(){return this._x}set x(t){this._x=t,this._onChangeCallback()}get y(){return this._y}set y(t){this._y=t,this._onChangeCallback()}get z(){return this._z}set z(t){this._z=t,this._onChangeCallback()}get w(){return this._w}set w(t){this._w=t,this._onChangeCallback()}set(t,e,i,s){return this._x=t,this._y=e,this._z=i,this._w=s,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._w)}copy(t){return this._x=t.x,this._y=t.y,this._z=t.z,this._w=t.w,this._onChangeCallback(),this}setFromEuler(t,e=!0){let i=t._x,s=t._y,r=t._z,a=t._order,o=Math.cos,l=Math.sin,c=o(i/2),h=o(s/2),d=o(r/2),u=l(i/2),f=l(s/2),g=l(r/2);switch(a){case"XYZ":this._x=u*h*d+c*f*g,this._y=c*f*d-u*h*g,this._z=c*h*g+u*f*d,this._w=c*h*d-u*f*g;break;case"YXZ":this._x=u*h*d+c*f*g,this._y=c*f*d-u*h*g,this._z=c*h*g-u*f*d,this._w=c*h*d+u*f*g;break;case"ZXY":this._x=u*h*d-c*f*g,this._y=c*f*d+u*h*g,this._z=c*h*g+u*f*d,this._w=c*h*d-u*f*g;break;case"ZYX":this._x=u*h*d-c*f*g,this._y=c*f*d+u*h*g,this._z=c*h*g-u*f*d,this._w=c*h*d+u*f*g;break;case"YZX":this._x=u*h*d+c*f*g,this._y=c*f*d+u*h*g,this._z=c*h*g-u*f*d,this._w=c*h*d-u*f*g;break;case"XZY":this._x=u*h*d-c*f*g,this._y=c*f*d-u*h*g,this._z=c*h*g+u*f*d,this._w=c*h*d+u*f*g;break;default:kt("Quaternion: .setFromEuler() encountered an unknown order: "+a)}return e===!0&&this._onChangeCallback(),this}setFromAxisAngle(t,e){let i=e/2,s=Math.sin(i);return this._x=t.x*s,this._y=t.y*s,this._z=t.z*s,this._w=Math.cos(i),this._onChangeCallback(),this}setFromRotationMatrix(t){let e=t.elements,i=e[0],s=e[4],r=e[8],a=e[1],o=e[5],l=e[9],c=e[2],h=e[6],d=e[10],u=i+o+d;if(u>0){let f=.5/Math.sqrt(u+1);this._w=.25/f,this._x=(h-l)*f,this._y=(r-c)*f,this._z=(a-s)*f}else if(i>o&&i>d){let f=2*Math.sqrt(1+i-o-d);this._w=(h-l)/f,this._x=.25*f,this._y=(s+a)/f,this._z=(r+c)/f}else if(o>d){let f=2*Math.sqrt(1+o-i-d);this._w=(r-c)/f,this._x=(s+a)/f,this._y=.25*f,this._z=(l+h)/f}else{let f=2*Math.sqrt(1+d-i-o);this._w=(a-s)/f,this._x=(r+c)/f,this._y=(l+h)/f,this._z=.25*f}return this._onChangeCallback(),this}setFromUnitVectors(t,e){let i=t.dot(e)+1;return i<1e-8?(i=0,Math.abs(t.x)>Math.abs(t.z)?(this._x=-t.y,this._y=t.x,this._z=0,this._w=i):(this._x=0,this._y=-t.z,this._z=t.y,this._w=i)):(this._x=t.y*e.z-t.z*e.y,this._y=t.z*e.x-t.x*e.z,this._z=t.x*e.y-t.y*e.x,this._w=i),this.normalize()}angleTo(t){return 2*Math.acos(Math.abs(te(this.dot(t),-1,1)))}rotateTowards(t,e){let i=this.angleTo(t);if(i===0)return this;let s=Math.min(1,e/i);return this.slerp(t,s),this}identity(){return this.set(0,0,0,1)}invert(){return this.conjugate()}conjugate(){return this._x*=-1,this._y*=-1,this._z*=-1,this._onChangeCallback(),this}dot(t){return this._x*t._x+this._y*t._y+this._z*t._z+this._w*t._w}lengthSq(){return this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w}length(){return Math.sqrt(this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w)}normalize(){let t=this.length();return t===0?(this._x=0,this._y=0,this._z=0,this._w=1):(t=1/t,this._x=this._x*t,this._y=this._y*t,this._z=this._z*t,this._w=this._w*t),this._onChangeCallback(),this}multiply(t){return this.multiplyQuaternions(this,t)}premultiply(t){return this.multiplyQuaternions(t,this)}multiplyQuaternions(t,e){let i=t._x,s=t._y,r=t._z,a=t._w,o=e._x,l=e._y,c=e._z,h=e._w;return this._x=i*h+a*o+s*c-r*l,this._y=s*h+a*l+r*o-i*c,this._z=r*h+a*c+i*l-s*o,this._w=a*h-i*o-s*l-r*c,this._onChangeCallback(),this}slerp(t,e){let i=t._x,s=t._y,r=t._z,a=t._w,o=this.dot(t);o<0&&(i=-i,s=-s,r=-r,a=-a,o=-o);let l=1-e;if(o<.9995){let c=Math.acos(o),h=Math.sin(c);l=Math.sin(l*c)/h,e=Math.sin(e*c)/h,this._x=this._x*l+i*e,this._y=this._y*l+s*e,this._z=this._z*l+r*e,this._w=this._w*l+a*e,this._onChangeCallback()}else this._x=this._x*l+i*e,this._y=this._y*l+s*e,this._z=this._z*l+r*e,this._w=this._w*l+a*e,this.normalize();return this}slerpQuaternions(t,e,i){return this.copy(t).slerp(e,i)}random(){let t=2*Math.PI*Math.random(),e=2*Math.PI*Math.random(),i=Math.random(),s=Math.sqrt(1-i),r=Math.sqrt(i);return this.set(s*Math.sin(t),s*Math.cos(t),r*Math.sin(e),r*Math.cos(e))}equals(t){return t._x===this._x&&t._y===this._y&&t._z===this._z&&t._w===this._w}fromArray(t,e=0){return this._x=t[e],this._y=t[e+1],this._z=t[e+2],this._w=t[e+3],this._onChangeCallback(),this}toArray(t=[],e=0){return t[e]=this._x,t[e+1]=this._y,t[e+2]=this._z,t[e+3]=this._w,t}fromBufferAttribute(t,e){return this._x=t.getX(e),this._y=t.getY(e),this._z=t.getZ(e),this._w=t.getW(e),this._onChangeCallback(),this}toJSON(){return this.toArray()}_onChange(t){return this._onChangeCallback=t,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._w}},vh=class vh{constructor(t=0,e=0,i=0){this.x=t,this.y=e,this.z=i}set(t,e,i){return i===void 0&&(i=this.z),this.x=t,this.y=e,this.z=i,this}setScalar(t){return this.x=t,this.y=t,this.z=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setZ(t){return this.z=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;case 2:this.z=e;break;default:throw new Error("THREE.Vector3: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;case 2:return this.z;default:throw new Error("THREE.Vector3: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y,this.z)}copy(t){return this.x=t.x,this.y=t.y,this.z=t.z,this}add(t){return this.x+=t.x,this.y+=t.y,this.z+=t.z,this}addScalar(t){return this.x+=t,this.y+=t,this.z+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this.z=t.z+e.z,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this.z+=t.z*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this.z-=t.z,this}subScalar(t){return this.x-=t,this.y-=t,this.z-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this.z=t.z-e.z,this}multiply(t){return this.x*=t.x,this.y*=t.y,this.z*=t.z,this}multiplyScalar(t){return this.x*=t,this.y*=t,this.z*=t,this}multiplyVectors(t,e){return this.x=t.x*e.x,this.y=t.y*e.y,this.z=t.z*e.z,this}applyEuler(t){return this.applyQuaternion(gu.setFromEuler(t))}applyAxisAngle(t,e){return this.applyQuaternion(gu.setFromAxisAngle(t,e))}applyMatrix3(t){let e=this.x,i=this.y,s=this.z,r=t.elements;return this.x=r[0]*e+r[3]*i+r[6]*s,this.y=r[1]*e+r[4]*i+r[7]*s,this.z=r[2]*e+r[5]*i+r[8]*s,this}applyNormalMatrix(t){return this.applyMatrix3(t).normalize()}applyMatrix4(t){let e=this.x,i=this.y,s=this.z,r=t.elements,a=1/(r[3]*e+r[7]*i+r[11]*s+r[15]);return this.x=(r[0]*e+r[4]*i+r[8]*s+r[12])*a,this.y=(r[1]*e+r[5]*i+r[9]*s+r[13])*a,this.z=(r[2]*e+r[6]*i+r[10]*s+r[14])*a,this}applyQuaternion(t){let e=this.x,i=this.y,s=this.z,r=t.x,a=t.y,o=t.z,l=t.w,c=2*(a*s-o*i),h=2*(o*e-r*s),d=2*(r*i-a*e);return this.x=e+l*c+a*d-o*h,this.y=i+l*h+o*c-r*d,this.z=s+l*d+r*h-a*c,this}project(t){return this.applyMatrix4(t.matrixWorldInverse).applyMatrix4(t.projectionMatrix)}unproject(t){return this.applyMatrix4(t.projectionMatrixInverse).applyMatrix4(t.matrixWorld)}transformDirection(t){let e=this.x,i=this.y,s=this.z,r=t.elements;return this.x=r[0]*e+r[4]*i+r[8]*s,this.y=r[1]*e+r[5]*i+r[9]*s,this.z=r[2]*e+r[6]*i+r[10]*s,this.normalize()}divide(t){return this.x/=t.x,this.y/=t.y,this.z/=t.z,this}divideScalar(t){return this.multiplyScalar(1/t)}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this.z=Math.min(this.z,t.z),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this.z=Math.max(this.z,t.z),this}clamp(t,e){return this.x=te(this.x,t.x,e.x),this.y=te(this.y,t.y,e.y),this.z=te(this.z,t.z,e.z),this}clampScalar(t,e){return this.x=te(this.x,t,e),this.y=te(this.y,t,e),this.z=te(this.z,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(te(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this}dot(t){return this.x*t.x+this.y*t.y+this.z*t.z}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)}normalize(){return this.divideScalar(this.length()||1)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this.z+=(t.z-this.z)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this.z=t.z+(e.z-t.z)*i,this}cross(t){return this.crossVectors(this,t)}crossVectors(t,e){let i=t.x,s=t.y,r=t.z,a=e.x,o=e.y,l=e.z;return this.x=s*l-r*o,this.y=r*a-i*l,this.z=i*o-s*a,this}projectOnVector(t){let e=t.lengthSq();if(e===0)return this.set(0,0,0);let i=t.dot(this)/e;return this.copy(t).multiplyScalar(i)}projectOnPlane(t){return vc.copy(this).projectOnVector(t),this.sub(vc)}reflect(t){return this.sub(vc.copy(t).multiplyScalar(2*this.dot(t)))}angleTo(t){let e=Math.sqrt(this.lengthSq()*t.lengthSq());if(e===0)return Math.PI/2;let i=this.dot(t)/e;return Math.acos(te(i,-1,1))}distanceTo(t){return Math.sqrt(this.distanceToSquared(t))}distanceToSquared(t){let e=this.x-t.x,i=this.y-t.y,s=this.z-t.z;return e*e+i*i+s*s}manhattanDistanceTo(t){return Math.abs(this.x-t.x)+Math.abs(this.y-t.y)+Math.abs(this.z-t.z)}setFromSpherical(t){return this.setFromSphericalCoords(t.radius,t.phi,t.theta)}setFromSphericalCoords(t,e,i){let s=Math.sin(e)*t;return this.x=s*Math.sin(i),this.y=Math.cos(e)*t,this.z=s*Math.cos(i),this}setFromCylindrical(t){return this.setFromCylindricalCoords(t.radius,t.theta,t.y)}setFromCylindricalCoords(t,e,i){return this.x=t*Math.sin(e),this.y=i,this.z=t*Math.cos(e),this}setFromMatrixPosition(t){let e=t.elements;return this.x=e[12],this.y=e[13],this.z=e[14],this}setFromMatrixScale(t){let e=this.setFromMatrixColumn(t,0).length(),i=this.setFromMatrixColumn(t,1).length(),s=this.setFromMatrixColumn(t,2).length();return this.x=e,this.y=i,this.z=s,this}setFromMatrixColumn(t,e){return this.fromArray(t.elements,e*4)}setFromMatrix3Column(t,e){return this.fromArray(t.elements,e*3)}setFromEuler(t){return this.x=t._x,this.y=t._y,this.z=t._z,this}setFromColor(t){return this.x=t.r,this.y=t.g,this.z=t.b,this}equals(t){return t.x===this.x&&t.y===this.y&&t.z===this.z}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this.z=t[e+2],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t[e+2]=this.z,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this.z=t.getZ(e),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this}randomDirection(){let t=Math.random()*Math.PI*2,e=Math.random()*2-1,i=Math.sqrt(1-e*e);return this.x=i*Math.cos(t),this.y=e,this.z=i*Math.sin(t),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z}};vh.prototype.isVector3=!0;var N=vh,vc=new N,gu=new xi,yh=class yh{constructor(t,e,i,s,r,a,o,l,c){this.elements=[1,0,0,0,1,0,0,0,1],t!==void 0&&this.set(t,e,i,s,r,a,o,l,c)}set(t,e,i,s,r,a,o,l,c){let h=this.elements;return h[0]=t,h[1]=s,h[2]=o,h[3]=e,h[4]=r,h[5]=l,h[6]=i,h[7]=a,h[8]=c,this}identity(){return this.set(1,0,0,0,1,0,0,0,1),this}copy(t){let e=this.elements,i=t.elements;return e[0]=i[0],e[1]=i[1],e[2]=i[2],e[3]=i[3],e[4]=i[4],e[5]=i[5],e[6]=i[6],e[7]=i[7],e[8]=i[8],this}extractBasis(t,e,i){return t.setFromMatrix3Column(this,0),e.setFromMatrix3Column(this,1),i.setFromMatrix3Column(this,2),this}setFromMatrix4(t){let e=t.elements;return this.set(e[0],e[4],e[8],e[1],e[5],e[9],e[2],e[6],e[10]),this}multiply(t){return this.multiplyMatrices(this,t)}premultiply(t){return this.multiplyMatrices(t,this)}multiplyMatrices(t,e){let i=t.elements,s=e.elements,r=this.elements,a=i[0],o=i[3],l=i[6],c=i[1],h=i[4],d=i[7],u=i[2],f=i[5],g=i[8],_=s[0],m=s[3],p=s[6],M=s[1],R=s[4],y=s[7],w=s[2],S=s[5],I=s[8];return r[0]=a*_+o*M+l*w,r[3]=a*m+o*R+l*S,r[6]=a*p+o*y+l*I,r[1]=c*_+h*M+d*w,r[4]=c*m+h*R+d*S,r[7]=c*p+h*y+d*I,r[2]=u*_+f*M+g*w,r[5]=u*m+f*R+g*S,r[8]=u*p+f*y+g*I,this}multiplyScalar(t){let e=this.elements;return e[0]*=t,e[3]*=t,e[6]*=t,e[1]*=t,e[4]*=t,e[7]*=t,e[2]*=t,e[5]*=t,e[8]*=t,this}determinant(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],l=t[6],c=t[7],h=t[8];return e*a*h-e*o*c-i*r*h+i*o*l+s*r*c-s*a*l}invert(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],l=t[6],c=t[7],h=t[8],d=h*a-o*c,u=o*l-h*r,f=c*r-a*l,g=e*d+i*u+s*f;if(g===0)return this.set(0,0,0,0,0,0,0,0,0);let _=1/g;return t[0]=d*_,t[1]=(s*c-h*i)*_,t[2]=(o*i-s*a)*_,t[3]=u*_,t[4]=(h*e-s*l)*_,t[5]=(s*r-o*e)*_,t[6]=f*_,t[7]=(i*l-c*e)*_,t[8]=(a*e-i*r)*_,this}transpose(){let t,e=this.elements;return t=e[1],e[1]=e[3],e[3]=t,t=e[2],e[2]=e[6],e[6]=t,t=e[5],e[5]=e[7],e[7]=t,this}getNormalMatrix(t){return this.setFromMatrix4(t).invert().transpose()}transposeIntoArray(t){let e=this.elements;return t[0]=e[0],t[1]=e[3],t[2]=e[6],t[3]=e[1],t[4]=e[4],t[5]=e[7],t[6]=e[2],t[7]=e[5],t[8]=e[8],this}setUvTransform(t,e,i,s,r,a,o){let l=Math.cos(r),c=Math.sin(r);return this.set(i*l,i*c,-i*(l*a+c*o)+a+t,-s*c,s*l,-s*(-c*a+l*o)+o+e,0,0,1),this}scale(t,e){return $n("Matrix3: .scale() is deprecated. Use .makeScale() instead."),this.premultiply(yc.makeScale(t,e)),this}rotate(t){return $n("Matrix3: .rotate() is deprecated. Use .makeRotation() instead."),this.premultiply(yc.makeRotation(-t)),this}translate(t,e){return $n("Matrix3: .translate() is deprecated. Use .makeTranslation() instead."),this.premultiply(yc.makeTranslation(t,e)),this}makeTranslation(t,e){return t.isVector2?this.set(1,0,t.x,0,1,t.y,0,0,1):this.set(1,0,t,0,1,e,0,0,1),this}makeRotation(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,-i,0,i,e,0,0,0,1),this}makeScale(t,e){return this.set(t,0,0,0,e,0,0,0,1),this}equals(t){let e=this.elements,i=t.elements;for(let s=0;s<9;s++)if(e[s]!==i[s])return!1;return!0}fromArray(t,e=0){for(let i=0;i<9;i++)this.elements[i]=t[i+e];return this}toArray(t=[],e=0){let i=this.elements;return t[e]=i[0],t[e+1]=i[1],t[e+2]=i[2],t[e+3]=i[3],t[e+4]=i[4],t[e+5]=i[5],t[e+6]=i[6],t[e+7]=i[7],t[e+8]=i[8],t}clone(){return new this.constructor().fromArray(this.elements)}};yh.prototype.isMatrix3=!0;var Xt=yh,yc=new Xt,xu=new Xt().set(.4123908,.3575843,.1804808,.212639,.7151687,.0721923,.0193308,.1191948,.9505322),_u=new Xt().set(3.2409699,-1.5373832,-.4986108,-.9692436,1.8759675,.0415551,.0556301,-.203977,1.0569715);function Ep(){let n={enabled:!0,workingColorSpace:wr,spaces:{},convert:function(s,r,a){return this.enabled===!1||r===a||!r||!a||(this.spaces[r].transfer===ae&&(s.r=cn(s.r),s.g=cn(s.g),s.b=cn(s.b)),this.spaces[r].primaries!==this.spaces[a].primaries&&(s.applyMatrix3(this.spaces[r].toXYZ),s.applyMatrix3(this.spaces[a].fromXYZ)),this.spaces[a].transfer===ae&&(s.r=Rs(s.r),s.g=Rs(s.g),s.b=Rs(s.b))),s},workingToColorSpace:function(s,r){return this.convert(s,this.workingColorSpace,r)},colorSpaceToWorking:function(s,r){return this.convert(s,r,this.workingColorSpace)},getPrimaries:function(s){return this.spaces[s].primaries},getTransfer:function(s){return s===wi?Tr:this.spaces[s].transfer},getToneMappingMode:function(s){return this.spaces[s].outputColorSpaceConfig.toneMappingMode||"standard"},getLuminanceCoefficients:function(s,r=this.workingColorSpace){return s.fromArray(this.spaces[r].luminanceCoefficients)},define:function(s){Object.assign(this.spaces,s)},_getMatrix:function(s,r,a){return s.copy(this.spaces[r].toXYZ).multiply(this.spaces[a].fromXYZ)},_getDrawingBufferColorSpace:function(s){return this.spaces[s].outputColorSpaceConfig.drawingBufferColorSpace},_getUnpackColorSpace:function(s=this.workingColorSpace){return this.spaces[s].workingColorSpaceConfig.unpackColorSpace},fromWorkingColorSpace:function(s,r){return $n("ColorManagement: .fromWorkingColorSpace() has been renamed to .workingToColorSpace()."),n.workingToColorSpace(s,r)},toWorkingColorSpace:function(s,r){return $n("ColorManagement: .toWorkingColorSpace() has been renamed to .colorSpaceToWorking()."),n.colorSpaceToWorking(s,r)}},t=[.64,.33,.3,.6,.15,.06],e=[.2126,.7152,.0722],i=[.3127,.329];return n.define({[wr]:{primaries:t,whitePoint:i,transfer:Tr,toXYZ:xu,fromXYZ:_u,luminanceCoefficients:e,workingColorSpaceConfig:{unpackColorSpace:Ee},outputColorSpaceConfig:{drawingBufferColorSpace:Ee}},[Ee]:{primaries:t,whitePoint:i,transfer:ae,toXYZ:xu,fromXYZ:_u,luminanceCoefficients:e,outputColorSpaceConfig:{drawingBufferColorSpace:Ee}}}),n}var Qt=Ep();function cn(n){return n<.04045?n*.0773993808:Math.pow(n*.9478672986+.0521327014,2.4)}function Rs(n){return n<.0031308?n*12.92:1.055*Math.pow(n,.41666)-.055}var hs,fo=class{static getDataURL(t,e="image/png"){if(/^data:/i.test(t.src)||typeof HTMLCanvasElement>"u")return t.src;let i;if(t instanceof HTMLCanvasElement)i=t;else{hs===void 0&&(hs=Er("canvas")),hs.width=t.width,hs.height=t.height;let s=hs.getContext("2d");t instanceof ImageData?s.putImageData(t,0,0):s.drawImage(t,0,0,t.width,t.height),i=hs}return i.toDataURL(e)}static sRGBToLinear(t){if(typeof HTMLImageElement<"u"&&t instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&t instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&t instanceof ImageBitmap){let e=Er("canvas");e.width=t.width,e.height=t.height;let i=e.getContext("2d");i.drawImage(t,0,0,t.width,t.height);let s=i.getImageData(0,0,t.width,t.height),r=s.data;for(let a=0;a<r.length;a++)r[a]=cn(r[a]/255)*255;return i.putImageData(s,0,0),e}else if(t.data){let e=t.data.slice(0);for(let i=0;i<e.length;i++)e instanceof Uint8Array||e instanceof Uint8ClampedArray?e[i]=Math.floor(cn(e[i]/255)*255):e[i]=cn(e[i]);return{data:e,width:t.width,height:t.height}}else return kt("ImageUtils.sRGBToLinear(): Unsupported image type. No color space conversion applied."),t}},Ap=0,Ns=class{constructor(t=null){this.isTextureSource=!0,Object.defineProperty(this,"id",{value:Ap++}),this.uuid=ln(),this.data=t,this.dataReady=!0,this.version=0}getSize(t){let e=this.data;return typeof HTMLVideoElement<"u"&&e instanceof HTMLVideoElement?t.set(e.videoWidth,e.videoHeight,0):typeof VideoFrame<"u"&&e instanceof VideoFrame?t.set(e.displayWidth,e.displayHeight,0):e!==null?t.set(e.width,e.height,e.depth||0):t.set(0,0,0),t}set needsUpdate(t){t===!0&&this.version++}toJSON(t){let e=t===void 0||typeof t=="string";if(!e&&t.images[this.uuid]!==void 0)return t.images[this.uuid];let i={uuid:this.uuid,url:""},s=this.data;if(s!==null){let r;if(Array.isArray(s)){r=[];for(let a=0,o=s.length;a<o;a++)s[a].isDataTexture?r.push(Mc(s[a].image)):r.push(Mc(s[a]))}else r=Mc(s);i.url=r}return e||(t.images[this.uuid]=i),i}};function Mc(n){return typeof HTMLImageElement<"u"&&n instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&n instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&n instanceof ImageBitmap?fo.getDataURL(n):n.data?{data:Array.from(n.data),width:n.width,height:n.height,type:n.data.constructor.name}:(kt("Texture: Unable to serialize Texture."),{})}var Rp=0,bc=new N,ai=class n extends Wi{constructor(t=n.DEFAULT_IMAGE,e=n.DEFAULT_MAPPING,i=Vi,s=Vi,r=Oe,a=Yi,o=Si,l=oi,c=n.DEFAULT_ANISOTROPY,h=wi){super(),this.isTexture=!0,Object.defineProperty(this,"id",{value:Rp++}),this.uuid=ln(),this.name="",this.source=new Ns(t),this.mipmaps=[],this.mapping=e,this.channel=0,this.wrapS=i,this.wrapT=s,this.magFilter=r,this.minFilter=a,this.anisotropy=c,this.format=o,this.internalFormat=null,this.type=l,this.offset=new xt(0,0),this.repeat=new xt(1,1),this.center=new xt(0,0),this.rotation=0,this.matrixAutoUpdate=!0,this.matrix=new Xt,this.generateMipmaps=!0,this.premultiplyAlpha=!1,this.flipY=!0,this.unpackAlignment=4,this.colorSpace=h,this.userData={},this.updateRanges=[],this.version=0,this.onUpdate=null,this.renderTarget=null,this.isRenderTargetTexture=!1,this.isArrayTexture=!!(t&&t.depth&&t.depth>1),this.pmremVersion=0,this.normalized=!1}get width(){return this.source.getSize(bc).x}get height(){return this.source.getSize(bc).y}get depth(){return this.source.getSize(bc).z}get image(){return this.source.data}set image(t){this.source.data=t}updateMatrix(){this.matrix.setUvTransform(this.offset.x,this.offset.y,this.repeat.x,this.repeat.y,this.rotation,this.center.x,this.center.y)}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}clone(){return new this.constructor().copy(this)}copy(t){return this.name=t.name,this.source=t.source,this.mipmaps=t.mipmaps.slice(0),this.mapping=t.mapping,this.channel=t.channel,this.wrapS=t.wrapS,this.wrapT=t.wrapT,this.magFilter=t.magFilter,this.minFilter=t.minFilter,this.anisotropy=t.anisotropy,this.format=t.format,this.internalFormat=t.internalFormat,this.type=t.type,this.normalized=t.normalized,this.offset.copy(t.offset),this.repeat.copy(t.repeat),this.center.copy(t.center),this.rotation=t.rotation,this.matrixAutoUpdate=t.matrixAutoUpdate,this.matrix.copy(t.matrix),this.generateMipmaps=t.generateMipmaps,this.premultiplyAlpha=t.premultiplyAlpha,this.flipY=t.flipY,this.unpackAlignment=t.unpackAlignment,this.colorSpace=t.colorSpace,this.renderTarget=t.renderTarget,this.isRenderTargetTexture=t.isRenderTargetTexture,this.isArrayTexture=t.isArrayTexture,this.userData=JSON.parse(JSON.stringify(t.userData)),this.needsUpdate=!0,this}setValues(t){for(let e in t){let i=t[e];if(i===void 0){kt(`Texture.setValues(): parameter '${e}' has value of undefined.`);continue}let s=this[e];if(s===void 0){kt(`Texture.setValues(): property '${e}' does not exist.`);continue}s&&i&&s.isVector2&&i.isVector2||s&&i&&s.isVector3&&i.isVector3||s&&i&&s.isMatrix3&&i.isMatrix3?s.copy(i):this[e]=i}}toJSON(t){let e=t===void 0||typeof t=="string";if(!e&&t.textures[this.uuid]!==void 0)return t.textures[this.uuid];let i={metadata:{version:4.7,type:"Texture",generator:"Texture.toJSON"},uuid:this.uuid,name:this.name,image:this.source.toJSON(t).uuid,mapping:this.mapping,channel:this.channel,repeat:[this.repeat.x,this.repeat.y],offset:[this.offset.x,this.offset.y],center:[this.center.x,this.center.y],rotation:this.rotation,wrap:[this.wrapS,this.wrapT],format:this.format,internalFormat:this.internalFormat,type:this.type,normalized:this.normalized,colorSpace:this.colorSpace,minFilter:this.minFilter,magFilter:this.magFilter,anisotropy:this.anisotropy,flipY:this.flipY,generateMipmaps:this.generateMipmaps,premultiplyAlpha:this.premultiplyAlpha,unpackAlignment:this.unpackAlignment};return Object.keys(this.userData).length>0&&(i.userData=this.userData),e||(t.textures[this.uuid]=i),i}dispose(){this.dispatchEvent({type:"dispose"})}transformUv(t){if(this.mapping!==nh)return t;if(t.applyMatrix3(this.matrix),t.x<0||t.x>1)switch(this.wrapS){case Tn:t.x=t.x-Math.floor(t.x);break;case Vi:t.x=t.x<0?0:1;break;case ho:Math.abs(Math.floor(t.x)%2)===1?t.x=Math.ceil(t.x)-t.x:t.x=t.x-Math.floor(t.x);break}if(t.y<0||t.y>1)switch(this.wrapT){case Tn:t.y=t.y-Math.floor(t.y);break;case Vi:t.y=t.y<0?0:1;break;case ho:Math.abs(Math.floor(t.y)%2)===1?t.y=Math.ceil(t.y)-t.y:t.y=t.y-Math.floor(t.y);break}return this.flipY&&(t.y=1-t.y),t}set needsUpdate(t){t===!0&&(this.version++,this.source.needsUpdate=!0)}set needsPMREMUpdate(t){t===!0&&this.pmremVersion++}};ai.DEFAULT_IMAGE=null;ai.DEFAULT_MAPPING=nh;ai.DEFAULT_ANISOTROPY=1;var Mh=class Mh{constructor(t=0,e=0,i=0,s=1){this.x=t,this.y=e,this.z=i,this.w=s}get width(){return this.z}set width(t){this.z=t}get height(){return this.w}set height(t){this.w=t}set(t,e,i,s){return this.x=t,this.y=e,this.z=i,this.w=s,this}setScalar(t){return this.x=t,this.y=t,this.z=t,this.w=t,this}setX(t){return this.x=t,this}setY(t){return this.y=t,this}setZ(t){return this.z=t,this}setW(t){return this.w=t,this}setComponent(t,e){switch(t){case 0:this.x=e;break;case 1:this.y=e;break;case 2:this.z=e;break;case 3:this.w=e;break;default:throw new Error("THREE.Vector4: index is out of range: "+t)}return this}getComponent(t){switch(t){case 0:return this.x;case 1:return this.y;case 2:return this.z;case 3:return this.w;default:throw new Error("THREE.Vector4: index is out of range: "+t)}}clone(){return new this.constructor(this.x,this.y,this.z,this.w)}copy(t){return this.x=t.x,this.y=t.y,this.z=t.z,this.w=t.w!==void 0?t.w:1,this}add(t){return this.x+=t.x,this.y+=t.y,this.z+=t.z,this.w+=t.w,this}addScalar(t){return this.x+=t,this.y+=t,this.z+=t,this.w+=t,this}addVectors(t,e){return this.x=t.x+e.x,this.y=t.y+e.y,this.z=t.z+e.z,this.w=t.w+e.w,this}addScaledVector(t,e){return this.x+=t.x*e,this.y+=t.y*e,this.z+=t.z*e,this.w+=t.w*e,this}sub(t){return this.x-=t.x,this.y-=t.y,this.z-=t.z,this.w-=t.w,this}subScalar(t){return this.x-=t,this.y-=t,this.z-=t,this.w-=t,this}subVectors(t,e){return this.x=t.x-e.x,this.y=t.y-e.y,this.z=t.z-e.z,this.w=t.w-e.w,this}multiply(t){return this.x*=t.x,this.y*=t.y,this.z*=t.z,this.w*=t.w,this}multiplyScalar(t){return this.x*=t,this.y*=t,this.z*=t,this.w*=t,this}applyMatrix4(t){let e=this.x,i=this.y,s=this.z,r=this.w,a=t.elements;return this.x=a[0]*e+a[4]*i+a[8]*s+a[12]*r,this.y=a[1]*e+a[5]*i+a[9]*s+a[13]*r,this.z=a[2]*e+a[6]*i+a[10]*s+a[14]*r,this.w=a[3]*e+a[7]*i+a[11]*s+a[15]*r,this}divide(t){return this.x/=t.x,this.y/=t.y,this.z/=t.z,this.w/=t.w,this}divideScalar(t){return this.multiplyScalar(1/t)}setAxisAngleFromQuaternion(t){this.w=2*Math.acos(t.w);let e=Math.sqrt(1-t.w*t.w);return e<1e-4?(this.x=1,this.y=0,this.z=0):(this.x=t.x/e,this.y=t.y/e,this.z=t.z/e),this}setAxisAngleFromRotationMatrix(t){let e,i,s,r,l=t.elements,c=l[0],h=l[4],d=l[8],u=l[1],f=l[5],g=l[9],_=l[2],m=l[6],p=l[10];if(Math.abs(h-u)<.01&&Math.abs(d-_)<.01&&Math.abs(g-m)<.01){if(Math.abs(h+u)<.1&&Math.abs(d+_)<.1&&Math.abs(g+m)<.1&&Math.abs(c+f+p-3)<.1)return this.set(1,0,0,0),this;e=Math.PI;let R=(c+1)/2,y=(f+1)/2,w=(p+1)/2,S=(h+u)/4,I=(d+_)/4,v=(g+m)/4;return R>y&&R>w?R<.01?(i=0,s=.707106781,r=.707106781):(i=Math.sqrt(R),s=S/i,r=I/i):y>w?y<.01?(i=.707106781,s=0,r=.707106781):(s=Math.sqrt(y),i=S/s,r=v/s):w<.01?(i=.707106781,s=.707106781,r=0):(r=Math.sqrt(w),i=I/r,s=v/r),this.set(i,s,r,e),this}let M=Math.sqrt((m-g)*(m-g)+(d-_)*(d-_)+(u-h)*(u-h));return Math.abs(M)<.001&&(M=1),this.x=(m-g)/M,this.y=(d-_)/M,this.z=(u-h)/M,this.w=Math.acos((c+f+p-1)/2),this}setFromMatrixPosition(t){let e=t.elements;return this.x=e[12],this.y=e[13],this.z=e[14],this.w=e[15],this}min(t){return this.x=Math.min(this.x,t.x),this.y=Math.min(this.y,t.y),this.z=Math.min(this.z,t.z),this.w=Math.min(this.w,t.w),this}max(t){return this.x=Math.max(this.x,t.x),this.y=Math.max(this.y,t.y),this.z=Math.max(this.z,t.z),this.w=Math.max(this.w,t.w),this}clamp(t,e){return this.x=te(this.x,t.x,e.x),this.y=te(this.y,t.y,e.y),this.z=te(this.z,t.z,e.z),this.w=te(this.w,t.w,e.w),this}clampScalar(t,e){return this.x=te(this.x,t,e),this.y=te(this.y,t,e),this.z=te(this.z,t,e),this.w=te(this.w,t,e),this}clampLength(t,e){let i=this.length();return this.divideScalar(i||1).multiplyScalar(te(i,t,e))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this.w=Math.floor(this.w),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this.w=Math.ceil(this.w),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this.w=Math.round(this.w),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this.w=Math.trunc(this.w),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this.w=-this.w,this}dot(t){return this.x*t.x+this.y*t.y+this.z*t.z+this.w*t.w}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)+Math.abs(this.w)}normalize(){return this.divideScalar(this.length()||1)}setLength(t){return this.normalize().multiplyScalar(t)}lerp(t,e){return this.x+=(t.x-this.x)*e,this.y+=(t.y-this.y)*e,this.z+=(t.z-this.z)*e,this.w+=(t.w-this.w)*e,this}lerpVectors(t,e,i){return this.x=t.x+(e.x-t.x)*i,this.y=t.y+(e.y-t.y)*i,this.z=t.z+(e.z-t.z)*i,this.w=t.w+(e.w-t.w)*i,this}equals(t){return t.x===this.x&&t.y===this.y&&t.z===this.z&&t.w===this.w}fromArray(t,e=0){return this.x=t[e],this.y=t[e+1],this.z=t[e+2],this.w=t[e+3],this}toArray(t=[],e=0){return t[e]=this.x,t[e+1]=this.y,t[e+2]=this.z,t[e+3]=this.w,t}fromBufferAttribute(t,e){return this.x=t.getX(e),this.y=t.getY(e),this.z=t.getZ(e),this.w=t.getW(e),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this.w=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z,yield this.w}};Mh.prototype.isVector4=!0;var Ae=Mh,po=class extends Wi{constructor(t=1,e=1,i={}){super(),i=Object.assign({generateMipmaps:!1,internalFormat:null,minFilter:Oe,depthBuffer:!0,stencilBuffer:!1,resolveColorBuffer:!0,resolveDepthBuffer:!0,resolveStencilBuffer:!0,storeMultisampledColorBuffer:!0,storeMultisampledDepthBuffer:!0,storeMultisampledStencilBuffer:!0,depthTexture:null,samples:0,count:1,depth:1,multiview:!1,useArrayDepthTexture:!1},i),this.isRenderTarget=!0,this.width=t,this.height=e,this.depth=i.depth,this.scissor=new Ae(0,0,t,e),this.scissorTest=!1,this.viewport=new Ae(0,0,t,e),this.textures=[];let s={width:t,height:e,depth:i.depth},r=new ai(s),a=i.count;for(let o=0;o<a;o++)this.textures[o]=r.clone(),this.textures[o].isRenderTargetTexture=!0,this.textures[o].renderTarget=this;this._setTextureOptions(i),this.depthBuffer=i.depthBuffer,this.stencilBuffer=i.stencilBuffer,this.resolveColorBuffer=i.resolveColorBuffer,this.resolveDepthBuffer=i.resolveDepthBuffer,this.resolveStencilBuffer=i.resolveStencilBuffer,this.storeMultisampledColorBuffer=i.storeMultisampledColorBuffer,this.storeMultisampledDepthBuffer=i.storeMultisampledDepthBuffer,this.storeMultisampledStencilBuffer=i.storeMultisampledStencilBuffer,this._depthTexture=null,this.depthTexture=i.depthTexture,this.samples=i.samples,this.multiview=i.multiview,this.useArrayDepthTexture=i.useArrayDepthTexture}_setTextureOptions(t={}){let e={minFilter:Oe,generateMipmaps:!1,flipY:!1,internalFormat:null};t.mapping!==void 0&&(e.mapping=t.mapping),t.wrapS!==void 0&&(e.wrapS=t.wrapS),t.wrapT!==void 0&&(e.wrapT=t.wrapT),t.wrapR!==void 0&&(e.wrapR=t.wrapR),t.magFilter!==void 0&&(e.magFilter=t.magFilter),t.minFilter!==void 0&&(e.minFilter=t.minFilter),t.format!==void 0&&(e.format=t.format),t.type!==void 0&&(e.type=t.type),t.anisotropy!==void 0&&(e.anisotropy=t.anisotropy),t.colorSpace!==void 0&&(e.colorSpace=t.colorSpace),t.flipY!==void 0&&(e.flipY=t.flipY),t.generateMipmaps!==void 0&&(e.generateMipmaps=t.generateMipmaps),t.internalFormat!==void 0&&(e.internalFormat=t.internalFormat);for(let i=0;i<this.textures.length;i++)this.textures[i].setValues(e)}get texture(){return this.textures[0]}set texture(t){this.textures[0]=t}set depthTexture(t){this._depthTexture!==null&&this._depthTexture.renderTarget===this&&(this._depthTexture.renderTarget=null),t!==null&&t.renderTarget===null&&(t.renderTarget=this),this._depthTexture=t}get depthTexture(){return this._depthTexture}setSize(t,e,i=1){if(this.width!==t||this.height!==e||this.depth!==i){this.width=t,this.height=e,this.depth=i;for(let s=0,r=this.textures.length;s<r;s++)this.textures[s].image.width=t,this.textures[s].image.height=e,this.textures[s].image.depth=i,this.textures[s].isData3DTexture!==!0&&(this.textures[s].isArrayTexture=this.textures[s].image.depth>1);this.dispose()}this.viewport.set(0,0,t,e),this.scissor.set(0,0,t,e)}clone(){return new this.constructor().copy(this)}copy(t){this.width=t.width,this.height=t.height,this.depth=t.depth,this.scissor.copy(t.scissor),this.scissorTest=t.scissorTest,this.viewport.copy(t.viewport),this.textures.length=0;for(let e=0,i=t.textures.length;e<i;e++){this.textures[e]=t.textures[e].clone(),this.textures[e].isRenderTargetTexture=!0,this.textures[e].renderTarget=this;let s=Object.assign({},t.textures[e].image);this.textures[e].source=new Ns(s)}if(this.depthBuffer=t.depthBuffer,this.stencilBuffer=t.stencilBuffer,this.resolveColorBuffer=t.resolveColorBuffer,this.resolveDepthBuffer=t.resolveDepthBuffer,this.resolveStencilBuffer=t.resolveStencilBuffer,this.storeMultisampledColorBuffer=t.storeMultisampledColorBuffer,this.storeMultisampledDepthBuffer=t.storeMultisampledDepthBuffer,this.storeMultisampledStencilBuffer=t.storeMultisampledStencilBuffer,t.depthTexture!==null)if(t.depthTexture.renderTarget===t){let e=t.depthTexture.clone();e.renderTarget=null,this.depthTexture=e}else this.depthTexture=t.depthTexture;return this.samples=t.samples,this.multiview=t.multiview,this.useArrayDepthTexture=t.useArrayDepthTexture,this}dispose(){this.dispatchEvent({type:"dispose"})}},Re=class extends po{constructor(t=1,e=1,i={}){super(t,e,i),this.isWebGLRenderTarget=!0}},Rr=class extends ai{constructor(t=null,e=1,i=1,s=1){super(null),this.isDataArrayTexture=!0,this.image={data:t,width:e,height:i,depth:s},this.magFilter=qe,this.minFilter=qe,this.wrapR=Vi,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1,this.layerUpdates=new Set}copy(t){return super.copy(t),this.wrapR=t.wrapR,this}addLayerUpdate(t){this.layerUpdates.add(t)}clearLayerUpdates(){this.layerUpdates.clear()}};var mo=class extends ai{constructor(t=null,e=1,i=1,s=1){super(null),this.isData3DTexture=!0,this.image={data:t,width:e,height:i,depth:s},this.magFilter=qe,this.minFilter=qe,this.wrapR=Vi,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}copy(t){return super.copy(t),this.wrapR=t.wrapR,this}};var Fo=class Fo{constructor(t,e,i,s,r,a,o,l,c,h,d,u,f,g,_,m){this.elements=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],t!==void 0&&this.set(t,e,i,s,r,a,o,l,c,h,d,u,f,g,_,m)}set(t,e,i,s,r,a,o,l,c,h,d,u,f,g,_,m){let p=this.elements;return p[0]=t,p[4]=e,p[8]=i,p[12]=s,p[1]=r,p[5]=a,p[9]=o,p[13]=l,p[2]=c,p[6]=h,p[10]=d,p[14]=u,p[3]=f,p[7]=g,p[11]=_,p[15]=m,this}identity(){return this.set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),this}clone(){return new Fo().fromArray(this.elements)}copy(t){let e=this.elements,i=t.elements;return e[0]=i[0],e[1]=i[1],e[2]=i[2],e[3]=i[3],e[4]=i[4],e[5]=i[5],e[6]=i[6],e[7]=i[7],e[8]=i[8],e[9]=i[9],e[10]=i[10],e[11]=i[11],e[12]=i[12],e[13]=i[13],e[14]=i[14],e[15]=i[15],this}copyPosition(t){let e=this.elements,i=t.elements;return e[12]=i[12],e[13]=i[13],e[14]=i[14],this}setFromMatrix3(t){let e=t.elements;return this.set(e[0],e[3],e[6],0,e[1],e[4],e[7],0,e[2],e[5],e[8],0,0,0,0,1),this}extractBasis(t,e,i){return this.determinantAffine()===0?(t.set(1,0,0),e.set(0,1,0),i.set(0,0,1),this):(t.setFromMatrixColumn(this,0),e.setFromMatrixColumn(this,1),i.setFromMatrixColumn(this,2),this)}makeBasis(t,e,i){return this.set(t.x,e.x,i.x,0,t.y,e.y,i.y,0,t.z,e.z,i.z,0,0,0,0,1),this}extractRotation(t){if(t.determinantAffine()===0)return this.identity();let e=this.elements,i=t.elements,s=1/us.setFromMatrixColumn(t,0).length(),r=1/us.setFromMatrixColumn(t,1).length(),a=1/us.setFromMatrixColumn(t,2).length();return e[0]=i[0]*s,e[1]=i[1]*s,e[2]=i[2]*s,e[3]=0,e[4]=i[4]*r,e[5]=i[5]*r,e[6]=i[6]*r,e[7]=0,e[8]=i[8]*a,e[9]=i[9]*a,e[10]=i[10]*a,e[11]=0,e[12]=0,e[13]=0,e[14]=0,e[15]=1,this}makeRotationFromEuler(t){let e=this.elements,i=t.x,s=t.y,r=t.z,a=Math.cos(i),o=Math.sin(i),l=Math.cos(s),c=Math.sin(s),h=Math.cos(r),d=Math.sin(r);if(t.order==="XYZ"){let u=a*h,f=a*d,g=o*h,_=o*d;e[0]=l*h,e[4]=-l*d,e[8]=c,e[1]=f+g*c,e[5]=u-_*c,e[9]=-o*l,e[2]=_-u*c,e[6]=g+f*c,e[10]=a*l}else if(t.order==="YXZ"){let u=l*h,f=l*d,g=c*h,_=c*d;e[0]=u+_*o,e[4]=g*o-f,e[8]=a*c,e[1]=a*d,e[5]=a*h,e[9]=-o,e[2]=f*o-g,e[6]=_+u*o,e[10]=a*l}else if(t.order==="ZXY"){let u=l*h,f=l*d,g=c*h,_=c*d;e[0]=u-_*o,e[4]=-a*d,e[8]=g+f*o,e[1]=f+g*o,e[5]=a*h,e[9]=_-u*o,e[2]=-a*c,e[6]=o,e[10]=a*l}else if(t.order==="ZYX"){let u=a*h,f=a*d,g=o*h,_=o*d;e[0]=l*h,e[4]=g*c-f,e[8]=u*c+_,e[1]=l*d,e[5]=_*c+u,e[9]=f*c-g,e[2]=-c,e[6]=o*l,e[10]=a*l}else if(t.order==="YZX"){let u=a*l,f=a*c,g=o*l,_=o*c;e[0]=l*h,e[4]=_-u*d,e[8]=g*d+f,e[1]=d,e[5]=a*h,e[9]=-o*h,e[2]=-c*h,e[6]=f*d+g,e[10]=u-_*d}else if(t.order==="XZY"){let u=a*l,f=a*c,g=o*l,_=o*c;e[0]=l*h,e[4]=-d,e[8]=c*h,e[1]=u*d+_,e[5]=a*h,e[9]=f*d-g,e[2]=g*d-f,e[6]=o*h,e[10]=_*d+u}return e[3]=0,e[7]=0,e[11]=0,e[12]=0,e[13]=0,e[14]=0,e[15]=1,this}makeRotationFromQuaternion(t){return this.compose(Cp,t,Ip)}lookAt(t,e,i){let s=this.elements;return ci.subVectors(t,e),ci.lengthSq()===0&&(ci.z=1),ci.normalize(),yn.crossVectors(i,ci),yn.lengthSq()===0&&(Math.abs(i.z)===1?ci.x+=1e-4:ci.z+=1e-4,ci.normalize(),yn.crossVectors(i,ci)),yn.normalize(),Ca.crossVectors(ci,yn),s[0]=yn.x,s[4]=Ca.x,s[8]=ci.x,s[1]=yn.y,s[5]=Ca.y,s[9]=ci.y,s[2]=yn.z,s[6]=Ca.z,s[10]=ci.z,this}multiply(t){return this.multiplyMatrices(this,t)}premultiply(t){return this.multiplyMatrices(t,this)}multiplyMatrices(t,e){let i=t.elements,s=e.elements,r=this.elements,a=i[0],o=i[4],l=i[8],c=i[12],h=i[1],d=i[5],u=i[9],f=i[13],g=i[2],_=i[6],m=i[10],p=i[14],M=i[3],R=i[7],y=i[11],w=i[15],S=s[0],I=s[4],v=s[8],A=s[12],P=s[1],O=s[5],L=s[9],z=s[13],D=s[2],k=s[6],Y=s[10],q=s[14],Z=s[3],V=s[7],tt=s[11],rt=s[15];return r[0]=a*S+o*P+l*D+c*Z,r[4]=a*I+o*O+l*k+c*V,r[8]=a*v+o*L+l*Y+c*tt,r[12]=a*A+o*z+l*q+c*rt,r[1]=h*S+d*P+u*D+f*Z,r[5]=h*I+d*O+u*k+f*V,r[9]=h*v+d*L+u*Y+f*tt,r[13]=h*A+d*z+u*q+f*rt,r[2]=g*S+_*P+m*D+p*Z,r[6]=g*I+_*O+m*k+p*V,r[10]=g*v+_*L+m*Y+p*tt,r[14]=g*A+_*z+m*q+p*rt,r[3]=M*S+R*P+y*D+w*Z,r[7]=M*I+R*O+y*k+w*V,r[11]=M*v+R*L+y*Y+w*tt,r[15]=M*A+R*z+y*q+w*rt,this}multiplyScalar(t){let e=this.elements;return e[0]*=t,e[4]*=t,e[8]*=t,e[12]*=t,e[1]*=t,e[5]*=t,e[9]*=t,e[13]*=t,e[2]*=t,e[6]*=t,e[10]*=t,e[14]*=t,e[3]*=t,e[7]*=t,e[11]*=t,e[15]*=t,this}determinant(){let t=this.elements,e=t[0],i=t[4],s=t[8],r=t[12],a=t[1],o=t[5],l=t[9],c=t[13],h=t[2],d=t[6],u=t[10],f=t[14],g=t[3],_=t[7],m=t[11],p=t[15],M=l*f-c*u,R=o*f-c*d,y=o*u-l*d,w=a*f-c*h,S=a*u-l*h,I=a*d-o*h;return e*(_*M-m*R+p*y)-i*(g*M-m*w+p*S)+s*(g*R-_*w+p*I)-r*(g*y-_*S+m*I)}determinantAffine(){let t=this.elements,e=t[0],i=t[4],s=t[8],r=t[1],a=t[5],o=t[9],l=t[2],c=t[6],h=t[10];return e*(a*h-o*c)-i*(r*h-o*l)+s*(r*c-a*l)}transpose(){let t=this.elements,e;return e=t[1],t[1]=t[4],t[4]=e,e=t[2],t[2]=t[8],t[8]=e,e=t[6],t[6]=t[9],t[9]=e,e=t[3],t[3]=t[12],t[12]=e,e=t[7],t[7]=t[13],t[13]=e,e=t[11],t[11]=t[14],t[14]=e,this}setPosition(t,e,i){let s=this.elements;return t.isVector3?(s[12]=t.x,s[13]=t.y,s[14]=t.z):(s[12]=t,s[13]=e,s[14]=i),this}invert(){let t=this.elements,e=t[0],i=t[1],s=t[2],r=t[3],a=t[4],o=t[5],l=t[6],c=t[7],h=t[8],d=t[9],u=t[10],f=t[11],g=t[12],_=t[13],m=t[14],p=t[15],M=e*o-i*a,R=e*l-s*a,y=e*c-r*a,w=i*l-s*o,S=i*c-r*o,I=s*c-r*l,v=h*_-d*g,A=h*m-u*g,P=h*p-f*g,O=d*m-u*_,L=d*p-f*_,z=u*p-f*m,D=M*z-R*L+y*O+w*P-S*A+I*v;if(D===0)return this.set(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);let k=1/D;return t[0]=(o*z-l*L+c*O)*k,t[1]=(s*L-i*z-r*O)*k,t[2]=(_*I-m*S+p*w)*k,t[3]=(u*S-d*I-f*w)*k,t[4]=(l*P-a*z-c*A)*k,t[5]=(e*z-s*P+r*A)*k,t[6]=(m*y-g*I-p*R)*k,t[7]=(h*I-u*y+f*R)*k,t[8]=(a*L-o*P+c*v)*k,t[9]=(i*P-e*L-r*v)*k,t[10]=(g*S-_*y+p*M)*k,t[11]=(d*y-h*S-f*M)*k,t[12]=(o*A-a*O-l*v)*k,t[13]=(e*O-i*A+s*v)*k,t[14]=(_*R-g*w-m*M)*k,t[15]=(h*w-d*R+u*M)*k,this}scale(t){let e=this.elements,i=t.x,s=t.y,r=t.z;return e[0]*=i,e[4]*=s,e[8]*=r,e[1]*=i,e[5]*=s,e[9]*=r,e[2]*=i,e[6]*=s,e[10]*=r,e[3]*=i,e[7]*=s,e[11]*=r,this}getMaxScaleOnAxis(){let t=this.elements,e=t[0]*t[0]+t[1]*t[1]+t[2]*t[2],i=t[4]*t[4]+t[5]*t[5]+t[6]*t[6],s=t[8]*t[8]+t[9]*t[9]+t[10]*t[10];return Math.sqrt(Math.max(e,i,s))}makeTranslation(t,e,i){return t.isVector3?this.set(1,0,0,t.x,0,1,0,t.y,0,0,1,t.z,0,0,0,1):this.set(1,0,0,t,0,1,0,e,0,0,1,i,0,0,0,1),this}makeRotationX(t){let e=Math.cos(t),i=Math.sin(t);return this.set(1,0,0,0,0,e,-i,0,0,i,e,0,0,0,0,1),this}makeRotationY(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,0,i,0,0,1,0,0,-i,0,e,0,0,0,0,1),this}makeRotationZ(t){let e=Math.cos(t),i=Math.sin(t);return this.set(e,-i,0,0,i,e,0,0,0,0,1,0,0,0,0,1),this}makeRotationAxis(t,e){let i=Math.cos(e),s=Math.sin(e),r=1-i,a=t.x,o=t.y,l=t.z,c=r*a,h=r*o;return this.set(c*a+i,c*o-s*l,c*l+s*o,0,c*o+s*l,h*o+i,h*l-s*a,0,c*l-s*o,h*l+s*a,r*l*l+i,0,0,0,0,1),this}makeScale(t,e,i){return this.set(t,0,0,0,0,e,0,0,0,0,i,0,0,0,0,1),this}makeShear(t,e,i,s,r,a){return this.set(1,i,r,0,t,1,a,0,e,s,1,0,0,0,0,1),this}compose(t,e,i){let s=this.elements,r=e._x,a=e._y,o=e._z,l=e._w,c=r+r,h=a+a,d=o+o,u=r*c,f=r*h,g=r*d,_=a*h,m=a*d,p=o*d,M=l*c,R=l*h,y=l*d,w=i.x,S=i.y,I=i.z;return s[0]=(1-(_+p))*w,s[1]=(f+y)*w,s[2]=(g-R)*w,s[3]=0,s[4]=(f-y)*S,s[5]=(1-(u+p))*S,s[6]=(m+M)*S,s[7]=0,s[8]=(g+R)*I,s[9]=(m-M)*I,s[10]=(1-(u+_))*I,s[11]=0,s[12]=t.x,s[13]=t.y,s[14]=t.z,s[15]=1,this}decompose(t,e,i){let s=this.elements;t.x=s[12],t.y=s[13],t.z=s[14];let r=this.determinantAffine();if(r===0)return i.set(1,1,1),e.identity(),this;let a=us.set(s[0],s[1],s[2]).length(),o=us.set(s[4],s[5],s[6]).length(),l=us.set(s[8],s[9],s[10]).length();r<0&&(a=-a),Ci.copy(this);let c=1/a,h=1/o,d=1/l;return Ci.elements[0]*=c,Ci.elements[1]*=c,Ci.elements[2]*=c,Ci.elements[4]*=h,Ci.elements[5]*=h,Ci.elements[6]*=h,Ci.elements[8]*=d,Ci.elements[9]*=d,Ci.elements[10]*=d,e.setFromRotationMatrix(Ci),i.x=a,i.y=o,i.z=l,this}makePerspective(t,e,i,s,r,a,o=Di,l=!1){let c=this.elements,h=2*r/(e-t),d=2*r/(i-s),u=(e+t)/(e-t),f=(i+s)/(i-s),g,_;if(l)g=r/(a-r),_=a*r/(a-r);else if(o===Di)g=-(a+r)/(a-r),_=-2*a*r/(a-r);else if(o===Ps)g=-a/(a-r),_=-a*r/(a-r);else throw new Error("THREE.Matrix4.makePerspective(): Invalid coordinate system: "+o);return c[0]=h,c[4]=0,c[8]=u,c[12]=0,c[1]=0,c[5]=d,c[9]=f,c[13]=0,c[2]=0,c[6]=0,c[10]=g,c[14]=_,c[3]=0,c[7]=0,c[11]=-1,c[15]=0,this}makeOrthographic(t,e,i,s,r,a,o=Di,l=!1){let c=this.elements,h=2/(e-t),d=2/(i-s),u=-(e+t)/(e-t),f=-(i+s)/(i-s),g,_;if(l)g=1/(a-r),_=a/(a-r);else if(o===Di)g=-2/(a-r),_=-(a+r)/(a-r);else if(o===Ps)g=-1/(a-r),_=-r/(a-r);else throw new Error("THREE.Matrix4.makeOrthographic(): Invalid coordinate system: "+o);return c[0]=h,c[4]=0,c[8]=0,c[12]=u,c[1]=0,c[5]=d,c[9]=0,c[13]=f,c[2]=0,c[6]=0,c[10]=g,c[14]=_,c[3]=0,c[7]=0,c[11]=0,c[15]=1,this}equals(t){let e=this.elements,i=t.elements;for(let s=0;s<16;s++)if(e[s]!==i[s])return!1;return!0}fromArray(t,e=0){for(let i=0;i<16;i++)this.elements[i]=t[i+e];return this}toArray(t=[],e=0){let i=this.elements;return t[e]=i[0],t[e+1]=i[1],t[e+2]=i[2],t[e+3]=i[3],t[e+4]=i[4],t[e+5]=i[5],t[e+6]=i[6],t[e+7]=i[7],t[e+8]=i[8],t[e+9]=i[9],t[e+10]=i[10],t[e+11]=i[11],t[e+12]=i[12],t[e+13]=i[13],t[e+14]=i[14],t[e+15]=i[15],t}};Fo.prototype.isMatrix4=!0;var oe=Fo,us=new N,Ci=new oe,Cp=new N(0,0,0),Ip=new N(1,1,1),yn=new N,Ca=new N,ci=new N,vu=new oe,yu=new xi,_i=class n{constructor(t=0,e=0,i=0,s=n.DEFAULT_ORDER){this.isEuler=!0,this._x=t,this._y=e,this._z=i,this._order=s}get x(){return this._x}set x(t){this._x=t,this._onChangeCallback()}get y(){return this._y}set y(t){this._y=t,this._onChangeCallback()}get z(){return this._z}set z(t){this._z=t,this._onChangeCallback()}get order(){return this._order}set order(t){this._order=t,this._onChangeCallback()}set(t,e,i,s=this._order){return this._x=t,this._y=e,this._z=i,this._order=s,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._order)}copy(t){return this._x=t._x,this._y=t._y,this._z=t._z,this._order=t._order,this._onChangeCallback(),this}setFromRotationMatrix(t,e=this._order,i=!0){let s=t.elements,r=s[0],a=s[4],o=s[8],l=s[1],c=s[5],h=s[9],d=s[2],u=s[6],f=s[10];switch(e){case"XYZ":this._y=Math.asin(te(o,-1,1)),Math.abs(o)<.9999999?(this._x=Math.atan2(-h,f),this._z=Math.atan2(-a,r)):(this._x=Math.atan2(u,c),this._z=0);break;case"YXZ":this._x=Math.asin(-te(h,-1,1)),Math.abs(h)<.9999999?(this._y=Math.atan2(o,f),this._z=Math.atan2(l,c)):(this._y=Math.atan2(-d,r),this._z=0);break;case"ZXY":this._x=Math.asin(te(u,-1,1)),Math.abs(u)<.9999999?(this._y=Math.atan2(-d,f),this._z=Math.atan2(-a,c)):(this._y=0,this._z=Math.atan2(l,r));break;case"ZYX":this._y=Math.asin(-te(d,-1,1)),Math.abs(d)<.9999999?(this._x=Math.atan2(u,f),this._z=Math.atan2(l,r)):(this._x=0,this._z=Math.atan2(-a,c));break;case"YZX":this._z=Math.asin(te(l,-1,1)),Math.abs(l)<.9999999?(this._x=Math.atan2(-h,c),this._y=Math.atan2(-d,r)):(this._x=0,this._y=Math.atan2(o,f));break;case"XZY":this._z=Math.asin(-te(a,-1,1)),Math.abs(a)<.9999999?(this._x=Math.atan2(u,c),this._y=Math.atan2(o,r)):(this._x=Math.atan2(-h,f),this._y=0);break;default:kt("Euler: .setFromRotationMatrix() encountered an unknown order: "+e)}return this._order=e,i===!0&&this._onChangeCallback(),this}setFromQuaternion(t,e,i){return vu.makeRotationFromQuaternion(t),this.setFromRotationMatrix(vu,e,i)}setFromVector3(t,e=this._order){return this.set(t.x,t.y,t.z,e)}reorder(t){return yu.setFromEuler(this),this.setFromQuaternion(yu,t)}equals(t){return t._x===this._x&&t._y===this._y&&t._z===this._z&&t._order===this._order}fromArray(t){return this._x=t[0],this._y=t[1],this._z=t[2],t[3]!==void 0&&(this._order=t[3]),this._onChangeCallback(),this}toArray(t=[],e=0){return t[e]=this._x,t[e+1]=this._y,t[e+2]=this._z,t[e+3]=this._order,t}_onChange(t){return this._onChangeCallback=t,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._order}};_i.DEFAULT_ORDER="XYZ";var Us=class{constructor(){this.mask=1}set(t){this.mask=(1<<t|0)>>>0}enable(t){this.mask|=1<<t|0}enableAll(){this.mask=-1}toggle(t){this.mask^=1<<t|0}disable(t){this.mask&=~(1<<t|0)}disableAll(){this.mask=0}test(t){return(this.mask&t.mask)!==0}isEnabled(t){return(this.mask&(1<<t|0))!==0}},Pp=0,Mu=new N,ds=new xi,en=new oe,Ia=new N,ur=new N,Lp=new N,Dp=new xi,bu=new N(1,0,0),Su=new N(0,1,0),wu=new N(0,0,1),Tu={type:"added"},Np={type:"removed"},fs={type:"childadded",child:null},Sc={type:"childremoved",child:null},Pe=class n extends Wi{constructor(){super(),this.isObject3D=!0,Object.defineProperty(this,"id",{value:Pp++}),this.uuid=ln(),this.name="",this.type="Object3D",this.parent=null,this.children=[],this.up=n.DEFAULT_UP.clone();let t=new N,e=new _i,i=new xi,s=new N(1,1,1);function r(){i.setFromEuler(e,!1)}function a(){e.setFromQuaternion(i,void 0,!1)}e._onChange(r),i._onChange(a),Object.defineProperties(this,{position:{configurable:!0,enumerable:!0,value:t},rotation:{configurable:!0,enumerable:!0,value:e},quaternion:{configurable:!0,enumerable:!0,value:i},scale:{configurable:!0,enumerable:!0,value:s},modelViewMatrix:{value:new oe},normalMatrix:{value:new Xt}}),this.matrix=new oe,this.matrixWorld=new oe,this.matrixAutoUpdate=n.DEFAULT_MATRIX_AUTO_UPDATE,this.matrixWorldAutoUpdate=n.DEFAULT_MATRIX_WORLD_AUTO_UPDATE,this.matrixWorldNeedsUpdate=!1,this.layers=new Us,this.visible=!0,this.castShadow=!1,this.receiveShadow=!1,this.frustumCulled=!0,this.renderOrder=0,this.animations=[],this.customDepthMaterial=void 0,this.customDistanceMaterial=void 0,this.static=!1,this.userData={},this.pivot=null}onBeforeShadow(){}onAfterShadow(){}onBeforeRender(){}onAfterRender(){}applyMatrix4(t){this.matrixAutoUpdate&&this.updateMatrix(),this.matrix.premultiply(t),this.matrix.decompose(this.position,this.quaternion,this.scale)}applyQuaternion(t){return this.quaternion.premultiply(t),this}setRotationFromAxisAngle(t,e){this.quaternion.setFromAxisAngle(t,e)}setRotationFromEuler(t){this.quaternion.setFromEuler(t,!0)}setRotationFromMatrix(t){this.quaternion.setFromRotationMatrix(t)}setRotationFromQuaternion(t){this.quaternion.copy(t)}rotateOnAxis(t,e){return ds.setFromAxisAngle(t,e),this.quaternion.multiply(ds),this}rotateOnWorldAxis(t,e){return ds.setFromAxisAngle(t,e),this.quaternion.premultiply(ds),this}rotateX(t){return this.rotateOnAxis(bu,t)}rotateY(t){return this.rotateOnAxis(Su,t)}rotateZ(t){return this.rotateOnAxis(wu,t)}translateOnAxis(t,e){return Mu.copy(t).applyQuaternion(this.quaternion),this.position.add(Mu.multiplyScalar(e)),this}translateX(t){return this.translateOnAxis(bu,t)}translateY(t){return this.translateOnAxis(Su,t)}translateZ(t){return this.translateOnAxis(wu,t)}localToWorld(t){return this.updateWorldMatrix(!0,!1),t.applyMatrix4(this.matrixWorld)}worldToLocal(t){return this.updateWorldMatrix(!0,!1),t.applyMatrix4(en.copy(this.matrixWorld).invert())}lookAt(t,e,i){t.isVector3?Ia.copy(t):Ia.set(t,e,i);let s=this.parent;this.updateWorldMatrix(!0,!1),ur.setFromMatrixPosition(this.matrixWorld),this.isCamera||this.isLight?en.lookAt(ur,Ia,this.up):en.lookAt(Ia,ur,this.up),this.quaternion.setFromRotationMatrix(en),s&&(en.extractRotation(s.matrixWorld),ds.setFromRotationMatrix(en),this.quaternion.premultiply(ds.invert()))}add(t){if(arguments.length>1){for(let e=0;e<arguments.length;e++)this.add(arguments[e]);return this}return t===this?(Ht("Object3D.add: object can't be added as a child of itself.",t),this):(t&&t.isObject3D?(t.removeFromParent(),t.parent=this,this.children.push(t),t.dispatchEvent(Tu),fs.child=t,this.dispatchEvent(fs),fs.child=null):Ht("Object3D.add: object not an instance of THREE.Object3D.",t),this)}remove(t){if(arguments.length>1){for(let i=0;i<arguments.length;i++)this.remove(arguments[i]);return this}let e=this.children.indexOf(t);return e!==-1&&(t.parent=null,this.children.splice(e,1),t.dispatchEvent(Np),Sc.child=t,this.dispatchEvent(Sc),Sc.child=null),this}removeFromParent(){let t=this.parent;return t!==null&&t.remove(this),this}clear(){return this.remove(...this.children)}attach(t){return this.updateWorldMatrix(!0,!1),en.copy(this.matrixWorld).invert(),t.parent!==null&&(t.parent.updateWorldMatrix(!0,!1),en.multiply(t.parent.matrixWorld)),t.applyMatrix4(en),t.removeFromParent(),t.parent=this,this.children.push(t),t.updateWorldMatrix(!1,!0),t.dispatchEvent(Tu),fs.child=t,this.dispatchEvent(fs),fs.child=null,this}getObjectById(t){return this.getObjectByProperty("id",t)}getObjectByName(t){return this.getObjectByProperty("name",t)}getObjectByProperty(t,e){if(this[t]===e)return this;for(let i=0,s=this.children.length;i<s;i++){let a=this.children[i].getObjectByProperty(t,e);if(a!==void 0)return a}}getObjectsByProperty(t,e,i=[]){this[t]===e&&i.push(this);let s=this.children;for(let r=0,a=s.length;r<a;r++)s[r].getObjectsByProperty(t,e,i);return i}getWorldPosition(t){return this.updateWorldMatrix(!0,!1),t.setFromMatrixPosition(this.matrixWorld)}getWorldQuaternion(t){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(ur,t,Lp),t}getWorldScale(t){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(ur,Dp,t),t}getWorldDirection(t){this.updateWorldMatrix(!0,!1);let e=this.matrixWorld.elements;return t.set(e[8],e[9],e[10]).normalize()}raycast(){}intersectsFrustum(){}traverse(t){t(this);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].traverse(t)}traverseVisible(t){if(this.visible===!1)return;t(this);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].traverseVisible(t)}traverseAncestors(t){let e=this.parent;e!==null&&(t(e),e.traverseAncestors(t))}updateMatrix(){this.matrix.compose(this.position,this.quaternion,this.scale);let t=this.pivot;if(t!==null){let e=t.x,i=t.y,s=t.z,r=this.matrix.elements;r[12]+=e-r[0]*e-r[4]*i-r[8]*s,r[13]+=i-r[1]*e-r[5]*i-r[9]*s,r[14]+=s-r[2]*e-r[6]*i-r[10]*s}this.matrixWorldNeedsUpdate=!0}updateMatrixWorld(t){this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||t)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,t=!0);let e=this.children;for(let i=0,s=e.length;i<s;i++)e[i].updateMatrixWorld(t)}updateWorldMatrix(t,e,i=!1){let s=this.parent;if(t===!0&&s!==null&&s.updateWorldMatrix(!0,!1),this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||i)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,i=!0),e===!0){let r=this.children;for(let a=0,o=r.length;a<o;a++)r[a].updateWorldMatrix(!1,!0,i)}}toJSON(t){let e=t===void 0||typeof t=="string",i={};e&&(t={geometries:{},materials:{},textures:{},images:{},shapes:{},skeletons:{},animations:{},nodes:{}},i.metadata={version:4.7,type:"Object",generator:"Object3D.toJSON"});let s={};s.uuid=this.uuid,s.type=this.type,s.name=this.name,s.castShadow=this.castShadow,s.receiveShadow=this.receiveShadow,s.visible=this.visible,s.frustumCulled=this.frustumCulled,s.renderOrder=this.renderOrder,s.static=this.static,s.matrixAutoUpdate=this.matrixAutoUpdate,Object.keys(this.userData).length>0&&(s.userData=this.userData),s.layers=this.layers.mask,s.matrix=this.matrix.toArray(),s.up=this.up.toArray(),this.pivot!==null&&(s.pivot=this.pivot.toArray()),this.morphTargetDictionary!==void 0&&(s.morphTargetDictionary=Object.assign({},this.morphTargetDictionary)),this.morphTargetInfluences!==void 0&&(s.morphTargetInfluences=this.morphTargetInfluences.slice()),this.isInstancedMesh&&(s.type="InstancedMesh",s.count=this.count,s.instanceMatrix=this.instanceMatrix.toJSON(),this.instanceColor!==null&&(s.instanceColor=this.instanceColor.toJSON())),this.isBatchedMesh&&(s.type="BatchedMesh",s.perObjectFrustumCulled=this.perObjectFrustumCulled,s.sortObjects=this.sortObjects,s.drawRanges=this._drawRanges,s.reservedRanges=this._reservedRanges,s.geometryInfo=this._geometryInfo.map(o=>({...o,boundingBox:o.boundingBox?o.boundingBox.toJSON():void 0,boundingSphere:o.boundingSphere?o.boundingSphere.toJSON():void 0})),s.instanceInfo=this._instanceInfo.map(o=>({...o})),s.availableInstanceIds=this._availableInstanceIds.slice(),s.availableGeometryIds=this._availableGeometryIds.slice(),s.nextIndexStart=this._nextIndexStart,s.nextVertexStart=this._nextVertexStart,s.geometryCount=this._geometryCount,s.maxInstanceCount=this._maxInstanceCount,s.maxVertexCount=this._maxVertexCount,s.maxIndexCount=this._maxIndexCount,s.geometryInitialized=this._geometryInitialized,s.matricesTexture=this._matricesTexture.toJSON(t),s.indirectTexture=this._indirectTexture.toJSON(t),this._colorsTexture!==null&&(s.colorsTexture=this._colorsTexture.toJSON(t)),this.boundingSphere!==null&&(s.boundingSphere=this.boundingSphere.toJSON()),this.boundingBox!==null&&(s.boundingBox=this.boundingBox.toJSON()));function r(o,l){return o[l.uuid]===void 0&&(o[l.uuid]=l.toJSON(t)),l.uuid}if(this.isScene)this.background&&(this.background.isColor?s.background=this.background.toJSON():this.background.isTexture&&(s.background=this.background.toJSON(t).uuid)),this.environment&&this.environment.isTexture&&this.environment.isRenderTargetTexture!==!0&&(s.environment=this.environment.toJSON(t).uuid);else if(this.isMesh||this.isLine||this.isPoints){s.geometry=r(t.geometries,this.geometry);let o=this.geometry.parameters;if(o!==void 0&&o.shapes!==void 0){let l=o.shapes;if(Array.isArray(l))for(let c=0,h=l.length;c<h;c++){let d=l[c];r(t.shapes,d)}else r(t.shapes,l)}}if(this.isSkinnedMesh&&(s.bindMode=this.bindMode,s.bindMatrix=this.bindMatrix.toArray(),this.skeleton!==void 0&&(r(t.skeletons,this.skeleton),s.skeleton=this.skeleton.uuid)),this.material!==void 0)if(Array.isArray(this.material)){let o=[];for(let l=0,c=this.material.length;l<c;l++)o.push(r(t.materials,this.material[l]));s.material=o}else s.material=r(t.materials,this.material);if(this.children.length>0){s.children=[];for(let o=0;o<this.children.length;o++)s.children.push(this.children[o].toJSON(t).object)}if(this.animations.length>0){s.animations=[];for(let o=0;o<this.animations.length;o++){let l=this.animations[o];s.animations.push(r(t.animations,l))}}if(e){let o=a(t.geometries),l=a(t.materials),c=a(t.textures),h=a(t.images),d=a(t.shapes),u=a(t.skeletons),f=a(t.animations),g=a(t.nodes);o.length>0&&(i.geometries=o),l.length>0&&(i.materials=l),c.length>0&&(i.textures=c),h.length>0&&(i.images=h),d.length>0&&(i.shapes=d),u.length>0&&(i.skeletons=u),f.length>0&&(i.animations=f),g.length>0&&(i.nodes=g)}return i.object=s,i;function a(o){let l=[];for(let c in o){let h=o[c];delete h.metadata,l.push(h)}return l}}clone(t){return new this.constructor().copy(this,t)}copy(t,e=!0){if(this.name=t.name,this.up.copy(t.up),this.position.copy(t.position),this.rotation.order=t.rotation.order,this.quaternion.copy(t.quaternion),this.scale.copy(t.scale),this.pivot=t.pivot!==null?t.pivot.clone():null,this.matrix.copy(t.matrix),this.matrixWorld.copy(t.matrixWorld),this.matrixAutoUpdate=t.matrixAutoUpdate,this.matrixWorldAutoUpdate=t.matrixWorldAutoUpdate,this.matrixWorldNeedsUpdate=t.matrixWorldNeedsUpdate,this.layers.mask=t.layers.mask,this.visible=t.visible,this.castShadow=t.castShadow,this.receiveShadow=t.receiveShadow,this.frustumCulled=t.frustumCulled,this.renderOrder=t.renderOrder,this.static=t.static,this.animations=t.animations.slice(),this.userData=JSON.parse(JSON.stringify(t.userData)),e===!0)for(let i=0;i<t.children.length;i++){let s=t.children[i];this.add(s.clone())}return this}dispose(){this.dispatchEvent({type:"dispose"})}};Pe.DEFAULT_UP=new N(0,1,0);Pe.DEFAULT_MATRIX_AUTO_UPDATE=!0;Pe.DEFAULT_MATRIX_WORLD_AUTO_UPDATE=!0;var fe=class extends Pe{constructor(){super(),this.isGroup=!0,this.type="Group"}},Up={type:"move"},Fs=class{constructor(){this._targetRay=null,this._grip=null,this._hand=null}getHandSpace(){return this._hand===null&&(this._hand=new fe,this._hand.matrixAutoUpdate=!1,this._hand.visible=!1,this._hand.joints={},this._hand.inputState={pinching:!1}),this._hand}getTargetRaySpace(){return this._targetRay===null&&(this._targetRay=new fe,this._targetRay.matrixAutoUpdate=!1,this._targetRay.visible=!1,this._targetRay.hasLinearVelocity=!1,this._targetRay.linearVelocity=new N,this._targetRay.hasAngularVelocity=!1,this._targetRay.angularVelocity=new N),this._targetRay}getGripSpace(){return this._grip===null&&(this._grip=new fe,this._grip.matrixAutoUpdate=!1,this._grip.visible=!1,this._grip.hasLinearVelocity=!1,this._grip.linearVelocity=new N,this._grip.hasAngularVelocity=!1,this._grip.angularVelocity=new N,this._grip.eventsEnabled=!1),this._grip}dispatchEvent(t){return this._targetRay!==null&&this._targetRay.dispatchEvent(t),this._grip!==null&&this._grip.dispatchEvent(t),this._hand!==null&&this._hand.dispatchEvent(t),this}connect(t){if(t&&t.hand){let e=this._hand;if(e)for(let i of t.hand.values())this._getHandJoint(e,i)}return this.dispatchEvent({type:"connected",data:t}),this}disconnect(t){return this.dispatchEvent({type:"disconnected",data:t}),this._targetRay!==null&&(this._targetRay.visible=!1),this._grip!==null&&(this._grip.visible=!1),this._hand!==null&&(this._hand.visible=!1),this}update(t,e,i){let s=null,r=null,a=null,o=this._targetRay,l=this._grip,c=this._hand;if(t&&e.session.visibilityState!=="visible-blurred"){if(c&&t.hand){a=!0;for(let _ of t.hand.values()){let m=e.getJointPose(_,i),p=this._getHandJoint(c,_);m!==null&&(p.matrix.fromArray(m.transform.matrix),p.matrix.decompose(p.position,p.rotation,p.scale),p.matrixWorldNeedsUpdate=!0,p.jointRadius=m.radius),p.visible=m!==null}let h=c.joints["index-finger-tip"],d=c.joints["thumb-tip"],u=h.position.distanceTo(d.position),f=.02,g=.005;c.inputState.pinching&&u>f+g?(c.inputState.pinching=!1,this.dispatchEvent({type:"pinchend",handedness:t.handedness,target:this})):!c.inputState.pinching&&u<=f-g&&(c.inputState.pinching=!0,this.dispatchEvent({type:"pinchstart",handedness:t.handedness,target:this}))}else l!==null&&t.gripSpace&&(r=e.getPose(t.gripSpace,i),r!==null&&(l.matrix.fromArray(r.transform.matrix),l.matrix.decompose(l.position,l.rotation,l.scale),l.matrixWorldNeedsUpdate=!0,r.linearVelocity?(l.hasLinearVelocity=!0,l.linearVelocity.copy(r.linearVelocity)):l.hasLinearVelocity=!1,r.angularVelocity?(l.hasAngularVelocity=!0,l.angularVelocity.copy(r.angularVelocity)):l.hasAngularVelocity=!1,l.eventsEnabled&&l.dispatchEvent({type:"gripUpdated",data:t,target:this})));o!==null&&(s=e.getPose(t.targetRaySpace,i),s===null&&r!==null&&(s=r),s!==null&&(o.matrix.fromArray(s.transform.matrix),o.matrix.decompose(o.position,o.rotation,o.scale),o.matrixWorldNeedsUpdate=!0,s.linearVelocity?(o.hasLinearVelocity=!0,o.linearVelocity.copy(s.linearVelocity)):o.hasLinearVelocity=!1,s.angularVelocity?(o.hasAngularVelocity=!0,o.angularVelocity.copy(s.angularVelocity)):o.hasAngularVelocity=!1,this.dispatchEvent(Up)))}return o!==null&&(o.visible=s!==null),l!==null&&(l.visible=r!==null),c!==null&&(c.visible=a!==null),this}_getHandJoint(t,e){if(t.joints[e.jointName]===void 0){let i=new fe;i.matrixAutoUpdate=!1,i.visible=!1,t.joints[e.jointName]=i,t.add(i)}return t.joints[e.jointName]}},Pd={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074},Mn={h:0,s:0,l:0},Pa={h:0,s:0,l:0};function wc(n,t,e){return e<0&&(e+=1),e>1&&(e-=1),e<1/6?n+(t-n)*6*e:e<1/2?t:e<2/3?n+(t-n)*6*(2/3-e):n}var Ut=class{constructor(t,e,i){return this.isColor=!0,this.r=1,this.g=1,this.b=1,this.set(t,e,i)}set(t,e,i){if(e===void 0&&i===void 0){let s=t;s&&s.isColor?this.copy(s):typeof s=="number"?this.setHex(s):typeof s=="string"&&this.setStyle(s)}else this.setRGB(t,e,i);return this}setScalar(t){return this.r=t,this.g=t,this.b=t,this}setHex(t,e=Ee){return t=Math.floor(t),this.r=(t>>16&255)/255,this.g=(t>>8&255)/255,this.b=(t&255)/255,Qt.colorSpaceToWorking(this,e),this}setRGB(t,e,i,s=Qt.workingColorSpace){return this.r=t,this.g=e,this.b=i,Qt.colorSpaceToWorking(this,s),this}setHSL(t,e,i,s=Qt.workingColorSpace){if(t=dh(t,1),e=te(e,0,1),i=te(i,0,1),e===0)this.r=this.g=this.b=i;else{let r=i<=.5?i*(1+e):i+e-i*e,a=2*i-r;this.r=wc(a,r,t+1/3),this.g=wc(a,r,t),this.b=wc(a,r,t-1/3)}return Qt.colorSpaceToWorking(this,s),this}setStyle(t,e=Ee){function i(r){r!==void 0&&parseFloat(r)<1&&kt("Color: Alpha component of "+t+" will be ignored.")}let s;if(s=/^(\w+)\(([^\)]*)\)/.exec(t)){let r,a=s[1],o=s[2];switch(a){case"rgb":case"rgba":if(r=/^\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setRGB(Math.min(255,parseInt(r[1],10))/255,Math.min(255,parseInt(r[2],10))/255,Math.min(255,parseInt(r[3],10))/255,e);if(r=/^\s*(\d+)\%\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setRGB(Math.min(100,parseInt(r[1],10))/100,Math.min(100,parseInt(r[2],10))/100,Math.min(100,parseInt(r[3],10))/100,e);break;case"hsl":case"hsla":if(r=/^\s*(\d*\.?\d+)\s*,\s*(\d*\.?\d+)\%\s*,\s*(\d*\.?\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(r[4]),this.setHSL(parseFloat(r[1])/360,parseFloat(r[2])/100,parseFloat(r[3])/100,e);break;default:kt("Color: Unknown color model "+t)}}else if(s=/^\#([A-Fa-f\d]+)$/.exec(t)){let r=s[1],a=r.length;if(a===3)return this.setRGB(parseInt(r.charAt(0),16)/15,parseInt(r.charAt(1),16)/15,parseInt(r.charAt(2),16)/15,e);if(a===6)return this.setHex(parseInt(r,16),e);kt("Color: Invalid hex color "+t)}else if(t&&t.length>0)return this.setColorName(t,e);return this}setColorName(t,e=Ee){let i=Pd[t.toLowerCase()];return i!==void 0?this.setHex(i,e):kt("Color: Unknown color "+t),this}clone(){return new this.constructor(this.r,this.g,this.b)}copy(t){return this.r=t.r,this.g=t.g,this.b=t.b,this}copySRGBToLinear(t){return this.r=cn(t.r),this.g=cn(t.g),this.b=cn(t.b),this}copyLinearToSRGB(t){return this.r=Rs(t.r),this.g=Rs(t.g),this.b=Rs(t.b),this}convertSRGBToLinear(){return this.copySRGBToLinear(this),this}convertLinearToSRGB(){return this.copyLinearToSRGB(this),this}getHex(t=Ee){return Qt.workingToColorSpace(je.copy(this),t),Math.round(te(je.r*255,0,255))*65536+Math.round(te(je.g*255,0,255))*256+Math.round(te(je.b*255,0,255))}getHexString(t=Ee){return("000000"+this.getHex(t).toString(16)).slice(-6)}getHSL(t,e=Qt.workingColorSpace){Qt.workingToColorSpace(je.copy(this),e);let i=je.r,s=je.g,r=je.b,a=Math.max(i,s,r),o=Math.min(i,s,r),l,c,h=(o+a)/2;if(o===a)l=0,c=0;else{let d=a-o;switch(c=h<=.5?d/(a+o):d/(2-a-o),a){case i:l=(s-r)/d+(s<r?6:0);break;case s:l=(r-i)/d+2;break;case r:l=(i-s)/d+4;break}l/=6}return t.h=l,t.s=c,t.l=h,t}getRGB(t,e=Qt.workingColorSpace){return Qt.workingToColorSpace(je.copy(this),e),t.r=je.r,t.g=je.g,t.b=je.b,t}getStyle(t=Ee){Qt.workingToColorSpace(je.copy(this),t);let e=je.r,i=je.g,s=je.b;return t!==Ee?`color(${t} ${e.toFixed(3)} ${i.toFixed(3)} ${s.toFixed(3)})`:`rgb(${Math.round(e*255)},${Math.round(i*255)},${Math.round(s*255)})`}offsetHSL(t,e,i){return this.getHSL(Mn),this.setHSL(Mn.h+t,Mn.s+e,Mn.l+i)}add(t){return this.r+=t.r,this.g+=t.g,this.b+=t.b,this}addColors(t,e){return this.r=t.r+e.r,this.g=t.g+e.g,this.b=t.b+e.b,this}addScalar(t){return this.r+=t,this.g+=t,this.b+=t,this}sub(t){return this.r=Math.max(0,this.r-t.r),this.g=Math.max(0,this.g-t.g),this.b=Math.max(0,this.b-t.b),this}multiply(t){return this.r*=t.r,this.g*=t.g,this.b*=t.b,this}multiplyScalar(t){return this.r*=t,this.g*=t,this.b*=t,this}lerp(t,e){return this.r+=(t.r-this.r)*e,this.g+=(t.g-this.g)*e,this.b+=(t.b-this.b)*e,this}lerpColors(t,e,i){return this.r=t.r+(e.r-t.r)*i,this.g=t.g+(e.g-t.g)*i,this.b=t.b+(e.b-t.b)*i,this}lerpHSL(t,e){this.getHSL(Mn),t.getHSL(Pa);let i=br(Mn.h,Pa.h,e),s=br(Mn.s,Pa.s,e),r=br(Mn.l,Pa.l,e);return this.setHSL(i,s,r),this}setFromVector3(t){return this.r=t.x,this.g=t.y,this.b=t.z,this}applyMatrix3(t){let e=this.r,i=this.g,s=this.b,r=t.elements;return this.r=r[0]*e+r[3]*i+r[6]*s,this.g=r[1]*e+r[4]*i+r[7]*s,this.b=r[2]*e+r[5]*i+r[8]*s,this}equals(t){return t.r===this.r&&t.g===this.g&&t.b===this.b}fromArray(t,e=0){return this.r=t[e],this.g=t[e+1],this.b=t[e+2],this}toArray(t=[],e=0){return t[e]=this.r,t[e+1]=this.g,t[e+2]=this.b,t}fromBufferAttribute(t,e){return this.r=t.getX(e),this.g=t.getY(e),this.b=t.getZ(e),this}toJSON(){return this.getHex()}*[Symbol.iterator](){yield this.r,yield this.g,yield this.b}},je=new Ut;Ut.NAMES=Pd;var Cr=class n{constructor(t,e=25e-5){this.isFogExp2=!0,this.name="",this.color=new Ut(t),this.density=e}clone(){return new n(this.color,this.density)}toJSON(){return{type:"FogExp2",name:this.name,color:this.color.getHex(),density:this.density}}};var En=class extends Pe{constructor(){super(),this.isScene=!0,this.type="Scene",this.background=null,this.environment=null,this.fog=null,this.backgroundBlurriness=0,this.backgroundIntensity=1,this.backgroundRotation=new _i,this.environmentIntensity=1,this.environmentRotation=new _i,this.overrideMaterial=null,typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}copy(t,e){return super.copy(t,e),t.background!==null&&(this.background=t.background.clone()),t.environment!==null&&(this.environment=t.environment.clone()),t.fog!==null&&(this.fog=t.fog.clone()),this.backgroundBlurriness=t.backgroundBlurriness,this.backgroundIntensity=t.backgroundIntensity,this.backgroundRotation.copy(t.backgroundRotation),this.environmentIntensity=t.environmentIntensity,this.environmentRotation.copy(t.environmentRotation),t.overrideMaterial!==null&&(this.overrideMaterial=t.overrideMaterial.clone()),this.matrixAutoUpdate=t.matrixAutoUpdate,this}toJSON(t){let e=super.toJSON(t);return this.fog!==null&&(e.object.fog=this.fog.toJSON()),e.object.backgroundBlurriness=this.backgroundBlurriness,e.object.backgroundIntensity=this.backgroundIntensity,e.object.backgroundRotation=this.backgroundRotation.toArray(),e.object.environmentIntensity=this.environmentIntensity,e.object.environmentRotation=this.environmentRotation.toArray(),e}},Ii=new N,nn=new N,Tc=new N,sn=new N,ps=new N,ms=new N,Eu=new N,Ec=new N,Ac=new N,Rc=new N,Cc=new Ae,Ic=new Ae,Pc=new Ae,on=class n{constructor(t=new N,e=new N,i=new N){this.a=t,this.b=e,this.c=i}static getNormal(t,e,i,s){s.subVectors(i,e),Ii.subVectors(t,e),s.cross(Ii);let r=s.lengthSq();return r>0?s.multiplyScalar(1/Math.sqrt(r)):s.set(0,0,0)}static getBarycoord(t,e,i,s,r){Ii.subVectors(s,e),nn.subVectors(i,e),Tc.subVectors(t,e);let a=Ii.dot(Ii),o=Ii.dot(nn),l=Ii.dot(Tc),c=nn.dot(nn),h=nn.dot(Tc),d=a*c-o*o;if(d===0)return r.set(0,0,0),null;let u=1/d,f=(c*l-o*h)*u,g=(a*h-o*l)*u;return r.set(1-f-g,g,f)}static containsPoint(t,e,i,s){return this.getBarycoord(t,e,i,s,sn)===null?!1:sn.x>=0&&sn.y>=0&&sn.x+sn.y<=1}static getInterpolation(t,e,i,s,r,a,o,l){return this.getBarycoord(t,e,i,s,sn)===null?(l.x=0,l.y=0,"z"in l&&(l.z=0),"w"in l&&(l.w=0),null):(l.setScalar(0),l.addScaledVector(r,sn.x),l.addScaledVector(a,sn.y),l.addScaledVector(o,sn.z),l)}static getInterpolatedAttribute(t,e,i,s,r,a){return Cc.setScalar(0),Ic.setScalar(0),Pc.setScalar(0),Cc.fromBufferAttribute(t,e),Ic.fromBufferAttribute(t,i),Pc.fromBufferAttribute(t,s),a.setScalar(0),a.addScaledVector(Cc,r.x),a.addScaledVector(Ic,r.y),a.addScaledVector(Pc,r.z),a}static isFrontFacing(t,e,i,s){return Ii.subVectors(i,e),nn.subVectors(t,e),Ii.cross(nn).dot(s)<0}set(t,e,i){return this.a.copy(t),this.b.copy(e),this.c.copy(i),this}setFromPointsAndIndices(t,e,i,s){return this.a.copy(t[e]),this.b.copy(t[i]),this.c.copy(t[s]),this}setFromAttributeAndIndices(t,e,i,s){return this.a.fromBufferAttribute(t,e),this.b.fromBufferAttribute(t,i),this.c.fromBufferAttribute(t,s),this}clone(){return new this.constructor().copy(this)}copy(t){return this.a.copy(t.a),this.b.copy(t.b),this.c.copy(t.c),this}getArea(){return Ii.subVectors(this.c,this.b),nn.subVectors(this.a,this.b),Ii.cross(nn).length()*.5}getMidpoint(t){return t.addVectors(this.a,this.b).add(this.c).multiplyScalar(1/3)}getNormal(t){return n.getNormal(this.a,this.b,this.c,t)}getPlane(t){return t.setFromCoplanarPoints(this.a,this.b,this.c)}getBarycoord(t,e){return n.getBarycoord(t,this.a,this.b,this.c,e)}getInterpolation(t,e,i,s,r){return n.getInterpolation(t,this.a,this.b,this.c,e,i,s,r)}containsPoint(t){return n.containsPoint(t,this.a,this.b,this.c)}isFrontFacing(t){return n.isFrontFacing(this.a,this.b,this.c,t)}intersectsBox(t){return t.intersectsTriangle(this)}closestPointToPoint(t,e){let i=this.a,s=this.b,r=this.c,a,o;ps.subVectors(s,i),ms.subVectors(r,i),Ec.subVectors(t,i);let l=ps.dot(Ec),c=ms.dot(Ec);if(l<=0&&c<=0)return e.copy(i);Ac.subVectors(t,s);let h=ps.dot(Ac),d=ms.dot(Ac);if(h>=0&&d<=h)return e.copy(s);let u=l*d-h*c;if(u<=0&&l>=0&&h<=0)return a=l/(l-h),e.copy(i).addScaledVector(ps,a);Rc.subVectors(t,r);let f=ps.dot(Rc),g=ms.dot(Rc);if(g>=0&&f<=g)return e.copy(r);let _=f*c-l*g;if(_<=0&&c>=0&&g<=0)return o=c/(c-g),e.copy(i).addScaledVector(ms,o);let m=h*g-f*d;if(m<=0&&d-h>=0&&f-g>=0)return Eu.subVectors(r,s),o=(d-h)/(d-h+(f-g)),e.copy(s).addScaledVector(Eu,o);let p=1/(m+_+u);return a=_*p,o=u*p,e.copy(i).addScaledVector(ps,a).addScaledVector(ms,o)}equals(t){return t.a.equals(this.a)&&t.b.equals(this.b)&&t.c.equals(this.c)}},Xi=class{constructor(t=new N(1/0,1/0,1/0),e=new N(-1/0,-1/0,-1/0)){this.isBox3=!0,this.min=t,this.max=e}set(t,e){return this.min.copy(t),this.max.copy(e),this}setFromArray(t){this.makeEmpty();for(let e=0,i=t.length;e<i;e+=3)this.expandByPoint(Pi.fromArray(t,e));return this}setFromBufferAttribute(t){this.makeEmpty();for(let e=0,i=t.count;e<i;e++)this.expandByPoint(Pi.fromBufferAttribute(t,e));return this}setFromPoints(t){this.makeEmpty();for(let e=0,i=t.length;e<i;e++)this.expandByPoint(t[e]);return this}setFromCenterAndSize(t,e){let i=Pi.copy(e).multiplyScalar(.5);return this.min.copy(t).sub(i),this.max.copy(t).add(i),this}setFromObject(t,e=!1){return this.makeEmpty(),this.expandByObject(t,e)}clone(){return new this.constructor().copy(this)}copy(t){return this.min.copy(t.min),this.max.copy(t.max),this}makeEmpty(){return this.min.x=this.min.y=this.min.z=1/0,this.max.x=this.max.y=this.max.z=-1/0,this}isEmpty(){return this.max.x<this.min.x||this.max.y<this.min.y||this.max.z<this.min.z}getCenter(t){return this.isEmpty()?t.set(0,0,0):t.addVectors(this.min,this.max).multiplyScalar(.5)}getSize(t){return this.isEmpty()?t.set(0,0,0):t.subVectors(this.max,this.min)}expandByPoint(t){return this.min.min(t),this.max.max(t),this}expandByVector(t){return this.min.sub(t),this.max.add(t),this}expandByScalar(t){return this.min.addScalar(-t),this.max.addScalar(t),this}expandByObject(t,e=!1){t.updateWorldMatrix(!1,!1);let i=t.geometry;if(i!==void 0){let r=i.getAttribute("position");if(e===!0&&r!==void 0&&t.isInstancedMesh!==!0)for(let a=0,o=r.count;a<o;a++)t.isMesh===!0?t.getVertexPosition(a,Pi):Pi.fromBufferAttribute(r,a),Pi.applyMatrix4(t.matrixWorld),this.expandByPoint(Pi);else t.boundingBox!==void 0?(t.boundingBox===null&&t.computeBoundingBox(),La.copy(t.boundingBox)):(i.boundingBox===null&&i.computeBoundingBox(),La.copy(i.boundingBox)),La.applyMatrix4(t.matrixWorld),this.union(La)}let s=t.children;for(let r=0,a=s.length;r<a;r++)this.expandByObject(s[r],e);return this}containsPoint(t){return t.x>=this.min.x&&t.x<=this.max.x&&t.y>=this.min.y&&t.y<=this.max.y&&t.z>=this.min.z&&t.z<=this.max.z}containsBox(t){return this.min.x<=t.min.x&&t.max.x<=this.max.x&&this.min.y<=t.min.y&&t.max.y<=this.max.y&&this.min.z<=t.min.z&&t.max.z<=this.max.z}getParameter(t,e){return e.set((t.x-this.min.x)/(this.max.x-this.min.x),(t.y-this.min.y)/(this.max.y-this.min.y),(t.z-this.min.z)/(this.max.z-this.min.z))}intersectsBox(t){return t.max.x>=this.min.x&&t.min.x<=this.max.x&&t.max.y>=this.min.y&&t.min.y<=this.max.y&&t.max.z>=this.min.z&&t.min.z<=this.max.z}intersectsSphere(t){return this.clampPoint(t.center,Pi),Pi.distanceToSquared(t.center)<=t.radius*t.radius}intersectsPlane(t){let e,i;return t.normal.x>0?(e=t.normal.x*this.min.x,i=t.normal.x*this.max.x):(e=t.normal.x*this.max.x,i=t.normal.x*this.min.x),t.normal.y>0?(e+=t.normal.y*this.min.y,i+=t.normal.y*this.max.y):(e+=t.normal.y*this.max.y,i+=t.normal.y*this.min.y),t.normal.z>0?(e+=t.normal.z*this.min.z,i+=t.normal.z*this.max.z):(e+=t.normal.z*this.max.z,i+=t.normal.z*this.min.z),e<=-t.constant&&i>=-t.constant}intersectsTriangle(t){if(this.isEmpty())return!1;this.getCenter(dr),Da.subVectors(this.max,dr),gs.subVectors(t.a,dr),xs.subVectors(t.b,dr),_s.subVectors(t.c,dr),bn.subVectors(xs,gs),Sn.subVectors(_s,xs),Wn.subVectors(gs,_s);let e=[0,-bn.z,bn.y,0,-Sn.z,Sn.y,0,-Wn.z,Wn.y,bn.z,0,-bn.x,Sn.z,0,-Sn.x,Wn.z,0,-Wn.x,-bn.y,bn.x,0,-Sn.y,Sn.x,0,-Wn.y,Wn.x,0];return!Lc(e,gs,xs,_s,Da)||(e=[1,0,0,0,1,0,0,0,1],!Lc(e,gs,xs,_s,Da))?!1:(Na.crossVectors(bn,Sn),e=[Na.x,Na.y,Na.z],Lc(e,gs,xs,_s,Da))}clampPoint(t,e){return e.copy(t).clamp(this.min,this.max)}distanceToPoint(t){return this.clampPoint(t,Pi).distanceTo(t)}getBoundingSphere(t){return this.isEmpty()?t.makeEmpty():(this.getCenter(t.center),t.radius=this.getSize(Pi).length()*.5),t}intersect(t){return this.min.max(t.min),this.max.min(t.max),this.isEmpty()&&this.makeEmpty(),this}union(t){return this.min.min(t.min),this.max.max(t.max),this}applyMatrix4(t){return this.isEmpty()?this:(rn[0].set(this.min.x,this.min.y,this.min.z).applyMatrix4(t),rn[1].set(this.min.x,this.min.y,this.max.z).applyMatrix4(t),rn[2].set(this.min.x,this.max.y,this.min.z).applyMatrix4(t),rn[3].set(this.min.x,this.max.y,this.max.z).applyMatrix4(t),rn[4].set(this.max.x,this.min.y,this.min.z).applyMatrix4(t),rn[5].set(this.max.x,this.min.y,this.max.z).applyMatrix4(t),rn[6].set(this.max.x,this.max.y,this.min.z).applyMatrix4(t),rn[7].set(this.max.x,this.max.y,this.max.z).applyMatrix4(t),this.setFromPoints(rn),this)}translate(t){return this.min.add(t),this.max.add(t),this}equals(t){return t.min.equals(this.min)&&t.max.equals(this.max)}toJSON(){return{min:this.min.toArray(),max:this.max.toArray()}}fromJSON(t){return this.min.fromArray(t.min),this.max.fromArray(t.max),this}},rn=[new N,new N,new N,new N,new N,new N,new N,new N],Pi=new N,La=new Xi,gs=new N,xs=new N,_s=new N,bn=new N,Sn=new N,Wn=new N,dr=new N,Da=new N,Na=new N,Xn=new N;function Lc(n,t,e,i,s){for(let r=0,a=n.length-3;r<=a;r+=3){Xn.fromArray(n,r);let o=s.x*Math.abs(Xn.x)+s.y*Math.abs(Xn.y)+s.z*Math.abs(Xn.z),l=t.dot(Xn),c=e.dot(Xn),h=i.dot(Xn);if(Math.max(-Math.max(l,c,h),Math.min(l,c,h))>o)return!1}return!0}var Fe=new N,Ua=new xt,Fp=0,ze=class extends Wi{constructor(t,e,i=!1){if(super(),Array.isArray(t))throw new TypeError("THREE.BufferAttribute: array should be a Typed Array.");this.isBufferAttribute=!0,Object.defineProperty(this,"id",{value:Fp++}),this.name="",this.array=t,this.itemSize=e,this.count=t!==void 0?t.length/e:0,this.normalized=i,this.usage=hh,this.updateRanges=[],this.gpuType=bi,this.version=0}onUploadCallback(){}set needsUpdate(t){t===!0&&this.version++}setUsage(t){return this.usage=t,this}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}copy(t){return this.name=t.name,this.array=new t.array.constructor(t.array),this.itemSize=t.itemSize,this.count=t.count,this.normalized=t.normalized,this.usage=t.usage,this.gpuType=t.gpuType,this}copyAt(t,e,i){t*=this.itemSize,i*=e.itemSize;for(let s=0,r=this.itemSize;s<r;s++)this.array[t+s]=e.array[i+s];return this}copyArray(t){return this.array.set(t),this}applyMatrix3(t){if(this.itemSize===2)for(let e=0,i=this.count;e<i;e++)Ua.fromBufferAttribute(this,e),Ua.applyMatrix3(t),this.setXY(e,Ua.x,Ua.y);else if(this.itemSize===3)for(let e=0,i=this.count;e<i;e++)Fe.fromBufferAttribute(this,e),Fe.applyMatrix3(t),this.setXYZ(e,Fe.x,Fe.y,Fe.z);return this}applyMatrix4(t){for(let e=0,i=this.count;e<i;e++)Fe.fromBufferAttribute(this,e),Fe.applyMatrix4(t),this.setXYZ(e,Fe.x,Fe.y,Fe.z);return this}applyNormalMatrix(t){for(let e=0,i=this.count;e<i;e++)Fe.fromBufferAttribute(this,e),Fe.applyNormalMatrix(t),this.setXYZ(e,Fe.x,Fe.y,Fe.z);return this}transformDirection(t){for(let e=0,i=this.count;e<i;e++)Fe.fromBufferAttribute(this,e),Fe.transformDirection(t),this.setXYZ(e,Fe.x,Fe.y,Fe.z);return this}set(t,e=0){return this.array.set(t,e),this}getComponent(t,e){let i=this.array[t*this.itemSize+e];return this.normalized&&(i=Li(i,this.array)),i}setComponent(t,e,i){return this.normalized&&(i=me(i,this.array)),this.array[t*this.itemSize+e]=i,this}getX(t){let e=this.array[t*this.itemSize];return this.normalized&&(e=Li(e,this.array)),e}setX(t,e){return this.normalized&&(e=me(e,this.array)),this.array[t*this.itemSize]=e,this}getY(t){let e=this.array[t*this.itemSize+1];return this.normalized&&(e=Li(e,this.array)),e}setY(t,e){return this.normalized&&(e=me(e,this.array)),this.array[t*this.itemSize+1]=e,this}getZ(t){let e=this.array[t*this.itemSize+2];return this.normalized&&(e=Li(e,this.array)),e}setZ(t,e){return this.normalized&&(e=me(e,this.array)),this.array[t*this.itemSize+2]=e,this}getW(t){let e=this.array[t*this.itemSize+3];return this.normalized&&(e=Li(e,this.array)),e}setW(t,e){return this.normalized&&(e=me(e,this.array)),this.array[t*this.itemSize+3]=e,this}setXY(t,e,i){return t*=this.itemSize,this.normalized&&(e=me(e,this.array),i=me(i,this.array)),this.array[t+0]=e,this.array[t+1]=i,this}setXYZ(t,e,i,s){return t*=this.itemSize,this.normalized&&(e=me(e,this.array),i=me(i,this.array),s=me(s,this.array)),this.array[t+0]=e,this.array[t+1]=i,this.array[t+2]=s,this}setXYZW(t,e,i,s,r){return t*=this.itemSize,this.normalized&&(e=me(e,this.array),i=me(i,this.array),s=me(s,this.array),r=me(r,this.array)),this.array[t+0]=e,this.array[t+1]=i,this.array[t+2]=s,this.array[t+3]=r,this}onUpload(t){return this.onUploadCallback=t,this}clone(){return new this.constructor(this.array,this.itemSize).copy(this)}toJSON(){let t={itemSize:this.itemSize,type:this.array.constructor.name,array:Array.from(this.array),normalized:this.normalized};return t.name=this.name,t.usage=this.usage,t.gpuType=this.gpuType,t}dispose(){this.dispatchEvent({type:"dispose"})}};var Ir=class extends ze{constructor(t,e,i){super(new Uint16Array(t),e,i)}};var Pr=class extends ze{constructor(t,e,i){super(new Uint32Array(t),e,i)}};var Gt=class extends ze{constructor(t,e,i){super(new Float32Array(t),e,i)}},zp=new Xi,fr=new N,Dc=new N,vi=class{constructor(t=new N,e=-1){this.isSphere=!0,this.center=t,this.radius=e}set(t,e){return this.center.copy(t),this.radius=e,this}setFromPoints(t,e){let i=this.center;e!==void 0?i.copy(e):zp.setFromPoints(t).getCenter(i);let s=0;for(let r=0,a=t.length;r<a;r++)s=Math.max(s,i.distanceToSquared(t[r]));return this.radius=Math.sqrt(s),this}copy(t){return this.center.copy(t.center),this.radius=t.radius,this}isEmpty(){return this.radius<0}makeEmpty(){return this.center.set(0,0,0),this.radius=-1,this}containsPoint(t){return t.distanceToSquared(this.center)<=this.radius*this.radius}distanceToPoint(t){return t.distanceTo(this.center)-this.radius}intersectsSphere(t){let e=this.radius+t.radius;return t.center.distanceToSquared(this.center)<=e*e}intersectsBox(t){return t.intersectsSphere(this)}intersectsPlane(t){return Math.abs(t.distanceToPoint(this.center))<=this.radius}clampPoint(t,e){let i=this.center.distanceToSquared(t);return e.copy(t),i>this.radius*this.radius&&(e.sub(this.center).normalize(),e.multiplyScalar(this.radius).add(this.center)),e}getBoundingBox(t){return this.isEmpty()?(t.makeEmpty(),t):(t.set(this.center,this.center),t.expandByScalar(this.radius),t)}applyMatrix4(t){return this.center.applyMatrix4(t),this.radius=this.radius*t.getMaxScaleOnAxis(),this}translate(t){return this.center.add(t),this}expandByPoint(t){if(this.isEmpty())return this.center.copy(t),this.radius=0,this;fr.subVectors(t,this.center);let e=fr.lengthSq();if(e>this.radius*this.radius){let i=Math.sqrt(e),s=(i-this.radius)*.5;this.center.addScaledVector(fr,s/i),this.radius+=s}return this}union(t){return t.isEmpty()?this:this.isEmpty()?(this.copy(t),this):(this.center.equals(t.center)===!0?this.radius=Math.max(this.radius,t.radius):(Dc.subVectors(t.center,this.center).setLength(t.radius),this.expandByPoint(fr.copy(t.center).add(Dc)),this.expandByPoint(fr.copy(t.center).sub(Dc))),this)}equals(t){return t.center.equals(this.center)&&t.radius===this.radius}clone(){return new this.constructor().copy(this)}toJSON(){return{radius:this.radius,center:this.center.toArray()}}fromJSON(t){return this.radius=t.radius,this.center.fromArray(t.center),this}},Bp=0,gi=new oe,Nc=new Pe,vs=new N,hi=new Xi,pr=new Xi,Xe=new N,ce=class n extends Wi{constructor(){super(),this.isBufferGeometry=!0,Object.defineProperty(this,"id",{value:Bp++}),this.uuid=ln(),this.name="",this.type="BufferGeometry",this.index=null,this.indirect=null,this.indirectOffset=0,this.attributes={},this.morphAttributes={},this.morphTargetsRelative=!1,this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.drawRange={start:0,count:1/0},this.userData={},this._transformed=!1}getIndex(){return this.index}setIndex(t){return Array.isArray(t)?this.index=new(lp(t)?Pr:Ir)(t,1):this.index=t,this}setIndirect(t,e=0){return this.indirect=t,this.indirectOffset=e,this}getIndirect(){return this.indirect}getAttribute(t){return this.attributes[t]}setAttribute(t,e){return this.attributes[t]=e,this}deleteAttribute(t){return delete this.attributes[t],this}hasAttribute(t){return this.attributes[t]!==void 0}addGroup(t,e,i=0){this.groups.push({start:t,count:e,materialIndex:i})}clearGroups(){this.groups=[]}setDrawRange(t,e){this.drawRange.start=t,this.drawRange.count=e}applyMatrix4(t){let e=this.attributes.position;e!==void 0&&(e.applyMatrix4(t),e.needsUpdate=!0);let i=this.attributes.normal;if(i!==void 0){let r=new Xt().getNormalMatrix(t);i.applyNormalMatrix(r),i.needsUpdate=!0}let s=this.attributes.tangent;return s!==void 0&&(s.transformDirection(t),s.needsUpdate=!0),this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this._transformed=!0,this}applyQuaternion(t){return gi.makeRotationFromQuaternion(t),this.applyMatrix4(gi),this}rotateX(t){return gi.makeRotationX(t),this.applyMatrix4(gi),this}rotateY(t){return gi.makeRotationY(t),this.applyMatrix4(gi),this}rotateZ(t){return gi.makeRotationZ(t),this.applyMatrix4(gi),this}translate(t,e,i){return gi.makeTranslation(t,e,i),this.applyMatrix4(gi),this}scale(t,e,i){return gi.makeScale(t,e,i),this.applyMatrix4(gi),this}lookAt(t){return Nc.lookAt(t),Nc.updateMatrix(),this.applyMatrix4(Nc.matrix),this}center(){return this.computeBoundingBox(),this.boundingBox.getCenter(vs).negate(),this.translate(vs.x,vs.y,vs.z),this}setFromPoints(t){let e=this.getAttribute("position");if(e===void 0){let i=[];for(let s=0,r=t.length;s<r;s++){let a=t[s];i.push(a.x,a.y,a.z||0)}this.setAttribute("position",new Gt(i,3))}else{let i=Math.min(t.length,e.count);for(let s=0;s<i;s++){let r=t[s];e.setXYZ(s,r.x,r.y,r.z||0)}t.length>e.count&&kt("BufferGeometry: Buffer size too small for points data. Use .dispose() and create a new geometry."),e.needsUpdate=!0}return this}computeBoundingBox(){this.boundingBox===null&&(this.boundingBox=new Xi);let t=this.attributes.position,e=this.morphAttributes.position;if(t&&t.isGLBufferAttribute){Ht("BufferGeometry.computeBoundingBox(): GLBufferAttribute requires a manual bounding box.",this),this.boundingBox.set(new N(-1/0,-1/0,-1/0),new N(1/0,1/0,1/0));return}if(t!==void 0){if(this.boundingBox.setFromBufferAttribute(t),e)for(let i=0,s=e.length;i<s;i++){let r=e[i];hi.setFromBufferAttribute(r),this.morphTargetsRelative?(Xe.addVectors(this.boundingBox.min,hi.min),this.boundingBox.expandByPoint(Xe),Xe.addVectors(this.boundingBox.max,hi.max),this.boundingBox.expandByPoint(Xe)):(this.boundingBox.expandByPoint(hi.min),this.boundingBox.expandByPoint(hi.max))}}else this.boundingBox.makeEmpty();(isNaN(this.boundingBox.min.x)||isNaN(this.boundingBox.min.y)||isNaN(this.boundingBox.min.z))&&Ht('BufferGeometry.computeBoundingBox(): Computed min/max have NaN values. The "position" attribute is likely to have NaN values.',this)}computeBoundingSphere(){this.boundingSphere===null&&(this.boundingSphere=new vi);let t=this.attributes.position,e=this.morphAttributes.position;if(t&&t.isGLBufferAttribute){Ht("BufferGeometry.computeBoundingSphere(): GLBufferAttribute requires a manual bounding sphere.",this),this.boundingSphere.set(new N,1/0);return}if(t){let i=this.boundingSphere.center;if(hi.setFromBufferAttribute(t),e)for(let r=0,a=e.length;r<a;r++){let o=e[r];pr.setFromBufferAttribute(o),this.morphTargetsRelative?(Xe.addVectors(hi.min,pr.min),hi.expandByPoint(Xe),Xe.addVectors(hi.max,pr.max),hi.expandByPoint(Xe)):(hi.expandByPoint(pr.min),hi.expandByPoint(pr.max))}hi.getCenter(i);let s=0;for(let r=0,a=t.count;r<a;r++)Xe.fromBufferAttribute(t,r),s=Math.max(s,i.distanceToSquared(Xe));if(e)for(let r=0,a=e.length;r<a;r++){let o=e[r],l=this.morphTargetsRelative;for(let c=0,h=o.count;c<h;c++)Xe.fromBufferAttribute(o,c),l&&(vs.fromBufferAttribute(t,c),Xe.add(vs)),s=Math.max(s,i.distanceToSquared(Xe))}this.boundingSphere.radius=Math.sqrt(s),isNaN(this.boundingSphere.radius)&&Ht('BufferGeometry.computeBoundingSphere(): Computed radius is NaN. The "position" attribute is likely to have NaN values.',this)}}computeTangents(){let t=this.index,e=this.attributes;if(t===null||e.position===void 0||e.normal===void 0||e.uv===void 0){Ht("BufferGeometry: .computeTangents() failed. Missing required attributes (index, position, normal or uv)");return}let i=e.position,s=e.normal,r=e.uv,a=this.getAttribute("tangent");(a===void 0||a.count!==i.count)&&(a=new ze(new Float32Array(4*i.count),4),this.setAttribute("tangent",a));let o=[],l=[];for(let v=0;v<i.count;v++)o[v]=new N,l[v]=new N;let c=new N,h=new N,d=new N,u=new xt,f=new xt,g=new xt,_=new N,m=new N;function p(v,A,P){c.fromBufferAttribute(i,v),h.fromBufferAttribute(i,A),d.fromBufferAttribute(i,P),u.fromBufferAttribute(r,v),f.fromBufferAttribute(r,A),g.fromBufferAttribute(r,P),h.sub(c),d.sub(c),f.sub(u),g.sub(u);let O=1/(f.x*g.y-g.x*f.y);isFinite(O)&&(_.copy(h).multiplyScalar(g.y).addScaledVector(d,-f.y).multiplyScalar(O),m.copy(d).multiplyScalar(f.x).addScaledVector(h,-g.x).multiplyScalar(O),o[v].add(_),o[A].add(_),o[P].add(_),l[v].add(m),l[A].add(m),l[P].add(m))}let M=this.groups;M.length===0&&(M=[{start:0,count:t.count}]);for(let v=0,A=M.length;v<A;++v){let P=M[v],O=P.start,L=P.count;for(let z=O,D=O+L;z<D;z+=3)p(t.getX(z+0),t.getX(z+1),t.getX(z+2))}let R=new N,y=new N,w=new N,S=new N;function I(v){w.fromBufferAttribute(s,v),S.copy(w);let A=o[v];R.copy(A),R.sub(w.multiplyScalar(w.dot(A))).normalize(),y.crossVectors(S,A);let O=y.dot(l[v])<0?-1:1;a.setXYZW(v,R.x,R.y,R.z,O)}for(let v=0,A=M.length;v<A;++v){let P=M[v],O=P.start,L=P.count;for(let z=O,D=O+L;z<D;z+=3)I(t.getX(z+0)),I(t.getX(z+1)),I(t.getX(z+2))}this._transformed=!0}computeVertexNormals(){let t=this.index,e=this.getAttribute("position");if(e!==void 0){let i=this.getAttribute("normal");if(i===void 0||i.count!==e.count)i=new ze(new Float32Array(e.count*3),3),this.setAttribute("normal",i);else for(let u=0,f=i.count;u<f;u++)i.setXYZ(u,0,0,0);let s=new N,r=new N,a=new N,o=new N,l=new N,c=new N,h=new N,d=new N;if(t)for(let u=0,f=t.count;u<f;u+=3){let g=t.getX(u+0),_=t.getX(u+1),m=t.getX(u+2);s.fromBufferAttribute(e,g),r.fromBufferAttribute(e,_),a.fromBufferAttribute(e,m),h.subVectors(a,r),d.subVectors(s,r),h.cross(d),o.fromBufferAttribute(i,g),l.fromBufferAttribute(i,_),c.fromBufferAttribute(i,m),o.add(h),l.add(h),c.add(h),i.setXYZ(g,o.x,o.y,o.z),i.setXYZ(_,l.x,l.y,l.z),i.setXYZ(m,c.x,c.y,c.z)}else for(let u=0,f=e.count;u<f;u+=3)s.fromBufferAttribute(e,u+0),r.fromBufferAttribute(e,u+1),a.fromBufferAttribute(e,u+2),h.subVectors(a,r),d.subVectors(s,r),h.cross(d),i.setXYZ(u+0,h.x,h.y,h.z),i.setXYZ(u+1,h.x,h.y,h.z),i.setXYZ(u+2,h.x,h.y,h.z);this.normalizeNormals(),i.needsUpdate=!0}}normalizeNormals(){let t=this.attributes.normal;for(let e=0,i=t.count;e<i;e++)Xe.fromBufferAttribute(t,e),Xe.normalize(),t.setXYZ(e,Xe.x,Xe.y,Xe.z)}toNonIndexed(){function t(o,l){let c=o.array,h=o.itemSize,d=o.normalized,u=new c.constructor(l.length*h),f=0,g=0;for(let _=0,m=l.length;_<m;_++){o.isInterleavedBufferAttribute?f=l[_]*o.data.stride+o.offset:f=l[_]*h;for(let p=0;p<h;p++)u[g++]=c[f++]}return new ze(u,h,d)}if(this.index===null)return kt("BufferGeometry.toNonIndexed(): BufferGeometry is already non-indexed."),this;let e=new n,i=this.index.array,s=this.attributes;for(let o in s){let l=s[o],c=t(l,i);e.setAttribute(o,c)}let r=this.morphAttributes;for(let o in r){let l=[],c=r[o];for(let h=0,d=c.length;h<d;h++){let u=c[h],f=t(u,i);l.push(f)}e.morphAttributes[o]=l}e.morphTargetsRelative=this.morphTargetsRelative;let a=this.groups;for(let o=0,l=a.length;o<l;o++){let c=a[o];e.addGroup(c.start,c.count,c.materialIndex)}return e}toJSON(){let t={metadata:{version:4.7,type:"BufferGeometry",generator:"BufferGeometry.toJSON"}};if(t.uuid=this.uuid,t.type=this.parameters!==void 0&&this._transformed===!0?"BufferGeometry":this.type,t.name=this.name,Object.keys(this.userData).length>0&&(t.userData=this.userData),this.parameters!==void 0&&this._transformed!==!0){let l=this.parameters;for(let c in l)l[c]!==void 0&&(t[c]=l[c]);return t}t.data={attributes:{}};let e=this.index;e!==null&&(t.data.index={type:e.array.constructor.name,array:Array.prototype.slice.call(e.array)});let i=this.attributes;for(let l in i){let c=i[l];t.data.attributes[l]=c.toJSON(t.data)}let s={},r=!1;for(let l in this.morphAttributes){let c=this.morphAttributes[l],h=[];for(let d=0,u=c.length;d<u;d++){let f=c[d];h.push(f.toJSON(t.data))}h.length>0&&(s[l]=h,r=!0)}r&&(t.data.morphAttributes=s,t.data.morphTargetsRelative=this.morphTargetsRelative);let a=this.groups;a.length>0&&(t.data.groups=JSON.parse(JSON.stringify(a)));let o=this.boundingSphere;return o!==null&&(t.data.boundingSphere=o.toJSON()),t}clone(){return new this.constructor().copy(this)}copy(t){this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null;let e={};this.name=t.name;let i=t.index;i!==null&&this.setIndex(i.clone());let s=t.attributes;for(let c in s){let h=s[c];this.setAttribute(c,h.clone(e))}let r=t.morphAttributes;for(let c in r){let h=[],d=r[c];for(let u=0,f=d.length;u<f;u++)h.push(d[u].clone(e));this.morphAttributes[c]=h}this.morphTargetsRelative=t.morphTargetsRelative;let a=t.groups;for(let c=0,h=a.length;c<h;c++){let d=a[c];this.addGroup(d.start,d.count,d.materialIndex)}let o=t.boundingBox;o!==null&&(this.boundingBox=o.clone());let l=t.boundingSphere;return l!==null&&(this.boundingSphere=l.clone()),this.drawRange.start=t.drawRange.start,this.drawRange.count=t.drawRange.count,this.userData=t.userData,this._transformed=t._transformed,this}dispose(){this.dispatchEvent({type:"dispose"})}},Lr=class{constructor(t,e){this.isInterleavedBuffer=!0,this.array=t,this.stride=e,this.count=t!==void 0?t.length/e:0,this.usage=hh,this.updateRanges=[],this.version=0,this.uuid=ln()}onUploadCallback(){}set needsUpdate(t){t===!0&&this.version++}setUsage(t){return this.usage=t,this}addUpdateRange(t,e){this.updateRanges.push({start:t,count:e})}clearUpdateRanges(){this.updateRanges.length=0}copy(t){return this.array=new t.array.constructor(t.array),this.count=t.count,this.stride=t.stride,this.usage=t.usage,this}copyAt(t,e,i){t*=this.stride,i*=e.stride;for(let s=0,r=this.stride;s<r;s++)this.array[t+s]=e.array[i+s];return this}set(t,e=0){return this.array.set(t,e),this}clone(t){t.arrayBuffers===void 0&&(t.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=ln()),t.arrayBuffers[this.array.buffer._uuid]===void 0&&(t.arrayBuffers[this.array.buffer._uuid]=this.array.slice(0).buffer);let e=new this.array.constructor(t.arrayBuffers[this.array.buffer._uuid]),i=new this.constructor(e,this.stride);return i.setUsage(this.usage),i}onUpload(t){return this.onUploadCallback=t,this}toJSON(t){t.arrayBuffers===void 0&&(t.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=ln()),t.arrayBuffers[this.array.buffer._uuid]===void 0&&(t.arrayBuffers[this.array.buffer._uuid]=Array.from(new Uint32Array(this.array.buffer)));let e={uuid:this.uuid,buffer:this.array.buffer._uuid,type:this.array.constructor.name,stride:this.stride};return e.usage=this.usage,e}},ri=new N,zs=class n{constructor(t,e,i,s=!1){this.isInterleavedBufferAttribute=!0,this.name="",this.data=t,this.itemSize=e,this.offset=i,this.normalized=s}get count(){return this.data.count}get array(){return this.data.array}set needsUpdate(t){this.data.needsUpdate=t}applyMatrix4(t){for(let e=0,i=this.data.count;e<i;e++)ri.fromBufferAttribute(this,e),ri.applyMatrix4(t),this.setXYZ(e,ri.x,ri.y,ri.z);return this}applyNormalMatrix(t){for(let e=0,i=this.count;e<i;e++)ri.fromBufferAttribute(this,e),ri.applyNormalMatrix(t),this.setXYZ(e,ri.x,ri.y,ri.z);return this}transformDirection(t){for(let e=0,i=this.count;e<i;e++)ri.fromBufferAttribute(this,e),ri.transformDirection(t),this.setXYZ(e,ri.x,ri.y,ri.z);return this}getComponent(t,e){let i=this.array[t*this.data.stride+this.offset+e];return this.normalized&&(i=Li(i,this.array)),i}setComponent(t,e,i){return this.normalized&&(i=me(i,this.array)),this.data.array[t*this.data.stride+this.offset+e]=i,this}setX(t,e){return this.normalized&&(e=me(e,this.array)),this.data.array[t*this.data.stride+this.offset]=e,this}setY(t,e){return this.normalized&&(e=me(e,this.array)),this.data.array[t*this.data.stride+this.offset+1]=e,this}setZ(t,e){return this.normalized&&(e=me(e,this.array)),this.data.array[t*this.data.stride+this.offset+2]=e,this}setW(t,e){return this.normalized&&(e=me(e,this.array)),this.data.array[t*this.data.stride+this.offset+3]=e,this}getX(t){let e=this.data.array[t*this.data.stride+this.offset];return this.normalized&&(e=Li(e,this.array)),e}getY(t){let e=this.data.array[t*this.data.stride+this.offset+1];return this.normalized&&(e=Li(e,this.array)),e}getZ(t){let e=this.data.array[t*this.data.stride+this.offset+2];return this.normalized&&(e=Li(e,this.array)),e}getW(t){let e=this.data.array[t*this.data.stride+this.offset+3];return this.normalized&&(e=Li(e,this.array)),e}setXY(t,e,i){return t=t*this.data.stride+this.offset,this.normalized&&(e=me(e,this.array),i=me(i,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this}setXYZ(t,e,i,s){return t=t*this.data.stride+this.offset,this.normalized&&(e=me(e,this.array),i=me(i,this.array),s=me(s,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this.data.array[t+2]=s,this}setXYZW(t,e,i,s,r){return t=t*this.data.stride+this.offset,this.normalized&&(e=me(e,this.array),i=me(i,this.array),s=me(s,this.array),r=me(r,this.array)),this.data.array[t+0]=e,this.data.array[t+1]=i,this.data.array[t+2]=s,this.data.array[t+3]=r,this}clone(t){if(t===void 0){Ar("InterleavedBufferAttribute.clone(): Cloning an interleaved buffer attribute will de-interleave buffer data.");let e=[];for(let i=0;i<this.count;i++){let s=i*this.data.stride+this.offset;for(let r=0;r<this.itemSize;r++)e.push(this.data.array[s+r])}return new ze(new this.array.constructor(e),this.itemSize,this.normalized)}else return t.interleavedBuffers===void 0&&(t.interleavedBuffers={}),t.interleavedBuffers[this.data.uuid]===void 0&&(t.interleavedBuffers[this.data.uuid]=this.data.clone(t)),new n(t.interleavedBuffers[this.data.uuid],this.itemSize,this.offset,this.normalized)}toJSON(t){if(t===void 0){Ar("InterleavedBufferAttribute.toJSON(): Serializing an interleaved buffer attribute will de-interleave buffer data.");let e=[];for(let i=0;i<this.count;i++){let s=i*this.data.stride+this.offset;for(let r=0;r<this.itemSize;r++)e.push(this.data.array[s+r])}return{itemSize:this.itemSize,type:this.array.constructor.name,array:e,normalized:this.normalized}}else return t.interleavedBuffers===void 0&&(t.interleavedBuffers={}),t.interleavedBuffers[this.data.uuid]===void 0&&(t.interleavedBuffers[this.data.uuid]=this.data.toJSON(t)),{isInterleavedBufferAttribute:!0,itemSize:this.itemSize,data:this.data.uuid,offset:this.offset,normalized:this.normalized}}},Uc=new N,Op=new N,kp=new Xt,ui=class{constructor(t=new N(1,0,0),e=0){this.isPlane=!0,this.normal=t,this.constant=e}set(t,e){return this.normal.copy(t),this.constant=e,this}setComponents(t,e,i,s){return this.normal.set(t,e,i),this.constant=s,this}setFromNormalAndCoplanarPoint(t,e){return this.normal.copy(t),this.constant=-e.dot(this.normal),this}setFromCoplanarPoints(t,e,i){let s=Uc.subVectors(i,e).cross(Op.subVectors(t,e)).normalize();return this.setFromNormalAndCoplanarPoint(s,t),this}copy(t){return this.normal.copy(t.normal),this.constant=t.constant,this}normalize(){let t=1/this.normal.length();return this.normal.multiplyScalar(t),this.constant*=t,this}negate(){return this.constant*=-1,this.normal.negate(),this}distanceToPoint(t){return this.normal.dot(t)+this.constant}distanceToSphere(t){return this.distanceToPoint(t.center)-t.radius}projectPoint(t,e){return e.copy(t).addScaledVector(this.normal,-this.distanceToPoint(t))}intersectLine(t,e,i=!0){let s=t.delta(Uc),r=this.normal.dot(s);if(r===0)return this.distanceToPoint(t.start)===0?e.copy(t.start):null;let a=-(t.start.dot(this.normal)+this.constant)/r;return i===!0&&(a<0||a>1)?null:e.copy(t.start).addScaledVector(s,a)}intersectsLine(t){let e=this.distanceToPoint(t.start),i=this.distanceToPoint(t.end);return e<0&&i>0||i<0&&e>0}intersectsBox(t){return t.intersectsPlane(this)}intersectsSphere(t){return t.intersectsPlane(this)}coplanarPoint(t){return t.copy(this.normal).multiplyScalar(-this.constant)}applyMatrix4(t,e){let i=e||kp.getNormalMatrix(t),s=this.coplanarPoint(Uc).applyMatrix4(t),r=this.normal.applyMatrix3(i).normalize();return this.constant=-s.dot(r),this}translate(t){return this.constant-=t.dot(this.normal),this}equals(t){return t.normal.equals(this.normal)&&t.constant===this.constant}clone(){return new this.constructor().copy(this)}toJSON(){return{normal:this.normal.toArray(),constant:this.constant}}fromJSON(t){return this.normal.fromArray(t.normal),this.constant=t.constant,this}},Hp=0,yi=class extends Wi{constructor(){super(),this.isMaterial=!0,Object.defineProperty(this,"id",{value:Hp++}),this.uuid=ln(),this.name="",this.type="Material",this.blending=Nn,this.side=Dn,this.vertexColors=!1,this.opacity=1,this.transparent=!1,this.alphaHash=!1,this.blendSrc=eh,this.blendDst=ih,this.blendEquation=jn,this.blendSrcAlpha=null,this.blendDstAlpha=null,this.blendEquationAlpha=null,this.blendColor=new Ut(0,0,0),this.blendAlpha=0,this.depthFunc=Cs,this.depthTest=!0,this.depthWrite=!0,this.stencilWriteMask=255,this.stencilFunc=yd,this.stencilRef=0,this.stencilFuncMask=255,this.stencilFail=no,this.stencilZFail=no,this.stencilZPass=no,this.stencilWrite=!1,this.clippingPlanes=null,this.clipIntersection=!1,this.clipShadows=!1,this.shadowSide=null,this.colorWrite=!0,this.precision=null,this.polygonOffset=!1,this.polygonOffsetFactor=0,this.polygonOffsetUnits=0,this.dithering=!1,this.alphaToCoverage=!1,this.premultipliedAlpha=!1,this.forceSinglePass=!1,this.allowOverride=!0,this.visible=!0,this.toneMapped=!0,this.userData={},this.version=0,this._alphaTest=0}get alphaTest(){return this._alphaTest}set alphaTest(t){this._alphaTest>0!=t>0&&this.version++,this._alphaTest=t}onBeforeRender(){}onBeforeCompile(){}customProgramCacheKey(){return this.onBeforeCompile.toString()}setValues(t){if(t!==void 0)for(let e in t){let i=t[e];if(i===void 0){kt(`Material: parameter '${e}' has value of undefined.`);continue}let s=this[e];if(s===void 0){kt(`Material: '${e}' is not a property of THREE.${this.type}.`);continue}s&&s.isColor?s.set(i):s&&s.isVector2&&i&&i.isVector2||s&&s.isEuler&&i&&i.isEuler||s&&s.isVector3&&i&&i.isVector3?s.copy(i):this[e]=i}}toJSON(t){let e=t===void 0||typeof t=="string";e&&(t={textures:{},images:{}});let i={metadata:{version:4.7,type:"Material",generator:"Material.toJSON"}};i.uuid=this.uuid,i.type=this.type,i.blending=this.blending,i.side=this.side,i.shadowSide=this.shadowSide,i.vertexColors=this.vertexColors,i.opacity=this.opacity,i.transparent=this.transparent,i.blendSrc=this.blendSrc,i.blendDst=this.blendDst,i.blendEquation=this.blendEquation,i.blendSrcAlpha=this.blendSrcAlpha,i.blendDstAlpha=this.blendDstAlpha,i.blendEquationAlpha=this.blendEquationAlpha,i.blendColor=this.blendColor.getHex(),i.blendAlpha=this.blendAlpha,i.depthFunc=this.depthFunc,i.depthTest=this.depthTest,i.depthWrite=this.depthWrite,i.colorWrite=this.colorWrite,i.clipIntersection=this.clipIntersection,i.clipShadows=this.clipShadows,i.stencilWriteMask=this.stencilWriteMask,i.stencilFunc=this.stencilFunc,i.stencilRef=this.stencilRef,i.stencilFuncMask=this.stencilFuncMask,i.stencilFail=this.stencilFail,i.stencilZFail=this.stencilZFail,i.stencilZPass=this.stencilZPass,i.stencilWrite=this.stencilWrite,i.polygonOffset=this.polygonOffset,i.polygonOffsetFactor=this.polygonOffsetFactor,i.polygonOffsetUnits=this.polygonOffsetUnits,i.dithering=this.dithering,i.alphaTest=this.alphaTest,i.alphaHash=this.alphaHash,i.alphaToCoverage=this.alphaToCoverage,i.premultipliedAlpha=this.premultipliedAlpha,i.forceSinglePass=this.forceSinglePass,i.allowOverride=this.allowOverride,i.visible=this.visible,i.toneMapped=this.toneMapped,i.name=this.name,this.color&&this.color.isColor&&(i.color=this.color.getHex()),this.roughness!==void 0&&(i.roughness=this.roughness),this.metalness!==void 0&&(i.metalness=this.metalness),this.sheen!==void 0&&(i.sheen=this.sheen),this.sheenColor&&this.sheenColor.isColor&&(i.sheenColor=this.sheenColor.getHex()),this.sheenRoughness!==void 0&&(i.sheenRoughness=this.sheenRoughness),this.emissive&&this.emissive.isColor&&(i.emissive=this.emissive.getHex()),this.emissiveIntensity!==void 0&&(i.emissiveIntensity=this.emissiveIntensity),this.specular&&this.specular.isColor&&(i.specular=this.specular.getHex()),this.specularIntensity!==void 0&&(i.specularIntensity=this.specularIntensity),this.specularColor&&this.specularColor.isColor&&(i.specularColor=this.specularColor.getHex()),this.shininess!==void 0&&(i.shininess=this.shininess),this.clearcoat!==void 0&&(i.clearcoat=this.clearcoat),this.clearcoatRoughness!==void 0&&(i.clearcoatRoughness=this.clearcoatRoughness),this.clearcoatMap&&this.clearcoatMap.isTexture&&(i.clearcoatMap=this.clearcoatMap.toJSON(t).uuid),this.clearcoatRoughnessMap&&this.clearcoatRoughnessMap.isTexture&&(i.clearcoatRoughnessMap=this.clearcoatRoughnessMap.toJSON(t).uuid),this.clearcoatNormalMap&&this.clearcoatNormalMap.isTexture&&(i.clearcoatNormalMap=this.clearcoatNormalMap.toJSON(t).uuid,i.clearcoatNormalScale=this.clearcoatNormalScale.toArray()),this.sheenColorMap&&this.sheenColorMap.isTexture&&(i.sheenColorMap=this.sheenColorMap.toJSON(t).uuid),this.sheenRoughnessMap&&this.sheenRoughnessMap.isTexture&&(i.sheenRoughnessMap=this.sheenRoughnessMap.toJSON(t).uuid),this.dispersion!==void 0&&(i.dispersion=this.dispersion),this.retroreflectivity!==void 0&&(i.retroreflectivity=this.retroreflectivity),this.iridescence!==void 0&&(i.iridescence=this.iridescence),this.iridescenceIOR!==void 0&&(i.iridescenceIOR=this.iridescenceIOR),this.iridescenceThicknessRange!==void 0&&(i.iridescenceThicknessRange=this.iridescenceThicknessRange),this.iridescenceMap&&this.iridescenceMap.isTexture&&(i.iridescenceMap=this.iridescenceMap.toJSON(t).uuid),this.iridescenceThicknessMap&&this.iridescenceThicknessMap.isTexture&&(i.iridescenceThicknessMap=this.iridescenceThicknessMap.toJSON(t).uuid),this.anisotropy!==void 0&&(i.anisotropy=this.anisotropy),this.anisotropyRotation!==void 0&&(i.anisotropyRotation=this.anisotropyRotation),this.anisotropyMap&&this.anisotropyMap.isTexture&&(i.anisotropyMap=this.anisotropyMap.toJSON(t).uuid),this.map&&this.map.isTexture&&(i.map=this.map.toJSON(t).uuid),this.matcap&&this.matcap.isTexture&&(i.matcap=this.matcap.toJSON(t).uuid),this.alphaMap&&this.alphaMap.isTexture&&(i.alphaMap=this.alphaMap.toJSON(t).uuid),this.lightMap&&this.lightMap.isTexture&&(i.lightMap=this.lightMap.toJSON(t).uuid,i.lightMapIntensity=this.lightMapIntensity),this.aoMap&&this.aoMap.isTexture&&(i.aoMap=this.aoMap.toJSON(t).uuid,i.aoMapIntensity=this.aoMapIntensity),this.bumpMap&&this.bumpMap.isTexture&&(i.bumpMap=this.bumpMap.toJSON(t).uuid,i.bumpScale=this.bumpScale),this.normalMap&&this.normalMap.isTexture&&(i.normalMap=this.normalMap.toJSON(t).uuid,i.normalMapType=this.normalMapType,i.normalScale=this.normalScale.toArray()),this.displacementMap&&this.displacementMap.isTexture&&(i.displacementMap=this.displacementMap.toJSON(t).uuid,i.displacementScale=this.displacementScale,i.displacementBias=this.displacementBias),this.roughnessMap&&this.roughnessMap.isTexture&&(i.roughnessMap=this.roughnessMap.toJSON(t).uuid),this.metalnessMap&&this.metalnessMap.isTexture&&(i.metalnessMap=this.metalnessMap.toJSON(t).uuid),this.emissiveMap&&this.emissiveMap.isTexture&&(i.emissiveMap=this.emissiveMap.toJSON(t).uuid),this.specularMap&&this.specularMap.isTexture&&(i.specularMap=this.specularMap.toJSON(t).uuid),this.specularIntensityMap&&this.specularIntensityMap.isTexture&&(i.specularIntensityMap=this.specularIntensityMap.toJSON(t).uuid),this.specularColorMap&&this.specularColorMap.isTexture&&(i.specularColorMap=this.specularColorMap.toJSON(t).uuid),this.envMap&&this.envMap.isTexture&&(i.envMap=this.envMap.toJSON(t).uuid,this.combine!==void 0&&(i.combine=this.combine)),this.envMapRotation!==void 0&&(i.envMapRotation=this.envMapRotation.toArray()),this.envMapIntensity!==void 0&&(i.envMapIntensity=this.envMapIntensity),this.reflectivity!==void 0&&(i.reflectivity=this.reflectivity),this.refractionRatio!==void 0&&(i.refractionRatio=this.refractionRatio),this.gradientMap&&this.gradientMap.isTexture&&(i.gradientMap=this.gradientMap.toJSON(t).uuid),this.transmission!==void 0&&(i.transmission=this.transmission),this.transmissionMap&&this.transmissionMap.isTexture&&(i.transmissionMap=this.transmissionMap.toJSON(t).uuid),this.thickness!==void 0&&(i.thickness=this.thickness),this.thicknessMap&&this.thicknessMap.isTexture&&(i.thicknessMap=this.thicknessMap.toJSON(t).uuid),this.attenuationDistance!==void 0&&(i.attenuationDistance=this.attenuationDistance),this.attenuationColor!==void 0&&(i.attenuationColor=this.attenuationColor.getHex()),this.size!==void 0&&(i.size=this.size),this.sizeAttenuation!==void 0&&(i.sizeAttenuation=this.sizeAttenuation),Array.isArray(this.clippingPlanes)&&this.clippingPlanes.length>0&&(i.clippingPlanes=this.clippingPlanes.map(r=>r.toJSON())),this.rotation!==void 0&&(i.rotation=this.rotation),this.depthPacking!==void 0&&(i.depthPacking=this.depthPacking),this.linewidth!==void 0&&(i.linewidth=this.linewidth),this.linecap!==void 0&&(i.linecap=this.linecap),this.linejoin!==void 0&&(i.linejoin=this.linejoin),this.dashSize!==void 0&&(i.dashSize=this.dashSize),this.gapSize!==void 0&&(i.gapSize=this.gapSize),this.scale!==void 0&&(i.scale=this.scale),this.wireframe!==void 0&&(i.wireframe=this.wireframe),this.wireframeLinewidth!==void 0&&(i.wireframeLinewidth=this.wireframeLinewidth),this.wireframeLinecap!==void 0&&(i.wireframeLinecap=this.wireframeLinecap),this.wireframeLinejoin!==void 0&&(i.wireframeLinejoin=this.wireframeLinejoin),this.flatShading!==void 0&&(i.flatShading=this.flatShading),this.fog!==void 0&&(i.fog=this.fog),Object.keys(this.userData).length>0&&(i.userData=this.userData);function s(r){let a=[];for(let o in r){let l=r[o];delete l.metadata,a.push(l)}return a}if(e){let r=s(t.textures),a=s(t.images);r.length>0&&(i.textures=r),a.length>0&&(i.images=a)}return i}fromJSON(t,e){if(t.uuid!==void 0&&(this.uuid=t.uuid),t.name!==void 0&&(this.name=t.name),t.color!==void 0&&this.color!==void 0&&this.color.setHex(t.color),t.roughness!==void 0&&(this.roughness=t.roughness),t.metalness!==void 0&&(this.metalness=t.metalness),t.sheen!==void 0&&(this.sheen=t.sheen),t.sheenColor!==void 0&&(this.sheenColor=new Ut().setHex(t.sheenColor)),t.sheenRoughness!==void 0&&(this.sheenRoughness=t.sheenRoughness),t.emissive!==void 0&&this.emissive!==void 0&&this.emissive.setHex(t.emissive),t.specular!==void 0&&this.specular!==void 0&&this.specular.setHex(t.specular),t.specularIntensity!==void 0&&(this.specularIntensity=t.specularIntensity),t.specularColor!==void 0&&this.specularColor!==void 0&&this.specularColor.setHex(t.specularColor),t.shininess!==void 0&&(this.shininess=t.shininess),t.clearcoat!==void 0&&(this.clearcoat=t.clearcoat),t.clearcoatRoughness!==void 0&&(this.clearcoatRoughness=t.clearcoatRoughness),t.dispersion!==void 0&&(this.dispersion=t.dispersion),t.retroreflectivity!==void 0&&(this.retroreflectivity=t.retroreflectivity),t.iridescence!==void 0&&(this.iridescence=t.iridescence),t.iridescenceIOR!==void 0&&(this.iridescenceIOR=t.iridescenceIOR),t.iridescenceThicknessRange!==void 0&&(this.iridescenceThicknessRange=t.iridescenceThicknessRange),t.transmission!==void 0&&(this.transmission=t.transmission),t.thickness!==void 0&&(this.thickness=t.thickness),t.attenuationDistance!==void 0&&(this.attenuationDistance=t.attenuationDistance),t.attenuationColor!==void 0&&this.attenuationColor!==void 0&&this.attenuationColor.setHex(t.attenuationColor),t.anisotropy!==void 0&&(this.anisotropy=t.anisotropy),t.anisotropyRotation!==void 0&&(this.anisotropyRotation=t.anisotropyRotation),t.fog!==void 0&&(this.fog=t.fog),t.flatShading!==void 0&&(this.flatShading=t.flatShading),t.blending!==void 0&&(this.blending=t.blending),t.combine!==void 0&&(this.combine=t.combine),t.side!==void 0&&(this.side=t.side),t.shadowSide!==void 0&&(this.shadowSide=t.shadowSide),t.opacity!==void 0&&(this.opacity=t.opacity),t.transparent!==void 0&&(this.transparent=t.transparent),t.alphaTest!==void 0&&(this.alphaTest=t.alphaTest),t.alphaHash!==void 0&&(this.alphaHash=t.alphaHash),t.depthFunc!==void 0&&(this.depthFunc=t.depthFunc),t.depthTest!==void 0&&(this.depthTest=t.depthTest),t.depthWrite!==void 0&&(this.depthWrite=t.depthWrite),t.colorWrite!==void 0&&(this.colorWrite=t.colorWrite),t.clippingPlanes!==void 0&&(this.clippingPlanes=t.clippingPlanes.map(i=>new ui().fromJSON(i))),t.clipIntersection!==void 0&&(this.clipIntersection=t.clipIntersection),t.clipShadows!==void 0&&(this.clipShadows=t.clipShadows),t.depthPacking!==void 0&&(this.depthPacking=t.depthPacking),t.blendSrc!==void 0&&(this.blendSrc=t.blendSrc),t.blendDst!==void 0&&(this.blendDst=t.blendDst),t.blendEquation!==void 0&&(this.blendEquation=t.blendEquation),t.blendSrcAlpha!==void 0&&(this.blendSrcAlpha=t.blendSrcAlpha),t.blendDstAlpha!==void 0&&(this.blendDstAlpha=t.blendDstAlpha),t.blendEquationAlpha!==void 0&&(this.blendEquationAlpha=t.blendEquationAlpha),t.blendColor!==void 0&&this.blendColor!==void 0&&this.blendColor.setHex(t.blendColor),t.blendAlpha!==void 0&&(this.blendAlpha=t.blendAlpha),t.stencilWriteMask!==void 0&&(this.stencilWriteMask=t.stencilWriteMask),t.stencilFunc!==void 0&&(this.stencilFunc=t.stencilFunc),t.stencilRef!==void 0&&(this.stencilRef=t.stencilRef),t.stencilFuncMask!==void 0&&(this.stencilFuncMask=t.stencilFuncMask),t.stencilFail!==void 0&&(this.stencilFail=t.stencilFail),t.stencilZFail!==void 0&&(this.stencilZFail=t.stencilZFail),t.stencilZPass!==void 0&&(this.stencilZPass=t.stencilZPass),t.stencilWrite!==void 0&&(this.stencilWrite=t.stencilWrite),t.wireframe!==void 0&&(this.wireframe=t.wireframe),t.wireframeLinewidth!==void 0&&(this.wireframeLinewidth=t.wireframeLinewidth),t.wireframeLinecap!==void 0&&(this.wireframeLinecap=t.wireframeLinecap),t.wireframeLinejoin!==void 0&&(this.wireframeLinejoin=t.wireframeLinejoin),t.rotation!==void 0&&(this.rotation=t.rotation),t.linewidth!==void 0&&(this.linewidth=t.linewidth),t.linecap!==void 0&&(this.linecap=t.linecap),t.linejoin!==void 0&&(this.linejoin=t.linejoin),t.dashSize!==void 0&&(this.dashSize=t.dashSize),t.gapSize!==void 0&&(this.gapSize=t.gapSize),t.scale!==void 0&&(this.scale=t.scale),t.polygonOffset!==void 0&&(this.polygonOffset=t.polygonOffset),t.polygonOffsetFactor!==void 0&&(this.polygonOffsetFactor=t.polygonOffsetFactor),t.polygonOffsetUnits!==void 0&&(this.polygonOffsetUnits=t.polygonOffsetUnits),t.dithering!==void 0&&(this.dithering=t.dithering),t.alphaToCoverage!==void 0&&(this.alphaToCoverage=t.alphaToCoverage),t.premultipliedAlpha!==void 0&&(this.premultipliedAlpha=t.premultipliedAlpha),t.forceSinglePass!==void 0&&(this.forceSinglePass=t.forceSinglePass),t.allowOverride!==void 0&&(this.allowOverride=t.allowOverride),t.visible!==void 0&&(this.visible=t.visible),t.toneMapped!==void 0&&(this.toneMapped=t.toneMapped),t.userData!==void 0&&(this.userData=t.userData),t.vertexColors!==void 0&&(typeof t.vertexColors=="number"?this.vertexColors=t.vertexColors>0:this.vertexColors=t.vertexColors),t.size!==void 0&&(this.size=t.size),t.sizeAttenuation!==void 0&&(this.sizeAttenuation=t.sizeAttenuation),t.map!==void 0&&(this.map=e[t.map]||null),t.matcap!==void 0&&(this.matcap=e[t.matcap]||null),t.alphaMap!==void 0&&(this.alphaMap=e[t.alphaMap]||null),t.bumpMap!==void 0&&(this.bumpMap=e[t.bumpMap]||null),t.bumpScale!==void 0&&(this.bumpScale=t.bumpScale),t.normalMap!==void 0&&(this.normalMap=e[t.normalMap]||null),t.normalMapType!==void 0&&(this.normalMapType=t.normalMapType),t.normalScale!==void 0){let i=t.normalScale;Array.isArray(i)===!1&&(i=[i,i]),this.normalScale=new xt().fromArray(i)}return t.displacementMap!==void 0&&(this.displacementMap=e[t.displacementMap]||null),t.displacementScale!==void 0&&(this.displacementScale=t.displacementScale),t.displacementBias!==void 0&&(this.displacementBias=t.displacementBias),t.roughnessMap!==void 0&&(this.roughnessMap=e[t.roughnessMap]||null),t.metalnessMap!==void 0&&(this.metalnessMap=e[t.metalnessMap]||null),t.emissiveMap!==void 0&&(this.emissiveMap=e[t.emissiveMap]||null),t.emissiveIntensity!==void 0&&(this.emissiveIntensity=t.emissiveIntensity),t.specularMap!==void 0&&(this.specularMap=e[t.specularMap]||null),t.specularIntensityMap!==void 0&&(this.specularIntensityMap=e[t.specularIntensityMap]||null),t.specularColorMap!==void 0&&(this.specularColorMap=e[t.specularColorMap]||null),t.envMap!==void 0&&(this.envMap=e[t.envMap]||null),t.envMapRotation!==void 0&&this.envMapRotation.fromArray(t.envMapRotation),t.envMapIntensity!==void 0&&(this.envMapIntensity=t.envMapIntensity),t.reflectivity!==void 0&&(this.reflectivity=t.reflectivity),t.refractionRatio!==void 0&&(this.refractionRatio=t.refractionRatio),t.lightMap!==void 0&&(this.lightMap=e[t.lightMap]||null),t.lightMapIntensity!==void 0&&(this.lightMapIntensity=t.lightMapIntensity),t.aoMap!==void 0&&(this.aoMap=e[t.aoMap]||null),t.aoMapIntensity!==void 0&&(this.aoMapIntensity=t.aoMapIntensity),t.gradientMap!==void 0&&(this.gradientMap=e[t.gradientMap]||null),t.clearcoatMap!==void 0&&(this.clearcoatMap=e[t.clearcoatMap]||null),t.clearcoatRoughnessMap!==void 0&&(this.clearcoatRoughnessMap=e[t.clearcoatRoughnessMap]||null),t.clearcoatNormalMap!==void 0&&(this.clearcoatNormalMap=e[t.clearcoatNormalMap]||null),t.clearcoatNormalScale!==void 0&&(this.clearcoatNormalScale=new xt().fromArray(t.clearcoatNormalScale)),t.iridescenceMap!==void 0&&(this.iridescenceMap=e[t.iridescenceMap]||null),t.iridescenceThicknessMap!==void 0&&(this.iridescenceThicknessMap=e[t.iridescenceThicknessMap]||null),t.transmissionMap!==void 0&&(this.transmissionMap=e[t.transmissionMap]||null),t.thicknessMap!==void 0&&(this.thicknessMap=e[t.thicknessMap]||null),t.anisotropyMap!==void 0&&(this.anisotropyMap=e[t.anisotropyMap]||null),t.sheenColorMap!==void 0&&(this.sheenColorMap=e[t.sheenColorMap]||null),t.sheenRoughnessMap!==void 0&&(this.sheenRoughnessMap=e[t.sheenRoughnessMap]||null),this}clone(){return new this.constructor().copy(this)}copy(t){this.name=t.name,this.blending=t.blending,this.side=t.side,this.vertexColors=t.vertexColors,this.opacity=t.opacity,this.transparent=t.transparent,this.blendSrc=t.blendSrc,this.blendDst=t.blendDst,this.blendEquation=t.blendEquation,this.blendSrcAlpha=t.blendSrcAlpha,this.blendDstAlpha=t.blendDstAlpha,this.blendEquationAlpha=t.blendEquationAlpha,this.blendColor.copy(t.blendColor),this.blendAlpha=t.blendAlpha,this.depthFunc=t.depthFunc,this.depthTest=t.depthTest,this.depthWrite=t.depthWrite,this.stencilWriteMask=t.stencilWriteMask,this.stencilFunc=t.stencilFunc,this.stencilRef=t.stencilRef,this.stencilFuncMask=t.stencilFuncMask,this.stencilFail=t.stencilFail,this.stencilZFail=t.stencilZFail,this.stencilZPass=t.stencilZPass,this.stencilWrite=t.stencilWrite;let e=t.clippingPlanes,i=null;if(e!==null){let s=e.length;i=new Array(s);for(let r=0;r!==s;++r)i[r]=e[r].clone()}return this.clippingPlanes=i,this.clipIntersection=t.clipIntersection,this.clipShadows=t.clipShadows,this.shadowSide=t.shadowSide,this.colorWrite=t.colorWrite,this.precision=t.precision,this.polygonOffset=t.polygonOffset,this.polygonOffsetFactor=t.polygonOffsetFactor,this.polygonOffsetUnits=t.polygonOffsetUnits,this.dithering=t.dithering,this.alphaTest=t.alphaTest,this.alphaHash=t.alphaHash,this.alphaToCoverage=t.alphaToCoverage,this.premultipliedAlpha=t.premultipliedAlpha,this.forceSinglePass=t.forceSinglePass,this.allowOverride=t.allowOverride,this.visible=t.visible,this.toneMapped=t.toneMapped,this.userData=JSON.parse(JSON.stringify(t.userData)),this}dispose(){this.dispatchEvent({type:"dispose"})}set needsUpdate(t){t===!0&&this.version++}},Bs=class extends yi{constructor(t){super(),this.isSpriteMaterial=!0,this.type="SpriteMaterial",this.color=new Ut(16777215),this.map=null,this.alphaMap=null,this.rotation=0,this.sizeAttenuation=!0,this.transparent=!0,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.alphaMap=t.alphaMap,this.rotation=t.rotation,this.sizeAttenuation=t.sizeAttenuation,this.fog=t.fog,this}},ys,mr=new N,Ms=new N,bs=new N,Ss=new xt,gr=new xt,Ld=new oe,Fa=new N,xr=new N,za=new N,Au=new xt,Fc=new xt,Ru=new xt,Dr=class extends Pe{constructor(t=new Bs){if(super(),this.isSprite=!0,this.type="Sprite",ys===void 0){ys=new ce;let e=new Float32Array([-.5,-.5,0,0,0,.5,-.5,0,1,0,.5,.5,0,1,1,-.5,.5,0,0,1]),i=new Lr(e,5);ys.setIndex([0,1,2,0,2,3]),ys.setAttribute("position",new zs(i,3,0,!1)),ys.setAttribute("uv",new zs(i,2,3,!1))}this.geometry=ys,this.material=t,this.center=new xt(.5,.5),this.count=1}intersectsFrustum(t){return t.intersectsSprite(this)}raycast(t,e){t.camera===null&&Ht('Sprite: "Raycaster.camera" needs to be set in order to raycast against sprites.'),Ms.setFromMatrixScale(this.matrixWorld),Ld.copy(t.camera.matrixWorld),this.modelViewMatrix.multiplyMatrices(t.camera.matrixWorldInverse,this.matrixWorld),bs.setFromMatrixPosition(this.modelViewMatrix),t.camera.isPerspectiveCamera&&this.material.sizeAttenuation===!1&&Ms.multiplyScalar(-bs.z);let i=this.material.rotation,s,r;i!==0&&(r=Math.cos(i),s=Math.sin(i));let a=this.center;Ba(Fa.set(-.5,-.5,0),bs,a,Ms,s,r),Ba(xr.set(.5,-.5,0),bs,a,Ms,s,r),Ba(za.set(.5,.5,0),bs,a,Ms,s,r),Au.set(0,0),Fc.set(1,0),Ru.set(1,1);let o=t.ray.intersectTriangle(Fa,xr,za,!1,mr);if(o===null&&(Ba(xr.set(-.5,.5,0),bs,a,Ms,s,r),Fc.set(0,1),o=t.ray.intersectTriangle(Fa,za,xr,!1,mr),o===null))return;let l=t.ray.origin.distanceTo(mr);l<t.near||l>t.far||e.push({distance:l,point:mr.clone(),uv:on.getInterpolation(mr,Fa,xr,za,Au,Fc,Ru,new xt),face:null,object:this})}copy(t,e){return super.copy(t,e),t.center!==void 0&&this.center.copy(t.center),this.material=t.material,this}};function Ba(n,t,e,i,s,r){Ss.subVectors(n,e).addScalar(.5).multiply(i),s!==void 0?(gr.x=r*Ss.x-s*Ss.y,gr.y=s*Ss.x+r*Ss.y):gr.copy(Ss),n.copy(t),n.x+=gr.x,n.y+=gr.y,n.applyMatrix4(Ld)}var an=new N,zc=new N,Oa=new N,ka=new N,Zn=class{constructor(t=new N,e=new N(0,0,-1)){this.origin=t,this.direction=e}set(t,e){return this.origin.copy(t),this.direction.copy(e),this}copy(t){return this.origin.copy(t.origin),this.direction.copy(t.direction),this}at(t,e){return e.copy(this.origin).addScaledVector(this.direction,t)}lookAt(t){return this.direction.copy(t).sub(this.origin).normalize(),this}recast(t){return this.origin.copy(this.at(t,an)),this}closestPointToPoint(t,e){e.subVectors(t,this.origin);let i=e.dot(this.direction);return i<0?e.copy(this.origin):e.copy(this.origin).addScaledVector(this.direction,i)}distanceToPoint(t){return Math.sqrt(this.distanceSqToPoint(t))}distanceSqToPoint(t){let e=an.subVectors(t,this.origin).dot(this.direction);return e<0?this.origin.distanceToSquared(t):(an.copy(this.origin).addScaledVector(this.direction,e),an.distanceToSquared(t))}distanceSqToSegment(t,e,i,s){zc.copy(t).add(e).multiplyScalar(.5),Oa.copy(e).sub(t).normalize(),ka.copy(this.origin).sub(zc);let r=t.distanceTo(e)*.5,a=-this.direction.dot(Oa),o=ka.dot(this.direction),l=-ka.dot(Oa),c=ka.lengthSq(),h=Math.abs(1-a*a),d,u,f,g;if(h>0)if(d=a*l-o,u=a*o-l,g=r*h,d>=0)if(u>=-g)if(u<=g){let _=1/h;d*=_,u*=_,f=d*(d+a*u+2*o)+u*(a*d+u+2*l)+c}else u=r,d=Math.max(0,-(a*u+o)),f=-d*d+u*(u+2*l)+c;else u=-r,d=Math.max(0,-(a*u+o)),f=-d*d+u*(u+2*l)+c;else u<=-g?(d=Math.max(0,-(-a*r+o)),u=d>0?-r:Math.min(Math.max(-r,-l),r),f=-d*d+u*(u+2*l)+c):u<=g?(d=0,u=Math.min(Math.max(-r,-l),r),f=u*(u+2*l)+c):(d=Math.max(0,-(a*r+o)),u=d>0?r:Math.min(Math.max(-r,-l),r),f=-d*d+u*(u+2*l)+c);else u=a>0?-r:r,d=Math.max(0,-(a*u+o)),f=-d*d+u*(u+2*l)+c;return i&&i.copy(this.origin).addScaledVector(this.direction,d),s&&s.copy(zc).addScaledVector(Oa,u),f}intersectSphere(t,e){if(t.radius<0)return null;an.subVectors(t.center,this.origin);let i=an.dot(this.direction),s=an.dot(an)-i*i,r=t.radius*t.radius;if(s>r)return null;let a=Math.sqrt(r-s),o=i-a,l=i+a;return l<0?null:o<0?this.at(l,e):this.at(o,e)}intersectsSphere(t){return t.radius<0?!1:this.distanceSqToPoint(t.center)<=t.radius*t.radius}distanceToPlane(t){let e=t.normal.dot(this.direction);if(e===0)return t.distanceToPoint(this.origin)===0?0:null;let i=-(this.origin.dot(t.normal)+t.constant)/e;return i>=0?i:null}intersectPlane(t,e){let i=this.distanceToPlane(t);return i===null?null:this.at(i,e)}intersectsPlane(t){let e=t.distanceToPoint(this.origin);return e===0||t.normal.dot(this.direction)*e<0}intersectBox(t,e){let i,s,r,a,o,l,c=1/this.direction.x,h=1/this.direction.y,d=1/this.direction.z,u=this.origin;return c>=0?(i=(t.min.x-u.x)*c,s=(t.max.x-u.x)*c):(i=(t.max.x-u.x)*c,s=(t.min.x-u.x)*c),h>=0?(r=(t.min.y-u.y)*h,a=(t.max.y-u.y)*h):(r=(t.max.y-u.y)*h,a=(t.min.y-u.y)*h),i>a||r>s||((r>i||isNaN(i))&&(i=r),(a<s||isNaN(s))&&(s=a),d>=0?(o=(t.min.z-u.z)*d,l=(t.max.z-u.z)*d):(o=(t.max.z-u.z)*d,l=(t.min.z-u.z)*d),i>l||o>s)||((o>i||i!==i)&&(i=o),(l<s||s!==s)&&(s=l),s<0)?null:this.at(i>=0?i:s,e)}intersectsBox(t){return this.intersectBox(t,an)!==null}intersectTriangle(t,e,i,s,r){let a=this.origin,o=this.direction,l=o.x,c=o.y,h=o.z,d=t.x-a.x,u=t.y-a.y,f=t.z-a.z,g=e.x-a.x,_=e.y-a.y,m=e.z-a.z,p=i.x-a.x,M=i.y-a.y,R=i.z-a.z,y=Math.abs(l),w=Math.abs(c),S=Math.abs(h),I,v,A,P,O,L,z,D,k,Y,q,Z;if(y>=w&&y>=S?(A=l,L=d,k=g,Z=p,l>=0?(I=c,v=h,P=u,O=f,z=_,D=m,Y=M,q=R):(I=h,v=c,P=f,O=u,z=m,D=_,Y=R,q=M)):w>=S?(A=c,L=u,k=_,Z=M,c>=0?(I=h,v=l,P=f,O=d,z=m,D=g,Y=R,q=p):(I=l,v=h,P=d,O=f,z=g,D=m,Y=p,q=R)):(A=h,L=f,k=m,Z=R,h>=0?(I=l,v=c,P=d,O=u,z=g,D=_,Y=p,q=M):(I=c,v=l,P=u,O=d,z=_,D=g,Y=M,q=p)),A===0)return null;let V=I/A,tt=v/A,rt=1/A,St=P-V*L,_t=O-tt*L,ee=z-V*k,Ct=D-tt*k,$t=Y-V*Z,Q=q-tt*Z,it=$t*Ct-Q*ee,Mt=St*Q-_t*$t,Ot=ee*_t-Ct*St;if(s){if(it<0||Mt<0||Ot<0)return null}else if((it<0||Mt<0||Ot<0)&&(it>0||Mt>0||Ot>0))return null;let yt=it+Mt+Ot;if(yt===0)return null;let qt=rt*(it*L+Mt*k+Ot*Z);return(yt>0?qt<0:qt>0)?null:this.at(qt/yt,r)}applyMatrix4(t){return this.origin.applyMatrix4(t),this.direction.transformDirection(t),this}equals(t){return t.origin.equals(this.origin)&&t.direction.equals(this.direction)}clone(){return new this.constructor().copy(this)}},Le=class extends yi{constructor(t){super(),this.isMeshBasicMaterial=!0,this.type="MeshBasicMaterial",this.color=new Ut(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new _i,this.combine=zo,this.reflectivity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.specularMap=t.specularMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.combine=t.combine,this.reflectivity=t.reflectivity,this.refractionRatio=t.refractionRatio,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.fog=t.fog,this}},Cu=new oe,qn=new Zn,Ha=new vi,Iu=new N,Va=new N,Ga=new N,Wa=new N,Bc=new N,Xa=new N,Pu=new N,qa=new N,Tt=class extends Pe{constructor(t=new ce,e=new Le){super(),this.isMesh=!0,this.type="Mesh",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.count=1,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),t.morphTargetInfluences!==void 0&&(this.morphTargetInfluences=t.morphTargetInfluences.slice()),t.morphTargetDictionary!==void 0&&(this.morphTargetDictionary=Object.assign({},t.morphTargetDictionary)),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}getVertexPosition(t,e){let i=this.geometry,s=i.attributes.position,r=i.morphAttributes.position,a=i.morphTargetsRelative;e.fromBufferAttribute(s,t);let o=this.morphTargetInfluences;if(r&&o){Xa.set(0,0,0);for(let l=0,c=r.length;l<c;l++){let h=o[l],d=r[l];h!==0&&(Bc.fromBufferAttribute(d,t),a?Xa.addScaledVector(Bc,h):Xa.addScaledVector(Bc.sub(e),h))}e.add(Xa)}return e}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.material,r=this.matrixWorld;s!==void 0&&(i.boundingSphere===null&&i.computeBoundingSphere(),Ha.copy(i.boundingSphere),Ha.applyMatrix4(r),qn.copy(t.ray).recast(t.near),!(Ha.containsPoint(qn.origin)===!1&&(qn.intersectSphere(Ha,Iu)===null||qn.origin.distanceToSquared(Iu)>(t.far-t.near)**2))&&(Cu.copy(r).invert(),qn.copy(t.ray).applyMatrix4(Cu),!(i.boundingBox!==null&&qn.intersectsBox(i.boundingBox)===!1)&&this._computeIntersections(t,e,qn)))}_computeIntersections(t,e,i){let s,r=this.geometry,a=this.material,o=r.index,l=r.attributes.position,c=r.attributes.uv,h=r.attributes.uv1,d=r.attributes.normal,u=r.groups,f=r.drawRange;if(o!==null)if(Array.isArray(a))for(let g=0,_=u.length;g<_;g++){let m=u[g],p=a[m.materialIndex],M=Math.max(m.start,f.start),R=Math.min(o.count,Math.min(m.start+m.count,f.start+f.count));for(let y=M,w=R;y<w;y+=3){let S=o.getX(y),I=o.getX(y+1),v=o.getX(y+2);s=Ya(this,p,t,i,c,h,d,S,I,v),s&&(s.faceIndex=Math.floor(y/3),s.face.materialIndex=m.materialIndex,e.push(s))}}else{let g=Math.max(0,f.start),_=Math.min(o.count,f.start+f.count);for(let m=g,p=_;m<p;m+=3){let M=o.getX(m),R=o.getX(m+1),y=o.getX(m+2);s=Ya(this,a,t,i,c,h,d,M,R,y),s&&(s.faceIndex=Math.floor(m/3),e.push(s))}}else if(l!==void 0)if(Array.isArray(a))for(let g=0,_=u.length;g<_;g++){let m=u[g],p=a[m.materialIndex],M=Math.max(m.start,f.start),R=Math.min(l.count,Math.min(m.start+m.count,f.start+f.count));for(let y=M,w=R;y<w;y+=3){let S=y,I=y+1,v=y+2;s=Ya(this,p,t,i,c,h,d,S,I,v),s&&(s.faceIndex=Math.floor(y/3),s.face.materialIndex=m.materialIndex,e.push(s))}}else{let g=Math.max(0,f.start),_=Math.min(l.count,f.start+f.count);for(let m=g,p=_;m<p;m+=3){let M=m,R=m+1,y=m+2;s=Ya(this,a,t,i,c,h,d,M,R,y),s&&(s.faceIndex=Math.floor(m/3),e.push(s))}}}};function Vp(n,t,e,i,s,r,a,o){let l;if(t.side===Ze?l=i.intersectTriangle(a,r,s,!0,o):l=i.intersectTriangle(s,r,a,t.side===Dn,o),l===null)return null;qa.copy(o),qa.applyMatrix4(n.matrixWorld);let c=e.ray.origin.distanceTo(qa);return c<e.near||c>e.far?null:{distance:c,point:qa.clone(),object:n}}function Ya(n,t,e,i,s,r,a,o,l,c){n.getVertexPosition(o,Va),n.getVertexPosition(l,Ga),n.getVertexPosition(c,Wa);let h=Vp(n,t,e,i,Va,Ga,Wa,Pu);if(h){let d=new N;on.getBarycoord(Pu,Va,Ga,Wa,d),s&&(h.uv=on.getInterpolatedAttribute(s,o,l,c,d,new xt)),r&&(h.uv1=on.getInterpolatedAttribute(r,o,l,c,d,new xt)),a&&(h.normal=on.getInterpolatedAttribute(a,o,l,c,d,new N),h.normal.dot(i.direction)>0&&h.normal.multiplyScalar(-1));let u={a:o,b:l,c,normal:new N,materialIndex:0};on.getNormal(Va,Ga,Wa,u.normal),h.face=u,h.barycoord=d}return h}var Nr=class extends ai{constructor(t=null,e=1,i=1,s,r,a,o,l,c=qe,h=qe,d,u){super(null,a,o,l,c,h,s,r,d,u),this.isDataTexture=!0,this.image={data:t,width:e,height:i},this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}};var Os=class extends ze{constructor(t,e,i,s=1){super(t,e,i),this.isInstancedBufferAttribute=!0,this.meshPerAttribute=s}copy(t){return super.copy(t),this.meshPerAttribute=t.meshPerAttribute,this}toJSON(){let t=super.toJSON();return t.meshPerAttribute=this.meshPerAttribute,t.isInstancedBufferAttribute=!0,t}},ws=new oe,Lu=new oe,$a=[],Du=new Xi,Gp=new oe,_r=new Tt,vr=new vi,Ur=class extends Tt{constructor(t,e,i){super(t,e),this.isInstancedMesh=!0,this.instanceMatrix=new Os(new Float32Array(i*16),16),this.instanceColor=null,this.morphTexture=null,this.count=i,this.boundingBox=null,this.boundingSphere=null;for(let s=0;s<i;s++)this.setMatrixAt(s,Gp)}computeBoundingBox(){let t=this.geometry,e=this.count;this.boundingBox===null&&(this.boundingBox=new Xi),t.boundingBox===null&&t.computeBoundingBox(),this.boundingBox.makeEmpty();for(let i=0;i<e;i++)this.getMatrixAt(i,ws),Du.copy(t.boundingBox).applyMatrix4(ws),this.boundingBox.union(Du)}computeBoundingSphere(){let t=this.geometry,e=this.count;this.boundingSphere===null&&(this.boundingSphere=new vi),t.boundingSphere===null&&t.computeBoundingSphere(),this.boundingSphere.makeEmpty();for(let i=0;i<e;i++)this.getMatrixAt(i,ws),vr.copy(t.boundingSphere).applyMatrix4(ws),this.boundingSphere.union(vr)}copy(t,e){return super.copy(t,e),this.instanceMatrix.copy(t.instanceMatrix),t.morphTexture!==null&&(this.morphTexture=t.morphTexture.clone()),t.instanceColor!==null&&(this.instanceColor=t.instanceColor.clone()),this.count=t.count,t.boundingBox!==null&&(this.boundingBox=t.boundingBox.clone()),t.boundingSphere!==null&&(this.boundingSphere=t.boundingSphere.clone()),this}getColorAt(t,e){return this.instanceColor===null?e.setRGB(1,1,1):e.fromArray(this.instanceColor.array,t*3)}getMatrixAt(t,e){return e.fromArray(this.instanceMatrix.array,t*16)}getMorphAt(t,e){let i=e.morphTargetInfluences,s=this.morphTexture.source.data.data,r=i.length+1,a=t*r+1;for(let o=0;o<i.length;o++)i[o]=s[a+o]}raycast(t,e){let i=this.matrixWorld,s=this.count;if(_r.geometry=this.geometry,_r.material=this.material,_r.material!==void 0&&(this.boundingSphere===null&&this.computeBoundingSphere(),vr.copy(this.boundingSphere),vr.applyMatrix4(i),t.ray.intersectsSphere(vr)!==!1))for(let r=0;r<s;r++){this.getMatrixAt(r,ws),Lu.multiplyMatrices(i,ws),_r.matrixWorld=Lu,_r.raycast(t,$a);for(let a=0,o=$a.length;a<o;a++){let l=$a[a];l.instanceId=r,l.object=this,e.push(l)}$a.length=0}}setColorAt(t,e){return this.instanceColor===null&&(this.instanceColor=new Os(new Float32Array(this.instanceMatrix.count*3).fill(1),3)),e.toArray(this.instanceColor.array,t*3),this}setMatrixAt(t,e){return e.toArray(this.instanceMatrix.array,t*16),this}setMorphAt(t,e){let i=e.morphTargetInfluences,s=i.length+1;this.morphTexture===null&&(this.morphTexture=new Nr(new Float32Array(s*this.count),s,this.count,Wo,bi));let r=this.morphTexture.source.data.data,a=0;for(let c=0;c<i.length;c++)a+=i[c];let o=this.geometry.morphTargetsRelative?1:1-a,l=s*t;return r[l]=o,r.set(i,l+1),this}updateMorphTargets(){}dispose(){super.dispose(),this.morphTexture!==null&&(this.morphTexture.dispose(),this.morphTexture=null)}},Yn=new vi,Wp=new xt(.5,.5),Za=new N,ks=class{constructor(t=new ui,e=new ui,i=new ui,s=new ui,r=new ui,a=new ui){this.planes=[t,e,i,s,r,a]}set(t,e,i,s,r,a){let o=this.planes;return o[0].copy(t),o[1].copy(e),o[2].copy(i),o[3].copy(s),o[4].copy(r),o[5].copy(a),this}copy(t){let e=this.planes;for(let i=0;i<6;i++)e[i].copy(t.planes[i]);return this}setFromProjectionMatrix(t,e=Di,i=!1){let s=this.planes,r=t.elements,a=r[0],o=r[1],l=r[2],c=r[3],h=r[4],d=r[5],u=r[6],f=r[7],g=r[8],_=r[9],m=r[10],p=r[11],M=r[12],R=r[13],y=r[14],w=r[15];if(s[0].setComponents(c-a,f-h,p-g,w-M).normalize(),s[1].setComponents(c+a,f+h,p+g,w+M).normalize(),s[2].setComponents(c+o,f+d,p+_,w+R).normalize(),s[3].setComponents(c-o,f-d,p-_,w-R).normalize(),i)s[4].setComponents(l,u,m,y).normalize(),s[5].setComponents(c-l,f-u,p-m,w-y).normalize();else if(s[4].setComponents(c-l,f-u,p-m,w-y).normalize(),e===Di)s[5].setComponents(c+l,f+u,p+m,w+y).normalize();else if(e===Ps)s[5].setComponents(l,u,m,y).normalize();else throw new Error("THREE.Frustum.setFromProjectionMatrix(): Invalid coordinate system: "+e);return this}intersectsObject(t){if(t.boundingSphere!==void 0)t.boundingSphere===null&&t.computeBoundingSphere(),Yn.copy(t.boundingSphere).applyMatrix4(t.matrixWorld);else{let e=t.geometry;e.boundingSphere===null&&e.computeBoundingSphere(),Yn.copy(e.boundingSphere).applyMatrix4(t.matrixWorld)}return this.intersectsSphere(Yn)}intersectsSprite(t){Yn.center.set(0,0,0);let e=Wp.distanceTo(t.center);return Yn.radius=.7071067811865476+e,Yn.applyMatrix4(t.matrixWorld),this.intersectsSphere(Yn)}intersectsSphere(t){let e=this.planes,i=t.center,s=-t.radius;for(let r=0;r<6;r++)if(e[r].distanceToPoint(i)<s)return!1;return!0}intersectsBox(t){let e=this.planes;for(let i=0;i<6;i++){let s=e[i];if(Za.x=s.normal.x>0?t.max.x:t.min.x,Za.y=s.normal.y>0?t.max.y:t.min.y,Za.z=s.normal.z>0?t.max.z:t.min.z,s.distanceToPoint(Za)<0)return!1}return!0}containsPoint(t){let e=this.planes;for(let i=0;i<6;i++)if(e[i].distanceToPoint(t)<0)return!1;return!0}clone(){return new this.constructor().copy(this)}};var Hs=class extends yi{constructor(t){super(),this.isLineBasicMaterial=!0,this.type="LineBasicMaterial",this.color=new Ut(16777215),this.map=null,this.linewidth=1,this.linecap="round",this.linejoin="round",this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.linewidth=t.linewidth,this.linecap=t.linecap,this.linejoin=t.linejoin,this.fog=t.fog,this}},go=new N,xo=new N,Nu=new oe,yr=new Zn,Ja=new vi,Oc=new N,Uu=new N,_o=class extends Pe{constructor(t=new ce,e=new Hs){super(),this.isLine=!0,this.type="Line",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}computeLineDistances(){let t=this.geometry;if(t.index===null){let e=t.attributes.position,i=[0];for(let s=1,r=e.count;s<r;s++)go.fromBufferAttribute(e,s-1),xo.fromBufferAttribute(e,s),i[s]=i[s-1],i[s]+=go.distanceTo(xo);t.setAttribute("lineDistance",new Gt(i,1))}else kt("Line.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.matrixWorld,r=t.params.Line.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),Ja.copy(i.boundingSphere),Ja.applyMatrix4(s),Ja.radius+=r,t.ray.intersectsSphere(Ja)===!1)return;Nu.copy(s).invert(),yr.copy(t.ray).applyMatrix4(Nu);let o=r/((this.scale.x+this.scale.y+this.scale.z)/3),l=o*o,c=this.isLineSegments?2:1,h=i.index,u=i.attributes.position;if(h!==null){let f=Math.max(0,a.start),g=Math.min(h.count,a.start+a.count);for(let _=f,m=g-1;_<m;_+=c){let p=h.getX(_),M=h.getX(_+1),R=Ka(this,t,yr,l,p,M,_);R&&e.push(R)}if(this.isLineLoop){let _=h.getX(g-1),m=h.getX(f),p=Ka(this,t,yr,l,_,m,g-1);p&&e.push(p)}}else{let f=Math.max(0,a.start),g=Math.min(u.count,a.start+a.count);for(let _=f,m=g-1;_<m;_+=c){let p=Ka(this,t,yr,l,_,_+1,_);p&&e.push(p)}if(this.isLineLoop){let _=Ka(this,t,yr,l,g-1,f,g-1);_&&e.push(_)}}}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}};function Ka(n,t,e,i,s,r,a){let o=n.geometry.attributes.position;if(go.fromBufferAttribute(o,s),xo.fromBufferAttribute(o,r),e.distanceSqToSegment(go,xo,Oc,Uu)>i)return;Oc.applyMatrix4(n.matrixWorld);let c=t.ray.origin.distanceTo(Oc);if(!(c<t.near||c>t.far))return{distance:c,point:Uu.clone().applyMatrix4(n.matrixWorld),index:a,face:null,faceIndex:null,barycoord:null,object:n}}var Fu=new N,zu=new N,Fr=class extends _o{constructor(t,e){super(t,e),this.isLineSegments=!0,this.type="LineSegments"}computeLineDistances(){let t=this.geometry;if(t.index===null){let e=t.attributes.position,i=[];for(let s=0,r=e.count;s<r;s+=2)Fu.fromBufferAttribute(e,s),zu.fromBufferAttribute(e,s+1),i[s]=s===0?0:i[s-1],i[s+1]=i[s]+Fu.distanceTo(zu);t.setAttribute("lineDistance",new Gt(i,1))}else kt("LineSegments.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}};var vo=class extends yi{constructor(t){super(),this.isPointsMaterial=!0,this.type="PointsMaterial",this.color=new Ut(16777215),this.map=null,this.alphaMap=null,this.size=1,this.sizeAttenuation=!0,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.alphaMap=t.alphaMap,this.size=t.size,this.sizeAttenuation=t.sizeAttenuation,this.fog=t.fog,this}},Bu=new oe,qc=new Zn,Qa=new vi,ja=new N,zr=class extends Pe{constructor(t=new ce,e=new vo){super(),this.isPoints=!0,this.type="Points",this.geometry=t,this.material=e,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(t,e){return super.copy(t,e),this.material=Array.isArray(t.material)?t.material.slice():t.material,this.geometry=t.geometry,this}intersectsFrustum(t){return t.intersectsObject(this)}raycast(t,e){let i=this.geometry,s=this.matrixWorld,r=t.params.Points.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),Qa.copy(i.boundingSphere),Qa.applyMatrix4(s),Qa.radius+=r,t.ray.intersectsSphere(Qa)===!1)return;Bu.copy(s).invert(),qc.copy(t.ray).applyMatrix4(Bu);let o=r/((this.scale.x+this.scale.y+this.scale.z)/3),l=o*o,c=i.index,d=i.attributes.position;if(c!==null){let u=Math.max(0,a.start),f=Math.min(c.count,a.start+a.count);for(let g=u,_=f;g<_;g++){let m=c.getX(g);ja.fromBufferAttribute(d,m),Ou(ja,m,l,s,t,e,this)}}else{let u=Math.max(0,a.start),f=Math.min(d.count,a.start+a.count);for(let g=u,_=f;g<_;g++)ja.fromBufferAttribute(d,g),Ou(ja,g,l,s,t,e,this)}}updateMorphTargets(){let e=this.geometry.morphAttributes,i=Object.keys(e);if(i.length>0){let s=e[i[0]];if(s!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let r=0,a=s.length;r<a;r++){let o=s[r].name||String(r);this.morphTargetInfluences.push(0),this.morphTargetDictionary[o]=r}}}}};function Ou(n,t,e,i,s,r,a){let o=qc.distanceSqToPoint(n);if(o<e){let l=new N;qc.closestPointToPoint(n,l),l.applyMatrix4(i);let c=s.ray.origin.distanceTo(l);if(c<s.near||c>s.far)return;r.push({distance:c,distanceToRay:Math.sqrt(o),point:l,index:t,face:null,faceIndex:null,barycoord:null,object:a})}}var Br=class extends ai{constructor(t=[],e=Un,i,s,r,a,o,l,c,h){super(t,e,i,s,r,a,o,l,c,h),this.isCubeTexture=!0,this.flipY=!1}get images(){return this.image}set images(t){this.image=t}},ti=class extends ai{constructor(t,e,i,s,r,a,o,l,c){super(t,e,i,s,r,a,o,l,c),this.isCanvasTexture=!0,this.needsUpdate=!0}};var An=class extends ai{constructor(t,e,i=Fi,s,r,a,o=qe,l=qe,c,h=Gi,d=1){if(h!==Gi&&h!==Fn)throw new Error("THREE.DepthTexture: format must be either THREE.DepthFormat or THREE.DepthStencilFormat");let u={width:t,height:e,depth:d};super(u,s,r,a,o,l,h,i,c),this.isDepthTexture=!0,this.flipY=!1,this.generateMipmaps=!1,this.compareFunction=null}copy(t){return super.copy(t),this.source=new Ns(Object.assign({},t.image)),this.compareFunction=t.compareFunction,this}toJSON(t){let e=super.toJSON(t);return e.compareFunction=this.compareFunction,e}},yo=class extends An{constructor(t,e=Fi,i=Un,s,r,a=qe,o=qe,l,c=Gi){let h={width:t,height:t,depth:1},d=[h,h,h,h,h,h];super(t,t,e,i,s,r,a,o,l,c),this.image=d,this.isCubeDepthTexture=!0,this.isCubeTexture=!0}get images(){return this.image}set images(t){this.image=t}},Or=class extends ai{constructor(t=null){super(),this.sourceTexture=t,this.isExternalTexture=!0}copy(t){return super.copy(t),this.sourceTexture=t.sourceTexture,this}},$e=class n extends ce{constructor(t=1,e=1,i=1,s=1,r=1,a=1){super(),this.type="BoxGeometry",this.parameters={width:t,height:e,depth:i,widthSegments:s,heightSegments:r,depthSegments:a};let o=this;s=Math.floor(s),r=Math.floor(r),a=Math.floor(a);let l=[],c=[],h=[],d=[],u=0,f=0;g("z","y","x",-1,-1,i,e,t,a,r,0),g("z","y","x",1,-1,i,e,-t,a,r,1),g("x","z","y",1,1,t,i,e,s,a,2),g("x","z","y",1,-1,t,i,-e,s,a,3),g("x","y","z",1,-1,t,e,i,s,r,4),g("x","y","z",-1,-1,t,e,-i,s,r,5),this.setIndex(l),this.setAttribute("position",new Gt(c,3)),this.setAttribute("normal",new Gt(h,3)),this.setAttribute("uv",new Gt(d,2));function g(_,m,p,M,R,y,w,S,I,v,A){let P=y/I,O=w/v,L=y/2,z=w/2,D=S/2,k=I+1,Y=v+1,q=0,Z=0,V=new N;for(let tt=0;tt<Y;tt++){let rt=tt*O-z;for(let St=0;St<k;St++){let _t=St*P-L;V[_]=_t*M,V[m]=rt*R,V[p]=D,c.push(V.x,V.y,V.z),V[_]=0,V[m]=0,V[p]=S>0?1:-1,h.push(V.x,V.y,V.z),d.push(St/I),d.push(1-tt/v),q+=1}}for(let tt=0;tt<v;tt++)for(let rt=0;rt<I;rt++){let St=u+rt+k*tt,_t=u+rt+k*(tt+1),ee=u+(rt+1)+k*(tt+1),Ct=u+(rt+1)+k*tt;l.push(St,_t,Ct),l.push(_t,ee,Ct),Z+=6}o.addGroup(f,Z,A),f+=Z,u+=q}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.width,t.height,t.depth,t.widthSegments,t.heightSegments,t.depthSegments)}};var Jn=class n extends ce{constructor(t=1,e=32,i=0,s=Math.PI*2){super(),this.type="CircleGeometry",this.parameters={radius:t,segments:e,thetaStart:i,thetaLength:s},e=Math.max(3,e);let r=[],a=[],o=[],l=[],c=new N,h=new xt;a.push(0,0,0),o.push(0,0,1),l.push(.5,.5);for(let d=0,u=3;d<=e;d++,u+=3){let f=i+d/e*s;c.x=t*Math.cos(f),c.y=t*Math.sin(f),a.push(c.x,c.y,c.z),o.push(0,0,1),h.x=(a[u]/t+1)/2,h.y=(a[u+1]/t+1)/2,l.push(h.x,h.y)}for(let d=1;d<=e;d++)r.push(d,d+1,0);this.setIndex(r),this.setAttribute("position",new Gt(a,3)),this.setAttribute("normal",new Gt(o,3)),this.setAttribute("uv",new Gt(l,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.segments,t.thetaStart,t.thetaLength)}},ei=class n extends ce{constructor(t=1,e=1,i=1,s=32,r=1,a=!1,o=0,l=Math.PI*2){super(),this.type="CylinderGeometry",this.parameters={radiusTop:t,radiusBottom:e,height:i,radialSegments:s,heightSegments:r,openEnded:a,thetaStart:o,thetaLength:l};let c=this;s=Math.floor(s),r=Math.floor(r);let h=[],d=[],u=[],f=[],g=0,_=[],m=i/2,p=0;M(),a===!1&&(t>0&&R(!0),e>0&&R(!1)),this.setIndex(h),this.setAttribute("position",new Gt(d,3)),this.setAttribute("normal",new Gt(u,3)),this.setAttribute("uv",new Gt(f,2));function M(){let y=new N,w=new N,S=0,I=(e-t)/i;for(let v=0;v<=r;v++){let A=[],P=v/r,O=P*(e-t)+t;for(let L=0;L<=s;L++){let z=L/s,D=z*l+o,k=Math.sin(D),Y=Math.cos(D);w.x=O*k,w.y=-P*i+m,w.z=O*Y,d.push(w.x,w.y,w.z),y.set(k,I,Y).normalize(),u.push(y.x,y.y,y.z),f.push(z,1-P),A.push(g++)}_.push(A)}for(let v=0;v<s;v++)for(let A=0;A<r;A++){let P=_[A][v],O=_[A+1][v],L=_[A+1][v+1],z=_[A][v+1];(t>0||A!==0)&&(h.push(P,O,z),S+=3),(e>0||A!==r-1)&&(h.push(O,L,z),S+=3)}c.addGroup(p,S,0),p+=S}function R(y){let w=g,S=new xt,I=new N,v=0,A=y===!0?t:e,P=y===!0?1:-1;for(let L=1;L<=s;L++)d.push(0,m*P,0),u.push(0,P,0),f.push(.5,.5),g++;let O=g;for(let L=0;L<=s;L++){let D=L/s*l+o,k=Math.cos(D),Y=Math.sin(D);I.x=A*Y,I.y=m*P,I.z=A*k,d.push(I.x,I.y,I.z),u.push(0,P,0),S.x=k*.5+.5,S.y=Y*.5*P+.5,f.push(S.x,S.y),g++}for(let L=0;L<s;L++){let z=w+L,D=O+L;y===!0?h.push(D,D+1,z):h.push(D+1,D,z),v+=3}c.addGroup(p,v,y===!0?1:2),p+=v}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radiusTop,t.radiusBottom,t.height,t.radialSegments,t.heightSegments,t.openEnded,t.thetaStart,t.thetaLength)}},Kn=class n extends ei{constructor(t=1,e=1,i=32,s=1,r=!1,a=0,o=Math.PI*2){super(0,t,e,i,s,r,a,o),this.type="ConeGeometry",this.parameters={radius:t,height:e,radialSegments:i,heightSegments:s,openEnded:r,thetaStart:a,thetaLength:o}}static fromJSON(t){return new n(t.radius,t.height,t.radialSegments,t.heightSegments,t.openEnded,t.thetaStart,t.thetaLength)}},Mo=class n extends ce{constructor(t=[],e=[],i=1,s=0){super(),this.type="PolyhedronGeometry",this.parameters={vertices:t,indices:e,radius:i,detail:s};let r=[],a=[];o(s),c(i),h(),this.setAttribute("position",new Gt(r,3)),this.setAttribute("normal",new Gt(r.slice(),3)),this.setAttribute("uv",new Gt(a,2)),s===0?this.computeVertexNormals():this.normalizeNormals();function o(M){let R=new N,y=new N,w=new N;for(let S=0;S<e.length;S+=3)f(e[S+0],R),f(e[S+1],y),f(e[S+2],w),l(R,y,w,M)}function l(M,R,y,w){let S=w+1,I=[];for(let v=0;v<=S;v++){I[v]=[];let A=M.clone().lerp(y,v/S),P=R.clone().lerp(y,v/S),O=S-v;for(let L=0;L<=O;L++)L===0&&v===S?I[v][L]=A:I[v][L]=A.clone().lerp(P,L/O)}for(let v=0;v<S;v++)for(let A=0;A<2*(S-v)-1;A++){let P=Math.floor(A/2);A%2===0?(u(I[v][P+1]),u(I[v+1][P]),u(I[v][P])):(u(I[v][P+1]),u(I[v+1][P+1]),u(I[v+1][P]))}}function c(M){let R=new N;for(let y=0;y<r.length;y+=3)R.x=r[y+0],R.y=r[y+1],R.z=r[y+2],R.normalize().multiplyScalar(M),r[y+0]=R.x,r[y+1]=R.y,r[y+2]=R.z}function h(){let M=new N;for(let R=0;R<r.length;R+=3){M.x=r[R+0],M.y=r[R+1],M.z=r[R+2];let y=m(M)/2/Math.PI+.5,w=p(M)/Math.PI+.5;a.push(y,1-w)}g(),d()}function d(){for(let M=0;M<a.length;M+=6){let R=a[M+0],y=a[M+2],w=a[M+4],S=Math.max(R,y,w),I=Math.min(R,y,w);S>.9&&I<.1&&(R<.2&&(a[M+0]+=1),y<.2&&(a[M+2]+=1),w<.2&&(a[M+4]+=1))}}function u(M){r.push(M.x,M.y,M.z)}function f(M,R){let y=M*3;R.x=t[y+0],R.y=t[y+1],R.z=t[y+2]}function g(){let M=new N,R=new N,y=new N,w=new N,S=new xt,I=new xt,v=new xt;for(let A=0,P=0;A<r.length;A+=9,P+=6){M.set(r[A+0],r[A+1],r[A+2]),R.set(r[A+3],r[A+4],r[A+5]),y.set(r[A+6],r[A+7],r[A+8]),S.set(a[P+0],a[P+1]),I.set(a[P+2],a[P+3]),v.set(a[P+4],a[P+5]),w.copy(M).add(R).add(y).divideScalar(3);let O=m(w);_(S,P+0,M,O),_(I,P+2,R,O),_(v,P+4,y,O)}}function _(M,R,y,w){w<0&&M.x===1&&(a[R]=M.x-1),y.x===0&&y.z===0&&(a[R]=w/2/Math.PI+.5)}function m(M){return Math.atan2(M.z,-M.x)}function p(M){return Math.atan2(-M.y,Math.sqrt(M.x*M.x+M.z*M.z))}}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.vertices,t.indices,t.radius,t.detail)}};var kr=class n extends ce{constructor(t=[new xt(0,-.5),new xt(.5,0),new xt(0,.5)],e=12,i=0,s=Math.PI*2){super(),this.type="LatheGeometry",this.parameters={points:t,segments:e,phiStart:i,phiLength:s},e=Math.floor(e),s=te(s,0,Math.PI*2);let r=[],a=[],o=[],l=[],c=[],h=1/e,d=new N,u=new xt,f=new N,g=new N,_=new N,m=0,p=0;for(let M=0;M<=t.length-1;M++)switch(M){case 0:m=t[M+1].x-t[M].x,p=t[M+1].y-t[M].y,f.x=p*1,f.y=-m,f.z=p*0,_.copy(f),f.normalize(),l.push(f.x,f.y,f.z);break;case t.length-1:l.push(_.x,_.y,_.z);break;default:m=t[M+1].x-t[M].x,p=t[M+1].y-t[M].y,f.x=p*1,f.y=-m,f.z=p*0,g.copy(f),f.x+=_.x,f.y+=_.y,f.z+=_.z,f.normalize(),l.push(f.x,f.y,f.z),_.copy(g)}for(let M=0;M<=e;M++){let R=i+M*h*s,y=Math.sin(R),w=Math.cos(R);for(let S=0;S<=t.length-1;S++){d.x=t[S].x*y,d.y=t[S].y,d.z=t[S].x*w,a.push(d.x,d.y,d.z),u.x=M/e,u.y=S/(t.length-1),o.push(u.x,u.y);let I=l[3*S+0]*y,v=l[3*S+1],A=l[3*S+0]*w;c.push(I,v,A)}}for(let M=0;M<e;M++)for(let R=0;R<t.length-1;R++){let y=R+M*t.length,w=y,S=y+t.length,I=y+t.length+1,v=y+1;r.push(w,S,v),r.push(I,v,S)}this.setIndex(r),this.setAttribute("position",new Gt(a,3)),this.setAttribute("uv",new Gt(o,2)),this.setAttribute("normal",new Gt(c,3))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.points,t.segments,t.phiStart,t.phiLength)}},Ni=class n extends Mo{constructor(t=1,e=0){let i=[1,0,0,-1,0,0,0,1,0,0,-1,0,0,0,1,0,0,-1],s=[0,2,4,0,4,3,0,3,5,0,5,2,1,2,5,1,5,3,1,3,4,1,4,2];super(i,s,t,e),this.type="OctahedronGeometry",this.parameters={radius:t,detail:e}}static fromJSON(t){return new n(t.radius,t.detail)}},qi=class n extends ce{constructor(t=1,e=1,i=1,s=1){super(),this.type="PlaneGeometry",this.parameters={width:t,height:e,widthSegments:i,heightSegments:s};let r=t/2,a=e/2,o=Math.floor(i),l=Math.floor(s),c=o+1,h=l+1,d=t/o,u=e/l,f=[],g=[],_=[],m=[];for(let p=0;p<h;p++){let M=p*u-a;for(let R=0;R<c;R++){let y=R*d-r;g.push(y,-M,0),_.push(0,0,1),m.push(R/o),m.push(1-p/l)}}for(let p=0;p<l;p++)for(let M=0;M<o;M++){let R=M+c*p,y=M+c*(p+1),w=M+1+c*(p+1),S=M+1+c*p;f.push(R,y,S),f.push(y,w,S)}this.setIndex(f),this.setAttribute("position",new Gt(g,3)),this.setAttribute("normal",new Gt(_,3)),this.setAttribute("uv",new Gt(m,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.width,t.height,t.widthSegments,t.heightSegments)}},hn=class n extends ce{constructor(t=.5,e=1,i=32,s=1,r=0,a=Math.PI*2){super(),this.type="RingGeometry",this.parameters={innerRadius:t,outerRadius:e,thetaSegments:i,phiSegments:s,thetaStart:r,thetaLength:a},i=Math.max(3,i),s=Math.max(1,s);let o=[],l=[],c=[],h=[],d=t,u=(e-t)/s,f=new N,g=new xt;for(let _=0;_<=s;_++){for(let m=0;m<=i;m++){let p=r+m/i*a;f.x=d*Math.cos(p),f.y=d*Math.sin(p),l.push(f.x,f.y,f.z),c.push(0,0,1),g.x=(f.x/e+1)/2,g.y=(f.y/e+1)/2,h.push(g.x,g.y)}d+=u}for(let _=0;_<s;_++){let m=_*(i+1);for(let p=0;p<i;p++){let M=p+m,R=M,y=M+i+1,w=M+i+2,S=M+1;o.push(R,y,S),o.push(y,w,S)}}this.setIndex(o),this.setAttribute("position",new Gt(l,3)),this.setAttribute("normal",new Gt(c,3)),this.setAttribute("uv",new Gt(h,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.innerRadius,t.outerRadius,t.thetaSegments,t.phiSegments,t.thetaStart,t.thetaLength)}};var un=class n extends ce{constructor(t=1,e=32,i=16,s=0,r=Math.PI*2,a=0,o=Math.PI){super(),this.type="SphereGeometry",this.parameters={radius:t,widthSegments:e,heightSegments:i,phiStart:s,phiLength:r,thetaStart:a,thetaLength:o},e=Math.max(3,Math.floor(e)),i=Math.max(2,Math.floor(i));let l=Math.min(a+o,Math.PI),c=0,h=[],d=new N,u=new N,f=[],g=[],_=[],m=[];for(let p=0;p<=i;p++){let M=[],R=p/i,y=a+R*o,w=t*Math.cos(y),S=Math.sqrt(t*t-w*w),I=0;p===0&&a===0?I=.5/e:p===i&&l===Math.PI&&(I=-.5/e);for(let v=0;v<=e;v++){let A=v/e,P=s+A*r;d.x=-S*Math.cos(P),d.y=w,d.z=S*Math.sin(P),g.push(d.x,d.y,d.z),u.copy(d).normalize(),_.push(u.x,u.y,u.z),m.push(A+I,1-R),M.push(c++)}h.push(M)}for(let p=0;p<i;p++)for(let M=0;M<e;M++){let R=h[p][M+1],y=h[p][M],w=h[p+1][M],S=h[p+1][M+1];(p!==0||a>0)&&f.push(R,y,S),(p!==i-1||l<Math.PI)&&f.push(y,w,S)}this.setIndex(f),this.setAttribute("position",new Gt(g,3)),this.setAttribute("normal",new Gt(_,3)),this.setAttribute("uv",new Gt(m,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.widthSegments,t.heightSegments,t.phiStart,t.phiLength,t.thetaStart,t.thetaLength)}};var Hr=class n extends ce{constructor(t=1,e=.4,i=12,s=48,r=Math.PI*2,a=0,o=Math.PI*2){super(),this.type="TorusGeometry",this.parameters={radius:t,tube:e,radialSegments:i,tubularSegments:s,arc:r,thetaStart:a,thetaLength:o},i=Math.floor(i),s=Math.floor(s);let l=[],c=[],h=[],d=[],u=new N,f=new N,g=new N;for(let _=0;_<=i;_++){let m=a+_/i*o;for(let p=0;p<=s;p++){let M=p/s*r;f.x=(t+e*Math.cos(m))*Math.cos(M),f.y=(t+e*Math.cos(m))*Math.sin(M),f.z=e*Math.sin(m),c.push(f.x,f.y,f.z),u.x=t*Math.cos(M),u.y=t*Math.sin(M),g.subVectors(f,u).normalize(),h.push(g.x,g.y,g.z),d.push(p/s),d.push(_/i)}}for(let _=1;_<=i;_++)for(let m=1;m<=s;m++){let p=(s+1)*_+m-1,M=(s+1)*(_-1)+m-1,R=(s+1)*(_-1)+m,y=(s+1)*_+m;l.push(p,M,y),l.push(M,R,y)}this.setIndex(l),this.setAttribute("position",new Gt(c,3)),this.setAttribute("normal",new Gt(h,3)),this.setAttribute("uv",new Gt(d,2))}copy(t){return super.copy(t),this.parameters=Object.assign({},t.parameters),this}static fromJSON(t){return new n(t.radius,t.tube,t.radialSegments,t.tubularSegments,t.arc,t.thetaStart,t.thetaLength)}};function is(n){let t={};for(let e in n){t[e]={};for(let i in n[e]){let s=n[e][i];if(ku(s))s.isRenderTargetTexture?(kt("UniformsUtils: Textures of render targets cannot be cloned via cloneUniforms() or mergeUniforms()."),t[e][i]=null):t[e][i]=s.clone();else if(Array.isArray(s))if(ku(s[0])){let r=[];for(let a=0,o=s.length;a<o;a++)r[a]=s[a].clone();t[e][i]=r}else t[e][i]=s.slice();else t[e][i]=s}}return t}function ii(n){let t={};for(let e=0;e<n.length;e++){let i=is(n[e]);for(let s in i)t[s]=i[s]}return t}function ku(n){return n&&(n.isColor||n.isMatrix3||n.isMatrix4||n.isVector2||n.isVector3||n.isVector4||n.isTexture||n.isQuaternion)}function Xp(n){let t=[];for(let e=0;e<n.length;e++)t.push(n[e].clone());return t}function ph(n){let t=n.getRenderTarget();return t===null?n.outputColorSpace:t.isXRRenderTarget===!0?t.texture.colorSpace:Qt.workingColorSpace}var dn={clone:is,merge:ii},qp=`void main() {
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}`,Yp=`void main() {
	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}`,Te=class extends yi{constructor(t){super(),this.isShaderMaterial=!0,this.type="ShaderMaterial",this.defines={},this.uniforms={},this.uniformsGroups=[],this.vertexShader=qp,this.fragmentShader=Yp,this.linewidth=1,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.clipping=!1,this.forceSinglePass=!0,this.extensions={clipCullDistance:!1,multiDraw:!1},this.defaultAttributeValues={color:[1,1,1],uv:[0,0],uv1:[0,0]},this.index0AttributeName=void 0,this.uniformsNeedUpdate=!1,this.glslVersion=null,t!==void 0&&this.setValues(t)}copy(t){return super.copy(t),this.fragmentShader=t.fragmentShader,this.vertexShader=t.vertexShader,this.uniforms=is(t.uniforms),this.uniformsGroups=Xp(t.uniformsGroups),this.defines=Object.assign({},t.defines),this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.fog=t.fog,this.lights=t.lights,this.clipping=t.clipping,this.extensions=Object.assign({},t.extensions),this.glslVersion=t.glslVersion,this.defaultAttributeValues=Object.assign({},t.defaultAttributeValues),this.index0AttributeName=t.index0AttributeName,this.uniformsNeedUpdate=t.uniformsNeedUpdate,this}toJSON(t){let e=super.toJSON(t);e.glslVersion=this.glslVersion,e.uniforms={};for(let s in this.uniforms){let a=this.uniforms[s].value;a&&a.isTexture?e.uniforms[s]={type:"t",value:a.toJSON(t).uuid}:a&&a.isColor?e.uniforms[s]={type:"c",value:a.getHex()}:a&&a.isVector2?e.uniforms[s]={type:"v2",value:a.toArray()}:a&&a.isVector3?e.uniforms[s]={type:"v3",value:a.toArray()}:a&&a.isVector4?e.uniforms[s]={type:"v4",value:a.toArray()}:a&&a.isMatrix3?e.uniforms[s]={type:"m3",value:a.toArray()}:a&&a.isMatrix4?e.uniforms[s]={type:"m4",value:a.toArray()}:e.uniforms[s]={value:a}}Object.keys(this.defines).length>0&&(e.defines=this.defines),e.vertexShader=this.vertexShader,e.fragmentShader=this.fragmentShader,e.lights=this.lights,e.clipping=this.clipping;let i={};for(let s in this.extensions)this.extensions[s]===!0&&(i[s]=!0);return Object.keys(i).length>0&&(e.extensions=i),e}fromJSON(t,e){if(super.fromJSON(t,e),t.uniforms!==void 0)for(let i in t.uniforms){let s=t.uniforms[i];switch(this.uniforms[i]={},s.type){case"t":this.uniforms[i].value=e[s.value]||null;break;case"c":this.uniforms[i].value=new Ut().setHex(s.value);break;case"v2":this.uniforms[i].value=new xt().fromArray(s.value);break;case"v3":this.uniforms[i].value=new N().fromArray(s.value);break;case"v4":this.uniforms[i].value=new Ae().fromArray(s.value);break;case"m3":this.uniforms[i].value=new Xt().fromArray(s.value);break;case"m4":this.uniforms[i].value=new oe().fromArray(s.value);break;default:this.uniforms[i].value=s.value}}if(t.defines!==void 0&&(this.defines=t.defines),t.vertexShader!==void 0&&(this.vertexShader=t.vertexShader),t.fragmentShader!==void 0&&(this.fragmentShader=t.fragmentShader),t.glslVersion!==void 0&&(this.glslVersion=t.glslVersion),t.extensions!==void 0)for(let i in t.extensions)this.extensions[i]=t.extensions[i];return t.lights!==void 0&&(this.lights=t.lights),t.clipping!==void 0&&(this.clipping=t.clipping),this}},Vs=class extends Te{constructor(t){super(t),this.isRawShaderMaterial=!0,this.type="RawShaderMaterial"}},Ce=class extends yi{constructor(t){super(),this.isMeshStandardMaterial=!0,this.type="MeshStandardMaterial",this.defines={STANDARD:""},this.color=new Ut(16777215),this.roughness=1,this.metalness=0,this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.emissive=new Ut(0),this.emissiveIntensity=1,this.emissiveMap=null,this.bumpMap=null,this.bumpScale=1,this.normalMap=null,this.normalMapType=ha,this.normalScale=new xt(1,1),this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.roughnessMap=null,this.metalnessMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new _i,this.envMapIntensity=1,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.flatShading=!1,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.defines={STANDARD:""},this.color.copy(t.color),this.roughness=t.roughness,this.metalness=t.metalness,this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.emissive.copy(t.emissive),this.emissiveMap=t.emissiveMap,this.emissiveIntensity=t.emissiveIntensity,this.bumpMap=t.bumpMap,this.bumpScale=t.bumpScale,this.normalMap=t.normalMap,this.normalMapType=t.normalMapType,this.normalScale.copy(t.normalScale),this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.roughnessMap=t.roughnessMap,this.metalnessMap=t.metalnessMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.envMapIntensity=t.envMapIntensity,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.flatShading=t.flatShading,this.fog=t.fog,this}};var Vr=class extends yi{constructor(t){super(),this.isMeshLambertMaterial=!0,this.type="MeshLambertMaterial",this.color=new Ut(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.emissive=new Ut(0),this.emissiveIntensity=1,this.emissiveMap=null,this.bumpMap=null,this.bumpScale=1,this.normalMap=null,this.normalMapType=ha,this.normalScale=new xt(1,1),this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new _i,this.combine=zo,this.reflectivity=1,this.envMapIntensity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.flatShading=!1,this.fog=!0,this.setValues(t)}copy(t){return super.copy(t),this.color.copy(t.color),this.map=t.map,this.lightMap=t.lightMap,this.lightMapIntensity=t.lightMapIntensity,this.aoMap=t.aoMap,this.aoMapIntensity=t.aoMapIntensity,this.emissive.copy(t.emissive),this.emissiveMap=t.emissiveMap,this.emissiveIntensity=t.emissiveIntensity,this.bumpMap=t.bumpMap,this.bumpScale=t.bumpScale,this.normalMap=t.normalMap,this.normalMapType=t.normalMapType,this.normalScale.copy(t.normalScale),this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.specularMap=t.specularMap,this.alphaMap=t.alphaMap,this.envMap=t.envMap,this.envMapRotation.copy(t.envMapRotation),this.combine=t.combine,this.reflectivity=t.reflectivity,this.envMapIntensity=t.envMapIntensity,this.refractionRatio=t.refractionRatio,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this.wireframeLinecap=t.wireframeLinecap,this.wireframeLinejoin=t.wireframeLinejoin,this.flatShading=t.flatShading,this.fog=t.fog,this}},bo=class extends yi{constructor(t){super(),this.isMeshDepthMaterial=!0,this.type="MeshDepthMaterial",this.depthPacking=_d,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.wireframe=!1,this.wireframeLinewidth=1,this.setValues(t)}copy(t){return super.copy(t),this.depthPacking=t.depthPacking,this.map=t.map,this.alphaMap=t.alphaMap,this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this.wireframe=t.wireframe,this.wireframeLinewidth=t.wireframeLinewidth,this}},So=class extends yi{constructor(t){super(),this.isMeshDistanceMaterial=!0,this.type="MeshDistanceMaterial",this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.setValues(t)}copy(t){return super.copy(t),this.map=t.map,this.alphaMap=t.alphaMap,this.displacementMap=t.displacementMap,this.displacementScale=t.displacementScale,this.displacementBias=t.displacementBias,this}};function Ts(n,t){return!n||n.constructor===t?n:typeof t.BYTES_PER_ELEMENT=="number"?new t(n):Array.prototype.slice.call(n)}function kc(n){return n!==void 0&&n.inTangents!==void 0&&n.outTangents!==void 0}var Rn=class{constructor(t,e,i,s){this.parameterPositions=t,this._cachedIndex=0,this.resultBuffer=s!==void 0?s:new e.constructor(i),this.sampleValues=e,this.valueSize=i,this.settings=null,this.DefaultSettings_={}}evaluate(t){let e=this.parameterPositions,i=this._cachedIndex,s=e[i],r=e[i-1];i:{t:{let a;e:{n:if(!(t<s)){for(let o=i+2;;){if(s===void 0){if(t<r)break n;return i=e.length,this._cachedIndex=i,this.copySampleValue_(i-1)}if(i===o)break;if(r=s,s=e[++i],t<s)break t}a=e.length;break e}if(!(t>=r)){let o=e[1];t<o&&(i=2,r=o);for(let l=i-2;;){if(r===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(i===l)break;if(s=r,r=e[--i-1],t>=r)break t}a=i,i=0;break e}break i}for(;i<a;){let o=i+a>>>1;t<e[o]?a=o:i=o+1}if(s=e[i],r=e[i-1],r===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(s===void 0)return i=e.length,this._cachedIndex=i,this.copySampleValue_(i-1)}this._cachedIndex=i,this.intervalChanged_(i,r,s)}return this.interpolate_(i,r,t,s)}getSettings_(){return this.settings||this.DefaultSettings_}copySampleValue_(t){let e=this.resultBuffer,i=this.sampleValues,s=this.valueSize,r=t*s;for(let a=0;a!==s;++a)e[a]=i[r+a];return e}interpolate_(){throw new Error("THREE.Interpolant: Call to abstract method.")}intervalChanged_(){}},wo=class extends Rn{constructor(t,e,i,s){super(t,e,i,s),this._weightPrev=-0,this._offsetPrev=-0,this._weightNext=-0,this._offsetNext=-0,this.DefaultSettings_={endingStart:Gc,endingEnd:Gc}}intervalChanged_(t,e,i){let s=this.parameterPositions,r=t-2,a=t+1,o=s[r],l=s[a];if(o===void 0)switch(this.getSettings_().endingStart){case Wc:r=t,o=2*e-i;break;case Xc:r=s.length-2,o=e+s[r]-s[r+1];break;default:r=t,o=i}if(l===void 0)switch(this.getSettings_().endingEnd){case Wc:a=t,l=2*i-e;break;case Xc:a=1,l=i+s[1]-s[0];break;default:a=t-1,l=e}let c=(i-e)*.5,h=this.valueSize;this._weightPrev=c/(e-o),this._weightNext=c/(l-i),this._offsetPrev=r*h,this._offsetNext=a*h}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,l=t*o,c=l-o,h=this._offsetPrev,d=this._offsetNext,u=this._weightPrev,f=this._weightNext,g=(i-e)/(s-e),_=g*g,m=_*g,p=-u*m+2*u*_-u*g,M=(1+u)*m+(-1.5-2*u)*_+(-.5+u)*g+1,R=(-1-f)*m+(1.5+f)*_+.5*g,y=f*m-f*_;for(let w=0;w!==o;++w)r[w]=p*a[h+w]+M*a[c+w]+R*a[l+w]+y*a[d+w];return r}},To=class extends Rn{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,l=t*o,c=l-o,h=(i-e)/(s-e),d=1-h;for(let u=0;u!==o;++u)r[u]=a[c+u]*d+a[l+u]*h;return r}},Eo=class extends Rn{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t){return this.copySampleValue_(t-1)}},Ao=class extends Rn{interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,l=t*o,c=l-o,h=this.inTangents,d=this.outTangents;if(!h||!d){let g=(i-e)/(s-e),_=1-g;for(let m=0;m!==o;++m)r[m]=a[c+m]*_+a[l+m]*g;return r}let u=o*2,f=t-1;for(let g=0;g!==o;++g){let _=a[c+g],m=a[l+g],p=f*u+g*2,M=d[p],R=d[p+1],y=t*u+g*2,w=h[y],S=h[y+1],I=Zp(i,e,M,w,s);r[g]=Dd(I,_,R,S,m)}return r}};function Dd(n,t,e,i,s){let r=1-n;return r*r*r*t+3*r*r*n*e+3*r*n*n*i+n*n*n*s}function $p(n,t,e,i,s){let r=1-n;return 3*r*r*(e-t)+6*r*n*(i-e)+3*n*n*(s-i)}function Zp(n,t,e,i,s){let r=(n-t)/(s-t);for(let a=0;a<8;a++){let o=Dd(r,t,e,i,s)-n;if(Math.abs(o)<1e-10)break;let l=$p(r,t,e,i,s);if(Math.abs(l)<1e-10)break;r=Math.max(0,Math.min(1,r-o/l))}return r}var di=class{constructor(t,e,i,s){if(t===void 0)throw new Error("THREE.KeyframeTrack: track name is undefined");if(e===void 0||e.length===0)throw new Error("THREE.KeyframeTrack: no keyframes in track named "+t);this.name=t,this.times=Ts(e,this.TimeBufferType),this.values=Ts(i,this.ValueBufferType),this.setInterpolation(s||this.DefaultInterpolation)}static toJSON(t){let e=t.constructor,i;if(e.toJSON!==this.toJSON)i=e.toJSON(t);else{i={name:t.name,times:Ts(t.times,Array),values:Ts(t.values,Array)};let s=t.getInterpolation();s!==t.DefaultInterpolation&&(i.interpolation=s),kc(t.settings)&&(i.settings={inTangents:Ts(t.settings.inTangents,Array),outTangents:Ts(t.settings.outTangents,Array)})}return i.type=t.ValueTypeName,i}InterpolantFactoryMethodDiscrete(t){return new Eo(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodLinear(t){return new To(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodSmooth(t){return new wo(this.times,this.values,this.getValueSize(),t)}InterpolantFactoryMethodBezier(t){let e=new Ao(this.times,this.values,this.getValueSize(),t);return this.settings&&(e.inTangents=this.settings.inTangents,e.outTangents=this.settings.outTangents),e}setInterpolation(t){let e;switch(t){case Sr:e=this.InterpolantFactoryMethodDiscrete;break;case uo:e=this.InterpolantFactoryMethodLinear;break;case io:e=this.InterpolantFactoryMethodSmooth;break;case Vc:e=this.InterpolantFactoryMethodBezier;break}if(e===void 0){let i="unsupported interpolation for "+this.ValueTypeName+" keyframe track named "+this.name;if(this.createInterpolant===void 0)if(t!==this.DefaultInterpolation)this.setInterpolation(this.DefaultInterpolation);else throw new Error(i);return kt("KeyframeTrack:",i),this}return this.createInterpolant=e,this}getInterpolation(){switch(this.createInterpolant){case this.InterpolantFactoryMethodDiscrete:return Sr;case this.InterpolantFactoryMethodLinear:return uo;case this.InterpolantFactoryMethodSmooth:return io;case this.InterpolantFactoryMethodBezier:return Vc}}getValueSize(){return this.values.length/this.times.length}shift(t){if(t!==0){let e=this.times;for(let i=0,s=e.length;i!==s;++i)e[i]+=t}return this}scale(t){if(t!==1){let e=this.times;for(let i=0,s=e.length;i!==s;++i)e[i]*=t;kc(this.settings)&&(Hu(this.settings.inTangents,t),Hu(this.settings.outTangents,t))}return this}trim(t,e){let i=this.times,s=i.length,r=0,a=s-1;for(;r!==s&&i[r]<t;)++r;for(;a!==-1&&i[a]>e;)--a;if(++a,r!==0||a!==s){r>=a&&(a=Math.max(a,1),r=a-1);let o=this.getValueSize();this.times=i.slice(r,a),this.values=this.values.slice(r*o,a*o)}return this}validate(){let t=!0,e=this.getValueSize();e-Math.floor(e)!==0&&(Ht("KeyframeTrack: Invalid value size in track.",this),t=!1);let i=this.times,s=this.values,r=i.length;r===0&&(Ht("KeyframeTrack: Track is empty.",this),t=!1);let a=null;for(let o=0;o!==r;o++){let l=i[o];if(typeof l=="number"&&isNaN(l)){Ht("KeyframeTrack: Time is not a valid number.",this,o,l),t=!1;break}if(a!==null&&a>l){Ht("KeyframeTrack: Out of order keys.",this,o,l,a),t=!1;break}a=l}if(s!==void 0&&cp(s))for(let o=0,l=s.length;o!==l;++o){let c=s[o];if(isNaN(c)){Ht("KeyframeTrack: Value is not a valid number.",this,o,c),t=!1;break}}return t}optimize(){let t=this.times.slice(),e=this.values.slice(),i=this.getValueSize(),s=this.getInterpolation()===io,r=t.length-1,a=1;for(let o=1;o<r;++o){let l=!1,c=t[o],h=t[o+1];if(c!==h&&(o!==1||c!==t[0]))if(s)l=!0;else{let d=o*i,u=d-i,f=d+i;for(let g=0;g!==i;++g){let _=e[d+g];if(_!==e[u+g]||_!==e[f+g]){l=!0;break}}}if(l){if(o!==a){t[a]=t[o];let d=o*i,u=a*i;for(let f=0;f!==i;++f)e[u+f]=e[d+f]}++a}}if(r>0){t[a]=t[r];for(let o=r*i,l=a*i,c=0;c!==i;++c)e[l+c]=e[o+c];++a}return a!==t.length?(this.times=t.slice(0,a),this.values=e.slice(0,a*i)):(this.times=t,this.values=e),this}clone(){let t=this.times.slice(),e=this.values.slice(),i=this.constructor,s=new i(this.name,t,e);return s.createInterpolant=this.createInterpolant,kc(this.settings)&&(s.settings={inTangents:this.settings.inTangents.slice(),outTangents:this.settings.outTangents.slice()}),s}};function Hu(n,t){for(let e=0,i=n.length;e!==i;e+=2)n[e]*=t}di.prototype.ValueTypeName="";di.prototype.TimeBufferType=Float32Array;di.prototype.ValueBufferType=Float32Array;di.prototype.DefaultInterpolation=uo;var Cn=class extends di{constructor(t,e,i){super(t,e,i)}};Cn.prototype.ValueTypeName="bool";Cn.prototype.ValueBufferType=Array;Cn.prototype.DefaultInterpolation=Sr;Cn.prototype.InterpolantFactoryMethodLinear=void 0;Cn.prototype.InterpolantFactoryMethodSmooth=void 0;var Ro=class extends di{constructor(t,e,i,s){super(t,e,i,s)}};Ro.prototype.ValueTypeName="color";var Co=class extends di{constructor(t,e,i,s){super(t,e,i,s)}};Co.prototype.ValueTypeName="number";var Io=class extends Rn{constructor(t,e,i,s){super(t,e,i,s)}interpolate_(t,e,i,s){let r=this.resultBuffer,a=this.sampleValues,o=this.valueSize,l=(i-e)/(s-e),c=t*o;for(let h=c+o;c!==h;c+=4)xi.slerpFlat(r,0,a,c-o,a,c,l);return r}},Gr=class extends di{constructor(t,e,i,s){super(t,e,i,s)}InterpolantFactoryMethodLinear(t){return new Io(this.times,this.values,this.getValueSize(),t)}};Gr.prototype.ValueTypeName="quaternion";Gr.prototype.InterpolantFactoryMethodSmooth=void 0;var In=class extends di{constructor(t,e,i){super(t,e,i)}};In.prototype.ValueTypeName="string";In.prototype.ValueBufferType=Array;In.prototype.DefaultInterpolation=Sr;In.prototype.InterpolantFactoryMethodLinear=void 0;In.prototype.InterpolantFactoryMethodSmooth=void 0;var Po=class extends di{constructor(t,e,i,s){super(t,e,i,s)}};Po.prototype.ValueTypeName="vector";var Lo=class{constructor(t,e,i){let s=this,r=!1,a=0,o=0,l,c=[];this.onStart=void 0,this.onLoad=t,this.onProgress=e,this.onError=i,this._abortController=null,this.itemStart=function(h){o++,r===!1&&s.onStart!==void 0&&s.onStart(h,a,o),r=!0},this.itemEnd=function(h){a++,s.onProgress!==void 0&&s.onProgress(h,a,o),a===o&&(r=!1,s.onLoad!==void 0&&s.onLoad())},this.itemError=function(h){s.onError!==void 0&&s.onError(h)},this.resolveURL=function(h){return h=h.normalize("NFC"),l?l(h):h},this.setURLModifier=function(h){return l=h,this},this.addHandler=function(h,d){return c.push(h,d),this},this.removeHandler=function(h){let d=c.indexOf(h);return d!==-1&&c.splice(d,2),this},this.getHandler=function(h){for(let d=0,u=c.length;d<u;d+=2){let f=c[d],g=c[d+1];if(f.global&&(f.lastIndex=0),f.test(h))return g}return null},this.abort=function(){return this.abortController.abort(),this._abortController=null,this}}get abortController(){return this._abortController||(this._abortController=new AbortController),this._abortController}},Nd=new Lo,Do=class{constructor(t){this.manager=t!==void 0?t:Nd,this.crossOrigin="anonymous",this.withCredentials=!1,this.path="",this.resourcePath="",this.requestHeader={},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}load(){}loadAsync(t,e){let i=this;return new Promise(function(s,r){i.load(t,s,e,r)})}parse(){}setCrossOrigin(t){return this.crossOrigin=t,this}setWithCredentials(t){return this.withCredentials=t,this}setPath(t){return this.path=t,this}setResourcePath(t){return this.resourcePath=t,this}setRequestHeader(t){return this.requestHeader=t,this}abort(){return this}};Do.DEFAULT_MATERIAL_NAME="__DEFAULT";var Gs=class extends Pe{constructor(t,e=1){super(),this.isLight=!0,this.type="Light",this.color=new Ut(t),this.intensity=e}copy(t,e){return super.copy(t,e),this.color.copy(t.color),this.intensity=t.intensity,this}toJSON(t){let e=super.toJSON(t);return e.object.color=this.color.getHex(),e.object.intensity=this.intensity,e}},Wr=class extends Gs{constructor(t,e,i){super(t,i),this.isHemisphereLight=!0,this.type="HemisphereLight",this.position.copy(Pe.DEFAULT_UP),this.updateMatrix(),this.groundColor=new Ut(e)}copy(t,e){return super.copy(t,e),this.groundColor.copy(t.groundColor),this}toJSON(t){let e=super.toJSON(t);return e.object.groundColor=this.groundColor.getHex(),e}},Hc=new oe,Vu=new N,Gu=new N,Xr=class{constructor(t){this.camera=t,this.intensity=1,this.bias=0,this.biasNode=null,this.normalBias=0,this.radius=1,this.blurSamples=8,this.mapSize=new xt(512,512),this.mapType=oi,this.map=null,this.mapPass=null,this.matrix=new oe,this.autoUpdate=!0,this.needsUpdate=!1,this._frustum=new ks,this._frameExtents=new xt(1,1),this._viewportCount=1,this._viewports=[new Ae(0,0,1,1)]}getViewportCount(){return this._viewportCount}getCamera(){return this.camera}getFrustum(){return this._frustum}updateMatrices(t){let e=this.camera;Vu.setFromMatrixPosition(t.matrixWorld),e.position.copy(Vu),Gu.setFromMatrixPosition(t.target.matrixWorld),e.lookAt(Gu),e.updateMatrixWorld(),this._updateMatrix(e,this.matrix,this._frustum)}_updateMatrix(t,e,i,s){Hc.multiplyMatrices(t.projectionMatrix,t.matrixWorldInverse),i.setFromProjectionMatrix(Hc,t.coordinateSystem,t.reversedDepth);let r=this._frameExtents,a=s?s.z/r.x:1,o=s?s.w/r.y:1,l=s?s.x/r.x:0,c=s?s.y/r.y:0;t.coordinateSystem===Ps||t.reversedDepth?e.set(.5*a,0,0,.5*a+l,0,.5*o,0,.5*o+c,0,0,1,0,0,0,0,1):e.set(.5*a,0,0,.5*a+l,0,.5*o,0,.5*o+c,0,0,.5,.5,0,0,0,1),e.multiply(Hc)}getViewport(t){return this._viewports[t]}getFrameExtents(){return this._frameExtents}dispose(){this.map&&this.map.dispose(),this.mapPass&&this.mapPass.dispose()}copy(t){return this.camera=t.camera.clone(),this.intensity=t.intensity,this.bias=t.bias,this.radius=t.radius,this.autoUpdate=t.autoUpdate,this.needsUpdate=t.needsUpdate,this.normalBias=t.normalBias,this.blurSamples=t.blurSamples,this.mapSize.copy(t.mapSize),this.biasNode=t.biasNode,this}clone(){return new this.constructor().copy(this)}toJSON(){let t={};return t.intensity=this.intensity,t.bias=this.bias,t.normalBias=this.normalBias,t.radius=this.radius,t.blurSamples=this.blurSamples,t.mapSize=this.mapSize.toArray(),t.camera=this.camera.toJSON(!1).object,delete t.camera.matrix,t}},to=new N,eo=new xi,Hi=new N,qr=class extends Pe{constructor(){super(),this.isCamera=!0,this.type="Camera",this.matrixWorldInverse=new oe,this.projectionMatrix=new oe,this.projectionMatrixInverse=new oe,this.coordinateSystem=Di,this._reversedDepth=!1}get reversedDepth(){return this._reversedDepth}copy(t,e){return super.copy(t,e),this.matrixWorldInverse.copy(t.matrixWorldInverse),this.projectionMatrix.copy(t.projectionMatrix),this.projectionMatrixInverse.copy(t.projectionMatrixInverse),this.coordinateSystem=t.coordinateSystem,this}getWorldDirection(t){return super.getWorldDirection(t).negate()}updateMatrixWorld(t){super.updateMatrixWorld(t),this.matrixWorld.decompose(to,eo,Hi),Hi.x===1&&Hi.y===1&&Hi.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(to,eo,Hi.set(1,1,1)).invert()}updateWorldMatrix(t,e,i=!1){super.updateWorldMatrix(t,e,i),this.matrixWorld.decompose(to,eo,Hi),Hi.x===1&&Hi.y===1&&Hi.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(to,eo,Hi.set(1,1,1)).invert()}clone(){return new this.constructor().copy(this)}},wn=new N,Wu=new xt,Xu=new xt,Ye=class extends qr{constructor(t=50,e=1,i=.1,s=2e3){super(),this.isPerspectiveCamera=!0,this.type="PerspectiveCamera",this.fov=t,this.zoom=1,this.near=i,this.far=s,this.focus=10,this.aspect=e,this.view=null,this.filmGauge=35,this.filmOffset=0,this.updateProjectionMatrix()}copy(t,e){return super.copy(t,e),this.fov=t.fov,this.zoom=t.zoom,this.near=t.near,this.far=t.far,this.focus=t.focus,this.aspect=t.aspect,this.view=t.view===null?null:Object.assign({},t.view),this.filmGauge=t.filmGauge,this.filmOffset=t.filmOffset,this}setFocalLength(t){let e=.5*this.getFilmHeight()/t;this.fov=Ds*2*Math.atan(e),this.updateProjectionMatrix()}getFocalLength(){let t=Math.tan(Mr*.5*this.fov);return .5*this.getFilmHeight()/t}getEffectiveFOV(){return Ds*2*Math.atan(Math.tan(Mr*.5*this.fov)/this.zoom)}getFilmWidth(){return this.filmGauge*Math.min(this.aspect,1)}getFilmHeight(){return this.filmGauge/Math.max(this.aspect,1)}getViewBounds(t,e,i){wn.set(-1,-1,.5).applyMatrix4(this.projectionMatrixInverse),e.set(wn.x,wn.y).multiplyScalar(-t/wn.z),wn.set(1,1,.5).applyMatrix4(this.projectionMatrixInverse),i.set(wn.x,wn.y).multiplyScalar(-t/wn.z)}getViewSize(t,e){return this.getViewBounds(t,Wu,Xu),e.subVectors(Xu,Wu)}setViewOffset(t,e,i,s,r,a){this.aspect=t/e,this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=t,this.view.fullHeight=e,this.view.offsetX=i,this.view.offsetY=s,this.view.width=r,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let t=this.near,e=t*Math.tan(Mr*.5*this.fov)/this.zoom,i=2*e,s=this.aspect*i,r=-.5*s,a=this.view;if(this.view!==null&&this.view.enabled){let l=a.fullWidth,c=a.fullHeight;r+=a.offsetX*s/l,e-=a.offsetY*i/c,s*=a.width/l,i*=a.height/c}let o=this.filmOffset;o!==0&&(r+=t*o/this.getFilmWidth()),this.projectionMatrix.makePerspective(r,r+s,e,e-i,t,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(t){let e=super.toJSON(t);return e.object.fov=this.fov,e.object.zoom=this.zoom,e.object.near=this.near,e.object.far=this.far,e.object.focus=this.focus,e.object.aspect=this.aspect,this.view!==null&&(e.object.view=Object.assign({},this.view)),e.object.filmGauge=this.filmGauge,e.object.filmOffset=this.filmOffset,e}};var Yc=class extends Xr{constructor(){super(new Ye(90,1,.5,500)),this.isPointLightShadow=!0}},Pn=class extends Gs{constructor(t,e,i=0,s=2){super(t,e),this.isPointLight=!0,this.type="PointLight",this.distance=i,this.decay=s,this.shadow=new Yc}get power(){return this.intensity*4*Math.PI}set power(t){this.intensity=t/(4*Math.PI)}dispose(){super.dispose(),this.shadow.dispose()}copy(t,e){return super.copy(t,e),this.distance=t.distance,this.decay=t.decay,this.shadow=t.shadow.clone(),this}toJSON(t){let e=super.toJSON(t);return e.object.distance=this.distance,e.object.decay=this.decay,e.object.shadow=this.shadow.toJSON(),e}},Ln=class extends qr{constructor(t=-1,e=1,i=1,s=-1,r=.1,a=2e3){super(),this.isOrthographicCamera=!0,this.type="OrthographicCamera",this.zoom=1,this.view=null,this.left=t,this.right=e,this.top=i,this.bottom=s,this.near=r,this.far=a,this.updateProjectionMatrix()}copy(t,e){return super.copy(t,e),this.left=t.left,this.right=t.right,this.top=t.top,this.bottom=t.bottom,this.near=t.near,this.far=t.far,this.zoom=t.zoom,this.view=t.view===null?null:Object.assign({},t.view),this}setViewOffset(t,e,i,s,r,a){this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=t,this.view.fullHeight=e,this.view.offsetX=i,this.view.offsetY=s,this.view.width=r,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let t=(this.right-this.left)/(2*this.zoom),e=(this.top-this.bottom)/(2*this.zoom),i=(this.right+this.left)/2,s=(this.top+this.bottom)/2,r=i-t,a=i+t,o=s+e,l=s-e;if(this.view!==null&&this.view.enabled){let c=(this.right-this.left)/this.view.fullWidth/this.zoom,h=(this.top-this.bottom)/this.view.fullHeight/this.zoom;r+=c*this.view.offsetX,a=r+c*this.view.width,o-=h*this.view.offsetY,l=o-h*this.view.height}this.projectionMatrix.makeOrthographic(r,a,o,l,this.near,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(t){let e=super.toJSON(t);return e.object.zoom=this.zoom,e.object.left=this.left,e.object.right=this.right,e.object.top=this.top,e.object.bottom=this.bottom,e.object.near=this.near,e.object.far=this.far,this.view!==null&&(e.object.view=Object.assign({},this.view)),e}},$c=class extends Xr{constructor(){super(new Ln(-5,5,5,-5,.5,500)),this.isDirectionalLightShadow=!0}},Yr=class extends Gs{constructor(t,e){super(t,e),this.isDirectionalLight=!0,this.type="DirectionalLight",this.position.copy(Pe.DEFAULT_UP),this.updateMatrix(),this.target=new Pe,this.shadow=new $c}dispose(){super.dispose(),this.shadow.dispose()}copy(t){return super.copy(t),this.target=t.target.clone(),this.shadow=t.shadow.clone(),this}toJSON(t){let e=super.toJSON(t);return e.object.shadow=this.shadow.toJSON(),e.object.target=this.target.uuid,e}};var Es=-90,As=1,No=class extends Pe{constructor(t,e,i){super(),this.type="CubeCamera",this.renderTarget=i,this.coordinateSystem=null,this.activeMipmapLevel=0;let s=new Ye(Es,As,t,e);s.layers=this.layers,this.add(s);let r=new Ye(Es,As,t,e);r.layers=this.layers,this.add(r);let a=new Ye(Es,As,t,e);a.layers=this.layers,this.add(a);let o=new Ye(Es,As,t,e);o.layers=this.layers,this.add(o);let l=new Ye(Es,As,t,e);l.layers=this.layers,this.add(l);let c=new Ye(Es,As,t,e);c.layers=this.layers,this.add(c)}updateCoordinateSystem(){let t=this.coordinateSystem,e=this.children.concat(),[i,s,r,a,o,l]=e;for(let c of e)this.remove(c);if(t===Di)i.up.set(0,1,0),i.lookAt(1,0,0),s.up.set(0,1,0),s.lookAt(-1,0,0),r.up.set(0,0,-1),r.lookAt(0,1,0),a.up.set(0,0,1),a.lookAt(0,-1,0),o.up.set(0,1,0),o.lookAt(0,0,1),l.up.set(0,1,0),l.lookAt(0,0,-1);else if(t===Ps)i.up.set(0,-1,0),i.lookAt(-1,0,0),s.up.set(0,-1,0),s.lookAt(1,0,0),r.up.set(0,0,1),r.lookAt(0,1,0),a.up.set(0,0,-1),a.lookAt(0,-1,0),o.up.set(0,-1,0),o.lookAt(0,0,1),l.up.set(0,-1,0),l.lookAt(0,0,-1);else throw new Error("THREE.CubeCamera.updateCoordinateSystem(): Invalid coordinate system: "+t);for(let c of e)this.add(c),c.updateMatrixWorld()}update(t,e){this.parent===null&&this.updateMatrixWorld();let{renderTarget:i,activeMipmapLevel:s}=this;this.coordinateSystem!==t.coordinateSystem&&(this.coordinateSystem=t.coordinateSystem,this.updateCoordinateSystem());let[r,a,o,l,c,h]=this.children,d=t.getRenderTarget(),u=t.getActiveCubeFace(),f=t.getActiveMipmapLevel(),g=t.xr.enabled;t.xr.enabled=!1;let _=i.texture.generateMipmaps;i.texture.generateMipmaps=!1;let m=!1;t.isWebGLRenderer===!0?m=t.state.buffers.depth.getReversed():m=t.reversedDepthBuffer,t.setRenderTarget(i,0,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,r),t.setRenderTarget(i,1,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,a),t.setRenderTarget(i,2,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,o),t.setRenderTarget(i,3,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,l),t.setRenderTarget(i,4,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,c),i.texture.generateMipmaps=_,t.setRenderTarget(i,5,s),m&&t.autoClear===!1&&t.clearDepth(),t.render(e,h),t.setRenderTarget(d,u,f),t.xr.enabled=g,i.texture.needsPMREMUpdate=!0}},Uo=class extends Ye{constructor(t=[]){super(),this.isArrayCamera=!0,this.isMultiViewCamera=!1,this.cameras=t}},$r=class{constructor(){this._previousTime=0,this._currentTime=0,this._startTime=performance.now(),this._delta=0,this._elapsed=0,this._timescale=1,this._document=null,this._pageVisibilityHandler=null}connect(t){this._document=t,t.hidden!==void 0&&(this._pageVisibilityHandler=Jp.bind(this),t.addEventListener("visibilitychange",this._pageVisibilityHandler,!1))}disconnect(){this._pageVisibilityHandler!==null&&(this._document.removeEventListener("visibilitychange",this._pageVisibilityHandler),this._pageVisibilityHandler=null),this._document=null}getDelta(){return this._delta/1e3}getElapsed(){return this._elapsed/1e3}getTimescale(){return this._timescale}setTimescale(t){return this._timescale=t,this}reset(){return this._currentTime=performance.now()-this._startTime,this}dispose(){this.disconnect()}update(t){return this._pageVisibilityHandler!==null&&this._document.hidden===!0?this._delta=0:(this._previousTime=this._currentTime,this._currentTime=(t!==void 0?t:performance.now())-this._startTime,this._delta=(this._currentTime-this._previousTime)*this._timescale,this._elapsed+=this._delta),this}};function Jp(){this._document.hidden===!1&&this.reset()}var mh="\\[\\]\\.:\\/",Kp=new RegExp("["+mh+"]","g"),gh="[^"+mh+"]",Qp="[^"+mh.replace("\\.","")+"]",jp=/((?:WC+[\/:])*)/.source.replace("WC",gh),tm=/(WCOD+)?/.source.replace("WCOD",Qp),em=/(?:\.(WC+)(?:\[(.+)\])?)?/.source.replace("WC",gh),im=/\.(WC+)(?:\[(.+)\])?/.source.replace("WC",gh),nm=new RegExp("^"+jp+tm+em+im+"$"),sm=["material","materials","bones","map"],Zc=class{constructor(t,e,i){let s=i||we.parseTrackName(e);this._targetGroup=t,this._bindings=t.subscribe_(e,s)}getValue(t,e){this.bind();let i=this._targetGroup.nCachedObjects_,s=this._bindings[i];s!==void 0&&s.getValue(t,e)}setValue(t,e){let i=this._bindings;for(let s=this._targetGroup.nCachedObjects_,r=i.length;s!==r;++s)i[s].setValue(t,e)}bind(){let t=this._bindings;for(let e=this._targetGroup.nCachedObjects_,i=t.length;e!==i;++e)t[e].bind()}unbind(){let t=this._bindings;for(let e=this._targetGroup.nCachedObjects_,i=t.length;e!==i;++e)t[e].unbind()}},we=class n{constructor(t,e,i){this.path=e,this.parsedPath=i||n.parseTrackName(e),this.node=n.findNode(t,this.parsedPath.nodeName),this.rootNode=t,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}static create(t,e,i){return t&&t.isAnimationObjectGroup?new n.Composite(t,e,i):new n(t,e,i)}static sanitizeNodeName(t){return t.replace(/\s/g,"_").replace(Kp,"")}static parseTrackName(t){let e=nm.exec(t);if(e===null)throw new Error("THREE.PropertyBinding: Cannot parse trackName: "+t);let i={nodeName:e[2],objectName:e[3],objectIndex:e[4],propertyName:e[5],propertyIndex:e[6]},s=i.nodeName&&i.nodeName.lastIndexOf(".");if(s!==void 0&&s!==-1){let r=i.nodeName.substring(s+1);sm.indexOf(r)!==-1&&(i.nodeName=i.nodeName.substring(0,s),i.objectName=r)}if(i.propertyName===null||i.propertyName.length===0)throw new Error("THREE.PropertyBinding: can not parse propertyName from trackName: "+t);return i}static findNode(t,e){if(e===void 0||e===""||e==="."||e===-1||e===t.name||e===t.uuid)return t;if(t.skeleton){let i=t.skeleton.getBoneByName(e);if(i!==void 0)return i}if(t.children){let i=function(r){for(let a=0;a<r.length;a++){let o=r[a];if(o.name===e||o.uuid===e)return o;let l=i(o.children);if(l)return l}return null},s=i(t.children);if(s)return s}return null}_getValue_unavailable(){}_setValue_unavailable(){}_getValue_direct(t,e){t[e]=this.targetObject[this.propertyName]}_getValue_array(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)t[e++]=i[s]}_getValue_arrayElement(t,e){t[e]=this.resolvedProperty[this.propertyIndex]}_getValue_toArray(t,e){this.resolvedProperty.toArray(t,e)}_setValue_direct(t,e){this.targetObject[this.propertyName]=t[e]}_setValue_direct_setNeedsUpdate(t,e){this.targetObject[this.propertyName]=t[e],this.targetObject.needsUpdate=!0}_setValue_direct_setMatrixWorldNeedsUpdate(t,e){this.targetObject[this.propertyName]=t[e],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_array(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++]}_setValue_array_setNeedsUpdate(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++];this.targetObject.needsUpdate=!0}_setValue_array_setMatrixWorldNeedsUpdate(t,e){let i=this.resolvedProperty;for(let s=0,r=i.length;s!==r;++s)i[s]=t[e++];this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_arrayElement(t,e){this.resolvedProperty[this.propertyIndex]=t[e]}_setValue_arrayElement_setNeedsUpdate(t,e){this.resolvedProperty[this.propertyIndex]=t[e],this.targetObject.needsUpdate=!0}_setValue_arrayElement_setMatrixWorldNeedsUpdate(t,e){this.resolvedProperty[this.propertyIndex]=t[e],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_fromArray(t,e){this.resolvedProperty.fromArray(t,e)}_setValue_fromArray_setNeedsUpdate(t,e){this.resolvedProperty.fromArray(t,e),this.targetObject.needsUpdate=!0}_setValue_fromArray_setMatrixWorldNeedsUpdate(t,e){this.resolvedProperty.fromArray(t,e),this.targetObject.matrixWorldNeedsUpdate=!0}_getValue_unbound(t,e){this.bind(),this.getValue(t,e)}_setValue_unbound(t,e){this.bind(),this.setValue(t,e)}bind(){let t=this.node,e=this.parsedPath,i=e.objectName,s=e.propertyName,r=e.propertyIndex;if(t||(t=n.findNode(this.rootNode,e.nodeName),this.node=t),this.getValue=this._getValue_unavailable,this.setValue=this._setValue_unavailable,!t){kt("PropertyBinding: No target node found for track: "+this.path+".");return}if(i){let c=e.objectIndex;switch(i){case"materials":if(!t.material){Ht("PropertyBinding: Can not bind to material as node does not have a material.",this);return}if(!t.material.materials){Ht("PropertyBinding: Can not bind to material.materials as node.material does not have a materials array.",this);return}t=t.material.materials;break;case"bones":if(!t.skeleton){Ht("PropertyBinding: Can not bind to bones as node does not have a skeleton.",this);return}t=t.skeleton.bones;for(let h=0;h<t.length;h++)if(t[h].name===c){c=h;break}break;case"map":if("map"in t){t=t.map;break}if(!t.material){Ht("PropertyBinding: Can not bind to material as node does not have a material.",this);return}if(!t.material.map){Ht("PropertyBinding: Can not bind to material.map as node.material does not have a map.",this);return}t=t.material.map;break;default:if(t[i]===void 0){Ht("PropertyBinding: Can not bind to objectName of node undefined.",this);return}t=t[i]}if(c!==void 0){if(t[c]===void 0){Ht("PropertyBinding: Trying to bind to objectIndex of objectName, but is undefined.",this,t);return}t=t[c]}}let a=t[s];if(a===void 0){let c=e.nodeName;Ht("PropertyBinding: Trying to update property for track: "+c+"."+s+" but it wasn't found.",t);return}let o=this.Versioning.None;this.targetObject=t,t.isMaterial===!0?o=this.Versioning.NeedsUpdate:t.isObject3D===!0&&(o=this.Versioning.MatrixWorldNeedsUpdate);let l=this.BindingType.Direct;if(r!==void 0){if(s==="morphTargetInfluences"){if(!t.geometry){Ht("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.",this);return}if(!t.geometry.morphAttributes){Ht("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.morphAttributes.",this);return}t.morphTargetDictionary[r]!==void 0&&(r=t.morphTargetDictionary[r])}l=this.BindingType.ArrayElement,this.resolvedProperty=a,this.propertyIndex=r}else a.fromArray!==void 0&&a.toArray!==void 0?(l=this.BindingType.HasFromToArray,this.resolvedProperty=a):Array.isArray(a)?(l=this.BindingType.EntireArray,this.resolvedProperty=a):this.propertyName=s;this.getValue=this.GetterByBindingType[l],this.setValue=this.SetterByBindingTypeAndVersioning[l][o]}unbind(){this.node=null,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}};we.Composite=Zc;we.prototype.BindingType={Direct:0,EntireArray:1,ArrayElement:2,HasFromToArray:3};we.prototype.Versioning={None:0,NeedsUpdate:1,MatrixWorldNeedsUpdate:2};we.prototype.GetterByBindingType=[we.prototype._getValue_direct,we.prototype._getValue_array,we.prototype._getValue_arrayElement,we.prototype._getValue_toArray];we.prototype.SetterByBindingTypeAndVersioning=[[we.prototype._setValue_direct,we.prototype._setValue_direct_setNeedsUpdate,we.prototype._setValue_direct_setMatrixWorldNeedsUpdate],[we.prototype._setValue_array,we.prototype._setValue_array_setNeedsUpdate,we.prototype._setValue_array_setMatrixWorldNeedsUpdate],[we.prototype._setValue_arrayElement,we.prototype._setValue_arrayElement_setNeedsUpdate,we.prototype._setValue_arrayElement_setMatrixWorldNeedsUpdate],[we.prototype._setValue_fromArray,we.prototype._setValue_fromArray_setNeedsUpdate,we.prototype._setValue_fromArray_setMatrixWorldNeedsUpdate]];var Cv=new Float32Array(1);var qu=new oe,Zr=class{constructor(t,e,i=0,s=1/0){this.ray=new Zn(t,e),this.near=i,this.far=s,this.camera=null,this.layers=new Us,this.params={Mesh:{},Line:{threshold:1},LOD:{},Points:{threshold:1},Sprite:{}}}set(t,e){this.ray.set(t,e)}setFromCamera(t,e){e.isPerspectiveCamera?(this.ray.origin.setFromMatrixPosition(e.matrixWorld),this.ray.direction.set(t.x,t.y,.5).unproject(e).sub(this.ray.origin).normalize(),this.camera=e):e.isOrthographicCamera?(this.ray.origin.set(t.x,t.y,e.projectionMatrix.elements[14]).unproject(e),this.ray.direction.set(0,0,-1).transformDirection(e.matrixWorld),this.camera=e):Ht("Raycaster: Unsupported camera type: "+e.type)}setFromXRController(t){return qu.identity().extractRotation(t.matrixWorld),this.ray.origin.setFromMatrixPosition(t.matrixWorld),this.ray.direction.set(0,0,-1).applyMatrix4(qu),this}intersectObject(t,e=!0,i=[]){return Jc(t,this,i,e),i.sort(Yu),i}intersectObjects(t,e=!0,i=[]){for(let s=0,r=t.length;s<r;s++)Jc(t[s],this,i,e);return i.sort(Yu),i}};function Yu(n,t){return n.distance-t.distance}function Jc(n,t,e,i){let s=!0;if(n.layers.test(t.layers)&&n.raycast(t,e)===!1&&(s=!1),s===!0&&i===!0){let r=n.children;for(let a=0,o=r.length;a<o;a++)Jc(r[a],t,e,!0)}}var bh=class bh{constructor(t,e,i,s){this.elements=[1,0,0,1],t!==void 0&&this.set(t,e,i,s)}identity(){return this.set(1,0,0,1),this}fromArray(t,e=0){for(let i=0;i<4;i++)this.elements[i]=t[i+e];return this}set(t,e,i,s){let r=this.elements;return r[0]=t,r[2]=e,r[1]=i,r[3]=s,this}};bh.prototype.isMatrix2=!0;var Kc=bh;function xh(n,t,e,i){let s=rm(i);switch(e){case lh:return n*t;case Wo:return n*t/s.components*s.byteLength;case Xo:return n*t/s.components*s.byteLength;case zn:return n*t*2/s.components*s.byteLength;case qo:return n*t*2/s.components*s.byteLength;case ch:return n*t*3/s.components*s.byteLength;case Si:return n*t*4/s.components*s.byteLength;case Yo:return n*t*4/s.components*s.byteLength;case sa:case ra:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*8;case aa:case oa:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case Zo:case Ko:return Math.max(n,16)*Math.max(t,8)/4;case $o:case Jo:return Math.max(n,8)*Math.max(t,8)/2;case Qo:case jo:case el:case il:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*8;case tl:case la:case nl:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case sl:return Math.floor((n+3)/4)*Math.floor((t+3)/4)*16;case rl:return Math.floor((n+4)/5)*Math.floor((t+3)/4)*16;case al:return Math.floor((n+4)/5)*Math.floor((t+4)/5)*16;case ol:return Math.floor((n+5)/6)*Math.floor((t+4)/5)*16;case ll:return Math.floor((n+5)/6)*Math.floor((t+5)/6)*16;case cl:return Math.floor((n+7)/8)*Math.floor((t+4)/5)*16;case hl:return Math.floor((n+7)/8)*Math.floor((t+5)/6)*16;case ul:return Math.floor((n+7)/8)*Math.floor((t+7)/8)*16;case dl:return Math.floor((n+9)/10)*Math.floor((t+4)/5)*16;case fl:return Math.floor((n+9)/10)*Math.floor((t+5)/6)*16;case pl:return Math.floor((n+9)/10)*Math.floor((t+7)/8)*16;case ml:return Math.floor((n+9)/10)*Math.floor((t+9)/10)*16;case gl:return Math.floor((n+11)/12)*Math.floor((t+9)/10)*16;case xl:return Math.floor((n+11)/12)*Math.floor((t+11)/12)*16;case _l:case vl:case yl:return Math.ceil(n/4)*Math.ceil(t/4)*16;case Ml:case bl:return Math.ceil(n/4)*Math.ceil(t/4)*8;case ca:case Sl:return Math.ceil(n/4)*Math.ceil(t/4)*16}throw new Error(`Unable to determine texture byte length for ${e} format.`)}function rm(n){switch(n){case oi:case sh:return{byteLength:1,components:1};case Xs:case rh:case He:return{byteLength:2,components:1};case Vo:case Go:return{byteLength:2,components:4};case Fi:case Ho:case bi:return{byteLength:4,components:1};case ah:case oh:return{byteLength:4,components:3}}throw new Error(`THREE.TextureUtils: Unknown texture type ${n}.`)}typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("register",{detail:{revision:"186"}}));typeof window<"u"&&(window.__THREE__?kt("WARNING: Multiple instances of Three.js being imported."):window.__THREE__="186");function nf(){let n=null,t=!1,e=null,i=null;function s(r,a){i=n.requestAnimationFrame(s),e(r,a)}return{start:function(){t!==!0&&e!==null&&n!==null&&(i=n.requestAnimationFrame(s),t=!0)},stop:function(){n!==null&&n.cancelAnimationFrame(i),t=!1},setAnimationLoop:function(r){e=r},setContext:function(r){n=r}}}function hm(n){let t=new WeakMap;function e(o,l){let c=o.array,h=o.usage,d=c.byteLength,u=n.createBuffer();n.bindBuffer(l,u),n.bufferData(l,c,h),o.onUploadCallback();let f;if(c instanceof Float32Array)f=n.FLOAT;else if(typeof Float16Array<"u"&&c instanceof Float16Array)f=n.HALF_FLOAT;else if(c instanceof Uint16Array)o.isFloat16BufferAttribute?f=n.HALF_FLOAT:f=n.UNSIGNED_SHORT;else if(c instanceof Int16Array)f=n.SHORT;else if(c instanceof Uint32Array)f=n.UNSIGNED_INT;else if(c instanceof Int32Array)f=n.INT;else if(c instanceof Int8Array)f=n.BYTE;else if(c instanceof Uint8Array)f=n.UNSIGNED_BYTE;else if(c instanceof Uint8ClampedArray)f=n.UNSIGNED_BYTE;else throw new Error("THREE.WebGLAttributes: Unsupported buffer data format: "+c);return{buffer:u,type:f,bytesPerElement:c.BYTES_PER_ELEMENT,version:o.version,size:d}}function i(o,l,c){let h=l.array,d=l.updateRanges;if(n.bindBuffer(c,o),d.length===0)n.bufferSubData(c,0,h);else{d.sort((f,g)=>f.start-g.start);let u=0;for(let f=1;f<d.length;f++){let g=d[u],_=d[f];_.start<=g.start+g.count+1?g.count=Math.max(g.count,_.start+_.count-g.start):(++u,d[u]=_)}d.length=u+1;for(let f=0,g=d.length;f<g;f++){let _=d[f];n.bufferSubData(c,_.start*h.BYTES_PER_ELEMENT,h,_.start,_.count)}l.clearUpdateRanges()}l.onUploadCallback()}function s(o){return o.isInterleavedBufferAttribute&&(o=o.data),t.get(o)}function r(o){o.isInterleavedBufferAttribute&&(o=o.data);let l=t.get(o);l&&(n.deleteBuffer(l.buffer),t.delete(o))}function a(o,l){if(o.isInterleavedBufferAttribute&&(o=o.data),o.isGLBufferAttribute){let h=t.get(o);(!h||h.version<o.version)&&t.set(o,{buffer:o.buffer,type:o.type,bytesPerElement:o.elementSize,version:o.version});return}let c=t.get(o);if(c===void 0)t.set(o,e(o,l));else if(c.version<o.version){if(c.size!==o.array.byteLength)throw new Error("THREE.WebGLAttributes: The size of the buffer attribute's array buffer does not match the original size. Resizing buffer attributes is not supported.");i(c.buffer,o,l),c.version=o.version}}return{get:s,remove:r,update:a}}var um=`#ifdef USE_ALPHAHASH
	if ( diffuseColor.a < getAlphaHashThreshold( vPosition ) ) discard;
#endif`,dm=`#ifdef USE_ALPHAHASH
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
#endif`,fm=`#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, vAlphaMapUv ).g;
#endif`,pm=`#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,mm=`#ifdef USE_ALPHATEST
	#ifdef ALPHA_TO_COVERAGE
	diffuseColor.a = smoothstep( alphaTest, alphaTest + fwidth( diffuseColor.a ), diffuseColor.a );
	if ( diffuseColor.a == 0.0 ) discard;
	#else
	if ( diffuseColor.a < alphaTest ) discard;
	#endif
#endif`,gm=`#ifdef USE_ALPHATEST
	uniform float alphaTest;
#endif`,xm=`#ifdef USE_AOMAP
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
#endif`,_m=`#ifdef USE_AOMAP
	uniform sampler2D aoMap;
	uniform float aoMapIntensity;
#endif`,vm=`#ifdef USE_BATCHING
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
#endif`,ym=`#ifdef USE_BATCHING
	mat4 batchingMatrix = getBatchingMatrix( getIndirectIndex( gl_DrawID ) );
#endif`,Mm=`vec3 transformed = vec3( position );
#ifdef USE_ALPHAHASH
	vPosition = vec3( position );
#endif`,bm=`vec3 objectNormal = vec3( normal );
#ifdef USE_TANGENT
	vec3 objectTangent = vec3( tangent.xyz );
#endif`,Sm=`float G_BlinnPhong_Implicit( ) {
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
} // validated`,wm=`#ifdef USE_IRIDESCENCE
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
#endif`,Tm=`#ifdef USE_BUMPMAP
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
#endif`,Em=`#if NUM_CLIPPING_PLANES > 0
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
#endif`,Am=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];
#endif`,Rm=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
#endif`,Cm=`#if NUM_CLIPPING_PLANES > 0
	vClipPosition = - mvPosition.xyz;
#endif`,Im=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	diffuseColor *= vColor;
#endif`,Pm=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	varying vec4 vColor;
#endif`,Lm=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	varying vec4 vColor;
#endif`,Dm=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
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
#endif`,Nm=`#define PI 3.141592653589793
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
} // validated`,Um=`#ifdef ENVMAP_TYPE_CUBE_UV
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
#endif`,Fm=`vec3 transformedNormal = objectNormal;
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
#endif`,zm=`#ifdef USE_DISPLACEMENTMAP
	uniform sampler2D displacementMap;
	uniform float displacementScale;
	uniform float displacementBias;
#endif`,Bm=`#ifdef USE_DISPLACEMENTMAP
	transformed += normalize( objectNormal ) * ( texture2D( displacementMap, vDisplacementMapUv ).x * displacementScale + displacementBias );
#endif`,Om=`#ifdef USE_EMISSIVEMAP
	vec4 emissiveColor = texture2D( emissiveMap, vEmissiveMapUv );
	#ifdef DECODE_VIDEO_TEXTURE_EMISSIVE
		emissiveColor = sRGBTransferEOTF( emissiveColor );
	#endif
	totalEmissiveRadiance *= emissiveColor.rgb;
#endif`,km=`#ifdef USE_EMISSIVEMAP
	uniform sampler2D emissiveMap;
#endif`,Hm="gl_FragColor = linearToOutputTexel( gl_FragColor );",Vm=`vec4 LinearTransferOETF( in vec4 value ) {
	return value;
}
vec4 sRGBTransferEOTF( in vec4 value ) {
	return vec4( mix( pow( value.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), value.rgb * 0.0773993808, vec3( lessThanEqual( value.rgb, vec3( 0.04045 ) ) ) ), value.a );
}
vec4 sRGBTransferOETF( in vec4 value ) {
	return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}`,Gm=`#ifdef USE_ENVMAP
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
#endif`,Wm=`#ifdef USE_ENVMAP
	uniform float envMapIntensity;
	uniform mat3 envMapRotation;
	#ifdef ENVMAP_TYPE_CUBE
		uniform samplerCube envMap;
	#else
		uniform sampler2D envMap;
	#endif
#endif`,Xm=`#ifdef USE_ENVMAP
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
#endif`,qm=`#ifdef USE_ENVMAP
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		
		varying vec3 vWorldPosition;
	#else
		varying vec3 vReflect;
		uniform float refractionRatio;
	#endif
#endif`,Ym=`#ifdef USE_ENVMAP
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
#endif`,$m=`#ifdef USE_FOG
	vFogDepth = - mvPosition.z;
#endif`,Zm=`#ifdef USE_FOG
	varying float vFogDepth;
#endif`,Jm=`#ifdef USE_FOG
	#ifdef FOG_EXP2
		float fogFactor = 1.0 - exp( - fogDensity * fogDensity * vFogDepth * vFogDepth );
	#else
		float fogFactor = smoothstep( fogNear, fogFar, vFogDepth );
	#endif
	gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );
#endif`,Km=`#ifdef USE_FOG
	uniform vec3 fogColor;
	varying float vFogDepth;
	#ifdef FOG_EXP2
		uniform float fogDensity;
	#else
		uniform float fogNear;
		uniform float fogFar;
	#endif
#endif`,Qm=`#ifdef USE_GRADIENTMAP
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
}`,jm=`#ifdef USE_LIGHTMAP
	uniform sampler2D lightMap;
	uniform float lightMapIntensity;
#endif`,t0=`LambertMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularStrength = specularStrength;`,e0=`varying vec3 vViewPosition;
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
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Lambert`,i0=`uniform bool receiveShadow;
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
#include <lightprobes_pars_fragment>`,n0=`#ifdef USE_ENVMAP
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
#endif`,s0=`ToonMaterial material;
material.diffuseColor = diffuseColor.rgb;`,r0=`varying vec3 vViewPosition;
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
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Toon`,a0=`BlinnPhongMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularColor = specular;
material.specularShininess = shininess;
material.specularStrength = specularStrength;`,o0=`varying vec3 vViewPosition;
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
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong`,l0=`PhysicalMaterial material;
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
#endif`,c0=`uniform sampler2D dfgLUT;
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
}`,h0=`
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
#endif`,u0=`#if defined( RE_IndirectDiffuse )
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
#endif`,d0=`#if defined( RE_IndirectDiffuse )
	#if defined( LAMBERT ) || defined( PHONG )
		irradiance += iblIrradiance;
	#endif
	RE_IndirectDiffuse( irradiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif
#if defined( RE_IndirectSpecular )
	RE_IndirectSpecular( radiance, iblIrradiance, clearcoatRadiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif`,f0=`#ifdef USE_LIGHT_PROBES_GRID
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
#endif`,p0=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	gl_FragDepth = vIsPerspective == 0.0 ? gl_FragCoord.z : log2( vFragDepth ) * logDepthBufFC * 0.5;
#endif`,m0=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	uniform float logDepthBufFC;
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,g0=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,x0=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	vFragDepth = 1.0 + gl_Position.w;
	vIsPerspective = float( isPerspectiveMatrix( projectionMatrix ) );
#endif`,_0=`#ifdef USE_MAP
	vec4 sampledDiffuseColor = texture2D( map, vMapUv );
	#ifdef DECODE_VIDEO_TEXTURE
		sampledDiffuseColor = sRGBTransferEOTF( sampledDiffuseColor );
	#endif
	diffuseColor *= sampledDiffuseColor;
#endif`,v0=`#ifdef USE_MAP
	uniform sampler2D map;
#endif`,y0=`#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
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
#endif`,M0=`#if defined( USE_POINTS_UV )
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
#endif`,b0=`float metalnessFactor = metalness;
#ifdef USE_METALNESSMAP
	vec4 texelMetalness = texture2D( metalnessMap, vMetalnessMapUv );
	metalnessFactor *= texelMetalness.b;
#endif`,S0=`#ifdef USE_METALNESSMAP
	uniform sampler2D metalnessMap;
#endif`,w0=`#ifdef USE_INSTANCING_MORPH
	float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	float morphTargetBaseInfluence = texelFetch( morphTexture, ivec2( 0, gl_InstanceID ), 0 ).r;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		morphTargetInfluences[i] =  texelFetch( morphTexture, ivec2( i + 1, gl_InstanceID ), 0 ).r;
	}
#endif`,T0=`#if defined( USE_MORPHCOLORS )
	vColor *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		#if defined( USE_COLOR_ALPHA )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ) * morphTargetInfluences[ i ];
		#elif defined( USE_COLOR )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ).rgb * morphTargetInfluences[ i ];
		#endif
	}
#endif`,E0=`#ifdef USE_MORPHNORMALS
	objectNormal *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) objectNormal += getMorph( gl_VertexID, i, 1 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,A0=`#ifdef USE_MORPHTARGETS
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
#endif`,R0=`#ifdef USE_MORPHTARGETS
	transformed *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) transformed += getMorph( gl_VertexID, i, 0 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,C0=`float faceDirection = gl_FrontFacing ? 1.0 : - 1.0;
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
vec3 nonPerturbedNormal = normal;`,I0=`#ifdef USE_NORMALMAP_OBJECTSPACE
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
#endif`,P0=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,L0=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,D0=`#ifndef FLAT_SHADED
	vNormal = normalize( transformedNormal );
	#ifdef USE_TANGENT
		vTangent = normalize( transformedTangent );
		vBitangent = normalize( cross( vNormal, vTangent ) * tangent.w );
		#ifdef FLIP_SIDED
			vBitangent = - vBitangent;
		#endif
	#endif
#endif`,N0=`#ifdef USE_NORMALMAP
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
#endif`,U0=`#ifdef USE_CLEARCOAT
	vec3 clearcoatNormal = nonPerturbedNormal;
#endif`,F0=`#ifdef USE_CLEARCOAT_NORMALMAP
	vec3 clearcoatMapN = texture2D( clearcoatNormalMap, vClearcoatNormalMapUv ).xyz * 2.0 - 1.0;
	clearcoatMapN.xy *= clearcoatNormalScale;
	clearcoatNormal = normalize( tbn2 * clearcoatMapN );
#endif`,z0=`#ifdef USE_CLEARCOATMAP
	uniform sampler2D clearcoatMap;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform sampler2D clearcoatNormalMap;
	uniform vec2 clearcoatNormalScale;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform sampler2D clearcoatRoughnessMap;
#endif`,B0=`#ifdef USE_IRIDESCENCEMAP
	uniform sampler2D iridescenceMap;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform sampler2D iridescenceThicknessMap;
#endif`,O0=`#ifdef OPAQUE
diffuseColor.a = 1.0;
#endif
#ifdef USE_TRANSMISSION
diffuseColor.a *= material.transmissionAlpha;
#endif
gl_FragColor = vec4( outgoingLight, diffuseColor.a );`,k0=`vec3 packNormalToRGB( const in vec3 normal ) {
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
}`,H0=`#ifdef PREMULTIPLIED_ALPHA
	gl_FragColor.rgb *= gl_FragColor.a;
#endif`,V0=`vec4 mvPosition = vec4( transformed, 1.0 );
#ifdef USE_BATCHING
	mvPosition = batchingMatrix * mvPosition;
#endif
#ifdef USE_INSTANCING
	mvPosition = instanceMatrix * mvPosition;
#endif
mvPosition = modelViewMatrix * mvPosition;
gl_Position = projectionMatrix * mvPosition;`,G0=`#ifdef DITHERING
	gl_FragColor.rgb = dithering( gl_FragColor.rgb );
#endif`,W0=`#ifdef DITHERING
	vec3 dithering( vec3 color ) {
		float grid_position = rand( gl_FragCoord.xy );
		vec3 dither_shift_RGB = vec3( 0.25 / 255.0, -0.25 / 255.0, 0.25 / 255.0 );
		dither_shift_RGB = mix( 2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position );
		return color + dither_shift_RGB;
	}
#endif`,X0=`float roughnessFactor = roughness;
#ifdef USE_ROUGHNESSMAP
	vec4 texelRoughness = texture2D( roughnessMap, vRoughnessMapUv );
	roughnessFactor *= texelRoughness.g;
#endif`,q0=`#ifdef USE_ROUGHNESSMAP
	uniform sampler2D roughnessMap;
#endif`,Y0=`#if NUM_SPOT_LIGHT_COORDS > 0
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
#endif`,$0=`#if NUM_SPOT_LIGHT_COORDS > 0
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
#endif`,Z0=`#if ( defined( USE_SHADOWMAP ) && ( NUM_DIR_LIGHT_SHADOWS > 0 || NUM_SUN_LIGHT_SHADOWS > 0 || NUM_POINT_LIGHT_SHADOWS > 0 ) ) || ( NUM_SPOT_LIGHT_COORDS > 0 )
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
#endif`,J0=`float getShadowMask() {
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
}`,K0=`#ifdef USE_SKINNING
	mat4 boneMatX = getBoneMatrix( skinIndex.x );
	mat4 boneMatY = getBoneMatrix( skinIndex.y );
	mat4 boneMatZ = getBoneMatrix( skinIndex.z );
	mat4 boneMatW = getBoneMatrix( skinIndex.w );
#endif`,Q0=`#ifdef USE_SKINNING
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
#endif`,j0=`#ifdef USE_SKINNING
	vec4 skinVertex = bindMatrix * vec4( transformed, 1.0 );
	vec4 skinned = vec4( 0.0 );
	skinned += boneMatX * skinVertex * skinWeight.x;
	skinned += boneMatY * skinVertex * skinWeight.y;
	skinned += boneMatZ * skinVertex * skinWeight.z;
	skinned += boneMatW * skinVertex * skinWeight.w;
	transformed = ( bindMatrixInverse * skinned ).xyz;
#endif`,tg=`#ifdef USE_SKINNING
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
#endif`,eg=`float specularStrength;
#ifdef USE_SPECULARMAP
	vec4 texelSpecular = texture2D( specularMap, vSpecularMapUv );
	specularStrength = texelSpecular.r;
#else
	specularStrength = 1.0;
#endif`,ig=`#ifdef USE_SPECULARMAP
	uniform sampler2D specularMap;
#endif`,ng=`#if defined( TONE_MAPPING )
	gl_FragColor.rgb = toneMapping( gl_FragColor.rgb );
#endif`,sg=`#ifndef saturate
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
vec3 CustomToneMapping( vec3 color ) { return color; }`,rg=`#ifdef USE_TRANSMISSION
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
#endif`,ag=`#ifdef USE_TRANSMISSION
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
#endif`,og=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
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
#endif`,lg=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
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
#endif`,cg=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
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
#endif`,hg=`#if defined( USE_ENVMAP ) || defined( DISTANCE ) || defined ( USE_SHADOWMAP ) || defined ( USE_TRANSMISSION ) || NUM_SPOT_LIGHT_COORDS > 0
	vec4 worldPosition = vec4( transformed, 1.0 );
	#ifdef USE_BATCHING
		worldPosition = batchingMatrix * worldPosition;
	#endif
	#ifdef USE_INSTANCING
		worldPosition = instanceMatrix * worldPosition;
	#endif
	worldPosition = modelMatrix * worldPosition;
#endif`,ug=`varying vec2 vUv;
uniform mat3 uvTransform;
void main() {
	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	gl_Position = vec4( position.xy, 1.0, 1.0 );
}`,dg=`uniform sampler2D t2D;
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
}`,fg=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,pg=`#ifdef ENVMAP_TYPE_CUBE
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
}`,mg=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,gg=`uniform samplerCube tCube;
uniform float tFlip;
uniform float opacity;
varying vec3 vWorldDirection;
void main() {
	vec4 texColor = textureCube( tCube, vec3( tFlip * vWorldDirection.x, vWorldDirection.yz ) );
	gl_FragColor = texColor;
	gl_FragColor.a *= opacity;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,xg=`#include <common>
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
}`,_g=`#if DEPTH_PACKING == 3200
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
}`,vg=`#define DISTANCE
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
}`,yg=`#define DISTANCE
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
}`,Mg=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
}`,bg=`uniform sampler2D tEquirect;
varying vec3 vWorldDirection;
#include <common>
void main() {
	vec3 direction = normalize( vWorldDirection );
	vec2 sampleUV = equirectUv( direction );
	gl_FragColor = texture2D( tEquirect, sampleUV );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,Sg=`uniform float scale;
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
}`,wg=`uniform vec3 diffuse;
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
}`,Tg=`#include <common>
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
}`,Eg=`uniform vec3 diffuse;
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
}`,Ag=`#define LAMBERT
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
}`,Rg=`#define LAMBERT
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
}`,Cg=`#define MATCAP
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
}`,Ig=`#define MATCAP
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
}`,Pg=`#define NORMAL
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
}`,Lg=`#define NORMAL
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
}`,Dg=`#define PHONG
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
}`,Ng=`#define PHONG
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
}`,Ug=`#define STANDARD
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
}`,Fg=`#define STANDARD
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
}`,zg=`#define TOON
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
}`,Bg=`#define TOON
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
}`,Og=`uniform float size;
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
}`,kg=`uniform vec3 diffuse;
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
}`,Hg=`#include <common>
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
}`,Vg=`uniform vec3 color;
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
}`,Gg=`uniform float rotation;
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
}`,Wg=`uniform vec3 diffuse;
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
}`,Jt={alphahash_fragment:um,alphahash_pars_fragment:dm,alphamap_fragment:fm,alphamap_pars_fragment:pm,alphatest_fragment:mm,alphatest_pars_fragment:gm,aomap_fragment:xm,aomap_pars_fragment:_m,batching_pars_vertex:vm,batching_vertex:ym,begin_vertex:Mm,beginnormal_vertex:bm,bsdfs:Sm,iridescence_fragment:wm,bumpmap_pars_fragment:Tm,clipping_planes_fragment:Em,clipping_planes_pars_fragment:Am,clipping_planes_pars_vertex:Rm,clipping_planes_vertex:Cm,color_fragment:Im,color_pars_fragment:Pm,color_pars_vertex:Lm,color_vertex:Dm,common:Nm,cube_uv_reflection_fragment:Um,defaultnormal_vertex:Fm,displacementmap_pars_vertex:zm,displacementmap_vertex:Bm,emissivemap_fragment:Om,emissivemap_pars_fragment:km,colorspace_fragment:Hm,colorspace_pars_fragment:Vm,envmap_fragment:Gm,envmap_common_pars_fragment:Wm,envmap_pars_fragment:Xm,envmap_pars_vertex:qm,envmap_physical_pars_fragment:n0,envmap_vertex:Ym,fog_vertex:$m,fog_pars_vertex:Zm,fog_fragment:Jm,fog_pars_fragment:Km,gradientmap_pars_fragment:Qm,lightmap_pars_fragment:jm,lights_lambert_fragment:t0,lights_lambert_pars_fragment:e0,lights_pars_begin:i0,lights_toon_fragment:s0,lights_toon_pars_fragment:r0,lights_phong_fragment:a0,lights_phong_pars_fragment:o0,lights_physical_fragment:l0,lights_physical_pars_fragment:c0,lights_fragment_begin:h0,lights_fragment_maps:u0,lights_fragment_end:d0,lightprobes_pars_fragment:f0,logdepthbuf_fragment:p0,logdepthbuf_pars_fragment:m0,logdepthbuf_pars_vertex:g0,logdepthbuf_vertex:x0,map_fragment:_0,map_pars_fragment:v0,map_particle_fragment:y0,map_particle_pars_fragment:M0,metalnessmap_fragment:b0,metalnessmap_pars_fragment:S0,morphinstance_vertex:w0,morphcolor_vertex:T0,morphnormal_vertex:E0,morphtarget_pars_vertex:A0,morphtarget_vertex:R0,normal_fragment_begin:C0,normal_fragment_maps:I0,normal_pars_fragment:P0,normal_pars_vertex:L0,normal_vertex:D0,normalmap_pars_fragment:N0,clearcoat_normal_fragment_begin:U0,clearcoat_normal_fragment_maps:F0,clearcoat_pars_fragment:z0,iridescence_pars_fragment:B0,opaque_fragment:O0,packing:k0,premultiplied_alpha_fragment:H0,project_vertex:V0,dithering_fragment:G0,dithering_pars_fragment:W0,roughnessmap_fragment:X0,roughnessmap_pars_fragment:q0,shadowmap_pars_fragment:Y0,shadowmap_pars_vertex:$0,shadowmap_vertex:Z0,shadowmask_pars_fragment:J0,skinbase_vertex:K0,skinning_pars_vertex:Q0,skinning_vertex:j0,skinnormal_vertex:tg,specularmap_fragment:eg,specularmap_pars_fragment:ig,tonemapping_fragment:ng,tonemapping_pars_fragment:sg,transmission_fragment:rg,transmission_pars_fragment:ag,uv_pars_fragment:og,uv_pars_vertex:lg,uv_vertex:cg,worldpos_vertex:hg,background_vert:ug,background_frag:dg,backgroundCube_vert:fg,backgroundCube_frag:pg,cube_vert:mg,cube_frag:gg,depth_vert:xg,depth_frag:_g,distance_vert:vg,distance_frag:yg,equirect_vert:Mg,equirect_frag:bg,linedashed_vert:Sg,linedashed_frag:wg,meshbasic_vert:Tg,meshbasic_frag:Eg,meshlambert_vert:Ag,meshlambert_frag:Rg,meshmatcap_vert:Cg,meshmatcap_frag:Ig,meshnormal_vert:Pg,meshnormal_frag:Lg,meshphong_vert:Dg,meshphong_frag:Ng,meshphysical_vert:Ug,meshphysical_frag:Fg,meshtoon_vert:zg,meshtoon_frag:Bg,points_vert:Og,points_frag:kg,shadow_vert:Hg,shadow_frag:Vg,sprite_vert:Gg,sprite_frag:Wg},mt={common:{diffuse:{value:new Ut(16777215)},opacity:{value:1},map:{value:null},mapTransform:{value:new Xt},alphaMap:{value:null},alphaMapTransform:{value:new Xt},alphaTest:{value:0}},specularmap:{specularMap:{value:null},specularMapTransform:{value:new Xt}},envmap:{envMap:{value:null},envMapRotation:{value:new Xt},reflectivity:{value:1},ior:{value:1.5},refractionRatio:{value:.98},dfgLUT:{value:null}},aomap:{aoMap:{value:null},aoMapIntensity:{value:1},aoMapTransform:{value:new Xt}},lightmap:{lightMap:{value:null},lightMapIntensity:{value:1},lightMapTransform:{value:new Xt}},bumpmap:{bumpMap:{value:null},bumpMapTransform:{value:new Xt},bumpScale:{value:1}},normalmap:{normalMap:{value:null},normalMapTransform:{value:new Xt},normalScale:{value:new xt(1,1)}},displacementmap:{displacementMap:{value:null},displacementMapTransform:{value:new Xt},displacementScale:{value:1},displacementBias:{value:0}},emissivemap:{emissiveMap:{value:null},emissiveMapTransform:{value:new Xt}},metalnessmap:{metalnessMap:{value:null},metalnessMapTransform:{value:new Xt}},roughnessmap:{roughnessMap:{value:null},roughnessMapTransform:{value:new Xt}},gradientmap:{gradientMap:{value:null}},fog:{fogDensity:{value:25e-5},fogNear:{value:1},fogFar:{value:2e3},fogColor:{value:new Ut(16777215)}},lights:{ambientLightColor:{value:[]},lightProbe:{value:[]},sunLights:{value:[],properties:{direction:{},color:{}}},sunLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},sunShadowMatrix:{value:[]},sunShadowCascade:{value:[]},directionalLights:{value:[],properties:{direction:{},color:{}}},directionalLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},directionalShadowMatrix:{value:[]},spotLights:{value:[],properties:{color:{},position:{},direction:{},distance:{},coneCos:{},penumbraCos:{},decay:{}}},spotLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},spotLightMap:{value:[]},spotLightMatrix:{value:[]},pointLights:{value:[],properties:{color:{},position:{},decay:{},distance:{}}},pointLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{},shadowCameraNear:{},shadowCameraFar:{}}},pointShadowMatrix:{value:[]},hemisphereLights:{value:[],properties:{direction:{},skyColor:{},groundColor:{}}},rectAreaLights:{value:[],properties:{color:{},position:{},width:{},height:{}}},ltc_1:{value:null},ltc_2:{value:null},probesSH:{value:null},probesMin:{value:new N},probesMax:{value:new N},probesResolution:{value:new N}},points:{diffuse:{value:new Ut(16777215)},opacity:{value:1},size:{value:1},scale:{value:1},map:{value:null},alphaMap:{value:null},alphaMapTransform:{value:new Xt},alphaTest:{value:0},uvTransform:{value:new Xt}},sprite:{diffuse:{value:new Ut(16777215)},opacity:{value:1},center:{value:new xt(.5,.5)},rotation:{value:0},map:{value:null},mapTransform:{value:new Xt},alphaMap:{value:null},alphaMapTransform:{value:new Xt},alphaTest:{value:0}}},Zi={basic:{uniforms:ii([mt.common,mt.specularmap,mt.envmap,mt.aomap,mt.lightmap,mt.fog]),vertexShader:Jt.meshbasic_vert,fragmentShader:Jt.meshbasic_frag},lambert:{uniforms:ii([mt.common,mt.specularmap,mt.envmap,mt.aomap,mt.lightmap,mt.emissivemap,mt.bumpmap,mt.normalmap,mt.displacementmap,mt.fog,mt.lights,{emissive:{value:new Ut(0)},envMapIntensity:{value:1}}]),vertexShader:Jt.meshlambert_vert,fragmentShader:Jt.meshlambert_frag},phong:{uniforms:ii([mt.common,mt.specularmap,mt.envmap,mt.aomap,mt.lightmap,mt.emissivemap,mt.bumpmap,mt.normalmap,mt.displacementmap,mt.fog,mt.lights,{emissive:{value:new Ut(0)},specular:{value:new Ut(1118481)},shininess:{value:30},envMapIntensity:{value:1}}]),vertexShader:Jt.meshphong_vert,fragmentShader:Jt.meshphong_frag},standard:{uniforms:ii([mt.common,mt.envmap,mt.aomap,mt.lightmap,mt.emissivemap,mt.bumpmap,mt.normalmap,mt.displacementmap,mt.roughnessmap,mt.metalnessmap,mt.fog,mt.lights,{emissive:{value:new Ut(0)},roughness:{value:1},metalness:{value:0},envMapIntensity:{value:1}}]),vertexShader:Jt.meshphysical_vert,fragmentShader:Jt.meshphysical_frag},toon:{uniforms:ii([mt.common,mt.aomap,mt.lightmap,mt.emissivemap,mt.bumpmap,mt.normalmap,mt.displacementmap,mt.gradientmap,mt.fog,mt.lights,{emissive:{value:new Ut(0)}}]),vertexShader:Jt.meshtoon_vert,fragmentShader:Jt.meshtoon_frag},matcap:{uniforms:ii([mt.common,mt.bumpmap,mt.normalmap,mt.displacementmap,mt.fog,{matcap:{value:null}}]),vertexShader:Jt.meshmatcap_vert,fragmentShader:Jt.meshmatcap_frag},points:{uniforms:ii([mt.points,mt.fog]),vertexShader:Jt.points_vert,fragmentShader:Jt.points_frag},dashed:{uniforms:ii([mt.common,mt.fog,{scale:{value:1},dashSize:{value:1},totalSize:{value:2}}]),vertexShader:Jt.linedashed_vert,fragmentShader:Jt.linedashed_frag},depth:{uniforms:ii([mt.common,mt.displacementmap]),vertexShader:Jt.depth_vert,fragmentShader:Jt.depth_frag},normal:{uniforms:ii([mt.common,mt.bumpmap,mt.normalmap,mt.displacementmap,{opacity:{value:1}}]),vertexShader:Jt.meshnormal_vert,fragmentShader:Jt.meshnormal_frag},sprite:{uniforms:ii([mt.sprite,mt.fog]),vertexShader:Jt.sprite_vert,fragmentShader:Jt.sprite_frag},background:{uniforms:{uvTransform:{value:new Xt},t2D:{value:null},backgroundIntensity:{value:1}},vertexShader:Jt.background_vert,fragmentShader:Jt.background_frag},backgroundCube:{uniforms:{envMap:{value:null},backgroundBlurriness:{value:0},backgroundIntensity:{value:1},backgroundRotation:{value:new Xt}},vertexShader:Jt.backgroundCube_vert,fragmentShader:Jt.backgroundCube_frag},cube:{uniforms:{tCube:{value:null},tFlip:{value:-1},opacity:{value:1}},vertexShader:Jt.cube_vert,fragmentShader:Jt.cube_frag},equirect:{uniforms:{tEquirect:{value:null}},vertexShader:Jt.equirect_vert,fragmentShader:Jt.equirect_frag},distance:{uniforms:ii([mt.common,mt.displacementmap,{referencePosition:{value:new N},nearDistance:{value:1},farDistance:{value:1e3}}]),vertexShader:Jt.distance_vert,fragmentShader:Jt.distance_frag},shadow:{uniforms:ii([mt.lights,mt.fog,{color:{value:new Ut(0)},opacity:{value:1}}]),vertexShader:Jt.shadow_vert,fragmentShader:Jt.shadow_frag}};Zi.physical={uniforms:ii([Zi.standard.uniforms,{clearcoat:{value:0},clearcoatMap:{value:null},clearcoatMapTransform:{value:new Xt},clearcoatNormalMap:{value:null},clearcoatNormalMapTransform:{value:new Xt},clearcoatNormalScale:{value:new xt(1,1)},clearcoatRoughness:{value:0},clearcoatRoughnessMap:{value:null},clearcoatRoughnessMapTransform:{value:new Xt},dispersion:{value:0},retroreflectivity:{value:0},iridescence:{value:0},iridescenceMap:{value:null},iridescenceMapTransform:{value:new Xt},iridescenceIOR:{value:1.3},iridescenceThicknessMinimum:{value:100},iridescenceThicknessMaximum:{value:400},iridescenceThicknessMap:{value:null},iridescenceThicknessMapTransform:{value:new Xt},sheen:{value:0},sheenColor:{value:new Ut(0)},sheenColorMap:{value:null},sheenColorMapTransform:{value:new Xt},sheenRoughness:{value:1},sheenRoughnessMap:{value:null},sheenRoughnessMapTransform:{value:new Xt},transmission:{value:0},transmissionMap:{value:null},transmissionMapTransform:{value:new Xt},transmissionSamplerSize:{value:new xt},transmissionSamplerMap:{value:null},thickness:{value:0},thicknessMap:{value:null},thicknessMapTransform:{value:new Xt},attenuationDistance:{value:0},attenuationColor:{value:new Ut(0)},specularColor:{value:new Ut(1,1,1)},specularColorMap:{value:null},specularColorMapTransform:{value:new Xt},specularIntensity:{value:1},specularIntensityMap:{value:null},specularIntensityMapTransform:{value:new Xt},anisotropyVector:{value:new xt},anisotropyMap:{value:null},anisotropyMapTransform:{value:new Xt}}]),vertexShader:Jt.meshphysical_vert,fragmentShader:Jt.meshphysical_frag};var El={r:0,b:0,g:0},Xg=new oe,sf=new Xt;sf.set(-1,0,0,0,1,0,0,0,1);function qg(n,t,e,i,s,r){let a=new Ut(0),o=s===!0?0:1,l,c,h=null,d=0,u=null;function f(M){let R=M.isScene===!0?M.background:null;if(R&&R.isTexture){let y=M.backgroundBlurriness>0;R=t.get(R,y)}return R}function g(M){let R=!1,y=f(M);y===null?m(a,o):y&&y.isColor&&(m(y,1),R=!0);let w=n.xr.getEnvironmentBlendMode();w==="additive"?e.buffers.color.setClear(0,0,0,1,r):w==="alpha-blend"&&e.buffers.color.setClear(0,0,0,0,r),(n.autoClear||R)&&(e.buffers.depth.setTest(!0),e.buffers.depth.setMask(!0),e.buffers.color.setMask(!0),n.clear(n.autoClearColor,n.autoClearDepth,n.autoClearStencil))}function _(M,R){let y=f(R);y&&(y.isCubeTexture||y.mapping===ia)?(c===void 0&&(c=new Tt(new $e(1,1,1),new Te({name:"BackgroundCubeMaterial",uniforms:is(Zi.backgroundCube.uniforms),vertexShader:Zi.backgroundCube.vertexShader,fragmentShader:Zi.backgroundCube.fragmentShader,side:Ze,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),c.geometry.deleteAttribute("normal"),c.geometry.deleteAttribute("uv"),c.onBeforeRender=function(w,S,I){this.matrixWorld.copyPosition(I.matrixWorld)},Object.defineProperty(c.material,"envMap",{get:function(){return this.uniforms.envMap.value}}),i.update(c)),c.material.uniforms.envMap.value=y,c.material.uniforms.backgroundBlurriness.value=R.backgroundBlurriness,c.material.uniforms.backgroundIntensity.value=R.backgroundIntensity,c.material.uniforms.backgroundRotation.value.setFromMatrix4(Xg.makeRotationFromEuler(R.backgroundRotation)).transpose(),y.isCubeTexture&&y.isRenderTargetTexture===!1&&c.material.uniforms.backgroundRotation.value.premultiply(sf),c.material.toneMapped=Qt.getTransfer(y.colorSpace)!==ae,(h!==y||d!==y.version||u!==n.toneMapping)&&(c.material.needsUpdate=!0,h=y,d=y.version,u=n.toneMapping),c.layers.enableAll(),M.unshift(c,c.geometry,c.material,0,0,null)):y&&y.isTexture&&(l===void 0&&(l=new Tt(new qi(2,2),new Te({name:"BackgroundMaterial",uniforms:is(Zi.background.uniforms),vertexShader:Zi.background.vertexShader,fragmentShader:Zi.background.fragmentShader,side:Dn,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),l.geometry.deleteAttribute("normal"),Object.defineProperty(l.material,"map",{get:function(){return this.uniforms.t2D.value}}),i.update(l)),l.material.uniforms.t2D.value=y,l.material.uniforms.backgroundIntensity.value=R.backgroundIntensity,l.material.toneMapped=Qt.getTransfer(y.colorSpace)!==ae,y.matrixAutoUpdate===!0&&y.updateMatrix(),l.material.uniforms.uvTransform.value.copy(y.matrix),(h!==y||d!==y.version||u!==n.toneMapping)&&(l.material.needsUpdate=!0,h=y,d=y.version,u=n.toneMapping),l.layers.enableAll(),M.unshift(l,l.geometry,l.material,0,0,null))}function m(M,R){M.getRGB(El,ph(n)),e.buffers.color.setClear(El.r,El.g,El.b,R,r)}function p(){c!==void 0&&(c.geometry.dispose(),c.material.dispose(),c=void 0),l!==void 0&&(l.geometry.dispose(),l.material.dispose(),l=void 0)}return{getClearColor:function(){return a},setClearColor:function(M,R=1){a.set(M),o=R,m(a,o)},getClearAlpha:function(){return o},setClearAlpha:function(M){o=M,m(a,o)},render:g,addToRenderList:_,dispose:p}}function Yg(n,t){let e=n.getParameter(n.MAX_VERTEX_ATTRIBS),i={},s=u(null),r=s,a=!1;function o(O,L,z,D,k){let Y=!1,q=d(O,D,z,L);r!==q&&(r=q,c(r.object)),Y=f(O,D,z,k),Y&&g(O,D,z,k),k!==null&&t.update(k,n.ELEMENT_ARRAY_BUFFER),(Y||a)&&(a=!1,y(O,L,z,D),k!==null&&n.bindBuffer(n.ELEMENT_ARRAY_BUFFER,t.get(k).buffer))}function l(){return n.createVertexArray()}function c(O){return n.bindVertexArray(O)}function h(O){return n.deleteVertexArray(O)}function d(O,L,z,D){let k=D.wireframe===!0,Y=i[L.id];Y===void 0&&(Y={},i[L.id]=Y);let q=O.isInstancedMesh===!0?O.id:0,Z=Y[q];Z===void 0&&(Z={},Y[q]=Z);let V=Z[z.id];V===void 0&&(V={},Z[z.id]=V);let tt=V[k];return tt===void 0&&(tt=u(l()),V[k]=tt),tt}function u(O){let L=[],z=[],D=[];for(let k=0;k<e;k++)L[k]=0,z[k]=0,D[k]=0;return{geometry:null,program:null,wireframe:!1,newAttributes:L,enabledAttributes:z,attributeDivisors:D,object:O,attributes:{},index:null}}function f(O,L,z,D){let k=r.attributes,Y=L.attributes,q=0,Z=z.getAttributes();for(let V in Z)if(Z[V].location>=0){let rt=k[V],St=Y[V];if(St===void 0&&(V==="instanceMatrix"&&O.instanceMatrix&&(St=O.instanceMatrix),V==="instanceColor"&&O.instanceColor&&(St=O.instanceColor)),rt===void 0||rt.attribute!==St||St&&rt.data!==St.data)return!0;q++}return r.attributesNum!==q||r.index!==D}function g(O,L,z,D){let k={},Y=L.attributes,q=0,Z=z.getAttributes();for(let V in Z)if(Z[V].location>=0){let rt=Y[V];rt===void 0&&(V==="instanceMatrix"&&O.instanceMatrix&&(rt=O.instanceMatrix),V==="instanceColor"&&O.instanceColor&&(rt=O.instanceColor));let St={};St.attribute=rt,rt&&rt.data&&(St.data=rt.data),k[V]=St,q++}r.attributes=k,r.attributesNum=q,r.index=D}function _(){let O=r.newAttributes;for(let L=0,z=O.length;L<z;L++)O[L]=0}function m(O){p(O,0)}function p(O,L){let z=r.newAttributes,D=r.enabledAttributes,k=r.attributeDivisors;z[O]=1,D[O]===0&&(n.enableVertexAttribArray(O),D[O]=1),k[O]!==L&&(n.vertexAttribDivisor(O,L),k[O]=L)}function M(){let O=r.newAttributes,L=r.enabledAttributes;for(let z=0,D=L.length;z<D;z++)L[z]!==O[z]&&(n.disableVertexAttribArray(z),L[z]=0)}function R(O,L,z,D,k,Y,q){q===!0?n.vertexAttribIPointer(O,L,z,k,Y):n.vertexAttribPointer(O,L,z,D,k,Y)}function y(O,L,z,D){_();let k=D.attributes,Y=z.getAttributes(),q=L.defaultAttributeValues;for(let Z in Y){let V=Y[Z];if(V.location>=0){let tt=k[Z];if(tt===void 0&&(Z==="instanceMatrix"&&O.instanceMatrix&&(tt=O.instanceMatrix),Z==="instanceColor"&&O.instanceColor&&(tt=O.instanceColor)),tt!==void 0){let rt=tt.normalized,St=tt.itemSize,_t=t.get(tt);if(_t===void 0)continue;let ee=_t.buffer,Ct=_t.type,$t=_t.bytesPerElement,Q=Ct===n.INT||Ct===n.UNSIGNED_INT||tt.gpuType===Ho;if(tt.isInterleavedBufferAttribute){let it=tt.data,Mt=it.stride,Ot=tt.offset;if(it.isInstancedInterleavedBuffer){for(let yt=0;yt<V.locationSize;yt++)p(V.location+yt,it.meshPerAttribute);O.isInstancedMesh!==!0&&D._maxInstanceCount===void 0&&(D._maxInstanceCount=it.meshPerAttribute*it.count)}else for(let yt=0;yt<V.locationSize;yt++)m(V.location+yt);n.bindBuffer(n.ARRAY_BUFFER,ee);for(let yt=0;yt<V.locationSize;yt++)R(V.location+yt,St/V.locationSize,Ct,rt,Mt*$t,(Ot+St/V.locationSize*yt)*$t,Q)}else{if(tt.isInstancedBufferAttribute){for(let it=0;it<V.locationSize;it++)p(V.location+it,tt.meshPerAttribute);O.isInstancedMesh!==!0&&D._maxInstanceCount===void 0&&(D._maxInstanceCount=tt.meshPerAttribute*tt.count)}else for(let it=0;it<V.locationSize;it++)m(V.location+it);n.bindBuffer(n.ARRAY_BUFFER,ee);for(let it=0;it<V.locationSize;it++)R(V.location+it,St/V.locationSize,Ct,rt,St*$t,St/V.locationSize*it*$t,Q)}}else if(q!==void 0){let rt=q[Z];if(rt!==void 0)switch(rt.length){case 2:n.vertexAttrib2fv(V.location,rt);break;case 3:n.vertexAttrib3fv(V.location,rt);break;case 4:n.vertexAttrib4fv(V.location,rt);break;default:n.vertexAttrib1fv(V.location,rt)}}}}M()}function w(){A();for(let O in i){let L=i[O];for(let z in L){let D=L[z];for(let k in D){let Y=D[k];for(let q in Y)h(Y[q].object),delete Y[q];delete D[k]}}delete i[O]}}function S(O){if(i[O.id]===void 0)return;let L=i[O.id];for(let z in L){let D=L[z];for(let k in D){let Y=D[k];for(let q in Y)h(Y[q].object),delete Y[q];delete D[k]}}delete i[O.id]}function I(O){for(let L in i){let z=i[L];for(let D in z){let k=z[D];if(k[O.id]===void 0)continue;let Y=k[O.id];for(let q in Y)h(Y[q].object),delete Y[q];delete k[O.id]}}}function v(O){for(let L in i){let z=i[L],D=O.isInstancedMesh===!0?O.id:0,k=z[D];if(k!==void 0){for(let Y in k){let q=k[Y];for(let Z in q)h(q[Z].object),delete q[Z];delete k[Y]}delete z[D],Object.keys(z).length===0&&delete i[L]}}}function A(){P(),a=!0,r!==s&&(r=s,c(r.object))}function P(){s.geometry=null,s.program=null,s.wireframe=!1}return{setup:o,reset:A,resetDefaultState:P,dispose:w,releaseStatesOfGeometry:S,releaseStatesOfObject:v,releaseStatesOfProgram:I,initAttributes:_,enableAttribute:m,disableUnusedAttributes:M}}function $g(n,t,e){let i;function s(l){i=l}function r(l,c){n.drawArrays(i,l,c),e.update(c,i,1)}function a(l,c,h){h!==0&&(n.drawArraysInstanced(i,l,c,h),e.update(c,i,h))}function o(l,c,h){if(h===0)return;t.get("WEBGL_multi_draw").multiDrawArraysWEBGL(i,l,0,c,0,h);let u=0;for(let f=0;f<h;f++)u+=c[f];e.update(u,i,1)}this.setMode=s,this.render=r,this.renderInstances=a,this.renderMultiDraw=o}function Zg(n,t,e,i){let s;function r(){if(s!==void 0)return s;if(t.has("EXT_texture_filter_anisotropic")===!0){let I=t.get("EXT_texture_filter_anisotropic");s=n.getParameter(I.MAX_TEXTURE_MAX_ANISOTROPY_EXT)}else s=0;return s}function a(I){return!(I!==Si&&i.convert(I)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_FORMAT))}function o(I){let v=I===He&&(t.has("EXT_color_buffer_half_float")||t.has("EXT_color_buffer_float"));return!(I!==oi&&I!==bi&&!v&&i.convert(I)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_TYPE))}function l(I){if(I==="highp"){if(n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.HIGH_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.HIGH_FLOAT).precision>0)return"highp";I="mediump"}return I==="mediump"&&n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.MEDIUM_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.MEDIUM_FLOAT).precision>0?"mediump":"lowp"}let c=e.precision!==void 0?e.precision:"highp",h=l(c);h!==c&&(kt("WebGLRenderer:",c,"not supported, using",h,"instead."),c=h);let d=e.logarithmicDepthBuffer===!0,u=e.reversedDepthBuffer===!0&&t.has("EXT_clip_control");e.reversedDepthBuffer===!0&&u===!1&&kt("WebGLRenderer: Unable to use reversed depth buffer due to missing EXT_clip_control extension. Fallback to default depth buffer.");let f=n.getParameter(n.MAX_TEXTURE_IMAGE_UNITS),g=n.getParameter(n.MAX_VERTEX_TEXTURE_IMAGE_UNITS),_=n.getParameter(n.MAX_TEXTURE_SIZE),m=n.getParameter(n.MAX_CUBE_MAP_TEXTURE_SIZE),p=n.getParameter(n.MAX_VERTEX_ATTRIBS),M=n.getParameter(n.MAX_VERTEX_UNIFORM_VECTORS),R=n.getParameter(n.MAX_VARYING_VECTORS),y=n.getParameter(n.MAX_FRAGMENT_UNIFORM_VECTORS),w=n.getParameter(n.MAX_SAMPLES),S=n.getParameter(n.SAMPLES);return{isWebGL2:!0,getMaxAnisotropy:r,getMaxPrecision:l,textureFormatReadable:a,textureTypeReadable:o,precision:c,logarithmicDepthBuffer:d,reversedDepthBuffer:u,maxTextures:f,maxVertexTextures:g,maxTextureSize:_,maxCubemapSize:m,maxAttributes:p,maxVertexUniforms:M,maxVaryings:R,maxFragmentUniforms:y,maxSamples:w,samples:S}}function Jg(n){let t=this,e=null,i=0,s=!1,r=!1,a=new ui,o=new Xt,l={value:null,needsUpdate:!1};this.uniform=l,this.numPlanes=0,this.numIntersection=0,this.init=function(d,u){let f=d.length!==0||u||i!==0||s;return s=u,i=d.length,f},this.beginShadows=function(){r=!0,h(null)},this.endShadows=function(){r=!1},this.setGlobalState=function(d,u){e=h(d,u,0)},this.setState=function(d,u,f){let g=d.clippingPlanes,_=d.clipIntersection,m=d.clipShadows,p=n.get(d);if(!s||g===null||g.length===0||r&&!m)r?h(null):c();else{let M=r?0:i,R=M*4,y=p.clippingState||null;l.value=y,y=h(g,u,R,f);for(let w=0;w!==R;++w)y[w]=e[w];p.clippingState=y,this.numIntersection=_?this.numPlanes:0,this.numPlanes+=M}};function c(){l.value!==e&&(l.value=e,l.needsUpdate=i>0),t.numPlanes=i,t.numIntersection=0}function h(d,u,f,g){let _=d!==null?d.length:0,m=null;if(_!==0){if(m=l.value,g!==!0||m===null){let p=f+_*4,M=u.matrixWorldInverse;o.getNormalMatrix(M),(m===null||m.length<p)&&(m=new Float32Array(p));for(let R=0,y=f;R!==_;++R,y+=4)a.copy(d[R]).applyMatrix4(M,o),a.normal.toArray(m,y),m[y+3]=a.constant}l.value=m,l.needsUpdate=!0}return t.numPlanes=_,t.numIntersection=0,m}}var $s=4,Kg=6,Qg=20,jg=256,da=new Ln,Ud=new Ut,Sh=null,wh=0,Th=0,Eh=!1,tx=new N,ns=new N,Js=class{constructor(t){this._renderer=t,this._pingPongRenderTarget=null,this._lodMax=0,this._cubeSize=0,this._sizeLods=[],this._lodMeshes=[],this._backgroundBox=null,this._cubemapMaterial=null,this._equirectMaterial=null,this._blurMaterial=null,this._ggxMaterial=null}fromScene(t,e=0,i=.1,s=100,r={}){let{size:a=256,position:o=tx}=r;Sh=this._renderer.getRenderTarget(),wh=this._renderer.getActiveCubeFace(),Th=this._renderer.getActiveMipmapLevel(),Eh=this._renderer.xr.enabled,this._renderer.xr.enabled=!1,this._setSize(a);let l=this._allocateTargets();return l.depthBuffer=!0,this._sceneToCubeUV(t,i,s,l,o),e>0&&this._blur(l,0,0,e),this._applyPMREM(l),this._cleanup(l),l}fromEquirectangular(t,e=null){return this._fromTexture(t,e)}fromCubemap(t,e=null){return this._fromTexture(t,e)}compileCubemapShader(){this._cubemapMaterial===null&&(this._cubemapMaterial=Bd(),this._compileMaterial(this._cubemapMaterial))}compileEquirectangularShader(){this._equirectMaterial===null&&(this._equirectMaterial=zd(),this._compileMaterial(this._equirectMaterial))}dispose(){this._dispose(),this._cubemapMaterial!==null&&this._cubemapMaterial.dispose(),this._equirectMaterial!==null&&this._equirectMaterial.dispose(),this._backgroundBox!==null&&(this._backgroundBox.geometry.dispose(),this._backgroundBox.material.dispose())}_setSize(t){this._lodMax=Math.floor(Math.log2(t)),this._cubeSize=Math.pow(2,this._lodMax)}_dispose(){this._blurMaterial!==null&&this._blurMaterial.dispose(),this._ggxMaterial!==null&&this._ggxMaterial.dispose(),this._pingPongRenderTarget!==null&&this._pingPongRenderTarget.dispose();for(let t=0;t<this._lodMeshes.length;t++)this._lodMeshes[t].geometry.dispose()}_cleanup(t){this._renderer.setRenderTarget(Sh,wh,Th),this._renderer.xr.enabled=Eh,t.scissorTest=!1,Ys(t,0,0,t.width,t.height)}_fromTexture(t,e){t.mapping===Un||t.mapping===es?this._setSize(t.image.length===0?16:t.image[0].width||t.image[0].image.width):this._setSize(t.image.width/4),Sh=this._renderer.getRenderTarget(),wh=this._renderer.getActiveCubeFace(),Th=this._renderer.getActiveMipmapLevel(),Eh=this._renderer.xr.enabled,this._renderer.xr.enabled=!1;let i=e||this._allocateTargets();return this._textureToCubeUV(t,i),this._applyPMREM(i),this._cleanup(i),i}_allocateTargets(){let t=3*Math.max(this._cubeSize,112),e=4*this._cubeSize,i={magFilter:Oe,minFilter:Oe,generateMipmaps:!1,type:He,format:Si,colorSpace:wr,depthBuffer:!1},s=Fd(t,e,i);if(this._pingPongRenderTarget===null||this._pingPongRenderTarget.width!==t||this._pingPongRenderTarget.height!==e){this._pingPongRenderTarget!==null&&this._dispose(),this._pingPongRenderTarget=Fd(t,e,i);let{_lodMax:r}=this;({lodMeshes:this._lodMeshes,sizeLods:this._sizeLods}=ex(r)),this._blurMaterial=nx(r,t,e),this._ggxMaterial=ix(r,t,e)}return s}_compileMaterial(t){let e=new Tt(new ce,t);this._renderer.compile(e,da)}_sceneToCubeUV(t,e,i,s,r){let l=new Ye(90,1,e,i),c=[1,-1,1,1,1,1],h=[1,1,1,-1,-1,-1],d=this._renderer,u=d.autoClear,f=d.toneMapping;d.getClearColor(Ud),d.toneMapping=Ui,d.autoClear=!1,d.state.buffers.depth.getReversed()&&(d.setRenderTarget(s),d.clearDepth(),d.setRenderTarget(null)),this._backgroundBox===null&&(this._backgroundBox=new Tt(new $e,new Le({name:"PMREM.Background",side:Ze,depthWrite:!1,depthTest:!1})));let _=this._backgroundBox,m=_.material,p=!1,M=t.background;M?M.isColor&&(m.color.copy(M),t.background=null,p=!0):(m.color.copy(Ud),p=!0);for(let R=0;R<6;R++){let y=R%3;y===0?(l.up.set(0,c[R],0),l.position.set(r.x,r.y,r.z),l.lookAt(r.x+h[R],r.y,r.z)):y===1?(l.up.set(0,0,c[R]),l.position.set(r.x,r.y,r.z),l.lookAt(r.x,r.y+h[R],r.z)):(l.up.set(0,c[R],0),l.position.set(r.x,r.y,r.z),l.lookAt(r.x,r.y,r.z+h[R]));let w=this._cubeSize;Ys(s,y*w,R>2?w:0,w,w),d.setRenderTarget(s),p&&d.render(_,l),d.render(t,l)}d.toneMapping=f,d.autoClear=u,t.background=M}_textureToCubeUV(t,e){let i=this._renderer,s=t.mapping===Un||t.mapping===es;s?(this._cubemapMaterial===null&&(this._cubemapMaterial=Bd()),this._cubemapMaterial.uniforms.flipEnvMap.value=t.isRenderTargetTexture===!1?-1:1):this._equirectMaterial===null&&(this._equirectMaterial=zd());let r=s?this._cubemapMaterial:this._equirectMaterial,a=this._lodMeshes[0];a.material=r;let o=r.uniforms;o.envMap.value=t;let l=this._cubeSize;Ys(e,0,0,3*l,2*l),i.setRenderTarget(e),i.render(a,da)}_applyPMREM(t){let e=this._renderer,i=e.autoClear;e.autoClear=!1;let s=this._lodMeshes.length;for(let r=1;r<s;r++)this._applyGGXFilter(t,r-1,r);e.autoClear=i}_applyGGXFilter(t,e,i){let s=this._renderer,r=this._pingPongRenderTarget,a=this._ggxMaterial,o=this._lodMeshes[i];o.material=a;let l=a.uniforms,c=i/(this._lodMeshes.length-1),h=e/(this._lodMeshes.length-1),d=Math.sqrt(c*c-h*h),u=c*1.25,f=d*u,{_lodMax:g}=this,_=this._sizeLods[i],m=3*_*(i>g-$s?i-g+$s:0),p=4*(this._cubeSize-_);l.envMap.value=t.texture,l.roughness.value=f,l.mipInt.value=g-e,Ys(r,m,p,3*_,2*_),s.setRenderTarget(r),s.render(o,da),l.envMap.value=r.texture,l.roughness.value=0,l.mipInt.value=g-i,Ys(t,m,p,3*_,2*_),s.setRenderTarget(t),s.render(o,da)}_blur(t,e,i,s){let r=this._pingPongRenderTarget,a=Math.min(s,Math.PI)/Math.SQRT2;this._blurPass(t,r,e,i,a),this._blurPass(r,t,i,i,a)}_blurPass(t,e,i,s,r){let a=this._renderer,o=this._blurMaterial,l=this._lodMeshes[s];l.material=o;let c=o.uniforms;c.envMap.value=t.texture,c.sigma.value=r,c.mipInt.value=this._lodMax-i;let h=this._sizeLods[s],d=3*h*(s>this._lodMax-$s?s-this._lodMax+$s:0),u=4*(this._cubeSize-h);Ys(e,d,u,3*h,2*h),a.setRenderTarget(e),a.render(l,da)}};function ex(n){let t=[],e=[],i=n,s=n-$s+1+Kg;for(let r=0;r<s;r++){let a=Math.pow(2,i);t.push(a);let o=1/(a-2),l=-o,c=1+o,h=[l,l,c,l,c,c,l,l,c,c,l,c],d=6,u=6,f=3,g=new Float32Array(f*u*d),_=new Float32Array(f*u*d);for(let p=0;p<d;p++){let M=p%3*2/3-1,R=p>2?0:-1,y=[M,R,0,M+2/3,R,0,M+2/3,R+1,0,M,R,0,M+2/3,R+1,0,M,R+1,0];g.set(y,f*u*p);for(let w=0;w<u;w++){let S=h[w*2]*2-1,I=h[w*2+1]*2-1;p===0?ns.set(1,I,S):p===1?ns.set(-S,1,-I):p===2?ns.set(-S,I,1):p===3?ns.set(-1,I,-S):p===4?ns.set(-S,-1,I):ns.set(S,I,-1),ns.toArray(_,(p*u+w)*f)}}let m=new ce;m.setAttribute("position",new ze(g,f)),m.setAttribute("outputDirection",new ze(_,f)),e.push(new Tt(m,null)),i>$s&&i--}return{lodMeshes:e,sizeLods:t}}function Fd(n,t,e){let i=new Re(n,t,e);return i.texture.mapping=ia,i.texture.name="PMREM.cubeUv",i.scissorTest=!0,i}function Ys(n,t,e,i,s){n.viewport.set(t,e,i,s),n.scissor.set(t,e,i,s)}function ix(n,t,e){return new Te({name:"PMREMGGXConvolution",defines:{GGX_SAMPLES:jg,CUBEUV_TEXEL_WIDTH:1/t,CUBEUV_TEXEL_HEIGHT:1/e,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},roughness:{value:0},mipInt:{value:0}},vertexShader:Il(),fragmentShader:`

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
		`,blending:Mi,depthTest:!1,depthWrite:!1})}function nx(n,t,e){return new Te({name:"SphericalGaussianBlur",defines:{SAMPLES:Qg,CUBEUV_TEXEL_WIDTH:1/t,CUBEUV_TEXEL_HEIGHT:1/e,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},sigma:{value:0},mipInt:{value:0}},vertexShader:Il(),fragmentShader:`

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
		`,blending:Mi,depthTest:!1,depthWrite:!1})}function zd(){return new Te({name:"EquirectangularToCubeUV",uniforms:{envMap:{value:null}},vertexShader:Il(),fragmentShader:`

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
		`,blending:Mi,depthTest:!1,depthWrite:!1})}function Bd(){return new Te({name:"CubemapToCubeUV",uniforms:{envMap:{value:null},flipEnvMap:{value:-1}},vertexShader:Il(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			uniform float flipEnvMap;

			varying vec3 vOutputDirection;

			uniform samplerCube envMap;

			void main() {

				gl_FragColor = textureCube( envMap, vec3( flipEnvMap * vOutputDirection.x, vOutputDirection.yz ) );

			}
		`,blending:Mi,depthTest:!1,depthWrite:!1})}function Il(){return`

		precision mediump float;
		precision mediump int;

		attribute vec3 outputDirection;

		varying vec3 vOutputDirection;

		void main() {

			vOutputDirection = outputDirection;
			gl_Position = vec4( position, 1.0 );

		}
	`}var Rl=class extends Re{constructor(t=1,e={}){super(t,t,e),this.isWebGLCubeRenderTarget=!0;let i={width:t,height:t,depth:1},s=[i,i,i,i,i,i];this.texture=new Br(s),this._setTextureOptions(e),this.texture.isRenderTargetTexture=!0}fromEquirectangularTexture(t,e){this.texture.type=e.type,this.texture.colorSpace=e.colorSpace,this.texture.generateMipmaps=e.generateMipmaps,this.texture.minFilter=e.minFilter,this.texture.magFilter=e.magFilter;let i={uniforms:{tEquirect:{value:null}},vertexShader:`

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
			`},s=new $e(5,5,5),r=new Te({name:"CubemapFromEquirect",uniforms:is(i.uniforms),vertexShader:i.vertexShader,fragmentShader:i.fragmentShader,side:Ze,blending:Mi});r.uniforms.tEquirect.value=e;let a=new Tt(s,r),o=e.minFilter;return e.minFilter===Yi&&(e.minFilter=Oe),new No(1,10,this).update(t,a),e.minFilter=o,a.geometry.dispose(),a.material.dispose(),this}clear(t,e=!0,i=!0,s=!0){let r=t.getRenderTarget();for(let a=0;a<6;a++)t.setRenderTarget(this,a),t.clear(e,i,s);t.setRenderTarget(r)}};function sx(n){let t=new WeakMap,e=new WeakMap,i=null;function s(u,f=!1){return u==null?null:f?a(u):r(u)}function r(u){if(u&&u.isTexture){let f=u.mapping;if(f===Bo||f===Oo)if(t.has(u)){let g=t.get(u).texture;return o(g,u.mapping)}else{let g=u.image;if(g&&g.height>0){let _=new Rl(g.height);return _.fromEquirectangularTexture(n,u),t.set(u,_),u.addEventListener("dispose",c),o(_.texture,u.mapping)}else return null}}return u}function a(u){if(u&&u.isTexture){let f=u.mapping,g=f===Bo||f===Oo,_=f===Un||f===es;if(g||_){let m=e.get(u),p=m!==void 0?m.texture.pmremVersion:0;if(u.isRenderTargetTexture&&u.pmremVersion!==p)return i===null&&(i=new Js(n)),m=g?i.fromEquirectangular(u,m):i.fromCubemap(u,m),m.texture.pmremVersion=u.pmremVersion,e.set(u,m),m.texture;if(m!==void 0)return m.texture;{let M=u.image;return g&&M&&M.height>0||_&&M&&l(M)?(i===null&&(i=new Js(n)),m=g?i.fromEquirectangular(u):i.fromCubemap(u),m.texture.pmremVersion=u.pmremVersion,e.set(u,m),u.addEventListener("dispose",h),m.texture):null}}}return u}function o(u,f){return f===Bo?u.mapping=Un:f===Oo&&(u.mapping=es),u}function l(u){let f=0,g=6;for(let _=0;_<g;_++)u[_]!==void 0&&f++;return f===g}function c(u){let f=u.target;f.removeEventListener("dispose",c);let g=t.get(f);g!==void 0&&(t.delete(f),g.dispose())}function h(u){let f=u.target;f.removeEventListener("dispose",h);let g=e.get(f);g!==void 0&&(e.delete(f),g.dispose())}function d(){t=new WeakMap,e=new WeakMap,i!==null&&(i.dispose(),i=null)}return{get:s,dispose:d}}function rx(n){let t={};function e(i){if(t[i]!==void 0)return t[i];let s=n.getExtension(i);return t[i]=s,s}return{has:function(i){return e(i)!==null},init:function(){e("EXT_color_buffer_float"),e("WEBGL_clip_cull_distance"),e("OES_texture_float_linear"),e("EXT_color_buffer_half_float"),e("WEBGL_multisampled_render_to_texture"),e("WEBGL_render_shared_exponent")},get:function(i){let s=e(i);return s===null&&$n("WebGLRenderer: "+i+" extension not supported."),s}}}function ax(n,t,e,i){let s={},r=new WeakMap;function a(d){let u=d.target;u.index!==null&&t.remove(u.index);for(let g in u.attributes)t.remove(u.attributes[g]);u.removeEventListener("dispose",a),delete s[u.id];let f=r.get(u);f&&(t.remove(f),r.delete(u)),i.releaseStatesOfGeometry(u),u.isInstancedBufferGeometry===!0&&delete u._maxInstanceCount,e.memory.geometries--}function o(d,u){return s[u.id]===!0||(u.addEventListener("dispose",a),s[u.id]=!0,e.memory.geometries++),u}function l(d){let u=d.attributes;for(let f in u)t.update(u[f],n.ARRAY_BUFFER)}function c(d){let u=[],f=d.index,g=d.attributes.position,_=0;if(g===void 0)return;if(f!==null){let M=f.array;_=f.version;for(let R=0,y=M.length;R<y;R+=3){let w=M[R+0],S=M[R+1],I=M[R+2];u.push(w,S,S,I,I,w)}}else{let M=g.array;_=g.version;for(let R=0,y=M.length/3-1;R<y;R+=3){let w=R+0,S=R+1,I=R+2;u.push(w,S,S,I,I,w)}}let m=new(g.count>=65535?Pr:Ir)(u,1);m.version=_;let p=r.get(d);p&&t.remove(p),r.set(d,m)}function h(d){let u=r.get(d);if(u){let f=d.index;f!==null&&u.version<f.version&&c(d)}else c(d);return r.get(d)}return{get:o,update:l,getWireframeAttribute:h}}function ox(n,t,e){let i;function s(d){i=d}let r,a;function o(d){r=d.type,a=d.bytesPerElement}function l(d,u){n.drawElements(i,u,r,d*a),e.update(u,i,1)}function c(d,u,f){f!==0&&(n.drawElementsInstanced(i,u,r,d*a,f),e.update(u,i,f))}function h(d,u,f){if(f===0)return;t.get("WEBGL_multi_draw").multiDrawElementsWEBGL(i,u,0,r,d,0,f);let _=0;for(let m=0;m<f;m++)_+=u[m];e.update(_,i,1)}this.setMode=s,this.setIndex=o,this.render=l,this.renderInstances=c,this.renderMultiDraw=h}function lx(n){let t={geometries:0,textures:0},e={frame:0,calls:0,triangles:0,points:0,lines:0};function i(r,a,o){switch(e.calls++,a){case n.TRIANGLES:e.triangles+=o*(r/3);break;case n.LINES:e.lines+=o*(r/2);break;case n.LINE_STRIP:e.lines+=o*(r-1);break;case n.LINE_LOOP:e.lines+=o*r;break;case n.POINTS:e.points+=o*r;break;default:Ht("WebGLInfo: Unknown draw mode:",a);break}}function s(){e.calls=0,e.triangles=0,e.points=0,e.lines=0}return{memory:t,render:e,programs:null,autoReset:!0,reset:s,update:i}}function cx(n,t,e){let i=new WeakMap,s=new Ae;function r(a,o,l){let c=a.morphTargetInfluences,h=o.morphAttributes.position||o.morphAttributes.normal||o.morphAttributes.color,d=h!==void 0?h.length:0,u=i.get(o);if(u===void 0||u.count!==d){let A=function(){I.dispose(),i.delete(o),o.removeEventListener("dispose",A)};u!==void 0&&u.texture.dispose();let f=o.morphAttributes.position!==void 0,g=o.morphAttributes.normal!==void 0,_=o.morphAttributes.color!==void 0,m=o.morphAttributes.position||[],p=o.morphAttributes.normal||[],M=o.morphAttributes.color||[],R=0;f===!0&&(R=1),g===!0&&(R=2),_===!0&&(R=3);let y=o.attributes.position.count*R,w=1;y>t.maxTextureSize&&(w=Math.ceil(y/t.maxTextureSize),y=t.maxTextureSize);let S=new Float32Array(y*w*4*d),I=new Rr(S,y,w,d);I.type=bi,I.needsUpdate=!0;let v=R*4;for(let P=0;P<d;P++){let O=m[P],L=p[P],z=M[P],D=y*w*4*P;for(let k=0;k<O.count;k++){let Y=k*v;f===!0&&(s.fromBufferAttribute(O,k),S[D+Y+0]=s.x,S[D+Y+1]=s.y,S[D+Y+2]=s.z,S[D+Y+3]=0),g===!0&&(s.fromBufferAttribute(L,k),S[D+Y+4]=s.x,S[D+Y+5]=s.y,S[D+Y+6]=s.z,S[D+Y+7]=0),_===!0&&(s.fromBufferAttribute(z,k),S[D+Y+8]=s.x,S[D+Y+9]=s.y,S[D+Y+10]=s.z,S[D+Y+11]=z.itemSize===4?s.w:1)}}u={count:d,texture:I,size:new xt(y,w)},i.set(o,u),o.addEventListener("dispose",A)}if(a.isInstancedMesh===!0&&a.morphTexture!==null)l.getUniforms().setValue(n,"morphTexture",a.morphTexture,e);else{let f=0;for(let _=0;_<c.length;_++)f+=c[_];let g=o.morphTargetsRelative?1:1-f;l.getUniforms().setValue(n,"morphTargetBaseInfluence",g),l.getUniforms().setValue(n,"morphTargetInfluences",c)}l.getUniforms().setValue(n,"morphTargetsTexture",u.texture,e),l.getUniforms().setValue(n,"morphTargetsTextureSize",u.size)}return{update:r}}function hx(n,t,e,i,s){let r=new WeakMap;function a(c){let h=s.render.frame,d=c.geometry,u=t.get(c,d);if(r.get(u)!==h&&(t.update(u),r.set(u,h)),c.isInstancedMesh&&(c.hasEventListener("dispose",l)===!1&&c.addEventListener("dispose",l),r.get(c)!==h&&(e.update(c.instanceMatrix,n.ARRAY_BUFFER),c.instanceColor!==null&&e.update(c.instanceColor,n.ARRAY_BUFFER),r.set(c,h))),c.isSkinnedMesh){let f=c.skeleton;r.get(f)!==h&&(f.update(),r.set(f,h))}return u}function o(){r=new WeakMap}function l(c){let h=c.target;h.removeEventListener("dispose",l),i.releaseStatesOfObject(h),e.remove(h.instanceMatrix),h.instanceColor!==null&&e.remove(h.instanceColor)}return{update:a,dispose:o}}var ux={[Jr]:"LINEAR_TONE_MAPPING",[Kr]:"REINHARD_TONE_MAPPING",[Qr]:"CINEON_TONE_MAPPING",[ts]:"ACES_FILMIC_TONE_MAPPING",[ta]:"AGX_TONE_MAPPING",[ea]:"NEUTRAL_TONE_MAPPING",[jr]:"CUSTOM_TONE_MAPPING"};function dx(n,t,e,i,s,r){let a=new Re(t,e,{type:n,depthBuffer:s,stencilBuffer:r,samples:i?4:0,storeMultisampledDepthBuffer:!1,storeMultisampledStencilBuffer:!1,resolveDepthBuffer:!1,resolveStencilBuffer:!1}),o=null,l=null,c=new ce;c.setAttribute("position",new Gt([-1,3,0,-1,-1,0,3,-1,0],3)),c.setAttribute("uv",new Gt([0,2,0,0,2,0],2));let h=new Vs({uniforms:{tDiffuse:{value:null}},vertexShader:`
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
			}`,depthTest:!1,depthWrite:!1}),d=new Tt(c,h),u=new Ln(-1,1,1,-1,0,1),f=null,g=null,_=!1,m,p=null,M=[],R=!1;this.setSize=function(y,w){a.setSize(y,w),o!==null&&o.setSize(y,w),l!==null&&l.setSize(y,w);for(let S=0;S<M.length;S++){let I=M[S];I.setSize&&I.setSize(y,w)}},this.setEffects=function(y){M=y,R=M.length>0&&M[0].isRenderPass===!0;let w=a.width,S=a.height;M.length>0&&o===null&&(o=new Re(w,S,{type:He,depthBuffer:!1,stencilBuffer:!1}),l=new Re(w,S,{type:He,depthBuffer:!1,stencilBuffer:!1}));for(let I=0;I<M.length;I++){let v=M[I];v.setSize&&v.setSize(w,S)}},this.begin=function(y,w){if(_||y.toneMapping===Ui&&M.length===0)return!1;if(p=w,w!==null){let S=w.width,I=w.height;(a.width!==S||a.height!==I)&&this.setSize(S,I)}return R===!1&&y.setRenderTarget(a),m=y.toneMapping,y.toneMapping=Ui,!0},this.hasRenderPass=function(){return R},this.end=function(y,w){y.toneMapping=m,_=!0;let S=a,I=o;for(let v=0;v<M.length;v++){let A=M[v];A.enabled!==!1&&(A.render(y,I,S,w),A.needsSwap!==!1&&(S=I,I=I===o?l:o))}if(f!==y.outputColorSpace||g!==y.toneMapping){f=y.outputColorSpace,g=y.toneMapping,h.defines={},Qt.getTransfer(f)===ae&&(h.defines.SRGB_TRANSFER="");let v=ux[g];v&&(h.defines[v]=""),h.needsUpdate=!0}h.uniforms.tDiffuse.value=S.texture,y.setRenderTarget(p),y.render(d,u),p=null,_=!1},this.isCompositing=function(){return _},this.dispose=function(){a.dispose(),o!==null&&o.dispose(),l!==null&&l.dispose(),c.dispose(),h.dispose()}}var rf=new ai,Ch=new An(1,1),af=new Rr,of=new mo,lf=new Br,Od=[],kd=[],Hd=new Float32Array(16),Vd=new Float32Array(9),Gd=new Float32Array(4);function Ks(n,t,e){let i=n[0];if(i<=0||i>0)return n;let s=t*e,r=Od[s];if(r===void 0&&(r=new Float32Array(s),Od[s]=r),t!==0){i.toArray(r,0);for(let a=1,o=0;a!==t;++a)o+=e,n[a].toArray(r,o)}return r}function Ve(n,t){if(n.length!==t.length)return!1;for(let e=0,i=n.length;e<i;e++)if(n[e]!==t[e])return!1;return!0}function Ge(n,t){for(let e=0,i=t.length;e<i;e++)n[e]=t[e]}function Pl(n,t){let e=kd[t];e===void 0&&(e=new Int32Array(t),kd[t]=e);for(let i=0;i!==t;++i)e[i]=n.allocateTextureUnit();return e}function fx(n,t){let e=this.cache;e[0]!==t&&(n.uniform1f(this.addr,t),e[0]=t)}function px(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2f(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(Ve(e,t))return;n.uniform2fv(this.addr,t),Ge(e,t)}}function mx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3f(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else if(t.r!==void 0)(e[0]!==t.r||e[1]!==t.g||e[2]!==t.b)&&(n.uniform3f(this.addr,t.r,t.g,t.b),e[0]=t.r,e[1]=t.g,e[2]=t.b);else{if(Ve(e,t))return;n.uniform3fv(this.addr,t),Ge(e,t)}}function gx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4f(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(Ve(e,t))return;n.uniform4fv(this.addr,t),Ge(e,t)}}function xx(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(Ve(e,t))return;n.uniformMatrix2fv(this.addr,!1,t),Ge(e,t)}else{if(Ve(e,i))return;Gd.set(i),n.uniformMatrix2fv(this.addr,!1,Gd),Ge(e,i)}}function _x(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(Ve(e,t))return;n.uniformMatrix3fv(this.addr,!1,t),Ge(e,t)}else{if(Ve(e,i))return;Vd.set(i),n.uniformMatrix3fv(this.addr,!1,Vd),Ge(e,i)}}function vx(n,t){let e=this.cache,i=t.elements;if(i===void 0){if(Ve(e,t))return;n.uniformMatrix4fv(this.addr,!1,t),Ge(e,t)}else{if(Ve(e,i))return;Hd.set(i),n.uniformMatrix4fv(this.addr,!1,Hd),Ge(e,i)}}function yx(n,t){let e=this.cache;e[0]!==t&&(n.uniform1i(this.addr,t),e[0]=t)}function Mx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2i(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(Ve(e,t))return;n.uniform2iv(this.addr,t),Ge(e,t)}}function bx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3i(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else{if(Ve(e,t))return;n.uniform3iv(this.addr,t),Ge(e,t)}}function Sx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4i(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(Ve(e,t))return;n.uniform4iv(this.addr,t),Ge(e,t)}}function wx(n,t){let e=this.cache;e[0]!==t&&(n.uniform1ui(this.addr,t),e[0]=t)}function Tx(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y)&&(n.uniform2ui(this.addr,t.x,t.y),e[0]=t.x,e[1]=t.y);else{if(Ve(e,t))return;n.uniform2uiv(this.addr,t),Ge(e,t)}}function Ex(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z)&&(n.uniform3ui(this.addr,t.x,t.y,t.z),e[0]=t.x,e[1]=t.y,e[2]=t.z);else{if(Ve(e,t))return;n.uniform3uiv(this.addr,t),Ge(e,t)}}function Ax(n,t){let e=this.cache;if(t.x!==void 0)(e[0]!==t.x||e[1]!==t.y||e[2]!==t.z||e[3]!==t.w)&&(n.uniform4ui(this.addr,t.x,t.y,t.z,t.w),e[0]=t.x,e[1]=t.y,e[2]=t.z,e[3]=t.w);else{if(Ve(e,t))return;n.uniform4uiv(this.addr,t),Ge(e,t)}}function Rx(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s);let r;this.type===n.SAMPLER_2D_SHADOW?(Ch.compareFunction=e.isReversedDepthBuffer()?Tl:wl,r=Ch):r=rf,e.setTexture2D(t||r,s)}function Cx(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTexture3D(t||of,s)}function Ix(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTextureCube(t||lf,s)}function Px(n,t,e){let i=this.cache,s=e.allocateTextureUnit();i[0]!==s&&(n.uniform1i(this.addr,s),i[0]=s),e.setTexture2DArray(t||af,s)}function Lx(n){switch(n){case 5126:return fx;case 35664:return px;case 35665:return mx;case 35666:return gx;case 35674:return xx;case 35675:return _x;case 35676:return vx;case 5124:case 35670:return yx;case 35667:case 35671:return Mx;case 35668:case 35672:return bx;case 35669:case 35673:return Sx;case 5125:return wx;case 36294:return Tx;case 36295:return Ex;case 36296:return Ax;case 35678:case 36198:case 36298:case 36306:case 35682:return Rx;case 35679:case 36299:case 36307:return Cx;case 35680:case 36300:case 36308:case 36293:return Ix;case 36289:case 36303:case 36311:case 36292:return Px}}function Dx(n,t){n.uniform1fv(this.addr,t)}function Nx(n,t){let e=Ks(t,this.size,2);n.uniform2fv(this.addr,e)}function Ux(n,t){let e=Ks(t,this.size,3);n.uniform3fv(this.addr,e)}function Fx(n,t){let e=Ks(t,this.size,4);n.uniform4fv(this.addr,e)}function zx(n,t){let e=Ks(t,this.size,4);n.uniformMatrix2fv(this.addr,!1,e)}function Bx(n,t){let e=Ks(t,this.size,9);n.uniformMatrix3fv(this.addr,!1,e)}function Ox(n,t){let e=Ks(t,this.size,16);n.uniformMatrix4fv(this.addr,!1,e)}function kx(n,t){n.uniform1iv(this.addr,t)}function Hx(n,t){n.uniform2iv(this.addr,t)}function Vx(n,t){n.uniform3iv(this.addr,t)}function Gx(n,t){n.uniform4iv(this.addr,t)}function Wx(n,t){n.uniform1uiv(this.addr,t)}function Xx(n,t){n.uniform2uiv(this.addr,t)}function qx(n,t){n.uniform3uiv(this.addr,t)}function Yx(n,t){n.uniform4uiv(this.addr,t)}function $x(n,t,e){let i=this.cache,s=t.length,r=Pl(e,s);Ve(i,r)||(n.uniform1iv(this.addr,r),Ge(i,r));let a;this.type===n.SAMPLER_2D_SHADOW?a=Ch:a=rf;for(let o=0;o!==s;++o)e.setTexture2D(t[o]||a,r[o])}function Zx(n,t,e){let i=this.cache,s=t.length,r=Pl(e,s);Ve(i,r)||(n.uniform1iv(this.addr,r),Ge(i,r));for(let a=0;a!==s;++a)e.setTexture3D(t[a]||of,r[a])}function Jx(n,t,e){let i=this.cache,s=t.length,r=Pl(e,s);Ve(i,r)||(n.uniform1iv(this.addr,r),Ge(i,r));for(let a=0;a!==s;++a)e.setTextureCube(t[a]||lf,r[a])}function Kx(n,t,e){let i=this.cache,s=t.length,r=Pl(e,s);Ve(i,r)||(n.uniform1iv(this.addr,r),Ge(i,r));for(let a=0;a!==s;++a)e.setTexture2DArray(t[a]||af,r[a])}function Qx(n){switch(n){case 5126:return Dx;case 35664:return Nx;case 35665:return Ux;case 35666:return Fx;case 35674:return zx;case 35675:return Bx;case 35676:return Ox;case 5124:case 35670:return kx;case 35667:case 35671:return Hx;case 35668:case 35672:return Vx;case 35669:case 35673:return Gx;case 5125:return Wx;case 36294:return Xx;case 36295:return qx;case 36296:return Yx;case 35678:case 36198:case 36298:case 36306:case 35682:return $x;case 35679:case 36299:case 36307:return Zx;case 35680:case 36300:case 36308:case 36293:return Jx;case 36289:case 36303:case 36311:case 36292:return Kx}}var Ih=class{constructor(t,e,i){this.id=t,this.addr=i,this.cache=[],this.type=e.type,this.setValue=Lx(e.type)}},Ph=class{constructor(t,e,i){this.id=t,this.addr=i,this.cache=[],this.type=e.type,this.size=e.size,this.setValue=Qx(e.type)}},Lh=class{constructor(t){this.id=t,this.seq=[],this.map={}}setValue(t,e,i){let s=this.seq;for(let r=0,a=s.length;r!==a;++r){let o=s[r];o.setValue(t,e[o.id],i)}}},Ah=/(\w+)(\])?(\[|\.)?/g;function Wd(n,t){n.seq.push(t),n.map[t.id]=t}function jx(n,t,e){let i=n.name,s=i.length;for(Ah.lastIndex=0;;){let r=Ah.exec(i),a=Ah.lastIndex,o=r[1],l=r[2]==="]",c=r[3];if(l&&(o=o|0),c===void 0||c==="["&&a+2===s){Wd(e,c===void 0?new Ih(o,n,t):new Ph(o,n,t));break}else{let d=e.map[o];d===void 0&&(d=new Lh(o),Wd(e,d)),e=d}}}var Zs=class{constructor(t,e){this.seq=[],this.map={};let i=t.getProgramParameter(e,t.ACTIVE_UNIFORMS);for(let a=0;a<i;++a){let o=t.getActiveUniform(e,a),l=t.getUniformLocation(e,o.name);jx(o,l,this)}let s=[],r=[];for(let a of this.seq)a.type===t.SAMPLER_2D_SHADOW||a.type===t.SAMPLER_CUBE_SHADOW||a.type===t.SAMPLER_2D_ARRAY_SHADOW?s.push(a):r.push(a);s.length>0&&(this.seq=s.concat(r))}setValue(t,e,i,s){let r=this.map[e];r!==void 0&&r.setValue(t,i,s)}setOptional(t,e,i){let s=e[i];s!==void 0&&this.setValue(t,i,s)}static upload(t,e,i,s){for(let r=0,a=e.length;r!==a;++r){let o=e[r],l=i[o.id];l.needsUpdate!==!1&&o.setValue(t,l.value,s)}}static seqWithValue(t,e){let i=[];for(let s=0,r=t.length;s!==r;++s){let a=t[s];a.id in e&&i.push(a)}return i}};function Xd(n,t,e){let i=n.createShader(t);return n.shaderSource(i,e),n.compileShader(i),i}var t_=37297,e_=0;function i_(n,t){let e=n.split(`
`),i=[],s=Math.max(t-6,0),r=Math.min(t+6,e.length);for(let a=s;a<r;a++){let o=a+1;i.push(`${o===t?">":" "} ${o}: ${e[a]}`)}return i.join(`
`)}var qd=new Xt;function n_(n){Qt._getMatrix(qd,Qt.workingColorSpace,n);let t=`mat3( ${qd.elements.map(e=>e.toFixed(4))} )`;switch(Qt.getTransfer(n)){case Tr:return[t,"LinearTransferOETF"];case ae:return[t,"sRGBTransferOETF"];default:return kt("WebGLProgram: Unsupported color space: ",n),[t,"LinearTransferOETF"]}}function Yd(n,t,e){let i=n.getShaderParameter(t,n.COMPILE_STATUS),r=(n.getShaderInfoLog(t)||"").trim();if(i&&r==="")return"";let a=/ERROR: 0:(\d+)/.exec(r);if(a){let o=parseInt(a[1]);return e.toUpperCase()+`

`+r+`

`+i_(n.getShaderSource(t),o)}else return r}function s_(n,t){let e=n_(t);return[`vec4 ${n}( vec4 value ) {`,`	return ${e[1]}( vec4( value.rgb * ${e[0]}, value.a ) );`,"}"].join(`
`)}var r_={[Jr]:"Linear",[Kr]:"Reinhard",[Qr]:"Cineon",[ts]:"ACESFilmic",[ta]:"AgX",[ea]:"Neutral",[jr]:"Custom"};function a_(n,t){let e=r_[t];return e===void 0?(kt("WebGLProgram: Unsupported toneMapping:",t),"vec3 "+n+"( vec3 color ) { return LinearToneMapping( color ); }"):"vec3 "+n+"( vec3 color ) { return "+e+"ToneMapping( color ); }"}var Al=new N;function o_(){Qt.getLuminanceCoefficients(Al);let n=Al.x.toFixed(4),t=Al.y.toFixed(4),e=Al.z.toFixed(4);return["float luminance( const in vec3 rgb ) {",`	const vec3 weights = vec3( ${n}, ${t}, ${e} );`,"	return dot( weights, rgb );","}"].join(`
`)}function l_(n){return[n.extensionClipCullDistance?"#extension GL_ANGLE_clip_cull_distance : require":"",n.extensionMultiDraw?"#extension GL_ANGLE_multi_draw : require":""].filter(pa).join(`
`)}function c_(n){let t=[];for(let e in n){let i=n[e];i!==!1&&t.push("#define "+e+" "+i)}return t.join(`
`)}function h_(n,t){let e={},i=n.getProgramParameter(t,n.ACTIVE_ATTRIBUTES);for(let s=0;s<i;s++){let r=n.getActiveAttrib(t,s),a=r.name,o=1;r.type===n.FLOAT_MAT2&&(o=2),r.type===n.FLOAT_MAT3&&(o=3),r.type===n.FLOAT_MAT4&&(o=4),e[a]={type:r.type,location:n.getAttribLocation(t,a),locationSize:o}}return e}function pa(n){return n!==""}function $d(n,t){let e=t.numSpotLightShadows+t.numSpotLightMaps-t.numSpotLightShadowsWithMaps;return n.replace(/NUM_SUN_LIGHTS/g,t.numSunLights).replace(/NUM_DIR_LIGHTS/g,t.numDirLights).replace(/NUM_SPOT_LIGHTS/g,t.numSpotLights).replace(/NUM_SPOT_LIGHT_MAPS/g,t.numSpotLightMaps).replace(/NUM_SPOT_LIGHT_COORDS/g,e).replace(/NUM_RECT_AREA_LIGHTS/g,t.numRectAreaLights).replace(/NUM_POINT_LIGHTS/g,t.numPointLights).replace(/NUM_HEMI_LIGHTS/g,t.numHemiLights).replace(/NUM_SUN_LIGHT_SHADOWS/g,t.numSunLightShadows).replace(/NUM_DIR_LIGHT_SHADOWS/g,t.numDirLightShadows).replace(/NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS/g,t.numSpotLightShadowsWithMaps).replace(/NUM_SPOT_LIGHT_SHADOWS/g,t.numSpotLightShadows).replace(/NUM_POINT_LIGHT_SHADOWS/g,t.numPointLightShadows)}function Zd(n,t){return n.replace(/NUM_CLIPPING_PLANES/g,t.numClippingPlanes).replace(/UNION_CLIPPING_PLANES/g,t.numClippingPlanes-t.numClipIntersection)}var u_=/^[ \t]*#include +<([\w\d./]+)>/gm;function Dh(n){return n.replace(u_,f_)}var d_=new Map;function f_(n,t){let e=Jt[t];if(e===void 0){let i=d_.get(t);if(i!==void 0)e=Jt[i],kt('WebGLRenderer: Shader chunk "%s" has been deprecated. Use "%s" instead.',t,i);else throw new Error("THREE.WebGLProgram: Can not resolve #include <"+t+">")}return Dh(e)}var p_=/#pragma unroll_loop_start\s+for\s*\(\s*int\s+i\s*=\s*(\d+)\s*;\s*i\s*<\s*(\d+)\s*;\s*i\s*\+\+\s*\)\s*{([\s\S]+?)}\s+#pragma unroll_loop_end/g;function Jd(n){return n.replace(p_,m_)}function m_(n,t,e,i){let s="";for(let r=parseInt(t);r<parseInt(e);r++)s+=i.replace(/\[\s*i\s*\]/g,"[ "+r+" ]").replace(/UNROLLED_LOOP_INDEX/g,r);return s}function Kd(n){let t=`precision ${n.precision} float;
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
#define LOW_PRECISION`),t}var g_={[Qn]:"SHADOWMAP_TYPE_PCF",[Ws]:"SHADOWMAP_TYPE_VSM"};function x_(n){return g_[n.shadowMapType]||"SHADOWMAP_TYPE_BASIC"}var __={[Un]:"ENVMAP_TYPE_CUBE",[es]:"ENVMAP_TYPE_CUBE",[ia]:"ENVMAP_TYPE_CUBE_UV"};function v_(n){return n.envMap===!1?"ENVMAP_TYPE_CUBE":__[n.envMapMode]||"ENVMAP_TYPE_CUBE"}var y_={[es]:"ENVMAP_MODE_REFRACTION"};function M_(n){return n.envMap===!1?"ENVMAP_MODE_REFLECTION":y_[n.envMapMode]||"ENVMAP_MODE_REFLECTION"}var b_={[zo]:"ENVMAP_BLENDING_MULTIPLY",[md]:"ENVMAP_BLENDING_MIX",[gd]:"ENVMAP_BLENDING_ADD"};function S_(n){return n.envMap===!1?"ENVMAP_BLENDING_NONE":b_[n.combine]||"ENVMAP_BLENDING_NONE"}function w_(n){let t=n.envMapCubeUVHeight;if(t===null)return null;let e=Math.log2(t)-2,i=1/t;return{texelWidth:1/(3*Math.max(Math.pow(2,e),112)),texelHeight:i,maxMip:e}}function T_(n,t,e,i){let s=n.getContext(),r=e.defines,a=e.vertexShader,o=e.fragmentShader,l=x_(e),c=v_(e),h=M_(e),d=S_(e),u=w_(e),f=l_(e),g=c_(r),_=s.createProgram(),m,p,M=e.glslVersion?"#version "+e.glslVersion+`
`:"";e.isRawShaderMaterial?(m=["#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,g].filter(pa).join(`
`),m.length>0&&(m+=`
`),p=["#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,g].filter(pa).join(`
`),p.length>0&&(p+=`
`)):(m=[Kd(e),"#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,g,e.extensionClipCullDistance?"#define USE_CLIP_DISTANCE":"",e.batching?"#define USE_BATCHING":"",e.batchingColor?"#define USE_BATCHING_COLOR":"",e.instancing?"#define USE_INSTANCING":"",e.instancingColor?"#define USE_INSTANCING_COLOR":"",e.instancingMorph?"#define USE_INSTANCING_MORPH":"",e.useFog&&e.fog?"#define USE_FOG":"",e.useFog&&e.fogExp2?"#define FOG_EXP2":"",e.map?"#define USE_MAP":"",e.envMap?"#define USE_ENVMAP":"",e.envMap?"#define "+h:"",e.lightMap?"#define USE_LIGHTMAP":"",e.aoMap?"#define USE_AOMAP":"",e.bumpMap?"#define USE_BUMPMAP":"",e.normalMap?"#define USE_NORMALMAP":"",e.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",e.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",e.displacementMap?"#define USE_DISPLACEMENTMAP":"",e.emissiveMap?"#define USE_EMISSIVEMAP":"",e.anisotropy?"#define USE_ANISOTROPY":"",e.anisotropyMap?"#define USE_ANISOTROPYMAP":"",e.clearcoatMap?"#define USE_CLEARCOATMAP":"",e.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",e.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",e.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",e.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",e.specularMap?"#define USE_SPECULARMAP":"",e.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",e.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",e.roughnessMap?"#define USE_ROUGHNESSMAP":"",e.metalnessMap?"#define USE_METALNESSMAP":"",e.alphaMap?"#define USE_ALPHAMAP":"",e.alphaHash?"#define USE_ALPHAHASH":"",e.transmission?"#define USE_TRANSMISSION":"",e.transmissionMap?"#define USE_TRANSMISSIONMAP":"",e.thicknessMap?"#define USE_THICKNESSMAP":"",e.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",e.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",e.mapUv?"#define MAP_UV "+e.mapUv:"",e.alphaMapUv?"#define ALPHAMAP_UV "+e.alphaMapUv:"",e.lightMapUv?"#define LIGHTMAP_UV "+e.lightMapUv:"",e.aoMapUv?"#define AOMAP_UV "+e.aoMapUv:"",e.emissiveMapUv?"#define EMISSIVEMAP_UV "+e.emissiveMapUv:"",e.bumpMapUv?"#define BUMPMAP_UV "+e.bumpMapUv:"",e.normalMapUv?"#define NORMALMAP_UV "+e.normalMapUv:"",e.displacementMapUv?"#define DISPLACEMENTMAP_UV "+e.displacementMapUv:"",e.metalnessMapUv?"#define METALNESSMAP_UV "+e.metalnessMapUv:"",e.roughnessMapUv?"#define ROUGHNESSMAP_UV "+e.roughnessMapUv:"",e.anisotropyMapUv?"#define ANISOTROPYMAP_UV "+e.anisotropyMapUv:"",e.clearcoatMapUv?"#define CLEARCOATMAP_UV "+e.clearcoatMapUv:"",e.clearcoatNormalMapUv?"#define CLEARCOAT_NORMALMAP_UV "+e.clearcoatNormalMapUv:"",e.clearcoatRoughnessMapUv?"#define CLEARCOAT_ROUGHNESSMAP_UV "+e.clearcoatRoughnessMapUv:"",e.iridescenceMapUv?"#define IRIDESCENCEMAP_UV "+e.iridescenceMapUv:"",e.iridescenceThicknessMapUv?"#define IRIDESCENCE_THICKNESSMAP_UV "+e.iridescenceThicknessMapUv:"",e.sheenColorMapUv?"#define SHEEN_COLORMAP_UV "+e.sheenColorMapUv:"",e.sheenRoughnessMapUv?"#define SHEEN_ROUGHNESSMAP_UV "+e.sheenRoughnessMapUv:"",e.specularMapUv?"#define SPECULARMAP_UV "+e.specularMapUv:"",e.specularColorMapUv?"#define SPECULAR_COLORMAP_UV "+e.specularColorMapUv:"",e.specularIntensityMapUv?"#define SPECULAR_INTENSITYMAP_UV "+e.specularIntensityMapUv:"",e.transmissionMapUv?"#define TRANSMISSIONMAP_UV "+e.transmissionMapUv:"",e.thicknessMapUv?"#define THICKNESSMAP_UV "+e.thicknessMapUv:"",e.vertexTangents&&e.flatShading===!1?"#define USE_TANGENT":"",e.vertexNormals?"#define HAS_NORMAL":"",e.vertexColors?"#define USE_COLOR":"",e.vertexAlphas?"#define USE_COLOR_ALPHA":"",e.vertexUv1s?"#define USE_UV1":"",e.vertexUv2s?"#define USE_UV2":"",e.vertexUv3s?"#define USE_UV3":"",e.pointsUvs?"#define USE_POINTS_UV":"",e.flatShading?"#define FLAT_SHADED":"",e.skinning?"#define USE_SKINNING":"",e.morphTargets?"#define USE_MORPHTARGETS":"",e.morphNormals&&e.flatShading===!1?"#define USE_MORPHNORMALS":"",e.morphColors?"#define USE_MORPHCOLORS":"",e.morphTargetsCount>0?"#define MORPHTARGETS_TEXTURE_STRIDE "+e.morphTextureStride:"",e.morphTargetsCount>0?"#define MORPHTARGETS_COUNT "+e.morphTargetsCount:"",e.doubleSided?"#define DOUBLE_SIDED":"",e.flipSided?"#define FLIP_SIDED":"",e.shadowMapEnabled?"#define USE_SHADOWMAP":"",e.shadowMapEnabled?"#define "+l:"",e.sizeAttenuation?"#define USE_SIZEATTENUATION":"",e.numLightProbes>0?"#define USE_LIGHT_PROBES":"",e.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",e.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 modelMatrix;","uniform mat4 modelViewMatrix;","uniform mat4 projectionMatrix;","uniform mat4 viewMatrix;","uniform mat3 normalMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;","#ifdef USE_INSTANCING","	attribute mat4 instanceMatrix;","#endif","#ifdef USE_INSTANCING_COLOR","	attribute vec3 instanceColor;","#endif","#ifdef USE_INSTANCING_MORPH","	uniform sampler2D morphTexture;","#endif","attribute vec3 position;","attribute vec3 normal;","attribute vec2 uv;","#ifdef USE_UV1","	attribute vec2 uv1;","#endif","#ifdef USE_UV2","	attribute vec2 uv2;","#endif","#ifdef USE_UV3","	attribute vec2 uv3;","#endif","#ifdef USE_TANGENT","	attribute vec4 tangent;","#endif","#if defined( USE_COLOR_ALPHA )","	attribute vec4 color;","#elif defined( USE_COLOR )","	attribute vec3 color;","#endif","#ifdef USE_SKINNING","	attribute vec4 skinIndex;","	attribute vec4 skinWeight;","#endif",`
`].filter(pa).join(`
`),p=[Kd(e),"#define SHADER_TYPE "+e.shaderType,"#define SHADER_NAME "+e.shaderName,g,e.useFog&&e.fog?"#define USE_FOG":"",e.useFog&&e.fogExp2?"#define FOG_EXP2":"",e.alphaToCoverage?"#define ALPHA_TO_COVERAGE":"",e.map?"#define USE_MAP":"",e.matcap?"#define USE_MATCAP":"",e.envMap?"#define USE_ENVMAP":"",e.envMap?"#define "+c:"",e.envMap?"#define "+h:"",e.envMap?"#define "+d:"",u?"#define CUBEUV_TEXEL_WIDTH "+u.texelWidth:"",u?"#define CUBEUV_TEXEL_HEIGHT "+u.texelHeight:"",u?"#define CUBEUV_MAX_MIP "+u.maxMip+".0":"",e.lightMap?"#define USE_LIGHTMAP":"",e.aoMap?"#define USE_AOMAP":"",e.bumpMap?"#define USE_BUMPMAP":"",e.normalMap?"#define USE_NORMALMAP":"",e.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",e.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",e.packedNormalMap?"#define USE_PACKED_NORMALMAP":"",e.emissiveMap?"#define USE_EMISSIVEMAP":"",e.anisotropy?"#define USE_ANISOTROPY":"",e.anisotropyMap?"#define USE_ANISOTROPYMAP":"",e.clearcoat?"#define USE_CLEARCOAT":"",e.clearcoatMap?"#define USE_CLEARCOATMAP":"",e.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",e.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",e.dispersion?"#define USE_DISPERSION":"",e.retroreflection?"#define USE_RETROREFLECTION":"",e.iridescence?"#define USE_IRIDESCENCE":"",e.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",e.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",e.specularMap?"#define USE_SPECULARMAP":"",e.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",e.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",e.roughnessMap?"#define USE_ROUGHNESSMAP":"",e.metalnessMap?"#define USE_METALNESSMAP":"",e.alphaMap?"#define USE_ALPHAMAP":"",e.alphaTest?"#define USE_ALPHATEST":"",e.alphaHash?"#define USE_ALPHAHASH":"",e.sheen?"#define USE_SHEEN":"",e.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",e.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",e.transmission?"#define USE_TRANSMISSION":"",e.transmissionMap?"#define USE_TRANSMISSIONMAP":"",e.thicknessMap?"#define USE_THICKNESSMAP":"",e.vertexTangents&&e.flatShading===!1?"#define USE_TANGENT":"",e.vertexColors||e.instancingColor?"#define USE_COLOR":"",e.vertexAlphas||e.batchingColor?"#define USE_COLOR_ALPHA":"",e.vertexUv1s?"#define USE_UV1":"",e.vertexUv2s?"#define USE_UV2":"",e.vertexUv3s?"#define USE_UV3":"",e.pointsUvs?"#define USE_POINTS_UV":"",e.gradientMap?"#define USE_GRADIENTMAP":"",e.flatShading?"#define FLAT_SHADED":"",e.doubleSided?"#define DOUBLE_SIDED":"",e.flipSided?"#define FLIP_SIDED":"",e.shadowMapEnabled?"#define USE_SHADOWMAP":"",e.shadowMapEnabled?"#define "+l:"",e.premultipliedAlpha?"#define PREMULTIPLIED_ALPHA":"",e.numLightProbes>0?"#define USE_LIGHT_PROBES":"",e.numLightProbeGrids>0?"#define USE_LIGHT_PROBES_GRID":"",e.decodeVideoTexture?"#define DECODE_VIDEO_TEXTURE":"",e.decodeVideoTextureEmissive?"#define DECODE_VIDEO_TEXTURE_EMISSIVE":"",e.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",e.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 viewMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;",e.toneMapping!==Ui?"#define TONE_MAPPING":"",e.toneMapping!==Ui?Jt.tonemapping_pars_fragment:"",e.toneMapping!==Ui?a_("toneMapping",e.toneMapping):"",e.dithering?"#define DITHERING":"",e.opaque?"#define OPAQUE":"",Jt.colorspace_pars_fragment,s_("linearToOutputTexel",e.outputColorSpace),o_(),e.useDepthPacking?"#define DEPTH_PACKING "+e.depthPacking:"",`
`].filter(pa).join(`
`)),a=Dh(a),a=$d(a,e),a=Zd(a,e),o=Dh(o),o=$d(o,e),o=Zd(o,e),a=Jd(a),o=Jd(o),e.isRawShaderMaterial!==!0&&(M=`#version 300 es
`,m=[f,"#define attribute in","#define varying out","#define texture2D texture"].join(`
`)+`
`+m,p=["#define varying in",e.glslVersion===uh?"":"layout(location = 0) out highp vec4 pc_fragColor;",e.glslVersion===uh?"":"#define gl_FragColor pc_fragColor","#define gl_FragDepthEXT gl_FragDepth","#define texture2D texture","#define textureCube texture","#define texture2DProj textureProj","#define texture2DLodEXT textureLod","#define texture2DProjLodEXT textureProjLod","#define textureCubeLodEXT textureLod","#define texture2DGradEXT textureGrad","#define texture2DProjGradEXT textureProjGrad","#define textureCubeGradEXT textureGrad"].join(`
`)+`
`+p);let R=M+m+a,y=M+p+o,w=Xd(s,s.VERTEX_SHADER,R),S=Xd(s,s.FRAGMENT_SHADER,y);s.attachShader(_,w),s.attachShader(_,S),e.index0AttributeName!==void 0?s.bindAttribLocation(_,0,e.index0AttributeName):e.hasPositionAttribute===!0&&s.bindAttribLocation(_,0,"position"),s.linkProgram(_);function I(O){if(n.debug.checkShaderErrors){let L=s.getProgramInfoLog(_)||"",z=s.getShaderInfoLog(w)||"",D=s.getShaderInfoLog(S)||"",k=L.trim(),Y=z.trim(),q=D.trim(),Z=!0,V=!0;if(s.getProgramParameter(_,s.LINK_STATUS)===!1)if(Z=!1,typeof n.debug.onShaderError=="function")n.debug.onShaderError(s,_,w,S);else{let tt=Yd(s,w,"vertex"),rt=Yd(s,S,"fragment");Ht("WebGLProgram: Shader Error "+s.getError()+" - VALIDATE_STATUS "+s.getProgramParameter(_,s.VALIDATE_STATUS)+`

Material Name: `+O.name+`
Material Type: `+O.type+`

Program Info Log: `+k+`
`+tt+`
`+rt)}else k!==""?kt("WebGLProgram: Program Info Log:",k):(Y===""||q==="")&&(V=!1);V&&(O.diagnostics={runnable:Z,programLog:k,vertexShader:{log:Y,prefix:m},fragmentShader:{log:q,prefix:p}})}s.deleteShader(w),s.deleteShader(S),v=new Zs(s,_),A=h_(s,_)}let v;this.getUniforms=function(){return v===void 0&&I(this),v};let A;this.getAttributes=function(){return A===void 0&&I(this),A};let P=e.rendererExtensionParallelShaderCompile===!1;return this.isReady=function(){return P===!1&&(P=s.getProgramParameter(_,t_)),P},this.destroy=function(){i.releaseStatesOfProgram(this),s.deleteProgram(_),this.program=void 0},this.type=e.shaderType,this.name=e.shaderName,this.id=e_++,this.cacheKey=t,this.usedTimes=1,this.program=_,this.vertexShader=w,this.fragmentShader=S,this}var E_=0,Nh=class{constructor(){this.shaderCache=new Map,this.materialCache=new Map}update(t,e,i){let s=this._getShaderCacheForMaterial(t);return s.has(e)===!1&&(s.add(e),e.usedTimes++),s.has(i)===!1&&(s.add(i),i.usedTimes++),this}remove(t){let e=this.materialCache.get(t);for(let i of e)i.usedTimes--,i.usedTimes===0&&this.shaderCache.delete(i.code);return this.materialCache.delete(t),this}getVertexShaderStage(t){return this._getShaderStage(t.vertexShader)}getFragmentShaderStage(t){return this._getShaderStage(t.fragmentShader)}dispose(){this.shaderCache.clear(),this.materialCache.clear()}_getShaderCacheForMaterial(t){let e=this.materialCache,i=e.get(t);return i===void 0&&(i=new Set,e.set(t,i)),i}_getShaderStage(t){let e=this.shaderCache,i=e.get(t);return i===void 0&&(i=new Uh(t),e.set(t,i)),i}},Uh=class{constructor(t){this.id=E_++,this.code=t,this.usedTimes=0}};function A_(n){return n===zn||n===la||n===ca}function R_(n,t,e,i,s,r){let a=new Us,o=new Nh,l=new Set,c=[],h=new Map,d=i.logarithmicDepthBuffer,u=i.precision,f={MeshDepthMaterial:"depth",MeshDistanceMaterial:"distance",MeshNormalMaterial:"normal",MeshBasicMaterial:"basic",MeshLambertMaterial:"lambert",MeshPhongMaterial:"phong",MeshToonMaterial:"toon",MeshStandardMaterial:"physical",MeshPhysicalMaterial:"physical",MeshMatcapMaterial:"matcap",LineBasicMaterial:"basic",LineDashedMaterial:"dashed",PointsMaterial:"points",ShadowMaterial:"shadow",SpriteMaterial:"sprite"};function g(v){return l.add(v),v===0?"uv":`uv${v}`}function _(v,A,P,O,L,z){let D=O.fog,k=L.geometry,Y=v.isMeshStandardMaterial||v.isMeshLambertMaterial||v.isMeshPhongMaterial?O.environment:null,q=v.isMeshStandardMaterial||v.isMeshLambertMaterial&&!v.envMap||v.isMeshPhongMaterial&&!v.envMap,Z=t.get(v.envMap||Y,q),V=Z&&Z.mapping===ia?Z.image.height:null,tt=f[v.type];v.precision!==null&&(u=i.getMaxPrecision(v.precision),u!==v.precision&&kt("WebGLProgram.getParameters:",v.precision,"not supported, using",u,"instead."));let rt=k.morphAttributes.position||k.morphAttributes.normal||k.morphAttributes.color,St=rt!==void 0?rt.length:0,_t=0;k.morphAttributes.position!==void 0&&(_t=1),k.morphAttributes.normal!==void 0&&(_t=2),k.morphAttributes.color!==void 0&&(_t=3);let ee,Ct,$t,Q;if(tt){let ve=Zi[tt];ee=ve.vertexShader,Ct=ve.fragmentShader}else{ee=v.vertexShader,Ct=v.fragmentShader;let ve=o.getVertexShaderStage(v),ue=o.getFragmentShaderStage(v);o.update(v,ve,ue),$t=ve.id,Q=ue.id}let it=n.getRenderTarget(),Mt=n.state.buffers.depth.getReversed(),Ot=L.isInstancedMesh===!0,yt=L.isBatchedMesh===!0,qt=!!v.map,be=!!v.matcap,Yt=!!Z,Kt=!!v.aoMap,se=!!v.lightMap,Wt=!!v.bumpMap&&v.wireframe===!1,ie=!!v.normalMap,ne=!!v.displacementMap,T=!!v.emissiveMap,G=!!v.metalnessMap,J=!!v.roughnessMap,C=v.anisotropy>0,nt=v.clearcoat>0,dt=v.dispersion>0,E=v.retroreflectivity>0,x=v.iridescence>0,F=v.sheen>0,H=v.transmission>0,K=C&&!!v.anisotropyMap,ot=nt&&!!v.clearcoatMap,ut=nt&&!!v.clearcoatNormalMap,j=nt&&!!v.clearcoatRoughnessMap,et=x&&!!v.iridescenceMap,lt=x&&!!v.iridescenceThicknessMap,Dt=F&&!!v.sheenColorMap,ft=F&&!!v.sheenRoughnessMap,ct=!!v.specularMap,Rt=!!v.specularColorMap,Ft=!!v.specularIntensityMap,Vt=H&&!!v.transmissionMap,B=H&&!!v.thicknessMap,ht=!!v.gradientMap,st=!!v.alphaMap,pt=v.alphaTest>0,bt=!!v.alphaHash,at=!!v.extensions,zt=Ui;v.toneMapped&&(it===null||it.isXRRenderTarget===!0)&&(zt=n.toneMapping);let Lt={shaderID:tt,shaderType:v.type,shaderName:v.name,vertexShader:ee,fragmentShader:Ct,defines:v.defines,customVertexShaderID:$t,customFragmentShaderID:Q,isRawShaderMaterial:v.isRawShaderMaterial===!0,glslVersion:v.glslVersion,precision:u,batching:yt,batchingColor:yt&&L._colorsTexture!==null,instancing:Ot,instancingColor:Ot&&L.instanceColor!==null,instancingMorph:Ot&&L.morphTexture!==null,outputColorSpace:it===null?n.outputColorSpace:it.isXRRenderTarget===!0?it.texture.colorSpace:Qt.workingColorSpace,alphaToCoverage:!!v.alphaToCoverage,map:qt,matcap:be,envMap:Yt,envMapMode:Yt&&Z.mapping,envMapCubeUVHeight:V,aoMap:Kt,lightMap:se,bumpMap:Wt,normalMap:ie,displacementMap:ne,emissiveMap:T,normalMapObjectSpace:ie&&v.normalMapType===vd,normalMapTangentSpace:ie&&v.normalMapType===ha,packedNormalMap:ie&&v.normalMapType===ha&&A_(v.normalMap.format),metalnessMap:G,roughnessMap:J,anisotropy:C,anisotropyMap:K,clearcoat:nt,clearcoatMap:ot,clearcoatNormalMap:ut,clearcoatRoughnessMap:j,dispersion:dt,retroreflection:E,iridescence:x,iridescenceMap:et,iridescenceThicknessMap:lt,sheen:F,sheenColorMap:Dt,sheenRoughnessMap:ft,specularMap:ct,specularColorMap:Rt,specularIntensityMap:Ft,transmission:H,transmissionMap:Vt,thicknessMap:B,gradientMap:ht,opaque:v.transparent===!1&&v.blending===Nn&&v.alphaToCoverage===!1,alphaMap:st,alphaTest:pt,alphaHash:bt,combine:v.combine,mapUv:qt&&g(v.map.channel),aoMapUv:Kt&&g(v.aoMap.channel),lightMapUv:se&&g(v.lightMap.channel),bumpMapUv:Wt&&g(v.bumpMap.channel),normalMapUv:ie&&g(v.normalMap.channel),displacementMapUv:ne&&g(v.displacementMap.channel),emissiveMapUv:T&&g(v.emissiveMap.channel),metalnessMapUv:G&&g(v.metalnessMap.channel),roughnessMapUv:J&&g(v.roughnessMap.channel),anisotropyMapUv:K&&g(v.anisotropyMap.channel),clearcoatMapUv:ot&&g(v.clearcoatMap.channel),clearcoatNormalMapUv:ut&&g(v.clearcoatNormalMap.channel),clearcoatRoughnessMapUv:j&&g(v.clearcoatRoughnessMap.channel),iridescenceMapUv:et&&g(v.iridescenceMap.channel),iridescenceThicknessMapUv:lt&&g(v.iridescenceThicknessMap.channel),sheenColorMapUv:Dt&&g(v.sheenColorMap.channel),sheenRoughnessMapUv:ft&&g(v.sheenRoughnessMap.channel),specularMapUv:ct&&g(v.specularMap.channel),specularColorMapUv:Rt&&g(v.specularColorMap.channel),specularIntensityMapUv:Ft&&g(v.specularIntensityMap.channel),transmissionMapUv:Vt&&g(v.transmissionMap.channel),thicknessMapUv:B&&g(v.thicknessMap.channel),alphaMapUv:st&&g(v.alphaMap.channel),vertexTangents:!!k.attributes.tangent&&(ie||C),vertexNormals:!!k.attributes.normal,vertexColors:v.vertexColors,vertexAlphas:v.vertexColors===!0&&!!k.attributes.color&&k.attributes.color.itemSize===4,pointsUvs:L.isPoints===!0&&!!k.attributes.uv&&(qt||st),fog:!!D,useFog:v.fog===!0,fogExp2:!!D&&D.isFogExp2,flatShading:v.wireframe===!1&&(v.flatShading===!0||k.attributes.normal===void 0&&ie===!1&&(v.isMeshLambertMaterial||v.isMeshPhongMaterial||v.isMeshStandardMaterial||v.isMeshPhysicalMaterial)),sizeAttenuation:v.sizeAttenuation===!0,logarithmicDepthBuffer:d,reversedDepthBuffer:Mt,skinning:L.isSkinnedMesh===!0,hasPositionAttribute:k.attributes.position!==void 0,morphTargets:k.morphAttributes.position!==void 0,morphNormals:k.morphAttributes.normal!==void 0,morphColors:k.morphAttributes.color!==void 0,morphTargetsCount:St,morphTextureStride:_t,numSunLights:A.sun.length,numDirLights:A.directional.length,numPointLights:A.point.length,numSpotLights:A.spot.length,numSpotLightMaps:A.spotLightMap.length,numRectAreaLights:A.rectArea.length,numHemiLights:A.hemi.length,numSunLightShadows:A.sunShadowMap.length,numDirLightShadows:A.directionalShadowMap.length,numPointLightShadows:A.pointShadowMap.length,numSpotLightShadows:A.spotShadowMap.length,numSpotLightShadowsWithMaps:A.numSpotLightShadowsWithMaps,numLightProbes:A.numLightProbes,numLightProbeGrids:z.length,numClippingPlanes:r.numPlanes,numClipIntersection:r.numIntersection,dithering:v.dithering,shadowMapEnabled:n.shadowMap.enabled&&P.length>0,shadowMapType:n.shadowMap.type,toneMapping:zt,decodeVideoTexture:qt&&v.map.isVideoTexture===!0&&Qt.getTransfer(v.map.colorSpace)===ae,decodeVideoTextureEmissive:T&&v.emissiveMap.isVideoTexture===!0&&Qt.getTransfer(v.emissiveMap.colorSpace)===ae,premultipliedAlpha:v.premultipliedAlpha,doubleSided:v.side===ke,flipSided:v.side===Ze,useDepthPacking:v.depthPacking>=0,depthPacking:v.depthPacking||0,index0AttributeName:v.index0AttributeName,extensionClipCullDistance:at&&v.extensions.clipCullDistance===!0&&e.has("WEBGL_clip_cull_distance"),extensionMultiDraw:(at&&v.extensions.multiDraw===!0||yt)&&e.has("WEBGL_multi_draw"),rendererExtensionParallelShaderCompile:e.has("KHR_parallel_shader_compile"),customProgramCacheKey:v.customProgramCacheKey()};return Lt.vertexUv1s=l.has(1),Lt.vertexUv2s=l.has(2),Lt.vertexUv3s=l.has(3),l.clear(),Lt}function m(v){let A=[];if(v.shaderID?A.push(v.shaderID):(A.push(v.customVertexShaderID),A.push(v.customFragmentShaderID)),v.defines!==void 0)for(let P in v.defines)A.push(P),A.push(v.defines[P]);return v.isRawShaderMaterial===!1&&(p(A,v),M(A,v),A.push(n.outputColorSpace)),A.push(v.customProgramCacheKey),A.join()}function p(v,A){v.push(A.precision),v.push(A.outputColorSpace),v.push(A.envMapMode),v.push(A.envMapCubeUVHeight),v.push(A.mapUv),v.push(A.alphaMapUv),v.push(A.lightMapUv),v.push(A.aoMapUv),v.push(A.bumpMapUv),v.push(A.normalMapUv),v.push(A.displacementMapUv),v.push(A.emissiveMapUv),v.push(A.metalnessMapUv),v.push(A.roughnessMapUv),v.push(A.anisotropyMapUv),v.push(A.clearcoatMapUv),v.push(A.clearcoatNormalMapUv),v.push(A.clearcoatRoughnessMapUv),v.push(A.iridescenceMapUv),v.push(A.iridescenceThicknessMapUv),v.push(A.sheenColorMapUv),v.push(A.sheenRoughnessMapUv),v.push(A.specularMapUv),v.push(A.specularColorMapUv),v.push(A.specularIntensityMapUv),v.push(A.transmissionMapUv),v.push(A.thicknessMapUv),v.push(A.combine),v.push(A.fogExp2),v.push(A.sizeAttenuation),v.push(A.morphTargetsCount),v.push(A.morphAttributeCount),v.push(A.numSunLights),v.push(A.numDirLights),v.push(A.numPointLights),v.push(A.numSpotLights),v.push(A.numSpotLightMaps),v.push(A.numHemiLights),v.push(A.numRectAreaLights),v.push(A.numSunLightShadows),v.push(A.numDirLightShadows),v.push(A.numPointLightShadows),v.push(A.numSpotLightShadows),v.push(A.numSpotLightShadowsWithMaps),v.push(A.numLightProbes),v.push(A.shadowMapType),v.push(A.toneMapping),v.push(A.numClippingPlanes),v.push(A.numClipIntersection),v.push(A.depthPacking)}function M(v,A){a.disableAll(),A.instancing&&a.enable(0),A.instancingColor&&a.enable(1),A.instancingMorph&&a.enable(2),A.matcap&&a.enable(3),A.envMap&&a.enable(4),A.normalMapObjectSpace&&a.enable(5),A.normalMapTangentSpace&&a.enable(6),A.clearcoat&&a.enable(7),A.iridescence&&a.enable(8),A.alphaTest&&a.enable(9),A.vertexColors&&a.enable(10),A.vertexAlphas&&a.enable(11),A.vertexUv1s&&a.enable(12),A.vertexUv2s&&a.enable(13),A.vertexUv3s&&a.enable(14),A.vertexTangents&&a.enable(15),A.anisotropy&&a.enable(16),A.alphaHash&&a.enable(17),A.batching&&a.enable(18),A.dispersion&&a.enable(19),A.retroreflection&&a.enable(24),A.batchingColor&&a.enable(20),A.gradientMap&&a.enable(21),A.packedNormalMap&&a.enable(22),A.vertexNormals&&a.enable(23),v.push(a.mask),a.disableAll(),A.fog&&a.enable(0),A.useFog&&a.enable(1),A.flatShading&&a.enable(2),A.logarithmicDepthBuffer&&a.enable(3),A.reversedDepthBuffer&&a.enable(4),A.skinning&&a.enable(5),A.morphTargets&&a.enable(6),A.morphNormals&&a.enable(7),A.morphColors&&a.enable(8),A.premultipliedAlpha&&a.enable(9),A.shadowMapEnabled&&a.enable(10),A.doubleSided&&a.enable(11),A.flipSided&&a.enable(12),A.useDepthPacking&&a.enable(13),A.dithering&&a.enable(14),A.transmission&&a.enable(15),A.sheen&&a.enable(16),A.opaque&&a.enable(17),A.pointsUvs&&a.enable(18),A.decodeVideoTexture&&a.enable(19),A.decodeVideoTextureEmissive&&a.enable(20),A.alphaToCoverage&&a.enable(21),A.numLightProbeGrids>0&&a.enable(22),A.hasPositionAttribute&&a.enable(23),v.push(a.mask)}function R(v){let A=f[v.type],P;if(A){let O=Zi[A];P=dn.clone(O.uniforms)}else P=v.uniforms;return P}function y(v,A){let P=h.get(A);return P!==void 0?++P.usedTimes:(P=new T_(n,A,v,s),c.push(P),h.set(A,P)),P}function w(v){if(--v.usedTimes===0){let A=c.indexOf(v);c[A]=c[c.length-1],c.pop(),h.delete(v.cacheKey),v.destroy()}}function S(v){o.remove(v)}function I(){o.dispose()}return{getParameters:_,getProgramCacheKey:m,getUniforms:R,acquireProgram:y,releaseProgram:w,releaseShaderCache:S,programs:c,dispose:I}}function C_(){let n=new WeakMap;function t(a){return n.has(a)}function e(a){let o=n.get(a);return o===void 0&&(o={},n.set(a,o)),o}function i(a){n.delete(a)}function s(a,o,l){n.get(a)[o]=l}function r(){n=new WeakMap}return{has:t,get:e,remove:i,update:s,dispose:r}}function I_(n,t){return n.groupOrder!==t.groupOrder?n.groupOrder-t.groupOrder:n.renderOrder!==t.renderOrder?n.renderOrder-t.renderOrder:n.material.id!==t.material.id?n.material.id-t.material.id:n.materialVariant!==t.materialVariant?n.materialVariant-t.materialVariant:n.z!==t.z?n.z-t.z:n.id-t.id}function Qd(n,t){return n.groupOrder!==t.groupOrder?n.groupOrder-t.groupOrder:n.renderOrder!==t.renderOrder?n.renderOrder-t.renderOrder:n.z!==t.z?t.z-n.z:n.id-t.id}function jd(){let n=[],t=0,e=[],i=[],s=[];function r(){t=0,e.length=0,i.length=0,s.length=0}function a(u){let f=0;return u.isInstancedMesh&&(f+=2),u.isSkinnedMesh&&(f+=1),f}function o(u,f,g,_,m,p){let M=n[t];return M===void 0?(M={id:u.id,object:u,geometry:f,material:g,materialVariant:a(u),groupOrder:_,renderOrder:u.renderOrder,z:m,group:p},n[t]=M):(M.id=u.id,M.object=u,M.geometry=f,M.material=g,M.materialVariant=a(u),M.groupOrder=_,M.renderOrder=u.renderOrder,M.z=m,M.group=p),t++,M}function l(u,f,g,_,m,p,M){M.reversedDepth===!0&&(m=-m);let R=o(u,f,g,_,m,p);g.transmission>0?i.push(R):g.transparent===!0?s.push(R):e.push(R)}function c(u,f,g,_,m,p){let M=o(u,f,g,_,m,p);g.transmission>0?i.unshift(M):g.transparent===!0?s.unshift(M):e.unshift(M)}function h(u,f){e.length>1&&e.sort(u||I_),i.length>1&&i.sort(f||Qd),s.length>1&&s.sort(f||Qd)}function d(){for(let u=t,f=n.length;u<f;u++){let g=n[u];if(g.id===null)break;g.id=null,g.object=null,g.geometry=null,g.material=null,g.group=null}}return{opaque:e,transmissive:i,transparent:s,init:r,push:l,unshift:c,finish:d,sort:h}}function P_(){let n=new WeakMap;function t(i,s){let r=n.get(i),a;return r===void 0?(a=new jd,n.set(i,[a])):s>=r.length?(a=new jd,r.push(a)):a=r[s],a}function e(){n=new WeakMap}return{get:t,dispose:e}}function L_(){let n={};return{get:function(t){if(n[t.id]!==void 0)return n[t.id];let e;switch(t.type){case"SunLight":case"DirectionalLight":e={direction:new N,color:new Ut};break;case"SpotLight":e={position:new N,direction:new N,color:new Ut,distance:0,coneCos:0,penumbraCos:0,decay:0};break;case"PointLight":e={position:new N,color:new Ut,distance:0,decay:0};break;case"HemisphereLight":e={direction:new N,skyColor:new Ut,groundColor:new Ut};break;case"RectAreaLight":e={color:new Ut,position:new N,halfWidth:new N,halfHeight:new N};break}return n[t.id]=e,e}}}function D_(){let n={};return{get:function(t){if(n[t.id]!==void 0)return n[t.id];let e;switch(t.type){case"SunLight":case"DirectionalLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new xt};break;case"SpotLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new xt};break;case"PointLight":e={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new xt,shadowCameraNear:1,shadowCameraFar:1e3};break}return n[t.id]=e,e}}}var N_=0;function U_(n,t){return(t.castShadow?2:0)-(n.castShadow?2:0)+(t.map?1:0)-(n.map?1:0)}function F_(n){let t=new L_,e=D_(),i={version:0,hash:{sunLength:-1,directionalLength:-1,pointLength:-1,spotLength:-1,rectAreaLength:-1,hemiLength:-1,numSunShadows:-1,numDirectionalShadows:-1,numPointShadows:-1,numSpotShadows:-1,numSpotMaps:-1,numLightProbes:-1},ambient:[0,0,0],probe:[],sun:[],sunShadow:[],sunShadowMap:[],sunShadowMatrix:[],sunShadowCascade:[],directional:[],directionalShadow:[],directionalShadowMap:[],directionalShadowMatrix:[],spot:[],spotLightMap:[],spotShadow:[],spotShadowMap:[],spotLightMatrix:[],rectArea:[],rectAreaLTC1:null,rectAreaLTC2:null,point:[],pointShadow:[],pointShadowMap:[],pointShadowMatrix:[],hemi:[],numSpotLightShadowsWithMaps:0,numLightProbes:0};for(let c=0;c<9;c++)i.probe.push(new N);let s=new N,r=new oe,a=new oe;function o(c){let h=0,d=0,u=0;for(let L=0;L<9;L++)i.probe[L].set(0,0,0);let f=0,g=0,_=0,m=0,p=0,M=0,R=0,y=0,w=0,S=0,I=0,v=0,A=0,P=0;c.sort(U_);for(let L=0,z=c.length;L<z;L++){let D=c[L],k=D.color,Y=D.intensity,q=D.distance,Z=null;if(D.shadow&&D.shadow.map&&(D.shadow.map.texture.format===zn?Z=D.shadow.map.texture:Z=D.shadow.map.depthTexture||D.shadow.map.texture),D.isAmbientLight)h+=k.r*Y,d+=k.g*Y,u+=k.b*Y;else if(D.isLightProbe){for(let V=0;V<9;V++)i.probe[V].addScaledVector(D.sh.coefficients[V],Y);P++}else if(D.isSunLight){let V=t.get(D);if(V.color.copy(D.color).multiplyScalar(D.intensity),D.castShadow){let tt=D.shadow,rt=e.get(D);rt.shadowIntensity=tt.intensity,rt.shadowBias=tt.bias,rt.shadowNormalBias=tt.normalBias,rt.shadowRadius=tt.radius,rt.shadowMapSize.copy(tt.mapSize).multiply(tt.getFrameExtents()),i.sunShadow[g]=rt,i.sunShadowMap[g]=Z;let St=tt.getViewportCount();for(let _t=0;_t<St;_t++)i.sunShadowMatrix[_+_t]=tt.getMatrix(_t),i.sunShadowCascade[_+_t]=tt._cascadeData[_t];_+=St,g++}i.sun[f]=V,f++}else if(D.isDirectionalLight){let V=t.get(D);if(V.color.copy(D.color).multiplyScalar(D.intensity),D.castShadow){let tt=D.shadow,rt=e.get(D);rt.shadowIntensity=tt.intensity,rt.shadowBias=tt.bias,rt.shadowNormalBias=tt.normalBias,rt.shadowRadius=tt.radius,rt.shadowMapSize=tt.mapSize,i.directionalShadow[m]=rt,i.directionalShadowMap[m]=Z,i.directionalShadowMatrix[m]=D.shadow.matrix,w++}i.directional[m]=V,m++}else if(D.isSpotLight){let V=t.get(D);V.position.setFromMatrixPosition(D.matrixWorld),V.color.copy(k).multiplyScalar(Y),V.distance=q,V.coneCos=Math.cos(D.angle),V.penumbraCos=Math.cos(D.angle*(1-D.penumbra)),V.decay=D.decay,i.spot[M]=V;let tt=D.shadow;if(D.map&&(i.spotLightMap[v]=D.map,v++,tt.updateMatrices(D),D.castShadow&&A++),i.spotLightMatrix[M]=tt.matrix,D.castShadow){let rt=e.get(D);rt.shadowIntensity=tt.intensity,rt.shadowBias=tt.bias,rt.shadowNormalBias=tt.normalBias,rt.shadowRadius=tt.radius,rt.shadowMapSize=tt.mapSize,i.spotShadow[M]=rt,i.spotShadowMap[M]=Z,I++}M++}else if(D.isRectAreaLight){let V=t.get(D);V.color.copy(k).multiplyScalar(Y),V.halfWidth.set(D.width*.5,0,0),V.halfHeight.set(0,D.height*.5,0),i.rectArea[R]=V,R++}else if(D.isPointLight){let V=t.get(D);if(V.color.copy(D.color).multiplyScalar(D.intensity),V.distance=D.distance,V.decay=D.decay,D.castShadow){let tt=D.shadow,rt=e.get(D);rt.shadowIntensity=tt.intensity,rt.shadowBias=tt.bias,rt.shadowNormalBias=tt.normalBias,rt.shadowRadius=tt.radius,rt.shadowMapSize=tt.mapSize,rt.shadowCameraNear=tt.camera.near,rt.shadowCameraFar=tt.camera.far,i.pointShadow[p]=rt,i.pointShadowMap[p]=Z,i.pointShadowMatrix[p]=D.shadow.matrix,S++}i.point[p]=V,p++}else if(D.isHemisphereLight){let V=t.get(D);V.skyColor.copy(D.color).multiplyScalar(Y),V.groundColor.copy(D.groundColor).multiplyScalar(Y),i.hemi[y]=V,y++}}R>0&&(n.has("OES_texture_float_linear")===!0?(i.rectAreaLTC1=mt.LTC_FLOAT_1,i.rectAreaLTC2=mt.LTC_FLOAT_2):(i.rectAreaLTC1=mt.LTC_HALF_1,i.rectAreaLTC2=mt.LTC_HALF_2)),i.ambient[0]=h,i.ambient[1]=d,i.ambient[2]=u;let O=i.hash;(O.sunLength!==f||O.directionalLength!==m||O.pointLength!==p||O.spotLength!==M||O.rectAreaLength!==R||O.hemiLength!==y||O.numSunShadows!==g||O.numDirectionalShadows!==w||O.numPointShadows!==S||O.numSpotShadows!==I||O.numSpotMaps!==v||O.numLightProbes!==P)&&(i.sun.length=f,i.directional.length=m,i.spot.length=M,i.rectArea.length=R,i.point.length=p,i.hemi.length=y,i.sunShadow.length=g,i.sunShadowMap.length=g,i.sunShadowMatrix.length=_,i.sunShadowCascade.length=_,i.directionalShadow.length=w,i.directionalShadowMap.length=w,i.directionalShadowMatrix.length=w,i.pointShadow.length=S,i.pointShadowMap.length=S,i.pointShadowMatrix.length=S,i.spotShadow.length=I,i.spotShadowMap.length=I,i.spotLightMatrix.length=I+v-A,i.spotLightMap.length=v,i.numSpotLightShadowsWithMaps=A,i.numLightProbes=P,O.sunLength=f,O.directionalLength=m,O.pointLength=p,O.spotLength=M,O.rectAreaLength=R,O.hemiLength=y,O.numSunShadows=g,O.numDirectionalShadows=w,O.numPointShadows=S,O.numSpotShadows=I,O.numSpotMaps=v,O.numLightProbes=P,i.version=N_++)}function l(c,h){let d=0,u=0,f=0,g=0,_=0,m=0,p=h.matrixWorldInverse;for(let M=0,R=c.length;M<R;M++){let y=c[M];if(y.isSunLight){let w=i.sun[d];w.direction.setFromMatrixPosition(y.matrixWorld),w.direction.transformDirection(p),d++}else if(y.isDirectionalLight){let w=i.directional[u];w.direction.setFromMatrixPosition(y.matrixWorld),s.setFromMatrixPosition(y.target.matrixWorld),w.direction.sub(s),w.direction.transformDirection(p),u++}else if(y.isSpotLight){let w=i.spot[g];w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(p),w.direction.setFromMatrixPosition(y.matrixWorld),s.setFromMatrixPosition(y.target.matrixWorld),w.direction.sub(s),w.direction.transformDirection(p),g++}else if(y.isRectAreaLight){let w=i.rectArea[_];w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(p),a.identity(),r.copy(y.matrixWorld),r.premultiply(p),a.extractRotation(r),w.halfWidth.set(y.width*.5,0,0),w.halfHeight.set(0,y.height*.5,0),w.halfWidth.applyMatrix4(a),w.halfHeight.applyMatrix4(a),_++}else if(y.isPointLight){let w=i.point[f];w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(p),f++}else if(y.isHemisphereLight){let w=i.hemi[m];w.direction.setFromMatrixPosition(y.matrixWorld),w.direction.transformDirection(p),m++}}}return{setup:o,setupView:l,state:i}}function tf(n){let t=new F_(n),e=[],i=[],s=[];function r(u){d.camera=u,e.length=0,i.length=0,s.length=0}function a(u){e.push(u)}function o(u){i.push(u)}function l(u){s.push(u)}function c(){t.setup(e)}function h(u){t.setupView(e,u)}let d={lightsArray:e,shadowsArray:i,lightProbeGridArray:s,camera:null,lights:t,transmissionRenderTarget:{},textureUnits:0};return{init:r,state:d,setupLights:c,setupLightsView:h,pushLight:a,pushShadow:o,pushLightProbeGrid:l}}function z_(n){let t=new WeakMap;function e(s,r=0){let a=t.get(s),o;return a===void 0?(o=new tf(n),t.set(s,[o])):r>=a.length?(o=new tf(n),a.push(o)):o=a[r],o}function i(){t=new WeakMap}return{get:e,dispose:i}}var B_=`void main() {
	gl_Position = vec4( position, 1.0 );
}`,O_=`uniform sampler2D shadow_pass;
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
}`,k_=[new N(1,0,0),new N(-1,0,0),new N(0,1,0),new N(0,-1,0),new N(0,0,1),new N(0,0,-1)],H_=[new N(0,-1,0),new N(0,-1,0),new N(0,0,1),new N(0,0,-1),new N(0,-1,0),new N(0,-1,0)],ef=new oe,fa=new N,Rh=new N;function V_(n,t,e){let i=new ks,s=new xt,r=new xt,a=new Ae,o=new bo,l=new So,c={},h=e.maxTextureSize,d={[Dn]:Ze,[Ze]:Dn,[ke]:ke},u=new Te({defines:{VSM_SAMPLES:8},uniforms:{shadow_pass:{value:null},resolution:{value:new xt},radius:{value:4}},vertexShader:B_,fragmentShader:O_}),f=u.clone();f.defines.HORIZONTAL_PASS=1;let g=new ce;g.setAttribute("position",new ze(new Float32Array([-1,-1,.5,3,-1,.5,-1,3,.5]),3));let _=new Tt(g,u),m=this;this.enabled=!1,this.autoUpdate=!0,this.needsUpdate=!1,this.type=Qn;let p=this.type;this.render=function(S,I,v){if(m.enabled===!1||m.autoUpdate===!1&&m.needsUpdate===!1||S.length===0)return;this.type===Ju&&(kt("WebGLShadowMap: PCFSoftShadowMap has been removed. Using PCFShadowMap instead."),this.type=Qn);let A=n.getRenderTarget(),P=n.getActiveCubeFace(),O=n.getActiveMipmapLevel(),L=n.state;L.setBlending(Mi),L.buffers.depth.getReversed()===!0?L.buffers.color.setClear(0,0,0,0):L.buffers.color.setClear(1,1,1,1),L.buffers.depth.setTest(!0),L.setScissorTest(!1);let z=p!==this.type;z&&I.traverse(function(D){D.material&&(Array.isArray(D.material)?D.material.forEach(k=>k.needsUpdate=!0):D.material.needsUpdate=!0)});for(let D=0,k=S.length;D<k;D++){let Y=S[D],q=Y.shadow;if(q===void 0){kt("WebGLShadowMap:",Y,"has no shadow.");continue}if(q.autoUpdate===!1&&q.needsUpdate===!1)continue;s.copy(q.mapSize);let Z=q.getFrameExtents();s.multiply(Z),r.copy(q.mapSize),(s.x>h||s.y>h)&&(s.x>h&&(r.x=Math.floor(h/Z.x),s.x=r.x*Z.x,q.mapSize.x=r.x),s.y>h&&(r.y=Math.floor(h/Z.y),s.y=r.y*Z.y,q.mapSize.y=r.y));let V=n.state.buffers.depth.getReversed();if(q.camera._reversedDepth=V,q.map===null||z===!0){if(q.map!==null&&(q.map.depthTexture!==null&&(q.map.depthTexture.dispose(),q.map.depthTexture=null),q.map.dispose()),this.type===Ws){if(Y.isPointLight){kt("WebGLShadowMap: VSM shadow maps are not supported for PointLights. Use PCF or BasicShadowMap instead.");continue}q.map=new Re(s.x,s.y,{format:zn,type:He,minFilter:Oe,magFilter:Oe,generateMipmaps:!1}),q.map.texture.name=Y.name+".shadowMap",q.map.depthTexture=new An(s.x,s.y,bi),q.map.depthTexture.name=Y.name+".shadowMapDepth",q.map.depthTexture.format=Gi,q.map.depthTexture.compareFunction=null,q.map.depthTexture.minFilter=qe,q.map.depthTexture.magFilter=qe}else Y.isPointLight?(q.map=new Rl(s.x),q.map.depthTexture=new yo(s.x,Fi)):(q.map=new Re(s.x,s.y),q.map.depthTexture=new An(s.x,s.y,Fi)),q.map.depthTexture.name=Y.name+".shadowMap",q.map.depthTexture.format=Gi,this.type===Qn?(q.map.depthTexture.compareFunction=V?Tl:wl,q.map.depthTexture.minFilter=Oe,q.map.depthTexture.magFilter=Oe):(q.map.depthTexture.compareFunction=null,q.map.depthTexture.minFilter=qe,q.map.depthTexture.magFilter=qe);q.camera.updateProjectionMatrix()}q.map.isWebGLCubeRenderTarget!==!0&&(q.map.width!==s.x||q.map.height!==s.y)&&q.map.setSize(s.x,s.y);let tt=q.map.isWebGLCubeRenderTarget?6:q.getViewportCount();Y.isPointLight!==!0&&q.updateMatrices(Y,v);for(let rt=0;rt<tt;rt++){let St=q.getCamera(rt);if(Y.isPointLight){let _t=q.camera,ee=q.matrix,Ct=Y.distance||_t.far;Ct!==_t.far&&(_t.far=Ct,_t.updateProjectionMatrix()),fa.setFromMatrixPosition(Y.matrixWorld),_t.position.copy(fa),Rh.copy(_t.position),Rh.add(k_[rt]),_t.up.copy(H_[rt]),_t.lookAt(Rh),_t.updateMatrixWorld(),ee.makeTranslation(-fa.x,-fa.y,-fa.z),ef.multiplyMatrices(_t.projectionMatrix,_t.matrixWorldInverse),q._frustum.setFromProjectionMatrix(ef,_t.coordinateSystem,_t.reversedDepth)}if(q.map.isWebGLCubeRenderTarget)n.setRenderTarget(q.map,rt),n.clear();else{rt===0&&(n.setRenderTarget(q.map),n.clear());let _t=q.getViewport(rt);a.set(r.x*_t.x,r.y*_t.y,r.x*_t.z,r.y*_t.w),L.viewport(a)}i=q.getFrustum(rt),y(I,v,St,Y,this.type)}q.isPointLightShadow!==!0&&this.type===Ws&&M(q,v),q.needsUpdate=!1}p=this.type,m.needsUpdate=!1,n.setRenderTarget(A,P,O)};function M(S,I){let v=t.update(_);u.defines.VSM_SAMPLES!==S.blurSamples&&(u.defines.VSM_SAMPLES=S.blurSamples,f.defines.VSM_SAMPLES=S.blurSamples,u.needsUpdate=!0,f.needsUpdate=!0),S.mapPass===null?S.mapPass=new Re(s.x,s.y,{format:zn,type:He}):(S.mapPass.width!==S.map.width||S.mapPass.height!==S.map.height)&&S.mapPass.setSize(S.map.width,S.map.height),u.uniforms.shadow_pass.value=S.map.depthTexture,u.uniforms.resolution.value.set(S.map.width,S.map.height),u.uniforms.radius.value=S.radius,n.setRenderTarget(S.mapPass),n.clear(),n.renderBufferDirect(I,null,v,u,_,null),f.uniforms.shadow_pass.value=S.mapPass.texture,f.uniforms.resolution.value.set(S.map.width,S.map.height),f.uniforms.radius.value=S.radius,n.setRenderTarget(S.map),n.clear(),n.renderBufferDirect(I,null,v,f,_,null)}function R(S,I,v,A){let P=null,O=v.isPointLight===!0?S.customDistanceMaterial:S.customDepthMaterial;if(O!==void 0)P=O;else if(P=v.isPointLight===!0?l:o,n.localClippingEnabled&&I.clipShadows===!0&&Array.isArray(I.clippingPlanes)&&I.clippingPlanes.length!==0||I.displacementMap&&I.displacementScale!==0||I.alphaMap&&I.alphaTest>0||I.map&&I.alphaTest>0||I.alphaToCoverage===!0){let L=P.uuid,z=I.uuid,D=c[L];D===void 0&&(D={},c[L]=D);let k=D[z];k===void 0&&(k=P.clone(),D[z]=k,I.addEventListener("dispose",w)),P=k}if(P.visible=I.visible,P.wireframe=I.wireframe,A===Ws?P.side=I.shadowSide!==null?I.shadowSide:I.side:P.side=I.shadowSide!==null?I.shadowSide:d[I.side],P.alphaMap=I.alphaMap,P.alphaTest=I.alphaToCoverage===!0?.5:I.alphaTest,P.map=I.map,P.clipShadows=I.clipShadows,P.clippingPlanes=I.clippingPlanes,P.clipIntersection=I.clipIntersection,P.displacementMap=I.displacementMap,P.displacementScale=I.displacementScale,P.displacementBias=I.displacementBias,P.wireframeLinewidth=I.wireframeLinewidth,P.linewidth=I.linewidth,v.isPointLight===!0&&P.isMeshDistanceMaterial===!0){let L=n.properties.get(P);L.light=v}return P}function y(S,I,v,A,P){if(S.visible===!1)return;if(S.layers.test(I.layers)&&(S.isMesh||S.isLine||S.isPoints)&&(S.castShadow||S.receiveShadow&&P===Ws)&&(!S.frustumCulled||S.intersectsFrustum(i))){S.modelViewMatrix.multiplyMatrices(v.matrixWorldInverse,S.matrixWorld);let z=t.update(S),D=S.material;if(Array.isArray(D)){let k=z.groups;for(let Y=0,q=k.length;Y<q;Y++){let Z=k[Y],V=D[Z.materialIndex];if(V&&V.visible){let tt=R(S,V,A,P);S.onBeforeShadow(n,S,I,v,z,tt,Z),n.renderBufferDirect(v,null,z,tt,S,Z),S.onAfterShadow(n,S,I,v,z,tt,Z)}}}else if(D.visible){let k=R(S,D,A,P);S.onBeforeShadow(n,S,I,v,z,k,null),n.renderBufferDirect(v,null,z,k,S,null),S.onAfterShadow(n,S,I,v,z,k,null)}}let L=S.children;for(let z=0,D=L.length;z<D;z++)y(L[z],I,v,A,P)}function w(S){S.target.removeEventListener("dispose",w);for(let v in c){let A=c[v],P=S.target.uuid;P in A&&(A[P].dispose(),delete A[P])}}}function G_(n,t){function e(){let B=!1,ht=new Ae,st=null,pt=new Ae(0,0,0,0);return{setMask:function(bt){st!==bt&&!B&&(n.colorMask(bt,bt,bt,bt),st=bt)},setLocked:function(bt){B=bt},setClear:function(bt,at,zt,Lt,ve){ve===!0&&(bt*=Lt,at*=Lt,zt*=Lt),ht.set(bt,at,zt,Lt),pt.equals(ht)===!1&&(n.clearColor(bt,at,zt,Lt),pt.copy(ht))},reset:function(){B=!1,st=null,pt.set(-1,0,0,0)}}}function i(){let B=!1,ht=!1,st=null,pt=null,bt=null;return{setReversed:function(at){if(ht!==at){let zt=t.get("EXT_clip_control");at?zt.clipControlEXT(zt.LOWER_LEFT_EXT,zt.ZERO_TO_ONE_EXT):zt.clipControlEXT(zt.LOWER_LEFT_EXT,zt.NEGATIVE_ONE_TO_ONE_EXT),ht=at;let Lt=bt;bt=null,this.setClear(Lt)}},getReversed:function(){return ht},setTest:function(at){at?it(n.DEPTH_TEST):Mt(n.DEPTH_TEST)},setMask:function(at){st!==at&&!B&&(n.depthMask(at),st=at)},setFunc:function(at){if(ht&&(at=Id[at]),pt!==at){switch(at){case so:n.depthFunc(n.NEVER);break;case ro:n.depthFunc(n.ALWAYS);break;case ao:n.depthFunc(n.LESS);break;case Cs:n.depthFunc(n.LEQUAL);break;case oo:n.depthFunc(n.EQUAL);break;case lo:n.depthFunc(n.GEQUAL);break;case Is:n.depthFunc(n.GREATER);break;case co:n.depthFunc(n.NOTEQUAL);break;default:n.depthFunc(n.LEQUAL)}pt=at}},setLocked:function(at){B=at},setClear:function(at){bt!==at&&(bt=at,ht&&(at=1-at),n.clearDepth(at))},reset:function(){B=!1,st=null,pt=null,bt=null,ht=!1}}}function s(){let B=!1,ht=null,st=null,pt=null,bt=null,at=null,zt=null,Lt=null,ve=null;return{setTest:function(ue){B||(ue?it(n.STENCIL_TEST):Mt(n.STENCIL_TEST))},setMask:function(ue){ht!==ue&&!B&&(n.stencilMask(ue),ht=ue)},setFunc:function(ue,Ri,Oi){(st!==ue||pt!==Ri||bt!==Oi)&&(n.stencilFunc(ue,Ri,Oi),st=ue,pt=Ri,bt=Oi)},setOp:function(ue,Ri,Oi){(at!==ue||zt!==Ri||Lt!==Oi)&&(n.stencilOp(ue,Ri,Oi),at=ue,zt=Ri,Lt=Oi)},setLocked:function(ue){B=ue},setClear:function(ue){ve!==ue&&(n.clearStencil(ue),ve=ue)},reset:function(){B=!1,ht=null,st=null,pt=null,bt=null,at=null,zt=null,Lt=null,ve=null}}}let r=new e,a=new i,o=new s,l=new WeakMap,c=new WeakMap,h={},d={},u={},f=new WeakMap,g=[],_=null,m=!1,p=null,M=null,R=null,y=null,w=null,S=null,I=null,v=new Ut(0,0,0),A=0,P=!1,O=null,L=null,z=null,D=null,k=null,Y=n.getParameter(n.MAX_COMBINED_TEXTURE_IMAGE_UNITS),q=!1,Z=0,V=n.getParameter(n.VERSION);V.indexOf("WebGL")!==-1?(Z=parseFloat(/^WebGL (\d)/.exec(V)[1]),q=Z>=1):V.indexOf("OpenGL ES")!==-1&&(Z=parseFloat(/^OpenGL ES (\d)/.exec(V)[1]),q=Z>=2);let tt=null,rt={},St=n.getParameter(n.SCISSOR_BOX),_t=n.getParameter(n.VIEWPORT),ee=new Ae().fromArray(St),Ct=new Ae().fromArray(_t);function $t(B,ht,st,pt){let bt=new Uint8Array(4),at=n.createTexture();n.bindTexture(B,at),n.texParameteri(B,n.TEXTURE_MIN_FILTER,n.NEAREST),n.texParameteri(B,n.TEXTURE_MAG_FILTER,n.NEAREST);for(let zt=0;zt<st;zt++)B===n.TEXTURE_3D||B===n.TEXTURE_2D_ARRAY?n.texImage3D(ht,0,n.RGBA,1,1,pt,0,n.RGBA,n.UNSIGNED_BYTE,bt):n.texImage2D(ht+zt,0,n.RGBA,1,1,0,n.RGBA,n.UNSIGNED_BYTE,bt);return at}let Q={};Q[n.TEXTURE_2D]=$t(n.TEXTURE_2D,n.TEXTURE_2D,1),Q[n.TEXTURE_CUBE_MAP]=$t(n.TEXTURE_CUBE_MAP,n.TEXTURE_CUBE_MAP_POSITIVE_X,6),Q[n.TEXTURE_2D_ARRAY]=$t(n.TEXTURE_2D_ARRAY,n.TEXTURE_2D_ARRAY,1,1),Q[n.TEXTURE_3D]=$t(n.TEXTURE_3D,n.TEXTURE_3D,1,1),r.setClear(0,0,0,1),a.setClear(1),o.setClear(0),it(n.DEPTH_TEST),a.setFunc(Cs),Wt(!1),ie(Qc),it(n.CULL_FACE),Kt(Mi);function it(B){h[B]!==!0&&(n.enable(B),h[B]=!0)}function Mt(B){h[B]!==!1&&(n.disable(B),h[B]=!1)}function Ot(B,ht){return u[B]!==ht?(n.bindFramebuffer(B,ht),u[B]=ht,B===n.DRAW_FRAMEBUFFER&&(u[n.FRAMEBUFFER]=ht),B===n.FRAMEBUFFER&&(u[n.DRAW_FRAMEBUFFER]=ht),!0):!1}function yt(B,ht){let st=g,pt=!1;if(B){st=f.get(ht),st===void 0&&(st=[],f.set(ht,st));let bt=B.textures;if(st.length!==bt.length||st[0]!==n.COLOR_ATTACHMENT0){for(let at=0,zt=bt.length;at<zt;at++)st[at]=n.COLOR_ATTACHMENT0+at;st.length=bt.length,pt=!0}}else st[0]!==n.BACK&&(st[0]=n.BACK,pt=!0);pt&&n.drawBuffers(st)}function qt(B){return _!==B?(n.useProgram(B),_=B,!0):!1}let be={[jn]:n.FUNC_ADD,[Qu]:n.FUNC_SUBTRACT,[ju]:n.FUNC_REVERSE_SUBTRACT};be[td]=n.MIN,be[ed]=n.MAX;let Yt={[id]:n.ZERO,[nd]:n.ONE,[sd]:n.SRC_COLOR,[eh]:n.SRC_ALPHA,[hd]:n.SRC_ALPHA_SATURATE,[ld]:n.DST_COLOR,[ad]:n.DST_ALPHA,[rd]:n.ONE_MINUS_SRC_COLOR,[ih]:n.ONE_MINUS_SRC_ALPHA,[cd]:n.ONE_MINUS_DST_COLOR,[od]:n.ONE_MINUS_DST_ALPHA,[ud]:n.CONSTANT_COLOR,[dd]:n.ONE_MINUS_CONSTANT_COLOR,[fd]:n.CONSTANT_ALPHA,[pd]:n.ONE_MINUS_CONSTANT_ALPHA};function Kt(B,ht,st,pt,bt,at,zt,Lt,ve,ue){if(B===Mi){m===!0&&(Mt(n.BLEND),m=!1);return}if(m===!1&&(it(n.BLEND),m=!0),B!==Ku){if(B!==p||ue!==P){if((M!==jn||w!==jn)&&(n.blendEquation(n.FUNC_ADD),M=jn,w=jn),ue)switch(B){case Nn:n.blendFuncSeparate(n.ONE,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Be:n.blendFunc(n.ONE,n.ONE);break;case jc:n.blendFuncSeparate(n.ZERO,n.ONE_MINUS_SRC_COLOR,n.ZERO,n.ONE);break;case th:n.blendFuncSeparate(n.DST_COLOR,n.ONE_MINUS_SRC_ALPHA,n.ZERO,n.ONE);break;default:Ht("WebGLState: Invalid blending: ",B);break}else switch(B){case Nn:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Be:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE,n.ONE,n.ONE);break;case jc:Ht("WebGLState: SubtractiveBlending requires material.premultipliedAlpha = true");break;case th:Ht("WebGLState: MultiplyBlending requires material.premultipliedAlpha = true");break;default:Ht("WebGLState: Invalid blending: ",B);break}R=null,y=null,S=null,I=null,v.set(0,0,0),A=0,p=B,P=ue}return}bt=bt||ht,at=at||st,zt=zt||pt,(ht!==M||bt!==w)&&(n.blendEquationSeparate(be[ht],be[bt]),M=ht,w=bt),(st!==R||pt!==y||at!==S||zt!==I)&&(n.blendFuncSeparate(Yt[st],Yt[pt],Yt[at],Yt[zt]),R=st,y=pt,S=at,I=zt),(Lt.equals(v)===!1||ve!==A)&&(n.blendColor(Lt.r,Lt.g,Lt.b,ve),v.copy(Lt),A=ve),p=B,P=!1}function se(B,ht){B.side===ke?Mt(n.CULL_FACE):it(n.CULL_FACE);let st=B.side===Ze;ht&&(st=!st),Wt(st),B.blending===Nn&&B.transparent===!1?Kt(Mi):Kt(B.blending,B.blendEquation,B.blendSrc,B.blendDst,B.blendEquationAlpha,B.blendSrcAlpha,B.blendDstAlpha,B.blendColor,B.blendAlpha,B.premultipliedAlpha),a.setFunc(B.depthFunc),a.setTest(B.depthTest),a.setMask(B.depthWrite),r.setMask(B.colorWrite);let pt=B.stencilWrite;o.setTest(pt),pt&&(o.setMask(B.stencilWriteMask),o.setFunc(B.stencilFunc,B.stencilRef,B.stencilFuncMask),o.setOp(B.stencilFail,B.stencilZFail,B.stencilZPass)),T(B.polygonOffset,B.polygonOffsetFactor,B.polygonOffsetUnits),B.alphaToCoverage===!0?it(n.SAMPLE_ALPHA_TO_COVERAGE):Mt(n.SAMPLE_ALPHA_TO_COVERAGE)}function Wt(B){O!==B&&(B?n.frontFace(n.CW):n.frontFace(n.CCW),O=B)}function ie(B){B!==$u?(it(n.CULL_FACE),B!==L&&(B===Qc?n.cullFace(n.BACK):B===Zu?n.cullFace(n.FRONT):n.cullFace(n.FRONT_AND_BACK))):Mt(n.CULL_FACE),L=B}function ne(B){B!==z&&(q&&n.lineWidth(B),z=B)}function T(B,ht,st){B?(it(n.POLYGON_OFFSET_FILL),(D!==ht||k!==st)&&(D=ht,k=st,a.getReversed()&&(ht=-ht),n.polygonOffset(ht,st))):Mt(n.POLYGON_OFFSET_FILL)}function G(B){B?it(n.SCISSOR_TEST):Mt(n.SCISSOR_TEST)}function J(B){B===void 0&&(B=n.TEXTURE0+Y-1),tt!==B&&(n.activeTexture(B),tt=B)}function C(B,ht,st){st===void 0&&(tt===null?st=n.TEXTURE0+Y-1:st=tt);let pt=rt[st];pt===void 0&&(pt={type:void 0,texture:void 0},rt[st]=pt),(pt.type!==B||pt.texture!==ht)&&(tt!==st&&(n.activeTexture(st),tt=st),n.bindTexture(B,ht||Q[B]),pt.type=B,pt.texture=ht)}function nt(){let B=rt[tt];B!==void 0&&B.type!==void 0&&(n.bindTexture(B.type,null),B.type=void 0,B.texture=void 0)}function dt(){try{n.compressedTexImage2D(...arguments)}catch(B){Ht("WebGLState:",B)}}function E(){try{n.compressedTexImage3D(...arguments)}catch(B){Ht("WebGLState:",B)}}function x(){try{n.texSubImage2D(...arguments)}catch(B){Ht("WebGLState:",B)}}function F(){try{n.texSubImage3D(...arguments)}catch(B){Ht("WebGLState:",B)}}function H(){try{n.compressedTexSubImage2D(...arguments)}catch(B){Ht("WebGLState:",B)}}function K(){try{n.compressedTexSubImage3D(...arguments)}catch(B){Ht("WebGLState:",B)}}function ot(){try{n.texStorage2D(...arguments)}catch(B){Ht("WebGLState:",B)}}function ut(){try{n.texStorage3D(...arguments)}catch(B){Ht("WebGLState:",B)}}function j(){try{n.texImage2D(...arguments)}catch(B){Ht("WebGLState:",B)}}function et(){try{n.texImage3D(...arguments)}catch(B){Ht("WebGLState:",B)}}function lt(B){return d[B]!==void 0?d[B]:n.getParameter(B)}function Dt(B,ht){d[B]!==ht&&(n.pixelStorei(B,ht),d[B]=ht)}function ft(B){ee.equals(B)===!1&&(n.scissor(B.x,B.y,B.z,B.w),ee.copy(B))}function ct(B){Ct.equals(B)===!1&&(n.viewport(B.x,B.y,B.z,B.w),Ct.copy(B))}function Rt(B,ht){let st=c.get(ht);st===void 0&&(st=new WeakMap,c.set(ht,st));let pt=st.get(B);pt===void 0&&(pt=n.getUniformBlockIndex(ht,B.name),st.set(B,pt))}function Ft(B,ht){let pt=c.get(ht).get(B);l.get(ht)!==pt&&(n.uniformBlockBinding(ht,pt,B.__bindingPointIndex),l.set(ht,pt))}function Vt(){n.disable(n.BLEND),n.disable(n.CULL_FACE),n.disable(n.DEPTH_TEST),n.disable(n.POLYGON_OFFSET_FILL),n.disable(n.SCISSOR_TEST),n.disable(n.STENCIL_TEST),n.disable(n.SAMPLE_ALPHA_TO_COVERAGE),n.blendEquation(n.FUNC_ADD),n.blendFunc(n.ONE,n.ZERO),n.blendFuncSeparate(n.ONE,n.ZERO,n.ONE,n.ZERO),n.blendColor(0,0,0,0),n.colorMask(!0,!0,!0,!0),n.clearColor(0,0,0,0),n.depthMask(!0),n.depthFunc(n.LESS),a.setReversed(!1),n.clearDepth(1),n.stencilMask(4294967295),n.stencilFunc(n.ALWAYS,0,4294967295),n.stencilOp(n.KEEP,n.KEEP,n.KEEP),n.clearStencil(0),n.cullFace(n.BACK),n.frontFace(n.CCW),n.polygonOffset(0,0),n.activeTexture(n.TEXTURE0),n.bindFramebuffer(n.FRAMEBUFFER,null),n.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),n.bindFramebuffer(n.READ_FRAMEBUFFER,null),n.useProgram(null),n.lineWidth(1),n.scissor(0,0,n.canvas.width,n.canvas.height),n.viewport(0,0,n.canvas.width,n.canvas.height),n.pixelStorei(n.PACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,!1),n.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,!1),n.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,n.BROWSER_DEFAULT_WEBGL),n.pixelStorei(n.PACK_ROW_LENGTH,0),n.pixelStorei(n.PACK_SKIP_PIXELS,0),n.pixelStorei(n.PACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_ROW_LENGTH,0),n.pixelStorei(n.UNPACK_IMAGE_HEIGHT,0),n.pixelStorei(n.UNPACK_SKIP_PIXELS,0),n.pixelStorei(n.UNPACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_SKIP_IMAGES,0),h={},d={},tt=null,rt={},u={},f=new WeakMap,g=[],_=null,m=!1,p=null,M=null,R=null,y=null,w=null,S=null,I=null,v=new Ut(0,0,0),A=0,P=!1,O=null,L=null,z=null,D=null,k=null,ee.set(0,0,n.canvas.width,n.canvas.height),Ct.set(0,0,n.canvas.width,n.canvas.height),r.reset(),a.reset(),o.reset()}return{buffers:{color:r,depth:a,stencil:o},enable:it,disable:Mt,bindFramebuffer:Ot,drawBuffers:yt,useProgram:qt,setBlending:Kt,setMaterial:se,setFlipSided:Wt,setCullFace:ie,setLineWidth:ne,setPolygonOffset:T,setScissorTest:G,activeTexture:J,bindTexture:C,unbindTexture:nt,compressedTexImage2D:dt,compressedTexImage3D:E,texImage2D:j,texImage3D:et,pixelStorei:Dt,getParameter:lt,updateUBOMapping:Rt,uniformBlockBinding:Ft,texStorage2D:ot,texStorage3D:ut,texSubImage2D:x,texSubImage3D:F,compressedTexSubImage2D:H,compressedTexSubImage3D:K,scissor:ft,viewport:ct,reset:Vt}}function W_(n,t,e,i,s,r,a){let o=t.has("WEBGL_multisampled_render_to_texture")?t.get("WEBGL_multisampled_render_to_texture"):null,l=typeof navigator>"u"?!1:/OculusBrowser/g.test(navigator.userAgent),c=new xt,h=new WeakMap,d=new Set,u,f=new WeakMap,g=!1;try{g=typeof OffscreenCanvas<"u"&&new OffscreenCanvas(1,1).getContext("2d")!==null}catch{}function _(E,x){return g?new OffscreenCanvas(E,x):Er("canvas")}function m(E,x,F){let H=1,K=dt(E);if((K.width>F||K.height>F)&&(H=F/Math.max(K.width,K.height)),H<1)if(typeof HTMLImageElement<"u"&&E instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&E instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&E instanceof ImageBitmap||typeof VideoFrame<"u"&&E instanceof VideoFrame){let ot=Math.floor(H*K.width),ut=Math.floor(H*K.height);u===void 0&&(u=_(ot,ut));let j=x?_(ot,ut):u;return j.width=ot,j.height=ut,j.getContext("2d").drawImage(E,0,0,ot,ut),kt("WebGLRenderer: Texture has been resized from ("+K.width+"x"+K.height+") to ("+ot+"x"+ut+")."),j}else return"data"in E&&kt("WebGLRenderer: Image in DataTexture is too big ("+K.width+"x"+K.height+")."),E;return E}function p(E){return E.generateMipmaps}function M(E){n.generateMipmap(E)}function R(E){return E.isWebGLCubeRenderTarget?n.TEXTURE_CUBE_MAP:E.isWebGL3DRenderTarget?n.TEXTURE_3D:E.isWebGLArrayRenderTarget||E.isCompressedArrayTexture?n.TEXTURE_2D_ARRAY:n.TEXTURE_2D}function y(E,x,F,H,K,ot=!1){if(E!==null){if(n[E]!==void 0)return n[E];kt("WebGLRenderer: Attempt to use non-existing WebGL internal format '"+E+"'")}let ut;H&&(ut=t.get("EXT_texture_norm16"),ut||kt("WebGLRenderer: Unable to use normalized textures without EXT_texture_norm16 extension"));let j=x;if(x===n.RED&&(F===n.FLOAT&&(j=n.R32F),F===n.HALF_FLOAT&&(j=n.R16F),F===n.UNSIGNED_BYTE&&(j=n.R8),F===n.UNSIGNED_SHORT&&ut&&(j=ut.R16_EXT),F===n.SHORT&&ut&&(j=ut.R16_SNORM_EXT)),x===n.RED_INTEGER&&(F===n.UNSIGNED_BYTE&&(j=n.R8UI),F===n.UNSIGNED_SHORT&&(j=n.R16UI),F===n.UNSIGNED_INT&&(j=n.R32UI),F===n.BYTE&&(j=n.R8I),F===n.SHORT&&(j=n.R16I),F===n.INT&&(j=n.R32I)),x===n.RG&&(F===n.FLOAT&&(j=n.RG32F),F===n.HALF_FLOAT&&(j=n.RG16F),F===n.UNSIGNED_BYTE&&(j=n.RG8),F===n.UNSIGNED_SHORT&&ut&&(j=ut.RG16_EXT),F===n.SHORT&&ut&&(j=ut.RG16_SNORM_EXT)),x===n.RG_INTEGER&&(F===n.UNSIGNED_BYTE&&(j=n.RG8UI),F===n.UNSIGNED_SHORT&&(j=n.RG16UI),F===n.UNSIGNED_INT&&(j=n.RG32UI),F===n.BYTE&&(j=n.RG8I),F===n.SHORT&&(j=n.RG16I),F===n.INT&&(j=n.RG32I)),x===n.RGB_INTEGER&&(F===n.UNSIGNED_BYTE&&(j=n.RGB8UI),F===n.UNSIGNED_SHORT&&(j=n.RGB16UI),F===n.UNSIGNED_INT&&(j=n.RGB32UI),F===n.BYTE&&(j=n.RGB8I),F===n.SHORT&&(j=n.RGB16I),F===n.INT&&(j=n.RGB32I)),x===n.RGBA_INTEGER&&(F===n.UNSIGNED_BYTE&&(j=n.RGBA8UI),F===n.UNSIGNED_SHORT&&(j=n.RGBA16UI),F===n.UNSIGNED_INT&&(j=n.RGBA32UI),F===n.BYTE&&(j=n.RGBA8I),F===n.SHORT&&(j=n.RGBA16I),F===n.INT&&(j=n.RGBA32I)),x===n.RGB&&(F===n.UNSIGNED_SHORT&&ut&&(j=ut.RGB16_EXT),F===n.SHORT&&ut&&(j=ut.RGB16_SNORM_EXT),F===n.UNSIGNED_INT_5_9_9_9_REV&&(j=n.RGB9_E5),F===n.UNSIGNED_INT_10F_11F_11F_REV&&(j=n.R11F_G11F_B10F)),x===n.RGBA){let et=ot?Tr:Qt.getTransfer(K);F===n.FLOAT&&(j=n.RGBA32F),F===n.HALF_FLOAT&&(j=n.RGBA16F),F===n.UNSIGNED_BYTE&&(j=et===ae?n.SRGB8_ALPHA8:n.RGBA8),F===n.UNSIGNED_SHORT&&ut&&(j=ut.RGBA16_EXT),F===n.SHORT&&ut&&(j=ut.RGBA16_SNORM_EXT),F===n.UNSIGNED_SHORT_4_4_4_4&&(j=n.RGBA4),F===n.UNSIGNED_SHORT_5_5_5_1&&(j=n.RGB5_A1)}return(j===n.R16F||j===n.R32F||j===n.RG16F||j===n.RG32F||j===n.RGBA16F||j===n.RGBA32F)&&t.get("EXT_color_buffer_float"),j}function w(E,x){let F;return E?x===null||x===Fi||x===qs?F=n.DEPTH24_STENCIL8:x===bi?F=n.DEPTH32F_STENCIL8:x===Xs&&(F=n.DEPTH24_STENCIL8,kt("DepthTexture: 16 bit depth attachment is not supported with stencil. Using 24-bit attachment.")):x===null||x===Fi||x===qs?F=n.DEPTH_COMPONENT24:x===bi?F=n.DEPTH_COMPONENT32F:x===Xs&&(F=n.DEPTH_COMPONENT16),F}function S(E,x){return p(E)===!0||E.isFramebufferTexture&&E.minFilter!==qe&&E.minFilter!==Oe?Math.log2(Math.max(x.width,x.height))+1:E.mipmaps!==void 0&&E.mipmaps.length>0?E.mipmaps.length:E.isCompressedTexture&&Array.isArray(E.image)?x.mipmaps.length:1}function I(E){let x=E.target;x.removeEventListener("dispose",I),A(x),x.isVideoTexture&&h.delete(x),x.isHTMLTexture&&d.delete(x)}function v(E){let x=E.target;x.removeEventListener("dispose",v),O(x)}function A(E){let x=i.get(E);if(x.__webglInit===void 0)return;let F=E.source,H=f.get(F);if(H){let K=H[x.__cacheKey];K.usedTimes--,K.usedTimes===0&&P(E),Object.keys(H).length===0&&f.delete(F)}i.remove(E)}function P(E){let x=i.get(E);n.deleteTexture(x.__webglTexture);let F=E.source,H=f.get(F);delete H[x.__cacheKey],a.memory.textures--}function O(E){let x=i.get(E);if(E.depthTexture&&(E.depthTexture.dispose(),i.remove(E.depthTexture)),E.isWebGLCubeRenderTarget)for(let H=0;H<6;H++){if(Array.isArray(x.__webglFramebuffer[H]))for(let K=0;K<x.__webglFramebuffer[H].length;K++)n.deleteFramebuffer(x.__webglFramebuffer[H][K]);else n.deleteFramebuffer(x.__webglFramebuffer[H]);x.__webglDepthbuffer&&n.deleteRenderbuffer(x.__webglDepthbuffer[H])}else{if(Array.isArray(x.__webglFramebuffer))for(let H=0;H<x.__webglFramebuffer.length;H++)n.deleteFramebuffer(x.__webglFramebuffer[H]);else n.deleteFramebuffer(x.__webglFramebuffer);if(x.__webglDepthbuffer&&n.deleteRenderbuffer(x.__webglDepthbuffer),x.__webglMultisampledFramebuffer&&n.deleteFramebuffer(x.__webglMultisampledFramebuffer),x.__webglColorRenderbuffer)for(let H=0;H<x.__webglColorRenderbuffer.length;H++)x.__webglColorRenderbuffer[H]&&n.deleteRenderbuffer(x.__webglColorRenderbuffer[H]);x.__webglDepthRenderbuffer&&n.deleteRenderbuffer(x.__webglDepthRenderbuffer)}let F=E.textures;for(let H=0,K=F.length;H<K;H++){let ot=i.get(F[H]);ot.__webglTexture&&(n.deleteTexture(ot.__webglTexture),a.memory.textures--),i.remove(F[H])}i.remove(E)}let L=0;function z(){L=0}function D(){return L}function k(E){L=E}function Y(){let E=L;return E>=s.maxTextures&&kt("WebGLTextures: Trying to use "+(E+1)+" texture units while this GPU supports only "+s.maxTextures),L+=1,E}function q(E){let x=[];return x.push(E.wrapS),x.push(E.wrapT),x.push(E.wrapR||0),x.push(E.magFilter),x.push(E.minFilter),x.push(E.anisotropy),x.push(E.internalFormat),x.push(E.format),x.push(E.type),x.push(E.generateMipmaps),x.push(E.premultiplyAlpha),x.push(E.flipY),x.push(E.unpackAlignment),x.push(E.colorSpace),x.join()}function Z(E,x){let F=i.get(E);if(E.isVideoTexture&&C(E),E.isRenderTargetTexture===!1&&E.isExternalTexture!==!0&&E.version>0&&F.__version!==E.version){let H=E.image;if(H===null)kt("WebGLRenderer: Texture marked for update but no image data found.");else if(H.complete===!1)kt("WebGLRenderer: Texture marked for update but image is incomplete");else{Mt(F,E,x);return}}else E.isExternalTexture&&(F.__webglTexture=E.sourceTexture?E.sourceTexture:null);e.bindTexture(n.TEXTURE_2D,F.__webglTexture,n.TEXTURE0+x)}function V(E,x){let F=i.get(E);if(E.isRenderTargetTexture===!1&&E.version>0&&F.__version!==E.version){Mt(F,E,x);return}else E.isExternalTexture&&(F.__webglTexture=E.sourceTexture?E.sourceTexture:null);e.bindTexture(n.TEXTURE_2D_ARRAY,F.__webglTexture,n.TEXTURE0+x)}function tt(E,x){let F=i.get(E);if(E.isRenderTargetTexture===!1&&E.version>0&&F.__version!==E.version){Mt(F,E,x);return}e.bindTexture(n.TEXTURE_3D,F.__webglTexture,n.TEXTURE0+x)}function rt(E,x){let F=i.get(E);if(E.isCubeDepthTexture!==!0&&E.version>0&&F.__version!==E.version){Ot(F,E,x);return}e.bindTexture(n.TEXTURE_CUBE_MAP,F.__webglTexture,n.TEXTURE0+x)}let St={[Tn]:n.REPEAT,[Vi]:n.CLAMP_TO_EDGE,[ho]:n.MIRRORED_REPEAT},_t={[qe]:n.NEAREST,[xd]:n.NEAREST_MIPMAP_NEAREST,[na]:n.NEAREST_MIPMAP_LINEAR,[Oe]:n.LINEAR,[ko]:n.LINEAR_MIPMAP_NEAREST,[Yi]:n.LINEAR_MIPMAP_LINEAR},ee={[Md]:n.NEVER,[Ed]:n.ALWAYS,[bd]:n.LESS,[wl]:n.LEQUAL,[Sd]:n.EQUAL,[Tl]:n.GEQUAL,[wd]:n.GREATER,[Td]:n.NOTEQUAL};function Ct(E,x){if(x.type===bi&&t.has("OES_texture_float_linear")===!1&&(x.magFilter===Oe||x.magFilter===ko||x.magFilter===na||x.magFilter===Yi||x.minFilter===Oe||x.minFilter===ko||x.minFilter===na||x.minFilter===Yi)&&kt("WebGLRenderer: Unable to use linear filtering with floating point textures. OES_texture_float_linear not supported on this device."),n.texParameteri(E,n.TEXTURE_WRAP_S,St[x.wrapS]),n.texParameteri(E,n.TEXTURE_WRAP_T,St[x.wrapT]),(E===n.TEXTURE_3D||E===n.TEXTURE_2D_ARRAY)&&n.texParameteri(E,n.TEXTURE_WRAP_R,St[x.wrapR]),n.texParameteri(E,n.TEXTURE_MAG_FILTER,_t[x.magFilter]),n.texParameteri(E,n.TEXTURE_MIN_FILTER,_t[x.minFilter]),x.compareFunction&&(n.texParameteri(E,n.TEXTURE_COMPARE_MODE,n.COMPARE_REF_TO_TEXTURE),n.texParameteri(E,n.TEXTURE_COMPARE_FUNC,ee[x.compareFunction])),t.has("EXT_texture_filter_anisotropic")===!0){if(x.magFilter===qe||x.minFilter!==na&&x.minFilter!==Yi||x.type===bi&&t.has("OES_texture_float_linear")===!1)return;if(x.anisotropy>1||i.get(x).__currentAnisotropy){let F=t.get("EXT_texture_filter_anisotropic");n.texParameterf(E,F.TEXTURE_MAX_ANISOTROPY_EXT,Math.min(x.anisotropy,s.getMaxAnisotropy())),i.get(x).__currentAnisotropy=x.anisotropy}}}function $t(E,x){let F=!1;E.__webglInit===void 0&&(E.__webglInit=!0,x.addEventListener("dispose",I));let H=x.source,K=f.get(H);K===void 0&&(K={},f.set(H,K));let ot=q(x);if(ot!==E.__cacheKey){K[ot]===void 0&&(K[ot]={texture:n.createTexture(),usedTimes:0},a.memory.textures++,F=!0),K[ot].usedTimes++;let ut=K[E.__cacheKey];ut!==void 0&&(K[E.__cacheKey].usedTimes--,ut.usedTimes===0&&P(x)),E.__cacheKey=ot,E.__webglTexture=K[ot].texture}return F}function Q(E,x,F){return Math.floor(Math.floor(E/F)/x)}function it(E,x,F,H){let ot=E.updateRanges;if(ot.length===0)e.texSubImage2D(n.TEXTURE_2D,0,0,0,x.width,x.height,F,H,x.data);else{ot.sort((Dt,ft)=>Dt.start-ft.start);let ut=0;for(let Dt=1;Dt<ot.length;Dt++){let ft=ot[ut],ct=ot[Dt],Rt=ft.start+ft.count,Ft=Q(ct.start,x.width,4),Vt=Q(ft.start,x.width,4);ct.start<=Rt+1&&Ft===Vt&&Q(ct.start+ct.count-1,x.width,4)===Ft?ft.count=Math.max(ft.count,ct.start+ct.count-ft.start):(++ut,ot[ut]=ct)}ot.length=ut+1;let j=e.getParameter(n.UNPACK_ROW_LENGTH),et=e.getParameter(n.UNPACK_SKIP_PIXELS),lt=e.getParameter(n.UNPACK_SKIP_ROWS);e.pixelStorei(n.UNPACK_ROW_LENGTH,x.width);for(let Dt=0,ft=ot.length;Dt<ft;Dt++){let ct=ot[Dt],Rt=Math.floor(ct.start/4),Ft=Math.ceil(ct.count/4),Vt=Rt%x.width,B=Math.floor(Rt/x.width),ht=Ft,st=1;e.pixelStorei(n.UNPACK_SKIP_PIXELS,Vt),e.pixelStorei(n.UNPACK_SKIP_ROWS,B),e.texSubImage2D(n.TEXTURE_2D,0,Vt,B,ht,st,F,H,x.data)}E.clearUpdateRanges(),e.pixelStorei(n.UNPACK_ROW_LENGTH,j),e.pixelStorei(n.UNPACK_SKIP_PIXELS,et),e.pixelStorei(n.UNPACK_SKIP_ROWS,lt)}}function Mt(E,x,F){let H=n.TEXTURE_2D;(x.isDataArrayTexture||x.isCompressedArrayTexture)&&(H=n.TEXTURE_2D_ARRAY),x.isData3DTexture&&(H=n.TEXTURE_3D);let K=$t(E,x),ot=x.source;e.bindTexture(H,E.__webglTexture,n.TEXTURE0+F);let ut=i.get(ot);if(ot.version!==ut.__version||K===!0){if(e.activeTexture(n.TEXTURE0+F),(typeof ImageBitmap<"u"&&x.image instanceof ImageBitmap)===!1){let st=Qt.getPrimaries(Qt.workingColorSpace),pt=x.colorSpace===wi?null:Qt.getPrimaries(x.colorSpace),bt=x.colorSpace===wi||st===pt?n.NONE:n.BROWSER_DEFAULT_WEBGL;e.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,x.flipY),e.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,x.premultiplyAlpha),e.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,bt)}e.pixelStorei(n.UNPACK_ALIGNMENT,x.unpackAlignment);let et=m(x.image,!1,s.maxTextureSize);et=nt(x,et);let lt=r.convert(x.format,x.colorSpace),Dt=r.convert(x.type),ft=y(x.internalFormat,lt,Dt,x.normalized,x.colorSpace,x.isVideoTexture);Ct(H,x);let ct,Rt=x.mipmaps,Ft=x.isVideoTexture!==!0,Vt=ut.__version===void 0||K===!0,B=ot.dataReady,ht=S(x,et);if(x.isDepthTexture)ft=w(x.format===Fn,x.type),Vt&&(Ft?e.texStorage2D(n.TEXTURE_2D,1,ft,et.width,et.height):e.texImage2D(n.TEXTURE_2D,0,ft,et.width,et.height,0,lt,Dt,null));else if(x.isDataTexture)if(Rt.length>0){Ft&&Vt&&e.texStorage2D(n.TEXTURE_2D,ht,ft,Rt[0].width,Rt[0].height);for(let st=0,pt=Rt.length;st<pt;st++)ct=Rt[st],Ft?B&&e.texSubImage2D(n.TEXTURE_2D,st,0,0,ct.width,ct.height,lt,Dt,ct.data):e.texImage2D(n.TEXTURE_2D,st,ft,ct.width,ct.height,0,lt,Dt,ct.data);x.generateMipmaps=!1}else Ft?(Vt&&e.texStorage2D(n.TEXTURE_2D,ht,ft,et.width,et.height),B&&it(x,et,lt,Dt)):e.texImage2D(n.TEXTURE_2D,0,ft,et.width,et.height,0,lt,Dt,et.data);else if(x.isCompressedTexture)if(x.isCompressedArrayTexture){Ft&&Vt&&e.texStorage3D(n.TEXTURE_2D_ARRAY,ht,ft,Rt[0].width,Rt[0].height,et.depth);for(let st=0,pt=Rt.length;st<pt;st++)if(ct=Rt[st],x.format!==Si)if(lt!==null)if(Ft){if(B)if(x.layerUpdates.size>0){let bt=xh(ct.width,ct.height,x.format,x.type);for(let at of x.layerUpdates){let zt=ct.data.subarray(at*bt/ct.data.BYTES_PER_ELEMENT,(at+1)*bt/ct.data.BYTES_PER_ELEMENT);e.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,st,0,0,at,ct.width,ct.height,1,lt,zt)}}else e.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,st,0,0,0,ct.width,ct.height,et.depth,lt,ct.data)}else e.compressedTexImage3D(n.TEXTURE_2D_ARRAY,st,ft,ct.width,ct.height,et.depth,0,ct.data,0,0);else kt("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()");else Ft?B&&e.texSubImage3D(n.TEXTURE_2D_ARRAY,st,0,0,0,ct.width,ct.height,et.depth,lt,Dt,ct.data):e.texImage3D(n.TEXTURE_2D_ARRAY,st,ft,ct.width,ct.height,et.depth,0,lt,Dt,ct.data);x.layerUpdates.size>0&&x.clearLayerUpdates()}else{Ft&&Vt&&e.texStorage2D(n.TEXTURE_2D,ht,ft,Rt[0].width,Rt[0].height);for(let st=0,pt=Rt.length;st<pt;st++)ct=Rt[st],x.format!==Si?lt!==null?Ft?B&&e.compressedTexSubImage2D(n.TEXTURE_2D,st,0,0,ct.width,ct.height,lt,ct.data):e.compressedTexImage2D(n.TEXTURE_2D,st,ft,ct.width,ct.height,0,ct.data):kt("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()"):Ft?B&&e.texSubImage2D(n.TEXTURE_2D,st,0,0,ct.width,ct.height,lt,Dt,ct.data):e.texImage2D(n.TEXTURE_2D,st,ft,ct.width,ct.height,0,lt,Dt,ct.data)}else if(x.isDataArrayTexture)if(Ft){if(Vt&&e.texStorage3D(n.TEXTURE_2D_ARRAY,ht,ft,et.width,et.height,et.depth),B)if(x.layerUpdates.size>0){let st=xh(et.width,et.height,x.format,x.type);for(let pt of x.layerUpdates){let bt=et.data.subarray(pt*st/et.data.BYTES_PER_ELEMENT,(pt+1)*st/et.data.BYTES_PER_ELEMENT);e.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,pt,et.width,et.height,1,lt,Dt,bt)}x.clearLayerUpdates()}else e.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,0,et.width,et.height,et.depth,lt,Dt,et.data)}else e.texImage3D(n.TEXTURE_2D_ARRAY,0,ft,et.width,et.height,et.depth,0,lt,Dt,et.data);else if(x.isData3DTexture)Ft?(Vt&&e.texStorage3D(n.TEXTURE_3D,ht,ft,et.width,et.height,et.depth),B&&e.texSubImage3D(n.TEXTURE_3D,0,0,0,0,et.width,et.height,et.depth,lt,Dt,et.data)):e.texImage3D(n.TEXTURE_3D,0,ft,et.width,et.height,et.depth,0,lt,Dt,et.data);else if(x.isFramebufferTexture){if(Vt)if(Ft)e.texStorage2D(n.TEXTURE_2D,ht,ft,et.width,et.height);else{let st=et.width,pt=et.height;for(let bt=0;bt<ht;bt++)e.texImage2D(n.TEXTURE_2D,bt,ft,st,pt,0,lt,Dt,null),st>>=1,pt>>=1}}else if(x.isHTMLTexture){if("texElementImage2D"in n){let st=n.canvas;if(st.hasAttribute("layoutsubtree")||st.setAttribute("layoutsubtree","true"),et.parentNode!==st){st.appendChild(et),d.add(x),st.onpaint=pt=>{let bt=pt.changedElements;for(let at of d)bt.includes(at.image)&&(at.needsUpdate=!0)},st.requestPaint();return}if(n.texElementImage2D.length===3)n.texElementImage2D(n.TEXTURE_2D,n.RGBA8,et);else{let bt=n.RGBA,at=n.RGBA,zt=n.UNSIGNED_BYTE;n.texElementImage2D(n.TEXTURE_2D,0,bt,at,zt,et)}n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MIN_FILTER,n.LINEAR),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_S,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_T,n.CLAMP_TO_EDGE)}}else if(Rt.length>0){if(Ft&&Vt){let st=dt(Rt[0]);e.texStorage2D(n.TEXTURE_2D,ht,ft,st.width,st.height)}for(let st=0,pt=Rt.length;st<pt;st++)ct=Rt[st],Ft?B&&e.texSubImage2D(n.TEXTURE_2D,st,0,0,lt,Dt,ct):e.texImage2D(n.TEXTURE_2D,st,ft,lt,Dt,ct);x.generateMipmaps=!1}else if(Ft){if(Vt){let st=dt(et);e.texStorage2D(n.TEXTURE_2D,ht,ft,st.width,st.height)}B&&e.texSubImage2D(n.TEXTURE_2D,0,0,0,lt,Dt,et)}else e.texImage2D(n.TEXTURE_2D,0,ft,lt,Dt,et);p(x)&&M(H),ut.__version=ot.version,x.onUpdate&&x.onUpdate(x)}E.__version=x.version}function Ot(E,x,F){if(x.image.length!==6)return;let H=$t(E,x),K=x.source;e.bindTexture(n.TEXTURE_CUBE_MAP,E.__webglTexture,n.TEXTURE0+F);let ot=i.get(K);if(K.version!==ot.__version||H===!0){e.activeTexture(n.TEXTURE0+F);let ut=Qt.getPrimaries(Qt.workingColorSpace),j=x.colorSpace===wi?null:Qt.getPrimaries(x.colorSpace),et=x.colorSpace===wi||ut===j?n.NONE:n.BROWSER_DEFAULT_WEBGL;e.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,x.flipY),e.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,x.premultiplyAlpha),e.pixelStorei(n.UNPACK_ALIGNMENT,x.unpackAlignment),e.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,et);let lt=x.isCompressedTexture||x.image[0].isCompressedTexture,Dt=x.image[0]&&x.image[0].isDataTexture,ft=[];for(let at=0;at<6;at++)!lt&&!Dt?ft[at]=m(x.image[at],!0,s.maxCubemapSize):ft[at]=Dt?x.image[at].image:x.image[at],ft[at]=nt(x,ft[at]);let ct=ft[0],Rt=r.convert(x.format,x.colorSpace),Ft=r.convert(x.type),Vt=y(x.internalFormat,Rt,Ft,x.normalized,x.colorSpace),B=x.isVideoTexture!==!0,ht=ot.__version===void 0||H===!0,st=K.dataReady,pt=S(x,ct);Ct(n.TEXTURE_CUBE_MAP,x);let bt;if(lt){B&&ht&&e.texStorage2D(n.TEXTURE_CUBE_MAP,pt,Vt,ct.width,ct.height);for(let at=0;at<6;at++){bt=ft[at].mipmaps;for(let zt=0;zt<bt.length;zt++){let Lt=bt[zt];x.format!==Si?Rt!==null?B?st&&e.compressedTexSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt,0,0,Lt.width,Lt.height,Rt,Lt.data):e.compressedTexImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt,Vt,Lt.width,Lt.height,0,Lt.data):kt("WebGLRenderer: Attempt to load unsupported compressed texture format in .setTextureCube()"):B?st&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt,0,0,Lt.width,Lt.height,Rt,Ft,Lt.data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt,Vt,Lt.width,Lt.height,0,Rt,Ft,Lt.data)}}}else{if(bt=x.mipmaps,B&&ht){bt.length>0&&pt++;let at=dt(ft[0]);e.texStorage2D(n.TEXTURE_CUBE_MAP,pt,Vt,at.width,at.height)}for(let at=0;at<6;at++)if(Dt){B?st&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,0,0,0,ft[at].width,ft[at].height,Rt,Ft,ft[at].data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,0,Vt,ft[at].width,ft[at].height,0,Rt,Ft,ft[at].data);for(let zt=0;zt<bt.length;zt++){let ve=bt[zt].image[at].image;B?st&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt+1,0,0,ve.width,ve.height,Rt,Ft,ve.data):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt+1,Vt,ve.width,ve.height,0,Rt,Ft,ve.data)}}else{B?st&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,0,0,0,Rt,Ft,ft[at]):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,0,Vt,Rt,Ft,ft[at]);for(let zt=0;zt<bt.length;zt++){let Lt=bt[zt];B?st&&e.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt+1,0,0,Rt,Ft,Lt.image[at]):e.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+at,zt+1,Vt,Rt,Ft,Lt.image[at])}}}p(x)&&M(n.TEXTURE_CUBE_MAP),ot.__version=K.version,x.onUpdate&&x.onUpdate(x)}E.__version=x.version}function yt(E,x,F,H,K,ot){let ut=r.convert(F.format,F.colorSpace),j=r.convert(F.type),et=y(F.internalFormat,ut,j,F.normalized,F.colorSpace),lt=i.get(x),Dt=i.get(F);if(Dt.__renderTarget=x,!lt.__hasExternalTextures){let ft=Math.max(1,x.width>>ot),ct=Math.max(1,x.height>>ot);K===n.TEXTURE_3D||K===n.TEXTURE_2D_ARRAY?e.texImage3D(K,ot,et,ft,ct,x.depth,0,ut,j,null):e.texImage2D(K,ot,et,ft,ct,0,ut,j,null)}e.bindFramebuffer(n.FRAMEBUFFER,E),J(x)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,H,K,Dt.__webglTexture,0,G(x)):(K===n.TEXTURE_2D||K>=n.TEXTURE_CUBE_MAP_POSITIVE_X&&K<=n.TEXTURE_CUBE_MAP_NEGATIVE_Z)&&n.framebufferTexture2D(n.FRAMEBUFFER,H,K,Dt.__webglTexture,ot),e.bindFramebuffer(n.FRAMEBUFFER,null)}function qt(E,x,F){if(n.bindRenderbuffer(n.RENDERBUFFER,E),x.depthBuffer){let H=x.depthTexture,K=H&&H.isDepthTexture?H.type:null,ot=w(x.stencilBuffer,K),ut=x.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;J(x)?o.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,G(x),ot,x.width,x.height):F?n.renderbufferStorageMultisample(n.RENDERBUFFER,G(x),ot,x.width,x.height):n.renderbufferStorage(n.RENDERBUFFER,ot,x.width,x.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,ut,n.RENDERBUFFER,E)}else{let H=x.textures;for(let K=0;K<H.length;K++){let ot=H[K],ut=r.convert(ot.format,ot.colorSpace),j=r.convert(ot.type),et=y(ot.internalFormat,ut,j,ot.normalized,ot.colorSpace);J(x)?o.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,G(x),et,x.width,x.height):F?n.renderbufferStorageMultisample(n.RENDERBUFFER,G(x),et,x.width,x.height):n.renderbufferStorage(n.RENDERBUFFER,et,x.width,x.height)}}n.bindRenderbuffer(n.RENDERBUFFER,null)}function be(E,x,F){let H=x.isWebGLCubeRenderTarget===!0;if(e.bindFramebuffer(n.FRAMEBUFFER,E),!(x.depthTexture&&x.depthTexture.isDepthTexture))throw new Error("THREE.WebGLTextures: renderTarget.depthTexture must be an instance of THREE.DepthTexture.");let K=i.get(x.depthTexture);if(K.__renderTarget=x,(!K.__webglTexture||x.depthTexture.image.width!==x.width||x.depthTexture.image.height!==x.height)&&(x.depthTexture.image.width=x.width,x.depthTexture.image.height=x.height,x.depthTexture.needsUpdate=!0),H){if(K.__webglInit===void 0&&(K.__webglInit=!0,x.depthTexture.addEventListener("dispose",I)),K.__webglTexture===void 0){K.__webglTexture=n.createTexture(),e.bindTexture(n.TEXTURE_CUBE_MAP,K.__webglTexture),Ct(n.TEXTURE_CUBE_MAP,x.depthTexture);let lt=r.convert(x.depthTexture.format),Dt=r.convert(x.depthTexture.type),ft;x.depthTexture.format===Gi?ft=n.DEPTH_COMPONENT24:x.depthTexture.format===Fn&&(ft=n.DEPTH24_STENCIL8);for(let ct=0;ct<6;ct++)n.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ct,0,ft,x.width,x.height,0,lt,Dt,null)}}else Z(x.depthTexture,0);let ot=K.__webglTexture,ut=G(x),j=H?n.TEXTURE_CUBE_MAP_POSITIVE_X+F:n.TEXTURE_2D,et=x.depthTexture.format===Fn?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;if(x.depthTexture.format===Gi)J(x)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,et,j,ot,0,ut):n.framebufferTexture2D(n.FRAMEBUFFER,et,j,ot,0);else if(x.depthTexture.format===Fn)J(x)?o.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,et,j,ot,0,ut):n.framebufferTexture2D(n.FRAMEBUFFER,et,j,ot,0);else throw new Error("THREE.WebGLTextures: Unknown depthTexture format.")}function Yt(E){let x=i.get(E),F=E.isWebGLCubeRenderTarget===!0;if(x.__boundDepthTexture!==E.depthTexture){let H=E.depthTexture;if(x.__depthDisposeCallback&&x.__depthDisposeCallback(),H){let K=()=>{delete x.__boundDepthTexture,delete x.__depthDisposeCallback,H.removeEventListener("dispose",K)};H.addEventListener("dispose",K),x.__depthDisposeCallback=K}x.__boundDepthTexture=H}if(E.depthTexture&&!x.__autoAllocateDepthBuffer)if(F)for(let H=0;H<6;H++)be(x.__webglFramebuffer[H],E,H);else{let H=E.texture.mipmaps;H&&H.length>0?be(x.__webglFramebuffer[0],E,0):be(x.__webglFramebuffer,E,0)}else if(F){x.__webglDepthbuffer=[];for(let H=0;H<6;H++)if(e.bindFramebuffer(n.FRAMEBUFFER,x.__webglFramebuffer[H]),x.__webglDepthbuffer[H]===void 0)x.__webglDepthbuffer[H]=n.createRenderbuffer(),qt(x.__webglDepthbuffer[H],E,!1);else{let K=E.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,ot=x.__webglDepthbuffer[H];n.bindRenderbuffer(n.RENDERBUFFER,ot),n.framebufferRenderbuffer(n.FRAMEBUFFER,K,n.RENDERBUFFER,ot)}}else{let H=E.texture.mipmaps;if(H&&H.length>0?e.bindFramebuffer(n.FRAMEBUFFER,x.__webglFramebuffer[0]):e.bindFramebuffer(n.FRAMEBUFFER,x.__webglFramebuffer),x.__webglDepthbuffer===void 0)x.__webglDepthbuffer=n.createRenderbuffer(),qt(x.__webglDepthbuffer,E,!1);else{let K=E.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,ot=x.__webglDepthbuffer;n.bindRenderbuffer(n.RENDERBUFFER,ot),n.framebufferRenderbuffer(n.FRAMEBUFFER,K,n.RENDERBUFFER,ot)}}e.bindFramebuffer(n.FRAMEBUFFER,null)}function Kt(E,x,F){let H=i.get(E);x!==void 0&&yt(H.__webglFramebuffer,E,E.texture,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,0),F!==void 0&&Yt(E)}function se(E){let x=E.texture,F=i.get(E),H=i.get(x);E.addEventListener("dispose",v);let K=E.textures,ot=E.isWebGLCubeRenderTarget===!0,ut=K.length>1;if(ut||(H.__webglTexture===void 0&&(H.__webglTexture=n.createTexture()),H.__version=x.version,a.memory.textures++),ot){F.__webglFramebuffer=[];for(let j=0;j<6;j++)if(x.mipmaps&&x.mipmaps.length>0){F.__webglFramebuffer[j]=[];for(let et=0;et<x.mipmaps.length;et++)F.__webglFramebuffer[j][et]=n.createFramebuffer()}else F.__webglFramebuffer[j]=n.createFramebuffer()}else{if(x.mipmaps&&x.mipmaps.length>0){F.__webglFramebuffer=[];for(let j=0;j<x.mipmaps.length;j++)F.__webglFramebuffer[j]=n.createFramebuffer()}else F.__webglFramebuffer=n.createFramebuffer();if(ut)for(let j=0,et=K.length;j<et;j++){let lt=i.get(K[j]);lt.__webglTexture===void 0&&(lt.__webglTexture=n.createTexture(),a.memory.textures++)}if(E.samples>0&&J(E)===!1){F.__webglMultisampledFramebuffer=n.createFramebuffer(),F.__webglColorRenderbuffer=[],e.bindFramebuffer(n.FRAMEBUFFER,F.__webglMultisampledFramebuffer);for(let j=0;j<K.length;j++){let et=K[j];F.__webglColorRenderbuffer[j]=n.createRenderbuffer(),n.bindRenderbuffer(n.RENDERBUFFER,F.__webglColorRenderbuffer[j]);let lt=r.convert(et.format,et.colorSpace),Dt=r.convert(et.type),ft=y(et.internalFormat,lt,Dt,et.normalized,et.colorSpace,E.isXRRenderTarget===!0),ct=G(E);n.renderbufferStorageMultisample(n.RENDERBUFFER,ct,ft,E.width,E.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+j,n.RENDERBUFFER,F.__webglColorRenderbuffer[j])}n.bindRenderbuffer(n.RENDERBUFFER,null),E.depthBuffer&&(F.__webglDepthRenderbuffer=n.createRenderbuffer(),qt(F.__webglDepthRenderbuffer,E,!0)),e.bindFramebuffer(n.FRAMEBUFFER,null)}}if(ot){e.bindTexture(n.TEXTURE_CUBE_MAP,H.__webglTexture),Ct(n.TEXTURE_CUBE_MAP,x);for(let j=0;j<6;j++)if(x.mipmaps&&x.mipmaps.length>0)for(let et=0;et<x.mipmaps.length;et++)yt(F.__webglFramebuffer[j][et],E,x,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+j,et);else yt(F.__webglFramebuffer[j],E,x,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+j,0);p(x)&&M(n.TEXTURE_CUBE_MAP),e.unbindTexture()}else if(ut){for(let j=0,et=K.length;j<et;j++){let lt=K[j],Dt=i.get(lt),ft=n.TEXTURE_2D;(E.isWebGL3DRenderTarget||E.isWebGLArrayRenderTarget)&&(ft=E.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),e.bindTexture(ft,Dt.__webglTexture),Ct(ft,lt),yt(F.__webglFramebuffer,E,lt,n.COLOR_ATTACHMENT0+j,ft,0),p(lt)&&M(ft)}e.unbindTexture()}else{let j=n.TEXTURE_2D;if((E.isWebGL3DRenderTarget||E.isWebGLArrayRenderTarget)&&(j=E.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),e.bindTexture(j,H.__webglTexture),Ct(j,x),x.mipmaps&&x.mipmaps.length>0)for(let et=0;et<x.mipmaps.length;et++)yt(F.__webglFramebuffer[et],E,x,n.COLOR_ATTACHMENT0,j,et);else yt(F.__webglFramebuffer,E,x,n.COLOR_ATTACHMENT0,j,0);p(x)&&M(j),e.unbindTexture()}E.depthBuffer&&Yt(E)}function Wt(E){let x=E.textures;for(let F=0,H=x.length;F<H;F++){let K=x[F];if(p(K)){let ot=R(E),ut=i.get(K).__webglTexture;e.bindTexture(ot,ut),M(ot),e.unbindTexture()}}}let ie=[],ne=[];function T(E){if(E.samples>0){if(J(E)===!1){let x=E.textures,F=E.width,H=E.height,K=n.COLOR_BUFFER_BIT,ot=E.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,ut=i.get(E),j=x.length>1;if(j)for(let lt=0;lt<x.length;lt++)e.bindFramebuffer(n.FRAMEBUFFER,ut.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+lt,n.RENDERBUFFER,null),e.bindFramebuffer(n.FRAMEBUFFER,ut.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+lt,n.TEXTURE_2D,null,0);e.bindFramebuffer(n.READ_FRAMEBUFFER,ut.__webglMultisampledFramebuffer);let et=E.texture.mipmaps;et&&et.length>0?e.bindFramebuffer(n.DRAW_FRAMEBUFFER,ut.__webglFramebuffer[0]):e.bindFramebuffer(n.DRAW_FRAMEBUFFER,ut.__webglFramebuffer);for(let lt=0;lt<x.length;lt++){if(E.resolveDepthBuffer&&(E.depthBuffer&&(K|=n.DEPTH_BUFFER_BIT),E.stencilBuffer&&E.resolveStencilBuffer&&(K|=n.STENCIL_BUFFER_BIT)),j){n.framebufferRenderbuffer(n.READ_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.RENDERBUFFER,ut.__webglColorRenderbuffer[lt]);let Dt=i.get(x[lt]).__webglTexture;n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,Dt,0)}n.blitFramebuffer(0,0,F,H,0,0,F,H,K,n.NEAREST),l===!0&&(ie.length=0,ne.length=0,ie.push(n.COLOR_ATTACHMENT0+lt),E.depthBuffer&&E.storeMultisampledDepthBuffer===!1&&(ie.push(ot),ne.push(ot),n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,ne)),n.invalidateFramebuffer(n.READ_FRAMEBUFFER,ie))}if(e.bindFramebuffer(n.READ_FRAMEBUFFER,null),e.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),j)for(let lt=0;lt<x.length;lt++){e.bindFramebuffer(n.FRAMEBUFFER,ut.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+lt,n.RENDERBUFFER,ut.__webglColorRenderbuffer[lt]);let Dt=i.get(x[lt]).__webglTexture;e.bindFramebuffer(n.FRAMEBUFFER,ut.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+lt,n.TEXTURE_2D,Dt,0)}e.bindFramebuffer(n.DRAW_FRAMEBUFFER,ut.__webglMultisampledFramebuffer)}else if(E.depthBuffer&&E.storeMultisampledDepthBuffer===!1&&l){let x=E.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,[x])}}}function G(E){return Math.min(s.maxSamples,E.samples)}function J(E){let x=i.get(E);return E.samples>0&&t.has("WEBGL_multisampled_render_to_texture")===!0&&x.__useRenderToTexture!==!1}function C(E){let x=a.render.frame;h.get(E)!==x&&(h.set(E,x),E.update())}function nt(E,x){let F=E.colorSpace,H=E.format,K=E.type;return E.isCompressedTexture===!0||E.isVideoTexture===!0||F!==wr&&F!==wi&&(Qt.getTransfer(F)===ae?(H!==Si||K!==oi)&&kt("WebGLTextures: sRGB encoded textures have to use RGBAFormat and UnsignedByteType."):Ht("WebGLTextures: Unsupported texture color space:",F)),x}function dt(E){return typeof HTMLImageElement<"u"&&E instanceof HTMLImageElement?(c.width=E.naturalWidth||E.width,c.height=E.naturalHeight||E.height):typeof VideoFrame<"u"&&E instanceof VideoFrame?(c.width=E.displayWidth,c.height=E.displayHeight):(c.width=E.width,c.height=E.height),c}this.allocateTextureUnit=Y,this.resetTextureUnits=z,this.getTextureUnits=D,this.setTextureUnits=k,this.setTexture2D=Z,this.setTexture2DArray=V,this.setTexture3D=tt,this.setTextureCube=rt,this.rebindTextures=Kt,this.setupRenderTarget=se,this.updateRenderTargetMipmap=Wt,this.updateMultisampleRenderTarget=T,this.setupDepthRenderbuffer=Yt,this.setupFrameBufferTexture=yt,this.useMultisampledRTT=J,this.isReversedDepthBuffer=function(){return e.buffers.depth.getReversed()}}function X_(n,t){function e(i,s=wi){let r,a=Qt.getTransfer(s);if(i===oi)return n.UNSIGNED_BYTE;if(i===Vo)return n.UNSIGNED_SHORT_4_4_4_4;if(i===Go)return n.UNSIGNED_SHORT_5_5_5_1;if(i===ah)return n.UNSIGNED_INT_5_9_9_9_REV;if(i===oh)return n.UNSIGNED_INT_10F_11F_11F_REV;if(i===sh)return n.BYTE;if(i===rh)return n.SHORT;if(i===Xs)return n.UNSIGNED_SHORT;if(i===Ho)return n.INT;if(i===Fi)return n.UNSIGNED_INT;if(i===bi)return n.FLOAT;if(i===He)return n.HALF_FLOAT;if(i===lh)return n.ALPHA;if(i===ch)return n.RGB;if(i===Si)return n.RGBA;if(i===Gi)return n.DEPTH_COMPONENT;if(i===Fn)return n.DEPTH_STENCIL;if(i===Wo)return n.RED;if(i===Xo)return n.RED_INTEGER;if(i===zn)return n.RG;if(i===qo)return n.RG_INTEGER;if(i===Yo)return n.RGBA_INTEGER;if(i===sa||i===ra||i===aa||i===oa)if(a===ae)if(r=t.get("WEBGL_compressed_texture_s3tc_srgb"),r!==null){if(i===sa)return r.COMPRESSED_SRGB_S3TC_DXT1_EXT;if(i===ra)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT;if(i===aa)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT;if(i===oa)return r.COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT}else return null;else if(r=t.get("WEBGL_compressed_texture_s3tc"),r!==null){if(i===sa)return r.COMPRESSED_RGB_S3TC_DXT1_EXT;if(i===ra)return r.COMPRESSED_RGBA_S3TC_DXT1_EXT;if(i===aa)return r.COMPRESSED_RGBA_S3TC_DXT3_EXT;if(i===oa)return r.COMPRESSED_RGBA_S3TC_DXT5_EXT}else return null;if(i===$o||i===Zo||i===Jo||i===Ko)if(r=t.get("WEBGL_compressed_texture_pvrtc"),r!==null){if(i===$o)return r.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;if(i===Zo)return r.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;if(i===Jo)return r.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;if(i===Ko)return r.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG}else return null;if(i===Qo||i===jo||i===tl||i===el||i===il||i===la||i===nl)if(r=t.get("WEBGL_compressed_texture_etc"),r!==null){if(i===Qo||i===jo)return a===ae?r.COMPRESSED_SRGB8_ETC2:r.COMPRESSED_RGB8_ETC2;if(i===tl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ETC2_EAC:r.COMPRESSED_RGBA8_ETC2_EAC;if(i===el)return r.COMPRESSED_R11_EAC;if(i===il)return r.COMPRESSED_SIGNED_R11_EAC;if(i===la)return r.COMPRESSED_RG11_EAC;if(i===nl)return r.COMPRESSED_SIGNED_RG11_EAC}else return null;if(i===sl||i===rl||i===al||i===ol||i===ll||i===cl||i===hl||i===ul||i===dl||i===fl||i===pl||i===ml||i===gl||i===xl)if(r=t.get("WEBGL_compressed_texture_astc"),r!==null){if(i===sl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR:r.COMPRESSED_RGBA_ASTC_4x4_KHR;if(i===rl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR:r.COMPRESSED_RGBA_ASTC_5x4_KHR;if(i===al)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR:r.COMPRESSED_RGBA_ASTC_5x5_KHR;if(i===ol)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR:r.COMPRESSED_RGBA_ASTC_6x5_KHR;if(i===ll)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR:r.COMPRESSED_RGBA_ASTC_6x6_KHR;if(i===cl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR:r.COMPRESSED_RGBA_ASTC_8x5_KHR;if(i===hl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR:r.COMPRESSED_RGBA_ASTC_8x6_KHR;if(i===ul)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR:r.COMPRESSED_RGBA_ASTC_8x8_KHR;if(i===dl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR:r.COMPRESSED_RGBA_ASTC_10x5_KHR;if(i===fl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR:r.COMPRESSED_RGBA_ASTC_10x6_KHR;if(i===pl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR:r.COMPRESSED_RGBA_ASTC_10x8_KHR;if(i===ml)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR:r.COMPRESSED_RGBA_ASTC_10x10_KHR;if(i===gl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR:r.COMPRESSED_RGBA_ASTC_12x10_KHR;if(i===xl)return a===ae?r.COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR:r.COMPRESSED_RGBA_ASTC_12x12_KHR}else return null;if(i===_l||i===vl||i===yl)if(r=t.get("EXT_texture_compression_bptc"),r!==null){if(i===_l)return a===ae?r.COMPRESSED_SRGB_ALPHA_BPTC_UNORM_EXT:r.COMPRESSED_RGBA_BPTC_UNORM_EXT;if(i===vl)return r.COMPRESSED_RGB_BPTC_SIGNED_FLOAT_EXT;if(i===yl)return r.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_EXT}else return null;if(i===Ml||i===bl||i===ca||i===Sl)if(r=t.get("EXT_texture_compression_rgtc"),r!==null){if(i===Ml)return r.COMPRESSED_RED_RGTC1_EXT;if(i===bl)return r.COMPRESSED_SIGNED_RED_RGTC1_EXT;if(i===ca)return r.COMPRESSED_RED_GREEN_RGTC2_EXT;if(i===Sl)return r.COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT}else return null;return i===qs?n.UNSIGNED_INT_24_8:n[i]!==void 0?n[i]:null}return{convert:e}}var q_=`
void main() {

	gl_Position = vec4( position, 1.0 );

}`,Y_=`
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

}`,Fh=class{constructor(){this.texture=null,this.mesh=null,this.depthNear=0,this.depthFar=0}init(t,e){if(this.texture===null){let i=new Or(t.texture);(t.depthNear!==e.depthNear||t.depthFar!==e.depthFar)&&(this.depthNear=t.depthNear,this.depthFar=t.depthFar),this.texture=i}}getMesh(t){if(this.texture!==null&&this.mesh===null){let e=t.cameras[0].viewport,i=new Te({vertexShader:q_,fragmentShader:Y_,uniforms:{depthColor:{value:this.texture},depthWidth:{value:e.z},depthHeight:{value:e.w}}});this.mesh=new Tt(new qi(20,20),i)}return this.mesh}reset(){this.texture=null,this.mesh=null}getDepthTexture(){return this.texture}},zh=class extends Wi{constructor(t,e){super();let i=this,s=null,r=1,a=null,o="local-floor",l=1,c=null,h=null,d=null,u=null,f=null,g=null,_=typeof XRWebGLBinding<"u",m=new Fh,p={},M=e.getContextAttributes(),R=null,y=null,w=[],S=[],I=new xt,v=null,A=null,P=new Ye;P.viewport=new Ae;let O=new Ye;O.viewport=new Ae;let L=[P,O],z=new Uo,D=null,k=null;this.cameraAutoUpdate=!0,this.enabled=!1,this.isPresenting=!1,this.getController=function(Q){let it=w[Q];return it===void 0&&(it=new Fs,w[Q]=it),it.getTargetRaySpace()},this.getControllerGrip=function(Q){let it=w[Q];return it===void 0&&(it=new Fs,w[Q]=it),it.getGripSpace()},this.getHand=function(Q){let it=w[Q];return it===void 0&&(it=new Fs,w[Q]=it),it.getHandSpace()};function Y(Q){let it=S.indexOf(Q.inputSource);if(it===-1)return;let Mt=w[it];Mt!==void 0&&(Mt.update(Q.inputSource,Q.frame,c||a),Mt.dispatchEvent({type:Q.type,data:Q.inputSource}))}function q(){s.removeEventListener("select",Y),s.removeEventListener("selectstart",Y),s.removeEventListener("selectend",Y),s.removeEventListener("squeeze",Y),s.removeEventListener("squeezestart",Y),s.removeEventListener("squeezeend",Y),s.removeEventListener("end",q),s.removeEventListener("inputsourceschange",Z);for(let Q=0;Q<w.length;Q++){let it=S[Q];it!==null&&(S[Q]=null,w[Q].disconnect(it))}D=null,k=null,m.reset();for(let Q in p)delete p[Q];if(t.setRenderTarget(R),f=null,u=null,d=null,s=null,y=null,$t.stop(),i.isPresenting=!1,t.setPixelRatio(v),t.setSize(I.width,I.height,!1),A!==null){let Q=A.camera;Q.fov=A.fov,Q.zoom=A.zoom,Q.updateProjectionMatrix(),A=null}i.dispatchEvent({type:"sessionend"})}this.setFramebufferScaleFactor=function(Q){r=Q,i.isPresenting===!0&&kt("WebXRManager: Cannot change framebuffer scale while presenting.")},this.setReferenceSpaceType=function(Q){o=Q,i.isPresenting===!0&&kt("WebXRManager: Cannot change reference space type while presenting.")},this.getReferenceSpace=function(){return c||a},this.setReferenceSpace=function(Q){c=Q},this.getBaseLayer=function(){return u!==null?u:f},this.getBinding=function(){return d===null&&_&&(d=new XRWebGLBinding(s,e)),d},this.getFrame=function(){return g},this.getSession=function(){return s},this.setSession=async function(Q){if(s=Q,s!==null){if(R=t.getRenderTarget(),s.addEventListener("select",Y),s.addEventListener("selectstart",Y),s.addEventListener("selectend",Y),s.addEventListener("squeeze",Y),s.addEventListener("squeezestart",Y),s.addEventListener("squeezeend",Y),s.addEventListener("end",q),s.addEventListener("inputsourceschange",Z),M.xrCompatible!==!0&&await e.makeXRCompatible(),v=t.getPixelRatio(),t.getSize(I),_&&"createProjectionLayer"in XRWebGLBinding.prototype){let Mt=null,Ot=null,yt=null;M.depth&&(yt=M.stencil?e.DEPTH24_STENCIL8:e.DEPTH_COMPONENT24,Mt=M.stencil?Fn:Gi,Ot=M.stencil?qs:Fi);let qt={colorFormat:e.RGBA8,depthFormat:yt,scaleFactor:r};d=this.getBinding(),u=d.createProjectionLayer(qt),s.updateRenderState({layers:[u]}),t.setPixelRatio(1),t.setSize(u.textureWidth,u.textureHeight,!1),y=new Re(u.textureWidth,u.textureHeight,{format:Si,type:oi,depthTexture:new An(u.textureWidth,u.textureHeight,Ot,void 0,void 0,void 0,void 0,void 0,void 0,Mt),stencilBuffer:M.stencil,colorSpace:t.outputColorSpace,samples:M.antialias?4:0,resolveDepthBuffer:u.ignoreDepthValues===!1,resolveStencilBuffer:u.ignoreDepthValues===!1,storeMultisampledDepthBuffer:u.ignoreDepthValues===!1,storeMultisampledStencilBuffer:u.ignoreDepthValues===!1})}else{let Mt={antialias:M.antialias,alpha:!0,depth:M.depth,stencil:M.stencil,framebufferScaleFactor:r};f=new XRWebGLLayer(s,e,Mt),s.updateRenderState({baseLayer:f}),t.setPixelRatio(1),t.setSize(f.framebufferWidth,f.framebufferHeight,!1),y=new Re(f.framebufferWidth,f.framebufferHeight,{format:Si,type:oi,colorSpace:t.outputColorSpace,stencilBuffer:M.stencil,resolveDepthBuffer:f.ignoreDepthValues===!1,resolveStencilBuffer:f.ignoreDepthValues===!1,storeMultisampledDepthBuffer:f.ignoreDepthValues===!1,storeMultisampledStencilBuffer:f.ignoreDepthValues===!1})}y.isXRRenderTarget=!0,this.setFoveation(l),c=null,a=await s.requestReferenceSpace(o),$t.setContext(s),$t.start(),i.isPresenting=!0,i.dispatchEvent({type:"sessionstart"})}},this.getEnvironmentBlendMode=function(){if(s!==null)return s.environmentBlendMode},this.getDepthTexture=function(){return m.getDepthTexture()};function Z(Q){for(let it=0;it<Q.removed.length;it++){let Mt=Q.removed[it],Ot=S.indexOf(Mt);Ot>=0&&(S[Ot]=null,w[Ot].disconnect(Mt))}for(let it=0;it<Q.added.length;it++){let Mt=Q.added[it],Ot=S.indexOf(Mt);if(Ot===-1){for(let qt=0;qt<w.length;qt++)if(qt>=S.length){S.push(Mt),Ot=qt;break}else if(S[qt]===null){S[qt]=Mt,Ot=qt;break}if(Ot===-1)break}let yt=w[Ot];yt&&yt.connect(Mt)}}let V=new N,tt=new N;function rt(Q,it,Mt){V.setFromMatrixPosition(it.matrixWorld),tt.setFromMatrixPosition(Mt.matrixWorld);let Ot=V.distanceTo(tt),yt=it.projectionMatrix.elements,qt=Mt.projectionMatrix.elements,be=yt[14]/(yt[10]-1),Yt=yt[14]/(yt[10]+1),Kt=(yt[9]+1)/yt[5],se=(yt[9]-1)/yt[5],Wt=(yt[8]-1)/yt[0],ie=(qt[8]+1)/qt[0],ne=be*Wt,T=be*ie,G=Ot/(-Wt+ie),J=G*-Wt;if(it.matrixWorld.decompose(Q.position,Q.quaternion,Q.scale),Q.translateX(J),Q.translateZ(G),Q.matrixWorld.compose(Q.position,Q.quaternion,Q.scale),Q.matrixWorldInverse.copy(Q.matrixWorld).invert(),yt[10]===-1)Q.projectionMatrix.copy(it.projectionMatrix),Q.projectionMatrixInverse.copy(it.projectionMatrixInverse);else{let C=be+G,nt=Yt+G,dt=ne-J,E=T+(Ot-J),x=Kt*Yt/nt*C,F=se*Yt/nt*C;Q.projectionMatrix.makePerspective(dt,E,x,F,C,nt),Q.projectionMatrixInverse.copy(Q.projectionMatrix).invert()}}function St(Q,it){it===null?Q.matrixWorld.copy(Q.matrix):Q.matrixWorld.multiplyMatrices(it.matrixWorld,Q.matrix),Q.matrixWorldInverse.copy(Q.matrixWorld).invert()}this.updateCamera=function(Q){if(s===null)return;let it=Q.near,Mt=Q.far;m.texture!==null&&(m.depthNear>0&&(it=m.depthNear),m.depthFar>0&&(Mt=m.depthFar)),z.near=O.near=P.near=it,z.far=O.far=P.far=Mt,(D!==z.near||k!==z.far)&&(s.updateRenderState({depthNear:z.near,depthFar:z.far}),D=z.near,k=z.far),z.layers.mask=Q.layers.mask|6,P.layers.mask=z.layers.mask&-5,O.layers.mask=z.layers.mask&-3;let Ot=Q.parent,yt=z.cameras;St(z,Ot);for(let qt=0;qt<yt.length;qt++)St(yt[qt],Ot);yt.length===2?rt(z,P,O):z.projectionMatrix.copy(P.projectionMatrix),A===null&&Q.isPerspectiveCamera&&(A={camera:Q,fov:Q.fov,zoom:Q.zoom}),_t(Q,z,Ot)};function _t(Q,it,Mt){Mt===null?Q.matrix.copy(it.matrixWorld):(Q.matrix.copy(Mt.matrixWorld),Q.matrix.invert(),Q.matrix.multiply(it.matrixWorld)),Q.matrix.decompose(Q.position,Q.quaternion,Q.scale),Q.updateMatrixWorld(!0),Q.projectionMatrix.copy(it.projectionMatrix),Q.projectionMatrixInverse.copy(it.projectionMatrixInverse),Q.isPerspectiveCamera&&(Q.fov=Ds*2*Math.atan(1/Q.projectionMatrix.elements[5]),Q.zoom=1)}this.getCamera=function(){return z},this.getFoveation=function(){if(!(u===null&&f===null))return l},this.setFoveation=function(Q){l=Q,u!==null&&(u.fixedFoveation=Q),f!==null&&f.fixedFoveation!==void 0&&(f.fixedFoveation=Q)},this.hasDepthSensing=function(){return m.texture!==null},this.getDepthSensingMesh=function(){return m.getMesh(z)},this.getCameraTexture=function(Q){return p[Q]};let ee=null;function Ct(Q,it){if(h=it.getViewerPose(c||a),g=it,h!==null){let Mt=h.views;f!==null&&(t.setRenderTargetFramebuffer(y,f.framebuffer),t.setRenderTarget(y));let Ot=!1;Mt.length!==z.cameras.length&&(z.cameras.length=0,Ot=!0);for(let Yt=0;Yt<Mt.length;Yt++){let Kt=Mt[Yt],se=null;if(f!==null)se=f.getViewport(Kt);else{let ie=d.getViewSubImage(u,Kt);se=ie.viewport,Yt===0&&(t.setRenderTargetTextures(y,ie.colorTexture,ie.depthStencilTexture),t.setRenderTarget(y))}let Wt=L[Yt];Wt===void 0&&(Wt=new Ye,Wt.layers.enable(Yt),Wt.viewport=new Ae,L[Yt]=Wt),Wt.matrix.fromArray(Kt.transform.matrix),Wt.matrix.decompose(Wt.position,Wt.quaternion,Wt.scale),Wt.projectionMatrix.fromArray(Kt.projectionMatrix),Wt.projectionMatrixInverse.copy(Wt.projectionMatrix).invert(),Wt.viewport.set(se.x,se.y,se.width,se.height),Yt===0&&(z.matrix.copy(Wt.matrix),z.matrix.decompose(z.position,z.quaternion,z.scale)),Ot===!0&&z.cameras.push(Wt)}let yt=s.enabledFeatures;if(yt&&yt.includes("depth-sensing")&&s.depthUsage=="gpu-optimized"&&_){d=i.getBinding();let Yt=d.getDepthInformation(Mt[0]);Yt&&Yt.isValid&&Yt.texture&&m.init(Yt,s.renderState)}if(yt&&yt.includes("camera-access")&&_){t.state.unbindTexture(),d=i.getBinding();for(let Yt=0;Yt<Mt.length;Yt++){let Kt=Mt[Yt].camera;if(Kt){let se=p[Kt];se||(se=new Or,p[Kt]=se);let Wt=d.getCameraImage(Kt);se.sourceTexture=Wt}}}}for(let Mt=0;Mt<w.length;Mt++){let Ot=S[Mt],yt=w[Mt];Ot!==null&&yt!==void 0&&yt.update(Ot,it,c||a)}ee&&ee(Q,it),it.detectedPlanes&&i.dispatchEvent({type:"planesdetected",data:it}),g=null}let $t=new nf;$t.setAnimationLoop(Ct),this.setAnimationLoop=function(Q){ee=Q},this.dispose=function(){}}},$_=new oe,cf=new Xt;cf.set(-1,0,0,0,1,0,0,0,1);function Z_(n,t){function e(m,p){m.matrixAutoUpdate===!0&&m.updateMatrix(),p.value.copy(m.matrix)}function i(m,p){p.color.getRGB(m.fogColor.value,ph(n)),p.isFog?(m.fogNear.value=p.near,m.fogFar.value=p.far):p.isFogExp2&&(m.fogDensity.value=p.density)}function s(m,p,M,R,y){p.isNodeMaterial?p.uniformsNeedUpdate=!1:p.isMeshBasicMaterial?r(m,p):p.isMeshLambertMaterial?(r(m,p),p.envMap&&(m.envMapIntensity.value=p.envMapIntensity)):p.isMeshToonMaterial?(r(m,p),d(m,p)):p.isMeshPhongMaterial?(r(m,p),h(m,p),p.envMap&&(m.envMapIntensity.value=p.envMapIntensity)):p.isMeshStandardMaterial?(r(m,p),u(m,p),p.isMeshPhysicalMaterial&&f(m,p,y)):p.isMeshMatcapMaterial?(r(m,p),g(m,p)):p.isMeshDepthMaterial?r(m,p):p.isMeshDistanceMaterial?(r(m,p),_(m,p)):p.isMeshNormalMaterial?r(m,p):p.isLineBasicMaterial?(a(m,p),p.isLineDashedMaterial&&o(m,p)):p.isPointsMaterial?l(m,p,M,R):p.isSpriteMaterial?c(m,p):p.isShadowMaterial?(m.color.value.copy(p.color),m.opacity.value=p.opacity):p.isShaderMaterial&&(p.uniformsNeedUpdate=!1)}function r(m,p){m.opacity.value=p.opacity,p.color&&m.diffuse.value.copy(p.color),p.emissive&&m.emissive.value.copy(p.emissive).multiplyScalar(p.emissiveIntensity),p.map&&(m.map.value=p.map,e(p.map,m.mapTransform)),p.alphaMap&&(m.alphaMap.value=p.alphaMap,e(p.alphaMap,m.alphaMapTransform)),p.bumpMap&&(m.bumpMap.value=p.bumpMap,e(p.bumpMap,m.bumpMapTransform),m.bumpScale.value=p.bumpScale,p.side===Ze&&(m.bumpScale.value*=-1)),p.normalMap&&(m.normalMap.value=p.normalMap,e(p.normalMap,m.normalMapTransform),m.normalScale.value.copy(p.normalScale),p.side===Ze&&m.normalScale.value.negate()),p.displacementMap&&(m.displacementMap.value=p.displacementMap,e(p.displacementMap,m.displacementMapTransform),m.displacementScale.value=p.displacementScale,m.displacementBias.value=p.displacementBias),p.emissiveMap&&(m.emissiveMap.value=p.emissiveMap,e(p.emissiveMap,m.emissiveMapTransform)),p.specularMap&&(m.specularMap.value=p.specularMap,e(p.specularMap,m.specularMapTransform)),p.alphaTest>0&&(m.alphaTest.value=p.alphaTest);let M=t.get(p),R=M.envMap,y=M.envMapRotation;R&&(m.envMap.value=R,m.envMapRotation.value.setFromMatrix4($_.makeRotationFromEuler(y)).transpose(),R.isCubeTexture&&R.isRenderTargetTexture===!1&&m.envMapRotation.value.premultiply(cf),m.reflectivity.value=p.reflectivity,m.ior.value=p.ior,m.refractionRatio.value=p.refractionRatio),p.lightMap&&(m.lightMap.value=p.lightMap,m.lightMapIntensity.value=p.lightMapIntensity,e(p.lightMap,m.lightMapTransform)),p.aoMap&&(m.aoMap.value=p.aoMap,m.aoMapIntensity.value=p.aoMapIntensity,e(p.aoMap,m.aoMapTransform))}function a(m,p){m.diffuse.value.copy(p.color),m.opacity.value=p.opacity,p.map&&(m.map.value=p.map,e(p.map,m.mapTransform))}function o(m,p){m.dashSize.value=p.dashSize,m.totalSize.value=p.dashSize+p.gapSize,m.scale.value=p.scale}function l(m,p,M,R){m.diffuse.value.copy(p.color),m.opacity.value=p.opacity,m.size.value=p.size*M,m.scale.value=R*.5,p.map&&(m.map.value=p.map,e(p.map,m.uvTransform)),p.alphaMap&&(m.alphaMap.value=p.alphaMap,e(p.alphaMap,m.alphaMapTransform)),p.alphaTest>0&&(m.alphaTest.value=p.alphaTest)}function c(m,p){m.diffuse.value.copy(p.color),m.opacity.value=p.opacity,m.rotation.value=p.rotation,p.map&&(m.map.value=p.map,e(p.map,m.mapTransform)),p.alphaMap&&(m.alphaMap.value=p.alphaMap,e(p.alphaMap,m.alphaMapTransform)),p.alphaTest>0&&(m.alphaTest.value=p.alphaTest)}function h(m,p){m.specular.value.copy(p.specular),m.shininess.value=Math.max(p.shininess,1e-4)}function d(m,p){p.gradientMap&&(m.gradientMap.value=p.gradientMap)}function u(m,p){m.metalness.value=p.metalness,p.metalnessMap&&(m.metalnessMap.value=p.metalnessMap,e(p.metalnessMap,m.metalnessMapTransform)),m.roughness.value=p.roughness,p.roughnessMap&&(m.roughnessMap.value=p.roughnessMap,e(p.roughnessMap,m.roughnessMapTransform)),p.envMap&&(m.envMapIntensity.value=p.envMapIntensity)}function f(m,p,M){m.ior.value=p.ior,p.sheen>0&&(m.sheenColor.value.copy(p.sheenColor).multiplyScalar(p.sheen),m.sheenRoughness.value=p.sheenRoughness,p.sheenColorMap&&(m.sheenColorMap.value=p.sheenColorMap,e(p.sheenColorMap,m.sheenColorMapTransform)),p.sheenRoughnessMap&&(m.sheenRoughnessMap.value=p.sheenRoughnessMap,e(p.sheenRoughnessMap,m.sheenRoughnessMapTransform))),p.clearcoat>0&&(m.clearcoat.value=p.clearcoat,m.clearcoatRoughness.value=p.clearcoatRoughness,p.clearcoatMap&&(m.clearcoatMap.value=p.clearcoatMap,e(p.clearcoatMap,m.clearcoatMapTransform)),p.clearcoatRoughnessMap&&(m.clearcoatRoughnessMap.value=p.clearcoatRoughnessMap,e(p.clearcoatRoughnessMap,m.clearcoatRoughnessMapTransform)),p.clearcoatNormalMap&&(m.clearcoatNormalMap.value=p.clearcoatNormalMap,e(p.clearcoatNormalMap,m.clearcoatNormalMapTransform),m.clearcoatNormalScale.value.copy(p.clearcoatNormalScale),p.side===Ze&&m.clearcoatNormalScale.value.negate())),p.dispersion>0&&(m.dispersion.value=p.dispersion),p.retroreflectivity>0&&(m.retroreflectivity.value=p.retroreflectivity),p.iridescence>0&&(m.iridescence.value=p.iridescence,m.iridescenceIOR.value=p.iridescenceIOR,m.iridescenceThicknessMinimum.value=p.iridescenceThicknessRange[0],m.iridescenceThicknessMaximum.value=p.iridescenceThicknessRange[1],p.iridescenceMap&&(m.iridescenceMap.value=p.iridescenceMap,e(p.iridescenceMap,m.iridescenceMapTransform)),p.iridescenceThicknessMap&&(m.iridescenceThicknessMap.value=p.iridescenceThicknessMap,e(p.iridescenceThicknessMap,m.iridescenceThicknessMapTransform))),p.transmission>0&&(m.transmission.value=p.transmission,m.transmissionSamplerMap.value=M.texture,m.transmissionSamplerSize.value.set(M.width,M.height),p.transmissionMap&&(m.transmissionMap.value=p.transmissionMap,e(p.transmissionMap,m.transmissionMapTransform)),m.thickness.value=p.thickness,p.thicknessMap&&(m.thicknessMap.value=p.thicknessMap,e(p.thicknessMap,m.thicknessMapTransform)),m.attenuationDistance.value=p.attenuationDistance,m.attenuationColor.value.copy(p.attenuationColor)),p.anisotropy>0&&(m.anisotropyVector.value.set(p.anisotropy*Math.cos(p.anisotropyRotation),p.anisotropy*Math.sin(p.anisotropyRotation)),p.anisotropyMap&&(m.anisotropyMap.value=p.anisotropyMap,e(p.anisotropyMap,m.anisotropyMapTransform))),m.specularIntensity.value=p.specularIntensity,m.specularColor.value.copy(p.specularColor),p.specularColorMap&&(m.specularColorMap.value=p.specularColorMap,e(p.specularColorMap,m.specularColorMapTransform)),p.specularIntensityMap&&(m.specularIntensityMap.value=p.specularIntensityMap,e(p.specularIntensityMap,m.specularIntensityMapTransform))}function g(m,p){p.matcap&&(m.matcap.value=p.matcap)}function _(m,p){let M=t.get(p).light;m.referencePosition.value.setFromMatrixPosition(M.matrixWorld),m.nearDistance.value=M.shadow.camera.near,m.farDistance.value=M.shadow.camera.far}return{refreshFogUniforms:i,refreshMaterialUniforms:s}}function J_(n,t,e,i){let s={},r={},a=[],o=n.getParameter(n.MAX_UNIFORM_BUFFER_BINDINGS);function l(y,w){let S=w.program;i.uniformBlockBinding(y,S)}function c(y,w){let S=s[y.id];S===void 0&&(m(y),S=h(y),s[y.id]=S,y.addEventListener("dispose",M));let I=w.program;i.updateUBOMapping(y,I);let v=t.render.frame;r[y.id]!==v&&(u(y),r[y.id]=v)}function h(y){let w=d();y.__bindingPointIndex=w;let S=n.createBuffer(),I=y.__size,v=y.usage;return n.bindBuffer(n.UNIFORM_BUFFER,S),n.bufferData(n.UNIFORM_BUFFER,I,v),n.bindBuffer(n.UNIFORM_BUFFER,null),n.bindBufferBase(n.UNIFORM_BUFFER,w,S),S}function d(){for(let y=0;y<o;y++)if(a.indexOf(y)===-1)return a.push(y),y;return Ht("WebGLRenderer: Maximum number of simultaneously usable uniforms groups reached."),0}function u(y){let w=s[y.id],S=y.uniforms,I=y.__cache;n.bindBuffer(n.UNIFORM_BUFFER,w);for(let v=0,A=S.length;v<A;v++){let P=S[v];if(Array.isArray(P))for(let O=0,L=P.length;O<L;O++)f(P[O],v,O,I);else f(P,v,0,I)}n.bindBuffer(n.UNIFORM_BUFFER,null)}function f(y,w,S,I){if(_(y,w,S,I)===!0){let v=y.__offset,A=y.value;if(Array.isArray(A)){let P=0;for(let O=0;O<A.length;O++){let L=A[O],z=p(L);g(L,y.__data,P),typeof L!="number"&&typeof L!="boolean"&&!L.isMatrix3&&!ArrayBuffer.isView(L)&&(P+=z.storage/Float32Array.BYTES_PER_ELEMENT)}}else g(A,y.__data,0);n.bufferSubData(n.UNIFORM_BUFFER,v,y.__data)}}function g(y,w,S){typeof y=="number"||typeof y=="boolean"?w[0]=y:y.isMatrix3?(w[0]=y.elements[0],w[1]=y.elements[1],w[2]=y.elements[2],w[3]=0,w[4]=y.elements[3],w[5]=y.elements[4],w[6]=y.elements[5],w[7]=0,w[8]=y.elements[6],w[9]=y.elements[7],w[10]=y.elements[8],w[11]=0):ArrayBuffer.isView(y)?w.set(new y.constructor(y.buffer,y.byteOffset,w.length)):y.toArray(w,S)}function _(y,w,S,I){let v=y.value,A=w+"_"+S;if(I[A]===void 0)return typeof v=="number"||typeof v=="boolean"?I[A]=v:ArrayBuffer.isView(v)?I[A]=v.slice():I[A]=v.clone(),!0;{let P=I[A];if(typeof v=="number"||typeof v=="boolean"){if(P!==v)return I[A]=v,!0}else{if(ArrayBuffer.isView(v))return!0;if(P.equals(v)===!1)return P.copy(v),!0}}return!1}function m(y){let w=y.uniforms,S=0,I=16;for(let A=0,P=w.length;A<P;A++){let O=Array.isArray(w[A])?w[A]:[w[A]];for(let L=0,z=O.length;L<z;L++){let D=O[L],k=Array.isArray(D.value)?D.value:[D.value];for(let Y=0,q=k.length;Y<q;Y++){let Z=k[Y],V=p(Z),tt=S%I,rt=tt%V.boundary,St=tt+rt;S+=rt,St!==0&&I-St<V.storage&&(S+=I-St),D.__data=new Float32Array(V.storage/Float32Array.BYTES_PER_ELEMENT),D.__offset=S,S+=V.storage}}}let v=S%I;return v>0&&(S+=I-v),y.__size=S,y.__cache={},this}function p(y){let w={boundary:0,storage:0};return typeof y=="number"||typeof y=="boolean"?(w.boundary=4,w.storage=4):y.isVector2?(w.boundary=8,w.storage=8):y.isVector3||y.isColor?(w.boundary=16,w.storage=12):y.isVector4?(w.boundary=16,w.storage=16):y.isMatrix3?(w.boundary=48,w.storage=48):y.isMatrix4?(w.boundary=64,w.storage=64):y.isTexture?kt("WebGLRenderer: Texture samplers can not be part of an uniforms group."):ArrayBuffer.isView(y)?(w.boundary=16,w.storage=y.byteLength):kt("WebGLRenderer: Unsupported uniform value type.",y),w}function M(y){let w=y.target;w.removeEventListener("dispose",M);let S=a.indexOf(w.__bindingPointIndex);a.splice(S,1),n.deleteBuffer(s[w.id]),delete s[w.id],delete r[w.id]}function R(){for(let y in s)n.deleteBuffer(s[y]);a=[],s={},r={}}return{bind:l,update:c,dispose:R}}var K_=new Uint16Array([12469,15057,12620,14925,13266,14620,13807,14376,14323,13990,14545,13625,14713,13328,14840,12882,14931,12528,14996,12233,15039,11829,15066,11525,15080,11295,15085,10976,15082,10705,15073,10495,13880,14564,13898,14542,13977,14430,14158,14124,14393,13732,14556,13410,14702,12996,14814,12596,14891,12291,14937,11834,14957,11489,14958,11194,14943,10803,14921,10506,14893,10278,14858,9960,14484,14039,14487,14025,14499,13941,14524,13740,14574,13468,14654,13106,14743,12678,14818,12344,14867,11893,14889,11509,14893,11180,14881,10751,14852,10428,14812,10128,14765,9754,14712,9466,14764,13480,14764,13475,14766,13440,14766,13347,14769,13070,14786,12713,14816,12387,14844,11957,14860,11549,14868,11215,14855,10751,14825,10403,14782,10044,14729,9651,14666,9352,14599,9029,14967,12835,14966,12831,14963,12804,14954,12723,14936,12564,14917,12347,14900,11958,14886,11569,14878,11247,14859,10765,14828,10401,14784,10011,14727,9600,14660,9289,14586,8893,14508,8533,15111,12234,15110,12234,15104,12216,15092,12156,15067,12010,15028,11776,14981,11500,14942,11205,14902,10752,14861,10393,14812,9991,14752,9570,14682,9252,14603,8808,14519,8445,14431,8145,15209,11449,15208,11451,15202,11451,15190,11438,15163,11384,15117,11274,15055,10979,14994,10648,14932,10343,14871,9936,14803,9532,14729,9218,14645,8742,14556,8381,14461,8020,14365,7603,15273,10603,15272,10607,15267,10619,15256,10631,15231,10614,15182,10535,15118,10389,15042,10167,14963,9787,14883,9447,14800,9115,14710,8665,14615,8318,14514,7911,14411,7507,14279,7198,15314,9675,15313,9683,15309,9712,15298,9759,15277,9797,15229,9773,15166,9668,15084,9487,14995,9274,14898,8910,14800,8539,14697,8234,14590,7790,14479,7409,14367,7067,14178,6621,15337,8619,15337,8631,15333,8677,15325,8769,15305,8871,15264,8940,15202,8909,15119,8775,15022,8565,14916,8328,14804,8009,14688,7614,14569,7287,14448,6888,14321,6483,14088,6171,15350,7402,15350,7419,15347,7480,15340,7613,15322,7804,15287,7973,15229,8057,15148,8012,15046,7846,14933,7611,14810,7357,14682,7069,14552,6656,14421,6316,14251,5948,14007,5528,15356,5942,15356,5977,15353,6119,15348,6294,15332,6551,15302,6824,15249,7044,15171,7122,15070,7050,14949,6861,14818,6611,14679,6349,14538,6067,14398,5651,14189,5311,13935,4958,15359,4123,15359,4153,15356,4296,15353,4646,15338,5160,15311,5508,15263,5829,15188,6042,15088,6094,14966,6001,14826,5796,14678,5543,14527,5287,14377,4985,14133,4586,13869,4257,15360,1563,15360,1642,15358,2076,15354,2636,15341,3350,15317,4019,15273,4429,15203,4732,15105,4911,14981,4932,14836,4818,14679,4621,14517,4386,14359,4156,14083,3795,13808,3437,15360,122,15360,137,15358,285,15355,636,15344,1274,15322,2177,15281,2765,15215,3223,15120,3451,14995,3569,14846,3567,14681,3466,14511,3305,14344,3121,14037,2800,13753,2467,15360,0,15360,1,15359,21,15355,89,15346,253,15325,479,15287,796,15225,1148,15133,1492,15008,1749,14856,1882,14685,1886,14506,1783,14324,1608,13996,1398,13702,1183]),$i=null;function Q_(){return $i===null&&($i=new Nr(K_,16,16,zn,He),$i.name="DFG_LUT",$i.minFilter=Oe,$i.magFilter=Oe,$i.wrapS=Vi,$i.wrapT=Vi,$i.generateMipmaps=!1,$i.needsUpdate=!0),$i}var Cl=class{constructor(t={}){let{canvas:e=Ad(),context:i=null,depth:s=!0,stencil:r=!1,alpha:a=!1,antialias:o=!1,premultipliedAlpha:l=!0,preserveDrawingBuffer:c=!1,powerPreference:h="default",failIfMajorPerformanceCaveat:d=!1,reversedDepthBuffer:u=!1,outputBufferType:f=oi}=t;this.isWebGLRenderer=!0;let g;if(i!==null){if(typeof WebGLRenderingContext<"u"&&i instanceof WebGLRenderingContext)throw new Error("THREE.WebGLRenderer: WebGL 1 is not supported since r163.");g=i.getContextAttributes().alpha}else g=a;let _=f,m=new Set([Yo,qo,Xo]),p=new Set([oi,Fi,Xs,qs,Vo,Go]),M=new Uint32Array(4),R=new Int32Array(4),y=new N,w=null,S=null,I=[],v=[],A=null;this.domElement=e,this.debug={checkShaderErrors:!0,diagnostics:{keywords:!1},onShaderError:null},this.autoClear=!0,this.autoClearColor=!0,this.autoClearDepth=!0,this.autoClearStencil=!0,this.sortObjects=!0,this.clippingPlanes=[],this.localClippingEnabled=!1,this.toneMapping=Ui,this.toneMappingExposure=1,this.transmissionResolutionScale=1;let P=this,O=!1,L=null,z=null,D=null,k=null;this._outputColorSpace=Ee;let Y=0,q=0,Z=null,V=-1,tt=null,rt=new Ae,St=new Ae,_t=null,ee=new Ut(0),Ct=0,$t=e.width,Q=e.height,it=1,Mt=null,Ot=null,yt=new Ae(0,0,$t,Q),qt=new Ae(0,0,$t,Q),be=!1,Yt=new ks,Kt=!1,se=!1,Wt=new oe,ie=new N,ne=new Ae,T={background:null,fog:null,environment:null,overrideMaterial:null,isScene:!0},G=!1;function J(){return Z===null?it:1}let C=i;function nt(b,U){return e.getContext(b,U)}let dt,E,x,F,H,K,ot,ut,j,et,lt,Dt,ft,ct,Rt,Ft,Vt,B,ht,st,pt,bt,at;try{let b={alpha:!0,depth:s,stencil:r,antialias:o,premultipliedAlpha:l,preserveDrawingBuffer:c,powerPreference:h,failIfMajorPerformanceCaveat:d};if("setAttribute"in e&&e.setAttribute("data-engine",`three.js r${"186"}`),e.addEventListener("webglcontextlost",ve,!1),e.addEventListener("webglcontextrestored",ue,!1),e.addEventListener("webglcontextcreationerror",Ri,!1),C===null){let U="webgl2";if(C=nt(U,b),C===null)throw nt(U)?new Error("THREE.WebGLRenderer: Error creating WebGL context with your selected attributes."):new Error("THREE.WebGLRenderer: Error creating WebGL context.")}zt()}catch(b){throw e.removeEventListener("webglcontextlost",ve,!1),e.removeEventListener("webglcontextrestored",ue,!1),e.removeEventListener("webglcontextcreationerror",Ri,!1),Ht("WebGLRenderer: "+b.message),b}function zt(){dt=new rx(C),dt.init(),pt=new X_(C,dt),E=new Zg(C,dt,t,pt),x=new G_(C,dt),E.reversedDepthBuffer&&u&&x.buffers.depth.setReversed(!0),z=C.createFramebuffer(),D=C.createFramebuffer(),k=C.createFramebuffer(),F=new lx(C),H=new C_,K=new W_(C,dt,x,H,E,pt,F),ot=new sx(P),ut=new hm(C),bt=new Yg(C,ut),j=new ax(C,ut,F,bt),et=new hx(C,j,ut,bt,F),B=new cx(C,E,K),Rt=new Jg(H),lt=new R_(P,ot,dt,E,bt,Rt),Dt=new Z_(P,H),ft=new P_,ct=new z_(dt),Vt=new qg(P,ot,x,et,g,l),Ft=new V_(P,et,E),at=new J_(C,F,E,x),ht=new $g(C,dt,F),st=new ox(C,dt,F),F.programs=lt.programs,P.capabilities=E,P.extensions=dt,P.properties=H,P.renderLists=ft,P.shadowMap=Ft,P.state=x,P.info=F}_!==oi&&(A=new dx(_,e.width,e.height,o,s,r));let Lt=new zh(P,C);this.xr=Lt,this.getContext=function(){return C},this.getContextAttributes=function(){return C.getContextAttributes()},this.forceContextLoss=function(){let b=dt.get("WEBGL_lose_context");b&&b.loseContext()},this.forceContextRestore=function(){let b=dt.get("WEBGL_lose_context");b&&b.restoreContext()},this.getPixelRatio=function(){return it},this.setPixelRatio=function(b){b!==void 0&&(it=b,this.setSize($t,Q,!1))},this.getSize=function(b){return b.set($t,Q)},this.setSize=function(b,U,$=!0){if(Lt.isPresenting){kt("WebGLRenderer: Can't change size while VR device is presenting.");return}$t=b,Q=U,e.width=Math.floor(b*it),e.height=Math.floor(U*it),$===!0&&(e.style.width=b+"px",e.style.height=U+"px"),A!==null&&A.setSize(e.width,e.height),this.setViewport(0,0,b,U)},this.getDrawingBufferSize=function(b){return b.set($t*it,Q*it).floor()},this.setDrawingBufferSize=function(b,U,$){$t=b,Q=U,it=$,e.width=Math.floor(b*$),e.height=Math.floor(U*$),this.setViewport(0,0,b,U)},this.setEffects=function(b){if(_===oi){Ht("WebGLRenderer: setEffects() requires outputBufferType set to HalfFloatType or FloatType.");return}if(b){for(let U=0;U<b.length;U++)if(b[U].isOutputPass===!0){kt("WebGLRenderer: OutputPass is not needed in setEffects(). Tone mapping and color space conversion are applied automatically.");break}}A.setEffects(b||[])},this.getCurrentViewport=function(b){return b.copy(rt)},this.getViewport=function(b){return b.copy(yt)},this.setViewport=function(b,U,$,W){b.isVector4?yt.set(b.x,b.y,b.z,b.w):yt.set(b,U,$,W),x.viewport(rt.copy(yt).multiplyScalar(it).round())},this.getScissor=function(b){return b.copy(qt)},this.setScissor=function(b,U,$,W){b.isVector4?qt.set(b.x,b.y,b.z,b.w):qt.set(b,U,$,W),x.scissor(St.copy(qt).multiplyScalar(it).round())},this.getScissorTest=function(){return be},this.setScissorTest=function(b){x.setScissorTest(be=b)},this.setOpaqueSort=function(b){Mt=b},this.setTransparentSort=function(b){Ot=b},this.getClearColor=function(b){return b.copy(Vt.getClearColor())},this.setClearColor=function(){Vt.setClearColor(...arguments)},this.getClearAlpha=function(){return Vt.getClearAlpha()},this.setClearAlpha=function(){Vt.setClearAlpha(...arguments)},this.clear=function(b=!0,U=!0,$=!0){let W=0;if(b){let X=!1;if(Z!==null){let vt=Z.texture.format;X=m.has(vt)}if(X){let vt=Z.texture.type,Et=p.has(vt),gt=Vt.getClearColor(),It=Vt.getClearAlpha(),Nt=gt.r,Zt=gt.g,jt=gt.b;Et?(M[0]=Nt,M[1]=Zt,M[2]=jt,M[3]=It,C.clearBufferuiv(C.COLOR,0,M)):(R[0]=Nt,R[1]=Zt,R[2]=jt,R[3]=It,C.clearBufferiv(C.COLOR,0,R))}else W|=C.COLOR_BUFFER_BIT}U&&(W|=C.DEPTH_BUFFER_BIT,this.state.buffers.depth.setMask(!0)),$&&(W|=C.STENCIL_BUFFER_BIT,this.state.buffers.stencil.setMask(4294967295)),W!==0&&C.clear(W)},this.clearColor=function(){this.clear(!0,!1,!1)},this.clearDepth=function(){this.clear(!1,!0,!1)},this.clearStencil=function(){this.clear(!1,!1,!0)},this.setNodesHandler=function(b){b.setRenderer(this),L=b},this.dispose=function(){e.removeEventListener("webglcontextlost",ve,!1),e.removeEventListener("webglcontextrestored",ue,!1),e.removeEventListener("webglcontextcreationerror",Ri,!1),Vt.dispose(),ft.dispose(),ct.dispose(),H.dispose(),ot.dispose(),et.dispose(),bt.dispose(),at.dispose(),lt.dispose(),Lt.dispose(),Lt.removeEventListener("sessionstart",ru),Lt.removeEventListener("sessionend",au),Gn.stop()};function ve(b){b.preventDefault(),Ar("WebGLRenderer: Context Lost."),O=!0}function ue(){Ar("WebGLRenderer: Context Restored."),O=!1;let b=F.autoReset,U=Ft.enabled,$=Ft.autoUpdate,W=Ft.needsUpdate,X=Ft.type;zt(),F.autoReset=b,Ft.enabled=U,Ft.autoUpdate=$,Ft.needsUpdate=W,Ft.type=X}function Ri(b){Ht("WebGLRenderer: A WebGL context could not be created. Reason: ",b.statusMessage)}function Oi(b){let U=b.target;U.removeEventListener("dispose",Oi),ep(U)}function ep(b){ip(b),H.remove(b)}function ip(b){let U=H.get(b).programs;U!==void 0&&(U.forEach(function($){lt.releaseProgram($)}),b.isShaderMaterial&&lt.releaseShaderCache(b))}this.renderBufferDirect=function(b,U,$,W,X,vt){U===null&&(U=T);let Et=X.isMesh&&X.matrixWorld.determinantAffine()<0,gt=rp(b,U,$,W,X);x.setMaterial(W,Et);let It=$.index,Nt=1;if(W.wireframe===!0){if(It=j.getWireframeAttribute($),It===void 0)return;Nt=2}let Zt=$.drawRange,jt=$.attributes.position,Pt=Zt.start*Nt,de=(Zt.start+Zt.count)*Nt;vt!==null&&(Pt=Math.max(Pt,vt.start*Nt),de=Math.min(de,(vt.start+vt.count)*Nt)),It!==null?(Pt=Math.max(Pt,0),de=Math.min(de,It.count)):jt!=null&&(Pt=Math.max(Pt,0),de=Math.min(de,jt.count));let Ue=de-Pt;if(Ue<0||Ue===1/0)return;bt.setup(X,W,gt,$,It);let Se,_e=ht;if(It!==null&&(Se=ut.get(It),_e=st,_e.setIndex(Se)),X.isMesh)W.wireframe===!0?(x.setLineWidth(W.wireframeLinewidth*J()),_e.setMode(C.LINES)):_e.setMode(C.TRIANGLES);else if(X.isLine){let Ke=W.linewidth;Ke===void 0&&(Ke=1),x.setLineWidth(Ke*J()),X.isLineSegments?_e.setMode(C.LINES):X.isLineLoop?_e.setMode(C.LINE_LOOP):_e.setMode(C.LINE_STRIP)}else X.isPoints?_e.setMode(C.POINTS):X.isSprite&&_e.setMode(C.TRIANGLES);if(X.isBatchedMesh)if(dt.get("WEBGL_multi_draw"))_e.renderMultiDraw(X._multiDrawStarts,X._multiDrawCounts,X._multiDrawCount);else{let Ke=X._multiDrawStarts,wt=X._multiDrawCounts,si=X._multiDrawCount,re=It?ut.get(It).bytesPerElement:1,mi=H.get(W).currentProgram.getUniforms();for(let ki=0;ki<si;ki++)mi.setValue(C,"_gl_DrawID",ki),_e.render(Ke[ki]/re,wt[ki])}else if(X.isInstancedMesh)_e.renderInstances(Pt,Ue,X.count);else if($.isInstancedBufferGeometry){let Ke=$._maxInstanceCount!==void 0?$._maxInstanceCount:1/0,wt=Math.min($.instanceCount,Ke);_e.renderInstances(Pt,Ue,wt)}else _e.render(Pt,Ue)};function su(b,U,$,W){L!==null&&b.isNodeMaterial&&L.setObject(W,b),Kt===!0&&Rt.setState(b,$,!1),b.transparent===!0&&b.side===ke&&b.forceSinglePass===!1?(b.side=Ze,b.needsUpdate=!0,Ra(b,U,W),b.side=Dn,b.needsUpdate=!0,Ra(b,U,W),b.side=ke):Ra(b,U,W)}this.compile=function(b,U,$=null){$===null&&($=b),L!==null&&L.renderStart(b,U,$),S=ct.get($),S.init(U),v.push(S),$.traverseVisible(function(X){X.isLight&&X.layers.test(U.layers)&&(S.pushLight(X),X.castShadow&&S.pushShadow(X))}),b!==$&&b.traverseVisible(function(X){X.isLight&&X.layers.test(U.layers)&&(S.pushLight(X),X.castShadow&&S.pushShadow(X))}),S.setupLights(),L!==null&&L.updateLights(S.state.lightsArray),se=this.localClippingEnabled,Kt=Rt.init(this.clippingPlanes,se),Kt===!0&&Rt.setGlobalState(this.clippingPlanes,U),L!==null&&Ft.render(S.state.shadowsArray,$,U);let W=new Set;return b.traverse(function(X){if(!(X.isMesh||X.isPoints||X.isLine||X.isSprite))return;let vt=X.material;if(vt)if(Array.isArray(vt))for(let Et=0;Et<vt.length;Et++){let gt=vt[Et];su(gt,$,U,X),W.add(gt)}else su(vt,$,U,X),W.add(vt)}),S=v.pop(),L!==null&&L.renderEnd(),W},this.compileAsync=function(b,U,$=null){let W=this.compile(b,U,$);return new Promise(X=>{function vt(){if(W.forEach(function(Et){let It=H.get(Et).currentProgram;(It===void 0||It.isReady())&&W.delete(Et)}),W.size===0){X(b);return}setTimeout(vt,10)}dt.get("KHR_parallel_shader_compile")!==null?vt():setTimeout(vt,10)})};let xc=null;function np(b){xc&&xc(b)}function ru(){Gn.stop()}function au(){Gn.start()}let Gn=new nf;Gn.setAnimationLoop(np),typeof self<"u"&&Gn.setContext(self),this.setAnimationLoop=function(b){xc=b,Lt.setAnimationLoop(b),b===null?Gn.stop():Gn.start()},Lt.addEventListener("sessionstart",ru),Lt.addEventListener("sessionend",au),this.render=function(b,U){if(U!==void 0&&U.isCamera!==!0){Ht("WebGLRenderer.render: camera is not an instance of THREE.Camera.");return}if(O===!0)return;L!==null&&L.renderStart(b,U);let $=Lt.enabled===!0&&Lt.isPresenting===!0,W=A!==null&&(Z===null||$)&&A.begin(P,Z);if(b.matrixWorldAutoUpdate===!0&&b.updateMatrixWorld(),U.parent===null&&U.matrixWorldAutoUpdate===!0&&U.updateMatrixWorld(),Lt.enabled===!0&&Lt.isPresenting===!0&&(A===null||A.isCompositing()===!1)&&(Lt.cameraAutoUpdate===!0&&Lt.updateCamera(U),U=Lt.getCamera()),b.isScene===!0&&b.onBeforeRender(P,b,U,Z),S=ct.get(b,v.length),S.init(U),S.state.textureUnits=K.getTextureUnits(),v.push(S),Wt.multiplyMatrices(U.projectionMatrix,U.matrixWorldInverse),Yt.setFromProjectionMatrix(Wt,Di,U.reversedDepth),se=this.localClippingEnabled,Kt=Rt.init(this.clippingPlanes,se),w=ft.get(b,I.length),w.init(),I.push(w),Lt.enabled===!0&&Lt.isPresenting===!0){let Et=P.xr.getDepthSensingMesh();Et!==null&&_c(Et,U,-1/0,P.sortObjects)}_c(b,U,0,P.sortObjects),w.finish(),L!==null&&L.updateLights(S.state.lightsArray),P.sortObjects===!0&&w.sort(Mt,Ot),G=Lt.enabled===!1||Lt.isPresenting===!1||Lt.hasDepthSensing()===!1,G&&Vt.addToRenderList(w,b),this.info.render.frame++,this.info.autoReset===!0&&this.info.reset(),Kt===!0&&Rt.beginShadows();let X=S.state.shadowsArray;if(Ft.render(X,b,U),Kt===!0&&Rt.endShadows(),(W&&A.hasRenderPass())===!1){let Et=w.opaque,gt=w.transmissive;if(S.setupLights(),U.isArrayCamera){let It=U.cameras;if(gt.length>0)for(let Nt=0,Zt=It.length;Nt<Zt;Nt++){let jt=It[Nt];lu(Et,gt,b,jt)}G&&Vt.render(b);for(let Nt=0,Zt=It.length;Nt<Zt;Nt++){let jt=It[Nt];ou(w,b,jt,jt.viewport)}}else gt.length>0&&lu(Et,gt,b,U),G&&Vt.render(b),ou(w,b,U)}Z!==null&&q===0&&(K.updateMultisampleRenderTarget(Z),K.updateRenderTargetMipmap(Z)),W&&A.end(P),b.isScene===!0&&b.onAfterRender(P,b,U),bt.resetDefaultState(),V=-1,tt=null,v.pop(),v.length>0?(S=v[v.length-1],K.setTextureUnits(S.state.textureUnits),Kt===!0&&Rt.setGlobalState(P.clippingPlanes,S.state.camera)):S=null,I.pop(),I.length>0?w=I[I.length-1]:w=null,L!==null&&L.renderEnd()};function _c(b,U,$,W){if(b.visible===!1)return;if(b.layers.test(U.layers)){if(b.isGroup)$=b.renderOrder;else if(b.isLOD)b.autoUpdate===!0&&b.update(U);else if(b.isLightProbeGrid)S.pushLightProbeGrid(b);else if(b.isLight)S.pushLight(b),b.castShadow&&S.pushShadow(b);else if(b.isSprite){if(!b.frustumCulled||b.intersectsFrustum(Yt)){W&&ne.setFromMatrixPosition(b.matrixWorld).applyMatrix4(Wt);let Et=et.update(b),gt=b.material;gt.visible&&w.push(b,Et,gt,$,ne.z,null,U)}}else if((b.isMesh||b.isLine||b.isPoints)&&(!b.frustumCulled||b.intersectsFrustum(Yt))){let Et=et.update(b),gt=b.material;if(W&&(b.boundingSphere!==void 0?(b.boundingSphere===null&&b.computeBoundingSphere(),ne.copy(b.boundingSphere.center)):(Et.boundingSphere===null&&Et.computeBoundingSphere(),ne.copy(Et.boundingSphere.center)),ne.applyMatrix4(b.matrixWorld).applyMatrix4(Wt)),Array.isArray(gt)){let It=Et.groups;for(let Nt=0,Zt=It.length;Nt<Zt;Nt++){let jt=It[Nt],Pt=gt[jt.materialIndex];Pt&&Pt.visible&&w.push(b,Et,Pt,$,ne.z,jt,U)}}else gt.visible&&w.push(b,Et,gt,$,ne.z,null,U)}}let vt=b.children;for(let Et=0,gt=vt.length;Et<gt;Et++)_c(vt[Et],U,$,W)}function ou(b,U,$,W){let{opaque:X,transmissive:vt,transparent:Et}=b;S.setupLightsView($),Kt===!0&&Rt.setGlobalState(P.clippingPlanes,$),W&&x.viewport(rt.copy(W)),X.length>0&&Aa(X,U,$),vt.length>0&&Aa(vt,U,$),Et.length>0&&Aa(Et,U,$),x.buffers.depth.setTest(!0),x.buffers.depth.setMask(!0),x.buffers.color.setMask(!0),x.setPolygonOffset(!1)}function lu(b,U,$,W){if(($.isScene===!0?$.overrideMaterial:null)!==null)return;if(S.state.transmissionRenderTarget[W.id]===void 0){let Pt=dt.has("EXT_color_buffer_half_float")||dt.has("EXT_color_buffer_float");S.state.transmissionRenderTarget[W.id]=new Re(1,1,{generateMipmaps:!0,type:Pt?He:oi,minFilter:Yi,samples:Math.max(4,E.samples),stencilBuffer:r,resolveDepthBuffer:!1,resolveStencilBuffer:!1,storeMultisampledDepthBuffer:!1,storeMultisampledStencilBuffer:!1,colorSpace:Qt.workingColorSpace})}let vt=S.state.transmissionRenderTarget[W.id],Et=W.viewport||rt;vt.setSize(Et.z*P.transmissionResolutionScale,Et.w*P.transmissionResolutionScale);let gt=P.getRenderTarget(),It=P.getActiveCubeFace(),Nt=P.getActiveMipmapLevel();P.setRenderTarget(vt),P.getClearColor(ee),Ct=P.getClearAlpha(),Ct<1&&P.setClearColor(16777215,.5),P.clear(),G&&Vt.render($);let Zt=P.toneMapping;P.toneMapping=Ui;let jt=W.viewport;if(W.viewport!==void 0&&(W.viewport=void 0),S.setupLightsView(W),Kt===!0&&Rt.setGlobalState(P.clippingPlanes,W),Aa(b,$,W),K.updateMultisampleRenderTarget(vt),K.updateRenderTargetMipmap(vt),dt.has("WEBGL_multisampled_render_to_texture")===!1){let Pt=!1;for(let de=0,Ue=U.length;de<Ue;de++){let Se=U[de],{object:_e,geometry:Ke,material:wt,group:si}=Se;if(wt.side===ke&&_e.layers.test(W.layers)){let re=wt.side;wt.side=Ze,wt.needsUpdate=!0,cu(_e,$,W,Ke,wt,si),wt.side=re,wt.needsUpdate=!0,Pt=!0}}Pt===!0&&(K.updateMultisampleRenderTarget(vt),K.updateRenderTargetMipmap(vt))}P.setRenderTarget(gt,It,Nt),P.setClearColor(ee,Ct),jt!==void 0&&(W.viewport=jt),P.toneMapping=Zt}function Aa(b,U,$){let W=U.isScene===!0?U.overrideMaterial:null;for(let X=0,vt=b.length;X<vt;X++){let Et=b[X],{object:gt,geometry:It,group:Nt}=Et,Zt=Et.material;Zt.allowOverride===!0&&W!==null&&(Zt=W),gt.layers.test($.layers)&&cu(gt,U,$,It,Zt,Nt)}}function cu(b,U,$,W,X,vt){L!==null&&X.isNodeMaterial&&L.setObject(b,X),b.onBeforeRender(P,U,$,W,X,vt),b.modelViewMatrix.multiplyMatrices($.matrixWorldInverse,b.matrixWorld),b.normalMatrix.getNormalMatrix(b.modelViewMatrix),X.onBeforeRender(P,U,$,W,b,vt),X.transparent===!0&&X.side===ke&&X.forceSinglePass===!1?(X.side=Ze,X.needsUpdate=!0,P.renderBufferDirect($,U,W,X,b,vt),X.side=Dn,X.needsUpdate=!0,P.renderBufferDirect($,U,W,X,b,vt),X.side=ke):P.renderBufferDirect($,U,W,X,b,vt),b.onAfterRender(P,U,$,W,X,vt)}function Ra(b,U,$){U.isScene!==!0&&(U=T);let W=H.get(b),X=S.state.lights,vt=S.state.shadowsArray,Et=X.state.version,gt=lt.getParameters(b,X.state,vt,U,$,S.state.lightProbeGridArray),It=lt.getProgramCacheKey(gt),Nt=W.programs;W.environment=b.isMeshStandardMaterial||b.isMeshLambertMaterial||b.isMeshPhongMaterial?U.environment:null,W.fog=U.fog;let Zt=b.isMeshStandardMaterial||b.isMeshLambertMaterial&&!b.envMap||b.isMeshPhongMaterial&&!b.envMap;W.envMap=ot.get(b.envMap||W.environment,Zt),W.envMapRotation=W.environment!==null&&b.envMap===null?U.environmentRotation:b.envMapRotation,Nt===void 0&&(b.addEventListener("dispose",Oi),Nt=new Map,W.programs=Nt);let jt=Nt.get(It);if(jt!==void 0){if(W.currentProgram===jt&&W.lightsStateVersion===Et)return uu(b,gt),jt}else gt.uniforms=lt.getUniforms(b),L!==null&&b.isNodeMaterial&&L.build(b,$,gt),b.onBeforeCompile(gt,P),jt=lt.acquireProgram(gt,It),Nt.set(It,jt),W.uniforms=gt.uniforms;let Pt=W.uniforms;return(!b.isShaderMaterial&&!b.isRawShaderMaterial||b.clipping===!0)&&(Pt.clippingPlanes=Rt.uniform),uu(b,gt),W.needsLights=op(b),W.lightsStateVersion=Et,W.needsLights&&(Pt.ambientLightColor.value=X.state.ambient,Pt.lightProbe.value=X.state.probe,Pt.sunLights.value=X.state.sun,Pt.sunLightShadows.value=X.state.sunShadow,Pt.directionalLights.value=X.state.directional,Pt.directionalLightShadows.value=X.state.directionalShadow,Pt.spotLights.value=X.state.spot,Pt.spotLightShadows.value=X.state.spotShadow,Pt.rectAreaLights.value=X.state.rectArea,Pt.ltc_1.value=X.state.rectAreaLTC1,Pt.ltc_2.value=X.state.rectAreaLTC2,Pt.pointLights.value=X.state.point,Pt.pointLightShadows.value=X.state.pointShadow,Pt.hemisphereLights.value=X.state.hemi,Pt.sunShadowMatrix.value=X.state.sunShadowMatrix,Pt.sunShadowCascade.value=X.state.sunShadowCascade,Pt.directionalShadowMatrix.value=X.state.directionalShadowMatrix,Pt.spotLightMatrix.value=X.state.spotLightMatrix,Pt.spotLightMap.value=X.state.spotLightMap,Pt.pointShadowMatrix.value=X.state.pointShadowMatrix),W.lightProbeGrid=S.state.lightProbeGridArray.length>0,W.currentProgram=jt,W.uniformsList=null,jt}function hu(b){if(b.uniformsList===null){let U=b.currentProgram.getUniforms();b.uniformsList=Zs.seqWithValue(U.seq,b.uniforms)}return b.uniformsList}function uu(b,U){let $=H.get(b);$.outputColorSpace=U.outputColorSpace,$.batching=U.batching,$.batchingColor=U.batchingColor,$.instancing=U.instancing,$.instancingColor=U.instancingColor,$.instancingMorph=U.instancingMorph,$.skinning=U.skinning,$.morphTargets=U.morphTargets,$.morphNormals=U.morphNormals,$.morphColors=U.morphColors,$.morphTargetsCount=U.morphTargetsCount,$.numClippingPlanes=U.numClippingPlanes,$.numIntersection=U.numClipIntersection,$.vertexAlphas=U.vertexAlphas,$.vertexTangents=U.vertexTangents,$.toneMapping=U.toneMapping}function sp(b,U){if(b.length===0)return null;if(b.length===1)return b[0].texture!==null?b[0]:null;y.setFromMatrixPosition(U.matrixWorld);for(let $=0,W=b.length;$<W;$++){let X=b[$];if(X.texture!==null&&X.boundingBox.containsPoint(y))return X}return null}function rp(b,U,$,W,X){U.isScene!==!0&&(U=T),K.resetTextureUnits();let vt=U.fog,Et=W.isMeshStandardMaterial||W.isMeshLambertMaterial||W.isMeshPhongMaterial?U.environment:null,gt=Z===null?P.outputColorSpace:Z.isXRRenderTarget===!0?Z.texture.colorSpace:Qt.workingColorSpace,It=W.isMeshStandardMaterial||W.isMeshLambertMaterial&&!W.envMap||W.isMeshPhongMaterial&&!W.envMap,Nt=ot.get(W.envMap||Et,It),Zt=W.vertexColors===!0&&!!$.attributes.color&&$.attributes.color.itemSize===4,jt=!!$.attributes.tangent&&(!!W.normalMap||W.anisotropy>0),Pt=!!$.morphAttributes.position,de=!!$.morphAttributes.normal,Ue=!!$.morphAttributes.color,Se=Ui;W.toneMapped&&(Z===null||Z.isXRRenderTarget===!0)&&(Se=P.toneMapping);let _e=$.morphAttributes.position||$.morphAttributes.normal||$.morphAttributes.color,Ke=_e!==void 0?_e.length:0,wt=H.get(W),si=S.state.lights;if(Kt===!0&&(se===!0||b!==tt)){let ye=b===tt&&W.id===V;Rt.setState(W,b,ye)}let re=!1;W.version===wt.__version?(wt.needsLights&&wt.lightsStateVersion!==si.state.version||wt.outputColorSpace!==gt||X.isBatchedMesh&&wt.batching===!1||!X.isBatchedMesh&&wt.batching===!0||X.isBatchedMesh&&wt.batchingColor===!0&&X._colorsTexture===null||X.isBatchedMesh&&wt.batchingColor===!1&&X._colorsTexture!==null||X.isInstancedMesh&&wt.instancing===!1||!X.isInstancedMesh&&wt.instancing===!0||X.isSkinnedMesh&&wt.skinning===!1||!X.isSkinnedMesh&&wt.skinning===!0||X.isInstancedMesh&&wt.instancingColor===!0&&X.instanceColor===null||X.isInstancedMesh&&wt.instancingColor===!1&&X.instanceColor!==null||X.isInstancedMesh&&wt.instancingMorph===!0&&X.morphTexture===null||X.isInstancedMesh&&wt.instancingMorph===!1&&X.morphTexture!==null||wt.envMap!==Nt||W.fog===!0&&wt.fog!==vt||wt.numClippingPlanes!==void 0&&(wt.numClippingPlanes!==Rt.numPlanes||wt.numIntersection!==Rt.numIntersection)||wt.vertexAlphas!==Zt||wt.vertexTangents!==jt||wt.morphTargets!==Pt||wt.morphNormals!==de||wt.morphColors!==Ue||wt.toneMapping!==Se||wt.morphTargetsCount!==Ke||!!wt.lightProbeGrid!=S.state.lightProbeGridArray.length>0)&&(re=!0):(re=!0,wt.__version=W.version);let mi=wt.currentProgram;re===!0&&(mi=Ra(W,U,X),L&&W.isNodeMaterial&&L.onUpdateProgram(W,mi,wt));let ki=!1,xn=!1,ls=!1,ge=mi.getUniforms(),Ie=wt.uniforms;if(x.useProgram(mi.program)&&(ki=!0,xn=!0,ls=!0),W.id!==V&&(V=W.id,xn=!0),wt.needsLights){let ye=sp(S.state.lightProbeGridArray,X);wt.lightProbeGrid!==ye&&(wt.lightProbeGrid=ye,xn=!0)}if(ki||tt!==b){x.buffers.depth.getReversed()&&b.reversedDepth!==!0&&(b._reversedDepth=!0,b.updateProjectionMatrix()),ge.setValue(C,"projectionMatrix",b.projectionMatrix),ge.setValue(C,"viewMatrix",b.matrixWorldInverse);let vn=ge.map.cameraPosition;vn!==void 0&&vn.setValue(C,ie.setFromMatrixPosition(b.matrixWorld)),E.logarithmicDepthBuffer&&ge.setValue(C,"logDepthBufFC",2/(Math.log(b.far+1)/Math.LN2)),(W.isMeshPhongMaterial||W.isMeshToonMaterial||W.isMeshLambertMaterial||W.isMeshBasicMaterial||W.isMeshStandardMaterial||W.isShaderMaterial)&&ge.setValue(C,"isOrthographic",b.isOrthographicCamera===!0),tt!==b&&(tt=b,xn=!0,ls=!0)}if(wt.needsLights&&(si.state.sunShadowMap.length>0&&ge.setValue(C,"sunShadowMap",si.state.sunShadowMap,K),si.state.directionalShadowMap.length>0&&ge.setValue(C,"directionalShadowMap",si.state.directionalShadowMap,K),si.state.spotShadowMap.length>0&&ge.setValue(C,"spotShadowMap",si.state.spotShadowMap,K),si.state.pointShadowMap.length>0&&ge.setValue(C,"pointShadowMap",si.state.pointShadowMap,K)),X.isSkinnedMesh){ge.setOptional(C,X,"bindMatrix"),ge.setOptional(C,X,"bindMatrixInverse");let ye=X.skeleton;ye&&(ye.boneTexture===null&&ye.computeBoneTexture(),ge.setValue(C,"boneTexture",ye.boneTexture,K))}X.isBatchedMesh&&(ge.setOptional(C,X,"batchingTexture"),ge.setValue(C,"batchingTexture",X._matricesTexture,K),ge.setOptional(C,X,"batchingIdTexture"),ge.setValue(C,"batchingIdTexture",X._indirectTexture,K),ge.setOptional(C,X,"batchingColorTexture"),X._colorsTexture!==null&&ge.setValue(C,"batchingColorTexture",X._colorsTexture,K));let _n=$.morphAttributes;if((_n.position!==void 0||_n.normal!==void 0||_n.color!==void 0)&&B.update(X,$,mi),(xn||wt.receiveShadow!==X.receiveShadow)&&(wt.receiveShadow=X.receiveShadow,ge.setValue(C,"receiveShadow",X.receiveShadow)),(W.isMeshStandardMaterial||W.isMeshLambertMaterial||W.isMeshPhongMaterial)&&W.envMap===null&&U.environment!==null&&(Ie.envMapIntensity.value=U.environmentIntensity),Ie.dfgLUT!==void 0&&(Ie.dfgLUT.value=Q_()),xn){if(ge.setValue(C,"toneMappingExposure",P.toneMappingExposure),wt.needsLights&&ap(Ie,ls),vt&&W.fog===!0&&Dt.refreshFogUniforms(Ie,vt),Dt.refreshMaterialUniforms(Ie,W,it,Q,S.state.transmissionRenderTarget[b.id]),wt.needsLights&&wt.lightProbeGrid){let ye=wt.lightProbeGrid;Ie.probesSH.value=ye.texture,Ie.probesMin.value.copy(ye.boundingBox.min),Ie.probesMax.value.copy(ye.boundingBox.max),Ie.probesResolution.value.copy(ye.resolution)}Zs.upload(C,hu(wt),Ie,K)}if(W.isShaderMaterial&&W.uniformsNeedUpdate===!0&&(Zs.upload(C,hu(wt),Ie,K),W.uniformsNeedUpdate=!1),W.isSpriteMaterial&&ge.setValue(C,"center",X.center),ge.setValue(C,"modelViewMatrix",X.modelViewMatrix),ge.setValue(C,"normalMatrix",X.normalMatrix),ge.setValue(C,"modelMatrix",X.matrixWorld),W.uniformsGroups!==void 0){let ye=W.uniformsGroups;for(let vn=0,cs=ye.length;vn<cs;vn++){let fu=ye[vn];at.update(fu,mi),at.bind(fu,mi)}}return mi}function ap(b,U){b.ambientLightColor.needsUpdate=U,b.lightProbe.needsUpdate=U,b.sunLights.needsUpdate=U,b.sunLightShadows.needsUpdate=U,b.directionalLights.needsUpdate=U,b.directionalLightShadows.needsUpdate=U,b.pointLights.needsUpdate=U,b.pointLightShadows.needsUpdate=U,b.spotLights.needsUpdate=U,b.spotLightShadows.needsUpdate=U,b.rectAreaLights.needsUpdate=U,b.hemisphereLights.needsUpdate=U}function op(b){return b.isMeshLambertMaterial||b.isMeshToonMaterial||b.isMeshPhongMaterial||b.isMeshStandardMaterial||b.isShadowMaterial||b.isShaderMaterial&&b.lights===!0}this.getActiveCubeFace=function(){return Y},this.getActiveMipmapLevel=function(){return q},this.getRenderTarget=function(){return Z},this.setRenderTargetTextures=function(b,U,$){let W=H.get(b);W.__autoAllocateDepthBuffer=b.resolveDepthBuffer===!1,W.__autoAllocateDepthBuffer===!1&&(W.__useRenderToTexture=!1),H.get(b.texture).__webglTexture=U,H.get(b.depthTexture).__webglTexture=W.__autoAllocateDepthBuffer?void 0:$,W.__hasExternalTextures=!0},this.setRenderTargetFramebuffer=function(b,U){let $=H.get(b);$.__webglFramebuffer=U,$.__useDefaultFramebuffer=U===void 0},this.setRenderTarget=function(b,U=0,$=0){Z=b,Y=U,q=$;let W=null,X=!1,vt=!1;if(b){let gt=H.get(b);if(gt.__useDefaultFramebuffer!==void 0){x.bindFramebuffer(C.FRAMEBUFFER,gt.__webglFramebuffer),rt.copy(b.viewport),St.copy(b.scissor),_t=b.scissorTest,x.viewport(rt),x.scissor(St),x.setScissorTest(_t),V=-1;return}else if(gt.__webglFramebuffer===void 0)K.setupRenderTarget(b);else if(gt.__hasExternalTextures)K.rebindTextures(b,H.get(b.texture).__webglTexture,H.get(b.depthTexture).__webglTexture);else if(b.depthBuffer){let Zt=b.depthTexture;if(gt.__boundDepthTexture!==Zt){if(Zt!==null&&H.has(Zt)&&(b.width!==Zt.image.width||b.height!==Zt.image.height))throw new Error("THREE.WebGLRenderer: Attached DepthTexture is initialized to the incorrect size.");K.setupDepthRenderbuffer(b)}}let It=b.texture;(It.isData3DTexture||It.isDataArrayTexture||It.isCompressedArrayTexture)&&(vt=!0);let Nt=H.get(b).__webglFramebuffer;b.isWebGLCubeRenderTarget?(Array.isArray(Nt[U])?W=Nt[U][$]:W=Nt[U],X=!0):b.samples>0&&K.useMultisampledRTT(b)===!1?W=H.get(b).__webglMultisampledFramebuffer:Array.isArray(Nt)?W=Nt[$]:W=Nt,rt.copy(b.viewport),St.copy(b.scissor),_t=b.scissorTest}else rt.copy(yt).multiplyScalar(it).floor(),St.copy(qt).multiplyScalar(it).floor(),_t=be;if($!==0&&(W=z),x.bindFramebuffer(C.FRAMEBUFFER,W)&&x.drawBuffers(b,W),x.viewport(rt),x.scissor(St),x.setScissorTest(_t),X){let gt=H.get(b.texture);C.framebufferTexture2D(C.FRAMEBUFFER,C.COLOR_ATTACHMENT0,C.TEXTURE_CUBE_MAP_POSITIVE_X+U,gt.__webglTexture,$)}else if(vt){let gt=U;for(let It=0;It<b.textures.length;It++){let Nt=H.get(b.textures[It]);C.framebufferTextureLayer(C.FRAMEBUFFER,C.COLOR_ATTACHMENT0+It,Nt.__webglTexture,$,gt)}}else if(b!==null&&$!==0){let gt=H.get(b.texture);C.framebufferTexture2D(C.FRAMEBUFFER,C.COLOR_ATTACHMENT0,C.TEXTURE_2D,gt.__webglTexture,$)}V=-1};function du(b){let U=H.get(b);return(U.__readFormat!==b.format||U.__readType!==b.type)&&(U.__readFormat=b.format,U.__readType=b.type,U.__formatReadable=E.textureFormatReadable(b.format),U.__typeReadable=E.textureTypeReadable(b.type)),U}this.readRenderTargetPixels=function(b,U,$,W,X,vt,Et,gt=0){if(!(b&&b.isWebGLRenderTarget)){Ht("WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");return}let It=H.get(b).__webglFramebuffer;if(b.isWebGLCubeRenderTarget&&Et!==void 0&&(It=It[Et]),It){x.bindFramebuffer(C.FRAMEBUFFER,It);try{let Nt=b.textures[gt],Zt=Nt.format,jt=Nt.type;b.textures.length>1&&C.readBuffer(C.COLOR_ATTACHMENT0+gt);let Pt=du(Nt);if(Pt.__formatReadable===!1){Ht("WebGLRenderer.readRenderTargetPixels: renderTarget is not in RGBA or implementation defined format.");return}if(Pt.__typeReadable===!1){Ht("WebGLRenderer.readRenderTargetPixels: renderTarget is not in UnsignedByteType or implementation defined type.");return}U>=0&&U<=b.width-W&&$>=0&&$<=b.height-X&&C.readPixels(U,$,W,X,pt.convert(Zt),pt.convert(jt),vt)}finally{let Nt=Z!==null?H.get(Z).__webglFramebuffer:null;x.bindFramebuffer(C.FRAMEBUFFER,Nt)}}},this.readRenderTargetPixelsAsync=async function(b,U,$,W,X,vt,Et,gt=0){if(!(b&&b.isWebGLRenderTarget))throw new Error("THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");let It=H.get(b).__webglFramebuffer;if(b.isWebGLCubeRenderTarget&&Et!==void 0&&(It=It[Et]),It)if(U>=0&&U<=b.width-W&&$>=0&&$<=b.height-X){x.bindFramebuffer(C.FRAMEBUFFER,It);let Nt=b.textures[gt],Zt=Nt.format,jt=Nt.type;b.textures.length>1&&C.readBuffer(C.COLOR_ATTACHMENT0+gt);let Pt=du(Nt);if(Pt.__formatReadable===!1)throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in RGBA or implementation defined format.");if(Pt.__typeReadable===!1)throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in UnsignedByteType or implementation defined type.");let de=C.createBuffer();C.bindBuffer(C.PIXEL_PACK_BUFFER,de),C.bufferData(C.PIXEL_PACK_BUFFER,vt.byteLength,C.STREAM_READ),C.readPixels(U,$,W,X,pt.convert(Zt),pt.convert(jt),0),C.bindBuffer(C.PIXEL_PACK_BUFFER,null);let Ue=Z!==null?H.get(Z).__webglFramebuffer:null;x.bindFramebuffer(C.FRAMEBUFFER,Ue);let Se=C.fenceSync(C.SYNC_GPU_COMMANDS_COMPLETE,0);return C.flush(),await Cd(C,Se,4),C.bindBuffer(C.PIXEL_PACK_BUFFER,de),C.getBufferSubData(C.PIXEL_PACK_BUFFER,0,vt),C.bindBuffer(C.PIXEL_PACK_BUFFER,null),C.deleteBuffer(de),C.deleteSync(Se),vt}else throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: requested read bounds are out of range.")},this.copyFramebufferToTexture=function(b,U=null,$=0){let W=Math.pow(2,-$),X=Math.floor(b.image.width*W),vt=Math.floor(b.image.height*W),Et=U!==null?U.x:0,gt=U!==null?U.y:0;K.setTexture2D(b,0),C.copyTexSubImage2D(C.TEXTURE_2D,$,0,0,Et,gt,X,vt),x.unbindTexture()},this.copyTextureToTexture=function(b,U,$=null,W=null,X=0,vt=0){let Et,gt,It,Nt,Zt,jt,Pt,de,Ue,Se=b.isCompressedTexture?b.mipmaps[vt]:b.image;if($!==null)Et=$.max.x-$.min.x,gt=$.max.y-$.min.y,It=$.isBox3?$.max.z-$.min.z:1,Nt=$.min.x,Zt=$.min.y,jt=$.isBox3?$.min.z:0;else{let Ie=Math.pow(2,-X);Et=Math.floor(Se.width*Ie),gt=Math.floor(Se.height*Ie),b.isDataArrayTexture?It=Se.depth:b.isData3DTexture?It=Math.floor(Se.depth*Ie):It=1,Nt=0,Zt=0,jt=0}W!==null?(Pt=W.x,de=W.y,Ue=W.z):(Pt=0,de=0,Ue=0);let _e=pt.convert(U.format),Ke=pt.convert(U.type),wt;U.isData3DTexture?(K.setTexture3D(U,0),wt=C.TEXTURE_3D):U.isDataArrayTexture||U.isCompressedArrayTexture?(K.setTexture2DArray(U,0),wt=C.TEXTURE_2D_ARRAY):(K.setTexture2D(U,0),wt=C.TEXTURE_2D),x.activeTexture(C.TEXTURE0),x.pixelStorei(C.UNPACK_FLIP_Y_WEBGL,U.flipY),x.pixelStorei(C.UNPACK_PREMULTIPLY_ALPHA_WEBGL,U.premultiplyAlpha),x.pixelStorei(C.UNPACK_ALIGNMENT,U.unpackAlignment);let si=x.getParameter(C.UNPACK_ROW_LENGTH),re=x.getParameter(C.UNPACK_IMAGE_HEIGHT),mi=x.getParameter(C.UNPACK_SKIP_PIXELS),ki=x.getParameter(C.UNPACK_SKIP_ROWS),xn=x.getParameter(C.UNPACK_SKIP_IMAGES);x.pixelStorei(C.UNPACK_ROW_LENGTH,Se.width),x.pixelStorei(C.UNPACK_IMAGE_HEIGHT,Se.height),x.pixelStorei(C.UNPACK_SKIP_PIXELS,Nt),x.pixelStorei(C.UNPACK_SKIP_ROWS,Zt),x.pixelStorei(C.UNPACK_SKIP_IMAGES,jt);let ls=b.isDataArrayTexture||b.isData3DTexture,ge=U.isDataArrayTexture||U.isData3DTexture;if(b.isDepthTexture){let Ie=H.get(b),_n=H.get(U),ye=H.get(Ie.__renderTarget),vn=H.get(_n.__renderTarget);x.bindFramebuffer(C.READ_FRAMEBUFFER,ye.__webglFramebuffer),x.bindFramebuffer(C.DRAW_FRAMEBUFFER,vn.__webglFramebuffer);for(let cs=0;cs<It;cs++)ls&&(C.framebufferTextureLayer(C.READ_FRAMEBUFFER,C.COLOR_ATTACHMENT0,H.get(b).__webglTexture,X,jt+cs),C.framebufferTextureLayer(C.DRAW_FRAMEBUFFER,C.COLOR_ATTACHMENT0,H.get(U).__webglTexture,vt,Ue+cs)),C.blitFramebuffer(Nt,Zt,Et,gt,Pt,de,Et,gt,C.DEPTH_BUFFER_BIT,C.NEAREST);x.bindFramebuffer(C.READ_FRAMEBUFFER,null),x.bindFramebuffer(C.DRAW_FRAMEBUFFER,null)}else if(X!==0||b.isRenderTargetTexture||H.has(b)){let Ie=H.get(b),_n=H.get(U);x.bindFramebuffer(C.READ_FRAMEBUFFER,D),x.bindFramebuffer(C.DRAW_FRAMEBUFFER,k);for(let ye=0;ye<It;ye++)ls?C.framebufferTextureLayer(C.READ_FRAMEBUFFER,C.COLOR_ATTACHMENT0,Ie.__webglTexture,X,jt+ye):C.framebufferTexture2D(C.READ_FRAMEBUFFER,C.COLOR_ATTACHMENT0,C.TEXTURE_2D,Ie.__webglTexture,X),ge?C.framebufferTextureLayer(C.DRAW_FRAMEBUFFER,C.COLOR_ATTACHMENT0,_n.__webglTexture,vt,Ue+ye):C.framebufferTexture2D(C.DRAW_FRAMEBUFFER,C.COLOR_ATTACHMENT0,C.TEXTURE_2D,_n.__webglTexture,vt),X!==0?C.blitFramebuffer(Nt,Zt,Et,gt,Pt,de,Et,gt,C.COLOR_BUFFER_BIT,C.NEAREST):ge?C.copyTexSubImage3D(wt,vt,Pt,de,Ue+ye,Nt,Zt,Et,gt):C.copyTexSubImage2D(wt,vt,Pt,de,Nt,Zt,Et,gt);x.bindFramebuffer(C.READ_FRAMEBUFFER,null),x.bindFramebuffer(C.DRAW_FRAMEBUFFER,null)}else ge?b.isDataTexture||b.isData3DTexture?C.texSubImage3D(wt,vt,Pt,de,Ue,Et,gt,It,_e,Ke,Se.data):U.isCompressedArrayTexture?C.compressedTexSubImage3D(wt,vt,Pt,de,Ue,Et,gt,It,_e,Se.data):C.texSubImage3D(wt,vt,Pt,de,Ue,Et,gt,It,_e,Ke,Se):b.isDataTexture?C.texSubImage2D(C.TEXTURE_2D,vt,Pt,de,Et,gt,_e,Ke,Se.data):b.isCompressedTexture?C.compressedTexSubImage2D(C.TEXTURE_2D,vt,Pt,de,Se.width,Se.height,_e,Se.data):C.texSubImage2D(C.TEXTURE_2D,vt,Pt,de,Et,gt,_e,Ke,Se);x.pixelStorei(C.UNPACK_ROW_LENGTH,si),x.pixelStorei(C.UNPACK_IMAGE_HEIGHT,re),x.pixelStorei(C.UNPACK_SKIP_PIXELS,mi),x.pixelStorei(C.UNPACK_SKIP_ROWS,ki),x.pixelStorei(C.UNPACK_SKIP_IMAGES,xn),vt===0&&U.generateMipmaps&&C.generateMipmap(wt),x.unbindTexture()},this.initRenderTarget=function(b){H.get(b).__webglFramebuffer===void 0&&K.setupRenderTarget(b)},this.initTexture=function(b){b.isCubeTexture?K.setTextureCube(b,0):b.isData3DTexture?K.setTexture3D(b,0):b.isDataArrayTexture||b.isCompressedArrayTexture?K.setTexture2DArray(b,0):K.setTexture2D(b,0),x.unbindTexture()},this.resetState=function(){Y=0,q=0,Z=null,x.reset(),bt.reset()},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}get coordinateSystem(){return Di}get outputColorSpace(){return this._outputColorSpace}set outputColorSpace(t){this._outputColorSpace=t;let e=this.getContext();e.drawingBufferColorSpace=Qt._getDrawingBufferColorSpace(t),e.unpackColorSpace=Qt._getUnpackColorSpace()}};var Qs={name:"CopyShader",uniforms:{tDiffuse:{value:null},opacity:{value:1}},vertexShader:`

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


		}`};var fi=class{constructor(){this.isPass=!0,this.enabled=!0,this.needsSwap=!0,this.clear=!1,this.renderToScreen=!1}setSize(){}render(){console.error("THREE.Pass: .render() must be implemented in derived pass.")}dispose(){}},j_=new Ln(-1,1,1,-1,0,1),Bh=class extends ce{constructor(){super(),this.setAttribute("position",new Gt([-1,3,0,-1,-1,0,3,-1,0],3)),this.setAttribute("uv",new Gt([0,2,0,0,2,0],2))}},tv=new Bh,Bn=class{constructor(t){this._mesh=new Tt(tv,t)}dispose(){this._mesh.geometry.dispose()}render(t){t.render(this._mesh,j_)}get material(){return this._mesh.material}set material(t){this._mesh.material=t}};var js=class extends fi{constructor(t,e="tDiffuse"){super(),this.textureID=e,this.uniforms=null,this.material=null,t instanceof Te?(this.uniforms=t.uniforms,this.material=t):t&&(this.uniforms=dn.clone(t.uniforms),this.material=new Te({name:t.name!==void 0?t.name:"unspecified",defines:Object.assign({},t.defines),uniforms:this.uniforms,vertexShader:t.vertexShader,fragmentShader:t.fragmentShader})),this._fsQuad=new Bn(this.material)}render(t,e,i){this.uniforms[this.textureID]&&(this.uniforms[this.textureID].value=i.texture),this._fsQuad.material=this.material,this.renderToScreen?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(e),this.clear&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),this._fsQuad.render(t))}dispose(){this.material.dispose(),this._fsQuad.dispose()}};var ma=class extends fi{constructor(t,e){super(),this.scene=t,this.camera=e,this.clear=!0,this.needsSwap=!1,this.inverse=!1}render(t,e,i){let s=t.getContext(),r=t.state;r.buffers.color.setMask(!1),r.buffers.depth.setMask(!1),r.buffers.color.setLocked(!0),r.buffers.depth.setLocked(!0);let a,o;this.inverse?(a=0,o=1):(a=1,o=0),r.buffers.stencil.setTest(!0),r.buffers.stencil.setOp(s.REPLACE,s.REPLACE,s.REPLACE),r.buffers.stencil.setFunc(s.ALWAYS,a,4294967295),r.buffers.stencil.setClear(o),r.buffers.stencil.setLocked(!0),t.setRenderTarget(i),this.clear&&t.clear(),t.render(this.scene,this.camera),t.setRenderTarget(e),this.clear&&t.clear(),t.render(this.scene,this.camera),r.buffers.color.setLocked(!1),r.buffers.depth.setLocked(!1),r.buffers.color.setMask(!0),r.buffers.depth.setMask(!0),r.buffers.stencil.setLocked(!1),r.buffers.stencil.setFunc(s.EQUAL,1,4294967295),r.buffers.stencil.setOp(s.KEEP,s.KEEP,s.KEEP),r.buffers.stencil.setLocked(!0)}},Ll=class extends fi{constructor(){super(),this.needsSwap=!1}render(t){t.state.buffers.stencil.setLocked(!1),t.state.buffers.stencil.setTest(!1)}};var Dl=class{constructor(t,e){if(this.renderer=t,this._pixelRatio=t.getPixelRatio(),e===void 0){let i=t.getSize(new xt);this._width=i.width,this._height=i.height,e=new Re(this._width*this._pixelRatio,this._height*this._pixelRatio,{type:He}),e.texture.name="EffectComposer.rt1"}else this._width=e.width,this._height=e.height;this.renderTarget1=e,this.renderTarget2=e.clone(),this.renderTarget2.texture.name="EffectComposer.rt2",this.writeBuffer=this.renderTarget1,this.readBuffer=this.renderTarget2,this.renderToScreen=!0,this.passes=[],this.copyPass=new js(Qs),this.copyPass.material.blending=Mi,this.timer=new $r}swapBuffers(){let t=this.readBuffer;this.readBuffer=this.writeBuffer,this.writeBuffer=t}addPass(t){this.passes.push(t),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}insertPass(t,e){this.passes.splice(e,0,t),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}removePass(t){let e=this.passes.indexOf(t);e!==-1&&this.passes.splice(e,1)}isLastEnabledPass(t){for(let e=t+1;e<this.passes.length;e++)if(this.passes[e].enabled)return!1;return!0}render(t){this.timer.update(),t===void 0&&(t=this.timer.getDelta());let e=this.renderer.getRenderTarget(),i=!1;for(let s=0,r=this.passes.length;s<r;s++){let a=this.passes[s];if(a.enabled!==!1){if(a.renderToScreen=this.renderToScreen&&this.isLastEnabledPass(s),a.render(this.renderer,this.writeBuffer,this.readBuffer,t,i),a.needsSwap){if(i){let o=this.renderer.getContext(),l=this.renderer.state.buffers.stencil;l.setFunc(o.NOTEQUAL,1,4294967295),this.copyPass.render(this.renderer,this.writeBuffer,this.readBuffer,t),l.setFunc(o.EQUAL,1,4294967295)}this.swapBuffers()}ma!==void 0&&(a instanceof ma?i=!0:a instanceof Ll&&(i=!1))}}this.renderer.setRenderTarget(e)}reset(t){if(t===void 0){let e=this.renderer.getSize(new xt);this._pixelRatio=this.renderer.getPixelRatio(),this._width=e.width,this._height=e.height,t=this.renderTarget1.clone(),t.setSize(this._width*this._pixelRatio,this._height*this._pixelRatio)}this.renderTarget1.dispose(),this.renderTarget2.dispose(),this.renderTarget1=t,this.renderTarget2=t.clone(),this.writeBuffer=this.renderTarget1,this.readBuffer=this.renderTarget2}setSize(t,e){this._width=t,this._height=e;let i=this._width*this._pixelRatio,s=this._height*this._pixelRatio;this.renderTarget1.setSize(i,s),this.renderTarget2.setSize(i,s);for(let r=0;r<this.passes.length;r++)this.passes[r].setSize(i,s)}setPixelRatio(t){this._pixelRatio=t,this.setSize(this._width,this._height)}dispose(){this.renderTarget1.dispose(),this.renderTarget2.dispose(),this.copyPass.dispose()}};var Nl=class extends fi{constructor(t,e,i=null,s=null,r=null){super(),this.scene=t,this.camera=e,this.overrideMaterial=i,this.clearColor=s,this.clearAlpha=r,this.clear=!0,this.clearDepth=!1,this.needsSwap=!1,this.isRenderPass=!0,this._oldClearColor=new Ut}render(t,e,i){let s=t.autoClear;t.autoClear=!1;let r,a;this.overrideMaterial!==null&&(a=this.scene.overrideMaterial,this.scene.overrideMaterial=this.overrideMaterial),this.clearColor!==null&&(t.getClearColor(this._oldClearColor),t.setClearColor(this.clearColor,t.getClearAlpha())),this.clearAlpha!==null&&(r=t.getClearAlpha(),t.setClearAlpha(this.clearAlpha)),this.clearDepth==!0&&t.clearDepth(),t.setRenderTarget(this.renderToScreen?null:i),this.clear===!0&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),t.render(this.scene,this.camera),this.clearColor!==null&&t.setClearColor(this._oldClearColor),this.clearAlpha!==null&&t.setClearAlpha(r),this.overrideMaterial!==null&&(this.scene.overrideMaterial=a),t.autoClear=s}};var hf={name:"LuminosityHighPassShader",uniforms:{tDiffuse:{value:null},luminosityThreshold:{value:1},smoothWidth:{value:1},defaultColor:{value:new Ut(0)},defaultOpacity:{value:0}},vertexShader:`

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

		}`};var tr=class n extends fi{constructor(t,e=1,i,s){super(),this.strength=e,this.radius=i,this.threshold=s,this.resolution=t!==void 0?new xt(t.x,t.y):new xt(256,256),this.clearColor=new Ut(0,0,0),this.needsSwap=!1,this.renderTargetsHorizontal=[],this.renderTargetsVertical=[],this.nMips=5;let r=Math.round(this.resolution.x/2),a=Math.round(this.resolution.y/2);this.renderTargetBright=new Re(r,a,{type:He,depthBuffer:!1}),this.renderTargetBright.texture.name="UnrealBloomPass.bright",this.renderTargetBright.texture.generateMipmaps=!1;for(let h=0;h<this.nMips;h++){let d=new Re(r,a,{type:He,depthBuffer:!1});d.texture.name="UnrealBloomPass.h"+h,d.texture.generateMipmaps=!1,this.renderTargetsHorizontal.push(d);let u=new Re(r,a,{type:He,depthBuffer:!1});u.texture.name="UnrealBloomPass.v"+h,u.texture.generateMipmaps=!1,this.renderTargetsVertical.push(u),r=Math.round(r/2),a=Math.round(a/2)}let o=hf;this.highPassUniforms=dn.clone(o.uniforms),this.highPassUniforms.luminosityThreshold.value=s,this.highPassUniforms.smoothWidth.value=.01,this.materialHighPassFilter=new Te({uniforms:this.highPassUniforms,vertexShader:o.vertexShader,fragmentShader:o.fragmentShader}),this.separableBlurMaterials=[];let l=[6,10,14,18,22];r=Math.round(this.resolution.x/2),a=Math.round(this.resolution.y/2);for(let h=0;h<this.nMips;h++)this.separableBlurMaterials.push(this._getSeparableBlurMaterial(l[h])),this.separableBlurMaterials[h].uniforms.invSize.value=new xt(1/r,1/a),r=Math.round(r/2),a=Math.round(a/2);this.compositeMaterial=this._getCompositeMaterial(this.nMips),this.compositeMaterial.uniforms.blurTexture1.value=this.renderTargetsVertical[0].texture,this.compositeMaterial.uniforms.blurTexture2.value=this.renderTargetsVertical[1].texture,this.compositeMaterial.uniforms.blurTexture3.value=this.renderTargetsVertical[2].texture,this.compositeMaterial.uniforms.blurTexture4.value=this.renderTargetsVertical[3].texture,this.compositeMaterial.uniforms.blurTexture5.value=this.renderTargetsVertical[4].texture,this.compositeMaterial.uniforms.bloomStrength.value=e,this.compositeMaterial.uniforms.bloomRadius.value=.1;let c=[1,.8,.6,.4,.2];this.compositeMaterial.uniforms.bloomFactors.value=c,this.bloomTintColors=[new N(1,1,1),new N(1,1,1),new N(1,1,1),new N(1,1,1),new N(1,1,1)],this.compositeMaterial.uniforms.bloomTintColors.value=this.bloomTintColors,this.copyUniforms=dn.clone(Qs.uniforms),this.blendMaterial=new Te({uniforms:this.copyUniforms,vertexShader:Qs.vertexShader,fragmentShader:Qs.fragmentShader,premultipliedAlpha:!0,blending:Be,depthTest:!1,depthWrite:!1,transparent:!0}),this._oldClearColor=new Ut,this._oldClearAlpha=1,this._basic=new Le,this._fsQuad=new Bn(null)}dispose(){for(let t=0;t<this.renderTargetsHorizontal.length;t++)this.renderTargetsHorizontal[t].dispose();for(let t=0;t<this.renderTargetsVertical.length;t++)this.renderTargetsVertical[t].dispose();this.renderTargetBright.dispose();for(let t=0;t<this.separableBlurMaterials.length;t++)this.separableBlurMaterials[t].dispose();this.compositeMaterial.dispose(),this.blendMaterial.dispose(),this._basic.dispose(),this._fsQuad.dispose()}setSize(t,e){let i=Math.round(t/2),s=Math.round(e/2);this.renderTargetBright.setSize(i,s);for(let r=0;r<this.nMips;r++)this.renderTargetsHorizontal[r].setSize(i,s),this.renderTargetsVertical[r].setSize(i,s),this.separableBlurMaterials[r].uniforms.invSize.value=new xt(1/i,1/s),i=Math.round(i/2),s=Math.round(s/2)}render(t,e,i,s,r){t.getClearColor(this._oldClearColor),this._oldClearAlpha=t.getClearAlpha();let a=t.autoClear;t.autoClear=!1,t.setClearColor(this.clearColor,0),r&&t.state.buffers.stencil.setTest(!1),this.renderToScreen&&(this._fsQuad.material=this._basic,this._basic.map=i.texture,t.setRenderTarget(null),t.clear(),this._fsQuad.render(t)),this.highPassUniforms.tDiffuse.value=i.texture,this.highPassUniforms.luminosityThreshold.value=this.threshold,this._fsQuad.material=this.materialHighPassFilter,t.setRenderTarget(this.renderTargetBright),t.clear(),this._fsQuad.render(t);let o=this.renderTargetBright;for(let l=0;l<this.nMips;l++)this._fsQuad.material=this.separableBlurMaterials[l],this.separableBlurMaterials[l].uniforms.colorTexture.value=o.texture,this.separableBlurMaterials[l].uniforms.direction.value=n.BlurDirectionX,t.setRenderTarget(this.renderTargetsHorizontal[l]),t.clear(),this._fsQuad.render(t),this.separableBlurMaterials[l].uniforms.colorTexture.value=this.renderTargetsHorizontal[l].texture,this.separableBlurMaterials[l].uniforms.direction.value=n.BlurDirectionY,t.setRenderTarget(this.renderTargetsVertical[l]),t.clear(),this._fsQuad.render(t),o=this.renderTargetsVertical[l];this._fsQuad.material=this.compositeMaterial,this.compositeMaterial.uniforms.bloomStrength.value=this.strength,this.compositeMaterial.uniforms.bloomRadius.value=this.radius,this.compositeMaterial.uniforms.bloomTintColors.value=this.bloomTintColors,t.setRenderTarget(this.renderTargetsHorizontal[0]),t.clear(),this._fsQuad.render(t),this._fsQuad.material=this.blendMaterial,this.copyUniforms.tDiffuse.value=this.renderTargetsHorizontal[0].texture,r&&t.state.buffers.stencil.setTest(!0),this.renderToScreen?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(i),this._fsQuad.render(t)),t.setClearColor(this._oldClearColor,this._oldClearAlpha),t.autoClear=a}_getSeparableBlurMaterial(t){let e=[],i=t/3;for(let a=0;a<t;a++)e.push(.39894*Math.exp(-.5*a*a/(i*i))/i);let s=[],r=[];for(let a=1;a<t;a+=2){let o=e[a],l=a+1<t?e[a+1]:0,c=o+l;s.push((a*o+(a+1)*l)/c),r.push(c)}return new Te({defines:{KERNEL_PAIRS:s.length},uniforms:{colorTexture:{value:null},invSize:{value:new xt(.5,.5)},direction:{value:new xt(.5,.5)},centerWeight:{value:e[0]},gaussianOffsets:{value:s},gaussianWeights:{value:r}},vertexShader:`

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

				}`})}_getCompositeMaterial(t){return new Te({defines:{NUM_MIPS:t},uniforms:{blurTexture1:{value:null},blurTexture2:{value:null},blurTexture3:{value:null},blurTexture4:{value:null},blurTexture5:{value:null},bloomStrength:{value:1},bloomFactors:{value:null},bloomTintColors:{value:null},bloomRadius:{value:0}},vertexShader:`

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

				}`})}};tr.BlurDirectionX=new xt(1,0);tr.BlurDirectionY=new xt(0,1);var ga={name:"OutputShader",uniforms:{tDiffuse:{value:null},toneMappingExposure:{value:1}},vertexShader:`
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

		}`};var Ul=class extends fi{constructor(){super(),this.isOutputPass=!0,this.uniforms=dn.clone(ga.uniforms),this.material=new Vs({name:ga.name,uniforms:this.uniforms,vertexShader:ga.vertexShader,fragmentShader:ga.fragmentShader}),this._fsQuad=new Bn(this.material),this._outputColorSpace=null,this._toneMapping=null}render(t,e,i){this.uniforms.tDiffuse.value=i.texture,this.uniforms.toneMappingExposure.value=t.toneMappingExposure,(this._outputColorSpace!==t.outputColorSpace||this._toneMapping!==t.toneMapping)&&(this._outputColorSpace=t.outputColorSpace,this._toneMapping=t.toneMapping,this.material.defines={},Qt.getTransfer(this._outputColorSpace)===ae&&(this.material.defines.SRGB_TRANSFER=""),this._toneMapping===Jr?this.material.defines.LINEAR_TONE_MAPPING="":this._toneMapping===Kr?this.material.defines.REINHARD_TONE_MAPPING="":this._toneMapping===Qr?this.material.defines.CINEON_TONE_MAPPING="":this._toneMapping===ts?this.material.defines.ACES_FILMIC_TONE_MAPPING="":this._toneMapping===ta?this.material.defines.AGX_TONE_MAPPING="":this._toneMapping===ea?this.material.defines.NEUTRAL_TONE_MAPPING="":this._toneMapping===jr&&(this.material.defines.CUSTOM_TONE_MAPPING=""),this.material.needsUpdate=!0),this.renderToScreen===!0?(t.setRenderTarget(null),this._fsQuad.render(t)):(t.setRenderTarget(e),this.clear&&t.clear(t.autoClearColor,t.autoClearDepth,t.autoClearStencil),this._fsQuad.render(t))}dispose(){this.material.dispose(),this._fsQuad.dispose()}};var Fl=class extends En{constructor(){super(),this.name="RoomEnvironment",this.position.y=-3.5;let t=new $e;t.deleteAttribute("uv");let e=new Ce({side:Ze}),i=new Ce,s=new Pn(16777215,900,28,2);s.position.set(.418,16.199,.3),this.add(s);let r=new Tt(t,e);r.position.set(-.757,13.219,.717),r.scale.set(31.713,28.305,28.591),this.add(r);let a=new Ur(t,i,6),o=new Pe;o.position.set(-10.906,2.009,1.846),o.rotation.set(0,-.195,0),o.scale.set(2.328,7.905,4.651),o.updateMatrix(),a.setMatrixAt(0,o.matrix),o.position.set(-5.607,-.754,-.758),o.rotation.set(0,.994,0),o.scale.set(1.97,1.534,3.955),o.updateMatrix(),a.setMatrixAt(1,o.matrix),o.position.set(6.167,.857,7.803),o.rotation.set(0,.561,0),o.scale.set(3.927,6.285,3.687),o.updateMatrix(),a.setMatrixAt(2,o.matrix),o.position.set(-2.017,.018,6.124),o.rotation.set(0,.333,0),o.scale.set(2.002,4.566,2.064),o.updateMatrix(),a.setMatrixAt(3,o.matrix),o.position.set(2.291,-.756,-2.621),o.rotation.set(0,-.286,0),o.scale.set(1.546,1.552,1.496),o.updateMatrix(),a.setMatrixAt(4,o.matrix),o.position.set(-2.193,-.369,-5.547),o.rotation.set(0,.516,0),o.scale.set(3.875,3.487,2.986),o.updateMatrix(),a.setMatrixAt(5,o.matrix),this.add(a);let l=new Tt(t,er(50));l.position.set(-16.116,14.37,8.208),l.scale.set(.1,2.428,2.739),this.add(l);let c=new Tt(t,er(50));c.position.set(-16.109,18.021,-8.207),c.scale.set(.1,2.425,2.751),this.add(c);let h=new Tt(t,er(17));h.position.set(14.904,12.198,-1.832),h.scale.set(.15,4.265,6.331),this.add(h);let d=new Tt(t,er(43));d.position.set(-.462,8.89,14.52),d.scale.set(4.38,5.441,.088),this.add(d);let u=new Tt(t,er(20));u.position.set(3.235,11.486,-12.541),u.scale.set(2.5,2,.1),this.add(u);let f=new Tt(t,er(100));f.position.set(0,20,0),f.scale.set(1,.1,1),this.add(f)}dispose(){let t=new Set;this.traverse(e=>{e.isMesh&&(t.add(e.geometry),t.add(e.material))});for(let e of t)e.dispose()}};function er(n){return new Vr({color:0,emissive:16777215,emissiveIntensity:n})}function ev(n){return function(){n|=0,n=n+1831565813|0;let t=Math.imul(n^n>>>15,1|n);return t=t+Math.imul(t^t>>>7,61|t)^t,((t^t>>>14)>>>0)/4294967296}}var Ki=class{constructor(t){this.f=ev(t>>>0)}next(){return this.f()}range(t,e){return t+(e-t)*this.f()}int(t,e){return Math.floor(t+(e-t+1)*this.f())}pick(t){return t[Math.floor(this.f()*t.length)]}chance(t){return this.f()<t}weighted(t){let e=0;for(let[,s]of t)e+=s;let i=this.f()*e;for(let[s,r]of t)if(i-=r,i<=0)return s;return t[t.length-1][0]}};function pe(n,t,e=0){let i=n*374761393+t*668265263+e*982451653|0;return i=Math.imul(i^i>>>13,1274126177),i=i^i>>>16,(i>>>0)/4294967296}var ir=(n,t)=>(n%t+t)%t;function On(n,t,e,i,s){let r=Math.floor(n),a=Math.floor(t),o=n-r,l=t-a,c=o*o*(3-2*o),h=l*l*(3-2*l),d=ir(r,i),u=ir(r+1,i),f=ir(a,s),g=ir(a+1,s),_=pe(d,f,e),m=pe(u,f,e),p=pe(d,g,e),M=pe(u,g,e);return _+(m-_)*c+(p-_)*h+(_-m-p+M)*c*h}function De(n,t,e,i=4,s=4){let r=0,a=.5,o=1,l=0;for(let c=0;c<s;c++){let h=i*o;r+=a*On(n*h,t*h,e+c*31,h,h),l+=a,a*=.5,o*=2}return r/l}function li(n,t,e,i,s=.9){let r=n*i,a=t*i,o=Math.floor(r),l=Math.floor(a),c=9,h=9,d=0;for(let u=-1;u<=1;u++)for(let f=-1;f<=1;f++){let g=o+f,_=l+u,m=ir(g,i),p=ir(_,i),M=g+.5+(pe(m,p,e)-.5)*s,R=_+.5+(pe(m,p,e+7)-.5)*s,y=M-r,w=R-a,S=Math.sqrt(y*y+w*w);S<c?(h=c,c=S,d=m+p*131):S<h&&(h=S)}return[c,h,d]}var Je=(n,t,e)=>n<t?t:n>e?e:n,le=(n,t,e)=>n+(t-n)*e,Ne=(n,t,e)=>{let i=Je((e-n)/(t-n),0,1);return i*i*(3-2*i)},zi=(n,t,e,i)=>le(n,t,1-Math.exp(-e*i));function kn(n,t){let e=t-n;for(;e>Math.PI;)e-=Math.PI*2;for(;e<-Math.PI;)e+=Math.PI*2;return e}function fn(n,t,e,i){return n+kn(n,t)*(1-Math.exp(-e*i))}var xa={catacumbas:{name:"Catacumbas Esquecidas",walls:[["brick",5],["brick_mossy",3],["brick_cracked",2],["bone_wall",1]],floor:[["flagstone",6],["cobble",2]],corridor:"cobble",raised:"polished",cap:"slate",pillar:"brick",foundation:"brick",pool:"pit",bridge:"planks",fog:460812,hemiSky:6254484,hemiGround:1775122,hemi:.55,moon:9413590,moonI:.9,torch:16751178,enemies:[["carnical",6],["esqueleto",4],["aranha",1],["necromante",1]],boss:"gorran",props:["bones","bones","skull","cobweb","candles","pot","pot","barrel","banner","rubble","coffin"]},minas:{name:"Minas de Ferro Negro",walls:[["stone",6],["stone_ore",2]],floor:[["dirt",5],["gravel",3]],corridor:"gravel",raised:"planks",cap:"stone",pillar:"log_side",foundation:"stone",pool:"water",bridge:"planks",fog:461066,hemiSky:7043704,hemiGround:1906704,hemi:.5,moon:10466496,moonI:.75,torch:16756832,enemies:[["aranha",5],["carnical",3],["esporo",3],["esqueleto",2]],boss:"veshkara",props:["crate","crate","barrel","barrel","beam","crystal","crystal","rubble","pot","cart","cobweb"]},forja:{name:"Forja Profunda",walls:[["darkbrick",5],["basalt",3],["obsidian",1]],floor:[["basalt",5],["basalt_glow",1]],corridor:"basalt",raised:"obsidian",cap:"obsidian",pillar:"darkbrick",foundation:"basalt",pool:"lava",bridge:"basalt",fog:788230,hemiSky:8018512,hemiGround:1707016,hemi:.45,moon:13668464,moonI:.55,torch:16742960,enemies:[["esqueleto",4],["esporo",3],["necromante",2],["carnical",3]],boss:"colosso",props:["anvil","barrel","crate","rubble","rubble","banner","pot","chains"]}},iv=["catacumbas","minas","forja"],uf=n=>iv[(n-1)%3];var At={VOID:0,FLOOR:1,WALL:2,PIT:3,LAVA:4,WATER:5,PILLAR:6},df=new Set(["barrel","crate","coffin","crystal","cart","anvil"]),kh=class{constructor(){this.a=[]}push(t,e){let i=this.a;i.push([t,e]);let s=i.length-1;for(;s>0;){let r=s-1>>1;if(i[r][1]<=i[s][1])break;[i[s],i[r]]=[i[r],i[s]],s=r}}pop(){let t=this.a,e=t[0],i=t.pop();if(t.length){t[0]=i;let s=0;for(;;){let r=s*2+1,a=r+1,o=s;if(r<t.length&&t[r][1]<t[o][1]&&(o=r),a<t.length&&t[a][1]<t[o][1]&&(o=a),o===s)break;[t[s],t[o]]=[t[o],t[s]],s=o}}return e[0]}get size(){return this.a.length}};function ff(n,t,e){for(let i=0;i<20;i++){let s=nv(n+i*7919,t,e);if(s)return s}throw new Error("falha ao gerar masmorra")}function nv(n,t,e){let i=new Ki(n),s=xa[e],r=96,a=96,o=r*a,l=(T,G)=>T+G*r,c=(T,G)=>T>=0&&G>=0&&T<r&&G<a,h=new Uint8Array(o),d=new Int8Array(o),u=new Array(o).fill(null),f=new Int16Array(o).fill(-1),g=new Uint8Array(o),_=new Uint8Array(o),m=new Uint8Array(o),p=new Uint8Array(o),M=[],R=(T,G)=>{for(let J=0;J<300;J++){let C=i.int(3,r-T-4),nt=i.int(3,a-G-4),dt=!0;for(let E of M)if(C<E.x+E.w+5&&C+T+5>E.x&&nt<E.z+E.d+5&&nt+G+5>E.z){dt=!1;break}if(dt){let E={x:C,z:nt,w:T,d:G,cx:C+T/2,cz:nt+G/2,type:"normal",id:M.length};return M.push(E),E}}return null},y=R(20,20);y.type="boss";for(let T=0;T<120&&M.length<14;T++)R(i.int(8,14),i.int(8,14));if(M.length<8)return null;for(let T of M)for(let G=T.z;G<T.z+T.d;G++)for(let J=T.x;J<T.x+T.w;J++)h[l(J,G)]=At.FLOOR,f[l(J,G)]=T.id;let w=M.filter(T=>T!==y),S=(T,G)=>Math.hypot(T.cx-G.cx,T.cz-G.cz),I=w[0];for(let T of w)S(T,y)>S(I,y)&&(I=T);I.type="start";let v=[],A=new Set([I]);for(;A.size<w.length;){let T=null,G=1e9;for(let J of A)for(let C of w)if(!A.has(C)){let nt=S(J,C);nt<G&&(G=nt,T=[J,C])}A.add(T[1]),v.push(T)}for(let T=0;T<w.length;T++)for(let G=T+1;G<w.length;G++){let J=w[T],C=w[G];S(J,C)<28&&!v.some(nt=>nt[0]===J&&nt[1]===C||nt[0]===C&&nt[1]===J)&&i.chance(.22)&&v.push([J,C])}let P=3,O=(T,G)=>T>=y.x-P&&T<y.x+y.w+P&&G>=y.z-P&&G<y.z+y.d+P,L=(T,G,J,C,nt)=>{let dt=new Float32Array(o).fill(1e9),E=new Int32Array(o).fill(-1),x=new Int8Array(o).fill(-1),F=new kh,H=l(T,G),K=l(J,C);dt[H]=0,F.push(H,0);let ot=[1,-1,0,0],ut=[0,0,1,-1];for(;F.size;){let lt=F.pop();if(lt===K)break;let Dt=lt%r,ft=lt/r|0;for(let ct=0;ct<4;ct++){let Rt=Dt+ot[ct],Ft=ft+ut[ct];if(Rt<3||Ft<3||Rt>r-4||Ft>a-4||nt&&O(Rt,Ft))continue;let Vt=l(Rt,Ft),B=h[Vt]===At.FLOOR?.6:1;x[lt]!==-1&&x[lt]!==ct&&(B+=2.5);let ht=dt[lt]+B;ht<dt[Vt]&&(dt[Vt]=ht,E[Vt]=lt,x[Vt]=ct,F.push(Vt,ht+Math.abs(Rt-J)+Math.abs(Ft-C)))}}let j=[],et=K;if(E[et]===-1&&et!==H)return null;for(;et!==-1&&(j.push(et),et!==H);)et=E[et];return j},z=T=>{for(let G of T){let J=G%r,C=G/r|0;for(let nt=-1;nt<=1;nt++)for(let dt=-1;dt<=1;dt++){let E=l(J+dt,C+nt);h[E]===At.VOID&&(h[E]=At.FLOOR,g[E]=1)}}};for(let[T,G]of v){let J=L(Math.floor(T.cx),Math.floor(T.cz),Math.floor(G.cx),Math.floor(G.cz),!0);if(!J)return null;z(J)}let D=w[0];for(let T of w)T!==I&&S(T,y)<S(D,y)&&(D=T);let k=L(Math.floor(D.cx),Math.floor(D.cz),Math.floor(y.cx),Math.floor(y.cz),!1);if(!k)return null;z(k);let Y=[];for(let T=y.z-1;T<=y.z+y.d;T++)for(let G=y.x-1;G<=y.x+y.w;G++)(G===y.x-1||G===y.x+y.w||T===y.z-1||T===y.z+y.d)&&h[l(G,T)]===At.FLOOR&&Y.push({x:G,z:T});if(Y.length===0||Y.length>8)return null;let q=w.filter(T=>T!==I),Z=[],V=[];for(let T=0;T<3;T++){let G=null,J=-1;for(let C of q){if(C.type!=="normal")continue;let nt=S(C,I)*.6;for(let dt of V)nt=Math.min(nt,S(C,dt));nt+=i.range(0,4),nt>J&&(J=nt,G=C)}if(!G)return null;G.type="brazier",V.push(G)}let tt=q.filter(T=>T.type==="normal");tt.length&&(tt.sort((T,G)=>G.w*G.d-T.w*T.d)[0].type="treasure");let rt=q.filter(T=>T.type==="normal");rt.length>=2&&(i.pick(rt).type="altar");let St=(T,G,J)=>{for(let C=-J;C<=J;C++)for(let nt=-J;nt<=J;nt++){let dt=l(T+nt,G+C);if(c(T+nt,G+C)&&g[dt])return!0}return!1},_t=(T,G)=>{let J=l(T,G);h[J]===At.FLOOR&&!St(T,G,2)&&(h[J]=At.PILLAR,_[J]=1)},ee=s.pool==="lava"?At.LAVA:s.pool==="water"?At.WATER:At.PIT,Ct={chests:[],pots:[],altar:null,spawns:[]},$t=[],Q=T=>({x:Math.floor(T.cx),z:Math.floor(T.cz)});for(let T of M){if(T.type==="boss"){for(let nt=T.z+3;nt<T.z+T.d-3;nt+=4)_t(T.x+3,nt),_t(T.x+T.w-4,nt);for(let nt=T.x+7;nt<T.x+T.w-7;nt+=4)_t(nt,T.z+3),_t(nt,T.z+T.d-4);if(ee!==At.WATER)for(let[nt,dt]of[[1,1],[T.w-3,1],[1,T.d-3],[T.w-3,T.d-3]])for(let E=0;E<2;E++)for(let x=0;x<2;x++){let F=T.x+nt+x,H=T.z+dt+E;St(F,H,2)||(h[l(F,H)]=ee)}continue}if(T.type==="start")continue;let G=T.w>=11&&T.d>=11;if(T.type==="brazier"||T.type==="treasure"||T.type==="altar"||!G&&i.chance(.3)){let nt=Math.min(3,Math.floor(T.w/3)),dt=Math.min(3,Math.floor(T.d/3));for(let E=T.z+dt;E<T.z+T.d-dt;E++)for(let x=T.x+nt;x<T.x+T.w-nt;x++){let F=l(x,E);h[F]===At.FLOOR&&(d[F]=1,u[F]=s.raised)}}else if(G&&i.chance(.55)){for(let nt=T.z+3;nt<T.z+T.d-3;nt++)for(let dt=T.x+3;dt<T.x+T.w-3;dt++)h[l(dt,nt)]=ee;if(ee!==At.WATER||i.chance(.5)){let nt=T.w>=T.d,dt=Math.floor(nt?T.cz:T.cx);for(let E=0;E<2;E++)if(nt)for(let x=T.x+3;x<T.x+T.w-3;x++){let F=l(x,dt-1+E);h[F]=At.FLOOR,m[F]=1,u[F]=s.bridge}else for(let x=T.z+3;x<T.z+T.d-3;x++){let F=l(dt-1+E,x);h[F]=At.FLOOR,m[F]=1,u[F]=s.bridge}}}else if(G)for(let nt=T.z+2;nt<T.z+T.d-2;nt+=3)_t(T.x+2,nt),_t(T.x+T.w-3,nt);let C=Q(T);T.type==="brazier"&&Z.push({x:C.x+.5,z:C.z+.5}),T.type==="treasure"&&Ct.chests.push({x:C.x+.5,z:C.z+.5,big:!0}),T.type==="altar"&&(Ct.altar={x:C.x+.5,z:C.z+.5})}for(let T of Z)_[l(Math.floor(T.x),Math.floor(T.z))]=1;for(let T of Ct.chests)_[l(Math.floor(T.x),Math.floor(T.z))]=1;Ct.altar&&(_[l(Math.floor(Ct.altar.x),Math.floor(Ct.altar.z))]=1);let it=(T,G)=>{if(!c(T,G))return!1;let J=h[l(T,G)];return J!==At.VOID&&J!==At.WALL};for(let T=0;T<a;T++)for(let G=0;G<r;G++){if(h[l(G,T)]!==At.VOID)continue;let J=!1;for(let C=-1;C<=1&&!J;C++)for(let nt=-1;nt<=1;nt++)if(it(G+nt,T+C)){J=!0;break}J&&(h[l(G,T)]=At.WALL)}for(let T=0;T<a;T++)for(let G=0;G<r;G++){let J=l(G,T);h[J]===At.WALL&&(p[J]=it(G-1,T)||it(G,T-1)||it(G-1,T-1)?2:4),h[J]===At.PILLAR&&(p[J]=4)}let Mt=(T,G,J)=>On(T*.17,G*.17,n+J,4096,4096)*.8+pe(T,G,n+J)*.2;for(let T=0;T<a;T++)for(let G=0;G<r;G++){let J=l(G,T);h[J]===At.FLOOR&&!u[J]&&(g[J]?u[J]=Mt(G,T,1)<.62?s.corridor:Oh(s.floor,Mt(T,G,2)):u[J]=Oh(s.floor,Mt(G,T,2))),h[J]===At.WALL&&(u[J]=Oh(s.walls,Mt(G,T,3))),h[J]===At.PILLAR&&(u[J]=s.pillar)}let Ot=[],yt=[],qt=(T,G,J,C)=>T.some(nt=>Math.hypot(nt.cx-G,nt.cz-J)<C);for(let T=1;T<a-1;T++)for(let G=1;G<r-1;G++){let J=l(G,T);if(!(h[J]!==At.WALL||p[J]!==4))for(let[C,nt]of[[1,0],[0,1]]){let dt=l(G+C,T+nt);if(h[dt]!==At.FLOOR||_[dt]||pe(G,T,n+9)<.35||qt(Ot,G,T,6))continue;let E=d[dt];Ot.push({cx:G,cz:T,x:G+.5+C*.62,y:E+2.1,z:T+.5+nt*.62,nx:C,nz:nt});break}}let be=[];if(s.props.includes("banner"))for(let T=1;T<a-1;T++)for(let G=1;G<r-1;G++){let J=l(G,T);if(!(h[J]!==At.WALL||p[J]!==4||g[J]))for(let[C,nt]of[[1,0],[0,1]]){let dt=l(G+C,T+nt);if(!(h[dt]!==At.FLOOR||g[dt]||f[dt]<0)&&!(pe(G,T,n+19)<.8||qt(Ot,G,T,2)||qt(be,G,T,7))){be.push({cx:G,cz:T,x:G+.5+C*.53,y:d[dt]+2.4,z:T+.5+nt*.53,nx:C,nz:nt});break}}}let Yt=[];if(s.props.includes("cobweb"))for(let T=1;T<a-1;T++)for(let G=1;G<r-1;G++){let J=l(G,T);if(h[J]!==At.FLOOR||_[J])continue;let C=l(G-1,T),nt=l(G,T-1);h[C]===At.WALL&&p[C]===4&&h[nt]===At.WALL&&p[nt]===4&&pe(G,T,n+29)<.55&&Yt.push({x:G,z:T,y:d[J]})}let Kt=(T,G)=>{let J=l(T,G);return h[J]===At.FLOOR&&!_[J]&&!m[J]&&!g[J]};for(let T of M){if(T.type==="boss")continue;let G=Math.floor(T.w*T.d/16);for(let J=0;J<G;J++){let C,nt,dt=i.int(0,3);if(dt===0?(C=T.x,nt=i.int(T.z,T.z+T.d-1)):dt===1?(C=T.x+T.w-1,nt=i.int(T.z,T.z+T.d-1)):dt===2?(nt=T.z,C=i.int(T.x,T.x+T.w-1)):(nt=T.z+T.d-1,C=i.int(T.x,T.x+T.w-1)),i.chance(.25)&&(C=i.int(T.x+1,T.x+T.w-2),nt=i.int(T.z+1,T.z+T.d-2)),!Kt(C,nt)||St(C,nt,2))continue;let E=i.pick(s.props);if(!(E==="banner"||E==="cobweb"||E==="chains")){if(E==="pot"){Ct.pots.push({x:C+.5,z:nt+.5}),_[l(C,nt)]=2;continue}T.type==="start"&&df.has(E)&&i.chance(.5)||($t.push({type:E,x:C+.5,z:nt+.5,y:d[l(C,nt)],rot:i.range(0,Math.PI*2),s:i.range(.85,1.15)}),df.has(E)?_[l(C,nt)]=1:_[l(C,nt)]=2)}}if(T.type==="normal"&&i.chance(.3)){let J=i.chance(.5)?T.x:T.x+T.w-1,C=i.chance(.5)?T.z:T.z+T.d-1;Kt(J,C)&&!St(J,C,2)&&(Ct.chests.push({x:J+.5,z:C+.5,big:!1}),_[l(J,C)]=1)}for(let J=0;J<2;J++){let C=i.int(T.x,T.x+T.w-1),nt=i.int(T.z,T.z+T.d-1);Kt(C,nt)&&!St(C,nt,1)&&(Ct.pots.push({x:C+.5,z:nt+.5}),_[l(C,nt)]=2)}}for(let T of $t)T.type==="crystal"&&yt.push({x:T.x,y:T.y+.8,z:T.z,color:6281471,intensity:3,dist:6});let se=(T,G)=>{let J=h[l(T,G)];return(J===At.FLOOR||J===At.WATER)&&_[l(T,G)]!==1};for(let T of M){if(T.type==="start"||T.type==="boss")continue;let G=T.type==="treasure"?2:1+(T.w*T.d>150?1:0);for(let J=0;J<G;J++){let C=Math.min(8,i.int(2,4)+Math.floor((t-1)*.6)),nt=i.int(T.x+1,T.x+T.w-2),dt=i.int(T.z+1,T.z+T.d-2),E=[];for(let x=0;x<C;x++)for(let F=0;F<12;F++){let H=nt+i.int(-2,2),K=dt+i.int(-2,2);if(H>=T.x&&K>=T.z&&H<T.x+T.w&&K<T.z+T.d&&se(H,K)){E.push({type:i.weighted(s.enemies),x:H+i.range(.3,.7),z:K+i.range(.3,.7)});break}}Ct.spawns.push(...E)}}for(let T=0;T<30;T++){let G=i.int(3,r-4),J=i.int(3,a-4),C=l(G,J);g[C]&&se(G,J)&&Math.hypot(G-I.cx,J-I.cz)>18&&!O(G,J)&&i.chance(.4)&&Ct.spawns.push({type:i.weighted(s.enemies),x:G+.5,z:J+.5})}let Wt=new Uint8Array(o),ie=[l(Math.floor(I.cx),Math.floor(I.cz))];for(Wt[ie[0]]=1;ie.length;){let T=ie.pop(),G=T%r,J=T/r|0;for(let[C,nt]of[[1,0],[-1,0],[0,1],[0,-1]]){let dt=G+C,E=J+nt,x=l(dt,E);!c(dt,E)||Wt[x]||!se(dt,E)||Math.abs(d[x]-d[T])>1||(Wt[x]=1,ie.push(x))}}let ne=(T,G)=>{for(let[J,C]of[[1,0],[-1,0],[0,1],[0,-1]])if(Wt[l(T+J,G+C)])return!0;return!1};for(let T of Z)if(!ne(Math.floor(T.x),Math.floor(T.z)))return null;if(!Y.some(T=>Wt[l(T.x,T.z)]))return null;for(let T of Ct.chests)ne(Math.floor(T.x),Math.floor(T.z))||(_[l(Math.floor(T.x),Math.floor(T.z))]=0,T.dead=!0);return Ct.chests=Ct.chests.filter(T=>!T.dead),Ct.altar&&!ne(Math.floor(Ct.altar.x),Math.floor(Ct.altar.z))&&(Ct.altar=null),{W:r,D:a,seed:n,floorNum:t,themeKey:e,theme:s,cell:h,h:d,mat:u,room:f,corr:g,solid:_,thin:m,wallH:p,rooms:M,boss:y,start:I,gates:Y,braziers:Z,torches:Ot,banners:be,cobwebs:Yt,props:$t,lightsExtra:yt,...Ct,idx:l,inb:c}}function Oh(n,t){let e=0;for(let[,i]of n)e+=i;t*=e;for(let[i,s]of n)if(t-=s,t<=0)return i;return n[0][0]}var Bt=64,_a=8,Hn=Bt+_a*2,nr=8,Hl={},kl=[],We=(n,t)=>{Hl[n]=kl.length,kl.push({name:n,gen:t})};function sr(n,t,e){n.r=le(n.r,t[0],e),n.g=le(n.g,t[1],e),n.b=le(n.b,t[2],e)}function mf(n,t=3){let e=new Float32Array(Bt*Bt),i=new Ki(n);for(let s=0;s<t;s++){let r=i.range(0,Bt),a=i.range(0,Bt),o=i.range(0,Math.PI*2),l=i.int(18,40);for(let c=0;c<l;c++){o+=i.range(-.6,.6),r+=Math.cos(o),a+=Math.sin(o);for(let h=-1;h<=1;h++)for(let d=-1;d<=1;d++){let u=((Math.round(r)+d)%Bt+Bt)%Bt,f=((Math.round(a)+h)%Bt+Bt)%Bt,g=d===0&&h===0?1:.35*(1-c/l);e[f*Bt+u]=Math.max(e[f*Bt+u],g)}i.chance(.06)&&(o+=i.range(-1.2,1.2))}}return e}function Vl(n){let t=n.crack?mf(n.seed+99,n.crack):null,e=n.bw||32,i=n.bh||16;return(s,r,a,o,l)=>{let c=Math.floor(l/i),h=c%2*(e/2),d=(o+h)%Bt,u=Math.floor(d/e),f=d-u*e,g=l-c*i,_=De(s,r,n.seed,8,4),m=Math.min(f+.5,e-f-.5,g+.5,i-g-.5)+(_-.5)*2.2,p=Ne(.6,3,m),R=1+(pe(u,c,n.seed)-.5)*n.var+(_-.5)*.4,y=pe(o,l,n.seed+3)<.05?.82:1,w=n.mortar;a.r=le(w[0],n.base[0]*R*y,p),a.g=le(w[1],n.base[1]*R*y,p),a.b=le(w[2],n.base[2]*R*y,p);let S=De(s,r,n.seed+11,16,2);if(a.h=.12+p*(.62+S*.18)+(_-.5)*.2,a.ro=le(.97,.78+_*.15,p),n.moss){let I=De(s,r,n.seed+50,4,5)+(1-p)*.14+l/Bt*.08,v=Ne(.66-n.moss*.2,.72-n.moss*.2,I);if(v>0){let A=De(s,r,n.seed+80,16,3);sr(a,[.15+A*.1,.25+A*.15,.07+A*.04],v),a.h=le(a.h,.75+A*.2,v),a.ro=le(a.ro,1,v)}}if(t){let I=t[l*Bt+o];I>0&&(a.r*=1-.75*I,a.g*=1-.75*I,a.b*=1-.75*I,a.h-=.55*I)}}}function Gl(n){return(t,e,i)=>{let[s,r,a]=li(t,e,n.seed,n.n,n.jit||.8),o=De(t,e,n.seed+5,8,4),l=r-s+(o-.5)*.06,c=Ne(.02,n.soft||.12,l),h=1+(pe(a,3,n.seed)-.5)*n.var+(o-.5)*.35;i.r=le(n.grout[0],n.base[0]*h,c),i.g=le(n.grout[1],n.base[1]*h,c),i.b=le(n.grout[2],n.base[2]*h,c),i.h=.1+c*.6+(o-.5)*.2+(n.dome?(1-s*1.5)*n.dome:0),i.ro=le(.98,n.rough||.8,c)}}function gf(n,t,e){return On(n*3,t*40,e,3,40)*.6+On(n*6,t*90,e+1,6,90)*.4}We("brick",Vl({seed:11,base:[.46,.45,.43],var:.3,mortar:[.2,.19,.18]}));We("brick_mossy",Vl({seed:11,base:[.44,.44,.4],var:.3,mortar:[.18,.2,.15],moss:1}));We("brick_cracked",Vl({seed:12,base:[.43,.42,.41],var:.35,mortar:[.19,.18,.17],crack:4}));We("flagstone",Gl({seed:21,n:3,base:[.42,.4,.37],grout:[.13,.12,.11],var:.3}));We("cobble",Gl({seed:23,n:6,base:[.47,.46,.44],grout:[.14,.13,.12],var:.45,dome:.35,soft:.2}));We("slate",(n,t,e)=>{let[i,s,r]=li(n,t,31,2,.6),a=De(n,t,32,8,5),o=Ne(.01,.06,s-i),l=.85+pe(r,1,31)*.3+(a-.5)*.3;e.r=.2*l*(.6+.4*o),e.g=.21*l*(.6+.4*o),e.b=.24*l*(.6+.4*o),e.h=.3+o*.4+a*.3,e.ro=.75+a*.2});function xf(n,t,e,i){let s=De(n,t,i,4,6),[r,a]=li(n,t,i+3,5,1),o=1-Ne(0,.05,a-r),l=.7+s*.6;e.r=.42*l,e.g=.38*l,e.b=.34*l,e.r*=1-o*.5,e.g*=1-o*.5,e.b*=1-o*.5,e.h=s*.8-o*.4+De(n,t,i+9,16,2)*.2,e.ro=.88}We("stone",(n,t,e)=>xf(n,t,e,41));We("stone_ore",(n,t,e)=>{xf(n,t,e,43);let[i,,s]=li(n,t,45,7,.9);if(pe(s,9,45)<.35&&i<.2){let a=Ne(.2,.1,i);sr(e,[.95,.72,.25],a),e.h+=a*.3,e.ro=le(e.ro,.25,a)}});We("dirt",(n,t,e)=>{let i=De(n,t,51,6,5),s=.65+i*.7;e.r=.34*s,e.g=.25*s,e.b=.17*s,e.h=i*.6,e.ro=.97;let[r,,a]=li(n,t,53,10,1);if(r<.22&&pe(a,2,53)<.5){let o=Ne(.22,.12,r);sr(e,[.45*(.8+pe(a,5,1)*.4),.42,.38],o),e.h+=o*.35}});We("gravel",Gl({seed:61,n:12,base:[.4,.38,.36],grout:[.14,.13,.12],var:.6,dome:.5,soft:.25,jit:1}));We("planks",(n,t,e,i,s)=>{let r=Math.floor(s/16),a=s-r*16,o=Math.floor(pe(r,1,71)*Bt),l=Math.min(Math.abs(i-o),Bt-Math.abs(i-o)),c=gf(n+r*.37,t,71+r),h=(.8+pe(r,2,71)*.35)*(.7+c*.6);e.r=.46*h,e.g=.31*h,e.b=.18*h;let d=Math.min(a+.5,16-a-.5,l+.5),u=Ne(.4,1.6,d);e.r*=.35+.65*u,e.g*=.35+.65*u,e.b*=.35+.65*u,e.h=.2+u*.5+c*.2,e.ro=.8;let f=(o+3)%Bt,g=(o-4+Bt)%Bt;(i===f||i===g)&&(a===4||a===11)&&(e.r=e.g=e.b=.12,e.ro=.4,e.h=.8)});We("log_side",(n,t,e)=>{let i=On(n*14,t*3,81,14,3)*.7+On(n*28,t*6,82,28,6)*.3,s=Math.pow(Math.abs(i*2-1),.6),r=.55+s*.6;e.r=.3*r,e.g=.21*r,e.b=.13*r,e.h=s*.8,e.ro=.95});We("log_top",(n,t,e)=>{let i=n-.5,s=t-.5,r=Math.sqrt(i*i+s*s),a=De(n,t,91,4,3),o=.5+.5*Math.sin((r+a*.05)*90),l=.75+o*.3;if(e.r=.55*l,e.g=.4*l,e.b=.24*l,e.h=o*.3,e.ro=.85,r>.42){let c=Ne(.42,.46,r);sr(e,[.2,.14,.09],c),e.h=.2+c*.4}});We("darkbrick",Vl({seed:101,base:[.3,.2,.17],var:.35,mortar:[.08,.06,.06],crack:2}));We("basalt",Gl({seed:111,n:4,base:[.19,.18,.18],grout:[.05,.05,.05],var:.3,soft:.08,rough:.9}));We("basalt_glow",(n,t,e)=>{let[i,s,r]=li(n,t,121,4,.8),a=De(n,t,122,8,4),o=s-i+(a-.5)*.05,l=.8+pe(r,1,121)*.4;e.r=.17*l,e.g=.15*l,e.b=.14*l,e.h=.2+Ne(0,.1,o)*.6+a*.2,e.ro=.9;let c=Ne(.06,0,o)*(.6+.4*a);c>0&&(sr(e,[1,.45,.1],c),e.er=1*c,e.eg=.32*c,e.eb=.04*c,e.h-=c*.3)});We("obsidian",(n,t,e)=>{let i=De(n,t,131,3,6),s=Math.pow(1-Math.abs(i*2-1),6),[r]=li(n,t,133,3,1);e.r=.06+s*.12,e.g=.045+s*.05,e.b=.09+s*.16,e.h=r*.35+s*.1,e.ro=.38+(1-s)*.2});We("polished",(n,t,e,i,s)=>{let r=Math.floor(i/32),a=Math.floor(s/32),o=(r+a)%2===0,l=De(n,t,141+(o?0:5),3,6),c=Math.pow(1-Math.abs(l*2-1),10),h=o?[.14,.13,.16]:[.46,.44,.41],d=o?[.4,.38,.42]:[.2,.19,.2];e.r=h[0],e.g=h[1],e.b=h[2],sr(e,d,c*.8);let u=i%32,f=s%32,g=Math.min(u+.5,32-u-.5,f+.5,32-f-.5),_=Ne(.4,1.4,g);e.r*=.4+.6*_,e.g*=.4+.6*_,e.b*=.4+.6*_,e.h=.3+_*.5,e.ro=le(.9,.28,_)});We("bone_wall",(n,t,e)=>{let[i,s,r]=li(n,t,151,5,.9),a=De(n,t,152,8,3),o=Ne(0,.18,s-i),l=pe(r,4,151)<.25,c=.75+pe(r,2,151)*.3+a*.2;if(e.r=.72*c*(.3+.7*o),e.g=.66*c*(.3+.7*o),e.b=.54*c*(.3+.7*o),e.h=o*.6+(1-i*1.6)*.3,e.ro=.8,l&&i<.3){let h=pe(r,8,151)*.1,[d]=li(n+.03,t+h*.1,151,5,.9);Math.abs(d-i)<.02&&i>.06&&i<.16&&(e.r*=.2,e.g*=.2,e.b*=.2,e.h-=.3)}});function sv(n){let t=Bt*Bt,e=new Float32Array(t*3),i=new Float32Array(t),s=new Float32Array(t),r=new Float32Array(t*3),a={};for(let c=0;c<Bt;c++)for(let h=0;h<Bt;h++){a.r=a.g=a.b=.5,a.h=.5,a.ro=.9,a.er=a.eg=a.eb=0,n((h+.5)/Bt,(c+.5)/Bt,a,h,c);let d=c*Bt+h;e[d*3]=a.r,e[d*3+1]=a.g,e[d*3+2]=a.b,i[d]=a.h,s[d]=a.ro,r[d*3]=a.er,r[d*3+1]=a.eg,r[d*3+2]=a.eb}let o=new Float32Array(t*3),l=2.4;for(let c=0;c<Bt;c++)for(let h=0;h<Bt;h++){let d=i[c*Bt+(h+Bt-1)%Bt],u=i[c*Bt+(h+1)%Bt],f=i[(c+Bt-1)%Bt*Bt+h],g=i[(c+1)%Bt*Bt+h],_=-(u-d)*l,m=(g-f)*l,p=1,M=Math.hypot(_,m,p);_/=M,m/=M,p/=M;let R=(c*Bt+h)*3;o[R]=_*.5+.5,o[R+1]=m*.5+.5,o[R+2]=p*.5+.5}return{alb:e,hgt:i,rou:s,emi:r,nor:o}}var zl=null,Hh=null;function _f(){return Hh||(Hh=kl.map(n=>sv(n.gen))),Hh}function ss(n,t,e){let i=document.createElement("canvas");i.width=n,i.height=t;let s=i.getContext("2d"),r=s.createImageData(n,t);return e(r.data),s.putImageData(r,0,0),i}function vf(){if(zl)return zl;let n=_f(),t=Math.ceil(kl.length/nr),e=nr*Hn,i=t*Hn,s=(d,u)=>{let f=ss(e,i,_=>{for(let m=0;m<n.length;m++){let p=m%nr*Hn,M=Math.floor(m/nr)*Hn;for(let R=0;R<Hn;R++)for(let y=0;y<Hn;y++){let w=((y-_a)%Bt+Bt)%Bt,S=((R-_a)%Bt+Bt)%Bt,I=d(n[m],S*Bt+w),v=((M+R)*e+p+y)*4;_[v]=Je(I[0],0,1)*255,_[v+1]=Je(I[1],0,1)*255,_[v+2]=Je(I[2],0,1)*255,_[v+3]=255}}}),g=new ti(f);return g.colorSpace=u?Ee:wi,g.anisotropy=8,g.minFilter=Yi,g.magFilter=Oe,g},r=[0,0,0],a=s((d,u)=>(r[0]=d.alb[u*3],r[1]=d.alb[u*3+1],r[2]=d.alb[u*3+2],r),!0),o=s((d,u)=>(r[0]=d.nor[u*3],r[1]=d.nor[u*3+1],r[2]=d.nor[u*3+2],r),!1),l=s((d,u)=>(r[0]=r[1]=r[2]=d.rou[u],r),!1),c=s((d,u)=>(r[0]=d.emi[u*3],r[1]=d.emi[u*3+1],r[2]=d.emi[u*3+2],r),!0);return zl={map:a,normalMap:o,roughnessMap:l,emissiveMap:c,uv:d=>{let u=d%nr*Hn+_a,f=Math.floor(d/nr)*Hn+_a,g=.5;return[(u+g)/e,1-(f+Bt-g)/i,(u+Bt-g)/e,1-(f+g)/i]}},zl}var Bl={};function va(n,t=1){let e=n+":"+t;if(Bl[e])return Bl[e];let i=_f()[Hl[n]],s=(r,a,o)=>{let l=ss(Bt,Bt,h=>{for(let d=0;d<Bt*Bt;d++)o?h[d*4]=h[d*4+1]=h[d*4+2]=Je(r[d],0,1)*255:(h[d*4]=Je(r[d*3],0,1)*255,h[d*4+1]=Je(r[d*3+1],0,1)*255,h[d*4+2]=Je(r[d*3+2],0,1)*255),h[d*4+3]=255}),c=new ti(l);return c.wrapS=c.wrapT=Tn,c.repeat.set(t,t),c.colorSpace=a?Ee:wi,c.anisotropy=4,c};return Bl[e]={map:s(i.alb,!0),normalMap:s(i.nor,!1),roughnessMap:s(i.rou,!1,!0)},Bl[e]}var Ol={},pf={steel:{base:[.55,.57,.6],var:.25,sc:6,scratch:!0},steel_dark:{base:[.28,.29,.32],var:.25,sc:6,scratch:!0},gold:{base:[.85,.66,.28],var:.2,sc:6,scratch:!0},iron:{base:[.22,.21,.21],var:.35,sc:8,rust:!0},cloth_blue:{base:[.12,.2,.42],var:.25,sc:16,weave:!0},cloth_red:{base:[.5,.08,.07],var:.25,sc:16,weave:!0},cloth_green:{base:[.12,.3,.16],var:.25,sc:16,weave:!0},cloth_purple:{base:[.26,.1,.34],var:.3,sc:16,weave:!0},leather:{base:[.36,.22,.12],var:.35,sc:8},skin:{base:[.78,.58,.46],var:.12,sc:6},skin_rot:{base:[.4,.47,.33],var:.45,sc:5,blotch:[.3,.18,.2]},rags:{base:[.3,.26,.2],var:.5,sc:10,weave:!0,holes:!0},bone:{base:[.82,.78,.66],var:.2,sc:8,pores:!0},robe:{base:[.12,.1,.14],var:.3,sc:12,weave:!0},chitin:{base:[.3,.24,.2],var:.3,sc:5,plates:!0},fungus:{base:[.55,.42,.3],var:.35,sc:6,spots:[.85,.8,.45]},obsidian:{base:[.08,.06,.1],var:.3,sc:4,lava:!0},wood:{base:[.42,.28,.16],var:.3,sc:4,grain:!0},hair:{base:[.15,.1,.06],var:.4,sc:20}};function rr(n){if(Ol[n])return Ol[n];let t=pf[n]||pf.steel,e=64,i=n.length*97+n.charCodeAt(0),s=new Float32Array(e*e),r=new Float32Array(e*e*3),a=new Float32Array(e*e),o=t.scratch?mf(i,5):null,l=ss(e,e,f=>{for(let g=0;g<e;g++)for(let _=0;_<e;_++){let m=(_+.5)/e,p=(g+.5)/e,M=g*e+_,R=De(m,p,i,t.sc,4);t.grain&&(R=gf(m,p,i));let y=1+(R-.5)*t.var*2,w=t.base[0]*y,S=t.base[1]*y,I=t.base[2]*y,v=.8,A=R;if(t.weave){let P=((_+g)%4<2?1:.9)*((_-g+64)%4<2?1:.94);w*=P,S*=P,I*=P,v=.95}if(t.scratch){v=.32+R*.2;let P=o[M];P>0&&(w*=1+P*.3,S*=1+P*.3,I*=1+P*.3,A-=P*.3)}if(t.rust){let P=Ne(.55,.7,De(m,p,i+4,4,4));w=le(w,.4,P),S=le(S,.2,P),I=le(I,.1,P),v=.5+P*.4}if(t.blotch){let P=Ne(.58,.7,De(m,p,i+6,4,4));w=le(w,t.blotch[0],P),S=le(S,t.blotch[1],P),I=le(I,t.blotch[2],P),v=.6}if(t.holes&&De(m,p,i+8,6,3)>.7&&(w*=.3,S*=.3,I*=.3),t.pores&&(pe(_,g,i)<.05&&(w*=.7,S*=.7,I*=.7),v=.7),t.plates){let[P,O]=li(m,p,i,3,.7),L=Ne(0,.08,O-P);w=w*(.4+.6*L)+(1-P)*.05,S*=.4+.6*L,I*=.4+.6*L,v=.35,A=L}if(t.spots){let[P,,O]=li(m,p,i,5,1);if(P<.25&&pe(O,1,i)<.6){let L=Ne(.25,.18,P);w=le(w,t.spots[0],L),S=le(S,t.spots[1],L),I=le(I,t.spots[2],L)}}if(t.lava){let[P,O]=li(m,p,i,4,.9),L=Ne(.035,0,O-P);v=.2+(1-L)*.2,L>0&&(w=le(w,1,L),S=le(S,.4,L),I=le(I,.05,L),r[M*3]=L,r[M*3+1]=L*.35,r[M*3+2]=L*.05)}s[M]=v,a[M]=A,f[M*4]=Je(w,0,1)*255,f[M*4+1]=Je(S,0,1)*255,f[M*4+2]=Je(I,0,1)*255,f[M*4+3]=255}}),c=new ti(l);c.colorSpace=Ee;let h=ss(e,e,f=>{for(let g=0;g<e*e;g++)f[g*4]=f[g*4+1]=f[g*4+2]=s[g]*255,f[g*4+3]=255}),d=new ti(h),u=null;if(t.lava){let f=ss(e,e,g=>{for(let _=0;_<e*e;_++)g[_*4]=r[_*3]*255,g[_*4+1]=r[_*3+1]*255,g[_*4+2]=r[_*3+2]*255,g[_*4+3]=255});u=new ti(f),u.colorSpace=Ee}return Ol[n]={map:c,roughnessMap:d,emissiveMap:u},Ol[n]}function yf(){let t=ss(128,128,i=>{for(let s=0;s<128;s++)for(let r=0;r<128;r++){let a=r/128,o=s/128,l=De(a,o,201,4,5),[c,h]=li(a,o,203,5,1),u=1-Ne(.02,.2,h-c)*Ne(.35,.65,l),f=le(.1,1,u),g=le(.02,.22+.4*u*u,u),_=le(.01,.02+.12*Math.pow(u,4),u),m=(s*128+r)*4;i[m]=f*255,i[m+1]=g*255,i[m+2]=_*255,i[m+3]=255}}),e=new ti(t);return e.colorSpace=Ee,e.wrapS=e.wrapT=Tn,e}function Mf(){let t=new Float32Array(16384);for(let s=0;s<128;s++)for(let r=0;r<128;r++)t[s*128+r]=De(r/128,s/128,301,4,5);let e=ss(128,128,s=>{for(let r=0;r<128;r++)for(let a=0;a<128;a++){let o=(t[r*128+(a+1)%128]-t[r*128+(a+128-1)%128])*6,l=(t[(r+1)%128*128+a]-t[(r+128-1)%128*128+a])*6,c=Math.hypot(o,l,1),h=(r*128+a)*4;s[h]=(-o/c*.5+.5)*255,s[h+1]=(l/c*.5+.5)*255,s[h+2]=(1/c*.5+.5)*255,s[h+3]=255}}),i=new ti(e);return i.wrapS=i.wrapT=Tn,i}function Wl(n,t,e){let i=document.createElement("canvas");i.width=n,i.height=t,e(i.getContext("2d"),n,t);let s=new ti(i);return s.colorSpace=Ee,s}var bf=()=>Wl(64,64,(n,t)=>{let e=n.createRadialGradient(t/2,t/2,0,t/2,t/2,t/2);e.addColorStop(0,"rgba(255,255,255,1)"),e.addColorStop(.35,"rgba(255,255,255,0.6)"),e.addColorStop(1,"rgba(255,255,255,0)"),n.fillStyle=e,n.fillRect(0,0,t,t)}),Sf=()=>Wl(128,128,n=>{n.strokeStyle="rgba(230,230,235,0.55)",n.lineWidth=1;let t=0,e=0;for(let i=0;i<=8;i++){let s=i/8*Math.PI/2;n.beginPath(),n.moveTo(t,e),n.lineTo(Math.cos(s)*128,Math.sin(s)*128),n.stroke()}for(let i=12;i<128;i+=11+i*.08){n.beginPath();for(let s=0;s<=8;s++){let r=s/8*Math.PI/2,a=i*(.92+.08*Math.sin(s*3+i)),o=Math.cos(r)*a,l=Math.sin(r)*a;s?n.lineTo(o,l):n.moveTo(o,l)}n.stroke()}}),wf=()=>Wl(128,128,(n,t)=>{let e=n.createRadialGradient(t/2,t/2,0,t/2,t/2,t/2);e.addColorStop(0,"rgba(255,255,255,0.15)"),e.addColorStop(.82,"rgba(255,255,255,0.35)"),e.addColorStop(.92,"rgba(255,255,255,1)"),e.addColorStop(1,"rgba(255,255,255,0)"),n.fillStyle=e,n.fillRect(0,0,t,t)}),Tf=(n,t)=>Wl(64,128,(e,i,s)=>{e.fillStyle=n,e.fillRect(0,0,i,s);for(let r=0;r<400;r++)e.fillStyle=`rgba(0,0,0,${Math.random()*.12})`,e.fillRect(Math.random()*i,Math.random()*s,2,2);e.fillStyle="rgba(210,170,70,0.9)",e.fillRect(4,4,i-8,3),e.fillRect(4,s-26,i-8,3),e.save(),e.translate(i/2,s*.42),e.fillStyle="rgba(215,180,80,0.95)",t===0?(e.beginPath(),e.moveTo(0,-18),e.lineTo(14,0),e.lineTo(0,18),e.lineTo(-14,0),e.closePath(),e.fill(),e.fillStyle=n,e.fillRect(-3,-8,6,16)):t===1?(e.beginPath(),e.arc(0,0,14,0,Math.PI*2),e.fill(),e.fillStyle=n,e.beginPath(),e.arc(4,-3,11,0,Math.PI*2),e.fill()):(e.fillRect(-2,-20,4,34),e.fillRect(-12,-10,24,4)),e.restore(),e.clearRect(0,s-20,i,20),e.fillStyle=n;for(let r=0;r<i;r+=8)e.beginPath(),e.moveTo(r,s-21),e.lineTo(r+8,s-21),e.lineTo(r+4,s-4-Math.random()*8),e.fill()});var pn=5,Xl=pn+5,ql=16,rv=[{dir:[-1,0,0],c:[[0,1,0,0,1],[0,0,0,0,0],[0,1,1,1,1],[0,0,1,1,0]]},{dir:[1,0,0],c:[[1,1,1,0,1],[1,0,1,0,0],[1,1,0,1,1],[1,0,0,1,0]]},{dir:[0,1,0],c:[[0,1,1,1,1],[1,1,1,0,1],[0,1,0,1,0],[1,1,0,0,0]],top:!0},{dir:[0,0,-1],c:[[1,0,0,0,0],[0,0,0,1,0],[1,1,0,0,1],[0,1,0,1,1]]},{dir:[0,0,1],c:[[0,0,1,0,0],[1,0,1,1,0],[0,1,1,0,1],[1,1,1,1,1]]}],av=[.34,.56,.78,1];function ov(n,t){let e=0;for(let[,i]of n)e+=i;t*=e;for(let[i,s]of n)if(t-=s,t<=0)return i;return n[0][0]}function Ef(n){let{W:t,D:e,cell:i,h:s,mat:r,thin:a,wallH:o,theme:l,seed:c}=n,h=new Uint8Array(t*e*Xl),d=new Uint8Array(t*e*Xl),u=(L,z,D)=>L+D*t+z*t*e,f=L=>Hl[L]+1,g=(L,z,D,k,Y)=>{let q=u(L,z,D);h[q]=k,d[q]=Y||k};for(let L=0;L<e;L++)for(let z=0;z<t;z++){let D=z+L*t,k=i[D],Y=f(l.foundation);if(k===At.FLOOR){let q=pn-1+s[D],Z=f(r[D]);if(a[D]){g(z,q,L,Z,Z);continue}for(let V=0;V<q;V++)g(z,V,L,Y);g(z,q,L,s[D]>0?Z:Y,Z)}else if(k===At.WATER||k===At.LAVA){let q=k===At.LAVA?f("basalt"):f((l.themeKey==="minas","gravel"));for(let Z=0;Z<pn-1;Z++)g(z,Z,L,Y,q)}else if(k===At.PIT)g(z,0,L,Y,f("gravel"));else if(k===At.WALL){let q=pn-1+o[D];for(let Z=0;Z<=q;Z++){let V=Z<pn-1?Y:f(ov(l.walls,pe(z*13+Z*7,L,c+3)));g(z,Z,L,V,Z===q?f(l.cap):V)}}else if(k===At.PILLAR){let q=pn-1+4,Z=f(l.pillar);for(let V=0;V<=q;V++)g(z,V,L,V<pn?Y:Z,V===q?l.pillar==="log_side"?f("log_top"):f(l.cap):Z)}}let _=(L,z,D)=>L<0||D<0||L>=t||D>=e||z>=Xl?!1:z<0?!0:h[u(L,z,D)]!==0,m=(L,z)=>L<0||z<0||L>=t||z>=e||i[L+z*t]===At.VOID,p=vf(),M=new Ce({map:p.map,normalMap:p.normalMap,roughnessMap:p.roughnessMap,emissiveMap:p.emissiveMap,emissive:16777215,emissiveIntensity:1.6,vertexColors:!0,metalness:0,normalScale:new xt(1.1,1.1)}),R=new fe;for(let L=0;L<e;L+=ql)for(let z=0;z<t;z+=ql){let D=[],k=[],Y=[],q=[],Z=[];for(let rt=L;rt<Math.min(e,L+ql);rt++)for(let St=z;St<Math.min(t,z+ql);St++)for(let _t=0;_t<Xl;_t++){let ee=u(St,_t,rt);if(h[ee])for(let Ct of rv){let[$t,Q,it]=Ct.dir;if(_(St+$t,_t+Q,rt+it))continue;let Mt=(Ct.top?d[ee]:h[ee])-1,[Ot,yt,qt,be]=p.uv(Mt),Yt=.88+pe(St*3+_t,rt*5+_t,c)*.18;!Ct.top&&m(St+$t,rt+it)&&(Yt*=.28),Ct.top||(Yt*=.78+.22*Math.min(1,Math.max(0,(_t-pn+1)/3)));let Kt=Ct.dir[0]?0:Ct.dir[1]?1:2,se=(Kt+1)%3,Wt=(Kt+2)%3,ie=[],ne=D.length/3;for(let T of Ct.c){let G=[T[0],T[1],T[2]],J=[St+$t,_t+Q,rt+it],C=[0,0,0],nt=[0,0,0];C[se]=G[se]?1:-1,nt[Wt]=G[Wt]?1:-1;let dt=_(J[0]+C[0],J[1]+C[1],J[2]+C[2])?1:0,E=_(J[0]+nt[0],J[1]+nt[1],J[2]+nt[2])?1:0,x=_(J[0]+C[0]+nt[0],J[1]+C[1]+nt[1],J[2]+C[2]+nt[2])?1:0,F=dt&&E?0:3-(dt+E+x);ie.push(F),D.push(St+T[0],_t-pn+T[1],rt+T[2]),k.push($t,Q,it),Y.push(Ot+T[3]*(qt-Ot),yt+T[4]*(be-yt));let H=av[F]*Yt;q.push(H,H,H)}ie[0]+ie[3]>ie[1]+ie[2]?Z.push(ne,ne+1,ne+3,ne,ne+3,ne+2):Z.push(ne,ne+1,ne+2,ne+2,ne+1,ne+3)}}if(!D.length)continue;let V=new ce;V.setAttribute("position",new Gt(D,3)),V.setAttribute("normal",new Gt(k,3)),V.setAttribute("uv",new Gt(Y,2)),V.setAttribute("color",new Gt(q,3)),V.setIndex(Z),V.computeBoundingSphere();let tt=new Tt(V,M);tt.castShadow=!0,tt.receiveShadow=!0,R.add(tt)}let y=[],w=(L,z)=>{let D=[],k=[],Y=[];for(let Z=0;Z<e;Z++)for(let V=0;V<t;V++){if(i[V+Z*t]!==L)continue;let tt=D.length/3;D.push(V,z,Z+1,V+1,z,Z+1,V,z,Z,V+1,z,Z),k.push(V*.25,(Z+1)*.25,(V+1)*.25,(Z+1)*.25,V*.25,Z*.25,(V+1)*.25,Z*.25),Y.push(tt,tt+1,tt+2,tt+2,tt+1,tt+3)}if(!D.length)return null;let q=new ce;return q.setAttribute("position",new Gt(D,3)),q.setAttribute("uv",new Gt(k,2)),q.setIndex(Y),q.computeVertexNormals(),q.computeBoundingSphere(),q},S=null,I=null,v=w(At.LAVA,-.82);if(v){let L=yf();S=new Ce({map:L,emissiveMap:L,emissive:16777215,emissiveIntensity:.95,roughness:.7});let z=new Tt(v,S);z.receiveShadow=!1,R.add(z),y.push(z)}let A=w(At.WATER,-.32);if(A){let L=Mf();I=new Ce({color:928816,roughness:.06,metalness:.2,normalMap:L,normalScale:new xt(.5,.5),transparent:!0,opacity:.8});let z=new Tt(A,I);z.receiveShadow=!0,R.add(z),y.push(z)}return{group:R,update:L=>{S&&(S.map.offset.set(Math.sin(L*.05)*.3,L*.02),S.emissiveIntensity=.95+Math.sin(L*1.3)*.12),I&&I.normalMap.offset.set(L*.02,L*.013)},dispose:()=>{R.traverse(L=>{L.geometry&&L.geometry.dispose()}),M.dispose(),S&&(S.map.dispose(),S.dispose()),I&&(I.normalMap.dispose(),I.dispose())},material:M}}function Rf(n,t=!1){let e=n[0].index!==null,i=new Set(Object.keys(n[0].attributes)),s=new Set(Object.keys(n[0].morphAttributes)),r={},a={},o=n[0].morphTargetsRelative,l=new ce,c=0;for(let h=0;h<n.length;++h){let d=n[h],u=0;if(e!==(d.index!==null))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". All geometries must have compatible attributes; make sure index attribute exists among all geometries, or in none of them."),null;for(let f in d.attributes){if(!i.has(f))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+'. All geometries must have compatible attributes; make sure "'+f+'" attribute exists among all geometries, or in none of them.'),null;r[f]===void 0&&(r[f]=[]),r[f].push(d.attributes[f]),u++}if(u!==i.size)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". Make sure all geometries have the same number of attributes."),null;if(o!==d.morphTargetsRelative)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". .morphTargetsRelative must be consistent throughout all geometries."),null;for(let f in d.morphAttributes){if(!s.has(f))return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+".  .morphAttributes must be consistent throughout all geometries."),null;a[f]===void 0&&(a[f]=[]),a[f].push(d.morphAttributes[f])}if(t){let f;if(e)f=d.index.count;else if(d.attributes.position!==void 0)f=d.attributes.position.count;else return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed with geometry at index "+h+". The geometry must have either an index or a position attribute"),null;l.addGroup(c,f,h),c+=f}}if(e){let h=0,d=[];for(let u=0;u<n.length;++u){let f=n[u].index;for(let g=0;g<f.count;++g)d.push(f.getX(g)+h);h+=n[u].attributes.position.count}l.setIndex(d)}for(let h in r){let d=Af(r[h]);if(!d)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed while trying to merge the "+h+" attribute."),null;l.setAttribute(h,d)}for(let h in a){let d=a[h][0].length;if(d!==0){l.morphAttributes=l.morphAttributes||{},l.morphAttributes[h]=[];for(let u=0;u<d;++u){let f=[];for(let _=0;_<a[h].length;++_)f.push(a[h][_][u]);let g=Af(f);if(!g)return console.error("THREE.BufferGeometryUtils: .mergeGeometries() failed while trying to merge the "+h+" morphAttribute."),null;l.morphAttributes[h].push(g)}}}return l}function Af(n){let t,e,i,s=-1,r=0;for(let c=0;c<n.length;++c){let h=n[c];if(t===void 0&&(t=h.array.constructor),t!==h.array.constructor)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.array must be of consistent array types across matching attributes."),null;if(e===void 0&&(e=h.itemSize),e!==h.itemSize)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.itemSize must be consistent across matching attributes."),null;if(i===void 0&&(i=h.normalized),i!==h.normalized)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.normalized must be consistent across matching attributes."),null;if(s===-1&&(s=h.gpuType),s!==h.gpuType)return console.error("THREE.BufferGeometryUtils: .mergeAttributes() failed. BufferAttribute.gpuType must be consistent across matching attributes."),null;r+=h.count*e}let a=new t(r),o=new ze(a,e,i),l=0;for(let c=0;c<n.length;++c){let h=n[c];if(h.isInterleavedBufferAttribute){let d=l/e;for(let u=0,f=h.count;u<f;u++)for(let g=0;g<e;g++){let _=h.getComponent(u,g);o.setComponent(u+d,g,_)}}else a.set(h.array,l);l+=h.count*e}return s!==void 0&&(o.gpuType=s),o}var Yl=null;function Ti(){if(Yl)return Yl;let n=l=>new Ce(l),t=va("planks"),e=va("log_side"),i=va("brick"),s=va("stone"),r=rr("iron"),a=rr("bone"),o=rr("gold");return Yl={wood:n({map:t.map,normalMap:t.normalMap,roughnessMap:t.roughnessMap}),darkwood:n({map:e.map,normalMap:e.normalMap,color:9075306,roughness:.9}),iron:n({map:r.map,roughnessMap:r.roughnessMap,metalness:.75}),bone:n({map:a.map,roughness:.75}),stone:n({map:i.map,normalMap:i.normalMap,roughnessMap:i.roughnessMap}),rock:n({map:s.map,normalMap:s.normalMap,roughness:.95}),gold:n({map:o.map,roughnessMap:o.roughnessMap,metalness:1}),wax:n({color:15129020,roughness:.55}),clay:n({color:9062954,roughness:.85}),clay2:n({color:7232062,roughness:.85}),crystal:n({color:6276847,emissive:1739974,emissiveIntensity:.9,roughness:.15,metalness:.1,transparent:!0,opacity:.92}),ore:n({color:14198336,metalness:.9,roughness:.35}),dark:n({color:328965,roughness:1}),web:new Le({map:Sf(),transparent:!0,depthWrite:!1,side:ke,opacity:.8}),banners:[0,1,2].map(l=>n({map:Tf(["#6d1510","#1b2d5e","#2a3d1c"][l],l),transparent:!0,alphaTest:.5,side:ke,roughness:.95}))},Yl}var ya=null;function lv(){if(ya)return ya;let n=document.createElement("canvas");n.width=64,n.height=128;let t=n.getContext("2d"),e=t.createRadialGradient(32,88,2,32,76,40);return e.addColorStop(0,"rgba(255,250,220,1)"),e.addColorStop(.25,"rgba(255,200,90,0.95)"),e.addColorStop(.55,"rgba(255,110,20,0.55)"),e.addColorStop(1,"rgba(255,60,0,0)"),t.fillStyle=e,t.beginPath(),t.moveTo(32,4),t.bezierCurveTo(58,60,60,110,32,124),t.bezierCurveTo(4,110,6,60,32,4),t.fill(),ya=new ti(n),ya.colorSpace=Ee,ya}function $l(n=1,t=16777215){let e=new Bs({map:lv(),color:t,blending:Be,depthWrite:!1,transparent:!0}),i=new Dr(e);return i.scale.set(.34*n,.6*n,1),i.userData.base=n,i}var Vh=class{constructor(){this.parts=new Map,this.m=new oe}add(t,e,i,s,r,a=0,o=0,l=0,c=1,h=1,d=1){let u=t.clone(),f=new _i(a,o,l,"YXZ");this.m.compose(new N(i,s,r),new xi().setFromEuler(f),new N(c,h,d)),u.applyMatrix4(this.m),this.parts.has(e)||this.parts.set(e,[]),this.parts.get(e).push(u)}local(t,e,i,s,r,a,o,l,c,h=0,d=0,u=0){let f=Math.cos(i.rot),g=Math.sin(i.rot),_=i.s||1,m=i.x+(s*f+a*g)*_,p=i.z+(-s*g+a*f)*_;this.add(t,e,m,i.y+r*_,p,h,i.rot+d,u,o*_,l*_,c*_)}bake(t){let e=new fe;for(let[i,s]of this.parts){let r=s.map(c=>c.index?c.toNonIndexed():c);for(let c of r)for(let h of Object.keys(c.attributes))["position","normal","uv"].includes(h)||c.deleteAttribute(h);let a=Rf(r,!1),o=i.startsWith("banner")?t.banners[+i.slice(6)]:t[i],l=new Tt(a,o);l.castShadow=i!=="web"&&!i.startsWith("banner"),l.receiveShadow=!0,e.add(l),s.forEach(c=>c.dispose())}return e}},he={box:new $e(1,1,1),cyl:new ei(.5,.5,1,12),cyl6:new ei(.5,.5,1,6),barrel:new ei(.3,.3,.82,14),cone:new Kn(.5,1,6),plane:new qi(1,1),sphere:new un(.5,8,6)};function If(n){let t=new Vh,e=new Ki(n.seed+555),i=[],s=[],r=(o,l,c,h,d,u,f=1)=>s.push({x:o,y:l,z:c,color:h,intensity:d,dist:u,flicker:f,phase:e.range(0,100)});for(let o of n.torches){let l=Math.atan2(o.nx,o.nz);t.add(he.box,"iron",o.x-o.nx*.1,o.y-.35,o.z-o.nz*.1,0,l,0,.16,.3,.04),t.add(he.cyl6,"darkwood",o.x-o.nx*.04,o.y-.2,o.z-o.nz*.04,.35,l,0,.07,.5,.07),t.add(he.cyl6,"iron",o.x,o.y+.04,o.z,0,0,0,.15,.1,.15);let c=$l(1,16769200);c.position.set(o.x+o.nx*.02,o.y+.3,o.z+o.nz*.02),i.push(c),r(o.x+o.nx*.35,o.y+.35,o.z+o.nz*.35,n.theme.torch,14,10)}for(let o of n.banners){let l=Math.atan2(o.nx,o.nz),c=e.int(0,2);t.add(he.plane,"banner"+c,o.x,o.y-.7,o.z,0,l,0,.8,1.6,1),t.add(he.cyl6,"iron",o.x+o.nx*.03,o.y+.12,o.z+o.nz*.03,0,l,Math.PI/2,.05,1,.05)}for(let o of n.cobwebs)t.add(he.plane,"web",o.x+.4,o.y+2.9,o.z+.4,-.6,Math.PI/4,0,1.3,1.3,1);for(let o of n.props)switch(o.type){case"barrel":t.local(he.barrel,"wood",o,0,.41,0,1,1,1),t.local(he.cyl,"iron",o,0,.2,0,.635,.05,.635),t.local(he.cyl,"iron",o,0,.62,0,.635,.05,.635),t.local(he.cyl,"darkwood",o,0,.825,0,.56,.02,.56);break;case"crate":t.local(he.box,"wood",o,0,.36,0,.72,.72,.72);for(let[l,c]of[[-1,-1],[1,-1],[-1,1],[1,1]])t.local(he.box,"darkwood",o,l*.33,.36,c*.33,.09,.74,.09);t.local(he.box,"darkwood",o,0,.36,.365,.9,.08,.02,0,0,.78);break;case"bones":for(let l=0;l<5;l++){let c=e.range(0,Math.PI*2),h=e.range(0,.3);t.local(he.cyl6,"bone",o,Math.cos(c)*h,.03,Math.sin(c)*h,.05,e.range(.25,.45),.05,Math.PI/2,e.range(0,3),0)}e.chance(.6)&&Cf(t,o,e.range(-.2,.2),e.range(-.2,.2));break;case"skull":Cf(t,o,0,0);break;case"candles":{let l=e.int(3,5),c=Math.cos(o.rot),h=Math.sin(o.rot);for(let d=0;d<l;d++){let u=e.range(0,Math.PI*2),f=e.range(.05,.3),g=e.range(.15,.4),_=Math.cos(u)*f,m=Math.sin(u)*f;t.local(he.cyl,"wax",o,_,g/2,m,.07,g,.07);let p=$l(.28,16773312);p.position.set(o.x+(_*c+m*h)*o.s,o.y+(g+.07)*o.s,o.z+(-_*h+m*c)*o.s),i.push(p)}r(o.x,o.y+.6,o.z,16760944,4,5,.6);break}case"rubble":for(let l=0;l<6;l++){let c=e.range(.12,.34);t.local(he.box,"rock",o,e.range(-.35,.35),c*.4,e.range(-.35,.35),c,c,c,e.range(0,1),e.range(0,3),e.range(0,1))}break;case"coffin":t.local(he.box,"darkwood",o,0,.22,0,.7,.44,1.6),t.local(he.box,"darkwood",o,.06,.48,.05,.74,.08,1.64,0,.12,.04),t.local(he.box,"iron",o,.06,.53,.2,.07,.02,.55,0,.12,.04),t.local(he.box,"iron",o,.06,.53,.32,.32,.02,.07,0,.12,.04);break;case"crystal":{let l=e.int(3,5);for(let c=0;c<l;c++){let h=e.range(0,Math.PI*2),d=e.range(.5,1.2);t.local(he.cone,"crystal",o,Math.cos(h)*.15,d/2-.05,Math.sin(h)*.15,.3,d,.3,Math.cos(h)*.4,0,Math.sin(h)*.4)}break}case"cart":t.local(he.box,"iron",o,0,.45,0,1,.5,.7);for(let[l,c]of[[-.35,.38],[.35,.38],[-.35,-.38],[.35,-.38]])t.local(he.cyl,"iron",o,l,.16,c,.32,.08,.32,Math.PI/2);for(let l=0;l<6;l++)t.local(he.sphere,"ore",o,e.range(-.3,.3),.72,e.range(-.2,.2),.26,.22,.26);break;case"anvil":t.local(he.box,"rock",o,0,.2,0,.45,.4,.45),t.local(he.box,"iron",o,0,.47,0,.26,.16,.2),t.local(he.box,"iron",o,0,.6,0,.7,.18,.3),t.local(he.cone,"iron",o,.5,.62,0,.2,.34,.2,0,0,-Math.PI/2);break}return{group:t.bake(Ti()),flames:i,lights:s}}function Cf(n,t,e,i){let s={...t,rot:t.rot+.5};n.local(he.box,"bone",s,e,.1,i,.22,.2,.25),n.local(he.box,"dark",s,e-.05,.12,i+.121,.06,.05,.02),n.local(he.box,"dark",s,e+.05,.12,i+.121,.06,.05,.02)}var cv=`
attribute float size; attribute vec4 pcolor;
varying vec4 vColor;
uniform float uScale;
void main(){
  vColor = pcolor;
  vec4 mv = modelViewMatrix * vec4(position, 1.0);
  gl_PointSize = size * uScale / -mv.z;
  gl_Position = projectionMatrix * mv;
}`,hv=`
uniform sampler2D map; varying vec4 vColor;
void main(){
  vec4 t = texture2D(map, gl_PointCoord);
  gl_FragColor = vec4(vColor.rgb, vColor.a * t.a);
  if (gl_FragColor.a < 0.004) discard;
}`,Zl=class{constructor(t,e,i){this.max=t,this.n=0,this.p=new Float32Array(t*3),this.v=new Float32Array(t*3),this.c=new Float32Array(t*4),this.s=new Float32Array(t),this.life=new Float32Array(t),this.maxLife=new Float32Array(t),this.size0=new Float32Array(t),this.size1=new Float32Array(t),this.grav=new Float32Array(t),this.drag=new Float32Array(t),this.col0=new Float32Array(t*4);let s=new ce;this.aPos=new ze(this.p,3),this.aPos.setUsage(ua),this.aCol=new ze(this.c,4),this.aCol.setUsage(ua),this.aSize=new ze(this.s,1),this.aSize.setUsage(ua),s.setAttribute("position",this.aPos),s.setAttribute("pcolor",this.aCol),s.setAttribute("size",this.aSize),s.boundingSphere=new vi(new N,1e5),this.uniforms={map:{value:i},uScale:{value:400}};let r=new Te({uniforms:this.uniforms,vertexShader:cv,fragmentShader:hv,transparent:!0,depthWrite:!1,blending:e?Be:Nn});this.points=new zr(s,r),this.points.frustumCulled=!1,this.points.renderOrder=5,s.setDrawRange(0,0)}emit(t,e,i,s,r,a,o,l,c,h,d,u,f,g=0,_=0){let m=this.n;m>=this.max?m=Math.floor(Math.random()*this.max):this.n++,this.p[m*3]=t,this.p[m*3+1]=e,this.p[m*3+2]=i,this.v[m*3]=s,this.v[m*3+1]=r,this.v[m*3+2]=a,this.life[m]=o,this.maxLife[m]=o,this.size0[m]=l,this.size1[m]=c,this.col0[m*4]=h,this.col0[m*4+1]=d,this.col0[m*4+2]=u,this.col0[m*4+3]=f,this.grav[m]=g,this.drag[m]=_}update(t){let e=0;for(;e<this.n;){if(this.life[e]-=t,this.life[e]<=0){this.copy(this.n-1,e),this.n--;continue}let s=1-this.life[e]/this.maxLife[e],r=Math.exp(-this.drag[e]*t);this.v[e*3]*=r,this.v[e*3+2]*=r,this.v[e*3+1]=this.v[e*3+1]*r-this.grav[e]*t,this.p[e*3]+=this.v[e*3]*t,this.p[e*3+1]+=this.v[e*3+1]*t,this.p[e*3+2]+=this.v[e*3+2]*t,this.p[e*3+1]<-.95&&this.grav[e]>0&&(this.p[e*3+1]=-.95,this.v[e*3+1]*=-.3),this.s[e]=this.size0[e]+(this.size1[e]-this.size0[e])*s;let a=s<.1?s/.1:1-(s-.1)/.9;this.c[e*4]=this.col0[e*4],this.c[e*4+1]=this.col0[e*4+1],this.c[e*4+2]=this.col0[e*4+2],this.c[e*4+3]=this.col0[e*4+3]*a,e++}this.points.geometry.setDrawRange(0,this.n),this.aPos.needsUpdate=!0,this.aCol.needsUpdate=!0,this.aSize.needsUpdate=!0}copy(t,e){if(t!==e){for(let i=0;i<3;i++)this.p[e*3+i]=this.p[t*3+i],this.v[e*3+i]=this.v[t*3+i];for(let i=0;i<4;i++)this.c[e*4+i]=this.c[t*4+i],this.col0[e*4+i]=this.col0[t*4+i];this.s[e]=this.s[t],this.life[e]=this.life[t],this.maxLife[e]=this.maxLife[t],this.size0[e]=this.size0[t],this.size1[e]=this.size1[t],this.grav[e]=this.grav[t],this.drag[e]=this.drag[t]}}clear(){this.n=0,this.points.geometry.setDrawRange(0,0)}},Jl=class{constructor(t){let e=bf();this.add=new Zl(3e3,!0,e),this.norm=new Zl(2e3,!1,e),t.add(this.add.points),t.add(this.norm.points)}setScale(t){this.add.uniforms.uScale.value=t,this.norm.uniforms.uScale.value=t}update(t){this.add.update(t),this.norm.update(t)}clear(){this.add.clear(),this.norm.clear()}attach(t){t.add(this.add.points),t.add(this.norm.points)}sparks(t,e,i,s=10,r=[1,.7,.3],a=5){for(let o=0;o<s;o++){let l=Math.random()*Math.PI*2,c=Math.random()*.8+.2,h=a*(.4+Math.random());this.add.emit(t,e,i,Math.cos(l)*h*(1-c*.5),c*h,Math.sin(l)*h*(1-c*.5),.3+Math.random()*.4,.12,.02,r[0],r[1],r[2],1,12,2)}}blood(t,e,i,s=8,r=[.35,.05,.04]){for(let a=0;a<s;a++){let o=Math.random()*Math.PI*2,l=1+Math.random()*3;this.norm.emit(t,e,i,Math.cos(o)*l,1+Math.random()*3,Math.sin(o)*l,.5+Math.random()*.5,.14,.08,r[0],r[1],r[2],1,12,1)}}dust(t,e,i,s=10,r=[.45,.42,.38],a=.5,o=1){for(let l=0;l<s;l++){let c=Math.random()*Math.PI*2,h=Math.random()*1.5*a;this.norm.emit(t+Math.cos(c)*a*.5,e,i+Math.sin(c)*a*.5,Math.cos(c)*h,Math.random()*o,Math.sin(c)*h,.8+Math.random()*.8,.3,.9,r[0],r[1],r[2],.35,-.2,2)}}fire(t,e,i,s=1,r=.1,a=[1,.5,.15],o=.5){for(let l=0;l<s;l++)this.add.emit(t+(Math.random()-.5)*r,e,i+(Math.random()-.5)*r,(Math.random()-.5)*.3,.8+Math.random()*1.2,(Math.random()-.5)*.3,.35+Math.random()*.4,o,.05,a[0],a[1],a[2],.6,-.5,1)}ember(t,e,i,s=[1,.55,.2]){this.add.emit(t,e,i,(Math.random()-.5)*.4,.6+Math.random()*.8,(Math.random()-.5)*.4,1.2+Math.random()*1.5,.06,.02,s[0],s[1],s[2],1,-.1,.5)}ring(t,e,i,s,r,a,o=4,l=.3){for(let c=0;c<r;c++){let h=c/r*Math.PI*2;this.add.emit(t+Math.cos(h)*s*.2,e,i+Math.sin(h)*s*.2,Math.cos(h)*o,.3+Math.random()*.5,Math.sin(h)*o,s/o,l,l*.3,a[0],a[1],a[2],1,0,0)}}burst(t,e,i,s,r,a=3,o=.6,l=.25,c=0){for(let h=0;h<s;h++){let d=Math.random()*Math.PI*2,u=Math.random()*Math.PI-Math.PI/2,f=a*(.3+Math.random()*.7);this.add.emit(t,e,i,Math.cos(d)*Math.cos(u)*f,Math.sin(u)*f+1,Math.sin(d)*Math.cos(u)*f,o*(.6+Math.random()*.6),l,l*.1,r[0],r[1],r[2],1,c,1.5)}}mote(t,e,i){this.norm.emit(t,e,i,(Math.random()-.5)*.15,(Math.random()-.3)*.1,(Math.random()-.5)*.15,4+Math.random()*4,.05,.05,.8,.75,.65,.35,0,0)}};var Gh=new Map;function uv(n,t,e){let i=n.toFixed(3)+","+t.toFixed(3)+","+e.toFixed(3);return Gh.has(i)||Gh.set(i,new $e(n,t,e)),Gh.get(i)}function rs(n,t={}){if(n==="dark")return new Ce({color:328708,roughness:1});if(n==="glow")return new Ce({color:t.color||16724e3,emissive:t.color||16724e3,emissiveIntensity:t.intensity||4,roughness:.5});let e=rr(n),i=["steel","steel_dark","gold","iron"].includes(n),s=new Ce({map:e.map,roughnessMap:e.roughnessMap,metalness:i?n==="iron"?.45:n==="gold"?.8:.55:0,color:t.color||16777215});return e.emissiveMap&&(s.emissiveMap=e.emissiveMap,s.emissive=new Ut(16777215),s.emissiveIntensity=t.emi||2.5),s}var pi=class{constructor(t){this.type=t,this.root=new fe,this.mats=[],this.meshes=[],this.flashT=0}mat(t,e){let i=rs(t,e);return i.userData.baseEmissive=i.emissive.clone(),i.userData.baseEI=i.emissiveIntensity,this.mats.push(i),i}part(t,e,i,s,r,a=0,o=0,l=0){let c=new Tt(uv(e,i,s),r);return c.position.set(a,o,l),c.castShadow=!0,c.receiveShadow=!0,t.add(c),this.meshes.push(c),c}pivot(t,e=0,i=0,s=0){let r=new fe;return r.position.set(e,i,s),t.add(r),r}flash(t){for(let e of this.mats)e.userData.baseEmissive&&(t>0?(e.emissive.setRGB(t,t*.95,t*.9),e.emissiveIntensity=1,e.emissiveMap&&(e.emissiveMap=e.emissiveMap)):(e.emissive.copy(e.userData.baseEmissive),e.emissiveIntensity=e.userData.baseEI))}tint(t,e){for(let i of this.mats)i.userData.baseColor||(i.userData.baseColor=i.color.clone()),i.color.copy(i.userData.baseColor).lerp(t,e)}fade(t){for(let e of this.mats)e.transparent=t<1,e.opacity=t,e.depthWrite=t>.5}dispose(){for(let t of this.mats)t.dispose()}};function Ma(n,t,e){let i=new fe,s=(d,u,f,g,_,m,p)=>t.part(i,d,u,f,g,_,m,p),r=t.mat("steel"),a=t.mat("leather"),o=t.mat("gold"),l=t.mat("wood"),c=t.mat("iron"),h=e?t.mat("glow",{color:e,intensity:1.2}):r;if(n==="espada"||n==="adagas"){let d=n==="espada"?.85:.42;s(.05,.2,.05,a,0,0,0),s(.08,.07,.08,o,0,-.12,0),s(n==="espada"?.32:.18,.05,.07,o,0,.12,0),s(.075,d,.022,h,0,.14+d/2,0),s(.045,.08,.018,h,0,.16+d,0)}else if(n==="machado")s(.055,.95,.055,l,0,.3,0),s(.04,.3,.28,h,0,.66,-.13),s(.05,.12,.1,c,0,.66,.06);else if(n==="martelo")s(.06,1,.06,l,0,.35,0),s(.26,.24,.42,c,0,.86,0),s(.27,.05,.43,o,0,.86,0);else if(n==="lanca")s(.05,1.7,.05,l,0,.45,0),s(.09,.3,.02,h,0,1.42,0),s(.14,.05,.05,o,0,1.28,0);else if(n==="cajado"){s(.06,1.7,.06,l,0,.3,0);let d=new Tt(new un(.12,12,10),t.mat("glow",{color:e||11555071,intensity:5}));d.position.y=1.25,i.add(d),t.meshes.push(d),s(.2,.05,.05,c,0,1.12,0)}return i}function Kl(n,t){let e=new fe,i=n.mat("wood"),s=n.mat("bone",{color:14540253});if(t)return n.part(e,.08,.08,.6,i,0,0,.1),n.part(e,.7,.05,.06,n.mat("iron"),0,0,.32),n.part(e,.66,.01,.01,s,0,0,.26),e;let r=[[0,0,0],[.18,.02,.25],[.34,.07,.5],[-.18,.02,-.25],[-.34,.07,-.5]];for(let[a,o,l]of r){let c=n.part(e,.05,.2,.05,i,0,a,o);c.rotation.x=l}return n.part(e,.01,.8,.01,s,0,0,-.02),e}function ba(n,t){let e=new pi(n),i=t.scale||1;e.root.scale.setScalar(i),e.legH=t.legH,e.hips=e.pivot(e.root,0,t.legH,0),e.legL=e.pivot(e.hips,-t.legX,0,0),e.legR=e.pivot(e.hips,t.legX,0,0);for(let r of[e.legL,e.legR])e.part(r,t.legW,t.legH,t.legW+.02,t.mLeg,0,-t.legH/2,0),t.mBoot&&e.part(r,t.legW+.03,.14,t.legW+.1,t.mBoot,0,-t.legH+.07,.03);e.torso=e.pivot(e.hips,0,0,0),e.part(e.torso,t.torsoW,t.torsoH,t.torsoD,t.mTorso,0,t.torsoH/2,0),e.head=e.pivot(e.torso,0,t.torsoH,0),e.part(e.head,t.headS,t.headS,t.headS,t.mHead,0,t.headS/2,0);let s=t.torsoW/2+t.armW/2+.01;e.armL=e.pivot(e.torso,-s,t.torsoH-.07,0),e.armR=e.pivot(e.torso,s,t.torsoH-.07,0);for(let r of[e.armL,e.armR])e.part(r,t.armW,t.armH,t.armW,t.mArm,0,-t.armH/2+.05,0),t.mHand&&e.part(r,t.armW+.02,.13,t.armW+.02,t.mHand,0,-t.armH+.02,0);return e.handR=e.pivot(e.armR,0,-t.armH+.02,.02),e.handL=e.pivot(e.armL,0,-t.armH+.02,.02),e.baseArm=t.baseArm||0,e}function Pf(){let n=new pi("hero"),t={steel:n.mat("steel"),dark:n.mat("steel_dark"),leather:n.mat("leather"),blue:n.mat("cloth_blue"),red:n.mat("cloth_red"),black:n.mat("dark"),gold:n.mat("gold")},e=ba("hero",{legH:.72,legX:.13,legW:.2,torsoW:.52,torsoH:.6,torsoD:.3,headS:.42,armW:.17,armH:.58,mLeg:t.dark,mBoot:t.leather,mTorso:t.steel,mHead:t.steel,mArm:t.dark,mHand:t.leather});return e.mats.push(...n.mats),e.m=t,e.part(e.torso,.4,.46,.02,t.blue,0,.28,.16),e.part(e.torso,.1,.12,.02,t.gold,0,.36,.172),e.part(e.torso,.55,.08,.33,t.leather,0,.04,0),e.part(e.head,.3,.05,.02,t.black,0,.23,.212),e.part(e.head,.05,.16,.02,t.black,0,.14,.212),e.plume=e.part(e.head,.07,.14,.4,t.red,0,.48,-.02),e.pauldrons=[e.part(e.armL,.28,.17,.34,t.steel,0,.03,0),e.part(e.armR,.28,.17,.34,t.steel,0,.03,0)],e.cape=e.pivot(e.torso,0,.58,-.17),e.part(e.cape,.5,.95,.03,t.red,0,-.47,0),e.weapon=null,e.bow=null,e}function Lf(n,t){let e={couro:[9068608,6965808],malha:[11580602,9080468],placas:[15265010,10527916],andarilho:[5929562,3820090],obsidiana:[6965898,3811914]}[t.look]||[16777215,16777215];n.m.steel.color.set(e[0]),n.m.dark.color.set(e[1]);for(let i of n.mats)i.userData.baseColor&&(i.userData.baseColor=i.color.clone())}function Df(n,t,e){n.weapon&&n.handR.remove(n.weapon),n.weapon2&&(n.handL.remove(n.weapon2),n.weapon2=null),n.weapon=Ma(t,n,e),n.weapon.rotation.x=Math.PI/2,n.handR.add(n.weapon),t==="adagas"&&(n.weapon2=Ma("adagas",n,e),n.weapon2.rotation.x=Math.PI/2,n.handL.add(n.weapon2))}function Nf(n,t){n.bow&&n.handL.remove(n.bow),n.bow=Kl(n,t),n.bow.visible=!1,n.handL.add(n.bow)}function Uf(n,t=3832789){let e=new Le({color:t,depthFunc:Is,depthWrite:!1});for(let i of[...n.meshes]){let s=new Tt(i.geometry,e);s.renderOrder=1,s.userData.sil=!0,i.add(s),i.renderOrder=2}n.silMat=e}function Wh(n=1,t=!1){let e=new pi("carnical"),i=e.mat("skin_rot"),s=e.mat("rags"),r=e.mat("glow",{color:10157882,intensity:5}),a=e.mat("dark"),o=ba("carnical",{scale:n,legH:.68,legX:.13,legW:.2,torsoW:t?.66:.5,torsoH:.62,torsoD:.3,headS:.4,armW:.16,armH:.64,mLeg:s,mTorso:s,mHead:i,mArm:i,baseArm:-1.35});return o.mats.push(...e.mats),o.part(o.head,.08,.05,.02,r,-.09,.24,.201),o.part(o.head,.08,.05,.02,r,.09,.24,.201),o.part(o.head,.26,.07,.02,a,0,.09,.201),o.part(o.torso,.3,.2,.02,i,.05,.45,.155),t&&(o.part(o.torso,.72,.18,.36,s,0,.62,-.02),o.part(o.torso,.3,.25,.2,i,0,.5,-.2)),o.head.rotation.z=.15,o}function dv(n=1){let t=new pi("esqueleto"),e=t.mat("bone"),i=t.mat("dark"),s=t.mat("glow",{color:16734768,intensity:3}),r=t.mat("iron"),a=ba("esqueleto",{scale:n,legH:.72,legX:.1,legW:.09,torsoW:.08,torsoH:.6,torsoD:.08,headS:.36,armW:.08,armH:.6,mLeg:e,mTorso:e,mHead:e,mArm:e});a.mats.push(...t.mats);for(let o=0;o<4;o++)a.part(a.torso,.4-o*.04,.045,.22,e,0,.5-o*.1,.02);return a.part(a.torso,.3,.1,.16,e,0,.02,0),a.part(a.torso,.46,.06,.1,e,0,.58,0),a.part(a.head,.09,.08,.02,i,-.08,.2,.181),a.part(a.head,.09,.08,.02,i,.08,.2,.181),a.part(a.head,.04,.03,.01,s,-.08,.2,.19),a.part(a.head,.04,.03,.01,s,.08,.2,.19),a.part(a.head,.24,.06,.02,i,0,.06,.181),a.part(a.head,.38,.1,.38,r,0,.36,0),a.bow=Kl(a),a.handL.add(a.bow),a.bow.rotation.x=Math.PI/2,a.bow.rotation.z=0,a.bow.rotation.set(Math.PI/2,0,0),a}function fv(n=1){let t=new pi("necromante"),e=t.mat("robe"),i=t.mat("cloth_purple"),s=t.mat("dark"),r=t.mat("glow",{color:12607743,intensity:6}),a=t.mat("bone",{color:11182240}),o=ba("necromante",{scale:n,legH:.7,legX:.12,legW:.2,torsoW:.54,torsoH:.66,torsoD:.34,headS:.4,armW:.18,armH:.62,mLeg:e,mTorso:e,mHead:e,mArm:e,mHand:a});return o.mats.push(...t.mats),o.skirt=o.part(o.hips,.62,.72,.42,e,0,-.34,0),o.part(o.torso,.14,.62,.02,i,0,.3,.175),o.part(o.head,.3,.26,.02,s,0,.17,.205),o.part(o.head,.06,.04,.01,r,-.07,.2,.215),o.part(o.head,.06,.04,.01,r,.07,.2,.215),o.part(o.head,.46,.1,.5,e,0,.44,-.03),o.staff=Ma("cajado",o,11555071),o.staff.position.y=-.1,o.handR.add(o.staff),o}function pv(n=1){let t=new pi("esporo");t.root.scale.setScalar(n);let e=t.mat("fungus"),i=t.mat("fungus",{color:11550768}),s=t.mat("glow",{color:16769088,intensity:5}),r=t.mat("dark");t.body=t.pivot(t.root,0,.2,0),t.part(t.body,.7,.62,.7,e,0,.36,0),t.cap=t.part(t.body,.98,.34,.98,i,0,.8,0),t.part(t.body,.7,.12,.7,i,0,1,0),t.part(t.body,.1,.1,.02,s,-.14,.46,.351),t.part(t.body,.1,.1,.02,s,.14,.46,.351),t.part(t.body,.3,.06,.02,r,0,.28,.351),t.legs=[];for(let[a,o]of[[-.22,.2],[.22,.2],[-.22,-.2],[.22,-.2]]){let l=t.pivot(t.root,a,.24,o);t.part(l,.16,.26,.16,e,0,-.12,0),t.legs.push(l)}return t}function Xh(n=1,t=!1){let e=new pi("aranha");e.root.scale.setScalar(n);let i=e.mat("chitin",{color:t?12622032:16777215}),s=e.mat("glow",{color:t?13648127:16719888,intensity:6}),r=e.mat("hair");e.body=e.pivot(e.root,0,.42,0),e.abdomen=e.part(e.body,.78,.6,.86,i,0,.12,-.5),e.part(e.body,.5,.08,.6,r,0,.44,-.5),t&&(e.part(e.body,.12,.05,.2,s,0,.43,-.42),e.part(e.body,.2,.05,.1,s,0,.43,-.6)),e.part(e.body,.56,.34,.56,i,0,0,.1),e.headM=e.part(e.body,.4,.3,.3,i,0,.02,.48);for(let[a,o]of[[-.1,.1],[.1,.1],[-.15,.03],[.15,.03],[-.06,.02],[.06,.02]])e.part(e.body,.06,.06,.02,s,a,o,.635);e.part(e.body,.06,.16,.06,r,-.08,-.12,.62),e.part(e.body,.06,.16,.06,r,.08,-.12,.62),e.legs=[];for(let a=-1;a<=1;a+=2)for(let o=0;o<4;o++){let l=e.pivot(e.body,a*.26,0,.3-o*.18);l.rotation.y=a*(-.6+o*.4);let c=e.pivot(l,0,0,0);c.rotation.z=a*.7,e.part(c,.07,.07,.07,i,0,0,0);let h=e.part(c,.55,.07,.07,i,a*.27,0,0),d=e.pivot(c,a*.54,0,0);d.rotation.z=-a*1.9,e.part(d,.62,.06,.06,i,a*.3,0,0),e.legs.push({hip:l,up:c,knee:d,side:a,i:o,seg1:h})}return e}function mv(n=2.6){let t=new pi("colosso"),e=t.mat("obsidian",{emi:.8}),i=t.mat("glow",{color:16747040,intensity:2.5}),s=t.mat("iron"),r=ba("colosso",{scale:n,legH:.7,legX:.18,legW:.3,torsoW:.8,torsoH:.7,torsoD:.46,headS:.36,armW:.3,armH:.8,mLeg:e,mTorso:e,mHead:e,mArm:e,mHand:s});return r.mats.push(...t.mats),r.part(r.torso,1,.3,.5,e,0,.62,-.04),r.part(r.head,.24,.05,.02,i,0,.2,.181),r.part(r.torso,.3,.3,.02,i,0,.4,.231),r.part(r.armL,.4,.34,.4,e,0,-.66,0),r.part(r.armR,.4,.34,.4,e,0,-.66,0),r.head.position.z=.08,r}function Ff(n,t=!1){switch(n){case"carnical":return Wh(1);case"esqueleto":return dv(1);case"necromante":return fv(1);case"esporo":return pv(1);case"aranha":return Xh(.9);case"aranhinha":return Xh(.5);case"gorran":return Wh(2.3,!0);case"veshkara":return Xh(2.4,!0);case"colosso":return mv(2.5)}return Wh(1)}function as(n,t,e,i){if(n.legs&&n.type==="aranha"){for(let r of n.legs){let a=t*1.6+r.i*Math.PI/2+(r.side>0?Math.PI:0);r.hip.rotation.x=Math.sin(a)*.35*e,r.up.rotation.z=r.side*(.7+Math.max(0,Math.cos(a))*.35*e)}n.body.position.y=.42+Math.abs(Math.sin(t*3.2))*.03*e,n.abdomen&&(n.abdomen.rotation.x=Math.sin(i*2)*.05);return}if(n.type==="esporo"){n.legs.forEach((r,a)=>{r.rotation.x=Math.sin(t*2+(a%2?Math.PI:0)+(a>1?Math.PI:0))*.7*e}),n.body.position.y=.2+Math.abs(Math.sin(t*2))*.07*e,n.body.rotation.z=Math.sin(t)*.08*e;return}let s=Math.sin(t);n.legL.rotation.x=s*.75*e,n.legR.rotation.x=-s*.75*e,n.armL.rotation.x=n.baseArm-s*.55*e+(n.baseArm?Math.sin(i*3)*.08:0),n.armR.rotation.x=n.baseArm+s*.55*e+(n.baseArm?Math.sin(i*3+1)*.08:0),n.armL.rotation.z=0,n.armR.rotation.z=0,n.armL.rotation.y=0,n.armR.rotation.y=0,n.hips.position.y=n.legH+Math.abs(Math.cos(t))*.045*e,n.torso.rotation.set(.05*e,0,0),n.hips.rotation.set(0,0,0),n.skirt&&(n.skirt.rotation.x=-s*.1*e),e<.1&&(n.torso.rotation.x=Math.sin(i*1.8)*.02,n.armL.rotation.z=-.05-Math.sin(i*1.8)*.02,n.armR.rotation.z=.05+Math.sin(i*1.8)*.02)}var mn={comum:{name:"Comum",color:"#cfc8b8",hex:13617336,mult:1,affixes:0},raro:{name:"Raro",color:"#4fb3ff",hex:4169983,mult:1.25,affixes:1},unico:{name:"\xDAnico",color:"#ffb92e",hex:16752670,mult:1.55,affixes:2}},os={espada:{name:"Espada",dmg:11,cd:.42,range:2,arc:2,combo:3},machado:{name:"Machado",dmg:18,cd:.66,range:2.1,arc:2.3,combo:2},adagas:{name:"Adagas G\xEAmeas",dmg:6.5,cd:.24,range:1.7,arc:1.6,combo:4},martelo:{name:"Martelo de Guerra",dmg:30,cd:1,range:2.4,arc:2.9,combo:1,knock:2.5},lanca:{name:"Lan\xE7a",dmg:14,cd:.55,range:3.1,arc:.9,combo:2}},Sa={arco:{name:"Arco Curto",dmg:9,cd:.38,speed:24,pierce:0},arcolongo:{name:"Arco Longo",dmg:17,cd:.78,speed:30,pierce:1},besta:{name:"Besta Pesada",dmg:25,cd:1.1,speed:34,pierce:2}},ar={couro:{name:"Gib\xE3o de Couro",hp:10,dr:.05,speed:.05,look:"couro"},malha:{name:"Cota de Malha",hp:25,dr:.12,speed:0,look:"malha"},placas:{name:"Armadura de Placas",hp:45,dr:.2,speed:-.06,look:"placas"},andarilho:{name:"Manto do Andarilho",hp:15,dr:.06,speed:.1,look:"andarilho"},obsidiana:{name:"Coura\xE7a de Obsidiana",hp:35,dr:.17,speed:-.02,look:"obsidiana"}},wa={chamas:{name:"Tomo das Chamas",cd:12,desc:"Libera um anel de fogo que queima os inimigos pr\xF3ximos.",color:"#ff7a2e"},raio:{name:"Rel\xE2mpago Engarrafado",cd:10,desc:"Um raio salta entre at\xE9 6 inimigos.",color:"#8fd8ff"},estandarte:{name:"Estandarte de Guerra",cd:24,desc:"Finca um estandarte: +40% de dano e cura cont\xEDnua na \xE1rea.",color:"#ff4a4a"},vendaval:{name:"Chifre do Vendaval",cd:8,desc:"Empurra e atordoa todos os inimigos ao redor.",color:"#c8e8d0"},laminas:{name:"L\xE2minas Espectrais",cd:18,desc:"Tr\xEAs l\xE2minas fantasmas giram ao seu redor por 8 s.",color:"#9a8cff"},gelo:{name:"Totem G\xE9lido",cd:16,desc:"Congela os inimigos pr\xF3ximos por 3 segundos.",color:"#8ff0ff"}},qh={melee:[["chamas","Chamejante","Golpes incendeiam o alvo"],["vampiro","Vamp\xEDrico|Vamp\xEDrica","Cada golpe recupera vida"],["critico","Afiado|Afiada","+15% de chance de cr\xEDtico"],["veloz","Ligeiro|Ligeira","Ataques 20% mais r\xE1pidos"],["trovao","do Trov\xE3o","20% de chance de lan\xE7ar um raio"]],bow:[["multi","Tr\xEDplice","Dispara tr\xEAs flechas em leque"],["perfura","Perfurante","Flechas atravessam +2 inimigos"],["explosiva","Explosivo|Explosiva","Flechas explodem ao acertar"],["chamas","\xCDgneo|\xCDgnea","Flechas incendeiam o alvo"]],armor:[["espinhos","de Espinhos","Devolve 40% do dano corpo a corpo"],["regen","Restaurador|Restauradora","Regenera 1,5 de vida por segundo"],["agil","\xC1gil","Rolamento recarrega 40% mais r\xE1pido"],["guarda","Guardi\xE3o|Guardi\xE3","+6% de redu\xE7\xE3o de dano"]],artifact:[["poder","Potente","+35% de poder"],["recarga","Veloz","Recarga 25% menor"]]},zf={espada:["L\xE2mina do Crep\xFAsculo","Presa de Valdor","Juramento Partido"],machado:["Machado do Carrasco","Racha-Ossos","F\xFAria do Norte"],adagas:["Garras da V\xEDbora","Sussurros G\xEAmeos","Ferroada Noturna"],martelo:["Martelo do Trov\xE3o","Quebra-Montanhas","Sino do Ju\xEDzo"],lanca:["Lan\xE7a do Alvorecer","Presa do Drag\xE3o","Vigia Eterna"],arco:["Arco Sussurrante","Corda do Vento","Asa de Corvo"],arcolongo:["Arco das Estrelas","Longa Vig\xEDlia","Arco do Ca\xE7ador P\xE1lido"],besta:["Besta do Inquisidor","Punho de Ferro","Vi\xFAva Negra"],couro:["Pele do Lobo Sombrio","Gib\xE3o do Ladino"],malha:["Cota do Cruzado","Malha de Mithral"],placas:["\xC9gide R\xFAnica","Basti\xE3o de Valdor"],andarilho:["Manto do Viajante Eterno","V\xE9u da N\xE9voa"],obsidiana:["Cora\xE7\xE3o da Forja","Carapa\xE7a do Vulc\xE3o"]};function gv(n,t=0){let e=n.next();return e<.05+t*.15?"unico":e<.3+t*.3?"raro":"comum"}function or(n,t,e={}){let i=e.cat||n.weighted([["melee",4],["bow",2],["armor",3],["artifact",2]]),s=e.rarity||gv(n,e.bonus||0),r=mn[s],a=(1+.32*(t-1))*n.range(.92,1.1)*r.mult,o={melee:os,bow:Sa,armor:ar,artifact:wa}[i],l=e.kind||n.pick(Object.keys(o)),c=o[l],h=[],d=[...qh[i]];for(let f=0;f<r.affixes&&d.length;f++)h.push(d.splice(Math.floor(n.next()*d.length),1)[0][0]);let u={id:Math.floor(n.next()*1e9),cat:i,kind:l,rarity:s,pw:a,affixes:h,floor:t};return i==="melee"&&(u.dmg=Math.round(c.dmg*a*10)/10),i==="bow"&&(u.dmg=Math.round(c.dmg*a*10)/10),i==="armor"&&(u.hp=Math.round(c.hp*a),u.dr=Math.min(.45,c.dr*(.9+.1*a)+(h.includes("guarda")?.06:0))),i==="artifact"&&(u.power=a*(h.includes("poder")?1.35:1)),u.name=xv(u,n),u}function xv(n,t){let e={melee:os,bow:Sa,armor:ar,artifact:wa}[n.cat][n.kind].name;if(n.rarity==="unico"&&zf[n.kind])return t.pick(zf[n.kind]);if(n.rarity==="raro"&&n.affixes.length){let i=qh[n.cat].find(l=>l[0]===n.affixes[0]);if(n.cat==="artifact")return e+" ("+i[1]+")";let[s,r]=i[1].includes("|")?i[1].split("|"):[i[1],i[1]],o=/^(Espada|Lança|Cota|Armadura|Couraça|Besta|Adagas)/.test(e)?r:s;return e.startsWith("Adagas")&&!o.startsWith("d")&&(o+="s"),e+" "+o}return e}function Bi(n){return n.cat==="melee"?os[n.kind].cd*(n.affixes.includes("veloz")?.8:1):n.cat==="bow"?Sa[n.kind].cd:n.cat==="artifact"?wa[n.kind].cd*(n.affixes.includes("recarga")?.75:1):0}function Bf(n){return n.affixes.map(t=>qh[n.cat].find(e=>e[0]===t)[2])}function Yh(n){let t=[];if(n.cat==="melee"){let e=os[n.kind];t.push(["Dano",n.dmg.toFixed(1)],["Velocidade",(1/Bi(n)).toFixed(1)+"/s"],["Alcance",e.range.toFixed(1)])}else if(n.cat==="bow")t.push(["Dano",n.dmg.toFixed(1)],["Velocidade",(1/Bi(n)).toFixed(1)+"/s"]);else if(n.cat==="armor"){let e=ar[n.kind];t.push(["Vida","+"+n.hp],["Prote\xE7\xE3o",Math.round(n.dr*100)+"%"]),e.speed&&t.push(["Movimento",(e.speed>0?"+":"")+Math.round(e.speed*100)+"%"])}else t.push(["Poder",Math.round(n.power*100)+"%"],["Recarga",Bi(n).toFixed(0)+" s"]);return t}function lr(n){return n?n.cat==="melee"||n.cat==="bow"?n.dmg/Bi(n)*(1+n.affixes.length*.12):n.cat==="armor"?n.hp+n.dr*200+n.affixes.length*8:n.power*10+n.affixes.length*3:0}function Of(n){return{melee:"Arma corpo a corpo",bow:"Arma \xE0 dist\xE2ncia",armor:"Armadura",artifact:"Artefato"}[n]}var kf=null,_v=()=>kf||(kf=wf()),Ei=(n,t,e,i)=>{let s=new Tt(new $e(n,t,e),i);return s.castShadow=!0,s.receiveShadow=!0,s},jl=class{constructor(t,e,i,s){this.game=t,this.x=e,this.z=i,this.big=s,this.opened=!1,this.t=0;let r=Ti(),a=new fe,o=s?1.15:.9,l=Ei(.9,.48,.6,r.wood);l.position.y=.24,a.add(l);for(let u of[-.44,.44]){let f=Ei(.06,.5,.62,s?r.gold:r.iron);f.position.set(u,.25,0),a.add(f)}this.lid=new fe,this.lid.position.set(0,.48,-.3),a.add(this.lid);let c=Ei(.92,.22,.62,r.wood);c.position.set(0,.11,.3),this.lid.add(c);let h=Ei(.94,.06,.64,s?r.gold:r.iron);h.position.set(0,.2,.3),this.lid.add(h);let d=Ei(.12,.14,.04,r.gold);d.position.set(0,.46,.31),a.add(d),a.scale.setScalar(o),a.position.set(e,t.floorAt(e,i),i),a.rotation.y=Math.PI/4+(Math.random()-.5)*.4,this.mesh=a,t.scene.add(a),this.glow=t.addLight(e,a.position.y+.9,i,16760928,0,3)}get prompt(){return this.opened?null:"Abrir ba\xFA"}interact(){if(this.opened)return;this.opened=!0,this.t=0;let t=this.game;t.audio.play("chest");let e=this.big?22+Math.floor(Math.random()*12):8+Math.floor(Math.random()*8);t.spawnGold(this.x,this.z,e,3),t.dropItem(this.x,this.z,{bonus:this.big?.7:.25}),this.big&&t.dropItem(this.x,this.z,{bonus:.3}),Math.random()<.6&&t.spawnLoot("arrows",this.x,this.z),this.glow.intensity=4}update(t){this.opened&&this.t<1&&(this.t+=t*2,this.lid.rotation.x=-1.9*Math.min(1,this.t)*(1+Math.sin(Math.min(1,this.t)*Math.PI)*.15),this.game.particles.sparks(this.x,this.mesh.position.y+.7,this.z,2,[1,.85,.4],3)),this.opened&&(this.glow.intensity=Math.max(0,this.glow.intensity-t*1.5))}},vv=new kr([[0,0],[.16,0],[.24,.1],[.27,.25],[.22,.42],[.12,.5],[.13,.58],[.16,.6],[0,.6]].map(n=>new xt(n[0],n[1])),12),tc=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.dead=!1,this.r=.3;let s=Ti();this.mesh=new Tt(vv,Math.random()<.5?s.clay:s.clay2),this.mesh.castShadow=!0,this.mesh.receiveShadow=!0;let r=.8+Math.random()*.5;this.mesh.scale.setScalar(r),this.mesh.position.set(e,t.floorAt(e,i),i),t.scene.add(this.mesh)}smash(){if(this.dead)return;this.dead=!0;let t=this.game;t.scene.remove(this.mesh),t.audio.play("pot"),t.particles.blood(this.x,this.mesh.position.y+.3,this.z,12,[.45,.25,.15]),t.particles.dust(this.x,this.mesh.position.y+.2,this.z,6);let e=Math.random();e<.45?t.spawnGold(this.x,this.z,1+Math.floor(Math.random()*4),1.5):e<.62?t.spawnLoot("arrows",this.x,this.z):e<.72&&t.spawnLoot("heart",this.x,this.z);let i=t.dg.idx(Math.floor(this.x),Math.floor(this.z));t.dg.solid[i]===2&&(t.dg.solid[i]=0)}},ec=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.lit=!1,this.t=0;let s=Ti(),r=new fe,a=Ei(.8,.7,.8,s.stone);a.position.y=.35,r.add(a);let o=Ei(.6,.2,.6,s.stone);o.position.y=.8,r.add(o);let l=new Tt(new ei(.55,.32,.32,10,1,!0),s.iron);l.material=s.iron,l.position.y=1.06,l.castShadow=!0,r.add(l);let c=new Tt(new ei(.5,.5,.05,10),rs("glow",{color:4198405,intensity:.4}));c.position.y=1.12,r.add(c),this.coal=c;let h=new Tt(new hn(.9,1.1,32),new Le({color:16751168,transparent:!0,opacity:.35,blending:Be,depthWrite:!1}));h.rotation.x=-Math.PI/2,h.position.y=.03,r.add(h),this.rune=h,r.position.set(e,t.floorAt(e,i),i),this.mesh=r,t.scene.add(r),this.flame=$l(3.2,16765088),this.flame.position.set(e,r.position.y+1.8,i),this.flame.visible=!1,t.scene.add(this.flame),this.light=t.addLight(e,r.position.y+2,i,16747066,0,14,1,!0)}get prompt(){return this.lit?null:"Acender o braseiro"}interact(){this.lit||(this.lit=!0,this.t=0,this.flame.visible=!0,this.coal.material.emissiveIntensity=5,this.game.audio.play("brazier"),this.game.particles.burst(this.x,this.mesh.position.y+1.3,this.z,60,[1,.6,.2],6,.9,.4),this.game.onBrazierLit(this))}update(t,e){if(this.rune.material.opacity=this.lit?.7:.25+Math.sin(e*2)*.1,!this.lit){Math.random()<t*4&&this.game.particles.ember(this.x+(Math.random()-.5)*.6,this.mesh.position.y+1.15,this.z+(Math.random()-.5)*.6);return}this.t+=t,this.light.intensity=Math.min(30,this.t*40)*(.9+Math.sin(e*13)*.05+Math.sin(e*7.3)*.05);let i=1+Math.sin(e*17)*.06;this.flame.scale.set(1.1*i,1.9/i,1),Math.random()<t*30&&this.game.particles.fire(this.x,this.mesh.position.y+1.2,this.z,1,.7,[1,.45,.12],.8),Math.random()<t*8&&this.game.particles.ember(this.x,this.mesh.position.y+1.6,this.z)}},ic=class{constructor(t,e){this.game=t,this.cells=e,this.closed=!0,this.h=0,this.target=0;let i=Ti();this.group=new fe;let s=new ei(.045,.045,3,6),r=new Set(e.map(a=>a.x+","+a.z));for(let a of e){let o=new fe,l=r.has(a.x+1+","+a.z)||r.has(a.x-1+","+a.z);for(let d=0;d<4;d++){let u=new Tt(s,i.iron);u.castShadow=!0;let f=-.375+d*.25;l?u.position.set(f,1.5,0):u.position.set(0,1.5,f),o.add(u)}let c=Ei(l?1:.08,.1,l?.08:1,i.iron);c.position.y=2.2,o.add(c);let h=Ei(l?1:.08,.1,l?.08:1,i.iron);h.position.y=.6,o.add(h),o.position.set(a.x+.5,t.floorAt(a.x+.5,a.z+.5),a.z+.5),this.group.add(o)}t.scene.add(this.group),this.key=new Set(e.map(a=>t.dg.idx(a.x,a.z)))}blocks(t){return this.closed&&this.key.has(t)}open(){this.closed&&(this.closed=!1,this.target=-3.1,this.game.audio.play("gate"),this.game.shake(.3))}close(){this.closed||(this.closed=!0,this.target=0,this.game.audio.play("gate"),this.game.shake(.4))}update(t){let e=this.h;if(this.h+=Math.sign(this.target-this.h)*Math.min(Math.abs(this.target-this.h),t*2.2),this.group.position.y=this.h,Math.abs(e-this.h)>.001&&Math.random()<.5){let i=this.cells[Math.floor(Math.random()*this.cells.length)];this.game.particles.dust(i.x+.5,this.game.floorAt(i.x+.5,i.z+.5),i.z+.5,2)}}},yv="varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }",Mv=`
uniform float t; varying vec2 vUv;
void main(){
  vec2 p = vUv*2.0-1.0; float r = length(p); if (r>1.0) discard;
  float a = atan(p.y,p.x);
  float s = sin(a*5.0 + r*12.0 - t*3.0)*0.5+0.5;
  float s2 = sin(a*3.0 - r*20.0 + t*2.0)*0.5+0.5;
  vec3 c = mix(vec3(0.25,0.05,0.6), vec3(0.3,0.9,1.0), s*s2);
  c += vec3(1.0)*pow(1.0-r,4.0);
  float alpha = smoothstep(1.0,0.8,r);
  gl_FragColor = vec4(c*1.6, alpha);
}`,nc=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.t=0;let s=new fe,r=t.floorAt(e,i);this.uni={t:{value:0}};let a=new Tt(new Jn(1.2,48),new Te({uniforms:this.uni,vertexShader:yv,fragmentShader:Mv,transparent:!0,side:ke,depthWrite:!1}));a.position.y=1.5,s.add(a),this.disc=a;let o=Ti(),l=new Tt(new Hr(1.3,.14,8,32),o.stone);l.position.y=1.5,l.castShadow=!0,s.add(l);for(let h=0;h<8;h++){let d=h/8*Math.PI*2,u=new Tt(new Ni(.1),rs("glow",{color:7397631,intensity:4}));u.position.set(Math.cos(d)*1.3,1.5+Math.sin(d)*1.3,.12),s.add(u)}let c=Ei(2.6,.2,.8,o.stone);c.position.y=.1,s.add(c),s.position.set(e,r,i),s.rotation.y=Math.PI/4,this.mesh=s,t.scene.add(s),this.light=t.addLight(e,r+1.5,i,7385343,20,12,.2,!0)}get prompt(){return"Entrar no portal"}interact(){this.game.enterPortal()}update(t){this.t+=t,this.uni.t.value=this.t;let e=Math.min(1,this.t*1.5);if(this.mesh.scale.setScalar(e),Math.random()<t*25){let i=Math.random()*Math.PI*2;this.game.particles.add.emit(this.x+Math.cos(i)*1.3*.7,this.mesh.position.y+1.5+Math.sin(i)*1.3,this.z-Math.cos(i)*1.3*.7,0,.5,0,1,.2,.02,.4,.8,1,1,0,0)}}},sc=class{constructor(t,e,i){this.game=t,this.x=e,this.z=i,this.uses=0,this.price=50+25*t.floorNum;let s=Ti(),r=new fe,a=Ei(1.1,.9,.8,s.stone);a.position.y=.45,r.add(a);let o=Ei(1.3,.12,1,s.stone);o.position.y=.96,r.add(o);let l=new Tt(new ei(.3,.2,.18,12),s.gold);l.position.y=1.1,l.castShadow=!0,r.add(l),this.orb=new Tt(new Ni(.16),rs("glow",{color:16760896,intensity:5})),this.orb.position.y=1.55,r.add(this.orb),r.position.set(e,t.floorAt(e,i),i),r.rotation.y=Math.PI/4,this.mesh=r,t.scene.add(r),t.addLight(e,r.position.y+1.7,i,16760928,6,6,.3)}get prompt(){return`Oferenda: ${this.price} de ouro por um item`}interact(){let t=this.game,e=t.player;if(e.gold<this.price){t.audio.play("deny"),t.ui.toast("Ouro insuficiente para a oferenda.");return}e.gold-=this.price,this.uses++,t.audio.play("chest"),t.particles.burst(this.x,this.mesh.position.y+1.5,this.z,40,[1,.8,.3],4,.8,.3),t.dropItem(this.x,this.z,{bonus:.6}),this.price=Math.round(this.price*1.5)}update(t,e){this.orb.rotation.y+=t*2,this.orb.position.y=1.55+Math.sin(e*2)*.08}},$h={coin:new ei(.1,.1,.03,10),heart:new Ni(.16),beam:new ei(.1,.25,5,10,1,!0)},Ql=null;function bv(){if(Ql)return Ql;let n=document.createElement("canvas");n.width=4,n.height=64;let t=n.getContext("2d"),e=t.createLinearGradient(0,0,0,64);return e.addColorStop(0,"rgba(255,255,255,0)"),e.addColorStop(.7,"rgba(255,255,255,0.5)"),e.addColorStop(1,"rgba(255,255,255,1)"),t.fillStyle=e,t.fillRect(0,0,4,64),Ql=new ti(n),Ql}function Sv(n){let t=new pi("item"),e=new fe,i=n.affixes.includes("chamas")?16738848:n.affixes.includes("trovao")?8442111:null;if(n.cat==="melee"){let s=Ma(n.kind,t,n.rarity==="unico"&&i||null);s.rotation.z=.6,s.position.y=-.3,e.add(s),e.scale.setScalar(.9)}else if(n.cat==="bow"){let s=Kl(t,n.kind==="besta");s.rotation.z=.3,e.add(s)}else if(n.cat==="armor"){let s={couro:"leather",malha:"steel",placas:"steel",andarilho:"cloth_green",obsidiana:"obsidian"}[n.kind],r=t.mat(s);t.part(e,.5,.55,.28,r,0,0,0),t.part(e,.24,.16,.3,r,-.34,.2,0),t.part(e,.24,.16,.3,r,.34,.2,0)}else{let s={chamas:16738848,raio:8442111,estandarte:16724016,vendaval:12648400,laminas:10128639,gelo:9433343}[n.kind];t.part(e,.34,.44,.1,t.mat("leather"),0,0,0),t.part(e,.3,.4,.11,t.mat("bone",{color:15788240}),.01,0,0);let r=new Tt(new Ni(.1),rs("glow",{color:s,intensity:4}));r.position.z=.08,e.add(r)}return e}var rc=class{constructor(t,e,i,s,r){this.game=t,this.kind=e,this.x=i,this.z=s,this.data=r,this.y=t.floorAt(i,s)+.6,this.vy=3+Math.random()*2;let a=Math.random()*Math.PI*2,o=e==="item"?1.2:1+Math.random()*2.5;this.vx=Math.cos(a)*o,this.vz=Math.sin(a)*o,this.t=0,this.dead=!1,this.grounded=!1;let l=Ti();if(e==="gold")this.mesh=new Tt($h.coin,l.gold),this.mesh.rotation.x=Math.PI/2;else if(e==="heart")this.mesh=new Tt($h.heart,rs("glow",{color:16722490,intensity:3}));else if(e==="arrows"){this.mesh=new fe;let c=new pi("a");for(let h=0;h<5;h++){let d=c.part(this.mesh,.025,.6,.025,l.wood,(h-2)*.05,0,0);d.rotation.z=(h-2)*.08}c.part(this.mesh,.18,.06,.05,l.iron,0,0,0),this.mesh.rotation.z=Math.PI/2.3}else if(e==="item"){this.mesh=new fe,this.model=Sv(r),this.mesh.add(this.model);let c=mn[r.rarity],h=new Le({color:c.hex,map:bv(),transparent:!0,blending:Be,depthWrite:!1,side:ke,opacity:.8});this.beam=new Tt($h.beam,h),this.beam.position.y=2,this.beam.rotation.x=Math.PI,this.mesh.add(this.beam),this.light=t.addLight(i,this.y,s,c.hex,r.rarity==="comum"?0:4,4,.1)}this.mesh.traverse(c=>{c.isMesh&&c!==this.beam&&(c.castShadow=!0)}),this.mesh.position.set(i,this.y,s),t.scene.add(this.mesh)}get prompt(){return this.kind==="item"?"item":null}update(t,e){let i=this.game,s=i.player;this.t+=t;let r=i.floorAt(this.x,this.z);if(!this.grounded){this.vy-=18*t;let o=this.x+this.vx*t,l=this.z+this.vz*t;i.walkable(o,l)?(this.x=o,this.z=l):(this.vx*=-.4,this.vz*=-.4),this.y+=this.vy*t;let c=r+(this.kind==="item"?.55:.12);this.y<c&&(this.y=c,Math.abs(this.vy)<2?(this.grounded=!0,this.vy=0):(this.vy*=-.35,this.vx*=.6,this.vz*=.6,this.kind==="gold"&&i.audio.play("coin",.25)))}let a=Math.hypot(s.x-this.x,s.z-this.z);if(this.kind!=="item"&&this.t>.5&&!s.dead){let o=this.kind==="gold"?3.5:2.2;if(a<o){let l=(1-a/o)*14+4;this.x+=(s.x-this.x)/a*l*t,this.z+=(s.z-this.z)/a*l*t,this.y+=(s.y+.8-this.y)*Math.min(1,t*6),this.grounded=!0}if(a<.5){this.collect();return}}this.mesh.position.set(this.x,this.y+(this.grounded?Math.sin(e*3+this.x)*.06:0),this.z),this.kind==="gold"?this.mesh.rotation.z+=t*4:this.kind==="item"?(this.model.rotation.y+=t*1.5,this.beam.material.opacity=.55+Math.sin(e*3)*.2,this.light&&(this.light.x=this.x,this.light.z=this.z)):this.mesh.rotation.y+=t*2,this.kind==="heart"&&Math.random()<t*5&&i.particles.add.emit(this.x,this.y,this.z,0,.6,0,.6,.12,.02,1,.2,.3,1,0,0)}collect(){let t=this.game,e=t.player;this.remove(),this.kind==="gold"&&(e.gold+=this.data||1,t.audio.play("coin",.6)),this.kind==="arrows"&&(e.arrows=Math.min(e.maxArrows,e.arrows+8),t.audio.play("pickup"),t.floatText(e.x,e.y+2,e.z,"+8 flechas","#d8d0b0")),this.kind==="heart"&&(e.heal(e.maxHp*.2),t.audio.play("potion",.6))}remove(){this.dead=!0,this.game.scene.remove(this.mesh),this.light&&this.game.removeLight(this.light)}};function Ta(n,t,e,i,s,r=16724e3){let a=new Tt(new Jn(1,40),new Le({map:_v(),color:r,transparent:!0,blending:Be,depthWrite:!1,opacity:0}));a.rotation.x=-Math.PI/2,a.position.set(t,n.floorAt(t,e)+.04,e),a.scale.setScalar(i),a.renderOrder=3,n.scene.add(a);let o=new Tt(new Jn(1,40),new Le({color:r,transparent:!0,blending:Be,depthWrite:!1,opacity:.25}));o.rotation.x=-Math.PI/2,o.position.copy(a.position),o.position.y+=.005,o.scale.setScalar(.01),n.scene.add(o);let l=0;n.effects.push({update(c){l+=c;let h=Math.min(1,l/s);return a.material.opacity=Math.min(1,l*5)*.9,o.scale.setScalar(i*h),l>=s?(n.scene.remove(a),n.scene.remove(o),a.geometry.dispose(),a.material.dispose(),o.geometry.dispose(),o.material.dispose(),!1):!0}})}function Hf(n,t,e,i,s,r,a,o=16724e3){let l=new Tt(new qi(r,s),new Le({color:o,transparent:!0,blending:Be,depthWrite:!1,opacity:.35}));l.rotation.x=-Math.PI/2,l.rotation.z=-i;let c=t+Math.sin(i)*s/2,h=e+Math.cos(i)*s/2;l.rotation.order="YXZ",l.rotation.set(-Math.PI/2,0,0),l.rotateOnWorldAxis(new N(0,1,0),i),l.position.set(c,n.floorAt(t,e)+.05,h),n.scene.add(l);let d=0;n.effects.push({update(u){return d+=u,l.material.opacity=.2+.3*Math.abs(Math.sin(d*12)),d>=a?(n.scene.remove(l),l.geometry.dispose(),l.material.dispose(),!1):!0}})}function Vf(n,t,e=10476799){let i=[];for(let c=0;c<t.length-1;c++){let h=t[c],d=t[c+1],u=h,f=6;for(let g=1;g<=f;g++){let _=g/f,m=g===f?d:new N(h.x+(d.x-h.x)*_+(Math.random()-.5)*.5,h.y+(d.y-h.y)*_+(Math.random()-.5)*.5,h.z+(d.z-h.z)*_+(Math.random()-.5)*.5);i.push(u.x,u.y,u.z,m.x,m.y,m.z),u=m}}let s=new ce;s.setAttribute("position",new Gt(i,3));let r=new Hs({color:e,transparent:!0,blending:Be,depthWrite:!1}),a=new Fr(s,r);n.scene.add(a);let o=n.addLight(t[0].x,t[0].y,t[0].z,e,25,10,0,!0),l=0;n.effects.push({update(c){return l+=c,r.opacity=1-l/.3,o.intensity=25*(1-l/.3),l>.3?(n.scene.remove(a),s.dispose(),r.dispose(),n.removeLight(o),!1):!0}})}function Zh(){let n=Ti(),t=new fe,e=new Tt(new ei(.04,.04,2.6,6),n.darkwood);e.position.y=1.3,e.castShadow=!0,t.add(e);let i=new Tt(new qi(.7,1.2),n.banners[0]);i.position.set(.37,1.9,0),i.castShadow=!0,t.add(i);let s=new Tt(new Ni(.1),n.gold);return s.position.y=2.65,t.add(s),t}var ac=[-Math.SQRT1_2,-Math.SQRT1_2],oc=[Math.SQRT1_2,-Math.SQRT1_2],Qi=n=>1-Math.pow(1-Je(n,0,1),3),cr=class{constructor(t){this.game=t,this.rig=Pf(),this.x=0,this.z=0,this.y=0,this.rot=0,this.r=.35,this.fh=0,this.level=1,this.xp=0,this.xpNext=60,this.gold=0,this.arrows=40,this.maxArrows=99,this.equip={melee:null,bow:null,armor:null,arts:[null,null,null]},this.artCd=[0,0,0],this.atkCd=0,this.shootCd=0,this.rollCd=0,this.potionCd=0,this.potionMax=25,this.rollT=0,this.rollDir=[0,1],this.invuln=0,this.flashT=0,this.swingT=-1,this.shootT=0,this.combo=0,this.comboT=0,this.phase=0,this.moveAmt=0,this.healLeft=0,this.bannerBuff=0,this.dead=!1,this.deadT=0,this.bladesT=0,this.blades=null,this.stepT=0,this.aimRot=0,this.lastAimT=0,this.hp=100}attach(){this.game.scene.add(this.rig.root),this.rig.silMat||Uf(this.rig)}setEquip(t,e){if(t==="melee"&&(this.equip.melee=e,Df(this.rig,e.kind,e.affixes.includes("chamas")?16736288:e.affixes.includes("trovao")?7391487:null),Gf(this.rig)),t==="bow"&&(this.equip.bow=e,Nf(this.rig,e.kind==="besta"),Gf(this.rig)),t==="armor"){let i=this.hp/this.maxHp;this.equip.armor=e,Lf(this.rig,ar[e.kind]),this.hp=Math.min(this.maxHp,Math.max(1,i*this.maxHp))}}get maxHp(){return 100+(this.level-1)*12+(this.equip.armor?this.equip.armor.hp:0)}get dr(){return this.equip.armor?this.equip.armor.dr:0}has(t,e){let i=this.equip[t];return!!(i&&i.affixes.includes(e))}get dmgMult(){return(1+.07*(this.level-1))*(this.bannerBuff>0?1.4:1)}get speed(){let t=this.equip.armor;return 4.7*(1+(t?ar[t.kind].speed:0))}get rollMax(){return 1.1*(this.has("armor","agil")?.6:1)*(this.equip.armor&&this.equip.armor.kind==="andarilho"?.75:1)}heal(t){if(this.dead)return;let e=this.hp;this.hp=Math.min(this.maxHp,this.hp+t);let i=Math.round(this.hp-e);i>0&&this.game.floatText(this.x,this.y+2.1,this.z,"+"+i,"#6dff7a")}gainXp(t){for(this.xp+=t;this.xp>=this.xpNext;)this.xp-=this.xpNext,this.level++,this.xpNext=Math.round(this.xpNext*1.3+20),this.hp=this.maxHp,this.game.audio.play("levelup"),this.game.ui.toast(`N\xEDvel ${this.level}! Vida e dano aumentados.`,"#ffd76a"),this.game.particles.burst(this.x,this.y+1,this.z,50,[1,.85,.3],4,1,.3,-2)}hurt(t,e){if(this.dead||this.rollT>0||this.invuln>0||this.game.state!=="play")return!1;t*=1-this.dr,this.hp-=t,this.invuln=.45,this.flashT=.15;let i=this.game;return i.audio.play("hurt"),i.shake(.18),i.ui.hurtFlash(),i.floatText(this.x,this.y+2,this.z,"-"+Math.round(t),"#ff5a4a"),i.particles.blood(this.x,this.y+1.1,this.z,6),e&&e.hurt&&this.has("armor","espinhos")&&e.melee&&e.hurt(t*.4*(1/(1-this.dr)),{thorns:!0}),this.hp<=0&&(this.hp=0,this.dead=!0,this.deadT=0,i.onPlayerDead()),!0}aimAssist(t,e){let i=null,s=1e9;for(let r of this.game.enemies){if(r.dead)continue;let a=r.x-this.x,o=r.z-this.z,l=Math.hypot(a,o);if(l>t+r.r)continue;let c=Math.abs(kn(this.aimRot,Math.atan2(a,o)));if(c>e)continue;let h=l+c*2;h<s&&(s=h,i=r)}return i}update(t,e,i){let s=this.game,r=this.rig;if(this.flashT-=t,r.flash(this.flashT>0?1.5:0),this.dead){this.deadT+=t;let f=Qi(this.deadT*2);r.hips.rotation.x=-f*Math.PI/2,r.hips.position.y=r.legH*(1-f*.7);return}for(let f of["atkCd","shootCd","rollCd","potionCd","invuln","comboT","bannerBuff"])this[f]=Math.max(0,this[f]-t);for(let f=0;f<3;f++)this.artCd[f]=Math.max(0,this.artCd[f]-t);if(this.healLeft>0){let f=Math.min(this.healLeft,this.maxHp*.6*t);this.healLeft-=f,this.hp=Math.min(this.maxHp,this.hp+f)}this.has("armor","regen")&&(this.hp=Math.min(this.maxHp,this.hp+1.5*t));let a=e.ax*oc[0]+e.ay*ac[0],o=e.ax*oc[1]+e.ay*ac[1],l=Math.hypot(a,o);if(l>1&&(a/=l,o/=l),e.aim){let f=e.aim.x-this.x,g=e.aim.z-this.z;Math.hypot(f,g)>.3&&(this.aimRot=Math.atan2(f,g))}else if(e.aimStick)this.aimRot=Math.atan2(e.aimStick[0]*oc[0]+e.aimStick[1]*ac[0],e.aimStick[0]*oc[1]+e.aimStick[1]*ac[1]);else{let f=this.nearestEnemy(9);f?this.aimRot=Math.atan2(f.x-this.x,f.z-this.z):l>.1&&(this.aimRot=Math.atan2(a,o))}let c=this.speed,h=s.cellType(this.x,this.z);if(h===5&&(c*=.65),this.slowT>0&&(this.slowT-=t,c*=.55),this.rollT>0)this.rollT-=t,s.moveEntity(this,this.rollDir[0]*11.5*t,this.rollDir[1]*11.5*t),this.rot=Math.atan2(this.rollDir[0],this.rollDir[1]),Math.random()<.5&&s.particles.dust(this.x,this.y+.1,this.z,1,[.4,.38,.35],.3,.3);else{e.pressed("roll")&&this.rollCd<=0&&(this.rollT=.34,this.rollCd=this.rollMax,this.swingT=-1,this.rollDir=l>.1?[a/Math.max(l,.001),o/Math.max(l,.001)]:[Math.sin(this.rot),Math.cos(this.rot)],s.audio.play("roll")),e.down("attack")&&this.atkCd<=0&&this.swingT<0?this.melee():e.down("shoot")&&this.shootCd<=0&&this.swingT<0&&this.shoot(),e.pressed("potion")&&this.usePotion();for(let _=0;_<3;_++)e.pressed("art"+(_+1))&&s.useArtifact(_);let f=this.swingT>=0||this.shootT>0,g=f?.35:1;s.moveEntity(this,a*c*g*t,o*c*g*t),f||i-this.lastAimT<.4?this.rot=fn(this.rot,this.aimRot,25,t):l>.1&&(this.rot=fn(this.rot,Math.atan2(a,o),14,t))}this.swingT>=0&&(this.swingT+=t,!this.swingHit&&this.swingT>=this.swingDur*.45&&(this.swingHit=!0,this.doMeleeHit()),this.swingT>=this.swingDur&&(this.swingT=-1)),this.shootT=Math.max(0,this.shootT-t);let d=s.floorAt(this.x,this.z);this.fh=s.cellH(this.x,this.z),this.y=zi(this.y,d,18,t);let u=this.rollT<=0&&l>.1;this.moveAmt=zi(this.moveAmt,u?l:0,10,t),this.phase+=t*c*2.1*(u?1:.3),u&&(this.stepT-=t,this.stepT<=0&&(this.stepT=.32,s.audio.play("step"),h===5&&s.particles.dust(this.x,this.y,this.z,2,[.5,.6,.65],.3,.8))),this.animate(t,i),r.root.position.set(this.x,this.y,this.z),r.root.rotation.y=this.rot,this.updateBlades(t,i)}nearestEnemy(t){let e=null,i=t;for(let s of this.game.enemies){if(s.dead||!s.awake)continue;let r=Math.hypot(s.x-this.x,s.z-this.z);r<i&&this.game.los(this.x,this.z,s.x,s.z)&&(i=r,e=s)}return e}animate(t,e){let i=this.rig;if(as(i,this.phase,this.moveAmt,e),i.hips.rotation.x=0,i.bow&&(i.bow.visible=this.shootT>0),i.weapon&&(i.weapon.visible=!(this.shootT>0&&this.equip.melee&&this.equip.melee.kind==="lanca")),i.cape.rotation.x=.1+this.moveAmt*.6+Math.sin(e*5)*.04,this.rollT>0){let s=1-this.rollT/.34;i.hips.rotation.x=s*Math.PI*2,i.hips.position.y=i.legH*.75,i.legL.rotation.x=-1.2,i.legR.rotation.x=-1.2,i.armL.rotation.x=-1,i.armR.rotation.x=-1;return}if(i.armR.rotation.x=Math.min(i.armR.rotation.x,-.25),this.swingT>=0){let s=Qi(this.swingT/this.swingDur),r=this.equip.melee.kind;if(r==="lanca"){let a=Math.sin(s*Math.PI);i.armR.rotation.x=-1.57,i.torso.rotation.y=-.4+a*.4,i.hips.position.z=a*.25,i.armR.position.z=a*.35}else if(r==="martelo"||this.combo===2)i.armR.rotation.x=-3+s*2.6,i.armL.rotation.x=-3+s*2.6,i.torso.rotation.x=-.2+s*.5;else if(r==="adagas"){let a=this.combo%2?i.armL:i.armR;a.rotation.x=-1.5,a.rotation.y=(this.combo%2?-1:1)*(1-s*2)*.9,i.torso.rotation.y=(this.combo%2?-1:1)*(.6-s*1.2)}else{let a=this.combo===1?-1:1;i.armR.rotation.x=-1.45,i.armR.rotation.z=.3,i.torso.rotation.y=a*(1.1-s*2.3)}}else i.armR.position.z=0,i.hips.position.z=0;this.shootT>0&&(i.armL.rotation.x=-1.55,i.armL.rotation.y=.2,i.armR.rotation.x=-1.45,i.armR.rotation.y=-.5,i.torso.rotation.y=.35,i.bow&&i.bow.rotation.set(Math.PI/2,0,0))}melee(){let t=this.game,e=this.equip.melee,i=os[e.kind],s=Bi(e);this.combo=this.comboT>0?(this.combo+1)%i.combo:0,this.comboT=s+.4,this.atkCd=s,this.swingT=0,this.swingDur=Math.min(.36,s*.85),this.swingHit=!1,this.lastAimT=t.time;let r=this.aimAssist(i.range+1.2,1);r&&(this.aimRot=Math.atan2(r.x-this.x,r.z-this.z)),this.rot=fn(this.rot,this.aimRot,60,.05),t.audio.play(i.dmg>20?"swingHeavy":"swing")}doMeleeHit(){let t=this.game,e=this.equip.melee,i=os[e.kind],s=i.combo>1&&this.combo===i.combo-1,r=i.range*(s?1.15:1),a=i.arc,o=e.dmg*this.dmgMult*(s?1.5:1),l=0;t.slashFx(this,r,a,s);for(let c of t.enemies){if(c.dead)continue;let h=c.x-this.x,d=c.z-this.z,u=Math.hypot(h,d);if(u>r+c.r||Math.abs(kn(this.rot,Math.atan2(h,d)))>a/2&&u>c.r+.3)continue;let f=Math.random()<.08+(this.has("melee","critico")?.15:0),g=(i.knock||1)*(s?1.6:1);c.hurt(o*(f?2:1),{crit:f,kx:h/(u||1)*5*g,kz:d/(u||1)*5*g,burn:this.has("melee","chamas"),melee:!0}),l++,this.has("melee","vampiro")&&this.heal(1+o*.06),this.has("melee","trovao")&&Math.random()<.2&&t.chainLightning(c,o*.8,3)}for(let c of t.pots){if(c.dead)continue;let h=c.x-this.x,d=c.z-this.z;Math.hypot(h,d)<r+.3&&Math.abs(kn(this.rot,Math.atan2(h,d)))<a/2+.3&&c.smash()}l&&(t.hitstop(s?.07:.035),t.shake(s?.12:.05))}shoot(){let t=this.game,e=this.equip.bow,i=Sa[e.kind];if(this.arrows<=0){t.audio.play("deny"),t.ui.toast("Sem flechas!"),this.shootCd=.5;return}this.arrows--,this.shootCd=Bi(e),this.shootT=.32,this.lastAimT=t.time;let s=this.aimAssist(16,.35);s&&(this.aimRot=Math.atan2(s.x-this.x,s.z-this.z)),this.rot=this.aimRot;let r=this.has("bow","multi")?[-.18,0,.18]:[0];for(let a of r){let o=this.aimRot+a;t.spawnProjectile({type:"arrow",owner:"player",x:this.x+Math.sin(o)*.5,y:this.y+1.2,z:this.z+Math.cos(o)*.5,dir:o,speed:i.speed,dmg:e.dmg*this.dmgMult,pierce:i.pierce+(this.has("bow","perfura")?2:0),explosive:this.has("bow","explosiva"),burn:this.has("bow","chamas"),range:22})}t.audio.play("bow")}usePotion(){let t=this.game;if(this.potionCd>0){t.audio.play("deny");return}this.potionCd=this.potionMax,this.healLeft+=this.maxHp*.6,t.audio.play("potion"),t.particles.burst(this.x,this.y+1,this.z,30,[1,.3,.35],2,.8,.25,-3)}updateBlades(t,e){let i=this.game;if(this.bladesT>0){if(this.bladesT-=t,!this.blades){this.blades=[];let r=new Ce({color:11577599,emissive:8022783,emissiveIntensity:3,transparent:!0,opacity:.85});for(let a=0;a<3;a++){let o=new Tt(new $e(.08,.02,.9),r);i.scene.add(o),this.blades.push(o)}this.bladeHit=new Map}let s=this.bladePower||1;this.blades.forEach((r,a)=>{let o=e*5+a/3*Math.PI*2,l=this.x+Math.sin(o)*1.7,c=this.z+Math.cos(o)*1.7;r.position.set(l,this.y+1,c),r.rotation.y=o+Math.PI/2,Math.random()<.5&&i.particles.add.emit(l,this.y+1,c,0,0,0,.3,.2,.02,.6,.55,1,.8,0,0);for(let h of i.enemies)if(!h.dead&&Math.hypot(h.x-l,h.z-c)<h.r+.5){let d=this.bladeHit.get(h)||0;e-d>.35&&(this.bladeHit.set(h,e),h.hurt(9*s*this.dmgMult,{kx:Math.sin(o)*2,kz:Math.cos(o)*2}))}})}else if(this.blades){for(let s of this.blades)i.scene.remove(s),s.geometry.dispose();this.blades[0].material.dispose(),this.blades=null}}};function Gf(n){if(n.silMat)for(let t of n.meshes){if(t.children.some(i=>i.userData.sil))continue;let e=new Tt(t.geometry,n.silMat);e.renderOrder=1,e.userData.sil=!0,t.add(e),t.renderOrder=2}}var Xf={carnical:{name:"Carni\xE7al",hp:42,dmg:10,speed:2.3,r:.4,range:1.35,windup:.5,cd:1.3,xp:10,blood:[.2,.28,.1],sound:"hit",mass:1},esqueleto:{name:"Esqueleto Arqueiro",hp:28,dmg:8,speed:2.5,r:.35,ranged:!0,prefer:7,windup:.7,cd:2.2,xp:12,blood:[.85,.82,.72],sound:"boneHit",mass:.8},aranha:{name:"Aranha da Cripta",hp:30,dmg:9,speed:3.5,r:.5,range:3.6,lunge:!0,windup:.4,cd:1.8,xp:12,blood:[.25,.3,.08],sound:"hit",mass:.8},aranhinha:{name:"Aranha Filhote",hp:12,dmg:5,speed:4.2,r:.3,range:1,windup:.25,cd:1,xp:3,blood:[.25,.3,.08],sound:"hit",mass:.5},necromante:{name:"Necromante",hp:50,dmg:12,speed:2,r:.4,ranged:!0,prefer:8,windup:.8,cd:2.6,xp:28,blood:[.4,.1,.5],sound:"hit",mass:1,summoner:!0},esporo:{name:"Esporo Inchado",hp:22,dmg:34,speed:2.7,r:.45,range:2,fuse:!0,windup:1.1,cd:1,xp:8,blood:[.8,.75,.3],sound:"hit",mass:.9}},wv={gorran:{name:"Gorran, o Devorador",hp:950,dmg:22,speed:2.4,r:1,attacks:["slam","charge","swipe","swipe"],summon:"carnical",blood:[.2,.28,.1],baseFloor:1},veshkara:{name:"Vesh'kara, M\xE3e da Teia",hp:1050,dmg:20,speed:3,r:1.2,attacks:["leap","spit","bite","bite"],summon:"aranhinha",blood:[.35,.1,.4],baseFloor:2},colosso:{name:"Colosso de Obsidiana",hp:1400,dmg:26,speed:2,r:1.1,attacks:["slam","meteor","charge","swipe"],summon:"esporo",blood:[1,.5,.1],baseFloor:3}},Kh=n=>1+.45*(n-1),Qh=n=>1+.3*(n-1),hr=class{constructor(t,e,i,s,r={}){this.game=t,this.type=e;let a=this.S=Xf[e],o=t.floorNum;this.maxHp=this.hp=a.hp*Kh(o)*(r.elite?2.2:1),this.dmg=a.dmg*Qh(o)*(r.elite?1.3:1),this.r=a.r,this.x=i,this.z=s,this.y=t.floorAt(i,s),this.fh=t.cellH(i,s),this.rot=Math.random()*Math.PI*2,this.kx=0,this.kz=0,this.awake=!!r.awake,this.dead=!1,this.deadT=0,this.state="move",this.atkT=0,this.cd=1+Math.random(),this.summonCd=6,this.burnT=0,this.burnDps=0,this.freezeT=0,this.stunT=0,this.flashT=0,this.slowT=0,this.phase=Math.random()*10,this.moveAmt=0,this.strafe=Math.random()<.5?1:-1,this.melee=!a.ranged,this.rig=Ff(e),r.elite&&(this.rig.root.scale.multiplyScalar(1.35),this.r*=1.3,this.elite=!0),this.rig.root.position.set(i,this.y,s),t.scene.add(this.rig.root),this.spawnT=r.spawnFx?0:1}get name(){return this.S.name}hurt(t,e={}){if(this.dead)return;let i=this.game;this.hp-=t,this.flashT=.12,this.wake();let s=1/(this.S.mass||1);if(e.kx&&(this.kx+=e.kx*s,this.kz+=e.kz*s),e.burn&&(this.burnT=3,this.burnDps=Math.max(this.burnDps,t*.18)),e.stun&&(this.stunT=Math.max(this.stunT,e.stun)),e.freeze&&(this.freezeT=Math.max(this.freezeT,e.freeze)),i.floatText(this.x,this.y+1.2*this.rig.root.scale.y+.9,this.z,Math.round(t)+(e.crit?"!":""),e.crit?"#ffd23a":e.fire?"#ff9a3a":e.dot?"#ffae5a":"#ffffff",e.crit),!e.dot){let r=this.S.blood;i.particles.blood(this.x,this.y+.9,this.z,e.crit?14:7,r),i.audio.play(e.crit?"crit":this.S.sound,.8)}this.hp<=0&&this.die()}wake(){if(!this.awake){this.awake=!0;for(let t of this.game.enemies)!t.awake&&!t.dead&&Math.hypot(t.x-this.x,t.z-this.z)<7&&(t.awake=!0)}}die(){let t=this.game;this.dead=!0,this.deadT=0,this.hp=0,t.player.gainXp(this.S.xp*(this.elite?3:1)*(1+.2*(t.floorNum-1))),t.stats.kills++,t.audio.play("die",.7),this.type==="esqueleto"&&t.particles.dust(this.x,this.y+.5,this.z,12,[.8,.78,.7],.6),this.type==="esporo"&&t.particles.burst(this.x,this.y+.6,this.z,20,[.8,.75,.3],2,.8,.3),Math.random()<.75&&t.spawnGold(this.x,this.z,1+Math.floor(Math.random()*3),1.5),Math.random()<.07&&t.spawnLoot("heart",this.x,this.z),Math.random()<.12&&t.spawnLoot("arrows",this.x,this.z),Math.random()<(this.elite?.6:.03)&&t.dropItem(this.x,this.z,{bonus:this.elite?.4:0})}update(t,e){let i=this.game,s=i.player,r=this.S,a=this.rig;if(this.dead){this.deadT+=t;let p=Qi(this.deadT*2.5);this.type==="aranha"||this.type==="aranhinha"?(a.root.rotation.z=p*Math.PI,a.root.position.y=this.y+p*.3):this.type==="esporo"?a.root.scale.setScalar(1-p):a.hips&&(a.hips.rotation.x=-p*Math.PI/2,a.hips.position.y=a.legH*(1-p*.75)),this.deadT>1.2&&(a.fade(Math.max(0,1-(this.deadT-1.2)*2)),a.root.position.y-=t*.4),this.deadT>1.8&&(i.scene.remove(a.root),a.dispose(),this.removed=!0);return}if(this.spawnT<1){this.spawnT+=t*1.5,a.root.scale.setScalar(Qi(this.spawnT)*(this.elite?1.35:1)*(this.baseScale||1)),a.root.position.set(this.x,this.y-(1-this.spawnT)*1.2,this.z);return}if(this.flashT-=t,a.flash(this.flashT>0?2:this.state==="attack"&&r.fuse&&Math.sin(this.atkT*30)>0?1.2:0),this.burnT>0){if(this.burnT-=t,this.burnAcc=(this.burnAcc||0)+t,this.burnAcc>.5&&(this.burnAcc=0,this.hurt(this.burnDps*.5,{dot:!0,fire:!0}),this.dead))return;Math.random()<t*20&&i.particles.fire(this.x,this.y+.3+Math.random()*1.2,this.z,1,.6)}else this.burnDps=0;if(this.freezeT>0){this.freezeT-=t,a.tint(new Ut(8444159),.7),this.freezeT<=0&&a.tint(new Ut(16777215),0),Math.random()<t*5&&i.particles.add.emit(this.x+(Math.random()-.5)*.6,this.y+Math.random()*1.5,this.z+(Math.random()-.5)*.6,0,.2,0,.6,.12,.02,.6,.9,1,1,0,0),this.applyKnock(t);return}this.applyKnock(t);let o=s.x-this.x,l=s.z-this.z,c=Math.hypot(o,l);if(!this.awake){c<11&&i.los(this.x,this.z,s.x,s.z)&&this.wake(),as(a,this.phase,0,e),this.place(t);return}if(this.stunT>0){this.stunT-=t,as(a,this.phase,0,e),this.place(t),Math.random()<t*6&&i.particles.add.emit(this.x,this.y+2,this.z,Math.random()-.5,.5,Math.random()-.5,.5,.15,.02,1,1,.5,1,0,0);return}this.cd-=t,this.summonCd-=t;let h=0,d=0,u=Math.atan2(o,l),f=c<16&&i.los(this.x,this.z,s.x,s.z);this.state==="attack"?(this.atkT+=t,this.rot=fn(this.rot,u,r.lunge&&this.lunging?0:6,t),this.attackUpdate(t,c,o,l)):s.dead||(r.ranged?(c<r.prefer-2.5&&f?(h=-o/c,d=-l/c):c>r.prefer+1||!f?[h,d]=i.flowDir(this):(h=l/c*this.strafe*.5,d=-o/c*this.strafe*.5,Math.random()<t*.4&&(this.strafe*=-1)),r.summoner&&this.summonCd<=0&&f&&c<12?this.startAttack("summon"):this.cd<=0&&f&&c<r.prefer+5&&this.startAttack("shoot")):(c<2.2&&f?(h=o/c,d=l/c):[h,d]=i.flowDir(this),this.cd<=0&&c<r.range+s.r+.2&&f&&this.startAttack(r.fuse?"fuse":r.lunge?"lunge":"melee")));{let p=this.x-s.x,M=this.z-s.z,R=Math.hypot(p,M),y=this.r+s.r;if(R<y&&R>.001&&!s.dead){let w=(y-R)/y;h+=p/R*w*2,d+=M/R*w*2}}for(let p of i.enemies){if(p===this||p.dead)continue;let M=this.x-p.x,R=this.z-p.z,y=Math.hypot(M,R),w=this.r+p.r;if(y<w&&y>.001){let S=(w-y)/w;h+=M/y*S*1.5,d+=R/y*S*1.5}}let g=Math.hypot(h,d),_=r.speed*(this.slowT>0?.5:1)*(i.cellType(this.x,this.z)===5?.7:1);if(this.slowT>0&&(this.slowT-=t),g>.01&&this.state!=="attack"){let p=Math.min(1,g);i.moveEntity(this,h/g*_*p*t,d/g*_*p*t);let M=r.ranged&&f&&c<r.prefer+3?u:Math.atan2(h,d);this.rot=fn(this.rot,M,8,t)}else this.state!=="attack"&&f&&(this.rot=fn(this.rot,u,6,t));let m=g>.05&&this.state!=="attack";this.moveAmt=zi(this.moveAmt,m?1:0,8,t),this.phase+=t*_*2.4*(m?1:0),as(a,this.phase,this.moveAmt,e),this.attackPose(),this.place(t)}applyKnock(t){if(Math.abs(this.kx)+Math.abs(this.kz)>.05){this.game.moveEntity(this,this.kx*t,this.kz*t);let e=Math.exp(-8*t);this.kx*=e,this.kz*=e}}place(t){this.y=zi(this.y,this.game.floorAt(this.x,this.z),15,t),this.fh=this.game.cellH(this.x,this.z),this.rig.root.position.set(this.x,this.y+(this.hover||0),this.z),this.rig.root.rotation.y=this.rot}startAttack(t){this.state="attack",this.atkKind=t,this.atkT=0,this.did=!1,this.lunging=!1,t==="fuse"&&this.game.audio.play("fuse"),t==="summon"&&this.game.audio.play("summon",.7),t==="lunge"&&this.game.audio.play("hiss",.6)}endAttack(t){this.state="move",this.cd=t,this.lunging=!1}attackUpdate(t,e,i,s){let r=this.game,a=r.player,o=this.S,l=this.atkKind==="summon"?1:o.windup;if(this.atkKind==="melee"){if(!this.did&&this.atkT>=l){this.did=!0,r.audio.play("swing",.6);let c=Math.abs(kn(this.rot,Math.atan2(i,s)));e<o.range+a.r+.35&&c<1.3&&a.hurt(this.dmg,this)}this.atkT>=l+.35&&this.endAttack(o.cd)}else if(this.atkKind==="lunge")this.atkT>=l&&this.atkT<l+.3&&(this.lunging=!0,r.moveEntity(this,Math.sin(this.rot)*10*t,Math.cos(this.rot)*10*t),!this.did&&e<this.r+a.r+.3&&(this.did=!0,a.hurt(this.dmg,this))),this.atkT>=l+.6&&this.endAttack(o.cd);else if(this.atkKind==="shoot"){if(!this.did&&this.atkT>=l){this.did=!0;let c=e/14,h=a.x+(a.vx||0)*c*.5,d=a.z+(a.vz||0)*c*.5,u=Math.atan2(h-this.x,d-this.z);this.type==="necromante"?(r.spawnProjectile({type:"bolt",owner:"enemy",x:this.x+Math.sin(u)*.6,y:this.y+1.3,z:this.z+Math.cos(u)*.6,dir:u,speed:7.5,dmg:this.dmg,homing:1.4,range:18}),r.audio.play("bolt",.8)):(r.spawnProjectile({type:"arrow",owner:"enemy",x:this.x+Math.sin(u)*.5,y:this.y+1.2,z:this.z+Math.cos(u)*.5,dir:u,speed:14,dmg:this.dmg,range:18}),r.audio.play("bow",.6))}this.atkT>=l+.3&&this.endAttack(o.cd*(.8+Math.random()*.4))}else if(this.atkKind==="summon"){if(Math.random()<.6&&r.particles.add.emit(this.x+(Math.random()-.5)*2,this.y+.1,this.z+(Math.random()-.5)*2,0,2,0,.6,.3,.05,.6,.2,1,1,0,0),!this.did&&this.atkT>=l){this.did=!0;let c=r.enemies.filter(h=>!h.dead).length<30?2:0;for(let h=0;h<c;h++)r.spawnEnemyNear(this.x,this.z,"carnical",2.5,!0);this.summonCd=11}this.atkT>=l+.3&&this.endAttack(1.2)}else if(this.atkKind==="fuse"){let c=this.atkT/l;this.rig.root.scale.setScalar(1+c*.35),this.atkT>=l&&this.explode()}}explode(){let t=this.game,e=t.player,i=2.9;t.explosion(this.x,this.y+.5,this.z,i,[.9,.8,.3]);let s=Math.hypot(e.x-this.x,e.z-this.z);s<i+e.r&&e.hurt(this.dmg*(1-.5*s/i),this);for(let r of t.enemies)r!==this&&!r.dead&&Math.hypot(r.x-this.x,r.z-this.z)<i&&r.hurt(this.dmg*.5,{kx:(r.x-this.x)*3,kz:(r.z-this.z)*3});for(let r of t.pots)!r.dead&&Math.hypot(r.x-this.x,r.z-this.z)<i&&r.smash();this.hp=0,this.die(),this.rig.root.visible=!1,this.deadT=1.5}attackPose(){let t=this.rig;if(this.state!=="attack")return;let e=this.atkT/(this.atkKind==="summon"?1:this.S.windup);if(this.type==="aranha"||this.type==="aranhinha"){t.body.rotation.x=this.atkT<this.S.windup?-.35*Math.min(1,e):.2;return}if(this.type!=="esporo")if(this.atkKind==="melee"){let i=e<1?Qi(e):1-Qi((this.atkT-this.S.windup)/.2);t.armL.rotation.x=t.armR.rotation.x=-1.3-i*1.5+(e>=1?1.2:0),t.torso.rotation.x=e<1?-.2*i:.35}else this.atkKind==="shoot"?this.type==="esqueleto"?(t.armL.rotation.x=-1.57,t.armR.rotation.x=-1.5,t.armR.rotation.y=-.4*Math.min(1,e),t.torso.rotation.y=.3):t.armR.rotation.x=-1.2-Math.min(1,e)*1.4:this.atkKind==="summon"&&(t.armL.rotation.x=t.armR.rotation.x=-2.8,t.armL.rotation.z=-.4,t.armR.rotation.z=.4)}remove(){this.game.scene.remove(this.rig.root),this.rig.dispose(),this.removed=!0}},lc=class extends hr{constructor(t,e,i,s){let r=wv[e];Xf[e]={name:r.name,hp:r.hp,dmg:r.dmg,speed:r.speed,r:r.r,windup:.5,cd:1.6,xp:400,blood:r.blood,sound:"hit",mass:12},super(t,e,i,s,{});let a=t.floorNum;this.maxHp=this.hp=r.hp*Kh(a)/Kh(r.baseFloor)*(a>r.baseFloor?1+.1*(a-r.baseFloor):1),this.dmg=r.dmg*Qh(a)/Qh(r.baseFloor),this.B=r,this.isBoss=!0,this.phase2=!1,this.cd=2,this.summonCd=14,this.light=t.addLight(i,5,s,{gorran:11599776,veshkara:14196991,colosso:16752736}[e],0,16,.05,!0),this.rot=Math.PI/4}hurt(t,e={}){e.freeze&&(e.freeze*=.25),e.stun&&(e.stun=0),super.hurt(t,e),!this.phase2&&this.hp<this.maxHp*.5&&!this.dead&&(this.phase2=!0,this.game.audio.play("roar"),this.game.shake(.5),this.game.ui.toast(`${this.B.name} est\xE1 enfurecido!`,"#ff6a4a"),this.summonCd=0)}wake(){this.game.bossActive&&(this.awake=!0)}die(){let t=this.game;this.dead=!0,this.deadT=0,this.hp=0,t.player.gainXp(300*(1+.25*(t.floorNum-1))),t.stats.kills++,t.audio.play("roar"),t.audio.play("explode"),t.shake(.8),t.particles.burst(this.x,this.y+2,this.z,120,[1,.7,.3],8,1.5,.5,4),t.spawnGold(this.x,this.z,40+t.floorNum*10,5),t.dropItem(this.x,this.z,{rarity:"unico"}),t.dropItem(this.x,this.z,{bonus:.6}),t.spawnLoot("heart",this.x,this.z),t.spawnLoot("arrows",this.x,this.z),t.onBossDead(this),t.removeLight(this.light)}update(t,e){let i=this.game,s=i.player,r=this.rig;if(this.dead||this.freezeT>0){super.update(t,e);return}if(!this.awake){as(r,this.phase,0,e),this.place(t);return}if(this.light.intensity=Math.min(22,this.light.intensity+t*20),this.light.x=this.x+1.5,this.light.y=this.y+5.5,this.light.z=this.z+1.5,this.flashT-=t,r.flash(this.flashT>0?1.2:0),this.burnT>0){if(this.burnT-=t,this.burnAcc=(this.burnAcc||0)+t,this.burnAcc>.5&&(this.burnAcc=0,this.hurt(this.burnDps*.5,{dot:!0,fire:!0}),this.dead))return;Math.random()<t*25&&i.particles.fire(this.x,this.y+Math.random()*3,this.z,1,1.2)}this.applyKnock(t);let a=s.x-this.x,o=s.z-this.z,l=Math.hypot(a,o),c=Math.atan2(a,o),h=this.S.speed*(this.phase2?1.25:1);this.cd-=t,this.summonCd-=t,this.type==="colosso"&&Math.random()<t*6&&i.particles.ember(this.x+(Math.random()-.5)*2,this.y+1+Math.random()*3,this.z+(Math.random()-.5)*2);let d=!1;if(this.atk)this.bossAttack(t,l,a,o,c);else if(!s.dead){if(l>2.2){let[f,g]=l<6?[a/l,o/l]:i.flowDir(this);i.moveEntity(this,f*h*t,g*h*t),d=!0}this.rot=fn(this.rot,c,5,t),this.cd<=0&&this.chooseAttack(l)}let u=Math.hypot(s.x-this.x,s.z-this.z);if(!s.dead&&u<this.r+s.r&&!this.hover){let f=(this.r+s.r-u)*Math.min(1,t*12),g=u>.001?(s.x-this.x)/u:1,_=u>.001?(s.z-this.z)/u:0;i.moveEntity(s,g*f,_*f)}this.moveAmt=zi(this.moveAmt,d?1:0,6,t),this.phase+=t*h*2*(d?1:0),(!this.atk||this.atk.anim!=="custom")&&as(r,this.phase,this.moveAmt,e),this.bossPose(),this.place(t)}chooseAttack(t){let e=this.B;if(this.summonCd<=0&&(this.phase2||Math.random()<.3)){this.atk={name:"summon",t:0},this.summonCd=this.phase2?12:18,this.game.audio.play("summon");return}let i=e.attacks.filter(o=>["swipe","bite","slam"].includes(o)?t<4.5:!0);t>6&&(i=e.attacks.filter(o=>["charge","leap","spit","meteor"].includes(o))),i.length||(i=e.attacks);let s=i[Math.floor(Math.random()*i.length)];this.atk={name:s,t:0,did:0,ang:this.rot};let r=this.game,a=r.player;if(s==="slam"&&Ta(r,this.x,this.z,4,1),(s==="swipe"||s==="bite")&&Ta(r,this.x+Math.sin(this.rot)*1.6,this.z+Math.cos(this.rot)*1.6,2.3,s==="bite"?.45:.6),s==="charge"){let o=Math.atan2(a.x-this.x,a.z-this.z);this.atk.ang=o,Hf(r,this.x,this.z,o,12,2.2,.8),r.audio.play("roar",.6)}if(s==="leap"&&(this.atk.tx=a.x,this.atk.tz=a.z,this.atk.sx=this.x,this.atk.sz=this.z,Ta(r,a.x,a.z,3.2,1.1,12599551),r.audio.play("hiss")),s==="meteor"){this.atk.targets=[];let o=this.phase2?8:6;for(let l=0;l<o;l++){let c=Math.random()*Math.PI*2,h=l===0?0:1.5+Math.random()*5,d=a.x+Math.cos(c)*h,u=a.z+Math.sin(c)*h;if(!r.walkable(d,u))continue;let f=.2+l*.12;this.atk.targets.push({x:d,z:u,t:1.3+f,done:!1}),Wf(r,f,()=>Ta(r,d,u,1.7,1.3,16738832))}r.audio.play("roar",.5)}}bossAttack(t,e,i,s,r){let a=this.game,o=a.player,l=this.atk;l.t+=t;let c=this.phase2?1.2:1,h=d=>{this.atk=null,this.cd=d/c};switch(l.name){case"swipe":case"bite":{let d=l.name==="bite"?.45:.6;if(!l.did&&l.t>=d){l.did=1,a.audio.play("swingHeavy");let u=Math.abs(kn(this.rot,r));e<3.4+o.r&&u<1.4&&o.hurt(this.dmg*.8,this),a.shake(.1)}l.t>=d+.4&&h(1.1);break}case"slam":{!l.did&&l.t>=1&&(l.did=1,a.audio.play("slam"),a.shake(.6),a.particles.dust(this.x,this.y+.2,this.z,40,[.5,.45,.4],4,1.5),this.type==="colosso"&&a.particles.burst(this.x,this.y+.3,this.z,50,[1,.5,.1],6,.8,.4,5),e<4+o.r&&o.hurt(this.dmg*1.2,this),a.shockwave(this.x,this.z,this.type==="colosso"?11:9,this.dmg*.6,this.type==="colosso"?16738848:13676672),this.phase2&&Wf(a,.45,()=>a.shockwave(this.x,this.z,9,this.dmg*.6,16728096))),l.t>=1.7&&h(1.4);break}case"charge":{if(l.t<.8){this.rot=fn(this.rot,l.ang,10,t);break}if(l.t<1.65&&!l.stopped){let d=Math.sin(l.ang)*15*t,u=Math.cos(l.ang)*15*t,f=this.x,g=this.z;a.moveEntity(this,d,u),Math.random()<.8&&a.particles.dust(this.x,this.y+.1,this.z,2,[.5,.45,.4],.8,.5),!l.did&&e<this.r+o.r+.4&&(l.did=1,o.hurt(this.dmg*1.1,this),o.slowT=.3),Math.hypot(this.x-f,this.z-g)<Math.hypot(d,u)*.3&&(l.stopped=!0,l.stopT=l.t,a.shake(.5),a.audio.play("slam"),a.particles.dust(this.x,this.y+1,this.z,25,[.5,.45,.4],2,2),this.stunT=0)}else l.stopped||(l.stopped=!0,l.stopT=l.t);l.stopped&&l.t>l.stopT+(l.did?.5:1.2)&&h(1.2);break}case"leap":{if(l.t>.3&&l.t<1.1){let f=(l.t-.3)/.8;this.x=l.sx+(l.tx-l.sx)*f,this.z=l.sz+(l.tz-l.sz)*f,this.hover=Math.sin(f*Math.PI)*3,this.rot=Math.atan2(l.tx-l.sx,l.tz-l.sz)}!l.did&&l.t>=1.1&&(l.did=1,this.hover=0,a.walkable(this.x,this.z)||(this.x=l.sx,this.z=l.sz),a.audio.play("slam"),a.shake(.5),a.particles.dust(this.x,this.y+.2,this.z,35,[.4,.35,.4],3.2,1.2),Math.hypot(o.x-this.x,o.z-this.z)<3.2+o.r&&o.hurt(this.dmg*1.1,this)),l.t>=1.1+.6&&h(1.2);break}case"spit":{let d=Math.floor(l.t/.45);if(d>l.did&&d<=3){l.did=d;let u=this.phase2?7:5;for(let f=0;f<u;f++){let g=r+(f-(u-1)/2)*.22;a.spawnProjectile({type:"web",owner:"enemy",x:this.x+Math.sin(g)*1.3,y:this.y+1,z:this.z+Math.cos(g)*1.3,dir:g,speed:9,dmg:this.dmg*.45,slow:1.5,range:16})}a.audio.play("hiss")}l.t>=1.8&&h(1.3);break}case"meteor":{for(let d of l.targets)if(!d.done&&l.t>=d.t)d.done=!0,a.explosion(d.x,a.floorAt(d.x,d.z)+.3,d.z,1.7,[1,.5,.1],!0),Math.hypot(o.x-d.x,o.z-d.z)<1.7+o.r&&o.hurt(this.dmg*.9,this);else if(!d.done&&l.t>=d.t-.5){let u=(d.t-l.t)/.5;a.particles.add.emit(d.x+u*3,a.floorAt(d.x,d.z)+u*12,d.z+u*3,-6,-24,-6,.1,1.2,.8,1,.5,.15,1,0,0)}l.t>=3.2&&h(1.5);break}case"summon":{if(Math.random()<.8&&a.particles.add.emit(this.x+(Math.random()-.5)*4,this.y+.1,this.z+(Math.random()-.5)*4,0,3,0,.7,.4,.05,.8,.3,1,1,0,0),!l.did&&l.t>=1.1){l.did=1;let d=this.B.summon==="aranhinha"?5:(this.B.summon==="esporo",3);for(let u=0;u<d;u++)a.spawnEnemyNear(this.x,this.z,this.B.summon,3.5,!0);a.audio.play("roar",.5)}l.t>=1.6&&h(1.2);break}}}bossPose(){let t=this.rig,e=this.atk;if(!e){t.body&&this.type==="veshkara"&&(t.body.rotation.x=0);return}if(this.type==="veshkara"){e.name==="leap"?t.body.rotation.x=e.t<.3?.2:-.3:e.name==="bite"?t.body.rotation.x=e.t<.45?-.4:.25:e.name==="spit"?t.body.rotation.x=-.25+Math.sin(e.t*14)*.08:e.name==="summon"&&(t.abdomen.rotation.x=Math.sin(e.t*20)*.1);return}if(e.name==="slam"){let i=e.t<1?Qi(e.t):1-Qi((e.t-1)*5);t.armL.rotation.x=t.armR.rotation.x=-.3-i*2.8,t.torso.rotation.x=e.t<1?-.25*i:.45}else if(e.name==="swipe"){let i=e.t/.6;t.armR.rotation.x=-1.5,t.armR.rotation.z=.2,t.torso.rotation.y=i<1?1*Qi(i):1-Qi((e.t-.6)*5)*2.2}else e.name==="charge"?(t.torso.rotation.x=.5,t.armL.rotation.x=t.armR.rotation.x=.6,t.head.rotation.x=-.4):(e.name==="summon"||e.name==="meteor")&&(t.armL.rotation.x=t.armR.rotation.x=-2.9,t.armL.rotation.z=-.5,t.armR.rotation.z=.5)}};function Wf(n,t,e){let i=0;n.effects.push({update(s){return i+=s,i>=t?(e(),!1):!0}})}var Jh={shaft:new $e(.035,.035,.7),tip:new Kn(.05,.14,4),orb:new un(.16,10,8)},cc=class{constructor(t,e){Object.assign(this,e),this.game=t,this.dead=!1,this.hitSet=new Set,this.dist=0,this.vx=Math.sin(e.dir)*e.speed,this.vz=Math.cos(e.dir)*e.speed;let i=Ti();if(e.type==="arrow"){this.mesh=new fe;let s=new Tt(Jh.shaft,i.wood);this.mesh.add(s);let r=new Tt(Jh.tip,i.iron);r.rotation.x=Math.PI/2,r.position.z=.4,this.mesh.add(r),e.burn||e.explosive?this.trail=[1,.5,.15]:e.owner==="player"&&(this.trail=[.9,.85,.7])}else{let s=e.type==="bolt"?12603647:e.type==="web"?15263984:16738832,r=e.type==="web"?new Ce({color:s,roughness:.8,transparent:!0,opacity:.9}):new Ce({color:s,emissive:s,emissiveIntensity:4});this.mesh=new Tt(Jh.orb,r),this.trail=e.type==="bolt"?[.7,.3,1]:e.type==="web"?null:[1,.5,.1],e.type==="bolt"&&(this.light=t.addLight(e.x,e.y,e.z,11555071,6,5,.2,!0))}this.mesh.position.set(e.x,e.y,e.z),this.mesh.rotation.y=e.dir,t.scene.add(this.mesh)}update(t){let e=this.game,i=e.player;if(this.homing&&!i.dead){let r=Math.atan2(i.x-this.x,i.z-this.z);this.dir=this.dir+Je(kn(this.dir,r),-this.homing*t,this.homing*t),this.vx=Math.sin(this.dir)*this.speed,this.vz=Math.cos(this.dir)*this.speed}let s=2;for(let r=0;r<s&&!this.dead;r++){if(this.x+=this.vx*t/s,this.z+=this.vz*t/s,this.dist+=this.speed*t/s,e.blocksProjectile(this.x,this.z,this.y)){e.particles.sparks(this.x,this.y,this.z,5,[1,.8,.5],2),this.type==="arrow"&&e.audio.play("arrowHit",.4),this.explosive&&this.boom(),this.kill();return}if(this.owner==="player"){for(let a of e.enemies){if(a.dead||this.hitSet.has(a))continue;let o=a.r+.25+(a.isBoss?.5:0);if(Math.hypot(a.x-this.x,a.z-this.z)<o){this.hitSet.add(a);let l=Math.random()<.1;if(a.hurt(this.dmg*(l?2:1),{crit:l,kx:this.vx*.12,kz:this.vz*.12,burn:this.burn}),this.explosive&&this.boom(),this.pierce--<=0){this.kill();return}}}for(let a of e.pots)!a.dead&&Math.hypot(a.x-this.x,a.z-this.z)<.4&&a.smash()}else if(!i.dead&&Math.hypot(i.x-this.x,i.z-this.z)<i.r+.2&&i.hurt(this.dmg,null)){this.slow&&(i.slowT=this.slow),this.kill();return}}if(this.dist>this.range){this.kill();return}this.mesh.position.set(this.x,this.y,this.z),this.mesh.rotation.y=this.dir,this.trail&&Math.random()<.8&&e.particles.add.emit(this.x,this.y,this.z,0,0,0,.25,this.type==="arrow"?.1:.35,.02,this.trail[0],this.trail[1],this.trail[2],.7,0,0),this.light&&(this.light.x=this.x,this.light.y=this.y,this.light.z=this.z)}boom(){let t=this.game;t.explosion(this.x,this.y,this.z,1.8,[1,.6,.2],!0,.35);for(let e of t.enemies)!e.dead&&Math.hypot(e.x-this.x,e.z-this.z)<1.8+e.r&&e.hurt(this.dmg*.6,{kx:(e.x-this.x)*2,kz:(e.z-this.z)*2,fire:!0});this.explosive=!1}kill(){this.dead=!0,this.game.scene.remove(this.mesh),this.mesh.material&&this.mesh.material.dispose(),this.light&&this.game.removeLight(this.light)}};var qf=12,jh=new N(11,19.5,11),hc=class{constructor(t,e,i,s){this.renderer=t,this.ui=e,this.input=i,this.audio=s,this.camera=new Ye(32,innerWidth/innerHeight,.5,140),this.hemi=new Wr(6254484,1775122,.55),this.moon=new Yr(9413590,.9),this.moon.castShadow=!0,this.moon.shadow.mapSize.set(2048,2048);let r=this.moon.shadow.camera;r.left=-22,r.right=22,r.top=22,r.bottom=-22,r.near=1,r.far=70,this.moon.shadow.bias=-6e-4,this.moon.shadow.normalBias=.03,this.pool=[];for(let a=0;a<qf;a++){let o=new Pn(16777215,0,10,2);this.pool.push(o)}this.playerLight=new Pn(16765088,6,9,2),this.scene=new En,this.particles=new Jl(this.scene),this.player=new cr(this),this.state="title",this.time=0,this.hitstopT=0,this.shakeAmt=0,this.zoom=1,this.camTarget=new N,this.lights=[],this.effects=[],this.enemies=[],this.projectiles=[],this.loot=[],this.pots=[],this.chests=[],this.braziers=[],this.floatTexts=[],this.floorNum=1,this.stats={kills:0,gold:0,time:0},this.raycaster=new Zr,this.aimPlane=new ui(new N(0,1,0),0),this.rng=new Ki(Date.now()&16777215)}newGame(){let t=this.player=new cr(this),e=this.rng;this.floorNum=1,this.loadFloor(1,!0),t.setEquip("melee",or(e,1,{cat:"melee",kind:"espada",rarity:"comum"})),t.setEquip("bow",or(e,1,{cat:"bow",kind:"arco",rarity:"comum"})),t.setEquip("armor",or(e,1,{cat:"armor",kind:"couro",rarity:"comum"})),t.equip.arts[0]=or(e,1,{cat:"artifact",kind:"chamas",rarity:"comum"}),t.hp=t.maxHp,this.snapshot=this.snap(),this.stats={kills:0,gold:0,time:0}}snap(){let t=this.player;return JSON.stringify({level:t.level,xp:t.xp,xpNext:t.xpNext,gold:t.gold,arrows:t.arrows,equip:t.equip})}restore(t){let e=JSON.parse(t),i=this.player=new cr(this);Object.assign(i,{level:e.level,xp:e.xp,xpNext:e.xpNext,gold:e.gold,arrows:e.arrows}),i.setEquip("melee",e.equip.melee),i.setEquip("bow",e.equip.bow),i.setEquip("armor",e.equip.armor),i.equip.arts=e.equip.arts,i.hp=i.maxHp}retryFloor(){this.restore(this.snapshot),this.loadFloor(this.floorNum,!0)}nextFloor(){this.floorNum++,this.player.hp=this.player.maxHp,this.loadFloor(this.floorNum,!1),this.snapshot=this.snap()}loadFloor(t,e,i=!1){this.disposeFloor(),this.floorNum=t;let s=uf(t),r=this.theme=xa[s],a=this.rng.next()*1e9|0,o=this.dg=ff(a,t,s),l=this.scene=new En;l.background=new Ut(r.fog),l.fog=new Cr(r.fog,.028),this.envMap&&(l.environment=this.envMap,l.environmentIntensity=.35),l.add(this.hemi,this.moon,this.moon.target,this.playerLight),this.hemi.color.set(r.hemiSky),this.hemi.groundColor.set(r.hemiGround),this.hemi.intensity=r.hemi,this.moon.color.set(r.moon),this.moon.intensity=r.moonI;for(let u of this.pool)l.add(u);this.particles.clear(),this.particles.attach(l),this.world=Ef(o),l.add(this.world.group);let c=If(o);this.staticProps=c,l.add(c.group);for(let u of c.flames)l.add(u);this.flames=c.flames,this.lights=[];for(let u of c.lights)this.addLight(u.x,u.y,u.z,u.color,u.intensity,u.dist,u.flicker);for(let u of o.lightsExtra)this.addLight(u.x,u.y,u.z,u.color,u.intensity,u.dist,.2);(o.themeKey==="forja"||o.cell.some(u=>u===At.LAVA))&&this.addLavaLights(),this.enemies=[],this.projectiles=[],this.loot=[],this.effects=[],this.floatTexts.forEach(u=>u.el.remove()),this.floatTexts=[],this.pots=o.pots.map(u=>new tc(this,u.x,u.z)),this.chests=o.chests.map(u=>new jl(this,u.x,u.z,u.big)),this.braziers=o.braziers.map(u=>new ec(this,u.x,u.z)),this.altar=o.altar?new sc(this,o.altar.x,o.altar.z):null,this.gates=new ic(this,o.gates),this.portal=null;for(let u of o.spawns)this.enemies.push(new hr(this,u.type,u.x,u.z));let h=o.boss;this.boss=new lc(this,r.boss,h.x+h.w/2,h.z+h.d/2),this.enemies.push(this.boss),this.bossActive=!1,this.bossDead=!1,this.litCount=0;let d=this.player;if(d.x=Math.floor(o.start.cx)+.5,d.z=Math.floor(o.start.cz)+.5,d.y=this.floorAt(d.x,d.z),d.fh=this.cellH(d.x,d.z),d.dead=!1,d.rollT=0,d.swingT=-1,d.bladesT=0,d.blades=null,d.rot=Math.PI/4,d.rig.hips.rotation.set(0,0,0),d.attach(),this.explored=new Uint8Array(o.W*o.D),this.flow=new Int16Array(o.W*o.D).fill(-1),this.flowT=0,this.flowCell=-1,this.camTarget.set(d.x,d.y,d.z),this.stats.floorStart=this.stats.time,this.state="play",!i){this.ui.floorTitle(t,r.name),t===1&&this.after(4.5,()=>this.ui.toast(this.input.isTouch?"Arraste \xE0 esquerda para andar. Acenda os 3 braseiros (marcados no mapa).":"WASD move \xB7 clique ataca \xB7 bot\xE3o direito atira \xB7 Espa\xE7o rola \xB7 E interage","#d8ccb0")),t===1&&this.after(8,()=>this.ui.toast("Acenda os 3 braseiros ancestrais \u2014 eles aparecem em laranja no minimapa.","#ffb45a")),this.ui.setBoss(null),this.audio.setBoss(!1),this.ui.buildMinimap(this);try{let u=+localStorage.getItem("criptas-best")||0;t>u&&localStorage.setItem("criptas-best",t)}catch{}}}addLavaLights(){let t=this.dg,e=new Set;for(let i=0;i<t.D;i+=4)for(let s=0;s<t.W;s+=4){let r=null;for(let a=0;a<4&&!r;a++)for(let o=0;o<4;o++)if(t.cell[t.idx(s+o,i+a)]===At.LAVA){r=[s+o,i+a];break}r&&!e.has(r.join())&&(e.add(r.join()),this.addLight(r[0]+.5,.6,r[1]+.5,16734736,12,9,.5))}}disposeFloor(){this.world&&(this.world.dispose(),this.world=null),this.staticProps&&(this.staticProps.group.traverse(t=>t.geometry&&t.geometry.dispose()),this.staticProps=null);for(let t of this.enemies)t.removed||t.rig.dispose()}addLight(t,e,i,s,r,a,o=1,l=!1){let c={x:t,y:e,z:i,color:new Ut(s),intensity:r,dist:a,flicker:o,phase:Math.random()*100,priority:l};return this.lights.push(c),c}removeLight(t){let e=this.lights.indexOf(t);e>=0&&this.lights.splice(e,1)}updateLights(){let t=this.time,e=this.camTarget.x,i=this.camTarget.z,s=[];for(let a of this.lights){if(a.intensity<=.01)continue;let o=Math.hypot(a.x-e,a.z-i);o>30||s.push([o-(a.priority?8:0),a])}s.sort((a,o)=>a[0]-o[0]);for(let a=0;a<qf;a++){let o=this.pool[a];if(a<s.length){let l=s[a][1],c=1+l.flicker*(Math.sin(t*9+l.phase)*.07+Math.sin(t*23+l.phase*3)*.05+Math.sin(t*3.1+l.phase)*.04);o.position.set(l.x,l.y,l.z),o.color.copy(l.color);let h=Je((30-s[a][0])/6,0,1);o.intensity=l.intensity*c*h,o.distance=l.dist}else o.intensity=0}let r=this.player;this.playerLight.position.set(r.x,r.y+2.2,r.z)}ci(t,e){let i=Math.floor(t),s=Math.floor(e);return i<0||s<0||i>=this.dg.W||s>=this.dg.D?-1:i+s*this.dg.W}cellType(t,e){let i=this.ci(t,e);return i<0?0:this.dg.cell[i]}cellH(t,e){let i=this.ci(t,e);return i<0?0:this.dg.h[i]}floorAt(t,e){let i=this.ci(t,e);if(i<0)return 0;let s=this.dg.cell[i];return s===At.WATER?-.55:s===At.PIT?-4:s===At.LAVA?-.85:this.dg.h[i]}walkIdx(t){if(t<0)return!1;let e=this.dg.cell[t];return(e===At.FLOOR||e===At.WATER)&&this.dg.solid[t]!==1&&!(this.gates&&this.gates.blocks(t))}walkable(t,e){return this.walkIdx(this.ci(t,e))}canStand(t,e,i,s){let r=this.dg;for(let[a,o]of[[-i,-i],[i,-i],[-i,i],[i,i]]){let l=this.ci(t+a,e+o);if(!this.walkIdx(l)||Math.abs(r.h[l]-s)>1)return!1}return!0}moveEntity(t,e,i){let s=Math.min(t.r,.55)*.9,r=!1;return e&&this.canStand(t.x+e,t.z,s,t.fh)&&(t.x+=e,r=!0),i&&this.canStand(t.x,t.z+i,s,t.fh)&&(t.z+=i,r=!0),r&&(t.fh=this.cellH(t.x,t.z)),r}los(t,e,i,s){let r=Math.hypot(i-t,s-e),a=Math.ceil(r/.35);for(let o=1;o<a;o++){let l=o/a,c=this.cellType(t+(i-t)*l,e+(s-e)*l);if(c===At.WALL||c===At.PILLAR||c===At.VOID)return!1}return!0}blocksProjectile(t,e,i){let s=this.ci(t,e);if(s<0)return!0;let r=this.dg.cell[s];return!!(r===At.WALL||r===At.PILLAR||r===At.VOID||this.dg.solid[s]===1&&i<this.dg.h[s]+1.1||this.gates&&this.gates.blocks(s))}computeFlow(){let t=this.dg,e=this.player,i=this.ci(e.x,e.z);if(i<0||(this.flowT-=this.dtLogic,this.flowT>0&&i===this.flowCell))return;this.flowT=.25,this.flowCell=i;let s=t.W,r=this.flow;r.fill(-1);let a=this.flowQ||(this.flowQ=new Int32Array(s*t.D)),o=0,l=0;for(a[l++]=i,r[i]=0;o<l;){let c=a[o++],h=r[c];if(h>55)continue;let d=c%s,u=c/s|0;for(let f=-1;f<=1;f++)for(let g=-1;g<=1;g++){if(!g&&!f)continue;let _=d+g+(u+f)*s;r[_]!==-1||!this.walkIdx(_)||Math.abs(t.h[_]-t.h[c])>1||g&&f&&(!this.walkIdx(d+g+u*s)||!this.walkIdx(d+(u+f)*s))||(r[_]=h+1,a[l++]=_)}}}flowDir(t){let e=this.dg,i=e.W,s=this.player,r=this.ci(t.x,t.z);if(r<0)return[0,0];let a=this.flow[r];if(a<=0){if(a===0||this.los(t.x,t.z,s.x,s.z)){let m=s.x-t.x,p=s.z-t.z,M=Math.hypot(m,p)||1;return[m/M,p/M]}return[0,0]}let o=-1,l=a,c=r%i,h=r/i|0;for(let m=-1;m<=1;m++)for(let p=-1;p<=1;p++){if(!p&&!m)continue;let M=c+p+(h+m)*i,R=this.flow[M];R>=0&&R<l&&(l=R,o=M)}if(o<0)return[0,0];let d=o%i+.5,u=(o/i|0)+.5,f=d-t.x,g=u-t.z,_=Math.hypot(f,g)||1;return[f/_,g/_]}spawnProjectile(t){this.projectiles.push(new cc(this,t))}spawnLoot(t,e,i,s){let r=new rc(this,t,e,i,s);return this.loot.push(r),r}spawnGold(t,e,i,s){let r=1+Math.floor((this.floorNum-1)/2),a=Math.min(i,14),o=Math.max(1,Math.round(i*r/a));for(let l=0;l<a;l++)this.spawnLoot("gold",t,e,o)}dropItem(t,e,i={}){return this.spawnLoot("item",t,e,or(this.rng,this.floorNum,i))}spawnEnemyNear(t,e,i,s,r,a=!1){for(let o=0;o<14;o++){let l=Math.random()*Math.PI*2,c=s*(.5+Math.random()*.5),h=t+Math.cos(l)*c,d=e+Math.sin(l)*c;if(!this.walkable(h,d)||Math.abs(this.cellH(h,d)-this.cellH(t,e))>1)continue;let u=new hr(this,i,h,d,{awake:r,spawnFx:!0,elite:a});return this.enemies.push(u),this.particles.burst(h,this.floorAt(h,d)+.2,d,25,[.6,.2,1],2.5,.7,.3,-2),u}return null}floatText(t,e,i,s,r,a=!1){let o=this.ui.makeFloat(s,r,a);this.floatTexts.push({wx:t,y:e,wz:i,el:o,t:0,jx:(Math.random()-.5)*.6,big:a})}hitstop(t){this.hitstopT=Math.max(this.hitstopT,t)}shake(t){this.shakeAmt=Math.min(1,Math.max(this.shakeAmt,t))}slashFx(t,e,i,s){let r=t.has("melee","chamas")?16747066:t.has("melee","trovao")?10148095:16773852,a=new hn(e*.3,e,24,1,-Math.PI/2-i/2,i),o=new Le({color:r,transparent:!0,opacity:s?.6:.4,blending:Be,depthWrite:!1,side:ke}),l=new Tt(a,o);l.rotation.order="YXZ",l.rotation.x=-Math.PI/2,l.rotation.y=t.rot,l.position.set(t.x,t.y+.95,t.z),this.scene.add(l);let c=0;this.effects.push({update:h=>(c+=h,o.opacity=(s?.6:.4)*(1-c/.18),l.scale.setScalar(1+c*1.2),c>.18?(this.scene.remove(l),a.dispose(),o.dispose(),!1):!0)})}explosion(t,e,i,s,r,a=!1,o=1){this.particles.burst(t,e,i,a?24:50,r,s*2.2,.7,a?.28:.4,2),this.particles.dust(t,e,i,a?8:20,[.3,.28,.25],s,1.5),this.particles.ring(t,e,i,s,30,r,s*2.5,.3);let l=this.addLight(t,e+1,i,16751168,40*o,s*4,0,!0),c=0;this.effects.push({update:h=>(c+=h,l.intensity=40*o*Math.max(0,1-c/.35),c>.35?(this.removeLight(l),!1):!0)}),this.audio.play("explode",o*(a?.5:1)),this.shake(a?.15:.45)}shockwave(t,e,i,s,r){let a=new hn(.8,1,48),o=new Le({color:r,transparent:!0,blending:Be,depthWrite:!1,side:ke}),l=new Tt(a,o);l.rotation.x=-Math.PI/2;let c=this.floorAt(t,e)+.15;l.position.set(t,c,e),this.scene.add(l);let h=.5,d=!1;this.effects.push({update:u=>{h+=u*8,l.scale.setScalar(h),o.opacity=1-h/i;let f=this.player,g=Math.hypot(f.x-t,f.z-e);!d&&Math.abs(g-h)<.5&&Math.abs(f.y-c)<1.2&&f.hurt(s,null)&&(d=!0);for(let _=0;_<3;_++){let m=Math.random()*Math.PI*2;this.particles.dust(t+Math.cos(m)*h,c,e+Math.sin(m)*h,1,[.5,.45,.4],.2,.5)}return h>i?(this.scene.remove(l),a.dispose(),o.dispose(),!1):!0}})}chainLightning(t,e,i){let s=[new N(this.player.x,this.player.y+1.4,this.player.z)],r=new Set,a=t;for(let o=0;o<i&&a;o++){r.add(a),s.push(new N(a.x,a.y+1,a.z)),a.hurt(e,{stun:.3});let l=null,c=5.5;for(let h of this.enemies){if(h.dead||r.has(h))continue;let d=Math.hypot(h.x-a.x,h.z-a.z);d<c&&(c=d,l=h)}a=l}Vf(this,s),this.audio.play("zap")}useArtifact(t){let e=this.player,i=e.equip.arts[t];if(!i)return;if(e.artCd[t]>0){this.audio.play("deny");return}e.artCd[t]=Bi(i);let s=i.power*e.dmgMult,r=e.x,a=e.z,o=e.y;switch(i.kind){case"chamas":{this.audio.play("fire");let l=0,c=4.8,h=new Set,d=this.addLight(r,o+1,a,16740384,18,12,0,!0);this.effects.push({update:u=>{l+=u*12;for(let f=0;f<7;f++){let g=Math.random()*Math.PI*2;this.particles.fire(r+Math.cos(g)*l,o+.25,a+Math.sin(g)*l,1,.3,[.9,.3,.05],.5)}for(let f of this.enemies)!f.dead&&!h.has(f)&&Math.hypot(f.x-r,f.z-a)<l+f.r&&(h.add(f),f.hurt(30*s,{burn:!0,fire:!0,kx:(f.x-r)*2,kz:(f.z-a)*2}));return d.intensity=18*(1-l/c),l>=c?(this.removeLight(d),!1):!0}});for(let u of this.pots)!u.dead&&Math.hypot(u.x-r,u.z-a)<c&&u.smash();break}case"raio":{let l=null,c=10;for(let h of this.enemies){if(h.dead)continue;let d=Math.hypot(h.x-r,h.z-a);d<c&&this.los(r,a,h.x,h.z)&&(c=d,l=h)}if(!l){e.artCd[t]=.5,this.audio.play("deny"),this.ui.toast("Nenhum inimigo por perto.");return}this.chainLightning(l,24*s,6);break}case"estandarte":{let l=Zh();l.position.set(r,o,a),this.scene.add(l);let c=new Tt(new hn(4.6,5,48),new Le({color:16730682,transparent:!0,opacity:.4,blending:Be,depthWrite:!1}));c.rotation.x=-Math.PI/2,c.position.set(r,o+.05,a),this.scene.add(c);let h=this.addLight(r,o+2.5,a,16736320,10,8,.1,!0);this.audio.play("banner");let d=0;this.effects.push({update:u=>{if(d+=u,Math.hypot(e.x-r,e.z-a)<5&&(e.bannerBuff=.25,e.heal(0),e.hp=Math.min(e.maxHp,e.hp+3*u*i.power)),Math.random()<u*10){let f=Math.random()*Math.PI*2;this.particles.add.emit(r+Math.cos(f)*4.8,o+.1,a+Math.sin(f)*4.8,0,1,0,.8,.25,.05,1,.35,.25,1,0,0)}return c.material.opacity=.3+Math.sin(d*4)*.1,d>8*Math.min(1.6,i.power)?(this.scene.remove(l),this.scene.remove(c),this.removeLight(h),!1):!0}});break}case"vendaval":{this.audio.play("wind"),this.particles.ring(r,o+.6,a,5,60,[.8,.95,.85],10,.35),this.particles.dust(r,o+.2,a,20,[.6,.6,.55],3,1);for(let l of this.enemies){if(l.dead)continue;let c=l.x-r,h=l.z-a,d=Math.hypot(c,h);d<5.5&&l.hurt(8*s,{kx:c/(d||1)*16,kz:h/(d||1)*16,stun:1.3})}for(let l of this.projectiles)l.owner==="enemy"&&Math.hypot(l.x-r,l.z-a)<5&&l.kill();this.shake(.2);break}case"laminas":e.bladesT=8,e.bladePower=s,this.audio.play("summon");break;case"gelo":{this.audio.play("freeze"),this.particles.ring(r,o+.4,a,6,70,[.6,.9,1],12,.3),this.particles.burst(r,o+1,a,40,[.7,.95,1],3,1,.2);let l=new Tt(new Ni(.5),new Ce({color:11463423,emissive:3844320,emissiveIntensity:2,roughness:.1,transparent:!0,opacity:.85}));l.scale.set(.7,1.6,.7),l.position.set(r,o+.9,a),this.scene.add(l);for(let h of this.enemies)!h.dead&&Math.hypot(h.x-r,h.z-a)<6.5&&h.hurt(10*s,{freeze:3*Math.min(1.5,i.power)});let c=0;this.effects.push({update:h=>(c+=h,l.rotation.y+=h,c>3?(this.scene.remove(l),l.geometry.dispose(),l.material.dispose(),this.particles.burst(r,o+1,a,20,[.7,.95,1],2,.6,.2,5),!1):!0)});break}}}after(t,e){let i=0;this.effects.push({update:s=>(i+=s,i>=t?(e(),!1):!0)})}onBrazierLit(t){this.litCount++;let i=this.braziers.length-this.litCount;this.ui.toast(i>0?`Braseiro ancestral aceso! Faltam ${i}.`:"Todos os braseiros est\xE3o acesos! O port\xE3o do guardi\xE3o se abriu.","#ffb45a");let s=3+Math.min(5,this.floorNum);for(let r=0;r<s;r++){let a=this.rng.weighted(this.theme.enemies),o=r===0&&this.floorNum>=2&&i===0;this.after(.6+r*.25,()=>this.spawnEnemyNear(t.x,t.z,a,5,!0,o))}i===0&&this.after(1.5,()=>this.gates.open())}onBossDead(t){this.bossDead=!0,this.bossActive=!1,this.audio.setBoss(!1),this.ui.toast(`${t.B.name} foi derrotado!`,"#ffd76a"),this.after(2.5,()=>{this.ui.setBoss(null),this.gates.open()}),this.after(3.2,()=>{let e=this.dg.boss;this.portal=new nc(this,e.x+e.w/2+.5,e.z+e.d/2+.5),this.audio.play("portal"),this.ui.toast("Um portal se abriu no centro da arena.","#8fd8ff")})}onPlayerDead(){this.audio.play("die"),this.after(1.8,()=>{this.player.dead&&(this.state="dead",this.ui.showDeath(this))})}enterPortal(){this.state==="play"&&(this.state="floorDone",this.audio.play("portal"),this.ui.showFloorDone(this))}nearestInteract(){let t=this.player,e=null,i=1.9,s=(r,a=1.9)=>{if(!r||!r.prompt)return;let o=Math.hypot(r.x-t.x,r.z-t.z);o<Math.min(i,a)&&(i=o,e=r)};for(let r of this.chests)s(r);for(let r of this.braziers)s(r,2.1);s(this.altar,2.1),s(this.portal,2.4);for(let r of this.loot)r.kind==="item"&&!r.dead&&s(r,1.6);return e}pickupItem(t,e){let i=this.player,s=t.data;t.remove(),this.audio.play("pickup");let r=null;if(s.cat==="artifact"){let a=e;if(a===void 0&&(a=i.equip.arts.findIndex(o=>!o),a<0)){let o=1e9;i.equip.arts.forEach((l,c)=>{let h=lr(l);h<o&&(o=h,a=c)})}r=i.equip.arts[a],i.equip.arts[a]=s,i.artCd[a]=Math.min(i.artCd[a],2)}else r=i.equip[s.cat],i.setEquip(s.cat,s);if(this.ui.toast(`Equipado: ${s.name}`,s.rarity==="unico"?"#ffb92e":s.rarity==="raro"?"#4fb3ff":"#e8e0d0"),r){let a=this.spawnLoot("item",i.x,i.z,r);a.vx*=.3,a.vz*=.3,a.t=0}}update(t){let e=this.input;if(this.time+=t,this.state==="title"){this.titleCam(t),this.world&&this.world.update(this.time),this.updateLights(),this.particles.update(t),this.animateFlames(t);return}if(e.pressed("pause")&&(this.state==="play"||this.state==="pause")&&(this.state==="play"?(this.state="pause",this.ui.showPause(this)):(this.state="play",this.ui.hidePanels())),this.state!=="play"&&this.state!=="dead"&&this.state!=="floorDone"){e.endFrame();return}let i=t;this.hitstopT>0&&(this.hitstopT-=t,i*=.08),this.dtLogic=i,this.state==="play"&&(this.stats.time+=t);let s=this.player;if(e.aim=null,e.mouseActive){this.raycaster.setFromCamera(e.mouseNdc,this.camera),this.aimPlane.constant=-(s.y+1);let c=new N;this.raycaster.ray.intersectPlane(this.aimPlane,c)&&(e.aim=c)}let r=this.state==="play"&&!s.dead?this.nearestInteract():null;if(this.near=r,r&&r.kind==="item"&&r.data.cat==="artifact"&&e.down("interact"))for(let c=0;c<3;c++)e.pressed("art"+(c+1))&&(e.consume("art"+(c+1)),e.consume("interact"),this.pickupItem(r,c),this.near=null);if(this.near&&e.pressed("interact")&&(this.near.kind==="item"?this.pickupItem(this.near):this.near.interact()),this.state==="play"||s.dead){let c=s.x,h=s.z;s.update(i,e,this.time),s.vx=(s.x-c)/Math.max(i,1e-4),s.vz=(s.z-h)/Math.max(i,1e-4)}this.computeFlow();let a=this.dg.boss;!this.bossActive&&!this.bossDead&&!this.gates.closed&&s.x>a.x+1.5&&s.x<a.x+a.w-1.5&&s.z>a.z+1.5&&s.z<a.z+a.d-1.5&&(this.bossActive=!0,this.gates.close(),this.boss.awake=!0,this.audio.play("roar"),this.audio.setBoss(!0),this.ui.setBoss(this.boss),this.ui.toast(this.boss.B.name,"#ff6a4a",!0),this.shake(.4));for(let c of this.enemies){if(!c.awake&&!c.dead&&Math.abs(c.x-s.x)+Math.abs(c.z-s.z)>40){c.rig.root.visible=!1;continue}c.rig.root.visible=!c.dead||c.deadT<1.5,c.update(i,this.time)}this.enemies=this.enemies.filter(c=>!c.removed);for(let c of this.projectiles)c.update(i);this.projectiles=this.projectiles.filter(c=>!c.dead);for(let c of this.loot)c.update(i,this.time);this.loot=this.loot.filter(c=>!c.dead);for(let c of this.chests)c.update(i);for(let c of this.braziers)c.update(i,this.time);this.altar&&this.altar.update(i,this.time),this.gates.update(i),this.portal&&(this.portal.update(i),Math.hypot(s.x-this.portal.x,s.z-this.portal.z)<1&&this.state==="play"&&this.enterPortal());let o=this.effects;this.effects=[];let l=o.filter(c=>c.update(i));this.effects=l.concat(this.effects),this.world.update(this.time),this.animateFlames(i),this.ambient(i),this.particles.update(i),this.updateCamera(t),this.updateLights(),this.updateExplored(),this.updateFloats(t),this.audio.update(),this.ui.update(this),e.endFrame()}animateFlames(t){let e=this.time;if(this.flames)for(let i=0;i<this.flames.length;i++){let s=this.flames[i],r=s.userData.base,a=1+Math.sin(e*15+i*1.7)*.08+Math.sin(e*27+i)*.05;s.scale.set(.34*r*(2-a),.6*r*a,1)}}ambient(t){let e=this.player;Math.random()<t*25&&this.particles.mote(e.x+(Math.random()-.5)*22,e.y+Math.random()*4,e.z+(Math.random()-.5)*22);for(let i of this.dg.torches)Math.abs(i.x-e.x)+Math.abs(i.z-e.z)>22||(Math.random()<t*2.5&&this.particles.ember(i.x+i.nx*.02,i.y+.45,i.z+i.nz*.02),Math.random()<t*10&&this.particles.fire(i.x+i.nx*.02,i.y+.2,i.z+i.nz*.02,1,.08,[1,.5,.15],.28));(this.theme===xa.forja||this.dg.themeKey==="forja")&&Math.random()<t*12&&this.particles.ember(e.x+(Math.random()-.5)*20,-.5,e.z+(Math.random()-.5)*20,[1,.45,.1])}updateCamera(t){let e=this.player,i=this.input.aim?.12:0,s=e.x+(this.input.aim?(this.input.aim.x-e.x)*i:0),r=e.z+(this.input.aim?(this.input.aim.z-e.z)*i:0);this.camTarget.x=zi(this.camTarget.x,s,6,t),this.camTarget.z=zi(this.camTarget.z,r,6,t),this.camTarget.y=zi(this.camTarget.y,e.y,5,t);let a=(this.bossActive?1.2:1)*this.input.zoom;this.zoom=zi(this.zoom,a,3,t);let o=this.shakeAmt;this.shakeAmt=Math.max(0,this.shakeAmt-t*2.2);let l=(Math.random()-.5)*o*.6,c=(Math.random()-.5)*o*.6;this.camera.position.set(this.camTarget.x+jh.x*this.zoom+l,this.camTarget.y+jh.y*this.zoom+c,this.camTarget.z+jh.z*this.zoom-l),this.camera.lookAt(this.camTarget.x,this.camTarget.y+.8,this.camTarget.z);let h=44/2048,d=Math.round(this.camTarget.x/h)*h,u=Math.round(this.camTarget.z/h)*h;this.moon.position.set(d-12,26,u+4),this.moon.target.position.set(d,0,u)}titleCam(t){if(!this.dg)return;let e=this.dg.start,i=this.time*.06,s=20;this.camera.position.set(e.cx+Math.cos(i)*s,16,e.cz+Math.sin(i)*s),this.camera.lookAt(e.cx,0,e.cz),this.camTarget.set(e.cx,0,e.cz),this.moon.position.set(e.cx-12,26,e.cz+4),this.moon.target.position.set(e.cx,0,e.cz);let r=this.player;r.rig.root.position.set(r.x,r.y,r.z)}updateExplored(){if(this.expT=(this.expT||0)-this.dtLogic,this.expT>0)return;this.expT=.15;let t=this.player,e=this.dg,i=8,s=!1,r=Math.floor(t.x),a=Math.floor(t.z);for(let o=-i;o<=i;o++)for(let l=-i;l<=i;l++){if(l*l+o*o>i*i)continue;let c=r+l,h=a+o;if(c<0||h<0||c>=e.W||h>=e.D)continue;let d=c+h*e.W;this.explored[d]||(this.explored[d]=1,s=!0)}s&&(this.ui.minimapDirty=!0)}updateFloats(t){let e=new N,i=innerWidth,s=innerHeight;this.floatTexts=this.floatTexts.filter(r=>(r.t+=t,r.t>.9?(r.el.remove(),!1):!0));for(let r of this.floatTexts)e.set(r.wx,r.y+r.t*1.4,r.wz).project(this.camera),r.el.style.opacity=String(Math.max(0,1-Math.max(0,r.t-.5)*2.5)),r.el.style.transform=`translate(${(e.x*.5+.5)*i+r.jx*30}px, ${(-e.y*.5+.5)*s}px) translate(-50%, -50%) scale(${r.big?1.3:1})`}};var Me=(n,t=document)=>t.querySelector(n),uc=(n,t,e)=>{let i=document.createElement(n);return t&&(i.className=t),e!==void 0&&(i.innerHTML=e),i},Vn={chamas:'<svg viewBox="0 0 32 32"><path d="M16 3c2 6 9 9 9 17a9 9 0 0 1-18 0c0-5 3-7 4-11 1 3 2 4 4 5-1-4 0-8 1-11z" fill="#ff7a2e"/><path d="M16 14c1 3 5 5 5 9a5 5 0 0 1-10 0c0-3 3-5 5-9z" fill="#ffd36a"/></svg>',raio:'<svg viewBox="0 0 32 32"><path d="M19 2L6 18h8l-3 12 15-18h-9z" fill="#8fd8ff" stroke="#fff" stroke-width="1"/></svg>',estandarte:'<svg viewBox="0 0 32 32"><rect x="7" y="3" width="2.5" height="27" fill="#a07850"/><path d="M9.5 5h15l-4 6 4 6h-15z" fill="#d8352a"/><circle cx="15" cy="11" r="2.2" fill="#ffd36a"/></svg>',vendaval:'<svg viewBox="0 0 32 32" fill="none" stroke="#c8e8d0" stroke-width="2.5" stroke-linecap="round"><path d="M4 11h15a4 4 0 1 0-4-4"/><path d="M4 17h21a4 4 0 1 1-4 4"/><path d="M4 23h10"/></svg>',laminas:'<svg viewBox="0 0 32 32"><g fill="#a89cff"><path d="M16 2l2 12-2 2-2-2z"/><path d="M29 22l-11-5-.5-2.7 2.7-.8z" /><path d="M5 24l7-10 2.7.6.3 2.8z"/></g><circle cx="16" cy="16" r="2.5" fill="#fff"/></svg>',gelo:'<svg viewBox="0 0 32 32" stroke="#8ff0ff" stroke-width="2.4" stroke-linecap="round"><path d="M16 3v26M4.7 9.5l22.6 13M4.7 22.5l22.6-13"/><path d="M12 5l4 4 4-4M12 27l4-4 4 4" fill="none"/></svg>',pocao:'<svg viewBox="0 0 32 32"><rect x="12" y="2" width="8" height="5" rx="1" fill="#a07850"/><path d="M13 7h6v5l6 7a8 8 0 1 1-18 0l6-7z" fill="#c8d0d8" opacity=".5"/><path d="M8.5 19h15a8 8 0 1 1-15 0z" fill="#e0303a"/><circle cx="13" cy="21" r="1.6" fill="#ff9a9a"/></svg>',flecha:'<svg viewBox="0 0 32 32"><path d="M5 27L25 7" stroke="#d8c8a0" stroke-width="2.5"/><path d="M25 7l-7 1 6 6z" fill="#c0c8d0"/><path d="M5 27l1-6 2 4 4 2z" fill="#e05040"/></svg>',ouro:'<svg viewBox="0 0 32 32"><circle cx="16" cy="16" r="11" fill="#e8b440" stroke="#8a6010" stroke-width="2"/><circle cx="16" cy="16" r="6" fill="none" stroke="#fff3b0" stroke-width="1.5" opacity=".7"/></svg>',melee:'<svg viewBox="0 0 32 32"><path d="M24 3l5 0 0 5-15 15-5-5z" fill="#d0d6de"/><path d="M8 17l7 7-2 2-7-7z" fill="#e0b050"/><path d="M8 24l-4 4" stroke="#8a5a30" stroke-width="3"/></svg>',bow:'<svg viewBox="0 0 32 32" fill="none"><path d="M8 4c14 4 14 20 0 24" stroke="#b08050" stroke-width="3"/><path d="M8 4v24" stroke="#ddd" stroke-width="1"/></svg>',armor:'<svg viewBox="0 0 32 32"><path d="M6 6l6-3h8l6 3-2 8v13H8V14z" fill="#b8c0c8"/><path d="M12 3h8v6h-8z" fill="#606870"/></svg>'};var dc=class{constructor(t,e){this.root=t,this.input=e,this.on={},this.cache={},t.innerHTML=`
      <div id="hurt"></div>
      <div id="bars"></div>
      <div id="floats"></div>
      <div id="hud" class="hidden">
        <div id="floorinfo"><div id="floorname"></div><div id="objective"></div></div>
        <div id="mapwrap"><canvas id="minimap" width="200" height="200"></canvas><div class="mapn">N</div></div>
        <div id="bossbar" class="hidden"><div id="bossname"></div><div class="bar"><div id="bossfill"></div><div id="bossghost"></div></div></div>
        <div id="toasts"></div>
        <div id="prompt" class="hidden"></div>
        <div id="bottom">
          <div id="xpbar"><div id="xpfill"></div><span id="lvl"></span></div>
          <div id="hotbar">
            <div class="slot big" id="s-potion" data-act="potion"><div class="ico">${Vn.pocao}</div><div class="cd"></div><kbd>Q</kbd></div>
            <div id="orb"><div id="orbfill"></div><div id="orbshine"></div><span id="hptext"></span><div id="rollpip"></div></div>
            <div class="slot" id="s-art0" data-act="art1"><div class="ico"></div><div class="cd"></div><kbd>1</kbd></div>
            <div class="slot" id="s-art1" data-act="art2"><div class="ico"></div><div class="cd"></div><kbd>2</kbd></div>
            <div class="slot" id="s-art2" data-act="art3"><div class="ico"></div><div class="cd"></div><kbd>3</kbd></div>
          </div>
          <div id="res"><span class="r">${Vn.flecha}<b id="arrows"></b></span><span class="r">${Vn.ouro}<b id="gold"></b></span></div>
          <div id="gear"></div>
        </div>
      </div>
      <div id="touch" class="hidden">
        <div class="tb" data-act="attack" style="right:20px;bottom:110px;width:84px;height:84px">\u2694</div>
        <div class="tb" data-act="shoot" style="right:118px;bottom:40px">\u{1F3F9}</div>
        <div class="tb" data-act="roll" style="right:118px;bottom:140px">\u27F2</div>
        <div class="tb" data-act="interact" style="right:30px;bottom:210px">E</div>
        <div class="tb" data-act="pause" style="right:16px;top:230px;width:44px;height:44px">\u275A\u275A</div>
      </div>
      <div id="panel" class="hidden"></div>`,this.hud=Me("#hud"),this.panel=Me("#panel"),this.floats=Me("#floats"),this.mm=Me("#minimap"),this.mctx=this.mm.getContext("2d");for(let i of t.querySelectorAll("[data-act]")){let s=i.dataset.act,r=o=>{o.preventDefault(),e.setTouch(s,!0),i.classList.add("down")},a=o=>{o.preventDefault(),e.setTouch(s,!1),i.classList.remove("down")};i.addEventListener("touchstart",r,{passive:!1}),i.addEventListener("touchend",a),i.addEventListener("touchcancel",a),i.addEventListener("mousedown",o=>{i.classList.contains("slot")&&(e.setTouch(s,!0),setTimeout(()=>e.setTouch(s,!1),60),o.stopPropagation())})}("ontouchstart"in window||navigator.maxTouchPoints>0)&&Me("#touch").classList.remove("hidden")}showPanel(t,e=""){this.panel.className=e,this.panel.innerHTML=`<div class="card">${t}</div>`;for(let i of this.panel.querySelectorAll("[data-go]"))i.addEventListener("click",()=>this.on[i.dataset.go]&&this.on[i.dataset.go](i))}hidePanels(){this.panel.className="hidden",this.panel.innerHTML=""}showTitle(t){this.hud.classList.add("hidden"),this.showPanel(`
      <div class="logo"><span>Criptas</span><small>de</small><span>Valdor</span></div>
      <p class="sub">Des\xE7a \xE0s profundezas, acenda os braseiros ancestrais<br>e derrote os guardi\xF5es que dormem sob a pedra.</p>
      <button data-go="play" class="primary">Jogar</button>
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
        <tr><td>Roda do mouse</td><td>Zoom</td></tr>
        <tr><td><kbd>Esc</kbd> / <kbd>P</kbd></td><td>Pausa</td></tr>
      </table>
      <p class="tiny">Controle (gamepad): anal\xF3gico esquerdo move, direito mira, X ataca, RT atira, A rola, B po\xE7\xE3o, Y interage, LB/LT/RB artefatos.<br>No celular: arraste no lado esquerdo para andar e use os bot\xF5es \xE0 direita (a mira \xE9 autom\xE1tica).</p>
      <button data-go="back">Voltar</button>`}showControls(t){this.on.back=t,this.showPanel(this.controlsHtml(),"title")}showPause(t){let e=t.quality;this.showPanel(`<h2>Pausado</h2>
      <button data-go="resume" class="primary">Continuar</button>
      <button data-go="controlsP">Controles</button>
      <button data-go="mute">Som: ${t.audio.muted?"desligado":"ligado"}</button>
      <button data-go="quality">Gr\xE1ficos: ${e}</button>
      <button data-go="retry">Reiniciar andar</button>
      <button data-go="menu">Menu principal</button>
      ${this.statsHtml(t)}`)}statsHtml(t){let e=t.player,i=s=>s?`<span style="color:${mn[s.rarity].color}">${s.name}</span>`:"\u2014";return`<div class="gearlist">
      <div>${Vn.melee}${i(e.equip.melee)}</div><div>${Vn.bow}${i(e.equip.bow)}</div><div>${Vn.armor}${i(e.equip.armor)}</div>
      ${e.equip.arts.map(s=>`<div>${s?Vn[s.kind]:'<span class="ph"></span>'}${i(s)}</div>`).join("")}
      <div class="lv">N\xEDvel ${e.level} \xB7 Vida ${Math.round(e.maxHp)} \xB7 Prote\xE7\xE3o ${Math.round(e.dr*100)}%</div></div>`}showDeath(t){this.showPanel(`<h2 class="red">Voc\xEA caiu</h2>
      <p class="sub">As sombras de ${t.theme.name} reclamam mais um aventureiro.</p>
      <div class="stats"><div><b>${t.floorNum}</b>andar</div><div><b>${t.stats.kills}</b>inimigos</div><div><b>${t.player.level}</b>n\xEDvel</div></div>
      <button data-go="retry" class="primary">Tentar de novo</button>
      <button data-go="menu">Menu principal</button>
      <p class="tiny">Ao tentar de novo, o andar \xE9 recriado e voc\xEA volta com o equipamento que tinha ao entrar nele.</p>`)}showFloorDone(t){let e=Math.round(t.stats.time-(t.stats.floorStart||0)),i=t.floorNum%3===0;this.showPanel(`<h2>${i?"Vit\xF3ria!":`Andar ${t.floorNum} conclu\xEDdo`}</h2>
      ${i?'<p class="sub">O Colosso de Obsidiana caiu e o cora\xE7\xE3o da Forja Profunda se apagou. As Criptas de Valdor est\xE3o livres... por enquanto.<br>Mais abaixo, as profundezas continuam \u2014 e ficam mais cru\xE9is.</p>':'<p class="sub">O portal pulsa com uma luz fria. Algo pior espera l\xE1 embaixo.</p>'}
      <div class="stats"><div><b>${t.stats.kills}</b>inimigos</div><div><b>${t.player.gold}</b>ouro</div><div><b>${Math.floor(e/60)}:${String(e%60).padStart(2,"0")}</b>tempo</div><div><b>${t.player.level}</b>n\xEDvel</div></div>
      <button data-go="next" class="primary">${i?"Descer \xE0s profundezas":"Descer"}</button>
      <button data-go="menu">Menu principal</button>`)}floorTitle(t,e){this.hud.classList.remove("hidden"),Me("#floorname").textContent=`Andar ${t} \xB7 ${e}`,this.bigTitle(`Andar ${t}`,e)}bigTitle(t,e){let i=uc("div","bigtitle",`<small>${t}</small>${e}`);this.root.appendChild(i),setTimeout(()=>i.remove(),4200)}toast(t,e="#e8e0d0",i=!1){let s=uc("div","toast"+(i?" big":""),t);s.style.color=e;let r=Me("#toasts");for(r.appendChild(s);r.children.length>4;)r.firstChild.remove();setTimeout(()=>{s.classList.add("out"),setTimeout(()=>s.remove(),600)},i?3200:2600)}hurtFlash(){let t=Me("#hurt");t.classList.remove("on"),t.offsetWidth,t.classList.add("on")}makeFloat(t,e,i){let s=uc("div","float"+(i?" big":""),t);return s.style.color=e,this.floats.appendChild(s),s}setBoss(t){this.boss=t,Me("#bossbar").classList.toggle("hidden",!t),t&&(Me("#bossname").textContent=t.B.name,this.bossGhost=1)}set(t,e,i){this.cache[t]!==e&&(this.cache[t]=e,i(e))}update(t){let e=t.player,i=Math.max(0,e.hp/e.maxHp);this.set("hp",Math.round(i*200),()=>{Me("#orbfill").style.transform=`translateY(${(1-i)*100}%)`,Me("#orb").classList.toggle("low",i<.3)}),this.set("hpt",`${Math.ceil(e.hp)}/${Math.round(e.maxHp)}`,c=>Me("#hptext").textContent=c),this.set("xp",Math.round(e.xp/e.xpNext*100),c=>Me("#xpfill").style.width=c+"%"),this.set("lvl",e.level,c=>Me("#lvl").textContent="N\xEDvel "+c),this.set("arrows",e.arrows,c=>{Me("#arrows").textContent=c,Me("#arrows").classList.toggle("empty",c===0)}),this.set("gold",e.gold,c=>Me("#gold").textContent=c),this.set("roll",e.rollCd>0?Math.round(e.rollCd/e.rollMax*20):0,c=>{Me("#rollpip").style.opacity=c?.35:1}),this.cool("#s-potion",e.potionCd/e.potionMax,e.potionCd);for(let c=0;c<3;c++){let h=e.equip.arts[c];this.set("art"+c,h?h.id:0,()=>{let d=Me("#s-art"+c);d.querySelector(".ico").innerHTML=h?Vn[h.kind]:"",d.classList.toggle("empty",!h),d.style.borderColor=h?mn[h.rarity].color:"",d.title=h?h.name:""}),this.cool("#s-art"+c,h?e.artCd[c]/Bi(h):0,e.artCd[c])}let s=t.litCount,r=t.braziers.length,a=t.bossDead?t.portal?"Entre no portal para descer.":"O guardi\xE3o caiu!":t.bossActive?`Derrote ${t.boss.B.name}.`:s<r?`Acenda os braseiros ancestrais: ${s}/${r}`:"Enfrente o guardi\xE3o na grande arena.";if(this.set("obj",a,c=>Me("#objective").textContent=c),this.boss){let c=Math.max(0,this.boss.hp/this.boss.maxHp);this.bossGhost=Math.max(c,(this.bossGhost||1)-.004),Me("#bossfill").style.width=c*100+"%",Me("#bossghost").style.width=this.bossGhost*100+"%"}let o=t.near,l=o?o.kind==="item"?"i"+o.data.id+":"+t.player.equip.arts.map(c=>c&&c.id).join():o.prompt:"";this.set("prompt",l,()=>this.renderPrompt(t,o)),this.drawMinimap(t),this.enemyBars(t)}enemyBars(t){let e=this.barsBox||(this.barsBox=Me("#bars"));this.barPool=this.barPool||[];let i=t.camera,s=t.player,r=innerWidth,a=innerHeight,o=[];for(let c of t.enemies)if(!(c.dead||c.isBoss||!c.awake||c.hp>=c.maxHp||!c.rig.root.visible)&&!(Math.abs(c.x-s.x)+Math.abs(c.z-s.z)>26)&&(o.push(c),o.length>=24))break;let l=this._v||(this._v=i.position.clone());for(let c=0;c<Math.max(o.length,this.barPool.length);c++){let h=this.barPool[c];h||(h=uc("div","ebar","<i></i>"),e.appendChild(h),this.barPool.push(h));let d=o[c];if(!d){h._on&&(h.style.display="none",h._on=!1);continue}h._on||(h.style.display="",h._on=!0),l.set(d.x,d.y+1.35*d.rig.root.scale.y+.75,d.z).project(i),h.style.transform=`translate(${(l.x*.5+.5)*r}px, ${(-l.y*.5+.5)*a}px) translate(-50%, -50%)`,h.firstChild.style.width=Math.max(0,d.hp/d.maxHp*100)+"%",h.classList.toggle("elite",!!d.elite)}}cool(t,e,i){let s=Me(t),r=Math.round(Math.max(0,e)*60);s._v!==r&&(s._v=r,s.querySelector(".cd").style.height=Math.max(0,Math.min(1,e))*100+"%",s.classList.toggle("ready",r===0))}renderPrompt(t,e){let i=Me("#prompt");if(!e){i.classList.add("hidden");return}if(i.classList.remove("hidden"),e.kind!=="item"){i.className="simple",i.innerHTML=`<kbd>E</kbd> ${e.prompt}`;return}let s=e.data,r=mn[s.rarity],a=t.player,o=null,l="";if(s.cat==="artifact"){if(a.equip.arts.findIndex(p=>!p)<0){let p=1e9,M=0;a.equip.arts.forEach((R,y)=>{let w=lr(R);w<p&&(p=w,M=y)}),o=a.equip.arts[M],l=`<div class="hint">Substitui o slot ${M+1}. Segure <kbd>E</kbd> e aperte <kbd>1</kbd>-<kbd>3</kbd> para escolher outro.</div>`}}else o=a.equip[s.cat];let c=Yh(s),h=o&&o.cat===s.cat?Yh(o):null,d=m=>parseFloat(String(m).replace(",",".").replace("+","")),u=c.map(([m,p],M)=>{let R="";if(h&&h[M]&&h[M][0]===m){let y=d(p),w=d(h[M][1]);if(!isNaN(y)&&!isNaN(w)&&Math.abs(y-w)>.01){let S=m==="Recarga"?y<w:y>w;R=`<i class="${S?"up":"dn"}">${S?"\u25B2":"\u25BC"}</i>`}}return`<tr><td>${m}</td><td>${p} ${R}</td></tr>`}).join(""),f=Bf(s).map(m=>`<li>${m}</li>`).join(""),g=s.cat==="artifact"?`<div class="desc">${wa[s.kind].desc}</div>`:"",_=o?lr(s)-lr(o):1;i.className="item",i.innerHTML=`<div class="ititle" style="color:${r.color}">${s.name}</div>
      <div class="icat">${r.name} \xB7 ${Of(s.cat)}</div>${g}
      <table>${u}</table>${f?`<ul>${f}</ul>`:""}
      ${o?`<div class="vs">Equipado: <span style="color:${mn[o.rarity].color}">${o.name}</span> ${_>.5?'<i class="up">melhor</i>':_<-.5?'<i class="dn">pior</i>':""}</div>`:""}
      ${l}<div class="act"><kbd>E</kbd> Equipar</div>`,i.style.borderColor=r.color}buildMinimap(t){let e=t.dg,i=3;this.off=document.createElement("canvas"),this.off.width=e.W*i,this.off.height=e.D*i,this.minimapDirty=!0}drawMinimap(t){let e=t.dg,i=3,s=this.off;if(!s)return;if(this.minimapDirty){this.minimapDirty=!1;let u=s.getContext("2d");u.clearRect(0,0,s.width,s.height);let f=e.boss;for(let g=0;g<e.D;g++)for(let _=0;_<e.W;_++){let m=_+g*e.W;if(!t.explored[m])continue;let p=e.cell[m],M=null;p===At.FLOOR?M=_>=f.x&&_<f.x+f.w&&g>=f.z&&g<f.z+f.d?"#8a5a50":e.h[m]>0?"#a89a86":"#857a6c":p===At.WALL?M="#2e2925":p===At.PILLAR?M="#3a342e":p===At.WATER?M="#2c5a68":p===At.LAVA?M="#d05a1a":p===At.PIT&&(M="#0c0b0a"),M&&(u.fillStyle=M,u.fillRect(_*i,g*i,i,i))}}let r=this.mctx,a=this.mm.width,o=t.player;r.clearRect(0,0,a,a),r.save(),r.beginPath(),r.arc(a/2,a/2,a/2-2,0,Math.PI*2),r.clip(),r.fillStyle="rgba(8,7,6,0.8)",r.fillRect(0,0,a,a),r.translate(a/2,a/2),r.rotate(Math.PI/4),r.scale(1.15,1.15),r.translate(-o.x*i,-o.z*i),r.drawImage(s,0,0);let l=(u,f,g,_,m)=>{r.beginPath(),r.arc(u*i,f*i,g,0,Math.PI*2),r.fillStyle=_,r.fill(),m&&(r.strokeStyle=m,r.lineWidth=1.5,r.stroke())},c=(u,f)=>t.explored[Math.floor(u)+Math.floor(f)*e.W];for(let u of t.chests)!u.opened&&c(u.x,u.z)&&l(u.x,u.z,3,"#e8b440");for(let u of t.loot)u.kind==="item"&&l(u.x,u.z,2.5,mn[u.data.rarity].color);t.altar&&c(t.altar.x,t.altar.z)&&l(t.altar.x,t.altar.z,3.5,"#ffd36a","#fff");for(let u of t.enemies)!u.dead&&u.awake&&!u.isBoss&&Math.hypot(u.x-o.x,u.z-o.z)<24&&l(u.x,u.z,2,"#e04030");let h=performance.now()/1e3;for(let u of t.braziers)l(u.x,u.z,u.lit?4.5:3.5+Math.sin(h*4),u.lit?"#ffcc50":"#ff7a20",u.lit?"#fff":"#3a1a08");let d=e.boss;if(t.litCount>=t.braziers.length&&!t.bossDead&&(r.save(),r.translate((d.x+d.w/2)*i,(d.z+d.d/2)*i),r.rotate(-Math.PI/4),r.font="bold 16px serif",r.textAlign="center",r.textBaseline="middle",r.fillStyle="#ff5a40",r.fillText("\u2620",0,0),r.restore()),t.boss&&t.bossActive&&l(t.boss.x,t.boss.z,5,"#ff3020","#fff"),t.portal&&l(t.portal.x,t.portal.z,5+Math.sin(h*5),"#6fd8ff","#fff"),t.gates.closed){r.fillStyle="#c03020";for(let u of e.gates)c(u.x,u.z)&&r.fillRect(u.x*i,u.z*i,i,i)}r.save(),r.translate(o.x*i,o.z*i),r.rotate(Math.atan2(Math.cos(o.rot),Math.sin(o.rot))),r.beginPath(),r.moveTo(7,0),r.lineTo(-4,4.5),r.lineTo(-2,0),r.lineTo(-4,-4.5),r.closePath(),r.fillStyle="#fff",r.fill(),r.strokeStyle="#1a3a7a",r.lineWidth=1.5,r.stroke(),r.restore(),r.restore()}};var Tv={up:["KeyW","ArrowUp"],down:["KeyS","ArrowDown"],left:["KeyA","ArrowLeft"],right:["KeyD","ArrowRight"],attack:["M0","KeyJ"],shoot:["M2","KeyK","KeyL"],roll:["Space","ShiftLeft","ShiftRight"],potion:["KeyQ","KeyH"],art1:["Digit1","Numpad1"],art2:["Digit2","Numpad2"],art3:["Digit3","Numpad3"],interact:["KeyE","KeyF","Enter"],pause:["Escape","KeyP"]},Ev={roll:[0],potion:[1],attack:[2,5],interact:[3],shoot:[7],art1:[4],art2:[6],art3:[8],pause:[9]},fc=class{constructor(t){this.keys=new Set,this.pressedSet=new Set,this.consumed=new Set,this.mouseNdc=new xt,this.mouseActive=!1,this.zoom=1,this.ax=0,this.ay=0,this.aim=null,this.aimStick=null,this.touch={id:null,ox:0,oy:0,x:0,y:0},this.touchActions=new Set,this.isTouch=!1,this.padPrev=new Set;let e=r=>{this.keys.has(r)||this.pressedSet.add(r),this.keys.add(r)},i=r=>this.keys.delete(r);addEventListener("keydown",r=>{(r.code==="Tab"||r.code==="Space"||r.code.startsWith("Arrow"))&&r.preventDefault(),r.repeat||e(r.code)}),addEventListener("keyup",r=>i(r.code)),addEventListener("blur",()=>{this.keys.clear(),this.touchActions.clear()}),t.addEventListener("mousedown",r=>{this.mouseActive=!0,e("M"+r.button)}),addEventListener("mouseup",r=>i("M"+r.button)),addEventListener("mousemove",r=>{this.mouseNdc.set(r.clientX/innerWidth*2-1,-(r.clientY/innerHeight)*2+1),this.isTouch||(this.mouseActive=!0)}),t.addEventListener("contextmenu",r=>r.preventDefault()),addEventListener("wheel",r=>{this.zoom=Math.min(1.35,Math.max(.7,this.zoom+Math.sign(r.deltaY)*.06))},{passive:!0}),t.addEventListener("touchstart",r=>{this.isTouch=!0,this.mouseActive=!1;for(let a of r.changedTouches)a.clientX<innerWidth*.5&&this.touch.id===null&&(this.touch={id:a.identifier,ox:a.clientX,oy:a.clientY,x:a.clientX,y:a.clientY});r.preventDefault()},{passive:!1}),t.addEventListener("touchmove",r=>{for(let a of r.changedTouches)a.identifier===this.touch.id&&(this.touch.x=a.clientX,this.touch.y=a.clientY);r.preventDefault()},{passive:!1});let s=r=>{for(let a of r.changedTouches)a.identifier===this.touch.id&&(this.touch.id=null)};t.addEventListener("touchend",s),t.addEventListener("touchcancel",s)}setTouch(t,e){e?(this.touchActions.has(t)||this.pressedSet.add("T:"+t),this.touchActions.add(t)):this.touchActions.delete(t)}codes(t){return Tv[t]||[]}down(t){return this.touchActions.has(t)||this.padDown&&this.padDown.has(t)?!0:this.codes(t).some(e=>this.keys.has(e))}pressed(t){return this.consumed.has(t)?!1:this.pressedSet.has("T:"+t)||this.pressedSet.has("P:"+t)?!0:this.codes(t).some(e=>this.pressedSet.has(e))}consume(t){this.consumed.add(t)}poll(){let t=0,e=0;if(this.down("left")&&(t-=1),this.down("right")&&(t+=1),this.down("up")&&(e+=1),this.down("down")&&(e-=1),this.touch.id!==null){let r=this.touch.x-this.touch.ox,a=this.touch.y-this.touch.oy,o=55,l=Math.hypot(r,a);if(l>8){let c=Math.min(1,l/o)/l;t+=r*c,e-=a*c}}this.aimStick=null,this.padDown=new Set;let i=navigator.getGamepads?navigator.getGamepads():[];for(let r of i){if(!r)continue;let a=c=>Math.abs(c)<.18?0:c;t+=a(r.axes[0]),e-=a(r.axes[1]);let o=a(r.axes[2]||0),l=a(r.axes[3]||0);Math.hypot(o,l)>.35&&(this.aimStick=[o,-l],this.mouseActive=!1);for(let[c,h]of Object.entries(Ev))h.some(d=>r.buttons[d]&&r.buttons[d].pressed)&&(this.padDown.add(c),this.padPrev.has(c)||this.pressedSet.add("P:"+c));r.buttons[12]&&r.buttons[12].pressed&&(e+=1),r.buttons[13]&&r.buttons[13].pressed&&(e-=1),r.buttons[14]&&r.buttons[14].pressed&&(t-=1),r.buttons[15]&&r.buttons[15].pressed&&(t+=1),(this.padDown.size||Math.abs(r.axes[0])>.3||Math.abs(r.axes[1])>.3)&&(this.mouseActive=!1);break}this.padPrev=this.padDown;let s=Math.hypot(t,e);s>1&&(t/=s,e/=s),this.ax=t,this.ay=e}endFrame(){this.pressedSet.clear(),this.consumed.clear()}};var pc=class{constructor(){this.ctx=null,this.muted=!1,this.vol=.8}init(){if(this.ctx){this.ctx.state==="suspended"&&this.ctx.resume();return}try{this.ctx=new(window.AudioContext||window.webkitAudioContext)}catch{return}let t=this.ctx;this.master=t.createGain(),this.master.gain.value=this.vol;let e=t.createDynamicsCompressor();e.threshold.value=-14,e.ratio.value=4,this.master.connect(e),e.connect(t.destination),this.sfx=t.createGain(),this.sfx.gain.value=.9,this.sfx.connect(this.master),this.music=t.createGain(),this.music.gain.value=.35,this.music.connect(this.master),this.rev=t.createConvolver();let i=t.sampleRate*2.2,s=t.createBuffer(2,i,t.sampleRate);for(let o=0;o<2;o++){let l=s.getChannelData(o);for(let c=0;c<i;c++)l[c]=(Math.random()*2-1)*Math.pow(1-c/i,3)}this.rev.buffer=s;let r=t.createGain();r.gain.value=.35,this.rev.connect(r),r.connect(this.master),this.noise=t.createBuffer(1,t.sampleRate,t.sampleRate);let a=this.noise.getChannelData(0);for(let o=0;o<a.length;o++)a[o]=Math.random()*2-1;this.startAmbient()}setMuted(t){this.muted=t,this.master&&(this.master.gain.value=t?0:this.vol)}get t(){return this.ctx.currentTime}ok(){return this.ctx&&!this.muted}env(t,e,i,s,r){t.gain.setValueAtTime(1e-4,e),t.gain.exponentialRampToValueAtTime(s,e+i),t.gain.exponentialRampToValueAtTime(1e-4,e+i+r)}osc(t,e,i,s,r,a,o=0,l=.2){let c=this.ctx,h=this.t+o,d=c.createOscillator(),u=c.createGain();if(d.type=t,d.frequency.setValueAtTime(e,h),i!==e&&d.frequency.exponentialRampToValueAtTime(Math.max(1,i),h+s),this.env(u,h,.005,r,s),d.connect(u),u.connect(a||this.sfx),l){let f=c.createGain();f.gain.value=l,u.connect(f),f.connect(this.rev)}d.start(h),d.stop(h+s+.05)}nz(t,e,i,s,r,a=1,o=0,l=.25){let c=this.ctx,h=this.t+o,d=c.createBufferSource();d.buffer=this.noise,d.loop=!0;let u=c.createBiquadFilter();u.type=i,u.Q.value=a,u.frequency.setValueAtTime(s,h),u.frequency.exponentialRampToValueAtTime(Math.max(20,r),h+t);let f=c.createGain();if(this.env(f,h,.004,e,t),d.connect(u),u.connect(f),f.connect(this.sfx),l){let g=c.createGain();g.gain.value=l,f.connect(g),g.connect(this.rev)}d.start(h,Math.random()*.5),d.stop(h+t+.05)}play(t,e=1){if(!this.ok())return;let i=()=>.9+Math.random()*.2;switch(t){case"swing":this.nz(.16,.35*e,"bandpass",900*i(),3500,1.5);break;case"swingHeavy":this.nz(.3,.45*e,"bandpass",400*i(),1500,1.2);break;case"hit":this.osc("sine",180*i(),60,.12,.5*e),this.nz(.08,.35*e,"lowpass",3e3,400);break;case"crit":this.osc("square",900,300,.1,.12*e),this.osc("sine",200,50,.2,.6*e),this.nz(.12,.4*e,"highpass",2e3,800);break;case"boneHit":this.nz(.07,.4*e,"bandpass",2500*i(),1200,4),this.osc("triangle",500*i(),200,.06,.2*e);break;case"bow":this.osc("triangle",260*i(),90,.12,.25*e),this.nz(.14,.15*e,"highpass",3e3,6e3);break;case"arrowHit":this.nz(.05,.3*e,"bandpass",1800,900,3);break;case"hurt":this.osc("sawtooth",220,110,.18,.18*e),this.nz(.15,.3*e,"lowpass",1500,300);break;case"roll":this.nz(.25,.25*e,"bandpass",500,1400,.8);break;case"coin":this.osc("sine",1800*i(),1800,.06,.12*e,null,0,.3),this.osc("sine",2400*i(),2400,.12,.1*e,null,.05,.3);break;case"pickup":this.osc("triangle",520,520,.1,.2*e),this.osc("triangle",780,780,.2,.2*e,null,.08);break;case"potion":for(let s=0;s<5;s++)this.osc("sine",300+Math.random()*500,800,.08,.15*e,null,s*.06);break;case"die":this.osc("sawtooth",160*i(),40,.45,.15*e),this.nz(.3,.2*e,"lowpass",900,100);break;case"explode":this.nz(.9,.9*e,"lowpass",1800,60,.7),this.osc("sine",90,30,.6,.8*e);break;case"fire":this.nz(.7,.5*e,"lowpass",400,2400,.7),this.osc("sawtooth",80,160,.5,.1*e);break;case"zap":for(let s=0;s<6;s++)this.nz(.05,.4*e,"highpass",3e3+Math.random()*3e3,1500,1,s*.035);this.osc("square",120,60,.3,.12*e);break;case"freeze":this.osc("sine",2e3,900,.5,.12*e),this.nz(.6,.25*e,"highpass",5e3,2500);break;case"wind":this.nz(.7,.5*e,"bandpass",300,1400,.6);break;case"chest":this.osc("triangle",150,120,.3,.3*e),this.nz(.4,.15*e,"bandpass",700,300,3),[660,880,1100,1320].forEach((s,r)=>this.osc("sine",s,s,.3,.1*e,null,.25+r*.07,.5));break;case"pot":this.nz(.2,.5*e,"bandpass",1500,600,1.5),this.osc("triangle",700*i(),300,.1,.2*e);break;case"brazier":this.nz(1.2,.6*e,"lowpass",300,3e3,.6),[220,330,440].forEach((s,r)=>this.osc("sine",s,s,1.2,.1*e,null,r*.1,.6));break;case"gate":this.nz(1.4,.5*e,"lowpass",200,90,1);for(let s=0;s<8;s++)this.osc("square",60+Math.random()*20,50,.06,.1*e,null,s*.15);break;case"levelup":[392,523,659,784,1046].forEach((s,r)=>this.osc("triangle",s,s,.35,.18*e,null,r*.09,.5));break;case"roar":this.osc("sawtooth",90,50,1.4,.3*e),this.osc("sawtooth",93,48,1.4,.3*e),this.nz(1.3,.5*e,"lowpass",600,150,.6);break;case"slam":this.osc("sine",70,25,.7,1*e),this.nz(.6,.7*e,"lowpass",800,60);break;case"summon":this.osc("sine",200,600,.6,.15*e,null,0,.8),this.osc("sine",300,900,.6,.1*e,null,.1,.8);break;case"bolt":this.osc("sine",700,200,.3,.15*e),this.nz(.25,.15*e,"bandpass",1200,400,3);break;case"fuse":for(let s=0;s<6;s++)this.osc("square",500+s*120,500+s*120,.05,.08*e,null,s*.18);break;case"hiss":this.nz(.35,.3*e,"highpass",4e3,2e3,1);break;case"portal":this.osc("sine",110,440,1.5,.2*e,null,0,.8),this.osc("sine",165,660,1.5,.15*e,null,.2,.8);break;case"step":this.nz(.05,.05*e,"lowpass",600*i(),200,1,0,.05);break;case"deny":this.osc("square",180,150,.15,.1*e);break;case"banner":[262,330,392].forEach((s,r)=>this.osc("sawtooth",s,s,.5,.08*e,null,r*.05,.4));break}}startAmbient(){let t=this.ctx,e=t.createBiquadFilter();e.type="lowpass",e.frequency.value=500,e.connect(this.music);let i=t.createOscillator(),s=t.createGain();i.frequency.value=.07,s.gain.value=200,i.connect(s),s.connect(e.frequency),i.start(),this.drone=[];for(let a of[55,55.4,82.4]){let o=t.createOscillator();o.type="sawtooth",o.frequency.value=a;let l=t.createGain();l.gain.value=.08,o.connect(l),l.connect(e),o.start(),this.drone.push(o)}this.padBus=t.createGain(),this.padBus.gain.value=.6,this.padBus.connect(e);let r=t.createGain();r.gain.value=.5,this.padBus.connect(r),r.connect(this.rev),this.chords=[[220,261.6,329.6],[174.6,220,261.6],[196,246.9,293.7],[164.8,196,246.9]],this.chordI=0,this.nextChord=0,this.nextDrip=2,this.bossMode=!1,this.beat=0,this.nextBeat=0}setBoss(t){this.bossMode=t}update(){if(!this.ctx||this.muted)return;let t=this.t;if(t>this.nextChord){let e=this.chords[this.chordI++%this.chords.length];for(let i of e){let s=this.ctx.createOscillator(),r=this.ctx.createGain();s.type="triangle",s.frequency.value=i*(this.bossMode?.5:1),r.gain.setValueAtTime(1e-4,t),r.gain.exponentialRampToValueAtTime(.06,t+2.5),r.gain.exponentialRampToValueAtTime(1e-4,t+8.5),s.connect(r),r.connect(this.padBus),s.start(t),s.stop(t+9)}this.nextChord=t+8}if(t>this.nextDrip&&!this.bossMode&&(this.osc("sine",1200+Math.random()*900,700,.12,.05,this.music,0,1),this.nextDrip=t+2+Math.random()*6),this.bossMode&&t>this.nextBeat){let e=this.beat++%8;(e===0||e===3||e===5)&&this.osc("sine",80,35,.35,.5,this.music,0,.3),e===4&&this.nz(.2,.25,"bandpass",1200,500,1),e%2===1&&this.nz(.04,.06,"highpass",7e3,6e3,1,0,0),this.nextBeat=t+.22}}};var Av={uniforms:{tDiffuse:{value:null},uTime:{value:0}},vertexShader:"varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }",fragmentShader:`
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
    }`},Zf=document.getElementById("c"),Ai=new Cl({canvas:Zf,antialias:!1,powerPreference:"high-performance"});Ai.shadowMap.enabled=!0;Ai.shadowMap.type=Qn;Ai.toneMapping=ts;Ai.toneMappingExposure=1.2;Ai.outputColorSpace=Ee;var nu=new fc(Zf),ni=new dc(document.getElementById("ui"),nu),mc=new pc,xe=new hc(Ai,ni,nu,mc),Rv=new Js(Ai);xe.envMap=Rv.fromScene(new Fl,.04).texture;var Ea=["Alta","M\xE9dia","Baixa"],tn="Alta";try{tn=localStorage.getItem("criptas-quality")||"Alta"}catch{}Ea.includes(tn)||(tn="Alta");xe.quality=tn;var ji,eu,Yf,iu,tu;function Jf(){ji&&(ji.dispose(),tu.dispose());let n=tn,t=n==="Alta"?Math.min(devicePixelRatio,1.5):n==="M\xE9dia"?Math.min(devicePixelRatio,1):.75;Ai.setPixelRatio(t),Ai.setSize(innerWidth,innerHeight,!1),tu=new Re(innerWidth*t,innerHeight*t,{type:He,samples:n==="Alta"?4:n==="M\xE9dia"?2:0}),ji=new Dl(Ai,tu),eu=new Nl(xe.scene,xe.camera),ji.addPass(eu),n!=="Baixa"&&(Yf=new tr(new xt(innerWidth/2,innerHeight/2),.6,.5,.8),ji.addPass(Yf)),ji.addPass(new Ul),iu=new js(Av),ji.addPass(iu);let e=n==="Alta"?2048:n==="M\xE9dia"?1024:512;xe.moon.shadow.mapSize.x!==e&&(xe.moon.shadow.mapSize.set(e,e),xe.moon.shadow.map&&(xe.moon.shadow.map.dispose(),xe.moon.shadow.map=null)),Kf()}function Kf(){let n=Ai.getPixelRatio();Ai.setSize(innerWidth,innerHeight,!1),ji.setSize(innerWidth,innerHeight),xe.camera.aspect=innerWidth/innerHeight,xe.camera.fov=innerWidth<innerHeight?44:32,xe.camera.updateProjectionMatrix(),xe.particles.setScale(innerHeight*n/(2*Math.tan(fh.degToRad(xe.camera.fov)/2)))}addEventListener("resize",()=>ji&&Kf());function Qf(n){tn=n,xe.quality=n;try{localStorage.setItem("criptas-quality",n)}catch{}Jf()}var gc=1;try{gc=+localStorage.getItem("criptas-best")||1}catch{}function jf(){xe.loadFloor(1,!1,!0),xe.state="title",ni.setBoss(null);try{gc=+localStorage.getItem("criptas-best")||1}catch{}ni.showTitle(gc)}var gn=null;ni.on={play:()=>{mc.init(),ni.hidePanels(),xe.newGame(),gn={t:0,frames:0}},controls:()=>ni.showControls(()=>ni.showTitle(gc)),controlsP:()=>ni.showControls(()=>ni.showPause(xe)),resume:()=>{xe.state="play",ni.hidePanels()},mute:()=>{mc.setMuted(!mc.muted),ni.showPause(xe)},quality:()=>{Qf(Ea[(Ea.indexOf(tn)+1)%3]),ni.showPause(xe)},retry:()=>{ni.hidePanels(),xe.retryFloor()},menu:()=>{ni.hidePanels(),jf()},next:()=>{ni.hidePanels(),xe.nextFloor()}};Jf();jf();var $f=performance.now();function tp(n){requestAnimationFrame(tp);let t=Math.min(.05,(n-$f)/1e3);if($f=n,nu.poll(),xe.update(t),eu.scene=xe.scene,iu.uniforms.uTime.value=n*.001%100,ji.render(),gn&&xe.state==="play"&&(gn.t+=t,gn.frames++,gn.t>6)){let e=gn.frames/gn.t;e<32&&tn!=="Baixa"?(Qf(Ea[Ea.indexOf(tn)+1]),ni.toast(`Gr\xE1ficos ajustados para "${tn}" (${Math.round(e)} FPS)`),gn={t:0,frames:0}):gn=null}}requestAnimationFrame(tp);window.__game=xe;})();
/*! Bundled license information:

three/build/three.core.js:
three/build/three.module.js:
  (**
   * @license
   * Copyright 2010-2026 Three.js Authors
   * SPDX-License-Identifier: MIT
   *)
*/
