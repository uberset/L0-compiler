.class public fun1
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
ldc "successor of 1 is "
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
sipush 1
jsr LBL_successor
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
goto LBL_end
LBL_successor:
swap
sipush 1
iadd
swap
astore 0
ret 0
LBL_end:
   return
.end method
