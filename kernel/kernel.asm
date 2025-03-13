
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	49013103          	ld	sp,1168(sp) # 8000a490 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	689040ef          	jal	80004e9e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	9e078793          	addi	a5,a5,-1568 # 80023a10 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	148000ef          	jal	80000190 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	49490913          	addi	s2,s2,1172 # 8000a4e0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	0ab050ef          	jal	80005900 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	133050ef          	jal	80005998 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	554050ef          	jal	800055d2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	40650513          	addi	a0,a0,1030 # 8000a4e0 <kmem>
    800000e2:	79e050ef          	jal	80005880 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00024517          	auipc	a0,0x24
    800000ee:	92650513          	addi	a0,a0,-1754 # 80023a10 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	3d848493          	addi	s1,s1,984 # 8000a4e0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7ee050ef          	jal	80005900 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	3c450513          	addi	a0,a0,964 # 8000a4e0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	073050ef          	jal	80005998 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	060000ef          	jal	80000190 <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	3a050513          	addi	a0,a0,928 # 8000a4e0 <kmem>
    80000148:	051050ef          	jal	80005998 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <count_freemem>:

int
count_freemem(void)
{
    8000014e:	1101                	addi	sp,sp,-32
    80000150:	ec06                	sd	ra,24(sp)
    80000152:	e822                	sd	s0,16(sp)
    80000154:	e426                	sd	s1,8(sp)
    80000156:	1000                	addi	s0,sp,32
  int n = 0;
  struct run *r;

  acquire(&kmem.lock);
    80000158:	0000a497          	auipc	s1,0xa
    8000015c:	38848493          	addi	s1,s1,904 # 8000a4e0 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	79e050ef          	jal	80005900 <acquire>

  // Count the number of completely empty pages  
  for (r = kmem.freelist; r; r = r->next) {
    80000166:	6c9c                	ld	a5,24(s1)
    80000168:	c395                	beqz	a5,8000018c <count_freemem+0x3e>
  int n = 0;
    8000016a:	4481                	li	s1,0
    n++;
    8000016c:	2485                	addiw	s1,s1,1
  for (r = kmem.freelist; r; r = r->next) {
    8000016e:	639c                	ld	a5,0(a5)
    80000170:	fff5                	bnez	a5,8000016c <count_freemem+0x1e>
  }

  release(&kmem.lock);
    80000172:	0000a517          	auipc	a0,0xa
    80000176:	36e50513          	addi	a0,a0,878 # 8000a4e0 <kmem>
    8000017a:	01f050ef          	jal	80005998 <release>

  return n * PGSIZE;
    8000017e:	00c4951b          	slliw	a0,s1,0xc
    80000182:	60e2                	ld	ra,24(sp)
    80000184:	6442                	ld	s0,16(sp)
    80000186:	64a2                	ld	s1,8(sp)
    80000188:	6105                	addi	sp,sp,32
    8000018a:	8082                	ret
  int n = 0;
    8000018c:	4481                	li	s1,0
    8000018e:	b7d5                	j	80000172 <count_freemem+0x24>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000196:	ca19                	beqz	a2,800001ac <memset+0x1c>
    80000198:	87aa                	mv	a5,a0
    8000019a:	1602                	slli	a2,a2,0x20
    8000019c:	9201                	srli	a2,a2,0x20
    8000019e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001a6:	0785                	addi	a5,a5,1
    800001a8:	fee79de3          	bne	a5,a4,800001a2 <memset+0x12>
  }
  return dst;
}
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001b8:	ca05                	beqz	a2,800001e8 <memcmp+0x36>
    800001ba:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001be:	1682                	slli	a3,a3,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	0685                	addi	a3,a3,1
    800001c4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001c6:	00054783          	lbu	a5,0(a0)
    800001ca:	0005c703          	lbu	a4,0(a1)
    800001ce:	00e79863          	bne	a5,a4,800001de <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001d2:	0505                	addi	a0,a0,1
    800001d4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001d6:	fed518e3          	bne	a0,a3,800001c6 <memcmp+0x14>
  }

  return 0;
    800001da:	4501                	li	a0,0
    800001dc:	a019                	j	800001e2 <memcmp+0x30>
      return *s1 - *s2;
    800001de:	40e7853b          	subw	a0,a5,a4
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret
  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	bfe5                	j	800001e2 <memcmp+0x30>

00000000800001ec <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e422                	sd	s0,8(sp)
    800001f0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001f2:	c205                	beqz	a2,80000212 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001f4:	02a5e263          	bltu	a1,a0,80000218 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f8:	1602                	slli	a2,a2,0x20
    800001fa:	9201                	srli	a2,a2,0x20
    800001fc:	00c587b3          	add	a5,a1,a2
{
    80000200:	872a                	mv	a4,a0
      *d++ = *s++;
    80000202:	0585                	addi	a1,a1,1
    80000204:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb5f1>
    80000206:	fff5c683          	lbu	a3,-1(a1)
    8000020a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020e:	feb79ae3          	bne	a5,a1,80000202 <memmove+0x16>

  return dst;
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
  if(s < d && s + n > d){
    80000218:	02061693          	slli	a3,a2,0x20
    8000021c:	9281                	srli	a3,a3,0x20
    8000021e:	00d58733          	add	a4,a1,a3
    80000222:	fce57be3          	bgeu	a0,a4,800001f8 <memmove+0xc>
    d += n;
    80000226:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000228:	fff6079b          	addiw	a5,a2,-1
    8000022c:	1782                	slli	a5,a5,0x20
    8000022e:	9381                	srli	a5,a5,0x20
    80000230:	fff7c793          	not	a5,a5
    80000234:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000236:	177d                	addi	a4,a4,-1
    80000238:	16fd                	addi	a3,a3,-1
    8000023a:	00074603          	lbu	a2,0(a4)
    8000023e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000242:	fef71ae3          	bne	a4,a5,80000236 <memmove+0x4a>
    80000246:	b7f1                	j	80000212 <memmove+0x26>

0000000080000248 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e406                	sd	ra,8(sp)
    8000024c:	e022                	sd	s0,0(sp)
    8000024e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000250:	f9dff0ef          	jal	800001ec <memmove>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret

000000008000025c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000262:	ce11                	beqz	a2,8000027e <strncmp+0x22>
    80000264:	00054783          	lbu	a5,0(a0)
    80000268:	cf89                	beqz	a5,80000282 <strncmp+0x26>
    8000026a:	0005c703          	lbu	a4,0(a1)
    8000026e:	00f71a63          	bne	a4,a5,80000282 <strncmp+0x26>
    n--, p++, q++;
    80000272:	367d                	addiw	a2,a2,-1
    80000274:	0505                	addi	a0,a0,1
    80000276:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000278:	f675                	bnez	a2,80000264 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	a801                	j	8000028c <strncmp+0x30>
    8000027e:	4501                	li	a0,0
    80000280:	a031                	j	8000028c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000282:	00054503          	lbu	a0,0(a0)
    80000286:	0005c783          	lbu	a5,0(a1)
    8000028a:	9d1d                	subw	a0,a0,a5
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000298:	87aa                	mv	a5,a0
    8000029a:	86b2                	mv	a3,a2
    8000029c:	367d                	addiw	a2,a2,-1
    8000029e:	02d05563          	blez	a3,800002c8 <strncpy+0x36>
    800002a2:	0785                	addi	a5,a5,1
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	fee78fa3          	sb	a4,-1(a5)
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	f775                	bnez	a4,8000029a <strncpy+0x8>
    ;
  while(n-- > 0)
    800002b0:	873e                	mv	a4,a5
    800002b2:	9fb5                	addw	a5,a5,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	00c05963          	blez	a2,800002c8 <strncpy+0x36>
    *s++ = 0;
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002c0:	40e786bb          	subw	a3,a5,a4
    800002c4:	fed04be3          	bgtz	a3,800002ba <strncpy+0x28>
  return os;
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d4:	02c05363          	blez	a2,800002fa <safestrcpy+0x2c>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	96ae                	add	a3,a3,a1
    800002e2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e4:	00d58963          	beq	a1,a3,800002f6 <safestrcpy+0x28>
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff5c703          	lbu	a4,-1(a1)
    800002f0:	fee78fa3          	sb	a4,-1(a5)
    800002f4:	fb65                	bnez	a4,800002e4 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f6:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strlen>:

int
strlen(const char *s)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf91                	beqz	a5,80000326 <strlen+0x26>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	86be                	mv	a3,a5
    80000312:	0785                	addi	a5,a5,1
    80000314:	fff7c703          	lbu	a4,-1(a5)
    80000318:	ff65                	bnez	a4,80000310 <strlen+0x10>
    8000031a:	40a6853b          	subw	a0,a3,a0
    8000031e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  for(n = 0; s[n]; n++)
    80000326:	4501                	li	a0,0
    80000328:	bfe5                	j	80000320 <strlen+0x20>

000000008000032a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032a:	1141                	addi	sp,sp,-16
    8000032c:	e406                	sd	ra,8(sp)
    8000032e:	e022                	sd	s0,0(sp)
    80000330:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000332:	24b000ef          	jal	80000d7c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	0000a717          	auipc	a4,0xa
    8000033a:	17a70713          	addi	a4,a4,378 # 8000a4b0 <started>
  if(cpuid() == 0){
    8000033e:	c51d                	beqz	a0,8000036c <main+0x42>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x16>
      ;
    __sync_synchronize();
    80000346:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000034a:	233000ef          	jal	80000d7c <cpuid>
    8000034e:	85aa                	mv	a1,a0
    80000350:	00007517          	auipc	a0,0x7
    80000354:	ce850513          	addi	a0,a0,-792 # 80007038 <etext+0x38>
    80000358:	7a9040ef          	jal	80005300 <printf>
    kvminithart();    // turn on paging
    8000035c:	080000ef          	jal	800003dc <kvminithart>
    trapinithart();   // install kernel trap vector
    80000360:	58e010ef          	jal	800018ee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000364:	554040ef          	jal	800048b8 <plicinithart>
  }

  scheduler();        
    80000368:	67d000ef          	jal	800011e4 <scheduler>
    consoleinit();
    8000036c:	6bf040ef          	jal	8000522a <consoleinit>
    printfinit();
    80000370:	29c050ef          	jal	8000560c <printfinit>
    printf("\n");
    80000374:	00007517          	auipc	a0,0x7
    80000378:	ca450513          	addi	a0,a0,-860 # 80007018 <etext+0x18>
    8000037c:	785040ef          	jal	80005300 <printf>
    printf("xv6 kernel is booting\n");
    80000380:	00007517          	auipc	a0,0x7
    80000384:	ca050513          	addi	a0,a0,-864 # 80007020 <etext+0x20>
    80000388:	779040ef          	jal	80005300 <printf>
    printf("\n");
    8000038c:	00007517          	auipc	a0,0x7
    80000390:	c8c50513          	addi	a0,a0,-884 # 80007018 <etext+0x18>
    80000394:	76d040ef          	jal	80005300 <printf>
    kinit();         // physical page allocator
    80000398:	d33ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000039c:	2ca000ef          	jal	80000666 <kvminit>
    kvminithart();   // turn on paging
    800003a0:	03c000ef          	jal	800003dc <kvminithart>
    procinit();      // process table
    800003a4:	123000ef          	jal	80000cc6 <procinit>
    trapinit();      // trap vectors
    800003a8:	522010ef          	jal	800018ca <trapinit>
    trapinithart();  // install kernel trap vector
    800003ac:	542010ef          	jal	800018ee <trapinithart>
    plicinit();      // set up interrupt controller
    800003b0:	4ee040ef          	jal	8000489e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b4:	504040ef          	jal	800048b8 <plicinithart>
    binit();         // buffer cache
    800003b8:	457010ef          	jal	8000200e <binit>
    iinit();         // inode table
    800003bc:	248020ef          	jal	80002604 <iinit>
    fileinit();      // file table
    800003c0:	7f5020ef          	jal	800033b4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c4:	5e4040ef          	jal	800049a8 <virtio_disk_init>
    userinit();      // first user process
    800003c8:	449000ef          	jal	80001010 <userinit>
    __sync_synchronize();
    800003cc:	0330000f          	fence	rw,rw
    started = 1;
    800003d0:	4785                	li	a5,1
    800003d2:	0000a717          	auipc	a4,0xa
    800003d6:	0cf72f23          	sw	a5,222(a4) # 8000a4b0 <started>
    800003da:	b779                	j	80000368 <main+0x3e>

00000000800003dc <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003dc:	1141                	addi	sp,sp,-16
    800003de:	e422                	sd	s0,8(sp)
    800003e0:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003e2:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003e6:	0000a797          	auipc	a5,0xa
    800003ea:	0d27b783          	ld	a5,210(a5) # 8000a4b8 <kernel_pagetable>
    800003ee:	83b1                	srli	a5,a5,0xc
    800003f0:	577d                	li	a4,-1
    800003f2:	177e                	slli	a4,a4,0x3f
    800003f4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003f6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003fa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003fe:	6422                	ld	s0,8(sp)
    80000400:	0141                	addi	sp,sp,16
    80000402:	8082                	ret

0000000080000404 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000404:	7139                	addi	sp,sp,-64
    80000406:	fc06                	sd	ra,56(sp)
    80000408:	f822                	sd	s0,48(sp)
    8000040a:	f426                	sd	s1,40(sp)
    8000040c:	f04a                	sd	s2,32(sp)
    8000040e:	ec4e                	sd	s3,24(sp)
    80000410:	e852                	sd	s4,16(sp)
    80000412:	e456                	sd	s5,8(sp)
    80000414:	e05a                	sd	s6,0(sp)
    80000416:	0080                	addi	s0,sp,64
    80000418:	84aa                	mv	s1,a0
    8000041a:	89ae                	mv	s3,a1
    8000041c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000041e:	57fd                	li	a5,-1
    80000420:	83e9                	srli	a5,a5,0x1a
    80000422:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000424:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000426:	02b7fc63          	bgeu	a5,a1,8000045e <walk+0x5a>
    panic("walk");
    8000042a:	00007517          	auipc	a0,0x7
    8000042e:	c2650513          	addi	a0,a0,-986 # 80007050 <etext+0x50>
    80000432:	1a0050ef          	jal	800055d2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000436:	060a8263          	beqz	s5,8000049a <walk+0x96>
    8000043a:	cc5ff0ef          	jal	800000fe <kalloc>
    8000043e:	84aa                	mv	s1,a0
    80000440:	c139                	beqz	a0,80000486 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000442:	6605                	lui	a2,0x1
    80000444:	4581                	li	a1,0
    80000446:	d4bff0ef          	jal	80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000044a:	00c4d793          	srli	a5,s1,0xc
    8000044e:	07aa                	slli	a5,a5,0xa
    80000450:	0017e793          	ori	a5,a5,1
    80000454:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000458:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb5e7>
    8000045a:	036a0063          	beq	s4,s6,8000047a <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000045e:	0149d933          	srl	s2,s3,s4
    80000462:	1ff97913          	andi	s2,s2,511
    80000466:	090e                	slli	s2,s2,0x3
    80000468:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000046a:	00093483          	ld	s1,0(s2)
    8000046e:	0014f793          	andi	a5,s1,1
    80000472:	d3f1                	beqz	a5,80000436 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000474:	80a9                	srli	s1,s1,0xa
    80000476:	04b2                	slli	s1,s1,0xc
    80000478:	b7c5                	j	80000458 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000047a:	00c9d513          	srli	a0,s3,0xc
    8000047e:	1ff57513          	andi	a0,a0,511
    80000482:	050e                	slli	a0,a0,0x3
    80000484:	9526                	add	a0,a0,s1
}
    80000486:	70e2                	ld	ra,56(sp)
    80000488:	7442                	ld	s0,48(sp)
    8000048a:	74a2                	ld	s1,40(sp)
    8000048c:	7902                	ld	s2,32(sp)
    8000048e:	69e2                	ld	s3,24(sp)
    80000490:	6a42                	ld	s4,16(sp)
    80000492:	6aa2                	ld	s5,8(sp)
    80000494:	6b02                	ld	s6,0(sp)
    80000496:	6121                	addi	sp,sp,64
    80000498:	8082                	ret
        return 0;
    8000049a:	4501                	li	a0,0
    8000049c:	b7ed                	j	80000486 <walk+0x82>

000000008000049e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000049e:	57fd                	li	a5,-1
    800004a0:	83e9                	srli	a5,a5,0x1a
    800004a2:	00b7f463          	bgeu	a5,a1,800004aa <walkaddr+0xc>
    return 0;
    800004a6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a8:	8082                	ret
{
    800004aa:	1141                	addi	sp,sp,-16
    800004ac:	e406                	sd	ra,8(sp)
    800004ae:	e022                	sd	s0,0(sp)
    800004b0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b2:	4601                	li	a2,0
    800004b4:	f51ff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800004b8:	c105                	beqz	a0,800004d8 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004ba:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004bc:	0117f693          	andi	a3,a5,17
    800004c0:	4745                	li	a4,17
    return 0;
    800004c2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004c4:	00e68663          	beq	a3,a4,800004d0 <walkaddr+0x32>
}
    800004c8:	60a2                	ld	ra,8(sp)
    800004ca:	6402                	ld	s0,0(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret
  pa = PTE2PA(*pte);
    800004d0:	83a9                	srli	a5,a5,0xa
    800004d2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d6:	bfcd                	j	800004c8 <walkaddr+0x2a>
    return 0;
    800004d8:	4501                	li	a0,0
    800004da:	b7fd                	j	800004c8 <walkaddr+0x2a>

00000000800004dc <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004dc:	715d                	addi	sp,sp,-80
    800004de:	e486                	sd	ra,72(sp)
    800004e0:	e0a2                	sd	s0,64(sp)
    800004e2:	fc26                	sd	s1,56(sp)
    800004e4:	f84a                	sd	s2,48(sp)
    800004e6:	f44e                	sd	s3,40(sp)
    800004e8:	f052                	sd	s4,32(sp)
    800004ea:	ec56                	sd	s5,24(sp)
    800004ec:	e85a                	sd	s6,16(sp)
    800004ee:	e45e                	sd	s7,8(sp)
    800004f0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004f2:	03459793          	slli	a5,a1,0x34
    800004f6:	e7a9                	bnez	a5,80000540 <mappages+0x64>
    800004f8:	8aaa                	mv	s5,a0
    800004fa:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004fc:	03461793          	slli	a5,a2,0x34
    80000500:	e7b1                	bnez	a5,8000054c <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000502:	ca39                	beqz	a2,80000558 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000504:	77fd                	lui	a5,0xfffff
    80000506:	963e                	add	a2,a2,a5
    80000508:	00b609b3          	add	s3,a2,a1
  a = va;
    8000050c:	892e                	mv	s2,a1
    8000050e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000512:	6b85                	lui	s7,0x1
    80000514:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	ee7ff0ef          	jal	80000404 <walk>
    80000522:	c539                	beqz	a0,80000570 <mappages+0x94>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	ef95                	bnez	a5,80000564 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	05390863          	beq	s2,s3,80000588 <mappages+0xac>
    a += PGSIZE;
    8000053c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053e:	bfd9                	j	80000514 <mappages+0x38>
    panic("mappages: va not aligned");
    80000540:	00007517          	auipc	a0,0x7
    80000544:	b1850513          	addi	a0,a0,-1256 # 80007058 <etext+0x58>
    80000548:	08a050ef          	jal	800055d2 <panic>
    panic("mappages: size not aligned");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b2c50513          	addi	a0,a0,-1236 # 80007078 <etext+0x78>
    80000554:	07e050ef          	jal	800055d2 <panic>
    panic("mappages: size");
    80000558:	00007517          	auipc	a0,0x7
    8000055c:	b4050513          	addi	a0,a0,-1216 # 80007098 <etext+0x98>
    80000560:	072050ef          	jal	800055d2 <panic>
      panic("mappages: remap");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	b4450513          	addi	a0,a0,-1212 # 800070a8 <etext+0xa8>
    8000056c:	066050ef          	jal	800055d2 <panic>
      return -1;
    80000570:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000572:	60a6                	ld	ra,72(sp)
    80000574:	6406                	ld	s0,64(sp)
    80000576:	74e2                	ld	s1,56(sp)
    80000578:	7942                	ld	s2,48(sp)
    8000057a:	79a2                	ld	s3,40(sp)
    8000057c:	7a02                	ld	s4,32(sp)
    8000057e:	6ae2                	ld	s5,24(sp)
    80000580:	6b42                	ld	s6,16(sp)
    80000582:	6ba2                	ld	s7,8(sp)
    80000584:	6161                	addi	sp,sp,80
    80000586:	8082                	ret
  return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7e5                	j	80000572 <mappages+0x96>

000000008000058c <kvmmap>:
{
    8000058c:	1141                	addi	sp,sp,-16
    8000058e:	e406                	sd	ra,8(sp)
    80000590:	e022                	sd	s0,0(sp)
    80000592:	0800                	addi	s0,sp,16
    80000594:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000596:	86b2                	mv	a3,a2
    80000598:	863e                	mv	a2,a5
    8000059a:	f43ff0ef          	jal	800004dc <mappages>
    8000059e:	e509                	bnez	a0,800005a8 <kvmmap+0x1c>
}
    800005a0:	60a2                	ld	ra,8(sp)
    800005a2:	6402                	ld	s0,0(sp)
    800005a4:	0141                	addi	sp,sp,16
    800005a6:	8082                	ret
    panic("kvmmap");
    800005a8:	00007517          	auipc	a0,0x7
    800005ac:	b1050513          	addi	a0,a0,-1264 # 800070b8 <etext+0xb8>
    800005b0:	022050ef          	jal	800055d2 <panic>

00000000800005b4 <kvmmake>:
{
    800005b4:	1101                	addi	sp,sp,-32
    800005b6:	ec06                	sd	ra,24(sp)
    800005b8:	e822                	sd	s0,16(sp)
    800005ba:	e426                	sd	s1,8(sp)
    800005bc:	e04a                	sd	s2,0(sp)
    800005be:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005c0:	b3fff0ef          	jal	800000fe <kalloc>
    800005c4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005c6:	6605                	lui	a2,0x1
    800005c8:	4581                	li	a1,0
    800005ca:	bc7ff0ef          	jal	80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005ce:	4719                	li	a4,6
    800005d0:	6685                	lui	a3,0x1
    800005d2:	10000637          	lui	a2,0x10000
    800005d6:	100005b7          	lui	a1,0x10000
    800005da:	8526                	mv	a0,s1
    800005dc:	fb1ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005e0:	4719                	li	a4,6
    800005e2:	6685                	lui	a3,0x1
    800005e4:	10001637          	lui	a2,0x10001
    800005e8:	100015b7          	lui	a1,0x10001
    800005ec:	8526                	mv	a0,s1
    800005ee:	f9fff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005f2:	4719                	li	a4,6
    800005f4:	040006b7          	lui	a3,0x4000
    800005f8:	0c000637          	lui	a2,0xc000
    800005fc:	0c0005b7          	lui	a1,0xc000
    80000600:	8526                	mv	a0,s1
    80000602:	f8bff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000606:	00007917          	auipc	s2,0x7
    8000060a:	9fa90913          	addi	s2,s2,-1542 # 80007000 <etext>
    8000060e:	4729                	li	a4,10
    80000610:	80007697          	auipc	a3,0x80007
    80000614:	9f068693          	addi	a3,a3,-1552 # 7000 <_entry-0x7fff9000>
    80000618:	4605                	li	a2,1
    8000061a:	067e                	slli	a2,a2,0x1f
    8000061c:	85b2                	mv	a1,a2
    8000061e:	8526                	mv	a0,s1
    80000620:	f6dff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000624:	46c5                	li	a3,17
    80000626:	06ee                	slli	a3,a3,0x1b
    80000628:	4719                	li	a4,6
    8000062a:	412686b3          	sub	a3,a3,s2
    8000062e:	864a                	mv	a2,s2
    80000630:	85ca                	mv	a1,s2
    80000632:	8526                	mv	a0,s1
    80000634:	f59ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000638:	4729                	li	a4,10
    8000063a:	6685                	lui	a3,0x1
    8000063c:	00006617          	auipc	a2,0x6
    80000640:	9c460613          	addi	a2,a2,-1596 # 80006000 <_trampoline>
    80000644:	040005b7          	lui	a1,0x4000
    80000648:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000064a:	05b2                	slli	a1,a1,0xc
    8000064c:	8526                	mv	a0,s1
    8000064e:	f3fff0ef          	jal	8000058c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000652:	8526                	mv	a0,s1
    80000654:	5da000ef          	jal	80000c2e <proc_mapstacks>
}
    80000658:	8526                	mv	a0,s1
    8000065a:	60e2                	ld	ra,24(sp)
    8000065c:	6442                	ld	s0,16(sp)
    8000065e:	64a2                	ld	s1,8(sp)
    80000660:	6902                	ld	s2,0(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <kvminit>:
{
    80000666:	1141                	addi	sp,sp,-16
    80000668:	e406                	sd	ra,8(sp)
    8000066a:	e022                	sd	s0,0(sp)
    8000066c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000066e:	f47ff0ef          	jal	800005b4 <kvmmake>
    80000672:	0000a797          	auipc	a5,0xa
    80000676:	e4a7b323          	sd	a0,-442(a5) # 8000a4b8 <kernel_pagetable>
}
    8000067a:	60a2                	ld	ra,8(sp)
    8000067c:	6402                	ld	s0,0(sp)
    8000067e:	0141                	addi	sp,sp,16
    80000680:	8082                	ret

0000000080000682 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000682:	715d                	addi	sp,sp,-80
    80000684:	e486                	sd	ra,72(sp)
    80000686:	e0a2                	sd	s0,64(sp)
    80000688:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000068a:	03459793          	slli	a5,a1,0x34
    8000068e:	e39d                	bnez	a5,800006b4 <uvmunmap+0x32>
    80000690:	f84a                	sd	s2,48(sp)
    80000692:	f44e                	sd	s3,40(sp)
    80000694:	f052                	sd	s4,32(sp)
    80000696:	ec56                	sd	s5,24(sp)
    80000698:	e85a                	sd	s6,16(sp)
    8000069a:	e45e                	sd	s7,8(sp)
    8000069c:	8a2a                	mv	s4,a0
    8000069e:	892e                	mv	s2,a1
    800006a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006a2:	0632                	slli	a2,a2,0xc
    800006a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800006a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006aa:	6b05                	lui	s6,0x1
    800006ac:	0735ff63          	bgeu	a1,s3,8000072a <uvmunmap+0xa8>
    800006b0:	fc26                	sd	s1,56(sp)
    800006b2:	a0a9                	j	800006fc <uvmunmap+0x7a>
    800006b4:	fc26                	sd	s1,56(sp)
    800006b6:	f84a                	sd	s2,48(sp)
    800006b8:	f44e                	sd	s3,40(sp)
    800006ba:	f052                	sd	s4,32(sp)
    800006bc:	ec56                	sd	s5,24(sp)
    800006be:	e85a                	sd	s6,16(sp)
    800006c0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	9fe50513          	addi	a0,a0,-1538 # 800070c0 <etext+0xc0>
    800006ca:	709040ef          	jal	800055d2 <panic>
      panic("uvmunmap: walk");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a0a50513          	addi	a0,a0,-1526 # 800070d8 <etext+0xd8>
    800006d6:	6fd040ef          	jal	800055d2 <panic>
      panic("uvmunmap: not mapped");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a0e50513          	addi	a0,a0,-1522 # 800070e8 <etext+0xe8>
    800006e2:	6f1040ef          	jal	800055d2 <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00007517          	auipc	a0,0x7
    800006ea:	a1a50513          	addi	a0,a0,-1510 # 80007100 <etext+0x100>
    800006ee:	6e5040ef          	jal	800055d2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006f6:	995a                	add	s2,s2,s6
    800006f8:	03397863          	bgeu	s2,s3,80000728 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006fc:	4601                	li	a2,0
    800006fe:	85ca                	mv	a1,s2
    80000700:	8552                	mv	a0,s4
    80000702:	d03ff0ef          	jal	80000404 <walk>
    80000706:	84aa                	mv	s1,a0
    80000708:	d179                	beqz	a0,800006ce <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000070a:	6108                	ld	a0,0(a0)
    8000070c:	00157793          	andi	a5,a0,1
    80000710:	d7e9                	beqz	a5,800006da <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000712:	3ff57793          	andi	a5,a0,1023
    80000716:	fd7788e3          	beq	a5,s7,800006e6 <uvmunmap+0x64>
    if(do_free){
    8000071a:	fc0a8ce3          	beqz	s5,800006f2 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000071e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000720:	0532                	slli	a0,a0,0xc
    80000722:	8fbff0ef          	jal	8000001c <kfree>
    80000726:	b7f1                	j	800006f2 <uvmunmap+0x70>
    80000728:	74e2                	ld	s1,56(sp)
    8000072a:	7942                	ld	s2,48(sp)
    8000072c:	79a2                	ld	s3,40(sp)
    8000072e:	7a02                	ld	s4,32(sp)
    80000730:	6ae2                	ld	s5,24(sp)
    80000732:	6b42                	ld	s6,16(sp)
    80000734:	6ba2                	ld	s7,8(sp)
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	6161                	addi	sp,sp,80
    8000073c:	8082                	ret

000000008000073e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000073e:	1101                	addi	sp,sp,-32
    80000740:	ec06                	sd	ra,24(sp)
    80000742:	e822                	sd	s0,16(sp)
    80000744:	e426                	sd	s1,8(sp)
    80000746:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000748:	9b7ff0ef          	jal	800000fe <kalloc>
    8000074c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000074e:	c509                	beqz	a0,80000758 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	a3dff0ef          	jal	80000190 <memset>
  return pagetable;
}
    80000758:	8526                	mv	a0,s1
    8000075a:	60e2                	ld	ra,24(sp)
    8000075c:	6442                	ld	s0,16(sp)
    8000075e:	64a2                	ld	s1,8(sp)
    80000760:	6105                	addi	sp,sp,32
    80000762:	8082                	ret

0000000080000764 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000764:	7179                	addi	sp,sp,-48
    80000766:	f406                	sd	ra,40(sp)
    80000768:	f022                	sd	s0,32(sp)
    8000076a:	ec26                	sd	s1,24(sp)
    8000076c:	e84a                	sd	s2,16(sp)
    8000076e:	e44e                	sd	s3,8(sp)
    80000770:	e052                	sd	s4,0(sp)
    80000772:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000774:	6785                	lui	a5,0x1
    80000776:	04f67063          	bgeu	a2,a5,800007b6 <uvmfirst+0x52>
    8000077a:	8a2a                	mv	s4,a0
    8000077c:	89ae                	mv	s3,a1
    8000077e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000780:	97fff0ef          	jal	800000fe <kalloc>
    80000784:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	a07ff0ef          	jal	80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000078e:	4779                	li	a4,30
    80000790:	86ca                	mv	a3,s2
    80000792:	6605                	lui	a2,0x1
    80000794:	4581                	li	a1,0
    80000796:	8552                	mv	a0,s4
    80000798:	d45ff0ef          	jal	800004dc <mappages>
  memmove(mem, src, sz);
    8000079c:	8626                	mv	a2,s1
    8000079e:	85ce                	mv	a1,s3
    800007a0:	854a                	mv	a0,s2
    800007a2:	a4bff0ef          	jal	800001ec <memmove>
}
    800007a6:	70a2                	ld	ra,40(sp)
    800007a8:	7402                	ld	s0,32(sp)
    800007aa:	64e2                	ld	s1,24(sp)
    800007ac:	6942                	ld	s2,16(sp)
    800007ae:	69a2                	ld	s3,8(sp)
    800007b0:	6a02                	ld	s4,0(sp)
    800007b2:	6145                	addi	sp,sp,48
    800007b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	96250513          	addi	a0,a0,-1694 # 80007118 <etext+0x118>
    800007be:	615040ef          	jal	800055d2 <panic>

00000000800007c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ce:	00b67d63          	bgeu	a2,a1,800007e8 <uvmdealloc+0x26>
    800007d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007d4:	6785                	lui	a5,0x1
    800007d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d8:	00f60733          	add	a4,a2,a5
    800007dc:	76fd                	lui	a3,0xfffff
    800007de:	8f75                	and	a4,a4,a3
    800007e0:	97ae                	add	a5,a5,a1
    800007e2:	8ff5                	and	a5,a5,a3
    800007e4:	00f76863          	bltu	a4,a5,800007f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007f4:	8f99                	sub	a5,a5,a4
    800007f6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007f8:	4685                	li	a3,1
    800007fa:	0007861b          	sext.w	a2,a5
    800007fe:	85ba                	mv	a1,a4
    80000800:	e83ff0ef          	jal	80000682 <uvmunmap>
    80000804:	b7d5                	j	800007e8 <uvmdealloc+0x26>

0000000080000806 <uvmalloc>:
  if(newsz < oldsz)
    80000806:	08b66f63          	bltu	a2,a1,800008a4 <uvmalloc+0x9e>
{
    8000080a:	7139                	addi	sp,sp,-64
    8000080c:	fc06                	sd	ra,56(sp)
    8000080e:	f822                	sd	s0,48(sp)
    80000810:	ec4e                	sd	s3,24(sp)
    80000812:	e852                	sd	s4,16(sp)
    80000814:	e456                	sd	s5,8(sp)
    80000816:	0080                	addi	s0,sp,64
    80000818:	8aaa                	mv	s5,a0
    8000081a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000081c:	6785                	lui	a5,0x1
    8000081e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000820:	95be                	add	a1,a1,a5
    80000822:	77fd                	lui	a5,0xfffff
    80000824:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000828:	08c9f063          	bgeu	s3,a2,800008a8 <uvmalloc+0xa2>
    8000082c:	f426                	sd	s1,40(sp)
    8000082e:	f04a                	sd	s2,32(sp)
    80000830:	e05a                	sd	s6,0(sp)
    80000832:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000834:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000838:	8c7ff0ef          	jal	800000fe <kalloc>
    8000083c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000083e:	c515                	beqz	a0,8000086a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	94dff0ef          	jal	80000190 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000848:	875a                	mv	a4,s6
    8000084a:	86a6                	mv	a3,s1
    8000084c:	6605                	lui	a2,0x1
    8000084e:	85ca                	mv	a1,s2
    80000850:	8556                	mv	a0,s5
    80000852:	c8bff0ef          	jal	800004dc <mappages>
    80000856:	e915                	bnez	a0,8000088a <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000858:	6785                	lui	a5,0x1
    8000085a:	993e                	add	s2,s2,a5
    8000085c:	fd496ee3          	bltu	s2,s4,80000838 <uvmalloc+0x32>
  return newsz;
    80000860:	8552                	mv	a0,s4
    80000862:	74a2                	ld	s1,40(sp)
    80000864:	7902                	ld	s2,32(sp)
    80000866:	6b02                	ld	s6,0(sp)
    80000868:	a811                	j	8000087c <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    8000086a:	864e                	mv	a2,s3
    8000086c:	85ca                	mv	a1,s2
    8000086e:	8556                	mv	a0,s5
    80000870:	f53ff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    80000874:	4501                	li	a0,0
    80000876:	74a2                	ld	s1,40(sp)
    80000878:	7902                	ld	s2,32(sp)
    8000087a:	6b02                	ld	s6,0(sp)
}
    8000087c:	70e2                	ld	ra,56(sp)
    8000087e:	7442                	ld	s0,48(sp)
    80000880:	69e2                	ld	s3,24(sp)
    80000882:	6a42                	ld	s4,16(sp)
    80000884:	6aa2                	ld	s5,8(sp)
    80000886:	6121                	addi	sp,sp,64
    80000888:	8082                	ret
      kfree(mem);
    8000088a:	8526                	mv	a0,s1
    8000088c:	f90ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000890:	864e                	mv	a2,s3
    80000892:	85ca                	mv	a1,s2
    80000894:	8556                	mv	a0,s5
    80000896:	f2dff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    8000089a:	4501                	li	a0,0
    8000089c:	74a2                	ld	s1,40(sp)
    8000089e:	7902                	ld	s2,32(sp)
    800008a0:	6b02                	ld	s6,0(sp)
    800008a2:	bfe9                	j	8000087c <uvmalloc+0x76>
    return oldsz;
    800008a4:	852e                	mv	a0,a1
}
    800008a6:	8082                	ret
  return newsz;
    800008a8:	8532                	mv	a0,a2
    800008aa:	bfc9                	j	8000087c <uvmalloc+0x76>

00000000800008ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008ac:	7179                	addi	sp,sp,-48
    800008ae:	f406                	sd	ra,40(sp)
    800008b0:	f022                	sd	s0,32(sp)
    800008b2:	ec26                	sd	s1,24(sp)
    800008b4:	e84a                	sd	s2,16(sp)
    800008b6:	e44e                	sd	s3,8(sp)
    800008b8:	e052                	sd	s4,0(sp)
    800008ba:	1800                	addi	s0,sp,48
    800008bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008be:	84aa                	mv	s1,a0
    800008c0:	6905                	lui	s2,0x1
    800008c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	4985                	li	s3,1
    800008c6:	a819                	j	800008dc <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008ca:	00c79513          	slli	a0,a5,0xc
    800008ce:	fdfff0ef          	jal	800008ac <freewalk>
      pagetable[i] = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008d6:	04a1                	addi	s1,s1,8
    800008d8:	01248f63          	beq	s1,s2,800008f6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008de:	00f7f713          	andi	a4,a5,15
    800008e2:	ff3703e3          	beq	a4,s3,800008c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008e6:	8b85                	andi	a5,a5,1
    800008e8:	d7fd                	beqz	a5,800008d6 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008ea:	00007517          	auipc	a0,0x7
    800008ee:	84e50513          	addi	a0,a0,-1970 # 80007138 <etext+0x138>
    800008f2:	4e1040ef          	jal	800055d2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008f6:	8552                	mv	a0,s4
    800008f8:	f24ff0ef          	jal	8000001c <kfree>
}
    800008fc:	70a2                	ld	ra,40(sp)
    800008fe:	7402                	ld	s0,32(sp)
    80000900:	64e2                	ld	s1,24(sp)
    80000902:	6942                	ld	s2,16(sp)
    80000904:	69a2                	ld	s3,8(sp)
    80000906:	6a02                	ld	s4,0(sp)
    80000908:	6145                	addi	sp,sp,48
    8000090a:	8082                	ret

000000008000090c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
  if(sz > 0)
    80000918:	e989                	bnez	a1,8000092a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000091a:	8526                	mv	a0,s1
    8000091c:	f91ff0ef          	jal	800008ac <freewalk>
}
    80000920:	60e2                	ld	ra,24(sp)
    80000922:	6442                	ld	s0,16(sp)
    80000924:	64a2                	ld	s1,8(sp)
    80000926:	6105                	addi	sp,sp,32
    80000928:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	4685                	li	a3,1
    80000932:	00c5d613          	srli	a2,a1,0xc
    80000936:	4581                	li	a1,0
    80000938:	d4bff0ef          	jal	80000682 <uvmunmap>
    8000093c:	bff9                	j	8000091a <uvmfree+0xe>

000000008000093e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000093e:	c65d                	beqz	a2,800009ec <uvmcopy+0xae>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	0880                	addi	s0,sp,80
    80000956:	8b2a                	mv	s6,a0
    80000958:	8aae                	mv	s5,a1
    8000095a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000095e:	4601                	li	a2,0
    80000960:	85ce                	mv	a1,s3
    80000962:	855a                	mv	a0,s6
    80000964:	aa1ff0ef          	jal	80000404 <walk>
    80000968:	c121                	beqz	a0,800009a8 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000096a:	6118                	ld	a4,0(a0)
    8000096c:	00177793          	andi	a5,a4,1
    80000970:	c3b1                	beqz	a5,800009b4 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000972:	00a75593          	srli	a1,a4,0xa
    80000976:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000097a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000097e:	f80ff0ef          	jal	800000fe <kalloc>
    80000982:	892a                	mv	s2,a0
    80000984:	c129                	beqz	a0,800009c6 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	85de                	mv	a1,s7
    8000098a:	863ff0ef          	jal	800001ec <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000098e:	8726                	mv	a4,s1
    80000990:	86ca                	mv	a3,s2
    80000992:	6605                	lui	a2,0x1
    80000994:	85ce                	mv	a1,s3
    80000996:	8556                	mv	a0,s5
    80000998:	b45ff0ef          	jal	800004dc <mappages>
    8000099c:	e115                	bnez	a0,800009c0 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000099e:	6785                	lui	a5,0x1
    800009a0:	99be                	add	s3,s3,a5
    800009a2:	fb49eee3          	bltu	s3,s4,8000095e <uvmcopy+0x20>
    800009a6:	a805                	j	800009d6 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800009a8:	00006517          	auipc	a0,0x6
    800009ac:	7a050513          	addi	a0,a0,1952 # 80007148 <etext+0x148>
    800009b0:	423040ef          	jal	800055d2 <panic>
      panic("uvmcopy: page not present");
    800009b4:	00006517          	auipc	a0,0x6
    800009b8:	7b450513          	addi	a0,a0,1972 # 80007168 <etext+0x168>
    800009bc:	417040ef          	jal	800055d2 <panic>
      kfree(mem);
    800009c0:	854a                	mv	a0,s2
    800009c2:	e5aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	00c9d613          	srli	a2,s3,0xc
    800009cc:	4581                	li	a1,0
    800009ce:	8556                	mv	a0,s5
    800009d0:	cb3ff0ef          	jal	80000682 <uvmunmap>
  return -1;
    800009d4:	557d                	li	a0,-1
}
    800009d6:	60a6                	ld	ra,72(sp)
    800009d8:	6406                	ld	s0,64(sp)
    800009da:	74e2                	ld	s1,56(sp)
    800009dc:	7942                	ld	s2,48(sp)
    800009de:	79a2                	ld	s3,40(sp)
    800009e0:	7a02                	ld	s4,32(sp)
    800009e2:	6ae2                	ld	s5,24(sp)
    800009e4:	6b42                	ld	s6,16(sp)
    800009e6:	6ba2                	ld	s7,8(sp)
    800009e8:	6161                	addi	sp,sp,80
    800009ea:	8082                	ret
  return 0;
    800009ec:	4501                	li	a0,0
}
    800009ee:	8082                	ret

00000000800009f0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009f0:	1141                	addi	sp,sp,-16
    800009f2:	e406                	sd	ra,8(sp)
    800009f4:	e022                	sd	s0,0(sp)
    800009f6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009f8:	4601                	li	a2,0
    800009fa:	a0bff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800009fe:	c901                	beqz	a0,80000a0e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a00:	611c                	ld	a5,0(a0)
    80000a02:	9bbd                	andi	a5,a5,-17
    80000a04:	e11c                	sd	a5,0(a0)
}
    80000a06:	60a2                	ld	ra,8(sp)
    80000a08:	6402                	ld	s0,0(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    panic("uvmclear");
    80000a0e:	00006517          	auipc	a0,0x6
    80000a12:	77a50513          	addi	a0,a0,1914 # 80007188 <etext+0x188>
    80000a16:	3bd040ef          	jal	800055d2 <panic>

0000000080000a1a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a1a:	cad1                	beqz	a3,80000aae <copyout+0x94>
{
    80000a1c:	711d                	addi	sp,sp,-96
    80000a1e:	ec86                	sd	ra,88(sp)
    80000a20:	e8a2                	sd	s0,80(sp)
    80000a22:	e4a6                	sd	s1,72(sp)
    80000a24:	fc4e                	sd	s3,56(sp)
    80000a26:	f456                	sd	s5,40(sp)
    80000a28:	f05a                	sd	s6,32(sp)
    80000a2a:	ec5e                	sd	s7,24(sp)
    80000a2c:	1080                	addi	s0,sp,96
    80000a2e:	8baa                	mv	s7,a0
    80000a30:	8aae                	mv	s5,a1
    80000a32:	8b32                	mv	s6,a2
    80000a34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a36:	74fd                	lui	s1,0xfffff
    80000a38:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000a3a:	57fd                	li	a5,-1
    80000a3c:	83e9                	srli	a5,a5,0x1a
    80000a3e:	0697ea63          	bltu	a5,s1,80000ab2 <copyout+0x98>
    80000a42:	e0ca                	sd	s2,64(sp)
    80000a44:	f852                	sd	s4,48(sp)
    80000a46:	e862                	sd	s8,16(sp)
    80000a48:	e466                	sd	s9,8(sp)
    80000a4a:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a4c:	4cd5                	li	s9,21
    80000a4e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a50:	8c3e                	mv	s8,a5
    80000a52:	a025                	j	80000a7a <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a54:	83a9                	srli	a5,a5,0xa
    80000a56:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a58:	409a8533          	sub	a0,s5,s1
    80000a5c:	0009061b          	sext.w	a2,s2
    80000a60:	85da                	mv	a1,s6
    80000a62:	953e                	add	a0,a0,a5
    80000a64:	f88ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000a68:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a6c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a6e:	02098963          	beqz	s3,80000aa0 <copyout+0x86>
    if(va0 >= MAXVA)
    80000a72:	054c6263          	bltu	s8,s4,80000ab6 <copyout+0x9c>
    80000a76:	84d2                	mv	s1,s4
    80000a78:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a7a:	4601                	li	a2,0
    80000a7c:	85a6                	mv	a1,s1
    80000a7e:	855e                	mv	a0,s7
    80000a80:	985ff0ef          	jal	80000404 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a84:	c121                	beqz	a0,80000ac4 <copyout+0xaa>
    80000a86:	611c                	ld	a5,0(a0)
    80000a88:	0157f713          	andi	a4,a5,21
    80000a8c:	05971b63          	bne	a4,s9,80000ae2 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a90:	01a48a33          	add	s4,s1,s10
    80000a94:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a98:	fb29fee3          	bgeu	s3,s2,80000a54 <copyout+0x3a>
    80000a9c:	894e                	mv	s2,s3
    80000a9e:	bf5d                	j	80000a54 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000aa0:	4501                	li	a0,0
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	a015                	j	80000ad0 <copyout+0xb6>
    80000aae:	4501                	li	a0,0
}
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	a831                	j	80000ad0 <copyout+0xb6>
    80000ab6:	557d                	li	a0,-1
    80000ab8:	6906                	ld	s2,64(sp)
    80000aba:	7a42                	ld	s4,48(sp)
    80000abc:	6c42                	ld	s8,16(sp)
    80000abe:	6ca2                	ld	s9,8(sp)
    80000ac0:	6d02                	ld	s10,0(sp)
    80000ac2:	a039                	j	80000ad0 <copyout+0xb6>
      return -1;
    80000ac4:	557d                	li	a0,-1
    80000ac6:	6906                	ld	s2,64(sp)
    80000ac8:	7a42                	ld	s4,48(sp)
    80000aca:	6c42                	ld	s8,16(sp)
    80000acc:	6ca2                	ld	s9,8(sp)
    80000ace:	6d02                	ld	s10,0(sp)
}
    80000ad0:	60e6                	ld	ra,88(sp)
    80000ad2:	6446                	ld	s0,80(sp)
    80000ad4:	64a6                	ld	s1,72(sp)
    80000ad6:	79e2                	ld	s3,56(sp)
    80000ad8:	7aa2                	ld	s5,40(sp)
    80000ada:	7b02                	ld	s6,32(sp)
    80000adc:	6be2                	ld	s7,24(sp)
    80000ade:	6125                	addi	sp,sp,96
    80000ae0:	8082                	ret
      return -1;
    80000ae2:	557d                	li	a0,-1
    80000ae4:	6906                	ld	s2,64(sp)
    80000ae6:	7a42                	ld	s4,48(sp)
    80000ae8:	6c42                	ld	s8,16(sp)
    80000aea:	6ca2                	ld	s9,8(sp)
    80000aec:	6d02                	ld	s10,0(sp)
    80000aee:	b7cd                	j	80000ad0 <copyout+0xb6>

0000000080000af0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6a5                	beqz	a3,80000b58 <copyin+0x68>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8a2e                	mv	s4,a1
    80000b0e:	8c32                	mv	s8,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a00d                	j	80000b38 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b18:	018505b3          	add	a1,a0,s8
    80000b1c:	0004861b          	sext.w	a2,s1
    80000b20:	412585b3          	sub	a1,a1,s2
    80000b24:	8552                	mv	a0,s4
    80000b26:	ec6ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b34:	02098063          	beqz	s3,80000b54 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	95fff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000b44:	cd01                	beqz	a0,80000b5c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b46:	418904b3          	sub	s1,s2,s8
    80000b4a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4c:	fc99f6e3          	bgeu	s3,s1,80000b18 <copyin+0x28>
    80000b50:	84ce                	mv	s1,s3
    80000b52:	b7d9                	j	80000b18 <copyin+0x28>
  }
  return 0;
    80000b54:	4501                	li	a0,0
    80000b56:	a021                	j	80000b5e <copyin+0x6e>
    80000b58:	4501                	li	a0,0
}
    80000b5a:	8082                	ret
      return -1;
    80000b5c:	557d                	li	a0,-1
}
    80000b5e:	60a6                	ld	ra,72(sp)
    80000b60:	6406                	ld	s0,64(sp)
    80000b62:	74e2                	ld	s1,56(sp)
    80000b64:	7942                	ld	s2,48(sp)
    80000b66:	79a2                	ld	s3,40(sp)
    80000b68:	7a02                	ld	s4,32(sp)
    80000b6a:	6ae2                	ld	s5,24(sp)
    80000b6c:	6b42                	ld	s6,16(sp)
    80000b6e:	6ba2                	ld	s7,8(sp)
    80000b70:	6c02                	ld	s8,0(sp)
    80000b72:	6161                	addi	sp,sp,80
    80000b74:	8082                	ret

0000000080000b76 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b76:	c6dd                	beqz	a3,80000c24 <copyinstr+0xae>
{
    80000b78:	715d                	addi	sp,sp,-80
    80000b7a:	e486                	sd	ra,72(sp)
    80000b7c:	e0a2                	sd	s0,64(sp)
    80000b7e:	fc26                	sd	s1,56(sp)
    80000b80:	f84a                	sd	s2,48(sp)
    80000b82:	f44e                	sd	s3,40(sp)
    80000b84:	f052                	sd	s4,32(sp)
    80000b86:	ec56                	sd	s5,24(sp)
    80000b88:	e85a                	sd	s6,16(sp)
    80000b8a:	e45e                	sd	s7,8(sp)
    80000b8c:	0880                	addi	s0,sp,80
    80000b8e:	8a2a                	mv	s4,a0
    80000b90:	8b2e                	mv	s6,a1
    80000b92:	8bb2                	mv	s7,a2
    80000b94:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b96:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b98:	6985                	lui	s3,0x1
    80000b9a:	a825                	j	80000bd2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b9c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ba0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ba2:	37fd                	addiw	a5,a5,-1
    80000ba4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ba8:	60a6                	ld	ra,72(sp)
    80000baa:	6406                	ld	s0,64(sp)
    80000bac:	74e2                	ld	s1,56(sp)
    80000bae:	7942                	ld	s2,48(sp)
    80000bb0:	79a2                	ld	s3,40(sp)
    80000bb2:	7a02                	ld	s4,32(sp)
    80000bb4:	6ae2                	ld	s5,24(sp)
    80000bb6:	6b42                	ld	s6,16(sp)
    80000bb8:	6ba2                	ld	s7,8(sp)
    80000bba:	6161                	addi	sp,sp,80
    80000bbc:	8082                	ret
    80000bbe:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bc2:	9742                	add	a4,a4,a6
      --max;
    80000bc4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bc8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bcc:	04e58463          	beq	a1,a4,80000c14 <copyinstr+0x9e>
{
    80000bd0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85a6                	mv	a1,s1
    80000bd8:	8552                	mv	a0,s4
    80000bda:	8c5ff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000bde:	cd0d                	beqz	a0,80000c18 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000be0:	417486b3          	sub	a3,s1,s7
    80000be4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000be6:	00d97363          	bgeu	s2,a3,80000bec <copyinstr+0x76>
    80000bea:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bec:	955e                	add	a0,a0,s7
    80000bee:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bf0:	c695                	beqz	a3,80000c1c <copyinstr+0xa6>
    80000bf2:	87da                	mv	a5,s6
    80000bf4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bf6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bfa:	96da                	add	a3,a3,s6
    80000bfc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bfe:	00f60733          	add	a4,a2,a5
    80000c02:	00074703          	lbu	a4,0(a4)
    80000c06:	db59                	beqz	a4,80000b9c <copyinstr+0x26>
        *dst = *p;
    80000c08:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c0c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c0e:	fed797e3          	bne	a5,a3,80000bfc <copyinstr+0x86>
    80000c12:	b775                	j	80000bbe <copyinstr+0x48>
    80000c14:	4781                	li	a5,0
    80000c16:	b771                	j	80000ba2 <copyinstr+0x2c>
      return -1;
    80000c18:	557d                	li	a0,-1
    80000c1a:	b779                	j	80000ba8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c1c:	6b85                	lui	s7,0x1
    80000c1e:	9ba6                	add	s7,s7,s1
    80000c20:	87da                	mv	a5,s6
    80000c22:	b77d                	j	80000bd0 <copyinstr+0x5a>
  int got_null = 0;
    80000c24:	4781                	li	a5,0
  if(got_null){
    80000c26:	37fd                	addiw	a5,a5,-1
    80000c28:	0007851b          	sext.w	a0,a5
}
    80000c2c:	8082                	ret

0000000080000c2e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2e:	7139                	addi	sp,sp,-64
    80000c30:	fc06                	sd	ra,56(sp)
    80000c32:	f822                	sd	s0,48(sp)
    80000c34:	f426                	sd	s1,40(sp)
    80000c36:	f04a                	sd	s2,32(sp)
    80000c38:	ec4e                	sd	s3,24(sp)
    80000c3a:	e852                	sd	s4,16(sp)
    80000c3c:	e456                	sd	s5,8(sp)
    80000c3e:	e05a                	sd	s6,0(sp)
    80000c40:	0080                	addi	s0,sp,64
    80000c42:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c44:	0000a497          	auipc	s1,0xa
    80000c48:	cec48493          	addi	s1,s1,-788 # 8000a930 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c4c:	8b26                	mv	s6,s1
    80000c4e:	ff4df937          	lui	s2,0xff4df
    80000c52:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafad>
    80000c56:	0936                	slli	s2,s2,0xd
    80000c58:	6f590913          	addi	s2,s2,1781
    80000c5c:	0936                	slli	s2,s2,0xd
    80000c5e:	bd390913          	addi	s2,s2,-1069
    80000c62:	0932                	slli	s2,s2,0xc
    80000c64:	7a790913          	addi	s2,s2,1959
    80000c68:	040009b7          	lui	s3,0x4000
    80000c6c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c6e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	00010a97          	auipc	s5,0x10
    80000c74:	8c0a8a93          	addi	s5,s5,-1856 # 80010530 <tickslock>
    char *pa = kalloc();
    80000c78:	c86ff0ef          	jal	800000fe <kalloc>
    80000c7c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7e:	cd15                	beqz	a0,80000cba <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c80:	416485b3          	sub	a1,s1,s6
    80000c84:	8591                	srai	a1,a1,0x4
    80000c86:	032585b3          	mul	a1,a1,s2
    80000c8a:	2585                	addiw	a1,a1,1
    80000c8c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c90:	4719                	li	a4,6
    80000c92:	6685                	lui	a3,0x1
    80000c94:	40b985b3          	sub	a1,s3,a1
    80000c98:	8552                	mv	a0,s4
    80000c9a:	8f3ff0ef          	jal	8000058c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9e:	17048493          	addi	s1,s1,368
    80000ca2:	fd549be3          	bne	s1,s5,80000c78 <proc_mapstacks+0x4a>
  }
}
    80000ca6:	70e2                	ld	ra,56(sp)
    80000ca8:	7442                	ld	s0,48(sp)
    80000caa:	74a2                	ld	s1,40(sp)
    80000cac:	7902                	ld	s2,32(sp)
    80000cae:	69e2                	ld	s3,24(sp)
    80000cb0:	6a42                	ld	s4,16(sp)
    80000cb2:	6aa2                	ld	s5,8(sp)
    80000cb4:	6b02                	ld	s6,0(sp)
    80000cb6:	6121                	addi	sp,sp,64
    80000cb8:	8082                	ret
      panic("kalloc");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	4de50513          	addi	a0,a0,1246 # 80007198 <etext+0x198>
    80000cc2:	111040ef          	jal	800055d2 <panic>

0000000080000cc6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc6:	7139                	addi	sp,sp,-64
    80000cc8:	fc06                	sd	ra,56(sp)
    80000cca:	f822                	sd	s0,48(sp)
    80000ccc:	f426                	sd	s1,40(sp)
    80000cce:	f04a                	sd	s2,32(sp)
    80000cd0:	ec4e                	sd	s3,24(sp)
    80000cd2:	e852                	sd	s4,16(sp)
    80000cd4:	e456                	sd	s5,8(sp)
    80000cd6:	e05a                	sd	s6,0(sp)
    80000cd8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cda:	00006597          	auipc	a1,0x6
    80000cde:	4c658593          	addi	a1,a1,1222 # 800071a0 <etext+0x1a0>
    80000ce2:	0000a517          	auipc	a0,0xa
    80000ce6:	81e50513          	addi	a0,a0,-2018 # 8000a500 <pid_lock>
    80000cea:	397040ef          	jal	80005880 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cee:	00006597          	auipc	a1,0x6
    80000cf2:	4ba58593          	addi	a1,a1,1210 # 800071a8 <etext+0x1a8>
    80000cf6:	0000a517          	auipc	a0,0xa
    80000cfa:	82250513          	addi	a0,a0,-2014 # 8000a518 <wait_lock>
    80000cfe:	383040ef          	jal	80005880 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000a497          	auipc	s1,0xa
    80000d06:	c2e48493          	addi	s1,s1,-978 # 8000a930 <proc>
      initlock(&p->lock, "proc");
    80000d0a:	00006b17          	auipc	s6,0x6
    80000d0e:	4aeb0b13          	addi	s6,s6,1198 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d12:	8aa6                	mv	s5,s1
    80000d14:	ff4df937          	lui	s2,0xff4df
    80000d18:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafad>
    80000d1c:	0936                	slli	s2,s2,0xd
    80000d1e:	6f590913          	addi	s2,s2,1781
    80000d22:	0936                	slli	s2,s2,0xd
    80000d24:	bd390913          	addi	s2,s2,-1069
    80000d28:	0932                	slli	s2,s2,0xc
    80000d2a:	7a790913          	addi	s2,s2,1959
    80000d2e:	040009b7          	lui	s3,0x4000
    80000d32:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d34:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	0000fa17          	auipc	s4,0xf
    80000d3a:	7faa0a13          	addi	s4,s4,2042 # 80010530 <tickslock>
      initlock(&p->lock, "proc");
    80000d3e:	85da                	mv	a1,s6
    80000d40:	8526                	mv	a0,s1
    80000d42:	33f040ef          	jal	80005880 <initlock>
      p->state = UNUSED;
    80000d46:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d4a:	415487b3          	sub	a5,s1,s5
    80000d4e:	8791                	srai	a5,a5,0x4
    80000d50:	032787b3          	mul	a5,a5,s2
    80000d54:	2785                	addiw	a5,a5,1
    80000d56:	00d7979b          	slliw	a5,a5,0xd
    80000d5a:	40f987b3          	sub	a5,s3,a5
    80000d5e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	17048493          	addi	s1,s1,368
    80000d64:	fd449de3          	bne	s1,s4,80000d3e <procinit+0x78>
  }
}
    80000d68:	70e2                	ld	ra,56(sp)
    80000d6a:	7442                	ld	s0,48(sp)
    80000d6c:	74a2                	ld	s1,40(sp)
    80000d6e:	7902                	ld	s2,32(sp)
    80000d70:	69e2                	ld	s3,24(sp)
    80000d72:	6a42                	ld	s4,16(sp)
    80000d74:	6aa2                	ld	s5,8(sp)
    80000d76:	6b02                	ld	s6,0(sp)
    80000d78:	6121                	addi	sp,sp,64
    80000d7a:	8082                	ret

0000000080000d7c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d82:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d84:	2501                	sext.w	a0,a0
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret

0000000080000d8c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e422                	sd	s0,8(sp)
    80000d90:	0800                	addi	s0,sp,16
    80000d92:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d94:	2781                	sext.w	a5,a5
    80000d96:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d98:	00009517          	auipc	a0,0x9
    80000d9c:	79850513          	addi	a0,a0,1944 # 8000a530 <cpus>
    80000da0:	953e                	add	a0,a0,a5
    80000da2:	6422                	ld	s0,8(sp)
    80000da4:	0141                	addi	sp,sp,16
    80000da6:	8082                	ret

0000000080000da8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000da8:	1101                	addi	sp,sp,-32
    80000daa:	ec06                	sd	ra,24(sp)
    80000dac:	e822                	sd	s0,16(sp)
    80000dae:	e426                	sd	s1,8(sp)
    80000db0:	1000                	addi	s0,sp,32
  push_off();
    80000db2:	30f040ef          	jal	800058c0 <push_off>
    80000db6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db8:	2781                	sext.w	a5,a5
    80000dba:	079e                	slli	a5,a5,0x7
    80000dbc:	00009717          	auipc	a4,0x9
    80000dc0:	74470713          	addi	a4,a4,1860 # 8000a500 <pid_lock>
    80000dc4:	97ba                	add	a5,a5,a4
    80000dc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc8:	37d040ef          	jal	80005944 <pop_off>
  return p;
}
    80000dcc:	8526                	mv	a0,s1
    80000dce:	60e2                	ld	ra,24(sp)
    80000dd0:	6442                	ld	s0,16(sp)
    80000dd2:	64a2                	ld	s1,8(sp)
    80000dd4:	6105                	addi	sp,sp,32
    80000dd6:	8082                	ret

0000000080000dd8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e406                	sd	ra,8(sp)
    80000ddc:	e022                	sd	s0,0(sp)
    80000dde:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000de0:	fc9ff0ef          	jal	80000da8 <myproc>
    80000de4:	3b5040ef          	jal	80005998 <release>

  if (first) {
    80000de8:	00009797          	auipc	a5,0x9
    80000dec:	6587a783          	lw	a5,1624(a5) # 8000a440 <first.1>
    80000df0:	e799                	bnez	a5,80000dfe <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000df2:	315000ef          	jal	80001906 <usertrapret>
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret
    fsinit(ROOTDEV);
    80000dfe:	4505                	li	a0,1
    80000e00:	798010ef          	jal	80002598 <fsinit>
    first = 0;
    80000e04:	00009797          	auipc	a5,0x9
    80000e08:	6207ae23          	sw	zero,1596(a5) # 8000a440 <first.1>
    __sync_synchronize();
    80000e0c:	0330000f          	fence	rw,rw
    80000e10:	b7cd                	j	80000df2 <forkret+0x1a>

0000000080000e12 <allocpid>:
{
    80000e12:	1101                	addi	sp,sp,-32
    80000e14:	ec06                	sd	ra,24(sp)
    80000e16:	e822                	sd	s0,16(sp)
    80000e18:	e426                	sd	s1,8(sp)
    80000e1a:	e04a                	sd	s2,0(sp)
    80000e1c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e1e:	00009917          	auipc	s2,0x9
    80000e22:	6e290913          	addi	s2,s2,1762 # 8000a500 <pid_lock>
    80000e26:	854a                	mv	a0,s2
    80000e28:	2d9040ef          	jal	80005900 <acquire>
  pid = nextpid;
    80000e2c:	00009797          	auipc	a5,0x9
    80000e30:	61878793          	addi	a5,a5,1560 # 8000a444 <nextpid>
    80000e34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e36:	0014871b          	addiw	a4,s1,1
    80000e3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e3c:	854a                	mv	a0,s2
    80000e3e:	35b040ef          	jal	80005998 <release>
}
    80000e42:	8526                	mv	a0,s1
    80000e44:	60e2                	ld	ra,24(sp)
    80000e46:	6442                	ld	s0,16(sp)
    80000e48:	64a2                	ld	s1,8(sp)
    80000e4a:	6902                	ld	s2,0(sp)
    80000e4c:	6105                	addi	sp,sp,32
    80000e4e:	8082                	ret

0000000080000e50 <proc_pagetable>:
{
    80000e50:	1101                	addi	sp,sp,-32
    80000e52:	ec06                	sd	ra,24(sp)
    80000e54:	e822                	sd	s0,16(sp)
    80000e56:	e426                	sd	s1,8(sp)
    80000e58:	e04a                	sd	s2,0(sp)
    80000e5a:	1000                	addi	s0,sp,32
    80000e5c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e5e:	8e1ff0ef          	jal	8000073e <uvmcreate>
    80000e62:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e64:	cd05                	beqz	a0,80000e9c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e66:	4729                	li	a4,10
    80000e68:	00005697          	auipc	a3,0x5
    80000e6c:	19868693          	addi	a3,a3,408 # 80006000 <_trampoline>
    80000e70:	6605                	lui	a2,0x1
    80000e72:	040005b7          	lui	a1,0x4000
    80000e76:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e78:	05b2                	slli	a1,a1,0xc
    80000e7a:	e62ff0ef          	jal	800004dc <mappages>
    80000e7e:	02054663          	bltz	a0,80000eaa <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e82:	4719                	li	a4,6
    80000e84:	05893683          	ld	a3,88(s2)
    80000e88:	6605                	lui	a2,0x1
    80000e8a:	020005b7          	lui	a1,0x2000
    80000e8e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e90:	05b6                	slli	a1,a1,0xd
    80000e92:	8526                	mv	a0,s1
    80000e94:	e48ff0ef          	jal	800004dc <mappages>
    80000e98:	00054f63          	bltz	a0,80000eb6 <proc_pagetable+0x66>
}
    80000e9c:	8526                	mv	a0,s1
    80000e9e:	60e2                	ld	ra,24(sp)
    80000ea0:	6442                	ld	s0,16(sp)
    80000ea2:	64a2                	ld	s1,8(sp)
    80000ea4:	6902                	ld	s2,0(sp)
    80000ea6:	6105                	addi	sp,sp,32
    80000ea8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eaa:	4581                	li	a1,0
    80000eac:	8526                	mv	a0,s1
    80000eae:	a5fff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000eb2:	4481                	li	s1,0
    80000eb4:	b7e5                	j	80000e9c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eb6:	4681                	li	a3,0
    80000eb8:	4605                	li	a2,1
    80000eba:	040005b7          	lui	a1,0x4000
    80000ebe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ec0:	05b2                	slli	a1,a1,0xc
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	fbeff0ef          	jal	80000682 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ec8:	4581                	li	a1,0
    80000eca:	8526                	mv	a0,s1
    80000ecc:	a41ff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000ed0:	4481                	li	s1,0
    80000ed2:	b7e9                	j	80000e9c <proc_pagetable+0x4c>

0000000080000ed4 <proc_freepagetable>:
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	e04a                	sd	s2,0(sp)
    80000ede:	1000                	addi	s0,sp,32
    80000ee0:	84aa                	mv	s1,a0
    80000ee2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee4:	4681                	li	a3,0
    80000ee6:	4605                	li	a2,1
    80000ee8:	040005b7          	lui	a1,0x4000
    80000eec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eee:	05b2                	slli	a1,a1,0xc
    80000ef0:	f92ff0ef          	jal	80000682 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ef4:	4681                	li	a3,0
    80000ef6:	4605                	li	a2,1
    80000ef8:	020005b7          	lui	a1,0x2000
    80000efc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000efe:	05b6                	slli	a1,a1,0xd
    80000f00:	8526                	mv	a0,s1
    80000f02:	f80ff0ef          	jal	80000682 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f06:	85ca                	mv	a1,s2
    80000f08:	8526                	mv	a0,s1
    80000f0a:	a03ff0ef          	jal	8000090c <uvmfree>
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6902                	ld	s2,0(sp)
    80000f16:	6105                	addi	sp,sp,32
    80000f18:	8082                	ret

0000000080000f1a <freeproc>:
{
    80000f1a:	1101                	addi	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f26:	6d28                	ld	a0,88(a0)
    80000f28:	c119                	beqz	a0,80000f2e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f2a:	8f2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f2e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f32:	68a8                	ld	a0,80(s1)
    80000f34:	c501                	beqz	a0,80000f3c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f36:	64ac                	ld	a1,72(s1)
    80000f38:	f9dff0ef          	jal	80000ed4 <proc_freepagetable>
  p->pagetable = 0;
    80000f3c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f40:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f44:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f48:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f4c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f50:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f54:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f58:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f5c:	0004ac23          	sw	zero,24(s1)
}
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6105                	addi	sp,sp,32
    80000f68:	8082                	ret

0000000080000f6a <allocproc>:
{
    80000f6a:	1101                	addi	sp,sp,-32
    80000f6c:	ec06                	sd	ra,24(sp)
    80000f6e:	e822                	sd	s0,16(sp)
    80000f70:	e426                	sd	s1,8(sp)
    80000f72:	e04a                	sd	s2,0(sp)
    80000f74:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f76:	0000a497          	auipc	s1,0xa
    80000f7a:	9ba48493          	addi	s1,s1,-1606 # 8000a930 <proc>
    80000f7e:	0000f917          	auipc	s2,0xf
    80000f82:	5b290913          	addi	s2,s2,1458 # 80010530 <tickslock>
    acquire(&p->lock);
    80000f86:	8526                	mv	a0,s1
    80000f88:	179040ef          	jal	80005900 <acquire>
    if(p->state == UNUSED) {
    80000f8c:	4c9c                	lw	a5,24(s1)
    80000f8e:	cb91                	beqz	a5,80000fa2 <allocproc+0x38>
      release(&p->lock);
    80000f90:	8526                	mv	a0,s1
    80000f92:	207040ef          	jal	80005998 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f96:	17048493          	addi	s1,s1,368
    80000f9a:	ff2496e3          	bne	s1,s2,80000f86 <allocproc+0x1c>
  return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	a089                	j	80000fe2 <allocproc+0x78>
  p->pid = allocpid();
    80000fa2:	e71ff0ef          	jal	80000e12 <allocpid>
    80000fa6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fa8:	4785                	li	a5,1
    80000faa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fac:	952ff0ef          	jal	800000fe <kalloc>
    80000fb0:	892a                	mv	s2,a0
    80000fb2:	eca8                	sd	a0,88(s1)
    80000fb4:	cd15                	beqz	a0,80000ff0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	e99ff0ef          	jal	80000e50 <proc_pagetable>
    80000fbc:	892a                	mv	s2,a0
    80000fbe:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fc0:	c121                	beqz	a0,80001000 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fc2:	07000613          	li	a2,112
    80000fc6:	4581                	li	a1,0
    80000fc8:	06048513          	addi	a0,s1,96
    80000fcc:	9c4ff0ef          	jal	80000190 <memset>
  p->context.ra = (uint64)forkret;
    80000fd0:	00000797          	auipc	a5,0x0
    80000fd4:	e0878793          	addi	a5,a5,-504 # 80000dd8 <forkret>
    80000fd8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fda:	60bc                	ld	a5,64(s1)
    80000fdc:	6705                	lui	a4,0x1
    80000fde:	97ba                	add	a5,a5,a4
    80000fe0:	f4bc                	sd	a5,104(s1)
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    freeproc(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	f29ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	1a1040ef          	jal	80005998 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	b7d5                	j	80000fe2 <allocproc+0x78>
    freeproc(p);
    80001000:	8526                	mv	a0,s1
    80001002:	f19ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80001006:	8526                	mv	a0,s1
    80001008:	191040ef          	jal	80005998 <release>
    return 0;
    8000100c:	84ca                	mv	s1,s2
    8000100e:	bfd1                	j	80000fe2 <allocproc+0x78>

0000000080001010 <userinit>:
{
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	1000                	addi	s0,sp,32
  p = allocproc();
    8000101a:	f51ff0ef          	jal	80000f6a <allocproc>
    8000101e:	84aa                	mv	s1,a0
  initproc = p;
    80001020:	00009797          	auipc	a5,0x9
    80001024:	4aa7b023          	sd	a0,1184(a5) # 8000a4c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001028:	03400613          	li	a2,52
    8000102c:	00009597          	auipc	a1,0x9
    80001030:	42458593          	addi	a1,a1,1060 # 8000a450 <initcode>
    80001034:	6928                	ld	a0,80(a0)
    80001036:	f2eff0ef          	jal	80000764 <uvmfirst>
  p->sz = PGSIZE;
    8000103a:	6785                	lui	a5,0x1
    8000103c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000103e:	6cb8                	ld	a4,88(s1)
    80001040:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001044:	6cb8                	ld	a4,88(s1)
    80001046:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001048:	4641                	li	a2,16
    8000104a:	00006597          	auipc	a1,0x6
    8000104e:	17658593          	addi	a1,a1,374 # 800071c0 <etext+0x1c0>
    80001052:	15848513          	addi	a0,s1,344
    80001056:	a78ff0ef          	jal	800002ce <safestrcpy>
  p->cwd = namei("/");
    8000105a:	00006517          	auipc	a0,0x6
    8000105e:	17650513          	addi	a0,a0,374 # 800071d0 <etext+0x1d0>
    80001062:	645010ef          	jal	80002ea6 <namei>
    80001066:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000106a:	478d                	li	a5,3
    8000106c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	129040ef          	jal	80005998 <release>
}
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret

000000008000107e <growproc>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	e04a                	sd	s2,0(sp)
    80001088:	1000                	addi	s0,sp,32
    8000108a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108c:	d1dff0ef          	jal	80000da8 <myproc>
    80001090:	84aa                	mv	s1,a0
  sz = p->sz;
    80001092:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001094:	01204c63          	bgtz	s2,800010ac <growproc+0x2e>
  } else if(n < 0){
    80001098:	02094463          	bltz	s2,800010c0 <growproc+0x42>
  p->sz = sz;
    8000109c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000109e:	4501                	li	a0,0
}
    800010a0:	60e2                	ld	ra,24(sp)
    800010a2:	6442                	ld	s0,16(sp)
    800010a4:	64a2                	ld	s1,8(sp)
    800010a6:	6902                	ld	s2,0(sp)
    800010a8:	6105                	addi	sp,sp,32
    800010aa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010ac:	4691                	li	a3,4
    800010ae:	00b90633          	add	a2,s2,a1
    800010b2:	6928                	ld	a0,80(a0)
    800010b4:	f52ff0ef          	jal	80000806 <uvmalloc>
    800010b8:	85aa                	mv	a1,a0
    800010ba:	f16d                	bnez	a0,8000109c <growproc+0x1e>
      return -1;
    800010bc:	557d                	li	a0,-1
    800010be:	b7cd                	j	800010a0 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c0:	00b90633          	add	a2,s2,a1
    800010c4:	6928                	ld	a0,80(a0)
    800010c6:	efcff0ef          	jal	800007c2 <uvmdealloc>
    800010ca:	85aa                	mv	a1,a0
    800010cc:	bfc1                	j	8000109c <growproc+0x1e>

00000000800010ce <fork>:
{
    800010ce:	7139                	addi	sp,sp,-64
    800010d0:	fc06                	sd	ra,56(sp)
    800010d2:	f822                	sd	s0,48(sp)
    800010d4:	f04a                	sd	s2,32(sp)
    800010d6:	e456                	sd	s5,8(sp)
    800010d8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010da:	ccfff0ef          	jal	80000da8 <myproc>
    800010de:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e0:	e8bff0ef          	jal	80000f6a <allocproc>
    800010e4:	0e050e63          	beqz	a0,800011e0 <fork+0x112>
    800010e8:	ec4e                	sd	s3,24(sp)
    800010ea:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ec:	048ab603          	ld	a2,72(s5)
    800010f0:	692c                	ld	a1,80(a0)
    800010f2:	050ab503          	ld	a0,80(s5)
    800010f6:	849ff0ef          	jal	8000093e <uvmcopy>
    800010fa:	04054e63          	bltz	a0,80001156 <fork+0x88>
    800010fe:	f426                	sd	s1,40(sp)
    80001100:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001102:	048ab783          	ld	a5,72(s5)
    80001106:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000110a:	058ab683          	ld	a3,88(s5)
    8000110e:	87b6                	mv	a5,a3
    80001110:	0589b703          	ld	a4,88(s3)
    80001114:	12068693          	addi	a3,a3,288
    80001118:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000111c:	6788                	ld	a0,8(a5)
    8000111e:	6b8c                	ld	a1,16(a5)
    80001120:	6f90                	ld	a2,24(a5)
    80001122:	01073023          	sd	a6,0(a4)
    80001126:	e708                	sd	a0,8(a4)
    80001128:	eb0c                	sd	a1,16(a4)
    8000112a:	ef10                	sd	a2,24(a4)
    8000112c:	02078793          	addi	a5,a5,32
    80001130:	02070713          	addi	a4,a4,32
    80001134:	fed792e3          	bne	a5,a3,80001118 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001138:	0589b783          	ld	a5,88(s3)
    8000113c:	0607b823          	sd	zero,112(a5)
  np->trace_mask = p->trace_mask;
    80001140:	168aa783          	lw	a5,360(s5)
    80001144:	16f9a423          	sw	a5,360(s3)
  for(i = 0; i < NOFILE; i++)
    80001148:	0d0a8493          	addi	s1,s5,208
    8000114c:	0d098913          	addi	s2,s3,208
    80001150:	150a8a13          	addi	s4,s5,336
    80001154:	a831                	j	80001170 <fork+0xa2>
    freeproc(np);
    80001156:	854e                	mv	a0,s3
    80001158:	dc3ff0ef          	jal	80000f1a <freeproc>
    release(&np->lock);
    8000115c:	854e                	mv	a0,s3
    8000115e:	03b040ef          	jal	80005998 <release>
    return -1;
    80001162:	597d                	li	s2,-1
    80001164:	69e2                	ld	s3,24(sp)
    80001166:	a0b5                	j	800011d2 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001168:	04a1                	addi	s1,s1,8
    8000116a:	0921                	addi	s2,s2,8
    8000116c:	01448963          	beq	s1,s4,8000117e <fork+0xb0>
    if(p->ofile[i])
    80001170:	6088                	ld	a0,0(s1)
    80001172:	d97d                	beqz	a0,80001168 <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001174:	2c2020ef          	jal	80003436 <filedup>
    80001178:	00a93023          	sd	a0,0(s2)
    8000117c:	b7f5                	j	80001168 <fork+0x9a>
  np->cwd = idup(p->cwd);
    8000117e:	150ab503          	ld	a0,336(s5)
    80001182:	614010ef          	jal	80002796 <idup>
    80001186:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000118a:	4641                	li	a2,16
    8000118c:	158a8593          	addi	a1,s5,344
    80001190:	15898513          	addi	a0,s3,344
    80001194:	93aff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    80001198:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000119c:	854e                	mv	a0,s3
    8000119e:	7fa040ef          	jal	80005998 <release>
  acquire(&wait_lock);
    800011a2:	00009497          	auipc	s1,0x9
    800011a6:	37648493          	addi	s1,s1,886 # 8000a518 <wait_lock>
    800011aa:	8526                	mv	a0,s1
    800011ac:	754040ef          	jal	80005900 <acquire>
  np->parent = p;
    800011b0:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	7e2040ef          	jal	80005998 <release>
  acquire(&np->lock);
    800011ba:	854e                	mv	a0,s3
    800011bc:	744040ef          	jal	80005900 <acquire>
  np->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011c6:	854e                	mv	a0,s3
    800011c8:	7d0040ef          	jal	80005998 <release>
  return pid;
    800011cc:	74a2                	ld	s1,40(sp)
    800011ce:	69e2                	ld	s3,24(sp)
    800011d0:	6a42                	ld	s4,16(sp)
}
    800011d2:	854a                	mv	a0,s2
    800011d4:	70e2                	ld	ra,56(sp)
    800011d6:	7442                	ld	s0,48(sp)
    800011d8:	7902                	ld	s2,32(sp)
    800011da:	6aa2                	ld	s5,8(sp)
    800011dc:	6121                	addi	sp,sp,64
    800011de:	8082                	ret
    return -1;
    800011e0:	597d                	li	s2,-1
    800011e2:	bfc5                	j	800011d2 <fork+0x104>

00000000800011e4 <scheduler>:
{
    800011e4:	715d                	addi	sp,sp,-80
    800011e6:	e486                	sd	ra,72(sp)
    800011e8:	e0a2                	sd	s0,64(sp)
    800011ea:	fc26                	sd	s1,56(sp)
    800011ec:	f84a                	sd	s2,48(sp)
    800011ee:	f44e                	sd	s3,40(sp)
    800011f0:	f052                	sd	s4,32(sp)
    800011f2:	ec56                	sd	s5,24(sp)
    800011f4:	e85a                	sd	s6,16(sp)
    800011f6:	e45e                	sd	s7,8(sp)
    800011f8:	e062                	sd	s8,0(sp)
    800011fa:	0880                	addi	s0,sp,80
    800011fc:	8792                	mv	a5,tp
  int id = r_tp();
    800011fe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001200:	00779b13          	slli	s6,a5,0x7
    80001204:	00009717          	auipc	a4,0x9
    80001208:	2fc70713          	addi	a4,a4,764 # 8000a500 <pid_lock>
    8000120c:	975a                	add	a4,a4,s6
    8000120e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001212:	00009717          	auipc	a4,0x9
    80001216:	32670713          	addi	a4,a4,806 # 8000a538 <cpus+0x8>
    8000121a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000121c:	4c11                	li	s8,4
        c->proc = p;
    8000121e:	079e                	slli	a5,a5,0x7
    80001220:	00009a17          	auipc	s4,0x9
    80001224:	2e0a0a13          	addi	s4,s4,736 # 8000a500 <pid_lock>
    80001228:	9a3e                	add	s4,s4,a5
        found = 1;
    8000122a:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000122c:	0000f997          	auipc	s3,0xf
    80001230:	30498993          	addi	s3,s3,772 # 80010530 <tickslock>
    80001234:	a0a9                	j	8000127e <scheduler+0x9a>
      release(&p->lock);
    80001236:	8526                	mv	a0,s1
    80001238:	760040ef          	jal	80005998 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123c:	17048493          	addi	s1,s1,368
    80001240:	03348563          	beq	s1,s3,8000126a <scheduler+0x86>
      acquire(&p->lock);
    80001244:	8526                	mv	a0,s1
    80001246:	6ba040ef          	jal	80005900 <acquire>
      if(p->state == RUNNABLE) {
    8000124a:	4c9c                	lw	a5,24(s1)
    8000124c:	ff2795e3          	bne	a5,s2,80001236 <scheduler+0x52>
        p->state = RUNNING;
    80001250:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001254:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001258:	06048593          	addi	a1,s1,96
    8000125c:	855a                	mv	a0,s6
    8000125e:	602000ef          	jal	80001860 <swtch>
        c->proc = 0;
    80001262:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001266:	8ade                	mv	s5,s7
    80001268:	b7f9                	j	80001236 <scheduler+0x52>
    if(found == 0) {
    8000126a:	000a9a63          	bnez	s5,8000127e <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000126e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001272:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001276:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000127a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001286:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000128a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000128c:	00009497          	auipc	s1,0x9
    80001290:	6a448493          	addi	s1,s1,1700 # 8000a930 <proc>
      if(p->state == RUNNABLE) {
    80001294:	490d                	li	s2,3
    80001296:	b77d                	j	80001244 <scheduler+0x60>

0000000080001298 <sched>:
{
    80001298:	7179                	addi	sp,sp,-48
    8000129a:	f406                	sd	ra,40(sp)
    8000129c:	f022                	sd	s0,32(sp)
    8000129e:	ec26                	sd	s1,24(sp)
    800012a0:	e84a                	sd	s2,16(sp)
    800012a2:	e44e                	sd	s3,8(sp)
    800012a4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012a6:	b03ff0ef          	jal	80000da8 <myproc>
    800012aa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012ac:	5ea040ef          	jal	80005896 <holding>
    800012b0:	c92d                	beqz	a0,80001322 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012b2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012b4:	2781                	sext.w	a5,a5
    800012b6:	079e                	slli	a5,a5,0x7
    800012b8:	00009717          	auipc	a4,0x9
    800012bc:	24870713          	addi	a4,a4,584 # 8000a500 <pid_lock>
    800012c0:	97ba                	add	a5,a5,a4
    800012c2:	0a87a703          	lw	a4,168(a5)
    800012c6:	4785                	li	a5,1
    800012c8:	06f71363          	bne	a4,a5,8000132e <sched+0x96>
  if(p->state == RUNNING)
    800012cc:	4c98                	lw	a4,24(s1)
    800012ce:	4791                	li	a5,4
    800012d0:	06f70563          	beq	a4,a5,8000133a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012da:	e7b5                	bnez	a5,80001346 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012dc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012de:	00009917          	auipc	s2,0x9
    800012e2:	22290913          	addi	s2,s2,546 # 8000a500 <pid_lock>
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	97ca                	add	a5,a5,s2
    800012ec:	0ac7a983          	lw	s3,172(a5)
    800012f0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	00009597          	auipc	a1,0x9
    800012fa:	24258593          	addi	a1,a1,578 # 8000a538 <cpus+0x8>
    800012fe:	95be                	add	a1,a1,a5
    80001300:	06048513          	addi	a0,s1,96
    80001304:	55c000ef          	jal	80001860 <swtch>
    80001308:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000130a:	2781                	sext.w	a5,a5
    8000130c:	079e                	slli	a5,a5,0x7
    8000130e:	993e                	add	s2,s2,a5
    80001310:	0b392623          	sw	s3,172(s2)
}
    80001314:	70a2                	ld	ra,40(sp)
    80001316:	7402                	ld	s0,32(sp)
    80001318:	64e2                	ld	s1,24(sp)
    8000131a:	6942                	ld	s2,16(sp)
    8000131c:	69a2                	ld	s3,8(sp)
    8000131e:	6145                	addi	sp,sp,48
    80001320:	8082                	ret
    panic("sched p->lock");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	eb650513          	addi	a0,a0,-330 # 800071d8 <etext+0x1d8>
    8000132a:	2a8040ef          	jal	800055d2 <panic>
    panic("sched locks");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eba50513          	addi	a0,a0,-326 # 800071e8 <etext+0x1e8>
    80001336:	29c040ef          	jal	800055d2 <panic>
    panic("sched running");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	ebe50513          	addi	a0,a0,-322 # 800071f8 <etext+0x1f8>
    80001342:	290040ef          	jal	800055d2 <panic>
    panic("sched interruptible");
    80001346:	00006517          	auipc	a0,0x6
    8000134a:	ec250513          	addi	a0,a0,-318 # 80007208 <etext+0x208>
    8000134e:	284040ef          	jal	800055d2 <panic>

0000000080001352 <yield>:
{
    80001352:	1101                	addi	sp,sp,-32
    80001354:	ec06                	sd	ra,24(sp)
    80001356:	e822                	sd	s0,16(sp)
    80001358:	e426                	sd	s1,8(sp)
    8000135a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000135c:	a4dff0ef          	jal	80000da8 <myproc>
    80001360:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001362:	59e040ef          	jal	80005900 <acquire>
  p->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	cc9c                	sw	a5,24(s1)
  sched();
    8000136a:	f2fff0ef          	jal	80001298 <sched>
  release(&p->lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	628040ef          	jal	80005998 <release>
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000137e:	7179                	addi	sp,sp,-48
    80001380:	f406                	sd	ra,40(sp)
    80001382:	f022                	sd	s0,32(sp)
    80001384:	ec26                	sd	s1,24(sp)
    80001386:	e84a                	sd	s2,16(sp)
    80001388:	e44e                	sd	s3,8(sp)
    8000138a:	1800                	addi	s0,sp,48
    8000138c:	89aa                	mv	s3,a0
    8000138e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001390:	a19ff0ef          	jal	80000da8 <myproc>
    80001394:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001396:	56a040ef          	jal	80005900 <acquire>
  release(lk);
    8000139a:	854a                	mv	a0,s2
    8000139c:	5fc040ef          	jal	80005998 <release>

  // Go to sleep.
  p->chan = chan;
    800013a0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013a4:	4789                	li	a5,2
    800013a6:	cc9c                	sw	a5,24(s1)

  sched();
    800013a8:	ef1ff0ef          	jal	80001298 <sched>

  // Tidy up.
  p->chan = 0;
    800013ac:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	5e6040ef          	jal	80005998 <release>
  acquire(lk);
    800013b6:	854a                	mv	a0,s2
    800013b8:	548040ef          	jal	80005900 <acquire>
}
    800013bc:	70a2                	ld	ra,40(sp)
    800013be:	7402                	ld	s0,32(sp)
    800013c0:	64e2                	ld	s1,24(sp)
    800013c2:	6942                	ld	s2,16(sp)
    800013c4:	69a2                	ld	s3,8(sp)
    800013c6:	6145                	addi	sp,sp,48
    800013c8:	8082                	ret

00000000800013ca <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013ca:	7139                	addi	sp,sp,-64
    800013cc:	fc06                	sd	ra,56(sp)
    800013ce:	f822                	sd	s0,48(sp)
    800013d0:	f426                	sd	s1,40(sp)
    800013d2:	f04a                	sd	s2,32(sp)
    800013d4:	ec4e                	sd	s3,24(sp)
    800013d6:	e852                	sd	s4,16(sp)
    800013d8:	e456                	sd	s5,8(sp)
    800013da:	0080                	addi	s0,sp,64
    800013dc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	00009497          	auipc	s1,0x9
    800013e2:	55248493          	addi	s1,s1,1362 # 8000a930 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013e6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013e8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000f917          	auipc	s2,0xf
    800013ee:	14690913          	addi	s2,s2,326 # 80010530 <tickslock>
    800013f2:	a801                	j	80001402 <wakeup+0x38>
      }
      release(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	5a2040ef          	jal	80005998 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	17048493          	addi	s1,s1,368
    800013fe:	03248263          	beq	s1,s2,80001422 <wakeup+0x58>
    if(p != myproc()){
    80001402:	9a7ff0ef          	jal	80000da8 <myproc>
    80001406:	fea48ae3          	beq	s1,a0,800013fa <wakeup+0x30>
      acquire(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	4f4040ef          	jal	80005900 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001410:	4c9c                	lw	a5,24(s1)
    80001412:	ff3791e3          	bne	a5,s3,800013f4 <wakeup+0x2a>
    80001416:	709c                	ld	a5,32(s1)
    80001418:	fd479ee3          	bne	a5,s4,800013f4 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000141c:	0154ac23          	sw	s5,24(s1)
    80001420:	bfd1                	j	800013f4 <wakeup+0x2a>
    }
  }
}
    80001422:	70e2                	ld	ra,56(sp)
    80001424:	7442                	ld	s0,48(sp)
    80001426:	74a2                	ld	s1,40(sp)
    80001428:	7902                	ld	s2,32(sp)
    8000142a:	69e2                	ld	s3,24(sp)
    8000142c:	6a42                	ld	s4,16(sp)
    8000142e:	6aa2                	ld	s5,8(sp)
    80001430:	6121                	addi	sp,sp,64
    80001432:	8082                	ret

0000000080001434 <reparent>:
{
    80001434:	7179                	addi	sp,sp,-48
    80001436:	f406                	sd	ra,40(sp)
    80001438:	f022                	sd	s0,32(sp)
    8000143a:	ec26                	sd	s1,24(sp)
    8000143c:	e84a                	sd	s2,16(sp)
    8000143e:	e44e                	sd	s3,8(sp)
    80001440:	e052                	sd	s4,0(sp)
    80001442:	1800                	addi	s0,sp,48
    80001444:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001446:	00009497          	auipc	s1,0x9
    8000144a:	4ea48493          	addi	s1,s1,1258 # 8000a930 <proc>
      pp->parent = initproc;
    8000144e:	00009a17          	auipc	s4,0x9
    80001452:	072a0a13          	addi	s4,s4,114 # 8000a4c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001456:	0000f997          	auipc	s3,0xf
    8000145a:	0da98993          	addi	s3,s3,218 # 80010530 <tickslock>
    8000145e:	a029                	j	80001468 <reparent+0x34>
    80001460:	17048493          	addi	s1,s1,368
    80001464:	01348b63          	beq	s1,s3,8000147a <reparent+0x46>
    if(pp->parent == p){
    80001468:	7c9c                	ld	a5,56(s1)
    8000146a:	ff279be3          	bne	a5,s2,80001460 <reparent+0x2c>
      pp->parent = initproc;
    8000146e:	000a3503          	ld	a0,0(s4)
    80001472:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001474:	f57ff0ef          	jal	800013ca <wakeup>
    80001478:	b7e5                	j	80001460 <reparent+0x2c>
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6a02                	ld	s4,0(sp)
    80001486:	6145                	addi	sp,sp,48
    80001488:	8082                	ret

000000008000148a <exit>:
{
    8000148a:	7179                	addi	sp,sp,-48
    8000148c:	f406                	sd	ra,40(sp)
    8000148e:	f022                	sd	s0,32(sp)
    80001490:	ec26                	sd	s1,24(sp)
    80001492:	e84a                	sd	s2,16(sp)
    80001494:	e44e                	sd	s3,8(sp)
    80001496:	e052                	sd	s4,0(sp)
    80001498:	1800                	addi	s0,sp,48
    8000149a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000149c:	90dff0ef          	jal	80000da8 <myproc>
    800014a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800014a2:	00009797          	auipc	a5,0x9
    800014a6:	01e7b783          	ld	a5,30(a5) # 8000a4c0 <initproc>
    800014aa:	0d050493          	addi	s1,a0,208
    800014ae:	15050913          	addi	s2,a0,336
    800014b2:	00a79f63          	bne	a5,a0,800014d0 <exit+0x46>
    panic("init exiting");
    800014b6:	00006517          	auipc	a0,0x6
    800014ba:	d6a50513          	addi	a0,a0,-662 # 80007220 <etext+0x220>
    800014be:	114040ef          	jal	800055d2 <panic>
      fileclose(f);
    800014c2:	7bb010ef          	jal	8000347c <fileclose>
      p->ofile[fd] = 0;
    800014c6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014ca:	04a1                	addi	s1,s1,8
    800014cc:	01248563          	beq	s1,s2,800014d6 <exit+0x4c>
    if(p->ofile[fd]){
    800014d0:	6088                	ld	a0,0(s1)
    800014d2:	f965                	bnez	a0,800014c2 <exit+0x38>
    800014d4:	bfdd                	j	800014ca <exit+0x40>
  begin_op();
    800014d6:	38d010ef          	jal	80003062 <begin_op>
  iput(p->cwd);
    800014da:	1509b503          	ld	a0,336(s3)
    800014de:	470010ef          	jal	8000294e <iput>
  end_op();
    800014e2:	3eb010ef          	jal	800030cc <end_op>
  p->cwd = 0;
    800014e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014ea:	00009497          	auipc	s1,0x9
    800014ee:	02e48493          	addi	s1,s1,46 # 8000a518 <wait_lock>
    800014f2:	8526                	mv	a0,s1
    800014f4:	40c040ef          	jal	80005900 <acquire>
  reparent(p);
    800014f8:	854e                	mv	a0,s3
    800014fa:	f3bff0ef          	jal	80001434 <reparent>
  wakeup(p->parent);
    800014fe:	0389b503          	ld	a0,56(s3)
    80001502:	ec9ff0ef          	jal	800013ca <wakeup>
  acquire(&p->lock);
    80001506:	854e                	mv	a0,s3
    80001508:	3f8040ef          	jal	80005900 <acquire>
  p->xstate = status;
    8000150c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001510:	4795                	li	a5,5
    80001512:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001516:	8526                	mv	a0,s1
    80001518:	480040ef          	jal	80005998 <release>
  sched();
    8000151c:	d7dff0ef          	jal	80001298 <sched>
  panic("zombie exit");
    80001520:	00006517          	auipc	a0,0x6
    80001524:	d1050513          	addi	a0,a0,-752 # 80007230 <etext+0x230>
    80001528:	0aa040ef          	jal	800055d2 <panic>

000000008000152c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000152c:	7179                	addi	sp,sp,-48
    8000152e:	f406                	sd	ra,40(sp)
    80001530:	f022                	sd	s0,32(sp)
    80001532:	ec26                	sd	s1,24(sp)
    80001534:	e84a                	sd	s2,16(sp)
    80001536:	e44e                	sd	s3,8(sp)
    80001538:	1800                	addi	s0,sp,48
    8000153a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000153c:	00009497          	auipc	s1,0x9
    80001540:	3f448493          	addi	s1,s1,1012 # 8000a930 <proc>
    80001544:	0000f997          	auipc	s3,0xf
    80001548:	fec98993          	addi	s3,s3,-20 # 80010530 <tickslock>
    acquire(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	3b2040ef          	jal	80005900 <acquire>
    if(p->pid == pid){
    80001552:	589c                	lw	a5,48(s1)
    80001554:	01278b63          	beq	a5,s2,8000156a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	43e040ef          	jal	80005998 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000155e:	17048493          	addi	s1,s1,368
    80001562:	ff3495e3          	bne	s1,s3,8000154c <kill+0x20>
  }
  return -1;
    80001566:	557d                	li	a0,-1
    80001568:	a819                	j	8000157e <kill+0x52>
      p->killed = 1;
    8000156a:	4785                	li	a5,1
    8000156c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000156e:	4c98                	lw	a4,24(s1)
    80001570:	4789                	li	a5,2
    80001572:	00f70d63          	beq	a4,a5,8000158c <kill+0x60>
      release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	420040ef          	jal	80005998 <release>
      return 0;
    8000157c:	4501                	li	a0,0
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6145                	addi	sp,sp,48
    8000158a:	8082                	ret
        p->state = RUNNABLE;
    8000158c:	478d                	li	a5,3
    8000158e:	cc9c                	sw	a5,24(s1)
    80001590:	b7dd                	j	80001576 <kill+0x4a>

0000000080001592 <setkilled>:

void
setkilled(struct proc *p)
{
    80001592:	1101                	addi	sp,sp,-32
    80001594:	ec06                	sd	ra,24(sp)
    80001596:	e822                	sd	s0,16(sp)
    80001598:	e426                	sd	s1,8(sp)
    8000159a:	1000                	addi	s0,sp,32
    8000159c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000159e:	362040ef          	jal	80005900 <acquire>
  p->killed = 1;
    800015a2:	4785                	li	a5,1
    800015a4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	3f0040ef          	jal	80005998 <release>
}
    800015ac:	60e2                	ld	ra,24(sp)
    800015ae:	6442                	ld	s0,16(sp)
    800015b0:	64a2                	ld	s1,8(sp)
    800015b2:	6105                	addi	sp,sp,32
    800015b4:	8082                	ret

00000000800015b6 <killed>:

int
killed(struct proc *p)
{
    800015b6:	1101                	addi	sp,sp,-32
    800015b8:	ec06                	sd	ra,24(sp)
    800015ba:	e822                	sd	s0,16(sp)
    800015bc:	e426                	sd	s1,8(sp)
    800015be:	e04a                	sd	s2,0(sp)
    800015c0:	1000                	addi	s0,sp,32
    800015c2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015c4:	33c040ef          	jal	80005900 <acquire>
  k = p->killed;
    800015c8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015cc:	8526                	mv	a0,s1
    800015ce:	3ca040ef          	jal	80005998 <release>
  return k;
}
    800015d2:	854a                	mv	a0,s2
    800015d4:	60e2                	ld	ra,24(sp)
    800015d6:	6442                	ld	s0,16(sp)
    800015d8:	64a2                	ld	s1,8(sp)
    800015da:	6902                	ld	s2,0(sp)
    800015dc:	6105                	addi	sp,sp,32
    800015de:	8082                	ret

00000000800015e0 <wait>:
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	e062                	sd	s8,0(sp)
    800015f6:	0880                	addi	s0,sp,80
    800015f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015fa:	faeff0ef          	jal	80000da8 <myproc>
    800015fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001600:	00009517          	auipc	a0,0x9
    80001604:	f1850513          	addi	a0,a0,-232 # 8000a518 <wait_lock>
    80001608:	2f8040ef          	jal	80005900 <acquire>
    havekids = 0;
    8000160c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000160e:	4a15                	li	s4,5
        havekids = 1;
    80001610:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001612:	0000f997          	auipc	s3,0xf
    80001616:	f1e98993          	addi	s3,s3,-226 # 80010530 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000161a:	00009c17          	auipc	s8,0x9
    8000161e:	efec0c13          	addi	s8,s8,-258 # 8000a518 <wait_lock>
    80001622:	a871                	j	800016be <wait+0xde>
          pid = pp->pid;
    80001624:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001628:	000b0c63          	beqz	s6,80001640 <wait+0x60>
    8000162c:	4691                	li	a3,4
    8000162e:	02c48613          	addi	a2,s1,44
    80001632:	85da                	mv	a1,s6
    80001634:	05093503          	ld	a0,80(s2)
    80001638:	be2ff0ef          	jal	80000a1a <copyout>
    8000163c:	02054b63          	bltz	a0,80001672 <wait+0x92>
          freeproc(pp);
    80001640:	8526                	mv	a0,s1
    80001642:	8d9ff0ef          	jal	80000f1a <freeproc>
          release(&pp->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	350040ef          	jal	80005998 <release>
          release(&wait_lock);
    8000164c:	00009517          	auipc	a0,0x9
    80001650:	ecc50513          	addi	a0,a0,-308 # 8000a518 <wait_lock>
    80001654:	344040ef          	jal	80005998 <release>
}
    80001658:	854e                	mv	a0,s3
    8000165a:	60a6                	ld	ra,72(sp)
    8000165c:	6406                	ld	s0,64(sp)
    8000165e:	74e2                	ld	s1,56(sp)
    80001660:	7942                	ld	s2,48(sp)
    80001662:	79a2                	ld	s3,40(sp)
    80001664:	7a02                	ld	s4,32(sp)
    80001666:	6ae2                	ld	s5,24(sp)
    80001668:	6b42                	ld	s6,16(sp)
    8000166a:	6ba2                	ld	s7,8(sp)
    8000166c:	6c02                	ld	s8,0(sp)
    8000166e:	6161                	addi	sp,sp,80
    80001670:	8082                	ret
            release(&pp->lock);
    80001672:	8526                	mv	a0,s1
    80001674:	324040ef          	jal	80005998 <release>
            release(&wait_lock);
    80001678:	00009517          	auipc	a0,0x9
    8000167c:	ea050513          	addi	a0,a0,-352 # 8000a518 <wait_lock>
    80001680:	318040ef          	jal	80005998 <release>
            return -1;
    80001684:	59fd                	li	s3,-1
    80001686:	bfc9                	j	80001658 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001688:	17048493          	addi	s1,s1,368
    8000168c:	03348063          	beq	s1,s3,800016ac <wait+0xcc>
      if(pp->parent == p){
    80001690:	7c9c                	ld	a5,56(s1)
    80001692:	ff279be3          	bne	a5,s2,80001688 <wait+0xa8>
        acquire(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	268040ef          	jal	80005900 <acquire>
        if(pp->state == ZOMBIE){
    8000169c:	4c9c                	lw	a5,24(s1)
    8000169e:	f94783e3          	beq	a5,s4,80001624 <wait+0x44>
        release(&pp->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	2f4040ef          	jal	80005998 <release>
        havekids = 1;
    800016a8:	8756                	mv	a4,s5
    800016aa:	bff9                	j	80001688 <wait+0xa8>
    if(!havekids || killed(p)){
    800016ac:	cf19                	beqz	a4,800016ca <wait+0xea>
    800016ae:	854a                	mv	a0,s2
    800016b0:	f07ff0ef          	jal	800015b6 <killed>
    800016b4:	e919                	bnez	a0,800016ca <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b6:	85e2                	mv	a1,s8
    800016b8:	854a                	mv	a0,s2
    800016ba:	cc5ff0ef          	jal	8000137e <sleep>
    havekids = 0;
    800016be:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c0:	00009497          	auipc	s1,0x9
    800016c4:	27048493          	addi	s1,s1,624 # 8000a930 <proc>
    800016c8:	b7e1                	j	80001690 <wait+0xb0>
      release(&wait_lock);
    800016ca:	00009517          	auipc	a0,0x9
    800016ce:	e4e50513          	addi	a0,a0,-434 # 8000a518 <wait_lock>
    800016d2:	2c6040ef          	jal	80005998 <release>
      return -1;
    800016d6:	59fd                	li	s3,-1
    800016d8:	b741                	j	80001658 <wait+0x78>

00000000800016da <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	84aa                	mv	s1,a0
    800016ec:	892e                	mv	s2,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	eb6ff0ef          	jal	80000da8 <myproc>
  if(user_dst){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	b1aff0ef          	jal	80000a1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove((char *)dst, src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	ad1fe0ef          	jal	800001ec <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyout+0x2a>

0000000080001724 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001724:	7179                	addi	sp,sp,-48
    80001726:	f406                	sd	ra,40(sp)
    80001728:	f022                	sd	s0,32(sp)
    8000172a:	ec26                	sd	s1,24(sp)
    8000172c:	e84a                	sd	s2,16(sp)
    8000172e:	e44e                	sd	s3,8(sp)
    80001730:	e052                	sd	s4,0(sp)
    80001732:	1800                	addi	s0,sp,48
    80001734:	892a                	mv	s2,a0
    80001736:	84ae                	mv	s1,a1
    80001738:	89b2                	mv	s3,a2
    8000173a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000173c:	e6cff0ef          	jal	80000da8 <myproc>
  if(user_src){
    80001740:	cc99                	beqz	s1,8000175e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001742:	86d2                	mv	a3,s4
    80001744:	864e                	mv	a2,s3
    80001746:	85ca                	mv	a1,s2
    80001748:	6928                	ld	a0,80(a0)
    8000174a:	ba6ff0ef          	jal	80000af0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000174e:	70a2                	ld	ra,40(sp)
    80001750:	7402                	ld	s0,32(sp)
    80001752:	64e2                	ld	s1,24(sp)
    80001754:	6942                	ld	s2,16(sp)
    80001756:	69a2                	ld	s3,8(sp)
    80001758:	6a02                	ld	s4,0(sp)
    8000175a:	6145                	addi	sp,sp,48
    8000175c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000175e:	000a061b          	sext.w	a2,s4
    80001762:	85ce                	mv	a1,s3
    80001764:	854a                	mv	a0,s2
    80001766:	a87fe0ef          	jal	800001ec <memmove>
    return 0;
    8000176a:	8526                	mv	a0,s1
    8000176c:	b7cd                	j	8000174e <either_copyin+0x2a>

000000008000176e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000176e:	715d                	addi	sp,sp,-80
    80001770:	e486                	sd	ra,72(sp)
    80001772:	e0a2                	sd	s0,64(sp)
    80001774:	fc26                	sd	s1,56(sp)
    80001776:	f84a                	sd	s2,48(sp)
    80001778:	f44e                	sd	s3,40(sp)
    8000177a:	f052                	sd	s4,32(sp)
    8000177c:	ec56                	sd	s5,24(sp)
    8000177e:	e85a                	sd	s6,16(sp)
    80001780:	e45e                	sd	s7,8(sp)
    80001782:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001784:	00006517          	auipc	a0,0x6
    80001788:	89450513          	addi	a0,a0,-1900 # 80007018 <etext+0x18>
    8000178c:	375030ef          	jal	80005300 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001790:	00009497          	auipc	s1,0x9
    80001794:	2f848493          	addi	s1,s1,760 # 8000aa88 <proc+0x158>
    80001798:	0000f917          	auipc	s2,0xf
    8000179c:	ef090913          	addi	s2,s2,-272 # 80010688 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017a2:	00006997          	auipc	s3,0x6
    800017a6:	a9e98993          	addi	s3,s3,-1378 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800017aa:	00006a97          	auipc	s5,0x6
    800017ae:	a9ea8a93          	addi	s5,s5,-1378 # 80007248 <etext+0x248>
    printf("\n");
    800017b2:	00006a17          	auipc	s4,0x6
    800017b6:	866a0a13          	addi	s4,s4,-1946 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ba:	00006b97          	auipc	s7,0x6
    800017be:	08eb8b93          	addi	s7,s7,142 # 80007848 <states.0>
    800017c2:	a829                	j	800017dc <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017c4:	ed86a583          	lw	a1,-296(a3)
    800017c8:	8556                	mv	a0,s5
    800017ca:	337030ef          	jal	80005300 <printf>
    printf("\n");
    800017ce:	8552                	mv	a0,s4
    800017d0:	331030ef          	jal	80005300 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017d4:	17048493          	addi	s1,s1,368
    800017d8:	03248263          	beq	s1,s2,800017fc <procdump+0x8e>
    if(p->state == UNUSED)
    800017dc:	86a6                	mv	a3,s1
    800017de:	ec04a783          	lw	a5,-320(s1)
    800017e2:	dbed                	beqz	a5,800017d4 <procdump+0x66>
      state = "???";
    800017e4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017e6:	fcfb6fe3          	bltu	s6,a5,800017c4 <procdump+0x56>
    800017ea:	02079713          	slli	a4,a5,0x20
    800017ee:	01d75793          	srli	a5,a4,0x1d
    800017f2:	97de                	add	a5,a5,s7
    800017f4:	6390                	ld	a2,0(a5)
    800017f6:	f679                	bnez	a2,800017c4 <procdump+0x56>
      state = "???";
    800017f8:	864e                	mv	a2,s3
    800017fa:	b7e9                	j	800017c4 <procdump+0x56>
  }
}
    800017fc:	60a6                	ld	ra,72(sp)
    800017fe:	6406                	ld	s0,64(sp)
    80001800:	74e2                	ld	s1,56(sp)
    80001802:	7942                	ld	s2,48(sp)
    80001804:	79a2                	ld	s3,40(sp)
    80001806:	7a02                	ld	s4,32(sp)
    80001808:	6ae2                	ld	s5,24(sp)
    8000180a:	6b42                	ld	s6,16(sp)
    8000180c:	6ba2                	ld	s7,8(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret

0000000080001812 <count_proc>:

int 
count_proc(void) 
{
    80001812:	7179                	addi	sp,sp,-48
    80001814:	f406                	sd	ra,40(sp)
    80001816:	f022                	sd	s0,32(sp)
    80001818:	ec26                	sd	s1,24(sp)
    8000181a:	e84a                	sd	s2,16(sp)
    8000181c:	e44e                	sd	s3,8(sp)
    8000181e:	1800                	addi	s0,sp,48
  int n = 0;
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001820:	00009497          	auipc	s1,0x9
    80001824:	11048493          	addi	s1,s1,272 # 8000a930 <proc>
  int n = 0;
    80001828:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000182a:	0000f997          	auipc	s3,0xf
    8000182e:	d0698993          	addi	s3,s3,-762 # 80010530 <tickslock>
    80001832:	a801                	j	80001842 <count_proc+0x30>
    
    if (p->state != UNUSED) {
      n++;
    }

    release(&p->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	162040ef          	jal	80005998 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000183a:	17048493          	addi	s1,s1,368
    8000183e:	01348963          	beq	s1,s3,80001850 <count_proc+0x3e>
    acquire(&p->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	0bc040ef          	jal	80005900 <acquire>
    if (p->state != UNUSED) {
    80001848:	4c9c                	lw	a5,24(s1)
    8000184a:	d7ed                	beqz	a5,80001834 <count_proc+0x22>
      n++;
    8000184c:	2905                	addiw	s2,s2,1
    8000184e:	b7dd                	j	80001834 <count_proc+0x22>
  }

  return n;
    80001850:	854a                	mv	a0,s2
    80001852:	70a2                	ld	ra,40(sp)
    80001854:	7402                	ld	s0,32(sp)
    80001856:	64e2                	ld	s1,24(sp)
    80001858:	6942                	ld	s2,16(sp)
    8000185a:	69a2                	ld	s3,8(sp)
    8000185c:	6145                	addi	sp,sp,48
    8000185e:	8082                	ret

0000000080001860 <swtch>:
    80001860:	00153023          	sd	ra,0(a0)
    80001864:	00253423          	sd	sp,8(a0)
    80001868:	e900                	sd	s0,16(a0)
    8000186a:	ed04                	sd	s1,24(a0)
    8000186c:	03253023          	sd	s2,32(a0)
    80001870:	03353423          	sd	s3,40(a0)
    80001874:	03453823          	sd	s4,48(a0)
    80001878:	03553c23          	sd	s5,56(a0)
    8000187c:	05653023          	sd	s6,64(a0)
    80001880:	05753423          	sd	s7,72(a0)
    80001884:	05853823          	sd	s8,80(a0)
    80001888:	05953c23          	sd	s9,88(a0)
    8000188c:	07a53023          	sd	s10,96(a0)
    80001890:	07b53423          	sd	s11,104(a0)
    80001894:	0005b083          	ld	ra,0(a1)
    80001898:	0085b103          	ld	sp,8(a1)
    8000189c:	6980                	ld	s0,16(a1)
    8000189e:	6d84                	ld	s1,24(a1)
    800018a0:	0205b903          	ld	s2,32(a1)
    800018a4:	0285b983          	ld	s3,40(a1)
    800018a8:	0305ba03          	ld	s4,48(a1)
    800018ac:	0385ba83          	ld	s5,56(a1)
    800018b0:	0405bb03          	ld	s6,64(a1)
    800018b4:	0485bb83          	ld	s7,72(a1)
    800018b8:	0505bc03          	ld	s8,80(a1)
    800018bc:	0585bc83          	ld	s9,88(a1)
    800018c0:	0605bd03          	ld	s10,96(a1)
    800018c4:	0685bd83          	ld	s11,104(a1)
    800018c8:	8082                	ret

00000000800018ca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018ca:	1141                	addi	sp,sp,-16
    800018cc:	e406                	sd	ra,8(sp)
    800018ce:	e022                	sd	s0,0(sp)
    800018d0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018d2:	00006597          	auipc	a1,0x6
    800018d6:	9b658593          	addi	a1,a1,-1610 # 80007288 <etext+0x288>
    800018da:	0000f517          	auipc	a0,0xf
    800018de:	c5650513          	addi	a0,a0,-938 # 80010530 <tickslock>
    800018e2:	79f030ef          	jal	80005880 <initlock>
}
    800018e6:	60a2                	ld	ra,8(sp)
    800018e8:	6402                	ld	s0,0(sp)
    800018ea:	0141                	addi	sp,sp,16
    800018ec:	8082                	ret

00000000800018ee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ee:	1141                	addi	sp,sp,-16
    800018f0:	e422                	sd	s0,8(sp)
    800018f2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018f4:	00003797          	auipc	a5,0x3
    800018f8:	f4c78793          	addi	a5,a5,-180 # 80004840 <kernelvec>
    800018fc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001900:	6422                	ld	s0,8(sp)
    80001902:	0141                	addi	sp,sp,16
    80001904:	8082                	ret

0000000080001906 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001906:	1141                	addi	sp,sp,-16
    80001908:	e406                	sd	ra,8(sp)
    8000190a:	e022                	sd	s0,0(sp)
    8000190c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000190e:	c9aff0ef          	jal	80000da8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001916:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001918:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000191c:	00004697          	auipc	a3,0x4
    80001920:	6e468693          	addi	a3,a3,1764 # 80006000 <_trampoline>
    80001924:	00004717          	auipc	a4,0x4
    80001928:	6dc70713          	addi	a4,a4,1756 # 80006000 <_trampoline>
    8000192c:	8f15                	sub	a4,a4,a3
    8000192e:	040007b7          	lui	a5,0x4000
    80001932:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001934:	07b2                	slli	a5,a5,0xc
    80001936:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001938:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000193c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000193e:	18002673          	csrr	a2,satp
    80001942:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001944:	6d30                	ld	a2,88(a0)
    80001946:	6138                	ld	a4,64(a0)
    80001948:	6585                	lui	a1,0x1
    8000194a:	972e                	add	a4,a4,a1
    8000194c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000194e:	6d38                	ld	a4,88(a0)
    80001950:	00000617          	auipc	a2,0x0
    80001954:	11060613          	addi	a2,a2,272 # 80001a60 <usertrap>
    80001958:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000195a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000195c:	8612                	mv	a2,tp
    8000195e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001960:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001964:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001968:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000196c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001970:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001972:	6f18                	ld	a4,24(a4)
    80001974:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000197c:	00004717          	auipc	a4,0x4
    80001980:	72070713          	addi	a4,a4,1824 # 8000609c <userret>
    80001984:	8f15                	sub	a4,a4,a3
    80001986:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001988:	577d                	li	a4,-1
    8000198a:	177e                	slli	a4,a4,0x3f
    8000198c:	8d59                	or	a0,a0,a4
    8000198e:	9782                	jalr	a5
}
    80001990:	60a2                	ld	ra,8(sp)
    80001992:	6402                	ld	s0,0(sp)
    80001994:	0141                	addi	sp,sp,16
    80001996:	8082                	ret

0000000080001998 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001998:	1101                	addi	sp,sp,-32
    8000199a:	ec06                	sd	ra,24(sp)
    8000199c:	e822                	sd	s0,16(sp)
    8000199e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800019a0:	bdcff0ef          	jal	80000d7c <cpuid>
    800019a4:	cd11                	beqz	a0,800019c0 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019a6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019aa:	000f4737          	lui	a4,0xf4
    800019ae:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019b2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019b4:	14d79073          	csrw	stimecmp,a5
}
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	6105                	addi	sp,sp,32
    800019be:	8082                	ret
    800019c0:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019c2:	0000f497          	auipc	s1,0xf
    800019c6:	b6e48493          	addi	s1,s1,-1170 # 80010530 <tickslock>
    800019ca:	8526                	mv	a0,s1
    800019cc:	735030ef          	jal	80005900 <acquire>
    ticks++;
    800019d0:	00009517          	auipc	a0,0x9
    800019d4:	af850513          	addi	a0,a0,-1288 # 8000a4c8 <ticks>
    800019d8:	411c                	lw	a5,0(a0)
    800019da:	2785                	addiw	a5,a5,1
    800019dc:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019de:	9edff0ef          	jal	800013ca <wakeup>
    release(&tickslock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	7b5030ef          	jal	80005998 <release>
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	bf75                	j	800019a6 <clockintr+0xe>

00000000800019ec <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019f8:	57fd                	li	a5,-1
    800019fa:	17fe                	slli	a5,a5,0x3f
    800019fc:	07a5                	addi	a5,a5,9
    800019fe:	00f70c63          	beq	a4,a5,80001a16 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a02:	57fd                	li	a5,-1
    80001a04:	17fe                	slli	a5,a5,0x3f
    80001a06:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a0a:	04f70763          	beq	a4,a5,80001a58 <devintr+0x6c>
  }
}
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	6105                	addi	sp,sp,32
    80001a14:	8082                	ret
    80001a16:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a18:	6d5020ef          	jal	800048ec <plic_claim>
    80001a1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a1e:	47a9                	li	a5,10
    80001a20:	00f50963          	beq	a0,a5,80001a32 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a24:	4785                	li	a5,1
    80001a26:	00f50963          	beq	a0,a5,80001a38 <devintr+0x4c>
    return 1;
    80001a2a:	4505                	li	a0,1
    } else if(irq){
    80001a2c:	e889                	bnez	s1,80001a3e <devintr+0x52>
    80001a2e:	64a2                	ld	s1,8(sp)
    80001a30:	bff9                	j	80001a0e <devintr+0x22>
      uartintr();
    80001a32:	613030ef          	jal	80005844 <uartintr>
    if(irq)
    80001a36:	a819                	j	80001a4c <devintr+0x60>
      virtio_disk_intr();
    80001a38:	37a030ef          	jal	80004db2 <virtio_disk_intr>
    if(irq)
    80001a3c:	a801                	j	80001a4c <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a3e:	85a6                	mv	a1,s1
    80001a40:	00006517          	auipc	a0,0x6
    80001a44:	85050513          	addi	a0,a0,-1968 # 80007290 <etext+0x290>
    80001a48:	0b9030ef          	jal	80005300 <printf>
      plic_complete(irq);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	6bf020ef          	jal	8000490c <plic_complete>
    return 1;
    80001a52:	4505                	li	a0,1
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	bf65                	j	80001a0e <devintr+0x22>
    clockintr();
    80001a58:	f41ff0ef          	jal	80001998 <clockintr>
    return 2;
    80001a5c:	4509                	li	a0,2
    80001a5e:	bf45                	j	80001a0e <devintr+0x22>

0000000080001a60 <usertrap>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	e04a                	sd	s2,0(sp)
    80001a6a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a6c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a70:	1007f793          	andi	a5,a5,256
    80001a74:	ef85                	bnez	a5,80001aac <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a76:	00003797          	auipc	a5,0x3
    80001a7a:	dca78793          	addi	a5,a5,-566 # 80004840 <kernelvec>
    80001a7e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a82:	b26ff0ef          	jal	80000da8 <myproc>
    80001a86:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a88:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a8a:	14102773          	csrr	a4,sepc
    80001a8e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a90:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a94:	47a1                	li	a5,8
    80001a96:	02f70163          	beq	a4,a5,80001ab8 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a9a:	f53ff0ef          	jal	800019ec <devintr>
    80001a9e:	892a                	mv	s2,a0
    80001aa0:	c135                	beqz	a0,80001b04 <usertrap+0xa4>
  if(killed(p))
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	b13ff0ef          	jal	800015b6 <killed>
    80001aa8:	cd1d                	beqz	a0,80001ae6 <usertrap+0x86>
    80001aaa:	a81d                	j	80001ae0 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001aac:	00006517          	auipc	a0,0x6
    80001ab0:	80450513          	addi	a0,a0,-2044 # 800072b0 <etext+0x2b0>
    80001ab4:	31f030ef          	jal	800055d2 <panic>
    if(killed(p))
    80001ab8:	affff0ef          	jal	800015b6 <killed>
    80001abc:	e121                	bnez	a0,80001afc <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001abe:	6cb8                	ld	a4,88(s1)
    80001ac0:	6f1c                	ld	a5,24(a4)
    80001ac2:	0791                	addi	a5,a5,4
    80001ac4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ace:	10079073          	csrw	sstatus,a5
    syscall();
    80001ad2:	248000ef          	jal	80001d1a <syscall>
  if(killed(p))
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	adfff0ef          	jal	800015b6 <killed>
    80001adc:	c901                	beqz	a0,80001aec <usertrap+0x8c>
    80001ade:	4901                	li	s2,0
    exit(-1);
    80001ae0:	557d                	li	a0,-1
    80001ae2:	9a9ff0ef          	jal	8000148a <exit>
  if(which_dev == 2)
    80001ae6:	4789                	li	a5,2
    80001ae8:	04f90563          	beq	s2,a5,80001b32 <usertrap+0xd2>
  usertrapret();
    80001aec:	e1bff0ef          	jal	80001906 <usertrapret>
}
    80001af0:	60e2                	ld	ra,24(sp)
    80001af2:	6442                	ld	s0,16(sp)
    80001af4:	64a2                	ld	s1,8(sp)
    80001af6:	6902                	ld	s2,0(sp)
    80001af8:	6105                	addi	sp,sp,32
    80001afa:	8082                	ret
      exit(-1);
    80001afc:	557d                	li	a0,-1
    80001afe:	98dff0ef          	jal	8000148a <exit>
    80001b02:	bf75                	j	80001abe <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b04:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b08:	5890                	lw	a2,48(s1)
    80001b0a:	00005517          	auipc	a0,0x5
    80001b0e:	7c650513          	addi	a0,a0,1990 # 800072d0 <etext+0x2d0>
    80001b12:	7ee030ef          	jal	80005300 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b16:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b1a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b1e:	00005517          	auipc	a0,0x5
    80001b22:	7e250513          	addi	a0,a0,2018 # 80007300 <etext+0x300>
    80001b26:	7da030ef          	jal	80005300 <printf>
    setkilled(p);
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	a67ff0ef          	jal	80001592 <setkilled>
    80001b30:	b75d                	j	80001ad6 <usertrap+0x76>
    yield();
    80001b32:	821ff0ef          	jal	80001352 <yield>
    80001b36:	bf5d                	j	80001aec <usertrap+0x8c>

0000000080001b38 <kerneltrap>:
{
    80001b38:	7179                	addi	sp,sp,-48
    80001b3a:	f406                	sd	ra,40(sp)
    80001b3c:	f022                	sd	s0,32(sp)
    80001b3e:	ec26                	sd	s1,24(sp)
    80001b40:	e84a                	sd	s2,16(sp)
    80001b42:	e44e                	sd	s3,8(sp)
    80001b44:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b46:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b4e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b52:	1004f793          	andi	a5,s1,256
    80001b56:	c795                	beqz	a5,80001b82 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b5c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b5e:	eb85                	bnez	a5,80001b8e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b60:	e8dff0ef          	jal	800019ec <devintr>
    80001b64:	c91d                	beqz	a0,80001b9a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b66:	4789                	li	a5,2
    80001b68:	04f50a63          	beq	a0,a5,80001bbc <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b6c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b70:	10049073          	csrw	sstatus,s1
}
    80001b74:	70a2                	ld	ra,40(sp)
    80001b76:	7402                	ld	s0,32(sp)
    80001b78:	64e2                	ld	s1,24(sp)
    80001b7a:	6942                	ld	s2,16(sp)
    80001b7c:	69a2                	ld	s3,8(sp)
    80001b7e:	6145                	addi	sp,sp,48
    80001b80:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b82:	00005517          	auipc	a0,0x5
    80001b86:	7a650513          	addi	a0,a0,1958 # 80007328 <etext+0x328>
    80001b8a:	249030ef          	jal	800055d2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b8e:	00005517          	auipc	a0,0x5
    80001b92:	7c250513          	addi	a0,a0,1986 # 80007350 <etext+0x350>
    80001b96:	23d030ef          	jal	800055d2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b9a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b9e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001ba2:	85ce                	mv	a1,s3
    80001ba4:	00005517          	auipc	a0,0x5
    80001ba8:	7cc50513          	addi	a0,a0,1996 # 80007370 <etext+0x370>
    80001bac:	754030ef          	jal	80005300 <printf>
    panic("kerneltrap");
    80001bb0:	00005517          	auipc	a0,0x5
    80001bb4:	7e850513          	addi	a0,a0,2024 # 80007398 <etext+0x398>
    80001bb8:	21b030ef          	jal	800055d2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bbc:	9ecff0ef          	jal	80000da8 <myproc>
    80001bc0:	d555                	beqz	a0,80001b6c <kerneltrap+0x34>
    yield();
    80001bc2:	f90ff0ef          	jal	80001352 <yield>
    80001bc6:	b75d                	j	80001b6c <kerneltrap+0x34>

0000000080001bc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bc8:	1101                	addi	sp,sp,-32
    80001bca:	ec06                	sd	ra,24(sp)
    80001bcc:	e822                	sd	s0,16(sp)
    80001bce:	e426                	sd	s1,8(sp)
    80001bd0:	1000                	addi	s0,sp,32
    80001bd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bd4:	9d4ff0ef          	jal	80000da8 <myproc>
  switch (n) {
    80001bd8:	4795                	li	a5,5
    80001bda:	0497e163          	bltu	a5,s1,80001c1c <argraw+0x54>
    80001bde:	048a                	slli	s1,s1,0x2
    80001be0:	00006717          	auipc	a4,0x6
    80001be4:	c9870713          	addi	a4,a4,-872 # 80007878 <states.0+0x30>
    80001be8:	94ba                	add	s1,s1,a4
    80001bea:	409c                	lw	a5,0(s1)
    80001bec:	97ba                	add	a5,a5,a4
    80001bee:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bf0:	6d3c                	ld	a5,88(a0)
    80001bf2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bf4:	60e2                	ld	ra,24(sp)
    80001bf6:	6442                	ld	s0,16(sp)
    80001bf8:	64a2                	ld	s1,8(sp)
    80001bfa:	6105                	addi	sp,sp,32
    80001bfc:	8082                	ret
    return p->trapframe->a1;
    80001bfe:	6d3c                	ld	a5,88(a0)
    80001c00:	7fa8                	ld	a0,120(a5)
    80001c02:	bfcd                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a2;
    80001c04:	6d3c                	ld	a5,88(a0)
    80001c06:	63c8                	ld	a0,128(a5)
    80001c08:	b7f5                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a3;
    80001c0a:	6d3c                	ld	a5,88(a0)
    80001c0c:	67c8                	ld	a0,136(a5)
    80001c0e:	b7dd                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a4;
    80001c10:	6d3c                	ld	a5,88(a0)
    80001c12:	6bc8                	ld	a0,144(a5)
    80001c14:	b7c5                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a5;
    80001c16:	6d3c                	ld	a5,88(a0)
    80001c18:	6fc8                	ld	a0,152(a5)
    80001c1a:	bfe9                	j	80001bf4 <argraw+0x2c>
  panic("argraw");
    80001c1c:	00005517          	auipc	a0,0x5
    80001c20:	78c50513          	addi	a0,a0,1932 # 800073a8 <etext+0x3a8>
    80001c24:	1af030ef          	jal	800055d2 <panic>

0000000080001c28 <fetchaddr>:
{
    80001c28:	1101                	addi	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	e426                	sd	s1,8(sp)
    80001c30:	e04a                	sd	s2,0(sp)
    80001c32:	1000                	addi	s0,sp,32
    80001c34:	84aa                	mv	s1,a0
    80001c36:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c38:	970ff0ef          	jal	80000da8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c3c:	653c                	ld	a5,72(a0)
    80001c3e:	02f4f663          	bgeu	s1,a5,80001c6a <fetchaddr+0x42>
    80001c42:	00848713          	addi	a4,s1,8
    80001c46:	02e7e463          	bltu	a5,a4,80001c6e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c4a:	46a1                	li	a3,8
    80001c4c:	8626                	mv	a2,s1
    80001c4e:	85ca                	mv	a1,s2
    80001c50:	6928                	ld	a0,80(a0)
    80001c52:	e9ffe0ef          	jal	80000af0 <copyin>
    80001c56:	00a03533          	snez	a0,a0
    80001c5a:	40a00533          	neg	a0,a0
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6902                	ld	s2,0(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
    return -1;
    80001c6a:	557d                	li	a0,-1
    80001c6c:	bfcd                	j	80001c5e <fetchaddr+0x36>
    80001c6e:	557d                	li	a0,-1
    80001c70:	b7fd                	j	80001c5e <fetchaddr+0x36>

0000000080001c72 <fetchstr>:
{
    80001c72:	7179                	addi	sp,sp,-48
    80001c74:	f406                	sd	ra,40(sp)
    80001c76:	f022                	sd	s0,32(sp)
    80001c78:	ec26                	sd	s1,24(sp)
    80001c7a:	e84a                	sd	s2,16(sp)
    80001c7c:	e44e                	sd	s3,8(sp)
    80001c7e:	1800                	addi	s0,sp,48
    80001c80:	892a                	mv	s2,a0
    80001c82:	84ae                	mv	s1,a1
    80001c84:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c86:	922ff0ef          	jal	80000da8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c8a:	86ce                	mv	a3,s3
    80001c8c:	864a                	mv	a2,s2
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	6928                	ld	a0,80(a0)
    80001c92:	ee5fe0ef          	jal	80000b76 <copyinstr>
    80001c96:	00054c63          	bltz	a0,80001cae <fetchstr+0x3c>
  return strlen(buf);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	e64fe0ef          	jal	80000300 <strlen>
}
    80001ca0:	70a2                	ld	ra,40(sp)
    80001ca2:	7402                	ld	s0,32(sp)
    80001ca4:	64e2                	ld	s1,24(sp)
    80001ca6:	6942                	ld	s2,16(sp)
    80001ca8:	69a2                	ld	s3,8(sp)
    80001caa:	6145                	addi	sp,sp,48
    80001cac:	8082                	ret
    return -1;
    80001cae:	557d                	li	a0,-1
    80001cb0:	bfc5                	j	80001ca0 <fetchstr+0x2e>

0000000080001cb2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001cb2:	1101                	addi	sp,sp,-32
    80001cb4:	ec06                	sd	ra,24(sp)
    80001cb6:	e822                	sd	s0,16(sp)
    80001cb8:	e426                	sd	s1,8(sp)
    80001cba:	1000                	addi	s0,sp,32
    80001cbc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cbe:	f0bff0ef          	jal	80001bc8 <argraw>
    80001cc2:	c088                	sw	a0,0(s1)
}
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret

0000000080001cce <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cce:	1101                	addi	sp,sp,-32
    80001cd0:	ec06                	sd	ra,24(sp)
    80001cd2:	e822                	sd	s0,16(sp)
    80001cd4:	e426                	sd	s1,8(sp)
    80001cd6:	1000                	addi	s0,sp,32
    80001cd8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cda:	eefff0ef          	jal	80001bc8 <argraw>
    80001cde:	e088                	sd	a0,0(s1)
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6105                	addi	sp,sp,32
    80001ce8:	8082                	ret

0000000080001cea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cea:	7179                	addi	sp,sp,-48
    80001cec:	f406                	sd	ra,40(sp)
    80001cee:	f022                	sd	s0,32(sp)
    80001cf0:	ec26                	sd	s1,24(sp)
    80001cf2:	e84a                	sd	s2,16(sp)
    80001cf4:	1800                	addi	s0,sp,48
    80001cf6:	84ae                	mv	s1,a1
    80001cf8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cfa:	fd840593          	addi	a1,s0,-40
    80001cfe:	fd1ff0ef          	jal	80001cce <argaddr>
  return fetchstr(addr, buf, max);
    80001d02:	864a                	mv	a2,s2
    80001d04:	85a6                	mv	a1,s1
    80001d06:	fd843503          	ld	a0,-40(s0)
    80001d0a:	f69ff0ef          	jal	80001c72 <fetchstr>
}
    80001d0e:	70a2                	ld	ra,40(sp)
    80001d10:	7402                	ld	s0,32(sp)
    80001d12:	64e2                	ld	s1,24(sp)
    80001d14:	6942                	ld	s2,16(sp)
    80001d16:	6145                	addi	sp,sp,48
    80001d18:	8082                	ret

0000000080001d1a <syscall>:
  [SYS_sysinfo] "sysinfo"
};

void
syscall(void)
{
    80001d1a:	7179                	addi	sp,sp,-48
    80001d1c:	f406                	sd	ra,40(sp)
    80001d1e:	f022                	sd	s0,32(sp)
    80001d20:	ec26                	sd	s1,24(sp)
    80001d22:	e84a                	sd	s2,16(sp)
    80001d24:	e44e                	sd	s3,8(sp)
    80001d26:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001d28:	880ff0ef          	jal	80000da8 <myproc>
    80001d2c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d2e:	05853903          	ld	s2,88(a0)
    80001d32:	0a893783          	ld	a5,168(s2)
    80001d36:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d3a:	37fd                	addiw	a5,a5,-1
    80001d3c:	475d                	li	a4,23
    80001d3e:	04f76563          	bltu	a4,a5,80001d88 <syscall+0x6e>
    80001d42:	00399713          	slli	a4,s3,0x3
    80001d46:	00006797          	auipc	a5,0x6
    80001d4a:	b4a78793          	addi	a5,a5,-1206 # 80007890 <syscalls>
    80001d4e:	97ba                	add	a5,a5,a4
    80001d50:	639c                	ld	a5,0(a5)
    80001d52:	cb9d                	beqz	a5,80001d88 <syscall+0x6e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d54:	9782                	jalr	a5
    80001d56:	06a93823          	sd	a0,112(s2)

    if ((1 << num) & p->trace_mask) {
    80001d5a:	1684a783          	lw	a5,360(s1)
    80001d5e:	4137d7bb          	sraw	a5,a5,s3
    80001d62:	8b85                	andi	a5,a5,1
    80001d64:	cf9d                	beqz	a5,80001da2 <syscall+0x88>
      printf("%d: syscall %s -> %ld\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001d66:	6cb8                	ld	a4,88(s1)
    80001d68:	098e                	slli	s3,s3,0x3
    80001d6a:	00006797          	auipc	a5,0x6
    80001d6e:	b2678793          	addi	a5,a5,-1242 # 80007890 <syscalls>
    80001d72:	97ce                	add	a5,a5,s3
    80001d74:	7b34                	ld	a3,112(a4)
    80001d76:	67f0                	ld	a2,200(a5)
    80001d78:	588c                	lw	a1,48(s1)
    80001d7a:	00005517          	auipc	a0,0x5
    80001d7e:	63650513          	addi	a0,a0,1590 # 800073b0 <etext+0x3b0>
    80001d82:	57e030ef          	jal	80005300 <printf>
    80001d86:	a831                	j	80001da2 <syscall+0x88>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d88:	86ce                	mv	a3,s3
    80001d8a:	15848613          	addi	a2,s1,344
    80001d8e:	588c                	lw	a1,48(s1)
    80001d90:	00005517          	auipc	a0,0x5
    80001d94:	63850513          	addi	a0,a0,1592 # 800073c8 <etext+0x3c8>
    80001d98:	568030ef          	jal	80005300 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d9c:	6cbc                	ld	a5,88(s1)
    80001d9e:	577d                	li	a4,-1
    80001da0:	fbb8                	sd	a4,112(a5)
  }
}
    80001da2:	70a2                	ld	ra,40(sp)
    80001da4:	7402                	ld	s0,32(sp)
    80001da6:	64e2                	ld	s1,24(sp)
    80001da8:	6942                	ld	s2,16(sp)
    80001daa:	69a2                	ld	s3,8(sp)
    80001dac:	6145                	addi	sp,sp,48
    80001dae:	8082                	ret

0000000080001db0 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001db0:	1101                	addi	sp,sp,-32
    80001db2:	ec06                	sd	ra,24(sp)
    80001db4:	e822                	sd	s0,16(sp)
    80001db6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db8:	fec40593          	addi	a1,s0,-20
    80001dbc:	4501                	li	a0,0
    80001dbe:	ef5ff0ef          	jal	80001cb2 <argint>
  exit(n);
    80001dc2:	fec42503          	lw	a0,-20(s0)
    80001dc6:	ec4ff0ef          	jal	8000148a <exit>
  return 0;  // not reached
}
    80001dca:	4501                	li	a0,0
    80001dcc:	60e2                	ld	ra,24(sp)
    80001dce:	6442                	ld	s0,16(sp)
    80001dd0:	6105                	addi	sp,sp,32
    80001dd2:	8082                	ret

0000000080001dd4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dd4:	1141                	addi	sp,sp,-16
    80001dd6:	e406                	sd	ra,8(sp)
    80001dd8:	e022                	sd	s0,0(sp)
    80001dda:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001ddc:	fcdfe0ef          	jal	80000da8 <myproc>
}
    80001de0:	5908                	lw	a0,48(a0)
    80001de2:	60a2                	ld	ra,8(sp)
    80001de4:	6402                	ld	s0,0(sp)
    80001de6:	0141                	addi	sp,sp,16
    80001de8:	8082                	ret

0000000080001dea <sys_fork>:

uint64
sys_fork(void)
{
    80001dea:	1141                	addi	sp,sp,-16
    80001dec:	e406                	sd	ra,8(sp)
    80001dee:	e022                	sd	s0,0(sp)
    80001df0:	0800                	addi	s0,sp,16
  return fork();
    80001df2:	adcff0ef          	jal	800010ce <fork>
}
    80001df6:	60a2                	ld	ra,8(sp)
    80001df8:	6402                	ld	s0,0(sp)
    80001dfa:	0141                	addi	sp,sp,16
    80001dfc:	8082                	ret

0000000080001dfe <sys_wait>:

uint64
sys_wait(void)
{
    80001dfe:	1101                	addi	sp,sp,-32
    80001e00:	ec06                	sd	ra,24(sp)
    80001e02:	e822                	sd	s0,16(sp)
    80001e04:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e06:	fe840593          	addi	a1,s0,-24
    80001e0a:	4501                	li	a0,0
    80001e0c:	ec3ff0ef          	jal	80001cce <argaddr>
  return wait(p);
    80001e10:	fe843503          	ld	a0,-24(s0)
    80001e14:	fccff0ef          	jal	800015e0 <wait>
}
    80001e18:	60e2                	ld	ra,24(sp)
    80001e1a:	6442                	ld	s0,16(sp)
    80001e1c:	6105                	addi	sp,sp,32
    80001e1e:	8082                	ret

0000000080001e20 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e20:	7179                	addi	sp,sp,-48
    80001e22:	f406                	sd	ra,40(sp)
    80001e24:	f022                	sd	s0,32(sp)
    80001e26:	ec26                	sd	s1,24(sp)
    80001e28:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e2a:	fdc40593          	addi	a1,s0,-36
    80001e2e:	4501                	li	a0,0
    80001e30:	e83ff0ef          	jal	80001cb2 <argint>
  addr = myproc()->sz;
    80001e34:	f75fe0ef          	jal	80000da8 <myproc>
    80001e38:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e3a:	fdc42503          	lw	a0,-36(s0)
    80001e3e:	a40ff0ef          	jal	8000107e <growproc>
    80001e42:	00054863          	bltz	a0,80001e52 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e46:	8526                	mv	a0,s1
    80001e48:	70a2                	ld	ra,40(sp)
    80001e4a:	7402                	ld	s0,32(sp)
    80001e4c:	64e2                	ld	s1,24(sp)
    80001e4e:	6145                	addi	sp,sp,48
    80001e50:	8082                	ret
    return -1;
    80001e52:	54fd                	li	s1,-1
    80001e54:	bfcd                	j	80001e46 <sys_sbrk+0x26>

0000000080001e56 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e56:	7139                	addi	sp,sp,-64
    80001e58:	fc06                	sd	ra,56(sp)
    80001e5a:	f822                	sd	s0,48(sp)
    80001e5c:	f04a                	sd	s2,32(sp)
    80001e5e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e60:	fcc40593          	addi	a1,s0,-52
    80001e64:	4501                	li	a0,0
    80001e66:	e4dff0ef          	jal	80001cb2 <argint>
  if(n < 0)
    80001e6a:	fcc42783          	lw	a5,-52(s0)
    80001e6e:	0607c763          	bltz	a5,80001edc <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e72:	0000e517          	auipc	a0,0xe
    80001e76:	6be50513          	addi	a0,a0,1726 # 80010530 <tickslock>
    80001e7a:	287030ef          	jal	80005900 <acquire>
  ticks0 = ticks;
    80001e7e:	00008917          	auipc	s2,0x8
    80001e82:	64a92903          	lw	s2,1610(s2) # 8000a4c8 <ticks>
  while(ticks - ticks0 < n){
    80001e86:	fcc42783          	lw	a5,-52(s0)
    80001e8a:	cf8d                	beqz	a5,80001ec4 <sys_sleep+0x6e>
    80001e8c:	f426                	sd	s1,40(sp)
    80001e8e:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e90:	0000e997          	auipc	s3,0xe
    80001e94:	6a098993          	addi	s3,s3,1696 # 80010530 <tickslock>
    80001e98:	00008497          	auipc	s1,0x8
    80001e9c:	63048493          	addi	s1,s1,1584 # 8000a4c8 <ticks>
    if(killed(myproc())){
    80001ea0:	f09fe0ef          	jal	80000da8 <myproc>
    80001ea4:	f12ff0ef          	jal	800015b6 <killed>
    80001ea8:	ed0d                	bnez	a0,80001ee2 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001eaa:	85ce                	mv	a1,s3
    80001eac:	8526                	mv	a0,s1
    80001eae:	cd0ff0ef          	jal	8000137e <sleep>
  while(ticks - ticks0 < n){
    80001eb2:	409c                	lw	a5,0(s1)
    80001eb4:	412787bb          	subw	a5,a5,s2
    80001eb8:	fcc42703          	lw	a4,-52(s0)
    80001ebc:	fee7e2e3          	bltu	a5,a4,80001ea0 <sys_sleep+0x4a>
    80001ec0:	74a2                	ld	s1,40(sp)
    80001ec2:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ec4:	0000e517          	auipc	a0,0xe
    80001ec8:	66c50513          	addi	a0,a0,1644 # 80010530 <tickslock>
    80001ecc:	2cd030ef          	jal	80005998 <release>
  return 0;
    80001ed0:	4501                	li	a0,0
}
    80001ed2:	70e2                	ld	ra,56(sp)
    80001ed4:	7442                	ld	s0,48(sp)
    80001ed6:	7902                	ld	s2,32(sp)
    80001ed8:	6121                	addi	sp,sp,64
    80001eda:	8082                	ret
    n = 0;
    80001edc:	fc042623          	sw	zero,-52(s0)
    80001ee0:	bf49                	j	80001e72 <sys_sleep+0x1c>
      release(&tickslock);
    80001ee2:	0000e517          	auipc	a0,0xe
    80001ee6:	64e50513          	addi	a0,a0,1614 # 80010530 <tickslock>
    80001eea:	2af030ef          	jal	80005998 <release>
      return -1;
    80001eee:	557d                	li	a0,-1
    80001ef0:	74a2                	ld	s1,40(sp)
    80001ef2:	69e2                	ld	s3,24(sp)
    80001ef4:	bff9                	j	80001ed2 <sys_sleep+0x7c>

0000000080001ef6 <sys_kill>:

uint64
sys_kill(void)
{
    80001ef6:	1101                	addi	sp,sp,-32
    80001ef8:	ec06                	sd	ra,24(sp)
    80001efa:	e822                	sd	s0,16(sp)
    80001efc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001efe:	fec40593          	addi	a1,s0,-20
    80001f02:	4501                	li	a0,0
    80001f04:	dafff0ef          	jal	80001cb2 <argint>
  return kill(pid);
    80001f08:	fec42503          	lw	a0,-20(s0)
    80001f0c:	e20ff0ef          	jal	8000152c <kill>
}
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	6105                	addi	sp,sp,32
    80001f16:	8082                	ret

0000000080001f18 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f18:	1101                	addi	sp,sp,-32
    80001f1a:	ec06                	sd	ra,24(sp)
    80001f1c:	e822                	sd	s0,16(sp)
    80001f1e:	e426                	sd	s1,8(sp)
    80001f20:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f22:	0000e517          	auipc	a0,0xe
    80001f26:	60e50513          	addi	a0,a0,1550 # 80010530 <tickslock>
    80001f2a:	1d7030ef          	jal	80005900 <acquire>
  xticks = ticks;
    80001f2e:	00008497          	auipc	s1,0x8
    80001f32:	59a4a483          	lw	s1,1434(s1) # 8000a4c8 <ticks>
  release(&tickslock);
    80001f36:	0000e517          	auipc	a0,0xe
    80001f3a:	5fa50513          	addi	a0,a0,1530 # 80010530 <tickslock>
    80001f3e:	25b030ef          	jal	80005998 <release>
  return xticks;
}
    80001f42:	02049513          	slli	a0,s1,0x20
    80001f46:	9101                	srli	a0,a0,0x20
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6105                	addi	sp,sp,32
    80001f50:	8082                	ret

0000000080001f52 <sys_hello>:

uint64
sys_hello(void)
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	1800                	addi	s0,sp,48
  int n;
  argint(0, &n);
    80001f5a:	fdc40593          	addi	a1,s0,-36
    80001f5e:	4501                	li	a0,0
    80001f60:	d53ff0ef          	jal	80001cb2 <argint>

  for (int i = 0; i < n; i++) {
    80001f64:	fdc42783          	lw	a5,-36(s0)
    80001f68:	02f05363          	blez	a5,80001f8e <sys_hello+0x3c>
    80001f6c:	ec26                	sd	s1,24(sp)
    80001f6e:	e84a                	sd	s2,16(sp)
    80001f70:	4481                	li	s1,0
      printf("Hello, world!\n");
    80001f72:	00005917          	auipc	s2,0x5
    80001f76:	52e90913          	addi	s2,s2,1326 # 800074a0 <etext+0x4a0>
    80001f7a:	854a                	mv	a0,s2
    80001f7c:	384030ef          	jal	80005300 <printf>
  for (int i = 0; i < n; i++) {
    80001f80:	2485                	addiw	s1,s1,1
    80001f82:	fdc42783          	lw	a5,-36(s0)
    80001f86:	fef4cae3          	blt	s1,a5,80001f7a <sys_hello+0x28>
    80001f8a:	64e2                	ld	s1,24(sp)
    80001f8c:	6942                	ld	s2,16(sp)
  }
  
  return 0;
}
    80001f8e:	4501                	li	a0,0
    80001f90:	70a2                	ld	ra,40(sp)
    80001f92:	7402                	ld	s0,32(sp)
    80001f94:	6145                	addi	sp,sp,48
    80001f96:	8082                	ret

0000000080001f98 <sys_trace>:

uint64 
sys_trace(void) 
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80001fa0:	fec40593          	addi	a1,s0,-20
    80001fa4:	4501                	li	a0,0
    80001fa6:	d0dff0ef          	jal	80001cb2 <argint>

  struct proc *p = myproc();
    80001faa:	dfffe0ef          	jal	80000da8 <myproc>
  p->trace_mask = mask;
    80001fae:	fec42783          	lw	a5,-20(s0)
    80001fb2:	16f52423          	sw	a5,360(a0)
  
  return 0;
}
    80001fb6:	4501                	li	a0,0
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret

0000000080001fc0 <sys_sysinfo>:

uint64 
sys_sysinfo(void) 
{
    80001fc0:	7139                	addi	sp,sp,-64
    80001fc2:	fc06                	sd	ra,56(sp)
    80001fc4:	f822                	sd	s0,48(sp)
    80001fc6:	f426                	sd	s1,40(sp)
    80001fc8:	0080                	addi	s0,sp,64
  uint64 addr;
  argaddr(0, &addr);
    80001fca:	fd840593          	addi	a1,s0,-40
    80001fce:	4501                	li	a0,0
    80001fd0:	cffff0ef          	jal	80001cce <argaddr>

  if (addr < 0) {
    return -1;
  }

  struct proc *p = myproc();
    80001fd4:	dd5fe0ef          	jal	80000da8 <myproc>
    80001fd8:	84aa                	mv	s1,a0
  struct sysinfo info;

  info.freemem = count_freemem();
    80001fda:	974fe0ef          	jal	8000014e <count_freemem>
    80001fde:	fca43023          	sd	a0,-64(s0)
  info.nproc = count_proc();
    80001fe2:	831ff0ef          	jal	80001812 <count_proc>
    80001fe6:	fca43423          	sd	a0,-56(s0)
  info.nopenfiles = count_open_file();
    80001fea:	79c010ef          	jal	80003786 <count_open_file>
    80001fee:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0) {
    80001ff2:	46e1                	li	a3,24
    80001ff4:	fc040613          	addi	a2,s0,-64
    80001ff8:	fd843583          	ld	a1,-40(s0)
    80001ffc:	68a8                	ld	a0,80(s1)
    80001ffe:	a1dfe0ef          	jal	80000a1a <copyout>
    return -1;
  }

  return 0;
    80002002:	957d                	srai	a0,a0,0x3f
    80002004:	70e2                	ld	ra,56(sp)
    80002006:	7442                	ld	s0,48(sp)
    80002008:	74a2                	ld	s1,40(sp)
    8000200a:	6121                	addi	sp,sp,64
    8000200c:	8082                	ret

000000008000200e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000200e:	7179                	addi	sp,sp,-48
    80002010:	f406                	sd	ra,40(sp)
    80002012:	f022                	sd	s0,32(sp)
    80002014:	ec26                	sd	s1,24(sp)
    80002016:	e84a                	sd	s2,16(sp)
    80002018:	e44e                	sd	s3,8(sp)
    8000201a:	e052                	sd	s4,0(sp)
    8000201c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000201e:	00005597          	auipc	a1,0x5
    80002022:	49258593          	addi	a1,a1,1170 # 800074b0 <etext+0x4b0>
    80002026:	0000e517          	auipc	a0,0xe
    8000202a:	52250513          	addi	a0,a0,1314 # 80010548 <bcache>
    8000202e:	053030ef          	jal	80005880 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002032:	00016797          	auipc	a5,0x16
    80002036:	51678793          	addi	a5,a5,1302 # 80018548 <bcache+0x8000>
    8000203a:	00016717          	auipc	a4,0x16
    8000203e:	77670713          	addi	a4,a4,1910 # 800187b0 <bcache+0x8268>
    80002042:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002046:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000204a:	0000e497          	auipc	s1,0xe
    8000204e:	51648493          	addi	s1,s1,1302 # 80010560 <bcache+0x18>
    b->next = bcache.head.next;
    80002052:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002054:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002056:	00005a17          	auipc	s4,0x5
    8000205a:	462a0a13          	addi	s4,s4,1122 # 800074b8 <etext+0x4b8>
    b->next = bcache.head.next;
    8000205e:	2b893783          	ld	a5,696(s2)
    80002062:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002064:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002068:	85d2                	mv	a1,s4
    8000206a:	01048513          	addi	a0,s1,16
    8000206e:	248010ef          	jal	800032b6 <initsleeplock>
    bcache.head.next->prev = b;
    80002072:	2b893783          	ld	a5,696(s2)
    80002076:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002078:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000207c:	45848493          	addi	s1,s1,1112
    80002080:	fd349fe3          	bne	s1,s3,8000205e <binit+0x50>
  }
}
    80002084:	70a2                	ld	ra,40(sp)
    80002086:	7402                	ld	s0,32(sp)
    80002088:	64e2                	ld	s1,24(sp)
    8000208a:	6942                	ld	s2,16(sp)
    8000208c:	69a2                	ld	s3,8(sp)
    8000208e:	6a02                	ld	s4,0(sp)
    80002090:	6145                	addi	sp,sp,48
    80002092:	8082                	ret

0000000080002094 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002094:	7179                	addi	sp,sp,-48
    80002096:	f406                	sd	ra,40(sp)
    80002098:	f022                	sd	s0,32(sp)
    8000209a:	ec26                	sd	s1,24(sp)
    8000209c:	e84a                	sd	s2,16(sp)
    8000209e:	e44e                	sd	s3,8(sp)
    800020a0:	1800                	addi	s0,sp,48
    800020a2:	892a                	mv	s2,a0
    800020a4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020a6:	0000e517          	auipc	a0,0xe
    800020aa:	4a250513          	addi	a0,a0,1186 # 80010548 <bcache>
    800020ae:	053030ef          	jal	80005900 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800020b2:	00016497          	auipc	s1,0x16
    800020b6:	74e4b483          	ld	s1,1870(s1) # 80018800 <bcache+0x82b8>
    800020ba:	00016797          	auipc	a5,0x16
    800020be:	6f678793          	addi	a5,a5,1782 # 800187b0 <bcache+0x8268>
    800020c2:	02f48b63          	beq	s1,a5,800020f8 <bread+0x64>
    800020c6:	873e                	mv	a4,a5
    800020c8:	a021                	j	800020d0 <bread+0x3c>
    800020ca:	68a4                	ld	s1,80(s1)
    800020cc:	02e48663          	beq	s1,a4,800020f8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020d0:	449c                	lw	a5,8(s1)
    800020d2:	ff279ce3          	bne	a5,s2,800020ca <bread+0x36>
    800020d6:	44dc                	lw	a5,12(s1)
    800020d8:	ff3799e3          	bne	a5,s3,800020ca <bread+0x36>
      b->refcnt++;
    800020dc:	40bc                	lw	a5,64(s1)
    800020de:	2785                	addiw	a5,a5,1
    800020e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	46650513          	addi	a0,a0,1126 # 80010548 <bcache>
    800020ea:	0af030ef          	jal	80005998 <release>
      acquiresleep(&b->lock);
    800020ee:	01048513          	addi	a0,s1,16
    800020f2:	1fa010ef          	jal	800032ec <acquiresleep>
      return b;
    800020f6:	a889                	j	80002148 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020f8:	00016497          	auipc	s1,0x16
    800020fc:	7004b483          	ld	s1,1792(s1) # 800187f8 <bcache+0x82b0>
    80002100:	00016797          	auipc	a5,0x16
    80002104:	6b078793          	addi	a5,a5,1712 # 800187b0 <bcache+0x8268>
    80002108:	00f48863          	beq	s1,a5,80002118 <bread+0x84>
    8000210c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000210e:	40bc                	lw	a5,64(s1)
    80002110:	cb91                	beqz	a5,80002124 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002112:	64a4                	ld	s1,72(s1)
    80002114:	fee49de3          	bne	s1,a4,8000210e <bread+0x7a>
  panic("bget: no buffers");
    80002118:	00005517          	auipc	a0,0x5
    8000211c:	3a850513          	addi	a0,a0,936 # 800074c0 <etext+0x4c0>
    80002120:	4b2030ef          	jal	800055d2 <panic>
      b->dev = dev;
    80002124:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002128:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000212c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002130:	4785                	li	a5,1
    80002132:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002134:	0000e517          	auipc	a0,0xe
    80002138:	41450513          	addi	a0,a0,1044 # 80010548 <bcache>
    8000213c:	05d030ef          	jal	80005998 <release>
      acquiresleep(&b->lock);
    80002140:	01048513          	addi	a0,s1,16
    80002144:	1a8010ef          	jal	800032ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002148:	409c                	lw	a5,0(s1)
    8000214a:	cb89                	beqz	a5,8000215c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000214c:	8526                	mv	a0,s1
    8000214e:	70a2                	ld	ra,40(sp)
    80002150:	7402                	ld	s0,32(sp)
    80002152:	64e2                	ld	s1,24(sp)
    80002154:	6942                	ld	s2,16(sp)
    80002156:	69a2                	ld	s3,8(sp)
    80002158:	6145                	addi	sp,sp,48
    8000215a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000215c:	4581                	li	a1,0
    8000215e:	8526                	mv	a0,s1
    80002160:	241020ef          	jal	80004ba0 <virtio_disk_rw>
    b->valid = 1;
    80002164:	4785                	li	a5,1
    80002166:	c09c                	sw	a5,0(s1)
  return b;
    80002168:	b7d5                	j	8000214c <bread+0xb8>

000000008000216a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002176:	0541                	addi	a0,a0,16
    80002178:	1f2010ef          	jal	8000336a <holdingsleep>
    8000217c:	c911                	beqz	a0,80002190 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000217e:	4585                	li	a1,1
    80002180:	8526                	mv	a0,s1
    80002182:	21f020ef          	jal	80004ba0 <virtio_disk_rw>
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6105                	addi	sp,sp,32
    8000218e:	8082                	ret
    panic("bwrite");
    80002190:	00005517          	auipc	a0,0x5
    80002194:	34850513          	addi	a0,a0,840 # 800074d8 <etext+0x4d8>
    80002198:	43a030ef          	jal	800055d2 <panic>

000000008000219c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000219c:	1101                	addi	sp,sp,-32
    8000219e:	ec06                	sd	ra,24(sp)
    800021a0:	e822                	sd	s0,16(sp)
    800021a2:	e426                	sd	s1,8(sp)
    800021a4:	e04a                	sd	s2,0(sp)
    800021a6:	1000                	addi	s0,sp,32
    800021a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021aa:	01050913          	addi	s2,a0,16
    800021ae:	854a                	mv	a0,s2
    800021b0:	1ba010ef          	jal	8000336a <holdingsleep>
    800021b4:	c135                	beqz	a0,80002218 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800021b6:	854a                	mv	a0,s2
    800021b8:	17a010ef          	jal	80003332 <releasesleep>

  acquire(&bcache.lock);
    800021bc:	0000e517          	auipc	a0,0xe
    800021c0:	38c50513          	addi	a0,a0,908 # 80010548 <bcache>
    800021c4:	73c030ef          	jal	80005900 <acquire>
  b->refcnt--;
    800021c8:	40bc                	lw	a5,64(s1)
    800021ca:	37fd                	addiw	a5,a5,-1
    800021cc:	0007871b          	sext.w	a4,a5
    800021d0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021d2:	e71d                	bnez	a4,80002200 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021d4:	68b8                	ld	a4,80(s1)
    800021d6:	64bc                	ld	a5,72(s1)
    800021d8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021da:	68b8                	ld	a4,80(s1)
    800021dc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021de:	00016797          	auipc	a5,0x16
    800021e2:	36a78793          	addi	a5,a5,874 # 80018548 <bcache+0x8000>
    800021e6:	2b87b703          	ld	a4,696(a5)
    800021ea:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800021ec:	00016717          	auipc	a4,0x16
    800021f0:	5c470713          	addi	a4,a4,1476 # 800187b0 <bcache+0x8268>
    800021f4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021f6:	2b87b703          	ld	a4,696(a5)
    800021fa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021fc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002200:	0000e517          	auipc	a0,0xe
    80002204:	34850513          	addi	a0,a0,840 # 80010548 <bcache>
    80002208:	790030ef          	jal	80005998 <release>
}
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	64a2                	ld	s1,8(sp)
    80002212:	6902                	ld	s2,0(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret
    panic("brelse");
    80002218:	00005517          	auipc	a0,0x5
    8000221c:	2c850513          	addi	a0,a0,712 # 800074e0 <etext+0x4e0>
    80002220:	3b2030ef          	jal	800055d2 <panic>

0000000080002224 <bpin>:

void
bpin(struct buf *b) {
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	e426                	sd	s1,8(sp)
    8000222c:	1000                	addi	s0,sp,32
    8000222e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002230:	0000e517          	auipc	a0,0xe
    80002234:	31850513          	addi	a0,a0,792 # 80010548 <bcache>
    80002238:	6c8030ef          	jal	80005900 <acquire>
  b->refcnt++;
    8000223c:	40bc                	lw	a5,64(s1)
    8000223e:	2785                	addiw	a5,a5,1
    80002240:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002242:	0000e517          	auipc	a0,0xe
    80002246:	30650513          	addi	a0,a0,774 # 80010548 <bcache>
    8000224a:	74e030ef          	jal	80005998 <release>
}
    8000224e:	60e2                	ld	ra,24(sp)
    80002250:	6442                	ld	s0,16(sp)
    80002252:	64a2                	ld	s1,8(sp)
    80002254:	6105                	addi	sp,sp,32
    80002256:	8082                	ret

0000000080002258 <bunpin>:

void
bunpin(struct buf *b) {
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	e426                	sd	s1,8(sp)
    80002260:	1000                	addi	s0,sp,32
    80002262:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002264:	0000e517          	auipc	a0,0xe
    80002268:	2e450513          	addi	a0,a0,740 # 80010548 <bcache>
    8000226c:	694030ef          	jal	80005900 <acquire>
  b->refcnt--;
    80002270:	40bc                	lw	a5,64(s1)
    80002272:	37fd                	addiw	a5,a5,-1
    80002274:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002276:	0000e517          	auipc	a0,0xe
    8000227a:	2d250513          	addi	a0,a0,722 # 80010548 <bcache>
    8000227e:	71a030ef          	jal	80005998 <release>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6105                	addi	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	e426                	sd	s1,8(sp)
    80002294:	e04a                	sd	s2,0(sp)
    80002296:	1000                	addi	s0,sp,32
    80002298:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000229a:	00d5d59b          	srliw	a1,a1,0xd
    8000229e:	00017797          	auipc	a5,0x17
    800022a2:	9867a783          	lw	a5,-1658(a5) # 80018c24 <sb+0x1c>
    800022a6:	9dbd                	addw	a1,a1,a5
    800022a8:	dedff0ef          	jal	80002094 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022ac:	0074f713          	andi	a4,s1,7
    800022b0:	4785                	li	a5,1
    800022b2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800022b6:	14ce                	slli	s1,s1,0x33
    800022b8:	90d9                	srli	s1,s1,0x36
    800022ba:	00950733          	add	a4,a0,s1
    800022be:	05874703          	lbu	a4,88(a4)
    800022c2:	00e7f6b3          	and	a3,a5,a4
    800022c6:	c29d                	beqz	a3,800022ec <bfree+0x60>
    800022c8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800022ca:	94aa                	add	s1,s1,a0
    800022cc:	fff7c793          	not	a5,a5
    800022d0:	8f7d                	and	a4,a4,a5
    800022d2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022d6:	711000ef          	jal	800031e6 <log_write>
  brelse(bp);
    800022da:	854a                	mv	a0,s2
    800022dc:	ec1ff0ef          	jal	8000219c <brelse>
}
    800022e0:	60e2                	ld	ra,24(sp)
    800022e2:	6442                	ld	s0,16(sp)
    800022e4:	64a2                	ld	s1,8(sp)
    800022e6:	6902                	ld	s2,0(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret
    panic("freeing free block");
    800022ec:	00005517          	auipc	a0,0x5
    800022f0:	1fc50513          	addi	a0,a0,508 # 800074e8 <etext+0x4e8>
    800022f4:	2de030ef          	jal	800055d2 <panic>

00000000800022f8 <balloc>:
{
    800022f8:	711d                	addi	sp,sp,-96
    800022fa:	ec86                	sd	ra,88(sp)
    800022fc:	e8a2                	sd	s0,80(sp)
    800022fe:	e4a6                	sd	s1,72(sp)
    80002300:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002302:	00017797          	auipc	a5,0x17
    80002306:	90a7a783          	lw	a5,-1782(a5) # 80018c0c <sb+0x4>
    8000230a:	0e078f63          	beqz	a5,80002408 <balloc+0x110>
    8000230e:	e0ca                	sd	s2,64(sp)
    80002310:	fc4e                	sd	s3,56(sp)
    80002312:	f852                	sd	s4,48(sp)
    80002314:	f456                	sd	s5,40(sp)
    80002316:	f05a                	sd	s6,32(sp)
    80002318:	ec5e                	sd	s7,24(sp)
    8000231a:	e862                	sd	s8,16(sp)
    8000231c:	e466                	sd	s9,8(sp)
    8000231e:	8baa                	mv	s7,a0
    80002320:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002322:	00017b17          	auipc	s6,0x17
    80002326:	8e6b0b13          	addi	s6,s6,-1818 # 80018c08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000232a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000232c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000232e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002330:	6c89                	lui	s9,0x2
    80002332:	a0b5                	j	8000239e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002334:	97ca                	add	a5,a5,s2
    80002336:	8e55                	or	a2,a2,a3
    80002338:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000233c:	854a                	mv	a0,s2
    8000233e:	6a9000ef          	jal	800031e6 <log_write>
        brelse(bp);
    80002342:	854a                	mv	a0,s2
    80002344:	e59ff0ef          	jal	8000219c <brelse>
  bp = bread(dev, bno);
    80002348:	85a6                	mv	a1,s1
    8000234a:	855e                	mv	a0,s7
    8000234c:	d49ff0ef          	jal	80002094 <bread>
    80002350:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002352:	40000613          	li	a2,1024
    80002356:	4581                	li	a1,0
    80002358:	05850513          	addi	a0,a0,88
    8000235c:	e35fd0ef          	jal	80000190 <memset>
  log_write(bp);
    80002360:	854a                	mv	a0,s2
    80002362:	685000ef          	jal	800031e6 <log_write>
  brelse(bp);
    80002366:	854a                	mv	a0,s2
    80002368:	e35ff0ef          	jal	8000219c <brelse>
}
    8000236c:	6906                	ld	s2,64(sp)
    8000236e:	79e2                	ld	s3,56(sp)
    80002370:	7a42                	ld	s4,48(sp)
    80002372:	7aa2                	ld	s5,40(sp)
    80002374:	7b02                	ld	s6,32(sp)
    80002376:	6be2                	ld	s7,24(sp)
    80002378:	6c42                	ld	s8,16(sp)
    8000237a:	6ca2                	ld	s9,8(sp)
}
    8000237c:	8526                	mv	a0,s1
    8000237e:	60e6                	ld	ra,88(sp)
    80002380:	6446                	ld	s0,80(sp)
    80002382:	64a6                	ld	s1,72(sp)
    80002384:	6125                	addi	sp,sp,96
    80002386:	8082                	ret
    brelse(bp);
    80002388:	854a                	mv	a0,s2
    8000238a:	e13ff0ef          	jal	8000219c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000238e:	015c87bb          	addw	a5,s9,s5
    80002392:	00078a9b          	sext.w	s5,a5
    80002396:	004b2703          	lw	a4,4(s6)
    8000239a:	04eaff63          	bgeu	s5,a4,800023f8 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000239e:	41fad79b          	sraiw	a5,s5,0x1f
    800023a2:	0137d79b          	srliw	a5,a5,0x13
    800023a6:	015787bb          	addw	a5,a5,s5
    800023aa:	40d7d79b          	sraiw	a5,a5,0xd
    800023ae:	01cb2583          	lw	a1,28(s6)
    800023b2:	9dbd                	addw	a1,a1,a5
    800023b4:	855e                	mv	a0,s7
    800023b6:	cdfff0ef          	jal	80002094 <bread>
    800023ba:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023bc:	004b2503          	lw	a0,4(s6)
    800023c0:	000a849b          	sext.w	s1,s5
    800023c4:	8762                	mv	a4,s8
    800023c6:	fca4f1e3          	bgeu	s1,a0,80002388 <balloc+0x90>
      m = 1 << (bi % 8);
    800023ca:	00777693          	andi	a3,a4,7
    800023ce:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023d2:	41f7579b          	sraiw	a5,a4,0x1f
    800023d6:	01d7d79b          	srliw	a5,a5,0x1d
    800023da:	9fb9                	addw	a5,a5,a4
    800023dc:	4037d79b          	sraiw	a5,a5,0x3
    800023e0:	00f90633          	add	a2,s2,a5
    800023e4:	05864603          	lbu	a2,88(a2)
    800023e8:	00c6f5b3          	and	a1,a3,a2
    800023ec:	d5a1                	beqz	a1,80002334 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023ee:	2705                	addiw	a4,a4,1
    800023f0:	2485                	addiw	s1,s1,1
    800023f2:	fd471ae3          	bne	a4,s4,800023c6 <balloc+0xce>
    800023f6:	bf49                	j	80002388 <balloc+0x90>
    800023f8:	6906                	ld	s2,64(sp)
    800023fa:	79e2                	ld	s3,56(sp)
    800023fc:	7a42                	ld	s4,48(sp)
    800023fe:	7aa2                	ld	s5,40(sp)
    80002400:	7b02                	ld	s6,32(sp)
    80002402:	6be2                	ld	s7,24(sp)
    80002404:	6c42                	ld	s8,16(sp)
    80002406:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002408:	00005517          	auipc	a0,0x5
    8000240c:	0f850513          	addi	a0,a0,248 # 80007500 <etext+0x500>
    80002410:	6f1020ef          	jal	80005300 <printf>
  return 0;
    80002414:	4481                	li	s1,0
    80002416:	b79d                	j	8000237c <balloc+0x84>

0000000080002418 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002418:	7179                	addi	sp,sp,-48
    8000241a:	f406                	sd	ra,40(sp)
    8000241c:	f022                	sd	s0,32(sp)
    8000241e:	ec26                	sd	s1,24(sp)
    80002420:	e84a                	sd	s2,16(sp)
    80002422:	e44e                	sd	s3,8(sp)
    80002424:	1800                	addi	s0,sp,48
    80002426:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002428:	47ad                	li	a5,11
    8000242a:	02b7e663          	bltu	a5,a1,80002456 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000242e:	02059793          	slli	a5,a1,0x20
    80002432:	01e7d593          	srli	a1,a5,0x1e
    80002436:	00b504b3          	add	s1,a0,a1
    8000243a:	0504a903          	lw	s2,80(s1)
    8000243e:	06091a63          	bnez	s2,800024b2 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002442:	4108                	lw	a0,0(a0)
    80002444:	eb5ff0ef          	jal	800022f8 <balloc>
    80002448:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000244c:	06090363          	beqz	s2,800024b2 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002450:	0524a823          	sw	s2,80(s1)
    80002454:	a8b9                	j	800024b2 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002456:	ff45849b          	addiw	s1,a1,-12
    8000245a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000245e:	0ff00793          	li	a5,255
    80002462:	06e7ee63          	bltu	a5,a4,800024de <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002466:	08052903          	lw	s2,128(a0)
    8000246a:	00091d63          	bnez	s2,80002484 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000246e:	4108                	lw	a0,0(a0)
    80002470:	e89ff0ef          	jal	800022f8 <balloc>
    80002474:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002478:	02090d63          	beqz	s2,800024b2 <bmap+0x9a>
    8000247c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000247e:	0929a023          	sw	s2,128(s3)
    80002482:	a011                	j	80002486 <bmap+0x6e>
    80002484:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002486:	85ca                	mv	a1,s2
    80002488:	0009a503          	lw	a0,0(s3)
    8000248c:	c09ff0ef          	jal	80002094 <bread>
    80002490:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002492:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002496:	02049713          	slli	a4,s1,0x20
    8000249a:	01e75593          	srli	a1,a4,0x1e
    8000249e:	00b784b3          	add	s1,a5,a1
    800024a2:	0004a903          	lw	s2,0(s1)
    800024a6:	00090e63          	beqz	s2,800024c2 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024aa:	8552                	mv	a0,s4
    800024ac:	cf1ff0ef          	jal	8000219c <brelse>
    return addr;
    800024b0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024b2:	854a                	mv	a0,s2
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
      addr = balloc(ip->dev);
    800024c2:	0009a503          	lw	a0,0(s3)
    800024c6:	e33ff0ef          	jal	800022f8 <balloc>
    800024ca:	0005091b          	sext.w	s2,a0
      if(addr){
    800024ce:	fc090ee3          	beqz	s2,800024aa <bmap+0x92>
        a[bn] = addr;
    800024d2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800024d6:	8552                	mv	a0,s4
    800024d8:	50f000ef          	jal	800031e6 <log_write>
    800024dc:	b7f9                	j	800024aa <bmap+0x92>
    800024de:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800024e0:	00005517          	auipc	a0,0x5
    800024e4:	03850513          	addi	a0,a0,56 # 80007518 <etext+0x518>
    800024e8:	0ea030ef          	jal	800055d2 <panic>

00000000800024ec <iget>:
{
    800024ec:	7179                	addi	sp,sp,-48
    800024ee:	f406                	sd	ra,40(sp)
    800024f0:	f022                	sd	s0,32(sp)
    800024f2:	ec26                	sd	s1,24(sp)
    800024f4:	e84a                	sd	s2,16(sp)
    800024f6:	e44e                	sd	s3,8(sp)
    800024f8:	e052                	sd	s4,0(sp)
    800024fa:	1800                	addi	s0,sp,48
    800024fc:	89aa                	mv	s3,a0
    800024fe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002500:	00016517          	auipc	a0,0x16
    80002504:	72850513          	addi	a0,a0,1832 # 80018c28 <itable>
    80002508:	3f8030ef          	jal	80005900 <acquire>
  empty = 0;
    8000250c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000250e:	00016497          	auipc	s1,0x16
    80002512:	73248493          	addi	s1,s1,1842 # 80018c40 <itable+0x18>
    80002516:	00018697          	auipc	a3,0x18
    8000251a:	1ba68693          	addi	a3,a3,442 # 8001a6d0 <log>
    8000251e:	a039                	j	8000252c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002520:	02090963          	beqz	s2,80002552 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002524:	08848493          	addi	s1,s1,136
    80002528:	02d48863          	beq	s1,a3,80002558 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000252c:	449c                	lw	a5,8(s1)
    8000252e:	fef059e3          	blez	a5,80002520 <iget+0x34>
    80002532:	4098                	lw	a4,0(s1)
    80002534:	ff3716e3          	bne	a4,s3,80002520 <iget+0x34>
    80002538:	40d8                	lw	a4,4(s1)
    8000253a:	ff4713e3          	bne	a4,s4,80002520 <iget+0x34>
      ip->ref++;
    8000253e:	2785                	addiw	a5,a5,1
    80002540:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002542:	00016517          	auipc	a0,0x16
    80002546:	6e650513          	addi	a0,a0,1766 # 80018c28 <itable>
    8000254a:	44e030ef          	jal	80005998 <release>
      return ip;
    8000254e:	8926                	mv	s2,s1
    80002550:	a02d                	j	8000257a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002552:	fbe9                	bnez	a5,80002524 <iget+0x38>
      empty = ip;
    80002554:	8926                	mv	s2,s1
    80002556:	b7f9                	j	80002524 <iget+0x38>
  if(empty == 0)
    80002558:	02090a63          	beqz	s2,8000258c <iget+0xa0>
  ip->dev = dev;
    8000255c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002560:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002564:	4785                	li	a5,1
    80002566:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000256a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000256e:	00016517          	auipc	a0,0x16
    80002572:	6ba50513          	addi	a0,a0,1722 # 80018c28 <itable>
    80002576:	422030ef          	jal	80005998 <release>
}
    8000257a:	854a                	mv	a0,s2
    8000257c:	70a2                	ld	ra,40(sp)
    8000257e:	7402                	ld	s0,32(sp)
    80002580:	64e2                	ld	s1,24(sp)
    80002582:	6942                	ld	s2,16(sp)
    80002584:	69a2                	ld	s3,8(sp)
    80002586:	6a02                	ld	s4,0(sp)
    80002588:	6145                	addi	sp,sp,48
    8000258a:	8082                	ret
    panic("iget: no inodes");
    8000258c:	00005517          	auipc	a0,0x5
    80002590:	fa450513          	addi	a0,a0,-92 # 80007530 <etext+0x530>
    80002594:	03e030ef          	jal	800055d2 <panic>

0000000080002598 <fsinit>:
fsinit(int dev) {
    80002598:	7179                	addi	sp,sp,-48
    8000259a:	f406                	sd	ra,40(sp)
    8000259c:	f022                	sd	s0,32(sp)
    8000259e:	ec26                	sd	s1,24(sp)
    800025a0:	e84a                	sd	s2,16(sp)
    800025a2:	e44e                	sd	s3,8(sp)
    800025a4:	1800                	addi	s0,sp,48
    800025a6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800025a8:	4585                	li	a1,1
    800025aa:	aebff0ef          	jal	80002094 <bread>
    800025ae:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800025b0:	00016997          	auipc	s3,0x16
    800025b4:	65898993          	addi	s3,s3,1624 # 80018c08 <sb>
    800025b8:	02000613          	li	a2,32
    800025bc:	05850593          	addi	a1,a0,88
    800025c0:	854e                	mv	a0,s3
    800025c2:	c2bfd0ef          	jal	800001ec <memmove>
  brelse(bp);
    800025c6:	8526                	mv	a0,s1
    800025c8:	bd5ff0ef          	jal	8000219c <brelse>
  if(sb.magic != FSMAGIC)
    800025cc:	0009a703          	lw	a4,0(s3)
    800025d0:	102037b7          	lui	a5,0x10203
    800025d4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800025d8:	02f71063          	bne	a4,a5,800025f8 <fsinit+0x60>
  initlog(dev, &sb);
    800025dc:	00016597          	auipc	a1,0x16
    800025e0:	62c58593          	addi	a1,a1,1580 # 80018c08 <sb>
    800025e4:	854a                	mv	a0,s2
    800025e6:	1f9000ef          	jal	80002fde <initlog>
}
    800025ea:	70a2                	ld	ra,40(sp)
    800025ec:	7402                	ld	s0,32(sp)
    800025ee:	64e2                	ld	s1,24(sp)
    800025f0:	6942                	ld	s2,16(sp)
    800025f2:	69a2                	ld	s3,8(sp)
    800025f4:	6145                	addi	sp,sp,48
    800025f6:	8082                	ret
    panic("invalid file system");
    800025f8:	00005517          	auipc	a0,0x5
    800025fc:	f4850513          	addi	a0,a0,-184 # 80007540 <etext+0x540>
    80002600:	7d3020ef          	jal	800055d2 <panic>

0000000080002604 <iinit>:
{
    80002604:	7179                	addi	sp,sp,-48
    80002606:	f406                	sd	ra,40(sp)
    80002608:	f022                	sd	s0,32(sp)
    8000260a:	ec26                	sd	s1,24(sp)
    8000260c:	e84a                	sd	s2,16(sp)
    8000260e:	e44e                	sd	s3,8(sp)
    80002610:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002612:	00005597          	auipc	a1,0x5
    80002616:	f4658593          	addi	a1,a1,-186 # 80007558 <etext+0x558>
    8000261a:	00016517          	auipc	a0,0x16
    8000261e:	60e50513          	addi	a0,a0,1550 # 80018c28 <itable>
    80002622:	25e030ef          	jal	80005880 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002626:	00016497          	auipc	s1,0x16
    8000262a:	62a48493          	addi	s1,s1,1578 # 80018c50 <itable+0x28>
    8000262e:	00018997          	auipc	s3,0x18
    80002632:	0b298993          	addi	s3,s3,178 # 8001a6e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002636:	00005917          	auipc	s2,0x5
    8000263a:	f2a90913          	addi	s2,s2,-214 # 80007560 <etext+0x560>
    8000263e:	85ca                	mv	a1,s2
    80002640:	8526                	mv	a0,s1
    80002642:	475000ef          	jal	800032b6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002646:	08848493          	addi	s1,s1,136
    8000264a:	ff349ae3          	bne	s1,s3,8000263e <iinit+0x3a>
}
    8000264e:	70a2                	ld	ra,40(sp)
    80002650:	7402                	ld	s0,32(sp)
    80002652:	64e2                	ld	s1,24(sp)
    80002654:	6942                	ld	s2,16(sp)
    80002656:	69a2                	ld	s3,8(sp)
    80002658:	6145                	addi	sp,sp,48
    8000265a:	8082                	ret

000000008000265c <ialloc>:
{
    8000265c:	7139                	addi	sp,sp,-64
    8000265e:	fc06                	sd	ra,56(sp)
    80002660:	f822                	sd	s0,48(sp)
    80002662:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002664:	00016717          	auipc	a4,0x16
    80002668:	5b072703          	lw	a4,1456(a4) # 80018c14 <sb+0xc>
    8000266c:	4785                	li	a5,1
    8000266e:	06e7f063          	bgeu	a5,a4,800026ce <ialloc+0x72>
    80002672:	f426                	sd	s1,40(sp)
    80002674:	f04a                	sd	s2,32(sp)
    80002676:	ec4e                	sd	s3,24(sp)
    80002678:	e852                	sd	s4,16(sp)
    8000267a:	e456                	sd	s5,8(sp)
    8000267c:	e05a                	sd	s6,0(sp)
    8000267e:	8aaa                	mv	s5,a0
    80002680:	8b2e                	mv	s6,a1
    80002682:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002684:	00016a17          	auipc	s4,0x16
    80002688:	584a0a13          	addi	s4,s4,1412 # 80018c08 <sb>
    8000268c:	00495593          	srli	a1,s2,0x4
    80002690:	018a2783          	lw	a5,24(s4)
    80002694:	9dbd                	addw	a1,a1,a5
    80002696:	8556                	mv	a0,s5
    80002698:	9fdff0ef          	jal	80002094 <bread>
    8000269c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000269e:	05850993          	addi	s3,a0,88
    800026a2:	00f97793          	andi	a5,s2,15
    800026a6:	079a                	slli	a5,a5,0x6
    800026a8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800026aa:	00099783          	lh	a5,0(s3)
    800026ae:	cb9d                	beqz	a5,800026e4 <ialloc+0x88>
    brelse(bp);
    800026b0:	aedff0ef          	jal	8000219c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800026b4:	0905                	addi	s2,s2,1
    800026b6:	00ca2703          	lw	a4,12(s4)
    800026ba:	0009079b          	sext.w	a5,s2
    800026be:	fce7e7e3          	bltu	a5,a4,8000268c <ialloc+0x30>
    800026c2:	74a2                	ld	s1,40(sp)
    800026c4:	7902                	ld	s2,32(sp)
    800026c6:	69e2                	ld	s3,24(sp)
    800026c8:	6a42                	ld	s4,16(sp)
    800026ca:	6aa2                	ld	s5,8(sp)
    800026cc:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800026ce:	00005517          	auipc	a0,0x5
    800026d2:	e9a50513          	addi	a0,a0,-358 # 80007568 <etext+0x568>
    800026d6:	42b020ef          	jal	80005300 <printf>
  return 0;
    800026da:	4501                	li	a0,0
}
    800026dc:	70e2                	ld	ra,56(sp)
    800026de:	7442                	ld	s0,48(sp)
    800026e0:	6121                	addi	sp,sp,64
    800026e2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800026e4:	04000613          	li	a2,64
    800026e8:	4581                	li	a1,0
    800026ea:	854e                	mv	a0,s3
    800026ec:	aa5fd0ef          	jal	80000190 <memset>
      dip->type = type;
    800026f0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800026f4:	8526                	mv	a0,s1
    800026f6:	2f1000ef          	jal	800031e6 <log_write>
      brelse(bp);
    800026fa:	8526                	mv	a0,s1
    800026fc:	aa1ff0ef          	jal	8000219c <brelse>
      return iget(dev, inum);
    80002700:	0009059b          	sext.w	a1,s2
    80002704:	8556                	mv	a0,s5
    80002706:	de7ff0ef          	jal	800024ec <iget>
    8000270a:	74a2                	ld	s1,40(sp)
    8000270c:	7902                	ld	s2,32(sp)
    8000270e:	69e2                	ld	s3,24(sp)
    80002710:	6a42                	ld	s4,16(sp)
    80002712:	6aa2                	ld	s5,8(sp)
    80002714:	6b02                	ld	s6,0(sp)
    80002716:	b7d9                	j	800026dc <ialloc+0x80>

0000000080002718 <iupdate>:
{
    80002718:	1101                	addi	sp,sp,-32
    8000271a:	ec06                	sd	ra,24(sp)
    8000271c:	e822                	sd	s0,16(sp)
    8000271e:	e426                	sd	s1,8(sp)
    80002720:	e04a                	sd	s2,0(sp)
    80002722:	1000                	addi	s0,sp,32
    80002724:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002726:	415c                	lw	a5,4(a0)
    80002728:	0047d79b          	srliw	a5,a5,0x4
    8000272c:	00016597          	auipc	a1,0x16
    80002730:	4f45a583          	lw	a1,1268(a1) # 80018c20 <sb+0x18>
    80002734:	9dbd                	addw	a1,a1,a5
    80002736:	4108                	lw	a0,0(a0)
    80002738:	95dff0ef          	jal	80002094 <bread>
    8000273c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000273e:	05850793          	addi	a5,a0,88
    80002742:	40d8                	lw	a4,4(s1)
    80002744:	8b3d                	andi	a4,a4,15
    80002746:	071a                	slli	a4,a4,0x6
    80002748:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000274a:	04449703          	lh	a4,68(s1)
    8000274e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002752:	04649703          	lh	a4,70(s1)
    80002756:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000275a:	04849703          	lh	a4,72(s1)
    8000275e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002762:	04a49703          	lh	a4,74(s1)
    80002766:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000276a:	44f8                	lw	a4,76(s1)
    8000276c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000276e:	03400613          	li	a2,52
    80002772:	05048593          	addi	a1,s1,80
    80002776:	00c78513          	addi	a0,a5,12
    8000277a:	a73fd0ef          	jal	800001ec <memmove>
  log_write(bp);
    8000277e:	854a                	mv	a0,s2
    80002780:	267000ef          	jal	800031e6 <log_write>
  brelse(bp);
    80002784:	854a                	mv	a0,s2
    80002786:	a17ff0ef          	jal	8000219c <brelse>
}
    8000278a:	60e2                	ld	ra,24(sp)
    8000278c:	6442                	ld	s0,16(sp)
    8000278e:	64a2                	ld	s1,8(sp)
    80002790:	6902                	ld	s2,0(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret

0000000080002796 <idup>:
{
    80002796:	1101                	addi	sp,sp,-32
    80002798:	ec06                	sd	ra,24(sp)
    8000279a:	e822                	sd	s0,16(sp)
    8000279c:	e426                	sd	s1,8(sp)
    8000279e:	1000                	addi	s0,sp,32
    800027a0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027a2:	00016517          	auipc	a0,0x16
    800027a6:	48650513          	addi	a0,a0,1158 # 80018c28 <itable>
    800027aa:	156030ef          	jal	80005900 <acquire>
  ip->ref++;
    800027ae:	449c                	lw	a5,8(s1)
    800027b0:	2785                	addiw	a5,a5,1
    800027b2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027b4:	00016517          	auipc	a0,0x16
    800027b8:	47450513          	addi	a0,a0,1140 # 80018c28 <itable>
    800027bc:	1dc030ef          	jal	80005998 <release>
}
    800027c0:	8526                	mv	a0,s1
    800027c2:	60e2                	ld	ra,24(sp)
    800027c4:	6442                	ld	s0,16(sp)
    800027c6:	64a2                	ld	s1,8(sp)
    800027c8:	6105                	addi	sp,sp,32
    800027ca:	8082                	ret

00000000800027cc <ilock>:
{
    800027cc:	1101                	addi	sp,sp,-32
    800027ce:	ec06                	sd	ra,24(sp)
    800027d0:	e822                	sd	s0,16(sp)
    800027d2:	e426                	sd	s1,8(sp)
    800027d4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800027d6:	cd19                	beqz	a0,800027f4 <ilock+0x28>
    800027d8:	84aa                	mv	s1,a0
    800027da:	451c                	lw	a5,8(a0)
    800027dc:	00f05c63          	blez	a5,800027f4 <ilock+0x28>
  acquiresleep(&ip->lock);
    800027e0:	0541                	addi	a0,a0,16
    800027e2:	30b000ef          	jal	800032ec <acquiresleep>
  if(ip->valid == 0){
    800027e6:	40bc                	lw	a5,64(s1)
    800027e8:	cf89                	beqz	a5,80002802 <ilock+0x36>
}
    800027ea:	60e2                	ld	ra,24(sp)
    800027ec:	6442                	ld	s0,16(sp)
    800027ee:	64a2                	ld	s1,8(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret
    800027f4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027f6:	00005517          	auipc	a0,0x5
    800027fa:	d8a50513          	addi	a0,a0,-630 # 80007580 <etext+0x580>
    800027fe:	5d5020ef          	jal	800055d2 <panic>
    80002802:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002804:	40dc                	lw	a5,4(s1)
    80002806:	0047d79b          	srliw	a5,a5,0x4
    8000280a:	00016597          	auipc	a1,0x16
    8000280e:	4165a583          	lw	a1,1046(a1) # 80018c20 <sb+0x18>
    80002812:	9dbd                	addw	a1,a1,a5
    80002814:	4088                	lw	a0,0(s1)
    80002816:	87fff0ef          	jal	80002094 <bread>
    8000281a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000281c:	05850593          	addi	a1,a0,88
    80002820:	40dc                	lw	a5,4(s1)
    80002822:	8bbd                	andi	a5,a5,15
    80002824:	079a                	slli	a5,a5,0x6
    80002826:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002828:	00059783          	lh	a5,0(a1)
    8000282c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002830:	00259783          	lh	a5,2(a1)
    80002834:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002838:	00459783          	lh	a5,4(a1)
    8000283c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002840:	00659783          	lh	a5,6(a1)
    80002844:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002848:	459c                	lw	a5,8(a1)
    8000284a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000284c:	03400613          	li	a2,52
    80002850:	05b1                	addi	a1,a1,12
    80002852:	05048513          	addi	a0,s1,80
    80002856:	997fd0ef          	jal	800001ec <memmove>
    brelse(bp);
    8000285a:	854a                	mv	a0,s2
    8000285c:	941ff0ef          	jal	8000219c <brelse>
    ip->valid = 1;
    80002860:	4785                	li	a5,1
    80002862:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002864:	04449783          	lh	a5,68(s1)
    80002868:	c399                	beqz	a5,8000286e <ilock+0xa2>
    8000286a:	6902                	ld	s2,0(sp)
    8000286c:	bfbd                	j	800027ea <ilock+0x1e>
      panic("ilock: no type");
    8000286e:	00005517          	auipc	a0,0x5
    80002872:	d1a50513          	addi	a0,a0,-742 # 80007588 <etext+0x588>
    80002876:	55d020ef          	jal	800055d2 <panic>

000000008000287a <iunlock>:
{
    8000287a:	1101                	addi	sp,sp,-32
    8000287c:	ec06                	sd	ra,24(sp)
    8000287e:	e822                	sd	s0,16(sp)
    80002880:	e426                	sd	s1,8(sp)
    80002882:	e04a                	sd	s2,0(sp)
    80002884:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002886:	c505                	beqz	a0,800028ae <iunlock+0x34>
    80002888:	84aa                	mv	s1,a0
    8000288a:	01050913          	addi	s2,a0,16
    8000288e:	854a                	mv	a0,s2
    80002890:	2db000ef          	jal	8000336a <holdingsleep>
    80002894:	cd09                	beqz	a0,800028ae <iunlock+0x34>
    80002896:	449c                	lw	a5,8(s1)
    80002898:	00f05b63          	blez	a5,800028ae <iunlock+0x34>
  releasesleep(&ip->lock);
    8000289c:	854a                	mv	a0,s2
    8000289e:	295000ef          	jal	80003332 <releasesleep>
}
    800028a2:	60e2                	ld	ra,24(sp)
    800028a4:	6442                	ld	s0,16(sp)
    800028a6:	64a2                	ld	s1,8(sp)
    800028a8:	6902                	ld	s2,0(sp)
    800028aa:	6105                	addi	sp,sp,32
    800028ac:	8082                	ret
    panic("iunlock");
    800028ae:	00005517          	auipc	a0,0x5
    800028b2:	cea50513          	addi	a0,a0,-790 # 80007598 <etext+0x598>
    800028b6:	51d020ef          	jal	800055d2 <panic>

00000000800028ba <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	1800                	addi	s0,sp,48
    800028c8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800028ca:	05050493          	addi	s1,a0,80
    800028ce:	08050913          	addi	s2,a0,128
    800028d2:	a021                	j	800028da <itrunc+0x20>
    800028d4:	0491                	addi	s1,s1,4
    800028d6:	01248b63          	beq	s1,s2,800028ec <itrunc+0x32>
    if(ip->addrs[i]){
    800028da:	408c                	lw	a1,0(s1)
    800028dc:	dde5                	beqz	a1,800028d4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800028de:	0009a503          	lw	a0,0(s3)
    800028e2:	9abff0ef          	jal	8000228c <bfree>
      ip->addrs[i] = 0;
    800028e6:	0004a023          	sw	zero,0(s1)
    800028ea:	b7ed                	j	800028d4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800028ec:	0809a583          	lw	a1,128(s3)
    800028f0:	ed89                	bnez	a1,8000290a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800028f2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800028f6:	854e                	mv	a0,s3
    800028f8:	e21ff0ef          	jal	80002718 <iupdate>
}
    800028fc:	70a2                	ld	ra,40(sp)
    800028fe:	7402                	ld	s0,32(sp)
    80002900:	64e2                	ld	s1,24(sp)
    80002902:	6942                	ld	s2,16(sp)
    80002904:	69a2                	ld	s3,8(sp)
    80002906:	6145                	addi	sp,sp,48
    80002908:	8082                	ret
    8000290a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000290c:	0009a503          	lw	a0,0(s3)
    80002910:	f84ff0ef          	jal	80002094 <bread>
    80002914:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002916:	05850493          	addi	s1,a0,88
    8000291a:	45850913          	addi	s2,a0,1112
    8000291e:	a021                	j	80002926 <itrunc+0x6c>
    80002920:	0491                	addi	s1,s1,4
    80002922:	01248963          	beq	s1,s2,80002934 <itrunc+0x7a>
      if(a[j])
    80002926:	408c                	lw	a1,0(s1)
    80002928:	dde5                	beqz	a1,80002920 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000292a:	0009a503          	lw	a0,0(s3)
    8000292e:	95fff0ef          	jal	8000228c <bfree>
    80002932:	b7fd                	j	80002920 <itrunc+0x66>
    brelse(bp);
    80002934:	8552                	mv	a0,s4
    80002936:	867ff0ef          	jal	8000219c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000293a:	0809a583          	lw	a1,128(s3)
    8000293e:	0009a503          	lw	a0,0(s3)
    80002942:	94bff0ef          	jal	8000228c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002946:	0809a023          	sw	zero,128(s3)
    8000294a:	6a02                	ld	s4,0(sp)
    8000294c:	b75d                	j	800028f2 <itrunc+0x38>

000000008000294e <iput>:
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	e426                	sd	s1,8(sp)
    80002956:	1000                	addi	s0,sp,32
    80002958:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000295a:	00016517          	auipc	a0,0x16
    8000295e:	2ce50513          	addi	a0,a0,718 # 80018c28 <itable>
    80002962:	79f020ef          	jal	80005900 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002966:	4498                	lw	a4,8(s1)
    80002968:	4785                	li	a5,1
    8000296a:	02f70063          	beq	a4,a5,8000298a <iput+0x3c>
  ip->ref--;
    8000296e:	449c                	lw	a5,8(s1)
    80002970:	37fd                	addiw	a5,a5,-1
    80002972:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002974:	00016517          	auipc	a0,0x16
    80002978:	2b450513          	addi	a0,a0,692 # 80018c28 <itable>
    8000297c:	01c030ef          	jal	80005998 <release>
}
    80002980:	60e2                	ld	ra,24(sp)
    80002982:	6442                	ld	s0,16(sp)
    80002984:	64a2                	ld	s1,8(sp)
    80002986:	6105                	addi	sp,sp,32
    80002988:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000298a:	40bc                	lw	a5,64(s1)
    8000298c:	d3ed                	beqz	a5,8000296e <iput+0x20>
    8000298e:	04a49783          	lh	a5,74(s1)
    80002992:	fff1                	bnez	a5,8000296e <iput+0x20>
    80002994:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002996:	01048913          	addi	s2,s1,16
    8000299a:	854a                	mv	a0,s2
    8000299c:	151000ef          	jal	800032ec <acquiresleep>
    release(&itable.lock);
    800029a0:	00016517          	auipc	a0,0x16
    800029a4:	28850513          	addi	a0,a0,648 # 80018c28 <itable>
    800029a8:	7f1020ef          	jal	80005998 <release>
    itrunc(ip);
    800029ac:	8526                	mv	a0,s1
    800029ae:	f0dff0ef          	jal	800028ba <itrunc>
    ip->type = 0;
    800029b2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800029b6:	8526                	mv	a0,s1
    800029b8:	d61ff0ef          	jal	80002718 <iupdate>
    ip->valid = 0;
    800029bc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800029c0:	854a                	mv	a0,s2
    800029c2:	171000ef          	jal	80003332 <releasesleep>
    acquire(&itable.lock);
    800029c6:	00016517          	auipc	a0,0x16
    800029ca:	26250513          	addi	a0,a0,610 # 80018c28 <itable>
    800029ce:	733020ef          	jal	80005900 <acquire>
    800029d2:	6902                	ld	s2,0(sp)
    800029d4:	bf69                	j	8000296e <iput+0x20>

00000000800029d6 <iunlockput>:
{
    800029d6:	1101                	addi	sp,sp,-32
    800029d8:	ec06                	sd	ra,24(sp)
    800029da:	e822                	sd	s0,16(sp)
    800029dc:	e426                	sd	s1,8(sp)
    800029de:	1000                	addi	s0,sp,32
    800029e0:	84aa                	mv	s1,a0
  iunlock(ip);
    800029e2:	e99ff0ef          	jal	8000287a <iunlock>
  iput(ip);
    800029e6:	8526                	mv	a0,s1
    800029e8:	f67ff0ef          	jal	8000294e <iput>
}
    800029ec:	60e2                	ld	ra,24(sp)
    800029ee:	6442                	ld	s0,16(sp)
    800029f0:	64a2                	ld	s1,8(sp)
    800029f2:	6105                	addi	sp,sp,32
    800029f4:	8082                	ret

00000000800029f6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029f6:	1141                	addi	sp,sp,-16
    800029f8:	e422                	sd	s0,8(sp)
    800029fa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029fc:	411c                	lw	a5,0(a0)
    800029fe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a00:	415c                	lw	a5,4(a0)
    80002a02:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a04:	04451783          	lh	a5,68(a0)
    80002a08:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a0c:	04a51783          	lh	a5,74(a0)
    80002a10:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a14:	04c56783          	lwu	a5,76(a0)
    80002a18:	e99c                	sd	a5,16(a1)
}
    80002a1a:	6422                	ld	s0,8(sp)
    80002a1c:	0141                	addi	sp,sp,16
    80002a1e:	8082                	ret

0000000080002a20 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a20:	457c                	lw	a5,76(a0)
    80002a22:	0ed7eb63          	bltu	a5,a3,80002b18 <readi+0xf8>
{
    80002a26:	7159                	addi	sp,sp,-112
    80002a28:	f486                	sd	ra,104(sp)
    80002a2a:	f0a2                	sd	s0,96(sp)
    80002a2c:	eca6                	sd	s1,88(sp)
    80002a2e:	e0d2                	sd	s4,64(sp)
    80002a30:	fc56                	sd	s5,56(sp)
    80002a32:	f85a                	sd	s6,48(sp)
    80002a34:	f45e                	sd	s7,40(sp)
    80002a36:	1880                	addi	s0,sp,112
    80002a38:	8b2a                	mv	s6,a0
    80002a3a:	8bae                	mv	s7,a1
    80002a3c:	8a32                	mv	s4,a2
    80002a3e:	84b6                	mv	s1,a3
    80002a40:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a42:	9f35                	addw	a4,a4,a3
    return 0;
    80002a44:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a46:	0cd76063          	bltu	a4,a3,80002b06 <readi+0xe6>
    80002a4a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a4c:	00e7f463          	bgeu	a5,a4,80002a54 <readi+0x34>
    n = ip->size - off;
    80002a50:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a54:	080a8f63          	beqz	s5,80002af2 <readi+0xd2>
    80002a58:	e8ca                	sd	s2,80(sp)
    80002a5a:	f062                	sd	s8,32(sp)
    80002a5c:	ec66                	sd	s9,24(sp)
    80002a5e:	e86a                	sd	s10,16(sp)
    80002a60:	e46e                	sd	s11,8(sp)
    80002a62:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a64:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a68:	5c7d                	li	s8,-1
    80002a6a:	a80d                	j	80002a9c <readi+0x7c>
    80002a6c:	020d1d93          	slli	s11,s10,0x20
    80002a70:	020ddd93          	srli	s11,s11,0x20
    80002a74:	05890613          	addi	a2,s2,88
    80002a78:	86ee                	mv	a3,s11
    80002a7a:	963a                	add	a2,a2,a4
    80002a7c:	85d2                	mv	a1,s4
    80002a7e:	855e                	mv	a0,s7
    80002a80:	c5bfe0ef          	jal	800016da <either_copyout>
    80002a84:	05850763          	beq	a0,s8,80002ad2 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a88:	854a                	mv	a0,s2
    80002a8a:	f12ff0ef          	jal	8000219c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a8e:	013d09bb          	addw	s3,s10,s3
    80002a92:	009d04bb          	addw	s1,s10,s1
    80002a96:	9a6e                	add	s4,s4,s11
    80002a98:	0559f763          	bgeu	s3,s5,80002ae6 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a9c:	00a4d59b          	srliw	a1,s1,0xa
    80002aa0:	855a                	mv	a0,s6
    80002aa2:	977ff0ef          	jal	80002418 <bmap>
    80002aa6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002aaa:	c5b1                	beqz	a1,80002af6 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002aac:	000b2503          	lw	a0,0(s6)
    80002ab0:	de4ff0ef          	jal	80002094 <bread>
    80002ab4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ab6:	3ff4f713          	andi	a4,s1,1023
    80002aba:	40ec87bb          	subw	a5,s9,a4
    80002abe:	413a86bb          	subw	a3,s5,s3
    80002ac2:	8d3e                	mv	s10,a5
    80002ac4:	2781                	sext.w	a5,a5
    80002ac6:	0006861b          	sext.w	a2,a3
    80002aca:	faf671e3          	bgeu	a2,a5,80002a6c <readi+0x4c>
    80002ace:	8d36                	mv	s10,a3
    80002ad0:	bf71                	j	80002a6c <readi+0x4c>
      brelse(bp);
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	ec8ff0ef          	jal	8000219c <brelse>
      tot = -1;
    80002ad8:	59fd                	li	s3,-1
      break;
    80002ada:	6946                	ld	s2,80(sp)
    80002adc:	7c02                	ld	s8,32(sp)
    80002ade:	6ce2                	ld	s9,24(sp)
    80002ae0:	6d42                	ld	s10,16(sp)
    80002ae2:	6da2                	ld	s11,8(sp)
    80002ae4:	a831                	j	80002b00 <readi+0xe0>
    80002ae6:	6946                	ld	s2,80(sp)
    80002ae8:	7c02                	ld	s8,32(sp)
    80002aea:	6ce2                	ld	s9,24(sp)
    80002aec:	6d42                	ld	s10,16(sp)
    80002aee:	6da2                	ld	s11,8(sp)
    80002af0:	a801                	j	80002b00 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002af2:	89d6                	mv	s3,s5
    80002af4:	a031                	j	80002b00 <readi+0xe0>
    80002af6:	6946                	ld	s2,80(sp)
    80002af8:	7c02                	ld	s8,32(sp)
    80002afa:	6ce2                	ld	s9,24(sp)
    80002afc:	6d42                	ld	s10,16(sp)
    80002afe:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b00:	0009851b          	sext.w	a0,s3
    80002b04:	69a6                	ld	s3,72(sp)
}
    80002b06:	70a6                	ld	ra,104(sp)
    80002b08:	7406                	ld	s0,96(sp)
    80002b0a:	64e6                	ld	s1,88(sp)
    80002b0c:	6a06                	ld	s4,64(sp)
    80002b0e:	7ae2                	ld	s5,56(sp)
    80002b10:	7b42                	ld	s6,48(sp)
    80002b12:	7ba2                	ld	s7,40(sp)
    80002b14:	6165                	addi	sp,sp,112
    80002b16:	8082                	ret
    return 0;
    80002b18:	4501                	li	a0,0
}
    80002b1a:	8082                	ret

0000000080002b1c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b1c:	457c                	lw	a5,76(a0)
    80002b1e:	10d7e063          	bltu	a5,a3,80002c1e <writei+0x102>
{
    80002b22:	7159                	addi	sp,sp,-112
    80002b24:	f486                	sd	ra,104(sp)
    80002b26:	f0a2                	sd	s0,96(sp)
    80002b28:	e8ca                	sd	s2,80(sp)
    80002b2a:	e0d2                	sd	s4,64(sp)
    80002b2c:	fc56                	sd	s5,56(sp)
    80002b2e:	f85a                	sd	s6,48(sp)
    80002b30:	f45e                	sd	s7,40(sp)
    80002b32:	1880                	addi	s0,sp,112
    80002b34:	8aaa                	mv	s5,a0
    80002b36:	8bae                	mv	s7,a1
    80002b38:	8a32                	mv	s4,a2
    80002b3a:	8936                	mv	s2,a3
    80002b3c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b3e:	00e687bb          	addw	a5,a3,a4
    80002b42:	0ed7e063          	bltu	a5,a3,80002c22 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b46:	00043737          	lui	a4,0x43
    80002b4a:	0cf76e63          	bltu	a4,a5,80002c26 <writei+0x10a>
    80002b4e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b50:	0a0b0f63          	beqz	s6,80002c0e <writei+0xf2>
    80002b54:	eca6                	sd	s1,88(sp)
    80002b56:	f062                	sd	s8,32(sp)
    80002b58:	ec66                	sd	s9,24(sp)
    80002b5a:	e86a                	sd	s10,16(sp)
    80002b5c:	e46e                	sd	s11,8(sp)
    80002b5e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b60:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b64:	5c7d                	li	s8,-1
    80002b66:	a825                	j	80002b9e <writei+0x82>
    80002b68:	020d1d93          	slli	s11,s10,0x20
    80002b6c:	020ddd93          	srli	s11,s11,0x20
    80002b70:	05848513          	addi	a0,s1,88
    80002b74:	86ee                	mv	a3,s11
    80002b76:	8652                	mv	a2,s4
    80002b78:	85de                	mv	a1,s7
    80002b7a:	953a                	add	a0,a0,a4
    80002b7c:	ba9fe0ef          	jal	80001724 <either_copyin>
    80002b80:	05850a63          	beq	a0,s8,80002bd4 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b84:	8526                	mv	a0,s1
    80002b86:	660000ef          	jal	800031e6 <log_write>
    brelse(bp);
    80002b8a:	8526                	mv	a0,s1
    80002b8c:	e10ff0ef          	jal	8000219c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b90:	013d09bb          	addw	s3,s10,s3
    80002b94:	012d093b          	addw	s2,s10,s2
    80002b98:	9a6e                	add	s4,s4,s11
    80002b9a:	0569f063          	bgeu	s3,s6,80002bda <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b9e:	00a9559b          	srliw	a1,s2,0xa
    80002ba2:	8556                	mv	a0,s5
    80002ba4:	875ff0ef          	jal	80002418 <bmap>
    80002ba8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bac:	c59d                	beqz	a1,80002bda <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bae:	000aa503          	lw	a0,0(s5)
    80002bb2:	ce2ff0ef          	jal	80002094 <bread>
    80002bb6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bb8:	3ff97713          	andi	a4,s2,1023
    80002bbc:	40ec87bb          	subw	a5,s9,a4
    80002bc0:	413b06bb          	subw	a3,s6,s3
    80002bc4:	8d3e                	mv	s10,a5
    80002bc6:	2781                	sext.w	a5,a5
    80002bc8:	0006861b          	sext.w	a2,a3
    80002bcc:	f8f67ee3          	bgeu	a2,a5,80002b68 <writei+0x4c>
    80002bd0:	8d36                	mv	s10,a3
    80002bd2:	bf59                	j	80002b68 <writei+0x4c>
      brelse(bp);
    80002bd4:	8526                	mv	a0,s1
    80002bd6:	dc6ff0ef          	jal	8000219c <brelse>
  }

  if(off > ip->size)
    80002bda:	04caa783          	lw	a5,76(s5)
    80002bde:	0327fa63          	bgeu	a5,s2,80002c12 <writei+0xf6>
    ip->size = off;
    80002be2:	052aa623          	sw	s2,76(s5)
    80002be6:	64e6                	ld	s1,88(sp)
    80002be8:	7c02                	ld	s8,32(sp)
    80002bea:	6ce2                	ld	s9,24(sp)
    80002bec:	6d42                	ld	s10,16(sp)
    80002bee:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bf0:	8556                	mv	a0,s5
    80002bf2:	b27ff0ef          	jal	80002718 <iupdate>

  return tot;
    80002bf6:	0009851b          	sext.w	a0,s3
    80002bfa:	69a6                	ld	s3,72(sp)
}
    80002bfc:	70a6                	ld	ra,104(sp)
    80002bfe:	7406                	ld	s0,96(sp)
    80002c00:	6946                	ld	s2,80(sp)
    80002c02:	6a06                	ld	s4,64(sp)
    80002c04:	7ae2                	ld	s5,56(sp)
    80002c06:	7b42                	ld	s6,48(sp)
    80002c08:	7ba2                	ld	s7,40(sp)
    80002c0a:	6165                	addi	sp,sp,112
    80002c0c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c0e:	89da                	mv	s3,s6
    80002c10:	b7c5                	j	80002bf0 <writei+0xd4>
    80002c12:	64e6                	ld	s1,88(sp)
    80002c14:	7c02                	ld	s8,32(sp)
    80002c16:	6ce2                	ld	s9,24(sp)
    80002c18:	6d42                	ld	s10,16(sp)
    80002c1a:	6da2                	ld	s11,8(sp)
    80002c1c:	bfd1                	j	80002bf0 <writei+0xd4>
    return -1;
    80002c1e:	557d                	li	a0,-1
}
    80002c20:	8082                	ret
    return -1;
    80002c22:	557d                	li	a0,-1
    80002c24:	bfe1                	j	80002bfc <writei+0xe0>
    return -1;
    80002c26:	557d                	li	a0,-1
    80002c28:	bfd1                	j	80002bfc <writei+0xe0>

0000000080002c2a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c2a:	1141                	addi	sp,sp,-16
    80002c2c:	e406                	sd	ra,8(sp)
    80002c2e:	e022                	sd	s0,0(sp)
    80002c30:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c32:	4639                	li	a2,14
    80002c34:	e28fd0ef          	jal	8000025c <strncmp>
}
    80002c38:	60a2                	ld	ra,8(sp)
    80002c3a:	6402                	ld	s0,0(sp)
    80002c3c:	0141                	addi	sp,sp,16
    80002c3e:	8082                	ret

0000000080002c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c40:	7139                	addi	sp,sp,-64
    80002c42:	fc06                	sd	ra,56(sp)
    80002c44:	f822                	sd	s0,48(sp)
    80002c46:	f426                	sd	s1,40(sp)
    80002c48:	f04a                	sd	s2,32(sp)
    80002c4a:	ec4e                	sd	s3,24(sp)
    80002c4c:	e852                	sd	s4,16(sp)
    80002c4e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c50:	04451703          	lh	a4,68(a0)
    80002c54:	4785                	li	a5,1
    80002c56:	00f71a63          	bne	a4,a5,80002c6a <dirlookup+0x2a>
    80002c5a:	892a                	mv	s2,a0
    80002c5c:	89ae                	mv	s3,a1
    80002c5e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c60:	457c                	lw	a5,76(a0)
    80002c62:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c64:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c66:	e39d                	bnez	a5,80002c8c <dirlookup+0x4c>
    80002c68:	a095                	j	80002ccc <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c6a:	00005517          	auipc	a0,0x5
    80002c6e:	93650513          	addi	a0,a0,-1738 # 800075a0 <etext+0x5a0>
    80002c72:	161020ef          	jal	800055d2 <panic>
      panic("dirlookup read");
    80002c76:	00005517          	auipc	a0,0x5
    80002c7a:	94250513          	addi	a0,a0,-1726 # 800075b8 <etext+0x5b8>
    80002c7e:	155020ef          	jal	800055d2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c82:	24c1                	addiw	s1,s1,16
    80002c84:	04c92783          	lw	a5,76(s2)
    80002c88:	04f4f163          	bgeu	s1,a5,80002cca <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c8c:	4741                	li	a4,16
    80002c8e:	86a6                	mv	a3,s1
    80002c90:	fc040613          	addi	a2,s0,-64
    80002c94:	4581                	li	a1,0
    80002c96:	854a                	mv	a0,s2
    80002c98:	d89ff0ef          	jal	80002a20 <readi>
    80002c9c:	47c1                	li	a5,16
    80002c9e:	fcf51ce3          	bne	a0,a5,80002c76 <dirlookup+0x36>
    if(de.inum == 0)
    80002ca2:	fc045783          	lhu	a5,-64(s0)
    80002ca6:	dff1                	beqz	a5,80002c82 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002ca8:	fc240593          	addi	a1,s0,-62
    80002cac:	854e                	mv	a0,s3
    80002cae:	f7dff0ef          	jal	80002c2a <namecmp>
    80002cb2:	f961                	bnez	a0,80002c82 <dirlookup+0x42>
      if(poff)
    80002cb4:	000a0463          	beqz	s4,80002cbc <dirlookup+0x7c>
        *poff = off;
    80002cb8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002cbc:	fc045583          	lhu	a1,-64(s0)
    80002cc0:	00092503          	lw	a0,0(s2)
    80002cc4:	829ff0ef          	jal	800024ec <iget>
    80002cc8:	a011                	j	80002ccc <dirlookup+0x8c>
  return 0;
    80002cca:	4501                	li	a0,0
}
    80002ccc:	70e2                	ld	ra,56(sp)
    80002cce:	7442                	ld	s0,48(sp)
    80002cd0:	74a2                	ld	s1,40(sp)
    80002cd2:	7902                	ld	s2,32(sp)
    80002cd4:	69e2                	ld	s3,24(sp)
    80002cd6:	6a42                	ld	s4,16(sp)
    80002cd8:	6121                	addi	sp,sp,64
    80002cda:	8082                	ret

0000000080002cdc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002cdc:	711d                	addi	sp,sp,-96
    80002cde:	ec86                	sd	ra,88(sp)
    80002ce0:	e8a2                	sd	s0,80(sp)
    80002ce2:	e4a6                	sd	s1,72(sp)
    80002ce4:	e0ca                	sd	s2,64(sp)
    80002ce6:	fc4e                	sd	s3,56(sp)
    80002ce8:	f852                	sd	s4,48(sp)
    80002cea:	f456                	sd	s5,40(sp)
    80002cec:	f05a                	sd	s6,32(sp)
    80002cee:	ec5e                	sd	s7,24(sp)
    80002cf0:	e862                	sd	s8,16(sp)
    80002cf2:	e466                	sd	s9,8(sp)
    80002cf4:	1080                	addi	s0,sp,96
    80002cf6:	84aa                	mv	s1,a0
    80002cf8:	8b2e                	mv	s6,a1
    80002cfa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cfc:	00054703          	lbu	a4,0(a0)
    80002d00:	02f00793          	li	a5,47
    80002d04:	00f70e63          	beq	a4,a5,80002d20 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d08:	8a0fe0ef          	jal	80000da8 <myproc>
    80002d0c:	15053503          	ld	a0,336(a0)
    80002d10:	a87ff0ef          	jal	80002796 <idup>
    80002d14:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d16:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d1a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d1c:	4b85                	li	s7,1
    80002d1e:	a871                	j	80002dba <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d20:	4585                	li	a1,1
    80002d22:	4505                	li	a0,1
    80002d24:	fc8ff0ef          	jal	800024ec <iget>
    80002d28:	8a2a                	mv	s4,a0
    80002d2a:	b7f5                	j	80002d16 <namex+0x3a>
      iunlockput(ip);
    80002d2c:	8552                	mv	a0,s4
    80002d2e:	ca9ff0ef          	jal	800029d6 <iunlockput>
      return 0;
    80002d32:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d34:	8552                	mv	a0,s4
    80002d36:	60e6                	ld	ra,88(sp)
    80002d38:	6446                	ld	s0,80(sp)
    80002d3a:	64a6                	ld	s1,72(sp)
    80002d3c:	6906                	ld	s2,64(sp)
    80002d3e:	79e2                	ld	s3,56(sp)
    80002d40:	7a42                	ld	s4,48(sp)
    80002d42:	7aa2                	ld	s5,40(sp)
    80002d44:	7b02                	ld	s6,32(sp)
    80002d46:	6be2                	ld	s7,24(sp)
    80002d48:	6c42                	ld	s8,16(sp)
    80002d4a:	6ca2                	ld	s9,8(sp)
    80002d4c:	6125                	addi	sp,sp,96
    80002d4e:	8082                	ret
      iunlock(ip);
    80002d50:	8552                	mv	a0,s4
    80002d52:	b29ff0ef          	jal	8000287a <iunlock>
      return ip;
    80002d56:	bff9                	j	80002d34 <namex+0x58>
      iunlockput(ip);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	c7dff0ef          	jal	800029d6 <iunlockput>
      return 0;
    80002d5e:	8a4e                	mv	s4,s3
    80002d60:	bfd1                	j	80002d34 <namex+0x58>
  len = path - s;
    80002d62:	40998633          	sub	a2,s3,s1
    80002d66:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d6a:	099c5063          	bge	s8,s9,80002dea <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d6e:	4639                	li	a2,14
    80002d70:	85a6                	mv	a1,s1
    80002d72:	8556                	mv	a0,s5
    80002d74:	c78fd0ef          	jal	800001ec <memmove>
    80002d78:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d7a:	0004c783          	lbu	a5,0(s1)
    80002d7e:	01279763          	bne	a5,s2,80002d8c <namex+0xb0>
    path++;
    80002d82:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d84:	0004c783          	lbu	a5,0(s1)
    80002d88:	ff278de3          	beq	a5,s2,80002d82 <namex+0xa6>
    ilock(ip);
    80002d8c:	8552                	mv	a0,s4
    80002d8e:	a3fff0ef          	jal	800027cc <ilock>
    if(ip->type != T_DIR){
    80002d92:	044a1783          	lh	a5,68(s4)
    80002d96:	f9779be3          	bne	a5,s7,80002d2c <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d9a:	000b0563          	beqz	s6,80002da4 <namex+0xc8>
    80002d9e:	0004c783          	lbu	a5,0(s1)
    80002da2:	d7dd                	beqz	a5,80002d50 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002da4:	4601                	li	a2,0
    80002da6:	85d6                	mv	a1,s5
    80002da8:	8552                	mv	a0,s4
    80002daa:	e97ff0ef          	jal	80002c40 <dirlookup>
    80002dae:	89aa                	mv	s3,a0
    80002db0:	d545                	beqz	a0,80002d58 <namex+0x7c>
    iunlockput(ip);
    80002db2:	8552                	mv	a0,s4
    80002db4:	c23ff0ef          	jal	800029d6 <iunlockput>
    ip = next;
    80002db8:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002dba:	0004c783          	lbu	a5,0(s1)
    80002dbe:	01279763          	bne	a5,s2,80002dcc <namex+0xf0>
    path++;
    80002dc2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dc4:	0004c783          	lbu	a5,0(s1)
    80002dc8:	ff278de3          	beq	a5,s2,80002dc2 <namex+0xe6>
  if(*path == 0)
    80002dcc:	cb8d                	beqz	a5,80002dfe <namex+0x122>
  while(*path != '/' && *path != 0)
    80002dce:	0004c783          	lbu	a5,0(s1)
    80002dd2:	89a6                	mv	s3,s1
  len = path - s;
    80002dd4:	4c81                	li	s9,0
    80002dd6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002dd8:	01278963          	beq	a5,s2,80002dea <namex+0x10e>
    80002ddc:	d3d9                	beqz	a5,80002d62 <namex+0x86>
    path++;
    80002dde:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002de0:	0009c783          	lbu	a5,0(s3)
    80002de4:	ff279ce3          	bne	a5,s2,80002ddc <namex+0x100>
    80002de8:	bfad                	j	80002d62 <namex+0x86>
    memmove(name, s, len);
    80002dea:	2601                	sext.w	a2,a2
    80002dec:	85a6                	mv	a1,s1
    80002dee:	8556                	mv	a0,s5
    80002df0:	bfcfd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002df4:	9cd6                	add	s9,s9,s5
    80002df6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002dfa:	84ce                	mv	s1,s3
    80002dfc:	bfbd                	j	80002d7a <namex+0x9e>
  if(nameiparent){
    80002dfe:	f20b0be3          	beqz	s6,80002d34 <namex+0x58>
    iput(ip);
    80002e02:	8552                	mv	a0,s4
    80002e04:	b4bff0ef          	jal	8000294e <iput>
    return 0;
    80002e08:	4a01                	li	s4,0
    80002e0a:	b72d                	j	80002d34 <namex+0x58>

0000000080002e0c <dirlink>:
{
    80002e0c:	7139                	addi	sp,sp,-64
    80002e0e:	fc06                	sd	ra,56(sp)
    80002e10:	f822                	sd	s0,48(sp)
    80002e12:	f04a                	sd	s2,32(sp)
    80002e14:	ec4e                	sd	s3,24(sp)
    80002e16:	e852                	sd	s4,16(sp)
    80002e18:	0080                	addi	s0,sp,64
    80002e1a:	892a                	mv	s2,a0
    80002e1c:	8a2e                	mv	s4,a1
    80002e1e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e20:	4601                	li	a2,0
    80002e22:	e1fff0ef          	jal	80002c40 <dirlookup>
    80002e26:	e535                	bnez	a0,80002e92 <dirlink+0x86>
    80002e28:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e2a:	04c92483          	lw	s1,76(s2)
    80002e2e:	c48d                	beqz	s1,80002e58 <dirlink+0x4c>
    80002e30:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e32:	4741                	li	a4,16
    80002e34:	86a6                	mv	a3,s1
    80002e36:	fc040613          	addi	a2,s0,-64
    80002e3a:	4581                	li	a1,0
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	be3ff0ef          	jal	80002a20 <readi>
    80002e42:	47c1                	li	a5,16
    80002e44:	04f51b63          	bne	a0,a5,80002e9a <dirlink+0x8e>
    if(de.inum == 0)
    80002e48:	fc045783          	lhu	a5,-64(s0)
    80002e4c:	c791                	beqz	a5,80002e58 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e4e:	24c1                	addiw	s1,s1,16
    80002e50:	04c92783          	lw	a5,76(s2)
    80002e54:	fcf4efe3          	bltu	s1,a5,80002e32 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e58:	4639                	li	a2,14
    80002e5a:	85d2                	mv	a1,s4
    80002e5c:	fc240513          	addi	a0,s0,-62
    80002e60:	c32fd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002e64:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e68:	4741                	li	a4,16
    80002e6a:	86a6                	mv	a3,s1
    80002e6c:	fc040613          	addi	a2,s0,-64
    80002e70:	4581                	li	a1,0
    80002e72:	854a                	mv	a0,s2
    80002e74:	ca9ff0ef          	jal	80002b1c <writei>
    80002e78:	1541                	addi	a0,a0,-16
    80002e7a:	00a03533          	snez	a0,a0
    80002e7e:	40a00533          	neg	a0,a0
    80002e82:	74a2                	ld	s1,40(sp)
}
    80002e84:	70e2                	ld	ra,56(sp)
    80002e86:	7442                	ld	s0,48(sp)
    80002e88:	7902                	ld	s2,32(sp)
    80002e8a:	69e2                	ld	s3,24(sp)
    80002e8c:	6a42                	ld	s4,16(sp)
    80002e8e:	6121                	addi	sp,sp,64
    80002e90:	8082                	ret
    iput(ip);
    80002e92:	abdff0ef          	jal	8000294e <iput>
    return -1;
    80002e96:	557d                	li	a0,-1
    80002e98:	b7f5                	j	80002e84 <dirlink+0x78>
      panic("dirlink read");
    80002e9a:	00004517          	auipc	a0,0x4
    80002e9e:	72e50513          	addi	a0,a0,1838 # 800075c8 <etext+0x5c8>
    80002ea2:	730020ef          	jal	800055d2 <panic>

0000000080002ea6 <namei>:

struct inode*
namei(char *path)
{
    80002ea6:	1101                	addi	sp,sp,-32
    80002ea8:	ec06                	sd	ra,24(sp)
    80002eaa:	e822                	sd	s0,16(sp)
    80002eac:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002eae:	fe040613          	addi	a2,s0,-32
    80002eb2:	4581                	li	a1,0
    80002eb4:	e29ff0ef          	jal	80002cdc <namex>
}
    80002eb8:	60e2                	ld	ra,24(sp)
    80002eba:	6442                	ld	s0,16(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret

0000000080002ec0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ec0:	1141                	addi	sp,sp,-16
    80002ec2:	e406                	sd	ra,8(sp)
    80002ec4:	e022                	sd	s0,0(sp)
    80002ec6:	0800                	addi	s0,sp,16
    80002ec8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002eca:	4585                	li	a1,1
    80002ecc:	e11ff0ef          	jal	80002cdc <namex>
}
    80002ed0:	60a2                	ld	ra,8(sp)
    80002ed2:	6402                	ld	s0,0(sp)
    80002ed4:	0141                	addi	sp,sp,16
    80002ed6:	8082                	ret

0000000080002ed8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ed8:	1101                	addi	sp,sp,-32
    80002eda:	ec06                	sd	ra,24(sp)
    80002edc:	e822                	sd	s0,16(sp)
    80002ede:	e426                	sd	s1,8(sp)
    80002ee0:	e04a                	sd	s2,0(sp)
    80002ee2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002ee4:	00017917          	auipc	s2,0x17
    80002ee8:	7ec90913          	addi	s2,s2,2028 # 8001a6d0 <log>
    80002eec:	01892583          	lw	a1,24(s2)
    80002ef0:	02892503          	lw	a0,40(s2)
    80002ef4:	9a0ff0ef          	jal	80002094 <bread>
    80002ef8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002efa:	02c92603          	lw	a2,44(s2)
    80002efe:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f00:	00c05f63          	blez	a2,80002f1e <write_head+0x46>
    80002f04:	00017717          	auipc	a4,0x17
    80002f08:	7fc70713          	addi	a4,a4,2044 # 8001a700 <log+0x30>
    80002f0c:	87aa                	mv	a5,a0
    80002f0e:	060a                	slli	a2,a2,0x2
    80002f10:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f12:	4314                	lw	a3,0(a4)
    80002f14:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f16:	0711                	addi	a4,a4,4
    80002f18:	0791                	addi	a5,a5,4
    80002f1a:	fec79ce3          	bne	a5,a2,80002f12 <write_head+0x3a>
  }
  bwrite(buf);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	a4aff0ef          	jal	8000216a <bwrite>
  brelse(buf);
    80002f24:	8526                	mv	a0,s1
    80002f26:	a76ff0ef          	jal	8000219c <brelse>
}
    80002f2a:	60e2                	ld	ra,24(sp)
    80002f2c:	6442                	ld	s0,16(sp)
    80002f2e:	64a2                	ld	s1,8(sp)
    80002f30:	6902                	ld	s2,0(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f36:	00017797          	auipc	a5,0x17
    80002f3a:	7c67a783          	lw	a5,1990(a5) # 8001a6fc <log+0x2c>
    80002f3e:	08f05f63          	blez	a5,80002fdc <install_trans+0xa6>
{
    80002f42:	7139                	addi	sp,sp,-64
    80002f44:	fc06                	sd	ra,56(sp)
    80002f46:	f822                	sd	s0,48(sp)
    80002f48:	f426                	sd	s1,40(sp)
    80002f4a:	f04a                	sd	s2,32(sp)
    80002f4c:	ec4e                	sd	s3,24(sp)
    80002f4e:	e852                	sd	s4,16(sp)
    80002f50:	e456                	sd	s5,8(sp)
    80002f52:	e05a                	sd	s6,0(sp)
    80002f54:	0080                	addi	s0,sp,64
    80002f56:	8b2a                	mv	s6,a0
    80002f58:	00017a97          	auipc	s5,0x17
    80002f5c:	7a8a8a93          	addi	s5,s5,1960 # 8001a700 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f60:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f62:	00017997          	auipc	s3,0x17
    80002f66:	76e98993          	addi	s3,s3,1902 # 8001a6d0 <log>
    80002f6a:	a829                	j	80002f84 <install_trans+0x4e>
    brelse(lbuf);
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	a2eff0ef          	jal	8000219c <brelse>
    brelse(dbuf);
    80002f72:	8526                	mv	a0,s1
    80002f74:	a28ff0ef          	jal	8000219c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f78:	2a05                	addiw	s4,s4,1
    80002f7a:	0a91                	addi	s5,s5,4
    80002f7c:	02c9a783          	lw	a5,44(s3)
    80002f80:	04fa5463          	bge	s4,a5,80002fc8 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f84:	0189a583          	lw	a1,24(s3)
    80002f88:	014585bb          	addw	a1,a1,s4
    80002f8c:	2585                	addiw	a1,a1,1
    80002f8e:	0289a503          	lw	a0,40(s3)
    80002f92:	902ff0ef          	jal	80002094 <bread>
    80002f96:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f98:	000aa583          	lw	a1,0(s5)
    80002f9c:	0289a503          	lw	a0,40(s3)
    80002fa0:	8f4ff0ef          	jal	80002094 <bread>
    80002fa4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fa6:	40000613          	li	a2,1024
    80002faa:	05890593          	addi	a1,s2,88
    80002fae:	05850513          	addi	a0,a0,88
    80002fb2:	a3afd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	9b2ff0ef          	jal	8000216a <bwrite>
    if(recovering == 0)
    80002fbc:	fa0b18e3          	bnez	s6,80002f6c <install_trans+0x36>
      bunpin(dbuf);
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	a96ff0ef          	jal	80002258 <bunpin>
    80002fc6:	b75d                	j	80002f6c <install_trans+0x36>
}
    80002fc8:	70e2                	ld	ra,56(sp)
    80002fca:	7442                	ld	s0,48(sp)
    80002fcc:	74a2                	ld	s1,40(sp)
    80002fce:	7902                	ld	s2,32(sp)
    80002fd0:	69e2                	ld	s3,24(sp)
    80002fd2:	6a42                	ld	s4,16(sp)
    80002fd4:	6aa2                	ld	s5,8(sp)
    80002fd6:	6b02                	ld	s6,0(sp)
    80002fd8:	6121                	addi	sp,sp,64
    80002fda:	8082                	ret
    80002fdc:	8082                	ret

0000000080002fde <initlog>:
{
    80002fde:	7179                	addi	sp,sp,-48
    80002fe0:	f406                	sd	ra,40(sp)
    80002fe2:	f022                	sd	s0,32(sp)
    80002fe4:	ec26                	sd	s1,24(sp)
    80002fe6:	e84a                	sd	s2,16(sp)
    80002fe8:	e44e                	sd	s3,8(sp)
    80002fea:	1800                	addi	s0,sp,48
    80002fec:	892a                	mv	s2,a0
    80002fee:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002ff0:	00017497          	auipc	s1,0x17
    80002ff4:	6e048493          	addi	s1,s1,1760 # 8001a6d0 <log>
    80002ff8:	00004597          	auipc	a1,0x4
    80002ffc:	5e058593          	addi	a1,a1,1504 # 800075d8 <etext+0x5d8>
    80003000:	8526                	mv	a0,s1
    80003002:	07f020ef          	jal	80005880 <initlock>
  log.start = sb->logstart;
    80003006:	0149a583          	lw	a1,20(s3)
    8000300a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000300c:	0109a783          	lw	a5,16(s3)
    80003010:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003012:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003016:	854a                	mv	a0,s2
    80003018:	87cff0ef          	jal	80002094 <bread>
  log.lh.n = lh->n;
    8000301c:	4d30                	lw	a2,88(a0)
    8000301e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003020:	00c05f63          	blez	a2,8000303e <initlog+0x60>
    80003024:	87aa                	mv	a5,a0
    80003026:	00017717          	auipc	a4,0x17
    8000302a:	6da70713          	addi	a4,a4,1754 # 8001a700 <log+0x30>
    8000302e:	060a                	slli	a2,a2,0x2
    80003030:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003032:	4ff4                	lw	a3,92(a5)
    80003034:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003036:	0791                	addi	a5,a5,4
    80003038:	0711                	addi	a4,a4,4
    8000303a:	fec79ce3          	bne	a5,a2,80003032 <initlog+0x54>
  brelse(buf);
    8000303e:	95eff0ef          	jal	8000219c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003042:	4505                	li	a0,1
    80003044:	ef3ff0ef          	jal	80002f36 <install_trans>
  log.lh.n = 0;
    80003048:	00017797          	auipc	a5,0x17
    8000304c:	6a07aa23          	sw	zero,1716(a5) # 8001a6fc <log+0x2c>
  write_head(); // clear the log
    80003050:	e89ff0ef          	jal	80002ed8 <write_head>
}
    80003054:	70a2                	ld	ra,40(sp)
    80003056:	7402                	ld	s0,32(sp)
    80003058:	64e2                	ld	s1,24(sp)
    8000305a:	6942                	ld	s2,16(sp)
    8000305c:	69a2                	ld	s3,8(sp)
    8000305e:	6145                	addi	sp,sp,48
    80003060:	8082                	ret

0000000080003062 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003062:	1101                	addi	sp,sp,-32
    80003064:	ec06                	sd	ra,24(sp)
    80003066:	e822                	sd	s0,16(sp)
    80003068:	e426                	sd	s1,8(sp)
    8000306a:	e04a                	sd	s2,0(sp)
    8000306c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000306e:	00017517          	auipc	a0,0x17
    80003072:	66250513          	addi	a0,a0,1634 # 8001a6d0 <log>
    80003076:	08b020ef          	jal	80005900 <acquire>
  while(1){
    if(log.committing){
    8000307a:	00017497          	auipc	s1,0x17
    8000307e:	65648493          	addi	s1,s1,1622 # 8001a6d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003082:	4979                	li	s2,30
    80003084:	a029                	j	8000308e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003086:	85a6                	mv	a1,s1
    80003088:	8526                	mv	a0,s1
    8000308a:	af4fe0ef          	jal	8000137e <sleep>
    if(log.committing){
    8000308e:	50dc                	lw	a5,36(s1)
    80003090:	fbfd                	bnez	a5,80003086 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003092:	5098                	lw	a4,32(s1)
    80003094:	2705                	addiw	a4,a4,1
    80003096:	0027179b          	slliw	a5,a4,0x2
    8000309a:	9fb9                	addw	a5,a5,a4
    8000309c:	0017979b          	slliw	a5,a5,0x1
    800030a0:	54d4                	lw	a3,44(s1)
    800030a2:	9fb5                	addw	a5,a5,a3
    800030a4:	00f95763          	bge	s2,a5,800030b2 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030a8:	85a6                	mv	a1,s1
    800030aa:	8526                	mv	a0,s1
    800030ac:	ad2fe0ef          	jal	8000137e <sleep>
    800030b0:	bff9                	j	8000308e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030b2:	00017517          	auipc	a0,0x17
    800030b6:	61e50513          	addi	a0,a0,1566 # 8001a6d0 <log>
    800030ba:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800030bc:	0dd020ef          	jal	80005998 <release>
      break;
    }
  }
}
    800030c0:	60e2                	ld	ra,24(sp)
    800030c2:	6442                	ld	s0,16(sp)
    800030c4:	64a2                	ld	s1,8(sp)
    800030c6:	6902                	ld	s2,0(sp)
    800030c8:	6105                	addi	sp,sp,32
    800030ca:	8082                	ret

00000000800030cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030cc:	7139                	addi	sp,sp,-64
    800030ce:	fc06                	sd	ra,56(sp)
    800030d0:	f822                	sd	s0,48(sp)
    800030d2:	f426                	sd	s1,40(sp)
    800030d4:	f04a                	sd	s2,32(sp)
    800030d6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030d8:	00017497          	auipc	s1,0x17
    800030dc:	5f848493          	addi	s1,s1,1528 # 8001a6d0 <log>
    800030e0:	8526                	mv	a0,s1
    800030e2:	01f020ef          	jal	80005900 <acquire>
  log.outstanding -= 1;
    800030e6:	509c                	lw	a5,32(s1)
    800030e8:	37fd                	addiw	a5,a5,-1
    800030ea:	0007891b          	sext.w	s2,a5
    800030ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800030f0:	50dc                	lw	a5,36(s1)
    800030f2:	ef9d                	bnez	a5,80003130 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800030f4:	04091763          	bnez	s2,80003142 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800030f8:	00017497          	auipc	s1,0x17
    800030fc:	5d848493          	addi	s1,s1,1496 # 8001a6d0 <log>
    80003100:	4785                	li	a5,1
    80003102:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003104:	8526                	mv	a0,s1
    80003106:	093020ef          	jal	80005998 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000310a:	54dc                	lw	a5,44(s1)
    8000310c:	04f04b63          	bgtz	a5,80003162 <end_op+0x96>
    acquire(&log.lock);
    80003110:	00017497          	auipc	s1,0x17
    80003114:	5c048493          	addi	s1,s1,1472 # 8001a6d0 <log>
    80003118:	8526                	mv	a0,s1
    8000311a:	7e6020ef          	jal	80005900 <acquire>
    log.committing = 0;
    8000311e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003122:	8526                	mv	a0,s1
    80003124:	aa6fe0ef          	jal	800013ca <wakeup>
    release(&log.lock);
    80003128:	8526                	mv	a0,s1
    8000312a:	06f020ef          	jal	80005998 <release>
}
    8000312e:	a025                	j	80003156 <end_op+0x8a>
    80003130:	ec4e                	sd	s3,24(sp)
    80003132:	e852                	sd	s4,16(sp)
    80003134:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003136:	00004517          	auipc	a0,0x4
    8000313a:	4aa50513          	addi	a0,a0,1194 # 800075e0 <etext+0x5e0>
    8000313e:	494020ef          	jal	800055d2 <panic>
    wakeup(&log);
    80003142:	00017497          	auipc	s1,0x17
    80003146:	58e48493          	addi	s1,s1,1422 # 8001a6d0 <log>
    8000314a:	8526                	mv	a0,s1
    8000314c:	a7efe0ef          	jal	800013ca <wakeup>
  release(&log.lock);
    80003150:	8526                	mv	a0,s1
    80003152:	047020ef          	jal	80005998 <release>
}
    80003156:	70e2                	ld	ra,56(sp)
    80003158:	7442                	ld	s0,48(sp)
    8000315a:	74a2                	ld	s1,40(sp)
    8000315c:	7902                	ld	s2,32(sp)
    8000315e:	6121                	addi	sp,sp,64
    80003160:	8082                	ret
    80003162:	ec4e                	sd	s3,24(sp)
    80003164:	e852                	sd	s4,16(sp)
    80003166:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003168:	00017a97          	auipc	s5,0x17
    8000316c:	598a8a93          	addi	s5,s5,1432 # 8001a700 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003170:	00017a17          	auipc	s4,0x17
    80003174:	560a0a13          	addi	s4,s4,1376 # 8001a6d0 <log>
    80003178:	018a2583          	lw	a1,24(s4)
    8000317c:	012585bb          	addw	a1,a1,s2
    80003180:	2585                	addiw	a1,a1,1
    80003182:	028a2503          	lw	a0,40(s4)
    80003186:	f0ffe0ef          	jal	80002094 <bread>
    8000318a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000318c:	000aa583          	lw	a1,0(s5)
    80003190:	028a2503          	lw	a0,40(s4)
    80003194:	f01fe0ef          	jal	80002094 <bread>
    80003198:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000319a:	40000613          	li	a2,1024
    8000319e:	05850593          	addi	a1,a0,88
    800031a2:	05848513          	addi	a0,s1,88
    800031a6:	846fd0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    800031aa:	8526                	mv	a0,s1
    800031ac:	fbffe0ef          	jal	8000216a <bwrite>
    brelse(from);
    800031b0:	854e                	mv	a0,s3
    800031b2:	febfe0ef          	jal	8000219c <brelse>
    brelse(to);
    800031b6:	8526                	mv	a0,s1
    800031b8:	fe5fe0ef          	jal	8000219c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031bc:	2905                	addiw	s2,s2,1
    800031be:	0a91                	addi	s5,s5,4
    800031c0:	02ca2783          	lw	a5,44(s4)
    800031c4:	faf94ae3          	blt	s2,a5,80003178 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031c8:	d11ff0ef          	jal	80002ed8 <write_head>
    install_trans(0); // Now install writes to home locations
    800031cc:	4501                	li	a0,0
    800031ce:	d69ff0ef          	jal	80002f36 <install_trans>
    log.lh.n = 0;
    800031d2:	00017797          	auipc	a5,0x17
    800031d6:	5207a523          	sw	zero,1322(a5) # 8001a6fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800031da:	cffff0ef          	jal	80002ed8 <write_head>
    800031de:	69e2                	ld	s3,24(sp)
    800031e0:	6a42                	ld	s4,16(sp)
    800031e2:	6aa2                	ld	s5,8(sp)
    800031e4:	b735                	j	80003110 <end_op+0x44>

00000000800031e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	e04a                	sd	s2,0(sp)
    800031f0:	1000                	addi	s0,sp,32
    800031f2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031f4:	00017917          	auipc	s2,0x17
    800031f8:	4dc90913          	addi	s2,s2,1244 # 8001a6d0 <log>
    800031fc:	854a                	mv	a0,s2
    800031fe:	702020ef          	jal	80005900 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003202:	02c92603          	lw	a2,44(s2)
    80003206:	47f5                	li	a5,29
    80003208:	06c7c363          	blt	a5,a2,8000326e <log_write+0x88>
    8000320c:	00017797          	auipc	a5,0x17
    80003210:	4e07a783          	lw	a5,1248(a5) # 8001a6ec <log+0x1c>
    80003214:	37fd                	addiw	a5,a5,-1
    80003216:	04f65c63          	bge	a2,a5,8000326e <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000321a:	00017797          	auipc	a5,0x17
    8000321e:	4d67a783          	lw	a5,1238(a5) # 8001a6f0 <log+0x20>
    80003222:	04f05c63          	blez	a5,8000327a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003226:	4781                	li	a5,0
    80003228:	04c05f63          	blez	a2,80003286 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000322c:	44cc                	lw	a1,12(s1)
    8000322e:	00017717          	auipc	a4,0x17
    80003232:	4d270713          	addi	a4,a4,1234 # 8001a700 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003236:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003238:	4314                	lw	a3,0(a4)
    8000323a:	04b68663          	beq	a3,a1,80003286 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000323e:	2785                	addiw	a5,a5,1
    80003240:	0711                	addi	a4,a4,4
    80003242:	fef61be3          	bne	a2,a5,80003238 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003246:	0621                	addi	a2,a2,8
    80003248:	060a                	slli	a2,a2,0x2
    8000324a:	00017797          	auipc	a5,0x17
    8000324e:	48678793          	addi	a5,a5,1158 # 8001a6d0 <log>
    80003252:	97b2                	add	a5,a5,a2
    80003254:	44d8                	lw	a4,12(s1)
    80003256:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003258:	8526                	mv	a0,s1
    8000325a:	fcbfe0ef          	jal	80002224 <bpin>
    log.lh.n++;
    8000325e:	00017717          	auipc	a4,0x17
    80003262:	47270713          	addi	a4,a4,1138 # 8001a6d0 <log>
    80003266:	575c                	lw	a5,44(a4)
    80003268:	2785                	addiw	a5,a5,1
    8000326a:	d75c                	sw	a5,44(a4)
    8000326c:	a80d                	j	8000329e <log_write+0xb8>
    panic("too big a transaction");
    8000326e:	00004517          	auipc	a0,0x4
    80003272:	38250513          	addi	a0,a0,898 # 800075f0 <etext+0x5f0>
    80003276:	35c020ef          	jal	800055d2 <panic>
    panic("log_write outside of trans");
    8000327a:	00004517          	auipc	a0,0x4
    8000327e:	38e50513          	addi	a0,a0,910 # 80007608 <etext+0x608>
    80003282:	350020ef          	jal	800055d2 <panic>
  log.lh.block[i] = b->blockno;
    80003286:	00878693          	addi	a3,a5,8
    8000328a:	068a                	slli	a3,a3,0x2
    8000328c:	00017717          	auipc	a4,0x17
    80003290:	44470713          	addi	a4,a4,1092 # 8001a6d0 <log>
    80003294:	9736                	add	a4,a4,a3
    80003296:	44d4                	lw	a3,12(s1)
    80003298:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000329a:	faf60fe3          	beq	a2,a5,80003258 <log_write+0x72>
  }
  release(&log.lock);
    8000329e:	00017517          	auipc	a0,0x17
    800032a2:	43250513          	addi	a0,a0,1074 # 8001a6d0 <log>
    800032a6:	6f2020ef          	jal	80005998 <release>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	64a2                	ld	s1,8(sp)
    800032b0:	6902                	ld	s2,0(sp)
    800032b2:	6105                	addi	sp,sp,32
    800032b4:	8082                	ret

00000000800032b6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032b6:	1101                	addi	sp,sp,-32
    800032b8:	ec06                	sd	ra,24(sp)
    800032ba:	e822                	sd	s0,16(sp)
    800032bc:	e426                	sd	s1,8(sp)
    800032be:	e04a                	sd	s2,0(sp)
    800032c0:	1000                	addi	s0,sp,32
    800032c2:	84aa                	mv	s1,a0
    800032c4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032c6:	00004597          	auipc	a1,0x4
    800032ca:	36258593          	addi	a1,a1,866 # 80007628 <etext+0x628>
    800032ce:	0521                	addi	a0,a0,8
    800032d0:	5b0020ef          	jal	80005880 <initlock>
  lk->name = name;
    800032d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032dc:	0204a423          	sw	zero,40(s1)
}
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	64a2                	ld	s1,8(sp)
    800032e6:	6902                	ld	s2,0(sp)
    800032e8:	6105                	addi	sp,sp,32
    800032ea:	8082                	ret

00000000800032ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032ec:	1101                	addi	sp,sp,-32
    800032ee:	ec06                	sd	ra,24(sp)
    800032f0:	e822                	sd	s0,16(sp)
    800032f2:	e426                	sd	s1,8(sp)
    800032f4:	e04a                	sd	s2,0(sp)
    800032f6:	1000                	addi	s0,sp,32
    800032f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032fa:	00850913          	addi	s2,a0,8
    800032fe:	854a                	mv	a0,s2
    80003300:	600020ef          	jal	80005900 <acquire>
  while (lk->locked) {
    80003304:	409c                	lw	a5,0(s1)
    80003306:	c799                	beqz	a5,80003314 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003308:	85ca                	mv	a1,s2
    8000330a:	8526                	mv	a0,s1
    8000330c:	872fe0ef          	jal	8000137e <sleep>
  while (lk->locked) {
    80003310:	409c                	lw	a5,0(s1)
    80003312:	fbfd                	bnez	a5,80003308 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003314:	4785                	li	a5,1
    80003316:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003318:	a91fd0ef          	jal	80000da8 <myproc>
    8000331c:	591c                	lw	a5,48(a0)
    8000331e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003320:	854a                	mv	a0,s2
    80003322:	676020ef          	jal	80005998 <release>
}
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	64a2                	ld	s1,8(sp)
    8000332c:	6902                	ld	s2,0(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	e04a                	sd	s2,0(sp)
    8000333c:	1000                	addi	s0,sp,32
    8000333e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003340:	00850913          	addi	s2,a0,8
    80003344:	854a                	mv	a0,s2
    80003346:	5ba020ef          	jal	80005900 <acquire>
  lk->locked = 0;
    8000334a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000334e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003352:	8526                	mv	a0,s1
    80003354:	876fe0ef          	jal	800013ca <wakeup>
  release(&lk->lk);
    80003358:	854a                	mv	a0,s2
    8000335a:	63e020ef          	jal	80005998 <release>
}
    8000335e:	60e2                	ld	ra,24(sp)
    80003360:	6442                	ld	s0,16(sp)
    80003362:	64a2                	ld	s1,8(sp)
    80003364:	6902                	ld	s2,0(sp)
    80003366:	6105                	addi	sp,sp,32
    80003368:	8082                	ret

000000008000336a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000336a:	7179                	addi	sp,sp,-48
    8000336c:	f406                	sd	ra,40(sp)
    8000336e:	f022                	sd	s0,32(sp)
    80003370:	ec26                	sd	s1,24(sp)
    80003372:	e84a                	sd	s2,16(sp)
    80003374:	1800                	addi	s0,sp,48
    80003376:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003378:	00850913          	addi	s2,a0,8
    8000337c:	854a                	mv	a0,s2
    8000337e:	582020ef          	jal	80005900 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003382:	409c                	lw	a5,0(s1)
    80003384:	ef81                	bnez	a5,8000339c <holdingsleep+0x32>
    80003386:	4481                	li	s1,0
  release(&lk->lk);
    80003388:	854a                	mv	a0,s2
    8000338a:	60e020ef          	jal	80005998 <release>
  return r;
}
    8000338e:	8526                	mv	a0,s1
    80003390:	70a2                	ld	ra,40(sp)
    80003392:	7402                	ld	s0,32(sp)
    80003394:	64e2                	ld	s1,24(sp)
    80003396:	6942                	ld	s2,16(sp)
    80003398:	6145                	addi	sp,sp,48
    8000339a:	8082                	ret
    8000339c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000339e:	0284a983          	lw	s3,40(s1)
    800033a2:	a07fd0ef          	jal	80000da8 <myproc>
    800033a6:	5904                	lw	s1,48(a0)
    800033a8:	413484b3          	sub	s1,s1,s3
    800033ac:	0014b493          	seqz	s1,s1
    800033b0:	69a2                	ld	s3,8(sp)
    800033b2:	bfd9                	j	80003388 <holdingsleep+0x1e>

00000000800033b4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033b4:	1141                	addi	sp,sp,-16
    800033b6:	e406                	sd	ra,8(sp)
    800033b8:	e022                	sd	s0,0(sp)
    800033ba:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033bc:	00004597          	auipc	a1,0x4
    800033c0:	27c58593          	addi	a1,a1,636 # 80007638 <etext+0x638>
    800033c4:	00017517          	auipc	a0,0x17
    800033c8:	45450513          	addi	a0,a0,1108 # 8001a818 <ftable>
    800033cc:	4b4020ef          	jal	80005880 <initlock>
}
    800033d0:	60a2                	ld	ra,8(sp)
    800033d2:	6402                	ld	s0,0(sp)
    800033d4:	0141                	addi	sp,sp,16
    800033d6:	8082                	ret

00000000800033d8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033d8:	1101                	addi	sp,sp,-32
    800033da:	ec06                	sd	ra,24(sp)
    800033dc:	e822                	sd	s0,16(sp)
    800033de:	e426                	sd	s1,8(sp)
    800033e0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033e2:	00017517          	auipc	a0,0x17
    800033e6:	43650513          	addi	a0,a0,1078 # 8001a818 <ftable>
    800033ea:	516020ef          	jal	80005900 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033ee:	00017497          	auipc	s1,0x17
    800033f2:	44248493          	addi	s1,s1,1090 # 8001a830 <ftable+0x18>
    800033f6:	00018717          	auipc	a4,0x18
    800033fa:	3da70713          	addi	a4,a4,986 # 8001b7d0 <disk>
    if(f->ref == 0){
    800033fe:	40dc                	lw	a5,4(s1)
    80003400:	cf89                	beqz	a5,8000341a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003402:	02848493          	addi	s1,s1,40
    80003406:	fee49ce3          	bne	s1,a4,800033fe <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000340a:	00017517          	auipc	a0,0x17
    8000340e:	40e50513          	addi	a0,a0,1038 # 8001a818 <ftable>
    80003412:	586020ef          	jal	80005998 <release>
  return 0;
    80003416:	4481                	li	s1,0
    80003418:	a809                	j	8000342a <filealloc+0x52>
      f->ref = 1;
    8000341a:	4785                	li	a5,1
    8000341c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000341e:	00017517          	auipc	a0,0x17
    80003422:	3fa50513          	addi	a0,a0,1018 # 8001a818 <ftable>
    80003426:	572020ef          	jal	80005998 <release>
}
    8000342a:	8526                	mv	a0,s1
    8000342c:	60e2                	ld	ra,24(sp)
    8000342e:	6442                	ld	s0,16(sp)
    80003430:	64a2                	ld	s1,8(sp)
    80003432:	6105                	addi	sp,sp,32
    80003434:	8082                	ret

0000000080003436 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003436:	1101                	addi	sp,sp,-32
    80003438:	ec06                	sd	ra,24(sp)
    8000343a:	e822                	sd	s0,16(sp)
    8000343c:	e426                	sd	s1,8(sp)
    8000343e:	1000                	addi	s0,sp,32
    80003440:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003442:	00017517          	auipc	a0,0x17
    80003446:	3d650513          	addi	a0,a0,982 # 8001a818 <ftable>
    8000344a:	4b6020ef          	jal	80005900 <acquire>
  if(f->ref < 1)
    8000344e:	40dc                	lw	a5,4(s1)
    80003450:	02f05063          	blez	a5,80003470 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003454:	2785                	addiw	a5,a5,1
    80003456:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003458:	00017517          	auipc	a0,0x17
    8000345c:	3c050513          	addi	a0,a0,960 # 8001a818 <ftable>
    80003460:	538020ef          	jal	80005998 <release>
  return f;
}
    80003464:	8526                	mv	a0,s1
    80003466:	60e2                	ld	ra,24(sp)
    80003468:	6442                	ld	s0,16(sp)
    8000346a:	64a2                	ld	s1,8(sp)
    8000346c:	6105                	addi	sp,sp,32
    8000346e:	8082                	ret
    panic("filedup");
    80003470:	00004517          	auipc	a0,0x4
    80003474:	1d050513          	addi	a0,a0,464 # 80007640 <etext+0x640>
    80003478:	15a020ef          	jal	800055d2 <panic>

000000008000347c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000347c:	7139                	addi	sp,sp,-64
    8000347e:	fc06                	sd	ra,56(sp)
    80003480:	f822                	sd	s0,48(sp)
    80003482:	f426                	sd	s1,40(sp)
    80003484:	0080                	addi	s0,sp,64
    80003486:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003488:	00017517          	auipc	a0,0x17
    8000348c:	39050513          	addi	a0,a0,912 # 8001a818 <ftable>
    80003490:	470020ef          	jal	80005900 <acquire>
  if(f->ref < 1)
    80003494:	40dc                	lw	a5,4(s1)
    80003496:	04f05a63          	blez	a5,800034ea <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000349a:	37fd                	addiw	a5,a5,-1
    8000349c:	0007871b          	sext.w	a4,a5
    800034a0:	c0dc                	sw	a5,4(s1)
    800034a2:	04e04e63          	bgtz	a4,800034fe <fileclose+0x82>
    800034a6:	f04a                	sd	s2,32(sp)
    800034a8:	ec4e                	sd	s3,24(sp)
    800034aa:	e852                	sd	s4,16(sp)
    800034ac:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034ae:	0004a903          	lw	s2,0(s1)
    800034b2:	0094ca83          	lbu	s5,9(s1)
    800034b6:	0104ba03          	ld	s4,16(s1)
    800034ba:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034be:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034c2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034c6:	00017517          	auipc	a0,0x17
    800034ca:	35250513          	addi	a0,a0,850 # 8001a818 <ftable>
    800034ce:	4ca020ef          	jal	80005998 <release>

  if(ff.type == FD_PIPE){
    800034d2:	4785                	li	a5,1
    800034d4:	04f90063          	beq	s2,a5,80003514 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034d8:	3979                	addiw	s2,s2,-2
    800034da:	4785                	li	a5,1
    800034dc:	0527f563          	bgeu	a5,s2,80003526 <fileclose+0xaa>
    800034e0:	7902                	ld	s2,32(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	6a42                	ld	s4,16(sp)
    800034e6:	6aa2                	ld	s5,8(sp)
    800034e8:	a00d                	j	8000350a <fileclose+0x8e>
    800034ea:	f04a                	sd	s2,32(sp)
    800034ec:	ec4e                	sd	s3,24(sp)
    800034ee:	e852                	sd	s4,16(sp)
    800034f0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034f2:	00004517          	auipc	a0,0x4
    800034f6:	15650513          	addi	a0,a0,342 # 80007648 <etext+0x648>
    800034fa:	0d8020ef          	jal	800055d2 <panic>
    release(&ftable.lock);
    800034fe:	00017517          	auipc	a0,0x17
    80003502:	31a50513          	addi	a0,a0,794 # 8001a818 <ftable>
    80003506:	492020ef          	jal	80005998 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000350a:	70e2                	ld	ra,56(sp)
    8000350c:	7442                	ld	s0,48(sp)
    8000350e:	74a2                	ld	s1,40(sp)
    80003510:	6121                	addi	sp,sp,64
    80003512:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003514:	85d6                	mv	a1,s5
    80003516:	8552                	mv	a0,s4
    80003518:	38a000ef          	jal	800038a2 <pipeclose>
    8000351c:	7902                	ld	s2,32(sp)
    8000351e:	69e2                	ld	s3,24(sp)
    80003520:	6a42                	ld	s4,16(sp)
    80003522:	6aa2                	ld	s5,8(sp)
    80003524:	b7dd                	j	8000350a <fileclose+0x8e>
    begin_op();
    80003526:	b3dff0ef          	jal	80003062 <begin_op>
    iput(ff.ip);
    8000352a:	854e                	mv	a0,s3
    8000352c:	c22ff0ef          	jal	8000294e <iput>
    end_op();
    80003530:	b9dff0ef          	jal	800030cc <end_op>
    80003534:	7902                	ld	s2,32(sp)
    80003536:	69e2                	ld	s3,24(sp)
    80003538:	6a42                	ld	s4,16(sp)
    8000353a:	6aa2                	ld	s5,8(sp)
    8000353c:	b7f9                	j	8000350a <fileclose+0x8e>

000000008000353e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000353e:	715d                	addi	sp,sp,-80
    80003540:	e486                	sd	ra,72(sp)
    80003542:	e0a2                	sd	s0,64(sp)
    80003544:	fc26                	sd	s1,56(sp)
    80003546:	f44e                	sd	s3,40(sp)
    80003548:	0880                	addi	s0,sp,80
    8000354a:	84aa                	mv	s1,a0
    8000354c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000354e:	85bfd0ef          	jal	80000da8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003552:	409c                	lw	a5,0(s1)
    80003554:	37f9                	addiw	a5,a5,-2
    80003556:	4705                	li	a4,1
    80003558:	04f76063          	bltu	a4,a5,80003598 <filestat+0x5a>
    8000355c:	f84a                	sd	s2,48(sp)
    8000355e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003560:	6c88                	ld	a0,24(s1)
    80003562:	a6aff0ef          	jal	800027cc <ilock>
    stati(f->ip, &st);
    80003566:	fb840593          	addi	a1,s0,-72
    8000356a:	6c88                	ld	a0,24(s1)
    8000356c:	c8aff0ef          	jal	800029f6 <stati>
    iunlock(f->ip);
    80003570:	6c88                	ld	a0,24(s1)
    80003572:	b08ff0ef          	jal	8000287a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003576:	46e1                	li	a3,24
    80003578:	fb840613          	addi	a2,s0,-72
    8000357c:	85ce                	mv	a1,s3
    8000357e:	05093503          	ld	a0,80(s2)
    80003582:	c98fd0ef          	jal	80000a1a <copyout>
    80003586:	41f5551b          	sraiw	a0,a0,0x1f
    8000358a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000358c:	60a6                	ld	ra,72(sp)
    8000358e:	6406                	ld	s0,64(sp)
    80003590:	74e2                	ld	s1,56(sp)
    80003592:	79a2                	ld	s3,40(sp)
    80003594:	6161                	addi	sp,sp,80
    80003596:	8082                	ret
  return -1;
    80003598:	557d                	li	a0,-1
    8000359a:	bfcd                	j	8000358c <filestat+0x4e>

000000008000359c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000359c:	7179                	addi	sp,sp,-48
    8000359e:	f406                	sd	ra,40(sp)
    800035a0:	f022                	sd	s0,32(sp)
    800035a2:	e84a                	sd	s2,16(sp)
    800035a4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035a6:	00854783          	lbu	a5,8(a0)
    800035aa:	cfd1                	beqz	a5,80003646 <fileread+0xaa>
    800035ac:	ec26                	sd	s1,24(sp)
    800035ae:	e44e                	sd	s3,8(sp)
    800035b0:	84aa                	mv	s1,a0
    800035b2:	89ae                	mv	s3,a1
    800035b4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035b6:	411c                	lw	a5,0(a0)
    800035b8:	4705                	li	a4,1
    800035ba:	04e78363          	beq	a5,a4,80003600 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035be:	470d                	li	a4,3
    800035c0:	04e78763          	beq	a5,a4,8000360e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035c4:	4709                	li	a4,2
    800035c6:	06e79a63          	bne	a5,a4,8000363a <fileread+0x9e>
    ilock(f->ip);
    800035ca:	6d08                	ld	a0,24(a0)
    800035cc:	a00ff0ef          	jal	800027cc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035d0:	874a                	mv	a4,s2
    800035d2:	5094                	lw	a3,32(s1)
    800035d4:	864e                	mv	a2,s3
    800035d6:	4585                	li	a1,1
    800035d8:	6c88                	ld	a0,24(s1)
    800035da:	c46ff0ef          	jal	80002a20 <readi>
    800035de:	892a                	mv	s2,a0
    800035e0:	00a05563          	blez	a0,800035ea <fileread+0x4e>
      f->off += r;
    800035e4:	509c                	lw	a5,32(s1)
    800035e6:	9fa9                	addw	a5,a5,a0
    800035e8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035ea:	6c88                	ld	a0,24(s1)
    800035ec:	a8eff0ef          	jal	8000287a <iunlock>
    800035f0:	64e2                	ld	s1,24(sp)
    800035f2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035f4:	854a                	mv	a0,s2
    800035f6:	70a2                	ld	ra,40(sp)
    800035f8:	7402                	ld	s0,32(sp)
    800035fa:	6942                	ld	s2,16(sp)
    800035fc:	6145                	addi	sp,sp,48
    800035fe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003600:	6908                	ld	a0,16(a0)
    80003602:	3dc000ef          	jal	800039de <piperead>
    80003606:	892a                	mv	s2,a0
    80003608:	64e2                	ld	s1,24(sp)
    8000360a:	69a2                	ld	s3,8(sp)
    8000360c:	b7e5                	j	800035f4 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000360e:	02451783          	lh	a5,36(a0)
    80003612:	03079693          	slli	a3,a5,0x30
    80003616:	92c1                	srli	a3,a3,0x30
    80003618:	4725                	li	a4,9
    8000361a:	02d76863          	bltu	a4,a3,8000364a <fileread+0xae>
    8000361e:	0792                	slli	a5,a5,0x4
    80003620:	00017717          	auipc	a4,0x17
    80003624:	15870713          	addi	a4,a4,344 # 8001a778 <devsw>
    80003628:	97ba                	add	a5,a5,a4
    8000362a:	639c                	ld	a5,0(a5)
    8000362c:	c39d                	beqz	a5,80003652 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000362e:	4505                	li	a0,1
    80003630:	9782                	jalr	a5
    80003632:	892a                	mv	s2,a0
    80003634:	64e2                	ld	s1,24(sp)
    80003636:	69a2                	ld	s3,8(sp)
    80003638:	bf75                	j	800035f4 <fileread+0x58>
    panic("fileread");
    8000363a:	00004517          	auipc	a0,0x4
    8000363e:	01e50513          	addi	a0,a0,30 # 80007658 <etext+0x658>
    80003642:	791010ef          	jal	800055d2 <panic>
    return -1;
    80003646:	597d                	li	s2,-1
    80003648:	b775                	j	800035f4 <fileread+0x58>
      return -1;
    8000364a:	597d                	li	s2,-1
    8000364c:	64e2                	ld	s1,24(sp)
    8000364e:	69a2                	ld	s3,8(sp)
    80003650:	b755                	j	800035f4 <fileread+0x58>
    80003652:	597d                	li	s2,-1
    80003654:	64e2                	ld	s1,24(sp)
    80003656:	69a2                	ld	s3,8(sp)
    80003658:	bf71                	j	800035f4 <fileread+0x58>

000000008000365a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000365a:	00954783          	lbu	a5,9(a0)
    8000365e:	10078b63          	beqz	a5,80003774 <filewrite+0x11a>
{
    80003662:	715d                	addi	sp,sp,-80
    80003664:	e486                	sd	ra,72(sp)
    80003666:	e0a2                	sd	s0,64(sp)
    80003668:	f84a                	sd	s2,48(sp)
    8000366a:	f052                	sd	s4,32(sp)
    8000366c:	e85a                	sd	s6,16(sp)
    8000366e:	0880                	addi	s0,sp,80
    80003670:	892a                	mv	s2,a0
    80003672:	8b2e                	mv	s6,a1
    80003674:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003676:	411c                	lw	a5,0(a0)
    80003678:	4705                	li	a4,1
    8000367a:	02e78763          	beq	a5,a4,800036a8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000367e:	470d                	li	a4,3
    80003680:	02e78863          	beq	a5,a4,800036b0 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003684:	4709                	li	a4,2
    80003686:	0ce79c63          	bne	a5,a4,8000375e <filewrite+0x104>
    8000368a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000368c:	0ac05863          	blez	a2,8000373c <filewrite+0xe2>
    80003690:	fc26                	sd	s1,56(sp)
    80003692:	ec56                	sd	s5,24(sp)
    80003694:	e45e                	sd	s7,8(sp)
    80003696:	e062                	sd	s8,0(sp)
    int i = 0;
    80003698:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000369a:	6b85                	lui	s7,0x1
    8000369c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036a0:	6c05                	lui	s8,0x1
    800036a2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036a6:	a8b5                	j	80003722 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036a8:	6908                	ld	a0,16(a0)
    800036aa:	250000ef          	jal	800038fa <pipewrite>
    800036ae:	a04d                	j	80003750 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036b0:	02451783          	lh	a5,36(a0)
    800036b4:	03079693          	slli	a3,a5,0x30
    800036b8:	92c1                	srli	a3,a3,0x30
    800036ba:	4725                	li	a4,9
    800036bc:	0ad76e63          	bltu	a4,a3,80003778 <filewrite+0x11e>
    800036c0:	0792                	slli	a5,a5,0x4
    800036c2:	00017717          	auipc	a4,0x17
    800036c6:	0b670713          	addi	a4,a4,182 # 8001a778 <devsw>
    800036ca:	97ba                	add	a5,a5,a4
    800036cc:	679c                	ld	a5,8(a5)
    800036ce:	c7dd                	beqz	a5,8000377c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800036d0:	4505                	li	a0,1
    800036d2:	9782                	jalr	a5
    800036d4:	a8b5                	j	80003750 <filewrite+0xf6>
      if(n1 > max)
    800036d6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800036da:	989ff0ef          	jal	80003062 <begin_op>
      ilock(f->ip);
    800036de:	01893503          	ld	a0,24(s2)
    800036e2:	8eaff0ef          	jal	800027cc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036e6:	8756                	mv	a4,s5
    800036e8:	02092683          	lw	a3,32(s2)
    800036ec:	01698633          	add	a2,s3,s6
    800036f0:	4585                	li	a1,1
    800036f2:	01893503          	ld	a0,24(s2)
    800036f6:	c26ff0ef          	jal	80002b1c <writei>
    800036fa:	84aa                	mv	s1,a0
    800036fc:	00a05763          	blez	a0,8000370a <filewrite+0xb0>
        f->off += r;
    80003700:	02092783          	lw	a5,32(s2)
    80003704:	9fa9                	addw	a5,a5,a0
    80003706:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000370a:	01893503          	ld	a0,24(s2)
    8000370e:	96cff0ef          	jal	8000287a <iunlock>
      end_op();
    80003712:	9bbff0ef          	jal	800030cc <end_op>

      if(r != n1){
    80003716:	029a9563          	bne	s5,s1,80003740 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000371a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000371e:	0149da63          	bge	s3,s4,80003732 <filewrite+0xd8>
      int n1 = n - i;
    80003722:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003726:	0004879b          	sext.w	a5,s1
    8000372a:	fafbd6e3          	bge	s7,a5,800036d6 <filewrite+0x7c>
    8000372e:	84e2                	mv	s1,s8
    80003730:	b75d                	j	800036d6 <filewrite+0x7c>
    80003732:	74e2                	ld	s1,56(sp)
    80003734:	6ae2                	ld	s5,24(sp)
    80003736:	6ba2                	ld	s7,8(sp)
    80003738:	6c02                	ld	s8,0(sp)
    8000373a:	a039                	j	80003748 <filewrite+0xee>
    int i = 0;
    8000373c:	4981                	li	s3,0
    8000373e:	a029                	j	80003748 <filewrite+0xee>
    80003740:	74e2                	ld	s1,56(sp)
    80003742:	6ae2                	ld	s5,24(sp)
    80003744:	6ba2                	ld	s7,8(sp)
    80003746:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003748:	033a1c63          	bne	s4,s3,80003780 <filewrite+0x126>
    8000374c:	8552                	mv	a0,s4
    8000374e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003750:	60a6                	ld	ra,72(sp)
    80003752:	6406                	ld	s0,64(sp)
    80003754:	7942                	ld	s2,48(sp)
    80003756:	7a02                	ld	s4,32(sp)
    80003758:	6b42                	ld	s6,16(sp)
    8000375a:	6161                	addi	sp,sp,80
    8000375c:	8082                	ret
    8000375e:	fc26                	sd	s1,56(sp)
    80003760:	f44e                	sd	s3,40(sp)
    80003762:	ec56                	sd	s5,24(sp)
    80003764:	e45e                	sd	s7,8(sp)
    80003766:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003768:	00004517          	auipc	a0,0x4
    8000376c:	f0050513          	addi	a0,a0,-256 # 80007668 <etext+0x668>
    80003770:	663010ef          	jal	800055d2 <panic>
    return -1;
    80003774:	557d                	li	a0,-1
}
    80003776:	8082                	ret
      return -1;
    80003778:	557d                	li	a0,-1
    8000377a:	bfd9                	j	80003750 <filewrite+0xf6>
    8000377c:	557d                	li	a0,-1
    8000377e:	bfc9                	j	80003750 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003780:	557d                	li	a0,-1
    80003782:	79a2                	ld	s3,40(sp)
    80003784:	b7f1                	j	80003750 <filewrite+0xf6>

0000000080003786 <count_open_file>:

int
count_open_file(void) 
{
    80003786:	1101                	addi	sp,sp,-32
    80003788:	ec06                	sd	ra,24(sp)
    8000378a:	e822                	sd	s0,16(sp)
    8000378c:	e426                	sd	s1,8(sp)
    8000378e:	1000                	addi	s0,sp,32
  int n = 0;
  
  struct file *f;

  acquire(&ftable.lock);
    80003790:	00017517          	auipc	a0,0x17
    80003794:	08850513          	addi	a0,a0,136 # 8001a818 <ftable>
    80003798:	168020ef          	jal	80005900 <acquire>

  for (f = ftable.file; f < &ftable.file[NFILE]; f++) {
    8000379c:	00017797          	auipc	a5,0x17
    800037a0:	09478793          	addi	a5,a5,148 # 8001a830 <ftable+0x18>
  int n = 0;
    800037a4:	4481                	li	s1,0
  for (f = ftable.file; f < &ftable.file[NFILE]; f++) {
    800037a6:	00018697          	auipc	a3,0x18
    800037aa:	02a68693          	addi	a3,a3,42 # 8001b7d0 <disk>
    800037ae:	a029                	j	800037b8 <count_open_file+0x32>
    800037b0:	02878793          	addi	a5,a5,40
    800037b4:	00d78763          	beq	a5,a3,800037c2 <count_open_file+0x3c>
    if (f->ref > 0) {
    800037b8:	43d8                	lw	a4,4(a5)
    800037ba:	fee05be3          	blez	a4,800037b0 <count_open_file+0x2a>
      n++;
    800037be:	2485                	addiw	s1,s1,1
    800037c0:	bfc5                	j	800037b0 <count_open_file+0x2a>
    }
  }

  release(&ftable.lock);
    800037c2:	00017517          	auipc	a0,0x17
    800037c6:	05650513          	addi	a0,a0,86 # 8001a818 <ftable>
    800037ca:	1ce020ef          	jal	80005998 <release>

  return n;
    800037ce:	8526                	mv	a0,s1
    800037d0:	60e2                	ld	ra,24(sp)
    800037d2:	6442                	ld	s0,16(sp)
    800037d4:	64a2                	ld	s1,8(sp)
    800037d6:	6105                	addi	sp,sp,32
    800037d8:	8082                	ret

00000000800037da <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037da:	7179                	addi	sp,sp,-48
    800037dc:	f406                	sd	ra,40(sp)
    800037de:	f022                	sd	s0,32(sp)
    800037e0:	ec26                	sd	s1,24(sp)
    800037e2:	e052                	sd	s4,0(sp)
    800037e4:	1800                	addi	s0,sp,48
    800037e6:	84aa                	mv	s1,a0
    800037e8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037ea:	0005b023          	sd	zero,0(a1)
    800037ee:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037f2:	be7ff0ef          	jal	800033d8 <filealloc>
    800037f6:	e088                	sd	a0,0(s1)
    800037f8:	c549                	beqz	a0,80003882 <pipealloc+0xa8>
    800037fa:	bdfff0ef          	jal	800033d8 <filealloc>
    800037fe:	00aa3023          	sd	a0,0(s4)
    80003802:	cd25                	beqz	a0,8000387a <pipealloc+0xa0>
    80003804:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003806:	8f9fc0ef          	jal	800000fe <kalloc>
    8000380a:	892a                	mv	s2,a0
    8000380c:	c12d                	beqz	a0,8000386e <pipealloc+0x94>
    8000380e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003810:	4985                	li	s3,1
    80003812:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003816:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000381a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000381e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003822:	00004597          	auipc	a1,0x4
    80003826:	bde58593          	addi	a1,a1,-1058 # 80007400 <etext+0x400>
    8000382a:	056020ef          	jal	80005880 <initlock>
  (*f0)->type = FD_PIPE;
    8000382e:	609c                	ld	a5,0(s1)
    80003830:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003834:	609c                	ld	a5,0(s1)
    80003836:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000383a:	609c                	ld	a5,0(s1)
    8000383c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003840:	609c                	ld	a5,0(s1)
    80003842:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003846:	000a3783          	ld	a5,0(s4)
    8000384a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000384e:	000a3783          	ld	a5,0(s4)
    80003852:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003856:	000a3783          	ld	a5,0(s4)
    8000385a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000385e:	000a3783          	ld	a5,0(s4)
    80003862:	0127b823          	sd	s2,16(a5)
  return 0;
    80003866:	4501                	li	a0,0
    80003868:	6942                	ld	s2,16(sp)
    8000386a:	69a2                	ld	s3,8(sp)
    8000386c:	a01d                	j	80003892 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000386e:	6088                	ld	a0,0(s1)
    80003870:	c119                	beqz	a0,80003876 <pipealloc+0x9c>
    80003872:	6942                	ld	s2,16(sp)
    80003874:	a029                	j	8000387e <pipealloc+0xa4>
    80003876:	6942                	ld	s2,16(sp)
    80003878:	a029                	j	80003882 <pipealloc+0xa8>
    8000387a:	6088                	ld	a0,0(s1)
    8000387c:	c10d                	beqz	a0,8000389e <pipealloc+0xc4>
    fileclose(*f0);
    8000387e:	bffff0ef          	jal	8000347c <fileclose>
  if(*f1)
    80003882:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003886:	557d                	li	a0,-1
  if(*f1)
    80003888:	c789                	beqz	a5,80003892 <pipealloc+0xb8>
    fileclose(*f1);
    8000388a:	853e                	mv	a0,a5
    8000388c:	bf1ff0ef          	jal	8000347c <fileclose>
  return -1;
    80003890:	557d                	li	a0,-1
}
    80003892:	70a2                	ld	ra,40(sp)
    80003894:	7402                	ld	s0,32(sp)
    80003896:	64e2                	ld	s1,24(sp)
    80003898:	6a02                	ld	s4,0(sp)
    8000389a:	6145                	addi	sp,sp,48
    8000389c:	8082                	ret
  return -1;
    8000389e:	557d                	li	a0,-1
    800038a0:	bfcd                	j	80003892 <pipealloc+0xb8>

00000000800038a2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038a2:	1101                	addi	sp,sp,-32
    800038a4:	ec06                	sd	ra,24(sp)
    800038a6:	e822                	sd	s0,16(sp)
    800038a8:	e426                	sd	s1,8(sp)
    800038aa:	e04a                	sd	s2,0(sp)
    800038ac:	1000                	addi	s0,sp,32
    800038ae:	84aa                	mv	s1,a0
    800038b0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038b2:	04e020ef          	jal	80005900 <acquire>
  if(writable){
    800038b6:	02090763          	beqz	s2,800038e4 <pipeclose+0x42>
    pi->writeopen = 0;
    800038ba:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038be:	21848513          	addi	a0,s1,536
    800038c2:	b09fd0ef          	jal	800013ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038c6:	2204b783          	ld	a5,544(s1)
    800038ca:	e785                	bnez	a5,800038f2 <pipeclose+0x50>
    release(&pi->lock);
    800038cc:	8526                	mv	a0,s1
    800038ce:	0ca020ef          	jal	80005998 <release>
    kfree((char*)pi);
    800038d2:	8526                	mv	a0,s1
    800038d4:	f48fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038d8:	60e2                	ld	ra,24(sp)
    800038da:	6442                	ld	s0,16(sp)
    800038dc:	64a2                	ld	s1,8(sp)
    800038de:	6902                	ld	s2,0(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret
    pi->readopen = 0;
    800038e4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038e8:	21c48513          	addi	a0,s1,540
    800038ec:	adffd0ef          	jal	800013ca <wakeup>
    800038f0:	bfd9                	j	800038c6 <pipeclose+0x24>
    release(&pi->lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	0a4020ef          	jal	80005998 <release>
}
    800038f8:	b7c5                	j	800038d8 <pipeclose+0x36>

00000000800038fa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038fa:	711d                	addi	sp,sp,-96
    800038fc:	ec86                	sd	ra,88(sp)
    800038fe:	e8a2                	sd	s0,80(sp)
    80003900:	e4a6                	sd	s1,72(sp)
    80003902:	e0ca                	sd	s2,64(sp)
    80003904:	fc4e                	sd	s3,56(sp)
    80003906:	f852                	sd	s4,48(sp)
    80003908:	f456                	sd	s5,40(sp)
    8000390a:	1080                	addi	s0,sp,96
    8000390c:	84aa                	mv	s1,a0
    8000390e:	8aae                	mv	s5,a1
    80003910:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003912:	c96fd0ef          	jal	80000da8 <myproc>
    80003916:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003918:	8526                	mv	a0,s1
    8000391a:	7e7010ef          	jal	80005900 <acquire>
  while(i < n){
    8000391e:	0b405a63          	blez	s4,800039d2 <pipewrite+0xd8>
    80003922:	f05a                	sd	s6,32(sp)
    80003924:	ec5e                	sd	s7,24(sp)
    80003926:	e862                	sd	s8,16(sp)
  int i = 0;
    80003928:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000392a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000392c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003930:	21c48b93          	addi	s7,s1,540
    80003934:	a81d                	j	8000396a <pipewrite+0x70>
      release(&pi->lock);
    80003936:	8526                	mv	a0,s1
    80003938:	060020ef          	jal	80005998 <release>
      return -1;
    8000393c:	597d                	li	s2,-1
    8000393e:	7b02                	ld	s6,32(sp)
    80003940:	6be2                	ld	s7,24(sp)
    80003942:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003944:	854a                	mv	a0,s2
    80003946:	60e6                	ld	ra,88(sp)
    80003948:	6446                	ld	s0,80(sp)
    8000394a:	64a6                	ld	s1,72(sp)
    8000394c:	6906                	ld	s2,64(sp)
    8000394e:	79e2                	ld	s3,56(sp)
    80003950:	7a42                	ld	s4,48(sp)
    80003952:	7aa2                	ld	s5,40(sp)
    80003954:	6125                	addi	sp,sp,96
    80003956:	8082                	ret
      wakeup(&pi->nread);
    80003958:	8562                	mv	a0,s8
    8000395a:	a71fd0ef          	jal	800013ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000395e:	85a6                	mv	a1,s1
    80003960:	855e                	mv	a0,s7
    80003962:	a1dfd0ef          	jal	8000137e <sleep>
  while(i < n){
    80003966:	05495b63          	bge	s2,s4,800039bc <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000396a:	2204a783          	lw	a5,544(s1)
    8000396e:	d7e1                	beqz	a5,80003936 <pipewrite+0x3c>
    80003970:	854e                	mv	a0,s3
    80003972:	c45fd0ef          	jal	800015b6 <killed>
    80003976:	f161                	bnez	a0,80003936 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003978:	2184a783          	lw	a5,536(s1)
    8000397c:	21c4a703          	lw	a4,540(s1)
    80003980:	2007879b          	addiw	a5,a5,512
    80003984:	fcf70ae3          	beq	a4,a5,80003958 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003988:	4685                	li	a3,1
    8000398a:	01590633          	add	a2,s2,s5
    8000398e:	faf40593          	addi	a1,s0,-81
    80003992:	0509b503          	ld	a0,80(s3)
    80003996:	95afd0ef          	jal	80000af0 <copyin>
    8000399a:	03650e63          	beq	a0,s6,800039d6 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000399e:	21c4a783          	lw	a5,540(s1)
    800039a2:	0017871b          	addiw	a4,a5,1
    800039a6:	20e4ae23          	sw	a4,540(s1)
    800039aa:	1ff7f793          	andi	a5,a5,511
    800039ae:	97a6                	add	a5,a5,s1
    800039b0:	faf44703          	lbu	a4,-81(s0)
    800039b4:	00e78c23          	sb	a4,24(a5)
      i++;
    800039b8:	2905                	addiw	s2,s2,1
    800039ba:	b775                	j	80003966 <pipewrite+0x6c>
    800039bc:	7b02                	ld	s6,32(sp)
    800039be:	6be2                	ld	s7,24(sp)
    800039c0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800039c2:	21848513          	addi	a0,s1,536
    800039c6:	a05fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    800039ca:	8526                	mv	a0,s1
    800039cc:	7cd010ef          	jal	80005998 <release>
  return i;
    800039d0:	bf95                	j	80003944 <pipewrite+0x4a>
  int i = 0;
    800039d2:	4901                	li	s2,0
    800039d4:	b7fd                	j	800039c2 <pipewrite+0xc8>
    800039d6:	7b02                	ld	s6,32(sp)
    800039d8:	6be2                	ld	s7,24(sp)
    800039da:	6c42                	ld	s8,16(sp)
    800039dc:	b7dd                	j	800039c2 <pipewrite+0xc8>

00000000800039de <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039de:	715d                	addi	sp,sp,-80
    800039e0:	e486                	sd	ra,72(sp)
    800039e2:	e0a2                	sd	s0,64(sp)
    800039e4:	fc26                	sd	s1,56(sp)
    800039e6:	f84a                	sd	s2,48(sp)
    800039e8:	f44e                	sd	s3,40(sp)
    800039ea:	f052                	sd	s4,32(sp)
    800039ec:	ec56                	sd	s5,24(sp)
    800039ee:	0880                	addi	s0,sp,80
    800039f0:	84aa                	mv	s1,a0
    800039f2:	892e                	mv	s2,a1
    800039f4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039f6:	bb2fd0ef          	jal	80000da8 <myproc>
    800039fa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039fc:	8526                	mv	a0,s1
    800039fe:	703010ef          	jal	80005900 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a02:	2184a703          	lw	a4,536(s1)
    80003a06:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a0a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a0e:	02f71563          	bne	a4,a5,80003a38 <piperead+0x5a>
    80003a12:	2244a783          	lw	a5,548(s1)
    80003a16:	cb85                	beqz	a5,80003a46 <piperead+0x68>
    if(killed(pr)){
    80003a18:	8552                	mv	a0,s4
    80003a1a:	b9dfd0ef          	jal	800015b6 <killed>
    80003a1e:	ed19                	bnez	a0,80003a3c <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a20:	85a6                	mv	a1,s1
    80003a22:	854e                	mv	a0,s3
    80003a24:	95bfd0ef          	jal	8000137e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a28:	2184a703          	lw	a4,536(s1)
    80003a2c:	21c4a783          	lw	a5,540(s1)
    80003a30:	fef701e3          	beq	a4,a5,80003a12 <piperead+0x34>
    80003a34:	e85a                	sd	s6,16(sp)
    80003a36:	a809                	j	80003a48 <piperead+0x6a>
    80003a38:	e85a                	sd	s6,16(sp)
    80003a3a:	a039                	j	80003a48 <piperead+0x6a>
      release(&pi->lock);
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	75b010ef          	jal	80005998 <release>
      return -1;
    80003a42:	59fd                	li	s3,-1
    80003a44:	a8b1                	j	80003aa0 <piperead+0xc2>
    80003a46:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a48:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a4a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a4c:	05505263          	blez	s5,80003a90 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a50:	2184a783          	lw	a5,536(s1)
    80003a54:	21c4a703          	lw	a4,540(s1)
    80003a58:	02f70c63          	beq	a4,a5,80003a90 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a5c:	0017871b          	addiw	a4,a5,1
    80003a60:	20e4ac23          	sw	a4,536(s1)
    80003a64:	1ff7f793          	andi	a5,a5,511
    80003a68:	97a6                	add	a5,a5,s1
    80003a6a:	0187c783          	lbu	a5,24(a5)
    80003a6e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a72:	4685                	li	a3,1
    80003a74:	fbf40613          	addi	a2,s0,-65
    80003a78:	85ca                	mv	a1,s2
    80003a7a:	050a3503          	ld	a0,80(s4)
    80003a7e:	f9dfc0ef          	jal	80000a1a <copyout>
    80003a82:	01650763          	beq	a0,s6,80003a90 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a86:	2985                	addiw	s3,s3,1
    80003a88:	0905                	addi	s2,s2,1
    80003a8a:	fd3a93e3          	bne	s5,s3,80003a50 <piperead+0x72>
    80003a8e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a90:	21c48513          	addi	a0,s1,540
    80003a94:	937fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    80003a98:	8526                	mv	a0,s1
    80003a9a:	6ff010ef          	jal	80005998 <release>
    80003a9e:	6b42                	ld	s6,16(sp)
  return i;
}
    80003aa0:	854e                	mv	a0,s3
    80003aa2:	60a6                	ld	ra,72(sp)
    80003aa4:	6406                	ld	s0,64(sp)
    80003aa6:	74e2                	ld	s1,56(sp)
    80003aa8:	7942                	ld	s2,48(sp)
    80003aaa:	79a2                	ld	s3,40(sp)
    80003aac:	7a02                	ld	s4,32(sp)
    80003aae:	6ae2                	ld	s5,24(sp)
    80003ab0:	6161                	addi	sp,sp,80
    80003ab2:	8082                	ret

0000000080003ab4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003ab4:	1141                	addi	sp,sp,-16
    80003ab6:	e422                	sd	s0,8(sp)
    80003ab8:	0800                	addi	s0,sp,16
    80003aba:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003abc:	8905                	andi	a0,a0,1
    80003abe:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003ac0:	8b89                	andi	a5,a5,2
    80003ac2:	c399                	beqz	a5,80003ac8 <flags2perm+0x14>
      perm |= PTE_W;
    80003ac4:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ac8:	6422                	ld	s0,8(sp)
    80003aca:	0141                	addi	sp,sp,16
    80003acc:	8082                	ret

0000000080003ace <exec>:

int
exec(char *path, char **argv)
{
    80003ace:	df010113          	addi	sp,sp,-528
    80003ad2:	20113423          	sd	ra,520(sp)
    80003ad6:	20813023          	sd	s0,512(sp)
    80003ada:	ffa6                	sd	s1,504(sp)
    80003adc:	fbca                	sd	s2,496(sp)
    80003ade:	0c00                	addi	s0,sp,528
    80003ae0:	892a                	mv	s2,a0
    80003ae2:	dea43c23          	sd	a0,-520(s0)
    80003ae6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aea:	abefd0ef          	jal	80000da8 <myproc>
    80003aee:	84aa                	mv	s1,a0

  begin_op();
    80003af0:	d72ff0ef          	jal	80003062 <begin_op>

  if((ip = namei(path)) == 0){
    80003af4:	854a                	mv	a0,s2
    80003af6:	bb0ff0ef          	jal	80002ea6 <namei>
    80003afa:	c931                	beqz	a0,80003b4e <exec+0x80>
    80003afc:	f3d2                	sd	s4,480(sp)
    80003afe:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b00:	ccdfe0ef          	jal	800027cc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b04:	04000713          	li	a4,64
    80003b08:	4681                	li	a3,0
    80003b0a:	e5040613          	addi	a2,s0,-432
    80003b0e:	4581                	li	a1,0
    80003b10:	8552                	mv	a0,s4
    80003b12:	f0ffe0ef          	jal	80002a20 <readi>
    80003b16:	04000793          	li	a5,64
    80003b1a:	00f51a63          	bne	a0,a5,80003b2e <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b1e:	e5042703          	lw	a4,-432(s0)
    80003b22:	464c47b7          	lui	a5,0x464c4
    80003b26:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b2a:	02f70663          	beq	a4,a5,80003b56 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b2e:	8552                	mv	a0,s4
    80003b30:	ea7fe0ef          	jal	800029d6 <iunlockput>
    end_op();
    80003b34:	d98ff0ef          	jal	800030cc <end_op>
  }
  return -1;
    80003b38:	557d                	li	a0,-1
    80003b3a:	7a1e                	ld	s4,480(sp)
}
    80003b3c:	20813083          	ld	ra,520(sp)
    80003b40:	20013403          	ld	s0,512(sp)
    80003b44:	74fe                	ld	s1,504(sp)
    80003b46:	795e                	ld	s2,496(sp)
    80003b48:	21010113          	addi	sp,sp,528
    80003b4c:	8082                	ret
    end_op();
    80003b4e:	d7eff0ef          	jal	800030cc <end_op>
    return -1;
    80003b52:	557d                	li	a0,-1
    80003b54:	b7e5                	j	80003b3c <exec+0x6e>
    80003b56:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b58:	8526                	mv	a0,s1
    80003b5a:	af6fd0ef          	jal	80000e50 <proc_pagetable>
    80003b5e:	8b2a                	mv	s6,a0
    80003b60:	2c050b63          	beqz	a0,80003e36 <exec+0x368>
    80003b64:	f7ce                	sd	s3,488(sp)
    80003b66:	efd6                	sd	s5,472(sp)
    80003b68:	e7de                	sd	s7,456(sp)
    80003b6a:	e3e2                	sd	s8,448(sp)
    80003b6c:	ff66                	sd	s9,440(sp)
    80003b6e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b70:	e7042d03          	lw	s10,-400(s0)
    80003b74:	e8845783          	lhu	a5,-376(s0)
    80003b78:	12078963          	beqz	a5,80003caa <exec+0x1dc>
    80003b7c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b7e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b80:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b82:	6c85                	lui	s9,0x1
    80003b84:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b88:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b8c:	6a85                	lui	s5,0x1
    80003b8e:	a085                	j	80003bee <exec+0x120>
      panic("loadseg: address should exist");
    80003b90:	00004517          	auipc	a0,0x4
    80003b94:	ae850513          	addi	a0,a0,-1304 # 80007678 <etext+0x678>
    80003b98:	23b010ef          	jal	800055d2 <panic>
    if(sz - i < PGSIZE)
    80003b9c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b9e:	8726                	mv	a4,s1
    80003ba0:	012c06bb          	addw	a3,s8,s2
    80003ba4:	4581                	li	a1,0
    80003ba6:	8552                	mv	a0,s4
    80003ba8:	e79fe0ef          	jal	80002a20 <readi>
    80003bac:	2501                	sext.w	a0,a0
    80003bae:	24a49a63          	bne	s1,a0,80003e02 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003bb2:	012a893b          	addw	s2,s5,s2
    80003bb6:	03397363          	bgeu	s2,s3,80003bdc <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003bba:	02091593          	slli	a1,s2,0x20
    80003bbe:	9181                	srli	a1,a1,0x20
    80003bc0:	95de                	add	a1,a1,s7
    80003bc2:	855a                	mv	a0,s6
    80003bc4:	8dbfc0ef          	jal	8000049e <walkaddr>
    80003bc8:	862a                	mv	a2,a0
    if(pa == 0)
    80003bca:	d179                	beqz	a0,80003b90 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003bcc:	412984bb          	subw	s1,s3,s2
    80003bd0:	0004879b          	sext.w	a5,s1
    80003bd4:	fcfcf4e3          	bgeu	s9,a5,80003b9c <exec+0xce>
    80003bd8:	84d6                	mv	s1,s5
    80003bda:	b7c9                	j	80003b9c <exec+0xce>
    sz = sz1;
    80003bdc:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be0:	2d85                	addiw	s11,s11,1
    80003be2:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003be6:	e8845783          	lhu	a5,-376(s0)
    80003bea:	08fdd063          	bge	s11,a5,80003c6a <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bee:	2d01                	sext.w	s10,s10
    80003bf0:	03800713          	li	a4,56
    80003bf4:	86ea                	mv	a3,s10
    80003bf6:	e1840613          	addi	a2,s0,-488
    80003bfa:	4581                	li	a1,0
    80003bfc:	8552                	mv	a0,s4
    80003bfe:	e23fe0ef          	jal	80002a20 <readi>
    80003c02:	03800793          	li	a5,56
    80003c06:	1cf51663          	bne	a0,a5,80003dd2 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003c0a:	e1842783          	lw	a5,-488(s0)
    80003c0e:	4705                	li	a4,1
    80003c10:	fce798e3          	bne	a5,a4,80003be0 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003c14:	e4043483          	ld	s1,-448(s0)
    80003c18:	e3843783          	ld	a5,-456(s0)
    80003c1c:	1af4ef63          	bltu	s1,a5,80003dda <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c20:	e2843783          	ld	a5,-472(s0)
    80003c24:	94be                	add	s1,s1,a5
    80003c26:	1af4ee63          	bltu	s1,a5,80003de2 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003c2a:	df043703          	ld	a4,-528(s0)
    80003c2e:	8ff9                	and	a5,a5,a4
    80003c30:	1a079d63          	bnez	a5,80003dea <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c34:	e1c42503          	lw	a0,-484(s0)
    80003c38:	e7dff0ef          	jal	80003ab4 <flags2perm>
    80003c3c:	86aa                	mv	a3,a0
    80003c3e:	8626                	mv	a2,s1
    80003c40:	85ca                	mv	a1,s2
    80003c42:	855a                	mv	a0,s6
    80003c44:	bc3fc0ef          	jal	80000806 <uvmalloc>
    80003c48:	e0a43423          	sd	a0,-504(s0)
    80003c4c:	1a050363          	beqz	a0,80003df2 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c50:	e2843b83          	ld	s7,-472(s0)
    80003c54:	e2042c03          	lw	s8,-480(s0)
    80003c58:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c5c:	00098463          	beqz	s3,80003c64 <exec+0x196>
    80003c60:	4901                	li	s2,0
    80003c62:	bfa1                	j	80003bba <exec+0xec>
    sz = sz1;
    80003c64:	e0843903          	ld	s2,-504(s0)
    80003c68:	bfa5                	j	80003be0 <exec+0x112>
    80003c6a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c6c:	8552                	mv	a0,s4
    80003c6e:	d69fe0ef          	jal	800029d6 <iunlockput>
  end_op();
    80003c72:	c5aff0ef          	jal	800030cc <end_op>
  p = myproc();
    80003c76:	932fd0ef          	jal	80000da8 <myproc>
    80003c7a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c7c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c80:	6985                	lui	s3,0x1
    80003c82:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c84:	99ca                	add	s3,s3,s2
    80003c86:	77fd                	lui	a5,0xfffff
    80003c88:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c8c:	4691                	li	a3,4
    80003c8e:	660d                	lui	a2,0x3
    80003c90:	964e                	add	a2,a2,s3
    80003c92:	85ce                	mv	a1,s3
    80003c94:	855a                	mv	a0,s6
    80003c96:	b71fc0ef          	jal	80000806 <uvmalloc>
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	e0a43423          	sd	a0,-504(s0)
    80003ca0:	e519                	bnez	a0,80003cae <exec+0x1e0>
  if(pagetable)
    80003ca2:	e1343423          	sd	s3,-504(s0)
    80003ca6:	4a01                	li	s4,0
    80003ca8:	aab1                	j	80003e04 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003caa:	4901                	li	s2,0
    80003cac:	b7c1                	j	80003c6c <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003cae:	75f5                	lui	a1,0xffffd
    80003cb0:	95aa                	add	a1,a1,a0
    80003cb2:	855a                	mv	a0,s6
    80003cb4:	d3dfc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003cb8:	7bf9                	lui	s7,0xffffe
    80003cba:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003cbc:	e0043783          	ld	a5,-512(s0)
    80003cc0:	6388                	ld	a0,0(a5)
    80003cc2:	cd39                	beqz	a0,80003d20 <exec+0x252>
    80003cc4:	e9040993          	addi	s3,s0,-368
    80003cc8:	f9040c13          	addi	s8,s0,-112
    80003ccc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003cce:	e32fc0ef          	jal	80000300 <strlen>
    80003cd2:	0015079b          	addiw	a5,a0,1
    80003cd6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cda:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cde:	11796e63          	bltu	s2,s7,80003dfa <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ce2:	e0043d03          	ld	s10,-512(s0)
    80003ce6:	000d3a03          	ld	s4,0(s10)
    80003cea:	8552                	mv	a0,s4
    80003cec:	e14fc0ef          	jal	80000300 <strlen>
    80003cf0:	0015069b          	addiw	a3,a0,1
    80003cf4:	8652                	mv	a2,s4
    80003cf6:	85ca                	mv	a1,s2
    80003cf8:	855a                	mv	a0,s6
    80003cfa:	d21fc0ef          	jal	80000a1a <copyout>
    80003cfe:	10054063          	bltz	a0,80003dfe <exec+0x330>
    ustack[argc] = sp;
    80003d02:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003d06:	0485                	addi	s1,s1,1
    80003d08:	008d0793          	addi	a5,s10,8
    80003d0c:	e0f43023          	sd	a5,-512(s0)
    80003d10:	008d3503          	ld	a0,8(s10)
    80003d14:	c909                	beqz	a0,80003d26 <exec+0x258>
    if(argc >= MAXARG)
    80003d16:	09a1                	addi	s3,s3,8
    80003d18:	fb899be3          	bne	s3,s8,80003cce <exec+0x200>
  ip = 0;
    80003d1c:	4a01                	li	s4,0
    80003d1e:	a0dd                	j	80003e04 <exec+0x336>
  sp = sz;
    80003d20:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003d24:	4481                	li	s1,0
  ustack[argc] = 0;
    80003d26:	00349793          	slli	a5,s1,0x3
    80003d2a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb580>
    80003d2e:	97a2                	add	a5,a5,s0
    80003d30:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d34:	00148693          	addi	a3,s1,1
    80003d38:	068e                	slli	a3,a3,0x3
    80003d3a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d3e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d42:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d46:	f5796ee3          	bltu	s2,s7,80003ca2 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d4a:	e9040613          	addi	a2,s0,-368
    80003d4e:	85ca                	mv	a1,s2
    80003d50:	855a                	mv	a0,s6
    80003d52:	cc9fc0ef          	jal	80000a1a <copyout>
    80003d56:	0e054263          	bltz	a0,80003e3a <exec+0x36c>
  p->trapframe->a1 = sp;
    80003d5a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d5e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d62:	df843783          	ld	a5,-520(s0)
    80003d66:	0007c703          	lbu	a4,0(a5)
    80003d6a:	cf11                	beqz	a4,80003d86 <exec+0x2b8>
    80003d6c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d6e:	02f00693          	li	a3,47
    80003d72:	a039                	j	80003d80 <exec+0x2b2>
      last = s+1;
    80003d74:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d78:	0785                	addi	a5,a5,1
    80003d7a:	fff7c703          	lbu	a4,-1(a5)
    80003d7e:	c701                	beqz	a4,80003d86 <exec+0x2b8>
    if(*s == '/')
    80003d80:	fed71ce3          	bne	a4,a3,80003d78 <exec+0x2aa>
    80003d84:	bfc5                	j	80003d74 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d86:	4641                	li	a2,16
    80003d88:	df843583          	ld	a1,-520(s0)
    80003d8c:	158a8513          	addi	a0,s5,344
    80003d90:	d3efc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003d94:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d98:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d9c:	e0843783          	ld	a5,-504(s0)
    80003da0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003da4:	058ab783          	ld	a5,88(s5)
    80003da8:	e6843703          	ld	a4,-408(s0)
    80003dac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003dae:	058ab783          	ld	a5,88(s5)
    80003db2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003db6:	85e6                	mv	a1,s9
    80003db8:	91cfd0ef          	jal	80000ed4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003dbc:	0004851b          	sext.w	a0,s1
    80003dc0:	79be                	ld	s3,488(sp)
    80003dc2:	7a1e                	ld	s4,480(sp)
    80003dc4:	6afe                	ld	s5,472(sp)
    80003dc6:	6b5e                	ld	s6,464(sp)
    80003dc8:	6bbe                	ld	s7,456(sp)
    80003dca:	6c1e                	ld	s8,448(sp)
    80003dcc:	7cfa                	ld	s9,440(sp)
    80003dce:	7d5a                	ld	s10,432(sp)
    80003dd0:	b3b5                	j	80003b3c <exec+0x6e>
    80003dd2:	e1243423          	sd	s2,-504(s0)
    80003dd6:	7dba                	ld	s11,424(sp)
    80003dd8:	a035                	j	80003e04 <exec+0x336>
    80003dda:	e1243423          	sd	s2,-504(s0)
    80003dde:	7dba                	ld	s11,424(sp)
    80003de0:	a015                	j	80003e04 <exec+0x336>
    80003de2:	e1243423          	sd	s2,-504(s0)
    80003de6:	7dba                	ld	s11,424(sp)
    80003de8:	a831                	j	80003e04 <exec+0x336>
    80003dea:	e1243423          	sd	s2,-504(s0)
    80003dee:	7dba                	ld	s11,424(sp)
    80003df0:	a811                	j	80003e04 <exec+0x336>
    80003df2:	e1243423          	sd	s2,-504(s0)
    80003df6:	7dba                	ld	s11,424(sp)
    80003df8:	a031                	j	80003e04 <exec+0x336>
  ip = 0;
    80003dfa:	4a01                	li	s4,0
    80003dfc:	a021                	j	80003e04 <exec+0x336>
    80003dfe:	4a01                	li	s4,0
  if(pagetable)
    80003e00:	a011                	j	80003e04 <exec+0x336>
    80003e02:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003e04:	e0843583          	ld	a1,-504(s0)
    80003e08:	855a                	mv	a0,s6
    80003e0a:	8cafd0ef          	jal	80000ed4 <proc_freepagetable>
  return -1;
    80003e0e:	557d                	li	a0,-1
  if(ip){
    80003e10:	000a1b63          	bnez	s4,80003e26 <exec+0x358>
    80003e14:	79be                	ld	s3,488(sp)
    80003e16:	7a1e                	ld	s4,480(sp)
    80003e18:	6afe                	ld	s5,472(sp)
    80003e1a:	6b5e                	ld	s6,464(sp)
    80003e1c:	6bbe                	ld	s7,456(sp)
    80003e1e:	6c1e                	ld	s8,448(sp)
    80003e20:	7cfa                	ld	s9,440(sp)
    80003e22:	7d5a                	ld	s10,432(sp)
    80003e24:	bb21                	j	80003b3c <exec+0x6e>
    80003e26:	79be                	ld	s3,488(sp)
    80003e28:	6afe                	ld	s5,472(sp)
    80003e2a:	6b5e                	ld	s6,464(sp)
    80003e2c:	6bbe                	ld	s7,456(sp)
    80003e2e:	6c1e                	ld	s8,448(sp)
    80003e30:	7cfa                	ld	s9,440(sp)
    80003e32:	7d5a                	ld	s10,432(sp)
    80003e34:	b9ed                	j	80003b2e <exec+0x60>
    80003e36:	6b5e                	ld	s6,464(sp)
    80003e38:	b9dd                	j	80003b2e <exec+0x60>
  sz = sz1;
    80003e3a:	e0843983          	ld	s3,-504(s0)
    80003e3e:	b595                	j	80003ca2 <exec+0x1d4>

0000000080003e40 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e40:	7179                	addi	sp,sp,-48
    80003e42:	f406                	sd	ra,40(sp)
    80003e44:	f022                	sd	s0,32(sp)
    80003e46:	ec26                	sd	s1,24(sp)
    80003e48:	e84a                	sd	s2,16(sp)
    80003e4a:	1800                	addi	s0,sp,48
    80003e4c:	892e                	mv	s2,a1
    80003e4e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e50:	fdc40593          	addi	a1,s0,-36
    80003e54:	e5ffd0ef          	jal	80001cb2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e58:	fdc42703          	lw	a4,-36(s0)
    80003e5c:	47bd                	li	a5,15
    80003e5e:	02e7e963          	bltu	a5,a4,80003e90 <argfd+0x50>
    80003e62:	f47fc0ef          	jal	80000da8 <myproc>
    80003e66:	fdc42703          	lw	a4,-36(s0)
    80003e6a:	01a70793          	addi	a5,a4,26
    80003e6e:	078e                	slli	a5,a5,0x3
    80003e70:	953e                	add	a0,a0,a5
    80003e72:	611c                	ld	a5,0(a0)
    80003e74:	c385                	beqz	a5,80003e94 <argfd+0x54>
    return -1;
  if(pfd)
    80003e76:	00090463          	beqz	s2,80003e7e <argfd+0x3e>
    *pfd = fd;
    80003e7a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e7e:	4501                	li	a0,0
  if(pf)
    80003e80:	c091                	beqz	s1,80003e84 <argfd+0x44>
    *pf = f;
    80003e82:	e09c                	sd	a5,0(s1)
}
    80003e84:	70a2                	ld	ra,40(sp)
    80003e86:	7402                	ld	s0,32(sp)
    80003e88:	64e2                	ld	s1,24(sp)
    80003e8a:	6942                	ld	s2,16(sp)
    80003e8c:	6145                	addi	sp,sp,48
    80003e8e:	8082                	ret
    return -1;
    80003e90:	557d                	li	a0,-1
    80003e92:	bfcd                	j	80003e84 <argfd+0x44>
    80003e94:	557d                	li	a0,-1
    80003e96:	b7fd                	j	80003e84 <argfd+0x44>

0000000080003e98 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e98:	1101                	addi	sp,sp,-32
    80003e9a:	ec06                	sd	ra,24(sp)
    80003e9c:	e822                	sd	s0,16(sp)
    80003e9e:	e426                	sd	s1,8(sp)
    80003ea0:	1000                	addi	s0,sp,32
    80003ea2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ea4:	f05fc0ef          	jal	80000da8 <myproc>
    80003ea8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003eaa:	0d050793          	addi	a5,a0,208
    80003eae:	4501                	li	a0,0
    80003eb0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003eb2:	6398                	ld	a4,0(a5)
    80003eb4:	cb19                	beqz	a4,80003eca <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003eb6:	2505                	addiw	a0,a0,1
    80003eb8:	07a1                	addi	a5,a5,8
    80003eba:	fed51ce3          	bne	a0,a3,80003eb2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ebe:	557d                	li	a0,-1
}
    80003ec0:	60e2                	ld	ra,24(sp)
    80003ec2:	6442                	ld	s0,16(sp)
    80003ec4:	64a2                	ld	s1,8(sp)
    80003ec6:	6105                	addi	sp,sp,32
    80003ec8:	8082                	ret
      p->ofile[fd] = f;
    80003eca:	01a50793          	addi	a5,a0,26
    80003ece:	078e                	slli	a5,a5,0x3
    80003ed0:	963e                	add	a2,a2,a5
    80003ed2:	e204                	sd	s1,0(a2)
      return fd;
    80003ed4:	b7f5                	j	80003ec0 <fdalloc+0x28>

0000000080003ed6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003ed6:	715d                	addi	sp,sp,-80
    80003ed8:	e486                	sd	ra,72(sp)
    80003eda:	e0a2                	sd	s0,64(sp)
    80003edc:	fc26                	sd	s1,56(sp)
    80003ede:	f84a                	sd	s2,48(sp)
    80003ee0:	f44e                	sd	s3,40(sp)
    80003ee2:	ec56                	sd	s5,24(sp)
    80003ee4:	e85a                	sd	s6,16(sp)
    80003ee6:	0880                	addi	s0,sp,80
    80003ee8:	8b2e                	mv	s6,a1
    80003eea:	89b2                	mv	s3,a2
    80003eec:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003eee:	fb040593          	addi	a1,s0,-80
    80003ef2:	fcffe0ef          	jal	80002ec0 <nameiparent>
    80003ef6:	84aa                	mv	s1,a0
    80003ef8:	10050a63          	beqz	a0,8000400c <create+0x136>
    return 0;

  ilock(dp);
    80003efc:	8d1fe0ef          	jal	800027cc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f00:	4601                	li	a2,0
    80003f02:	fb040593          	addi	a1,s0,-80
    80003f06:	8526                	mv	a0,s1
    80003f08:	d39fe0ef          	jal	80002c40 <dirlookup>
    80003f0c:	8aaa                	mv	s5,a0
    80003f0e:	c129                	beqz	a0,80003f50 <create+0x7a>
    iunlockput(dp);
    80003f10:	8526                	mv	a0,s1
    80003f12:	ac5fe0ef          	jal	800029d6 <iunlockput>
    ilock(ip);
    80003f16:	8556                	mv	a0,s5
    80003f18:	8b5fe0ef          	jal	800027cc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f1c:	4789                	li	a5,2
    80003f1e:	02fb1463          	bne	s6,a5,80003f46 <create+0x70>
    80003f22:	044ad783          	lhu	a5,68(s5)
    80003f26:	37f9                	addiw	a5,a5,-2
    80003f28:	17c2                	slli	a5,a5,0x30
    80003f2a:	93c1                	srli	a5,a5,0x30
    80003f2c:	4705                	li	a4,1
    80003f2e:	00f76c63          	bltu	a4,a5,80003f46 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f32:	8556                	mv	a0,s5
    80003f34:	60a6                	ld	ra,72(sp)
    80003f36:	6406                	ld	s0,64(sp)
    80003f38:	74e2                	ld	s1,56(sp)
    80003f3a:	7942                	ld	s2,48(sp)
    80003f3c:	79a2                	ld	s3,40(sp)
    80003f3e:	6ae2                	ld	s5,24(sp)
    80003f40:	6b42                	ld	s6,16(sp)
    80003f42:	6161                	addi	sp,sp,80
    80003f44:	8082                	ret
    iunlockput(ip);
    80003f46:	8556                	mv	a0,s5
    80003f48:	a8ffe0ef          	jal	800029d6 <iunlockput>
    return 0;
    80003f4c:	4a81                	li	s5,0
    80003f4e:	b7d5                	j	80003f32 <create+0x5c>
    80003f50:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f52:	85da                	mv	a1,s6
    80003f54:	4088                	lw	a0,0(s1)
    80003f56:	f06fe0ef          	jal	8000265c <ialloc>
    80003f5a:	8a2a                	mv	s4,a0
    80003f5c:	cd15                	beqz	a0,80003f98 <create+0xc2>
  ilock(ip);
    80003f5e:	86ffe0ef          	jal	800027cc <ilock>
  ip->major = major;
    80003f62:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f66:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f6a:	4905                	li	s2,1
    80003f6c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f70:	8552                	mv	a0,s4
    80003f72:	fa6fe0ef          	jal	80002718 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f76:	032b0763          	beq	s6,s2,80003fa4 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f7a:	004a2603          	lw	a2,4(s4)
    80003f7e:	fb040593          	addi	a1,s0,-80
    80003f82:	8526                	mv	a0,s1
    80003f84:	e89fe0ef          	jal	80002e0c <dirlink>
    80003f88:	06054563          	bltz	a0,80003ff2 <create+0x11c>
  iunlockput(dp);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	a49fe0ef          	jal	800029d6 <iunlockput>
  return ip;
    80003f92:	8ad2                	mv	s5,s4
    80003f94:	7a02                	ld	s4,32(sp)
    80003f96:	bf71                	j	80003f32 <create+0x5c>
    iunlockput(dp);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	a3dfe0ef          	jal	800029d6 <iunlockput>
    return 0;
    80003f9e:	8ad2                	mv	s5,s4
    80003fa0:	7a02                	ld	s4,32(sp)
    80003fa2:	bf41                	j	80003f32 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fa4:	004a2603          	lw	a2,4(s4)
    80003fa8:	00003597          	auipc	a1,0x3
    80003fac:	6f058593          	addi	a1,a1,1776 # 80007698 <etext+0x698>
    80003fb0:	8552                	mv	a0,s4
    80003fb2:	e5bfe0ef          	jal	80002e0c <dirlink>
    80003fb6:	02054e63          	bltz	a0,80003ff2 <create+0x11c>
    80003fba:	40d0                	lw	a2,4(s1)
    80003fbc:	00003597          	auipc	a1,0x3
    80003fc0:	6e458593          	addi	a1,a1,1764 # 800076a0 <etext+0x6a0>
    80003fc4:	8552                	mv	a0,s4
    80003fc6:	e47fe0ef          	jal	80002e0c <dirlink>
    80003fca:	02054463          	bltz	a0,80003ff2 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fce:	004a2603          	lw	a2,4(s4)
    80003fd2:	fb040593          	addi	a1,s0,-80
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	e35fe0ef          	jal	80002e0c <dirlink>
    80003fdc:	00054b63          	bltz	a0,80003ff2 <create+0x11c>
    dp->nlink++;  // for ".."
    80003fe0:	04a4d783          	lhu	a5,74(s1)
    80003fe4:	2785                	addiw	a5,a5,1
    80003fe6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fea:	8526                	mv	a0,s1
    80003fec:	f2cfe0ef          	jal	80002718 <iupdate>
    80003ff0:	bf71                	j	80003f8c <create+0xb6>
  ip->nlink = 0;
    80003ff2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ff6:	8552                	mv	a0,s4
    80003ff8:	f20fe0ef          	jal	80002718 <iupdate>
  iunlockput(ip);
    80003ffc:	8552                	mv	a0,s4
    80003ffe:	9d9fe0ef          	jal	800029d6 <iunlockput>
  iunlockput(dp);
    80004002:	8526                	mv	a0,s1
    80004004:	9d3fe0ef          	jal	800029d6 <iunlockput>
  return 0;
    80004008:	7a02                	ld	s4,32(sp)
    8000400a:	b725                	j	80003f32 <create+0x5c>
    return 0;
    8000400c:	8aaa                	mv	s5,a0
    8000400e:	b715                	j	80003f32 <create+0x5c>

0000000080004010 <sys_dup>:
{
    80004010:	7179                	addi	sp,sp,-48
    80004012:	f406                	sd	ra,40(sp)
    80004014:	f022                	sd	s0,32(sp)
    80004016:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004018:	fd840613          	addi	a2,s0,-40
    8000401c:	4581                	li	a1,0
    8000401e:	4501                	li	a0,0
    80004020:	e21ff0ef          	jal	80003e40 <argfd>
    return -1;
    80004024:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004026:	02054363          	bltz	a0,8000404c <sys_dup+0x3c>
    8000402a:	ec26                	sd	s1,24(sp)
    8000402c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000402e:	fd843903          	ld	s2,-40(s0)
    80004032:	854a                	mv	a0,s2
    80004034:	e65ff0ef          	jal	80003e98 <fdalloc>
    80004038:	84aa                	mv	s1,a0
    return -1;
    8000403a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000403c:	00054d63          	bltz	a0,80004056 <sys_dup+0x46>
  filedup(f);
    80004040:	854a                	mv	a0,s2
    80004042:	bf4ff0ef          	jal	80003436 <filedup>
  return fd;
    80004046:	87a6                	mv	a5,s1
    80004048:	64e2                	ld	s1,24(sp)
    8000404a:	6942                	ld	s2,16(sp)
}
    8000404c:	853e                	mv	a0,a5
    8000404e:	70a2                	ld	ra,40(sp)
    80004050:	7402                	ld	s0,32(sp)
    80004052:	6145                	addi	sp,sp,48
    80004054:	8082                	ret
    80004056:	64e2                	ld	s1,24(sp)
    80004058:	6942                	ld	s2,16(sp)
    8000405a:	bfcd                	j	8000404c <sys_dup+0x3c>

000000008000405c <sys_read>:
{
    8000405c:	7179                	addi	sp,sp,-48
    8000405e:	f406                	sd	ra,40(sp)
    80004060:	f022                	sd	s0,32(sp)
    80004062:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004064:	fd840593          	addi	a1,s0,-40
    80004068:	4505                	li	a0,1
    8000406a:	c65fd0ef          	jal	80001cce <argaddr>
  argint(2, &n);
    8000406e:	fe440593          	addi	a1,s0,-28
    80004072:	4509                	li	a0,2
    80004074:	c3ffd0ef          	jal	80001cb2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004078:	fe840613          	addi	a2,s0,-24
    8000407c:	4581                	li	a1,0
    8000407e:	4501                	li	a0,0
    80004080:	dc1ff0ef          	jal	80003e40 <argfd>
    80004084:	87aa                	mv	a5,a0
    return -1;
    80004086:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004088:	0007ca63          	bltz	a5,8000409c <sys_read+0x40>
  return fileread(f, p, n);
    8000408c:	fe442603          	lw	a2,-28(s0)
    80004090:	fd843583          	ld	a1,-40(s0)
    80004094:	fe843503          	ld	a0,-24(s0)
    80004098:	d04ff0ef          	jal	8000359c <fileread>
}
    8000409c:	70a2                	ld	ra,40(sp)
    8000409e:	7402                	ld	s0,32(sp)
    800040a0:	6145                	addi	sp,sp,48
    800040a2:	8082                	ret

00000000800040a4 <sys_write>:
{
    800040a4:	7179                	addi	sp,sp,-48
    800040a6:	f406                	sd	ra,40(sp)
    800040a8:	f022                	sd	s0,32(sp)
    800040aa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040ac:	fd840593          	addi	a1,s0,-40
    800040b0:	4505                	li	a0,1
    800040b2:	c1dfd0ef          	jal	80001cce <argaddr>
  argint(2, &n);
    800040b6:	fe440593          	addi	a1,s0,-28
    800040ba:	4509                	li	a0,2
    800040bc:	bf7fd0ef          	jal	80001cb2 <argint>
  if(argfd(0, 0, &f) < 0)
    800040c0:	fe840613          	addi	a2,s0,-24
    800040c4:	4581                	li	a1,0
    800040c6:	4501                	li	a0,0
    800040c8:	d79ff0ef          	jal	80003e40 <argfd>
    800040cc:	87aa                	mv	a5,a0
    return -1;
    800040ce:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040d0:	0007ca63          	bltz	a5,800040e4 <sys_write+0x40>
  return filewrite(f, p, n);
    800040d4:	fe442603          	lw	a2,-28(s0)
    800040d8:	fd843583          	ld	a1,-40(s0)
    800040dc:	fe843503          	ld	a0,-24(s0)
    800040e0:	d7aff0ef          	jal	8000365a <filewrite>
}
    800040e4:	70a2                	ld	ra,40(sp)
    800040e6:	7402                	ld	s0,32(sp)
    800040e8:	6145                	addi	sp,sp,48
    800040ea:	8082                	ret

00000000800040ec <sys_close>:
{
    800040ec:	1101                	addi	sp,sp,-32
    800040ee:	ec06                	sd	ra,24(sp)
    800040f0:	e822                	sd	s0,16(sp)
    800040f2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040f4:	fe040613          	addi	a2,s0,-32
    800040f8:	fec40593          	addi	a1,s0,-20
    800040fc:	4501                	li	a0,0
    800040fe:	d43ff0ef          	jal	80003e40 <argfd>
    return -1;
    80004102:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004104:	02054063          	bltz	a0,80004124 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004108:	ca1fc0ef          	jal	80000da8 <myproc>
    8000410c:	fec42783          	lw	a5,-20(s0)
    80004110:	07e9                	addi	a5,a5,26
    80004112:	078e                	slli	a5,a5,0x3
    80004114:	953e                	add	a0,a0,a5
    80004116:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000411a:	fe043503          	ld	a0,-32(s0)
    8000411e:	b5eff0ef          	jal	8000347c <fileclose>
  return 0;
    80004122:	4781                	li	a5,0
}
    80004124:	853e                	mv	a0,a5
    80004126:	60e2                	ld	ra,24(sp)
    80004128:	6442                	ld	s0,16(sp)
    8000412a:	6105                	addi	sp,sp,32
    8000412c:	8082                	ret

000000008000412e <sys_fstat>:
{
    8000412e:	1101                	addi	sp,sp,-32
    80004130:	ec06                	sd	ra,24(sp)
    80004132:	e822                	sd	s0,16(sp)
    80004134:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004136:	fe040593          	addi	a1,s0,-32
    8000413a:	4505                	li	a0,1
    8000413c:	b93fd0ef          	jal	80001cce <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004140:	fe840613          	addi	a2,s0,-24
    80004144:	4581                	li	a1,0
    80004146:	4501                	li	a0,0
    80004148:	cf9ff0ef          	jal	80003e40 <argfd>
    8000414c:	87aa                	mv	a5,a0
    return -1;
    8000414e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004150:	0007c863          	bltz	a5,80004160 <sys_fstat+0x32>
  return filestat(f, st);
    80004154:	fe043583          	ld	a1,-32(s0)
    80004158:	fe843503          	ld	a0,-24(s0)
    8000415c:	be2ff0ef          	jal	8000353e <filestat>
}
    80004160:	60e2                	ld	ra,24(sp)
    80004162:	6442                	ld	s0,16(sp)
    80004164:	6105                	addi	sp,sp,32
    80004166:	8082                	ret

0000000080004168 <sys_link>:
{
    80004168:	7169                	addi	sp,sp,-304
    8000416a:	f606                	sd	ra,296(sp)
    8000416c:	f222                	sd	s0,288(sp)
    8000416e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004170:	08000613          	li	a2,128
    80004174:	ed040593          	addi	a1,s0,-304
    80004178:	4501                	li	a0,0
    8000417a:	b71fd0ef          	jal	80001cea <argstr>
    return -1;
    8000417e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004180:	0c054e63          	bltz	a0,8000425c <sys_link+0xf4>
    80004184:	08000613          	li	a2,128
    80004188:	f5040593          	addi	a1,s0,-176
    8000418c:	4505                	li	a0,1
    8000418e:	b5dfd0ef          	jal	80001cea <argstr>
    return -1;
    80004192:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004194:	0c054463          	bltz	a0,8000425c <sys_link+0xf4>
    80004198:	ee26                	sd	s1,280(sp)
  begin_op();
    8000419a:	ec9fe0ef          	jal	80003062 <begin_op>
  if((ip = namei(old)) == 0){
    8000419e:	ed040513          	addi	a0,s0,-304
    800041a2:	d05fe0ef          	jal	80002ea6 <namei>
    800041a6:	84aa                	mv	s1,a0
    800041a8:	c53d                	beqz	a0,80004216 <sys_link+0xae>
  ilock(ip);
    800041aa:	e22fe0ef          	jal	800027cc <ilock>
  if(ip->type == T_DIR){
    800041ae:	04449703          	lh	a4,68(s1)
    800041b2:	4785                	li	a5,1
    800041b4:	06f70663          	beq	a4,a5,80004220 <sys_link+0xb8>
    800041b8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041ba:	04a4d783          	lhu	a5,74(s1)
    800041be:	2785                	addiw	a5,a5,1
    800041c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041c4:	8526                	mv	a0,s1
    800041c6:	d52fe0ef          	jal	80002718 <iupdate>
  iunlock(ip);
    800041ca:	8526                	mv	a0,s1
    800041cc:	eaefe0ef          	jal	8000287a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041d0:	fd040593          	addi	a1,s0,-48
    800041d4:	f5040513          	addi	a0,s0,-176
    800041d8:	ce9fe0ef          	jal	80002ec0 <nameiparent>
    800041dc:	892a                	mv	s2,a0
    800041de:	cd21                	beqz	a0,80004236 <sys_link+0xce>
  ilock(dp);
    800041e0:	decfe0ef          	jal	800027cc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041e4:	00092703          	lw	a4,0(s2)
    800041e8:	409c                	lw	a5,0(s1)
    800041ea:	04f71363          	bne	a4,a5,80004230 <sys_link+0xc8>
    800041ee:	40d0                	lw	a2,4(s1)
    800041f0:	fd040593          	addi	a1,s0,-48
    800041f4:	854a                	mv	a0,s2
    800041f6:	c17fe0ef          	jal	80002e0c <dirlink>
    800041fa:	02054b63          	bltz	a0,80004230 <sys_link+0xc8>
  iunlockput(dp);
    800041fe:	854a                	mv	a0,s2
    80004200:	fd6fe0ef          	jal	800029d6 <iunlockput>
  iput(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	f48fe0ef          	jal	8000294e <iput>
  end_op();
    8000420a:	ec3fe0ef          	jal	800030cc <end_op>
  return 0;
    8000420e:	4781                	li	a5,0
    80004210:	64f2                	ld	s1,280(sp)
    80004212:	6952                	ld	s2,272(sp)
    80004214:	a0a1                	j	8000425c <sys_link+0xf4>
    end_op();
    80004216:	eb7fe0ef          	jal	800030cc <end_op>
    return -1;
    8000421a:	57fd                	li	a5,-1
    8000421c:	64f2                	ld	s1,280(sp)
    8000421e:	a83d                	j	8000425c <sys_link+0xf4>
    iunlockput(ip);
    80004220:	8526                	mv	a0,s1
    80004222:	fb4fe0ef          	jal	800029d6 <iunlockput>
    end_op();
    80004226:	ea7fe0ef          	jal	800030cc <end_op>
    return -1;
    8000422a:	57fd                	li	a5,-1
    8000422c:	64f2                	ld	s1,280(sp)
    8000422e:	a03d                	j	8000425c <sys_link+0xf4>
    iunlockput(dp);
    80004230:	854a                	mv	a0,s2
    80004232:	fa4fe0ef          	jal	800029d6 <iunlockput>
  ilock(ip);
    80004236:	8526                	mv	a0,s1
    80004238:	d94fe0ef          	jal	800027cc <ilock>
  ip->nlink--;
    8000423c:	04a4d783          	lhu	a5,74(s1)
    80004240:	37fd                	addiw	a5,a5,-1
    80004242:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004246:	8526                	mv	a0,s1
    80004248:	cd0fe0ef          	jal	80002718 <iupdate>
  iunlockput(ip);
    8000424c:	8526                	mv	a0,s1
    8000424e:	f88fe0ef          	jal	800029d6 <iunlockput>
  end_op();
    80004252:	e7bfe0ef          	jal	800030cc <end_op>
  return -1;
    80004256:	57fd                	li	a5,-1
    80004258:	64f2                	ld	s1,280(sp)
    8000425a:	6952                	ld	s2,272(sp)
}
    8000425c:	853e                	mv	a0,a5
    8000425e:	70b2                	ld	ra,296(sp)
    80004260:	7412                	ld	s0,288(sp)
    80004262:	6155                	addi	sp,sp,304
    80004264:	8082                	ret

0000000080004266 <sys_unlink>:
{
    80004266:	7151                	addi	sp,sp,-240
    80004268:	f586                	sd	ra,232(sp)
    8000426a:	f1a2                	sd	s0,224(sp)
    8000426c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000426e:	08000613          	li	a2,128
    80004272:	f3040593          	addi	a1,s0,-208
    80004276:	4501                	li	a0,0
    80004278:	a73fd0ef          	jal	80001cea <argstr>
    8000427c:	16054063          	bltz	a0,800043dc <sys_unlink+0x176>
    80004280:	eda6                	sd	s1,216(sp)
  begin_op();
    80004282:	de1fe0ef          	jal	80003062 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004286:	fb040593          	addi	a1,s0,-80
    8000428a:	f3040513          	addi	a0,s0,-208
    8000428e:	c33fe0ef          	jal	80002ec0 <nameiparent>
    80004292:	84aa                	mv	s1,a0
    80004294:	c945                	beqz	a0,80004344 <sys_unlink+0xde>
  ilock(dp);
    80004296:	d36fe0ef          	jal	800027cc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000429a:	00003597          	auipc	a1,0x3
    8000429e:	3fe58593          	addi	a1,a1,1022 # 80007698 <etext+0x698>
    800042a2:	fb040513          	addi	a0,s0,-80
    800042a6:	985fe0ef          	jal	80002c2a <namecmp>
    800042aa:	10050e63          	beqz	a0,800043c6 <sys_unlink+0x160>
    800042ae:	00003597          	auipc	a1,0x3
    800042b2:	3f258593          	addi	a1,a1,1010 # 800076a0 <etext+0x6a0>
    800042b6:	fb040513          	addi	a0,s0,-80
    800042ba:	971fe0ef          	jal	80002c2a <namecmp>
    800042be:	10050463          	beqz	a0,800043c6 <sys_unlink+0x160>
    800042c2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042c4:	f2c40613          	addi	a2,s0,-212
    800042c8:	fb040593          	addi	a1,s0,-80
    800042cc:	8526                	mv	a0,s1
    800042ce:	973fe0ef          	jal	80002c40 <dirlookup>
    800042d2:	892a                	mv	s2,a0
    800042d4:	0e050863          	beqz	a0,800043c4 <sys_unlink+0x15e>
  ilock(ip);
    800042d8:	cf4fe0ef          	jal	800027cc <ilock>
  if(ip->nlink < 1)
    800042dc:	04a91783          	lh	a5,74(s2)
    800042e0:	06f05763          	blez	a5,8000434e <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042e4:	04491703          	lh	a4,68(s2)
    800042e8:	4785                	li	a5,1
    800042ea:	06f70963          	beq	a4,a5,8000435c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042ee:	4641                	li	a2,16
    800042f0:	4581                	li	a1,0
    800042f2:	fc040513          	addi	a0,s0,-64
    800042f6:	e9bfb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042fa:	4741                	li	a4,16
    800042fc:	f2c42683          	lw	a3,-212(s0)
    80004300:	fc040613          	addi	a2,s0,-64
    80004304:	4581                	li	a1,0
    80004306:	8526                	mv	a0,s1
    80004308:	815fe0ef          	jal	80002b1c <writei>
    8000430c:	47c1                	li	a5,16
    8000430e:	08f51b63          	bne	a0,a5,800043a4 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004312:	04491703          	lh	a4,68(s2)
    80004316:	4785                	li	a5,1
    80004318:	08f70d63          	beq	a4,a5,800043b2 <sys_unlink+0x14c>
  iunlockput(dp);
    8000431c:	8526                	mv	a0,s1
    8000431e:	eb8fe0ef          	jal	800029d6 <iunlockput>
  ip->nlink--;
    80004322:	04a95783          	lhu	a5,74(s2)
    80004326:	37fd                	addiw	a5,a5,-1
    80004328:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000432c:	854a                	mv	a0,s2
    8000432e:	beafe0ef          	jal	80002718 <iupdate>
  iunlockput(ip);
    80004332:	854a                	mv	a0,s2
    80004334:	ea2fe0ef          	jal	800029d6 <iunlockput>
  end_op();
    80004338:	d95fe0ef          	jal	800030cc <end_op>
  return 0;
    8000433c:	4501                	li	a0,0
    8000433e:	64ee                	ld	s1,216(sp)
    80004340:	694e                	ld	s2,208(sp)
    80004342:	a849                	j	800043d4 <sys_unlink+0x16e>
    end_op();
    80004344:	d89fe0ef          	jal	800030cc <end_op>
    return -1;
    80004348:	557d                	li	a0,-1
    8000434a:	64ee                	ld	s1,216(sp)
    8000434c:	a061                	j	800043d4 <sys_unlink+0x16e>
    8000434e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004350:	00003517          	auipc	a0,0x3
    80004354:	35850513          	addi	a0,a0,856 # 800076a8 <etext+0x6a8>
    80004358:	27a010ef          	jal	800055d2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000435c:	04c92703          	lw	a4,76(s2)
    80004360:	02000793          	li	a5,32
    80004364:	f8e7f5e3          	bgeu	a5,a4,800042ee <sys_unlink+0x88>
    80004368:	e5ce                	sd	s3,200(sp)
    8000436a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000436e:	4741                	li	a4,16
    80004370:	86ce                	mv	a3,s3
    80004372:	f1840613          	addi	a2,s0,-232
    80004376:	4581                	li	a1,0
    80004378:	854a                	mv	a0,s2
    8000437a:	ea6fe0ef          	jal	80002a20 <readi>
    8000437e:	47c1                	li	a5,16
    80004380:	00f51c63          	bne	a0,a5,80004398 <sys_unlink+0x132>
    if(de.inum != 0)
    80004384:	f1845783          	lhu	a5,-232(s0)
    80004388:	efa1                	bnez	a5,800043e0 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000438a:	29c1                	addiw	s3,s3,16
    8000438c:	04c92783          	lw	a5,76(s2)
    80004390:	fcf9efe3          	bltu	s3,a5,8000436e <sys_unlink+0x108>
    80004394:	69ae                	ld	s3,200(sp)
    80004396:	bfa1                	j	800042ee <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004398:	00003517          	auipc	a0,0x3
    8000439c:	32850513          	addi	a0,a0,808 # 800076c0 <etext+0x6c0>
    800043a0:	232010ef          	jal	800055d2 <panic>
    800043a4:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800043a6:	00003517          	auipc	a0,0x3
    800043aa:	33250513          	addi	a0,a0,818 # 800076d8 <etext+0x6d8>
    800043ae:	224010ef          	jal	800055d2 <panic>
    dp->nlink--;
    800043b2:	04a4d783          	lhu	a5,74(s1)
    800043b6:	37fd                	addiw	a5,a5,-1
    800043b8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043bc:	8526                	mv	a0,s1
    800043be:	b5afe0ef          	jal	80002718 <iupdate>
    800043c2:	bfa9                	j	8000431c <sys_unlink+0xb6>
    800043c4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043c6:	8526                	mv	a0,s1
    800043c8:	e0efe0ef          	jal	800029d6 <iunlockput>
  end_op();
    800043cc:	d01fe0ef          	jal	800030cc <end_op>
  return -1;
    800043d0:	557d                	li	a0,-1
    800043d2:	64ee                	ld	s1,216(sp)
}
    800043d4:	70ae                	ld	ra,232(sp)
    800043d6:	740e                	ld	s0,224(sp)
    800043d8:	616d                	addi	sp,sp,240
    800043da:	8082                	ret
    return -1;
    800043dc:	557d                	li	a0,-1
    800043de:	bfdd                	j	800043d4 <sys_unlink+0x16e>
    iunlockput(ip);
    800043e0:	854a                	mv	a0,s2
    800043e2:	df4fe0ef          	jal	800029d6 <iunlockput>
    goto bad;
    800043e6:	694e                	ld	s2,208(sp)
    800043e8:	69ae                	ld	s3,200(sp)
    800043ea:	bff1                	j	800043c6 <sys_unlink+0x160>

00000000800043ec <sys_open>:

uint64
sys_open(void)
{
    800043ec:	7131                	addi	sp,sp,-192
    800043ee:	fd06                	sd	ra,184(sp)
    800043f0:	f922                	sd	s0,176(sp)
    800043f2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043f4:	f4c40593          	addi	a1,s0,-180
    800043f8:	4505                	li	a0,1
    800043fa:	8b9fd0ef          	jal	80001cb2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043fe:	08000613          	li	a2,128
    80004402:	f5040593          	addi	a1,s0,-176
    80004406:	4501                	li	a0,0
    80004408:	8e3fd0ef          	jal	80001cea <argstr>
    8000440c:	87aa                	mv	a5,a0
    return -1;
    8000440e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004410:	0a07c263          	bltz	a5,800044b4 <sys_open+0xc8>
    80004414:	f526                	sd	s1,168(sp)

  begin_op();
    80004416:	c4dfe0ef          	jal	80003062 <begin_op>

  if(omode & O_CREATE){
    8000441a:	f4c42783          	lw	a5,-180(s0)
    8000441e:	2007f793          	andi	a5,a5,512
    80004422:	c3d5                	beqz	a5,800044c6 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004424:	4681                	li	a3,0
    80004426:	4601                	li	a2,0
    80004428:	4589                	li	a1,2
    8000442a:	f5040513          	addi	a0,s0,-176
    8000442e:	aa9ff0ef          	jal	80003ed6 <create>
    80004432:	84aa                	mv	s1,a0
    if(ip == 0){
    80004434:	c541                	beqz	a0,800044bc <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004436:	04449703          	lh	a4,68(s1)
    8000443a:	478d                	li	a5,3
    8000443c:	00f71763          	bne	a4,a5,8000444a <sys_open+0x5e>
    80004440:	0464d703          	lhu	a4,70(s1)
    80004444:	47a5                	li	a5,9
    80004446:	0ae7ed63          	bltu	a5,a4,80004500 <sys_open+0x114>
    8000444a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000444c:	f8dfe0ef          	jal	800033d8 <filealloc>
    80004450:	892a                	mv	s2,a0
    80004452:	c179                	beqz	a0,80004518 <sys_open+0x12c>
    80004454:	ed4e                	sd	s3,152(sp)
    80004456:	a43ff0ef          	jal	80003e98 <fdalloc>
    8000445a:	89aa                	mv	s3,a0
    8000445c:	0a054a63          	bltz	a0,80004510 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004460:	04449703          	lh	a4,68(s1)
    80004464:	478d                	li	a5,3
    80004466:	0cf70263          	beq	a4,a5,8000452a <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000446a:	4789                	li	a5,2
    8000446c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004470:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004474:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004478:	f4c42783          	lw	a5,-180(s0)
    8000447c:	0017c713          	xori	a4,a5,1
    80004480:	8b05                	andi	a4,a4,1
    80004482:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004486:	0037f713          	andi	a4,a5,3
    8000448a:	00e03733          	snez	a4,a4
    8000448e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004492:	4007f793          	andi	a5,a5,1024
    80004496:	c791                	beqz	a5,800044a2 <sys_open+0xb6>
    80004498:	04449703          	lh	a4,68(s1)
    8000449c:	4789                	li	a5,2
    8000449e:	08f70d63          	beq	a4,a5,80004538 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800044a2:	8526                	mv	a0,s1
    800044a4:	bd6fe0ef          	jal	8000287a <iunlock>
  end_op();
    800044a8:	c25fe0ef          	jal	800030cc <end_op>

  return fd;
    800044ac:	854e                	mv	a0,s3
    800044ae:	74aa                	ld	s1,168(sp)
    800044b0:	790a                	ld	s2,160(sp)
    800044b2:	69ea                	ld	s3,152(sp)
}
    800044b4:	70ea                	ld	ra,184(sp)
    800044b6:	744a                	ld	s0,176(sp)
    800044b8:	6129                	addi	sp,sp,192
    800044ba:	8082                	ret
      end_op();
    800044bc:	c11fe0ef          	jal	800030cc <end_op>
      return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	74aa                	ld	s1,168(sp)
    800044c4:	bfc5                	j	800044b4 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800044c6:	f5040513          	addi	a0,s0,-176
    800044ca:	9ddfe0ef          	jal	80002ea6 <namei>
    800044ce:	84aa                	mv	s1,a0
    800044d0:	c11d                	beqz	a0,800044f6 <sys_open+0x10a>
    ilock(ip);
    800044d2:	afafe0ef          	jal	800027cc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044d6:	04449703          	lh	a4,68(s1)
    800044da:	4785                	li	a5,1
    800044dc:	f4f71de3          	bne	a4,a5,80004436 <sys_open+0x4a>
    800044e0:	f4c42783          	lw	a5,-180(s0)
    800044e4:	d3bd                	beqz	a5,8000444a <sys_open+0x5e>
      iunlockput(ip);
    800044e6:	8526                	mv	a0,s1
    800044e8:	ceefe0ef          	jal	800029d6 <iunlockput>
      end_op();
    800044ec:	be1fe0ef          	jal	800030cc <end_op>
      return -1;
    800044f0:	557d                	li	a0,-1
    800044f2:	74aa                	ld	s1,168(sp)
    800044f4:	b7c1                	j	800044b4 <sys_open+0xc8>
      end_op();
    800044f6:	bd7fe0ef          	jal	800030cc <end_op>
      return -1;
    800044fa:	557d                	li	a0,-1
    800044fc:	74aa                	ld	s1,168(sp)
    800044fe:	bf5d                	j	800044b4 <sys_open+0xc8>
    iunlockput(ip);
    80004500:	8526                	mv	a0,s1
    80004502:	cd4fe0ef          	jal	800029d6 <iunlockput>
    end_op();
    80004506:	bc7fe0ef          	jal	800030cc <end_op>
    return -1;
    8000450a:	557d                	li	a0,-1
    8000450c:	74aa                	ld	s1,168(sp)
    8000450e:	b75d                	j	800044b4 <sys_open+0xc8>
      fileclose(f);
    80004510:	854a                	mv	a0,s2
    80004512:	f6bfe0ef          	jal	8000347c <fileclose>
    80004516:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004518:	8526                	mv	a0,s1
    8000451a:	cbcfe0ef          	jal	800029d6 <iunlockput>
    end_op();
    8000451e:	baffe0ef          	jal	800030cc <end_op>
    return -1;
    80004522:	557d                	li	a0,-1
    80004524:	74aa                	ld	s1,168(sp)
    80004526:	790a                	ld	s2,160(sp)
    80004528:	b771                	j	800044b4 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000452a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000452e:	04649783          	lh	a5,70(s1)
    80004532:	02f91223          	sh	a5,36(s2)
    80004536:	bf3d                	j	80004474 <sys_open+0x88>
    itrunc(ip);
    80004538:	8526                	mv	a0,s1
    8000453a:	b80fe0ef          	jal	800028ba <itrunc>
    8000453e:	b795                	j	800044a2 <sys_open+0xb6>

0000000080004540 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004540:	7175                	addi	sp,sp,-144
    80004542:	e506                	sd	ra,136(sp)
    80004544:	e122                	sd	s0,128(sp)
    80004546:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004548:	b1bfe0ef          	jal	80003062 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000454c:	08000613          	li	a2,128
    80004550:	f7040593          	addi	a1,s0,-144
    80004554:	4501                	li	a0,0
    80004556:	f94fd0ef          	jal	80001cea <argstr>
    8000455a:	02054363          	bltz	a0,80004580 <sys_mkdir+0x40>
    8000455e:	4681                	li	a3,0
    80004560:	4601                	li	a2,0
    80004562:	4585                	li	a1,1
    80004564:	f7040513          	addi	a0,s0,-144
    80004568:	96fff0ef          	jal	80003ed6 <create>
    8000456c:	c911                	beqz	a0,80004580 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000456e:	c68fe0ef          	jal	800029d6 <iunlockput>
  end_op();
    80004572:	b5bfe0ef          	jal	800030cc <end_op>
  return 0;
    80004576:	4501                	li	a0,0
}
    80004578:	60aa                	ld	ra,136(sp)
    8000457a:	640a                	ld	s0,128(sp)
    8000457c:	6149                	addi	sp,sp,144
    8000457e:	8082                	ret
    end_op();
    80004580:	b4dfe0ef          	jal	800030cc <end_op>
    return -1;
    80004584:	557d                	li	a0,-1
    80004586:	bfcd                	j	80004578 <sys_mkdir+0x38>

0000000080004588 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004588:	7135                	addi	sp,sp,-160
    8000458a:	ed06                	sd	ra,152(sp)
    8000458c:	e922                	sd	s0,144(sp)
    8000458e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004590:	ad3fe0ef          	jal	80003062 <begin_op>
  argint(1, &major);
    80004594:	f6c40593          	addi	a1,s0,-148
    80004598:	4505                	li	a0,1
    8000459a:	f18fd0ef          	jal	80001cb2 <argint>
  argint(2, &minor);
    8000459e:	f6840593          	addi	a1,s0,-152
    800045a2:	4509                	li	a0,2
    800045a4:	f0efd0ef          	jal	80001cb2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045a8:	08000613          	li	a2,128
    800045ac:	f7040593          	addi	a1,s0,-144
    800045b0:	4501                	li	a0,0
    800045b2:	f38fd0ef          	jal	80001cea <argstr>
    800045b6:	02054563          	bltz	a0,800045e0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045ba:	f6841683          	lh	a3,-152(s0)
    800045be:	f6c41603          	lh	a2,-148(s0)
    800045c2:	458d                	li	a1,3
    800045c4:	f7040513          	addi	a0,s0,-144
    800045c8:	90fff0ef          	jal	80003ed6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045cc:	c911                	beqz	a0,800045e0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045ce:	c08fe0ef          	jal	800029d6 <iunlockput>
  end_op();
    800045d2:	afbfe0ef          	jal	800030cc <end_op>
  return 0;
    800045d6:	4501                	li	a0,0
}
    800045d8:	60ea                	ld	ra,152(sp)
    800045da:	644a                	ld	s0,144(sp)
    800045dc:	610d                	addi	sp,sp,160
    800045de:	8082                	ret
    end_op();
    800045e0:	aedfe0ef          	jal	800030cc <end_op>
    return -1;
    800045e4:	557d                	li	a0,-1
    800045e6:	bfcd                	j	800045d8 <sys_mknod+0x50>

00000000800045e8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045e8:	7135                	addi	sp,sp,-160
    800045ea:	ed06                	sd	ra,152(sp)
    800045ec:	e922                	sd	s0,144(sp)
    800045ee:	e14a                	sd	s2,128(sp)
    800045f0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045f2:	fb6fc0ef          	jal	80000da8 <myproc>
    800045f6:	892a                	mv	s2,a0
  
  begin_op();
    800045f8:	a6bfe0ef          	jal	80003062 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045fc:	08000613          	li	a2,128
    80004600:	f6040593          	addi	a1,s0,-160
    80004604:	4501                	li	a0,0
    80004606:	ee4fd0ef          	jal	80001cea <argstr>
    8000460a:	04054363          	bltz	a0,80004650 <sys_chdir+0x68>
    8000460e:	e526                	sd	s1,136(sp)
    80004610:	f6040513          	addi	a0,s0,-160
    80004614:	893fe0ef          	jal	80002ea6 <namei>
    80004618:	84aa                	mv	s1,a0
    8000461a:	c915                	beqz	a0,8000464e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000461c:	9b0fe0ef          	jal	800027cc <ilock>
  if(ip->type != T_DIR){
    80004620:	04449703          	lh	a4,68(s1)
    80004624:	4785                	li	a5,1
    80004626:	02f71963          	bne	a4,a5,80004658 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000462a:	8526                	mv	a0,s1
    8000462c:	a4efe0ef          	jal	8000287a <iunlock>
  iput(p->cwd);
    80004630:	15093503          	ld	a0,336(s2)
    80004634:	b1afe0ef          	jal	8000294e <iput>
  end_op();
    80004638:	a95fe0ef          	jal	800030cc <end_op>
  p->cwd = ip;
    8000463c:	14993823          	sd	s1,336(s2)
  return 0;
    80004640:	4501                	li	a0,0
    80004642:	64aa                	ld	s1,136(sp)
}
    80004644:	60ea                	ld	ra,152(sp)
    80004646:	644a                	ld	s0,144(sp)
    80004648:	690a                	ld	s2,128(sp)
    8000464a:	610d                	addi	sp,sp,160
    8000464c:	8082                	ret
    8000464e:	64aa                	ld	s1,136(sp)
    end_op();
    80004650:	a7dfe0ef          	jal	800030cc <end_op>
    return -1;
    80004654:	557d                	li	a0,-1
    80004656:	b7fd                	j	80004644 <sys_chdir+0x5c>
    iunlockput(ip);
    80004658:	8526                	mv	a0,s1
    8000465a:	b7cfe0ef          	jal	800029d6 <iunlockput>
    end_op();
    8000465e:	a6ffe0ef          	jal	800030cc <end_op>
    return -1;
    80004662:	557d                	li	a0,-1
    80004664:	64aa                	ld	s1,136(sp)
    80004666:	bff9                	j	80004644 <sys_chdir+0x5c>

0000000080004668 <sys_exec>:

uint64
sys_exec(void)
{
    80004668:	7121                	addi	sp,sp,-448
    8000466a:	ff06                	sd	ra,440(sp)
    8000466c:	fb22                	sd	s0,432(sp)
    8000466e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004670:	e4840593          	addi	a1,s0,-440
    80004674:	4505                	li	a0,1
    80004676:	e58fd0ef          	jal	80001cce <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000467a:	08000613          	li	a2,128
    8000467e:	f5040593          	addi	a1,s0,-176
    80004682:	4501                	li	a0,0
    80004684:	e66fd0ef          	jal	80001cea <argstr>
    80004688:	87aa                	mv	a5,a0
    return -1;
    8000468a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000468c:	0c07c463          	bltz	a5,80004754 <sys_exec+0xec>
    80004690:	f726                	sd	s1,424(sp)
    80004692:	f34a                	sd	s2,416(sp)
    80004694:	ef4e                	sd	s3,408(sp)
    80004696:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004698:	10000613          	li	a2,256
    8000469c:	4581                	li	a1,0
    8000469e:	e5040513          	addi	a0,s0,-432
    800046a2:	aeffb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046a6:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800046aa:	89a6                	mv	s3,s1
    800046ac:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800046ae:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046b2:	00391513          	slli	a0,s2,0x3
    800046b6:	e4040593          	addi	a1,s0,-448
    800046ba:	e4843783          	ld	a5,-440(s0)
    800046be:	953e                	add	a0,a0,a5
    800046c0:	d68fd0ef          	jal	80001c28 <fetchaddr>
    800046c4:	02054663          	bltz	a0,800046f0 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046c8:	e4043783          	ld	a5,-448(s0)
    800046cc:	c3a9                	beqz	a5,8000470e <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046ce:	a31fb0ef          	jal	800000fe <kalloc>
    800046d2:	85aa                	mv	a1,a0
    800046d4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046d8:	cd01                	beqz	a0,800046f0 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046da:	6605                	lui	a2,0x1
    800046dc:	e4043503          	ld	a0,-448(s0)
    800046e0:	d92fd0ef          	jal	80001c72 <fetchstr>
    800046e4:	00054663          	bltz	a0,800046f0 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046e8:	0905                	addi	s2,s2,1
    800046ea:	09a1                	addi	s3,s3,8
    800046ec:	fd4913e3          	bne	s2,s4,800046b2 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046f0:	f5040913          	addi	s2,s0,-176
    800046f4:	6088                	ld	a0,0(s1)
    800046f6:	c931                	beqz	a0,8000474a <sys_exec+0xe2>
    kfree(argv[i]);
    800046f8:	925fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046fc:	04a1                	addi	s1,s1,8
    800046fe:	ff249be3          	bne	s1,s2,800046f4 <sys_exec+0x8c>
  return -1;
    80004702:	557d                	li	a0,-1
    80004704:	74ba                	ld	s1,424(sp)
    80004706:	791a                	ld	s2,416(sp)
    80004708:	69fa                	ld	s3,408(sp)
    8000470a:	6a5a                	ld	s4,400(sp)
    8000470c:	a0a1                	j	80004754 <sys_exec+0xec>
      argv[i] = 0;
    8000470e:	0009079b          	sext.w	a5,s2
    80004712:	078e                	slli	a5,a5,0x3
    80004714:	fd078793          	addi	a5,a5,-48
    80004718:	97a2                	add	a5,a5,s0
    8000471a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000471e:	e5040593          	addi	a1,s0,-432
    80004722:	f5040513          	addi	a0,s0,-176
    80004726:	ba8ff0ef          	jal	80003ace <exec>
    8000472a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000472c:	f5040993          	addi	s3,s0,-176
    80004730:	6088                	ld	a0,0(s1)
    80004732:	c511                	beqz	a0,8000473e <sys_exec+0xd6>
    kfree(argv[i]);
    80004734:	8e9fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004738:	04a1                	addi	s1,s1,8
    8000473a:	ff349be3          	bne	s1,s3,80004730 <sys_exec+0xc8>
  return ret;
    8000473e:	854a                	mv	a0,s2
    80004740:	74ba                	ld	s1,424(sp)
    80004742:	791a                	ld	s2,416(sp)
    80004744:	69fa                	ld	s3,408(sp)
    80004746:	6a5a                	ld	s4,400(sp)
    80004748:	a031                	j	80004754 <sys_exec+0xec>
  return -1;
    8000474a:	557d                	li	a0,-1
    8000474c:	74ba                	ld	s1,424(sp)
    8000474e:	791a                	ld	s2,416(sp)
    80004750:	69fa                	ld	s3,408(sp)
    80004752:	6a5a                	ld	s4,400(sp)
}
    80004754:	70fa                	ld	ra,440(sp)
    80004756:	745a                	ld	s0,432(sp)
    80004758:	6139                	addi	sp,sp,448
    8000475a:	8082                	ret

000000008000475c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000475c:	7139                	addi	sp,sp,-64
    8000475e:	fc06                	sd	ra,56(sp)
    80004760:	f822                	sd	s0,48(sp)
    80004762:	f426                	sd	s1,40(sp)
    80004764:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004766:	e42fc0ef          	jal	80000da8 <myproc>
    8000476a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000476c:	fd840593          	addi	a1,s0,-40
    80004770:	4501                	li	a0,0
    80004772:	d5cfd0ef          	jal	80001cce <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004776:	fc840593          	addi	a1,s0,-56
    8000477a:	fd040513          	addi	a0,s0,-48
    8000477e:	85cff0ef          	jal	800037da <pipealloc>
    return -1;
    80004782:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004784:	0a054463          	bltz	a0,8000482c <sys_pipe+0xd0>
  fd0 = -1;
    80004788:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000478c:	fd043503          	ld	a0,-48(s0)
    80004790:	f08ff0ef          	jal	80003e98 <fdalloc>
    80004794:	fca42223          	sw	a0,-60(s0)
    80004798:	08054163          	bltz	a0,8000481a <sys_pipe+0xbe>
    8000479c:	fc843503          	ld	a0,-56(s0)
    800047a0:	ef8ff0ef          	jal	80003e98 <fdalloc>
    800047a4:	fca42023          	sw	a0,-64(s0)
    800047a8:	06054063          	bltz	a0,80004808 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047ac:	4691                	li	a3,4
    800047ae:	fc440613          	addi	a2,s0,-60
    800047b2:	fd843583          	ld	a1,-40(s0)
    800047b6:	68a8                	ld	a0,80(s1)
    800047b8:	a62fc0ef          	jal	80000a1a <copyout>
    800047bc:	00054e63          	bltz	a0,800047d8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047c0:	4691                	li	a3,4
    800047c2:	fc040613          	addi	a2,s0,-64
    800047c6:	fd843583          	ld	a1,-40(s0)
    800047ca:	0591                	addi	a1,a1,4
    800047cc:	68a8                	ld	a0,80(s1)
    800047ce:	a4cfc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047d2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047d4:	04055c63          	bgez	a0,8000482c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047d8:	fc442783          	lw	a5,-60(s0)
    800047dc:	07e9                	addi	a5,a5,26
    800047de:	078e                	slli	a5,a5,0x3
    800047e0:	97a6                	add	a5,a5,s1
    800047e2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047e6:	fc042783          	lw	a5,-64(s0)
    800047ea:	07e9                	addi	a5,a5,26
    800047ec:	078e                	slli	a5,a5,0x3
    800047ee:	94be                	add	s1,s1,a5
    800047f0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047f4:	fd043503          	ld	a0,-48(s0)
    800047f8:	c85fe0ef          	jal	8000347c <fileclose>
    fileclose(wf);
    800047fc:	fc843503          	ld	a0,-56(s0)
    80004800:	c7dfe0ef          	jal	8000347c <fileclose>
    return -1;
    80004804:	57fd                	li	a5,-1
    80004806:	a01d                	j	8000482c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004808:	fc442783          	lw	a5,-60(s0)
    8000480c:	0007c763          	bltz	a5,8000481a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004810:	07e9                	addi	a5,a5,26
    80004812:	078e                	slli	a5,a5,0x3
    80004814:	97a6                	add	a5,a5,s1
    80004816:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000481a:	fd043503          	ld	a0,-48(s0)
    8000481e:	c5ffe0ef          	jal	8000347c <fileclose>
    fileclose(wf);
    80004822:	fc843503          	ld	a0,-56(s0)
    80004826:	c57fe0ef          	jal	8000347c <fileclose>
    return -1;
    8000482a:	57fd                	li	a5,-1
}
    8000482c:	853e                	mv	a0,a5
    8000482e:	70e2                	ld	ra,56(sp)
    80004830:	7442                	ld	s0,48(sp)
    80004832:	74a2                	ld	s1,40(sp)
    80004834:	6121                	addi	sp,sp,64
    80004836:	8082                	ret
	...

0000000080004840 <kernelvec>:
    80004840:	7111                	addi	sp,sp,-256
    80004842:	e006                	sd	ra,0(sp)
    80004844:	e40a                	sd	sp,8(sp)
    80004846:	e80e                	sd	gp,16(sp)
    80004848:	ec12                	sd	tp,24(sp)
    8000484a:	f016                	sd	t0,32(sp)
    8000484c:	f41a                	sd	t1,40(sp)
    8000484e:	f81e                	sd	t2,48(sp)
    80004850:	e4aa                	sd	a0,72(sp)
    80004852:	e8ae                	sd	a1,80(sp)
    80004854:	ecb2                	sd	a2,88(sp)
    80004856:	f0b6                	sd	a3,96(sp)
    80004858:	f4ba                	sd	a4,104(sp)
    8000485a:	f8be                	sd	a5,112(sp)
    8000485c:	fcc2                	sd	a6,120(sp)
    8000485e:	e146                	sd	a7,128(sp)
    80004860:	edf2                	sd	t3,216(sp)
    80004862:	f1f6                	sd	t4,224(sp)
    80004864:	f5fa                	sd	t5,232(sp)
    80004866:	f9fe                	sd	t6,240(sp)
    80004868:	ad0fd0ef          	jal	80001b38 <kerneltrap>
    8000486c:	6082                	ld	ra,0(sp)
    8000486e:	6122                	ld	sp,8(sp)
    80004870:	61c2                	ld	gp,16(sp)
    80004872:	7282                	ld	t0,32(sp)
    80004874:	7322                	ld	t1,40(sp)
    80004876:	73c2                	ld	t2,48(sp)
    80004878:	6526                	ld	a0,72(sp)
    8000487a:	65c6                	ld	a1,80(sp)
    8000487c:	6666                	ld	a2,88(sp)
    8000487e:	7686                	ld	a3,96(sp)
    80004880:	7726                	ld	a4,104(sp)
    80004882:	77c6                	ld	a5,112(sp)
    80004884:	7866                	ld	a6,120(sp)
    80004886:	688a                	ld	a7,128(sp)
    80004888:	6e6e                	ld	t3,216(sp)
    8000488a:	7e8e                	ld	t4,224(sp)
    8000488c:	7f2e                	ld	t5,232(sp)
    8000488e:	7fce                	ld	t6,240(sp)
    80004890:	6111                	addi	sp,sp,256
    80004892:	10200073          	sret
	...

000000008000489e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000489e:	1141                	addi	sp,sp,-16
    800048a0:	e422                	sd	s0,8(sp)
    800048a2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048a4:	0c0007b7          	lui	a5,0xc000
    800048a8:	4705                	li	a4,1
    800048aa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048ac:	0c0007b7          	lui	a5,0xc000
    800048b0:	c3d8                	sw	a4,4(a5)
}
    800048b2:	6422                	ld	s0,8(sp)
    800048b4:	0141                	addi	sp,sp,16
    800048b6:	8082                	ret

00000000800048b8 <plicinithart>:

void
plicinithart(void)
{
    800048b8:	1141                	addi	sp,sp,-16
    800048ba:	e406                	sd	ra,8(sp)
    800048bc:	e022                	sd	s0,0(sp)
    800048be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048c0:	cbcfc0ef          	jal	80000d7c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048c4:	0085171b          	slliw	a4,a0,0x8
    800048c8:	0c0027b7          	lui	a5,0xc002
    800048cc:	97ba                	add	a5,a5,a4
    800048ce:	40200713          	li	a4,1026
    800048d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048d6:	00d5151b          	slliw	a0,a0,0xd
    800048da:	0c2017b7          	lui	a5,0xc201
    800048de:	97aa                	add	a5,a5,a0
    800048e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048e4:	60a2                	ld	ra,8(sp)
    800048e6:	6402                	ld	s0,0(sp)
    800048e8:	0141                	addi	sp,sp,16
    800048ea:	8082                	ret

00000000800048ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048ec:	1141                	addi	sp,sp,-16
    800048ee:	e406                	sd	ra,8(sp)
    800048f0:	e022                	sd	s0,0(sp)
    800048f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048f4:	c88fc0ef          	jal	80000d7c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048f8:	00d5151b          	slliw	a0,a0,0xd
    800048fc:	0c2017b7          	lui	a5,0xc201
    80004900:	97aa                	add	a5,a5,a0
  return irq;
}
    80004902:	43c8                	lw	a0,4(a5)
    80004904:	60a2                	ld	ra,8(sp)
    80004906:	6402                	ld	s0,0(sp)
    80004908:	0141                	addi	sp,sp,16
    8000490a:	8082                	ret

000000008000490c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000490c:	1101                	addi	sp,sp,-32
    8000490e:	ec06                	sd	ra,24(sp)
    80004910:	e822                	sd	s0,16(sp)
    80004912:	e426                	sd	s1,8(sp)
    80004914:	1000                	addi	s0,sp,32
    80004916:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004918:	c64fc0ef          	jal	80000d7c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000491c:	00d5151b          	slliw	a0,a0,0xd
    80004920:	0c2017b7          	lui	a5,0xc201
    80004924:	97aa                	add	a5,a5,a0
    80004926:	c3c4                	sw	s1,4(a5)
}
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	64a2                	ld	s1,8(sp)
    8000492e:	6105                	addi	sp,sp,32
    80004930:	8082                	ret

0000000080004932 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004932:	1141                	addi	sp,sp,-16
    80004934:	e406                	sd	ra,8(sp)
    80004936:	e022                	sd	s0,0(sp)
    80004938:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000493a:	479d                	li	a5,7
    8000493c:	04a7ca63          	blt	a5,a0,80004990 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004940:	00017797          	auipc	a5,0x17
    80004944:	e9078793          	addi	a5,a5,-368 # 8001b7d0 <disk>
    80004948:	97aa                	add	a5,a5,a0
    8000494a:	0187c783          	lbu	a5,24(a5)
    8000494e:	e7b9                	bnez	a5,8000499c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004950:	00451693          	slli	a3,a0,0x4
    80004954:	00017797          	auipc	a5,0x17
    80004958:	e7c78793          	addi	a5,a5,-388 # 8001b7d0 <disk>
    8000495c:	6398                	ld	a4,0(a5)
    8000495e:	9736                	add	a4,a4,a3
    80004960:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004964:	6398                	ld	a4,0(a5)
    80004966:	9736                	add	a4,a4,a3
    80004968:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000496c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004970:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004974:	97aa                	add	a5,a5,a0
    80004976:	4705                	li	a4,1
    80004978:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000497c:	00017517          	auipc	a0,0x17
    80004980:	e6c50513          	addi	a0,a0,-404 # 8001b7e8 <disk+0x18>
    80004984:	a47fc0ef          	jal	800013ca <wakeup>
}
    80004988:	60a2                	ld	ra,8(sp)
    8000498a:	6402                	ld	s0,0(sp)
    8000498c:	0141                	addi	sp,sp,16
    8000498e:	8082                	ret
    panic("free_desc 1");
    80004990:	00003517          	auipc	a0,0x3
    80004994:	d5850513          	addi	a0,a0,-680 # 800076e8 <etext+0x6e8>
    80004998:	43b000ef          	jal	800055d2 <panic>
    panic("free_desc 2");
    8000499c:	00003517          	auipc	a0,0x3
    800049a0:	d5c50513          	addi	a0,a0,-676 # 800076f8 <etext+0x6f8>
    800049a4:	42f000ef          	jal	800055d2 <panic>

00000000800049a8 <virtio_disk_init>:
{
    800049a8:	1101                	addi	sp,sp,-32
    800049aa:	ec06                	sd	ra,24(sp)
    800049ac:	e822                	sd	s0,16(sp)
    800049ae:	e426                	sd	s1,8(sp)
    800049b0:	e04a                	sd	s2,0(sp)
    800049b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800049b4:	00003597          	auipc	a1,0x3
    800049b8:	d5458593          	addi	a1,a1,-684 # 80007708 <etext+0x708>
    800049bc:	00017517          	auipc	a0,0x17
    800049c0:	f3c50513          	addi	a0,a0,-196 # 8001b8f8 <disk+0x128>
    800049c4:	6bd000ef          	jal	80005880 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049c8:	100017b7          	lui	a5,0x10001
    800049cc:	4398                	lw	a4,0(a5)
    800049ce:	2701                	sext.w	a4,a4
    800049d0:	747277b7          	lui	a5,0x74727
    800049d4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049d8:	18f71063          	bne	a4,a5,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049dc:	100017b7          	lui	a5,0x10001
    800049e0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049e2:	439c                	lw	a5,0(a5)
    800049e4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049e6:	4709                	li	a4,2
    800049e8:	16e79863          	bne	a5,a4,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049ec:	100017b7          	lui	a5,0x10001
    800049f0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049f2:	439c                	lw	a5,0(a5)
    800049f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049f6:	16e79163          	bne	a5,a4,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049fa:	100017b7          	lui	a5,0x10001
    800049fe:	47d8                	lw	a4,12(a5)
    80004a00:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a02:	554d47b7          	lui	a5,0x554d4
    80004a06:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a0a:	14f71763          	bne	a4,a5,80004b58 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a0e:	100017b7          	lui	a5,0x10001
    80004a12:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a16:	4705                	li	a4,1
    80004a18:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a1a:	470d                	li	a4,3
    80004a1c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a1e:	10001737          	lui	a4,0x10001
    80004a22:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a24:	c7ffe737          	lui	a4,0xc7ffe
    80004a28:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdad4f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a2c:	8ef9                	and	a3,a3,a4
    80004a2e:	10001737          	lui	a4,0x10001
    80004a32:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a34:	472d                	li	a4,11
    80004a36:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a38:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a3c:	439c                	lw	a5,0(a5)
    80004a3e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a42:	8ba1                	andi	a5,a5,8
    80004a44:	12078063          	beqz	a5,80004b64 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a48:	100017b7          	lui	a5,0x10001
    80004a4c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a50:	100017b7          	lui	a5,0x10001
    80004a54:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a58:	439c                	lw	a5,0(a5)
    80004a5a:	2781                	sext.w	a5,a5
    80004a5c:	10079a63          	bnez	a5,80004b70 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a60:	100017b7          	lui	a5,0x10001
    80004a64:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a68:	439c                	lw	a5,0(a5)
    80004a6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a6c:	10078863          	beqz	a5,80004b7c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a70:	471d                	li	a4,7
    80004a72:	10f77b63          	bgeu	a4,a5,80004b88 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a76:	e88fb0ef          	jal	800000fe <kalloc>
    80004a7a:	00017497          	auipc	s1,0x17
    80004a7e:	d5648493          	addi	s1,s1,-682 # 8001b7d0 <disk>
    80004a82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a84:	e7afb0ef          	jal	800000fe <kalloc>
    80004a88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a8a:	e74fb0ef          	jal	800000fe <kalloc>
    80004a8e:	87aa                	mv	a5,a0
    80004a90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a92:	6088                	ld	a0,0(s1)
    80004a94:	10050063          	beqz	a0,80004b94 <virtio_disk_init+0x1ec>
    80004a98:	00017717          	auipc	a4,0x17
    80004a9c:	d4073703          	ld	a4,-704(a4) # 8001b7d8 <disk+0x8>
    80004aa0:	0e070a63          	beqz	a4,80004b94 <virtio_disk_init+0x1ec>
    80004aa4:	0e078863          	beqz	a5,80004b94 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004aa8:	6605                	lui	a2,0x1
    80004aaa:	4581                	li	a1,0
    80004aac:	ee4fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004ab0:	00017497          	auipc	s1,0x17
    80004ab4:	d2048493          	addi	s1,s1,-736 # 8001b7d0 <disk>
    80004ab8:	6605                	lui	a2,0x1
    80004aba:	4581                	li	a1,0
    80004abc:	6488                	ld	a0,8(s1)
    80004abe:	ed2fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    80004ac2:	6605                	lui	a2,0x1
    80004ac4:	4581                	li	a1,0
    80004ac6:	6888                	ld	a0,16(s1)
    80004ac8:	ec8fb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004acc:	100017b7          	lui	a5,0x10001
    80004ad0:	4721                	li	a4,8
    80004ad2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ad4:	4098                	lw	a4,0(s1)
    80004ad6:	100017b7          	lui	a5,0x10001
    80004ada:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004ade:	40d8                	lw	a4,4(s1)
    80004ae0:	100017b7          	lui	a5,0x10001
    80004ae4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ae8:	649c                	ld	a5,8(s1)
    80004aea:	0007869b          	sext.w	a3,a5
    80004aee:	10001737          	lui	a4,0x10001
    80004af2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004af6:	9781                	srai	a5,a5,0x20
    80004af8:	10001737          	lui	a4,0x10001
    80004afc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b00:	689c                	ld	a5,16(s1)
    80004b02:	0007869b          	sext.w	a3,a5
    80004b06:	10001737          	lui	a4,0x10001
    80004b0a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b0e:	9781                	srai	a5,a5,0x20
    80004b10:	10001737          	lui	a4,0x10001
    80004b14:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b18:	10001737          	lui	a4,0x10001
    80004b1c:	4785                	li	a5,1
    80004b1e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b20:	00f48c23          	sb	a5,24(s1)
    80004b24:	00f48ca3          	sb	a5,25(s1)
    80004b28:	00f48d23          	sb	a5,26(s1)
    80004b2c:	00f48da3          	sb	a5,27(s1)
    80004b30:	00f48e23          	sb	a5,28(s1)
    80004b34:	00f48ea3          	sb	a5,29(s1)
    80004b38:	00f48f23          	sb	a5,30(s1)
    80004b3c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b40:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b44:	100017b7          	lui	a5,0x10001
    80004b48:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b4c:	60e2                	ld	ra,24(sp)
    80004b4e:	6442                	ld	s0,16(sp)
    80004b50:	64a2                	ld	s1,8(sp)
    80004b52:	6902                	ld	s2,0(sp)
    80004b54:	6105                	addi	sp,sp,32
    80004b56:	8082                	ret
    panic("could not find virtio disk");
    80004b58:	00003517          	auipc	a0,0x3
    80004b5c:	bc050513          	addi	a0,a0,-1088 # 80007718 <etext+0x718>
    80004b60:	273000ef          	jal	800055d2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b64:	00003517          	auipc	a0,0x3
    80004b68:	bd450513          	addi	a0,a0,-1068 # 80007738 <etext+0x738>
    80004b6c:	267000ef          	jal	800055d2 <panic>
    panic("virtio disk should not be ready");
    80004b70:	00003517          	auipc	a0,0x3
    80004b74:	be850513          	addi	a0,a0,-1048 # 80007758 <etext+0x758>
    80004b78:	25b000ef          	jal	800055d2 <panic>
    panic("virtio disk has no queue 0");
    80004b7c:	00003517          	auipc	a0,0x3
    80004b80:	bfc50513          	addi	a0,a0,-1028 # 80007778 <etext+0x778>
    80004b84:	24f000ef          	jal	800055d2 <panic>
    panic("virtio disk max queue too short");
    80004b88:	00003517          	auipc	a0,0x3
    80004b8c:	c1050513          	addi	a0,a0,-1008 # 80007798 <etext+0x798>
    80004b90:	243000ef          	jal	800055d2 <panic>
    panic("virtio disk kalloc");
    80004b94:	00003517          	auipc	a0,0x3
    80004b98:	c2450513          	addi	a0,a0,-988 # 800077b8 <etext+0x7b8>
    80004b9c:	237000ef          	jal	800055d2 <panic>

0000000080004ba0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ba0:	7159                	addi	sp,sp,-112
    80004ba2:	f486                	sd	ra,104(sp)
    80004ba4:	f0a2                	sd	s0,96(sp)
    80004ba6:	eca6                	sd	s1,88(sp)
    80004ba8:	e8ca                	sd	s2,80(sp)
    80004baa:	e4ce                	sd	s3,72(sp)
    80004bac:	e0d2                	sd	s4,64(sp)
    80004bae:	fc56                	sd	s5,56(sp)
    80004bb0:	f85a                	sd	s6,48(sp)
    80004bb2:	f45e                	sd	s7,40(sp)
    80004bb4:	f062                	sd	s8,32(sp)
    80004bb6:	ec66                	sd	s9,24(sp)
    80004bb8:	1880                	addi	s0,sp,112
    80004bba:	8a2a                	mv	s4,a0
    80004bbc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bbe:	00c52c83          	lw	s9,12(a0)
    80004bc2:	001c9c9b          	slliw	s9,s9,0x1
    80004bc6:	1c82                	slli	s9,s9,0x20
    80004bc8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004bcc:	00017517          	auipc	a0,0x17
    80004bd0:	d2c50513          	addi	a0,a0,-724 # 8001b8f8 <disk+0x128>
    80004bd4:	52d000ef          	jal	80005900 <acquire>
  for(int i = 0; i < 3; i++){
    80004bd8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004bda:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bdc:	00017b17          	auipc	s6,0x17
    80004be0:	bf4b0b13          	addi	s6,s6,-1036 # 8001b7d0 <disk>
  for(int i = 0; i < 3; i++){
    80004be4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004be6:	00017c17          	auipc	s8,0x17
    80004bea:	d12c0c13          	addi	s8,s8,-750 # 8001b8f8 <disk+0x128>
    80004bee:	a8b9                	j	80004c4c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bf0:	00fb0733          	add	a4,s6,a5
    80004bf4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bf8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bfa:	0207c563          	bltz	a5,80004c24 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bfe:	2905                	addiw	s2,s2,1
    80004c00:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c02:	05590963          	beq	s2,s5,80004c54 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004c06:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c08:	00017717          	auipc	a4,0x17
    80004c0c:	bc870713          	addi	a4,a4,-1080 # 8001b7d0 <disk>
    80004c10:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004c12:	01874683          	lbu	a3,24(a4)
    80004c16:	fee9                	bnez	a3,80004bf0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004c18:	2785                	addiw	a5,a5,1
    80004c1a:	0705                	addi	a4,a4,1
    80004c1c:	fe979be3          	bne	a5,s1,80004c12 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004c20:	57fd                	li	a5,-1
    80004c22:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004c24:	01205d63          	blez	s2,80004c3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c28:	f9042503          	lw	a0,-112(s0)
    80004c2c:	d07ff0ef          	jal	80004932 <free_desc>
      for(int j = 0; j < i; j++)
    80004c30:	4785                	li	a5,1
    80004c32:	0127d663          	bge	a5,s2,80004c3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c36:	f9442503          	lw	a0,-108(s0)
    80004c3a:	cf9ff0ef          	jal	80004932 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c3e:	85e2                	mv	a1,s8
    80004c40:	00017517          	auipc	a0,0x17
    80004c44:	ba850513          	addi	a0,a0,-1112 # 8001b7e8 <disk+0x18>
    80004c48:	f36fc0ef          	jal	8000137e <sleep>
  for(int i = 0; i < 3; i++){
    80004c4c:	f9040613          	addi	a2,s0,-112
    80004c50:	894e                	mv	s2,s3
    80004c52:	bf55                	j	80004c06 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c54:	f9042503          	lw	a0,-112(s0)
    80004c58:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c5c:	00017797          	auipc	a5,0x17
    80004c60:	b7478793          	addi	a5,a5,-1164 # 8001b7d0 <disk>
    80004c64:	00a50713          	addi	a4,a0,10
    80004c68:	0712                	slli	a4,a4,0x4
    80004c6a:	973e                	add	a4,a4,a5
    80004c6c:	01703633          	snez	a2,s7
    80004c70:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c72:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c76:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c7a:	6398                	ld	a4,0(a5)
    80004c7c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c7e:	0a868613          	addi	a2,a3,168
    80004c82:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c84:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c86:	6390                	ld	a2,0(a5)
    80004c88:	00d605b3          	add	a1,a2,a3
    80004c8c:	4741                	li	a4,16
    80004c8e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c90:	4805                	li	a6,1
    80004c92:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c96:	f9442703          	lw	a4,-108(s0)
    80004c9a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c9e:	0712                	slli	a4,a4,0x4
    80004ca0:	963a                	add	a2,a2,a4
    80004ca2:	058a0593          	addi	a1,s4,88
    80004ca6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ca8:	0007b883          	ld	a7,0(a5)
    80004cac:	9746                	add	a4,a4,a7
    80004cae:	40000613          	li	a2,1024
    80004cb2:	c710                	sw	a2,8(a4)
  if(write)
    80004cb4:	001bb613          	seqz	a2,s7
    80004cb8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cbc:	00166613          	ori	a2,a2,1
    80004cc0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004cc4:	f9842583          	lw	a1,-104(s0)
    80004cc8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ccc:	00250613          	addi	a2,a0,2
    80004cd0:	0612                	slli	a2,a2,0x4
    80004cd2:	963e                	add	a2,a2,a5
    80004cd4:	577d                	li	a4,-1
    80004cd6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cda:	0592                	slli	a1,a1,0x4
    80004cdc:	98ae                	add	a7,a7,a1
    80004cde:	03068713          	addi	a4,a3,48
    80004ce2:	973e                	add	a4,a4,a5
    80004ce4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004ce8:	6398                	ld	a4,0(a5)
    80004cea:	972e                	add	a4,a4,a1
    80004cec:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cf0:	4689                	li	a3,2
    80004cf2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cf6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cfa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cfe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d02:	6794                	ld	a3,8(a5)
    80004d04:	0026d703          	lhu	a4,2(a3)
    80004d08:	8b1d                	andi	a4,a4,7
    80004d0a:	0706                	slli	a4,a4,0x1
    80004d0c:	96ba                	add	a3,a3,a4
    80004d0e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d12:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d16:	6798                	ld	a4,8(a5)
    80004d18:	00275783          	lhu	a5,2(a4)
    80004d1c:	2785                	addiw	a5,a5,1
    80004d1e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d22:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d26:	100017b7          	lui	a5,0x10001
    80004d2a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d2e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d32:	00017917          	auipc	s2,0x17
    80004d36:	bc690913          	addi	s2,s2,-1082 # 8001b8f8 <disk+0x128>
  while(b->disk == 1) {
    80004d3a:	4485                	li	s1,1
    80004d3c:	01079a63          	bne	a5,a6,80004d50 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d40:	85ca                	mv	a1,s2
    80004d42:	8552                	mv	a0,s4
    80004d44:	e3afc0ef          	jal	8000137e <sleep>
  while(b->disk == 1) {
    80004d48:	004a2783          	lw	a5,4(s4)
    80004d4c:	fe978ae3          	beq	a5,s1,80004d40 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d50:	f9042903          	lw	s2,-112(s0)
    80004d54:	00290713          	addi	a4,s2,2
    80004d58:	0712                	slli	a4,a4,0x4
    80004d5a:	00017797          	auipc	a5,0x17
    80004d5e:	a7678793          	addi	a5,a5,-1418 # 8001b7d0 <disk>
    80004d62:	97ba                	add	a5,a5,a4
    80004d64:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d68:	00017997          	auipc	s3,0x17
    80004d6c:	a6898993          	addi	s3,s3,-1432 # 8001b7d0 <disk>
    80004d70:	00491713          	slli	a4,s2,0x4
    80004d74:	0009b783          	ld	a5,0(s3)
    80004d78:	97ba                	add	a5,a5,a4
    80004d7a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d7e:	854a                	mv	a0,s2
    80004d80:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d84:	bafff0ef          	jal	80004932 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d88:	8885                	andi	s1,s1,1
    80004d8a:	f0fd                	bnez	s1,80004d70 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d8c:	00017517          	auipc	a0,0x17
    80004d90:	b6c50513          	addi	a0,a0,-1172 # 8001b8f8 <disk+0x128>
    80004d94:	405000ef          	jal	80005998 <release>
}
    80004d98:	70a6                	ld	ra,104(sp)
    80004d9a:	7406                	ld	s0,96(sp)
    80004d9c:	64e6                	ld	s1,88(sp)
    80004d9e:	6946                	ld	s2,80(sp)
    80004da0:	69a6                	ld	s3,72(sp)
    80004da2:	6a06                	ld	s4,64(sp)
    80004da4:	7ae2                	ld	s5,56(sp)
    80004da6:	7b42                	ld	s6,48(sp)
    80004da8:	7ba2                	ld	s7,40(sp)
    80004daa:	7c02                	ld	s8,32(sp)
    80004dac:	6ce2                	ld	s9,24(sp)
    80004dae:	6165                	addi	sp,sp,112
    80004db0:	8082                	ret

0000000080004db2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004db2:	1101                	addi	sp,sp,-32
    80004db4:	ec06                	sd	ra,24(sp)
    80004db6:	e822                	sd	s0,16(sp)
    80004db8:	e426                	sd	s1,8(sp)
    80004dba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004dbc:	00017497          	auipc	s1,0x17
    80004dc0:	a1448493          	addi	s1,s1,-1516 # 8001b7d0 <disk>
    80004dc4:	00017517          	auipc	a0,0x17
    80004dc8:	b3450513          	addi	a0,a0,-1228 # 8001b8f8 <disk+0x128>
    80004dcc:	335000ef          	jal	80005900 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004dd0:	100017b7          	lui	a5,0x10001
    80004dd4:	53b8                	lw	a4,96(a5)
    80004dd6:	8b0d                	andi	a4,a4,3
    80004dd8:	100017b7          	lui	a5,0x10001
    80004ddc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dde:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004de2:	689c                	ld	a5,16(s1)
    80004de4:	0204d703          	lhu	a4,32(s1)
    80004de8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dec:	04f70663          	beq	a4,a5,80004e38 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004df0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004df4:	6898                	ld	a4,16(s1)
    80004df6:	0204d783          	lhu	a5,32(s1)
    80004dfa:	8b9d                	andi	a5,a5,7
    80004dfc:	078e                	slli	a5,a5,0x3
    80004dfe:	97ba                	add	a5,a5,a4
    80004e00:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e02:	00278713          	addi	a4,a5,2
    80004e06:	0712                	slli	a4,a4,0x4
    80004e08:	9726                	add	a4,a4,s1
    80004e0a:	01074703          	lbu	a4,16(a4)
    80004e0e:	e321                	bnez	a4,80004e4e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e10:	0789                	addi	a5,a5,2
    80004e12:	0792                	slli	a5,a5,0x4
    80004e14:	97a6                	add	a5,a5,s1
    80004e16:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e18:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e1c:	daefc0ef          	jal	800013ca <wakeup>

    disk.used_idx += 1;
    80004e20:	0204d783          	lhu	a5,32(s1)
    80004e24:	2785                	addiw	a5,a5,1
    80004e26:	17c2                	slli	a5,a5,0x30
    80004e28:	93c1                	srli	a5,a5,0x30
    80004e2a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e2e:	6898                	ld	a4,16(s1)
    80004e30:	00275703          	lhu	a4,2(a4)
    80004e34:	faf71ee3          	bne	a4,a5,80004df0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e38:	00017517          	auipc	a0,0x17
    80004e3c:	ac050513          	addi	a0,a0,-1344 # 8001b8f8 <disk+0x128>
    80004e40:	359000ef          	jal	80005998 <release>
}
    80004e44:	60e2                	ld	ra,24(sp)
    80004e46:	6442                	ld	s0,16(sp)
    80004e48:	64a2                	ld	s1,8(sp)
    80004e4a:	6105                	addi	sp,sp,32
    80004e4c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e4e:	00003517          	auipc	a0,0x3
    80004e52:	98250513          	addi	a0,a0,-1662 # 800077d0 <etext+0x7d0>
    80004e56:	77c000ef          	jal	800055d2 <panic>

0000000080004e5a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e5a:	1141                	addi	sp,sp,-16
    80004e5c:	e422                	sd	s0,8(sp)
    80004e5e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e60:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e64:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e68:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e6c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e70:	577d                	li	a4,-1
    80004e72:	177e                	slli	a4,a4,0x3f
    80004e74:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e76:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e7a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e82:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e86:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e8a:	000f4737          	lui	a4,0xf4
    80004e8e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e92:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e94:	14d79073          	csrw	stimecmp,a5
}
    80004e98:	6422                	ld	s0,8(sp)
    80004e9a:	0141                	addi	sp,sp,16
    80004e9c:	8082                	ret

0000000080004e9e <start>:
{
    80004e9e:	1141                	addi	sp,sp,-16
    80004ea0:	e406                	sd	ra,8(sp)
    80004ea2:	e022                	sd	s0,0(sp)
    80004ea4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ea6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004eaa:	7779                	lui	a4,0xffffe
    80004eac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdadef>
    80004eb0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004eb2:	6705                	lui	a4,0x1
    80004eb4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004eb8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004eba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ebe:	ffffb797          	auipc	a5,0xffffb
    80004ec2:	46c78793          	addi	a5,a5,1132 # 8000032a <main>
    80004ec6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004eca:	4781                	li	a5,0
    80004ecc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ed0:	67c1                	lui	a5,0x10
    80004ed2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ed4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ed8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004edc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004ee0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ee4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ee8:	57fd                	li	a5,-1
    80004eea:	83a9                	srli	a5,a5,0xa
    80004eec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ef0:	47bd                	li	a5,15
    80004ef2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ef6:	f65ff0ef          	jal	80004e5a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004efa:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004efe:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f00:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f02:	30200073          	mret
}
    80004f06:	60a2                	ld	ra,8(sp)
    80004f08:	6402                	ld	s0,0(sp)
    80004f0a:	0141                	addi	sp,sp,16
    80004f0c:	8082                	ret

0000000080004f0e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f0e:	715d                	addi	sp,sp,-80
    80004f10:	e486                	sd	ra,72(sp)
    80004f12:	e0a2                	sd	s0,64(sp)
    80004f14:	f84a                	sd	s2,48(sp)
    80004f16:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004f18:	04c05263          	blez	a2,80004f5c <consolewrite+0x4e>
    80004f1c:	fc26                	sd	s1,56(sp)
    80004f1e:	f44e                	sd	s3,40(sp)
    80004f20:	f052                	sd	s4,32(sp)
    80004f22:	ec56                	sd	s5,24(sp)
    80004f24:	8a2a                	mv	s4,a0
    80004f26:	84ae                	mv	s1,a1
    80004f28:	89b2                	mv	s3,a2
    80004f2a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f2c:	5afd                	li	s5,-1
    80004f2e:	4685                	li	a3,1
    80004f30:	8626                	mv	a2,s1
    80004f32:	85d2                	mv	a1,s4
    80004f34:	fbf40513          	addi	a0,s0,-65
    80004f38:	fecfc0ef          	jal	80001724 <either_copyin>
    80004f3c:	03550263          	beq	a0,s5,80004f60 <consolewrite+0x52>
      break;
    uartputc(c);
    80004f40:	fbf44503          	lbu	a0,-65(s0)
    80004f44:	035000ef          	jal	80005778 <uartputc>
  for(i = 0; i < n; i++){
    80004f48:	2905                	addiw	s2,s2,1
    80004f4a:	0485                	addi	s1,s1,1
    80004f4c:	ff2991e3          	bne	s3,s2,80004f2e <consolewrite+0x20>
    80004f50:	894e                	mv	s2,s3
    80004f52:	74e2                	ld	s1,56(sp)
    80004f54:	79a2                	ld	s3,40(sp)
    80004f56:	7a02                	ld	s4,32(sp)
    80004f58:	6ae2                	ld	s5,24(sp)
    80004f5a:	a039                	j	80004f68 <consolewrite+0x5a>
    80004f5c:	4901                	li	s2,0
    80004f5e:	a029                	j	80004f68 <consolewrite+0x5a>
    80004f60:	74e2                	ld	s1,56(sp)
    80004f62:	79a2                	ld	s3,40(sp)
    80004f64:	7a02                	ld	s4,32(sp)
    80004f66:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004f68:	854a                	mv	a0,s2
    80004f6a:	60a6                	ld	ra,72(sp)
    80004f6c:	6406                	ld	s0,64(sp)
    80004f6e:	7942                	ld	s2,48(sp)
    80004f70:	6161                	addi	sp,sp,80
    80004f72:	8082                	ret

0000000080004f74 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f74:	711d                	addi	sp,sp,-96
    80004f76:	ec86                	sd	ra,88(sp)
    80004f78:	e8a2                	sd	s0,80(sp)
    80004f7a:	e4a6                	sd	s1,72(sp)
    80004f7c:	e0ca                	sd	s2,64(sp)
    80004f7e:	fc4e                	sd	s3,56(sp)
    80004f80:	f852                	sd	s4,48(sp)
    80004f82:	f456                	sd	s5,40(sp)
    80004f84:	f05a                	sd	s6,32(sp)
    80004f86:	1080                	addi	s0,sp,96
    80004f88:	8aaa                	mv	s5,a0
    80004f8a:	8a2e                	mv	s4,a1
    80004f8c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f8e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f92:	0001f517          	auipc	a0,0x1f
    80004f96:	97e50513          	addi	a0,a0,-1666 # 80023910 <cons>
    80004f9a:	167000ef          	jal	80005900 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f9e:	0001f497          	auipc	s1,0x1f
    80004fa2:	97248493          	addi	s1,s1,-1678 # 80023910 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fa6:	0001f917          	auipc	s2,0x1f
    80004faa:	a0290913          	addi	s2,s2,-1534 # 800239a8 <cons+0x98>
  while(n > 0){
    80004fae:	0b305d63          	blez	s3,80005068 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004fb2:	0984a783          	lw	a5,152(s1)
    80004fb6:	09c4a703          	lw	a4,156(s1)
    80004fba:	0af71263          	bne	a4,a5,8000505e <consoleread+0xea>
      if(killed(myproc())){
    80004fbe:	debfb0ef          	jal	80000da8 <myproc>
    80004fc2:	df4fc0ef          	jal	800015b6 <killed>
    80004fc6:	e12d                	bnez	a0,80005028 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004fc8:	85a6                	mv	a1,s1
    80004fca:	854a                	mv	a0,s2
    80004fcc:	bb2fc0ef          	jal	8000137e <sleep>
    while(cons.r == cons.w){
    80004fd0:	0984a783          	lw	a5,152(s1)
    80004fd4:	09c4a703          	lw	a4,156(s1)
    80004fd8:	fef703e3          	beq	a4,a5,80004fbe <consoleread+0x4a>
    80004fdc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fde:	0001f717          	auipc	a4,0x1f
    80004fe2:	93270713          	addi	a4,a4,-1742 # 80023910 <cons>
    80004fe6:	0017869b          	addiw	a3,a5,1
    80004fea:	08d72c23          	sw	a3,152(a4)
    80004fee:	07f7f693          	andi	a3,a5,127
    80004ff2:	9736                	add	a4,a4,a3
    80004ff4:	01874703          	lbu	a4,24(a4)
    80004ff8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004ffc:	4691                	li	a3,4
    80004ffe:	04db8663          	beq	s7,a3,8000504a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005002:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005006:	4685                	li	a3,1
    80005008:	faf40613          	addi	a2,s0,-81
    8000500c:	85d2                	mv	a1,s4
    8000500e:	8556                	mv	a0,s5
    80005010:	ecafc0ef          	jal	800016da <either_copyout>
    80005014:	57fd                	li	a5,-1
    80005016:	04f50863          	beq	a0,a5,80005066 <consoleread+0xf2>
      break;

    dst++;
    8000501a:	0a05                	addi	s4,s4,1
    --n;
    8000501c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000501e:	47a9                	li	a5,10
    80005020:	04fb8d63          	beq	s7,a5,8000507a <consoleread+0x106>
    80005024:	6be2                	ld	s7,24(sp)
    80005026:	b761                	j	80004fae <consoleread+0x3a>
        release(&cons.lock);
    80005028:	0001f517          	auipc	a0,0x1f
    8000502c:	8e850513          	addi	a0,a0,-1816 # 80023910 <cons>
    80005030:	169000ef          	jal	80005998 <release>
        return -1;
    80005034:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005036:	60e6                	ld	ra,88(sp)
    80005038:	6446                	ld	s0,80(sp)
    8000503a:	64a6                	ld	s1,72(sp)
    8000503c:	6906                	ld	s2,64(sp)
    8000503e:	79e2                	ld	s3,56(sp)
    80005040:	7a42                	ld	s4,48(sp)
    80005042:	7aa2                	ld	s5,40(sp)
    80005044:	7b02                	ld	s6,32(sp)
    80005046:	6125                	addi	sp,sp,96
    80005048:	8082                	ret
      if(n < target){
    8000504a:	0009871b          	sext.w	a4,s3
    8000504e:	01677a63          	bgeu	a4,s6,80005062 <consoleread+0xee>
        cons.r--;
    80005052:	0001f717          	auipc	a4,0x1f
    80005056:	94f72b23          	sw	a5,-1706(a4) # 800239a8 <cons+0x98>
    8000505a:	6be2                	ld	s7,24(sp)
    8000505c:	a031                	j	80005068 <consoleread+0xf4>
    8000505e:	ec5e                	sd	s7,24(sp)
    80005060:	bfbd                	j	80004fde <consoleread+0x6a>
    80005062:	6be2                	ld	s7,24(sp)
    80005064:	a011                	j	80005068 <consoleread+0xf4>
    80005066:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005068:	0001f517          	auipc	a0,0x1f
    8000506c:	8a850513          	addi	a0,a0,-1880 # 80023910 <cons>
    80005070:	129000ef          	jal	80005998 <release>
  return target - n;
    80005074:	413b053b          	subw	a0,s6,s3
    80005078:	bf7d                	j	80005036 <consoleread+0xc2>
    8000507a:	6be2                	ld	s7,24(sp)
    8000507c:	b7f5                	j	80005068 <consoleread+0xf4>

000000008000507e <consputc>:
{
    8000507e:	1141                	addi	sp,sp,-16
    80005080:	e406                	sd	ra,8(sp)
    80005082:	e022                	sd	s0,0(sp)
    80005084:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005086:	10000793          	li	a5,256
    8000508a:	00f50863          	beq	a0,a5,8000509a <consputc+0x1c>
    uartputc_sync(c);
    8000508e:	604000ef          	jal	80005692 <uartputc_sync>
}
    80005092:	60a2                	ld	ra,8(sp)
    80005094:	6402                	ld	s0,0(sp)
    80005096:	0141                	addi	sp,sp,16
    80005098:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000509a:	4521                	li	a0,8
    8000509c:	5f6000ef          	jal	80005692 <uartputc_sync>
    800050a0:	02000513          	li	a0,32
    800050a4:	5ee000ef          	jal	80005692 <uartputc_sync>
    800050a8:	4521                	li	a0,8
    800050aa:	5e8000ef          	jal	80005692 <uartputc_sync>
    800050ae:	b7d5                	j	80005092 <consputc+0x14>

00000000800050b0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050b0:	1101                	addi	sp,sp,-32
    800050b2:	ec06                	sd	ra,24(sp)
    800050b4:	e822                	sd	s0,16(sp)
    800050b6:	e426                	sd	s1,8(sp)
    800050b8:	1000                	addi	s0,sp,32
    800050ba:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050bc:	0001f517          	auipc	a0,0x1f
    800050c0:	85450513          	addi	a0,a0,-1964 # 80023910 <cons>
    800050c4:	03d000ef          	jal	80005900 <acquire>

  switch(c){
    800050c8:	47d5                	li	a5,21
    800050ca:	08f48f63          	beq	s1,a5,80005168 <consoleintr+0xb8>
    800050ce:	0297c563          	blt	a5,s1,800050f8 <consoleintr+0x48>
    800050d2:	47a1                	li	a5,8
    800050d4:	0ef48463          	beq	s1,a5,800051bc <consoleintr+0x10c>
    800050d8:	47c1                	li	a5,16
    800050da:	10f49563          	bne	s1,a5,800051e4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050de:	e90fc0ef          	jal	8000176e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050e2:	0001f517          	auipc	a0,0x1f
    800050e6:	82e50513          	addi	a0,a0,-2002 # 80023910 <cons>
    800050ea:	0af000ef          	jal	80005998 <release>
}
    800050ee:	60e2                	ld	ra,24(sp)
    800050f0:	6442                	ld	s0,16(sp)
    800050f2:	64a2                	ld	s1,8(sp)
    800050f4:	6105                	addi	sp,sp,32
    800050f6:	8082                	ret
  switch(c){
    800050f8:	07f00793          	li	a5,127
    800050fc:	0cf48063          	beq	s1,a5,800051bc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005100:	0001f717          	auipc	a4,0x1f
    80005104:	81070713          	addi	a4,a4,-2032 # 80023910 <cons>
    80005108:	0a072783          	lw	a5,160(a4)
    8000510c:	09872703          	lw	a4,152(a4)
    80005110:	9f99                	subw	a5,a5,a4
    80005112:	07f00713          	li	a4,127
    80005116:	fcf766e3          	bltu	a4,a5,800050e2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000511a:	47b5                	li	a5,13
    8000511c:	0cf48763          	beq	s1,a5,800051ea <consoleintr+0x13a>
      consputc(c);
    80005120:	8526                	mv	a0,s1
    80005122:	f5dff0ef          	jal	8000507e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005126:	0001e797          	auipc	a5,0x1e
    8000512a:	7ea78793          	addi	a5,a5,2026 # 80023910 <cons>
    8000512e:	0a07a683          	lw	a3,160(a5)
    80005132:	0016871b          	addiw	a4,a3,1
    80005136:	0007061b          	sext.w	a2,a4
    8000513a:	0ae7a023          	sw	a4,160(a5)
    8000513e:	07f6f693          	andi	a3,a3,127
    80005142:	97b6                	add	a5,a5,a3
    80005144:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005148:	47a9                	li	a5,10
    8000514a:	0cf48563          	beq	s1,a5,80005214 <consoleintr+0x164>
    8000514e:	4791                	li	a5,4
    80005150:	0cf48263          	beq	s1,a5,80005214 <consoleintr+0x164>
    80005154:	0001f797          	auipc	a5,0x1f
    80005158:	8547a783          	lw	a5,-1964(a5) # 800239a8 <cons+0x98>
    8000515c:	9f1d                	subw	a4,a4,a5
    8000515e:	08000793          	li	a5,128
    80005162:	f8f710e3          	bne	a4,a5,800050e2 <consoleintr+0x32>
    80005166:	a07d                	j	80005214 <consoleintr+0x164>
    80005168:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000516a:	0001e717          	auipc	a4,0x1e
    8000516e:	7a670713          	addi	a4,a4,1958 # 80023910 <cons>
    80005172:	0a072783          	lw	a5,160(a4)
    80005176:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000517a:	0001e497          	auipc	s1,0x1e
    8000517e:	79648493          	addi	s1,s1,1942 # 80023910 <cons>
    while(cons.e != cons.w &&
    80005182:	4929                	li	s2,10
    80005184:	02f70863          	beq	a4,a5,800051b4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005188:	37fd                	addiw	a5,a5,-1
    8000518a:	07f7f713          	andi	a4,a5,127
    8000518e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005190:	01874703          	lbu	a4,24(a4)
    80005194:	03270263          	beq	a4,s2,800051b8 <consoleintr+0x108>
      cons.e--;
    80005198:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000519c:	10000513          	li	a0,256
    800051a0:	edfff0ef          	jal	8000507e <consputc>
    while(cons.e != cons.w &&
    800051a4:	0a04a783          	lw	a5,160(s1)
    800051a8:	09c4a703          	lw	a4,156(s1)
    800051ac:	fcf71ee3          	bne	a4,a5,80005188 <consoleintr+0xd8>
    800051b0:	6902                	ld	s2,0(sp)
    800051b2:	bf05                	j	800050e2 <consoleintr+0x32>
    800051b4:	6902                	ld	s2,0(sp)
    800051b6:	b735                	j	800050e2 <consoleintr+0x32>
    800051b8:	6902                	ld	s2,0(sp)
    800051ba:	b725                	j	800050e2 <consoleintr+0x32>
    if(cons.e != cons.w){
    800051bc:	0001e717          	auipc	a4,0x1e
    800051c0:	75470713          	addi	a4,a4,1876 # 80023910 <cons>
    800051c4:	0a072783          	lw	a5,160(a4)
    800051c8:	09c72703          	lw	a4,156(a4)
    800051cc:	f0f70be3          	beq	a4,a5,800050e2 <consoleintr+0x32>
      cons.e--;
    800051d0:	37fd                	addiw	a5,a5,-1
    800051d2:	0001e717          	auipc	a4,0x1e
    800051d6:	7cf72f23          	sw	a5,2014(a4) # 800239b0 <cons+0xa0>
      consputc(BACKSPACE);
    800051da:	10000513          	li	a0,256
    800051de:	ea1ff0ef          	jal	8000507e <consputc>
    800051e2:	b701                	j	800050e2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051e4:	ee048fe3          	beqz	s1,800050e2 <consoleintr+0x32>
    800051e8:	bf21                	j	80005100 <consoleintr+0x50>
      consputc(c);
    800051ea:	4529                	li	a0,10
    800051ec:	e93ff0ef          	jal	8000507e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051f0:	0001e797          	auipc	a5,0x1e
    800051f4:	72078793          	addi	a5,a5,1824 # 80023910 <cons>
    800051f8:	0a07a703          	lw	a4,160(a5)
    800051fc:	0017069b          	addiw	a3,a4,1
    80005200:	0006861b          	sext.w	a2,a3
    80005204:	0ad7a023          	sw	a3,160(a5)
    80005208:	07f77713          	andi	a4,a4,127
    8000520c:	97ba                	add	a5,a5,a4
    8000520e:	4729                	li	a4,10
    80005210:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005214:	0001e797          	auipc	a5,0x1e
    80005218:	78c7ac23          	sw	a2,1944(a5) # 800239ac <cons+0x9c>
        wakeup(&cons.r);
    8000521c:	0001e517          	auipc	a0,0x1e
    80005220:	78c50513          	addi	a0,a0,1932 # 800239a8 <cons+0x98>
    80005224:	9a6fc0ef          	jal	800013ca <wakeup>
    80005228:	bd6d                	j	800050e2 <consoleintr+0x32>

000000008000522a <consoleinit>:

void
consoleinit(void)
{
    8000522a:	1141                	addi	sp,sp,-16
    8000522c:	e406                	sd	ra,8(sp)
    8000522e:	e022                	sd	s0,0(sp)
    80005230:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005232:	00002597          	auipc	a1,0x2
    80005236:	5b658593          	addi	a1,a1,1462 # 800077e8 <etext+0x7e8>
    8000523a:	0001e517          	auipc	a0,0x1e
    8000523e:	6d650513          	addi	a0,a0,1750 # 80023910 <cons>
    80005242:	63e000ef          	jal	80005880 <initlock>

  uartinit();
    80005246:	3f4000ef          	jal	8000563a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000524a:	00015797          	auipc	a5,0x15
    8000524e:	52e78793          	addi	a5,a5,1326 # 8001a778 <devsw>
    80005252:	00000717          	auipc	a4,0x0
    80005256:	d2270713          	addi	a4,a4,-734 # 80004f74 <consoleread>
    8000525a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000525c:	00000717          	auipc	a4,0x0
    80005260:	cb270713          	addi	a4,a4,-846 # 80004f0e <consolewrite>
    80005264:	ef98                	sd	a4,24(a5)
}
    80005266:	60a2                	ld	ra,8(sp)
    80005268:	6402                	ld	s0,0(sp)
    8000526a:	0141                	addi	sp,sp,16
    8000526c:	8082                	ret

000000008000526e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000526e:	7179                	addi	sp,sp,-48
    80005270:	f406                	sd	ra,40(sp)
    80005272:	f022                	sd	s0,32(sp)
    80005274:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005276:	c219                	beqz	a2,8000527c <printint+0xe>
    80005278:	08054063          	bltz	a0,800052f8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000527c:	4881                	li	a7,0
    8000527e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005282:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005284:	00002617          	auipc	a2,0x2
    80005288:	79c60613          	addi	a2,a2,1948 # 80007a20 <digits>
    8000528c:	883e                	mv	a6,a5
    8000528e:	2785                	addiw	a5,a5,1
    80005290:	02b57733          	remu	a4,a0,a1
    80005294:	9732                	add	a4,a4,a2
    80005296:	00074703          	lbu	a4,0(a4)
    8000529a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000529e:	872a                	mv	a4,a0
    800052a0:	02b55533          	divu	a0,a0,a1
    800052a4:	0685                	addi	a3,a3,1
    800052a6:	feb773e3          	bgeu	a4,a1,8000528c <printint+0x1e>

  if(sign)
    800052aa:	00088a63          	beqz	a7,800052be <printint+0x50>
    buf[i++] = '-';
    800052ae:	1781                	addi	a5,a5,-32
    800052b0:	97a2                	add	a5,a5,s0
    800052b2:	02d00713          	li	a4,45
    800052b6:	fee78823          	sb	a4,-16(a5)
    800052ba:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800052be:	02f05963          	blez	a5,800052f0 <printint+0x82>
    800052c2:	ec26                	sd	s1,24(sp)
    800052c4:	e84a                	sd	s2,16(sp)
    800052c6:	fd040713          	addi	a4,s0,-48
    800052ca:	00f704b3          	add	s1,a4,a5
    800052ce:	fff70913          	addi	s2,a4,-1
    800052d2:	993e                	add	s2,s2,a5
    800052d4:	37fd                	addiw	a5,a5,-1
    800052d6:	1782                	slli	a5,a5,0x20
    800052d8:	9381                	srli	a5,a5,0x20
    800052da:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052de:	fff4c503          	lbu	a0,-1(s1)
    800052e2:	d9dff0ef          	jal	8000507e <consputc>
  while(--i >= 0)
    800052e6:	14fd                	addi	s1,s1,-1
    800052e8:	ff249be3          	bne	s1,s2,800052de <printint+0x70>
    800052ec:	64e2                	ld	s1,24(sp)
    800052ee:	6942                	ld	s2,16(sp)
}
    800052f0:	70a2                	ld	ra,40(sp)
    800052f2:	7402                	ld	s0,32(sp)
    800052f4:	6145                	addi	sp,sp,48
    800052f6:	8082                	ret
    x = -xx;
    800052f8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800052fc:	4885                	li	a7,1
    x = -xx;
    800052fe:	b741                	j	8000527e <printint+0x10>

0000000080005300 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005300:	7155                	addi	sp,sp,-208
    80005302:	e506                	sd	ra,136(sp)
    80005304:	e122                	sd	s0,128(sp)
    80005306:	f0d2                	sd	s4,96(sp)
    80005308:	0900                	addi	s0,sp,144
    8000530a:	8a2a                	mv	s4,a0
    8000530c:	e40c                	sd	a1,8(s0)
    8000530e:	e810                	sd	a2,16(s0)
    80005310:	ec14                	sd	a3,24(s0)
    80005312:	f018                	sd	a4,32(s0)
    80005314:	f41c                	sd	a5,40(s0)
    80005316:	03043823          	sd	a6,48(s0)
    8000531a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000531e:	0001e797          	auipc	a5,0x1e
    80005322:	6b27a783          	lw	a5,1714(a5) # 800239d0 <pr+0x18>
    80005326:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000532a:	e3a1                	bnez	a5,8000536a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000532c:	00840793          	addi	a5,s0,8
    80005330:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005334:	00054503          	lbu	a0,0(a0)
    80005338:	26050763          	beqz	a0,800055a6 <printf+0x2a6>
    8000533c:	fca6                	sd	s1,120(sp)
    8000533e:	f8ca                	sd	s2,112(sp)
    80005340:	f4ce                	sd	s3,104(sp)
    80005342:	ecd6                	sd	s5,88(sp)
    80005344:	e8da                	sd	s6,80(sp)
    80005346:	e0e2                	sd	s8,64(sp)
    80005348:	fc66                	sd	s9,56(sp)
    8000534a:	f86a                	sd	s10,48(sp)
    8000534c:	f46e                	sd	s11,40(sp)
    8000534e:	4981                	li	s3,0
    if(cx != '%'){
    80005350:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005354:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005358:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000535c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005360:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005364:	07000d93          	li	s11,112
    80005368:	a815                	j	8000539c <printf+0x9c>
    acquire(&pr.lock);
    8000536a:	0001e517          	auipc	a0,0x1e
    8000536e:	64e50513          	addi	a0,a0,1614 # 800239b8 <pr>
    80005372:	58e000ef          	jal	80005900 <acquire>
  va_start(ap, fmt);
    80005376:	00840793          	addi	a5,s0,8
    8000537a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000537e:	000a4503          	lbu	a0,0(s4)
    80005382:	fd4d                	bnez	a0,8000533c <printf+0x3c>
    80005384:	a481                	j	800055c4 <printf+0x2c4>
      consputc(cx);
    80005386:	cf9ff0ef          	jal	8000507e <consputc>
      continue;
    8000538a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000538c:	0014899b          	addiw	s3,s1,1
    80005390:	013a07b3          	add	a5,s4,s3
    80005394:	0007c503          	lbu	a0,0(a5)
    80005398:	1e050b63          	beqz	a0,8000558e <printf+0x28e>
    if(cx != '%'){
    8000539c:	ff5515e3          	bne	a0,s5,80005386 <printf+0x86>
    i++;
    800053a0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800053a4:	009a07b3          	add	a5,s4,s1
    800053a8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053ac:	1e090163          	beqz	s2,8000558e <printf+0x28e>
    800053b0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800053b4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800053b6:	c789                	beqz	a5,800053c0 <printf+0xc0>
    800053b8:	009a0733          	add	a4,s4,s1
    800053bc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800053c0:	03690763          	beq	s2,s6,800053ee <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800053c4:	05890163          	beq	s2,s8,80005406 <printf+0x106>
    } else if(c0 == 'u'){
    800053c8:	0d990b63          	beq	s2,s9,8000549e <printf+0x19e>
    } else if(c0 == 'x'){
    800053cc:	13a90163          	beq	s2,s10,800054ee <printf+0x1ee>
    } else if(c0 == 'p'){
    800053d0:	13b90b63          	beq	s2,s11,80005506 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800053d4:	07300793          	li	a5,115
    800053d8:	16f90a63          	beq	s2,a5,8000554c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053dc:	1b590463          	beq	s2,s5,80005584 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800053e0:	8556                	mv	a0,s5
    800053e2:	c9dff0ef          	jal	8000507e <consputc>
      consputc(c0);
    800053e6:	854a                	mv	a0,s2
    800053e8:	c97ff0ef          	jal	8000507e <consputc>
    800053ec:	b745                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800053ee:	f8843783          	ld	a5,-120(s0)
    800053f2:	00878713          	addi	a4,a5,8
    800053f6:	f8e43423          	sd	a4,-120(s0)
    800053fa:	4605                	li	a2,1
    800053fc:	45a9                	li	a1,10
    800053fe:	4388                	lw	a0,0(a5)
    80005400:	e6fff0ef          	jal	8000526e <printint>
    80005404:	b761                	j	8000538c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005406:	03678663          	beq	a5,s6,80005432 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000540a:	05878263          	beq	a5,s8,8000544e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000540e:	0b978463          	beq	a5,s9,800054b6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005412:	fda797e3          	bne	a5,s10,800053e0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005416:	f8843783          	ld	a5,-120(s0)
    8000541a:	00878713          	addi	a4,a5,8
    8000541e:	f8e43423          	sd	a4,-120(s0)
    80005422:	4601                	li	a2,0
    80005424:	45c1                	li	a1,16
    80005426:	6388                	ld	a0,0(a5)
    80005428:	e47ff0ef          	jal	8000526e <printint>
      i += 1;
    8000542c:	0029849b          	addiw	s1,s3,2
    80005430:	bfb1                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005432:	f8843783          	ld	a5,-120(s0)
    80005436:	00878713          	addi	a4,a5,8
    8000543a:	f8e43423          	sd	a4,-120(s0)
    8000543e:	4605                	li	a2,1
    80005440:	45a9                	li	a1,10
    80005442:	6388                	ld	a0,0(a5)
    80005444:	e2bff0ef          	jal	8000526e <printint>
      i += 1;
    80005448:	0029849b          	addiw	s1,s3,2
    8000544c:	b781                	j	8000538c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000544e:	06400793          	li	a5,100
    80005452:	02f68863          	beq	a3,a5,80005482 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005456:	07500793          	li	a5,117
    8000545a:	06f68c63          	beq	a3,a5,800054d2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000545e:	07800793          	li	a5,120
    80005462:	f6f69fe3          	bne	a3,a5,800053e0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005466:	f8843783          	ld	a5,-120(s0)
    8000546a:	00878713          	addi	a4,a5,8
    8000546e:	f8e43423          	sd	a4,-120(s0)
    80005472:	4601                	li	a2,0
    80005474:	45c1                	li	a1,16
    80005476:	6388                	ld	a0,0(a5)
    80005478:	df7ff0ef          	jal	8000526e <printint>
      i += 2;
    8000547c:	0039849b          	addiw	s1,s3,3
    80005480:	b731                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005482:	f8843783          	ld	a5,-120(s0)
    80005486:	00878713          	addi	a4,a5,8
    8000548a:	f8e43423          	sd	a4,-120(s0)
    8000548e:	4605                	li	a2,1
    80005490:	45a9                	li	a1,10
    80005492:	6388                	ld	a0,0(a5)
    80005494:	ddbff0ef          	jal	8000526e <printint>
      i += 2;
    80005498:	0039849b          	addiw	s1,s3,3
    8000549c:	bdc5                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000549e:	f8843783          	ld	a5,-120(s0)
    800054a2:	00878713          	addi	a4,a5,8
    800054a6:	f8e43423          	sd	a4,-120(s0)
    800054aa:	4601                	li	a2,0
    800054ac:	45a9                	li	a1,10
    800054ae:	4388                	lw	a0,0(a5)
    800054b0:	dbfff0ef          	jal	8000526e <printint>
    800054b4:	bde1                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054b6:	f8843783          	ld	a5,-120(s0)
    800054ba:	00878713          	addi	a4,a5,8
    800054be:	f8e43423          	sd	a4,-120(s0)
    800054c2:	4601                	li	a2,0
    800054c4:	45a9                	li	a1,10
    800054c6:	6388                	ld	a0,0(a5)
    800054c8:	da7ff0ef          	jal	8000526e <printint>
      i += 1;
    800054cc:	0029849b          	addiw	s1,s3,2
    800054d0:	bd75                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054d2:	f8843783          	ld	a5,-120(s0)
    800054d6:	00878713          	addi	a4,a5,8
    800054da:	f8e43423          	sd	a4,-120(s0)
    800054de:	4601                	li	a2,0
    800054e0:	45a9                	li	a1,10
    800054e2:	6388                	ld	a0,0(a5)
    800054e4:	d8bff0ef          	jal	8000526e <printint>
      i += 2;
    800054e8:	0039849b          	addiw	s1,s3,3
    800054ec:	b545                	j	8000538c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800054ee:	f8843783          	ld	a5,-120(s0)
    800054f2:	00878713          	addi	a4,a5,8
    800054f6:	f8e43423          	sd	a4,-120(s0)
    800054fa:	4601                	li	a2,0
    800054fc:	45c1                	li	a1,16
    800054fe:	4388                	lw	a0,0(a5)
    80005500:	d6fff0ef          	jal	8000526e <printint>
    80005504:	b561                	j	8000538c <printf+0x8c>
    80005506:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005508:	f8843783          	ld	a5,-120(s0)
    8000550c:	00878713          	addi	a4,a5,8
    80005510:	f8e43423          	sd	a4,-120(s0)
    80005514:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005518:	03000513          	li	a0,48
    8000551c:	b63ff0ef          	jal	8000507e <consputc>
  consputc('x');
    80005520:	07800513          	li	a0,120
    80005524:	b5bff0ef          	jal	8000507e <consputc>
    80005528:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000552a:	00002b97          	auipc	s7,0x2
    8000552e:	4f6b8b93          	addi	s7,s7,1270 # 80007a20 <digits>
    80005532:	03c9d793          	srli	a5,s3,0x3c
    80005536:	97de                	add	a5,a5,s7
    80005538:	0007c503          	lbu	a0,0(a5)
    8000553c:	b43ff0ef          	jal	8000507e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005540:	0992                	slli	s3,s3,0x4
    80005542:	397d                	addiw	s2,s2,-1
    80005544:	fe0917e3          	bnez	s2,80005532 <printf+0x232>
    80005548:	6ba6                	ld	s7,72(sp)
    8000554a:	b589                	j	8000538c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000554c:	f8843783          	ld	a5,-120(s0)
    80005550:	00878713          	addi	a4,a5,8
    80005554:	f8e43423          	sd	a4,-120(s0)
    80005558:	0007b903          	ld	s2,0(a5)
    8000555c:	00090d63          	beqz	s2,80005576 <printf+0x276>
      for(; *s; s++)
    80005560:	00094503          	lbu	a0,0(s2)
    80005564:	e20504e3          	beqz	a0,8000538c <printf+0x8c>
        consputc(*s);
    80005568:	b17ff0ef          	jal	8000507e <consputc>
      for(; *s; s++)
    8000556c:	0905                	addi	s2,s2,1
    8000556e:	00094503          	lbu	a0,0(s2)
    80005572:	f97d                	bnez	a0,80005568 <printf+0x268>
    80005574:	bd21                	j	8000538c <printf+0x8c>
        s = "(null)";
    80005576:	00002917          	auipc	s2,0x2
    8000557a:	27a90913          	addi	s2,s2,634 # 800077f0 <etext+0x7f0>
      for(; *s; s++)
    8000557e:	02800513          	li	a0,40
    80005582:	b7dd                	j	80005568 <printf+0x268>
      consputc('%');
    80005584:	02500513          	li	a0,37
    80005588:	af7ff0ef          	jal	8000507e <consputc>
    8000558c:	b501                	j	8000538c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000558e:	f7843783          	ld	a5,-136(s0)
    80005592:	e385                	bnez	a5,800055b2 <printf+0x2b2>
    80005594:	74e6                	ld	s1,120(sp)
    80005596:	7946                	ld	s2,112(sp)
    80005598:	79a6                	ld	s3,104(sp)
    8000559a:	6ae6                	ld	s5,88(sp)
    8000559c:	6b46                	ld	s6,80(sp)
    8000559e:	6c06                	ld	s8,64(sp)
    800055a0:	7ce2                	ld	s9,56(sp)
    800055a2:	7d42                	ld	s10,48(sp)
    800055a4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800055a6:	4501                	li	a0,0
    800055a8:	60aa                	ld	ra,136(sp)
    800055aa:	640a                	ld	s0,128(sp)
    800055ac:	7a06                	ld	s4,96(sp)
    800055ae:	6169                	addi	sp,sp,208
    800055b0:	8082                	ret
    800055b2:	74e6                	ld	s1,120(sp)
    800055b4:	7946                	ld	s2,112(sp)
    800055b6:	79a6                	ld	s3,104(sp)
    800055b8:	6ae6                	ld	s5,88(sp)
    800055ba:	6b46                	ld	s6,80(sp)
    800055bc:	6c06                	ld	s8,64(sp)
    800055be:	7ce2                	ld	s9,56(sp)
    800055c0:	7d42                	ld	s10,48(sp)
    800055c2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800055c4:	0001e517          	auipc	a0,0x1e
    800055c8:	3f450513          	addi	a0,a0,1012 # 800239b8 <pr>
    800055cc:	3cc000ef          	jal	80005998 <release>
    800055d0:	bfd9                	j	800055a6 <printf+0x2a6>

00000000800055d2 <panic>:

void
panic(char *s)
{
    800055d2:	1101                	addi	sp,sp,-32
    800055d4:	ec06                	sd	ra,24(sp)
    800055d6:	e822                	sd	s0,16(sp)
    800055d8:	e426                	sd	s1,8(sp)
    800055da:	1000                	addi	s0,sp,32
    800055dc:	84aa                	mv	s1,a0
  pr.locking = 0;
    800055de:	0001e797          	auipc	a5,0x1e
    800055e2:	3e07a923          	sw	zero,1010(a5) # 800239d0 <pr+0x18>
  printf("panic: ");
    800055e6:	00002517          	auipc	a0,0x2
    800055ea:	21250513          	addi	a0,a0,530 # 800077f8 <etext+0x7f8>
    800055ee:	d13ff0ef          	jal	80005300 <printf>
  printf("%s\n", s);
    800055f2:	85a6                	mv	a1,s1
    800055f4:	00002517          	auipc	a0,0x2
    800055f8:	20c50513          	addi	a0,a0,524 # 80007800 <etext+0x800>
    800055fc:	d05ff0ef          	jal	80005300 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005600:	4785                	li	a5,1
    80005602:	00005717          	auipc	a4,0x5
    80005606:	ecf72523          	sw	a5,-310(a4) # 8000a4cc <panicked>
  for(;;)
    8000560a:	a001                	j	8000560a <panic+0x38>

000000008000560c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000560c:	1101                	addi	sp,sp,-32
    8000560e:	ec06                	sd	ra,24(sp)
    80005610:	e822                	sd	s0,16(sp)
    80005612:	e426                	sd	s1,8(sp)
    80005614:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005616:	0001e497          	auipc	s1,0x1e
    8000561a:	3a248493          	addi	s1,s1,930 # 800239b8 <pr>
    8000561e:	00002597          	auipc	a1,0x2
    80005622:	1ea58593          	addi	a1,a1,490 # 80007808 <etext+0x808>
    80005626:	8526                	mv	a0,s1
    80005628:	258000ef          	jal	80005880 <initlock>
  pr.locking = 1;
    8000562c:	4785                	li	a5,1
    8000562e:	cc9c                	sw	a5,24(s1)
}
    80005630:	60e2                	ld	ra,24(sp)
    80005632:	6442                	ld	s0,16(sp)
    80005634:	64a2                	ld	s1,8(sp)
    80005636:	6105                	addi	sp,sp,32
    80005638:	8082                	ret

000000008000563a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000563a:	1141                	addi	sp,sp,-16
    8000563c:	e406                	sd	ra,8(sp)
    8000563e:	e022                	sd	s0,0(sp)
    80005640:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005642:	100007b7          	lui	a5,0x10000
    80005646:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000564a:	10000737          	lui	a4,0x10000
    8000564e:	f8000693          	li	a3,-128
    80005652:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005656:	468d                	li	a3,3
    80005658:	10000637          	lui	a2,0x10000
    8000565c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005660:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005664:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005668:	10000737          	lui	a4,0x10000
    8000566c:	461d                	li	a2,7
    8000566e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005672:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005676:	00002597          	auipc	a1,0x2
    8000567a:	19a58593          	addi	a1,a1,410 # 80007810 <etext+0x810>
    8000567e:	0001e517          	auipc	a0,0x1e
    80005682:	35a50513          	addi	a0,a0,858 # 800239d8 <uart_tx_lock>
    80005686:	1fa000ef          	jal	80005880 <initlock>
}
    8000568a:	60a2                	ld	ra,8(sp)
    8000568c:	6402                	ld	s0,0(sp)
    8000568e:	0141                	addi	sp,sp,16
    80005690:	8082                	ret

0000000080005692 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005692:	1101                	addi	sp,sp,-32
    80005694:	ec06                	sd	ra,24(sp)
    80005696:	e822                	sd	s0,16(sp)
    80005698:	e426                	sd	s1,8(sp)
    8000569a:	1000                	addi	s0,sp,32
    8000569c:	84aa                	mv	s1,a0
  push_off();
    8000569e:	222000ef          	jal	800058c0 <push_off>

  if(panicked){
    800056a2:	00005797          	auipc	a5,0x5
    800056a6:	e2a7a783          	lw	a5,-470(a5) # 8000a4cc <panicked>
    800056aa:	e795                	bnez	a5,800056d6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800056ac:	10000737          	lui	a4,0x10000
    800056b0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800056b2:	00074783          	lbu	a5,0(a4)
    800056b6:	0207f793          	andi	a5,a5,32
    800056ba:	dfe5                	beqz	a5,800056b2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800056bc:	0ff4f513          	zext.b	a0,s1
    800056c0:	100007b7          	lui	a5,0x10000
    800056c4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800056c8:	27c000ef          	jal	80005944 <pop_off>
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	64a2                	ld	s1,8(sp)
    800056d2:	6105                	addi	sp,sp,32
    800056d4:	8082                	ret
    for(;;)
    800056d6:	a001                	j	800056d6 <uartputc_sync+0x44>

00000000800056d8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800056d8:	00005797          	auipc	a5,0x5
    800056dc:	df87b783          	ld	a5,-520(a5) # 8000a4d0 <uart_tx_r>
    800056e0:	00005717          	auipc	a4,0x5
    800056e4:	df873703          	ld	a4,-520(a4) # 8000a4d8 <uart_tx_w>
    800056e8:	08f70263          	beq	a4,a5,8000576c <uartstart+0x94>
{
    800056ec:	7139                	addi	sp,sp,-64
    800056ee:	fc06                	sd	ra,56(sp)
    800056f0:	f822                	sd	s0,48(sp)
    800056f2:	f426                	sd	s1,40(sp)
    800056f4:	f04a                	sd	s2,32(sp)
    800056f6:	ec4e                	sd	s3,24(sp)
    800056f8:	e852                	sd	s4,16(sp)
    800056fa:	e456                	sd	s5,8(sp)
    800056fc:	e05a                	sd	s6,0(sp)
    800056fe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005700:	10000937          	lui	s2,0x10000
    80005704:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005706:	0001ea97          	auipc	s5,0x1e
    8000570a:	2d2a8a93          	addi	s5,s5,722 # 800239d8 <uart_tx_lock>
    uart_tx_r += 1;
    8000570e:	00005497          	auipc	s1,0x5
    80005712:	dc248493          	addi	s1,s1,-574 # 8000a4d0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005716:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000571a:	00005997          	auipc	s3,0x5
    8000571e:	dbe98993          	addi	s3,s3,-578 # 8000a4d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005722:	00094703          	lbu	a4,0(s2)
    80005726:	02077713          	andi	a4,a4,32
    8000572a:	c71d                	beqz	a4,80005758 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000572c:	01f7f713          	andi	a4,a5,31
    80005730:	9756                	add	a4,a4,s5
    80005732:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005736:	0785                	addi	a5,a5,1
    80005738:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000573a:	8526                	mv	a0,s1
    8000573c:	c8ffb0ef          	jal	800013ca <wakeup>
    WriteReg(THR, c);
    80005740:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005744:	609c                	ld	a5,0(s1)
    80005746:	0009b703          	ld	a4,0(s3)
    8000574a:	fcf71ce3          	bne	a4,a5,80005722 <uartstart+0x4a>
      ReadReg(ISR);
    8000574e:	100007b7          	lui	a5,0x10000
    80005752:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005754:	0007c783          	lbu	a5,0(a5)
  }
}
    80005758:	70e2                	ld	ra,56(sp)
    8000575a:	7442                	ld	s0,48(sp)
    8000575c:	74a2                	ld	s1,40(sp)
    8000575e:	7902                	ld	s2,32(sp)
    80005760:	69e2                	ld	s3,24(sp)
    80005762:	6a42                	ld	s4,16(sp)
    80005764:	6aa2                	ld	s5,8(sp)
    80005766:	6b02                	ld	s6,0(sp)
    80005768:	6121                	addi	sp,sp,64
    8000576a:	8082                	ret
      ReadReg(ISR);
    8000576c:	100007b7          	lui	a5,0x10000
    80005770:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005772:	0007c783          	lbu	a5,0(a5)
      return;
    80005776:	8082                	ret

0000000080005778 <uartputc>:
{
    80005778:	7179                	addi	sp,sp,-48
    8000577a:	f406                	sd	ra,40(sp)
    8000577c:	f022                	sd	s0,32(sp)
    8000577e:	ec26                	sd	s1,24(sp)
    80005780:	e84a                	sd	s2,16(sp)
    80005782:	e44e                	sd	s3,8(sp)
    80005784:	e052                	sd	s4,0(sp)
    80005786:	1800                	addi	s0,sp,48
    80005788:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000578a:	0001e517          	auipc	a0,0x1e
    8000578e:	24e50513          	addi	a0,a0,590 # 800239d8 <uart_tx_lock>
    80005792:	16e000ef          	jal	80005900 <acquire>
  if(panicked){
    80005796:	00005797          	auipc	a5,0x5
    8000579a:	d367a783          	lw	a5,-714(a5) # 8000a4cc <panicked>
    8000579e:	efbd                	bnez	a5,8000581c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057a0:	00005717          	auipc	a4,0x5
    800057a4:	d3873703          	ld	a4,-712(a4) # 8000a4d8 <uart_tx_w>
    800057a8:	00005797          	auipc	a5,0x5
    800057ac:	d287b783          	ld	a5,-728(a5) # 8000a4d0 <uart_tx_r>
    800057b0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800057b4:	0001e997          	auipc	s3,0x1e
    800057b8:	22498993          	addi	s3,s3,548 # 800239d8 <uart_tx_lock>
    800057bc:	00005497          	auipc	s1,0x5
    800057c0:	d1448493          	addi	s1,s1,-748 # 8000a4d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057c4:	00005917          	auipc	s2,0x5
    800057c8:	d1490913          	addi	s2,s2,-748 # 8000a4d8 <uart_tx_w>
    800057cc:	00e79d63          	bne	a5,a4,800057e6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800057d0:	85ce                	mv	a1,s3
    800057d2:	8526                	mv	a0,s1
    800057d4:	babfb0ef          	jal	8000137e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057d8:	00093703          	ld	a4,0(s2)
    800057dc:	609c                	ld	a5,0(s1)
    800057de:	02078793          	addi	a5,a5,32
    800057e2:	fee787e3          	beq	a5,a4,800057d0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800057e6:	0001e497          	auipc	s1,0x1e
    800057ea:	1f248493          	addi	s1,s1,498 # 800239d8 <uart_tx_lock>
    800057ee:	01f77793          	andi	a5,a4,31
    800057f2:	97a6                	add	a5,a5,s1
    800057f4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800057f8:	0705                	addi	a4,a4,1
    800057fa:	00005797          	auipc	a5,0x5
    800057fe:	cce7bf23          	sd	a4,-802(a5) # 8000a4d8 <uart_tx_w>
  uartstart();
    80005802:	ed7ff0ef          	jal	800056d8 <uartstart>
  release(&uart_tx_lock);
    80005806:	8526                	mv	a0,s1
    80005808:	190000ef          	jal	80005998 <release>
}
    8000580c:	70a2                	ld	ra,40(sp)
    8000580e:	7402                	ld	s0,32(sp)
    80005810:	64e2                	ld	s1,24(sp)
    80005812:	6942                	ld	s2,16(sp)
    80005814:	69a2                	ld	s3,8(sp)
    80005816:	6a02                	ld	s4,0(sp)
    80005818:	6145                	addi	sp,sp,48
    8000581a:	8082                	ret
    for(;;)
    8000581c:	a001                	j	8000581c <uartputc+0xa4>

000000008000581e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000581e:	1141                	addi	sp,sp,-16
    80005820:	e422                	sd	s0,8(sp)
    80005822:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005824:	100007b7          	lui	a5,0x10000
    80005828:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000582a:	0007c783          	lbu	a5,0(a5)
    8000582e:	8b85                	andi	a5,a5,1
    80005830:	cb81                	beqz	a5,80005840 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005832:	100007b7          	lui	a5,0x10000
    80005836:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000583a:	6422                	ld	s0,8(sp)
    8000583c:	0141                	addi	sp,sp,16
    8000583e:	8082                	ret
    return -1;
    80005840:	557d                	li	a0,-1
    80005842:	bfe5                	j	8000583a <uartgetc+0x1c>

0000000080005844 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005844:	1101                	addi	sp,sp,-32
    80005846:	ec06                	sd	ra,24(sp)
    80005848:	e822                	sd	s0,16(sp)
    8000584a:	e426                	sd	s1,8(sp)
    8000584c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000584e:	54fd                	li	s1,-1
    80005850:	a019                	j	80005856 <uartintr+0x12>
      break;
    consoleintr(c);
    80005852:	85fff0ef          	jal	800050b0 <consoleintr>
    int c = uartgetc();
    80005856:	fc9ff0ef          	jal	8000581e <uartgetc>
    if(c == -1)
    8000585a:	fe951ce3          	bne	a0,s1,80005852 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000585e:	0001e497          	auipc	s1,0x1e
    80005862:	17a48493          	addi	s1,s1,378 # 800239d8 <uart_tx_lock>
    80005866:	8526                	mv	a0,s1
    80005868:	098000ef          	jal	80005900 <acquire>
  uartstart();
    8000586c:	e6dff0ef          	jal	800056d8 <uartstart>
  release(&uart_tx_lock);
    80005870:	8526                	mv	a0,s1
    80005872:	126000ef          	jal	80005998 <release>
}
    80005876:	60e2                	ld	ra,24(sp)
    80005878:	6442                	ld	s0,16(sp)
    8000587a:	64a2                	ld	s1,8(sp)
    8000587c:	6105                	addi	sp,sp,32
    8000587e:	8082                	ret

0000000080005880 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005880:	1141                	addi	sp,sp,-16
    80005882:	e422                	sd	s0,8(sp)
    80005884:	0800                	addi	s0,sp,16
  lk->name = name;
    80005886:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005888:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000588c:	00053823          	sd	zero,16(a0)
}
    80005890:	6422                	ld	s0,8(sp)
    80005892:	0141                	addi	sp,sp,16
    80005894:	8082                	ret

0000000080005896 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005896:	411c                	lw	a5,0(a0)
    80005898:	e399                	bnez	a5,8000589e <holding+0x8>
    8000589a:	4501                	li	a0,0
  return r;
}
    8000589c:	8082                	ret
{
    8000589e:	1101                	addi	sp,sp,-32
    800058a0:	ec06                	sd	ra,24(sp)
    800058a2:	e822                	sd	s0,16(sp)
    800058a4:	e426                	sd	s1,8(sp)
    800058a6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800058a8:	6904                	ld	s1,16(a0)
    800058aa:	ce2fb0ef          	jal	80000d8c <mycpu>
    800058ae:	40a48533          	sub	a0,s1,a0
    800058b2:	00153513          	seqz	a0,a0
}
    800058b6:	60e2                	ld	ra,24(sp)
    800058b8:	6442                	ld	s0,16(sp)
    800058ba:	64a2                	ld	s1,8(sp)
    800058bc:	6105                	addi	sp,sp,32
    800058be:	8082                	ret

00000000800058c0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800058c0:	1101                	addi	sp,sp,-32
    800058c2:	ec06                	sd	ra,24(sp)
    800058c4:	e822                	sd	s0,16(sp)
    800058c6:	e426                	sd	s1,8(sp)
    800058c8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058ca:	100024f3          	csrr	s1,sstatus
    800058ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058d2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058d4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800058d8:	cb4fb0ef          	jal	80000d8c <mycpu>
    800058dc:	5d3c                	lw	a5,120(a0)
    800058de:	cb99                	beqz	a5,800058f4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058e0:	cacfb0ef          	jal	80000d8c <mycpu>
    800058e4:	5d3c                	lw	a5,120(a0)
    800058e6:	2785                	addiw	a5,a5,1
    800058e8:	dd3c                	sw	a5,120(a0)
}
    800058ea:	60e2                	ld	ra,24(sp)
    800058ec:	6442                	ld	s0,16(sp)
    800058ee:	64a2                	ld	s1,8(sp)
    800058f0:	6105                	addi	sp,sp,32
    800058f2:	8082                	ret
    mycpu()->intena = old;
    800058f4:	c98fb0ef          	jal	80000d8c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058f8:	8085                	srli	s1,s1,0x1
    800058fa:	8885                	andi	s1,s1,1
    800058fc:	dd64                	sw	s1,124(a0)
    800058fe:	b7cd                	j	800058e0 <push_off+0x20>

0000000080005900 <acquire>:
{
    80005900:	1101                	addi	sp,sp,-32
    80005902:	ec06                	sd	ra,24(sp)
    80005904:	e822                	sd	s0,16(sp)
    80005906:	e426                	sd	s1,8(sp)
    80005908:	1000                	addi	s0,sp,32
    8000590a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000590c:	fb5ff0ef          	jal	800058c0 <push_off>
  if(holding(lk))
    80005910:	8526                	mv	a0,s1
    80005912:	f85ff0ef          	jal	80005896 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005916:	4705                	li	a4,1
  if(holding(lk))
    80005918:	e105                	bnez	a0,80005938 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000591a:	87ba                	mv	a5,a4
    8000591c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005920:	2781                	sext.w	a5,a5
    80005922:	ffe5                	bnez	a5,8000591a <acquire+0x1a>
  __sync_synchronize();
    80005924:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005928:	c64fb0ef          	jal	80000d8c <mycpu>
    8000592c:	e888                	sd	a0,16(s1)
}
    8000592e:	60e2                	ld	ra,24(sp)
    80005930:	6442                	ld	s0,16(sp)
    80005932:	64a2                	ld	s1,8(sp)
    80005934:	6105                	addi	sp,sp,32
    80005936:	8082                	ret
    panic("acquire");
    80005938:	00002517          	auipc	a0,0x2
    8000593c:	ee050513          	addi	a0,a0,-288 # 80007818 <etext+0x818>
    80005940:	c93ff0ef          	jal	800055d2 <panic>

0000000080005944 <pop_off>:

void
pop_off(void)
{
    80005944:	1141                	addi	sp,sp,-16
    80005946:	e406                	sd	ra,8(sp)
    80005948:	e022                	sd	s0,0(sp)
    8000594a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000594c:	c40fb0ef          	jal	80000d8c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005950:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005954:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005956:	e78d                	bnez	a5,80005980 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005958:	5d3c                	lw	a5,120(a0)
    8000595a:	02f05963          	blez	a5,8000598c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000595e:	37fd                	addiw	a5,a5,-1
    80005960:	0007871b          	sext.w	a4,a5
    80005964:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005966:	eb09                	bnez	a4,80005978 <pop_off+0x34>
    80005968:	5d7c                	lw	a5,124(a0)
    8000596a:	c799                	beqz	a5,80005978 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000596c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005970:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005974:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005978:	60a2                	ld	ra,8(sp)
    8000597a:	6402                	ld	s0,0(sp)
    8000597c:	0141                	addi	sp,sp,16
    8000597e:	8082                	ret
    panic("pop_off - interruptible");
    80005980:	00002517          	auipc	a0,0x2
    80005984:	ea050513          	addi	a0,a0,-352 # 80007820 <etext+0x820>
    80005988:	c4bff0ef          	jal	800055d2 <panic>
    panic("pop_off");
    8000598c:	00002517          	auipc	a0,0x2
    80005990:	eac50513          	addi	a0,a0,-340 # 80007838 <etext+0x838>
    80005994:	c3fff0ef          	jal	800055d2 <panic>

0000000080005998 <release>:
{
    80005998:	1101                	addi	sp,sp,-32
    8000599a:	ec06                	sd	ra,24(sp)
    8000599c:	e822                	sd	s0,16(sp)
    8000599e:	e426                	sd	s1,8(sp)
    800059a0:	1000                	addi	s0,sp,32
    800059a2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800059a4:	ef3ff0ef          	jal	80005896 <holding>
    800059a8:	c105                	beqz	a0,800059c8 <release+0x30>
  lk->cpu = 0;
    800059aa:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059ae:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059b2:	0310000f          	fence	rw,w
    800059b6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059ba:	f8bff0ef          	jal	80005944 <pop_off>
}
    800059be:	60e2                	ld	ra,24(sp)
    800059c0:	6442                	ld	s0,16(sp)
    800059c2:	64a2                	ld	s1,8(sp)
    800059c4:	6105                	addi	sp,sp,32
    800059c6:	8082                	ret
    panic("release");
    800059c8:	00002517          	auipc	a0,0x2
    800059cc:	e7850513          	addi	a0,a0,-392 # 80007840 <etext+0x840>
    800059d0:	c03ff0ef          	jal	800055d2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
