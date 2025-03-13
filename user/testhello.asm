
user/_testhello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user.h"

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc < 2) {
   8:	4785                	li	a5,1
   a:	00a7da63          	bge	a5,a0,1e <main+0x1e>
        printf("Error\n");
        exit(1);
    }

    int num = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	194000ef          	jal	1a4 <atoi>

    hello(num);
  14:	326000ef          	jal	33a <hello>
    exit(0);
  18:	4501                	li	a0,0
  1a:	280000ef          	jal	29a <exit>
        printf("Error\n");
  1e:	00001517          	auipc	a0,0x1
  22:	86250513          	addi	a0,a0,-1950 # 880 <malloc+0x102>
  26:	6a4000ef          	jal	6ca <printf>
        exit(1);
  2a:	4505                	li	a0,1
  2c:	26e000ef          	jal	29a <exit>

0000000000000030 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  extern int main();
  main();
  38:	fc9ff0ef          	jal	0 <main>
  exit(0);
  3c:	4501                	li	a0,0
  3e:	25c000ef          	jal	29a <exit>

0000000000000042 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	addi	a0,a0,1
  74:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	addi	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	86be                	mv	a3,a5
  9c:	0785                	addi	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	ff65                	bnez	a4,9a <strlen+0x10>
  a4:	40a6853b          	subw	a0,a3,a0
  a8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1c>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x12>
  }
  return dst;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb99                	beqz	a5,f6 <strchr+0x20>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1a>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xc>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strchr+0x1a>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	addi	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	1080                	addi	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 118:	4aa9                	li	s5,10
 11a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11c:	89a6                	mv	s3,s1
 11e:	2485                	addiw	s1,s1,1
 120:	0344d663          	bge	s1,s4,14c <gets+0x52>
    cc = read(0, &c, 1);
 124:	4605                	li	a2,1
 126:	faf40593          	addi	a1,s0,-81
 12a:	4501                	li	a0,0
 12c:	186000ef          	jal	2b2 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x52>
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01578763          	beq	a5,s5,14a <gets+0x50>
 140:	0905                	addi	s2,s2,1
 142:	fd679de3          	bne	a5,s6,11c <gets+0x22>
    buf[i++] = c;
 146:	89a6                	mv	s3,s1
 148:	a011                	j	14c <gets+0x52>
 14a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14c:	99de                	add	s3,s3,s7
 14e:	00098023          	sb	zero,0(s3)
  return buf;
}
 152:	855e                	mv	a0,s7
 154:	60e6                	ld	ra,88(sp)
 156:	6446                	ld	s0,80(sp)
 158:	64a6                	ld	s1,72(sp)
 15a:	6906                	ld	s2,64(sp)
 15c:	79e2                	ld	s3,56(sp)
 15e:	7a42                	ld	s4,48(sp)
 160:	7aa2                	ld	s5,40(sp)
 162:	7b02                	ld	s6,32(sp)
 164:	6be2                	ld	s7,24(sp)
 166:	6125                	addi	sp,sp,96
 168:	8082                	ret

000000000000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	1101                	addi	sp,sp,-32
 16c:	ec06                	sd	ra,24(sp)
 16e:	e822                	sd	s0,16(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	4581                	li	a1,0
 178:	162000ef          	jal	2da <open>
  if(fd < 0)
 17c:	02054263          	bltz	a0,1a0 <stat+0x36>
 180:	e426                	sd	s1,8(sp)
 182:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 184:	85ca                	mv	a1,s2
 186:	16c000ef          	jal	2f2 <fstat>
 18a:	892a                	mv	s2,a0
  close(fd);
 18c:	8526                	mv	a0,s1
 18e:	134000ef          	jal	2c2 <close>
  return r;
 192:	64a2                	ld	s1,8(sp)
}
 194:	854a                	mv	a0,s2
 196:	60e2                	ld	ra,24(sp)
 198:	6442                	ld	s0,16(sp)
 19a:	6902                	ld	s2,0(sp)
 19c:	6105                	addi	sp,sp,32
 19e:	8082                	ret
    return -1;
 1a0:	597d                	li	s2,-1
 1a2:	bfcd                	j	194 <stat+0x2a>

00000000000001a4 <atoi>:

int
atoi(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1aa:	00054683          	lbu	a3,0(a0)
 1ae:	fd06879b          	addiw	a5,a3,-48
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	4625                	li	a2,9
 1b8:	02f66863          	bltu	a2,a5,1e8 <atoi+0x44>
 1bc:	872a                	mv	a4,a0
  n = 0;
 1be:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c0:	0705                	addi	a4,a4,1
 1c2:	0025179b          	slliw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	slliw	a5,a5,0x1
 1cc:	9fb5                	addw	a5,a5,a3
 1ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d2:	00074683          	lbu	a3,0(a4)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	fef671e3          	bgeu	a2,a5,1c0 <atoi+0x1c>
  return n;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <atoi+0x3e>

00000000000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57463          	bgeu	a0,a1,21a <memmove+0x2e>
    while(n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x28>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 210:	fef71ae3          	bne	a4,a5,204 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
    dst += n;
 21a:	00c50733          	add	a4,a0,a2
    src += n;
 21e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 220:	fec05ae3          	blez	a2,214 <memmove+0x28>
 224:	fff6079b          	addiw	a5,a2,-1
 228:	1782                	slli	a5,a5,0x20
 22a:	9381                	srli	a5,a5,0x20
 22c:	fff7c793          	not	a5,a5
 230:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 232:	15fd                	addi	a1,a1,-1
 234:	177d                	addi	a4,a4,-1
 236:	0005c683          	lbu	a3,0(a1)
 23a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x46>
 242:	bfc9                	j	214 <memmove+0x28>

0000000000000244 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24a:	ca05                	beqz	a2,27a <memcmp+0x36>
 24c:	fff6069b          	addiw	a3,a2,-1
 250:	1682                	slli	a3,a3,0x20
 252:	9281                	srli	a3,a3,0x20
 254:	0685                	addi	a3,a3,1
 256:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x14>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x30>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  return 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <memcmp+0x30>

000000000000027e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 286:	f67ff0ef          	jal	1ec <memmove>
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 292:	4885                	li	a7,1
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <exit>:
.global exit
exit:
 li a7, SYS_exit
 29a:	4889                	li	a7,2
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a2:	488d                	li	a7,3
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2aa:	4891                	li	a7,4
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <read>:
.global read
read:
 li a7, SYS_read
 2b2:	4895                	li	a7,5
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <write>:
.global write
write:
 li a7, SYS_write
 2ba:	48c1                	li	a7,16
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <close>:
.global close
close:
 li a7, SYS_close
 2c2:	48d5                	li	a7,21
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ca:	4899                	li	a7,6
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d2:	489d                	li	a7,7
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <open>:
.global open
open:
 li a7, SYS_open
 2da:	48bd                	li	a7,15
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e2:	48c5                	li	a7,17
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ea:	48c9                	li	a7,18
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f2:	48a1                	li	a7,8
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <link>:
.global link
link:
 li a7, SYS_link
 2fa:	48cd                	li	a7,19
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 302:	48d1                	li	a7,20
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30a:	48a5                	li	a7,9
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <dup>:
.global dup
dup:
 li a7, SYS_dup
 312:	48a9                	li	a7,10
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31a:	48ad                	li	a7,11
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 322:	48b1                	li	a7,12
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32a:	48b5                	li	a7,13
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 332:	48b9                	li	a7,14
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <hello>:
.global hello
hello:
 li a7, SYS_hello
 33a:	48d9                	li	a7,22
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <trace>:
.global trace
trace:
 li a7, SYS_trace
 342:	48dd                	li	a7,23
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 34a:	48e1                	li	a7,24
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	1000                	addi	s0,sp,32
 35a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35e:	4605                	li	a2,1
 360:	fef40593          	addi	a1,s0,-17
 364:	f57ff0ef          	jal	2ba <write>
}
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	6105                	addi	sp,sp,32
 36e:	8082                	ret

0000000000000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	7139                	addi	sp,sp,-64
 372:	fc06                	sd	ra,56(sp)
 374:	f822                	sd	s0,48(sp)
 376:	f426                	sd	s1,40(sp)
 378:	0080                	addi	s0,sp,64
 37a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37c:	c299                	beqz	a3,382 <printint+0x12>
 37e:	0805c963          	bltz	a1,410 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 382:	2581                	sext.w	a1,a1
  neg = 0;
 384:	4881                	li	a7,0
 386:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 38a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 38c:	2601                	sext.w	a2,a2
 38e:	00000517          	auipc	a0,0x0
 392:	50250513          	addi	a0,a0,1282 # 890 <digits>
 396:	883a                	mv	a6,a4
 398:	2705                	addiw	a4,a4,1
 39a:	02c5f7bb          	remuw	a5,a1,a2
 39e:	1782                	slli	a5,a5,0x20
 3a0:	9381                	srli	a5,a5,0x20
 3a2:	97aa                	add	a5,a5,a0
 3a4:	0007c783          	lbu	a5,0(a5)
 3a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ac:	0005879b          	sext.w	a5,a1
 3b0:	02c5d5bb          	divuw	a1,a1,a2
 3b4:	0685                	addi	a3,a3,1
 3b6:	fec7f0e3          	bgeu	a5,a2,396 <printint+0x26>
  if(neg)
 3ba:	00088c63          	beqz	a7,3d2 <printint+0x62>
    buf[i++] = '-';
 3be:	fd070793          	addi	a5,a4,-48
 3c2:	00878733          	add	a4,a5,s0
 3c6:	02d00793          	li	a5,45
 3ca:	fef70823          	sb	a5,-16(a4)
 3ce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d2:	02e05a63          	blez	a4,406 <printint+0x96>
 3d6:	f04a                	sd	s2,32(sp)
 3d8:	ec4e                	sd	s3,24(sp)
 3da:	fc040793          	addi	a5,s0,-64
 3de:	00e78933          	add	s2,a5,a4
 3e2:	fff78993          	addi	s3,a5,-1
 3e6:	99ba                	add	s3,s3,a4
 3e8:	377d                	addiw	a4,a4,-1
 3ea:	1702                	slli	a4,a4,0x20
 3ec:	9301                	srli	a4,a4,0x20
 3ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f2:	fff94583          	lbu	a1,-1(s2)
 3f6:	8526                	mv	a0,s1
 3f8:	f5bff0ef          	jal	352 <putc>
  while(--i >= 0)
 3fc:	197d                	addi	s2,s2,-1
 3fe:	ff391ae3          	bne	s2,s3,3f2 <printint+0x82>
 402:	7902                	ld	s2,32(sp)
 404:	69e2                	ld	s3,24(sp)
}
 406:	70e2                	ld	ra,56(sp)
 408:	7442                	ld	s0,48(sp)
 40a:	74a2                	ld	s1,40(sp)
 40c:	6121                	addi	sp,sp,64
 40e:	8082                	ret
    x = -xx;
 410:	40b005bb          	negw	a1,a1
    neg = 1;
 414:	4885                	li	a7,1
    x = -xx;
 416:	bf85                	j	386 <printint+0x16>

0000000000000418 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 418:	711d                	addi	sp,sp,-96
 41a:	ec86                	sd	ra,88(sp)
 41c:	e8a2                	sd	s0,80(sp)
 41e:	e0ca                	sd	s2,64(sp)
 420:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 422:	0005c903          	lbu	s2,0(a1)
 426:	26090863          	beqz	s2,696 <vprintf+0x27e>
 42a:	e4a6                	sd	s1,72(sp)
 42c:	fc4e                	sd	s3,56(sp)
 42e:	f852                	sd	s4,48(sp)
 430:	f456                	sd	s5,40(sp)
 432:	f05a                	sd	s6,32(sp)
 434:	ec5e                	sd	s7,24(sp)
 436:	e862                	sd	s8,16(sp)
 438:	e466                	sd	s9,8(sp)
 43a:	8b2a                	mv	s6,a0
 43c:	8a2e                	mv	s4,a1
 43e:	8bb2                	mv	s7,a2
  state = 0;
 440:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 442:	4481                	li	s1,0
 444:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 446:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 44a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 44e:	06c00c93          	li	s9,108
 452:	a005                	j	472 <vprintf+0x5a>
        putc(fd, c0);
 454:	85ca                	mv	a1,s2
 456:	855a                	mv	a0,s6
 458:	efbff0ef          	jal	352 <putc>
 45c:	a019                	j	462 <vprintf+0x4a>
    } else if(state == '%'){
 45e:	03598263          	beq	s3,s5,482 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 462:	2485                	addiw	s1,s1,1
 464:	8726                	mv	a4,s1
 466:	009a07b3          	add	a5,s4,s1
 46a:	0007c903          	lbu	s2,0(a5)
 46e:	20090c63          	beqz	s2,686 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 472:	0009079b          	sext.w	a5,s2
    if(state == 0){
 476:	fe0994e3          	bnez	s3,45e <vprintf+0x46>
      if(c0 == '%'){
 47a:	fd579de3          	bne	a5,s5,454 <vprintf+0x3c>
        state = '%';
 47e:	89be                	mv	s3,a5
 480:	b7cd                	j	462 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 482:	00ea06b3          	add	a3,s4,a4
 486:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 48a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 48c:	c681                	beqz	a3,494 <vprintf+0x7c>
 48e:	9752                	add	a4,a4,s4
 490:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 494:	03878f63          	beq	a5,s8,4d2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 498:	05978963          	beq	a5,s9,4ea <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 49c:	07500713          	li	a4,117
 4a0:	0ee78363          	beq	a5,a4,586 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a4:	07800713          	li	a4,120
 4a8:	12e78563          	beq	a5,a4,5d2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ac:	07000713          	li	a4,112
 4b0:	14e78a63          	beq	a5,a4,604 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b4:	07300713          	li	a4,115
 4b8:	18e78a63          	beq	a5,a4,64c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4bc:	02500713          	li	a4,37
 4c0:	04e79563          	bne	a5,a4,50a <vprintf+0xf2>
        putc(fd, '%');
 4c4:	02500593          	li	a1,37
 4c8:	855a                	mv	a0,s6
 4ca:	e89ff0ef          	jal	352 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	bf49                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d2:	008b8913          	addi	s2,s7,8
 4d6:	4685                	li	a3,1
 4d8:	4629                	li	a2,10
 4da:	000ba583          	lw	a1,0(s7)
 4de:	855a                	mv	a0,s6
 4e0:	e91ff0ef          	jal	370 <printint>
 4e4:	8bca                	mv	s7,s2
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	bfad                	j	462 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	06400793          	li	a5,100
 4ee:	02f68963          	beq	a3,a5,520 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f2:	06c00793          	li	a5,108
 4f6:	04f68263          	beq	a3,a5,53a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4fa:	07500793          	li	a5,117
 4fe:	0af68063          	beq	a3,a5,59e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 502:	07800793          	li	a5,120
 506:	0ef68263          	beq	a3,a5,5ea <vprintf+0x1d2>
        putc(fd, '%');
 50a:	02500593          	li	a1,37
 50e:	855a                	mv	a0,s6
 510:	e43ff0ef          	jal	352 <putc>
        putc(fd, c0);
 514:	85ca                	mv	a1,s2
 516:	855a                	mv	a0,s6
 518:	e3bff0ef          	jal	352 <putc>
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b791                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 520:	008b8913          	addi	s2,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	e43ff0ef          	jal	370 <printint>
        i += 1;
 532:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
        i += 1;
 538:	b72d                	j	462 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53a:	06400793          	li	a5,100
 53e:	02f60763          	beq	a2,a5,56c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 542:	07500793          	li	a5,117
 546:	06f60963          	beq	a2,a5,5b8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 54a:	07800793          	li	a5,120
 54e:	faf61ee3          	bne	a2,a5,50a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 552:	008b8913          	addi	s2,s7,8
 556:	4681                	li	a3,0
 558:	4641                	li	a2,16
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	e11ff0ef          	jal	370 <printint>
        i += 2;
 564:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
        i += 2;
 56a:	bde5                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56c:	008b8913          	addi	s2,s7,8
 570:	4685                	li	a3,1
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	df7ff0ef          	jal	370 <printint>
        i += 2;
 57e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
        i += 2;
 584:	bdf9                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	dddff0ef          	jal	370 <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b5d9                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dc5ff0ef          	jal	370 <printint>
        i += 1;
 5b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
        i += 1;
 5b6:	b575                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	dabff0ef          	jal	370 <printint>
        i += 2;
 5ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bd49                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	d91ff0ef          	jal	370 <printint>
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bdad                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	d79ff0ef          	jal	370 <printint>
        i += 1;
 5fc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
        i += 1;
 602:	b585                	j	462 <vprintf+0x4a>
 604:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 606:	008b8d13          	addi	s10,s7,8
 60a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60e:	03000593          	li	a1,48
 612:	855a                	mv	a0,s6
 614:	d3fff0ef          	jal	352 <putc>
  putc(fd, 'x');
 618:	07800593          	li	a1,120
 61c:	855a                	mv	a0,s6
 61e:	d35ff0ef          	jal	352 <putc>
 622:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 624:	00000b97          	auipc	s7,0x0
 628:	26cb8b93          	addi	s7,s7,620 # 890 <digits>
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97de                	add	a5,a5,s7
 632:	0007c583          	lbu	a1,0(a5)
 636:	855a                	mv	a0,s6
 638:	d1bff0ef          	jal	352 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63c:	0992                	slli	s3,s3,0x4
 63e:	397d                	addiw	s2,s2,-1
 640:	fe0916e3          	bnez	s2,62c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 644:	8bea                	mv	s7,s10
      state = 0;
 646:	4981                	li	s3,0
 648:	6d02                	ld	s10,0(sp)
 64a:	bd21                	j	462 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 64c:	008b8993          	addi	s3,s7,8
 650:	000bb903          	ld	s2,0(s7)
 654:	00090f63          	beqz	s2,672 <vprintf+0x25a>
        for(; *s; s++)
 658:	00094583          	lbu	a1,0(s2)
 65c:	c195                	beqz	a1,680 <vprintf+0x268>
          putc(fd, *s);
 65e:	855a                	mv	a0,s6
 660:	cf3ff0ef          	jal	352 <putc>
        for(; *s; s++)
 664:	0905                	addi	s2,s2,1
 666:	00094583          	lbu	a1,0(s2)
 66a:	f9f5                	bnez	a1,65e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	bbcd                	j	462 <vprintf+0x4a>
          s = "(null)";
 672:	00000917          	auipc	s2,0x0
 676:	21690913          	addi	s2,s2,534 # 888 <malloc+0x10a>
        for(; *s; s++)
 67a:	02800593          	li	a1,40
 67e:	b7c5                	j	65e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	bbf9                	j	462 <vprintf+0x4a>
 686:	64a6                	ld	s1,72(sp)
 688:	79e2                	ld	s3,56(sp)
 68a:	7a42                	ld	s4,48(sp)
 68c:	7aa2                	ld	s5,40(sp)
 68e:	7b02                	ld	s6,32(sp)
 690:	6be2                	ld	s7,24(sp)
 692:	6c42                	ld	s8,16(sp)
 694:	6ca2                	ld	s9,8(sp)
    }
  }
}
 696:	60e6                	ld	ra,88(sp)
 698:	6446                	ld	s0,80(sp)
 69a:	6906                	ld	s2,64(sp)
 69c:	6125                	addi	sp,sp,96
 69e:	8082                	ret

00000000000006a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a0:	715d                	addi	sp,sp,-80
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e010                	sd	a2,0(s0)
 6aa:	e414                	sd	a3,8(s0)
 6ac:	e818                	sd	a4,16(s0)
 6ae:	ec1c                	sd	a5,24(s0)
 6b0:	03043023          	sd	a6,32(s0)
 6b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6bc:	8622                	mv	a2,s0
 6be:	d5bff0ef          	jal	418 <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6161                	addi	sp,sp,80
 6c8:	8082                	ret

00000000000006ca <printf>:

void
printf(const char *fmt, ...)
{
 6ca:	711d                	addi	sp,sp,-96
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	e40c                	sd	a1,8(s0)
 6d4:	e810                	sd	a2,16(s0)
 6d6:	ec14                	sd	a3,24(s0)
 6d8:	f018                	sd	a4,32(s0)
 6da:	f41c                	sd	a5,40(s0)
 6dc:	03043823          	sd	a6,48(s0)
 6e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e4:	00840613          	addi	a2,s0,8
 6e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ec:	85aa                	mv	a1,a0
 6ee:	4505                	li	a0,1
 6f0:	d29ff0ef          	jal	418 <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6125                	addi	sp,sp,96
 6fa:	8082                	ret

00000000000006fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fc:	1141                	addi	sp,sp,-16
 6fe:	e422                	sd	s0,8(sp)
 700:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 702:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	00001797          	auipc	a5,0x1
 70a:	8fa7b783          	ld	a5,-1798(a5) # 1000 <freep>
 70e:	a02d                	j	738 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 710:	4618                	lw	a4,8(a2)
 712:	9f2d                	addw	a4,a4,a1
 714:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 718:	6398                	ld	a4,0(a5)
 71a:	6310                	ld	a2,0(a4)
 71c:	a83d                	j	75a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71e:	ff852703          	lw	a4,-8(a0)
 722:	9f31                	addw	a4,a4,a2
 724:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 726:	ff053683          	ld	a3,-16(a0)
 72a:	a091                	j	76e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	6398                	ld	a4,0(a5)
 72e:	00e7e463          	bltu	a5,a4,736 <free+0x3a>
 732:	00e6ea63          	bltu	a3,a4,746 <free+0x4a>
{
 736:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	fed7fae3          	bgeu	a5,a3,72c <free+0x30>
 73c:	6398                	ld	a4,0(a5)
 73e:	00e6e463          	bltu	a3,a4,746 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	fee7eae3          	bltu	a5,a4,736 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 746:	ff852583          	lw	a1,-8(a0)
 74a:	6390                	ld	a2,0(a5)
 74c:	02059813          	slli	a6,a1,0x20
 750:	01c85713          	srli	a4,a6,0x1c
 754:	9736                	add	a4,a4,a3
 756:	fae60de3          	beq	a2,a4,710 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 75a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75e:	4790                	lw	a2,8(a5)
 760:	02061593          	slli	a1,a2,0x20
 764:	01c5d713          	srli	a4,a1,0x1c
 768:	973e                	add	a4,a4,a5
 76a:	fae68ae3          	beq	a3,a4,71e <free+0x22>
    p->s.ptr = bp->s.ptr;
 76e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 770:	00001717          	auipc	a4,0x1
 774:	88f73823          	sd	a5,-1904(a4) # 1000 <freep>
}
 778:	6422                	ld	s0,8(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

000000000000077e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77e:	7139                	addi	sp,sp,-64
 780:	fc06                	sd	ra,56(sp)
 782:	f822                	sd	s0,48(sp)
 784:	f426                	sd	s1,40(sp)
 786:	ec4e                	sd	s3,24(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051493          	slli	s1,a0,0x20
 78e:	9081                	srli	s1,s1,0x20
 790:	04bd                	addi	s1,s1,15
 792:	8091                	srli	s1,s1,0x4
 794:	0014899b          	addiw	s3,s1,1
 798:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79a:	00001517          	auipc	a0,0x1
 79e:	86653503          	ld	a0,-1946(a0) # 1000 <freep>
 7a2:	c915                	beqz	a0,7d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	08977a63          	bgeu	a4,s1,83c <malloc+0xbe>
 7ac:	f04a                	sd	s2,32(sp)
 7ae:	e852                	sd	s4,16(sp)
 7b0:	e456                	sd	s5,8(sp)
 7b2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b4:	8a4e                	mv	s4,s3
 7b6:	0009871b          	sext.w	a4,s3
 7ba:	6685                	lui	a3,0x1
 7bc:	00d77363          	bgeu	a4,a3,7c2 <malloc+0x44>
 7c0:	6a05                	lui	s4,0x1
 7c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ca:	00001917          	auipc	s2,0x1
 7ce:	83690913          	addi	s2,s2,-1994 # 1000 <freep>
  if(p == (char*)-1)
 7d2:	5afd                	li	s5,-1
 7d4:	a081                	j	814 <malloc+0x96>
 7d6:	f04a                	sd	s2,32(sp)
 7d8:	e852                	sd	s4,16(sp)
 7da:	e456                	sd	s5,8(sp)
 7dc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7de:	00001797          	auipc	a5,0x1
 7e2:	83278793          	addi	a5,a5,-1998 # 1010 <base>
 7e6:	00001717          	auipc	a4,0x1
 7ea:	80f73d23          	sd	a5,-2022(a4) # 1000 <freep>
 7ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f4:	b7c1                	j	7b4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	e118                	sd	a4,0(a0)
 7fa:	a8a9                	j	854 <malloc+0xd6>
  hp->s.size = nu;
 7fc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 800:	0541                	addi	a0,a0,16
 802:	efbff0ef          	jal	6fc <free>
  return freep;
 806:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 80a:	c12d                	beqz	a0,86c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	02977263          	bgeu	a4,s1,834 <malloc+0xb6>
    if(p == freep)
 814:	00093703          	ld	a4,0(s2)
 818:	853e                	mv	a0,a5
 81a:	fef719e3          	bne	a4,a5,80c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 81e:	8552                	mv	a0,s4
 820:	b03ff0ef          	jal	322 <sbrk>
  if(p == (char*)-1)
 824:	fd551ce3          	bne	a0,s5,7fc <malloc+0x7e>
        return 0;
 828:	4501                	li	a0,0
 82a:	7902                	ld	s2,32(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
 832:	a03d                	j	860 <malloc+0xe2>
 834:	7902                	ld	s2,32(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83c:	fae48de3          	beq	s1,a4,7f6 <malloc+0x78>
        p->s.size -= nunits;
 840:	4137073b          	subw	a4,a4,s3
 844:	c798                	sw	a4,8(a5)
        p += p->s.size;
 846:	02071693          	slli	a3,a4,0x20
 84a:	01c6d713          	srli	a4,a3,0x1c
 84e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 850:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 854:	00000717          	auipc	a4,0x0
 858:	7aa73623          	sd	a0,1964(a4) # 1000 <freep>
      return (void*)(p + 1);
 85c:	01078513          	addi	a0,a5,16
  }
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	74a2                	ld	s1,40(sp)
 866:	69e2                	ld	s3,24(sp)
 868:	6121                	addi	sp,sp,64
 86a:	8082                	ret
 86c:	7902                	ld	s2,32(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	b7f5                	j	860 <malloc+0xe2>
