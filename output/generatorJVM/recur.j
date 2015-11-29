.class public recur
.super java/lang/Object
.method static <clinit>()V
   .limit stack  1
   .limit locals 0
   return
.end method
.method public <init>()V
   aload_0
   invokenonvirtual java/lang/Object/<init>()V
   return
.end method
.method public static main([Ljava/lang/String;)V
   .limit stack 10000
ldc "factorial of 5 is "
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
sipush 5
jsr LBL_factorial
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
goto LBL_end
LBL_factorial:
swap
dup
sipush 0
if_icmpeq LBL_eins
dup
sipush 1
isub
jsr LBL_factorial
imul
swap
astore 0
ret 0
LBL_eins:
pop
sipush 1
swap
astore 0
ret 0
LBL_end:
   return
.end method
